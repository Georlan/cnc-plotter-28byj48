# Guia didático de testes e montagem

Este guia acompanha a CNC Plotter 28BYJ-48 desde os primeiros cupons até o
primeiro desenho. Ele foi escrito para continuar válido quando as medidas do
projeto forem recalibradas.

## 1. Regra principal: parâmetros, não medidas copiadas

As medidas vigentes estão em `00_Parametros.scad`. Não copie dimensões de uma
captura de tela, de um STL antigo ou deste guia. Quando um teste físico indicar
outra folga, altere primeiro o parâmetro correspondente e gere novamente as
peças afetadas.

Antes de cada rodada anote:

- impressora, bico, material e perfil de fatiamento;
- altura de camada, número de paredes e compensação de pé de elefante;
- nome do arquivo e data em que o STL foi gerado;
- resultado observado, sem corrigir a peça com lixa antes de medir;
- folga escolhida e qualquer ruído, ponto duro ou movimento lateral.

Remova apenas fios, rebarbas soltas e o pé de elefante evidente. Lixar uma guia
até ela caber esconde o valor que deveria ser corrigido no modelo.

## 2. Inventário

### 2.1 Peças impressas finais

| Arquivo | O que sai na placa | Onde fica |
|---|---|---|
| `01_Base_Trilho_X.scad` | 1 trilho X motriz | frente da máquina; rack voltado para fora e para cima |
| `01B_Trilho_X_Passivo.scad` | 1 trilho X passivo | atrás; paralelo ao trilho motriz |
| `02_Carrinho_X.scad` | 1 carrinho X motriz + 1 sela rígida | carrinho no trilho dianteiro; sela sobre a sapata traseira |
| `02B_Sapata_X_Passiva_PETG.scad` | 1 sapata flutuante | desliza no trilho traseiro, sob a sela |
| `03_Trilho_Y.scad` | 1 viga Y com guia e rack | atravessa os dois carrinhos X; guia e rack para cima |
| `04_Carrinho_Y.scad` | 1 carrinho Y | desliza sobre a viga; sustenta motores Y/Z e módulo Z |
| `05_Modulo_Z_Caneta.scad` | êmbolo, colar, haste com mandril e buchas | dentro da guia Z do carrinho Y |
| `06_Pinhoes.scad` | 3 pinhões iguais | um em cada eixo de motor: X, Y e Z |
| `07_Batentes.scad` | 4 batentes X + 2 batentes Y | nas extremidades das três guias, após inserir os carrinhos |
| `08_Clips_Fixacao_Papel.scad` | 4 clips | nos cantos da área do papel |

Identifique os três pinhões como X, Y e Z depois do teste. Mesmo sendo iguais,
isso ajuda a relacionar um eventual defeito ao eixo correto.

### 2.2 Componentes não impressos

- 3 motores 28BYJ-48 compatíveis com os parâmetros atuais;
- 3 drivers apropriados para os motores;
- 1 mola de compressão compatível com os parâmetros atuais do Z;
- 1 base plana e rígida, normalmente MDF;
- 1 caneta para calibração e o pincel que será usado no final;
- cabos, fonte correta, controlador e itens de organização elétrica;
- fita dupla-face ou fixadores para os clips de papel.

Não compre a mola apenas pelo diâmetro. Confirme também comprimento livre,
curso útil e rigidez. Uma mola dimensionalmente correta pode exercer força
excessiva sobre o papel.

## 3. Parafusos e porcas

Esta é a lista inicial para a geometria atual. Os diâmetros e quantidades são
definidos pelas interfaces; o comprimento do M4 da base depende da espessura da
base e deve ser confirmado antes da compra definitiva.

| Quantidade | Fixador inicial | Aplicação | Aperto correto |
|---:|---|---|---|
| 8 | M4, comprimento conforme a base | quatro pontos de cada trilho X | firme, sem deformar o piso do trilho |
| 6 | M3x8 + 6 porcas M3 | dois parafusos em cada motor | alternado, apenas até a flange apoiar |
| 2 | M3x10 | uma extremidade da viga Y em cada carrinho X | rosca no furo piloto da chaveta; sem espanar o plástico |
| 1 | M3x8 | retenção da sela/sapata passiva | encostar no ressalto sem bloquear a flutuação |
| 1 | M3x12 + 1 porca M3 | colar da haste Z | suficiente para o colar não escorregar |
| 1 | M3x14 + 1 porca M3 | mandril da caneta ou pincel | suficiente para impedir giro, sem esmagar o cabo |

Total estrutural: **8 M4 + 11 M3 = 19 parafusos** e **8 porcas M3**.

