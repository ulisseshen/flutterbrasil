---
ia-translate: true
title: API descontinuada removida após v3.7
description: >
  Após atingir o fim da vida útil, as seguintes APIs descontinuadas
  foram removidas do Flutter.
---

## Resumo {:#summary}

De acordo com a [Política de Obsolescência][Deprecation Policy] do Flutter,
APIs descontinuadas que atingiram o fim da vida útil após o
lançamento estável 3.7 foram removidas.

Todas as APIs afetadas foram compiladas nesta
fonte primária para auxiliar na migração. Uma
[folha de referência rápida][quick reference sheet] também está disponível.

[Deprecation Policy]: {{site.repo.flutter}}/blob/main/docs/contributing/Tree-hygiene.md#deprecations
[quick reference sheet]: /go/deprecations-removed-after-3-7

## Mudanças {:#changes}

Esta seção lista as descontinuações, agrupadas pela classe afetada.

### `GestureRecognizer.kind` & subclasses {:#gesturerecognizerkind-subclasses}

Suportado pelo Flutter Fix: sim

`GestureRecognizer.kind` foi descontinuado na v2.3.
Use `GestureRecognizer.supportedDevices` no lugar.

Esta mesma mudança afeta todas as subclasses de `GestureRecognizer`:

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

Essa mudança permitiu que múltiplos dispositivos fossem reconhecidos para um
gesto, em vez da opção única fornecida por `kind`.

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

* Descontinuado em [#81858][]
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

### `ThemeData` `accentColor`, `accentColorBrightness`, `accentColorTextTheme`, `accentColorIconTheme`, e `buttonColor` {:#themedata-accentcolor-accentcolorbrightness-accentcolortexttheme-accentcoloricontheme-and-buttoncolor}

Suportado pelo Flutter Fix: sim

As propriedades `accentColor`, `accentColorBrightness`, `accentColorTextTheme`,
`accentColorIconTheme` e `buttonColor` de `ThemeData` foram descontinuadas na
v2.3.

Essa mudança alinhou melhor `ThemeData` às diretrizes do Material Design. Também
trouxe mais clareza à customização de temas, passando a depender do esquema de
cores principal ou dos temas de componentes individuais para a estilização
desejada.

As propriedades `accentColorBrightness`, `accentColorTextTheme`,
`accentColorIconTheme` e `buttonColor` não são mais usadas pelo framework.
Referências a elas devem ser removidas.

Usos de `ThemeData.accentColor` devem ser substituídos por
`ThemeData.colorScheme.secondary`.

## Guia de migração {:#migration-guide}

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

* [Guia de migração cor de destaque][Accent color migration guide]

Documentação da API:

* [`ThemeData`][]
* [`ColorScheme`][]

Issues relevantes:

* [#56639][]
* [#84748][]
* [#56918][]
* [#91772][]

PRs relevantes:

Descontinuado em:

* [#92822][]
* [#81336][]
* [#85144][]

Removido em:

* [#118658][]
* [#119360][]
* [#120577][]
* [#120932][]

[Accent color migration guide]: /release/breaking-changes/theme-data-accent-properties
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

### Atualizações de `AppBar`, `SliverAppBar` e `AppBarTheme` {:#appbar-sliverappbar-and-appbartheme-updates}

Suportado pelo Flutter Fix: sim

Na v2.4, várias mudanças foram feitas nas classes de app bar e em seus temas
para se alinhar melhor ao Material Design. Algumas propriedades foram
descontinuadas naquele momento e agora foram removidas.

Para `AppBar`, `SliverAppBar` e `AppBarTheme`:

* `brightness` foi removido e substituído por `systemOverlayStyle`
* `textTheme` foi removido e substituído por `toolbarTextStyle` ou `titleTextStyle`.
* `backwardsCompatibility` pode ser removido, pois era uma flag temporária de migração para essas propriedades.

Além disso, `AppBarTheme.color` foi removido, tendo `AppBarTheme.backgroundColor`
como substituto.

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

Issues relevantes:

* [#86127][]
* [#70645][]
* [#67921][]
* [#67497][]
* [#50606][]
* [#51820][]
* [#61618][]

Descontinuado em:

* [#86198][]
* [#71184][]

Removido em:

* [#120618][]
* [#119253][]
* [#120575][]


[`AppBar`]: {{site.material_ui}}/AppBar-class.html
[`SliverAppBar`]: {{site.material_ui}}/SliverAppBar-class.html
[`AppBarTheme`]: {{site.material_ui}}/AppBarTheme-class.html
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

### `SystemChrome.setEnabledSystemUIOverlays` {:#systemchromesetenabledsystemuioverlays}

Suportado pelo Flutter Fix: sim

Na v2.3, `SystemChrome.setEnabledSystemUIOVerlays`, o método estático para
definir as sobreposições de nível de sistema do dispositivo, como as barras de
status e de navegação, foi descontinuado em favor de
`SystemChrome.setEnabledSystemUIMode`.

Essa mudança permitiu configurar modos de tela cheia comuns que correspondem
aos designs nativos de apps Android, como edge to edge.

Definir as sobreposições manualmente, em vez de escolher um modo específico,
continua sendo suportado por meio de `SystemUiMode.manual`, permitindo passar a
mesma lista de sobreposições de antes.

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

Issues relevantes:

* [#35748][]
* [#40974][]
* [#44033][]
* [#63761][]
* [#69999][]

Descontinuado em:

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

### `SystemNavigator.routeUpdated` {:#systemnavigatorrouteupdated}

Suportado pelo Flutter Fix: sim

Na v2.3, `SystemNavigator.routeUpdated` foi descontinuado em favor de
`SystemNavigator.routeInformationUpdated`.

Em vez de haver duas formas de atualizar o engine sobre a rota atual, a mudança
centralizou tudo em uma única API, que seleciona separadamente o modo de
histórico de entrada única caso um `Navigator` que reporta rotas seja criado.

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

Issues relevantes:

* [#82574][]

Descontinuado em:

* [#82594][]

Removido em:

* [#119187][]


[`SystemNavigator`]: {{site.api}}/flutter/services/SystemNavigator-class.html
[#82594]: {{site.repo.flutter}}/pull/82594
[#82574]: {{site.repo.flutter}}/pull/82574
[#119187]: {{site.repo.flutter}}/pull/119187

---

### `AnimatedSize.vsync` {:#animatedsizevsync}

Suportado pelo Flutter Fix: sim

Na v2.2, `AnimatedSize.vsyc` foi descontinuado. Essa propriedade deixou de ser
necessária depois que `AnimatedSize` foi convertido em um `StatefulWidget` cujo
`State` usa o mixin `SingleTickerProviderStateMixin`. A mudança foi feita para
corrigir um vazamento de memória.

Usos de `vsync` devem ser removidos, pois `AnimatedSize` agora trata essa
propriedade.

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

Descontinuado em:

* [#80554][]
* [#81067][]

Removido em:

* [#119186][]

[`AnimatedSize`]: {{site.api}}/flutter/widgets/AnimatedSize-class.html
[#80554]: {{site.repo.flutter}}/pull/80554
[#81067]: {{site.repo.flutter}}/pull/81067
[#119186]: {{site.repo.flutter}}/pull/119186

---

## Linha do tempo {:#timeline}

Na versão estável: 3.10

---
