---
ia-translate: true
title: API Deprecada Removida após a v2.10
description: >
  Após atingir o fim de vida, as seguintes APIs depreciadas
  foram removidas do Flutter.
---

## Sumário

De acordo com a [Política de Depreciação][] do Flutter,
APIs depreciadas que atingiram o fim de vida após o
lançamento estável 2.10 foram removidas.

Todas as APIs afetadas foram compiladas nesta
fonte primária para auxiliar na migração. Uma
[folha de referência rápida][] também está disponível.


[Política de Depreciação]: {{site.repo.flutter}}/blob/master/docs/contributing/Tree-hygiene.md#deprecations
[folha de referência rápida]: /go/deprecations-removed-after-2-10

## Mudanças

Esta seção lista as depreciações pela classe afetada.

---

### `maxLengthEnforced` de `TextField` & classes relacionadas

Suportado pelo Flutter Fix: sim

`maxLengthEnforced` foi depreciado na v1.25.

Use `maxLengthEnforcement` em vez disso.
Onde `maxLengthEnforced` era true, substitua por `MaxLengthEnforcement.enforce`.
Onde `maxLengthEnforced` era false, substitua por `MaxLengthEnforcement.none`.
Essa alteração permite que mais comportamentos sejam especificados além da escolha
binária original, adicionando `MaxLengthEnforcement.truncateAfterCompositionEnds`
como uma opção adicional.

As seguintes classes têm todas a mesma alteração de API:

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

Problemas relevantes:

* [Issue 67898]({{site.repo.flutter}}/issues/67898)

PRs relevantes:

* Depreciado em [#68086]({{site.repo.flutter}}/pull/68086)
* Removido em [#98539]({{site.repo.flutter}}/pull/98539)

[Guia de migração detalhado disponível]: /release/breaking-changes/use-maxLengthEnforcement-instead-of-maxLengthEnforced
[`TextField`]: {{site.api}}/flutter/material/TextField-class.html
[`TextFormField`]: {{site.api}}/flutter/material/TextFormField-class.html
[`CupertinoTextField`]: {{site.api}}/flutter/cupertino/CupertinoTextField-class.html

---

### Construtor `VelocityTracker`

Suportado pelo Flutter Fix: sim

O construtor padrão para `VelocityTracker` foi depreciado na v1.22.

O `VelocityTracker.withKind()` deve ser usado em vez disso. Isso permite que um
`PointerDeviceKind` seja especificado para o rastreador. O padrão anterior para
`VelocityTracker.kind` era `PointerDeviceKind.touch`.

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

Os widgets `DayPicker` e `MonthPicker` foram depreciados pela primeira vez na
v1.15 e, em seguida, estendidos na v1.26.

Eles foram substituídos por um widget abrangente, `CalendarDatePicker`.

Esses widgets foram exibidos usando o método `showDatePicker`. Este método foi
migrado para apresentar o novo `CalendarDatePicker` antes deste lançamento, e
assim sua remoção final não deve exigir nenhuma ação adicional.

**Referências**

Documento de design:

* [Redesign do Seletor de Data Material][]

Documentação da API:

* [`CalendarDatePicker`][]
* [`showDatePicker`][]

Problemas relevantes:

* [Issue 50133]({{site.repo.flutter}}/issues/50133)

PRs relevantes:

* Depreciado em [#50546]({{site.repo.flutter}}/issues/50546)
* Removido em [#98543]({{site.repo.flutter}}/issues/98543)

[Redesign do Seletor de Data Material]: /go/material-date-picker-redesign
[`CalendarDatePicker`]: {{site.api}}/flutter/material/CalendarDatePicker-class.html
[`showDatePicker`]: {{site.api}}/flutter/material/showDatePicker.html

---

### `FlatButton`, `RaisedButton` e `OutlineButton`

Suportado pelo Flutter Fix: não

Os widgets `FlatButton`, `RaisedButton` e `OutlineButton` foram depreciados
pela primeira vez na v1.20 e, em seguida, estendidos na v1.26.

Eles são substituídos por novos botões, `TextButton`, `ElevatedButton` e
`OutlinedButton`. Esses novos widgets também usam novos temas associados, em vez
do genérico `ButtonTheme`.

| Widget Antigo     | Tema Antigo    | Novo Widget       | Novo Tema             |
|-------------------|----------------|-------------------|-----------------------|
| `FlatButton`      | `ButtonTheme`  | `TextButton`      | `TextButtonTheme`     |
| `RaisedButton`    | `ButtonTheme`  | `ElevatedButton`  | `ElevatedButtonTheme` |
| `OutlineButton`   | `ButtonTheme`  | `OutlinedButton`  | `OutlinedButtonTheme` |

{:.table .table-striped .nowrap}

**Guia de migração**

[Guia de migração detalhado disponível para estilização detalhada][]

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

* [Novos botões e temas Material][]

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

[Guia de migração detalhado disponível para estilização detalhada]: /release/breaking-changes/buttons
[Novos botões e temas Material]: /go/material-button-migration-guide
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

### Métodos `SnackBar` de `Scaffold`

Suportado pelo Flutter Fix: não

Os seguintes métodos `SnackBar` de `Scaffold` foram depreciados na v1.23.

- `showSnackBar`
- `removeCurrentSnackBar`
- `hideCurrentSnackBar`

Os mesmos métodos nomeados do `ScaffoldMessenger` devem ser usados em vez disso.
Um `ScaffoldMessenger` padrão já é criado em cada `MaterialApp`.

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
* [Design do ScaffoldMessenger][]

Conteúdo em vídeo:

* [Entrega de SnackBar][]
* [Widget da Semana][]

Documentação da API:

* [`ScaffoldMessenger`][]
* [`SnackBar`][]

Problemas relevantes:

* [Issue 57218]({{site.repo.flutter}}/issues/57218)
* [Issue 62921]({{site.repo.flutter}}/issues/62921)

PRs relevantes:

* Nova API adicionada em [#64101]({{site.repo.flutter}}/issues/64101)
* Depreciado em [#67947]({{site.repo.flutter}}/issues/67947)
* Removido em [#98549]({{site.repo.flutter}}/issues/98549)

[Guia de migração detalhado disponível]: /release/breaking-changes/scaffold-messenger
[Design do ScaffoldMessenger]: /go/scaffold-messenger
[Entrega de SnackBar]: https://youtu.be/sYG7HAGu_Eg?t=10271
[Widget da Semana]: https://youtu.be/lytQi-slT5Y
[`ScaffoldMessenger`]: {{site.api}}/flutter/material/ScaffoldMessenger-class.html
[`SnackBar`]: {{site.api}}/flutter/material/SnackBar-class.html

---

### `RectangularSliderTrackShape.disabledThumbGapWidth`

Suportado pelo Flutter Fix: sim

`RectangularSliderTrackShape.disabledThumbGapWidth` foi depreciado pela primeira
vez na v1.5 e, em seguida, estendido na v1.26.

Isso não era mais usado pela estrutura, pois a animação do polegar do controle
deslizante não ocorre mais quando desativado.

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
* Animação alterada em [#30390]({{site.repo.flutter}}/issues/30390)
* Depreciado em [#65246]({{site.repo.flutter}}/issues/65246)
* Removido em [#98613]({{site.repo.flutter}}/issues/98613)

[`RectangularSliderTrackShape`]: {{site.api}}/flutter/material/RectangularSliderTrackShape-class.html

---

### Seleção de texto de `ThemeData` para `TextSelectionThemeData`

Suportado pelo Flutter Fix: sim

Os seguintes membros `ThemeData` foram depreciados pela primeira vez na v1.23
e estendidos na v1.26.

- `useTextSelectionTheme`
- `textSelectionColor`
- `cursorColor`
- `textSelectionHandleColor`

Eles devem ser substituídos por um `TextSelectionThemeData` mais abrangente, que
agora é especificado no próprio `ThemeData`.

O sinalizador `useTextSelectionTheme` serviu como um sinalizador de migração
temporário para distinguir as duas APIs, ele pode ser removido agora.

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

* [Tema de Seleção de Texto][]

Documentação da API:

* [`ThemeData`][]
* [`TextSelectionThemeData`][]

Problemas relevantes:

* [Issue 17635]({{site.repo.flutter}}/issues/17635)
* [Issue 56082]({{site.repo.flutter}}/issues/56082)
* [Issue 61227]({{site.repo.flutter}}/issues/61227)

PRs relevantes:

* Nova API adicionada em [#62014]({{site.repo.flutter}}/issues/62014)
* Depreciado em [#66485]({{site.repo.flutter}}/issues/66482)
* Removido em [#98578]({{site.repo.flutter}}/issues/98578)

[Guia de migração detalhado disponível]: /release/breaking-changes/text-selection-theme
[Tema de Seleção de Texto]: /go/text-selection-theme
[`ThemeData`]: {{site.api}}/flutter/material/ThemeData-class.html
[`TextSelectionThemeData`]: {{site.api}}/flutter/material/TextSelectionThemeData-class.html

---

### `RenderEditable.onSelectionChanged` para `TextSelectionDelegate.textEditingValue`

Suportado pelo Flutter Fix: não

`RenderEditable.onSelectionChanged` e `TextSelectionDelegate.textEditingValue`
foram depreciados na v1.26.

Em vez de chamar um ou ambos esses métodos, chame
`TextSelectionDelegate.userUpdateTextEditingValue`. Isso corrigiu um bug onde o
`TextInputFormatter` receberia o valor de seleção errado.

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

Problemas relevantes:

* Resolvido [#75505]({{site.repo.flutter}}/issues/75502)

PRs relevantes:

* Depreciado em [#75541]({{site.repo.flutter}}/issues/75541)
* Removido em [#98582]({{site.repo.flutter}}/issues/98582)

[`RenderEditable`]: {{site.api}}/flutter/rendering/RenderEditable-class.html
[`TextSelectionDelegate`]: {{site.api}}/flutter/services/TextSelectionDelegate-mixin.html

---

### `Stack.overflow`

Suportado pelo Flutter Fix: sim

`Stack.overflow`, assim como o enum `Overflow` foram depreciados na v1.22.

A substituição é `Stack.clipBehavior`, uma alteração feita como parte da
unificação de comportamentos e semântica de clipe em toda a estrutura. Onde
`Overflow.visible` era usado, use `Clip.none`. Onde `Overflow.clip` era usado,
use `Clip.hardEdge`.

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

Problemas relevantes:

* Resolvido [#66030]({{site.repo.flutter}}/issues/66030)

PRs relevantes:

* Depreciado em [#66305]({{site.repo.flutter}}/issues/66305)
* Removido em [#98583]({{site.repo.flutter}}/issues/98583)

[Guia de migração detalhado disponível]: /release/breaking-changes/clip-behavior
[`Stack`]: {{site.api}}/flutter/widgets/Stack-class.html
[`Clip`]: {{site.api}}/flutter/dart-ui/Clip.html

---

### `UpdateLiveRegionEvent`

Suportado pelo Flutter Fix: não

O `SemanticsEvent` `UpdateLiveRegionEvent` foi depreciado pela primeira vez
na v1.12 e, em seguida, estendido na v1.26.

Isso nunca foi implementado pela estrutura e quaisquer referências devem ser
removidas.

**Referências**

Documentação da API:

* [`SemanticsEvent`][]

PRs relevantes:

* Depreciado em [#45940]({{site.repo.flutter}}/issues/45940)
* Removido em [#98615]({{site.repo.flutter}}/issues/98615)

[`SemanticsEvent`]: {{site.api}}/flutter/semantics/SemanticsEvent-class.html

---

### Métodos `RenderObjectElement`

Suportado pelo Flutter Fix: sim

Os seguintes métodos `RenderObjectElement` foram depreciados na v1.21.

- `insertChildRenderObject`
- `moveChildRenderObject`
- `removeChildRenderObject`

Esses métodos são substituídos, respectivamente, por:

- `insertRenderObjectChild`
- `moveRenderObjectChild`
- `removeRenderObjectChild`

Essas alterações foram feitas como uma depreciação de quebra suave para alterar
a assinatura da função.

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

Problemas relevantes:

* [Issue 63269]({{site.repo.flutter}}/issues/63269)

PRs relevantes:

* Depreciado em [#64254]({{site.repo.flutter}}/issues/64254)
* Removido em [#98616]({{site.repo.flutter}}/issues/98616)

[`RenderObjectElement`]: {{site.api}}/flutter/widgets/RenderObjectElement-class.html

---

## Linha do tempo

No lançamento estável: 3.0.0
