---
ia-translate: true
title: Casual Games Toolkit
description: >-
  Aprenda sobre desenvolvimento gratuito e de código aberto de jogos 2D multiplataforma em Flutter.
---

O Flutter Casual Games Toolkit reúne recursos novos e existentes
para que você possa acelerar o desenvolvimento de jogos em plataformas móveis.

:::recommend
Confira as últimas [atualizações e recursos de jogos para Flutter 3.22](#updates)!
:::

Esta página descreve onde você pode encontrar esses recursos disponíveis.

## Por que Flutter para jogos?

O framework Flutter pode criar apps performáticos para seis plataformas de destino,
desde o desktop até dispositivos móveis e a web.

Com os benefícios do Flutter de desenvolvimento multiplataforma, performance e
licenciamento de código aberto, ele é uma ótima escolha para jogos.

Os jogos casuais se dividem em duas categorias: jogos baseados em turnos
e jogos em tempo real.
Você pode estar familiarizado com ambos os tipos de jogos,
embora talvez não tenha pensado neles exatamente dessa maneira.

_Jogos baseados em turnos_ cobrem jogos destinados ao mercado de massa com
regras e jogabilidade simples.
Isso inclui jogos de tabuleiro, jogos de cartas, quebra-cabeças e jogos de estratégia.
Esses jogos respondem a entradas simples do usuário,
como tocar em uma carta ou inserir um número ou letra.
Esses jogos são bem adequados para Flutter.

_Jogos em tempo real_ cobrem jogos onde uma série de ações requer respostas em tempo real.
Isso inclui jogos de corrida infinita, jogos de corrida e assim por diante.
Você pode querer criar um jogo com recursos avançados como detecção de colisão,
visualizações de câmera, loops de jogo e similares.
Esses tipos de jogos podem usar um engine de jogo de código aberto como o
[Flame game engine][] construído usando Flutter.

## O que está incluído no toolkit

O Casual Games Toolkit fornece os seguintes recursos gratuitos.

* Um repositório que inclui três novos templates de jogos que fornecem
  um ponto de partida para construir um jogo casual.

  1. Um [template de jogo base][basic-template]
     que inclui o básico para:

     * Menu principal
     * Navegação
     * Configurações
     * Seleção de nível
     * Progresso do jogador
     * Gerenciamento de sessão de jogo
     * Som
     * Temas

  1. Um [template de jogo de cartas][card-template]
     que inclui tudo no template base mais:

     * Arrastar e soltar
     * Gerenciamento de estado do jogo
     * Hooks de integração multiplayer

  1. Um [template de corrida infinita][runner-template] criado em parceria
     com o engine de jogo de código aberto, Flame. Ele implementa:

     * Um template base FlameGame
     * Direcionamento do jogador
     * Detecção de colisão
     * Efeitos de parallax
     * Spawning
     * Diferentes efeitos visuais

  1. Um jogo de exemplo construído em cima do template de corrida infinita,
     chamado SuperDash. Você pode jogar o jogo no iOS, Android
     ou [web][], [ver o repositório de código aberto][] ou
     [ler como o jogo foi criado em 6 semanas][].

* Guias de desenvolvedor para integrar serviços necessários.
* Um link para um [canal do Discord Flame][game-discord].
  Se você tem uma conta no Discord, use este [link direto][discord-direct].

Os templates de jogo incluídos e receitas do cookbook fazem certas escolhas
para acelerar o desenvolvimento.
Eles incluem packages específicos, como `provider`, `google_mobile_ads`,
`in_app_purchase`, `audioplayers`, `crashlytics` e `games_services`.
Se você preferir outros packages, pode alterar o código para usá-los.

A equipe Flutter entende que a monetização pode ser uma consideração futura.
Receitas de cookbook para publicidade e compras no app foram adicionadas.

Como explicado na página [Games][],
você pode aproveitar até $900 em ofertas ao integrar serviços do Google,
como [Cloud, Firebase][] e [Ads][], no seu jogo.

:::important
Você deve conectar suas contas Firebase e GCP para usar créditos para
serviços Firebase e verificar seu e-mail comercial durante o cadastro para ganhar
$100 adicionais além dos $300 normais de crédito.
Para a oferta de Ads, [verifique a elegibilidade da sua região][].
:::

## Começar

Está pronto? Para começar:

1. Se ainda não o fez, [instale o Flutter][install Flutter].
1. [Clone o repositório de jogos][game-repo].
1. Revise o arquivo `README` para o primeiro tipo de jogo que você deseja criar.

   * [jogo básico][basic-template-readme]
   * [jogo de cartas][card-template-readme]
   * [jogo de corrida][runner-template-readme]

1. [Junte-se à comunidade Flame no Discord][game-discord]
   (use o [link direto][discord-direct] se você já
   tem uma conta no Discord).
1. Revise os codelabs e receitas do cookbook.

   * {{recipe-icon}} Construa um [jogo multiplayer][multiplayer-recipe] com Cloud Firestore.
   * {{codelab}} Construa um [quebra-cabeça de palavras][word puzzle] com Flutter.—**NOVO**
   * {{codelab}} Construa um [jogo de física 2D][2D physics game] com Flutter e Flame.—**NOVO**
   * {{codelab}} [Adicione som e música][Add sound and music] ao seu jogo Flutter com SoLoud.—**NOVO**
   * {{recipe-icon}}Torne seus jogos mais envolventes
     com [placares de líderes e conquistas][leaderboard-recipe].
   * Monetize seus jogos com {{recipe-icon}}[anúncios no jogo][ads-recipe]
     e {{codelab}} [compras no app][iap-recipe].
   * Adicione fluxo de autenticação de usuário ao seu jogo com
     {{recipe-icon}} [Firebase Authentication][firebase-auth].
   * Colete análises sobre crashes e erros dentro do seu jogo
     com {{recipe-icon}} [Firebase Crashlytics][firebase-crashlytics].

1. Configure contas no AdMob, Firebase e Cloud, conforme necessário.
1. Escreva seu jogo!
1. Implante nas lojas Google Play e Apple.

[Add sound and music]: {{site.codelabs}}/codelabs/flutter-codelab-soloud
[2D physics game]: {{site.codelabs}}/codelabs/flutter-flame-forge2d
[word puzzle]: {{site.codelabs}}/codelabs/flutter-word-puzzle

## Exemplos de jogos

Para o Google I/O 2022, tanto a equipe Flutter
quanto a Very Good Ventures criaram novos jogos.

* A VGV criou o [jogo I/O Pinball][pinball-game] usando o engine Flame.
  Para aprender sobre este jogo,
  confira [I/O Pinball Powered by Flutter and Firebase][] no Medium
  e [jogue o jogo][pinball-game] no seu navegador.

* A equipe Flutter criou o [I/O Flip][flip-game], um [CCG] virtual.
  Para saber mais sobre o I/O Flip,
  confira [How It's Made: I/O FLIP adds a twist to a classic card game with generative AI][flip-blog]
  no blog do Google Developers e [jogue o jogo][flip-game] no seu navegador.

## Outros recursos

Uma vez que você se sinta pronto para ir além desses templates de jogos,
investigue outros recursos que nossa comunidade recomendou.

{% assign pkg-icon = '<span class="material-symbols">package_2</span>' %}
{% assign doc-icon = '<span class="material-symbols">quick_reference_all</span>' %}
{% assign codelab = '<span class="material-symbols">science</span>' %}
{% assign engine = '<span class="material-symbols">manufacturing</span>' %}
{% assign tool-icon = '<span class="material-symbols">handyman</span>' %}
{% assign recipe-icon = '<span class="material-symbols">book_5</span>' %}
{% assign assets-icon = '<span class="material-symbols">photo_album</span>' %}
{% assign api-icon = '<span class="material-symbols">api</span>' %}

:::secondary
{{pkg-icon}} Package Flutter<br>
{{api-icon}} Documentação da API<br>
{{codelab}} Codelab <br>
{{recipe-icon}} Receita do Cookbook<br>
{{tool-icon}} Aplicativo desktop<br>
{{assets-icon}} Assets de jogo<br>
{{doc-icon}} Guia<br>
:::

<table class="table table-striped">
<tr>
<th>Recurso</th>
<th>Recursos</th>
</tr>

<tr>
<td>Animação e sprites</td>
<td>

{{recipe-icon}} [Efeitos especiais][Special effects]<br>
{{tool-icon}} [Spriter Pro][]<br>
{{pkg-icon}} [rive][]<br>
{{pkg-icon}} [spriteWidget][]

</td>
</tr>

<tr>
<td>Avaliação de app</td>
<td>

{{pkg-icon}} [app_review][]

</td>
</tr>

<tr>
<td>Áudio</td>
<td>

{{pkg-icon}} [audioplayers][]<br>
{{pkg-icon}} [flutter_soloud][]—**NOVO**<br>
{{codelab}}  [Adicione som e música ao seu jogo Flutter com SoLoud][Add sound and music to your Flutter game with SoLoud]—**NOVO**

</td>
</tr>

<tr>
<td>Autenticação</td>
<td>

{{codelab}} [Autenticação de usuário usando Firebase][firebase-auth]

</td>
</tr>

<tr>
<td>Serviços de nuvem</td>
<td>

{{codelab}} [Adicione Firebase ao seu jogo Flutter][Add Firebase to your Flutter game]

</td>
</tr>

<tr>
<td>Depuração</td>
<td>

{{doc-icon}} [Visão geral do Firebase Crashlytics][firebase-crashlytics]<br>
{{pkg-icon}} [firebase_crashlytics][]

</td>
</tr>

<tr>
<td>Drivers</td>
<td>

{{pkg-icon}} [win32_gamepad][]

</td>
</tr>

<tr>
<td>Assets de jogo<br>e ferramentas de assets</td>
<td>

{{assets-icon}} [CraftPix][]<br>
{{assets-icon}} [Game Developer Studio][]<br>
{{tool-icon}} [GIMP][]

</td>
</tr>

<tr>
<td>Engines de jogo</td>
<td>

{{pkg-icon}} [Flame][flame-pkg]<br>
{{pkg-icon}} [Bonfire][bonfire-pkg]<br>
{{pkg-icon}} [forge2d][]

</td>
</tr>

<tr>
<td>Recursos de jogo</td>
<td>

{{recipe-icon}} [Adicione conquistas e placares de líderes ao seu jogo][leaderboard-recipe]<br>
{{recipe-icon}} [Adicione suporte multiplayer ao seu jogo][multiplayer-recipe]

</td>
</tr>

<tr>
<td>Integração de serviços de jogos</td>
<td>

{{pkg-icon}} [games_services][game-svc-pkg]

</td>
</tr>

<tr>
<td>Código legado</td>
<td>

{{codelab}} [Use a Foreign Function Interface em um plugin Flutter][Use the Foreign Function Interface in a Flutter plugin]

</td>
</tr>

<tr>
<td>Editor de níveis</td>
<td>

{{tool-icon}} [Tiled][]

</td>
</tr>

<tr>
<td>Monetização</td>
<td>

{{recipe-icon}} [Adicione publicidade ao seu jogo Flutter][ads-recipe]<br>
{{codelab}}  [Adicione anúncios AdMob a um app Flutter][Add AdMob ads to a Flutter app]<br>
{{codelab}}  [Adicione compras no app ao seu app Flutter][iap-recipe]<br>
{{doc-icon}} [Otimizações de UX e Receita para Apps de Jogos][Gaming UX and Revenue Optimizations for Apps] (PDF)

</td>
</tr>

<tr>
<td>Persistência</td>
<td>

{{pkg-icon}} [shared_preferences][]<br>
{{pkg-icon}} [sqflite][]<br>
{{pkg-icon}} [cbl_flutter][] (Couchbase Lite)<br>

</td>
</tr>

<tr>
<td>Efeitos especiais</td>
<td>

{{api-icon}} [API Paint][Paint API]<br>
{{recipe-icon}} [Efeitos especiais][Special effects]

</td>
</tr>

<tr>
<td>Experiência do usuário</td>
<td>

{{codelab}} [Construa UIs de próxima geração em Flutter][Build next generation UIs in Flutter]<br>
{{doc-icon}} [Melhores práticas para otimizar a velocidade de carregamento do Flutter web][Best practices for optimizing Flutter web loading speed]—**NOVO**

</td>
</tr>
</table>

{% assign games-gh = site.github | append: '/flutter/games' -%}

[Ads]: https://ads.google.com/intl/en_us/home/flutter/#!/
[Air Hockey]: https://play.google.com/store/apps/details?id=com.ignacemaes.airhockey
[CCG]: https://en.wikipedia.org/wiki/Collectible_card_game
[Cloud, Firebase]: https://cloud.google.com/free
[Flame game engine]: https://flame-engine.org/
[Games]: {{site.main-url}}/games
[I/O Pinball Powered by Flutter and Firebase]: {{site.medium}}/flutter/di-o-pinball-powered-by-flutter-and-firebase-d22423f3f5d
[install Flutter]: /get-started/install
[Tomb Toad]: https://play.google.com/store/apps/details?id=com.crescentmoongames.tombtoad
[basic-template-readme]: {{games-gh}}/blob/main/templates/basic/README.md
[basic-template]: {{games-gh}}/tree/main/templates/basic
[card-template-readme]: {{games-gh}}/blob/main/templates/card/README.md
[card-template]: {{games-gh}}/tree/main/templates/card
[check your region's eligibility]: https://www.google.com/intl/en/ads/coupons/terms/flutter/
[verifique a elegibilidade da sua região]: https://www.google.com/intl/en/ads/coupons/terms/flutter/
[discord-direct]: https://discord.com/login?redirect_to=%2Fchannels%2F509714518008528896%2F788415774938103829
[firebase_crashlytics]: {{site.pub}}/packages/firebase_crashlytics
[flame-pkg]: {{site.pub}}/packages/flame
[flip-blog]: {{site.google-blog}}/2023/05/how-its-made-io-flip-adds-twist-to.html
[flip-game]: https://flip.withgoogle.com/#/
[game-discord]: https://discord.gg/qUyQFVbV45
[game-repo]: {{games-gh}}
[pinball-game]: https://pinball.flutterbrasil.dev/#/
[runner-template-readme]: {{games-gh}}/blob/main/templates/endless_runner/README.md
[runner-template]: {{games-gh}}/tree/main/templates/endless_runner

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
[read how the game was created in 6 weeks]: {{site.flutter-medium}}/how-we-built-the-new-super-dash-demo-in-flutter-and-flame-in-just-six-weeks-9c7aa2a5ad31
[ler como o jogo foi criado em 6 semanas]: {{site.flutter-medium}}/how-we-built-the-new-super-dash-demo-in-flutter-and-flame-in-just-six-weeks-9c7aa2a5ad31
[view the open source code repo]: {{site.github}}/flutter/super_dash
[ver o repositório de código aberto]: {{site.github}}/flutter/super_dash
[web]: https://superdash.flutterbrasil.dev/
[Tiled]: https://www.mapeditor.org/
[flutter_soloud]: {{site.pub-pkg}}/flutter_soloud
[SoLoud codelab]: {{site.codelabs}}/codelabs/flutter-codelab-soloud

## Atualizações do Games Toolkit para Flutter 3.22 {#updates}

Os seguintes codelabs e guias foram adicionados para
o lançamento do Flutter 3.22:

**Som de baixa latência e alto desempenho**
: Em colaboração com a comunidade Flutter ([@Marco Bavagnoli][]),
  habilitamos o engine de áudio SoLoud.
  Este engine gratuito e portável oferece som de baixa latência e
  alto desempenho que é essencial para muitos jogos.
  Para ajudá-lo a começar, confira o novo codelab,
  [Adicione som e música ao seu jogo Flutter com SoLoud][Add sound and music to your Flutter game with SoLoud],
  dedicado a adicionar som e música ao seu jogo.

**Jogos de quebra-cabeça de palavras**
: Confira o novo codelab,
  [Construa um quebra-cabeça de palavras com Flutter][Build a word puzzle with Flutter],
  focado na construção de jogos de quebra-cabeça de palavras.
  Este gênero é perfeito para explorar as capacidades de UI do Flutter,
  e este codelab mergulha no uso do processamento em segundo plano do Flutter
  para gerar sem esforço grades expansivas de palavras entrelaçadas no estilo de palavras cruzadas
  sem comprometer a experiência do usuário.

**Engine de física Forge 2D**
: O novo codelab Forge2D,
  [Construa um jogo de física 2D com Flutter e Flame][Build a 2D physics game with Flutter and Flame],
  guia você através da criação de mecânicas de jogo em um
  jogo Flutter e Flame usando uma simulação de física 2D
  ao longo das linhas do Box2D, chamada [Forge2D][].

**Otimize a velocidade de carregamento para jogos baseados em Flutter web**
: No mundo acelerado dos jogos baseados na web,
  um jogo de carregamento lento é um grande impedimento.
  Os jogadores esperam gratificação instantânea e
  abandonarão rapidamente um jogo que não carrega prontamente.
  Portanto, publicamos um guia,
  [Melhores práticas para otimizar a velocidade de carregamento do Flutter web][Best practices for optimizing Flutter web loading speed],
  de autoria de [Cheng Lin][],
  para ajudá-lo a otimizar seus jogos e apps baseados em Flutter web
  para velocidades de carregamento ultrarrápidas.

[@Marco Bavagnoli]: {{site.github}}/alnitak
[Add sound and music to your Flutter game with SoLoud]: {{site.codelabs}}/codelabs/flutter-codelab-soloud
[Best practices for optimizing Flutter web loading speed]: {{site.flutter-medium}}/best-practices-for-optimizing-flutter-web-loading-speed-7cc0df14ce5c
[Build a word puzzle with Flutter]: {{site.codelabs}}/codelabs/flutter-word-puzzle
[Build a 2D physics game with Flutter and Flame]: {{site.codelabs}}/codelabs/flutter-flame-forge2d
[Cheng Lin]: {{site.medium}}/@mhclin113_26002
[Forge2D]: {{site.pub-pkgs}}/forge2d

## Outros novos recursos

Confira os seguintes vídeos:

* [Construindo jogos multiplataforma com Flutter][gdc-talk], uma palestra
  apresentada na [Game Developer Conference (GDC)][] 2024.
* [Como construir um jogo baseado em física com Flutter e Forge2D do Flame][forge2d-video],
  do Google I/O 2024.

[Game Developer Conference (GDC)]: https://gdconf.com/
[forge2d-video]: {{site.youtube-site}}/watch?v=nsnQJrYHHNQ
[gdc-talk]: {{site.youtube-site}}/watch?v=7mG_sW40tsw
