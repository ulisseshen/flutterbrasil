---
ia-translate: true
title: Adicionando Flutter a qualquer aplicação web
short-title: Adicione Flutter a qualquer app web
description: Aprenda as diferentes formas de incorporar views do Flutter em conteúdo web.
---

Views do Flutter e conteúdo web podem ser compostos para produzir uma aplicação
web de diferentes maneiras. Escolha uma das seguintes dependendo do seu caso de uso:

* Uma view do Flutter controla a página inteira ([modo de página inteira][])
* Adicionando views do Flutter a uma aplicação web existente ([modo embutido][])

[modo de página inteira]: #full-page-mode
[modo embutido]: #embedded-mode

## Modo de página inteira

No modo de página inteira, a aplicação web Flutter assume o controle de toda a
janela do navegador e cobre completamente seu viewport ao renderizar.

Este é o modo de incorporação padrão para novos projetos web Flutter, e nenhuma
configuração adicional é necessária.

```html highlightLines=6
<!DOCTYPE html>
<html>
  <head>
  </head>
  <body>
    <script src="flutter_bootstrap.js" defer></script>
  </body>
</html>
```

Quando o Flutter web é iniciado sem referenciar `multiViewEnabled` ou um
`hostElement`, ele usa o modo de página inteira.

Para aprender mais sobre o arquivo `flutter_bootstrap.js`,
confira [Personalizar a inicialização do app][].

[Personalizar a inicialização do app]: {{site.docs}}/platform-integration/web/initialization/

### Incorporação com `iframe`

O modo de página inteira é recomendado ao incorporar uma aplicação web Flutter através de um
`iframe`. A página que incorpora o `iframe` pode dimensioná-lo e posicioná-lo conforme necessário,
e o Flutter o preencherá completamente.

```html
<iframe src="https://url-para-seu-flutter/index.html"></iframe>
```

Para aprender mais sobre os prós e contras de um `iframe`,
confira a documentação do [Elemento Inline Frame][] no MDN.

[Elemento Inline Frame]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe

## Modo Embutido

Aplicações web Flutter também podem renderizar conteúdo em um número arbitrário de
elementos (comumente `div`s) de outra aplicação web; isso é chamado de "modo embutido"
(ou "multi-view").

Neste modo:

* Uma aplicação web Flutter pode ser iniciada, mas não renderiza até que a primeira
  "view" seja adicionada, com `addView`.
* A aplicação hospedeira pode adicionar ou remover views da aplicação web Flutter
  embutida.
* A aplicação Flutter é notificada quando views são adicionadas ou removidas,
  para que possa ajustar seus widgets de acordo.

### Habilitar modo multi-view

Habilite o modo multi-view definindo `multiViewEnabled: true` no
método `initializeEngine` como mostrado:

```js highlightLines=8 title="flutter_bootstrap.js"
{% raw %}{{flutter_js}}{% endraw %}
{% raw %}{{flutter_build_config}}{% endraw %}

_flutter.loader.load({
  onEntrypointLoaded: async function onEntrypointLoaded(engineInitializer) {
    let engine = await engineInitializer.initializeEngine({
      multiViewEnabled: true, // Habilita o modo embutido.
    });
    let app = await engine.runApp();
    // Torne este objeto `app` disponível para seu app JS.
  }
});
```

### Gerenciar views do Flutter a partir de JS

Para adicionar ou remover views, use o objeto `app` retornado pelo método `runApp`:

```js highlightLines=2-4,7
// Adicionando uma view...
let viewId = app.addView({
  hostElement: document.querySelector('#some-element'),
});

// Removendo viewId...
let viewConfig = app.removeView(viewId);
```

### Lidando com mudanças de view a partir do Dart

Adições e remoções de views são apresentadas ao Flutter através do
[`método didChangeMetrics`][] da classe `WidgetsBinding`.

A lista completa de views anexadas ao seu app Flutter está disponível
através do iterável `WidgetsBinding.instance.platformDispatcher.views`. Essas
views são do [tipo `FlutterView`][].

