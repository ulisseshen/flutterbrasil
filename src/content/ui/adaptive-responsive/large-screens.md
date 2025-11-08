---
title: Dispositivos de tela grande
description: >-
  Coisas a ter em mente ao adaptar aplicativos
  para telas grandes.
short-title: Telas grandes
ia-translate: true
---

<?code-excerpt path-base="ui/adaptive_app_demos"?>

Esta página fornece orientações sobre como otimizar seu
aplicativo para melhorar seu comportamento em telas grandes.

O Flutter, assim como o Android, define [telas grandes][large screens] como tablets,
dobráveis e dispositivos ChromeOS executando Android. O Flutter
_também_ define dispositivos de tela grande como web, desktop
e iPads.

:::secondary Por que as telas grandes são importantes, em particular?
A demanda por telas grandes continua aumentando.
A partir de janeiro de 2024,
mais de [270 milhões de dispositivos ativos de tela grande][large screens]
e dobráveis executam Android e mais de
[14,9 milhões de usuários de iPad][14.9 million iPad users].

Quando seu aplicativo suporta telas grandes,
ele também recebe outros benefícios.
Otimizar seu aplicativo para preencher a tela.
Por exemplo:

* Melhora as métricas de engajamento do usuário do seu aplicativo.
* Aumenta a visibilidade do seu aplicativo na Play Store.
  As [atualizações recentes da Play Store][Play Store updates] mostram avaliações por
  tipo de dispositivo e indica quando um aplicativo não possui
  suporte para tela grande.
* Garante que seu aplicativo atenda às diretrizes de submissão do iPadOS
  e seja [aceito na App Store][accepted in the App Store].
:::

[14.9 million iPad users]: https://www.statista.com/statistics/299632/tablet-shipments-apple/
[accepted in the App Store]: https://developer.apple.com/ipados/submit/
[large screens]: {{site.android-dev}}/guide/topics/large-screens/get-started-with-large-screens
[Play Store updates]: {{site.android-dev}}/2022/03/helping-users-discover-quality-apps-on.html

<a id="layout-with-gridview"></a>
## Layout com GridView

Considere as seguintes capturas de tela de um aplicativo.
O aplicativo exibe sua UI em um `ListView`.
A imagem à esquerda mostra o aplicativo sendo executado
em um dispositivo móvel. A imagem à direita mostra o
aplicativo sendo executado em um dispositivo de tela grande
_antes das orientações desta página serem aplicadas_.

![Sample of large screen](/assets/images/docs/ui/adaptive-responsive/large-screen.png){:width="90%"}

Isso não é ideal.

As [Diretrizes de Qualidade de Aplicativos para Telas Grandes do Android][guidelines]
e o [equivalente para iOS][iOS equivalent]
dizem que nem o texto nem as caixas devem ocupar toda a
largura da tela. Como resolver isso de forma adaptativa?

[guidelines]: https://developer.android.com/docs/quality-guidelines/large-screen-app-quality
[iOS equivalent]: https://developer.apple.com/design/human-interface-guidelines/designing-for-ipados

Uma solução comum usa `GridView`, conforme mostrado na próxima seção.

### GridView

Você pode usar o widget `GridView` para transformar
seu `ListView` existente em itens de tamanho mais razoável.

`GridView` é semelhante ao widget [`ListView`][], mas em vez
de lidar apenas com uma lista de widgets organizados linearmente,
`GridView` pode organizar widgets em um array bidimensional.

`GridView` também tem construtores semelhantes ao `ListView`.
O construtor padrão do `ListView` mapeia para `GridView.count`,
e `ListView.builder` é semelhante ao `GridView.builder`.

`GridView` tem alguns construtores adicionais para layouts mais personalizados.
Para saber mais, visite a página da API [`GridView`][].

[`GridView`]: {{site.api}}/flutter/widgets/GridView-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html

Por exemplo, se seu aplicativo original usava um `ListView.builder`,
substitua-o por um `GridView.builder`.
Se seu aplicativo tiver um grande número de itens,
é recomendado usar este construtor builder para construir apenas
os widgets de item que estão realmente visíveis.

A maioria dos parâmetros no construtor são os mesmos entre
os dois widgets, então é uma troca direta.
No entanto, você precisa descobrir o que definir para o `gridDelegate`.

O Flutter fornece `gridDelegates` pré-fabricados poderosos
que você pode usar, especificamente:

[`SliverGridDelegateWith<b>FixedCrossAxisCount</b>`][]
: Permite que você atribua um número específico de colunas à sua grade.

[`SliverGridDelegateWith<b>MaxCrossAxisExtent</b>`][]
: Permite que você defina uma largura máxima do item.

[`SliverGridDelegateWith<b>FixedCrossAxisCount</b>`]: {{site.api}}/flutter/rendering/SliverGridDelegateWithFixedCrossAxisCount-class.html
[`SliverGridDelegateWith<b>MaxCrossAxisExtent</b>`]:  {{site.api}}/flutter/rendering/SliverGridDelegateWithMaxCrossAxisExtent-class.html

:::secondary
Não use o grid delegate para essas classes que permite
definir a contagem de colunas diretamente e depois codificar
o número de colunas com base em se o dispositivo
é um tablet ou qualquer outra coisa.
O número de colunas deve ser baseado no tamanho da
janela e não no tamanho do dispositivo físico.

