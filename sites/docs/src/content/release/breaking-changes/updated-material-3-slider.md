---
title: '`Slider` do Material 3 atualizado'
description: >-
  O widget `Slider` foi atualizado para seguir as
  especificações do Material 3 Design.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

O `Slider` foi atualizado para seguir as especificações do Material 3 Design.

As mudanças no `Slider` incluem uma altura atualizada, um espaço entre
a trilha ativa e a inativa, e um indicador de parada para mostrar o
valor final da trilha inativa. Pressionar o thumb ajusta a largura dele,
e a trilha ajusta o seu formato. O novo formato do indicador de valor
é um retângulo arredondado. Também foram introduzidos novos mapeamentos
de cores para alguns formatos do `Slider`.

## Contexto {:#context}

As especificações do Material 3 Design para o `Slider` foram atualizadas
em dezembro de 2023. Para optar pela especificação de design de 2024,
defina a flag `Slider.year2023` como `false`.
Isso foi feito para garantir que os apps existentes não sejam afetados
pelas especificações de design atualizadas.

## Descrição da mudança {:#description-of-change}

O widget `Slider` tem uma flag `year2023` que pode ser definida como `false`
para optar pela especificação de design atualizada.
O valor padrão da flag `year2023` é `true`, o que significa que o `Slider`
usa as especificações de design de 2023 anteriores.

Quando [`Slider.year2023`][] é definido como `false`,
o slider usa as especificações de design atualizadas.

## Guia de migração {:#migration-guide}

Para optar pela especificação de design atualizada do `Slider`,
defina a flag `year2023` como `false`:

```dart highlightLines=2
Slider(
  year2023: false,
  value: _value,
  onChanged: (value) {
    setState(() {
      _value = value;
    });
  },
),
```

Para atualizar todo o seu app para usar o design atualizado do `Slider`,
defina a propriedade `SliderThemeData.year2023` como `false` no seu `MaterialApp`:

```dart highlightLines=2
return MaterialApp(
  theme: ThemeData(sliderTheme: const SliderThemeData(year2023: false)),
        // ...
        Slider(
          value: _value,
          onChanged: (value) {
            setState(() {
              _value = value;
            });
          },
        ),
        // ...
```

## Linha do tempo {:#timeline}

Incluído na versão: 3.28.0-0.1.pre<br>
Na versão estável: 3.29

## Referências {:#references}

Documentação da API:

* [`Slider`][`Slider`]
* [`Slider.year2023`][`Slider.year2023`]

Issues relevantes:

* [Atualização do `Slider` para o redesign do Material 3][Update `Slider` for Material 3 redesign]

PRs relevantes:

* [Introdução de novos formatos do `Slider` do Material 3][Introduce new Material 3 `Slider` shapes]

[`Slider`]: {{site.material_ui}}/Slider-class.html
[`Slider.year2023`]: {{site.material_ui}}/Slider/year2023.html
[Update `Slider` for Material 3 redesign]: {{site.repo.flutter}}/issues/141842
[Introduce new Material 3 `Slider` shapes]: {{site.repo.flutter}}/pull/152237