Para renderizar conteúdo em cada `FlutterView`, seu app Flutter precisa criar um
[`Widget View`][]. Widgets `View` podem ser agrupados sob um
[`Widget ViewCollection`][].

O exemplo a seguir, do _Multi View Playground_, encapsula
o acima em um widget `MultiViewApp` que pode ser usado como o widget raiz para
seu app. Uma [`função WidgetBuilder`][] é executada para cada `FlutterView`:

```dart highlightLines=25,39,46-49,56-61,72 title="multi_view_app.dart"
import 'dart:ui' show FlutterView;
import 'package:flutter/widgets.dart';

/// Chama [viewBuilder] para cada view adicionada ao app para obter o widget a
/// ser renderizado naquela view. A view atual pode ser consultada com [View.of].
class MultiViewApp extends StatefulWidget {
  const MultiViewApp({super.key, required this.viewBuilder});

  final WidgetBuilder viewBuilder;

  @override
  State<MultiViewApp> createState() => _MultiViewAppState();
}

class _MultiViewAppState extends State<MultiViewApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateViews();
  }

  @override
  void didUpdateWidget(MultiViewApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Necessário reavaliar o callback viewBuilder para todas as views.
    _views.clear();
    _updateViews();
  }

  @override
  void didChangeMetrics() {
    _updateViews();
  }

  Map<Object, Widget> _views = <Object, Widget>{};

  void _updateViews() {
    final Map<Object, Widget> newViews = <Object, Widget>{};
    for (final FlutterView view in WidgetsBinding.instance.platformDispatcher.views) {
      final Widget viewWidget = _views[view.viewId] ?? _createViewWidget(view);
      newViews[view.viewId] = viewWidget;
    }
    setState(() {
      _views = newViews;
    });
  }

  Widget _createViewWidget(FlutterView view) {
    return View(
      view: view,
      child: Builder(
        builder: widget.viewBuilder,
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewCollection(views: _views.values.toList(growable: false));
  }
}
```

Para mais informações, confira o [`mixin WidgetsBinding`][] na documentação da API, ou
o [repositório Multi View Playground][] que foi usado durante o desenvolvimento.

[`método didChangeMetrics`]: {{site.api}}/flutter/widgets/WidgetsBindingObserver/didChangeMetrics.html
[repositório Multi View Playground]: {{site.github}}/goderbauer/mvp
[tipo `FlutterView`]: {{site.api}}/flutter/dart-ui/FlutterView-class.html
[`Widget View`]: {{site.api}}/flutter/widgets/View-class.html
[`Widget ViewCollection`]: {{site.api}}/flutter/widgets/ViewCollection-class.html
[`mixin WidgetsBinding`]: {{site.api}}/flutter/widgets/WidgetsBinding-mixin.html
[`função WidgetBuilder`]: {{site.api}}/flutter/widgets/WidgetBuilder.html

### Substitua `runApp` por `runWidget` em Dart

A [`função runApp`][] do Flutter assume que há pelo menos uma view disponível
para renderizar (a `implicitView`), no entanto, no modo multi-view do Flutter web,
a `implicitView` não existe mais, então `runApp` começará a falhar com
erros de `Unexpected null value`.

No modo multi-view, seu `main.dart` deve chamar a [`função runWidget`][]
em vez disso. Ela não requer uma `implicitView` e só renderizará nas
views que foram explicitamente adicionadas ao seu app.

O exemplo a seguir usa o `MultiViewApp` descrito acima para renderizar
cópias do widget `MyApp()` em cada `FlutterView` disponível:

```dart highlightLines=3 title="main.dart"
void main() {
  runWidget(
    MultiViewApp(
      viewBuilder: (BuildContext context) => const MyApp(),
    ),
  );
}
```

[`função runApp`]: {{site.api}}/flutter/widgets/runApp.html
[`função runWidget`]: {{site.api}}/flutter/widgets/runWidget.html

### Identificando views

Cada `FlutterView` tem um identificador atribuído pelo Flutter quando
anexada. Este `viewId` pode ser usado para identificar exclusivamente cada view, recuperar
sua configuração inicial ou decidir o que renderizar nela.

