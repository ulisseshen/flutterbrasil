---
ia-translate: true
title: Suporte web para Flutter
shortTitle: Web
description: >-
  Detalhes de como o Flutter oferece suporte à criação de experiências web.
---

O Flutter entrega as mesmas experiências na web que em dispositivos móveis.

Com base na portabilidade do Dart, no poder da plataforma web,
na flexibilidade do framework Flutter e no desempenho do WebAssembly,
você pode criar apps para iOS, Android e navegadores a partir da mesma base de código.
A web é apenas mais um alvo de dispositivo para o seu app.

Para começar, visite [Criando uma aplicação web com Flutter][Building a web application with Flutter].

## Alimentado por WebAssembly {:#powered-by-webassembly}

Dart e Flutter podem compilar para WebAssembly,
um formato de instruções binárias que possibilita apps rápidos em todos os principais navegadores.

Para ter uma ideia dos benefícios do WebAssembly,
confira o vídeo a seguir.

<YouTubeEmbed id="lpnKWK-KEYs?start=1712"
  title="What's new in Flutter - WebAssembly"></YouTubeEmbed>

## Como funciona {:#how-it-works}

O Flutter na web compila sua aplicação Dart e o framework Flutter para
JavaScript (usando `dartdevc` durante o desenvolvimento e `dart2js` para
produção) ou para [WebAssembly][WebAssembly] (`dart2wasm` ao compilar com `--wasm`),
em vez do código de máquina ARM ou x64 usado em plataformas móveis e desktop.
O Flutter renderiza sua UI usando APIs gráficas do navegador com aceleração por hardware
(WebGL e WebGPU) por meio dos renderizadores CanvasKit e Skwasm, entregando uma
experiência portável, consistente e de alto desempenho em navegadores modernos.

<img src="/assets/images/docs/arch-overview/web-framework-diagram.png"
  alt="Arquitetura do Flutter para web" >

## Que tipos de apps posso criar? {:#what-types-of-apps-can-i-build}

Embora você possa fazer muita coisa na web,
o suporte web do Flutter é mais valioso nos seguintes cenários:

**Single Page Application**
: O suporte web do Flutter possibilita aplicações web independentes e complexas, ricas em
  gráficos e conteúdo interativo, para alcançar usuários em uma grande variedade de
  dispositivos.

**Aplicativos móveis existentes**
: O suporte web do Flutter oferece um modelo de entrega baseado em navegador para
  apps Flutter móveis já existentes.

Nem todo cenário HTML é ideal para o Flutter neste momento.
Por exemplo, conteúdo estático, baseado em fluxo e rico em texto, como artigos de blog,
se beneficia do modelo centrado em documentos em que a web foi construída,
em vez dos serviços centrados em apps que um framework de UI como o Flutter
oferece. No entanto, você _pode_ usar o Flutter para incorporar
experiências interativas nesses sites.

Porém, se você quiser usar Dart e implementar um site tradicional baseado em DOM,
um pacote Dart lançado pela comunidade,
o [Jaspr][Jaspr], oferece suporte a sites estáticos; na verdade,
a [documentação do Dart][Dart documentation], a [documentação do Flutter][Flutter documentation]
e os sites de [marketing][marketing] foram migrados para usar o pacote Jaspr.
Observe que o Jaspr usa Dart (mas não Flutter) e faz o SEO funcionar
da mesma forma que um site tradicional.

[Dart documentation]: {{site.dart-site}}
[Flutter documentation]: {{site.main-url}}
[Jaspr]: https://jaspr.site/
[marketing]: {{site.main-url}}

## Começando {:#get-started}

Os seguintes recursos podem ajudar você a começar:

* Para adicionar suporte web a um app existente, ou para criar um
  novo app que inclua suporte web,
  visite [Criando uma aplicação web com Flutter][Building a web application with Flutter].
* Para configurar as definições do servidor de desenvolvimento web em um arquivo centralizado,
  confira [Configure um arquivo de configuração de desenvolvimento web][Set up a web development configuration file].
* Para aprender a criar um app Flutter responsivo,
  confira [Criando apps responsivos][Creating responsive apps].
* Para ver perguntas e respostas frequentes,
  visite o [FAQ de web][web FAQ].
* Para exemplos de código,
  confira os [exemplos web para Flutter][web samples for Flutter].
* Para uma demonstração de app web Flutter, confira o [aplicativo Wonderous][Wonderous app].
* Para aprender sobre a publicação de um app web,
  visite [Preparando um app para lançamento na web][Preparing an app for web release].
* [Abra uma issue][file an issue] no repositório principal do Flutter.
* Você pode conversar e fazer perguntas relacionadas à web no canal
  **#help** do [Discord][Discord].

[Building a web application with Flutter]: /platform-integration/web/building
[Set up a web development configuration file]: /platform-integration/web/web-dev-config-file
[Creating responsive apps]: /ui/adaptive-responsive
[Discord]: https://discordapp.com/invite/yeZ6s7k
[file an issue]: https://goo.gle/flutter_web_issue
[Wonderous app]: {{site.wonderous}}/web
[Preparing an app for web release]: /deployment/web
[Progressive Web Application]: https://web.dev/progressive-web-apps/
[web FAQ]: /platform-integration/web/faq
[web samples for Flutter]: https://github.com/flutter/samples/#?platform=web
[WebAssembly]: /platform-integration/web/wasm
