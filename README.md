# CNC Plotter 28BYJ-48 — baixo custo, impressa em 3D

Plotter cartesiana para papel A5, modelada parametricamente em OpenSCAD e
otimizada para fabricação na Bambu Lab A1.

## Arquitetura atual

- Um único eixo X apoiado em **dois trilhos paralelos**.
- Trilho X dianteiro motriz: uma cremalheira, um pinhão e um 28BYJ-48.
- Trilho X traseiro passivo: sem cremalheira e sem segundo motor.
- Sapata PETG flutuante no apoio traseiro: `±0,60 mm` em Y para não travar por
  pequeno erro de paralelismo.
- Viga Y tubular de `30 x 24 mm`, parede de `1,8 mm`, diafragmas a cada
  `40 mm` e apoio nas duas extremidades.
- Papel parado; apenas pórtico, carrinho Y e caneta se movem.
- Z com mola metálica: o plástico guia a caneta, mas não define sozinho a
  pressão no papel.

O curso conservador é **148 x 180 mm** dentro de uma folha A5. A máquina segura
a folha inteira, mas mantém margem de 15 mm nas extremidades longas.

## Arquivos imprimíveis

| Arquivo | Conteúdo | Material |
|---|---|---|
| `01_Base_Trilho_X.scad` | trilho dianteiro com cremalheira | PLA |
| `01B_Trilho_X_Passivo.scad` | trilho traseiro sem cremalheira | PLA |
| `02_Carrinho_X.scad` | carrinho motriz + sela traseira | PLA |
| `02B_Sapata_X_Passiva_PETG.scad` | sapata flutuante | PETG |
| `03_Trilho_Y.scad` | viga-caixão Y com guia e rack | PLA |
| `04_Carrinho_Y.scad` | carrinho Y e suportes dos motores Y/Z | PLA |
| `05_Modulo_Z_Caneta.scad` | êmbolo Z + colar | PETG recomendado |
| `06_Pinhoes.scad` | três pinhões D de 10 dentes | PETG recomendado |
| `07_Batentes.scad` | quatro batentes X + dois Y, por pressão | PETG |
| `08_Clips_Fixacao_Papel.scad` | quatro clips de papel | PLA ou PETG |

`02_Carrinho_X.scad` e `02B_Sapata_X_Passiva_PETG.scad` foram separados para
não exigir PLA e PETG na mesma placa.

## Parâmetros principais

- Trilhos X: `220 x 26 mm`; distância entre centros: `240 mm`.
- Viga Y: `240 x 30 x 24 mm`.
- Guia XY: rabo de andorinha, folga inicial `0,22 mm` por lado.
- Guia Z: folga inicial `0,15 mm` por lado e 22 mm de comprimento guiado.
- Cremalheira: passo circular `4,0 mm`.
- Pinhão: 10 dentes, perfil involuta *stub*, ângulo de pressão de 30°.
- Relação cinemática correta: **9° de pinhão por mm linear**; 4 mm correspondem
  a 36°, não a uma volta completa.

Antes das peças longas, imprima `99_Teste_Tolerancias.scad`. Use a menor folga
que deslize sem força após retirar rebarbas.

## Altura e pressão da caneta

- Curso total do motor Z: `8 mm`.
- Compressão nominal no contato: `2 mm`.
- Elevação livre real: `6 mm`.
- Ponta baixa: `Z = 0,30 mm`, na superfície modelada do papel.
- Ponta alta: `Z = 6,30 mm`.
- Mola-alvo: `0,20 N/mm`, pré-carga de `1 mm`, curso complacente de `3 mm`.
- Força nominal modelada: aproximadamente `0,60 N`.
- Força no fim do curso complacente: aproximadamente `0,80 N`.

Uma mola entre `0,15 e 0,25 N/mm` é aceitável. Ajuste primeiro a altura do
colar com a máquina desligada; não use o motor para esmagar a ponta na mesa.

## Massa e rigidez

