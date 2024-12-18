---
ia-translate: true
title: API Deprecadas Removidas Após a v3.10
description: >
  Após atingir o fim de vida útil, as seguintes APIs deprecadas
  foram removidas do Flutter.
---

## Resumo

De acordo com a [Política de Depreciação][] do Flutter,
APIs deprecadas que atingiram o fim de vida útil após o
lançamento da versão estável 3.10 foram removidas.

Todas as APIs afetadas foram compiladas nesta
fonte primária para auxiliar na migração. Uma
[folha de referência rápida][] também está disponível.

[Política de Depreciação]: {{site.repo.flutter}}/blob/master/docs/contributing/Tree-hygiene.md#deprecations
[folha de referência rápida]: /go/deprecations-removed-after-3-10

## Mudanças

Esta seção lista as depreciações, listadas pelo pacote e classe afetada.

### ThemeData.fixTextFieldOutlineLabel

Pacote: flutter
Suportado pelo Flutter Fix: sim

`ThemeData.fixTextFieldOutlineLabel` foi depreciado na v2.5.
Referências a esta propriedade podem ser removidas.

O `fixTextFieldOutlineLabel` era um sinalizador de migração temporário que permitia aos
usuários migrar graciosamente para um novo comportamento, em vez de experimentar uma
quebra brusca. Antes da depreciação, essa propriedade foi transicionada para o novo padrão
da correção do rótulo para campos de texto.

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

* [`ThemeData`][]

PRs relevantes:

