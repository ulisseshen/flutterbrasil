---
ia-translate: true
title: API descontinuada removida após a v1.22
description: >
  Após atingir o fim da vida útil, as seguintes APIs descontinuadas foram
  removidas do Flutter.
---

## Resumo

De acordo com a [Política de Descontinuação][Deprecation Policy] do Flutter,
as APIs descontinuadas que atingiram o fim da vida útil após o
lançamento estável da versão 1.22 foram removidas.
Esta é a primeira vez que APIs descontinuadas
foram removidas do Flutter,
e algumas dessas descontinuações são anteriores à nossa
política de guia de migração.

Todas as APIs afetadas foram compiladas nesta
fonte primária para auxiliar na migração. Uma
[folha de referência rápida][quick reference sheet] também está disponível.

Um [documento de design][design document] e um [artigo][article] estão
disponíveis para mais contexto sobre a política de descontinuação do Flutter.

[Deprecation Policy]: {{site.repo.flutter}}/blob/master/docs/contributing/Tree-hygiene.md#deprecations
[quick reference sheet]: /go/deprecations-removed-after-1-22
[design document]: /go/deprecation-lifetime
[article]: {{site.flutter-medium}}/deprecation-lifetime-in-flutter-e4d76ee738ad

## Alterações

Esta seção lista as descontinuações, listadas pela classe afetada.

### `CupertinoDialog`

Suportado pela ferramenta de correção: Somente correção do IDE.

`CupertinoDialog` foi descontinuado na v0.2.3.
Use `CupertinoAlertDialog` ou `CupertinoPopupSurface` em seu lugar.

**Guia de Migração**

*CupertinoAlertDialog*

Código antes da migração:

```dart
CupertinoDialog(child: myWidget);
```

Código após a migração:

```dart
CupertinoAlertDialog(content: myWidget);
```

*CupertinoPopupSurface*

Código antes da migração:

```dart
CupertinoDialog(child: myWidget);
```

Código após a migração:

```dart
CupertinoPopupSurface(child: myWidget);
```

**Referências**

Documentação da API:

*   [`CupertinoAlertDialog`][]
*   [`CupertinoPopupSurface`][]

Issues relevantes:

*   [Deprecate CupertinoDialog class][]

PRs relevantes:

