# Guia visual de testes e montagem

## Simulação 3D interativa

Abra [`GUIA_3D_INTERATIVO.html`](GUIA_3D_INTERATIVO.html) em um navegador para
girar a máquina, aplicar zoom e acompanhar as peças entrando em sete etapas.
Use **Montar** para reproduzir a sequência automaticamente; na última etapa,
os três eixos e os pinhões são animados juntos.

> No GitHub, baixe o arquivo HTML e abra-o localmente. O visual abaixo continua
> útil como folha de referência rápida durante a bancada.

![Infográfico completo de testes, peças, fixadores e montagem](docs/guia-visual-montagem.svg)

## Como usar

1. Comece pelos quatro cupons da primeira faixa.
2. Só imprima as peças longas depois que os quatro estiverem aprovados.
3. Monte seguindo a sequência numerada; o trilho traseiro só recebe o aperto
   final depois que o pórtico estiver correndo livre.
4. Confira o mapa dos fixadores antes de apertar qualquer subconjunto.
5. Faça o controle manual mostrado no quadro verde antes de energizar.

As dimensões continuam centralizadas em `00_Parametros.scad`. O infográfico
mostra relações, posição e ordem de montagem, portanto continua válido após
uma recalibração de folgas.

Para critérios detalhados de aprovação, diagnóstico e registro dos resultados,
consulte [`GUIA_TESTES_E_MONTAGEM.md`](GUIA_TESTES_E_MONTAGEM.md).
