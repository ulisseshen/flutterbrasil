---
ia-translate: true
title: Hospedando views Android nativas em seu app Flutter com Platform Views
shortTitle: Platform-views Android
description: >-
  Aprenda como hospedar views Android nativas em seu
  app Flutter com Platform Views.
---

<?code-excerpt path-base="platform_integration/platform_views"?>

Platform views permitem que você incorpore views nativas em um app Flutter,
para que você possa aplicar transformações, recortes e opacidade à view nativa
do Dart.

Isso permite que você, por exemplo,
use o Google Maps nativo do Android SDK
diretamente dentro do seu app Flutter.

:::note
Esta página discute como hospedar suas próprias views Android nativas
dentro de um app Flutter.
Se você gostaria de incorporar views iOS nativas em seu app Flutter,
visite [Hospedando views iOS nativas][Hosting native iOS views].
Para incorporar views macOS nativas em seu app Flutter,
visite [Hospedando views macOS nativas][Hosting native macOS views].
:::

[Hosting native iOS views]: /platform-integration/ios/platform-views
[Hosting native macOS views]: /platform-integration/macos/platform-views

Platform Views no Android têm várias implementações.
Elas vêm com trade-offs tanto em termos de performance quanto de fidelidade.

### Escolhendo uma implementação {:#choosing-an-implementation}

A matriz a seguir resume as diferentes implementações e seus trade-offs:

| Modo | Benefícios | Considerações | Habilitador |
| :--- | :--- | :--- | :--- |
| **Texture layer** | • Boa performance do Flutter<br>• Todas as transformações de widgets funcionam | • Instável durante rolagem rápida<br>• SurfaceViews perdem acessibilidade e a lupa de texto quebra<br>• Platform View -> Renderiza em textura -> Envia para o Impeller -> O Impeller compõe o conteúdo Flutter e o conteúdo da Platform View | Comportamento padrão ou `AndroidView` padrão |
| **Hybrid composition** | • Fidelidade nativa total<br>• Suporte correto a acessibilidade e SurfaceView | • Causa a fusão das threads de raster e de plataforma, o que degrada o FPS do Flutter<br>• Platform View -> Renderiza na hierarquia de views Android normalmente, o conteúdo Flutter é renderizado em `FlutterImageView`s baseadas em `ImageReader` (uma camada de fundo, mais uma camada de sobreposição para conteúdo desenhado acima de uma platform view), e a hierarquia de views Android as compõe juntas |• `PlatformViewLink` com `AndroidViewSurface`<br>• [`AndroidViewController` constrói uma Platform View TLHC ou HC][AC] |
| **HCPP** (Experimental) | • Fidelidade e performance totais<br>• Resolve o overhead de sincronização original | • Requer Android API 34+, suporte a Vulkan e uso do motor de renderização Impeller<br>• Platform View -> Renderiza em uma Surface nativa do Android, o Impeller renderiza em uma Surface nativa do Android, e o SurfaceFlinger compõe as duas juntas | • `<meta-data>` no `AndroidManifest.xml`<br>• Flag local `--enable-hcpp`<br> •[`AndroidViewController` constrói uma Platform View TLHC ou HC][AC] |

{:.table .table-striped}

[AC]: {{site.repo.flutter}}/blob/main/dev/integration_tests/hybrid_android_views/lib/android_platform_view.dart

## Hybrid composition {: #hybrid-composition }

Platform views são renderizadas como normalmente são,
diretamente na hierarquia de views Android.
O conteúdo Flutter é renderizado em `ImageReader`s e pintado por
`FlutterImageView`s que ficam na mesma janela que as platform views,
de modo que a hierarquia de views Android os compõe juntos.

O Flutter usa dois tipos dessas camadas.
A superfície de renderização principal do Flutter é trocada por uma
`FlutterImageView` de fundo assim que uma platform view é adicionada.
O conteúdo Flutter que é desenhado sobre uma platform view
vai para uma `FlutterImageView` de sobreposição adicional,
alocada a partir de um pool e reciclada entre frames.

## Hybrid composition++ (HCPP) {: #hcpp }

:::version-note
Este recurso é experimental e está disponível a partir do Flutter 3.44.
:::

HCPP é a estratégia de hybrid composition mais recente,
projetada para resolver problemas de performance de composição e de sincronização
vistos no modo Hybrid Composition original.
Atualmente, ele está disponível como um recurso opcional (opt-in).

### Requisitos {:#requirements}

* **Android API 34 ou superior**: Necessário para os recursos nativos de
  sincronização de transações.
* **Impeller com o backend Vulkan**: O dispositivo deve ser capaz de
  renderizar com Vulkan. O Impeller também tem um backend OpenGLES e
  recorre a ele em dispositivos sem suporte utilizável a Vulkan.
  O HCPP não está disponível nessa configuração.

