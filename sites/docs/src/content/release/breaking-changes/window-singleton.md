---
title: O singleton window está obsoleto
description: >
  Em preparação para o suporte a múltiplas views e
  múltiplas janelas, o singleton window foi tornado obsoleto.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Em preparação para o suporte a múltiplas views e múltiplas janelas, o singleton
`window` foi tornado obsoleto. O código que antes dependia do singleton `window`
precisa buscar a view específica com a qual quer trabalhar, por meio da API
`View.of`, ou interagir diretamente com o `PlatformDispatcher`.

## Contexto {:#context}

Originalmente, o Flutter presumia que um aplicativo consistiria em uma única
view (a `window`) na qual o conteúdo pode ser desenhado. Em um mundo com
múltiplas views, essa premissa não faz mais sentido, e as APIs que
a codificavam foram tornadas obsoletas. Em vez disso, aplicativos e bibliotecas
que dependiam dessas APIs precisam escolher a view específica
com a qual querem trabalhar e migrar para as novas APIs compatíveis
com múltiplas views, conforme descrito neste guia de migração.

## Descrição da mudança {:#description-of-the-change}

As APIs que foram obsoletas como parte desta mudança são:

* A propriedade global `window` exposta por `dart:ui`.
* A propriedade `window` da classe `BaseBinding`, que normalmente é acessada via
  * `GestureBinding.instance.window`,
  * `SchedulerBinding.instance.window`,
  * `ServicesBinding.instance.window`,
  * `PaintingBinding.instance.window`,
  * `SemanticsBinding.instance.window`,
  * `RendererBinding.instance.window`,
  * `WidgetsBinding.instance.window`, ou
  * `WidgetTester.binding.window`.
* A classe `SingletonFlutterView` de `dart:ui`.
* `TestWindow` de `flutter_test`, seus construtores
  e todas as suas propriedades e métodos.

As opções a seguir existem para migrar o código de aplicativos e bibliotecas que
dependem dessas APIs obsoletas:

Se um `BuildContext` estiver disponível, considere buscar o `FlutterView` atual
via `View.of`. Isso retorna o `FlutterView` no qual
os widgets construídos pelo método `build` associado ao contexto dado
serão desenhados. O `FlutterView` oferece acesso à mesma funcionalidade
que antes estava disponível na classe obsoleta `SingletonFlutterView`,
retornada pelas propriedades `window` obsoletas mencionadas acima. No entanto, parte da
funcionalidade específica de plataforma foi movida para o `PlatformDispatcher`,
que pode ser acessado a partir do `FlutterView` retornado por `View.of` via
`FlutterView.platformDispatcher`. Usar `View.of` é a forma preferida de
migrar para longe das propriedades obsoletas mencionadas acima.

Se nenhum `BuildContext` estiver disponível para buscar um `FlutterView`, o
`PlatformDispatcher` pode ser consultado diretamente para acessar a
funcionalidade específica de plataforma. Ele também mantém uma lista de todos os
`FlutterView`s disponíveis em `PlatformDispatcher.views`, para acessar a
funcionalidade específica de cada view. Se possível, o
`PlatformDispatcher` deve ser acessado por meio de um binding (por exemplo,
`WidgetsBinding.instance.platformDispatcher`), em vez de usar a propriedade
estática `PlatformDispatcher.instance`. Isso garante que a funcionalidade
do `PlatformDispatcher` possa ser devidamente mockada nos testes.

### Testes {:#testing}

Para testes que acessavam a propriedade `WidgetTester.binding.window` para
alterar propriedades da janela durante os testes, as seguintes migrações estão disponíveis:

Em testes escritos com `testWidgets`, foram adicionadas duas novas propriedades que,
em conjunto, substituem a funcionalidade de `TestWindow`.

* `WidgetTester.view` fornece um `TestFlutterView` que pode ser modificado
  de forma semelhante a `WidgetTester.binding.window`, mas com apenas propriedades
  específicas da view, como o tamanho da view, sua razão de pixels da tela etc.
  * `WidgetTester.viewOf` está disponível para certos casos de uso com múltiplas views, mas
      não deve ser necessário para nenhuma migração a partir de
      `WidgetTester.binding.window`.
* `WidgetTester.platformDispatcher` fornece acesso a um
  `TestPlatformDispatcher` que pode ser usado para modificar propriedades
  específicas de plataforma, como o locale da plataforma, se certos recursos
  do sistema estão disponíveis etc.

## Guia de migração {:#migration-guide}

Em vez de acessar a propriedade estática `window`, o código de aplicativos e bibliotecas
que tem acesso a um `BuildContext` deve usar `View.of` para buscar o
`FlutterView` ao qual o contexto está associado. Algumas propriedades foram movidas para
o `PlatformDispatcher`, acessível a partir da view via o getter
`platformDispatcher`.

Código antes da migração:

```dart
Widget build(BuildContext context) {
  final double dpr = WidgetsBinding.instance.window.devicePixelRatio;
  final Locale locale = WidgetsBinding.instance.window.locale;
  return Text('The device pixel ratio is $dpr and the locale is $locale.');
}
```

Código após a migração:

```dart
Widget build(BuildContext context) {
  final double dpr = View.of(context).devicePixelRatio;
  final Locale locale = View.of(context).platformDispatcher.locale;
  return Text('The device pixel ratio is $dpr and the locale is $locale.');
}
```

