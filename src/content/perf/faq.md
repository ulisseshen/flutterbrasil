---
ia-translate: true
title: FAQ de desempenho
description: Perguntas frequentes sobre desempenho do Flutter
---

Esta página reúne algumas perguntas frequentes
sobre avaliação e depuração do desempenho do Flutter.

* Quais dashboards de desempenho têm métricas relacionadas ao Flutter?
  * [Flutter dashboard no appspot][Flutter dashboard on appspot]
  * [Flutter Skia dashboard][]
  * [Flutter Engine Skia dashboard][]

[Flutter dashboard on appspot]: https://flutter-dashboard.appspot.com/
[Flutter engine Skia dashboard]: https://flutter-engine-perf.skia.org/t/?subset=regressions
[Flutter Skia dashboard]: https://flutter-flutter-perf.skia.org/t/?subset=regressions

* Como adiciono um benchmark ao Flutter?
  * [How to write a render speed test for Flutter][speed-test]
  * [How to write a memory test for Flutter][memory-test]

[memory-test]: {{site.repo.flutter}}/blob/main/docs/contributing/testing/How-to-write-a-memory-test-for-Flutter.md
[speed-test]: {{site.repo.flutter}}/blob/main/docs/contributing/testing/How-to-write-a-render-speed-test-for-Flutter.md

* Quais são algumas ferramentas para capturar e analisar métricas
  de desempenho?
  * [Dart/Flutter DevTools](/tools/devtools)
  * [Apple instruments](https://en.wikipedia.org/wiki/Instruments_(software))
  * [Linux perf](https://en.wikipedia.org/wiki/Perf_(Linux))
  * [Chrome tracing (entre `about:tracing` no
    campo URL do seu Chrome)][tracing]
  * [Android systrace (`adb systrace`)][systrace]
  * [Fuchsia `fx traceutil`][traceutil]
  * [Perfetto](https://ui.perfetto.dev/)
  * [speedscope](https://www.speedscope.app/)

[systrace]: {{site.android-dev}}/studio/profile/systrace
[tracing]: https://www.chromium.org/developers/how-tos/trace-event-profiling-tool
[traceutil]: https://fuchsia.dev/fuchsia-src/development/tracing/usage-guide

* Meu app Flutter parece travar ou gaguejar. Como eu conserto isso?
  * [Improving rendering performance][]

[Improving rendering performance]: /perf/rendering-performance

* Quais são algumas operações de desempenho caras com as quais
  preciso ter cuidado?
  * [`Opacity`][], [`Clip.antiAliasWithSaveLayer`][],
     ou qualquer coisa que dispare [`saveLayer`][]
  * [`ImageFilter`][]
  * Veja também [Performance best practices][]

[`Clip.antiAliasWithSaveLayer`]: {{site.api}}/flutter/dart-ui/Clip.html#antiAliasWithSaveLayer
[`ImageFilter`]: {{site.api}}/flutter/dart-ui/ImageFilter-class.html
[`Opacity`]: {{site.api}}/flutter/widgets/Opacity-class.html
[Performance best practices]: /perf/best-practices
[`savelayer`]: {{site.api}}/flutter/dart-ui/Canvas/saveLayer.html

* Como eu descubro quais widgets no meu app Flutter são reconstruídos
  em cada frame?
  * Defina [`debugProfileBuildsEnabled`][] como true em
    [widgets/debug.dart][debug.dart].
  * Alternativamente, mude a função `performRebuild` em
    [widgets/framework.dart][framework.dart] para ignorar
    `debugProfileBuildsEnabled` e sempre chamar
    `Timeline.startSync(...)/finish`.
  * Se você usa IntelliJ, uma visualização GUI desses dados está disponível.
    Selecione **Track widget rebuilds**,
    e sua IDE exibirá quais widgets são reconstruídos.

[`debugProfileBuildsEnabled`]: {{site.api}}/flutter/widgets/debugProfileBuildsEnabled.html
[debug.dart]: {{site.repo.flutter}}/blob/main/packages/flutter/lib/src/widgets/debug.dart
[framework.dart]: {{site.repo.flutter}}/blob/main/packages/flutter/lib/src/widgets/framework.dart

* Como eu consulto a taxa de frames por segundo alvo (do display)?
  * [Get the display refresh rate][]

[Get the display refresh rate]: {{site.repo.flutter}}/blob/main/engine/src/flutter/docs/Engine-specific-Service-Protocol-extensions.md#get-the-display-refresh-rate-_fluttergetdisplayrefreshrate

* Como resolver as animações ruins do meu app causadas por uma chamada
  de função async Dart cara que está bloqueando a thread da UI?
  * Crie outro isolate usando o método [`compute()`][],
    como demonstrado no cookbook [Parse JSON in the background][].

[`compute()`]: {{site.api}}/flutter/foundation/compute-constant.html
[Parse JSON in the background]: /cookbook/networking/background-parsing

* Como eu determino o tamanho do pacote do meu app Flutter que um
  usuário irá baixar?
  * Veja [Measuring your app's size][]

[Measuring your app's size]: /perf/app-size

* Como eu vejo o detalhamento do tamanho do motor Flutter?
  * Visite o [binary size dashboard][], e substitua o hash git
    na URL com um hash de commit recente dos
    [commits do GitHub do Flutter][Flutter's GitHub commits].

[binary size dashboard]: https://storage.googleapis.com/flutter_infra_release/flutter/241c87ad800beeab545ab867354d4683d5bfb6ce/android-arm-release/sizes/index.html
[Flutter's GitHub commits]: {{site.repo.flutter}}/commits/main

* Como posso tirar um screenshot de um app que está executando e exportá-lo
  como um arquivo SKP?
  * Execute `flutter screenshot --type=skia --observatory-uri=...`
  * Note um problema conhecido ao visualizar screenshots:
    * [Issue 21237][]: Não registra imagens em dispositivos reais.
  * Para analisar e visualizar o arquivo SKP,
    confira o [Skia WASM debugger][].

[Issue 21237]: {{site.repo.flutter}}/issues/21237
[Skia WASM debugger]: https://debugger.skia.org/

* Como eu recupero o cache persistente de shader de um dispositivo?
  * No Android, você pode fazer o seguinte:
    ```console
    adb shell
    run-as <com.your_app_package_name>
    cp <your_folder> <some_public_folder, e.g., /sdcard> -r
    adb pull <some_public_folder/your_folder>
    ```

* Como eu realizo um trace no Fuchsia?
  * Veja [Fuchsia tracing guidelines][traceutil]
