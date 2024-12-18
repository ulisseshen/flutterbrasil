---
ia-translate: true
title: O singleton window está obsoleto
description: >
  Em preparação para o suporte a múltiplas visualizações e
  múltiplas janelas, o singleton window foi descontinuado.
---

## Resumo

Em preparação para o suporte a múltiplas visualizações e múltiplas janelas, o
singleton `window` foi descontinuado. O código que antes dependia do singleton
`window` precisa procurar a visualização específica na qual deseja operar por
meio da API `View.of` ou interagir diretamente com o `PlatformDispatcher`.

## Contexto

Originalmente, o Flutter assumia que um aplicativo consistiria apenas em uma
única visualização (a `window`) na qual o conteúdo poderia ser desenhado. Em um
mundo multi-visualização, essa suposição não faz mais sentido e as APIs que
codificam essa suposição foram descontinuadas. Em vez disso, aplicativos e
bibliotecas que dependiam dessas APIs devem escolher uma visualização específica
na qual desejam operar e migrar para novas APIs compatíveis com multi-visualização,
conforme descrito neste guia de migração.

## Descrição da alteração

As APIs que foram descontinuadas como parte desta alteração são:

* A propriedade global `window` exposta por `dart:ui`.
* A propriedade `window` na classe `BaseBinding`, que geralmente é acessada via
  * `GestureBinding.instance.window`,
  * `SchedulerBinding.instance.window`,
  * `ServicesBinding.instance.window`,
  * `PaintingBinding.instance.window`,
  * `SemanticsBinding.instance.window`,
  * `RendererBinding.instance.window`,
  * `WidgetsBinding.instance.window`, ou
  * `WidgetTester.binding.window`.
* A classe `SingletonFlutterView` de `dart:ui`.
* `TestWindow` de `flutter_test`, seus construtores e todas as suas
  propriedades e métodos.

As seguintes opções existem para migrar o código de aplicativos e bibliotecas
que dependem dessas APIs descontinuadas:

Se um `BuildContext` estiver disponível, considere procurar o `FlutterView`
atual via `View.of`. Isso retorna o `FlutterView` no qual os widgets construídos
pelo método `build` associado ao contexto fornecido serão desenhados. O
`FlutterView` fornece acesso à mesma funcionalidade que antes estava disponível
na classe `SingletonFlutterView` descontinuada retornada pelas propriedades
`window` descontinuadas mencionadas acima. No entanto, algumas das
funcionalidades específicas da plataforma foram movidas para o
`PlatformDispatcher`, que pode ser acessado a partir do `FlutterView`
retornado por `View.of` via `FlutterView.platformDispatcher`. O uso de `View.of`
é a maneira preferida de migrar das propriedades descontinuadas mencionadas
acima.

Se nenhum `BuildContext` estiver disponível para procurar um `FlutterView`, o
`PlatformDispatcher` pode ser consultado diretamente para acessar a
funcionalidade específica da plataforma. Ele também mantém uma lista de todos os
`FlutterView`s disponíveis em `PlatformDispatcher.views` para acessar a
funcionalidade específica da visualização. Se possível, o `PlatformDispatcher`
deve ser acessado por meio de um binding (por exemplo,
`WidgetsBinding.instance.platformDispatcher`) em vez de usar a propriedade
estática `PlatformDispatcher.instance`. Isso garante que a funcionalidade do
`PlatformDispatcher` possa ser devidamente simulada em testes.

### Testando

Para testes que acessavam a propriedade `WidgetTester.binding.window` para
alterar as propriedades da janela para testes, as seguintes migrações estão
disponíveis:

Em testes escritos com `testWidgets`, duas novas propriedades foram adicionadas
que, juntas, substituem a funcionalidade de `TestWindow`.

* `WidgetTester.view` fornecerá um `TestFlutterView` que pode ser modificado
  de forma semelhante a `WidgetTester.binding.window`, mas com apenas
  propriedades específicas da visualização, como o tamanho de uma visualização,
  sua proporção de pixel de exibição, etc.
  * `WidgetTester.viewOf` está disponível para certos casos de uso de
    multi-visualização, mas não deve ser necessário para nenhuma migração de
    `WidgetTester.binding.window`.
