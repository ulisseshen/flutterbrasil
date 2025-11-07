---
ia-translate: true
title: Adicionando Flutter a qualquer aplicação web
short-title: Adicione Flutter a qualquer web app
description: Aprenda as diferentes formas de incorporar views Flutter em conteúdo web.
---

Views Flutter e conteúdo web podem ser compostos para produzir uma aplicação web
de diferentes formas. Escolha uma das seguintes dependendo do seu caso de uso:

* Uma view Flutter controla a página inteira ([modo de página inteira][full page mode])
* Adicionando views Flutter a uma aplicação web existente ([modo incorporado][embedded mode])

[full page mode]: #full-page-mode
[embedded mode]: #embedded-mode

## Modo de página inteira

No modo de página inteira, a aplicação Flutter web assume o controle de toda a
janela do browser e cobre seu viewport completamente ao renderizar.

Este é o modo de incorporação padrão para novos projetos Flutter web, e nenhuma
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

Quando Flutter web é iniciado sem referenciar `multiViewEnabled` ou um
`hostElement`, ele usa o modo de página inteira.

Para aprender mais sobre o arquivo `flutter_bootstrap.js`,
confira [Personalize a inicialização do app][Customize app initialization].

[Customize app initialization]: {{site.docs}}/platform-integration/web/initialization/

### Incorporação com `iframe`

O modo de página inteira é recomendado ao incorporar uma aplicação Flutter web através de um
`iframe`. A página que incorpora o `iframe` pode dimensioná-lo e posicioná-lo conforme necessário,
e Flutter o preencherá completamente.

```html
<iframe src="https://url-to-your-flutter/index.html"></iframe>
```

Para aprender mais sobre os prós e contras de um `iframe`,
confira a documentação do [Inline Frame element][] no MDN.

[Inline Frame element]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe

## Modo incorporado

Aplicações Flutter web também podem renderizar conteúdo em um número arbitrário de
elementos (comumente `div`s) de outra aplicação web; isso é chamado de "modo
incorporado" (ou "multi-view").

Neste modo:

* Uma aplicação Flutter web pode iniciar, mas não renderiza até a primeira
  "view" ser adicionada, com `addView`.
* A aplicação host pode adicionar ou remover views da aplicação Flutter web
  incorporada.
* A aplicação Flutter é notificada quando views são adicionadas ou removidas,
  para que possa ajustar seus widgets adequadamente.

### Habilite o modo multi-view

Habilite o modo multi-view configurando `multiViewEnabled: true` no
método `initializeEngine` conforme mostrado:

```js highlightLines=8 title="flutter_bootstrap.js"
{% raw %}{{flutter_js}}{% endraw %}
{% raw %}{{flutter_build_config}}{% endraw %}

_flutter.loader.load({
  onEntrypointLoaded: async function onEntrypointLoaded(engineInitializer) {
    let engine = await engineInitializer.initializeEngine({
      multiViewEnabled: true, // Enables embedded mode.
    });
    let app = await engine.runApp();
    // Make this `app` object available to your JS app.
  }
});
```

### Gerencie views Flutter a partir do JS

Para adicionar ou remover views, use o objeto `app` retornado pelo método `runApp`:

```js highlightLines=2-4,7
// Adding a view...
let viewId = app.addView({
  hostElement: document.querySelector('#some-element'),
});

// Removing viewId...
let viewConfig = app.removeView(viewId);
```

### Lidando com mudanças de view no Dart

Adições e remoções de views são apresentadas ao Flutter através do
[método `didChangeMetrics`][`didChangeMetrics` method] da classe `WidgetsBinding`.

A lista completa de views anexadas ao seu app Flutter está disponível
através do iterável `WidgetsBinding.instance.platformDispatcher.views`. Estas
views são do [tipo `FlutterView`][type `FlutterView`].

Para renderizar conteúdo em cada `FlutterView`, seu app Flutter precisa criar um
[widget `View`][`View` widget]. Widgets `View` podem ser agrupados juntos sob um
[widget `ViewCollection`][`ViewCollection` widget].

O exemplo a seguir, do _Multi View Playground_, encapsula
o exposto acima em um widget `MultiViewApp` que pode ser usado como o widget raiz para
seu app. Uma [função `WidgetBuilder`][`WidgetBuilder` function] é executada para cada `FlutterView`:

