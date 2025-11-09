---
ia-translate: true
title: Modos de compilação do Flutter
description: Descreve os modos de compilação do Flutter e quando você deve usar o modo debug, release ou profile.
---

As ferramentas Flutter suportam três modos ao compilar seu app,
e um modo headless para testes.
Você escolhe um modo de compilação dependendo de onde está no
ciclo de desenvolvimento. Você está depurando seu código? Precisa
de informações de profiling? Está pronto para implantar seu app?

Um resumo rápido de quando usar qual modo é o seguinte:

* Use o modo [debug](#debug) durante o desenvolvimento,
  quando você quiser usar [hot reload][hot reload].
* Use o modo [profile](#profile) quando quiser analisar
  performance.
* Use o modo [release](#release) quando estiver pronto para lançar
  seu app.

O restante da página detalha esses modos.

* Para aprender sobre o modo de teste headless,
  consulte os documentos da wiki do engine sobre [modos de compilação do Flutter][Flutter's build modes].
* Para aprender como detectar o modo de compilação, confira o
  post do blog [Check for Debug/Release Mode in Flutter Apps].

[Check for Debug/Release Mode in Flutter Apps]: https://retroportalstudio.medium.com/check-for-debug-release-mode-in-flutter-apps-d8d545f20da3

## Debug

No _modo debug_, o app é configurado para depuração no dispositivo
físico, emulador ou simulador.

O modo debug para apps mobile significa que:

* [Assertions][Assertions] estão habilitadas.
* Service extensions estão habilitadas.
* A compilação é otimizada para ciclos rápidos de desenvolvimento e execução
  (mas não para velocidade de execução, tamanho do binário ou implantação).
* A depuração está habilitada, e ferramentas que suportam depuração em nível de código-fonte
  (como [DevTools][DevTools]) podem se conectar ao processo.

O modo debug para um app web significa que:

* A compilação _não_ é minificada e tree shaking _não_ foi
  realizado.
* O app é compilado com o compilador [dartdevc][dartdevc] para
  facilitar a depuração.

Por padrão, `flutter run` compila no modo debug.
Sua IDE suporta este modo. Android Studio,
por exemplo, fornece uma opção de menu **Run > Debug...**,
bem como um ícone de bug verde sobreposto com um pequeno triângulo
na página do projeto.

:::note
* Hot reload funciona _apenas_ no modo debug.
* O emulador e simulador executam _apenas_ no modo debug.
* A performance da aplicação pode ser irregular no modo debug.
  Meça a performance no modo [profile](#profile)
  em um dispositivo real.
:::

## Release

Use o _modo release_ para implantar o app, quando você quiser máxima
otimização e tamanho mínimo. Para mobile, o modo release
(que não é suportado no simulador ou emulador), significa que:

* Assertions estão desabilitadas.
* Informações de depuração são removidas.
* A depuração está desabilitada.
* A compilação é otimizada para inicialização rápida, execução rápida,
  e tamanhos de pacote pequenos.
* Service extensions estão desabilitadas.

O modo release para um app web significa que:

* A compilação é minificada e tree shaking foi realizado.
* O app é compilado com o compilador [dart2js][dart2js] para
  melhor performance.

O comando `flutter run --release` compila no modo release.
Sua IDE suporta este modo. Android Studio, por exemplo,
fornece uma opção de menu **Run > Run...**, bem como um ícone
triangular verde de executar na página do projeto.
Você pode compilar no modo release para um target específico
com `flutter build <target>`. Para uma lista de targets suportados,
use `flutter help build`.

Para mais informações, veja os documentos sobre lançamento de
apps [iOS][iOS] e [Android][Android].

## Profile

No _modo profile_, alguma capacidade de depuração é mantida&mdash;o suficiente
para fazer o profiling da performance do seu app. O modo profile está desabilitado no
emulador e simulador, porque seu comportamento não é representativo
da performance real. No mobile, o modo profile é similar ao modo release,
com as seguintes diferenças:

* Algumas service extensions, como a que habilita o performance
  overlay, estão habilitadas.
* Tracing está habilitado, e ferramentas que suportam depuração em nível de código-fonte
  (como [DevTools][DevTools]) podem se conectar ao processo.

O modo profile para um app web significa que:

* A compilação _não_ é minificada mas tree shaking foi realizado.
* O app é compilado com o compilador [dart2js][dart2js].
* DevTools não pode se conectar a um app Flutter web executando
  no modo profile. Use Chrome DevTools para
  [gerar eventos de timeline][generate timeline events] para um app web.

Sua IDE suporta este modo. Android Studio, por exemplo,
fornece uma opção de menu **Run > Profile...**.
O comando `flutter run --profile` compila no modo profile.

:::note
Use o conjunto de ferramentas [DevTools][DevTools] para fazer o profiling da performance do seu app.
:::

Para mais informações sobre os modos de compilação, veja
[modos de compilação do Flutter][Flutter's build modes].


[Android]: /deployment/android
[Assertions]: {{site.dart-site}}/language/error-handling#assert
[dart2js]: {{site.dart-site}}/tools/dart2js
[dartdevc]: {{site.dart-site}}/tools/dartdevc
[DevTools]: /tools/devtools
[Flutter's build modes]: {{site.repo.flutter}}/blob/main/docs/engine/Flutter's-modes.md
[generate timeline events]: {{site.developers}}/web/tools/chrome-devtools/evaluate-performance/performance-reference
[hot reload]: /tools/hot-reload
[iOS]: /deployment/ios
