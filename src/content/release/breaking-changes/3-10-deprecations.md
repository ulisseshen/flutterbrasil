---
ia-translate: true
title: API descontinuada removida após v3.10
description: >
  Após atingir o fim da vida útil, as seguintes APIs descontinuadas
  foram removidas do Flutter.
---

## Resumo

De acordo com a [Deprecation Policy][Deprecation Policy] do Flutter,
APIs descontinuadas que atingiram o fim da vida útil após a
versão estável 3.10 foram removidas.

Todas as APIs afetadas foram compiladas nesta
fonte primária para auxiliar na migração. Uma
[quick reference sheet][quick reference sheet] também está disponível.

[Deprecation Policy]: {{site.repo.flutter}}/blob/main/docs/contributing/Tree-hygiene.md#deprecations
[quick reference sheet]: /go/deprecations-removed-after-3-10

## Mudanças

Esta seção lista as descontinuações, listadas pelo pacote e classe afetada.

### ThemeData.fixTextFieldOutlineLabel

Package: flutter
Suportado pelo Flutter Fix: sim

`ThemeData.fixTextFieldOutlineLabel` foi descontinuado na v2.5.
Referências a esta propriedade podem ser removidas.

O `fixTextFieldOutlineLabel` era um sinalizador de migração temporário que permitia aos usuários
migrar graciosamente para um novo comportamento em vez de experimentar uma quebra drástica.
Antes de ser descontinuado, esta propriedade foi transicionada para o novo padrão a partir da
correção para o label de campos de texto.

**Guia de migração**

Código antes da migração:

```dart
var themeData = ThemeData(
  fixTextFieldOutlineLabel: true,
);
```

Código após a migração:

```dart
var themeData = ThemeData(
);
```

**Referências**

Documentação da API:

* [`ThemeData`][ThemeData]

PRs relevantes:

