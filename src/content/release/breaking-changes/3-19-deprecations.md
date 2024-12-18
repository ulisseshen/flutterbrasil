---
ia-translate: true
title: API Deprecadas Removidas após a v3.19
description: >-
  Após atingir o fim da vida útil, as seguintes APIs deprecadas
  foram removidas do Flutter.
---

## Resumo

De acordo com a [Política de Depreciação][] do Flutter,
APIs deprecadas que atingiram o fim da vida útil após o
lançamento estável 3.19 foram removidas.

Todas as APIs afetadas foram compiladas nesta
fonte primária para auxiliar na migração.
Para auxiliar ainda mais na sua migração, confira esta
[folha de referência rápida][].

[Política de Depreciação]: {{site.repo.flutter}}/blob/master/docs/contributing/Tree-hygiene.md#deprecations
[folha de referência rápida]: /go/deprecations-removed-after-3-19

## Mudanças

Esta seção lista as depreciações pelo pacote e classe afetada.

### `TextTheme`

Pacote: flutter
Suportado pelo Flutter Fix: sim

Várias propriedades `TextStyle` de `TextTheme` foram deprecadas na v3.1 para suportar
novos estilos da especificação do Material Design. Elas estão
listadas na tabela a seguir, juntamente com a substituição apropriada na
nova API.

| Depreciação | Nova API     |
|-------------|--------------|
| headline1   | displayLarge |
| headline2   | displayMedium|
| headline3   | displaySmall |
| headline4   | headlineMedium|
| headline5   | headlineSmall|
| headline6   | titleLarge   |
| subtitle1   | titleMedium  |
| subtitle2   | titleSmall   |
| bodyText1   | bodyLarge    |
| bodyText2   | bodyMedium   |
| caption     | bodySmall    |
| button      | labelLarge   |
| overline    | labelSmall   |

**Guia de migração**

Código antes da migração:

```dart
// TextTheme
// Construtor base
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

Código após a migração:

```dart
// TextTheme
// Construtor base
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

**Referências**

Documentação da API:

* [`TextTheme`][]

PRs relevantes:

