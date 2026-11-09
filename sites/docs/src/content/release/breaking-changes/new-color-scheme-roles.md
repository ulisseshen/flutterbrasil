---
title: Novos papéis de ColorScheme para o Material 3
description: >-
  O `ColorScheme` introduz novos papéis de cor para se alinhar melhor ao
  Material Design 3. O método `ColorScheme.fromSeed` também foi atualizado
  para oferecer suporte às novas cores.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Os novos papéis de cor no `ColorScheme` incluem sete superfícies e
contêineres baseados em tons e doze cores de destaque para os grupos
primary, secondary e tertiary.
Esta atualização descontinua três papéis de cor existentes:
`background`, `onBackground` e `surfaceVariant`.
O `ColorScheme` construído pelo método `ColorScheme.fromSeed` atualizado
agora gera valores diferentes em relação à versão anterior,
adequando-se às diretrizes do Material Design 3.

## Contexto {:#background}

As cores de superfície baseadas em tons incluem:

- `surfaceBright`
- `surfaceDim`
- `surfaceContainer`
- `surfaceContainerLow`
- `surfaceContainerLowest`
- `surfaceContainerHigh`
- `surfaceContainerHighest`

Essas mudanças ajudam a eliminar o uso de `surfaceTintColor` nos widgets
e substituem o antigo modelo baseado em opacidade, que aplicava uma
sobreposição com tonalidade sobre as superfícies conforme a sua elevação.

O `surfaceTintColor` padrão de todos os widgets agora é `null`, e a cor de
fundo padrão deles passou a ser baseada nas novas cores de superfície
baseadas em tons.

O `ColorScheme.fromSeed` também foi atualizado para usar o algoritmo mais
recente do pacote [Material color utilities][Material color utilities].
Essa mudança impede que o `ColorScheme` construído fique claro demais,
mesmo quando a cor de origem parece clara e tem alto croma
(contém pouco preto, branco e tons de cinza).

[Material color utilities]: {{site.pub-pkg}}/material_color_utilities

## Guia de migração {:#migration-guide}

As diferenças causadas pelo `ColorScheme.fromSeed` atualizado e pelos novos
papéis de cor devem ser pequenas e aceitáveis.
No entanto, ao fornecer uma cor de origem mais clara ao
`ColorScheme.fromSeed`, ele pode construir uma versão relativamente mais
escura do `ColorScheme`.
Para forçar a saída a continuar clara, defina
`dynamicSchemeVariant: DynamicSchemeVariant.fidelity` no
`ColorScheme.fromSeed`. Por exemplo:

Código antes da migração:

```dart
ColorScheme.fromSeed(
    seedColor: Color(0xFF0000FF), // Bright blue
)
```

Código depois da migração:

```dart
ColorScheme.fromSeed(
    seedColor: Color(0xFF0000FF), // Bright blue
    dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
)
```

O Material Design 3 remove 3 cores.

Para configurar a aparência dos componentes material,
`background` deve ser substituído por `surface`,
`onBackground` deve ser substituído por `onSurface`, e
`surfaceVariant` deve ser migrado para `surfaceContainerHighest`.

Código antes da migração:

```dart
final ColorScheme colorScheme = ColorScheme();
MaterialApp(
  theme: ThemeData(
    //...
    colorScheme: colorScheme.copyWith(
      background: myColor1,
      onBackground: myColor2,
      surfaceVariant: myColor3,
    ),
  ),
  //...
)
```

Código depois da migração:

```dart
final ColorScheme colorScheme = ColorScheme();
MaterialApp(
  theme: ThemeData(
    //...
    colorScheme: colorScheme.copyWith(
      surface: myColor1,
      onSurface: myColor2,
      surfaceContainerHighest: myColor3,
    ),
  ),
  //...
)
```

Componentes personalizados que consultavam `ColorScheme.background`,
`ColorScheme.onBackground` e `ColorScheme.surfaceVariant` podem consultar
`ColorScheme.surface`, `ColorScheme.onSurface` e
`ColorScheme.surfaceContainerHighest`.

Código antes da migração:

```dart
Color myColor1 = Theme.of(context).colorScheme.background;
Color myColor2 = Theme.of(context).colorScheme.onBackground;
Color myColor3 = Theme.of(context).colorScheme.surfaceVariant;
```

Código depois da migração:

```dart
Color myColor1 = Theme.of(context).colorScheme.surface;
Color myColor2 = Theme.of(context).colorScheme.onSurface;
Color myColor3 = Theme.of(context).colorScheme.surfaceContainerHighest;
```

## Linha do tempo {:#timeline}

Incluído na versão: 3.21.0-4.0.pre<br>
Na versão estável: 3.22.0

## Referências {:#references}

Issues relevantes:

* [Suporte aos papéis de superfície e de contêiner baseados em tons do ColorScheme][Support tone-based surface and surface container ColorScheme roles]
* [Suporte à variante fidelity do ColorScheme.fromSeed][Support fidelity variant for ColorScheme.fromSeed]

PRs relevantes:

* [Introdução de superfícies baseadas em tons e complementos de cores de destaque - Parte 1][Introduce tone-based surfaces and accent color add-ons - Part 1]
* [Introdução de superfícies baseadas em tons e complementos de cores de destaque - Parte 2][Introduce tone-based surfaces and accent color add-ons - Part 2]
* [Aprimoramento do ColorScheme.fromSeed com um novo parâmetro de variante][Enhance ColorScheme.fromSeed with a new variant parameter]

[Support tone-based surface and surface container ColorScheme roles]: {{site.repo.flutter}}/issues/115912
[Support fidelity variant for ColorScheme.fromSeed]: {{site.repo.flutter}}/issues/144649
[Introduce tone-based surfaces and accent color add-ons - Part 1]: {{site.repo.flutter}}/pull/142654
[Introduce tone-based surfaces and accent color add-ons - Part 2]: {{site.repo.flutter}}/pull/144273
[Enhance ColorScheme.fromSeed with a new variant parameter]: {{site.repo.flutter}}/pull/144805