Volumes medidos nos STLs renderizados:

- peças móveis impressas: aproximadamente **154 g**;
- três motores, usando 35 g por motor como referência: aproximadamente 105 g;
- caneta, mola e fixadores móveis: aproximadamente 15–25 g;
- conjunto móvel estimado: **274–284 g**.

O valor dos motores varia por fabricante. A estimativa não substitui a pesagem.

Para a viga 30 x 24 x 1,8 mm, um cálculo simplificado de viga biapoiada com
1,3 N no centro e módulo de PLA de 1,8 GPa resulta em cerca de `0,013 mm` de
deflexão elástica. Isso não é FEA: juntas, empenamento e montagem fora de
esquadro dominarão o erro real.

## Fatiamento econômico na Bambu Lab A1

### Trilhos e viga em PLA

- camada: `0,24 mm`;
- gerador de paredes: Arachne;
- 3 paredes;
- 4 camadas de topo/fundo;
- 10% Gyroid nos blocos locais;
- brim de 5–8 mm nos trilhos de 220 mm e 5 mm na viga de 240 mm;
- suporte desativado.

### Carrinhos em PLA

- camada: `0,20 ou 0,24 mm`;
- 4 paredes;
- 15% Gyroid;
- suporte desativado.

### Sapata, Z e pinhões em PETG

- camada: `0,20 mm`;
- 4 paredes;
- pinhões: 100% de preenchimento;
- sapata/Z: 20–30%;
- seque o PETG antes de imprimir as superfícies de guia.

Os canais inferiores têm 0,25 mm de profundidade e pontes de no máximo 10 mm.
Não ative suporte dentro deles.

## Parafusos mínimos

- 8x M4 para os dois trilhos (quatro por trilho);
- 6x M3 para os três motores (dois por motor);
- 2x M3 para as extremidades da viga;
- 1x M3x8 para reter a sapata sem apertar a sela;
- 1x M3 para o colar da caneta.

Total estrutural: **18 parafusos**. Batentes são de pressão e os clips de papel
podem usar fita dupla-face.

## Montagem sem perder o esquadro

1. Fixe totalmente apenas o trilho dianteiro.
2. Deixe os quatro parafusos do trilho traseiro levemente soltos.
3. Monte os dois carrinhos e a viga, sem forçar a sapata passiva.
4. Desloque o pórtico manualmente por todo o X.
5. Aperte o trilho traseiro aos poucos, alternando posições do pórtico.
6. Aperte o M3 da sapata contra o ressalto; a sela deve continuar movendo
   aproximadamente `±0,60 mm`.
7. Só então monte motores e ajuste o engrenamento.

## Validação

Com o OpenSCAD CLI instalado:

```bash
python3 validate_geometry.py
```

Testes:

- `92_Teste_Estrutural.scad`: dimensões, esbeltez e área A5;
- `93_Teste_Plano_Caneta.scad`: altura, elevação, força e guia Z;
- `94_Teste_Engrenamento_Dinamico.scad`: 17 amostras em um passo completo;
- `95_Teste_Montagem_Completa.scad`: interfaces e colisões estruturais;
- `96_Validacao_Curso.scad`: centro e quatro extremos para inspeção visual;
- `97_Diagnostico_Motores.scad`: envelopes dos motores;
- `98_Teste_Interferencias.scad`: bolsos de pinhão e curso Z;
- `99_Teste_Tolerancias.scad`: cupom físico de folgas.

Os testes 92–95 e 97–98 devem exportar somente seu cubo marcador de 1 mm.
Geometria adicional indica colisão.

Para gerar somente os STLs imprimíveis:

```bash
./build_stl.sh
```

## Limite elétrico

Não alimente um 28BYJ-48 de 5 V diretamente com 12 V. Esta revisão mecânica não
depende dessa modificação. Use aceleração moderada no firmware e valide perda
de passos com quadrados e círculos antes do trabalho final.

## Licença

Hardware aberto para uso pessoal e educacional.
