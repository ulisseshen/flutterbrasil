---
title: Modos de build do Flutter
description: Descreve os modos de build do Flutter e quando você deve usar o modo debug, release ou profile.
ia-translate: true
---

As ferramentas do Flutter suportam três modos ao compilar seu aplicativo,
e um modo headless para testes.
Você escolhe um modo de compilação dependendo de onde você está no
ciclo de desenvolvimento. Você está depurando seu código? Você precisa
de informações de profiling? Você está pronto para implantar seu aplicativo?

Um resumo rápido de quando usar cada modo é o seguinte:

* Use o modo [debug](#debug) durante o desenvolvimento,
  quando você quiser usar o [hot reload][].
* Use o modo [profile](#profile) quando você quiser analisar
  o desempenho.
* Use o modo [release](#release) quando você estiver pronto para lançar
  seu aplicativo.

O restante da página detalha esses modos.

* Para saber mais sobre o modo de teste headless,
  consulte a documentação do wiki do engine sobre os [modos de build do Flutter][].
* Para saber como detectar o modo de build, verifique a postagem do blog
  [Check for Debug/Release Mode in Flutter Apps].

[Check for Debug/Release Mode in Flutter Apps]: https://retroportalstudio.medium.com/check-for-debug-release-mode-in-flutter-apps-d8d545f20da3

## Debug

No _modo debug_, o aplicativo é configurado para depuração no dispositivo físico,
emulador ou simulador.

O modo debug para aplicativos móveis significa que:

* [Assertions][] estão habilitadas.
* Extensões de serviço estão habilitadas.
* A compilação é otimizada para desenvolvimento rápido e ciclos de execução
  (mas não para velocidade de execução, tamanho binário ou implantação).
* A depuração está habilitada e as ferramentas que suportam depuração em nível de código-fonte
  (como [DevTools][]) podem se conectar ao processo.

O modo debug para um aplicativo web significa que:

* O build _não_ é minificado e o tree shaking _não_ foi
  executado.
* O aplicativo é compilado com o compilador [dartdevc][] para
  facilitar a depuração.

Por padrão, `flutter run` compila para o modo debug.
Seu IDE oferece suporte a esse modo. O Android Studio,
por exemplo, fornece uma opção de menu **Run > Debug...**,
bem como um ícone de bug verde sobreposto com um pequeno triângulo
na página do projeto.

:::note
* Hot reload funciona _apenas_ no modo debug.
* O emulador e o simulador são executados _apenas_ no modo debug.
* O desempenho do aplicativo pode ser instável no modo debug.
  Meça o desempenho no modo [profile](#profile)
  em um dispositivo real.
:::

## Release

Use o _modo release_ para implantar o aplicativo, quando você quiser o máximo
de otimização e tamanho mínimo. Para dispositivos móveis, o modo release
(que não é suportado no simulador ou emulador), significa que:

* Assertions são desabilitadas.
* Informações de depuração são removidas.
* A depuração está desabilitada.
* A compilação é otimizada para inicialização rápida, execução rápida
  e tamanhos de pacote pequenos.
* Extensões de serviço são desabilitadas.

O modo release para um aplicativo web significa que:

* O build é minificado e o tree shaking foi executado.
* O aplicativo é compilado com o compilador [dart2js][] para
  melhor desempenho.

O comando `flutter run --release` compila para o modo release.
Seu IDE oferece suporte a esse modo. O Android Studio, por exemplo,
fornece uma opção de menu **Run > Run...**, bem como um botão
triangular verde de execução na página do projeto.
Você pode compilar para o modo release para um destino específico
com `flutter build <destino>`. Para obter uma lista de destinos suportados,
use `flutter help build`.

Para mais informações, consulte a documentação sobre lançamento de aplicativos
[iOS][] e [Android][].

## Profile

No _modo profile_, alguma capacidade de depuração é mantida — o suficiente
para fazer o profiling do desempenho do seu aplicativo. O modo profile é desabilitado no
emulador e no simulador, porque o comportamento deles não é representativo
do desempenho real. Em dispositivos móveis, o modo profile é semelhante ao modo release,
com as seguintes diferenças:

* Algumas extensões de serviço, como a que habilita a sobreposição de desempenho,
  estão habilitadas.
* O tracing está habilitado e as ferramentas que suportam a depuração em nível de código-fonte
  (como [DevTools][]) podem se conectar ao processo.

O modo profile para um aplicativo web significa que:

* O build _não_ é minificado, mas o tree shaking foi executado.
* O aplicativo é compilado com o compilador [dart2js][].
* DevTools não consegue se conectar a um aplicativo web Flutter em execução
  no modo profile. Use o Chrome DevTools para
  [gerar eventos de timeline][] para um aplicativo web.

Seu IDE oferece suporte a esse modo. O Android Studio, por exemplo,
fornece uma opção de menu **Run > Profile...**.
O comando `flutter run --profile` compila para o modo profile.

:::note
Use o conjunto [DevTools][] para fazer o profiling do desempenho do seu aplicativo.
:::

Para mais informações sobre os modos de build, veja
[modos de build do Flutter][].

[Android]: /deployment/android
[Assertions]: {{site.dart-site}}/language/error-handling#assert
[dart2js]: {{site.dart-site}}/tools/dart2js
[dartdevc]: {{site.dart-site}}/tools/dartdevc
[DevTools]: /tools/devtools
[modos de build do Flutter]: {{site.repo.engine}}/blob/main/docs/Flutter's-modes.md
[gerar eventos de timeline]: {{site.developers}}/web/tools/chrome-devtools/evaluate-performance/performance-reference
[hot reload]: /tools/hot-reload
[iOS]: /deployment/ios
