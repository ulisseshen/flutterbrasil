---
ia-translate: true
title: Introduzir novas funções de ColorScheme para Material 3
description: >-
  'ColorScheme' introduz novas funções de cores para
  melhor se alinhar com o Material Design 3.
  O método 'ColorScheme.fromSeed' também é atualizado para
  suportar as cores recém-adicionadas.
---

## Resumo

Novas funções de cores em `ColorScheme` incluem
sete superfícies e containers baseados em tons, e doze cores de destaque para
grupos primários, secundários e terciários.
Esta atualização torna obsoletas três funções de cores existentes:
`background`, `onBackground` e `surfaceVariant`.
O `ColorScheme` construído pelo método `ColorScheme.fromSeed` atualizado agora
gera valores diferentes em comparação com a versão anterior,
adaptando-se às diretrizes do Material Design 3.

## Contexto

As cores de superfície baseadas em tons incluem:

- `surfaceBright`
- `surfaceDim`
- `surfaceContainer`
- `surfaceContainerLow`
- `surfaceContainerLowest`
- `surfaceContainerHigh`
- `surfaceContainerHighest`

Estas mudanças ajudam a eliminar o uso de `surfaceTintColor` dos widgets, e
substitui o antigo modelo baseado em opacidade que aplicava uma sobreposição
colorida sobre as superfícies com base em sua elevação.

O `surfaceTintColor` padrão para todos os widgets agora é `null` e
sua cor de fundo padrão agora é
baseada nas novas cores de superfície baseadas em tons.

`ColorScheme.fromSeed` também foi atualizado para usar o algoritmo mais recente
do pacote [Material color utilities][].
Essa mudança impede que o `ColorScheme` construído seja muito brilhante,
mesmo que a cor de origem pareça brilhante e
tenha um croma alto (continha pouco preto, branco e tons de cinza).

[Material color utilities]: {{site.pub-pkg}}/material_color_utilities

## Guia de migração

As diferenças causadas pelo `ColorScheme.fromSeed` atualizado e
as novas funções de cores devem ser pequenas e aceitáveis.
No entanto, ao fornecer uma cor inicial mais brilhante para `ColorScheme.fromSeed`,
ele pode construir uma versão relativamente mais escura de `ColorScheme`.
Para forçar a saída a ainda ser brilhante,
defina `dynamicSchemeVariant: DynamicSchemeVariant.fidelity` em
`ColorScheme.fromSeed`. Por exemplo:

Código antes da migração:

```dart
ColorScheme.fromSeed(
    seedColor: Color(0xFF0000FF), // Azul brilhante
)
```

Código após a migração:

```dart
ColorScheme.fromSeed(
    seedColor: Color(0xFF0000FF), // Azul brilhante
    dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
)
```

O Material Design 3 remove 3 cores.

Para configurar a aparência dos componentes do material,
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

Código após a migração:

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

Componentes personalizados que costumavam procurar `ColorScheme.background`,
`ColorScheme.onBackground` e `ColorScheme.surfaceVariant` podem procurar
`ColorScheme.surface`, `ColorScheme.onSurface` e
`ColorScheme.surfaceContainerHighest` em vez disso.

Código antes da migração:

```dart
Color myColor1 = Theme.of(context).colorScheme.background;
Color myColor2 = Theme.of(context).colorScheme.onBackground;
Color myColor3 = Theme.of(context).colorScheme.surfaceVariant;
```

Código após a migração:

```dart
Color myColor1 = Theme.of(context).colorScheme.surface;
Color myColor2 = Theme.of(context).colorScheme.onSurface;
Color myColor3 = Theme.of(context).colorScheme.surfaceContainerHighest;
```

## Cronograma

Implementado na versão: 3.21.0-4.0.pre<br>
Na versão estável: 3.22.0

## Referências

Problemas relevantes:

* [Suporte para funções de ColorScheme de superfície baseada em tom e container de superfície][]
* [Suporte para variante de fidelidade para ColorScheme.fromSeed][]

PRs relevantes:

* [Introduzir superfícies baseadas em tom e complementos de cores de destaque - Parte 1][]
* [Introduzir superfícies baseadas em tom e complementos de cores de destaque - Parte 2][]
* [Aprimorar ColorScheme.fromSeed com um novo parâmetro de variante][]

[Suporte para funções de ColorScheme de superfície baseada em tom e container de superfície]: {{site.repo.flutter}}/issues/115912
[Suporte para variante de fidelidade para ColorScheme.fromSeed]: {{site.repo.flutter}}/issues/144649
[Introduzir superfícies baseadas em tom e complementos de cores de destaque - Parte 1]: {{site.repo.flutter}}/pull/142654
[Introduzir superfícies baseadas em tom e complementos de cores de destaque - Parte 2]: {{site.repo.flutter}}/pull/144273
[Aprimorar ColorScheme.fromSeed com um novo parâmetro de variante]: {{site.repo.flutter}}/pull/144805