Esta distinção é importante porque muitos dispositivos móveis
suportam o modo multi-janela, que pode
fazer com que seu aplicativo seja renderizado em um espaço menor que
o tamanho físico da tela. Além disso, aplicativos Flutter
podem ser executados na web e no desktop, que podem ser dimensionados de várias maneiras.
**Por esse motivo, use `MediaQuery` para obter o tamanho da janela do aplicativo
em vez do tamanho do dispositivo físico.**
:::

### Outras soluções

Outra maneira de abordar essas situações é
usar a propriedade `maxWidth` de `BoxConstraints`.
Isso envolve o seguinte:

* Envolver o `GridView` em um `ConstrainedBox` e dar
  a ele um `BoxConstraints` com uma largura máxima definida.
* Use um `Container` em vez de um `ConstrainedBox`
  se você quiser outras funcionalidades como definir a
  cor de fundo.

Para escolher o valor da largura máxima,
considere usar os valores recomendados
pelo Material 3 no guia [Applying layout][].

[Applying layout]: https://m3.material.io/foundations/layout/applying-layout/window-size-classes

## Dobráveis

Conforme mencionado anteriormente, tanto o Android quanto o Flutter
recomendam em suas orientações de design **não**
bloquear a orientação da tela,
mas alguns aplicativos bloqueiam a orientação da tela de qualquer forma.
Esteja ciente de que isso pode causar problemas ao executar seu
aplicativo em um dispositivo dobrável.

Ao executar em um dobrável, o aplicativo pode parecer ok
quando o dispositivo está dobrado. Mas ao desdobrar,
você pode encontrar o aplicativo em letterbox.

Conforme descrito na página [SafeArea & MediaQuery][sa-mq],
letterbox significa que a janela do aplicativo está bloqueada no
centro da tela enquanto a janela está
cercada de preto.

[sa-mq]: /ui/adaptive-responsive/safearea-mediaquery

Por que isso pode acontecer?

Isso pode acontecer ao usar `MediaQuery` para descobrir
o tamanho da janela para seu aplicativo. Quando o dispositivo está dobrado,
a orientação é restrita ao modo retrato.
Por baixo dos panos, `setPreferredOrientations` faz com que
o Android use um modo de compatibilidade retrato e o aplicativo
seja exibido em um estado letterboxed.
No estado letterboxed, `MediaQuery` nunca recebe
o tamanho de janela maior que permite que a UI se expanda.

Você pode resolver isso de duas maneiras:

* Suportar todas as orientações.
* Usar as dimensões da _tela física_.
  Na verdade, esta é uma das _poucas_ situações em que
  você usaria as dimensões da tela física e
  _não_ as dimensões da janela.

Como obter as dimensões da tela física?

Você pode usar a API [`Display`][], introduzida no
Flutter 3.13, que contém o tamanho,
taxa de pixels e a taxa de atualização do dispositivo físico.

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

O importante é encontrar o display da
view que você se importa. Isso cria uma API voltada para o futuro
que deve lidar com dispositivos multi-display
e multi-view atuais _e_ futuros.

## Entrada adaptativa

Adicionar suporte para mais telas também significa
expandir os controles de entrada.

As diretrizes do Android descrevem três níveis de suporte a dispositivos de formato grande.

![3 tiers of large format device support](/assets/images/docs/ui/adaptive-responsive/large-screen-guidelines.png){:width="90%"}

O nível 3, o nível mais baixo de suporte,
inclui suporte para entrada de mouse e stylus
([diretrizes Material 3][m3-guide], [diretrizes Apple][Apple guidelines]).

Se seu aplicativo usa Material 3 e seus botões e seletores,
então seu aplicativo já tem suporte integrado para
vários estados de entrada adicionais.

Mas e se você tiver um widget personalizado?
Confira a página [Entrada do usuário][User input] para
orientações sobre como adicionar
[suporte de entrada para widgets][input support for widgets].

[Apple guidelines]: https://developer.apple.com/design/human-interface-guidelines/designing-for-ipados#Best-practices
[input support for widgets]: /ui/adaptive-responsive/input#custom-widgets
[m3-guide]: {{site.android-dev}}/docs/quality-guidelines/large-screen-app-quality
[User input]: /ui/adaptive-responsive/input

### Navegação

A navegação pode criar desafios únicos ao trabalhar com uma variedade de
dispositivos de tamanhos diferentes. Geralmente, você deseja alternar entre
um [`BottomNavigationBar`][] e um [`NavigationRail`] dependendo do
espaço disponível na tela.

Para mais informações (e código de exemplo correspondente),
confira [Problema: Navigation rail][Problem: Navigation rail], uma seção no
artigo [Desenvolvendo aplicativos Flutter para telas grandes][article].

[article]: {{site.flutter-medium}}/developing-flutter-apps-for-large-screens-53b7b0e17f10
[`BottomNavigationBar`]: {{site.api}}/flutter/material/BottomNavigationBar-class.html
[`NavigationRail`]: {{site.api}}/flutter/material/NavigationRail-class.html
[Problem: Navigation rail]: {{site.flutter-medium}}/developing-flutter-apps-for-large-screens-53b7b0e17f10#:~:text=Problem%3A%20Navigation%20rail1