*   Descontinuado em [#20649][]
*   Removido em [#73604][]

[`CupertinoAlertDialog`]: {{site.api}}/flutter/cupertino/CupertinoAlertDialog-class.html
[`CupertinoPopupSurface`]: {{site.api}}/flutter/cupertino/CupertinoPopupSurface-class.html
[Deprecate CupertinoDialog class]: {{site.repo.flutter}}/issues/20397
[#20649]: {{site.repo.flutter}}/pull/20649
[#73604]: {{site.repo.flutter}}/pull/73604

---

### `actionsForegroundColor` das barras de navegação Cupertino

Suportado pela ferramenta de correção: Não

`CupertinoNavigationBar.actionsForegroundColor`
e `CupertinoSliverNavigationBar.actionsForegroundColor`
foram descontinuados na v1.1.2.
Definir `primaryColor` em seu `CupertinoTheme` propaga isso em seu lugar.
Para acessar o `primaryColor`,
chame `CupertinoTheme.of(context).primaryColor`.

**Guia de Migração**

Código antes da migração:

```dart
CupertinoNavigationBar(
  actionsForegroundColor: CupertinoColors.systemBlue,
);
CupertinoSliverNavigationBar(
  actionsForegroundColor: CupertinoColors.systemBlue,
);
```

Código após a migração:

```dart
CupertinoTheme(
  data: CupertinoThemeData(
    primaryColor: CupertinoColors.systemBlue
  ),
  child: ...
);

// Para acessar a cor do `CupertinoTheme`
CupertinoTheme.of(context).primaryColor;
```

**Referências**

Documentação da API:

*   [`CupertinoNavigationBar`][]
*   [`CupertinoSliverNavigationBar`][]
*   [`CupertinoTheme`][]
*   [`CupertinoThemeData`][]

Issues relevantes:

*   [Create a CupertinoApp and a CupertinoTheme][]

PRs relevantes:

*   Descontinuado em [#23759][]
*   Removido em [#73745][]

[`CupertinoNavigationBar`]: {{site.api}}/flutter/cupertino/CupertinoNavigationBar-class.html
[`CupertinoSliverNavigationBar`]: {{site.api}}/flutter/cupertino/CupertinoSliverNavigationBar-class.html
[`CupertinoTheme`]: {{site.api}}/flutter/cupertino/CupertinoTheme-class.html
[`CupertinoThemeData`]: {{site.api}}/flutter/cupertino/CupertinoThemeData-class.html
[Create a CupertinoApp and a CupertinoTheme]: {{site.repo.flutter}}/issues/18037
[#23759]: {{site.repo.flutter}}/pull/23759
[#73745]: {{site.repo.flutter}}/pull/73745

---

### `CupertinoTextThemeData.brightness`

Suportado pela ferramenta de correção: Sim

`CupertinoTextThemeData.brightness` foi descontinuado na v1.10.14.
Este membro do campo foi tornado ineficaz no momento da descontinuação.
Não há substituição para este
parâmetro, as referências devem ser removidas.

**Guia de Migração**

Código antes da migração:

```dart
const CupertinoTextThemeData themeData = CupertinoTextThemeData(brightness: Brightness.dark);
themeData.copyWith(brightness: Brightness.light);
```

Código após a migração:

```dart
const CupertinoTextThemeData themeData = CupertinoTextThemeData();
themeData.copyWith();
```

**Referências**

Documentação da API:

*   [`CupertinoTextThemeData`][]

Issues relevantes:

*   [Revise CupertinoColors and CupertinoTheme for dynamic colors][]

PRs relevantes:

*   Descontinuado em [#41859][]
*   Removido em [#72017][]

[`CupertinoTextThemeData`]: {{site.api}}/flutter/cupertino/CupertinoTextThemeData-class.html
[Revise CupertinoColors and CupertinoTheme for dynamic colors]: {{site.repo.flutter}}/issues/35541
[#41859]: {{site.repo.flutter}}/pull/41859
[#72017]: {{site.repo.flutter}}/pull/72017

---

### Eventos de ponteiro construídos `fromHoverEvent`

Suportado pela ferramenta de correção: Sim

Os construtores `fromHoverEvent` para `PointerEnterEvent`
e `PointerExitEvent` foram descontinuados na v1.4.3.
O construtor `fromMouseEvent` deve ser usado em seu lugar.

**Guia de Migração**

Código antes da migração:

```dart
final PointerEnterEvent enterEvent = PointerEnterEvent.fromHoverEvent(PointerHoverEvent());
final PointerExitEvent exitEvent = PointerExitEvent.fromHoverEvent(PointerHoverEvent());
```

Código após a migração:

```dart
final PointerEnterEvent enterEvent = PointerEnterEvent.fromMouseEvent(PointerHoverEvent());
final PointerExitEvent exitEvent = PointerExitEvent.fromMouseEvent(PointerHoverEvent());
```

**Referências**

Documentação da API:

*   [`PointerEnterEvent`][]
*   [`PointerExitEvent`][]

Issues relevantes:

*   [PointerEnterEvent and PointerExitEvent can only
    be created from hover events][]

PRs relevantes:

*   Descontinuado em [#28602][]
*   Removido em [#72395][]

[`PointerEnterEvent`]: {{site.api}}/flutter/gestures/PointerEnterEvent-class.html
[`PointerExitEvent`]: {{site.api}}/flutter/gestures/PointerExitEvent-class.html
[PointerEnterEvent and PointerExitEvent can only be created from hover events]: {{site.repo.flutter}}/issues/29696
[#28602]: {{site.repo.flutter}}/pull/28602
[#72395]: {{site.repo.flutter}}/pull/72395

---

### `showDialog` usa `builder`

Suportado pela ferramenta de correção: Sim

O parâmetro `child` de `showDialog` foi descontinuado na v0.2.3.
O parâmetro `builder` deve ser usado em seu lugar.

**Guia de Migração**

Código antes da migração:

```dart
showDialog(child: myWidget);
```

Código após a migração:

```dart
showDialog(builder: (context) => myWidget);
```

**Referências**

Documentação da API:

*   [`showDialog`][]

Issues relevantes:

*   [showDialog should take a builder rather than a child][]

PRs relevantes:

*   Descontinuado em [#15303][]
*   Removido em [#72532][]

[`showDialog`]: {{site.api}}/flutter/material/showDialog.html
[showDialog should take a builder rather than a child]: {{site.repo.flutter}}/issues/14341
[#15303]: {{site.repo.flutter}}/pull/15303
[#72532]: {{site.repo.flutter}}/pull/72532

---

### `Scaffold.resizeToAvoidBottomPadding`

Suportado pela ferramenta de correção: Sim

O parâmetro `resizeToAvoidBottomPadding` de `Scaffold` foi descontinuado na v1.1.9.
O parâmetro `resizeToAvoidBottomInset` deve ser usado em seu lugar.

**Guia de Migração**

Código antes da migração:

```dart
Scaffold(resizeToAvoidBottomPadding: true);
```

Código após a migração:

```dart
Scaffold(resizeToAvoidBottomInset: true);
```

**Referências**

Documentação da API:

*   [`Scaffold`][]

Issues relevantes:

*   [Show warning when nesting Scaffolds][]
*   [SafeArea with keyboard][]
*   [Double stacked material scaffolds shouldn't double resizeToAvoidBottomPadding][]
*   [viewInsets and padding on Window and MediaQueryData should define how they interact][]
*   [bottom overflow issue, when using textfields inside tabbarview][]

PRs relevantes:

*   Descontinuado em [#26259][]
*   Removido em [#72890][]

[`Scaffold`]: {{site.api}}/flutter/material/Scaffold-class.html
[Show warning when nesting Scaffolds]: {{site.repo.flutter}}/issues/23106
[SafeArea with keyboard]: {{site.repo.flutter}}/issues/25758
[Double stacked material scaffolds shouldn't double resizeToAvoidBottomPadding]: {{site.repo.flutter}}/issues/12084
[viewInsets and padding on Window and MediaQueryData should define how they interact]: {{site.repo.flutter}}/issues/15424
[bottom overflow issue, when using textfields inside tabbarview]: {{site.repo.flutter}}/issues/20295
[#26259]: {{site.repo.flutter}}/pull/26259
[#72890]: {{site.repo.flutter}}/pull/72890

---

### `ButtonTheme.bar`

Suportado pela ferramenta de correção: Não

O construtor `bar` de `ButtonTheme` foi descontinuado na v1.9.1.
`ButtonBarTheme` pode ser usado em seu lugar para `ButtonBar`s,
ou use outro construtor de `ButtonTheme`
se o uso não for específico para `ButtonBar`.

O tema específico do botão também está disponível com as classes `TextButtonTheme`,
`ElevatedButtonTheme` e `OutlinedButtonTheme`,
cada uma correspondendo à classe de botão apropriada,
`TextButton`, `ElevatedButton` e `OutlinedButton`.

**Guia de Migração**

Código antes da migração:

```dart
ButtonTheme.bar(
  minWidth: 10.0,
  alignedDropdown: true,
  height: 40.0,
);
```

Código após a migração, usando `ButtonTheme`:

```dart
ButtonTheme(
  minWidth: 10.0,
  alignedDropdown: true,
  height: 40.0,
);
```

Código após a migração, usando `ButtonBarTheme`:

```dart
ButtonBarTheme(
  data: ButtonBarThemeData(
    buttonMinWidth: 10.0,
    buttonAlignedDropdown: true,
    buttonHeight: 40.0,
  )
);
```

**Referências**

Documentação da API:

*   [`ButtonTheme`][]
*   [`ButtonBarTheme`][]
*   [`ButtonBar`][]
*   [`TextButtonTheme`][]
*   [`TextButton`][]
*   [`ElevatedButtonTheme`][]
*   [`ElevatedButton`][]
*   [`OutlinedButtonTheme`][]
*   [`OutlinedButton`][]

Issues relevantes:

*   [ButtonTheme.bar uses accent color when it should be using primary color][]
*   [ThemeData.accentColor has insufficient contrast for text][]
*   [Increased height as a result of changes to materialTapTargetSize affecting AlertDialog/ButtonBar heights][]

PRs relevantes:

*   Descontinuado em [#37544][]
*   Removido em [#73746][]

[`ButtonTheme`]: {{site.api}}/flutter/material/ButtonTheme-class.html
[`ButtonBarTheme`]: {{site.api}}/flutter/material/ButtonBarTheme-class.html
[`ButtonBar`]: {{site.api}}/flutter/material/ButtonBar-class.html
[`TextButtonTheme`]: {{site.api}}/flutter/material/TextButtonTheme-class.html
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html
[`ElevatedButtonTheme`]: {{site.api}}/flutter/material/ElevatedButtonTheme-class.html
[`ElevatedButton`]: {{site.api}}/flutter/material/ElevatedButton-class.html
[`OutlinedButtonTheme`]: {{site.api}}/flutter/material/OutlinedButtonTheme-class.html
[`OutlinedButton`]: {{site.api}}/flutter/material/OutlinedButton-class.html
[ButtonTheme.bar uses accent color when it should be using primary color]: {{site.repo.flutter}}/issues/31333
[ThemeData.accentColor has insufficient contrast for text]: {{site.repo.flutter}}/issues/19946
[Increased height as a result of changes to materialTapTargetSize affecting AlertDialog/ButtonBar heights]: {{site.repo.flutter}}/issues/20585
[#37544]: {{site.repo.flutter}}/pull/37544
[#73746]: {{site.repo.flutter}}/pull/73746

---

### `InlineSpan`, `TextSpan`, `PlaceholderSpan`

Suportado pela ferramenta de correção: Não

Os seguintes métodos foram descontinuados em
`InlineSpan`, `TextSpan` e `PlaceholderSpan` para
permitir a incorporação de widgets inline em parágrafos, como imagens.

**Guia de Migração**

Código antes da migração | Código após a migração
-- | --
`InlineSpan.text` | `TextSpan.text`
`InlineSpan.children` | `TextSpan.children`
`InlineSpan.visitTextSpan` | `InlineSpan.visitChildren`
`InlineSpan.recognizer` | `TextSpan.recognizer`
`InlineSpan.describeSemantics` | `InlineSpan.computeSemanticsInformation`
`PlaceholderSpan.visitTextSpan` | `PlaceHolderSpan.visitChildren`
`TextSpan.visitTextSpan` |  `TextSpan.visitChildren`

**Referências**

Documentação da API:

*   [`InlineSpan`][]
*   [`TextSpan`][]
*   [`PlaceholderSpan`][]
*   [`WidgetSpan`][]

Issues relevantes:

*   [Text: support inline images][]

PRs relevantes:

*   Histórico de desenvolvimento:
    *   [#30069][]
    *   [#33946][]
    *   [#33794][]
*   Descontinuado em [#34051][]
*   Removido em [#73747][]

[`InlineSpan`]: {{site.api}}/flutter/painting/InlineSpan-class.html
[`TextSpan`]: {{site.api}}/flutter/painting/TextSpan-class.html
[`PlaceholderSpan`]: {{site.api}}/flutter/painting/PlaceholderSpan-class.html
[`WidgetSpan`]: {{site.api}}/flutter/widgets/WidgetSpan-class.html
[Text: support inline images]: {{site.repo.flutter}}/issues/2022
[#30069]: {{site.repo.flutter}}/pull/30069
[#33946]: {{site.repo.flutter}}/pull/33946
[#33794]: {{site.repo.flutter}}/pull/33794
[#34051]: {{site.repo.flutter}}/pull/34051
[#73747]: {{site.repo.flutter}}/pull/73747

---

### `RenderView.scheduleInitialFrame`

Suportado pela ferramenta de correção: Não

O método `RenderView.scheduleInitialFrame` foi descontinuado e removido
para evitar que as telas iniciais fossem retiradas muito cedo,
resultando em uma tela preta.
Isso aconteceria quando `WidgetsFlutterBinding.ensureInitialized` fosse chamado.
Em vez disso, substitua as chamadas para este método por `RenderView.prepareInitialFrame`,
seguido por `RenderView.owner.requestVisualUpdate`.

**Guia de Migração**

Código antes da migração:

```dart
scheduleInitialFrame();
```

Código após a migração:

```dart
prepareInitialFrame();
owner.requestVisualUpdate();
```

**Referências**

Documentação da API:

*   [`RenderView`][]
*   [`WidgetsFlutterBinding`][]

Issues relevantes:

*   [WidgetsFlutterBinding.ensureInitialized() takes down splash screen too early][]

PRs relevantes:

*   Descontinuado em [#39535][]
*   Removido em [#73748][]

[`RenderView`]: {{site.api}}/flutter/rendering/RenderView-class.html
[`TextSpan`]: {{site.api}}/flutter/widgets/WidgetsFlutterBinding-class.html
[`WidgetsFlutterBinding`]: {{site.api}}/flutter/widgets/WidgetsFlutterBinding-class.html
[WidgetsFlutterBinding.ensureInitialized() takes down splash screen too early]: {{site.repo.flutter}}/issues/39494
[#39535]: {{site.repo.flutter}}/pull/39535
[#73748]: {{site.repo.flutter}}/pull/73748

---

### `Layer.findAll`

Suportado pela ferramenta de correção: Não

O método `Layer.findAll` foi descontinuado com a
introdução de `Layer.findAnnotations` para unificar
as implementações de `find` e `findAll`.
Para migrar o código afetado, chame `findAllAnnotations` em seu lugar.
Este método retorna um `AnnotationResult`, contendo o antigo
valor de retorno de `findAll` em `AnnotationResult.annotations`.

**Guia de Migração**

Código antes da migração:

```dart
findAll(offset);
```

Código após a migração:

```dart
findAllAnnotations(offset).annotations;
```

**Referências**

Documentação da API:

*   [`Layer`][]
*   [`MouseRegion`][]
*   [`RenderMouseRegion`][]
*   [`AnnotatedRegionLayer`][]
*   [`AnnotationResult`][]

Issues relevantes:

*   [Breaking Proposal: MouseRegion defaults to opaque; Layers are required to implement findAnnotations][]

PRs relevantes:

*   Inicialmente alterado em [#37896][]
*   Descontinuado em [#42953][]
*   Removido em [#73749][]

[`Layer`]: {{site.api}}/flutter/rendering/Layer-class.html
[`MouseRegion`]: {{site.api}}/flutter/widgets/MouseRegion-class.html
[`RenderMouseRegion`]: {{site.api}}/flutter/rendering/RenderMouseRegion-class.html
[`AnnotatedRegionLayer`]: {{site.api}}/flutter/rendering/AnnotatedRegionLayer-class.html
[`AnnotationResult`]: {{site.api}}/flutter/rendering/AnnotationResult-class.html
[Breaking Proposal: MouseRegion defaults to opaque; Layers are required to implement findAnnotations]: {{site.repo.flutter}}/issues/38488
[#37896]: {{site.repo.flutter}}/pull/37896
[#42953]: {{site.repo.flutter}}/pull/42953
[#73749]: {{site.repo.flutter}}/pull/73749

---

### `BinaryMessages`

Suportado pela ferramenta de correção: Não

A classe `BinaryMessages`, seus métodos estáticos associados e o getter `defaultBinaryMessenger`
foram descontinuados e removidos. A instância `defaultBinaryMessenger` foi movida para `ServicesBinding`.
Isso tornou possível registrar um `BinaryMessenger` padrão diferente em ambiente de teste,
criando uma subclasse `ServicesBinding` para teste. Fazer isso permite que você rastreie o número de
mensagens de plataforma pendentes para fins de sincronização.

**Guia de Migração**

Código antes da migração: | Código após a migração:
-- | --
`defaultBinaryMessenger` | `ServicesBinding.instance.defaultBinaryMessenger`
`BinaryMessages` | `BinaryMessenger`
`BinaryMessages.handlePlatformMessage` | `ServicesBinding.instance.defaultBinaryMessenger.handlePlatformMessage`
`BinaryMessages.send` | `ServicesBinding.instance.defaultBinaryMessenger.send`
`BinaryMessages.setMessageHandler` | `ServicesBinding.instance.defaultBinaryMessenger.setMessageHandler`
`BinaryMessages.setMockMessageHandler` | `ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler`

**Referências**

Documentação da API:

*   [`ServicesBinding`][]
*   [`BinaryMessenger`][]

Issues relevantes:

*   [Flutter synchronization support for Espresso/EarlGrey][]

PRs relevantes:

*   Inicialmente alterado em [#37489][]
*   Descontinuado em [#38464][]
*   Removido em [#73750][]

[`ServicesBinding`]: {{site.api}}/flutter/services/ServicesBinding-mixin.html
[`BinaryMessenger`]: {{site.api}}/flutter/services/BinaryMessenger-class.html
[Flutter synchronization support for Espresso/EarlGrey]: {{site.repo.flutter}}/issues/37409
[#37489]: {{site.repo.flutter}}/pull/37489
[#38464]: {{site.repo.flutter}}/pull/38464
[#73750]: {{site.repo.flutter}}/pull/73750

---

### Métodos genéricos para `BuildContext`

Suportado pela ferramenta de correção: Sim

Vários métodos em `BuildContext` estavam usando `Type` para procurar ancestrais.
A maioria desses métodos implicava em uma conversão no local da chamada porque
seu tipo de retorno era um tipo pai.
Além disso, o tipo fornecido não era verificado no momento da análise
mesmo que o tipo seja realmente restrito.
Tornar esses métodos genéricos melhora a segurança de tipo e requer menos código.

Essas alterações de método afetam
as classes `BuildContext`, `Element` e `StatefulElement`.
A classe `TypeMatcher` também foi removida.

**Guia de Migração**

Código antes da migração:

```dart
ComplexLayoutState state = context.ancestorStateOfType(const TypeMatcher<ComplexLayoutState>()) as ComplexLayoutState;
```

Código após a migração:

```dart
ComplexLayoutState state = context.ancestorStateOfType<ComplexLayoutState>();
```

`BuildContext`

Código antes da migração: | Código após a migração:
--  | --
`inheritFromElement` | `dependOnInheritedElement`
`inheritFromWidgetOfExactType` | `dependOnInheritedWidgetOfExactType`
`ancestorInheritedElementForWidgetOfExactType` | `getElementForInheritedWidgetOfExactType`
`ancestorWidgetOfExactType` | `findAncestorWidgetOfExactType`
`ancestorStateOfType` | `findAncestorStateOfType`
`rootAncestorStateOfType` | `findRootAncestorStateOfType`
`ancestorRenderObjectOfType` | `findAncestorRenderObjectOfType`

`Element`

Código antes da migração: | Código após a migração:
--  | --
`inheritFromElement` | `dependOnInheritedElement`
`inheritFromWidgetOfExactType` | `dependOnInheritedWidgetOfExactType`
`ancestorInheritedElementForWidgetOfExactType` | `getElementForInheritedWidgetOfExactType`
`ancestorWidgetOfExactType` | `findAncestorWidgetOfExactType`
`ancestorStateOfType` | `findAncestorStateOfType`
`rootAncestorStateOfType` | `findRootAncestorStateOfType`
`ancestorRenderObjectOfType` | `findAncestorRenderObjectOfType`

`StatefulElement`

Código antes da migração: | Código após a migração:
--  | --
`inheritFromElement` | `dependOnInheritedElement`

**Referências**

Documentação da API:

*   [`Type`][]
*   [`BuildContext`][]
*   [`Element`][]
*   [`StatefulElement`][]

PRs relevantes:

*   Descontinuado em [#44189][]
*   Removido em:
    *   [#69620][]
    *   [#72903][]
    *   [#72901][]
    *   [#73751][]

[`Type`]: {{site.api}}/flutter/dart-core/Type-class.html
[`BuildContext`]: {{site.api}}/flutter/widgets/BuildContext-class.html
[`Element`]: {{site.api}}/flutter/widgets/Element-class.html
[`StatefulElement`]: {{site.api}}/flutter/widgets/StatefulElement-class.html
[#44189]: {{site.repo.flutter}}/pull/44189
[#69620]: {{site.repo.flutter}}/pull/69620
[#72903]: {{site.repo.flutter}}/pull/72903
[#72901]: {{site.repo.flutter}}/pull/72901
[#73751]: {{site.repo.flutter}}/pull/73751

---

### `WidgetsBinding.deferFirstFrameReport` & `WidgetsBinding.allowFirstFrameReport`

Suportado pela ferramenta de correção: Sim

Os métodos `deferFirstFrameReport` e `allowFirstFrameReport`
de `WidgetsBinding` foram descontinuados e removidos para
fornecer a opção de atrasar a renderização do primeiro quadro.
Isso é útil para widgets que precisam obter informações de inicialização
de forma assíncrona e, enquanto aguardam por
essas informações, nenhum quadro deve ser renderizado, pois isso removeria
a tela inicial prematuramente.
Os métodos `deferFirstFrame` e `allowFirstFrame`
devem ser usados respectivamente em seu lugar.

**Guia de Migração**

Código antes da migração:

```dart
final WidgetsBinding binding = WidgetsBinding.instance;
binding.deferFirstFrameReport();
binding.allowFirstFrameReport();
```

Código após a migração:

```dart
final WidgetsBinding binding = WidgetsBinding.instance;
binding.deferFirstFrame();
binding.allowFirstFrame();
```

**Referências**

Documentação da API:

*   [`WidgetsBinding`][]

PRs relevantes:

*   Inicialmente alterado em
    *   [#45135][]
    *   [#45588][]
*   Descontinuado em [#45941][]
*   Removido em [#72893][]

[`WidgetsBinding`]: {{site.api}}/flutter/widgets/WidgetsBinding-mixin.html
[#45135]: {{site.repo.flutter}}/pull/45135
[#45588]: {{site.repo.flutter}}/pull/45588
[#45941]: {{site.repo.flutter}}/pull/45941
[#72893]: {{site.repo.flutter}}/pull/72893

---

### `WaitUntilNoTransientCallbacks`, `WaitUntilNoPendingFrame`, & `WaitUntilFirstFrameRasterized`

Suportado pela ferramenta de correção: Não

Os métodos `WaitUntilNoTransientCallbacks`, `WaitUntilNoPendingFrame` e `WaitUntilFirstFrameRasterized`
dos pacotes `flutter_driver` foram descontinuados e removidos para fornecer uma
API `waitForCondition` mais componível que pode ser usada para compor condições que o cliente gostaria
de esperar.

**Guia de Migração**

Código antes da migração: | Código após a migração:
-- | --
`WaitUntilNoTransientCallbacks` | `WaitForCondition(NoTransientCallbacks())`
`WaitUntilNoPendingFrame` | `WaitForCondition(NoPendingFrame())`
`WaitUntilFirstFrameRasterized` | `WaitForCondition(FirstFrameRasterized))`

**Referências**

Documentação da API:

*   [`WaitForCondition`][]

Issues relevantes:

*   [Flutter synchronization support for Espresso/EarlGrey][]

PRs relevantes:

*   Inicialmente alterado em [#37736][]
*   Descontinuado em [#38836][]
*   Removido em [#73754][]

[`WaitForCondition`]: {{site.api}}/flutter/flutter_driver/WaitForCondition-class.html
[#37736]: {{site.repo.flutter}}/pull/37736
[#38836]: {{site.repo.flutter}}/pull/38836
[#73754]: {{site.repo.flutter}}/pull/73754

---

## Linha do tempo

Na versão estável: 2.0.0
