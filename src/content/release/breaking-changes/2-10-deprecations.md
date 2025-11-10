---
title: API obsoleta removida após v2.10
description: >
  Após atingir o fim da vida útil, as seguintes APIs obsoletas
  foram removidas do Flutter.
ia-translate: true
---

## Resumo

De acordo com a [Política de Obsolescência][Deprecation Policy] do Flutter,
APIs obsoletas que atingiram o fim da vida útil após o
lançamento estável 2.10 foram removidas.

Todas as APIs afetadas foram compiladas nesta
fonte primária para auxiliar na migração. Uma
[folha de referência rápida][quick reference sheet] também está disponível.


[Deprecation Policy]: {{site.repo.flutter}}/blob/main/docs/contributing/Tree-hygiene.md#deprecations
[quick reference sheet]: /go/deprecations-removed-after-2-10

## Mudanças

Esta seção lista as obsolescências pela classe afetada.

---

### `maxLengthEnforced` of `TextField` & related classes

Suportado pelo Flutter Fix: sim

`maxLengthEnforced` foi obsoleto em v1.25.

Use `maxLengthEnforcement` em vez disso.
Onde `maxLengthEnforced` era true, substitua por `MaxLengthEnforcement.enforce`.
Onde `maxLengthEnforced` era false, substitua por `MaxLengthEnforcement.none`.
Esta mudança permite que mais comportamentos sejam especificados além da escolha
binária original, adicionando `MaxLengthEnforcement.truncateAfterCompositionEnds` como uma
opção adicional.

As seguintes classes têm a mesma mudança de API:

- `TextField`
- `TextFormField`
- `CupertinoTextField`

**Migration guide**

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

**References**

Documentação da API:

* [`TextField`][]
* [`TextFormField`][]
* [`CupertinoTextField`][]

Issues relevantes:

* [Issue 67898]({{site.repo.flutter}}/issues/67898)

PRs relevantes:

