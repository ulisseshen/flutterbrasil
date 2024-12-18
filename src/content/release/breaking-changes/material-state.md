---
ia-translate: true
title: Renomear MaterialState para WidgetState
description: >-
  MaterialState e suas APIs relacionadas foram movidas para
  fora da biblioteca Material e renomeadas para
  WidgetState.
---

## Resumo

`MaterialState`, e suas APIs relacionadas, foram movidas para
fora da biblioteca Material e renomeadas para `WidgetState`.

## Contexto

Anteriormente, `MaterialState` fornecia lógica para
manipular vários estados diferentes que um widget poderia ter,
como "hovered" (pairado), "focused" (focado) e "disabled" (desabilitado).
Como essa funcionalidade é útil fora da biblioteca Material,
nomeadamente para a camada base Widgets e Cupertino,
decidiu-se movê-la para fora do Material.
Como parte da mudança, e para evitar confusões futuras,
as diferentes classes `MaterialState` foram renomeadas para `WidgetState`.
O comportamento dos dois é o mesmo.

| Antes                          | Agora                           |
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
biblioteca Material sem um equivalente `WidgetState`, pois
elas são específicas do Material design.

## Guia de migração

Um [Flutter fix][] está disponível para ajudar a migrar as classes
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

## Linha do tempo

Implementado na versão: 3.21.0-11.0.pre<br>
Na versão estável: 3.22.0

## Referências

Problemas relevantes:

* [Criar suporte em nível de widgets para State][]

PRs relevantes:

* [Propriedades de Estado do Widget][]

[Criar suporte em nível de widgets para State]: {{site.repo.flutter}}/issues/138270
[Flutter fix]: /tools/flutter-fix
[Propriedades de Estado do Widget]: {{site.repo.flutter}}/pull/142151
