---
ia-translate: true
title: API Deprecada Removida após a v3.7
description: >
  Após atingir o fim de vida útil, as seguintes APIs
  deprecadas foram removidas do Flutter.
---

## Sumário

De acordo com a [Política de Depreciação][] do Flutter,
APIs deprecadas que atingiram o fim de vida útil após o
lançamento estável 3.7 foram removidas.

Todas as APIs afetadas foram compiladas nesta
fonte primária para auxiliar na migração. Uma
[folha de referência rápida][] também está disponível.

[Política de Depreciação]: {{site.repo.flutter}}/blob/master/docs/contributing/Tree-hygiene.md#deprecations
[folha de referência rápida]: /go/deprecations-removed-after-3-7

## Mudanças

Esta seção lista as depreciações, listadas pela classe afetada.

### `GestureRecognizer.kind` & subclasses

Suportado pelo Flutter Fix: sim

`GestureRecognizer.kind` foi depreciado na v2.3.
Use `GestureRecognizer.supportedDevices` em vez disso.

Essa mesma alteração afeta todas as subclasses de `GestureRecognizer`:

* `EagerGestureRecognizer`
* `ForcePressGestureRecognizer`
* `LongPressGestureRecognizer`
* `DragGestureRecognizer`
* `VerticalDragGestureRecognizer`
* `HorizontalDragGestureRecognizer`
* `MultiDragGestureRecognizer`
* `ImmediateMultiDragGestureRecognizer`
* `HorizontalMultiDragGestureRecognizer`
* `VerticalMultiDragGestureRecognizer`
* `DelayedMultiDragGestureRecognizer`
* `DoubleTapGestureRecognizer`
* `MultiTapGestureRecognizer`
* `OneSequenceGestureRecognizer`
* `PrimaryPointerGestureRecognizer`
* `ScaleGestureRecognizer`

Essa mudança permitiu que vários dispositivos fossem reconhecidos por um gesto, em
vez da única opção `kind` fornecida.

**Guia de migração**

Código antes da migração:

```dart
var myRecognizer = GestureRecognizer(
  kind: PointerDeviceKind.mouse,
);
```

Código após a migração:

```dart
var myRecognizer = GestureRecognizer(
  supportedDevices: <PointerDeviceKind>[ PointerDeviceKind.mouse ],
);
```

**Referências**

Documentação da API:

* [`GestureRecognizer`][]
* [`EagerGestureRecognizer`][]
* [`ForcePressGestureRecognizer`][]
* [`LongPressGestureRecognizer`][]
* [`DragGestureRecognizer`][]
* [`VerticalDragGestureRecognizer`][]
* [`HorizontalDragGestureRecognizer`][]
* [`MultiDragGestureRecognizer`][]
* [`ImmediateMultiDragGestureRecognizer`][]
* [`HorizontalMultiDragGestureRecognizer`][]
* [`VerticalMultiDragGestureRecognizer`][]
* [`DelayedMultiDragGestureRecognizer`][]
* [`DoubleTapGestureRecognizer`][]
* [`MultiTapGestureRecognizer`][]
* [`OneSequenceGestureRecognizer`][]
* [`PrimaryPointerGestureRecognizer`][]
* [`ScaleGestureRecognizer`][]

PRs relevantes:

