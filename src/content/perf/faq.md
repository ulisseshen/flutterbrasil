---
ia-translate: true
title: FAQ de Performance
description: Perguntas frequentes sobre performance do Flutter
---

Esta página coleta algumas perguntas frequentes
sobre avaliar e depurar a performance do Flutter.

* Quais dashboards de performance têm métricas relacionadas ao Flutter?
  * [Flutter dashboard no appspot][Flutter dashboard on appspot]
  * [Flutter Skia dashboard][Flutter Skia dashboard]
  * [Flutter Engine Skia dashboard][Flutter Engine Skia dashboard]

[Flutter dashboard on appspot]: https://flutter-dashboard.appspot.com/
[Flutter engine Skia dashboard]: https://flutter-engine-perf.skia.org/t/?subset=regressions
[Flutter Skia dashboard]: https://flutter-flutter-perf.skia.org/t/?subset=regressions

* Como adiciono um benchmark ao Flutter?
  * [Como escrever um teste de velocidade de renderização para Flutter][speed-test]
  * [Como escrever um teste de memória para Flutter][memory-test]

[memory-test]: {{site.repo.flutter}}/blob/main/docs/contributing/testing/How-to-write-a-memory-test-for-Flutter.md
[speed-test]: {{site.repo.flutter}}/blob/main/docs/contributing/testing/How-to-write-a-render-speed-test-for-Flutter.md

* Quais são algumas ferramentas para capturar e analisar métricas
  de performance?
  * [Dart/Flutter DevTools](/tools/devtools)
  * [Apple instruments](https://en.wikipedia.org/wiki/Instruments_(software))
  * [Linux perf](https://en.wikipedia.org/wiki/Perf_(Linux))
  * [Chrome tracing (digite `about:tracing` no seu
    campo de URL do Chrome)][tracing]
  * [Android systrace (`adb systrace`)][systrace]
  * [Fuchsia `fx traceutil`][traceutil]
  * [Perfetto](https://ui.perfetto.dev/)
  * [speedscope](https://www.speedscope.app/)

[systrace]: {{site.android-dev}}/studio/profile/systrace
[tracing]: https://www.chromium.org/developers/how-tos/trace-event-profiling-tool
[traceutil]: https://fuchsia.dev/fuchsia-src/development/tracing/usage-guide

* Meu app Flutter parece travado ou gagueja. Como eu conserto isso?
  * [Melhorando a performance de renderização][Improving rendering performance]

[Improving rendering performance]: /perf/rendering-performance

* Quais são algumas operações de performance custosas com as quais preciso
  ter cuidado?
  * [`Opacity`][`Opacity`], [`Clip.antiAliasWithSaveLayer`][`Clip.antiAliasWithSaveLayer`],
     ou qualquer coisa que dispare [`saveLayer`][`savelayer`]
  * [`ImageFilter`][`ImageFilter`]
  * Veja também [Melhores práticas de performance][Performance best practices]

[`Clip.antiAliasWithSaveLayer`]: {{site.api}}/flutter/dart-ui/Clip.html#antiAliasWithSaveLayer
[`ImageFilter`]: {{site.api}}/flutter/dart-ui/ImageFilter-class.html
[`Opacity`]: {{site.api}}/flutter/widgets/Opacity-class.html
[Performance best practices]: /perf/best-practices
[`savelayer`]: {{site.api}}/flutter/dart-ui/Canvas/saveLayer.html

* Como eu descubro quais widgets no meu app Flutter são reconstruídos
  em cada frame?
  * Defina [`debugProfileBuildsEnabled`][`debugProfileBuildsEnabled`] como true em
    [widgets/debug.dart][debug.dart].
  * Alternativamente, mude a função `performRebuild` em
    [widgets/framework.dart][framework.dart] para ignorar
    `debugProfileBuildsEnabled` e sempre chamar
    `Timeline.startSync(...)/finish`.
  * Se você usar IntelliJ, uma visualização GUI desses dados está disponível.
    Selecione **Track widget rebuilds**,
    e sua IDE exibe quais widgets fazem rebuild.

[`debugProfileBuildsEnabled`]: {{site.api}}/flutter/widgets/debugProfileBuildsEnabled.html
[debug.dart]: {{site.repo.flutter}}/blob/main/packages/flutter/lib/src/widgets/debug.dart
[framework.dart]: {{site.repo.flutter}}/blob/main/packages/flutter/lib/src/widgets/framework.dart

* Como eu consulto a taxa de quadros por segundo alvo (do display)?
  * [Obtenha a taxa de atualização do display][Get the display refresh rate]

[Get the display refresh rate]: {{site.repo.flutter}}/blob/main/engine/src/flutter/docs/Engine-specific-Service-Protocol-extensions.md#get-the-display-refresh-rate-_fluttergetdisplayrefreshrate

* Como resolver as animações ruins do meu app causadas por uma chamada de função
  async Dart cara que está bloqueando a thread da UI?
  * Crie outro isolate usando o método [`compute()`][`compute()`],
    conforme demonstrado no cookbook [Analisar JSON em background][Parse JSON in the background].

[`compute()`]: {{site.api}}/flutter/foundation/compute-constant.html
[Parse JSON in the background]: /cookbook/networking/background-parsing

* Como determino o tamanho do pacote do meu app Flutter que um
  usuário vai baixar?
  * Veja [Medindo o tamanho do seu app][Measuring your app's size]

[Measuring your app's size]: /perf/app-size

* Como vejo o detalhamento do tamanho do engine Flutter?
  * Visite o [dashboard de tamanho binário][binary size dashboard], e substitua o hash
    git na URL com um hash de commit recente dos
    [commits do GitHub do Flutter][Flutter's GitHub commits].

[binary size dashboard]: https://storage.googleapis.com/flutter_infra_release/flutter/241c87ad800beeab545ab867354d4683d5bfb6ce/android-arm-release/sizes/index.html
[Flutter's GitHub commits]: {{site.repo.flutter}}/commits/main

* Como posso tirar uma screenshot de um app que está rodando e exportá-la
  como um arquivo SKP?
  * Execute `flutter screenshot --type=skia --observatory-uri=...`
  * Note um problema conhecido ao visualizar screenshots:
    * [Issue 21237][Issue 21237]: Não grava imagens em dispositivos reais.
  * Para analisar e visualizar o arquivo SKP,
    confira o [Skia WASM debugger][Skia WASM debugger].

[Issue 21237]: {{site.repo.flutter}}/issues/21237
[Skia WASM debugger]: https://debugger.skia.org/

* Como recupero o cache persistente de shader de um dispositivo?
  * No Android, você pode fazer o seguinte:
    ```console
    adb shell
    run-as <com.your_app_package_name>
    cp <your_folder> <some_public_folder, e.g., /sdcard> -r
    adb pull <some_public_folder/your_folder>
    ```

* Como executo um trace no Fuchsia?
  * Veja [diretrizes de tracing do Fuchsia][traceutil]