O `viewId` da `FlutterView` renderizada pode ser recuperado de
seu `BuildContext` assim:

```dart highlightLines=4-5
class SomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Recupera o `viewId` onde este Widget está sendo construído:
    final int viewId = View.of(context).viewId;
    // ...
```

Da mesma forma, a partir do método `viewBuilder` do `MultiViewApp`, o `viewId`
pode ser recuperado assim:

```dart highlightLines=4
MultiViewApp(
  viewBuilder: (BuildContext context) {
    // Recupera o `viewId` onde este Widget está sendo construído:
    final int viewId = View.of(context).viewId;
    // Decide o que renderizar com base em `viewId`...
  },
)
```

Leia mais sobre o [`construtor View.of`][].

[`construtor View.of`]: {{site.api}}/flutter/widgets/View/of.html

### Configuração inicial da view

Views do Flutter podem receber quaisquer dados de inicialização do JS ao iniciar.
Os valores são passados através da propriedade `initialData` do método `addView`,
como mostrado:

```js highlightLines=4-7
// Adicionando uma view com dados iniciais...
let viewId = app.addView({
  hostElement: someElement,
  initialData: {
    greeting: 'Olá, mundo!',
    randomValue: Math.floor(Math.random() * 100),
  }
});
```

Em Dart, o `initialData` está disponível como um objeto `JSAny`, acessível através
da propriedade de nível superior `views` na biblioteca `dart:ui_web`. Os dados são
acessados através do `viewId` da view atual, como mostrado:

```dart
final initialData = ui_web.views.getInitialData(viewId) as YourJsInteropType;
```

Para aprender como definir a classe `YourJsInteropType` para mapear o objeto
`initialData` passado do JS para que seja type-safe em seu programa Dart, confira:
[Interoperabilidade JS][] em dart.dev.

[Interoperabilidade JS]: {{site.dart-site}}/interop/js-interop

### Restrições de view

Por padrão, uma view web Flutter embutida considera o tamanho de seu `hostElement`
como uma propriedade imutável e restringe rigidamente seu layout ao espaço disponível.

Na web, é comum que o tamanho intrínseco de um elemento afete o
layout da página (como tags `img` ou `p` que podem refluir o conteúdo ao redor
delas).

Ao adicionar uma view ao Flutter web, você pode configurá-la com restrições que
informam o Flutter de como a view precisa ser disposta:

```js highlightLines=4-8
// Adicionando uma view com dados iniciais...
let viewId = app.addView({
  hostElement: someElement,
  viewConstraints: {
    maxWidth: 320,
    minHeight: 0,
    maxHeight: Infinity,
  }
});
```

As restrições de view passadas do JS precisam ser compatíveis com o estilo CSS
do `hostElement` onde o Flutter está sendo incorporado. Por exemplo, o Flutter
não tentará "corrigir" constantes contraditórias como passar `max-height: 100px`
em CSS, mas `maxHeight: Infinity` para o Flutter.

Para saber mais, confira a [`classe ViewConstraints`][],
e [Entendendo restrições][].

[`classe ViewConstraints`]: {{site.api}}/flutter/dart-ui/ViewConstraints-class.html
[Entendendo restrições]: {{site.docs}}/ui/layout/constraints

## Elemento customizado (`hostElement`)

_Entre Flutter 3.10 e 3.24_<br />
Você pode incorporar um app web Flutter de view única em qualquer elemento HTML da sua página web.

Para informar ao Flutter web em qual elemento renderizar, passe um objeto com um campo `config`
para a função `_flutter.loader.load` que especifica um `HTMLElement` como o `hostElement`.

```js highlightLines=3
_flutter.loader.load({
  config: {
    hostElement: document.getElementById('flutter_host'),
  }
});
```

Para saber mais sobre outras opções de configuração,
confira [Personalizando a inicialização do app web][].

[Personalizando a inicialização do app web]: {{site.docs}}/platform-integration/web/initialization
