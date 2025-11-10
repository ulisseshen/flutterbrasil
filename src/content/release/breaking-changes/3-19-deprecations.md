---
title: Deprecated API removed after v3.19
description: >-
  After reaching end of life, the following deprecated APIs
  were removed from Flutter.
ia-translate: true
---

## Summary

De acordo com a [Política de Descontinuação][Deprecation Policy] do Flutter,
APIs descontinuadas que atingiram o fim da vida útil após o
lançamento estável 3.19 foram removidas.

Todas as APIs afetadas foram compiladas nesta
fonte primária para auxiliar na migração.
Para auxiliar ainda mais sua migração, confira esta
[folha de referência rápida][quick reference sheet].

[Deprecation Policy]: {{site.repo.flutter}}/blob/main/docs/contributing/Tree-hygiene.md#deprecations
[quick reference sheet]: /go/deprecations-removed-after-3-19

## Changes

Esta seção lista as descontinuações por pacote e classe afetada.

### `TextTheme`

Package: flutter
Supported by Flutter Fix: yes

Várias propriedades `TextStyle` de `TextTheme` foram descontinuadas na v3.1 para suportar novos
estilos da especificação Material Design. Elas
estão listadas na tabela a seguir ao lado da substituição apropriada na
nova API.

| Deprecation | New API |
|---|---|
| headline1	| displayLarge |
| headline2	| displayMedium |
| headline3	| displaySmall |
| headline4	| headlineMedium |
| headline5	| headlineSmall |
| headline6	| titleLarge |
| subtitle1	| titleMedium |
| subtitle2	| titleSmall |
| bodyText1	| bodyLarge |
| bodyText2	| bodyMedium |
| caption	  | bodySmall |
| button	  | labelLarge |
| overline	| labelSmall |

**Migration guide**

Code before migration:

```dart
// TextTheme
// Base constructor
TextTheme(
  headline1: headline1Style,
  headline2: headline2Style,
  headline3: headline3Style,
  headline4: headline4Style,
  headline5: headline5Style,
  headline6: headline6Style,
  subtitle1: subtitle1Style,
  subtitle2: subtitle2Style,
  bodyText1: bodyText1Style,
  bodyText2: bodyText2Style,
  caption: captionStyle,
  button: buttonStyle,
  overline: overlineStyle,
);

// copyWith
TextTheme.copyWith(
  headline1: headline1Style,
  headline2: headline2Style,
  headline3: headline3Style,
  headline4: headline4Style,
  headline5: headline5Style,
  headline6: headline6Style,
  subtitle1: subtitle1Style,
  subtitle2: subtitle2Style,
  bodyText1: bodyText1Style,
  bodyText2: bodyText2Style,
  caption: captionStyle,
  button: buttonStyle,
  overline: overlineStyle,
);

// Getters
TextStyle style;
style = textTheme.headline1,
style = textTheme.headline2,
style = textTheme.headline3,
style = textTheme.headline4,
style = textTheme.headline5,
style = textTheme.headline6,
style = textTheme.subtitle1,
style = textTheme.subtitle2,
style = textTheme.bodyText1,
style = textTheme.bodyText2,
style = textTheme.caption,
style = textTheme.button,
style = textTheme.overline,
```

Code after migration:

```dart
// TextTheme
// Base constructor
TextTheme(
  displayLarge: headline1Style,
  displayMedium: headline2Style,
  displaySmall: headline3Style,
  headlineMedium: headline4Style,
  headlineSmall: headline5Style,
  titleLarge: headline6Style,
  titleMedium: subtitle1Style,
  titleSmall: subtitle2Style,
  bodyLarge: bodyText1Style,
  bodyMedium: bodyText2Style,
  bodySmall: captionStyle,
  labelLarge: buttonStyle,
  labelSmall: overlineStyle,
);

TextTheme.copyWith(
  displayLarge: headline1Style,
  displayMedium: headline2Style,
  displaySmall: headline3Style,
  headlineMedium: headline4Style,
  headlineSmall: headline5Style,
  titleLarge: headline6Style,
  titleMedium: subtitle1Style,
  titleSmall: subtitle2Style,
  bodyLarge: bodyText1Style,
  bodyMedium: bodyText2Style,
  bodySmall: captionStyle,
  labelLarge: buttonStyle,
  labelSmall: overlineStyle,
);

TextStyle style;
style = textTheme.displayLarge;
style = textTheme.displayMedium;
style = textTheme.displaySmall;
style = textTheme.headlineMedium;
style = textTheme.headlineSmall;
style = textTheme.titleLarge;
style = textTheme.titleMedium;
style = textTheme.titleSmall;
style = textTheme.bodyLarge;
style = textTheme.bodyMedium;
style = textTheme.bodySmall;
style = textTheme.labelLarge;
style = textTheme.labelSmall;
```

