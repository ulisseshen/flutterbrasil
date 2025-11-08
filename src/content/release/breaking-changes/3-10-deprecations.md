---
title: API depreciada removida após v3.10
description: >
  Após atingir o fim da vida útil, as seguintes APIs depreciadas
  foram removidas do Flutter.
ia-translate: true
---

## Resumo

De acordo com a [Política de Depreciação][Deprecation Policy] do Flutter,
APIs depreciadas que atingiram o fim da vida útil após a
3.10 versão estável foram removidas.

Todas as APIs afetadas foram compiladas nesta
fonte primária para auxiliar na migração. A
[folha de referência rápida][quick reference sheet] também está disponível.

[Deprecation Policy]: {{site.repo.flutter}}/blob/main/docs/contributing/Tree-hygiene.md#deprecations
[quick reference sheet]: /go/deprecations-removed-after-3-10

## Mudanças

This section lists the deprecations, listed by the package and affected class.

### ThemeData.fixTextFieldOutlineLabel

Package: flutter
Suportado pelo Flutter Fix: sim

`ThemeData.fixTextFieldOutlineLabel` foi depreciado na v2.5.
References to this property can be removed.

The `fixTextFieldOutlineLabel` was a temporary migration flag that allowed users
to gracefully migrate to a new behavior rather than experiencing a hard break.
Before deprecating, this property was transitioned to the new default from the
fix to the label for text fields.

**Guia de migração**

Código antes da migração:

```dart
var themeData = ThemeData(
  fixTextFieldOutlineLabel: true,  
);
```

Código após a migração:

```dart
var themeData = ThemeData(
);
```

**Referências**

Documentação da API:

* [`ThemeData`][]

PRs relevantes:

* Depreciado em [#87281][]
* Removido em [#125893][]

[`ThemeData`]: {{site.api}}/flutter/material/ThemeData-class.html

[#87281]: {{site.repo.flutter}}/pull/87281
[#125893]: {{site.repo.flutter}}/pull/125893

---

### OverscrollIndicatorNotification.disallowGlow

Package: flutter
Suportado pelo Flutter Fix: sim

`OverscrollIndicatorNotification.disallowGlow` foi depreciado na v2.5.
The replacement is the `disallowIndicator` method.

The `disallowIndicator` was created as a replacement for the original method
with the introduction of the `StretchingOverscrollIndicator`. Previously,
the `GlowingOverscrollIndicator` was the only kind to dispatch
`OverscrollIndicatorNotification`s, and so the method was updated to better
reflect multiple kinds of indicators.

**Guia de migração**

Código antes da migração:

```dart
bool _handleOverscrollIndicatorNotification(OverscrollIndicatorNotification notification) {
  notification.disallowGlow();
  return false;
}
```

Código após a migração:

```dart
bool _handleOverscrollIndicatorNotification(OverscrollIndicatorNotification notification) {
  notification.disallowIndicator();
  return false;
}
```

**Referências**

Documentação da API:

* [`OverscrollIndicatorNotification`][]
* [`StretchingOverscrollIndicator`][]
* [`GlowingOverscrollIndicator`][]

PRs relevantes:

* Depreciado em [#87839][]
* Removido em [#127042][]

[`OverscrollIndicatorNotification`]: {{site.api}}/flutter/widgets/OverscrollIndicatorNotification-class.html
[`StretchingOverscrollIndicator`]: {{site.api}}/flutter/widgets/StretchingOverscrollIndicator-class.html
[`GlowingOverscrollIndicator`]: {{site.api}}/flutter/widgets/GlowingOverscrollIndicator-class.html

[#87839]: {{site.repo.flutter}}/pull/87839
[#127042]: {{site.repo.flutter}}/pull/127042

---

### ColorScheme primaryVariant & secondaryVariant

Package: flutter
Suportado pelo Flutter Fix: sim

`ColorScheme.primaryVariant` and `ColorScheme.secondaryVariant` were deprecated
in v2.6. The replacements are the `ColorScheme.primaryContainer` and
`ColorScheme.secondaryContainer`, respectively.

These changes were made to align with the updated Material Design specification
for `ColorScheme`. The updates to `ColorScheme` are covered more extensively in 
the [ColorScheme for Material 3][] design document.

**Guia de migração**

Código antes da migração:

```dart
var colorScheme = ColorScheme(
  primaryVariant: Colors.blue,
  secondaryVariant: Colors.amber,
);
var primaryColor = colorScheme.primaryVariant;
var secondaryColor = colorScheme.secondaryVariant;
```

Código após a migração:

```dart
var colorScheme = ColorScheme(
  primaryContainer: Colors.blue,
  secondaryContainer: Colors.amber,
);
var primaryColor = colorScheme.primaryContainer;
var secondaryColor = colorScheme.secondaryContainer;
```

**Referências**

Design Document:

* [ColorScheme for Material 3][]

Documentação da API:

* [`ColorScheme`][]

PRs relevantes:

* Depreciado em [#93427][]
* Removido em [#127124][]

[ColorScheme for Material 3]: /go/colorscheme-m3

[`ColorScheme`]: {{site.api}}/flutter/material/ColorScheme-class.html

[#93427]: {{site.repo.flutter}}/pull/93427
[#127124]: {{site.repo.flutter}}/pull/127124

---

### ThemeData.primaryColorBrightness

Package: flutter
Suportado pelo Flutter Fix: sim

`ThemeData.primaryColorBrightness` foi depreciado na v2.6, and has not been used
by the framework since then. References should be removed. The `Brightness` is
now extrapolated from the `ThemeData.primaryColor` if `ThemeData.brightness` has
not been explicitly provided.

This change was made as part of the update to `Theme` to match new Material
Design guidelines. The overall update to the theming system, including the
removal of `primaryColorBrightness` is discussed more extensively in the
[Material Theme System Updates][] design document.

**Guia de migração**

Código antes da migração:

```dart
var themeData = ThemeData(
  primaryColorBrightness: Brightness.dark,
);
```

Código após a migração:

```dart
var themeData = ThemeData(
);
```

**Referências**

Design Document:

* [Material Theme System Updates][]

Documentação da API:

* [`Theme`][]
* [`ThemeData`][]
* [`Brightness`][]

PRs relevantes:

* Depreciado em [#93396][]
* Removido em [#127238][]

[Material Theme System Updates]: /go/material-theme-system-updates

[`Theme`]: {{site.api}}/flutter/material/Theme-class.html
[`ThemeData`]: {{site.api}}/flutter/material/Theme-class.html
[`Brightness`]: {{site.api}}/flutter/dart-ui/Brightness.html

[#93396]: {{site.repo.flutter}}/pull/93396
[#127238]: {{site.repo.flutter}}/pull/127238

---

### RawScrollbar & subclasses updates

Package: flutter
Suportado pelo Flutter Fix: sim

The `isAlwaysShown` property of `RawScrollbar`, `Scrollbar`,
`ScrollbarThemeData` and `CupertinoScrollbar` foi depreciado na v2.9. The
replacement in all cases is `thumbVisibility`.

This change was made since `isAlwaysShown` always referred to the scrollbar
thumb. With the addition of a scrollbar track, and varying configurations for
its visibility in response to mouse hovering and dragging, we renamed this
property for a clearer API.

Additionally, `Scrollbar.hoverThickness` was also deprecated in v2.9. Its
replacement is the `MaterialStateProperty` `ScrollbarThemeData.thickness`.

This change was made to allow the thickness of a `Scrollbar` to respond to all
kind of states, including and beyond just hovering. The use of
`MaterialStateProperties` also matches the convention in the material library of
configuring widgets based on their state, rather than enumerating properties for
every permutation of interactive states.

**Guia de migração**

Código antes da migração:

```dart
var rawScrollbar = RawScrollbar(
  isAlwaysShown: true,
);
var scrollbar = Scrollbar(
  isAlwaysShown: true,
  hoverThickness: 15.0,
);
var cupertinoScrollbar = CupertinoScrollbar(
  isAlwaysShown: true,
);
var scrollbarThemeData = ScrollbarThemeData(
  isAlwaysShown: true,
);
```

Código após a migração:

```dart
var rawScrollbar = RawScrollbar(
  thumbVisibility: true,
);
var scrollbar = Scrollbar(
  thumbVisibility: true,
);
var cupertinoScrollbar = CupertinoScrollbar(
  thumbVisibility: true,
);
var scrollbarThemeData = ScrollbarThemeData(
  thumbVisibility: true,
  thickness: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
    return states.contains(MaterialState.hovered) ? null : 15.0;
  }),
);
```

**Referências**

Documentação da API:

* [`RawScrollbar`][]
* [`Scrollbar`][]
* [`CupertinoScrollbar`][]
* [`ScrollbarThemeData`][]
* [`MaterialStateProperty`][]
* [`MaterialState`][]

PRs relevantes:

* Depreciado em [#96957][]
* Depreciado em [#97173][]
* Removido em [#127351][]


[`RawScrollbar`]: {{site.api}}/flutter/widgets/RawScrollbar-class.html
[`Scrollbar`]: {{site.api}}/flutter/material/Scrollbar-class.html
[`CupertinoScrollbar`]: {{site.api}}/flutter/cupertino/CupertinoScrollbar-class.html
[`ScrollbarThemeData`]: {{site.api}}/flutter/material/ScrollbarThemeData-class.html
[`MaterialStateProperty`]: {{site.api}}/flutter/material/MaterialStateProperty-class.html
[`MaterialState`]: {{site.api}}/flutter/material/MaterialState.html

[#96957]: {{site.repo.flutter}}/pull/96957
[#97173]: {{site.repo.flutter}}/pull/97173
[#127351]: {{site.repo.flutter}}/pull/127351

---

### AnimationSheetBuilder display & sheetSize

Package: flutter_test
Suportado pelo Flutter Fix: sim

The `display` and `sheetSize` methods of `AnimationSheetBuilder` were deprecated
in v2.3. The replacement is the `collate` method.

`AnimationSheetBuilder`'s output step previously required these two methods to
be called, but is now streamlined through a single call to `collate`.

The `collate` function directly puts the images together and asynchronously
returns an image. It requires less boilerplate, and outputs smaller images
without any compromise to quality.

**Guia de migração**

[Guia de migração detalhado disponível]

Código antes da migração:

```dart
final AnimationSheetBuilder animationSheet = AnimationSheetBuilder(
    frameSize: const Size(40, 40)
);

await tester.pumpFrames(animationSheet.record(
  const Directionality(
    textDirection: TextDirection.ltr,
    child: Padding(
      padding: EdgeInsets.all(4),
      child: CircularProgressIndicator(),
    ),
  ),
), const Duration(seconds: 2));

tester.binding.setSurfaceSize(animationSheet.sheetSize());

final Widget display = await animationSheet.display();
await tester.pumpWidget(display);

await expectLater(
  find.byWidget(display),
  matchesGoldenFile('material.circular_progress_indicator.indeterminate.png'),
);
```

Código após a migração:

```dart
final AnimationSheetBuilder animationSheet = AnimationSheetBuilder(
    frameSize: const Size(40, 40)
);

await tester.pumpFrames(animationSheet.record(
  const Directionality(
    textDirection: TextDirection.ltr,
    child: Padding(
      padding: EdgeInsets.all(4),
      child: CircularProgressIndicator(),
    ),
  ),
), const Duration(seconds: 2));

await expectLater(
  animationSheet.collate(20),
  matchesGoldenFile('material.circular_progress_indicator.indeterminate.png'),
);
```

[Guia de migração detalhado disponível]: /release/breaking-changes/animation-sheet-builder-display

**Referências**

Documentação da API:

* [`AnimationSheetBuilder`][]

PRs relevantes:

* Depreciado em [#83337][]
* Removido em [#129657][]

[`AnimationSheetBuilder`]: {{site.api}}/flutter/flutter_test/AnimationSheetBuilder-class.html

[#83337]: {{site.repo.flutter}}/pull/83337
[#129657]: {{site.repo.flutter}}/pull/129657

---

---

### flutter_test timeout logic

Package: flutter_test
Suportado pelo Flutter Fix: não

The following APIs related to timeout logic in tests were deprecated
in v2.6. There are no replacements, and references should be removed, except for
the `initialTimeout` parameter of `testWidgets`, which is replaced by using
`timeout`.

* `TestWidgetsFlutterBinding.addTime`
* `TestWidgetsFlutterBinding.runAsync` method - `additionalTime` parameter
* `TestWidgetsFlutterBinding.runTest` method - `timeout` parameter
* `AutomatedTestWidgetsFlutterBinding.runTest` method - `timeout` parameter
* `LiveTestWidgetsFlutterBinding.runTest` method - `timeout` parameter
* `testWidgets` method - `initialTime` parameter

These were found to cause flakiness in testing, and were not in use by tested
customers.

Since being deprecated, use of these parameters have had no effect on tests, so
removing references should have no effect on existing code bases.

**Guia de migração**


Código antes da migração:

```dart
testWidgets('Test', (_) {}, initialTimeout:  Duration(seconds: 5));
```

Código após a migração:

```dart
testWidgets('Test', (_) {}, timeout:  Timeout(Duration(seconds: 5)));
```

**Referências**

Documentação da API:

* [`testWidgets`][]
* [`TestWidgetsFlutterBinding`][]
* [`AutomatedTestWidgetsFlutterBinding`][]
* [`LiveTestWidgetsFlutterBinding`][]

PRs relevantes:

* Depreciado em [#89952][]
* Removido em [#129663][]

[`testWidgets`]: {{site.api}}/flutter/flutter_test/testWidgets.html
[`TestWidgetsFlutterBinding`]: {{site.api}}/flutter/flutter_test/TestWidgetsFlutterBinding-class.html
[`AutomatedTestWidgetsFlutterBinding`]: {{site.api}}/flutter/flutter_test/AutomatedTestWidgetsFlutterBinding-class.html
[`LiveTestWidgetsFlutterBinding`]: {{site.api}}/flutter/flutter_test/LiveTestWidgetsFlutterBinding-class.html

[#89952]: {{site.repo.flutter}}/pull/89952
[#129663]: {{site.repo.flutter}}/pull/129663

---

## Linha do tempo

Na versão estável: 3.13.0
