---
ia-translate: true
title: Suporte web para Flutter
short-title: Web
description: Detalhes de como Flutter suporta a criação de experiências web.
---

Flutter entrega as mesmas experiências na web que no mobile.

Construindo na portabilidade do Dart, no poder da plataforma web, na
flexibilidade do framework Flutter e na performance do WebAssembly,
você pode construir apps para iOS, Android e o navegador a partir da mesma base de código.
A web é apenas mais um dispositivo de destino para seu app.

Para começar, visite [Building a web application with Flutter][].

## Powered by WebAssembly
Dart e Flutter podem compilar para WebAssembly,
um formato de instrução binária que habilita apps rápidos em todos os principais navegadores.

Para um vislumbre dos benefícios de usar WebAssembly,
confira o vídeo a seguir.

{% ytEmbed 'lpnKWK-KEYs?start=1712', 'What\'s new in Flutter - WebAssembly' %}

## Como funciona
Adicionar suporte web ao Flutter envolveu implementar a
camada de desenho core do Flutter sobre APIs padrão do navegador, além
de compilar Dart para JavaScript, em vez do código de máquina ARM que
é usado para aplicações mobile. Usando uma combinação de DOM, Canvas
e WebAssembly, Flutter pode fornecer uma experiência de usuário portável, de alta qualidade
e performática através de navegadores modernos.
Implementamos a camada de desenho core completamente em Dart
e usamos o compilador JavaScript otimizado do Dart para compilar o
core e framework do Flutter junto com sua aplicação
em um único arquivo fonte minificado que pode ser implantado em
qualquer servidor web.

<img src="/assets/images/docs/arch-overview/web-arch.png"
alt="Flutter architecture for web"
width="100%">

## Que tipos de apps eu posso construir?
Embora você possa fazer muito na web,
o suporte web do Flutter é mais valioso nos
seguintes cenários:

**Single Page Application**
: O suporte web do Flutter habilita apps web complexos e independentes que são ricos em
  gráficos e conteúdo interativo para alcançar usuários finais em uma ampla variedade de
  dispositivos.

**Aplicações mobile existentes**
: Suporte web para Flutter fornece um modelo de entrega baseado em navegador para
  apps Flutter mobile existentes.

Nem todo cenário HTML é idealmente adequado para Flutter neste momento.
Por exemplo, conteúdo rico em texto, baseado em fluxo e estático, como artigos de blog,
se beneficia do modelo centrado em documento que a web é construída,
em vez dos serviços centrados em app que um framework de UI como Flutter
pode entregar. No entanto, você _pode_ usar Flutter para incorporar
experiências interativas nesses websites.

## Comece

Os seguintes recursos podem ajudá-lo a começar:

* Para adicionar suporte web a um app existente, ou para criar um
  novo app que inclua suporte web, veja
  [Building a web application with Flutter][].
* Para aprender sobre os diferentes web renderers do Flutter (CanvasKit e Skwasm), veja
  [Web renderers][]
* Para aprender como criar um app Flutter
  responsivo, veja [Creating responsive apps][].
* Para ver perguntas frequentes e respostas, veja o
  [web FAQ][].
* Para ver exemplos de código,
  confira os [web samples for Flutter][].
* Para ver uma demo de app Flutter web, confira o [app Wonderous][Wonderous app].
* Para aprender sobre implantar um app web, veja
  [Preparing an app for web release][].
* [Registre um issue][File an issue] no repositório principal do Flutter.
* Você pode conversar e fazer perguntas relacionadas à web no
  canal **#help** no [Discord][].

[Building a web application with Flutter]: /platform-integration/web/building
[Creating responsive apps]: /ui/adaptive-responsive
[Discord]: https://discordapp.com/invite/yeZ6s7k
[file an issue]: https://goo.gle/flutter_web_issue
[Wonderous app]: {{site.wonderous}}/web
[Preparing an app for web release]: /deployment/web
[Progressive Web Application]: https://web.dev/progressive-web-apps/
[web FAQ]: /platform-integration/web/faq
[web samples for Flutter]: https://flutter.github.io/samples/#?platform=web
[Web renderers]: /platform-integration/web/renderers
