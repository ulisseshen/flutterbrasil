---
title: Comportamento atualizado do `Checkbox.fillColor`
description: >
  Comportamento melhorado do `Checkbox.fillColor` aplica a cor de preenchimento ao
  background quando o checkbox não está selecionado.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

O `Checkbox.fillColor` é agora aplicado ao background do checkbox quando
o checkbox não está selecionado.

## Contexto

Anteriormente, o `Checkbox.fillColor` era aplicado à borda do checkbox
quando o checkbox não estava selecionado e seu background era transparente.
Com esta mudança, o `Checkbox.fillColor` é aplicado ao background
do checkbox e a borda usa a cor `Checkbox.side` quando o checkbox
não está selecionado.

## Descrição da mudança

O `Checkbox.fillColor` é agora aplicado ao background do checkbox quando
o checkbox não está selecionado em vez de ser usado como a cor da borda.

## Guia de migração

O comportamento atualizado do `Checkbox.fillColor` aplica a cor de preenchimento ao
background do checkbox no estado não selecionado. Para obter o comportamento anterior,
defina `Checbox.fillColor` como `Colors.transparent` no estado não selecionado e
defina `Checkbox.side` para a cor desejada.

Se você usa a propriedade `Checkbox.fillColor` para personalizar o checkbox.

Código antes da migração:

```dart
Checkbox(
  fillColor: MaterialStateProperty.resolveWith((states) {
    if (!states.contains(MaterialState.selected)) {
      return Colors.red;
    }
    return null;
  }),
  value: _checked,
  onChanged: _enabled
    ? (bool? value) {
        setState(() {
          _checked = value!;
        });
      }
    : null,
),
```

Código após a migração:

```dart
Checkbox(
  fillColor: MaterialStateProperty.resolveWith((states) {
    if (!states.contains(MaterialState.selected)) {
      return Colors.transparent;
    }
    return null;
  }),
  side: const BorderSide(color: Colors.red, width: 2),
  value: _checked,
  onChanged: _enabled
    ? (bool? value) {
        setState(() {
          _checked = value!;
        });
      }
    : null,
),
```

Se você usa a propriedade `CheckboxThemeData.fillColor` para personalizar o checkbox.

Código antes da migração:

```dart
checkboxTheme: CheckboxThemeData(
  fillColor: MaterialStateProperty.resolveWith((states) {
    if (!states.contains(MaterialState.selected)) {
      return Colors.red;
    }
    return null;
  }),
),
```

Código após a migração:

```dart
checkboxTheme: CheckboxThemeData(
  fillColor: MaterialStateProperty.resolveWith((states) {
    if (!states.contains(MaterialState.selected)) {
      return Colors.transparent;
    }
    return null;
  }),
  side: const BorderSide(color: Colors.red, width: 2),
),
```

## Linha do tempo

Lançado na versão: 3.10.0-17.0.pre<br>
Na versão estável: 3.13.0

## Referências

Documentação da API:

* [`Checkbox.fillColor`][]

Issues relevantes:

* [Adicionar `backgroundColor` ao `Checkbox` e `CheckboxThemeData`][Add `backgroundColor` to `Checkbox` and `CheckboxThemeData`]

PRs relevantes:

* [`Checkbox.fillColor` deveria ser aplicado à cor de background do checkbox quando não está marcado.][`Checkbox.fillColor` should be applied to checkbox's background color when it is unchecked.]

[`Checkbox.fillColor`]: {{site.api}}/flutter/material/Checkbox/fillColor.html

[Add `backgroundColor` to `Checkbox` and `CheckboxThemeData`]: {{site.repo.flutter}}/issues/123386
[`Checkbox.fillColor` should be applied to checkbox's background color when it is unchecked.]: {{site.repo.flutter}}/pull/125643
