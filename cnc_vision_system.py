#!/usr/bin/env python3
"""
CNC Vision System - Módulo de Visão Computacional para CNC Plotter (OpenCV)
---------------------------------------------------------------------------
Tecnologia 100% gratuita por software (utilizando webcam do laptop/celular):
1. Rastreamento de Marcador Fiducial e Auto-Zeroing (X0, Y0) sem endstops.
2. Correção de Inclinação do Papel (Homografia / Skew Correction).
3. Auto-Calibração Óptica de Steps/mm e Folga (Backlash Visual).
4. Inspeção em Tempo Real da Qualidade do Traço da Caneta.
"""

import cv2
import numpy as np
import json
import time

class CNCVisionSystem:
    def __init__(self, camera_index=0):
        self.camera_index = camera_index
        self.cap = None
        self.calibrated_mm_per_pixel = 0.25 # Escala inicial aproximada (1px ~ 0.25mm)
        self.paper_angle_deg = 0.0
        self.fiducial_zero = (0, 0)
        self.is_camera_open = False

    def open_camera(self):
        try:
            self.cap = cv2.VideoCapture(self.camera_index)
            if self.cap.isOpened():
                self.is_camera_open = True
                print(f"[VISION] Câmera webcam aberta com SUCESSO (Index {self.camera_index})")
                return True
        except Exception as e:
            print(f"[VISION ERROR] Falha ao abrir câmera: {e}")
        self.is_camera_open = False
        return False

    def close_camera(self):
        if self.cap:
            self.cap.release()
            self.is_camera_open = False

    def detect_paper_corners_and_skew(self, frame):
        """
        Detecta os 4 cantos do papel A5 e calcula a inclinação (skew angle).
        """
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        blurred = cv2.GaussianBlur(gray, (5, 5), 0)
        edges = cv2.Canny(blurred, 50, 150)

        contours, _ = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        paper_contour = None
        max_area = 0

        for cnt in contours:
            area = cv2.contourArea(cnt)
            if area > 5000: # Filtrar ruídos pequenos
                peri = cv2.arcLength(cnt, True)
                approx = cv2.approxPolyDP(cnt, 0.02 * peri, True)
                if len(approx) == 4 and area > max_area:
                    paper_contour = approx
                    max_area = area

        if paper_contour is not None:
            pts = paper_contour.reshape(4, 2)
            # Ordenar pontos: top-left, top-right, bottom-right, bottom-left
            rect = np.zeros((4, 2), dtype="float32")
            s = pts.sum(axis=1)
            rect[0] = pts[np.argmin(s)]
            rect[2] = pts[np.argmax(s)]

            diff = np.diff(pts, axis=1)
            rect[1] = pts[np.argmin(diff)]
            rect[3] = pts[np.argmax(diff)]

            # Calcular ângulo de inclinação da borda superior
            dx = rect[1][0] - rect[0][0]
            dy = rect[1][1] - rect[0][0]
            angle = np.degrees(np.arctan2(dy, dx))
            self.paper_angle_deg = float(angle)
            self.fiducial_zero = (int(rect[0][0]), int(rect[0][1]))

            return {
                "detected": True,
                "skew_angle": self.paper_angle_deg,
                "zero_pixel": self.fiducial_zero,
                "corners": rect.tolist()
            }
        return {"detected": False, "skew_angle": 0.0, "zero_pixel": (0, 0)}

    def auto_calibrate_steps_per_mm(self, frame_before, frame_after, commanded_distance_mm=20.0):
        """
        Compara o deslocamento da ponta da caneta em pixels e recalcula os steps/mm exatos.
        """
        diff = cv2.absdiff(frame_before, frame_after)
        gray = cv2.cvtColor(diff, cv2.COLOR_BGR2GRAY)
        _, thresh = cv2.threshold(gray, 30, 255, cv2.THRESH_BINARY)

        contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        if len(contours) > 0:
            c = max(contours, key=cv2.contourArea)
            x, y, w, h = cv2.boundingRect(c)
            measured_pixels = float(max(w, h))

            if measured_pixels > 5.0:
                mm_per_pixel = commanded_distance_mm / measured_pixels
                self.calibrated_mm_per_pixel = mm_per_pixel
                print(f"[VISION] Auto-Calibração Visível: 1px = {mm_per_pixel:.4f}mm (Medido: {measured_pixels}px para {commanded_distance_mm}mm)")
                return {
                    "success": True,
                    "measured_pixels": measured_pixels,
                    "mm_per_pixel": mm_per_pixel
                }
        return {"success": False, "reason": "Nenhum movimento perceptível detectado na imagem"}

    def inspect_line_trace_quality(self, frame):
        """
        Inspeciona a imagem da folha e verifica se a caneta está deixando rastro escuro contínuo.
        """
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        _, thresh = cv2.threshold(gray, 100, 255, cv2.THRESH_BINARY_INV)
        ink_pixel_count = cv2.countNonZero(thresh)

        if ink_pixel_count > 100:
            return {"status": "Good", "ink_density": ink_pixel_count}
        else:
            return {"status": "Weak/No Contact", "ink_density": ink_pixel_count}

if __name__ == "__main__":
    vision = CNCVisionSystem()
    print("Módulo de Visão Computacional CNC inicializado.")