Também é prudente separar arruelas M4 para a base e arruelas M3 para as flanges
dos motores. Os quatro clips aceitam fixação opcional; se forem parafusados,
adicione quatro fixadores compatíveis com a sua base. Eles não entram no total
estrutural porque podem ser presos com fita.

### Como confirmar o comprimento sem depender deste guia

1. Atravesse as peças sem apertar.
2. Some a espessura atravessada, arruela e porca.
3. Procure deixar alguns filetes completos além da porca, sem a ponta atingir
   rack, guia, motor ou mesa.
4. Nas roscas feitas diretamente no plástico, o parafuso deve alcançar o piloto
   sem atravessar a parede oposta.

## 4. Ordem dos testes

Não imprima trilhos e viga antes de aprovar os cupons físicos. Uma etapa só
avança quando o critério de aprovação estiver atendido.

### T0 — inspeção digital e geração dos STLs

Execute, com o OpenSCAD CLI instalado:

```bash
python3 validate_geometry.py
```

O resultado global deve ser `TODOS PASSARAM`. Erros de variável indefinida,
quantidade de componentes ou `min Z` devem ser resolvidos antes do fatiamento.

Para gerar as peças e os cupons físicos listados no script:

```bash
./build_stl.sh
```

### T1 — folga das guias: `99_Teste_Tolerancias.scad`

O cupom gera pares macho/fêmea em ordem crescente de folga.

1. Marque cada par ainda na mesa da impressora para não misturá-los.
2. Remova apenas rebarbas soltas.
3. Introduza cada macho na fêmea correspondente sem inclinar.
4. Teste o curso inteiro com os dedos, sem óleo.
5. Escolha a menor folga que percorra todo o curso sem ponto duro.

**Passou:** desliza sob pressão leve dos dedos, não cai sozinho e não balança
visivelmente. **Falhou apertado:** exige pancada, alicate ou força crescente.
**Falhou folgado:** desliza, mas apresenta inclinação ou batida lateral.

Registre o índice e o valor do par escolhido. Esse resultado calibra a família
de guias; ele não autoriza lixar todas as peças longas depois.

### T2 — perfil de engrenamento: `91_Teste_Engrenamento_FDM.scad`

1. Teste o furo D do pinhão num eixo de motor sem usar martelo.
2. Apoie o pinhão contra o rack curto mantendo os eixos paralelos.
3. Role o pinhão por vários dentes com leve pressão radial.
4. Repita depois de girar o pinhão meia volta no eixo.

**Passou:** rotação contínua, sem salto de dente e sem travamento periódico.
Uma pequena folga é preferível a pré-carga permanente. Se o ponto duro acompanha
o pinhão, investigue excentricidade ou furo D; se fica numa posição do rack,
investigue impressão do rack.

### T3 — espaço do pinhão: `99_Teste_Folga_Pinhao_FDM.scad`

O cupom contém um pinhão, um anel radial e um garfo axial.

1. Coloque o pinhão dentro do anel e gire-o em uma volta completa.
2. Passe o pinhão entre as paredes do garfo sem inclinar.
3. Procure marcas de raspagem nos dentes e nas faces.

**Passou:** gira no anel e atravessa o garfo sem ser forçado, mantendo folga
pequena. Esse teste valida o bolso livre ao redor do pinhão; não mede a folga
entre dentes do rack.

### T4 — mandril e buchas: `99B_Teste_Portaferramenta_FDM.scad`

1. Meça e teste a caneta e o pincel reais.
2. Use a menor bucha que aceite o cabo sem força.
3. Alinhe a fenda da bucha com a fenda do mandril.
4. Insira o cabo numa região aproximadamente cilíndrica, acima da virola.
5. Coloque a porca no alojamento e aperte o M3 gradualmente.
6. Faça um teste de giro e de tração com a mão.

**Passou:** a ferramenta não gira nem desce com força manual moderada, e o
mandril reabre quando o parafuso é solto. Não aperte sobre cerdas, virola fina
ou trecho cônico. Se a menor bucha ainda ficar folgada, relate o diâmetro real
do cabo para gerar outra bucha; não compense esmagando o mandril.

### T5 — testes paramétricos `92` e `93`

- `92_Teste_Estrutural.scad` verifica limites estruturais, espaço do papel,
  fabricação e curso da sapata.
- `93_Teste_Plano_Caneta.scad` verifica contato, elevação, força da mola e
  comprimento guiado do Z.

Ao renderizar, o resultado correto é somente o cubo marcador. Uma mensagem de
`assert` indica que algum parâmetro deixou a faixa segura.

