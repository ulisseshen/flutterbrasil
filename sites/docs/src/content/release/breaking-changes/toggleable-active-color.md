---
title: A propriedade toggleableActiveColor do ThemeData foi descontinuada
description: >
  Widgets Material que usam a propriedade toggleableActiveColor
  foram migrados para usar o ColorScheme do Material.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Os widgets Material `Switch`, `SwitchListTile`, `Checkbox`,
`CheckboxListTile`, `Radio` e `RadioListTile` agora usam a cor
`ColorScheme.secondary` para o seu widget alternável.
`ThemeData.toggleableActiveColor` foi descontinuada e será removida
eventualmente.

## Contexto {:#context}

A migração dos widgets que dependiam de `ThemeData.toggleableActiveColor`
para `ColorScheme.secondary` tornou a propriedade `toggleableActiveColor`
desnecessária. Essa propriedade será removida eventualmente, conforme a
[política de descontinuação do Flutter](/release/compatibility-policy#deprecation-policy).

## Descrição da mudança {:#description-of-change}

Os widgets que usavam a cor `ThemeData.toggleableActiveColor` para o
estado ativo/selecionado agora usam `ColorScheme.secondary`.

## Guia de migração {:#migration-guide}

A cor do estado ativo/selecionado dos widgets alternáveis pode, em geral,
ser personalizada de 3 formas:

1. Usando o `ColorScheme.secondary` do ThemeData.
2. Usando os temas de componentes `SwitchThemeData`, `ListTileThemeData`,
   `CheckboxThemeData` e `RadioThemeData`.
3. Personalizando as propriedades de cor do próprio widget.

Código antes da migração:

```dart
MaterialApp(
  theme: ThemeData(toggleableActiveColor: myColor),
  // ...
);
```

Código depois da migração:

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

## Linha do tempo {:#timeline}

Na versão estável: 3.7

## Referências {:#references}

Documentação da API:

* [`ThemeData.toggleableActiveColor`][`ThemeData.toggleableActiveColor`]
* [`ColorScheme.secondary`][`ColorScheme.secondary`]

Issues relevantes:

* [A cor do widget `Switch` não usa `ColorScheme`][`Switch` widget color doesn't use `ColorScheme`]

PRs relevantes:

* [Descontinuação de `toggleableActiveColor`][Deprecate `toggleableActiveColor`].

[`ThemeData.toggleableActiveColor`]: {{site.material_ui}}/ThemeData/toggleableActiveColor.html
[`ColorScheme.secondary`]: {{site.material_ui}}/ColorScheme/secondary.html
[`Switch` widget color doesn't use `ColorScheme`]: {{site.repo.flutter}}/issues/93709
[Deprecate `toggleableActiveColor`]: {{site.repo.flutter}}/pull/97972