Se esses requisitos não forem atendidos no dispositivo do usuário final,
o Flutter recorrerá automaticamente à estratégia de platform view existente
configurada para o app.

### Habilitando {:#opt-in}

Como o HCPP atua como uma atualização global na forma como as platform views são suportadas,
ele é habilitado por meio de configuração, e não pelos
métodos padrão de inicialização do Dart (`initAndroidView` e assim por diante).

Você pode habilitar o HCPP usando um dos seguintes métodos:

1.  **Flag de linha de comando (run/test)**:
    Passe a flag `--enable-hcpp` para seu
    comando `flutter run` ou `flutter test`:

    ```console
    $ flutter run --enable-hcpp
    ```

    :::note
    Esta flag é destinada à execução e aos testes locais.
    **Ela não pode ser passada para os comandos `flutter build`.**
    Para builds de release, use a configuração no manifest
    conforme mostrado no próximo passo.
    :::

2.  **AndroidManifest.xml**:
    Inclua uma tag `<meta-data>` dentro do
    bloco `<application>` do seu `AndroidManifest.xml`:

    ```xml
    <meta-data
        android:name="io.flutter.embedding.android.EnableHcpp"
        android:value="true" />
    ```

### Limitações e problemas conhecidos {:#limitations-and-known-issues}

* **Empilhamento complexo de sobreposições**:
  Platform views transparentes não serão exibidas corretamente
  em pilhas de layout estruturadas como:
  **Flutter canvas -> Platform View -> Overlay -> Transparent Platform View**,
  quando todas essas quatro camadas se interceptam.

## Texture layer {: #texture-layer }

Platform Views são renderizadas em uma textura.
Flutter desenha as platform views (usando a textura).
O conteúdo Flutter é renderizado diretamente em uma Surface.

Esta abordagem oferece:

* boa performance para Android Views
* boa performance para renderização Flutter
* todas as transformações funcionam corretamente

No entanto, esta abordagem pode causar:

* instabilidade em rolagem rápida (como em uma web view)
* acessibilidade quebrada para `SurfaceView`s
* lupa de texto quebrada, a menos que o Flutter seja renderizado
  em uma `TextureView`

## Do lado do Dart {:#on-the-dart-side}

Para criar uma platform view no Android, use os passos a seguir.
Primeiro, do lado do Dart, crie um `Widget` e adicione uma das
seguintes implementações de build, dependendo da estratégia escolhida.

### Hybrid composition

Em seu arquivo Dart,
por exemplo `native_view_example.dart`,
use as seguintes instruções:

1. Adicione as seguintes importações:

   <?code-excerpt "lib/native_view_example_1.dart (import)"?>
   ```dart
   import 'package:flutter/foundation.dart';
   import 'package:flutter/gestures.dart';
   import 'package:flutter/rendering.dart';
   import 'package:flutter/services.dart';
   import 'package:material_ui/material_ui.dart';
   ```

2. Implemente um método `build`:

   <?code-excerpt "lib/native_view_example_1.dart (hybrid-composition)"?>
   ```dart
   Widget build(BuildContext context) {
     // This is used in the platform side to register the view.
     const String viewType = '<platform-view-type>';
     // Pass parameters to the platform side.
     const Map<String, dynamic> creationParams = <String, dynamic>{};
   
     return PlatformViewLink(
       viewType: viewType,
       surfaceFactory: (context, controller) {
         return AndroidViewSurface(
           controller: controller as AndroidViewController,
           gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
           hitTestBehavior: PlatformViewHitTestBehavior.opaque,
         );
       },
       onCreatePlatformView: (params) {
         return PlatformViewsService.initSurfaceAndroidView(
             id: params.id,
             viewType: viewType,
             layoutDirection: TextDirection.ltr,
             creationParams: creationParams,
             creationParamsCodec: const StandardMessageCodec(),
             onFocus: () {
               params.onFocusChanged(true);
             },
           )
           ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
           ..create();
       },
     );
   }
   ```

Para mais informações, visite a documentação da API a seguir:

* [`PlatformViewLink`][PlatformViewLink]
* [`AndroidViewSurface`][AndroidViewSurface]
* [`PlatformViewsService`][PlatformViewsService]

[AndroidViewSurface]: {{site.api}}/flutter/widgets/AndroidViewSurface-class.html
[PlatformViewLink]: {{site.api}}/flutter/widgets/PlatformViewLink-class.html
[PlatformViewsService]: {{site.api}}/flutter/services/PlatformViewsService-class.html

### TextureLayerHybridComposition

Em seu arquivo Dart,
por exemplo `native_view_example.dart`,
use as seguintes instruções:

1. Adicione as seguintes importações:

   <?code-excerpt "lib/native_view_example_2.dart (import)"?>
   ```dart
   import 'package:flutter/services.dart';
   import 'package:material_ui/material_ui.dart';
   ```

2. Implemente um método `build`:

   <?code-excerpt "lib/native_view_example_2.dart (virtual-display)"?>
   ```dart
   Widget build(BuildContext context) {
     // This is used in the platform side to register the view.
     const String viewType = '<platform-view-type>';
     // Pass parameters to the platform side.
     final Map<String, dynamic> creationParams = <String, dynamic>{};
   
     return AndroidView(
       viewType: viewType,
       layoutDirection: TextDirection.ltr,
       creationParams: creationParams,
       creationParamsCodec: const StandardMessageCodec(),
     );
   }
   ```

Para mais informações, visite a página da API de [`AndroidView`][AndroidView].

[AndroidView]: {{site.api}}/flutter/widgets/AndroidView-class.html

## Do lado da plataforma {:#on-the-platform-side}

Do lado da plataforma, use o pacote padrão
`io.flutter.plugin.platform`
em Kotlin ou Java:

<Tabs key="android-language">
<Tab name="Kotlin">

Em seu código nativo, implemente o seguinte:

Estenda `io.flutter.plugin.platform.PlatformView`
para fornecer uma referência à `android.view.View`
(por exemplo, `NativeView.kt`):

```kotlin
package dev.flutter.example

import android.content.Context
import android.graphics.Color
import android.view.View
import android.widget.TextView
import io.flutter.plugin.platform.PlatformView

internal class NativeView(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
    private val textView: TextView

    override fun getView(): View {
        return textView
    }

    override fun dispose() {}

    init {
        textView = TextView(context)
        textView.textSize = 72f
        textView.setBackgroundColor(Color.rgb(255, 255, 255))
        textView.text = "Rendered on a native Android view (id: $id)"
    }
}
```

Crie uma classe factory que cria uma instância da
`NativeView` criada anteriormente
(por exemplo, `NativeViewFactory.kt`):

```kotlin
package dev.flutter.example

import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NativeViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        return NativeView(context, viewId, creationParams)
    }
}
```

Finalmente, registre a platform view.
Você pode fazer isso em um app ou em um plugin.

Para registro de app,
modifique a activity principal do app
(por exemplo, `MainActivity.kt`):

```kotlin
package dev.flutter.example

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine
                .platformViewsController
                .registry
                .registerViewFactory("<platform-view-type>",
                                      NativeViewFactory())
    }
}
```

Para registro de plugin,
modifique a classe principal do plugin
(por exemplo, `PlatformViewPlugin.kt`):

```kotlin
package dev.flutter.plugin.example

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding

class PlatformViewPlugin : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        binding
                .platformViewRegistry
                .registerViewFactory("<platform-view-type>", NativeViewFactory())
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {}
}
```

</Tab>
<Tab name="Java">

Em seu código nativo, implemente o seguinte:

Estenda `io.flutter.plugin.platform.PlatformView`
para fornecer uma referência à `android.view.View`
(por exemplo, `NativeView.java`):

```java
package dev.flutter.example;

import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.platform.PlatformView;
import java.util.Map;

class NativeView implements PlatformView {
   @NonNull private final TextView textView;

    NativeView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams) {
        textView = new TextView(context);
        textView.setTextSize(72);
        textView.setBackgroundColor(Color.rgb(255, 255, 255));
        textView.setText("Rendered on a native Android view (id: " + id + ")");
    }

    @NonNull
    @Override
    public View getView() {
        return textView;
    }

    @Override
    public void dispose() {}
}
```

Crie uma classe factory que cria uma
instância da `NativeView` criada anteriormente
(por exemplo, `NativeViewFactory.java`):

```java
package dev.flutter.example;

import android.content.Context;
import androidx.annotation.Nullable;
import androidx.annotation.NonNull;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import java.util.Map;

class NativeViewFactory extends PlatformViewFactory {

  NativeViewFactory() {
    super(StandardMessageCodec.INSTANCE);
  }

  @NonNull
  @Override
  public PlatformView create(@NonNull Context context, int id, @Nullable Object args) {
    final Map<String, Object> creationParams = (Map<String, Object>) args;
    return new NativeView(context, id, creationParams);
  }
}
```

Finalmente, registre a platform view.
Você pode fazer isso em um app ou em um plugin.

Para registro de app, modifique a activity principal do app
(por exemplo, `MainActivity.java`):

```java
package dev.flutter.example;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        flutterEngine
            .getPlatformViewsController()
            .getRegistry()
            .registerViewFactory("<platform-view-type>", new NativeViewFactory());
    }
}
```