* Descontinuado em [#87281][#87281]
* Removido em [#125893][#125893]

[ThemeData]: {{site.api}}/flutter/material/ThemeData-class.html

[#87281]: {{site.repo.flutter}}/pull/87281
[#125893]: {{site.repo.flutter}}/pull/125893

---

### OverscrollIndicatorNotification.disallowGlow

Package: flutter
Suportado pelo Flutter Fix: sim

`OverscrollIndicatorNotification.disallowGlow` foi descontinuado na v2.5.
A substituição é o método `disallowIndicator`.

O `disallowIndicator` foi criado como substituto para o método original
com a introdução do `StretchingOverscrollIndicator`. Anteriormente,
o `GlowingOverscrollIndicator` era o único tipo a despachar
`OverscrollIndicatorNotification`s, e então o método foi atualizado para melhor
refletir múltiplos tipos de indicadores.

**Guia de migração**

Código antes da migração:

```dart
bool _handleOverscrollIndicatorNotification(OverscrollIndicatorNotification notification) {
  notification.disallowGlow();
  return false;
}
```

Código após a migração:

```dart
bool _handleOverscrollIndicatorNotification(OverscrollIndicatorNotification notification) {
  notification.disallowIndicator();
  return false;
}
```

**Referências**

Documentação da API:

* [`OverscrollIndicatorNotification`][OverscrollIndicatorNotification]
* [`StretchingOverscrollIndicator`][StretchingOverscrollIndicator]
* [`GlowingOverscrollIndicator`][GlowingOverscrollIndicator]

PRs relevantes:

* Descontinuado em [#87839][#87839]
* Removido em [#127042][#127042]

[OverscrollIndicatorNotification]: {{site.api}}/flutter/widgets/OverscrollIndicatorNotification-class.html
[StretchingOverscrollIndicator]: {{site.api}}/flutter/widgets/StretchingOverscrollIndicator-class.html
[GlowingOverscrollIndicator]: {{site.api}}/flutter/widgets/GlowingOverscrollIndicator-class.html

[#87839]: {{site.repo.flutter}}/pull/87839
[#127042]: {{site.repo.flutter}}/pull/127042

---

### ColorScheme primaryVariant & secondaryVariant

Package: flutter
Suportado pelo Flutter Fix: sim

`ColorScheme.primaryVariant` e `ColorScheme.secondaryVariant` foram descontinuados
na v2.6. As substituições são `ColorScheme.primaryContainer` e
`ColorScheme.secondaryContainer`, respectivamente.

Essas mudanças foram feitas para alinhar com a especificação atualizada do Material Design
para `ColorScheme`. As atualizações para `ColorScheme` são cobertas mais extensivamente no
documento de design [ColorScheme for Material 3][ColorScheme for Material 3].

**Guia de migração**

Código antes da migração:

```dart
var colorScheme = ColorScheme(
  primaryVariant: Colors.blue,
  secondaryVariant: Colors.amber,
);
var primaryColor = colorScheme.primaryVariant;
var secondaryColor = colorScheme.secondaryVariant;
```

Código após a migração:

```dart
var colorScheme = ColorScheme(
  primaryContainer: Colors.blue,
  secondaryContainer: Colors.amber,
);
var primaryColor = colorScheme.primaryContainer;
var secondaryColor = colorScheme.secondaryContainer;
```

**Referências**

Documento de design:

* [ColorScheme for Material 3][ColorScheme for Material 3]

Documentação da API:

* [`ColorScheme`][ColorScheme]

PRs relevantes:

* Descontinuado em [#93427][#93427]
* Removido em [#127124][#127124]

[ColorScheme for Material 3]: /go/colorscheme-m3

[ColorScheme]: {{site.api}}/flutter/material/ColorScheme-class.html

[#93427]: {{site.repo.flutter}}/pull/93427
[#127124]: {{site.repo.flutter}}/pull/127124

---

### ThemeData.primaryColorBrightness

Package: flutter
Suportado pelo Flutter Fix: sim

`ThemeData.primaryColorBrightness` foi descontinuado na v2.6, e não tem sido usado
pelo framework desde então. Referências devem ser removidas. O `Brightness` é
agora extrapolado de `ThemeData.primaryColor` se `ThemeData.brightness` não foi
explicitamente fornecido.

Esta mudança foi feita como parte da atualização do `Theme` para corresponder às novas
diretrizes do Material Design. A atualização geral do sistema de temas, incluindo a
remoção de `primaryColorBrightness` é discutida mais extensivamente no
documento de design [Material Theme System Updates][Material Theme System Updates].

**Guia de migração**

Código antes da migração:

```dart
var themeData = ThemeData(
  primaryColorBrightness: Brightness.dark,
);
```

Código após a migração:

```dart
var themeData = ThemeData(
);
```

**Referências**

Documento de design:

* [Material Theme System Updates][Material Theme System Updates]

Documentação da API:

* [`Theme`][Theme]
* [`ThemeData`][ThemeData2]
* [`Brightness`][Brightness]

PRs relevantes:

* Descontinuado em [#93396][#93396]
* Removido em [#127238][#127238]

[Material Theme System Updates]: /go/material-theme-system-updates

[Theme]: {{site.api}}/flutter/material/Theme-class.html
[ThemeData2]: {{site.api}}/flutter/material/Theme-class.html
[Brightness]: {{site.api}}/flutter/dart-ui/Brightness.html

[#93396]: {{site.repo.flutter}}/pull/93396
[#127238]: {{site.repo.flutter}}/pull/127238

---

### RawScrollbar & subclasses updates

Package: flutter
Suportado pelo Flutter Fix: sim

A propriedade `isAlwaysShown` de `RawScrollbar`, `Scrollbar`,
`ScrollbarThemeData` e `CupertinoScrollbar` foi descontinuada na v2.9. A
substituição em todos os casos é `thumbVisibility`.

Esta mudança foi feita já que `isAlwaysShown` sempre se referia ao controle
da scrollbar. Com a adição de uma trilha de scrollbar, e configurações variadas para
sua visibilidade em resposta ao hovering e arrastar do mouse, renomeamos esta
propriedade para uma API mais clara.

Adicionalmente, `Scrollbar.hoverThickness` também foi descontinuado na v2.9. Sua
substituição é o `MaterialStateProperty` `ScrollbarThemeData.thickness`.

Esta mudança foi feita para permitir que a espessura de uma `Scrollbar` responda a todos os
tipos de estados, incluindo e além de apenas hovering. O uso de
`MaterialStateProperties` também corresponde à convenção na biblioteca material de
configurar widgets com base em seu estado, em vez de enumerar propriedades para
cada permutação de estados interativos.

**Guia de migração**

Código antes da migração:

```dart
var rawScrollbar = RawScrollbar(
  isAlwaysShown: true,
);
var scrollbar = Scrollbar(
  isAlwaysShown: true,
  hoverThickness: 15.0,
);
var cupertinoScrollbar = CupertinoScrollbar(
  isAlwaysShown: true,
);
var scrollbarThemeData = ScrollbarThemeData(
  isAlwaysShown: true,
);
```

Código após a migração:

```dart
var rawScrollbar = RawScrollbar(
  thumbVisibility: true,
);
var scrollbar = Scrollbar(
  thumbVisibility: true,
);
var cupertinoScrollbar = CupertinoScrollbar(
  thumbVisibility: true,
);
var scrollbarThemeData = ScrollbarThemeData(
  thumbVisibility: true,
  thickness: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
    return states.contains(MaterialState.hovered) ? null : 15.0;
  }),
);
```

**Referências**

Documentação da API:

* [`RawScrollbar`][RawScrollbar]
* [`Scrollbar`][Scrollbar]
* [`CupertinoScrollbar`][CupertinoScrollbar]
* [`ScrollbarThemeData`][ScrollbarThemeData]
* [`MaterialStateProperty`][MaterialStateProperty]
* [`MaterialState`][MaterialState]

PRs relevantes:

* Descontinuado em [#96957][#96957]
* Descontinuado em [#97173][#97173]
* Removido em [#127351][#127351]


[RawScrollbar]: {{site.api}}/flutter/widgets/RawScrollbar-class.html
[Scrollbar]: {{site.api}}/flutter/material/Scrollbar-class.html
[CupertinoScrollbar]: {{site.api}}/flutter/cupertino/CupertinoScrollbar-class.html
[ScrollbarThemeData]: {{site.api}}/flutter/material/ScrollbarThemeData-class.html
[MaterialStateProperty]: {{site.api}}/flutter/material/MaterialStateProperty-class.html
[MaterialState]: {{site.api}}/flutter/material/MaterialState.html

[#96957]: {{site.repo.flutter}}/pull/96957
[#97173]: {{site.repo.flutter}}/pull/97173
[#127351]: {{site.repo.flutter}}/pull/127351

---

### AnimationSheetBuilder display & sheetSize

Package: flutter_test
Suportado pelo Flutter Fix: sim

Os métodos `display` e `sheetSize` de `AnimationSheetBuilder` foram descontinuados
na v2.3. A substituição é o método `collate`.

A etapa de saída de `AnimationSheetBuilder` anteriormente exigia que esses dois métodos fossem
chamados, mas agora está simplificada através de uma única chamada a `collate`.

A função `collate` coloca diretamente as imagens juntas e assincronamente
retorna uma imagem. Ela requer menos código boilerplate, e gera imagens menores
sem nenhum compromisso com a qualidade.

**Guia de migração**

[Guia de migração detalhado disponível][In-depth migration guide available]

Código antes da migração:

```dart
final AnimationSheetBuilder animationSheet = AnimationSheetBuilder(
    frameSize: const Size(40, 40)
);

await tester.pumpFrames(animationSheet.record(
  const Directionality(
    textDirection: TextDirection.ltr,
    child: Padding(
      padding: EdgeInsets.all(4),
      child: CircularProgressIndicator(),
    ),
  ),
), const Duration(seconds: 2));

tester.binding.setSurfaceSize(animationSheet.sheetSize());

final Widget display = await animationSheet.display();
await tester.pumpWidget(display);

await expectLater(
  find.byWidget(display),
  matchesGoldenFile('material.circular_progress_indicator.indeterminate.png'),
);
```

Código após a migração:

```dart
final AnimationSheetBuilder animationSheet = AnimationSheetBuilder(
    frameSize: const Size(40, 40)
);

await tester.pumpFrames(animationSheet.record(
  const Directionality(
    textDirection: TextDirection.ltr,
    child: Padding(
      padding: EdgeInsets.all(4),
      child: CircularProgressIndicator(),
    ),
  ),
), const Duration(seconds: 2));

await expectLater(
  animationSheet.collate(20),
  matchesGoldenFile('material.circular_progress_indicator.indeterminate.png'),
);
```

[In-depth migration guide available]: /release/breaking-changes/animation-sheet-builder-display

**Referências**

Documentação da API:

* [`AnimationSheetBuilder`][AnimationSheetBuilder]

PRs relevantes:

* Descontinuado em [#83337][#83337]
* Removido em [#129657][#129657]

[AnimationSheetBuilder]: {{site.api}}/flutter/flutter_test/AnimationSheetBuilder-class.html

[#83337]: {{site.repo.flutter}}/pull/83337
[#129657]: {{site.repo.flutter}}/pull/129657

---

---

### flutter_test timeout logic

Package: flutter_test
Suportado pelo Flutter Fix: não

As seguintes APIs relacionadas à lógica de timeout em testes foram descontinuadas
na v2.6. Não há substituições, e referências devem ser removidas, exceto para
o parâmetro `initialTimeout` de `testWidgets`, que é substituído usando
`timeout`.

* `TestWidgetsFlutterBinding.addTime`
* `TestWidgetsFlutterBinding.runAsync` method - `additionalTime` parameter
* `TestWidgetsFlutterBinding.runTest` method - `timeout` parameter
* `AutomatedTestWidgetsFlutterBinding.runTest` method - `timeout` parameter
* `LiveTestWidgetsFlutterBinding.runTest` method - `timeout` parameter
* `testWidgets` method - `initialTime` parameter

Estes foram encontrados causando instabilidade nos testes, e não estavam em uso por
clientes testados.

Desde que foram descontinuados, o uso desses parâmetros não teve efeito nos testes, então
remover referências não deve ter efeito nas bases de código existentes.

**Guia de migração**


Código antes da migração:

```dart
testWidgets('Test', (_) {}, initialTimeout:  Duration(seconds: 5));
```

Código após a migração:

```dart
testWidgets('Test', (_) {}, timeout:  Timeout(Duration(seconds: 5)));
```

**Referências**

Documentação da API:

* [`testWidgets`][testWidgets]
* [`TestWidgetsFlutterBinding`][TestWidgetsFlutterBinding]
* [`AutomatedTestWidgetsFlutterBinding`][AutomatedTestWidgetsFlutterBinding]
* [`LiveTestWidgetsFlutterBinding`][LiveTestWidgetsFlutterBinding]

PRs relevantes:

* Descontinuado em [#89952][#89952]
* Removido em [#129663][#129663]

[testWidgets]: {{site.api}}/flutter/flutter_test/testWidgets.html
[TestWidgetsFlutterBinding]: {{site.api}}/flutter/flutter_test/TestWidgetsFlutterBinding-class.html
[AutomatedTestWidgetsFlutterBinding]: {{site.api}}/flutter/flutter_test/AutomatedTestWidgetsFlutterBinding-class.html
[LiveTestWidgetsFlutterBinding]: {{site.api}}/flutter/flutter_test/LiveTestWidgetsFlutterBinding-class.html

[#89952]: {{site.repo.flutter}}/pull/89952
[#129663]: {{site.repo.flutter}}/pull/129663

---

## Cronograma

Na versão estável: 3.13.0