* `WidgetTester.platformDispatcher` fornecerá acesso a um
  `TestPlatformDispatcher` que pode ser usado para modificar propriedades
  específicas da plataforma, como a localidade da plataforma, se determinados
  recursos do sistema estão disponíveis, etc.

## Guia de migração

Em vez de acessar a propriedade estática `window`, o código do aplicativo e da
biblioteca que tem acesso a um `BuildContext` deve usar `View.of` para procurar
o `FlutterView` ao qual o contexto está associado. Algumas propriedades foram
movidas para o `PlatformDispatcher` acessível a partir da visualização por meio
do getter `platformDispatcher`.

Código antes da migração:

```dart
Widget build(BuildContext context) {
  final double dpr = WidgetsBinding.instance.window.devicePixelRatio;
  final Locale locale = WidgetsBinding.instance.window.locale;
  return Text('A proporção de pixel do dispositivo é $dpr e a localidade é $locale.');
}
```

Código após a migração:

```dart
Widget build(BuildContext context) {
  final double dpr = View.of(context).devicePixelRatio;
  final Locale locale = View.of(context).platformDispatcher.locale;
  return Text('A proporção de pixel do dispositivo é $dpr e a localidade é $locale.');
}
```

Se nenhum `BuildContext` estiver disponível, o `PlatformDispatcher` exposto
pelos bindings pode ser consultado diretamente.

Código antes da migração:

```dart
double getTextScaleFactor() {
  return WidgetsBinding.instance.window.textScaleFactor;
}
```

Código após a migração:

```dart
double getTextScaleFactor() {
  // View.of(context).platformDispatcher.textScaleFactor se um BuildContext estiver disponível, caso contrário:
  return WidgetsBinding.instance.platformDispatcher.textScaleFactor;
}
```

### Testando

Em testes escritos com `testWidget`, os novos acessadores `view` e
`platformDispatcher` devem ser usados em vez disso.

#### Definindo propriedades específicas da visualização

`TestFlutterView` também fez um esforço para tornar a API de teste mais clara e
concisa usando setters com o mesmo nome que seu getter relacionado, em vez de
setters com o sufixo `TestValue`.

Código antes da migração:

```dart
testWidget('nome do teste', (WidgetTester tester) async {
  tester.binding.window.devicePixelRatioTestValue = 2.0;
  tester.binding.window.displayFeaturesTestValue = <DisplayFeatures>[];
  tester.binding.window.gestureSettingsTestValue = const GestureSettings(physicalTouchSlop: 100);
  tester.binding.window.paddingTestValue = FakeViewPadding.zero;
  tester.binding.window.physicalGeometryTestValue = const Rect.fromLTRB(0,0, 500, 800);
  tester.binding.window.physicalSizeTestValue = const Size(300, 400);
  tester.binding.window.systemGestureInsetsTestValue = FakeViewPadding.zero;
  tester.binding.window.viewInsetsTestValue = FakeViewPadding.zero;
  tester.binding.window.viewPaddingTestValue = FakeViewPadding.zero;
});
```

Código após a migração:

```dart
testWidget('nome do teste', (WidgetTester tester) async {
  tester.view.devicePixelRatio = 2.0;
  tester.view.displayFeatures = <DisplayFeatures>[];
  tester.view.gestureSettings = const GestureSettings(physicalTouchSlop: 100);
  tester.view.padding = FakeViewPadding.zero;
  tester.view.physicalGeometry = const Rect.fromLTRB(0,0, 500, 800);
  tester.view.physicalSize = const Size(300, 400);
  tester.view.systemGestureInsets = FakeViewPadding.zero;
  tester.view.viewInsets = FakeViewPadding.zero;
  tester.view.viewPadding = FakeViewPadding.zero;
});
```

#### Redefinindo propriedades específicas da visualização

`TestFlutterView` mantém a capacidade de redefinir propriedades individuais ou
toda a visualização, mas, para ser mais claro e consistente, a nomenclatura
desses métodos foi alterada de `clear<property>TestValue` e `clearAllTestValues`
para `reset<property>` e `reset`, respectivamente.

