---
ia-translate: true
title: Abordagem geral para aplicativos adaptáveis
description: >-
  Conselhos gerais sobre como abordar a criação de um aplicativo Flutter adaptável.
short-title: Abordagem geral
---

<?code-excerpt path-base="ui/adaptive_app_demos"?>

Então, _como_ você aborda a tarefa de pegar um aplicativo
projetado para dispositivos móveis convencionais e torná-lo
bonito em uma ampla variedade de dispositivos? Quais etapas são
necessárias?

Engenheiros do Google, que têm experiência em fazer isso
para grandes aplicativos, recomendam a seguinte abordagem
em 3 etapas.

## Etapa 1: Abstrair

![Etapa 1: Abstrair informações comuns a qualquer widget de UI](/assets/images/docs/ui/adaptive-responsive/abstract.png)

Primeiro, identifique os widgets que você planeja
tornar dinâmicos. Analise os construtores desses
widgets e abstraia os dados que você pode compartilhar.

Widgets comuns que exigem adaptabilidade são:

*   Diálogos, tanto em tela cheia quanto modais
*   UI de navegação, tanto rail quanto barra inferior
*   Layout personalizado, como "a área da UI é mais alta ou mais larga?"

Por exemplo, em um widget `Dialog`, você pode compartilhar as
informações que contêm o _conteúdo_ do diálogo.

Ou, talvez você queira alternar entre uma `NavigationBar`
quando a janela do aplicativo é pequena e um `NavigationRail`
quando a janela do aplicativo é grande. Esses widgets
provavelmente compartilhariam uma lista de destinos navegáveis.
Nesse caso, você pode criar um widget `Destination` para
conter essas informações e especificar que o `Destination`
tenha um ícone e um rótulo de texto.

Em seguida, você avaliará o tamanho da tela para decidir
como exibir sua UI.

## Etapa 2: Medir

![Etapa 2: Como medir o tamanho da tela](/assets/images/docs/ui/adaptive-responsive/measure.png)

Você tem duas maneiras de determinar o tamanho da sua área
de exibição: `MediaQuery` e `LayoutBuilder`.

### MediaQuery

No passado, você poderia ter usado `MediaQuery.of` para
determinar o tamanho da tela do dispositivo. No entanto, os
dispositivos hoje apresentam telas com uma ampla variedade de
tamanhos e formatos, e este teste pode ser enganoso.

Por exemplo, talvez seu aplicativo ocupe atualmente uma
pequena janela em uma tela grande. Se você usar o método
`MediaQuery.of` e concluir que a tela é pequena
(quando, na verdade, o aplicativo é exibido em uma pequena
janela em uma tela grande), e você bloqueou o aplicativo
para o modo retrato, isso faz com que a janela do aplicativo
seja bloqueada no centro da tela, cercada de preto.
Esta não é uma UI ideal em uma tela grande.

:::note
As diretrizes do Material recomendam que você nunca
_bloqueie o modo retrato_ do seu aplicativo (desativando o
modo paisagem). No entanto, se você sentir que realmente
precisa, defina pelo menos o modo retrato para funcionar
tanto no modo de cima para baixo quanto de baixo para cima.
:::

Lembre-se de que `MediaQuery.sizeOf` retorna o tamanho atual
de toda a tela do aplicativo e não apenas de um único widget.

Você tem duas maneiras de medir o espaço da sua tela. Você
pode usar `MediaQuery.sizeOf` ou `LayoutBuilder`, dependendo
se você deseja o tamanho de toda a janela do aplicativo
ou um dimensionamento mais local.

Se você quer que seu widget seja em tela cheia, mesmo
quando a janela do aplicativo é pequena, use `MediaQuery.sizeOf`
para que você possa escolher a UI com base no tamanho da
própria janela do aplicativo. Na seção anterior, você quer
basear o comportamento de dimensionamento em toda a janela do
aplicativo, então você usaria `MediaQuery.sizeOf`.

:::secondary Por que usar `MediaQuery.sizeOf` em vez de `MediaQuery.of`?
Conselhos anteriores recomendavam que você usasse o método
`of` de `MediaQuery` para obter as dimensões da janela do
aplicativo. Por que este conselho mudou? A resposta curta é
**por razões de desempenho.**

`MediaQuery` contém muitos dados, mas se você estiver
interessado apenas na propriedade size, é mais eficiente
usar o método `sizeOf`. Ambos os métodos retornam o tamanho
da janela do aplicativo em pixels lógicos (também conhecidos
como _pixels independentes de densidade_). As dimensões de
pixel lógico geralmente funcionam melhor, pois têm
aproximadamente o mesmo tamanho visual em todos os
dispositivos. A classe `MediaQuery` tem outras funções
especializadas para cada uma de suas propriedades individuais
pelo mesmo motivo.
:::

Solicitar o tamanho da janela do aplicativo de dentro do
método `build`, como em `MediaQuery.sizeOf(context)`, faz
com que o `BuildContext` fornecido seja reconstruído sempre
que a propriedade size for alterada.

### LayoutBuilder

`LayoutBuilder` alcança um objetivo semelhante ao de
`MediaQuery.sizeOf`, com algumas distinções.

Em vez de fornecer o tamanho da janela do aplicativo,
`LayoutBuilder` fornece as restrições de layout do `Widget`
pai. Isso significa que você obtém informações de
dimensionamento com base no local específico na árvore de
widgets onde você adicionou o `LayoutBuilder`. Além disso,
`LayoutBuilder` retorna um objeto `BoxConstraints` em vez
de um objeto `Size`, então você recebe as faixas de largura
e altura válidas (mínima e máxima) para o conteúdo, em vez
de apenas um tamanho fixo. Isso pode ser útil para widgets
personalizados.

Por exemplo, imagine um widget personalizado, onde você
deseja que o dimensionamento seja baseado no espaço
especificamente dado a esse widget e não na janela do
aplicativo em geral. Neste cenário, use `LayoutBuilder`.

## Etapa 3: Ramificar

![Etapa 3: Ramificar o código com base na UI desejada](/assets/images/docs/ui/adaptive-responsive/branch.png)

Neste ponto, você deve decidir quais pontos de interrupção
de dimensionamento usar ao escolher qual versão da UI
exibir. Por exemplo, as diretrizes de [layout do Material][]
sugerem o uso de uma barra de navegação inferior para janelas
com menos de 600 pixels lógicos de largura e um nav rail
para aquelas com 600 pixels de largura ou mais.
Novamente, sua escolha não deve depender do _tipo_ de
dispositivo, mas do tamanho da janela disponível do
dispositivo.

[layout do Material]: https://m3.material.io/foundations/layout/applying-layout/window-size-classes

Para trabalhar em um exemplo que alterna entre um
`NavigationRail` e uma `NavigationBar`, confira
[Criando um layout de aplicativo responsivo animado com Material 3][codelab].

[codelab]: {{site.codelabs}}/codelabs/flutter-animated-responsive-layout

A próxima página discute como garantir que seu
aplicativo tenha a melhor aparência em telas grandes e dobráveis.
