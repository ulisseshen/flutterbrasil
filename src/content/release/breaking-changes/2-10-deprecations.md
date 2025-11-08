---
title: API depreciada removida após v2.10
description: >
  Após atingir o fim da vida útil, as seguintes APIs depreciadas
  foram removidas do Flutter.
ia-translate: true
---

## Resumo

De acordo com a [Política de Depreciação][Deprecation Policy] do Flutter,
APIs depreciadas que atingiram o fim da vida útil após a
versão estável 2.10 foram removidas.

Todas as APIs afetadas foram compiladas nesta
fonte primária para auxiliar na migração. Uma
[folha de referência rápida][quick reference sheet] também está disponível.


[Deprecation Policy]: {{site.repo.flutter}}/blob/main/docs/contributing/Tree-hygiene.md#deprecations
[quick reference sheet]: /go/deprecations-removed-after-2-10

## Mudanças

Esta seção lista as depreciações por classe afetada.

---

### `maxLengthEnforced` of `TextField` & related classes

Suportado pelo Flutter Fix: sim

`maxLengthEnforced` was deprecated in v1.25.

Use `maxLengthEnforcement` instead.
Where `maxLengthEnforced` was true, replace with `MaxLengthEnforcement.enforce`.
Where `maxLengthEnforced` was false, replace with `MaxLengthEnforcement.none`.
This change allows more behaviors to be specified beyond the original binary
choice, adding `MaxLengthEnforcement.truncateAfterCompositionEnds` as an
additional option.

The following classes all have the same change of API:

- `TextField`
- `TextFormField`
- `CupertinoTextField`

**Guia de migração**

[Guia de migração detalhado disponível][]

Código antes da migração:

```dart
const TextField textField = TextField(maxLengthEnforced: true);
const TextField textField = TextField(maxLengthEnforced: false);
final lengthEnforced = textField.maxLengthEnforced;

const TextFormField textFormField = TextFormField(maxLengthEnforced: true);
const TextFormField textFormField = TextFormField(maxLengthEnforced: false);
final lengthEnforced = textFormField.maxLengthEnforced;

const CupertinoTextField cupertinoTextField = CupertinoTextField(maxLengthEnforced: true);
const CupertinoTextField cupertinoTextField = CupertinoTextField(maxLengthEnforced: false);
final lengthEnforced = cupertinoTextField.maxLengthEnforced;
```

Código após a migração:

```dart
const TextField textField = TextField(maxLengthEnforcement: MaxLengthEnforcement.enforce);
const TextField textField = TextField(maxLengthEnforcement: MaxLengthEnforcement.none);
final lengthEnforced = textField.maxLengthEnforcement;

const TextFormField textFormField = TextFormField(maxLengthEnforcement: MaxLengthEnforcement.enforce);
const TextFormField textFormField = TextFormField(maxLengthEnforcement: MaxLengthEnforcement.none);
final lengthEnforced = textFormField.maxLengthEnforcement;

const CupertinoTextField cupertinoTextField = CupertinoTextField(maxLengthEnforcement: MaxLengthEnforcement.enforce);
const CupertinoTextField cupertinoTextField = CupertinoTextField(maxLengthEnforcement: MaxLengthEnforcement.none);
final lengthEnforced = cupertinoTextField.maxLengthEnforcement;
```

**Referências**

Documentação da API:

* [`TextField`][]
* [`TextFormField`][]
* [`CupertinoTextField`][]

Issues relevantes:

* [Issue 67898]({{site.repo.flutter}}/issues/67898)

PRs relevantes:

* Depreciado em [#68086]({{site.repo.flutter}}/pull/68086)
* Removido em [#98539]({{site.repo.flutter}}/pull/98539)

[Guia de migração detalhado disponível]: /release/breaking-changes/use-maxLengthEnforcement-instead-of-maxLengthEnforced
[`TextField`]: {{site.api}}/flutter/material/TextField-class.html
[`TextFormField`]: {{site.api}}/flutter/material/TextFormField-class.html
[`CupertinoTextField`]: {{site.api}}/flutter/cupertino/CupertinoTextField-class.html

---

### `VelocityTracker` constructor

Suportado pelo Flutter Fix: sim

The default constructor for `VelocityTracker`was deprecated in v1.22.

The `VelocityTracker.withKind()` should be used instead. This allows for a
`PointerDeviceKind` to be specified for the tracker. The previous default for
`VelocityTracker.kind` was `PointerDeviceKind.touch`.

**Guia de migração**

Código antes da migração:

```dart
final VelocityTracker tracker = VelocityTracker();
```

Código após a migração:

```dart
final VelocityTracker tracker = VelocityTracker.withKind(PointerDeviceKind.touch);
```

**Referências**

Documentação da API:

* [`VelocityTracker`][]
* [`PointerDeviceKind`][]

PRs relevantes:

* Depreciado em [#66043]({{site.repo.flutter}}/pull/66043)
* Removido em [#98541]({{site.repo.flutter}}/pull/98541)

[`VelocityTracker`]: {{site.api}}/flutter/gestures/VelocityTracker-class.html
[`PointerDeviceKind`]: {{site.api}}/flutter/dart-ui/PointerDeviceKind.html

---

### `DayPicker` & `MonthPicker`

Suportado pelo Flutter Fix: não

The `DayPicker` and `MonthPicker` widgets were first deprecated in v1.15, and
then extended in v1.26.

They have been replaced by one comprehensive widget, `CalendarDatePicker`.

These widgets were displayed using the `showDatePicker` method. This method was
migrated to present the new `CalendarDatePicker` before this release, and so
their final removal should not necessitate further action.

**Referências**

Documento de design:

* [Material Date Picker Redesign][]

Documentação da API:

* [`CalendarDatePicker`][]
* [`showDatePicker`][]

Issues relevantes:

* [Issue 50133]({{site.repo.flutter}}/issues/50133)

PRs relevantes:

* Depreciado em [#50546]({{site.repo.flutter}}/issues/50546)
* Removido em [#98543]({{site.repo.flutter}}/issues/98543)

[Material Date Picker Redesign]: /go/material-date-picker-redesign
[`CalendarDatePicker`]: {{site.api}}/flutter/material/CalendarDatePicker-class.html
[`showDatePicker`]: {{site.api}}/flutter/material/showDatePicker.html

---

### `FlatButton`, `RaisedButton`, & `OutlineButton`

Suportado pelo Flutter Fix: não

The `FlatButton`, `RaisedButton`, and `OutlineButton` widgets were first
deprecated in v1.20, and then extended in v1.26.

They are replaced by new buttons, `TextButton`, `ElevatedButton`, and
`OutlinedButton`. These new widgets also use new associated themes, rather than
the generic `ButtonTheme`.

| Old Widget      | Old Theme     | New Widget       | New Theme             |
|-----------------|---------------|------------------|-----------------------|
| `FlatButton`    | `ButtonTheme` | `TextButton`     | `TextButtonTheme`     |
| `RaisedButton`  | `ButtonTheme` | `ElevatedButton` | `ElevatedButtonTheme` |
| `OutlineButton` | `ButtonTheme` | `OutlinedButton` | `OutlinedButtonTheme` |

{:.table .table-striped .nowrap}

**Guia de migração**

[Guia de migração detalhado disponível for detailed styling][]

Código antes da migração:

```dart
FlatButton(
  onPressed: onPressed,
  child: Text('Button'),
  // ...
);

RaisedButton(
  onPressed: onPressed,
  child: Text('Button'),
  // ...
);

OutlineButton(
  onPressed: onPressed,
  child: Text('Button'),
  // ...
);
```

Código após a migração:

```dart
TextButton(
  onPressed: onPressed,
  child: Text('Button'),
  // ...
);

ElevatedButton(
  onPressed: onPressed,
  child: Text('Button'),
  // ...
);

OutlinedButton(
  onPressed: onPressed,
  child: Text('Button'),
  // ...
);
```

**Referências**

Documento de design:

* [New Material buttons and themes][]

Documentação da API:

* [`ButtonStyle`][]
* [`ButtonStyleButton`][]
* [`ElevatedButton`][]
* [`ElevatedButtonTheme`][]
* [`ElevatedButtonThemeData`][]
* [`OutlinedButton`][]
* [`OutlinedButtonTheme`][]
* [`OutlinedButtonThemeData`][]
* [`TextButton`][]
* [`TextButtonTheme`][]
* [`TextButtonThemeData`][]

PRs relevantes:

* Nova API adicionada em [#59702]({{site.repo.flutter}}/issues/59702)
* Depreciado em [#73352]({{site.repo.flutter}}/issues/73352)
* Removido em [#98546]({{site.repo.flutter}}/issues/98546)

[Guia de migração detalhado disponível for detailed styling]: /release/breaking-changes/buttons
[New Material buttons and themes]: /go/material-button-migration-guide
[`ButtonStyle`]: {{site.api}}/flutter/material/ButtonStyle-class.html
[`ButtonStyleButton`]: {{site.api}}/flutter/material/ButtonStyleButton-class.html
[`ElevatedButton`]: {{site.api}}/flutter/material/ElevatedButton-class.html
[`ElevatedButtonTheme`]: {{site.api}}/flutter/material/ElevatedButtonTheme-class.html
[`ElevatedButtonThemeData`]: {{site.api}}/flutter/material/ElevatedButtonThemeData-class.html
[`OutlinedButton`]: {{site.api}}/flutter/material/OutlinedButton-class.html
[`OutlinedButtonTheme`]: {{site.api}}/flutter/material/OutlinedButtonTheme-class.html
[`OutlinedButtonThemeData`]: {{site.api}}/flutter/material/OutlinedButtonThemeData-class.html
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html
[`TextButtonTheme`]: {{site.api}}/flutter/material/TextButtonTheme-class.html
[`TextButtonThemeData`]: {{site.api}}/flutter/material/TextButtonThemeData-class.html

---

### `Scaffold` `SnackBar` methods

Suportado pelo Flutter Fix: não

The following `Scaffold` `SnackBar` methods were deprecated in v1.23.

- `showSnackBar`
- `removeCurrentSnackBar`
- `hideCurrentSnackBar`

The same named methods of the `ScaffoldMessenger` should be used instead. A
default `ScaffoldMessenger` is already created in every `MaterialApp`.

**Guia de migração**

[Guia de migração detalhado disponível][]

Código antes da migração:

```dart
Scaffold.of(context).showSnackBar(mySnackBar);
Scaffold.of(context).removeCurrentSnackBar(mySnackBar);
Scaffold.of(context).hideCurrentSnackBar(mySnackBar);
```

Código após a migração:

```dart
ScaffoldMessenger.of(context).showSnackBar(mySnackBar);
ScaffoldMessenger.of(context).removeCurrentSnackBar(mySnackBar);
ScaffoldMessenger.of(context).hideCurrentSnackBar(mySnackBar);
```

**Referências**

Documento de design:
* [ScaffoldMessenger Design][]

Conteúdo em vídeo:

* [SnackBar Delivery][]
* [Widget of the Week][]

Documentação da API:

* [`ScaffoldMessenger`][]
* [`SnackBar`][]

Issues relevantes:

* [Issue 57218]({{site.repo.flutter}}/issues/57218)
* [Issue 62921]({{site.repo.flutter}}/issues/62921)

PRs relevantes:

* Nova API adicionada em [#64101]({{site.repo.flutter}}/issues/64101)
* Depreciado em [#67947]({{site.repo.flutter}}/issues/67947)
* Removido em [#98549]({{site.repo.flutter}}/issues/98549)

[Guia de migração detalhado disponível]: /release/breaking-changes/scaffold-messenger
[ScaffoldMessenger Design]: /go/scaffold-messenger
[SnackBar Delivery]: https://youtu.be/sYG7HAGu_Eg?t=10271
[Widget of the Week]: https://youtu.be/lytQi-slT5Y
[`ScaffoldMessenger`]: {{site.api}}/flutter/material/ScaffoldMessenger-class.html
[`SnackBar`]: {{site.api}}/flutter/material/SnackBar-class.html

---

### `RectangularSliderTrackShape.disabledThumbGapWidth`

Suportado pelo Flutter Fix: sim

The `RectangularSliderTrackShape.disabledThumbGapWidth` was first deprecated in
v1.5, and then extended in v1.26.

This was no longer used by the framework, as the animation of the slider thumb
no longer occurs when disabled.

**Guia de migração**

Código antes da migração:

```dart
RectangularSliderTrackShape(disabledThumbGapWidth: 2.0);
```

Código após a migração:

```dart
RectangularSliderTrackShape();
```

**Referências**

Documentação da API:
* [`RectangularSliderTrackShape`][]

PRs relevantes:
* Animation changed in [#30390]({{site.repo.flutter}}/issues/30390)
* Depreciado em [#65246]({{site.repo.flutter}}/issues/65246)
* Removido em [#98613]({{site.repo.flutter}}/issues/98613)

[`RectangularSliderTrackShape`]: {{site.api}}/flutter/material/RectangularSliderTrackShape-class.html

---

### Text selection of `ThemeData` to `TextSelectionThemeData`

Suportado pelo Flutter Fix: sim

The following `ThemeData` members were first deprecated in v1.23, and extended
in v1.26.

- `useTextSelectionTheme`
- `textSelectionColor`
- `cursorColor`
- `textSelectionHandleColor`

These should be replaced by a more comprehensive `TextSelectionThemeData`,
which is now specified in `ThemeData` itself.

The `useTextSelectionTheme` flag served as a temporary migration flag to
distinguish the two APIs, it can be removed now.

**Guia de migração**

[Guia de migração detalhado disponível][]

Código antes da migração:

```dart
ThemeData(
  useTextSelectionTheme: false,
  textSelectionColor: Colors.blue,
  cursorColor: Colors.green,
  textSelectionHandleColor: Colors.red,
);
```

Código após a migração:

```dart
ThemeData(
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: Colors.blue,
    cursorColor: Colors.green,
    selectionHandleColor: Colors.red,
  ),
);
```

**Referências**

Documento de design:

* [Text Selection Theme][]

Documentação da API:

* [`ThemeData`][]
* [`TextSelectionThemeData`][]

Issues relevantes:

* [Issue 17635]({{site.repo.flutter}}/issues/17635)
* [Issue 56082]({{site.repo.flutter}}/issues/56082)
* [Issue 61227]({{site.repo.flutter}}/issues/61227)

PRs relevantes:

* Nova API adicionada em [#62014]({{site.repo.flutter}}/issues/62014)
* Depreciado em [#66485]({{site.repo.flutter}}/issues/66482)
* Removido em [#98578]({{site.repo.flutter}}/issues/98578)

[Guia de migração detalhado disponível]: /release/breaking-changes/text-selection-theme
[Text Selection Theme]: /go/text-selection-theme
[`ThemeData`]: {{site.api}}/flutter/material/ThemeData-class.html
[`TextSelectionThemeData`]: {{site.api}}/flutter/material/TextSelectionThemeData-class.html

---

### `RenderEditable.onSelectionChanged` to `TextSelectionDelegate.textEditingValue`

Suportado pelo Flutter Fix: não

`RenderEditable.onSelectionChanged` and `TextSelectionDelegate.textEditingValue`
were deprecated in v1.26.

Instead of calling one or both of these methods, call
`TextSelectionDelegate.userUpdateTextEditingValue`. This fixed a bug where the
`TextInputFormatter` would receive the wrong selection value.

**Guia de migração**

Código antes da migração:

```dart
renderEditable.onSelectionChanged(selection, renderObject, cause);
textSelectionDelegate.textEditingValue = value;
```

Código após a migração:

```dart
textSelectionDelegate.userUpdateTextEditingValue(value, cause);
```

**Referências**

Documentação da API:

* [`RenderEditable`][]
* [`TextSelectionDelegate`][]

Issues relevantes:

* Resolved [#75505]({{site.repo.flutter}}/issues/75502)

PRs relevantes:

* Depreciado em [#75541]({{site.repo.flutter}}/issues/75541)
* Removido em [#98582]({{site.repo.flutter}}/issues/98582)

[`RenderEditable`]: {{site.api}}/flutter/rendering/RenderEditable-class.html
[`TextSelectionDelegate`]: {{site.api}}/flutter/services/TextSelectionDelegate-mixin.html

---

### `Stack.overflow`

Suportado pelo Flutter Fix: sim

`Stack.overflow`, as well as the `Overflow` enum were deprecated in v1.22.

The replacement is `Stack.clipBehavior`, a change made as part of unifying clip
behaviors and semantics across the framework. Where `Overflow.visible` was used,
use `Clip.none`. Where `Overflow.clip` was used, use `Clip.hardEdge`.

**Guia de migração**

[Guia de migração detalhado disponível][]

Código antes da migração:

```dart
const Stack stack = Stack(overflow: Overflow.visible);
const Stack stack = Stack(overflow: Overflow.clip);
```

Código após a migração:

```dart
const Stack stack = Stack(clipBehavior: Clip.none);
const Stack stack = Stack(clipBehavior: Clip.hardEdge);
```

**Referências**

Documentação da API:

* [`Stack`][]
* [`Clip`][]

Issues relevantes:

* Resolved [#66030]({{site.repo.flutter}}/issues/66030)

PRs relevantes:

* Depreciado em [#66305]({{site.repo.flutter}}/issues/66305)
* Removido em [#98583]({{site.repo.flutter}}/issues/98583)

[Guia de migração detalhado disponível]: /release/breaking-changes/clip-behavior
[`Stack`]: {{site.api}}/flutter/widgets/Stack-class.html
[`Clip`]: {{site.api}}/flutter/dart-ui/Clip.html

---

### `UpdateLiveRegionEvent`

Suportado pelo Flutter Fix: não

The `SemanticsEvent` `UpdateLiveRegionEvent`, was first deprecated in v1.12, and
then extended in v1.26.

This was never implemented by the framework, and any references should be
removed.

**Referências**

Documentação da API:

* [`SemanticsEvent`][]

PRs relevantes:

* Depreciado em [#45940]({{site.repo.flutter}}/issues/45940)
* Removido em [#98615]({{site.repo.flutter}}/issues/98615)

[`SemanticsEvent`]: {{site.api}}/flutter/semantics/SemanticsEvent-class.html

---

### `RenderObjectElement` methods

Suportado pelo Flutter Fix: sim

The following `RenderObjectElement` methods were deprecated in v1.21.

- `insertChildRenderObject`
- `moveChildRenderObject`
- `removeChildRenderObject`

These methods are replaced, respectively, by:

- `insertRenderObjectChild`
- `moveRenderObjectChild`
- `removeRenderObjectChild`

These changes were made as a soft breaking deprecation in order to change the
function signature.

**Guia de migração**

Código antes da migração:

```dart
element.insertChildRenderObject(child, slot);
element.moveChildRenderObject(child, slot);
element.removeChildRenderObject(child);
```

Código após a migração:

```dart
element.insertRenderObjectChild(child, slot);
element.moveRenderObjectChild(child, oldSlot, newSlot);
element.removeRenderObjectChild(child, slot);
```

**Referências**

Documentação da API:

* [`RenderObjectElement`][]

Issues relevantes:

* [Issue 63269]({{site.repo.flutter}}/issues/63269)

PRs relevantes:

* Depreciado em [#64254]({{site.repo.flutter}}/issues/64254)
* Removido em [#98616]({{site.repo.flutter}}/issues/98616)

[`RenderObjectElement`]: {{site.api}}/flutter/widgets/RenderObjectElement-class.html

---

## Linha do tempo

Na versão estável: 3.0.0
