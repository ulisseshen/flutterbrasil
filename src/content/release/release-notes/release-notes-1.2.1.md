---
ia-translate: true
title: Notas de lançamento do Flutter 1.2.1
shortTitle: Notas de lançamento 1.2.1
description: Notas de lançamento para o Flutter 1.2.1.
skipTemplateRendering: true
---

Nossa prioridade #1 desde o lançamento do Flutter v1.0 tem sido
continuar a atender problemas de alta prioridade reportados tanto por
desenvolvedores Flutter quanto pela própria equipe Flutter.
Isso inclui o commit de 672 pull requests no motor e framework Flutter
desde dezembro (estivemos ocupados!).
Destacamos as novas funcionalidades e mudanças incompatíveis
que achamos notáveis abaixo. As maiores vieram
das nossas tags Framework e Tool, mas também encontramos e
corrigimos alguns problemas Severe.

## Framework

Para complementar mais completamente o suporte de animação do Flutter,
este lançamento adiciona várias das funções de easing padrão:

[#25788](https://github.com/flutter/flutter/pull/25788) Add Robert Penner's easing functions

Para integrar mais completamente com Android,
este lançamento adiciona suporte para [Android App Bundles][Android App Bundles],
um novo formato de empacotamento que ajuda a reduzir o tamanho do app
e habilita novas funcionalidades como entrega dinâmica para apps Android:

[#24440](https://github.com/flutter/flutter/pull/24440) Adding support for android app bundle

Para integrar mais completamente com iOS, este lançamento adiciona várias novas funcionalidades e correções para iOS, incluindo um novo CupertinoTheme:

[#25183](https://github.com/flutter/flutter/pull/25183) Add navigatorKey to CupertinoTabView

[#25593](https://github.com/flutter/flutter/pull/25593) Let CupertinoTabScaffold handle keyboard insets too

[#24876](https://github.com/flutter/flutter/pull/24876) Adds a fade in and out, rounds corners, fixes offset and fixes height of cursor on iOS

[#23759](https://github.com/flutter/flutter/pull/23759) Adds CupertinoTheme

Além do suporte ao tema Cupertino do iOS, este lançamento continua a aprimorar o tema Material também:

[#24169](https://github.com/flutter/flutter/pull/24169) [Material] Theme-able elevation on dialogs

[#25339](https://github.com/flutter/flutter/pull/25339) [Material] Theme-able TextStyles for AlertDialog

Para integrar mais completamente com formatos desktop como tablets Android e ChromeOS, bem como suporte a web desktop e desktop OS, este lançamento adiciona mais suporte para teclado e mouse como dispositivos de entrada de primeira classe:

[#7758](https://github.com/flutter/engine/pull/7758) Recommended implementation of combining characters implementation

[#27853](https://github.com/flutter/flutter/pull/27853) Hook up character events and unmodified code points to Android raw key event handling

[#27620](https://github.com/flutter/flutter/pull/27620) Add a keyboard key code generator

[#27627](https://github.com/flutter/flutter/pull/27627) Adding support for logical and physical key events

[#6961](https://github.com/flutter/engine/pull/6961) Add hover event support to the engine

[#24830](https://github.com/flutter/flutter/pull/24830) Implement hover support for mouse pointers

Como widgets são a forma principal de interagir com usuários no Flutter, este lançamento continua a adicionar funcionalidades e correções ao conjunto de widgets Flutter com atenção particular ao [SliverAppBar](https://api.flutterbrasil.dev/flutter/material/SliverAppBar-class.html):

[#26021](https://github.com/flutter/flutter/pull/26021) Fix SliverAppBar title opacity and test all cases

[#26101](https://github.com/flutter/flutter/pull/26101) Fix a floating snapping SliverAppBar crash

[#25091](https://github.com/flutter/flutter/pull/25091) Add animations to SliverAppBar doc

[#24736](https://github.com/flutter/flutter/pull/24736) Provide some more locations for the FAB

[#25585](https://github.com/flutter/flutter/pull/25585) Expose font fallback API in TextStyle, Roll engine 54a3577c0139..215ca1560088

[#24457](https://github.com/flutter/flutter/pull/24457) Revise Android and iOS gestures on Material TextField

[#24554](https://github.com/flutter/flutter/pull/24554) Adds force press gesture detector and recognizer

[#23919](https://github.com/flutter/flutter/pull/23919) Allow detection of taps on TabBar

[#25384](https://github.com/flutter/flutter/pull/25384) Adds support for floating cursor

[#24976](https://github.com/flutter/flutter/pull/24976) Support TextField multi-line hint text

[#26332](https://github.com/flutter/flutter/pull/26332) Strut: fine tuned control over text minimum line heights, allows forcing the line height to be a specified height

E finalmente, como o uso do Flutter continua a crescer mundialmente, continuamos a aprimorar o suporte para localizações em vários idiomas, incluindo ucraniano, polonês, suaíli e galego neste lançamento.

[#25394](https://github.com/flutter/flutter/pull/25394) Update localizations

[#27506](https://github.com/flutter/flutter/pull/27506) Added support for Swahili (material_sw.arb)

[#27352](https://github.com/flutter/flutter/pull/24876) Including Galician language


## Plug-Ins

Assim como no framework e motor, estamos continuando a focar na qualidade dos plugins também:

[flutter/engine#7317](https://github.com/flutter/engine/pull/7317) Fix stale GrContext for iOS platform views

[flutter/engine#7558](https://github.com/flutter/engine/pull/7558) Fix lost touch events for iOS platform views

[flutter/plugins#1157](https://github.com/flutter/plugins/pull/1157) [google_maps_flutter] Fix camera positioning issue on iOS

[flutter/plugins#1176](https://github.com/flutter/plugins/pull/1176) [firebase_auth] Fix Firebase phone auth on Android

[flutter/plugins#1037](https://github.com/flutter/plugins/pull/1037) [camera] Save photo orientation on iOS

[flutter/plugins#1129](https://github.com/flutter/plugins/pull/1129) [android_alarm_manager] Fix "background start not allowed" issues, queue events that are received too early

[flutter/plugins#1051 ](https://github.com/flutter/plugins/pull/1051)[image_picker] Fix crash on iOS when the picker is tapped multiple times

O plugin webview_flutter ganhou um canal de comunicação entre Dart e JavaScript:

[flutter/plugins#1116](https://github.com/flutter/plugins/pull/1116) Add WebView JavaScript channels (Dart side)

[flutter/plugins#1130](https://github.com/flutter/plugins/pull/1130) WebView JavasScript channels Android implementation

[flutter/plugins#1139](https://github.com/flutter/plugins/pull/1139) WebView JavaScript channels - iOS implementation

[lutter/plugins1021](https://github.com/flutter/plugins/pull/1021) javascript evaluation ios/android

Fizemos progresso construindo o plugin In App Purchase (que ainda está em pré-lançamento):

[#1057](https://github.com/flutter/plugins/pull/1057) [IAP] Check if the payment processor is available

[#1084](https://github.com/flutter/plugins/pull/1084) [IAP] Fetch SkuDetails from Google Play

[#1068](https://github.com/flutter/plugins/pull/1068) IAP productlist ios

[#1172](https://github.com/flutter/plugins/pull/1172) [In_app_purchase] add payment objc translators


## Dart

O lançamento contém um novo Dart SDK que fornece suporte para uma nova sintaxe de set literals e aumenta a performance AOT em 10-20% reduzindo a sobrecarga de chamar construtores ou métodos estáticos:

[#37](https://github.com/dart-lang/language/issues/37) Set Literal

[#33274](https://github.com/dart-lang/sdk/issues/33274) Add support for "naked" instructions: global object pool, pc-relative static calls, faster indirect calls, potential code sharing


## Tool

Adicionamos várias novas ferramentas e novas funcionalidades às ferramentas existentes neste lançamento.

Este lançamento continua a melhorar mensagens de erro em uma variedade de ferramentas:

[#26107](https://github.com/flutter/flutter/pull/26107) Better error messages for flutter tool --dynamic flag

[#26084](https://github.com/flutter/flutter/pull/26084) Improve message when saving compilation training data

[#25863](https://github.com/flutter/flutter/pull/25863) Friendlier messages when using dynamic patching

Este lançamento também adiciona suporte para Java 1.8:

[#25470](https://github.com/flutter/flutter/pull/25470) Support Java 1.8


## Severe

Neste lançamento, encontramos e corrigimos alguns problemas graves do lançamento anterior, incluindo duas falhas e uma degradação de performance.

Crashes

[#7314](https://github.com/flutter/flutter/issues/7314) Flutter crash on startup (metabug)

Performance

[#25381](https://github.com/flutter/flutter/pull/25381) Add cull opacity perf test to device lab


## Breaking Changes

Em um esforço para continuar a melhorar o Flutter desde a versão 1.0 para atender às necessidades dos clientes, tivemos que fazer algumas mudanças incompatíveis:

### [#8769](https://github.com/flutter/flutter/pull/8769) Rename ListItem to ListTile, document ListTile fixed height geometry

Muitos desenvolvedores estavam confusos pelo fato de que ListItem tinha altura fixa. Renomeamos para ListTile, para indicar que (como outros tiles) sua altura é fixa, e a documentação foi atualizada para dizer claramente isso sobre ListTile. Você precisará renomear instâncias da classe ListItem para ListTile no seu código.

### [#7518](https://github.com/flutter/engine/pull/7518) Update default flutter_assets path for iOS embedding

Os assets Flutter para aplicações iOS agora são encontrados em Frameworks/App.framework/flutter_assets ao invés de flutter_assets. A ferramenta de linha de comando flutter deve cuidar dessa diferença, mas se você está escrevendo uma aplicação AddToApp para iOS que compartilha assets com Flutter, você precisará estar ciente dessa mudança.


### [#27697](https://github.com/flutter/flutter/pull/27697) Cupertino TextField Cursor Fix

O padrão do cursorColor do CupertinoTextField agora corresponde ao tema do app. Se isso for indesejável, desenvolvedores podem usar a propriedade cupertinoOverrideTheme de ThemeData para fornecer uma substituição específica do Cupertino usando um objeto CupertinoThemeData, por exemplo:

```dart
Widget build(BuildContext context) {
  // Set theme data for override in the CupertinoThemeData's constructor
  Theme.of(context).cupertinoOverrideTheme = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF42A5F5)
  );
  return Text(
    'Example',
    style: Theme.of(context).textTheme.title,
  );
}
```


### [#23424](https://github.com/flutter/flutter/pull/23424) Teach drag start behaviors to DragGestureRecognizer

Por padrão, o callback onStart de um detector de gesto de arrastar será chamado com a localização de onde um gesto de arrastar é detectado (ou seja, após arrastar um certo número de pixels) ao invés da localização do toque inicial. Para usar a funcionalidade antiga com um determinado reconhecedor de gesto de arrastar, a variável dragStartBehavior do reconhecedor deve ser definida como DragStartBehavior.down, por exemplo, inclua a linha em negrito abaixo ao declarar seu GestureDecorator:

```dart
GestureDectector(
  dragStartBehavior: DragStartBehavior.down,
  onVerticalDragDown: myDragDown
  onVerticalDragEnd: myDragEnd,
  onVerticalDragStart: myDragStart,
  onVerticalDragUpdate: myDragUpdate,
  onVerticalDragCancel: myDragCancel,
  onHorizontalDragDown: myDragDown
  onHorizontalDragEnd: myDragEnd,
  onHorizontalDragStart: myDragStart,
  onHorizontalDragUpdate: myDragUpdate,
  onHorizontalDragCancel: myDragCancel,
// Other fields…
```


### [#26238](https://github.com/flutter/flutter/pull/26238) Remove long-deprecated TwoLevelList

Removido o widget TwoLevelList há muito tempo obsoleto; use ListView com ExpansionTile ao invés. Veja [este exemplo](https://github.com/flutter/flutter/blob/v1.2.1/examples/catalog/lib/expansion_tile_sample.dart) para um exemplo que usa ExpansionTile.


###[#7442](https://github.com/flutter/engine/pull/7442) Move Picture.toImage rasterization to the GPU thread

Picture.toImage agora retorna um `Future<Image>` ao invés. Isso permite que a rasterização de imagem ocorra na thread GPU, melhorando a performance em muitos casos e garantindo resultados corretos. No mínimo, você precisará declarar métodos que invocam instâncias Picture como async, e usar await, assim:

```dart
void usePictureImage(Picture p) async {
  var image = await p.toImage();
  // Do something with the pixels in image….
}
```

No entanto, sua aplicação pode muito bem estar executando outras ações assíncronas, e você deve considerar como deseja lidar com o processamento de imagem sob essa perspectiva. Para mais sobre o suporte do Dart para programação assíncrona e a classe Future, veja [https://dartbrasil.dev/tutorials/language/futures.](https://dartbrasil.dev/tutorials/language/futures)


### [#7567](https://github.com/flutter/engine/pull/7567) Rename FlutterResult in embedder.h

Na API Embedder, o tipo FlutterResult foi renomeado para FlutterEngineResult para melhor explicar seu propósito. Você precisará renomear quaisquer instâncias do primeiro para o último.


### [#7414](https://github.com/flutter/engine/pull/7414) Strut implementation

Renomear dart:ui ParagraphStyle.lineHeight para ParagraphStyle.height. A propriedade ParagraphStyle.lineHeight anteriormente não fazia nada e foi renomeada para permanecer consistente com TextStyle.height. Você precisará renomear quaisquer instâncias do primeiro para o último.


## Regressions

Logo após nosso lançamento 1.2, encontramos duas regressões:


* [#28640](https://github.com/flutter/flutter/issues/28640) NoSuchMethodError: android.view.MotionEvent.isFromSource

[flutter/flutter#24830](https://github.com/flutter/flutter/pull/24830) ("Implement hover support for mouse pointers.") está usando uma API Android que não existe em dispositivos mais antigos. Isso pode causar uma falha no Android 4.1 (Jellybean) e 4.1 (Jellybean MR1).


* [#28484](https://github.com/flutter/flutter/issues/28484) Widget rendering strange since Flutter update

Isso pode causar problemas de renderização ao carregar certas imagens em dispositivos iOS físicos.

Para obter uma correção para essas regressões, uma vez que o beta 1.3 seja lançado em março, você pode mudar para o canal beta e executar um "flutter upgrade" na linha de comando. No momento da escrita, isso irá atualizá-lo para pelo menos a versão 1.3.8, que inclui [flutter/engine#8006](https://github.com/flutter/engine/pull/8006) ("Guard against using Android API not defined in API level 16 & 17") e o commit Skia que corrige o problema de renderização. Para o problema de falha, as duas versões afetadas do Android têm mais de dez anos e representam no máximo 2,5% dos usuários Android, poucos dos quais provavelmente estão instalando novos aplicativos Android, sejam eles Flutter ou não. Mesmo assim, odiamos deixar regressões conhecidas em um lançamento estável, mas após muito debate interno, decidimos que era a melhor maneira de proceder para desenvolvedores Flutter e seus usuários de app.

Nossa correção ideal para qualquer problema sério é criar um lançamento "hotfix" pegando um lançamento existente e fazendo "cherry pick" das correções que gostaríamos de aplicar. A capacidade de fazer hotfix em um lançamento estável existente é algo que implementamos para 1.2 mas ainda não chegamos à qualidade de produção. A consequência disso é que se tivéssemos criado um novo lançamento estável "1.2.1-a" com a correção para as regressões, teríamos deixado todos os nossos usuários presos naquele branch; atualizar para branches futuros teria exigido que os usuários removessem e reinstalassem o Flutter do zero, o que era claramente inaceitável. Estamos trabalhando duro para validar nossa capacidade de fazer hotfix em 1.3+ para que não tenhamos esse problema novamente.

Outra opção teria sido trazer o 1.3 para um lançamento estável. Nossa política atual é trazer um novo lançamento estável apenas uma vez por trimestre para reduzir a agitação para desenvolvedores Flutter. No momento da escrita, o lançamento pré-estável 1.3 contém 104 commits de framework (e ainda mais commits de motor, Dart e Skia), qualquer um dos quais é um risco para como seus apps atuais estão rodando. Para reduzir esse risco, deixamos lançamentos em beta por um mês, permitimos que desenvolvedores os testem, e apenas promovemos lançamentos para o canal estável quando estamos confiantes neles. É assim que mantemos estabilidade nos lançamentos trimestrais.

Nosso próximo lançamento estável está atualmente planejado para maio de 2019, que é o primeiro lançamento estável que incluirá a correção para essa regressão. Se você for afetado por [#28640](https://github.com/flutter/flutter/issues/28640) e sentir que a solução alternativa de usar o pré-lançamento 1.3 não é uma opção para você, por favor nos informe em [flutter/flutter#29235](https://github.com/flutter/flutter/issues/29235). Da mesma forma, se você for afetado por [#28484](https://github.com/flutter/flutter/issues/28484), nos informe em [flutter/flutter/#29360](https://github.com/flutter/flutter/issues/29360). Se descobrirmos que há muito feedback da comunidade Flutter de que tomamos a decisão errada aqui, usaremos seu feedback para reavaliar. Flutter é, afinal de contas, um esforço da comunidade, e suas opiniões importam.


## Tooling Releases

Além das mudanças no framework Flutter no lançamento 1.2, fizemos vários lançamentos de ferramentas no mesmo período, sobre os quais você pode ler aqui:



*   Dart & Flutter support for Visual Studio Code: versions [2.21](https://dartcode.org/releases/v2-21/), [2.22](https://dartcode.org/releases/v2-22/), [2.23](https://dartcode.org/releases/v2-23/) and [2.24](https://dartcode.org/releases/v2-24/).
*   Dart & Flutter support for IntelliJ & Android Studio: [January, 2019](https://groups.google.com/forum/#!searchin/flutter-dev/nilay%7Csort:date/flutter-dev/VCfGRhDsHgs/JcYKxkxHBAAJ) and [February, 2019](https://groups.google.com/forum/#!searchin/flutter-dev/nilay%7Csort:date/flutter-dev/VCfGRhDsHgs/JcYKxkxHBAAJ) releases.
*   Dart DevTools [alpha release](/tools/devtools).

## Full Issue List

Você pode ver [a lista completa de PRs commitados neste lançamento](/release/release-notes/changelogs/changelog-1.2.1).

[Android App Bundles]: https://developer.android.com/guide/app-bundle/