Se nenhum `BuildContext` estiver disponível, o `PlatformDispatcher` exposto pelos
bindings pode ser consultado diretamente.

Código antes da migração:

```dart
double getTextScaleFactor() {
  return WidgetsBinding.instance.window.textScaleFactor;
}
```

Código após a migração:

```dart
double getTextScaleFactor() {
  // View.of(context).platformDispatcher.textScaleFactor if a BuildContext is available, otherwise:
  return WidgetsBinding.instance.platformDispatcher.textScaleFactor;
}
```

### Testes {:#testing-migration}

Em testes escritos com `testWidget`, use as novas propriedades `view` e
`platformDispatcher`.

#### Definindo propriedades específicas da view {:#setting-view-specific-properties}

`TestFlutterView` também buscou tornar a API de testes mais clara e concisa, usando
setters com o mesmo nome do getter relacionado, em vez de setters com o
sufixo `TestValue`.

Código antes da migração:

```dart
testWidget('test name', (WidgetTester tester) async {
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
testWidget('test name', (WidgetTester tester) async {
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

#### Redefinindo propriedades específicas da view {:#resetting-view-specific-properties}

`TestFlutterView` mantém a capacidade de redefinir propriedades individuais ou a
view inteira, mas, para ficar mais claro e consistente, os nomes desses
métodos mudaram de `clear<property>TestValue` e `clearAllTestValues` para
`reset<property>` e `reset`, respectivamente.

##### Redefinindo propriedades individuais {:#resetting-individual-properties}

Código antes da migração:

```dart
testWidget('test name', (WidgetTester tester) async {
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
testWidget('test name', (WidgetTester tester) async {
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

##### Redefinindo todas as propriedades de uma vez {:#resetting-all-properties-at-once}

Código antes da migração:

```dart
testWidget('test name', (WidgetTester tester) async {
  addTearDown(tester.binding.window.clearAllTestValues);
});
```

Código após a migração:

```dart
testWidget('test name', (WidgetTester tester) async {
  addTearDown(tester.view.reset);
});
```

#### Definindo propriedades específicas da plataforma {:#setting-platform-specific-properties}

`TestPlatformDispatcher` mantém a mesma funcionalidade e o mesmo esquema de nomes
para os setters de teste que `TestWindow`, então a migração das propriedades
específicas de plataforma consiste principalmente em chamar os mesmos setters no novo
acessor `WidgetTester.platformDispatcher`.

Código antes da migração:

```dart
testWidgets('test name', (WidgetTester tester) async {
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
testWidgets('test name', (WidgetTester tester) async {
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

#### Redefinindo propriedades específicas da plataforma {:#resetting-platform-specific-properties}

Assim como na definição de propriedades, redefinir propriedades específicas de plataforma consiste
principalmente em trocar o acessor `binding.window` pelo
acessor `platformDispatcher`.

##### Redefinindo propriedades individuais {:#resetting-individual-platform-properties}

Código antes da migração:

```dart
testWidgets('test name', (WidgetTester tester) async {
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
testWidgets('test name', (WidgetTester tester) async {
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

##### Redefinindo todas as propriedades de uma vez {:#resetting-all-platform-properties-at-once}

Código antes da migração:

```dart
testWidgets('test name', (WidgetTester tester) async {
  addTeardown(tester.binding.window.clearAllTestValues);
});
```

Código após a migração:

```dart
testWidgets('test name', (WidgetTester tester) async {
  addTeardown(tester.platformDispatcher.clearAllTestValues);
});
```

## Linha do tempo {:#timeline}

Incluído na versão: 3.9.0-13.0.pre.20<br>
Na versão estável: 3.10.0

## Referências {:#references}

Documentação da API:

* [`View.of`][]
* [`FlutterView`][]
* [`PlatformDispatcher`][]
* [`TestPlatformDispatcher`][]
* [`TestFlutterView`][]
* [`TestWidgetsFlutterBinding.window`][]

Issues relevantes:

* [Issue 116929][]
* [Issue 117481][]
* [Issue 121915][]

PRs relevantes:

* [Deprecate SingletonFlutterWindow and global window singleton][]
* [Deprecate BindingBase.window][]
* [Deprecates `TestWindow`][]


[`View.of`]: {{site.api}}/flutter/widgets/View/of.html
[`FlutterView`]: {{site.api}}/flutter/dart-ui/FlutterView-class.html
[`PlatformDispatcher`]: {{site.api}}/flutter/dart-ui/PlatformDispatcher-class.html
[`TestPlatformDispatcher`]: {{site.api}}/flutter/flutter_test/TestPlatformDispatcher-class.html
[`TestFlutterView`]: {{site.api}}/flutter/flutter_test/TestFlutterView-class.html
[`TestWidgetsFlutterBinding.window`]: {{site.api}}/flutter/flutter_test/TestWidgetsFlutterBinding/window.html
[Issue 116929]: {{site.repo.flutter}}/issues/116929
[Issue 117481]: {{site.repo.flutter}}/issues/117481
[Issue 121915]: {{site.repo.flutter}}/issues/121915
[Deprecate SingletonFlutterWindow and global window singleton]: {{site.repo.engine}}/pull/39302
[Deprecate BindingBase.window]: {{site.repo.flutter}}/pull/120998
[Deprecates `TestWindow`]: {{site.repo.flutter}}/pull/122824