### T6 — testes digitais de movimento e colisão `94`, `95`, `97` e `98`

- `94`: engrenamento amostrado durante um passo completo em X, Y e Z;
- `95`: interfaces entre trilhos, carrinhos, viga, pinhões e êmbolo;
- `97`: corpos, flanges, ressaltos e eixos dos três motores;
- `98`: verificação local rápida dos bolsos dos pinhões, guia Z e sapata.

Renderize com F6. O resultado correto é somente o cubo marcador distante.
Qualquer outra geometria exportada representa uma interseção real e deve ser
investigada; não prossiga porque o preview F5 “parece bom”.

### T7 — inspeção visual do curso: `96_Validacao_Curso.scad`

Renderize todas as posições definidas por `VALIDATION_POSITION`. Observe em
cada uma:

- se nenhum motor invade trilho, viga, outro motor ou ferramenta;
- se o pinhão permanece dentro do bolso e alinhado ao rack;
- se o êmbolo conserva apoio dentro da guia Z;
- se o porta-ferramenta não alcança a mesa;
- se cabos poderão acompanhar o movimento sem puxar os carrinhos.

Este teste mostra a montagem completa; nele não se aplica a regra do “somente
um cubo”.

## 5. Preparação das peças finais

1. Confirme que os STLs foram gerados depois da última alteração dos parâmetros.
2. Separe PLA e PETG conforme a tabela de peças.
3. Verifique empenamento dos dois trilhos e da viga sobre uma superfície plana.
4. Limpe canais, furos e entradas de guia sem aumentar suas dimensões.
5. Passe cada carrinho manualmente pela guia correspondente antes da montagem.
6. Teste cada pinhão no respectivo motor e identifique X, Y e Z.

Se uma peça longa prender somente numa extremidade, investigue empenamento ou
pé de elefante antes de aumentar globalmente a folga.

## 6. Montagem mecânica

### Etapa A — trilhos X na base

1. Posicione o trilho motriz na frente, com rack para cima e voltado para o lado
   externo da máquina.
2. Alinhe-o com uma referência reta e aperte seus quatro M4 gradualmente.
3. Posicione o trilho passivo atrás, paralelo ao primeiro.
4. Instale os quatro M4 traseiros apenas encostados; o ajuste final vem depois.
5. Não instale os batentes ainda.

### Etapa B — carrinhos X e apoio flutuante

1. Introduza o carrinho X motriz no trilho dianteiro pela extremidade.
2. Introduza a sapata PETG no trilho traseiro, com o ressalto voltado para cima.
3. Apoie a sela rígida sobre a sapata, encaixando o ressalto no bolso alongado.
4. Coloque o M3x8 pelo rasgo da sela e rosqueie no piloto da sapata.
5. Aperte até encostar no ressalto, nunca até prensar a sela.

**Controle:** a sela deve continuar se deslocando transversalmente dentro do
curso parametrizado, sem folga vertical perceptível.

### Etapa C — viga Y e esquadro do pórtico

1. Com os dois carrinhos na mesma posição longitudinal, assente os encaixes
   inferiores da viga nas chavetas dianteira e traseira.
2. Deixe a guia e o rack da viga voltados para cima.
3. Insira um M3x10 por cada face de extremidade e rosqueie nas chavetas.
4. Aperte alternadamente até a viga assentar, sem esmagar o plástico.
5. Desloque o pórtico manualmente por todo o X várias vezes.
6. Mantendo o movimento livre, aperte aos poucos os M4 do trilho traseiro em
   posições diferentes do curso.

**Controle:** o esforço deve permanecer parecido do início ao fim. Se endurece
nas pontas, solte o trilho passivo e refaça o paralelismo; não use o motor para
vencer desalinhamento.

### Etapa D — carrinho Y

1. Introduza o carrinho Y pela extremidade da viga antes dos batentes.
2. A guia fêmea fica sobre o rabo de andorinha da viga.
3. O bolso do pinhão Y deve coincidir com o rack da viga.
4. A face do motor Z fica voltada para a extremidade dianteira da viga; o motor
   Y fica na lateral externa do carrinho.
5. Percorra manualmente todo o Y e verifique esforço uniforme.

### Etapa E — êmbolo, mola e porta-ferramenta Z

1. Introduza o êmbolo na guia vertical com a cremalheira alinhada ao corredor
   externo e ao bolso do pinhão Z.
2. Insira a haste do porta-ferramenta por baixo, através do furo central.
3. Posicione a mola ao redor da haste, dentro da gaiola aberta do êmbolo.
4. Coloque o colar abaixo da mola e aperte seu M3 apenas o suficiente para que
   não escorregue. A mola deve ficar apoiada entre o colar e a tampa superior.
