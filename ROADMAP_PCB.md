# ⚡ ROADMAP AVANÇADO: Fabricação de Placas de Circuito Impresso (PCB) via Plotter CNC + Percloreto

Este roadmap foi otimizado para transformar a sua Mini CNC Plotter em uma estação dedicada à fabricação de **Placas de Circuito Impresso (PCB)** de alta precisão.

---

## 🚀 FASE 1: Hardware & Estabilidade Elétrica (Urgente)
- [ ] **Alimentação Externa 5V (2A)**:
  - Não alimentar os 3 drivers ULN2003 pela USB do Arduino.
  - Conectar fonte de 5V 2A na protoboard + GND comum no Arduino.
- [ ] **Ajuste Mecânico de Precisão (Eliminar Folgas / Backlash)**:
  - A corrosão em percloreto exige precisão de $0.1\text{ mm}$.
  - Verificar se a engrenagem do pinhão está bem presa no eixo do motor 28BYJ-48 sem patinar.
  - Adicionar molas ou pressão suave no eixo Z para a caneta não variar a força no cobre.

---

## 🖥️ FASE 2: Frontend Web Customizada (`CNC PCB Commander`)
- [x] **Substituição do UGS por Interface Nativa Otimizada**:
  - Criado servidor local `cnc_web_server.py` e frontend moderna em `http://localhost:8080`.
- [x] **Recursos Específicos para PCB na Web App**:
  - Visualizador 2D em tempo real das trilhas de cobre (G0 em vermelho, G1 em verde néon).
  - Controle de Jogging com precisão de $0.1\text{ mm}$, $1.0\text{ mm}$ e $5.0\text{ mm}$.
  - Botão rápido de teste de profundidade da caneta (`Z5` subir / `Z-1` baixar).
  - Transmissor G-code integrado via WebSockets (sem necessidade de Java ou UGS).

---

## 🎨 FASE 3: Fluxo de G-Code de PCB (Gerber / SVG $\rightarrow$ G-Code)
- [ ] **Desenho da Placa no CAD (KiCad / EasyEDA)**:
  - Desenhar as trilhas com largura mínima de $0.5\text{ mm}$ ($20\text{ mil}$) e pads aumentados para facilitar a furação.
  - Exportar o layer de trilhas (*Bottom Copper*) em SVG ou Gerber.
- [ ] **Compensação de Espessura da Caneta (Inkscape)**:
  - Importar o SVG no Inkscape.
  - Converter trilhas em contornos com traço de $0.4\text{ mm}$ (diâmetro exato da ponta da caneta permanente).
  - Gerar o G-code utilizando o plugin *Inkscape Gcodetools*.

---

## 🧪 FASE 4: Processo de Desenho e Corrosão em Percloreto de Ferro ($\text{FeCl}_3$)
- [ ] **1. Preparação da Placa de Fenolite / Cobre**:
  - Lixar suavemente a placa de cobre com palha de aço bem fina (Bombril) até o cobre ficar brilhante e 100% sem oxidação.
  - Limpar com álcool isopropílico para remover qualquer oleosidade de dedos (a gordura impede a aderência da tinta e do ácido).
- [ ] **2. Caneta Recomendada**:
  - Utilizar canetas permanentes à base de solvente e resistentes a ácido:
    - *Staedtler Lumocolor Permanent (Ponta S 0.4mm ou F 0.6mm)*
    - *Pilot CD/DVD Marker*
- [ ] **3. Desenho Automático com Passe Duplo**:
  - Fixar a placa na mesa da CNC com fita dupla face para não mover.
  - Zerar a caneta no canto inferior esquerdo da placa (`X0, Y0, Z0`).
  - Executar o desenho via **CNC PCB Commander** (`http://localhost:8080`).
  - Habilitar o **Passe Duplo de Tinta** no painel da Web App para garantir camada espessa que impede o percloreto de corroer microfuros na tinta.
- [ ] **4. Banho de Percloreto de Ferro**:
  - Diluir o percloreto em recipiente plástico (nunca metálico!).
  - Dica de Ouro: Aqueça a água da solução até $\sim 40^\circ\text{C}$ e agite suavemente a placa durante a corrosão. O processo levará apenas de 8 a 12 minutos.
- [ ] **5. Limpeza e Furação**:
  - Remover a tinta preta com álcool ou acetona.
  - Furar os ilhós dos componentes com mini furadeira / retífica e broca de $0.8\text{ mm}$ a $1.0\text{ mm}$.

---

## 🎯 FASE 5: Automações Futuras na CNC
- [ ] Implementação de Auto-Leveling (Mapeamento de desnível da placa de cobre via pino sensor no Arduino).
- [ ] Adaptação de spindle / micro-retífica para furação automática de PCBs.
