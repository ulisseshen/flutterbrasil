---
ia-translate: true
title: Comportamento atualizado de `Checkbox.fillColor`
description: >
  O comportamento aprimorado de `Checkbox.fillColor` aplica a cor de
  preenchimento ao fundo quando a caixa de seleção está desmarcada.
---

## Resumo

O `Checkbox.fillColor` agora é aplicado ao fundo da caixa de seleção quando
a caixa de seleção está desmarcada.

## Contexto

Anteriormente, o `Checkbox.fillColor` era aplicado à borda da caixa de
seleção quando a caixa de seleção estava desmarcada e seu fundo era
transparente. Com esta alteração, o `Checkbox.fillColor` é aplicado ao
fundo da caixa de seleção e a borda usa a cor `Checkbox.side` quando a
caixa de seleção está desmarcada.

## Descrição da mudança

O `Checkbox.fillColor` agora é aplicado ao fundo da caixa de seleção quando
a caixa de seleção está desmarcada, em vez de ser usado como a cor da borda.

## Guia de migração

O comportamento atualizado de `Checkbox.fillColor` aplica a cor de
preenchimento ao fundo da caixa de seleção no estado desmarcado. Para obter
o comportamento anterior, defina `Checbox.fillColor` como `Colors.transparent`
no estado desmarcado e defina `Checkbox.side` com a cor desejada.

Se você usa a propriedade `Checkbox.fillColor` para personalizar a caixa de
seleção.

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

Se você usa a propriedade `CheckboxThemeData.fillColor` para personalizar a
caixa de seleção.

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

Implementado na versão: 3.10.0-17.0.pre<br>
Na versão estável: 3.13.0

## Referências

Documentação da API:

* [`Checkbox.fillColor`][]

Problemas relevantes:

* [Adicionar `backgroundColor` a `Checkbox` e `CheckboxThemeData`][]

PRs relevantes:

* [`Checkbox.fillColor` deve ser aplicado à cor de fundo da caixa de seleção quando ela estiver desmarcada.][]

[`Checkbox.fillColor`]: {{site.api}}/flutter/material/Checkbox/fillColor.html
[Adicionar `backgroundColor` a `Checkbox` e `CheckboxThemeData`]: {{site.repo.flutter}}/issues/123386
[`Checkbox.fillColor` deve ser aplicado à cor de fundo da caixa de seleção quando ela estiver desmarcada.]: {{site.repo.flutter}}/pull/125643