```dart highlightLines=25,39,46-49,56-61,72 title="multi_view_app.dart"
import 'dart:ui' show FlutterView;
import 'package:flutter/widgets.dart';

/// Calls [viewBuilder] for every view added to the app to obtain the widget to
/// render into that view. The current view can be looked up with [View.of].
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
    // Need to re-evaluate the viewBuilder callback for all views.
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

Para mais informações, confira o [mixin `WidgetsBinding`][`WidgetsBinding` mixin] na documentação da API, ou
o [repositório Multi View Playground][Multi View Playground repo] que foi usado durante o desenvolvimento.

[`didChangeMetrics` method]: {{site.api}}/flutter/widgets/WidgetsBindingObserver/didChangeMetrics.html
[Multi View Playground repo]: {{site.github}}/goderbauer/mvp
[type `FlutterView`]: {{site.api}}/flutter/dart-ui/FlutterView-class.html
[`View` widget]: {{site.api}}/flutter/widgets/View-class.html
[`ViewCollection` widget]: {{site.api}}/flutter/widgets/ViewCollection-class.html
[`WidgetsBinding` mixin]: {{site.api}}/flutter/widgets/WidgetsBinding-mixin.html
[`WidgetBuilder` function]: {{site.api}}/flutter/widgets/WidgetBuilder.html

### Substitua `runApp` por `runWidget` no Dart

A [função `runApp`][`runApp` function] do Flutter assume que há pelo menos uma view disponível
para renderizar (a `implicitView`), no entanto no modo multi-view do Flutter web,
a `implicitView` não existe mais, então `runApp` começará a falhar com
erros `Unexpected null value`.

No modo multi-view, seu `main.dart` deve chamar a [função `runWidget`][`runWidget` function]
em vez disso. Ela não requer uma `implicitView`, e só renderizará nas
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

[`runApp` function]: {{site.api}}/flutter/widgets/runApp.html
[`runWidget` function]: {{site.api}}/flutter/widgets/runWidget.html

### Identificando views

Cada `FlutterView` tem um identificador atribuído pelo Flutter quando
anexada. Este `viewId` pode ser usado para identificar exclusivamente cada view, recuperar
sua configuração inicial, ou decidir o que renderizar nela.

O `viewId` da `FlutterView` renderizada pode ser recuperado de
seu `BuildContext` assim:

```dart highlightLines=4-5
class SomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the `viewId` where this Widget is being built:
    final int viewId = View.of(context).viewId;
    // ...
```

Similarmente, a partir do método `viewBuilder` do `MultiViewApp`, o `viewId`
pode ser recuperado assim:

```dart highlightLines=4
MultiViewApp(
  viewBuilder: (BuildContext context) {
    // Retrieve the `viewId` where this Widget is being built:
    final int viewId = View.of(context).viewId;
    // Decide what to render based on `viewId`...
  },
)
```

Leia mais sobre o [construtor `View.of`][`View.of` constructor].

[`View.of` constructor]: {{site.api}}/flutter/widgets/View/of.html

### Configuração inicial da view

Views Flutter podem receber quaisquer dados de inicialização do JS ao iniciar.
Os valores são passados através da propriedade `initialData` do método `addView`,
conforme mostrado:

```js highlightLines=4-7
// Adding a view with initial data...
let viewId = app.addView({
  hostElement: someElement,
  initialData: {
    greeting: 'Hello, world!',
    randomValue: Math.floor(Math.random() * 100),
  }
});
```

No Dart, os `initialData` estão disponíveis como um objeto `JSAny`, acessível através da
propriedade de nível superior `views` na biblioteca `dart:ui_web`. Os dados são
acessados através do `viewId` da view atual, conforme mostrado:

```dart
final initialData = ui_web.views.getInitialData(viewId) as YourJsInteropType;
```

Para aprender como definir a classe `YourJsInteropType` para mapear o objeto `initialData`
passado do JS para que seja type-safe no seu programa Dart, confira:
[JS Interoperability][] em dart.dev.

[JS Interoperability]: {{site.dart-site}}/interop/js-interop

### Restrições de view

Por padrão, uma view Flutter web incorporada considera o tamanho de seu `hostElement`
como uma propriedade imutável, e restringe rigidamente seu layout ao espaço
disponível.

Na web, é comum que o tamanho intrínseco de um elemento afete o
layout da página (como tags `img` ou `p` que podem refluir conteúdo ao
redor delas).

Ao adicionar uma view ao Flutter web, você pode configurá-la com restrições que
informam ao Flutter como a view precisa ser disposta:

```js highlightLines=4-8
// Adding a view with initial data...
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
do `hostElement` onde o Flutter está sendo incorporado. Por exemplo, Flutter
não tentará "corrigir" constantes contraditórias como passar `max-height: 100px`
no CSS, mas `maxHeight: Infinity` para o Flutter.

Para aprender mais, confira a [classe `ViewConstraints`][`ViewConstraints` class],
e [Entendendo restrições][Understanding constraints].

[`ViewConstraints` class]: {{site.api}}/flutter/dart-ui/ViewConstraints-class.html
[Understanding constraints]: {{site.docs}}/ui/layout/constraints

## Elemento customizado (`hostElement`)

_Entre Flutter 3.10 e 3.24_<br />
Você pode incorporar um app Flutter web de view única em qualquer elemento HTML da sua página
web.

Para informar ao Flutter web em qual elemento renderizar, passe um objeto com um campo `config`
para a função `_flutter.loader.load` que especifica um `HTMLElement` como
o `hostElement`.

```js highlightLines=3
_flutter.loader.load({
  config: {
    hostElement: document.getElementById('flutter_host'),
  }
});
```

Para aprender mais sobre outras opções de configuração,
confira [Personalizando a inicialização do web app][Customizing web app initialization].

[Customizing web app initialization]: {{site.docs}}/platform-integration/web/initialization
