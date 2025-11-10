---
title: Kit de Ferramentas para Jogos Casuais
description: >-
  Aprenda sobre desenvolvimento de jogos 2D multiplataforma gratuito e open source no Flutter.
showBreadcrumbs: false
ia-translate: true
---

O Flutter Casual Games Toolkit reúne recursos novos e existentes
para que você possa acelerar o desenvolvimento de jogos em plataformas móveis.

:::recommend
Confira as últimas [atualizações e recursos de jogos para Flutter 3.22](#updates)!
:::

Esta página descreve onde você pode encontrar esses recursos disponíveis.

## Por que Flutter para jogos?

O framework Flutter pode criar apps performáticos para seis plataformas alvo,
desde o desktop até dispositivos móveis e a web.

Com os benefícios do Flutter de desenvolvimento multiplataforma, performance e
licenciamento open source, é uma ótima escolha para jogos.

Jogos casuais se dividem em duas categorias: jogos baseados em turnos
e jogos em tempo real.
Você pode estar familiarizado com ambos os tipos de jogos,
embora talvez não tenha pensado sobre eles exatamente dessa forma.

_Jogos baseados em turnos_ abrangem jogos destinados ao mercado de massa com
regras e gameplay simples.
Isso inclui jogos de tabuleiro, jogos de cartas, puzzles e jogos de estratégia.
Estes jogos respondem a entradas simples do usuário,
como tocar em uma carta ou inserir um número ou letra.
Estes jogos são adequados para Flutter.

_Jogos em tempo real_ abrangem jogos onde uma série de ações requer respostas em tempo real.
Isso inclui jogos endless runner, jogos de corrida e assim por diante.
Você pode querer criar um jogo com recursos avançados como detecção de colisão,
visões de câmera, loops de jogo e similares.
Estes tipos de jogos podem usar um motor de jogo open source como o
[Flame game engine][] construído usando Flutter.

## O que está incluído no kit de ferramentas

O Kit de Ferramentas para Jogos Casuais fornece os seguintes recursos gratuitos.

* Um repositório que inclui três novos modelos de jogos que fornecem
  um ponto de partida para construir um jogo casual.

  1. A [base game template][basic-template]
     that includes the basics for:

     * Main menu
     * Navigation
     * Settings
     * Level selection
     * Player progress
     * Play session management
     * Sound
     * Themes

  1. A [card game template][card-template]
     that includes everything in the base template plus:

     * Drag and drop
     * Game state management
     * Multiplayer integration hooks

  1. An [endless runner template][runner-template] created in partnership
     with the open source game engine, Flame. It implements:

     * A FlameGame base template
     * Player steering
     * Collision detection
     * Parallax effects
     * Spawning
     * Different visual effects

  1. A sample game built on top of the endless runner template,
     called SuperDash. You can play the game on iOS, Android,
     or [web][], [view the open source code repo][], or
     [read how the game was created in 6 weeks][].

* * Guias para desenvolvedores para integrar serviços necessários.
* Um link para um canal do [Discord Flame][game-discord].
  Se você tem uma conta Discord, use este [link direto][discord-direct].

Os modelos de jogos e receitas do cookbook incluídos fazem certas escolhas
para acelerar o desenvolvimento.
Eles incluem pacotes específicos, como `provider`, `google_mobile_ads`,
`in_app_purchase`, `audioplayers`, `crashlytics` e `games_services`.
Se você preferir outros pacotes, pode alterar o código para usá-los.

A equipe do Flutter entende que a monetização pode ser uma consideração futura.
Receitas do cookbook para publicidade e compras no app foram adicionadas.

Como explicado na página [Games][],
você pode aproveitar até $900 em ofertas ao integrar serviços Google,
como [Cloud, Firebase][] e [Ads][], no seu jogo.

:::important
Você deve conectar suas contas Firebase e GCP para usar créditos para
serviços Firebase e verificar seu e-mail comercial durante o cadastro para ganhar
um adicional de $100 além do crédito normal de $300.
Para a oferta de Ads, [verifique a elegibilidade da sua região][].
:::

## Começando

Você está pronto? Para começar:

1. Se você ainda não o fez, [instale o Flutter][].
1. [Clone o repositório de jogos][game-repo].
1. Revise o arquivo `README` para o primeiro tipo de jogo que você deseja criar.

   * [basic game][basic-template-readme]
   * [card game][card-template-readme]
   * [runner game][runner-template-readme]

1. [Junte-se à comunidade Flame no Discord][game-discord]
   (use o [link direto][discord-direct] se você já
   tem uma conta Discord).
1. Revise os codelabs e receitas do cookbook.

   * {{recipeIcon}} Build a [multiplayer game][multiplayer-recipe] with Cloud Firestore.
   * {{codelab}} Build a [word puzzle][] with Flutter.—**NEW**
   * {{codelab}} Build a [2D physics game][] with Flutter and Flame.—**NEW**
   * {{codelab}} [Add sound and music][] to your Flutter game with SoLoud.—**NEW**
   * {{recipeIcon}}Make your games more engaging
     with [leaderboards and achievements][leaderboard-recipe].
   * Monetize your games with {{recipeIcon}}[in-game ads][ads-recipe]
     and {{codelab}} [in-app purchases][iap-recipe].
   * Add user authentication flow to your game with
     {{recipeIcon}} [Firebase Authentication][firebase-auth].
   * Collect analytics about crashes and errors inside your game
     with {{recipeIcon}} [Firebase Crashlytics][firebase-crashlytics].

1. Configure contas no AdMob, Firebase e Cloud, conforme necessário.
1. Escreva seu jogo!
1. Faça o deploy nas lojas Google Play e Apple.

[Add sound and music]: {{site.codelabs}}/codelabs/flutter-codelab-soloud
[2D physics game]: {{site.codelabs}}/codelabs/flutter-flame-forge2d
[word puzzle]: {{site.codelabs}}/codelabs/flutter-word-puzzle

## Jogos de exemplo

Para o Google I/O 2022, tanto a equipe Flutter
quanto a Very Good Ventures criaram novos jogos.

* VGV created the [I/O Pinball game][pinball-game] using the Flame engine.
  To learn about this game,
  check out [I/O Pinball Powered by Flutter and Firebase][] on Medium
  and [play the game][pinball-game] in your browser.

* The Flutter team created [I/O Flip][flip-game], a virtual [CCG].
  To learn more about I/O Flip,
  check out [How It's Made: I/O FLIP adds a twist to a classic card game with generative AI][flip-blog]
  on the Google Developers blog and [play the game][flip-game] in your browser.

## Outros recursos

Quando você se sentir pronto para ir além desses modelos de jogos,
investigue outros recursos recomendados por nossa comunidade.

{% assign pkgIcon = '<span class="material-symbols" aria-label="Package" translate="no">package_2</span>' %}
{% assign apiIcon = '<span class="material-symbols" aria-label="API documentation" translate="no">api</span>' %}
{% assign docIcon = '<span class="material-symbols" aria-label="Guide" translate="no">quick_reference_all</span>' %}
{% assign codelab = '<span class="material-symbols" aria-label="Codelab" translate="no">science</span>' %}
{% assign engine = '<span class="material-symbols" aria-label="Game engine" translate="no">manufacturing</span>' %}
{% assign toolIcon = '<span class="material-symbols" aria-label="Desktop application" translate="no">handyman</span>' %}
{% assign recipeIcon = '<span class="material-symbols" aria-label="Cookbook recipe" translate="no">book_5</span>' %}
{% assign assetsIcon = '<span class="material-symbols" aria-label="Game assets" translate="no">photo_album</span>' %}

:::secondary
{{pkgIcon}} Flutter package<br>
{{apiIcon}} API documentation<br>
{{codelab}} Codelab<br>
{{recipeIcon}} Cookbook recipe<br>
{{toolIcon}} Desktop application<br>
{{assetsIcon}} Game assets<br>
{{docIcon}} Guide<br>
:::

<table class="table table-striped">
<tr>
<th>Feature</th>
<th>Resources</th>
</tr>

<tr>
<td>Animation and sprites</td>
<td>

{{recipeIcon}} [Special effects][]<br>
{{toolIcon}} [Spriter Pro][]<br>
{{pkgIcon}} [rive][]<br>
{{pkgIcon}} [spriteWidget][]

</td>
</tr>

<tr>
<td>App review</td>
<td>

{{pkgIcon}} [app_review][]

</td>
</tr>

<tr>
<td>Audio</td>
<td>

{{pkgIcon}} [audioplayers][]<br>
{{pkgIcon}} [flutter_soloud][]—**NEW**<br>
{{codelab}}  [Add sound and music to your Flutter game with SoLoud][]—**NEW**

</td>
</tr>

<tr>
<td>Authentication</td>
<td>

{{codelab}} [User Authentication using Firebase][firebase-auth]

</td>
</tr>

<tr>
<td>Cloud services</td>
<td>

{{codelab}} [Add Firebase to your Flutter game][]

</td>
</tr>

<tr>
<td>Debugging</td>
<td>

{{docIcon}} [Firebase Crashlytics overview][firebase-crashlytics]<br>
{{pkgIcon}} [firebase_crashlytics][]

</td>
</tr>

<tr>
<td>Drivers</td>
<td>

{{pkgIcon}} [win32_gamepad][]

</td>
</tr>

<tr>
<td>Game assets<br>and asset tools</td>
<td>

{{assetsIcon}} [CraftPix][]<br>
{{assetsIcon}} [Game Developer Studio][]<br>
{{toolIcon}} [GIMP][]

</td>
</tr>

<tr>
<td>Game engines</td>
<td>

{{pkgIcon}} [Flame][flame-pkg]<br>
{{pkgIcon}} [Bonfire][bonfire-pkg]<br>
{{pkgIcon}} [forge2d][]

</td>
</tr>

<tr>
<td>Game features</td>
<td>

{{recipeIcon}} [Add achievements and leaderboards to your game][leaderboard-recipe]<br>
{{recipeIcon}} [Add multiplayer support to your game][multiplayer-recipe]

</td>
</tr>

<tr>
<td>Game services integration</td>
<td>

{{pkgIcon}} [games_services][game-svc-pkg]

</td>
</tr>

<tr>
<td>Legacy code</td>
<td>

{{codelab}} [Use the Foreign Function Interface in a Flutter plugin][]

</td>
</tr>

<tr>
<td>Level editor</td>
<td>

{{toolIcon}} [Tiled][]

</td>
</tr>

<tr>
<td>Monetization</td>
<td>

{{recipeIcon}} [Add advertising to your Flutter game][ads-recipe]<br>
{{codelab}}  [Add AdMob ads to a Flutter app][]<br>
{{codelab}}  [Add in-app purchases to your Flutter app][iap-recipe]<br>
{{docIcon}} [Gaming UX and Revenue Optimizations for Apps][] (PDF)

</td>
</tr>

<tr>
<td>Persistence</td>
<td>

{{pkgIcon}} [shared_preferences][]<br>
{{pkgIcon}} [sqflite][]<br>
{{pkgIcon}} [cbl_flutter][] (Couchbase Lite)<br>

</td>
</tr>

<tr>
<td>Special effects</td>
<td>

{{apiIcon}} [Paint API][]<br>
{{recipeIcon}} [Special effects][]

</td>
</tr>

<tr>
<td>User Experience</td>
<td>

{{codelab}} [Build next generation UIs in Flutter][]<br>
{{docIcon}} [Best practices for optimizing Flutter web loading speed][]—**NEW**

</td>
</tr>
</table>

[Ads]: https://ads.google.com/intl/en_us/home/flutter/#!/
[Air Hockey]: https://play.google.com/store/apps/details?id=com.ignacemaes.airhockey
[CCG]: https://en.wikipedia.org/wiki/Collectible_card_game
[Cloud, Firebase]: https://cloud.google.com/free
[Flame game engine]: https://flame-engine.org/
[Games]: {{site.main-url}}/games
[I/O Pinball Powered by Flutter and Firebase]: {{site.medium}}/flutter/di-o-pinball-powered-by-flutter-and-firebase-d22423f3f5d
[install Flutter]: /get-started
[Tomb Toad]: https://play.google.com/store/apps/details?id=com.crescentmoongames.tombtoad
[basic-template-readme]: {{site.repo.games}}/blob/main/templates/basic/README.md
[basic-template]: {{site.repo.games}}/tree/main/templates/basic
[card-template-readme]: {{site.repo.games}}/blob/main/templates/card/README.md
[card-template]: {{site.repo.games}}/tree/main/templates/card
[check your region's eligibility]: https://www.google.com/intl/en/ads/coupons/terms/flutter/
[discord-direct]: https://discord.com/login?redirect_to=%2Fchannels%2F509714518008528896%2F788415774938103829
[firebase_crashlytics]: {{site.pub}}/packages/firebase_crashlytics
[flame-pkg]: {{site.pub}}/packages/flame
[flip-blog]: {{site.google-blog}}/2023/05/how-its-made-io-flip-adds-twist-to.html
[flip-game]: https://flip.withgoogle.com/#/
[game-discord]: https://discord.gg/qUyQFVbV45
[game-repo]: {{site.repo.games}}
[pinball-game]: https://pinball.flutterbrasil.dev/#/
[runner-template-readme]: {{site.repo.games}}/blob/main/templates/endless_runner/README.md
[runner-template]: {{site.repo.games}}/tree/main/templates/endless_runner

[Add AdMob ads to a Flutter app]: {{site.codelabs}}/codelabs/admob-ads-in-flutter
[Build next generation UIs in Flutter]: {{site.codelabs}}/codelabs/flutter-next-gen-uis
[firebase-crashlytics]: {{site.firebase}}/docs/crashlytics/get-started?platform=flutter
[ads-recipe]: /cookbook/plugins/google-mobile-ads
[iap-recipe]: {{site.codelabs}}/codelabs/flutter-in-app-purchases#0
[leaderboard-recipe]: /cookbook/games/achievements-leaderboard
[multiplayer-recipe]: /cookbook/games/firestore-multiplayer
[firebase-auth]: {{site.firebase}}/codelabs/firebase-auth-in-flutter-apps#0
[Use the Foreign Function Interface in a Flutter plugin]: {{site.codelabs}}/codelabs/flutter-ffigen
[bonfire-pkg]: {{site.pub}}/packages/bonfire
[CraftPix]: https://craftpix.net
[Add Firebase to your Flutter game]: {{site.firebase}}/docs/flutter/setup
[GIMP]: https://www.gimp.org
[Game Developer Studio]: https://www.gamedeveloperstudio.com
[Gaming UX and Revenue Optimizations for Apps]: {{site.main-url}}/go/games-revenue
[Paint API]: {{site.api}}/flutter/dart-ui/Paint-class.html
[Special effects]: /cookbook/effects
[Spriter Pro]: https://store.steampowered.com/app/332360/Spriter_Pro/
[app_review]: {{site.pub-pkg}}/app_review
[audioplayers]: {{site.pub-pkg}}/audioplayers
[cbl_flutter]: {{site.pub-pkg}}/cbl_flutter
[firebase_crashlytics]: {{site.pub-pkg}}/firebase_crashlytics
[forge2d]: {{site.pub-pkg}}/forge2d
[game-svc-pkg]: {{site.pub-pkg}}/games_services
[rive]: {{site.pub-pkg}}/rive
[shared_preferences]: {{site.pub-pkg}}/shared_preferences
[spriteWidget]: {{site.pub-pkg}}/spritewidget
[sqflite]: {{site.pub-pkg}}/sqflite
[win32_gamepad]: {{site.pub-pkg}}/win32_gamepad
[read how the game was created in 6 weeks]: {{site.flutter-blog}}/how-we-built-the-new-super-dash-demo-in-flutter-and-flame-in-just-six-weeks-9c7aa2a5ad31
[view the open source code repo]: {{site.github}}/flutter/super_dash
[web]: https://superdash.flutterbrasil.dev/
[Tiled]: https://www.mapeditor.org/
[flutter_soloud]: {{site.pub-pkg}}/flutter_soloud
[SoLoud codelab]: {{site.codelabs}}/codelabs/flutter-codelab-soloud

## Atualizações do Kit de Ferramentas para Jogos para o Flutter 3.22 {:#updates}

The following codelabs and guides were added for
the Flutter 3.22 release:

**Low-latency, high-performance sound**
: In collaboration with the Flutter community ([@Marco Bavagnoli][]),
  we've enabled the SoLoud audio engine.
  This free and portable engine delivers the low-latency and
  high-performance sound that's essential for many games.
  To help you get started, check out the new codelab,
  [Add sound and music to your Flutter game with SoLoud][],
  dedicated to adding sound and music to your game.

**Word puzzle games**
: Check out the new codelab,
  [Build a word puzzle with Flutter][],
  focused on building word puzzle games.
  This genre is perfect for exploring Flutter's UI capabilities,
  and this codelab dives into using Flutter's background processing
  to effortlessly generate expansive crossword-style grids of
  interlocking words without compromising the user experience.

**Forge 2D physics engine**
: The new Forge2D codelab,
  [Build a 2D physics game with Flutter and Flame][],
  guides you through crafting game mechanics in a
  Flutter and Flame game using a 2D physics simulation
  along the lines of Box2D, called [Forge2D][].

**Optimize loading speed for Flutter web-based games**
: In the fast-paced world of web-based gaming,
  a slow loading game is a major deterrent.
  Players expect instant gratification and will
  quickly abandon a game that doesn't load promptly.
  Hence, we've published a guide,
  [Best practices for optimizing Flutter web loading speed][],
  authored by [Cheng Lin][],
  to help you optimize your Flutter web-based games
  and apps for lightning-fast loading speeds.

[@Marco Bavagnoli]: {{site.github}}/alnitak
[Add sound and music to your Flutter game with SoLoud]: {{site.codelabs}}/codelabs/flutter-codelab-soloud
[Best practices for optimizing Flutter web loading speed]: {{site.flutter-blog}}/best-practices-for-optimizing-flutter-web-loading-speed-7cc0df14ce5c
[Build a word puzzle with Flutter]: {{site.codelabs}}/codelabs/flutter-word-puzzle
[Build a 2D physics game with Flutter and Flame]: {{site.codelabs}}/codelabs/flutter-flame-forge2d
[Cheng Lin]: {{site.medium}}/@mhclin113_26002
[Forge2D]: {{site.pub-pkgs}}/forge2d

## Outros novos recursos

Confira os seguintes vídeos:

* [Building multiplatform games with Flutter][gdc-talk], a talk
  given at the [Game Developer Conference (GDC)][] 2024.
* [How to build a physics-based game with Flutter and Flame's Forge2D][forge2d-video],
  from Google I/O 2024.

[Game Developer Conference (GDC)]: https://gdconf.com/
[forge2d-video]: {{site.youtube-site}}/watch?v=nsnQJrYHHNQ
[gdc-talk]: {{site.youtube-site}}/watch?v=7mG_sW40tsw
