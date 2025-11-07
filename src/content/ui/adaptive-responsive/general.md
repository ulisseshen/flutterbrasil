---
ia-translate: true
title: Abordagem geral para apps adaptativos
description: >-
  Conselhos gerais sobre como abordar a criação de seu app Flutter adaptativo.
short-title: Abordagem geral
---

<?code-excerpt path-base="ui/adaptive_app_demos"?>

Então, apenas _como_ você aborda pegar um app
projetado para dispositivos móveis convencionais,
e torná-lo bonito em uma ampla gama
de dispositivos? Quais passos são necessários?

Engenheiros do Google, que têm experiência fazendo isso
para apps grandes, recomendam a
seguinte abordagem de 3 passos.

## Passo 1: Abstrair

![Step 1: Abstract info common to any UI widget](/assets/images/docs/ui/adaptive-responsive/abstract.png)

Primeiro, identifique os widgets que você planeja
tornar dinâmicos. Analise os construtores desses
widgets e abstraia os dados que você pode compartilhar.

Widgets comuns que exigem adaptabilidade são:

* Dialogs, tanto fullscreen quanto modal
* UI de navegação, tanto rail quanto barra inferior
* Layout customizado, como "a área da UI é mais alta ou mais larga?"

Por exemplo, em um widget `Dialog`, você pode compartilhar
a informação que contém o _conteúdo_ do diálogo.

Ou, talvez você queira alternar entre uma
`NavigationBar` quando a janela do app é pequena,
e um `NavigationRail` quando a janela do app é grande.
Esses widgets provavelmente compartilhariam uma lista de
destinos navegáveis. Neste caso,
você pode criar um widget `Destination` para armazenar
essa informação, e especificar o `Destination` como tendo tanto
um ícone quanto um rótulo de texto.

A seguir, você avaliará o tamanho da tela para decidir
como exibir sua UI.

## Passo 2: Medir

![Step 2: How to measure screen size](/assets/images/docs/ui/adaptive-responsive/measure.png)

Você tem duas maneiras de determinar o tamanho da sua área de exibição:
`MediaQuery` e `LayoutBuilder`.

### MediaQuery

No passado, você pode ter usado `MediaQuery.of` para
determinar o tamanho da tela do dispositivo.
No entanto, os dispositivos hoje apresentam telas
com uma ampla variedade de tamanhos e formatos,
e este teste pode ser enganoso.

Por exemplo, talvez seu app ocupe atualmente uma
pequena janela em uma tela grande. Se você usar o
método `MediaQuery.of` e concluir que a tela é pequena
(quando, na verdade, o app é exibido em uma janela minúscula em uma tela grande),
e você bloqueou seu app no modo retrato, isso faz com que a
janela do app fique bloqueada no centro da
tela, cercada por preto.
Isso dificilmente é uma UI ideal em uma tela grande.

:::note
As Material Guidelines encorajam você a nunca
_bloquear no modo retrato_ seu app (desabilitando o modo paisagem).
No entanto, se você sentir que realmente deve,
então pelo menos defina o modo retrato para funcionar
no modo de cima para baixo, bem como de baixo para cima.
:::

Tenha em mente que `MediaQuery.sizeOf` retorna o
tamanho atual da tela inteira do app e
não apenas um único widget.

Você tem duas maneiras de medir seu espaço de tela.
Você pode usar `MediaQuery.sizeOf` ou `LayoutBuilder`,
dependendo se você quer o tamanho de toda a
janela do app, ou dimensionamento mais local.

Se você quer que seu widget seja fullscreen,
mesmo quando a janela do app é pequena,
use `MediaQuery.sizeOf` para que você possa escolher a
UI com base no tamanho da janela do app em si.
Na seção anterior, você quer basear o
comportamento de dimensionamento na janela inteira do app,
então você usaria `MediaQuery.sizeOf`.

:::secondary Por que usar `MediaQuery.sizeOf` em vez de `MediaQuery.of`?
Conselhos anteriores recomendavam que você usasse o método `of` do
`MediaQuery` para obter as dimensões da janela do app.
Por que esse conselho mudou?
A resposta curta é **por razões de desempenho.**

`MediaQuery` contém muitos dados, mas se você está
interessado apenas na propriedade de tamanho, é mais
eficiente usar o método `sizeOf`. Ambos os métodos
retornam o tamanho da janela do app em pixels lógicos
(também conhecidos como _pixels independentes de densidade_).
As dimensões de pixels lógicos geralmente funcionam melhor, pois têm
aproximadamente o mesmo tamanho visual em todos os dispositivos.
A classe `MediaQuery` tem outras funções especializadas
para cada uma de suas propriedades individuais pelo mesmo motivo.
:::

Solicitar o tamanho da janela do app de dentro
do método `build`, como em `MediaQuery.sizeOf(context)`,
faz com que o `BuildContext` fornecido reconstrua sempre que
a propriedade de tamanho muda.

### LayoutBuilder

`LayoutBuilder` realiza um objetivo semelhante ao
`MediaQuery.sizeOf`, com algumas distinções.

Em vez de fornecer o tamanho da janela do app,
`LayoutBuilder` fornece as restrições de layout do
`Widget` pai. Isso significa que você obtém
informações de dimensionamento baseadas no local específico
na árvore de widgets onde você adicionou o `LayoutBuilder`.
Além disso, `LayoutBuilder` retorna um objeto `BoxConstraints`
em vez de um objeto `Size`,
então você recebe os intervalos de largura
e altura válidos (mínimo e máximo) para o conteúdo,
em vez de apenas um tamanho fixo.
Isso pode ser útil para widgets customizados.

Por exemplo, imagine um widget customizado, onde você quer
que o dimensionamento seja baseado no espaço especificamente
dado a esse widget, e não na janela do app em geral.
Neste cenário, use `LayoutBuilder`.

## Passo 3: Ramificar

![Step 3: Branch the code based on the desired UI](/assets/images/docs/ui/adaptive-responsive/branch.png)

Neste ponto, você deve decidir quais pontos de interrupção de dimensionamento usar
ao escolher qual versão da UI exibir.
Por exemplo, as diretrizes de [layout Material][Material layout] sugerem usar
uma barra de navegação inferior para janelas com menos de 600 pixels lógicos de largura,
e uma rail de navegação para aquelas com 600 pixels de largura ou mais.
Novamente, sua escolha não deve depender do _tipo_ de dispositivo,
mas do tamanho de janela disponível do dispositivo.

[Material layout]: https://m3.material.io/foundations/layout/applying-layout/window-size-classes

Para trabalhar com um exemplo que alterna entre um
`NavigationRail` e uma `NavigationBar`, confira
o [Building an animated responsive app layout with Material 3][codelab].

[codelab]: {{site.codelabs}}/codelabs/flutter-animated-responsive-layout

A próxima página discute como garantir que seu
app tenha a melhor aparência em telas grandes e dobráveis.