##### Redefinindo propriedades individuais

Código antes da migração:

```dart
testWidget('nome do teste', (WidgetTester tester) async {
  addTearDown(tester.binding.window.clearDevicePixelRatioTestValue);
  addTearDown(tester.binding.window.clearDisplayFeaturesTestValue);
  addTearDown(tester.binding.window.clearGestureSettingsTestValue);
  addTearDown(tester.binding.window.clearPaddingTestValue);
  addTearDown(tester.binding.window.clearPhysicalGeometryTestValue);
  addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  addTearDown(tester.binding.window.clearSystemGestureInsetsTestValue);
  addTearDown(tester.binding.window.clearViewInsetsTestValue);
  addTearDown(tester.binding.window.clearViewPaddingTestValue);
});
```

Código após a migração:

```dart
testWidget('nome do teste', (WidgetTester tester) async {
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetDisplayFeatures);
  addTearDown(tester.view.resetGestureSettings);
  addTearDown(tester.view.resetPadding);
  addTearDown(tester.view.resetPhysicalGeometry);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetSystemGestureInsets);
  addTearDown(tester.view.resetViewInsets);
  addTearDown(tester.view.resetViewPadding);
});
```

##### Redefinindo todas as propriedades de uma vez

Código antes da migração:

```dart
testWidget('nome do teste', (WidgetTester tester) async {
  addTearDown(tester.binding.window.clearAllTestValues);
});
```

Código após a migração:

```dart
testWidget('nome do teste', (WidgetTester tester) async {
  addTearDown(tester.view.reset);
});
```

#### Definindo propriedades específicas da plataforma

`TestPlatformDispatcher` mantém a mesma funcionalidade e esquema de nomenclatura
para setters de teste que `TestWindow`, portanto, a migração de propriedades
específicas da plataforma consiste principalmente em chamar os mesmos setters no
novo acessador `WidgetTester.platformDispatcher`.

Código antes da migração:

```dart
testWidgets('nome do teste', (WidgetTester tester) async {
  tester.binding.window.accessibilityFeaturesTestValue = FakeAccessibilityFeatures.allOn;
  tester.binding.window.alwaysUse24HourFormatTestValue = false;
  tester.binding.window.brieflyShowPasswordTestValue = true;
  tester.binding.window.defaultRouteNameTestValue = '/test';
  tester.binding.window.initialLifecycleStateTestValue = 'painting';
  tester.binding.window.localesTestValue = <Locale>[const Locale('en-us'), const Locale('ar-jo')];
  tester.binding.window.localeTestValue = const Locale('ar-jo');
  tester.binding.window.nativeSpellCheckServiceDefinedTestValue = false;
  tester.binding.window.platformBrightnessTestValue = Brightness.dark;
  tester.binding.window.semanticsEnabledTestValue = true;
  tester.binding.window.textScaleFactorTestValue = 2.0;
});
```

Código após a migração:

```dart
testWidgets('nome do teste', (WidgetTester tester) async {
  tester.platformDispatcher.accessibilityFeaturesTestValue = FakeAccessibilityFeatures.allOn;
  tester.platformDispatcher.alwaysUse24HourFormatTestValue = false;
  tester.platformDispatcher.brieflyShowPasswordTestValue = true;
  tester.platformDispatcher.defaultRouteNameTestValue = '/test';
  tester.platformDispatcher.initialLifecycleStateTestValue = 'painting';
  tester.platformDispatcher.localesTestValue = <Locale>[const Locale('en-us'), const Locale('ar-jo')];
  tester.platformDispatcher.localeTestValue = const Locale('ar-jo');
  tester.platformDispatcher.nativeSpellCheckServiceDefinedTestValue = false;
  tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
  tester.platformDispatcher.semanticsEnabledTestValue = true;
  tester.platformDispatcher.textScaleFactorTestValue = 2.0;
});
```

#### Redefinindo propriedades específicas da plataforma

De forma semelhante à definição de propriedades, a redefinição de propriedades
específicas da plataforma consiste principalmente em alterar o acessador
`binding.window` para o acessador `platformDispatcher`.

##### Redefinindo propriedades individuais

Código antes da migração:

```dart
testWidgets('nome do teste', (WidgetTester tester) async {
  addTeardown(tester.binding.window.clearAccessibilityFeaturesTestValue);
  addTeardown(tester.binding.window.clearAlwaysUse24HourFormatTestValue);
  addTeardown(tester.binding.window.clearBrieflyShowPasswordTestValue);
  addTeardown(tester.binding.window.clearDefaultRouteNameTestValue);
  addTeardown(tester.binding.window.clearInitialLifecycleStateTestValue);
  addTeardown(tester.binding.window.clearLocalesTestValue);
  addTeardown(tester.binding.window.clearLocaleTestValue);
  addTeardown(tester.binding.window.clearNativeSpellCheckServiceDefinedTestValue);
  addTeardown(tester.binding.window.clearPlatformBrightnessTestValue);
  addTeardown(tester.binding.window.clearSemanticsEnabledTestValue);
  addTeardown(tester.binding.window.clearTextScaleFactorTestValue);
});
```

Código após a migração:

```dart
testWidgets('nome do teste', (WidgetTester tester) async {
  addTeardown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
  addTeardown(tester.platformDispatcher.clearAlwaysUse24HourFormatTestValue);
  addTeardown(tester.platformDispatcher.clearBrieflyShowPasswordTestValue);
  addTeardown(tester.platformDispatcher.clearDefaultRouteNameTestValue);
  addTeardown(tester.platformDispatcher.clearInitialLifecycleStateTestValue);
  addTeardown(tester.platformDispatcher.clearLocalesTestValue);
  addTeardown(tester.platformDispatcher.clearLocaleTestValue);
  addTeardown(tester.platformDispatcher.clearNativeSpellCheckServiceDefinedTestValue);
  addTeardown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
  addTeardown(tester.platformDispatcher.clearSemanticsEnabledTestValue);
  addTeardown(tester.platformDispatcher.clearTextScaleFactorTestValue);
});
```

##### Redefinindo todas as propriedades de uma vez

Código antes da migração:

```dart
testWidgets('nome do teste', (WidgetTester tester) async {
  addTeardown(tester.binding.window.clearAllTestValues);
});
```

Código após a migração:

```dart
testWidgets('nome do teste', (WidgetTester tester) async {
  addTeardown(tester.platformDispatcher.clearAllTestValues);
});
```

## Linha do tempo

Implementado na versão: 3.9.0-13.0.pre.20<br>
Na versão estável: 3.10.0

## Referências

Documentação da API:

* [`View.of`][]
* [`FlutterView`][]
* [`PlatformDispatcher`][]
* [`TestPlatformDispatcher`][]
* [`TestFlutterView`][]
* [`TestWidgetsFlutterBinding.window`][]

Problemas relevantes:

* [Issue 116929][]
* [Issue 117481][]
* [Issue 121915][]

PRs relevantes:

* [Descontinuar SingletonFlutterWindow e o singleton window global][]
* [Descontinuar BindingBase.window][]
* [Descontinua `TestWindow`][]

[`View.of`]: {{site.api}}/flutter/widgets/View/of.html
[`FlutterView`]: {{site.api}}/flutter/dart-ui/FlutterView-class.html
[`PlatformDispatcher`]: {{site.api}}/flutter/dart-ui/PlatformDispatcher-class.html
[`TestPlatformDispatcher`]: {{site.api}}/flutter/flutter_test/TestPlatformDispatcher-class.html
[`TestFlutterView`]: {{site.api}}/flutter/flutter_test/TestFlutterView-class.html
[`TestWidgetsFlutterBinding.window`]: {{site.api}}/flutter/flutter_test/TestWidgetsFlutterBinding/window.html
[Issue 116929]: {{site.repo.flutter}}/issues/116929
[Issue 117481]: {{site.repo.flutter}}/issues/117481
[Issue 121915]: {{site.repo.flutter}}/issues/121915
[Descontinuar SingletonFlutterWindow e o singleton window global]: {{site.repo.engine}}/pull/39302
[Descontinuar BindingBase.window]: {{site.repo.flutter}}/pull/120998
[Descontinua `TestWindow`]: {{site.repo.flutter}}/pull/122824
