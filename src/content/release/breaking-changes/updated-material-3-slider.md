---
ia-translate: true
title: O `Slider` do Material 3 Atualizado
description: >-
  O widget `Slider` foi atualizado para corresponder às especificações de
  Design do Material 3.
---

## Resumo

O `Slider` foi atualizado para corresponder às especificações de Design do
Material 3. As mudanças no `Slider` incluem uma altura atualizada, um espaço
entre a trilha ativa e inativa e um indicador de parada para mostrar o valor
final da trilha inativa. Pressionar o polegar ajusta sua largura, e a trilha
ajusta seu formato. O novo formato do indicador de valor é um retângulo
arredondado. Novos mapeamentos de cores também foram introduzidos para algumas
das formas do `Slider`.

## Contexto

As especificações de Design do Material 3 para o `Slider` foram atualizadas em
dezembro de 2023. Para optar pela especificação de design de 2024, defina a
flag `Slider.year2023` como `false`. Isso é feito para garantir que os aplicativos
existentes não sejam afetados pelas especificações de design atualizadas.

## Descrição da Mudança

O widget `Slider` tem uma flag `year2023` que pode ser definida como `false` para
optar pela especificação de design atualizada. O valor padrão para a flag
`year2023` é `true`, o que significa que o `Slider` usa as especificações de
design de 2023.

Quando [`Slider.year2023`][] é definido como `false`, o slider usará as
especificações de design atualizadas.

## Guia de Migração

Para optar pela especificação de design atualizada para o `Slider`, defina a
flag `year2023` como `false`:

```dart
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

## Linha do Tempo

Implementado na versão: v3.27.0-0.2.pre.<br>
Em release estável: Ainda não

## Referências

Documentação da API:

* [`Slider`][]
* [`Slider.year2023`][]

Issues relevantes:

* [Atualizar `Slider` para o redesign do Material 3][]

PRs relevantes:

* [Introduzir novas formas do `Slider` do Material 3][]

[`Slider`]: {{site.api}}/flutter/material/Slider-class.html
[`Slider.year2023`]: {{site.api}}/flutter/material/Slider/year2023.html
[Atualizar `Slider` para o redesign do Material 3]: {{site.repo.flutter}}/issues/141842
[Introduzir novas formas do `Slider` do Material 3]: {{site.repo.flutter}}/pull/152237
