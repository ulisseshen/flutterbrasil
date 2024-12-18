---
ia-translate: true
title: Atualização de Tokens do Material 3 no Flutter
description: >-
  Os tokens mais recentes do Material Design 3 (v6.1) foram aplicados à
  biblioteca Material do Flutter.
---

## Resumo

Os tokens do Material Design atualizaram o mapeamento de 4 papéis de cores (apenas
no modo Claro) para serem mais visualmente atraentes, mantendo o contraste
acessível. Os testes identificaram essa mudança como [não-destrutiva] no Flutter,
mas alguns clientes podem notar essa pequena alteração. A atualização afetou as
seguintes propriedades de cor:

* On-primary-container (Primary10 para Primary30)
* On-secondary-container (Secondary10 para Secondary30)
* On-tertiary-container (Tertiary10 para Tertiary30)
* On-error-container (Error10 para Error30)

Widgets que têm usado esses papéis com seu valor padrão podem parecer diferentes.

Além disso, os tokens do Material 3 atualizaram a cor da borda dos Chips de
`ColorScheme.outline` para `ColorScheme.outlineVariant` para melhorar a hierarquia
visual entre chips e botões. Chips (`Chip`, `ActionChip`, `ChoiceChip`,
`FilterChip` e `InputChip`) que têm usado os tokens de borda de chip podem
parecer diferentes.

## Guia de migração

As diferenças nos mapeamentos dos papéis de cor são pequenas. Use
`ColorScheme.copyWith` para reverter para as cores padrão originais:

Código antes da migração:

```dart
final ColorScheme colors = ThemeData().colorScheme;
```

Código após a migração:

```dart
final ColorScheme colors = ThemeData().colorScheme.copyWith(
  onPrimaryContainer: const Color(0xFF21005D),
  onSecondaryContainer: const Color(0xFF1D192B),
  onTertiaryContainer: const Color(0xFF31111D),
  onErrorContainer: const Color(0xFF410E0B),
);
```

Após aplicar a atualização do token, a cor padrão da borda dos chips M3 parece
mais clara. Tome `ActionChip` como exemplo:

Código antes da migração:

```dart
final Widget chip = ActionChip(
  label: const Text('action chip'),
  onPressed: () {},
);
```

Código após a migração:

```dart
final Widget chip = ChipTheme(
  data: ChipThemeData(
    side: BorderSide(
      color: Theme.of(context).colorScheme.outline
    ),
  ),
  child: ActionChip(
    label: const Text('action chip'), 
    onPressed: () {}
  )
);
```

## Cronograma

Implementado na versão: 3.26.0-0.0.pre<br>
Na versão estável: ainda não

## Referências

Documentação da API:

* [`ColorScheme`][]
* [`ThemeData`][]
* [`Chip`][]

PRs relevantes:

* [Atualizar tokens para v5.0.0][]
* [Atualizar tokens para v6.1.0][]

[`ColorScheme`]: {{site.api}}/flutter/material/ColorScheme-class.html
[`ThemeData`]: {{site.api}}/flutter/material/ThemeData-class.html
[`Chip`]: {{site.api}}/flutter/material/Chip-class.html
[Atualizar tokens para v5.0.0]: {{site.repo.flutter}}/pull/153385
[Atualizar tokens para v6.1.0]: {{site.repo.flutter}}/pull/153722
[não-destrutiva]: {{site.repo.flutter}}/flutter/blob/master/docs/contributing/Tree-hygiene.md#1-determine-if-your-change-is-a-breaking-change
