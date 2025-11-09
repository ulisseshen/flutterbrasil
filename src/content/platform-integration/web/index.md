---
ia-translate: true
title: Suporte web para Flutter
shortTitle: Web
description: Detalhes de como o Flutter suporta a criação de experiências web.
---

Flutter entrega as mesmas experiências na web que em mobile.

Construindo sobre a portabilidade do Dart, o poder da plataforma web, a
flexibilidade do framework Flutter e a performance do WebAssembly,
você pode construir apps para iOS, Android e navegador a partir da mesma base de código.
A web é apenas mais um dispositivo alvo para seu app.

Para começar, visite [Construindo uma aplicação web com Flutter][Building a web application with Flutter].

## Desenvolvido com WebAssembly

Dart e Flutter podem compilar para WebAssembly,
um formato de instrução binária que permite apps rápidos em todos os principais navegadores.

Para uma visão geral dos benefícios de usar WebAssembly,
confira o vídeo a seguir.

<YouTubeEmbed id="lpnKWK-KEYs?start=1712" title="What's new in Flutter - WebAssembly"></YouTubeEmbed>

## Como funciona

Adicionar suporte web ao Flutter envolveu implementar a camada de
desenho principal do Flutter sobre APIs de navegador padrão, além de
compilar Dart para JavaScript, em vez do código de máquina ARM que
é usado para aplicações mobile. Usando uma combinação de DOM, Canvas
e WebAssembly, o Flutter pode fornecer uma experiência de usuário portável,
de alta qualidade e performática em navegadores modernos.
Implementamos a camada de desenho principal completamente em Dart
e usamos o compilador JavaScript otimizado do Dart para compilar o
núcleo e framework Flutter junto com sua aplicação
em um único arquivo fonte minificado que pode ser implantado em
qualquer servidor web.

<img src="/assets/images/docs/arch-overview/web-framework-diagram.png" alt="Flutter architecture for web" >

## Que tipos de apps posso construir?

Embora você possa fazer muito na web,
o suporte web do Flutter é mais valioso nos
seguintes cenários:

**Single Page Application**
: O suporte web do Flutter permite apps web complexos e autônomos que são ricos em
  gráficos e conteúdo interativo para alcançar usuários finais em uma ampla variedade de
  dispositivos.

**Aplicações mobile existentes**
: O suporte web para Flutter fornece um modelo de entrega baseado em navegador para apps
  Flutter mobile existentes.

Nem todo cenário HTML é idealmente adequado para Flutter neste momento.
Por exemplo, conteúdo estático rico em texto e baseado em fluxo, como artigos de blog,
se beneficia do modelo centrado em documentos no qual a web é construída,
em vez dos serviços centrados em aplicativos que um framework de UI como o Flutter
pode oferecer. No entanto, você _pode_ usar Flutter para incorporar experiências
interativas nesses sites.

## Começando

Os seguintes recursos podem ajudá-lo a começar:

* Para adicionar suporte web a um app existente, ou para criar um
  novo app que inclua suporte web, consulte
  [Construindo uma aplicação web com Flutter][Building a web application with Flutter].
* Para configurar definições do servidor de desenvolvimento web em um arquivo centralizado, consulte [Configure um arquivo de configuração de desenvolvimento web][Set up a web development configuration file].
* Para aprender sobre os diferentes renderizadores web do Flutter (CanvasKit e Skwasm), consulte
  [Renderizadores web][Web renderers].
* Para aprender como criar um app Flutter responsivo,
  consulte [Criando apps responsivos][Creating responsive apps].
* Para ver perguntas e respostas comuns, consulte o
  [FAQ web][web FAQ].
* Para ver exemplos de código,
  confira os [exemplos web para Flutter][web samples for Flutter].
* Para ver uma demo de app web Flutter, confira o [app Wonderous][Wonderous app].
* Para aprender sobre fazer deploy de um app web, consulte
  [Preparando um app para lançamento web][Preparing an app for web release].
* [Registre uma issue][File an issue] no repositório principal do Flutter.
* Você pode conversar e fazer perguntas relacionadas à web no
  canal **#help** no [Discord][Discord].

[Building a web application with Flutter]: /platform-integration/web/building
[Set up a web development configuration file]: /platform-integration/web/web-dev-config-file
[Creating responsive apps]: /ui/adaptive-responsive
[Discord]: https://discordapp.com/invite/yeZ6s7k
[File an issue]: https://goo.gle/flutter_web_issue
[Wonderous app]: {{site.wonderous}}/web
[Preparing an app for web release]: /deployment/web
[Progressive Web Application]: https://web.dev/progressive-web-apps/
[web FAQ]: /platform-integration/web/faq
[web samples for Flutter]: https://github.com/flutter/samples/#?platform=web
[Web renderers]: /platform-integration/web/renderers