* Obsoleto em [#68086]({{site.repo.flutter}}/pull/68086)
* Removido em [#98539]({{site.repo.flutter}}/pull/98539)

[Guia de migração detalhado disponível]: /release/breaking-changes/use-maxLengthEnforcement-instead-of-maxLengthEnforced
[`TextField`]: {{site.api}}/flutter/material/TextField-class.html
[`TextFormField`]: {{site.api}}/flutter/material/TextFormField-class.html
[`CupertinoTextField`]: {{site.api}}/flutter/cupertino/CupertinoTextField-class.html

---

### `VelocityTracker` constructor

Suportado pelo Flutter Fix: sim

O construtor padrão para `VelocityTracker` foi obsoleto em v1.22.

O `VelocityTracker.withKind()` deve ser usado em vez disso. Isso permite que um
`PointerDeviceKind` seja especificado para o rastreador. O padrão anterior para
`VelocityTracker.kind` era `PointerDeviceKind.touch`.

**Migration guide**

Código antes da migração:

```dart
final VelocityTracker tracker = VelocityTracker();
```

Código após a migração:

```dart
final VelocityTracker tracker = VelocityTracker.withKind(PointerDeviceKind.touch);
```

**References**

Documentação da API:

* [`VelocityTracker`][]
* [`PointerDeviceKind`][]

PRs relevantes:

* Obsoleto em [#66043]({{site.repo.flutter}}/pull/66043)
* Removido em [#98541]({{site.repo.flutter}}/pull/98541)

[`VelocityTracker`]: {{site.api}}/flutter/gestures/VelocityTracker-class.html
[`PointerDeviceKind`]: {{site.api}}/flutter/dart-ui/PointerDeviceKind.html

---

### `DayPicker` & `MonthPicker`

Suportado pelo Flutter Fix: não

Os widgets `DayPicker` e `MonthPicker` foram obsoletos pela primeira vez em v1.15, e
então estendidos em v1.26.

Eles foram substituídos por um widget abrangente, `CalendarDatePicker`.

Esses widgets eram exibidos usando o método `showDatePicker`. Este método foi
migrado para apresentar o novo `CalendarDatePicker` antes deste lançamento, e portanto
sua remoção final não deve necessitar ação adicional.

**References**

Design document:

* [Material Date Picker Redesign][]

Documentação da API:

* [`CalendarDatePicker`][]
* [`showDatePicker`][]

Issues relevantes:

* [Issue 50133]({{site.repo.flutter}}/issues/50133)

PRs relevantes:

* Obsoleto em [#50546]({{site.repo.flutter}}/issues/50546)
* Removido em [#98543]({{site.repo.flutter}}/issues/98543)

[Material Date Picker Redesign]: /go/material-date-picker-redesign
[`CalendarDatePicker`]: {{site.api}}/flutter/material/CalendarDatePicker-class.html
[`showDatePicker`]: {{site.api}}/flutter/material/showDatePicker.html

---

### `FlatButton`, `RaisedButton`, & `OutlineButton`

Suportado pelo Flutter Fix: não

Os widgets `FlatButton`, `RaisedButton` e `OutlineButton` foram obsoletos pela primeira
vez em v1.20, e então estendidos em v1.26.

Eles são substituídos por novos botões, `TextButton`, `ElevatedButton` e
`OutlinedButton`. Esses novos widgets também usam novos temas associados, em vez do
`ButtonTheme` genérico.

| Old Widget      | Old Theme     | New Widget       | New Theme             |
|-----------------|---------------|------------------|-----------------------|
| `FlatButton`    | `ButtonTheme` | `TextButton`     | `TextButtonTheme`     |
| `RaisedButton`  | `ButtonTheme` | `ElevatedButton` | `ElevatedButtonTheme` |
| `OutlineButton` | `ButtonTheme` | `OutlinedButton` | `OutlinedButtonTheme` |

{:.table .table-striped .nowrap}

**Migration guide**

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

**References**

Design document:

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

* New API added in [#59702]({{site.repo.flutter}}/issues/59702)
* Obsoleto em [#73352]({{site.repo.flutter}}/issues/73352)
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

Os seguintes métodos `SnackBar` de `Scaffold` foram obsoletos em v1.23.

- `showSnackBar`
- `removeCurrentSnackBar`
- `hideCurrentSnackBar`

Os métodos de mesmo nome de `ScaffoldMessenger` devem ser usados em vez disso. Um
`ScaffoldMessenger` padrão já é criado em todo `MaterialApp`.

**Migration guide**

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

**References**

Design document:
* [ScaffoldMessenger Design][]

Video content:

* [SnackBar Delivery][]
* [Widget of the Week][]

Documentação da API:

* [`ScaffoldMessenger`][]
* [`SnackBar`][]

Issues relevantes:

* [Issue 57218]({{site.repo.flutter}}/issues/57218)
* [Issue 62921]({{site.repo.flutter}}/issues/62921)

PRs relevantes:

* New API added in [#64101]({{site.repo.flutter}}/issues/64101)
* Obsoleto em [#67947]({{site.repo.flutter}}/issues/67947)
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

O `RectangularSliderTrackShape.disabledThumbGapWidth` foi obsoleto pela primeira vez em
v1.5, e então estendido em v1.26.

Isso não era mais usado pelo framework, pois a animação do thumb do slider
não ocorre mais quando desabilitado.

**Migration guide**

Código antes da migração:

```dart
RectangularSliderTrackShape(disabledThumbGapWidth: 2.0);
```

Código após a migração:

```dart
RectangularSliderTrackShape();
```

**References**

Documentação da API:
* [`RectangularSliderTrackShape`][]

PRs relevantes:
* Animation changed in [#30390]({{site.repo.flutter}}/issues/30390)
* Obsoleto em [#65246]({{site.repo.flutter}}/issues/65246)
* Removido em [#98613]({{site.repo.flutter}}/issues/98613)

[`RectangularSliderTrackShape`]: {{site.api}}/flutter/material/RectangularSliderTrackShape-class.html

---

### Text selection of `ThemeData` to `TextSelectionThemeData`

Suportado pelo Flutter Fix: sim

Os seguintes membros de `ThemeData` foram obsoletos pela primeira vez em v1.23, e estendidos
em v1.26.

- `useTextSelectionTheme`
- `textSelectionColor`
- `cursorColor`
- `textSelectionHandleColor`

Eles devem ser substituídos por um `TextSelectionThemeData` mais abrangente,
que agora é especificado no próprio `ThemeData`.

A flag `useTextSelectionTheme` serviu como uma flag de migração temporária para
distinguir as duas APIs, ela pode ser removida agora.

**Migration guide**

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

**References**

Design document:

* [Text Selection Theme][]

Documentação da API:

* [`ThemeData`][]
* [`TextSelectionThemeData`][]

Issues relevantes:

* [Issue 17635]({{site.repo.flutter}}/issues/17635)
* [Issue 56082]({{site.repo.flutter}}/issues/56082)
* [Issue 61227]({{site.repo.flutter}}/issues/61227)

PRs relevantes:

* New API added in [#62014]({{site.repo.flutter}}/issues/62014)
* Obsoleto em [#66485]({{site.repo.flutter}}/issues/66482)
* Removido em [#98578]({{site.repo.flutter}}/issues/98578)

[Guia de migração detalhado disponível]: /release/breaking-changes/text-selection-theme
[Text Selection Theme]: /go/text-selection-theme
[`ThemeData`]: {{site.api}}/flutter/material/ThemeData-class.html
[`TextSelectionThemeData`]: {{site.api}}/flutter/material/TextSelectionThemeData-class.html

---

### `RenderEditable.onSelectionChanged` to `TextSelectionDelegate.textEditingValue`

Suportado pelo Flutter Fix: não

`RenderEditable.onSelectionChanged` e `TextSelectionDelegate.textEditingValue`
foram obsoletos em v1.26.

Em vez de chamar um ou ambos esses métodos, chame
`TextSelectionDelegate.userUpdateTextEditingValue`. Isso corrigiu um bug onde o
`TextInputFormatter` receberia o valor de seleção errado.

**Migration guide**

Código antes da migração:

```dart
renderEditable.onSelectionChanged(selection, renderObject, cause);
textSelectionDelegate.textEditingValue = value;
```

Código após a migração:

```dart
textSelectionDelegate.userUpdateTextEditingValue(value, cause);
```

**References**

Documentação da API:

* [`RenderEditable`][]
* [`TextSelectionDelegate`][]

Issues relevantes:

* Resolved [#75505]({{site.repo.flutter}}/issues/75502)

PRs relevantes:

* Obsoleto em [#75541]({{site.repo.flutter}}/issues/75541)
* Removido em [#98582]({{site.repo.flutter}}/issues/98582)

[`RenderEditable`]: {{site.api}}/flutter/rendering/RenderEditable-class.html
[`TextSelectionDelegate`]: {{site.api}}/flutter/services/TextSelectionDelegate-mixin.html

---

### `Stack.overflow`

Suportado pelo Flutter Fix: sim

`Stack.overflow`, assim como o enum `Overflow` foram obsoletos em v1.22.

A substituição é `Stack.clipBehavior`, uma mudança feita como parte da unificação de
comportamentos e semântica de clip em todo o framework. Onde `Overflow.visible` era usado,
use `Clip.none`. Onde `Overflow.clip` era usado, use `Clip.hardEdge`.

**Migration guide**

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

**References**

Documentação da API:

* [`Stack`][]
* [`Clip`][]

Issues relevantes:

* Resolved [#66030]({{site.repo.flutter}}/issues/66030)

PRs relevantes:

* Obsoleto em [#66305]({{site.repo.flutter}}/issues/66305)
* Removido em [#98583]({{site.repo.flutter}}/issues/98583)

[Guia de migração detalhado disponível]: /release/breaking-changes/clip-behavior
[`Stack`]: {{site.api}}/flutter/widgets/Stack-class.html
[`Clip`]: {{site.api}}/flutter/dart-ui/Clip.html

---

### `UpdateLiveRegionEvent`

Suportado pelo Flutter Fix: não

O `SemanticsEvent` `UpdateLiveRegionEvent`, foi obsoleto pela primeira vez em v1.12, e
então estendido em v1.26.

Isso nunca foi implementado pelo framework, e quaisquer referências devem ser
removidas.

**References**

Documentação da API:

* [`SemanticsEvent`][]

PRs relevantes:

* Obsoleto em [#45940]({{site.repo.flutter}}/issues/45940)
* Removido em [#98615]({{site.repo.flutter}}/issues/98615)

[`SemanticsEvent`]: {{site.api}}/flutter/semantics/SemanticsEvent-class.html

---

### `RenderObjectElement` methods

Suportado pelo Flutter Fix: sim

Os seguintes métodos `RenderObjectElement` foram obsoletos em v1.21.

- `insertChildRenderObject`
- `moveChildRenderObject`
- `removeChildRenderObject`

Esses métodos são substituídos, respectivamente, por:

- `insertRenderObjectChild`
- `moveRenderObjectChild`
- `removeRenderObjectChild`

Essas mudanças foram feitas como uma obsolescência de quebra suave para mudar a
assinatura da função.

**Migration guide**

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

**References**

Documentação da API:

* [`RenderObjectElement`][]

Issues relevantes:

* [Issue 63269]({{site.repo.flutter}}/issues/63269)

PRs relevantes:

* Obsoleto em [#64254]({{site.repo.flutter}}/issues/64254)
* Removido em [#98616]({{site.repo.flutter}}/issues/98616)

[`RenderObjectElement`]: {{site.api}}/flutter/widgets/RenderObjectElement-class.html

---

## Linha do tempo

No lançamento estável: 3.0.0