**References**

API documentation:

* [`TextTheme`][]

Relevant PRs:

* Deprecated in [#109817][]
* Removed in [#139255][]

[`TextTheme`]: {{site.api}}/flutter/material/TextTheme-class.html

[#109817]: {{site.repo.flutter}}/pull/109817
[#139255]: {{site.repo.flutter}}/pull/139255

---

### `ThemeData`

Package: flutter
Supported by Flutter Fix: yes

Várias propriedades `Color` de `ThemeData` foram descontinuadas na v3.3 para suportar novos estilos
da especificação Material Design. Essas cores eram `errorColor`, `backgroundColor`,
 `bottomAppBarColor`, e `toggleableActiveColor`. As duas primeiras são substituídas por
 propriedades do `ThemeData.colorScheme`, enquanto `bottomAppBarColor` é substituída pela
 cor do tema do componente, `BottomAppBarTheme`. O `toggleableActiveColor` não era
 mais usado pelo framework e foi removido.

**Migration guide**

Code before migration:

```dart
var myTheme = ThemeData(
  //...
  errorColor: Colors.red,
  backgroundColor: Colors.blue,
  bottomAppBarColor: Colors.purple,
  toggleableActiveColor: Colors.orange,
  //...
);
var errorColor = myTheme.errorColor;
var backgroundColor = myTheme.backgroundColor;
var bottomAppBarColor = myTheme.bottomAppBarColor;
var toggleableActiveColor = myTheme.toggleableActiveColor;
```

Code after migration:

```dart
var myTheme = ThemeData(
  //...
  colorScheme: ColorScheme(
    /// ...
    error: Colors.red,
    background: Colors.blue,
  ),
  bottomAppBarTheme: BottomAppBarTheme(
    color: Colors.purple,
  ),
  //...
);
var errorColor = myTheme.colorScheme.error;
var backgroundColor = myTheme.colorScheme.background;
var bottomAppBarColor = myTheme.bottomAppBarTheme.color;
var toggleableActiveColor = Colors.orange;
```

**References**

API documentation:

* [`ThemeData`][]
* [`ColorScheme`][]
* [`BottomAppBarTheme`][]

Relevant PRs:

* Deprecated in [#110162][], [#111080][], and [#97972][]
* Removed in [#144178][], [#144080][], [#144079][], and [#144078][]

[`ThemeData`]: {{site.api}}/flutter/material/ThemeData-class.html
[`ColorScheme`]: {{site.api}}/flutter/material/ColorScheme-class.html
[`BottomAppBarTheme`]: {{site.api}}/flutter/material/BottomAppBarTheme-class.html

[#110162]: {{site.repo.flutter}}/pull/110162
[#111080]: {{site.repo.flutter}}/pull/111080
[#97972]: {{site.repo.flutter}}/pull/97972
[#144178]: {{site.repo.flutter}}/pull/144178
[#144080]: {{site.repo.flutter}}/pull/144080
[#144079]: {{site.repo.flutter}}/pull/144079
[#144078]: {{site.repo.flutter}}/pull/144078

---

### `CupertinoContextMenu.previewBuilder`

Package: flutter
Supported by Flutter Fix: yes

O `previewBuilder` foi substituído pelo `builder` de `CupertinoContextMenu` após
v3.4. Ao adicionar `builder`, toda a animação executada pelo menu de contexto
é coberta, sendo a segunda metade executada por `previewBuilder`, e
delimitada por `CupertinoContextMenu.animationOpensAt`.


**Migration guide**

Code before migration:

```dart
CupertinoContextMenu(
  previewBuilder: (BuildContext context, Animation<double> animation, Widget child) {
    return FittedBox(
      fit: BoxFit.cover,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(64.0 * animation.value),
        child: Image.asset('assets/photo.jpg'),
      ),
    );
  },
  actions: <Widget>[
    CupertinoContextMenuAction(
      child: const Text('Action one'),
      onPressed: () {},
    ),
  ],
  child: FittedBox(
    fit: BoxFit.cover,
    child: Image.asset('assets/photo.jpg'),
  ),
);
```

Code after migration:

```dart
CupertinoContextMenu(
  actions: <Widget>[
    CupertinoContextMenuAction(
      child: const Text('Action one'),
      onPressed: () {},
    ),
  ],
  builder: (BuildContext context, Animation<double> animation) {
    final Animation<BorderRadius?> borderRadiusAnimation = BorderRadiusTween(
      begin: BorderRadius.circular(0.0),
      end: BorderRadius.circular(CupertinoContextMenu.kOpenBorderRadius),
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: Interval(
          CupertinoContextMenu.animationOpensAt,
          1.0,
        ),
      ),
    );

    final Animation<Decoration> boxDecorationAnimation = DecorationTween(
      begin: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        boxShadow: <BoxShadow>[],
      ),
      end: BoxDecoration(
        color: Color(0xFFFFFFFF),
        boxShadow: CupertinoContextMenu.kEndBoxShadow,
      ),
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: Interval(
          0.0,
          CupertinoContextMenu.animationOpensAt,
        )
      )
    );

    return Container(
      decoration: animation.value < CupertinoContextMenu.animationOpensAt
        ? boxDecorationAnimation.value
        : null,
      child: FittedBox(
        fit: BoxFit.cover,
        child: ClipRRect(
          borderRadius: borderRadiusAnimation.value ?? BorderRadius.circular(0.0),
          child: SizedBox(
            height: 150,
            width: 150,
            child: Image.asset('assets/photo.jpg'),
          ),
        ),
      )
    );
   }
 )
```

**References**

API documentation:

* [`CupertinoContextMenu`][]

Relevant PRs:

* Deprecated in [#110616][]
* Removed in [#143990][]

[`CupertinoContextMenu`]: {{site.api}}/flutter/cupertino/CupertinoContextMenu-class.html

[#110616]: {{site.repo.flutter}}/pull/110616
[#143990]: {{site.repo.flutter}}/pull/143990

---

### `Scrollbar.showTrackOnHover`

Package: flutter
Supported by Flutter Fix: yes

A propriedade `showTrackOnHover` de `Scrollbar`, e seu tema de componente associado,
`ScrollbarThemeData.showTrackOnHover`, foram substituídos pela propriedade stateful
`ScrollbarThemeData.trackVisibility` após v3.4. Ao utilizar `trackVisibility`,
todas as permutações de estado podem influenciar na revelação da trilha da scrollbar, não
apenas hover.


**Migration guide**

Code before migration:

```dart
Scrollbar(
  showTrackOnHover: true,
  child: //...
);
ScrollbarThemeData(
  showTrackOnHover: true,
);
```

Code after migration:

```dart
Scrollbar(
  child: //...
);
ScrollbarThemeData(
  // This will always show the track for any state.
  trackVisibility: MaterialStateProperty<bool>.all(true),
);
// Or
ScrollbarThemeData(
  // Only show on hover.
  trackVisibility: (Set<MaterialState> states) => states.contains(MaterialState.hovered),
);
```

**References**

API documentation:

* [`Scrollbar`][]
* [`ScrollbarThemeData`][]
* [`MaterialState`][]
* [`MaterialStateProperty`][]

Relevant PRs:

* Deprecated in [#111706][]
* Removed in [#144180][]

[`Scrollbar`]: {{site.api}}/flutter/material/Scrollbar-class.html
[`ScrollbarThemeData`]: {{site.api}}/flutter/material/ScrollbarThemeData-class.html
[`MaterialState`]: {{site.api}}/flutter/material/MaterialState-class.html
[`MaterialStateProperty`]: {{site.api}}/flutter/material/MaterialStateProperty-class.html

[#111706]: {{site.repo.flutter}}/pull/111706
[#144180]: {{site.repo.flutter}}/pull/144180

---

### `KeepAliveHandle.release` method

Package: flutter
Supported by Flutter Fix: no

O método `release` de `KeepAliveHandle` foi removido e substituído pela chamada
`dispose` após v3.3. Esta mudança foi feita porque `release` era frequentemente
chamado sem então chamar `dispose`, levando a vazamentos de memória. O método `dispose`
executa a mesma funcionalidade que `release` executava agora.


**Migration guide**

Code before migration:

```dart
KeepAliveHandle handle = KeepAliveHandle();
handle.release();
handle.dispose();
```

Code after migration:

```dart
KeepAliveHandle handle = KeepAliveHandle();
handle.dispose();
```

**References**

API documentation:

* [`KeepAliveHandle`][]

Relevant PRs:

* Deprecated in [#108384][]
* Removed in [#143961][]

[`KeepAliveHandle`]: {{site.api}}/flutter/widgets/KeepAliveHandle-class.html

[#108384]: {{site.repo.flutter}}/pull/108384
[#143961]: {{site.repo.flutter}}/pull/143961

---

### `InteractiveViewer.alignPanAxis`

Package: flutter
Supported by Flutter Fix: yes

A propriedade `alignPanAxis` de `InteractiveViewer` foi removida e substituída por
`panAxis` após v3.3. Esta mudança foi feita para habilitar mais modos de panning em
`InteractiveViewer`.


**Migration guide**

Code before migration:

```dart
InteractiveViewer(
  alignPanAxis: true,
);
```

Code after migration:

```dart
InteractiveViewer(
  panAxis: PanAxis.aligned,
);
```

**References**

API documentation:

* [`InteractiveViewer`][]
* [`PanAxis`][]

Relevant PRs:

* Deprecated in [#109014][]
* Removed in [#142500][]

[`InteractiveViewer`]: {{site.api}}/flutter/widgets/InteractiveViewer-class.html
[`PanAxis`]: {{site.api}}/flutter/widgets/PanAxis.html

[#109014]: {{site.repo.flutter}}/pull/109014
[#142500]: {{site.repo.flutter}}/pull/142500

---

### `MediaQuery.boldTextOverride`

Package: flutter
Supported by Flutter Fix: yes

O método `boldTextOverride` de `MediaQuery` foi removido e substituído por
`boldTextOf` após v3.5. Esta mudança foi feita como parte de uma refatoração maior de
`MediaQuery`, notavelmente reduzindo o número de rebuilds que seriam
acionados por widgets que dependem dele.


**Migration guide**

Code before migration:

```dart
MediaQuery.boldTextOverride(context);
```

Code after migration:

```dart
MediaQuery.boldTextOf(context)
```

**References**

API documentation:

* [`MediaQuery`][]

Relevant PRs:

* Deprecated in [#114459][]
* Removed in [#143960][]

[`MediaQuery`]: {{site.api}}/flutter/widgets/MediaQuery-class.html

[#114459]: {{site.repo.flutter}}/pull/114459
[#143960]: {{site.repo.flutter}}/pull/143960

---

### Renamed builder typedefs for `AnimatedList`

Package: flutter
Supported by Flutter Fix: no

Com a adição de `AnimatedGrid`, `AnimatedList` foi refatorado para compartilhar uma classe base
comum. Os anteriormente nomeados `AnimatedListItemBuilder` e `AnimatedListRemovedItemBuilder`
foram renomeados para melhor refletir as classes com as quais poderiam ser usados após v3.5.
Renomeie quaisquer referências para `AnimatedItemBuilder` e `AnimatedRemovedItemBuilder`.

**References**

API documentation:

* [`AnimatedGrid`][]
* [`AnimatedList`][]
* [`AnimatedItemBuilder`][]
* [`AnimatedRemovedItemBuilder`][]

Relevant PRs:

* Deprecated in [#113793][]
* Removed in [#143974][]

[`AnimatedGrid`]: {{site.api}}/flutter/widgets/AnimatedGrid-class.html
[`AnimatedList`]: {{site.api}}/flutter/widgets/AnimatedList-class.html
[`AnimatedItemBuilder`]: {{site.api}}/flutter/widgets/AnimatedItemBuilder.html
[`AnimatedRemovedItemBuilder`]: {{site.api}}/flutter/widgets/AnimatedRemovedItemBuilder.html

[#113793]: {{site.repo.flutter}}/pull/113793
[#143974]: {{site.repo.flutter}}/pull/143974

---

### `FlutterDriver.enableAccessibility`

Package: flutter_driver
Supported by Flutter Fix: yes

O método `enableAccessibility` de `flutterDriver` foi descontinuado na v2.3. Ele
foi removido e substituído por `setSemantics`. Esta mudança tornou possível
habilitar ou desabilitar acessibilidade, ao invés de apenas habilitá-la.

**Migration guide**

Code before migration:

```dart
FlutterDriver driver = FlutterDriver.connectedTo(
  // ...
);
driver.enableAccessibility();
```

Code after migration:

```dart
FlutterDriver driver = FlutterDriver.connectedTo(
  // ...
);
driver.setSemantics(true);
```

**References**

API documentation:

* [`FlutterDriver`][]

Relevant PRs:

* Deprecated in [#82939][]
* Removed in [#143979][]

[`FlutterDriver`]: {{site.api}}/flutter/flutter_driver/FlutterDriver-class.html

[#82939]: {{site.repo.flutter}}/pull/82939
[#143979]: {{site.repo.flutter}}/pull/143979

---

### `TimelineSummary.writeSummaryToFile`

Package: flutter_driver
Supported by Flutter Fix: yes

O método `writeSummaryToFile` de `TimelineSummary` foi descontinuado na v2.1. Ele
foi removido e substituído por `writeTimelineToFile`.

**Migration guide**

Code before migration:

```dart
TimelineSummary summary = TimelineSummary.summarize(
  myTimeline,
);
summary.writeSummaryToFile(
  traceName,
  pretty: true,
);
```

Code after migration:

```dart
TimelineSummary summary = TimelineSummary.summarize(
  myTimeline,
);
summary.writeTimelineToFile(
  traceName,
  pretty: true,
);
```

**References**

API documentation:

* [`TimelineSummary`][]

Relevant PRs:

* Deprecated in [#79310][]
* Removed in [#143983][]

[`TimelineSummary`]: {{site.api}}/flutter/flutter_driver/TimelineSummary-class.html

[#79310]: {{site.repo.flutter}}/pull/79310
[#143983]: {{site.repo.flutter}}/pull/143983

### `Android Platform Views on API 22 and below `

Supported by Flutter Fix: no

A partir do Flutter 3.0, platform views requerem api 23 ou superior. No Flutter 3.19 agora lançamos UnsupportedOperationException
ao usar platform views em dispositivos android rodando api level 22 ou inferior.

**Migration guide**

Defina o nível mínimo de api para 23 (ou superior) ou verifique o nível de api android antes de exibir uma platform view.

---

As [descontinuações previamente anunciadas][previously announced] para menus de contexto, relacionadas a `ToolbarOptions`
assim como partes de `TextSelectionController` e `SelectableRegionState` não foram
removidas neste ciclo, para permitir mais tempo para migração.
Espere que essas descontinuações sejam removidas no próximo ciclo, o que será
anunciado novamente quando chegar a hora.

[previously announced]: https://groups.google.com/g/flutter-announce/c/8XjXpUKlnf8

---

## Timeline

In stable release: 3.22.0
