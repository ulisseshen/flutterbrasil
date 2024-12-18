---
ia-translate: true
title: A propriedade `toggleableActiveColor` de ThemeData foi descontinuada
description: >
  Widgets Material que usam a propriedade `toggleableActiveColor`
  foram migrados para usar o `ColorScheme` do Material.
---

## Resumo

Os widgets Material `Switch`, `SwitchListTile`, `Checkbox`,
`CheckboxListTile`, `Radio`, `RadioListTile` agora usam a cor
`ColorScheme.secondary` para seus widgets alternáveis.
`ThemeData.toggleableActiveColor` está descontinuada e será removida eventualmente.

## Contexto

A migração de widgets que dependem de `ThemeData.toggleableActiveColor`
para `ColorScheme.secondary` fez com que a propriedade
`toggleableActiveColor` se tornasse desnecessária. Essa propriedade será
eventualmente removida, conforme a [política de descontinuação](/release/compatibility-policy#deprecation-policy) do Flutter.

## Descrição da mudança

Os widgets que usam a cor `ThemeData.toggleableActiveColor` para o
estado ativo/selecionado agora usam `ColorScheme.secondary`.

## Guia de migração

A cor ativa/selecionada dos widgets alternáveis pode ser geralmente
customizada de 3 maneiras:

1. Usando `ColorScheme.secondary` de ThemeData.
2. Usando temas de componentes `SwitchThemeData`, `ListTileThemeData`,
   `CheckboxThemeData` e `RadioThemeData`.
3. Customizando as propriedades de cor do widget.

Código antes da migração:

```dart
MaterialApp(
  theme: ThemeData(toggleableActiveColor: myColor),
  // ...
);
```

Código após a migração:

```dart
final ThemeData theme = ThemeData();
MaterialApp(
  theme: theme.copyWith(
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return myColor;
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return myColor;
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return myColor;
        }
        return null;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return myColor;
        }
        return null;
      }),
    ),
  ),
  //...
)
```

## Linha do tempo

Na versão estável: 3.7

## Referências

Documentação da API:

* [`ThemeData.toggleableActiveColor`][]
* [`ColorScheme.secondary`][]

Issues relevantes:

* [`Switch` widget color doesn't use `ColorScheme`][]

PRs relevantes:

* [Deprecate `toggleableActiveColor`][].

[`ThemeData.toggleableActiveColor`]: {{site.api}}/flutter/material/ThemeData/toggleableActiveColor.html
[`ColorScheme.secondary`]: {{site.api}}/flutter/material/ColorScheme/secondary.html
[`Switch` widget color doesn't use `ColorScheme`]: {{site.repo.flutter}}/issues/93709
[Deprecate `toggleableActiveColor`]: {{site.repo.flutter}}/pull/97972
