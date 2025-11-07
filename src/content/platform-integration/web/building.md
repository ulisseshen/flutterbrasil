---
ia-translate: true
title: Construindo uma aplicação web com Flutter
description: Instruções para criar um app Flutter para a web.
short-title: Desenvolvimento web
---

Esta página fornece uma visão geral de como configurar, executar e construir uma
aplicação web usando Flutter.

## Requisitos

Antes de poder construir uma aplicação web com Flutter,
certifique-se de ter o [Flutter SDK][] e um navegador web instalados.
Veja as instruções [Set up web development for Flutter][Setup-web]
para detalhes.

## Configurar um projeto Flutter

Para configurar seu projeto, você pode criar um novo projeto Flutter ou adicionar suporte web
a um projeto existente.

### Criar um novo projeto

Para criar um novo app que inclua suporte web, execute o seguinte comando:

```console
$ flutter create my_app
```

### Adicionar suporte web a um projeto existente

Se você já tem um projeto, execute o comando `flutter create` no diretório do seu projeto:

```console
$ flutter create . --platforms web
```

Isso cria um diretório `web/` contendo os assets web usados para inicializar
e executar seu app Flutter.

## Executar seu app

Selecione [Chrome][] como o dispositivo de destino do seu app para executar e debugar um app Flutter web:

```console
$ flutter run -d chrome
```

Você também pode escolher Chrome como um dispositivo de destino na sua IDE.

Se preferir, você pode usar o tipo de dispositivo `edge` no Windows, ou usar `web-server` para
navegar para uma URL local no navegador de sua escolha.

:::warning
**Hot reload não é suportado em um navegador web**.
Atualmente, Flutter só suporta **hot restart**, que reinicia seu app
sem atualizar a página web.
:::

### Executar seu app usando WebAssembly

Você pode passar a flag `--wasm` para executar seu app usando WebAssembly:

```console
$ flutter run -d chrome --wasm
```

Flutter web oferece múltiplos modos de build e renderers. Para mais informações,
veja [Web renderers][].

## Construir seu app

Execute o seguinte comando para gerar um build de release:

```console
$ flutter build web
```

### Construir seu app usando WebAssembly
Você também pode passar a flag `--wasm` para construir seu app usando WebAssembly:

```console
$ flutter build web --wasm
```

Isso popula um diretório `build/web`
com arquivos construídos, incluindo um diretório `assets`,
que precisam ser servidos juntos.

Para saber mais sobre como implantar esses assets na web, veja
[Build and release a web app][].
Para respostas a outras perguntas comuns, veja o [Web FAQ][].

## Debug

Use [Flutter DevTools][] para as seguintes tarefas:

* [Debugging][]
* [Logging][]
* [Running Flutter inspector][]

Use [Chrome DevTools][] para as seguintes tarefas:

* [Generating event timeline][]
* [Analyzing performance][]&mdash;certifique-se de usar um
  build profile

## Testes

Use [widget tests][Widget tests] ou testes de integração. Para saber mais sobre
executar testes de integração em um navegador, veja a página [Integration testing][].

[Analyzing performance]: {{site.developers}}/web/tools/chrome-devtools/evaluate-performance
[Build and release a web app]: /deployment/web
[Chrome DevTools]: {{site.developers}}/web/tools/chrome-devtools
[Chrome]: https://www.google.com/chrome/
[Debugging]: /tools/devtools/debugger
[Flutter DevTools]: /tools/devtools
[Flutter SDK]: /get-started/install
[Generating event timeline]: {{site.developers}}/web/tools/chrome-devtools/evaluate-performance/performance-reference
[Integration testing]: /testing/integration-tests#test-in-a-web-browser
[Logging]: /tools/devtools/logging
[Running Flutter inspector]: /tools/devtools/inspector
[Setup-web]: {{site.url}}/platform-integration/web/install-web
[Web FAQ]: /platform-integration/web/faq
[Web renderers]: /platform-integration/web/renderers
[Widget tests]: /testing/overview#widget-tests
