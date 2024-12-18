---
ia-translate: true
title: Construindo uma aplicação web com Flutter
description: Instruções para criar um aplicativo Flutter para a web.
short-title: Desenvolvimento Web
---

Esta página fornece uma visão geral de como configurar, executar e construir
uma aplicação web usando Flutter.

## Requisitos

Antes de construir uma aplicação web com Flutter, certifique-se de ter o
[Flutter SDK][] e um navegador instalado. Veja as instruções de
[Configurar o desenvolvimento web para Flutter][Setup-web] para detalhes.

## Configurar um projeto Flutter

Para configurar seu projeto, você pode criar um novo projeto Flutter ou adicionar
suporte web a um projeto existente.

### Criar um novo projeto

Para criar um novo aplicativo que inclua suporte web, execute o seguinte comando:

```console
$ flutter create my_app
```

### Adicionar suporte web a um projeto existente

Se você já tem um projeto, execute o comando `flutter create` no diretório
do seu projeto:

```console
$ flutter create . --platforms web
```

Isso cria um diretório `web/` contendo os ativos web usados para inicializar
e executar seu aplicativo Flutter.

## Executar seu aplicativo

Selecione [Chrome][] como o dispositivo alvo do seu aplicativo para executar e
depurar um aplicativo web Flutter:

```console
$ flutter run -d chrome
```

Você também pode escolher o Chrome como um dispositivo alvo em sua IDE.

Se preferir, você pode usar o tipo de dispositivo `edge` no Windows, ou usar
`web-server` para navegar até uma URL local no navegador de sua escolha.

:::warning
**Hot reload não é suportado em um navegador web**. Atualmente, o Flutter
suporta apenas **hot restart**, que reinicia seu aplicativo sem atualizar a
página web.
:::

### Execute seu aplicativo usando WebAssembly

Você pode passar a flag `--wasm` para executar seu aplicativo usando WebAssembly:

```console
$ flutter run -d chrome --wasm
```

Flutter web oferece múltiplos modos de build e renderizadores. Para mais
informações, veja [Renderizadores web][].

## Construir seu aplicativo

Execute o seguinte comando para gerar uma build de release:

```console
$ flutter build web
```

### Construir seu aplicativo usando WebAssembly
Você também pode passar a flag `--wasm` para construir seu aplicativo usando
WebAssembly:

```console
$ flutter build web --wasm
```

Isso preenche um diretório `build/web` com arquivos construídos, incluindo um
diretório `assets`, que precisam ser servidos juntos.

Para aprender mais sobre como realizar o deploy desses ativos na web, veja
[Construir e liberar um aplicativo web][]. Para respostas a outras perguntas
comuns, veja o [FAQ web][].

## Depuração

Use o [Flutter DevTools][] para as seguintes tarefas:

* [Depuração][]
* [Logging][]
* [Executando o inspetor do Flutter][]

Use o [Chrome DevTools][] para as seguintes tarefas:

* [Gerando timeline de eventos][]
* [Analisando performance][]&mdash;certifique-se de usar uma
  build de perfil

## Testes

Use [testes de widget][Widget tests] ou testes de integração. Para aprender
mais sobre como executar testes de integração em um navegador, veja a página
[Testes de integração][].

[Analisando performance]: {{site.developers}}/web/tools/chrome-devtools/evaluate-performance
[Build and release a web app]: /deployment/web
[Chrome DevTools]: {{site.developers}}/web/tools/chrome-devtools
[Chrome]: https://www.google.com/chrome/
[Depuração]: /tools/devtools/debugger
[Flutter DevTools]: /tools/devtools
[Flutter SDK]: /get-started/install
[Gerando timeline de eventos]: {{site.developers}}/web/tools/chrome-devtools/evaluate-performance/performance-reference
[Testes de integração]: /testing/integration-tests#test-in-a-web-browser
[Logging]: /tools/devtools/logging
[Executando o inspetor do Flutter]: /tools/devtools/inspector
[Setup-web]: {{site.url}}/platform-integration/web/install-web
[FAQ web]: /platform-integration/web/faq
[Renderizadores web]: /platform-integration/web/renderers
[Testes de widget]: /testing/overview#widget-tests
