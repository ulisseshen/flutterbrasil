---
ia-translate: true
title: Dispositivos de tela grande
description: >-
  O que ter em mente ao adaptar aplicativos
  para telas grandes.
short-title: Telas grandes
---

<?code-excerpt path-base="ui/adaptive_app_demos"?>

Esta página fornece orientação sobre como otimizar seu
aplicativo para melhorar seu comportamento em telas grandes.

O Flutter, assim como o Android, define [telas grandes][] como tablets,
dispositivos dobráveis e dispositivos ChromeOS executando Android. O Flutter
_também_ define dispositivos de tela grande como web, desktop e
iPads.

:::secondary Por que telas grandes importam, em particular?
A demanda por telas grandes continua a aumentar.
Em janeiro de 2024,
mais de [270 milhões de dispositivos ativos de tela grande][large screens]
e dobráveis executam no Android e mais de
[14,9 milhões de usuários de iPad][].

Quando seu aplicativo suporta telas grandes,
ele também recebe outros benefícios.
Otimizar seu aplicativo para preencher a tela.
Por exemplo, ele:

* Melhora as métricas de engajamento do usuário do seu aplicativo.
* Aumenta a visibilidade do seu aplicativo na Play Store.
  [Atualizações recentes da Play Store][] mostram avaliações por
  tipo de dispositivo e indica quando um aplicativo não tem
  suporte para tela grande.
* Garante que seu aplicativo atenda às diretrizes de envio
  do iPadOS e seja [aceito na App Store][].
:::

[14,9 milhões de usuários de iPad]: https://www.statista.com/statistics/299632/tablet-shipments-apple/
[aceito na App Store]: https://developer.apple.com/ipados/submit/
[large screens]: {{site.android-dev}}/guide/topics/large-screens/get-started-with-large-screens
[Atualizações recentes da Play Store]: {{site.android-dev}}/2022/03/helping-users-discover-quality-apps-on.html

## Layout com GridView

Considere as seguintes capturas de tela de um aplicativo.
O aplicativo exibe sua interface do usuário em uma `ListView`.
A imagem à esquerda mostra o aplicativo em execução
em um dispositivo móvel. A imagem à direita mostra o
aplicativo em execução em um dispositivo de tela grande
_antes que as orientações desta página fossem aplicadas_.

![Exemplo de tela grande](/assets/images/docs/ui/adaptive-responsive/large-screen.png){:width="90%"}

Isso não é ideal.

As [Diretrizes de Qualidade de Aplicativos para Telas Grandes do Android][guidelines]
e o [equivalente do iOS][]
dizem que nem texto nem caixas devem ocupar toda a
largura da tela. Como resolver isso de forma adaptativa?

[guidelines]: https://developer.android.com/docs/quality-guidelines/large-screen-app-quality
[equivalente do iOS]: https://developer.apple.com/design/human-interface-guidelines/designing-for-ipados

Uma solução comum usa `GridView`, como mostrado na próxima seção.

### GridView

Você pode usar o widget `GridView` para transformar
sua `ListView` existente em itens de tamanho mais razoável.

`GridView` é semelhante ao widget [`ListView`][],
mas em vez de lidar apenas com uma lista de widgets organizados linearmente,
`GridView` pode organizar widgets em um array bidimensional.

`GridView` também possui construtores semelhantes a `ListView`.
O construtor padrão `ListView` mapeia para `GridView.count`,
e `ListView.builder` é semelhante a `GridView.builder`.

`GridView` possui alguns construtores adicionais para layouts mais personalizados.
Para saber mais, visite a página da API [`GridView`][].

[`GridView`]: {{site.api}}/flutter/widgets/GridView-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html

Por exemplo, se seu aplicativo original usava um `ListView.builder`,
troque-o por um `GridView.builder`.
Se seu aplicativo tiver um grande número de itens,
é recomendável usar este construtor builder para apenas
construir os widgets de item que estão realmente visíveis.

A maioria dos parâmetros no construtor são os mesmos entre
os dois widgets, então é uma troca direta.
No entanto, você precisa descobrir o que definir para o `gridDelegate`.

O Flutter fornece `gridDelegates` poderosos pré-fabricados
que você pode usar, a saber:

[`SliverGridDelegateWith<b>FixedCrossAxisCount</b>`][]
: Permite atribuir um número específico de colunas à sua grade.

[`SliverGridDelegateWith<b>MaxCrossAxisExtent</b>`][]
: Permite definir uma largura máxima do item.

[`SliverGridDelegateWith<b>FixedCrossAxisCount</b>`]: {{site.api}}/flutter/rendering/SliverGridDelegateWithFixedCrossAxisCount-class.html
[`SliverGridDelegateWith<b>MaxCrossAxisExtent</b>`]: {{site.api}}/flutter/rendering/SliverGridDelegateWithMaxCrossAxisExtent-class.html

:::secondary
Não use o grid delegate para essas classes que permitem
definir a contagem de colunas diretamente e, em seguida, codificar
o número de colunas com base em se o dispositivo
é um tablet, ou o que for.
O número de colunas deve ser baseado no tamanho
da janela e não no tamanho do dispositivo físico.

