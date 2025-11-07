---
ia-translate: true
title: Modos de compilação do Flutter
description: Descreve os modos de compilação do Flutter e quando você deve usar os modos debug, release ou profile.
---

O ferramental do Flutter suporta três modos ao compilar seu app,
e um modo headless para testes.
Você escolhe um modo de compilação dependendo de onde você está no
ciclo de desenvolvimento. Você está depurando seu código? Você
precisa de informações de profiling? Você está pronto para implantar seu app?

Um resumo rápido de quando usar qual modo é o seguinte:

* Use o modo [debug](#debug) durante o desenvolvimento,
  quando você quiser usar [hot reload][].
* Use o modo [profile](#profile) quando quiser analisar
  o desempenho.
* Use o modo [release](#release) quando estiver pronto para lançar
  seu app.

O restante da página detalha esses modos.

* Para aprender sobre o modo de testes headless,
  consulte a documentação do wiki do engine sobre [Flutter's build modes][].
* Para aprender como detectar o modo de compilação, confira a
  postagem do blog [Check for Debug/Release Mode in Flutter Apps].

[Check for Debug/Release Mode in Flutter Apps]: https://retroportalstudio.medium.com/check-for-debug-release-mode-in-flutter-apps-d8d545f20da3

## Debug

No _modo debug_, o app é configurado para depuração no dispositivo
físico, emulador ou simulador.

O modo debug para apps mobile significa que:

* [Assertions][] estão habilitadas.
* Extensões de serviço estão habilitadas.
* A compilação é otimizada para ciclos rápidos de desenvolvimento e execução
  (mas não para velocidade de execução, tamanho do binário ou implantação).
* A depuração está habilitada, e ferramentas que suportam depuração em nível de código fonte
  (como [DevTools][]) podem se conectar ao processo.

O modo debug para um app web significa que:

* A compilação _não_ é minificada e tree shaking _não_ foi
  realizado.
* O app é compilado com o compilador [dartdevc][] para
  facilitar a depuração.

Por padrão, `flutter run` compila para o modo debug.
Seu IDE suporta esse modo. Android Studio,
por exemplo, fornece uma opção de menu **Run > Debug...**,
bem como um ícone de bug verde sobreposto com um pequeno triângulo
na página do projeto.

:::note
* Hot reload funciona _apenas_ no modo debug.
* O emulador e simulador executam _apenas_ no modo debug.
* O desempenho do aplicativo pode ser irregular no modo debug.
  Meça o desempenho no modo [profile](#profile)
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
* Extensões de serviço estão desabilitadas.

O modo release para um app web significa que:

* A compilação é minificada e tree shaking foi realizado.
* O app é compilado com o compilador [dart2js][] para
  melhor desempenho.

O comando `flutter run --release` compila para o modo release.
Seu IDE suporta esse modo. Android Studio, por exemplo,
fornece uma opção de menu **Run > Run...**, bem como um ícone
triangular verde de execução na página do projeto.
Você pode compilar para o modo release para um alvo específico
com `flutter build <target>`. Para uma lista de alvos suportados,
use `flutter help build`.

Para mais informações, veja a documentação sobre lançamento de
apps [iOS][] e [Android][].

## Profile

No _modo profile_, alguma capacidade de depuração é mantida&mdash;o suficiente
para perfilar o desempenho do seu app. O modo profile está desabilitado no
emulador e simulador, porque seu comportamento não é representativo
do desempenho real. No mobile, o modo profile é similar ao modo release,
com as seguintes diferenças:

* Algumas extensões de serviço, como a que habilita a sobreposição de desempenho,
  estão habilitadas.
* O tracing está habilitado, e ferramentas que suportam depuração em nível de código fonte
  (como [DevTools][]) podem se conectar ao processo.

O modo profile para um app web significa que:

* A compilação _não_ é minificada mas tree shaking foi realizado.
* O app é compilado com o compilador [dart2js][].
* DevTools não pode se conectar a um app web Flutter executando
  no modo profile. Use Chrome DevTools para
  [gerar eventos de timeline][] para um app web.

Seu IDE suporta esse modo. Android Studio, por exemplo,
fornece uma opção de menu **Run > Profile...**.
O comando `flutter run --profile` compila para o modo profile.

:::note
Use a suite [DevTools][] para perfilar o desempenho do seu app.
:::

Para mais informações sobre os modos de compilação, veja
[Flutter's build modes][].


[Android]: /deployment/android
[Assertions]: {{site.dart-site}}/language/error-handling#assert
[dart2js]: {{site.dart-site}}/tools/dart2js
[dartdevc]: {{site.dart-site}}/tools/dartdevc
[DevTools]: /tools/devtools
[Flutter's build modes]: {{site.repo.flutter}}/blob/main/engine/src/flutter/docs/Flutter's-modes.md
[gerar eventos de timeline]: {{site.developers}}/web/tools/chrome-devtools/evaluate-performance/performance-reference
[hot reload]: /tools/hot-reload
[iOS]: /deployment/ios