5. Acione o conjunto com a mão: ele deve comprimir e retornar sem raspar.
6. Instale a bucha aprovada e a ferramenta somente depois desse teste.

Se o colar não entrar lateralmente pela fenda sem risco de quebrar, não force:
desmonte o subconjunto, monte colar e mola na haste e repita a inserção. O colar
é recomendado em PETG justamente para tolerar essa abertura controlada.

### Etapa F — motores e pinhões

Repita para X, Y e Z:

1. Confira se o eixo D e o ressalto entram livremente no corredor coaxial.
2. Posicione o pinhão identificado no bolso e alinhe o lado plano ao eixo D.
3. Apoie a flange do motor na face externa da peça impressa.
4. Instale os dois M3x8 com porcas, deixando-os inicialmente frouxos.
5. Assente o pinhão no eixo sem martelo e sem usar o parafuso como prensa.
6. Gire o eixo manualmente e confirme que o pinhão não toca o bolso.
7. Aperte os dois parafusos alternadamente e repita a rotação.

**Controle:** o pinhão deve permanecer engrenado, mas o eixo precisa girar sem
pré-carga lateral. Se o motor solto gira e o apertado trava, revise assentamento
da flange, rebarba e alinhamento; não aumente corrente para mascarar o defeito.

### Etapa G — batentes, clips e ferramenta

1. Depois de todos os carrinhos estarem nas guias, pressione dois batentes em
   cada trilho X e um em cada extremidade da guia Y.
2. Instale os clips sem invadir o curso útil da ferramenta.
3. Coloque a bucha correspondente no mandril, alinhando as fendas.
4. Prenda caneta ou pincel pelo cabo redondo, nunca pelas cerdas ou virola.
5. Com a máquina desligada, ajuste o colar para produzir apenas a pré-carga
   definida nos parâmetros quando a ferramenta toca o papel.

## 7. Testes da máquina montada

Faça tudo primeiro sem energia:

1. mova X por todo o curso;
2. mova Y por todo o curso em três posições diferentes de X;
3. mova Z para baixo e solte; ele deve retornar;
4. gire cada motor lentamente pelo eixo e procure pontos duros;
5. confirme que nenhum cabo pode entrar em rack ou pinhão.

Depois energize um eixo por vez, em baixa velocidade e aceleração:

1. execute pequenos deslocamentos nos dois sentidos;
2. confirme sentido e limite antes de testar curso completo;
3. escute mudança de ruído e observe perda de passos;
4. repita com a ferramenta levantada e depois tocando levemente o papel;
5. pare imediatamente se houver travamento, salto de dentes ou aquecimento
   anormal.

Não alimente um motor nominal de 5 V diretamente com 12 V.

## 8. Primeiro desenho e primeiro teste com pincel

### Caneta

1. Prenda uma folha de rascunho.
2. Faça linhas horizontais e verticais curtas.
3. Faça um quadrado e duas diagonais.
4. Faça um círculo em baixa velocidade.
5. Observe falha de fechamento, ondulação, espessura irregular e marcas nas
   mudanças de direção.

### Pincel

1. Use tinta pouco carregada e uma folha protegendo a base.
2. Comece com força Z menor do que a usada na caneta.
3. Faça linhas retas em diferentes velocidades.
4. Verifique se o cabo gira no mandril e se as cerdas dobram sempre para o mesmo
   lado.
5. Só depois teste curvas e preenchimentos.

Pincel introduz arrasto variável, tinta e flexibilidade das cerdas. Um resultado
ruim com pincel não significa automaticamente defeito mecânico: compare sempre
com o teste de caneta feito na mesma montagem.

## 9. O que registrar e enviar para uma recalibração

Envie os resultados sem lixar os cupons, incluindo:

- foto dos cinco pares de tolerância ainda identificados;
- valor do menor par que deslizou livremente;
- vídeo curto do pinhão rolando no rack;
- foto do pinhão dentro do anel e entre as paredes do garfo;
- diâmetro real da caneta e do cabo do pincel no ponto de aperto;
- foto do `99B` segurando cada ferramenta e descrição do aperto necessário;
- vídeo do pórtico sendo movido à mão do início ao fim;
- eixo que apresentou ruído, folga, raspagem ou perda de passo;
- material, camada, paredes e qualquer compensação usada no fatiador.

Com esses dados, as alterações podem ser feitas nos parâmetros corretos sem
redesenhar a estrutura nem repetir impressões grandes desnecessariamente.
