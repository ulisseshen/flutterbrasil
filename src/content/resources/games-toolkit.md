---
ia-translate: true
title: Kit de Ferramentas para Jogos Casuais
description: >-
  Aprenda sobre o desenvolvimento de jogos 2D multiplataforma gratuitos e de código aberto em Flutter.
---

O Kit de Ferramentas para Jogos Casuais do Flutter reúne recursos novos e existentes
para que você possa acelerar o desenvolvimento de jogos em plataformas móveis.

:::recommend
Confira as últimas [atualizações de jogos e recursos para Flutter 3.22](#updates)!
:::

Esta página descreve onde você pode encontrar esses recursos disponíveis.

## Por que Flutter para jogos?

O framework Flutter pode criar aplicativos de alto desempenho para seis plataformas
de destino, desde desktops até dispositivos móveis e a web.

Com os benefícios do Flutter de desenvolvimento multiplataforma, desempenho e
licenciamento de código aberto, ele é uma ótima opção para jogos.

Jogos casuais se dividem em duas categorias: jogos baseados em turnos e jogos em tempo real.
Você pode estar familiarizado com os dois tipos de jogos,
embora talvez não tenha pensado neles dessa forma.

_Jogos baseados em turnos_ abrangem jogos destinados a um mercado de massa com
regras e jogabilidade simples.
Isso inclui jogos de tabuleiro, jogos de cartas, quebra-cabeças e jogos de estratégia.
Esses jogos respondem a entradas simples do usuário,
como tocar em uma carta ou inserir um número ou letra.
Esses jogos são adequados para Flutter.

_Jogos em tempo real_ abrangem jogos em que uma série de ações exigem respostas em tempo real.
Isso inclui jogos de corrida sem fim, jogos de corrida e assim por diante.
Você pode querer criar um jogo com recursos avançados como detecção de colisão,
visualizações de câmera, game loops e similares.
Esses tipos de jogos podem usar um game engine de código aberto como o
[Flame game engine][] construído usando Flutter.

## O que está incluído no kit de ferramentas

O Kit de Ferramentas para Jogos Casuais fornece os seguintes recursos gratuitos.

* Um repositório que inclui três novos modelos de jogos que fornecem
  um ponto de partida para construir um jogo casual.

  1. Um [modelo de jogo básico][basic-template]
     que inclui o básico para:

     * Menu principal
     * Navegação
     * Configurações
     * Seleção de nível
     * Progresso do jogador
     * Gerenciamento de sessão de jogo
     * Som
     * Temas

  1. Um [modelo de jogo de cartas][card-template]
     que inclui tudo no modelo base mais:

     * Arrastar e soltar
     * Gerenciamento de estado do jogo
     * Hooks de integração multijogador

  1. Um [modelo de endless runner][runner-template] criado em parceria
     com o game engine de código aberto, Flame. Ele implementa:

     * Um modelo base FlameGame
     * Direção do jogador
     * Detecção de colisão
     * Efeitos de paralaxe
     * Geração de objetos
     * Diferentes efeitos visuais

  1. Um jogo de amostra construído sobre o modelo de endless runner,
     chamado SuperDash. Você pode jogar o jogo no iOS, Android ou
     [web][], [visualizar o repositório de código aberto][], ou
     [ler como o jogo foi criado em 6 semanas][].

* Guias para desenvolvedores para integrar os serviços necessários.
* Um link para um canal [Flame Discord][game-discord].
  Se você tiver uma conta no Discord, use este [link direto][discord-direct].

Os modelos de jogos incluídos e as receitas do cookbook fazem certas escolhas
para acelerar o desenvolvimento.
Eles incluem packages específicos, como `provider`, `google_mobile_ads`,
`in_app_purchase`, `audioplayers`, `crashlytics` e `games_services`.
Se você preferir outros packages, pode alterar o código para usá-los.

A equipe do Flutter entende que a monetização pode ser uma consideração futura.
Receitas de cookbook para publicidade e compras no aplicativo foram adicionadas.

Conforme explicado na página [Games][],
você pode aproveitar até US$ 900 em ofertas ao integrar os serviços do Google,
como [Cloud, Firebase][] e [Ads][], em seu jogo.

:::important
Você deve conectar suas contas do Firebase e do GCP para usar créditos para
serviços do Firebase e verificar seu e-mail comercial durante a inscrição para ganhar
US$ 100 adicionais em cima do crédito normal de US$ 300.
Para a oferta de anúncios, [verifique a elegibilidade da sua região][].
:::

## Comece

Você está pronto? Para começar:

1. Se você ainda não o fez, [instale o Flutter][].
1. [Clone o repositório de jogos][game-repo].
1. Revise o arquivo `README` para o primeiro tipo de jogo que você deseja criar.

   * [Jogo básico][basic-template-readme]
   * [Jogo de cartas][card-template-readme]
   * [Jogo de corrida][runner-template-readme]

1. [Junte-se à comunidade Flame no Discord][game-discord]
   (use o [link direto][discord-direct] se você já
   tiver uma conta no Discord).
1. Revise os codelabs e as receitas do cookbook.

   * {{recipe-icon}} Construa um [jogo multijogador][multiplayer-recipe] com o Cloud Firestore.
   * {{codelab}} Construa um [quebra-cabeça de palavras][] com Flutter. — **NOVO**
   * {{codelab}} Construa um [jogo de física 2D][] com Flutter e Flame. — **NOVO**
   * {{codelab}} [Adicione som e música][] ao seu jogo Flutter com SoLoud. — **NOVO**
   * {{recipe-icon}} Torne seus jogos mais envolventes
     com [placar de líderes e conquistas][leaderboard-recipe].
   * Monetize seus jogos com {{recipe-icon}}[anúncios no jogo][ads-recipe]
     e {{codelab}} [compras no aplicativo][iap-recipe].
   * Adicione um fluxo de autenticação de usuário ao seu jogo com
     {{recipe-icon}} [Firebase Authentication][firebase-auth].
   * Colete análises sobre falhas e erros dentro do seu jogo
     com {{recipe-icon}} [Firebase Crashlytics][firebase-crashlytics].

1. Configure as contas no AdMob, Firebase e Cloud, conforme necessário.
1. Escreva seu jogo!
1. Implante nas lojas Google Play e Apple.

[Adicione som e música]: {{site.codelabs}}/codelabs/flutter-codelab-soloud
[jogo de física 2D]: {{site.codelabs}}/codelabs/flutter-flame-forge2d
[quebra-cabeça de palavras]: {{site.codelabs}}/codelabs/flutter-word-puzzle

## Jogos de exemplo

Para o Google I/O 2022, tanto a equipe do Flutter
quanto a Very Good Ventures criaram novos jogos.

* A VGV criou o [jogo I/O Pinball][pinball-game] usando o engine Flame.
  Para saber mais sobre este jogo,
  confira [I/O Pinball Powered by Flutter and Firebase][] no Medium
  e [jogue o jogo][pinball-game] no seu navegador.

* A equipe do Flutter criou o [I/O Flip][flip-game], um [CCG] virtual.
  Para saber mais sobre o I/O Flip,
  confira [Como foi feito: I/O FLIP adiciona um toque especial a um jogo de cartas clássico com IA generativa][flip-blog]
  no blog Google Developers e [jogue o jogo][flip-game] no seu navegador.

## Outros recursos

Depois de se sentir pronto para ir além desses modelos de jogos,
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
{{tool-icon}} Aplicativo de desktop<br>
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

{{recipe-icon}} [Efeitos especiais][]<br>
{{tool-icon}} [Spriter Pro][]<br>
{{pkg-icon}} [rive][]<br>
{{pkg-icon}} [spriteWidget][]

</td>
</tr>

<tr>
<td>Avaliação do aplicativo</td>
<td>

{{pkg-icon}} [app_review][]

</td>
</tr>

<tr>
<td>Áudio</td>
<td>

{{pkg-icon}} [audioplayers][]<br>
{{pkg-icon}} [flutter_soloud][]—**NOVO**<br>
{{codelab}}  [Adicione som e música ao seu jogo Flutter com SoLoud][]—**NOVO**

</td>
</tr>

<tr>
<td>Autenticação</td>
<td>

{{codelab}} [Autenticação de Usuário usando Firebase][firebase-auth]

</td>
</tr>

<tr>
<td>Serviços de nuvem</td>
<td>

{{codelab}} [Adicione o Firebase ao seu jogo Flutter][]

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
<td>Game engines</td>
<td>

{{pkg-icon}} [Flame][flame-pkg]<br>
{{pkg-icon}} [Bonfire][bonfire-pkg]<br>
{{pkg-icon}} [forge2d][]

</td>
</tr>

<tr>
<td>Recursos do jogo</td>
<td>

{{recipe-icon}} [Adicione conquistas e placares de líderes ao seu jogo][leaderboard-recipe]<br>
{{recipe-icon}} [Adicione suporte multijogador ao seu jogo][multiplayer-recipe]

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

{{codelab}} [Use a Interface de Função Estrangeira em um plugin Flutter][]

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
{{codelab}}  [Adicione anúncios AdMob a um aplicativo Flutter][]<br>
{{codelab}}  [Adicione compras no aplicativo ao seu aplicativo Flutter][iap-recipe]<br>
{{doc-icon}} [Otimizações de UX de jogos e receita para aplicativos][] (PDF)

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

{{api-icon}} [Paint API][]<br>
{{recipe-icon}} [Efeitos especiais][]

</td>
</tr>

<tr>
<td>Experiência do Usuário</td>
<td>

{{codelab}} [Crie UIs de última geração em Flutter][]<br>
{{doc-icon}} [Melhores práticas para otimizar a velocidade de carregamento da web do Flutter][]—**NOVO**

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
[discord-direct]: https://discord.com/login?redirect_to=%2Fchannels%2F509714518008528896%2F788415774938103829
[firebase_crashlytics]: {{site.pub}}/packages/firebase_crashlytics
[flame-pkg]: {{site.pub}}/packages/flame
[flip-blog]: {{site.google-blog}}/2023/05/how-its-made-io-flip-adds-twist-to.html
[flip-game]: https://flip.withgoogle.com/#/
[game-discord]: https://discord.gg/qUyQFVbV45
[game-repo]: {{games-gh}}
[pinball-game]: https://pinball.flutter.dev/#/
[runner-template-readme]: {{games-gh}}/blob/main/templates/endless_runner/README.md
[runner-template]: {{games-gh}}/tree/main/templates/endless_runner

[Adicione anúncios AdMob a um aplicativo Flutter]: {{site.codelabs}}/codelabs/admob-ads-in-flutter
[Crie UIs de última geração em Flutter]: {{site.codelabs}}/codelabs/flutter-next-gen-uis
[firebase-crashlytics]: {{site.firebase}}/docs/crashlytics/get-started?platform=flutter
[ads-recipe]: /cookbook/plugins/google-mobile-ads
[iap-recipe]: {{site.codelabs}}/codelabs/flutter-in-app-purchases#0
[leaderboard-recipe]: /cookbook/games/achievements-leaderboard
[multiplayer-recipe]: /cookbook/games/firestore-multiplayer
[firebase-auth]: {{site.firebase}}/codelabs/firebase-auth-in-flutter-apps#0
[Use a Interface de Função Estrangeira em um plugin Flutter]: {{site.codelabs}}/codelabs/flutter-ffigen
[bonfire-pkg]: {{site.pub}}/packages/bonfire
[CraftPix]: https://craftpix.net
[Adicione o Firebase ao seu jogo Flutter]: {{site.firebase}}/docs/flutter/setup
[GIMP]: https://www.gimp.org
[Game Developer Studio]: https://www.gamedeveloperstudio.com
[Otimizações de UX de jogos e receita para aplicativos]: {{site.main-url}}/go/games-revenue
[Paint API]: {{site.api}}/flutter/dart-ui/Paint-class.html
[Efeitos especiais]: /cookbook/effects
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
[ler como o jogo foi criado em 6 semanas]: {{site.flutter-medium}}/how-we-built-the-new-super-dash-demo-in-flutter-and-flame-in-just-six-weeks-9c7aa2a5ad31
[visualizar o repositório de código aberto]: {{site.github}}/flutter/super_dash
[web]: https://superdash.flutter.dev/
[Tiled]: https://www.mapeditor.org/
[flutter_soloud]: {{site.pub-pkg}}/flutter_soloud
[SoLoud codelab]: {{site.codelabs}}/codelabs/flutter-codelab-soloud

## Atualizações do Kit de Ferramentas para Jogos para Flutter 3.22 {:#updates}

Os seguintes codelabs e guias foram adicionados para
a versão do Flutter 3.22:

**Som de baixa latência e alto desempenho**
: Em colaboração com a comunidade Flutter ([@Marco Bavagnoli][]),
  habilitamos o engine de áudio SoLoud.
  Este engine gratuito e portátil oferece a baixa latência e
  som de alto desempenho que é essencial para muitos jogos.
  Para ajudá-lo a começar, confira o novo codelab,
  [Adicione som e música ao seu jogo Flutter com SoLoud][],
  dedicado a adicionar som e música ao seu jogo.

**Jogos de quebra-cabeça de palavras**
: Confira o novo codelab,
  [Construa um quebra-cabeça de palavras com Flutter][],
  focado na construção de jogos de quebra-cabeça de palavras.
  Este gênero é perfeito para explorar os recursos de UI do Flutter,
  e este codelab mergulha no uso do processamento em segundo plano do Flutter
  para gerar sem esforço grades expansivas no estilo de palavras cruzadas de
  palavras interligadas sem comprometer a experiência do usuário.

**Engine de física Forge 2D**
: O novo codelab Forge2D,
  [Construa um jogo de física 2D com Flutter e Flame][],
  orienta você na criação de mecânicas de jogo em um
  jogo Flutter e Flame usando uma simulação de física 2D
  semelhante ao Box2D, chamado [Forge2D][].

**Otimize a velocidade de carregamento para jogos baseados na web do Flutter**
: No mundo acelerado dos jogos baseados na web,
  um jogo com carregamento lento é um grande impedimento.
  Os jogadores esperam gratificação instantânea e irão
  abandonar rapidamente um jogo que não carrega prontamente.
  Portanto, publicamos um guia,
  [Melhores práticas para otimizar a velocidade de carregamento da web do Flutter][],
  escrito por [Cheng Lin][],
  para ajudá-lo a otimizar seus jogos e
  aplicativos baseados na web do Flutter para velocidades de carregamento extremamente rápidas.

[@Marco Bavagnoli]: {{site.github}}/alnitak
[Adicione som e música ao seu jogo Flutter com SoLoud]: {{site.codelabs}}/codelabs/flutter-codelab-soloud
[Melhores práticas para otimizar a velocidade de carregamento da web do Flutter]: {{site.flutter-medium}}/best-practices-for-optimizing-flutter-web-loading-speed-7cc0df14ce5c
[Construa um quebra-cabeça de palavras com Flutter]: {{site.codelabs}}/codelabs/flutter-word-puzzle
[Construa um jogo de física 2D com Flutter e Flame]: {{site.codelabs}}/codelabs/flutter-flame-forge2d
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
