---
ia-translate: true
title: Suporte Web para Flutter
short-title: Web
description: Detalhes de como o Flutter suporta a criação de experiências web.
---

O Flutter oferece as mesmas experiências na web que no mobile.

Aproveitando a portabilidade do Dart, o poder da plataforma web, a
flexibilidade do framework Flutter e o desempenho do WebAssembly,
você pode criar aplicativos para iOS, Android e navegador a partir da mesma base de código.
A web é apenas mais um dispositivo alvo para seu aplicativo.

Para começar, visite [Construindo um aplicativo web com Flutter][].

## Desenvolvido por WebAssembly
Dart e Flutter podem ser compilados para WebAssembly,
um formato de instrução binária que permite aplicativos rápidos em todos os principais navegadores.

Para ter uma visão dos benefícios de usar o WebAssembly,
confira o vídeo a seguir.

{% ytEmbed 'lpnKWK-KEYs?start=1712', 'O que há de novo no Flutter - WebAssembly' %}

## Como funciona
Adicionar suporte web ao Flutter envolveu a implementação da
camada de desenho principal do Flutter em cima das APIs padrão do navegador,
além de compilar o Dart para JavaScript, em vez do código de máquina ARM que
é usado para aplicativos móveis. Usando uma combinação de DOM, Canvas e
WebAssembly, o Flutter pode fornecer uma experiência de usuário portátil, de alta qualidade
e performática em navegadores modernos. Implementamos a camada de desenho
principal completamente em Dart e usamos o compilador JavaScript otimizado do Dart para
compilar o núcleo e o framework do Flutter juntamente com seu aplicativo
em um único arquivo de código-fonte minificado que pode ser implantado em
qualquer servidor web.

<img src="/assets/images/docs/arch-overview/web-arch.png"
alt="Arquitetura Flutter para web"
width="100%">

## Que tipos de aplicativos posso construir?
Embora você possa fazer muito na web,
o suporte web do Flutter é mais valioso nos
seguintes cenários:

**Aplicativo de Página Única**
: O suporte web do Flutter permite aplicativos web autônomos complexos, ricos em
  gráficos e conteúdo interativo, para alcançar usuários finais em uma ampla variedade de
  dispositivos.

**Aplicativos móveis existentes**
: O suporte web para Flutter fornece um modelo de entrega baseado em navegador para
  aplicativos móveis Flutter existentes.

Nem todo cenário HTML é ideal para o Flutter neste momento.
Por exemplo, conteúdo estático rico em texto e baseado em fluxo, como artigos de blog,
se beneficia do modelo centrado em documentos em torno do qual a web é construída,
em vez dos serviços centrados em aplicativos que um framework de UI como o Flutter
pode oferecer. No entanto, você _pode_ usar o Flutter para incorporar experiências interativas
nesses sites.

## Comece
Os seguintes recursos podem ajudá-lo a começar:

* Para adicionar suporte web a um aplicativo existente ou criar um
  novo aplicativo que inclua suporte web, veja
  [Construindo um aplicativo web com Flutter][].
* Para aprender sobre os diferentes renderizadores web do Flutter (CanvasKit e Skwasm), veja
  [Renderizadores web][]
* Para aprender a criar um aplicativo Flutter responsivo, veja
  [Criando aplicativos responsivos][].
* Para ver perguntas e respostas frequentes, consulte o
  [FAQ da web][].
* Para ver exemplos de código,
  confira os [exemplos web para Flutter][].
* Para ver uma demonstração do aplicativo web Flutter, confira o [aplicativo Wonderous][].
* Para aprender sobre como implantar um aplicativo web, consulte
  [Preparando um aplicativo para lançamento na web][].
* [Abra um issue][] no repositório principal do Flutter.
* Você pode conversar e fazer perguntas relacionadas à web no
  canal **#help** no [Discord][].

[Construindo um aplicativo web com Flutter]: /platform-integration/web/building
[Criando aplicativos responsivos]: /ui/adaptive-responsive
[Discord]: https://discordapp.com/invite/yeZ6s7k
[Abra um issue]: https://goo.gle/flutter_web_issue
[aplicativo Wonderous]: {{site.wonderous}}/web
[Preparando um aplicativo para lançamento na web]: /deployment/web
[Progressive Web Application]: https://web.dev/progressive-web-apps/
[FAQ da web]: /platform-integration/web/faq
[exemplos web para Flutter]: https://flutter.github.io/samples/#?platform=web
[Renderizadores web]: /platform-integration/web/renderers