* Depreciado em [#87281][]
* Removido em [#125893][]

[`ThemeData`]: {{site.api}}/flutter/material/ThemeData-class.html

[#87281]: {{site.repo.flutter}}/pull/87281
[#125893]: {{site.repo.flutter}}/pull/125893

---

### OverscrollIndicatorNotification.disallowGlow

Pacote: flutter
Suportado pelo Flutter Fix: sim

`OverscrollIndicatorNotification.disallowGlow` foi depreciado na v2.5.
A substituição é o método `disallowIndicator`.

O `disallowIndicator` foi criado como uma substituição para o método original
com a introdução do `StretchingOverscrollIndicator`. Anteriormente,
o `GlowingOverscrollIndicator` era o único tipo a despachar
`OverscrollIndicatorNotification`s, e então o método foi atualizado para melhor
refletir vários tipos de indicadores.

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

* [`OverscrollIndicatorNotification`][]
* [`StretchingOverscrollIndicator`][]
* [`GlowingOverscrollIndicator`][]

PRs relevantes:

* Depreciado em [#87839][]
* Removido em [#127042][]

[`OverscrollIndicatorNotification`]: {{site.api}}/flutter/widgets/OverscrollIndicatorNotification-class.html
[`StretchingOverscrollIndicator`]: {{site.api}}/flutter/widgets/StretchingOverscrollIndicator-class.html
[`GlowingOverscrollIndicator`]: {{site.api}}/flutter/widgets/GlowingOverscrollIndicator-class.html

[#87839]: {{site.repo.flutter}}/pull/87839
[#127042]: {{site.repo.flutter}}/pull/127042

---

### ColorScheme primaryVariant & secondaryVariant

Pacote: flutter
Suportado pelo Flutter Fix: sim

`ColorScheme.primaryVariant` e `ColorScheme.secondaryVariant` foram depreciados
na v2.6. As substituições são `ColorScheme.primaryContainer` e
`ColorScheme.secondaryContainer`, respectivamente.

Essas mudanças foram feitas para se alinhar com a especificação do Material Design
atualizada para `ColorScheme`. As atualizações para `ColorScheme` são abordadas mais extensivamente
no documento de design [ColorScheme para Material 3][].

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

Documento de Design:

* [ColorScheme para Material 3][]

Documentação da API:

* [`ColorScheme`][]

PRs relevantes:

* Depreciado em [#93427][]
* Removido em [#127124][]

[ColorScheme para Material 3]: /go/colorscheme-m3

[`ColorScheme`]: {{site.api}}/flutter/material/ColorScheme-class.html

[#93427]: {{site.repo.flutter}}/pull/93427
[#127124]: {{site.repo.flutter}}/pull/127124

---

### ThemeData.primaryColorBrightness

Pacote: flutter
Suportado pelo Flutter Fix: sim

`ThemeData.primaryColorBrightness` foi depreciado na v2.6 e não tem sido usado
pelo framework desde então. As referências devem ser removidas. O `Brightness` é
agora extrapolado do `ThemeData.primaryColor` se `ThemeData.brightness` não
tiver sido fornecido explicitamente.

Essa mudança foi feita como parte da atualização do `Theme` para corresponder às novas
diretrizes do Material Design. A atualização geral do sistema de temas, incluindo a
remoção do `primaryColorBrightness` é discutida mais extensivamente no documento de
design [Atualizações do Sistema de Temas Material][].

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

Documento de Design:

* [Atualizações do Sistema de Temas Material][]

Documentação da API:

* [`Theme`][]
* [`ThemeData`][]
* [`Brightness`][]

PRs relevantes:

* Depreciado em [#93396][]
* Removido em [#127238][]

[Atualizações do Sistema de Temas Material]: /go/material-theme-system-updates

[`Theme`]: {{site.api}}/flutter/material/Theme-class.html
[`ThemeData`]: {{site.api}}/flutter/material/Theme-class.html
[`Brightness`]: {{site.api}}/flutter/dart-ui/Brightness.html

[#93396]: {{site.repo.flutter}}/pull/93396
[#127238]: {{site.repo.flutter}}/pull/127238

---

### RawScrollbar e atualizações de subclasses

Pacote: flutter
Suportado pelo Flutter Fix: sim

A propriedade `isAlwaysShown` de `RawScrollbar`, `Scrollbar`,
`ScrollbarThemeData` e `CupertinoScrollbar` foi depreciada na v2.9. A
substituição em todos os casos é `thumbVisibility`.

Essa mudança foi feita, pois `isAlwaysShown` sempre se referia ao scrollbar
thumb. Com a adição de uma trilha de scrollbar e várias configurações para
sua visibilidade em resposta à passagem e arrasto do mouse, renomeamos esta
propriedade para uma API mais clara.

Além disso, `Scrollbar.hoverThickness` também foi depreciado na v2.9. Sua
substituição é o `MaterialStateProperty` `ScrollbarThemeData.thickness`.

Essa mudança foi feita para permitir que a espessura de um `Scrollbar` responda a todos
os tipos de estados, incluindo e além de apenas a passagem do mouse. O uso de
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

* [`RawScrollbar`][]
* [`Scrollbar`][]
* [`CupertinoScrollbar`][]
* [`ScrollbarThemeData`][]
* [`MaterialStateProperty`][]
* [`MaterialState`][]

PRs relevantes:

* Depreciado em [#96957][]
* Depreciado em [#97173][]
* Removido em [#127351][]


[`RawScrollbar`]: {{site.api}}/flutter/widgets/RawScrollbar-class.html
[`Scrollbar`]: {{site.api}}/flutter/material/Scrollbar-class.html
[`CupertinoScrollbar`]: {{site.api}}/flutter/cupertino/CupertinoScrollbar-class.html
[`ScrollbarThemeData`]: {{site.api}}/flutter/material/ScrollbarThemeData-class.html
[`MaterialStateProperty`]: {{site.api}}/flutter/material/MaterialStateProperty-class.html
[`MaterialState`]: {{site.api}}/flutter/material/MaterialState.html

[#96957]: {{site.repo.flutter}}/pull/96957
[#97173]: {{site.repo.flutter}}/pull/97173
[#127351]: {{site.repo.flutter}}/pull/127351

---

### AnimationSheetBuilder display e sheetSize

Pacote: flutter_test
Suportado pelo Flutter Fix: sim

Os métodos `display` e `sheetSize` de `AnimationSheetBuilder` foram depreciados
na v2.3. A substituição é o método `collate`.

A etapa de saída de `AnimationSheetBuilder` anteriormente exigia que esses dois métodos
fossem chamados, mas agora é simplificada por meio de uma única chamada para `collate`.

A função `collate` junta as imagens diretamente e retorna assincronamente uma imagem.
Ela requer menos boilerplate e produz imagens menores, sem qualquer comprometimento da qualidade.

**Guia de migração**

[Guia de migração aprofundado disponível]

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

[Guia de migração aprofundado disponível]: /release/breaking-changes/animation-sheet-builder-display

**Referências**

Documentação da API:

* [`AnimationSheetBuilder`][]

PRs relevantes:

* Depreciado em [#83337][]
* Removido em [#129657][]

[`AnimationSheetBuilder`]: {{site.api}}/flutter/flutter_test/AnimationSheetBuilder-class.html

[#83337]: {{site.repo.flutter}}/pull/83337
[#129657]: {{site.repo.flutter}}/pull/129657

---

---

### Lógica de timeout do flutter_test

Pacote: flutter_test
Suportado pelo Flutter Fix: não

As seguintes APIs relacionadas à lógica de timeout em testes foram depreciadas
na v2.6. Não há substituições e as referências devem ser removidas, exceto para
o parâmetro `initialTimeout` de `testWidgets`, que é substituído pelo uso de
`timeout`.

* `TestWidgetsFlutterBinding.addTime`
* Método `TestWidgetsFlutterBinding.runAsync` - parâmetro `additionalTime`
* Método `TestWidgetsFlutterBinding.runTest` - parâmetro `timeout`
* Método `AutomatedTestWidgetsFlutterBinding.runTest` - parâmetro `timeout`
* Método `LiveTestWidgetsFlutterBinding.runTest` - parâmetro `timeout`
* Método `testWidgets` - parâmetro `initialTime`

Foi descoberto que eles causavam instabilidade nos testes e não estavam em uso por
clientes testados.

Desde que foram depreciados, o uso desses parâmetros não teve efeito nos testes,
portanto, remover as referências não deve ter efeito nas bases de código existentes.

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

* [`testWidgets`][]
* [`TestWidgetsFlutterBinding`][]
* [`AutomatedTestWidgetsFlutterBinding`][]
* [`LiveTestWidgetsFlutterBinding`][]

PRs relevantes:

* Depreciado em [#89952][]
* Removido em [#129663][]

[`testWidgets`]: {{site.api}}/flutter/flutter_test/testWidgets.html
[`TestWidgetsFlutterBinding`]: {{site.api}}/flutter/flutter_test/TestWidgetsFlutterBinding-class.html
[`AutomatedTestWidgetsFlutterBinding`]: {{site.api}}/flutter/flutter_test/AutomatedTestWidgetsFlutterBinding-class.html
[`LiveTestWidgetsFlutterBinding`]: {{site.api}}/flutter/flutter_test/LiveTestWidgetsFlutterBinding-class.html

[#89952]: {{site.repo.flutter}}/pull/89952
[#129663]: {{site.repo.flutter}}/pull/129663

---

## Linha do tempo

Na versão estável: 3.13.0
