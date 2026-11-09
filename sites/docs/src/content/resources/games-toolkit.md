---
title: Kit de Ferramentas para Jogos Casuais
description: >-
  Aprenda sobre desenvolvimento de jogos 2D multiplataforma gratuito e open source no Flutter.
showBreadcrumbs: false
ia-translate: true
---

O Flutter Casual Games Toolkit reúne recursos novos e existentes
para que você possa acelerar o desenvolvimento de jogos em plataformas móveis.

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

_Jogos em tempo real_ abrangem jogos com uma série de ações que
requerem respostas em tempo real.
Isso inclui jogos endless runner, jogos de corrida e assim por diante.
Você pode querer criar um jogo com recursos avançados como detecção de colisão,
visões de câmera, loops de jogo e similares.
Estes tipos de jogos podem usar um motor de jogo open source como o
[Flame game engine][] construído usando Flutter.

## O que está incluído no kit de ferramentas

O Kit de Ferramentas para Jogos Casuais fornece os seguintes recursos gratuitos.

* Um repositório que inclui três modelos de jogos que fornecem
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
Para a oferta de Ads, [verifique a elegibilidade da sua região][check your region's eligibility].
:::

## Começando

Você está pronto? Para começar:

1. Se você ainda não o fez, [instale o Flutter][install Flutter].
1. [Clone o repositório de jogos][game-repo].
1. Revise o arquivo `README` para o primeiro tipo de jogo que você deseja criar.

   * [basic game][basic-template-readme]
   * [card game][card-template-readme]
   * [runner game][runner-template-readme]

1. [Junte-se à comunidade Flame no Discord][game-discord]
   (use o [link direto][discord-direct] se você já
   tem uma conta Discord).
1. Revise os codelabs e receitas do cookbook.

   * Construa um [jogo multiplayer][multiplayer-recipe] com Cloud Firestore.
   * Construa um [quebra-cabeça de palavras][word puzzle] com Flutter.
   * Torne seus jogos mais envolventes
     com [placares e conquistas][leaderboard-recipe].
   * Monetize seus jogos com [anúncios no jogo][ads-recipe]
     e [compras no app][iap-recipe].
   * Adicione um fluxo de autenticação de usuários ao seu jogo com
     [Firebase Authentication][firebase-auth].
   * Colete análises sobre falhas e erros dentro do seu jogo
     com [Firebase Crashlytics][firebase-crashlytics].

1. Configure contas no AdMob, Firebase e Cloud, conforme necessário.
1. Escreva seu jogo!
1. Faça o deploy nas lojas Google Play e Apple.

[word puzzle]: {{site.codelabs}}/codelabs/flutter-word-puzzle

## Jogos de exemplo

Para o Google I/O 2022, tanto a equipe Flutter
quanto a Very Good Ventures criaram novos jogos.

* A VGV criou o [jogo I/O Pinball][pinball-game] usando o motor Flame.
  Para saber mais sobre esse jogo,
  leia [I/O Pinball Powered by Flutter and Firebase][] no blog do Flutter
  e [jogue o jogo][pinball-game] no seu navegador.

* A equipe Flutter criou o [I/O Flip][flip-game], um [CCG] virtual.
  Para saber mais sobre o I/O Flip,
  confira [How It's Made: I/O FLIP adds a twist to a classic card game with generative AI][flip-blog]
  no blog do Google Developers e [jogue o jogo][flip-game] no seu navegador.


## Outros recursos

Quando você se sentir pronto para ir além desses modelos de jogos,
investigue outros recursos recomendados por nossa comunidade.

<table class="table table-striped">
<tr>
<th>Feature</th>
<th>Resources</th>
</tr>

<tr>
<td>Animation and sprites</td>
<td>

<Icon id="book_5" title="Cookbook recipe"></Icon> [Special effects][]<br>
<Icon id="handyman" title="Desktop tool"></Icon> [Spriter Pro][]<br>
<Icon id="package_2" title="Flutter package"></Icon> [rive][]

</td>
</tr>

<tr>
<td>App review</td>
<td>

<Icon id="package_2" title="Flutter package"></Icon> [app_review][]

</td>
</tr>

<tr>
<td>Audio</td>
<td>

<Icon id="package_2" title="Flutter package"></Icon> [audioplayers][]<br>
<Icon id="package_2" title="Flutter package"></Icon> [flutter_soloud][]<br>

</td>
</tr>

<tr>
<td>Authentication</td>
<td>

<Icon id="science" title="Codelab"></Icon> [User Authentication using Firebase][firebase-auth]

</td>
</tr>

<tr>
<td>Cloud services</td>
<td>

<Icon id="science" title="Codelab"></Icon> [Add Firebase to your Flutter game][]

</td>
</tr>

<tr>
<td>Debugging</td>
<td>

<Icon id="quick_reference_all" title="Guide"></Icon> [Firebase Crashlytics overview][firebase-crashlytics]<br>
<Icon id="package_2" title="Flutter package"></Icon> [firebase_crashlytics][]

</td>
</tr>

<tr>
<td>Drivers</td>
<td>

<Icon id="package_2" title="Flutter package"></Icon> [win32_gamepad][]

</td>
</tr>

<tr>
<td>Game assets<br>and asset tools</td>
<td>

<Icon id="photo_album" title="Game assets"></Icon> [CraftPix][]<br>
<Icon id="photo_album" title="Game assets"></Icon> [Game Developer Studio][]<br>
<Icon id="handyman" title="Desktop tool"></Icon> [GIMP][]

</td>
</tr>

<tr>
<td>Game engines</td>
<td>

<Icon id="package_2" title="Flutter package"></Icon> [Flame][flame-pkg]<br>
<Icon id="package_2" title="Flutter package"></Icon> [Bonfire][bonfire-pkg]<br>
<Icon id="package_2" title="Flutter package"></Icon> [forge2d][]

</td>
</tr>

<tr>
<td>Game features</td>
<td>

<Icon id="book_5" title="Cookbook recipe"></Icon> [Add achievements and leaderboards to your game][leaderboard-recipe]<br>
<Icon id="book_5" title="Cookbook recipe"></Icon> [Add multiplayer support to your game][multiplayer-recipe]

</td>
</tr>

<tr>
<td>Game services integration</td>
<td>

<Icon id="package_2" title="Flutter package"></Icon> [games_services][game-svc-pkg]

</td>
</tr>

<tr>
<td>Level editor</td>
<td>

<Icon id="handyman" title="Desktop tool"></Icon> [Tiled][]

</td>
</tr>

<tr>
<td>Monetization</td>
<td>

<Icon id="book_5" title="Cookbook recipe"></Icon> [Add advertising to your Flutter game][ads-recipe]<br>
<Icon id="science" title="Codelab"></Icon> [Add AdMob ads to a Flutter app][]<br>
<Icon id="science" title="Codelab"></Icon> [Add in-app purchases to your Flutter app][iap-recipe]<br>
<Icon id="science" title="Codelab"></Icon> [Gaming UX and Revenue Optimizations for Apps][] (PDF)<br>

</td>
</tr>

<tr>
<td>Persistence</td>
<td>

<Icon id="package_2" title="Flutter package"></Icon> [shared_preferences][]<br>
<Icon id="package_2" title="Flutter package"></Icon> [sqflite][]<br>
<Icon id="package_2" title="Flutter package"></Icon> [cbl_flutter][] (Couchbase Lite)<br>

</td>
</tr>

<tr>
<td>Special effects</td>
<td>

<Icon id="api" title="API documentation"></Icon> [Paint API][]<br>
<Icon id="book_5" title="Cookbook recipe"></Icon> [Special effects][]

</td>
</tr>

<tr>
<td>User Experience</td>
<td>

<Icon id="quick_reference_all" title="Guide"></Icon> [Best practices for optimizing Flutter web loading speed][]

</td>
</tr>
</table>

[Ads]: https://ads.google.com/intl/en_us/home/flutter/#!/
[Air Hockey]: https://play.google.com/store/apps/details?id=com.ignacemaes.airhockey
[CCG]: https://en.wikipedia.org/wiki/Collectible_card_game
[Cloud, Firebase]: https://cloud.google.com/free
[Flame game engine]: https://flame-engine.org/
[Games]: {{site.main-url}}/games
[I/O Pinball Powered by Flutter and Firebase]: https://flutter.dev/blog/i-o-pinball-powered-by-flutter-and-firebase
[install Flutter]: /install
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
[firebase-crashlytics]: {{site.firebase}}/docs/crashlytics/get-started?platform=flutter
[ads-recipe]: /cookbook/plugins/google-mobile-ads
[iap-recipe]: {{site.codelabs}}/codelabs/flutter-in-app-purchases#0
[leaderboard-recipe]: /cookbook/games/achievements-leaderboard
[multiplayer-recipe]: /cookbook/games/firestore-multiplayer
[firebase-auth]: {{site.firebase}}/codelabs/firebase-auth-in-flutter-apps#0
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
[sqflite]: {{site.pub-pkg}}/sqflite
[win32_gamepad]: {{site.pub-pkg}}/win32_gamepad
[read how the game was created in 6 weeks]: {{site.flutter-blog}}/how-we-built-the-new-super-dash-demo-in-flutter-and-flame-in-just-six-weeks-9c7aa2a5ad31
[view the open source code repo]: https://github.com/flutter/super_dash
[web]: https://superdash.flutter.dev/
[Tiled]: https://www.mapeditor.org/
[flutter_soloud]: {{site.pub-pkg}}/flutter_soloud
[Best practices for optimizing Flutter web loading speed]: {{site.flutter-blog}}/best-practices-for-optimizing-flutter-web-loading-speed-7cc0df14ce5c

## Outros recursos

Confira os seguintes vídeos:

* [Building multiplatform games with Flutter][gdc-talk], a talk
  given at the [Game Developer Conference (GDC)][] 2024.
* [How to build a physics-based game with Flutter and Flame's Forge2D][forge2d-video],
  from Google I/O 2024.

[Game Developer Conference (GDC)]: https://gdconf.com/
[forge2d-video]: {{site.yt.watch}}?v=nsnQJrYHHNQ
[gdc-talk]: {{site.yt.watch}}?v=7mG_sW40tsw
