---
ia-translate: true
title: Perguntas Frequentes sobre Desempenho
description: Perguntas frequentes sobre o desempenho do Flutter
---

Esta página reúne algumas perguntas frequentes sobre como avaliar
e depurar o desempenho do Flutter.

* Quais dashboards de desempenho possuem métricas relacionadas
  ao Flutter?
  * [Dashboard do Flutter no appspot][]
  * [Dashboard do Flutter Skia][]
  * [Dashboard do Flutter Engine Skia][]

[Dashboard do Flutter no appspot]: https://flutter-dashboard.appspot.com/
[Dashboard do Flutter Engine Skia]: https://flutter-engine-perf.skia.org/t/?subset=regressions
[Dashboard do Flutter Skia]: https://flutter-flutter-perf.skia.org/t/?subset=regressions

* Como adiciono um benchmark ao Flutter?
  * [Como escrever um teste de velocidade de renderização para o
    Flutter][speed-test]
  * [Como escrever um teste de memória para o Flutter][memory-test]

[memory-test]: {{site.repo.flutter}}/blob/master/docs/contributing/testing/How-to-write-a-memory-test-for-Flutter.md
[speed-test]: {{site.repo.flutter}}/blob/master/docs/contributing/testing/How-to-write-a-render-speed-test-for-Flutter.md

* Quais são algumas ferramentas para capturar e analisar métricas
  de desempenho?
  * [Dart/Flutter DevTools](/tools/devtools)
  * [Apple instruments](https://en.wikipedia.org/wiki/Instruments_(software))
  * [Linux perf](https://en.wikipedia.org/wiki/Perf_(Linux))
  * [Chrome tracing (digite `about:tracing` no campo de URL do
    Chrome)][tracing]
  * [Android systrace (`adb systrace`)][systrace]
  * [Fuchsia `fx traceutil`][traceutil]
  * [Perfetto](https://ui.perfetto.dev/)
  * [speedscope](https://www.speedscope.app/)

[systrace]: {{site.android-dev}}/studio/profile/systrace
[tracing]: https://www.chromium.org/developers/how-tos/trace-event-profiling-tool
[traceutil]: https://fuchsia.dev/fuchsia-src/development/tracing/usage-guide

* Meu aplicativo Flutter parece instável ou gagueja. Como posso
  corrigir isso?
  * [Melhorando o desempenho da renderização][]

[Melhorando o desempenho da renderização]: /perf/rendering-performance

* Quais são algumas operações de desempenho dispendiosas com as
  quais devo ter cuidado?
  * [`Opacity`][], [`Clip.antiAliasWithSaveLayer`][], ou qualquer coisa que
    dispare [`saveLayer`][]
  * [`ImageFilter`][]
  * Veja também [Melhores práticas de desempenho][]

[`Clip.antiAliasWithSaveLayer`]: {{site.api}}/flutter/dart-ui/Clip.html#antiAliasWithSaveLayer
[`ImageFilter`]: {{site.api}}/flutter/dart-ui/ImageFilter-class.html
[`Opacity`]: {{site.api}}/flutter/widgets/Opacity-class.html
[Melhores práticas de desempenho]: /perf/best-practices
[`savelayer`]: {{site.api}}/flutter/dart-ui/Canvas/saveLayer.html

* Como posso saber quais widgets em meu aplicativo Flutter são
  reconstruídos em cada frame?
  * Defina [`debugProfileBuildsEnabled`][] como true em
    [widgets/debug.dart][debug.dart].
  * Alternativamente, altere a função `performRebuild` em
    [widgets/framework.dart][framework.dart] para ignorar
    `debugProfileBuildsEnabled` e sempre chamar
    `Timeline.startSync(...)/finish`.
  * Se você usa o IntelliJ, uma visualização GUI desses dados
    está disponível. Selecione **Track widget rebuilds** e seu
    IDE exibirá quais widgets são reconstruídos.

[`debugProfileBuildsEnabled`]: {{site.api}}/flutter/widgets/debugProfileBuildsEnabled.html
[debug.dart]: {{site.repo.flutter}}/blob/master/packages/flutter/lib/src/widgets/debug.dart
[framework.dart]: {{site.repo.flutter}}/blob/master/packages/flutter/lib/src/widgets/framework.dart

* Como consulto o target frames per second (do display)?
  * [Obtenha a taxa de atualização do display][]

[Obtenha a taxa de atualização do display]: {{site.repo.engine}}/blob/main/docs/Engine-specific-Service-Protocol-extensions.md#get-the-display-refresh-rate-_fluttergetdisplayrefreshrate

* Como resolvo as animações ruins do meu aplicativo causadas por
  uma chamada de função assíncrona Dart dispendiosa que está
  bloqueando a thread da UI?
  * Gere outro isolate usando o método [`compute()`][], conforme
    demonstrado no cookbook [Analisar JSON em segundo plano][].

[`compute()`]: {{site.api}}/flutter/foundation/compute-constant.html
[Analisar JSON em segundo plano]: /cookbook/networking/background-parsing

* Como determino o tamanho do pacote do meu aplicativo Flutter
  que um usuário fará o download?
  * Veja [Medindo o tamanho do seu aplicativo][]

[Medindo o tamanho do seu aplicativo]: /perf/app-size

* Como posso ver o detalhamento do tamanho do Flutter engine?
  * Visite o [dashboard de tamanho binário][], e substitua o
    hash do git na URL por um hash de commit recente do
    [repositório de commits do GitHub engine][].

[dashboard de tamanho binário]: https://storage.googleapis.com/flutter_infra_release/flutter/241c87ad800beeab545ab867354d4683d5bfb6ce/android-arm-release/sizes/index.html
[repositório de commits do GitHub engine]: {{site.repo.engine}}/commits

* Como posso tirar uma captura de tela de um aplicativo em
  execução e exportá-la como um arquivo SKP?
  * Execute `flutter screenshot --type=skia --observatory-uri=...`
  * Observe um problema conhecido na visualização de capturas
    de tela:
    * [Issue 21237][]: Não grava imagens em dispositivos reais.
  * Para analisar e visualizar o arquivo SKP, confira o
    [depurador Skia WASM][].

[Issue 21237]: {{site.repo.flutter}}/issues/21237
[depurador Skia WASM]: https://debugger.skia.org/

* Como faço para recuperar o cache persistente de shader de um
  dispositivo?
  * No Android, você pode fazer o seguinte:
    ```console
    adb shell
    run-as <com.seu_pacote_app>
    cp <sua_pasta> <alguma_pasta_pública, ex., /sdcard> -r
    adb pull <alguma_pasta_pública/sua_pasta>
    ```

* Como realizo um trace no Fuchsia?
  * Veja [Diretrizes de tracing do Fuchsia][traceutil]
