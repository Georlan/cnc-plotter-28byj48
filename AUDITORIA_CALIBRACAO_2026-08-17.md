# Auditoria de calibração — CNC Plotter 28BYJ-48

Data: 2026-08-17  
Impressora de referência: Bambu Lab A1, PLA, bico 0.4 mm

## Parâmetros aprovados

- `slide_clearance_xy = 0.22` mm — Teste 99, par #3.
- `slide_clearance_z = 0.15` mm.
- `passive_float = 0.60` mm.
- `pressfit_clearance = 0.15` mm.
- `shaft_clearance = 0.18` mm — teste físico do eixo Double-D, pinhão #1.
- 28BYJ-48: corpo Ø28.0 mm, montagem 35.0 mm, eixo Ø5.0 mm, seção Double-D 3.0 mm, faces 6.0 mm, eixo livre 8.5 mm, furos de flange r=2.1 mm, boss r=4.5 mm.

## Resultado da revisão arquivo por arquivo

| Arquivo | Resultado |
|---|---|
| `00_Parametros.scad` | **OK.** Parâmetros calibrados presentes; `d_shaft_hole()` e `d_shaft_solid()` usam dois cortes simétricos; `pinion_gear()` repassa `clearance`. |
| `01_Base_Trilho_X.scad` | **OK.** Usa `dovetail_male_x()` global; sem constantes antigas do motor. |
| `01B_Trilho_X_Passivo.scad` | **OK.** Apenas reutiliza o trilho X paramétrico. |
| `02_Carrinho_X.scad` | **OK.** Não existe bolso para o corpo Ø28: o corpo do motor fica fora da peça por projeto. O corredor usa `motor_boss_r`, `motor_shaft_r`, `motor_shaft_length` e os furos usam `motor_flange_hole_r`. |
| `02B_Sapata_X_Passiva_PETG.scad` | **OK.** Reutiliza a sapata paramétrica. |
| `03_Trilho_Y.scad` | **OK.** Sem parâmetros de motor duplicados; geometria principal já modelada sem suporte. |
| `04_Carrinho_Y.scad` | **OK.** Motores Y/Z ficam com o corpo fora da peça; corredores usam boss/eixo globais e os furos usam `motor_flange_hole_r`. |
| `05_Modulo_Z_Caneta.scad` | **OK.** Orelhas M3 já possuem base autoportante a 45° e o teto interno é cônico. |
| `06_Pinhoes.scad` | **OK.** Todos os pinhões chamam `pinion_gear()`, portanto usam `shaft_clearance=0.18` e Double-D global. |
| `07_Batentes.scad` | **CORRIGIDO.** Havia `clearance=0.10` hardcoded. Como o encaixe é de pressão, foi substituído por `pressfit_clearance=0.15`, não pela folga deslizante de 0.22. |
| `08_Clips_Fixacao_Papel.scad` | **CORRIGIDO.** Entrada inclinada passou de 30° para chanfro autoportante de 45°. |
| `90_Componentes_Referencia.scad` | **OK.** Modelo visual real usa `d_shaft_solid()` Double-D. O envelope de colisão do eixo permanece cilíndrico de propósito por ser conservador. |
| `91_Teste_Engrenamento_FDM.scad` | **OK.** Pinhão herda Double-D e folga global. |
| `92_Teste_Estrutural.scad` | **OK.** Guardas estruturais não duplicam calibrações. |
| `93_Teste_Plano_Caneta.scad` | **OK.** Sem dependências conflitantes do motor/folgas XY. |
| `94_Teste_Engrenamento_Dinamico.scad` | **OK.** Usa transmissão e pinhões paramétricos. |
| `95_Teste_Montagem_Completa.scad` | **OK.** Usa apenas módulos paramétricos compartilhados. |
| `96_Validacao_Curso.scad` | **OK.** Montagem completa reutilizada sem constantes antigas. |
| `97_Diagnostico_Motores.scad` | **OK.** Envelopes dos motores vêm de `90_Componentes_Referencia.scad`; sem dimensões antigas hardcoded. |
| `98_Teste_Interferencias.scad` | **OK.** Pinhões/carrinhos paramétricos. |
| `99_Teste_Tolerancias.scad` | **CORRIGIDO.** O arquivo não refletia a série realmente impressa. Agora registra `[0.14, 0.18, 0.22, 0.26, 0.30]` e identifica 0.22 mm como vencedor. |
| `99_Teste_Eixo_D.scad` | **CORRIGIDO.** A descrição antiga chamava 0.22 mm de nominal; agora registra 0.18 mm como resultado aprovado e identifica explicitamente o eixo Double-D. |
| `99_Teste_Folga_Pinhao_FDM.scad` | **OK.** Usa o pinhão global e parâmetros de bolso. |
| `99B_Teste_Portaferramenta_FDM.scad` | **OK.** Reutiliza o módulo Z já autoportante. |
| `CNC_Plotter_Full_Assembly.scad` | **OK.** Motores e pinhões vêm dos módulos paramétricos revisados. |
| `CNC_Plotter_Animated_Simulation.scad` | **OK.** Apenas anima a montagem paramétrica. |
| `placa_testes_completa.scad` | **OK.** Pinhões usam `pinion_gear()` global e porta-ferramenta usa o módulo Z revisado. |
| `scratch_frames_99/frame_000.scad` a `frame_023.scad` | **OK.** Arquivos gerados de visualização adicionados no commit `4b927a7`; todos usam `c=0.22`, módulos dovetail globais e não duplicam dimensões de motor. |
| `99C_Validacao_Parametros_Calibrados.scad` | **NOVO.** Assertions impedem regressão das calibrações e cotas do 28BYJ-48. |

## Observações de geometria FDM

- Não foi necessário alterar `01_Base_Trilho_X.scad`, `03_Trilho_Y.scad`, `04_Carrinho_Y.scad` ou `05_Modulo_Z_Caneta.scad`: as regiões verificadas estão apoiadas, ligadas ao corpo, ou já usam geometrias autoportantes.
- A ponte de fixação do motor X em `02_Carrinho_X.scad` está ligada ao corpo ao longo da face de montagem; não é um cantilever suspenso isolado.
- O único ponto adicional claramente abaixo do critério desejado de 45° foi a entrada dos clips, corrigida em `08_Clips_Fixacao_Papel.scad`.

## Build e regressão

- `build_stl.sh` agora inclui `99_Teste_Eixo_D.scad` e `placa_testes_completa.scad`, que estavam fora do lote automático.
- A workflow `.github/workflows/openscad-validation.yml` compila os STLs imprimíveis, executa a guarda de parâmetros e roda `validate_geometry.py`.
- Os STLs gerados continuam fora do versionamento (`/*.stl` no `.gitignore`) e são publicados como artefato temporário da CI.

## Arquivos de referência

- `28BYJ-48-dimensions.webp` está presente no branch `master`.
- `StepMotorModel.stl` **não está presente na árvore atual do branch `master`** no momento desta auditoria. Por isso, a verificação dimensional foi baseada nas cotas fornecidas e no datasheet já versionado.
