---
title: Novas APIs para plugins Android que renderizam em uma Surface
description: >-
  Adiciona uma nova API, SurfaceProducer, à API de incorporação Android, que
  gerencia de forma opaca a criação e o gerenciamento de uma `Surface` para plugins.
  Para Impeller, é recomendado o uso desta API.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

O embedder Android para Flutter introduz uma nova API, [`SurfaceProducer`][],
que permite que plugins renderizem em uma `Surface` sem precisar gerenciar qual
é a implementação subjacente. Plugins que usam a API [`createSurfaceTexture`][]
mais antiga continuarão a funcionar com [Impeller][] após o
_próximo_ lançamento estável, mas é recomendado migrar para a nova API.

## Background

Um [`SurfaceTexture`][] Android é uma implementação subjacente para uma [`Surface`][]
que usa uma textura [OpenGLES][] como armazenamento de apoio.

Por exemplo, um plugin pode exibir frames de um plugin de _camera_:

![Flowchart](https://camo.githubusercontent.com/cdb52c5d371b4f1d5573b650a0eddb0871e5e8be1012d290e008f41bc71b2580/68747470733a2f2f736f757263652e616e64726f69642e636f6d2f7374617469632f646f63732f636f72652f67726170686963732f696d616765732f636f6e74696e756f75735f636170747572655f61637469766974792e706e67)

Em versões mais recentes da API Android (>= 29), o Android introduziu um
[`HardwareBuffer`][] agnóstico de backend, que coincide com a versão mínima
em que o Flutter tentará usar o renderizador [Vulkan][]. A API de incorporação
Android precisava ser atualizada para suportar uma API de criação de `Surface`
mais genérica que não depende de OpenGLES.

## Migration guide

Se você está usando a API [`createSurfaceTexture`][] mais antiga, você deve migrar para
a nova API [`createSurfaceProducer`][]. A nova API é mais flexível e permite que
o engine Flutter escolha de forma opaca a melhor implementação para a
plataforma e nível de API atuais.

1. Em vez de criar um `SurfaceTextureEntry`, crie um `SurfaceProducer`:

   ```java diff
   - TextureRegistry.SurfaceTextureEntry entry = textureRegistry.createSurfaceTexture();
   + TextureRegistry.SurfaceProducer producer = textureRegistry.createSurfaceProducer();
   ```

1. Em vez de criar um `new Surface(...)`, chame [`getSurface()`][] no
   `SurfaceProducer`:

   ```java diff
   - Surface surface = new Surface(entry.surfaceTexture());
   + Surface surface = producer.getSurface();
   ```

Para conservar memória quando a aplicação está suspensa em segundo plano,
Android e Flutter _podem_ destruir uma surface quando ela não está mais visível. Para
garantir que a surface seja recriada quando a aplicação for retomada, você deve
usar o método [`setCallback`][] fornecido para escutar eventos do ciclo de vida da surface:

```java
surfaceProducer.setCallback(
   new TextureRegistry.SurfaceProducer.Callback() {
      @Override
      public void onSurfaceAvailable() {
         // Do surface initialization here, and draw the current frame.
      }

      @Override
      public void onSurfaceDestroyed() {
         // Do surface cleanup here, and stop drawing frames.
      }
   }
);
```

Um exemplo completo de uso desta nova API pode ser encontrado na [PR 6989][] para o
plugin `video_player_android`.

:::note
Em versões iniciais desta API, o callback era chamado `onSurfaceCreated`, e
era invocado mesmo se a surface original não fosse destruída. Isso foi corrigido
na versão mais recente (pendente 3.27) da API.
:::

## Note on camera previews

Se o seu plugin implementa uma visualização de câmera, sua migração também pode exigir
corrigir a rotação dessa visualização. Isso ocorre porque `Surface`s produzidas pelo
`SurfaceProducer` podem não conter as informações de transformação que as
bibliotecas Android precisam para rotacionar corretamente a visualização automaticamente.

Para corrigir a rotação, você precisa rotacionar a visualização com
relação à orientação do sensor da câmera e à orientação do dispositivo de acordo
com a equação:

```plaintext
rotation = (sensorOrientationDegrees - deviceOrientationDegrees * sign + 360) % 360
```

onde `deviceOrientationDegrees` são graus no sentido anti-horário e `sign` é 1 para
câmeras frontais e -1 para câmeras traseiras.

Para calcular esta rotação,

- Use [`SurfaceProducer.handlesCropAndRotation`][] para verificar se a
  `Surface` subjacente lida com rotação (se `false`, você pode precisar lidar com a rotação).
- Recupere os graus de orientação do sensor recuperando o valor de
  [`CameraCharacteristics.SENSOR_ORIENTATION`][].
- Recupere os graus de orientação do dispositivo de uma das maneiras que a
  [documentação de cálculo de orientação do Android][Android orientation calculation documentation] detalha.

Para aplicar esta rotação, você pode usar um widget [`RotatedBox`][].

Para mais informações sobre este cálculo, confira a
[documentação de cálculo de orientação do Android][Android orientation calculation documentation]. Para um exemplo completo de como fazer
esta correção, confira [este PR do `camera_android_camerax`][this `camera_android_camerax` PR].

## Timeline

Landed in version: 3.22

:::note
Este recurso foi adicionado na versão _anterior_ do SDK mas não era funcional;
plugins que migram para esta API devem definir `3.24` como uma restrição de versão mínima.
:::

In stable release: 3.24

No próximo lançamento estável, 3.27, `onSurfaceCreated` está obsoleto, e
`onSurfaceAvailable` e `handlesCropAndRotation` são adicionados.

## References

API documentation:

- [`SurfaceProducer`][]
- [`createSurfaceProducer`][]
- [`createSurfaceTexture`][]

Relevant issues:

- [Issue 139702][]
- [Issue 145930][]

Relevant PRs:

- [PR 51061][], onde testamos a nova API nos testes do engine.
- [PR 6456][], onde migramos o plugin `video_player` para usar a nova API.
- [PR 6461][], onde migramos o plugin `camera_android` para usar a nova API.
- [PR 6989][], onde adicionamos um exemplo completo de uso da nova API no plugin `video_player_android`.

[Impeller]: /perf/impeller
[OpenGLES]: https://www.khronos.org/opengles/
[Vulkan]: https://source.android.com/docs/core/graphics/arch-vulkan
[`HardwareBuffer`]: https://developer.android.com/reference/android/hardware/HardwareBuffer
[`Surface`]: https://developer.android.com/reference/android/view/Surface
[`SurfaceProducer`]: {{site.api}}/javadoc/io/flutter/view/TextureRegistry.SurfaceProducer.html
[`SurfaceProducer.handlesCropAndRotation`]: {{site.api}}/javadoc/io/flutter/view/TextureRegistry.SurfaceProducer.html#handlesCropAndRotation()
[`SurfaceTexture`]: https://source.android.com/docs/core/graphics/arch-st
[`createSurfaceProducer`]: {{site.api}}/javadoc/io/flutter/view/TextureRegistry.html#createSurfaceProducer()
[`createSurfaceTexture`]: {{site.api}}/javadoc/io/flutter/view/TextureRegistry.html#createSurfaceTexture()
[`getSurface()`]: {{site.api}}/javadoc/io/flutter/view/TextureRegistry.SurfaceProducer.html#getSurface()
[`setCallback`]: {{site.api}}/javadoc/io/flutter/view/TextureRegistry.SurfaceProducer.html#setCallback(io.flutter.view.TextureRegistry.SurfaceProducer.Callback)
[`CameraCharacteristics.SENSOR_ORIENTATION`]: {{site.android-dev}}/reference/android/hardware/camera2/CameraCharacteristics#SENSOR_ORIENTATION
[`RotatedBox`]: {{site.api}}/flutter/widgets/RotatedBox-class.html
[Android orientation calculation documentation]: {{site.android-dev}}/media/camera/camera2/camera-preview#orientation_calculation
[this `camera_android_camerax` PR]: {{site.repo.packages}}/pull/7044
[Issue 139702]: {{site.repo.flutter}}/issues/139702
[Issue 145930]: {{site.repo.flutter}}/issues/145930
[PR 51061]: {{site.repo.engine}}/pull/51061
[PR 6456]: {{site.repo.packages}}/pull/6456
[PR 6461]: {{site.repo.packages}}/pull/6461
[PR 6989]: {{site.repo.packages}}/pull/6989
