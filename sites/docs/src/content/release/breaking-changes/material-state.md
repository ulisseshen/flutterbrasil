---
ia-translate: true
title: Renomear MaterialState para WidgetState
description: >-
  MaterialState e suas APIs relacionadas foram movidas
  para fora da biblioteca Material e renomeadas para
  WidgetState.
---

{% render "docs/breaking-changes.md" %}

## Resumo

`MaterialState`, e suas APIs relacionadas, foram movidas para fora
da biblioteca Material e renomeadas para `WidgetState`.

## Contexto

Anteriormente, `MaterialState` fornecia lógica para
lidar com múltiplos estados diferentes que um widget poderia ter,
como "hovered", "focused" e "disabled".
Como essa funcionalidade é útil fora da biblioteca Material,
especialmente para a camada base de Widgets e Cupertino,
foi decidido movê-la para fora do Material.
Como parte da mudança, e para evitar confusão futura,
as diferentes classes `MaterialState` foram renomeadas para `WidgetState`.
O comportamento das duas é o mesmo.

| Antes                           | Agora                         |
|---------------------------------|-------------------------------|
| `MaterialState`                 | `WidgetState`                 |
| `MaterialStatePropertyResolver` | `WidgetStatePropertyResolver` |
| `MaterialStateColor`            | `WidgetStateColor`            |
| `MaterialStateMouseCursor`      | `WidgetStateColorMouseCursor` |
| `MaterialStateBorderSide`       | `WidgetStateBorderSide`       |
| `MaterialStateOutlinedBorder`   | `WidgetStateOutlinedBorder`   |
| `MaterialStateTextStyle`        | `WidgetStateTextStyle`        |
| `MaterialStateProperty`         | `WidgetStateProperty`         |
| `MaterialStatePropertyAll`      | `WidgetStatePropertyAll`      |
| `MaterialStatesController`      | `WidgetStatesController`      |

As classes `MaterialStateOutlineInputBorder` e
`MaterialStateUnderlineInputBorder` foram deixadas na
biblioteca Material sem equivalente `WidgetState`, pois
são específicas do design Material.

## Guia de migração

Um [Flutter fix][Flutter fix] está disponível para ajudar a migrar as classes
`MaterialState` para `WidgetState`.

Para migrar, substitua `MaterialState` por `WidgetState`.

Código antes da migração:

```dart
MaterialState selected = MaterialState.selected;

final MaterialStateProperty<Color> backgroundColor;

class _MouseCursor extends MaterialStateMouseCursor{
  const _MouseCursor(this.resolveCallback);

  final MaterialPropertyResolver<MouseCursor?> resolveCallback;

  @override
  MouseCursor resolve(Set<MaterialState> states) => resolveCallback(states) ?? MouseCursor.uncontrolled;
}

BorderSide side = MaterialStateBorderSide.resolveWith((Set<MaterialState> states) {
  if (states.contains(MaterialState.selected)) {
    return const BorderSide(color: Colors.red);
  }
  return null;
});
```

Código após a migração:

```dart
WidgetState selected = WidgetState.selected;

final WidgetStateProperty<Color> backgroundColor;

class _MouseCursor extends WidgetStateMouseCursor{
  const _MouseCursor(this.resolveCallback);

  final WidgetPropertyResolver<MouseCursor?> resolveCallback;

  @override
  MouseCursor resolve(Set<WidgetState> states) => resolveCallback(states) ?? MouseCursor.uncontrolled;
}

BorderSide side = WidgetStateBorderSide.resolveWith((Set<WidgetState> states) {
  if (states.contains(WidgetState.selected)) {
    return const BorderSide(color: Colors.red);
  }
  return null;
});
```

## Cronograma

Disponível na versão: 3.21.0-11.0.pre<br>
Na versão estável: 3.22.0

## Referências

Issues relevantes:

* [Create widgets level support for State][Create widgets level support for State]

PRs relevantes:

* [Widget State Properties][Widget State Properties]

[Create widgets level support for State]: {{site.repo.flutter}}/issues/138270
[Flutter fix]: /tools/flutter-fix
[Widget State Properties]: {{site.repo.flutter}}/pull/142151
