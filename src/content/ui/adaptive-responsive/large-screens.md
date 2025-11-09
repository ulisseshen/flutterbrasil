---
ia-translate: true
title: Dispositivos de tela grande
description: >-
  Coisas para ter em mente ao adaptar apps
  para telas grandes.
shortTitle: Telas grandes
---

<?code-excerpt path-base="ui/adaptive_app_demos"?>

Esta página fornece orientação sobre otimizar seu
app para melhorar seu comportamento em telas grandes.

Flutter, como Android, define [large screens][large screens] como tablets,
dobráveis, e dispositivos ChromeOS executando Android. Flutter
_também_ define dispositivos de tela grande como web, desktop,
e iPads.

:::secondary Por que telas grandes importam, em particular?
A demanda por telas grandes continua a aumentar.
Em janeiro de 2024,
mais de [270 milhões de telas grandes ativas][large screens]
e dispositivos dobráveis rodam em Android e mais de
[14.9 milhões de usuários de iPad][14.9 million iPad users].

Quando seu app suporta telas grandes,
ele também recebe outros benefícios.
Otimizar seu app para preencher a tela.
Por exemplo, isso:

* Melhora as métricas de engajamento do usuário do seu app.
* Aumenta a visibilidade do seu app na Play Store.
  [Atualizações recentes da Play Store][Play Store updates] mostram classificações por
  tipo de dispositivo e indicam quando um app carece de
  suporte a telas grandes.
* Garante que seu app atenda às diretrizes de envio do iPadOS
  e seja [aceito na App Store][accepted in the App Store].
:::

[14.9 million iPad users]: https://www.statista.com/statistics/299632/tablet-shipments-apple/
[accepted in the App Store]: https://developer.apple.com/ipados/submit/
[large screens]: {{site.android-dev}}/guide/topics/large-screens/get-started-with-large-screens
[Play Store updates]: {{site.android-dev}}/2022/03/helping-users-discover-quality-apps-on.html

## Layout com GridView

Considere as seguintes capturas de tela de um app.
O app exibe sua UI em um `ListView`.
A imagem à esquerda mostra o app rodando
em um dispositivo móvel. A imagem à direita mostra o
app rodando em um dispositivo de tela grande
_antes do conselho nesta página ser aplicado_.

![Sample of large screen](/assets/images/docs/ui/adaptive-responsive/large-screen.png){:width="90%"}

Isso não é ideal.

As [Diretrizes de Qualidade de App de Tela Grande do Android][guidelines]
e o [equivalente do iOS][iOS equivalent]
dizem que nem texto nem caixas devem ocupar toda a
largura da tela. Como resolver isso de forma adaptativa?

[guidelines]: https://developer.android.com/docs/quality-guidelines/large-screen-app-quality
[iOS equivalent]: https://developer.apple.com/design/human-interface-guidelines/designing-for-ipados

Uma solução comum usa `GridView`, como mostrado na próxima seção.

### GridView

Você pode usar o widget `GridView` para transformar
seu `ListView` existente em itens de tamanho mais razoável.

`GridView` é similar ao widget [`ListView`][`ListView`],
mas em vez de lidar apenas com uma lista de widgets organizados linearmente,
`GridView` pode organizar widgets em um array bidimensional.

`GridView` também tem construtores que são similares ao `ListView`.
O construtor padrão do `ListView` mapeia para `GridView.count`,
e `ListView.builder` é similar a `GridView.builder`.

`GridView` tem alguns construtores adicionais para layouts mais customizados.
Para saber mais, visite a página da API [`GridView`][`GridView`].

[`GridView`]: {{site.api}}/flutter/widgets/GridView-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html

Por exemplo, se seu app original usava um `ListView.builder`,
troque por um `GridView.builder`.
Se seu app tem um grande número de itens,
é recomendado usar este construtor builder para apenas
construir os widgets de item que estão realmente visíveis.

A maioria dos parâmetros no construtor são os mesmos entre
os dois widgets, então é uma troca direta.
No entanto, você precisa descobrir o que definir para o `gridDelegate`.

Flutter fornece `gridDelegates` pré-fabricados poderosos
que você pode usar, a saber:

[`SliverGridDelegateWithFixedCrossAxisCount`][`SliverGridDelegateWithFixedCrossAxisCount`]
: Permite que você atribua um número específico de colunas à sua grade.

[`SliverGridDelegateWithMaxCrossAxisExtent`][`SliverGridDelegateWithMaxCrossAxisExtent`]
: Permite que você defina uma largura máxima de item.

[`SliverGridDelegateWithFixedCrossAxisCount`]: {{site.api}}/flutter/rendering/SliverGridDelegateWithFixedCrossAxisCount-class.html
[`SliverGridDelegateWithMaxCrossAxisExtent`]:  {{site.api}}/flutter/rendering/SliverGridDelegateWithMaxCrossAxisExtent-class.html

:::secondary
Não use o grid delegate para essas classes que permitem
definir a contagem de colunas diretamente e então codificar
o número de colunas com base em se o dispositivo
é um tablet, ou qualquer outra coisa.
O número de colunas deve ser baseado no tamanho da
janela e não no tamanho do dispositivo físico.

