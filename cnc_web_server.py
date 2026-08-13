#!/usr/bin/env python3
"""
CNC PCB Commander - Web Frontend Backend Server (Robust Serial Driver)
----------------------------------------------------------------------
Servidor web local com WebSockets para controle da CNC Plotter (28BYJ-48 + ULN2003)
Conecta automaticamente na porta serial real (/dev/ttyACM0) com re-tentativa contínua.
"""

import sys
import os
import json
import time
import asyncio
import threading
import http.server
import socketserver
import serial
import glob
import websockets

BAUD_RATE = 115200
HTTP_PORT = 8080
WS_PORT   = 8081

ser = None
connected = False
current_status = {"state": "Disconnected", "port": "None", "x": 0.0, "y": 0.0, "z": 0.0, "line": 0, "total_lines": 0}
connected_clients = set()
is_streaming = False
gcode_lines = []
current_line_idx = 0
serial_lock = threading.Lock()

def find_serial_port():
    candidate_ports = glob.glob("/dev/ttyACM*") + glob.glob("/dev/ttyUSB*")
    return candidate_ports[0] if candidate_ports else None

def init_serial():
    global ser, connected
    with serial_lock:
        if connected and ser and ser.is_open:
            return True
        port = find_serial_port()
        if not port:
            connected = False
            current_status["state"] = "Error: Nenhuma porta serial encontrada"
            current_status["port"] = "None"
            return False
        try:
            if ser and ser.is_open:
                ser.close()
            ser = serial.Serial(port, BAUD_RATE, timeout=2.0)
            time.sleep(2.0) # Espera reset do Arduino Uno
            ser.reset_input_buffer()
            ser.reset_output_buffer()
            connected = True
            current_status["state"] = "Idle"
            current_status["port"] = port
            print(f"[SERIAL] Conectado com SUCESSO em {port} @ {BAUD_RATE}")
            return True
        except Exception as e:
            connected = False
            current_status["state"] = f"Error: {e}"
            current_status["port"] = port
            print(f"[SERIAL ERROR] Falha ao abrir {port}: {e}")
            return False

def send_serial(cmd):
    global ser, connected
    with serial_lock:
        if not connected or ser is None or not ser.is_open:
            if not init_serial():
                return "Not connected"
        try:
            ser.reset_input_buffer()
            ser.write((cmd.strip() + "\n").encode("utf-8"))
            # Aguarda a resposta 'ok' do firmware Arduino
            response_bytes = bytearray()
            start_time = time.time()
            while (time.time() - start_time) < 3.0:
                if ser.in_waiting > 0:
                    chunk = ser.read(ser.in_waiting)
                    response_bytes.extend(chunk)
                    if b"ok" in response_bytes or b"CNC" in response_bytes:
                        break
                time.sleep(0.02)
            resp_str = response_bytes.decode("utf-8", errors="ignore").strip()
            return resp_str if resp_str else "ok"
        except Exception as e:
            connected = False
            return f"Error: {e}"

async def ws_handler(websocket):
    global is_streaming, gcode_lines, current_line_idx
    connected_clients.add(websocket)
    print(f"[WS] Cliente conectado: {websocket.remote_address}")
    
    # Tenta conectar no serial se ainda não estiver
    init_serial()
    await websocket.send(json.dumps({"type": "status", "data": current_status}))
    
    try:
        async for message in websocket:
            try:
                data = json.loads(message)
                cmd_type = data.get("type")

                if cmd_type == "connect":
                    init_serial()
                    await broadcast({"type": "status", "data": current_status})

                elif cmd_type == "gcode_single":
                    gcode = data.get("gcode", "")
                    resp = send_serial(gcode)
                    await websocket.send(json.dumps({"type": "response", "gcode": gcode, "response": resp}))

                elif cmd_type == "jog":
                    axis = data.get("axis")
                    dist = float(data.get("dist", 1.0))
                    gcode = f"G91\nG0 {axis}{dist}\nG90"
                    resp = send_serial(gcode)
                    await websocket.send(json.dumps({"type": "response", "gcode": gcode, "response": resp}))

                elif cmd_type == "zero":
                    current_status["x"] = 0.0
                    current_status["y"] = 0.0
                    current_status["z"] = 0.0
                    send_serial("G28")
                    await broadcast({"type": "status", "data": current_status})

                elif cmd_type == "start_stream":
                    lines = data.get("lines", [])
                    if lines and not is_streaming:
                        gcode_lines = lines
                        current_line_idx = 0
                        is_streaming = True
                        asyncio.create_task(stream_gcode_task())

                elif cmd_type == "stop_stream":
                    is_streaming = False
                    current_status["state"] = "Idle"
                    send_serial("G0 Z6")
                    await broadcast({"type": "status", "data": current_status})

            except Exception as ex:
                print(f"[WS Error]: {ex}")
    finally:
        connected_clients.remove(websocket)
        print("[WS] Cliente desconectado")

async def stream_gcode_task():
    global is_streaming, gcode_lines, current_line_idx
    current_status["state"] = "Running"
    current_status["total_lines"] = len(gcode_lines)
    
    for idx, line in enumerate(gcode_lines):
        if not is_streaming:
            break
        current_line_idx = idx
        current_status["line"] = idx + 1
        
        resp = send_serial(line)
        
        if idx % 5 == 0 or idx == len(gcode_lines) - 1:
            await broadcast({"type": "progress", "line": idx + 1, "total": len(gcode_lines), "current_gcode": line})
        
        await asyncio.sleep(0.01)
        
    is_streaming = False
    current_status["state"] = "Idle"
    send_serial("G0 Z6")
    await broadcast({"type": "status", "data": current_status})
    await broadcast({"type": "complete"})

async def broadcast(message_dict):
    if connected_clients:
        msg = json.dumps(message_dict)
        await asyncio.gather(*[client.send(msg) for client in connected_clients], return_exceptions=True)

def start_http_server():
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    handler = http.server.SimpleHTTPRequestHandler
    httpd = socketserver.TCPServer(("", HTTP_PORT), handler)
    print(f"[HTTP] Servidor Web servindo em http://localhost:{HTTP_PORT}")
    httpd.serve_forever()

async def main():
    print("=== INICIANDO CNC PCB COMMANDER BACKEND ===")
    init_serial()

    http_thread = threading.Thread(target=start_http_server, daemon=True)
    http_thread.start()

    print(f"[WS] Servidor WebSocket iniciando em ws://localhost:{WS_PORT}")
    async with websockets.serve(ws_handler, "0.0.0.0", WS_PORT):
        stop_event = asyncio.Event()
        await stop_event.wait()

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\nServidor encerrado pelo usuário.")