* Depreciado em [#81858][]
* Removido em [#119572][]

[`GestureRecognizer`]: {{site.api}}/flutter/gestures/GestureRecognizer-class.html
[`EagerGestureRecognizer`]: {{site.api}}/flutter/gestures/EagerGestureRecognizer-class.html
[`ForcePressGestureRecognizer`]: {{site.api}}/flutter/gestures/ForcePressGestureRecognizer-class.html
[`LongPressGestureRecognizer`]: {{site.api}}/flutter/gestures/LongPressGestureRecognizer-class.html
[`DragGestureRecognizer`]: {{site.api}}/flutter/gestures/DragGestureRecognizer-class.html
[`VerticalDragGestureRecognizer`]: {{site.api}}/flutter/gestures/VerticalDragGestureRecognizer-class.html
[`HorizontalDragGestureRecognizer`]: {{site.api}}/flutter/gestures/HorizontalDragGestureRecognizer-class.html
[`MultiDragGestureRecognizer`]: {{site.api}}/flutter/gestures/MultiDragGestureRecognizer-class.html
[`ImmediateMultiDragGestureRecognizer`]: {{site.api}}/flutter/gestures/ImmediateMultiDragGestureRecognizer-class.html
[`HorizontalMultiDragGestureRecognizer`]: {{site.api}}/flutter/gestures/HorizontalMultiDragGestureRecognizer-class.html
[`VerticalMultiDragGestureRecognizer`]: {{site.api}}/flutter/gestures/VerticalMultiDragGestureRecognizer-class.html
[`DelayedMultiDragGestureRecognizer`]: {{site.api}}/flutter/gestures/DelayedMultiDragGestureRecognizer-class.html
[`DoubleTapGestureRecognizer`]: {{site.api}}/flutter/gestures/DoubleTapGestureRecognizer-class.html
[`MultiTapGestureRecognizer`]: {{site.api}}/flutter/gestures/MultiTapGestureRecognizer-class.html
[`OneSequenceGestureRecognizer`]: {{site.api}}/flutter/gestures/OneSequenceGestureRecognizer-class.html
[`PrimaryPointerGestureRecognizer`]: {{site.api}}/flutter/gestures/PrimaryPointerGestureRecognizer-class.html
[`ScaleGestureRecognizer`]: {{site.api}}/flutter/gestures/ScaleGestureRecognizer-class.html

[#81858]: {{site.repo.flutter}}/pull/81858
[#119572]: {{site.repo.flutter}}/pull/119572

---

### `ThemeData` `accentColor`, `accentColorBrightness`, `accentColorTextTheme`, `accentColorIconTheme` e `buttonColor`

Suportado pelo Flutter Fix: sim

As propriedades `accentColor`, `accentColorBrightness`, `accentColorTextTheme`,
`accentColorIconTheme` e `buttonColor` de `ThemeData` foram
depreciadas na v2.3.

Essa alteração alinhou melhor o `ThemeData` com as diretrizes do Material Design. Também
criou mais clareza na tematização, dependendo do esquema de cores principal ou
temas de componentes individuais para o estilo desejado.

`accentColorBrightness`, `accentColorTextTheme`,
`accentColorIconTheme` e `buttonColor` não são mais usados pelo framework.
As referências devem ser removidas.

Os usos de `ThemeData.accentColor` devem ser substituídos por
`ThemeData.colorScheme.secondary`.

## Guia de migração

Código antes da migração:

```dart
var myTheme = ThemeData(
  //...
  accentColor: Colors.blue,
  //...
);
var color = myTheme.accentColor;
```

Código após a migração:

```dart
var myTheme = ThemeData(
  //...
  colorScheme: ColorScheme(
    //...
    secondary:Colors.blue,
    //...
  ),
  //...
);
var color = myTheme.colorScheme.secondary;
```

**Referências**

* [Guia de migração da cor de destaque][]

Documentação da API:

* [`ThemeData`][]
* [`ColorScheme`][]

Problemas relevantes:

* [#56639][]
* [#84748][]
* [#56918][]
* [#91772][]

PRs relevantes:

Depreciado em:

* [#92822][]
* [#81336][]
* [#85144][]

Removido em:

* [#118658][]
* [#119360][]
* [#120577][]
* [#120932][]

[Guia de migração da cor de destaque]: /release/breaking-changes/theme-data-accent-properties
[`ThemeData`]: {{site.api}}/flutter/widgets/Draggable-class.html
[`ColorScheme`]: {{site.api}}/flutter/widgets/LongPressDraggable-class.html
[#56639]: {{site.repo.flutter}}/pull/56639
[#84748]: {{site.repo.flutter}}/pull/84748
[#56918]: {{site.repo.flutter}}/pull/56918
[#91772]: {{site.repo.flutter}}/pull/91772
[#92822]: {{site.repo.flutter}}/pull/92822
[#81336]: {{site.repo.flutter}}/pull/81336
[#85144]: {{site.repo.flutter}}/pull/85144
[#118658]: {{site.repo.flutter}}/pull/118658
[#119360]: {{site.repo.flutter}}/pull/119360
[#120577]: {{site.repo.flutter}}/pull/120577
[#120932]: {{site.repo.flutter}}/pull/120932

---

### Atualizações de `AppBar`, `SliverAppBar` e `AppBarTheme`

Suportado pelo Flutter Fix: sim

Na v2.4, várias alterações foram feitas nas classes de barra de aplicativo e seus temas para
melhor alinhar com o Material Design. Várias propriedades foram depreciadas naquele
momento e foram removidas.

Para `AppBar`, `SliverAppBar` e `AppBarTheme`:

* `brightness` foi removido e é substituído por `systemOverlayStyle`
* `textTheme` foi removido e é substituído por `toolbarTextStyle` ou `titleTextStyle`.
* `backwardsCompatibility` pode ser removido, pois era uma sinalização de migração temporária para essas propriedades.

Além disso, `AppBarTheme.color` foi removido, com `AppBarTheme.backgroundColor`
como sua substituição.

**Guia de migração**

Código antes da migração:

```dart
var toolbarTextStyle = TextStyle(...);
var titleTextStyle = TextStyle(...);
AppBar(
  brightness: Brightness.light,
  textTheme: TextTheme(
    bodyMedium: toolbarTextStyle,
    titleLarge: titleTextStyle,
  )
  backwardsCompatibility: true,
);
AppBarTheme(color: Colors.blue);
```

Código após a migração:

```dart
var toolbarTextStyle = TextStyle(...);
var titleTextStyle = TextStyle(...);
AppBar(
  systemOverlayStyle: SystemOverlayStyle(statusBarBrightness: Brightness.light),
  toolbarTextStyle: toolbarTextStyle,
  titleTextStyle: titleTextStyle,
);
AppBarTheme(backgroundColor: Colors.blue);
```

**Referências**

Documentação da API:

* [`AppBar`][]
* [`SliverAppBar`][]
* [`AppBarTheme`][]

Problemas relevantes:

* [#86127][]
* [#70645][]
* [#67921][]
* [#67497][]
* [#50606][]
* [#51820][]
* [#61618][]

Depreciado em:

* [#86198][]
* [#71184][]

Removido em:

* [#120618][]
* [#119253][]
* [#120575][]


[`AppBar`]: {{site.api}}/flutter/material/AppBar-class.html
[`SliverAppBar`]: {{site.api}}/flutter/material/SliverAppBar-class.html
[`AppBarTheme`]: {{site.api}}/flutter/material/AppBarTheme-class.html
[#86127]: {{site.repo.flutter}}/pull/86127
[#70645]: {{site.repo.flutter}}/pull/70645
[#67921]: {{site.repo.flutter}}/pull/67921
[#67497]: {{site.repo.flutter}}/pull/67497
[#50606]: {{site.repo.flutter}}/pull/50606
[#51820]: {{site.repo.flutter}}/pull/51820
[#61618]: {{site.repo.flutter}}/pull/61618
[#86198]: {{site.repo.flutter}}/pull/86198
[#71184]: {{site.repo.flutter}}/pull/71184
[#120618]: {{site.repo.flutter}}/pull/120618
[#119253]: {{site.repo.flutter}}/pull/119253
[#120575]: {{site.repo.flutter}}/pull/120575

---

### `SystemChrome.setEnabledSystemUIOverlays`

Suportado pelo Flutter Fix: sim

Na v2.3, `SystemChrome.setEnabledSystemUIOVerlays`, o método estático para
configurar sobreposições de nível do sistema do dispositivo, como barras de status e de navegação, foi
depreciado em favor de `SystemChrome.setEnabledSystemUIMode`.

Essa alteração permitiu configurar modos de tela cheia comuns que correspondem a nativos
Designs de aplicativos Android como edge to edge.

A configuração manual de sobreposições, em vez de escolher um modo específico, ainda é
suportado por meio de `SystemUiMode.manual`, permitindo que os desenvolvedores passem o mesmo
lista de sobreposições como antes.

**Guia de migração**

Código antes da migração:
```dart
SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[
  SystemUiOverlay.top,
  SystemUiOverlay.bottom,
]);
```

Código após a migração:
```dart
SystemChrome.setEnabledSystemUIMode(
  SystemUiMode.manual,
  overlays: <SystemUiOverlay>[
    SystemUiOverlay.top,
    SystemUiOverlay.bottom,
  ],
);
```

**Referências**

Documentação da API:

* [`SystemChrome`][]

Problemas relevantes:

* [#35748][]
* [#40974][]
* [#44033][]
* [#63761][]
* [#69999][]

Depreciado em:

* [#81303][]

Removido em:

* [#11957][]

[`SystemChrome`]: {{site.api}}/flutter/services/SystemChrome-class.html
[#35748]: {{site.repo.flutter}}/pull/35748
[#40974]: {{site.repo.flutter}}/pull/40974
[#44033]: {{site.repo.flutter}}/pull/44033
[#63761]: {{site.repo.flutter}}/pull/63761
[#69999]: {{site.repo.flutter}}/pull/69999
[#81303]: {{site.repo.flutter}}/pull/81303
[#11957]: {{site.repo.flutter}}/pull/11957

---

### `SystemNavigator.routeUpdated`

Suportado pelo Flutter Fix: sim

Na v2.3, `SystemNavigator.routeUpdated` foi depreciado em favor de
`SystemNavigator.routeInformationUpdated`.

Em vez de ter duas maneiras de atualizar o engine sobre a rota atual, a
alteração moveu tudo para uma API, que seleciona separadamente a entrada única
modo de histórico se um `Navigator` que relata rotas for criado.

**Guia de migração**

Código antes da migração:

```dart
SystemNavigator.routeUpdated(routeName: 'foo', previousRouteName: 'bar');
```

Código após a migração:

```dart
SystemNavigator.routeInformationUpdated(location: 'foo');
```

**Referências**

Documentação da API:

* [`SystemNavigator`][]

Problemas relevantes:

* [#82574][]

Depreciado em:

* [#82594][]

Removido em:

* [#119187][]


[`SystemNavigator`]: {{site.api}}/flutter/services/SystemNavigator-class.html
[#82594]: {{site.repo.flutter}}/pull/82594
[#82574]: {{site.repo.flutter}}/pull/82574
[#119187]: {{site.repo.flutter}}/pull/119187

---

### `AnimatedSize.vsync`

Suportado pelo Flutter Fix: sim

Na v2.2, `AnimatedSize.vsyc` foi depreciado. Essa propriedade não era mais
necessário depois que `AnimatedSize` foi convertido em um `StatefulWidget` cujo `State`
misturado em `SingleTickerProviderStateMixin`. A alteração foi feita para corrigir um vazamento de memória.

Os usos de `vsync` devem ser removidos, pois `AnimatedSize` agora lida com essa propriedade.

**Guia de migração**

Código antes da migração:

```dart
AnimatedSize(
  vsync: this,
  // ...
);
```

Código após a migração:

```dart
AnimatedSize(
  // ...
);
```

**Referências**

Documentação da API:

* [`AnimatedSize`][]

Depreciado em:

* [#80554][]
* [#81067][]

Removido em:

* [#119186][]

[`AnimatedSize`]: {{site.api}}/flutter/widgets/AnimatedSize-class.html
[#80554]: {{site.repo.flutter}}/pull/80554
[#81067]: {{site.repo.flutter}}/pull/81067
[#119186]: {{site.repo.flutter}}/pull/119186

---

## Linha do tempo

Em versão estável: 3.10
