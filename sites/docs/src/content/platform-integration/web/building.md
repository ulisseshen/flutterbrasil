---
ia-translate: true
title: Construindo uma aplicação web com Flutter
description: Instruções para criar um app Flutter para a web.
shortTitle: Desenvolvimento web
---

Esta página fornece uma visão geral de como configurar, executar e compilar uma
aplicação web usando Flutter.

## Requisitos

Antes de poder construir uma aplicação web com Flutter,
certifique-se de que você tem o [Flutter SDK][] e um navegador web instalado.
Visite as instruções em [Set up web development for Flutter][Setup-web]
para detalhes.

## Configurar um projeto Flutter

Para configurar seu projeto, você pode criar um
novo projeto Flutter ou adicionar suporte web
a um projeto existente.

### Criar um novo projeto

Para criar um novo app que inclui suporte web, execute o seguinte comando:

```console
$ flutter create my_app
```

### Adicionar suporte web a um projeto existente

Se você já tem um projeto,
execute o comando `flutter create` no diretório do seu projeto:

```console
$ flutter create . --platforms web
```

Isso cria um diretório `web/` contendo os assets web usados para inicializar
e executar seu app Flutter.

## Executar seu app

Confira as seções a seguir para executar seu app.

### Executar seu app a partir da linha de comando

Selecione [Chrome][Chrome] como o dispositivo alvo do seu app para executar e depurar
um app Flutter web:

```console
$ flutter run -d chrome
```

Você também pode escolher Chrome como dispositivo alvo na sua IDE.

Se preferir, você pode usar o tipo de dispositivo `edge` no Windows,
ou usar `web-server` para
navegar para uma URL local no navegador de sua escolha.

<a id="hot-reload-web" aria-hidden="true" ></a>

:::note Hot reload na web
A partir do lançamento do Flutter 3.35,
hot reload está habilitado por padrão na web.
[Hot restart][Hot restart] ainda está disponível também.

Se você descobrir quaisquer problemas, pedimos que registre um bug
usando nosso [Web Hot Reload issue template][Web Hot Reload issue template].
Note que isso está no repositório Dart SDK onde é mais fácil
para nós rastrear problemas. Problemas conhecidos podem ser vistos no
[GitHub project][GitHub project] associado.
:::

### Executar seu app usando WebAssembly

Você pode passar a flag `--wasm` para executar seu app usando WebAssembly:

```console
$ flutter run -d chrome --wasm
```

Para aprender mais sobre compilação WebAssembly e requisitos de servidor,
confira [Suporte a WebAssembly (Wasm)][Wasm support].

### Usar hot reload no DartPad

Hot reload também está habilitado no DartPad com um novo botão "Reload".
A funcionalidade está disponível apenas se Flutter for detectado
na aplicação em execução. Você pode iniciar uma
sessão com hot reload selecionando um app de exemplo fornecido pelo DartPad.

[Hot restart]: /tools/hot-reload
[How to switch channels]: /install/upgrade#switching-flutter-channels
[Web Hot Reload issue template]: {{site.repo.dart-sdk}}/issues/new?template=5_web_hot_reload.yml
[GitHub project]: https://github.com/orgs/dart-lang/projects/107/views/1

## Compilar seu app

Veja as seções a seguir para compilar seu app.

### Compilar seu app a partir da linha de comando

Execute o seguinte comando para gerar um build de release:

```console
$ flutter build web
```

### Compilar seu app usando WebAssembly

Você também pode passar a flag `--wasm` para compilar seu app usando WebAssembly:

```console
$ flutter build web --wasm
```

Isso popula um diretório `build/web`
com arquivos compilados, incluindo um diretório `assets`,
que precisam ser servidos juntos.

Para aprender mais sobre como fazer deploy desses assets na web,
visite [Build and release a web app][].
Para respostas a outras perguntas comuns, visite o [Web FAQ][].

Se você encontrar erros ao compilar seu app com Wasm, confira
[Diagnosticando erros de compilação Wasm](/platform-integration/web/wasm#diagnosing-wasm-compilation-errors).

## Depuração

Use [Flutter DevTools][Flutter DevTools] para as seguintes tarefas:

* [Debugging][Debugging]
* [Logging][Logging]
* [Running Flutter inspector][Running Flutter inspector]

Use [Chrome DevTools][Chrome DevTools] para as seguintes tarefas:

* [Generating event timeline][Generating event timeline]
* [Analyzing performance][Analyzing performance]&mdash;certifique-se de usar um
  build de profile

## Testes

Use [widget tests][Widget tests] ou testes de integração. Para aprender mais sobre
como executar testes de integração em um navegador, confira a página [Integration testing][].

[Analyzing performance]: {{site.developers}}/web/tools/chrome-devtools/evaluate-performance
[Build and release a web app]: /deployment/web
[Chrome DevTools]: {{site.developers}}/web/tools/chrome-devtools
[Chrome]: https://www.google.com/chrome/
[Debugging]: /tools/devtools/debugger
[Flutter DevTools]: /tools/devtools
[Flutter SDK]: /install
[Generating event timeline]: {{site.developers}}/web/tools/chrome-devtools/evaluate-performance/performance-reference
[Integration testing]: /testing/integration-tests#test-in-a-web-browser
[Logging]: /tools/devtools/logging
[Running Flutter inspector]: /tools/devtools/inspector
[Setup-web]: /platform-integration/web/setup
[Web FAQ]: /platform-integration/web/faq
[Wasm support]: /platform-integration/web/wasm
[Widget tests]: /testing/overview#widget-tests
