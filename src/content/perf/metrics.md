---
ia-translate: true
title: Métricas de desempenho
description: Métricas do Flutter e quais ferramentas e APIs são usadas para obtê-las
---

* Tempo de inicialização até o primeiro frame
  * Verifique o tempo quando
    [WidgetsBinding.instance.firstFrameRasterized][firstFrameRasterized]
    for verdadeiro.
  * Veja o
    [painel de desempenho](https://flutter-flutter-perf.skia.org/e/?queries=sub_result%3DtimeToFirstFrameRasterizedMicros).

* `buildDuration`, `rasterDuration` e `totalSpan` do frame
  * Veja [`FrameTiming`]({{site.api}}/flutter/dart-ui/FrameTiming-class.html)
    na documentação da API.

* Estatísticas do `buildDuration` do frame (`*_frame_build_time_millis`)
  * Recomendamos monitorar quatro estatísticas: média, percentil 90,
    percentil 99 e o pior tempo de construção do frame.
  * Veja, por exemplo, [métricas][transition_build] para o teste
    `flutter_gallery__transition_perf`.

* Estatísticas do `rasterDuration` do frame (`*_frame_build_time_millis`)
  * Recomendamos monitorar quatro estatísticas: média, percentil 90,
    percentil 99 e o pior tempo de construção do frame.
  * Veja, por exemplo, [métricas][transition_raster] para o teste
    `flutter_gallery__transition_perf`.

* Uso de CPU/GPU (uma boa aproximação para o uso de energia)
  * O uso está atualmente disponível apenas por meio de eventos de trace.
    Veja [profiling_summarizer.dart][profiling_summarizer].
  * Veja [métricas][cpu_gpu] para o teste `simple_animation_perf_ios`.

* `release_size_bytes` para medir aproximadamente o tamanho de um app Flutter
  * Veja os testes [basic_material_app_android][], [basic_material_app_ios][],
    [hello_world_android][], [hello_world_ios][], [flutter_gallery_android][] e
    [flutter_gallery_ios][].
  * Veja [métricas][size_perf] no painel.
  * Para obter informações sobre como medir o tamanho com mais precisão,
    veja a página [tamanho do app](/perf/app-size).

Para obter uma lista completa das métricas de desempenho que o Flutter mede por
commit, visite os seguintes sites, clique em **Query** e filtre os campos
**test** e **sub_result**:

  * [https://flutter-flutter-perf.skia.org/e/](https://flutter-flutter-perf.skia.org/e/)
  * [https://flutter-engine-perf.skia.org/e/](https://flutter-engine-perf.skia.org/e/)

[firstFrameRasterized]: {{site.api}}/flutter/widgets/WidgetsBinding/firstFrameRasterized.html

[transition_build]: https://flutter-flutter-perf.skia.org/e/?queries=sub_result%3D90th_percentile_frame_build_time_millis%26sub_result%3D99th_percentile_frame_build_time_millis%26sub_result%3Daverage_frame_build_time_millis%26sub_result%3Dworst_frame_build_time_millis%26test%3Dflutter_gallery__transition_perf

[transition_raster]: https://flutter-flutter-perf.skia.org/e/?queries=sub_result%3D90th_percentile_frame_rasterizer_time_millis%26sub_result%3D99th_percentile_frame_rasterizer_time_millis%26sub_result%3Daverage_frame_rasterizer_time_millis%26sub_result%3Dworst_frame_rasterizer_time_millis%26test%3Dflutter_gallery__transition_perf

[profiling_summarizer]: {{site.repo.flutter}}/blob/master/packages/flutter_driver/lib/src/driver/profiling_summarizer.dart

[cpu_gpu]: https://flutter-flutter-perf.skia.org/e/?queries=sub_result%3Daverage_cpu_usage%26sub_result%3Daverage_gpu_usage%26test%3Dsimple_animation_perf_ios

[basic_material_app_android]: {{site.repo.flutter}}/blob/master/dev/devicelab/bin/tasks/basic_material_app_android__compile.dart

[basic_material_app_ios]: {{site.repo.flutter}}/blob/master/dev/devicelab/bin/tasks/basic_material_app_ios__compile.dart

[hello_world_android]: {{site.repo.flutter}}/blob/master/dev/devicelab/bin/tasks/hello_world_android__compile.dart

[hello_world_ios]: {{site.repo.flutter}}/blob/master/dev/devicelab/bin/tasks/hello_world_ios__compile.dart

[flutter_gallery_android]: {{site.repo.flutter}}/blob/master/dev/devicelab/bin/tasks/flutter_gallery_android__compile.dart

[flutter_gallery_ios]: {{site.repo.flutter}}/blob/master/dev/devicelab/bin/tasks/flutter_gallery_ios__compile.dart

[size_perf]: https://flutter-flutter-perf.skia.org/e/?queries=sub_result%3Drelease_size_bytes%26test%3Dbasic_material_app_android__compile%26test%3Dbasic_material_app_ios__compile%26test%3Dhello_world_android__compile%26test%3Dhello_world_ios__compile%26test%3Dflutter_gallery_ios__compile%26test%3Dflutter_gallery_android__compile
