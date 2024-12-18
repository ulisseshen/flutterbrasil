---
ia-translate: true
title: API Deprecada Removida Após a v3.13
description: >-
  Após atingir o fim de vida útil, as seguintes APIs depreciadas foram
  removidas do Flutter.
---

## Resumo

De acordo com a [Política de Depreciação][] do Flutter, as APIs depreciadas
que atingiram o fim de vida útil após o lançamento da versão estável 3.13
foram removidas.

Todas as APIs afetadas foram compiladas nesta fonte primária para auxiliar
na migração. Para ajudar ainda mais na sua migração, confira esta
[folha de referência rápida][].

[Política de Depreciação]: {{site.repo.flutter}}/blob/master/docs/contributing/Tree-hygiene.md#deprecations
[folha de referência rápida]: /go/deprecations-removed-after-3-13

## Mudanças

Esta seção lista as depreciações por pacote e classe afetada.

### `useDeleteButtonTooltip` das Classes Chip

Pacote: flutter
Suportado pelo Flutter Fix: sim

A propriedade `useDeleteButtonTooltip` das seguintes classes foi depreciada
na v2.10:

*   `DeletableChipAttributes`
*   `Chip`
*   `RawChip`
*   `InputChip`

`deleteButtonTooltipMessage` substitui `useDeleteButtonTooltip`. Esta mudança
simplificou a API, já que fornecer uma String vazia para `deleteButtonTooltipMessage`
alcança o mesmo resultado que definir a propriedade original `useDeleteButtonTooltip`
como false. Quando `deleteButtonTooltipMessage` não está definido, o
`MaterialLocalizations.deleteButtonTooltip` é usado por padrão.

O documento de design [Depreciar `useDeleteButtonTooltip` para Chips][]
aborda esta atualização para chips e tooltips com mais detalhes.
Para saber mais, confira o [guia de migração de chips e tooltips][].

[Depreciar `useDeleteButtonTooltip` para Chips]: https://docs.google.com/document/d/1wc9ot7T2E7hJubYxEWMX230a79wYSiFey4BHxnEzHtw/edit?usp=sharing&resourcekey=0-Bo7KPqEtkWgZcSuRCqwQ5w
[guia de migração de chips e tooltips]: /release/breaking-changes/chip-usedeletebuttontooltip-migration

**Guia de migração**

Código antes da migração:

```dart
Chip(useDeleteButtonTooltip: false);
InputChip(useDeleteButtonTooltip: true);
RawChip rawChip = RawChip();
rawChip.useDeleteButtonTooltip;
```

Código após a migração:

```dart
Chip(deleteButtonTooltipMessage: '');
InputChip();
RawChip rawChip = RawChip();
rawChip.deleteButtonTooltipMessage;
```

**Referências**

Documentação da API:

*   [`DeletableChipAttributes`][]
*   [`Chip`][]
*   [`RawChip`][]
*   [`InputChip`][]
*   [`MaterialLocalizations.deleteButtonTooltip`][]

PRs relevantes:

*   Depreciado em [#96174][]
*   Removido em [#134486][]

[`DeletableChipAttributes`]: {{site.api}}/flutter/material/DeletableChipAttributes-class.html
[`Chip`]: {{site.api}}/flutter/material/Chip-class.html
[`RawChip`]: {{site.api}}/flutter/material/RawChip-class.html
[`InputChip`]: {{site.api}}/flutter/material/InputChip-class.html
[`MaterialLocalizations.deleteButtonTooltip`]: {{site.api}}/flutter/material/MaterialLocalizations/deleteButtonTooltip.html

[#96174]: {{site.repo.flutter}}/pull/96174
[#134486]: {{site.repo.flutter}}/pull/134486

---

### MaterialButtonWithIconMixin

Pacote: flutter
Suportado pelo Flutter Fix: não

A propriedade `MaterialButtonWithIconMixin` foi depreciada na v2.11.

Com a introdução das novas classes de botões `TextButton`, `OutlinedButton` e
`ElevatedButton`, este mixin não é mais usado. Uma versão anterior removeu
as classes de botões antigas que usavam este mixin. Como resultado, este mixin
não afeta mais nenhuma classe que possa usá-lo.

**Guia de migração**

Código antes da migração:

```dart
class MyButtonClass extends StatelessWidget with MaterialButtonWithIconMixin {
  // ...
}
```

Código após a migração:

```dart
class MyButtonClass extends StatelessWidget {
  // ...
}
```

**Referências**

PRs relevantes:

*   Depreciado em [#99088][]
*   Removido em [#133173][]

[#99088]: {{site.repo.flutter}}/pull/99088
[#133173]: {{site.repo.flutter}}/pull/133173

---

### `PlatformsViewsService.synchronizeToNativeViewHierarchy`

Pacote: flutter
Suportado pelo Flutter Fix: não

O método estático `synchronizeToNativeViewHierarchy` de `PlatformsViewsService`
foi depreciado na v2.11.

Durante o período de depreciação, o método era uma função no-op, pois não era
mais necessário chamar para melhorias de desempenho. As referências ao método
devem ser removidas e não impactarão o aplicativo.

**Guia de migração**

Código antes da migração:

```dart
await PlatformsViewsService.synchronizeToNativeViewHierarchy(false);
```

Código após a migração:

```dart
```

**Referências**

Documentação da API:

*   [`PlatformViewsService`][]

PRs relevantes:

*   Depreciado em [#100990][]
*   Removido em [#133175][]

[`PlatformViewsService`]: {{site.api}}/flutter/services/PlatformViewsService-class.html

[#100990]: {{site.repo.flutter}}/pull/100990
[#133175]: {{site.repo.flutter}}/pull/133175

---

### `TextSelectionOverlay.fadeDuration`

Pacote: flutter
Suportado pelo Flutter Fix: sim

A propriedade estática `fadeDuration` de `TextSelectionOverlay` foi depreciada
na v2.12.

A propriedade `SelectionOverlay.fadeDuration` substitui
`TextSelectionOverlay.fadeDuration`. Com a refatoração de `TextSelectionOverlay`,
`SelectionOverlay` foi adicionado como um widget mais genérico sem a dependência
específica de `RenderEditable`.

**Guia de migração**

Código antes da migração:

```dart
TextSelectionOverlay.fadeDuration;
```

Código após a migração:

```dart
SelectionOverlay.fadeDuration;
```

**Referências**

Documentação da API:

*   [`TextSelectionOverlay`][]
*   [`SelectionOverlay`][]

PRs relevantes:

*   Depreciado em [#100381][]
*   Removido em [#134485][]

[`TextSelectionOverlay`]: {{site.api}}/flutter/widgets/TextSelectionOverlay-class.html
[`SelectionOverlay`]: {{site.api}}/flutter/widgets/SelectionOverlay-class.html

[#100381]: {{site.repo.flutter}}/pull/100381
[#134485]: {{site.repo.flutter}}/pull/134485

---

### `androidOverscrollIndicator`

Pacote: flutter
Suportado pelo Flutter Fix: não

A propriedade `androidOverscrollIndicator` das seguintes classes foi
depreciada na v2.13:

*   `ScrollBehavior`
*   `MaterialScrollBehavior`
*   `ThemeData`

Esta flag foi introduzida para permitir que os usuários configurassem widgets
de rolagem para usar o `GlowingOverscrollIndicator` ou o
`StretchingOvercrollIndicator`. Foi depreciado em favor da flag
`ThemeData.useMaterial3` à medida que o framework introduziu mais suporte para
widgets com estilo Material 3.

Como `ThemeData.useMaterial3` é `true` por padrão, o
`StretchingOverscrollIndicator` é aplicado por padrão. Definir este valor
como `false` aplicará um `GlowingOverscrollIndicator` em vez disso.

Alternativamente, o método `buildOverscrollIndicator` de `ScrollBehavior` ou
`MaterialScrollBehavior` pode ser substituído para alterar ainda mais a
aparência dos indicadores de overscroll.

**Guia de migração**

Código antes da migração:

```dart
MaterialApp(
  scrollBehavior: MaterialScrollBehavior(
    androidOverscrollIndicator: AndroidOverscrollIndicator.glow,
  ),
  //...
);

MaterialApp(
  scrollBehavior: ScrollBehavior(
    androidOverscrollIndicator: AndroidOverscrollIndicator.glow,
  ),
  //...
);

MaterialApp(
  theme: Theme.light().copyWith(
    androidOverscrollIndicator: AndroidOverscrollIndicator.glow,
  ),
  //...
);
```

Código após a migração:

```dart
MaterialApp(
  theme: Theme.light().copyWith(
    // o padrão é true e indicador de alongamento,
    // false resulta em indicador brilhante
    useMaterial3: false,
  ),
  //...
);
```

**Referências**

Documentação da API:

*   [`ScrollBehavior`][]
*   [`MaterialScrollBehavior`][]
*   [`ThemeData`][]
*   [`GlowingOverscrollIndicator`][]
*   [`StretchingOverscrollIndicator`][]

PRs relevantes:

*   Depreciado em [#100234][]
*   Removido em [#133181][]

[`ScrollBehavior`]: {{site.api}}/flutter/widgets/ScrollBehavior-class.html
[`MaterialScrollBehavior`]: {{site.api}}/flutter/material/MaterialScrollBehavior-class.html
[`ThemeData`]: {{site.api}}/flutter/material/ThemeData-class.html
[`GlowingOverscrollIndicator`]: {{site.api}}/flutter/widgets/GlowingOverscrollIndicator-class.html
[`StretchingOverscrollIndicator`]: {{site.api}}/flutter/widgets/StretchingOverscrollIndicator-class.html

[#100234]: {{site.repo.flutter}}/pull/100234
[#133181]: {{site.repo.flutter}}/pull/133181

---

### Atualizações para `ImageProvider` e `PaintingBinding`

Pacote: flutter
Suportado pelo Flutter Fix: não

O método `instantiateImageCodec` de `PaintingBinding`, assim como o método
`load` de `ImageProvider` e o `DecoderCallback` associado foram todos
depreciados na v2.13.

As respectivas substituições são:

| Método Depreciado                       | Método Atual                                     |
|-----------------------------------------|-------------------------------------------------|
| `PaintingBinding.instantiateImageCodec` | `PaintingBinding.instantiateImageCodecFromBuffer` |
| `ImageProvider.load`                    | `ImageProvider.loadBuffer`                        |
| `DecoderCallback`                       | `DecoderBufferCallback`                           |

Esta mudança permitiu um desempenho mais rápido no carregamento de imagens
usando um buffer.

**Guia de migração**

Código antes da migração:

```dart
PaintingBinding.instance.instantiateImageCodec
```

Código após a migração:

```dart
PaintingBinding.instance.instantiateImageCodecFromBuffer
```

**Referências**

Documentação da API:

*   [`PaintingBinding`][]
*   [`ImageProvider`][]
*   [`DecoderBufferCallback`][]

PRs relevantes:

*   Depreciado em [#103496][]
*   Removido em [#132679][]

[`PaintingBinding`]: {{site.api}}/flutter/painting/PaintingBinding-mixin.html
[`ImageProvider`]: {{site.api}}/flutter/painting/ImageProvider-class.html
[`DecoderBufferCallback`]: {{site.api}}/flutter/painting/DecoderBufferCallback.html

[#103496]: {{site.repo.flutter}}/pull/103496
[#132679]: {{site.repo.flutter}}/pull/132679

---

### Propriedades `TestWindow`

Pacote: flutter_test
Suportado pelo Flutter Fix: não

Para preparar o suporte a múltiplas janelas, muitas propriedades depreciadas
de `TestWindow` foram removidas. Embora `TestWindow` tenha sido depreciado,
não se qualifica para remoção neste momento. Migrar as propriedades expiradas
agora ajudará na migração de `TestWindow`.

As seguintes propriedades foram removidas:

*   `localeTestValue`
*   `clearLocaleTestValue`
*   `localesTestValue`
*   `clearLocalesTestValue`
*   `initialLifecycleStateTestValue`
*   `textScaleFactorTestValue`
*   `clearTextScaleFactorTestValue`
*   `platformBrightnessTestValue`
*   `clearPlatformBrightnessTestValue`
*   `alwaysUse24HourFormatTestValue`
*   `clearAlwaysUse24HourTestValue`
*   `brieflyShowPasswordTestValue`
*   `defaultRouteNameTestValue`
*   `clearDefaultRouteNameTestValue`
*   `semanticsEnabledTestValue`
*   `clearSemanticsEnabledTestValue`
*   `accessibilityFeaturesTestValue`
*   `clearAccessibilityFeaturesTestValue`

Para saber mais sobre esta atualização do `TestWindow`, confira o
[guia de migração de `TestWindow`][].

[guia de migração de `TestWindow`]: /release/breaking-changes/window-singleton

**Guia de migração**

Código antes da migração:

```dart
testWidgets('Meu teste', (WidgetTester tester) aysnc {
  // Para todas as instâncias, substitua window por platformDispatcher
  tester.binding.window.textScaleFactorTestValue = 42;
  addTearDown(tester.binding.window.clearTextScaleFactorTestValue);
  // ...
});
```

Código após a migração:

```dart
testWidgets('Meu teste', (WidgetTester tester) aysnc {
  // Para todas as instâncias, substitua window por platformDispatcher
  tester.binding.platformDispatcher.textScaleFactorTestValue = 42;
  addTearDown(tester.binding.platformDispatcher.clearTextScaleFactorTestValue);
  // ...
});
```

**Referências**

Documentação da API:

*   [`WidgetTester`][]
*   [`TestWidgetsFlutterBinding`][]
*   [`TestPlatformDispatcher`][]

PRs relevantes:

*   Depreciado em [#99443][]
*   Removido em [#131098][]

[`WidgetTester`]: {{site.api}}/flutter/flutter_test/WidgetTester-class.html
[`TestWidgetsFlutterBinding`]: {{site.api}}/flutter/flutter_test/TestWidgetsFlutterBinding-class.html
[`TestPlatformDispatcher`]: {{site.api}}/flutter/flutter_test/TestPlatformDispatcher-class.html

[#99443]: {{site.repo.flutter}}/pull/99443
[#131098]: {{site.repo.flutter}}/pull/131098

---

## Linha do tempo

Na versão estável: 3.16