Essa distinção é importante porque muitos dispositivos móveis
suportam o modo multi-janela, o que pode
fazer com que seu aplicativo seja renderizado em um espaço menor do que
o tamanho físico da tela. Além disso, os aplicativos Flutter
podem ser executados na web e no desktop, que podem ter muitos tamanhos.
**Por esse motivo, use `MediaQuery` para obter o tamanho da janela do aplicativo
em vez do tamanho físico do dispositivo.**
:::

### Outras soluções

Outra forma de abordar essas situações é usar
a propriedade `maxWidth` de `BoxConstraints`.
Isso envolve o seguinte:

* Envolva o `GridView` em um `ConstrainedBox` e dê
  a ele um `BoxConstraints` com uma largura máxima definida.
* Use um `Container` em vez de um `ConstrainedBox`
  se você quiser outras funcionalidades como definir a
  cor de fundo.

Para escolher o valor da largura máxima,
considere usar os valores recomendados
pelo Material 3 no guia [Aplicando layout][].

[Aplicando layout]: https://m3.material.io/foundations/layout/applying-layout/window-size-classes

## Dispositivos dobráveis

Como mencionado anteriormente, o Android e o Flutter ambos
recomendam em suas orientações de design **não**
travar a orientação da tela,
mas alguns aplicativos travam a orientação da tela de qualquer maneira.
Esteja ciente de que isso pode causar problemas ao executar seu
aplicativo em um dispositivo dobrável.

Ao executar em um dispositivo dobrável, o aplicativo pode parecer ok
quando o dispositivo está dobrado. Mas ao desdobrar,
você pode encontrar o aplicativo com letterboxing.

Como descrito na página [SafeArea & MediaQuery][sa-mq],
letterboxing significa que a janela do aplicativo está travada no
centro da tela enquanto a janela está
cercada de preto.

[sa-mq]: /ui/adaptive-responsive/safearea-mediaquery

Por que isso pode acontecer?

Isso pode acontecer ao usar `MediaQuery` para descobrir
o tamanho da janela do seu aplicativo. Quando o dispositivo está dobrado,
a orientação é restrita ao modo retrato.
Por baixo dos panos, `setPreferredOrientations` faz com que
o Android use um modo de compatibilidade retrato e o aplicativo
é exibido em um estado de letterboxing.
No estado de letterboxing, `MediaQuery` nunca recebe
o tamanho de janela maior que permite que a interface do usuário se expanda.

Você pode resolver isso de uma das duas maneiras:

* Suporte todas as orientações.
* Use as dimensões do _display físico_.
  Na verdade, esta é uma das _poucas_ situações em que
  você usaria as dimensões físicas do display e
  _não_ as dimensões da janela.

Como obter as dimensões físicas da tela?

Você pode usar a API [`Display`][], introduzida em
Flutter 3.13, que contém o tamanho,
a proporção de pixels e a taxa de atualização do dispositivo físico.

[`Display`]: {{site.api}}/flutter/dart-ui/Display-class.html

O código de amostra a seguir recupera um objeto `Display`:

```dart
/// Objeto AppState.
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
que deve lidar com dispositivos multi-display _e_ multi-view atuais _e_ futuros.

## Entrada adaptativa

Adicionar suporte para mais telas também significa
expandir os controles de entrada.

As diretrizes do Android descrevem três níveis de suporte a dispositivos de grande formato.

![3 níveis de suporte a dispositivos de grande formato](/assets/images/docs/ui/adaptive-responsive/large-screen-guidelines.png){:width="90%"}

O Nível 3, o nível mais baixo de suporte,
inclui suporte para entrada de mouse e caneta
([diretrizes do Material 3][m3-guide], [diretrizes da Apple][]).

Se seu aplicativo usa Material 3 e seus botões e seletores,
então seu aplicativo já possui suporte integrado para
vários estados de entrada adicionais.

Mas e se você tiver um widget personalizado?
Confira a página [Entrada do usuário][] para
orientação sobre como adicionar
[suporte de entrada para widgets][].

[diretrizes da Apple]: https://developer.apple.com/design/human-interface-guidelines/designing-for-ipados#Best-practices
[suporte de entrada para widgets]: /ui/adaptive-responsive/input#custom-widgets
[m3-guide]: {{site.android-dev}}/docs/quality-guidelines/large-screen-app-quality
[Entrada do usuário]: /ui/adaptive-responsive/input

### Navegação

A navegação pode criar desafios únicos ao trabalhar com uma variedade de
dispositivos de tamanhos diferentes. Geralmente, você deseja alternar entre
um [`BottomNavigationBar`][] e um [`NavigationRail`] dependendo do
espaço de tela disponível.

Para obter mais informações (e o código de exemplo correspondente),
confira [Problema: Barra de navegação][], uma seção no
artigo [Desenvolvendo aplicativos Flutter para telas grandes][article].

[article]: {{site.flutter-medium}}/developing-flutter-apps-for-large-screens-53b7b0e17f10
[`BottomNavigationBar`]: {{site.api}}/flutter/material/BottomNavigationBar-class.html
[`NavigationRail`]: {{site.api}}/flutter/material/NavigationRail-class.html
[Problema: Barra de navegação]: {{site.flutter-medium}}/developing-flutter-apps-for-large-screens-53b7b0e17f10#:~:text=Problema%3A%20Navigation%20rail1
