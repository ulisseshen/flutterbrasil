---
title: Atualização do `Slider` do Material 3
description: >-
  O widget `Slider` foi atualizado para corresponder às
  especificações de design do Material 3.
ia-translate: true
---

## Resumo

O `Slider` foi atualizado para corresponder às especificações de design do Material 3.

As mudanças no `Slider` incluem uma altura atualizada,
uma lacuna entre a trilha ativa e inativa, e
um indicador de parada para mostrar o valor final da trilha inativa.
Pressionar o controle deslizante ajusta sua largura, e a trilha ajusta sua forma.
A nova forma do indicador de valor é um retângulo arredondado.
Novos mapeamentos de cores também foram introduzidos para algumas das formas do `Slider`.

## Contexto

As especificações de design do Material 3 para o `Slider` foram atualizadas em dezembro de 2023.
Para aderir à especificação de design de 2024, defina a flag `Slider.year2023` como `false`.
Isso é feito para garantir que os aplicativos existentes não sejam afetados pelas
especificações de design atualizadas.

## Descrição da mudança

O widget `Slider` tem uma flag `year2023` que pode ser definida como `false` para
aderir à especificação de design atualizada.
O valor padrão para a flag `year2023` é `true`,
o que significa que o `Slider` usa as especificações de design anteriores de 2023.

Quando [`Slider.year2023`][] é definido como `false`,
o slider usa as especificações de design atualizadas.

## Guia de migração

Para aderir à especificação de design atualizada para o `Slider`,
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

## Linha do tempo

Implementado na versão: 3.28.0-0.1.pre<br>
Na versão estável: Ainda não

## Referências

Documentação da API:

* [`Slider`][]
* [`Slider.year2023`][]

Issues relevantes:

* [Update `Slider` for Material 3 redesign][]

PRs relevantes:

* [Introduce new Material 3 `Slider` shapes][]

[`Slider`]: {{site.main-api}}/flutter/material/Slider-class.html
[`Slider.year2023`]: {{site.main-api}}/flutter/material/Slider/year2023.html
[Update `Slider` for Material 3 redesign]: {{site.repo.flutter}}/issues/141842
[Introduce new Material 3 `Slider` shapes]: {{site.repo.flutter}}/pull/152237
