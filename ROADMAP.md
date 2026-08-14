# Roadmap — CNC Plotter 28BYJ-48

Este roadmap acompanha o estado real do projeto. As medidas continuam em
`00_Parametros.scad`; resultados físicos podem alterar folgas sem invalidar a
sequência abaixo.

## Estado atual

- [x] Estrutura paramétrica completa em OpenSCAD.
- [x] Trilhos X duplos, viga Y apoiada e módulo Z redesenhados.
- [x] Motores e pinhões posicionados nos três eixos.
- [x] Folgas de segurança e porta-ferramenta para caneta/pincel adicionados.
- [x] Testes de impressão e guias de montagem preparados.
- [x] Simulação 3D interativa em `GUIA_3D_INTERATIVO.html`.
- [ ] Validar as tolerâncias na impressora real.

## Fase 1 — Cupons antes das peças grandes

- [ ] Imprimir `91_Teste_Engrenamento_FDM.scad` e escolher o engrenamento que
  gira continuamente, sem salto e sem forçar o eixo.
- [ ] Imprimir `99_Teste_Folga_Pinhao_FDM.scad` e registrar a melhor folga.
- [ ] Imprimir `99_Teste_Tolerancias.scad` e registrar as folgas que deslizam
  sem jogo excessivo.
- [ ] Imprimir `99B_Teste_Portaferramenta_FDM.scad` com o material final e
  testar caneta e pincel.
- [ ] Atualizar somente os parâmetros correspondentes em `00_Parametros.scad`.

**Portão de avanço:** todos os cupons devem passar antes de imprimir trilhos,
viga e carrinhos completos.

## Fase 2 — Impressão e inspeção

- [ ] Gerar os STL com `build_stl.sh` após calibrar os cupons.
- [ ] Imprimir pinhões e peças de precisão primeiro; depois as peças longas.
- [ ] Remover rebarbas sem desgastar dentes ou superfícies de referência.
- [ ] Conferir empenamento, furos, encaixes, rachaduras e camadas.
- [ ] Separar parafusos, porcas, mola, motores, drivers e fonte.

## Fase 3 — Montagem mecânica sem energia

- [ ] Fixar o trilho X motriz e deixar o trilho X passivo levemente solto.
- [ ] Inserir os dois carrinhos X e montar sapata/sela passiva.
- [ ] Assentar a viga Y nas chavetas e usá-la para alinhar os trilhos X.
- [ ] Percorrer todo o curso X e apertar o trilho passivo gradualmente.
- [ ] Inserir o carrinho Y antes dos batentes.
- [ ] Montar êmbolo, mola, colar e porta-ferramenta do eixo Z.
- [ ] Instalar motores e aproximar os pinhões sem pré-carga radial.

**Portão de avanço:** X, Y e Z devem mover manualmente em todo o curso, sem
pontos duros, colisões, salto de dentes ou flexão visível dos eixos.

## Fase 4 — Elétrica e segurança

- [ ] Alimentar os três ULN2003 com fonte externa regulada de 5 V e margem de
  corrente; não alimentar todos os motores pelo pino 5 V do Arduino.
- [ ] Unir o GND da fonte ao GND do Arduino.
- [ ] Ligar um motor por vez e conferir temperatura, ruído e giro.
- [ ] Organizar cabos com folga para todo o curso e longe das engrenagens.
- [ ] Manter um desligamento rápido disponível nos primeiros testes.

| Eixo | ULN2003 no Arduino Uno |
|---|---|
| X | IN1–IN4 em D2–D5 |
| Y | IN1–IN4 em D6–D9 |
| Z | IN1–IN4 em D10–D13 |

## Fase 5 — Firmware e calibração

- [x] Firmware `CNC_Plotter_28BYJ48.ino` criado para três 28BYJ-48.
- [ ] Gravar o firmware e validar a serial em 115200 baud.
- [ ] Testar um eixo por vez em baixa velocidade.
- [ ] Mandar 10 mm, medir e recalcular `STEPS_PER_MM`; repetir com 50 mm.
- [ ] Ajustar velocidade e aceleração até eliminar perda de passos.
- [ ] Confirmar que Z não esmaga o pincel contra o papel.

## Fase 6 — Movimento e desenho

- [ ] Rodar o teste de interferências nos extremos do curso.
- [ ] Desenhar linhas, quadrado e diagonais; medir esquadro e repetibilidade.
- [ ] Executar `G-code-to-write-a-spiral.ngc` para movimento contínuo X/Y.
- [ ] Executar `G-code-to-write-ABC+Hatched.ngc` para validar X/Y/Z.
- [ ] Repetir o desenho três vezes e comparar retorno, pressão e passos perdidos.
- [ ] Registrar material, camada, folgas, passos/mm, velocidade e resultado.

## Fase 7 — Melhorias após a primeira máquina funcional

- [ ] Fins de curso e homing automático.
- [ ] Fixação definitiva do papel e superfície substituível.
- [ ] Alívio de tração e guia para cabos.
- [ ] Avaliar motores mais fortes somente se os testes comprovarem falta de
  torque; primeiro eliminar atrito, desalinhamento e pré-carga.

## Documentos de apoio

- `GUIA_3D_INTERATIVO.html` — montagem e movimento em 3D.
- `GUIA_VISUAL_MONTAGEM.md` — referência visual rápida.
- `GUIA_TESTES_E_MONTAGEM.md` — critérios e lista de fixadores.
- `CNC_Plotter_Animated_Simulation.scad` — simulação paramétrica no OpenSCAD.