Para registro de plugin,
modifique o arquivo principal do plugin
(por exemplo, `PlatformViewPlugin.java`):

```java
package dev.flutter.plugin.example;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

public class PlatformViewPlugin implements FlutterPlugin {
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    binding
        .getPlatformViewRegistry()
        .registerViewFactory("<platform-view-type>", new NativeViewFactory());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {}
}
```

</Tab>
</Tabs>

Para mais informações, visite a documentação da API para:

* [`FlutterPlugin`][FlutterPlugin]
* [`PlatformViewRegistry`][PlatformViewRegistry]
* [`PlatformViewFactory`][PlatformViewFactory]
* [`PlatformView`][PlatformView]

[FlutterPlugin]: {{site.api}}/javadoc/io/flutter/embedding/engine/plugins/FlutterPlugin.html
[PlatformView]: {{site.api}}/javadoc/io/flutter/plugin/platform/PlatformView.html
[PlatformViewFactory]: {{site.api}}/javadoc/io/flutter/plugin/platform/PlatformViewFactory.html
[PlatformViewRegistry]: {{site.api}}/javadoc/io/flutter/plugin/platform/PlatformViewRegistry.html

### Invalidação manual de view {:#manual-view-invalidation}

Certas Android Views não se invalidam quando seu conteúdo muda.
Alguns exemplos incluem `SurfaceView` e `SurfaceTexture`.
Quando sua Platform View incluir essas views,
você deve invalidá-la manualmente depois que ela for desenhada
(ou, mais especificamente, depois que a swap chain for invertida).
Invalide a view chamando `invalidate` nela ou em uma de suas views pai.

[AndroidViewSurface]: {{site.api}}/flutter/widgets/AndroidViewSurface-class.html

### Issues

Confira as [issues existentes de Platform View][existing Platform View issues] no GitHub.

[existing Platform View issues]: {{site.repo.flutter}}/issues?q=is%3Aopen+is%3Aissue+label%3A%22a%3A+platform-views

## Performance

Platform views no Flutter vêm com trade-offs de performance.

Em um app Flutter típico,
o Flutter rasteriza os frames em uma thread de raster dedicada,
enquanto o código de plataforma, como plugins e views Android,
é executado na thread de plataforma, que é a thread principal do Android.
Essa separação mantém a renderização do Flutter rápida e fluida,
já que a thread de plataforma não é bloqueada pelo trabalho de rasterização.

No entanto, quando uma platform view é renderizada no Android usando
hybrid composition,
o Flutter mescla a thread de raster na thread de plataforma
para garantir a sincronização correta entre
as views Android nativas e o canvas do Flutter.
Por causa dessa fusão de threads,
rasterizar widgets Flutter complexos junto com uma platform view
compete com outros trabalhos na thread de plataforma,
como mensagens do sistema operacional e interações com plugins,
podendo causar um FPS menor na aplicação e perda de frames.

Além disso, antes do Android 10, a hybrid composition copiava cada frame do Flutter
da memória gráfica para a memória principal
e depois o copiava de volta para uma textura da GPU. Como essa cópia acontece a cada frame,
a performance de toda a UI do Flutter pode ser impactada.
No Android 10 ou superior, a memória gráfica é copiada apenas uma vez.

A Hybrid Composition++ (HCPP) minimiza esse overhead usando a
sincronização nativa de transações em dispositivos suportados (Android API 34+ com Vulkan),
permitindo uma performance superior sem os altos custos da hybrid
composition original.

O virtual display, por outro lado, faz cada pixel da view nativa passar
por buffers gráficos intermediários adicionais,
o que custa memória gráfica e performance de desenho.
Isso pode causar instabilidade (jank) durante atualizações de alta frequência, como rolagem rápida.

Para casos complexos, existem algumas técnicas que
podem ser usadas para mitigar esses problemas.

Por exemplo, você pode usar uma textura placeholder
enquanto uma animação está acontecendo no Dart.
Em outras palavras, se uma animação estiver lenta enquanto uma
platform view é renderizada,
considere tirar uma captura de tela da
view nativa e renderizá-la como uma textura.

Para mais informações, visite as seguintes páginas da API:


* [`TextureLayer`][]
* [`TextureRegistry`][]
* [`FlutterTextureRegistry`][]
* [`FlutterImageView`][]

[`FlutterImageView`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterImageView.html
[`FlutterTextureRegistry`]: {{site.api}}/ios-embedder/protocol_flutter_texture_registry-p.html
[`TextureLayer`]: {{site.api}}/flutter/rendering/TextureLayer-class.html
[`TextureRegistry`]: {{site.api}}/javadoc/io/flutter/view/TextureRegistry.html
