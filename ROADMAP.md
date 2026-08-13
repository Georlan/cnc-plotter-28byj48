# 🗺️ Roadmap do Projeto: Mini CNC Plotter 28BYJ-48 + ULN2003

Este documento organiza todas as etapas necessárias para colocar a sua Mini CNC Plotter em pleno funcionamento.

---

## 📌 Etapa 1: Parte Elétrica e Alimentação (Urgente)
- [ ] **Alimentação Externa de 5V (2A)**:
  - Desconectar a alimentação dos 3 drivers ULN2003 do pino 5V do Arduino.
  - Conectar uma fonte externa de 5V (2A) na barra de alimentação da protoboard.
  - **GND Comum**: Unificar o GND da fonte externa com o pino GND do Arduino.
- [ ] **Conferência da Pinagem no Arduino Uno**:
  - **Eixo X**: IN1 $\rightarrow$ D2 | IN2 $\rightarrow$ D3 | IN3 $\rightarrow$ D4 | IN4 $\rightarrow$ D5
  - **Eixo Y**: IN1 $\rightarrow$ D6 | IN2 $\rightarrow$ D7 | IN3 $\rightarrow$ D8 | IN4 $\rightarrow$ D9
  - **Eixo Z**: IN1 $\rightarrow$ D10 | IN2 $\rightarrow$ D11 | IN3 $\rightarrow$ D12 | IN4 $\rightarrow$ D13

---

## 📌 Etapa 2: Gravação e Teste de Firmware
- [x] **Criar Firmware Customizado**: Arquivo `CNC_Plotter_28BYJ48.ino` criado com suporte a 3x ULN2003 (half-stepping) e interpretador G-code.
- [ ] **Carregar Firmware no Arduino Uno**: Gravar o sketch via Arduino IDE ou linha de comando.
- [ ] **Teste Inicial de Comunicação Serial**: Conectar na porta a 115200 baud e enviar o comando `?` para receber o status `<Idle>`.

---

## 📌 Etapa 3: Calibração Mecânica e Eixos
- [ ] **Verificação de Sentido de Giro**:
  - Testar movimentação individual dos eixos X, Y e Z.
  - Se algum eixo mover no sentido inverso, inverter a sequência dos pinos ou a direção no código.
- [ ] **Calibração de Passos por Millímetro (`STEPS_PER_MM`)**:
  - Medir com paquímetro/régua o deslocamento real de 10mm.
  - Ajustar as variáveis `STEPS_PER_MM_X`, `STEPS_PER_MM_Y` e `STEPS_PER_MM_Z` no `.ino`.

---

## 📌 Etapa 4: Primeiros Testes de Desenho (G-Code)
- [ ] **Desenho de Teste 1**: Enviar o arquivo `G-code-to-write-a-spiral.ngc` para testar movimento contínuo nos eixos X e Y.
- [ ] **Desenho de Teste 2**: Enviar o arquivo `G-code-to-write-ABC+Hatched.ngc` para testar o acionamento do eixo Z (subir/descer caneta) e hachuras.

---

## 📌 Etapa 5: Expansões Futuras (Opcional)
- [ ] Instalação de Chaves de Fim de Curso (*Endstops*) para Homing automático (`G28`).
- [ ] Adição de Suporte Fixo para Papel / Mesa Acrílica.