* Deprecado em [#109817][]
* Removido em [#139255][]

[`TextTheme`]: {{site.api}}/flutter/material/TextTheme-class.html

[#109817]: {{site.repo.flutter}}/pull/109817
[#139255]: {{site.repo.flutter}}/pull/139255

---

### `ThemeData`

Pacote: flutter
Suportado pelo Flutter Fix: sim

Várias propriedades `Color` de `ThemeData` foram deprecadas na v3.3 para suportar
novos estilos da especificação do Material Design. Essas cores eram `errorColor`,
`backgroundColor`, `bottomAppBarColor` e `toggleableActiveColor`. As duas primeiras são
substituídas por propriedades de `ThemeData.colorScheme`, enquanto `bottomAppBarColor` é
substituída pela cor do tema do componente, `BottomAppBarTheme`. A
`toggleableActiveColor` não era mais usada pelo framework e foi removida.

**Guia de migração**

Código antes da migração:

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

Código após a migração:

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

**Referências**

Documentação da API:

* [`ThemeData`][]
* [`ColorScheme`][]
* [`BottomAppBarTheme`][]

PRs relevantes:

* Deprecado em [#110162][], [#111080][] e [#97972][]
* Removido em [#144178][], [#144080][], [#144079][] e [#144078][]

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

Pacote: flutter
Suportado pelo Flutter Fix: sim

O `previewBuilder` foi substituído pelo `builder` de `CupertinoContextMenu` após
a v3.4. Ao adicionar `builder`, toda a animação executada pelo menu de contexto
é coberta, sendo que a segunda metade era realizada por `previewBuilder`, e
delineada por `CupertinoContextMenu.animationOpensAt`.

**Guia de migração**

Código antes da migração:

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

Código após a migração:

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

**Referências**

Documentação da API:

* [`CupertinoContextMenu`][]

PRs relevantes:

* Deprecado em [#110616][]
* Removido em [#143990][]

[`CupertinoContextMenu`]: {{site.api}}/flutter/cupertino/CupertinoContextMenu-class.html

[#110616]: {{site.repo.flutter}}/pull/110616
[#143990]: {{site.repo.flutter}}/pull/143990

---

### `Scrollbar.showTrackOnHover`

Pacote: flutter
Suportado pelo Flutter Fix: sim

A propriedade `showTrackOnHover` de `Scrollbar`, e seu tema de componente associado,
`ScrollbarThemeData.showTrackOnHover`, foram substituídos pela propriedade stateful
`ScrollbarThemeData.trackVisibility` após a v3.4. Ao utilizar `trackVisibility`,
todas as permutações de estado podem influenciar na exibição da track da barra de rolagem, não
apenas o hover.

**Guia de migração**

Código antes da migração:

```dart
Scrollbar(
  showTrackOnHover: true,
  child: //...
);
ScrollbarThemeData(
  showTrackOnHover: true,
);
```

Código após a migração:

```dart
Scrollbar(
  child: //...
);
ScrollbarThemeData(
  // Isso sempre mostrará a track para qualquer estado.
  trackVisibility: MaterialStateProperty<bool>.all(true),
);
// Ou
ScrollbarThemeData(
  // Mostra apenas no hover.
  trackVisibility: (Set<MaterialState> states) => states.contains(MaterialState.hovered),
);
```

**Referências**

Documentação da API:

* [`Scrollbar`][]
* [`ScrollbarThemeData`][]
* [`MaterialState`][]
* [`MaterialStateProperty`][]

PRs relevantes:

* Deprecado em [#111706][]
* Removido em [#144180][]

[`Scrollbar`]: {{site.api}}/flutter/material/Scrollbar-class.html
[`ScrollbarThemeData`]: {{site.api}}/flutter/material/ScrollbarThemeData-class.html
[`MaterialState`]: {{site.api}}/flutter/material/MaterialState-class.html
[`MaterialStateProperty`]: {{site.api}}/flutter/material/MaterialStateProperty-class.html

[#111706]: {{site.repo.flutter}}/pull/111706
[#144180]: {{site.repo.flutter}}/pull/144180

---

### Método `KeepAliveHandle.release`

Pacote: flutter
Suportado pelo Flutter Fix: não

O método `release` de `KeepAliveHandle` foi removido e substituído por chamar
`dispose` após a v3.3. Essa alteração foi feita porque descobriu-se que `release` era
frequentemente chamado sem chamar `dispose` em seguida, levando a vazamentos de memória. O método
`dispose` executa a mesma funcionalidade que `release` fazia agora.

**Guia de migração**

Código antes da migração:

```dart
KeepAliveHandle handle = KeepAliveHandle();
handle.release();
handle.dispose();
```

Código após a migração:

```dart
KeepAliveHandle handle = KeepAliveHandle();
handle.dispose();
```

**Referências**

Documentação da API:

* [`KeepAliveHandle`][]

PRs relevantes:

* Deprecado em [#108384][]
* Removido em [#143961][]

[`KeepAliveHandle`]: {{site.api}}/flutter/widgets/KeepAliveHandle-class.html

[#108384]: {{site.repo.flutter}}/pull/108384
[#143961]: {{site.repo.flutter}}/pull/143961

---

### `InteractiveViewer.alignPanAxis`

Pacote: flutter
Suportado pelo Flutter Fix: sim

A propriedade `alignPanAxis` de `InteractiveViewer` foi removida e substituída por
`panAxis` após a v3.3. Essa alteração foi feita para habilitar mais modos de pan em
`InteractiveViewer`.

**Guia de migração**

Código antes da migração:

```dart
InteractiveViewer(
  alignPanAxis: true,
);
```

Código após a migração:

```dart
InteractiveViewer(
  panAxis: PanAxis.aligned,
);
```

**Referências**

Documentação da API:

* [`InteractiveViewer`][]
* [`PanAxis`][]

PRs relevantes:

* Deprecado em [#109014][]
* Removido em [#142500][]

[`InteractiveViewer`]: {{site.api}}/flutter/widgets/InteractiveViewer-class.html
[`PanAxis`]: {{site.api}}/flutter/widgets/PanAxis.html

[#109014]: {{site.repo.flutter}}/pull/109014
[#142500]: {{site.repo.flutter}}/pull/142500

---

### `MediaQuery.boldTextOverride`

Pacote: flutter
Suportado pelo Flutter Fix: sim

O método `boldTextOverride` de `MediaQuery` foi removido e substituído por
`boldTextOf` após a v3.5. Essa alteração foi feita como parte de uma refatoração maior de
`MediaQuery`, principalmente reduzindo o número de reconstruções que seriam
acionadas por widgets que dependem dele.

**Guia de migração**

Código antes da migração:

```dart
MediaQuery.boldTextOverride(context);
```

Código após a migração:

```dart
MediaQuery.boldTextOf(context)
```

**Referências**

Documentação da API:

* [`MediaQuery`][]

PRs relevantes:

* Deprecado em [#114459][]
* Removido em [#143960][]

[`MediaQuery`]: {{site.api}}/flutter/widgets/MediaQuery-class.html

[#114459]: {{site.repo.flutter}}/pull/114459
[#143960]: {{site.repo.flutter}}/pull/143960

---

### Typedefs de builder renomeados para `AnimatedList`

Pacote: flutter
Suportado pelo Flutter Fix: não

Com a adição de `AnimatedGrid`, `AnimatedList` foi refatorado para compartilhar uma base
classe comum. Os anteriormente nomeados `AnimatedListItemBuilder` e `AnimatedListRemovedItemBuilder`
foram renomeados para melhor refletir as classes com as quais poderiam ser usados após a v3.5.
Renomeie qualquer referência para `AnimatedItemBuilder` e `AnimatedRemovedItemBuilder`.

**Referências**

Documentação da API:

* [`AnimatedGrid`][]
* [`AnimatedList`][]
* [`AnimatedItemBuilder`][]
* [`AnimatedRemovedItemBuilder`][]

PRs relevantes:

* Deprecado em [#113793][]
* Removido em [#143974][]

[`AnimatedGrid`]: {{site.api}}/flutter/widgets/AnimatedGrid-class.html
[`AnimatedList`]: {{site.api}}/flutter/widgets/AnimatedList-class.html
[`AnimatedItemBuilder`]: {{site.api}}/flutter/widgets/AnimatedItemBuilder.html
[`AnimatedRemovedItemBuilder`]: {{site.api}}/flutter/widgets/AnimatedRemovedItemBuilder.html

[#113793]: {{site.repo.flutter}}/pull/113793
[#143974]: {{site.repo.flutter}}/pull/143974

---

### `FlutterDriver.enableAccessibility`

Pacote: flutter_driver
Suportado pelo Flutter Fix: sim

O método `enableAccessibility` de `flutterDriver` foi deprecado na v2.3. Ele
foi removido e substituído por `setSemantics`. Essa alteração tornou possível
habilitar ou desabilitar a acessibilidade, em vez de apenas habilitá-la.

**Guia de migração**

Código antes da migração:

```dart
FlutterDriver driver = FlutterDriver.connectedTo(
  // ...
);
driver.enableAccessibility();
```

Código após a migração:

```dart
FlutterDriver driver = FlutterDriver.connectedTo(
  // ...
);
driver.setSemantics(true);
```

**Referências**

Documentação da API:

* [`FlutterDriver`][]

PRs relevantes:

* Deprecado em [#82939][]
* Removido em [#143979][]

[`FlutterDriver`]: {{site.api}}/flutter/flutter_driver/FlutterDriver-class.html

[#82939]: {{site.repo.flutter}}/pull/82939
[#143979]: {{site.repo.flutter}}/pull/143979

---

### `TimelineSummary.writeSummaryToFile`

Pacote: flutter_driver
Suportado pelo Flutter Fix: sim

O método `writeSummaryToFile` de `TimelineSummary` foi deprecado na v2.1. Ele
foi removido e substituído por `writeTimelineToFile`.

**Guia de migração**

Código antes da migração:

```dart
TimelineSummary summary = TimelineSummary.summarize(
  myTimeline,
);
summary.writeSummaryToFile(
  traceName,
  pretty: true,
);
```

Código após a migração:

```dart
TimelineSummary summary = TimelineSummary.summarize(
  myTimeline,
);
summary.writeTimelineToFile(
  traceName,
  pretty: true,
);
```

**Referências**

Documentação da API:

* [`TimelineSummary`][]

PRs relevantes:

* Deprecado em [#79310][]
* Removido em [#143983][]

[`TimelineSummary`]: {{site.api}}/flutter/flutter_driver/TimelineSummary-class.html

[#79310]: {{site.repo.flutter}}/pull/79310
[#143983]: {{site.repo.flutter}}/pull/143983

### `Platform Views Android em API 22 e inferior`

Suportado pelo Flutter Fix: não

A partir do Flutter 3.0, as platform views exigem a API 23 ou superior. No Flutter 3.19, agora lançamos UnsupportedOperationException
ao usar platform views em dispositivos Android executando o nível de API 22 e inferior.

**Guia de migração**

Defina o nível mínimo da API para 23 (ou superior) ou verifique o nível da API do Android antes de exibir uma platform view.

---

As depreciações [anunciadas anteriormente][] para menus de contexto, relacionadas a `ToolbarOptions`
bem como partes de `TextSelectionController` e `SelectableRegionState` não foram
removidas neste ciclo, para permitir mais tempo para migração.
Espere que essas depreciações sejam removidas no próximo ciclo, que será
anunciado novamente quando chegar a hora.

[anunciadas anteriormente]: https://groups.google.com/g/flutter-announce/c/8XjXpUKlnf8

---

## Cronograma

Em versão estável: 3.22.0