Esta distinção é importante porque muitos dispositivos
móveis suportam modo de várias janelas, que pode
fazer com que seu app seja renderizado em um espaço menor do que
o tamanho físico da tela. Além disso, apps Flutter
podem rodar na web e desktop, que podem ser dimensionados de muitas maneiras.
**Por esta razão, use `MediaQuery` para obter o tamanho da janela do app
em vez do tamanho do dispositivo físico.**
:::

### Outras soluções

Outra maneira de abordar essas situações é
usar a propriedade `maxWidth` de `BoxConstraints`.
Isso envolve o seguinte:

* Envolva o `GridView` em um `ConstrainedBox` e dê
  a ele um `BoxConstraints` com uma largura máxima definida.
* Use um `Container` em vez de um `ConstrainedBox`
  se você quiser outra funcionalidade como definir a
  cor de fundo.

Para escolher o valor de largura máxima,
considere usar os valores recomendados
pelo Material 3 no guia [Applying layout][Applying layout].

[Applying layout]: https://m3.material.io/foundations/layout/applying-layout/window-size-classes

## Dobráveis

Como mencionado anteriormente, Android e Flutter ambos
recomendam em suas orientações de design **não**
bloquear a orientação da tela,
mas alguns apps bloqueiam a orientação da tela de qualquer maneira.
Esteja ciente de que isso pode causar problemas ao executar seu
app em um dispositivo dobrável.

Quando rodando em um dobrável, o app pode parecer ok
quando o dispositivo está dobrado. Mas ao desdobrar,
você pode encontrar o app em letterbox.

Como descrito na página [SafeArea & MediaQuery][sa-mq],
letterbox significa que a janela do app está bloqueada no
centro da tela enquanto a janela está
cercada por preto.

[sa-mq]: /ui/adaptive-responsive/safearea-mediaquery

Por que isso pode acontecer?

Isso pode acontecer ao usar `MediaQuery` para descobrir
o tamanho da janela para seu app. Quando o dispositivo está dobrado,
a orientação é restrita ao modo retrato.
Por baixo dos panos, `setPreferredOrientations` faz com que
o Android use um modo de compatibilidade retrato e o app
é exibido em um estado de letterbox.
No estado de letterbox, `MediaQuery` nunca recebe
o tamanho de janela maior que permite que a UI se expanda.

Você pode resolver isso de duas maneiras:

* Suporte todas as orientações.
* Use as dimensões da _tela física_.
  Na verdade, esta é uma das _poucas_ situações onde
  você usaria as dimensões da tela física e
  _não_ as dimensões da janela.

Como obter as dimensões da tela física?

Você pode usar a API [`Display`][`Display`], introduzida no
Flutter 3.13, que contém o tamanho,
proporção de pixels, e a taxa de atualização do dispositivo físico.

[`Display`]: {{site.api}}/flutter/dart-ui/Display-class.html

O seguinte código de exemplo recupera um objeto `Display`:

```dart
/// AppState object.
ui.FlutterView? _view;

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  _view = View.maybeOf(context);
}

void didChangeMetrics() {
  final ui.Display? display = _view?.display;
}
```

O importante é encontrar a tela da
visualização que você se importa. Isso cria uma API
com visão de futuro que deve lidar com dispositivos
de múltiplas telas _e_ múltiplas visualizações atuais e futuros.

## Entrada adaptativa

Adicionar suporte para mais telas, também significa
expandir controles de entrada.

As diretrizes do Android descrevem três níveis de suporte a dispositivos de formato grande.

![3 tiers of large format device support](/assets/images/docs/ui/adaptive-responsive/large-screen-guidelines.png){:width="90%"}

O nível 3, o nível mais baixo de suporte,
inclui suporte para entrada de mouse e stylus
([diretrizes Material 3][m3-guide], [diretrizes da Apple][Apple guidelines]).

Se seu app usa Material 3 e seus botões e seletores,
então seu app já tem suporte integrado para
vários estados de entrada adicionais.

Mas e se você tem um widget customizado?
Confira a página [User input][User input] para
orientação sobre adicionar
[suporte de entrada para widgets][input support for widgets].

[Apple guidelines]: https://developer.apple.com/design/human-interface-guidelines/designing-for-ipados#Best-practices
[input support for widgets]: /ui/adaptive-responsive/input#custom-widgets
[m3-guide]: {{site.android-dev}}/docs/quality-guidelines/large-screen-app-quality
[User input]: /ui/adaptive-responsive/input

### Navegação

A navegação pode criar desafios únicos ao trabalhar com uma variedade de
dispositivos de tamanhos diferentes. Geralmente, você quer alternar entre
um [`BottomNavigationBar`][`BottomNavigationBar`] e um [`NavigationRail`][`NavigationRail`] dependendo do
espaço de tela disponível.

Para mais informações (e código de exemplo correspondente),
confira [Problem: Navigation rail][Problem: Navigation rail], uma seção no
artigo [Developing Flutter apps for Large screens][article].

[article]: {{site.flutter-blog}}/developing-flutter-apps-for-large-screens-53b7b0e17f10
[`BottomNavigationBar`]: {{site.api}}/flutter/material/BottomNavigationBar-class.html
[`NavigationRail`]: {{site.api}}/flutter/material/NavigationRail-class.html
[Problem: Navigation rail]: {{site.flutter-blog}}/developing-flutter-apps-for-large-screens-53b7b0e17f10#:~:text=Problem%3A%20Navigation%20rail1
