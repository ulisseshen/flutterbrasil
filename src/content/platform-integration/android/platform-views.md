---
ia-translate: true
title: Hospedando views Android nativas em seu app Flutter com Platform Views
shortTitle: Platform-views Android
description: Aprenda como hospedar views Android nativas em seu app Flutter com Platform Views.
---

<?code-excerpt path-base="platform_integration/platform_views"?>

Platform views permitem que você incorpore views nativas em um app Flutter,
para que você possa aplicar transformações, recortes e opacidade à view nativa
do Dart.

Isso permite que você, por exemplo, use o
Google Maps nativo do Android SDK
diretamente dentro do seu app Flutter.

:::note
Esta página discute como hospedar suas próprias views Android nativas
dentro de um app Flutter.
Se você gostaria de incorporar views iOS nativas em seu app Flutter,
veja [Hospedando views iOS nativas][Hosting native iOS views].
Se você gostaria de incorporar views macOS nativas em seu app Flutter,
veja [Hospedando views macOS nativas][Hosting native macOS views].
:::

[Hosting native iOS views]: /platform-integration/ios/platform-views
[Hosting native macOS views]: /platform-integration/macos/platform-views

Platform Views no Android têm duas implementações. Elas vêm com trade-offs
tanto em termos de performance quanto de fidelidade.
Platform views requerem Android API 23+.

## [Hybrid Composition](#hybrid-composition)

Platform Views são renderizadas como normalmente são. O conteúdo Flutter é renderizado em uma textura.
SurfaceFlinger compõe o conteúdo Flutter e as platform views.

* `+` melhor performance e fidelidade de views Android.
* `-` A performance do Flutter sofre.
* `-` FPS da aplicação será menor.
* `-` Certas transformações que podem ser aplicadas a widgets Flutter não funcionarão quando aplicadas a platform views.

## [Texture Layer](#texturelayerhybridcomposition) (ou Texture Layer Hybrid Composition)

Platform Views são renderizadas em uma textura.
Flutter desenha as platform views (via a textura).
O conteúdo Flutter é renderizado diretamente em uma Surface.

* `+` boa performance para Android Views
* `+` melhor performance para renderização Flutter.
* `+` todas as transformações funcionam corretamente.
* `-` rolagem rápida (ex.: uma web view) será instável
* `-` SurfaceViews são problemáticas neste modo e serão movidas para um display virtual (quebrando a11y)
* `-` A lupa de texto quebrará a menos que o Flutter seja renderizado em uma TextureView.

Para criar uma platform view no Android,
use os seguintes passos:

## Do lado do Dart

Do lado do Dart, crie um `Widget`
e adicione uma das seguintes implementações de build.

### Hybrid composition

Em seu arquivo Dart,
por exemplo `native_view_example.dart`,
use as seguintes instruções:

1. Adicione as seguintes importações:

   <?code-excerpt "lib/native_view_example_1.dart (import)"?>
   ```dart
   import 'package:flutter/foundation.dart';
   import 'package:flutter/gestures.dart';
   import 'package:flutter/material.dart';
   import 'package:flutter/rendering.dart';
   import 'package:flutter/services.dart';
   ```

2. Implemente um método `build()`:

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

Para mais informações, veja a documentação da API para:

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
   import 'package:flutter/material.dart';
   import 'package:flutter/services.dart';
   ```

2. Implemente um método `build()`:

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

Para mais informações, veja a documentação da API para:

* [`AndroidView`][AndroidView]

[AndroidView]: {{site.api}}/flutter/widgets/AndroidView-class.html

## Do lado da plataforma

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

Para registro de app,
modifique a activity principal do app
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

Para mais informações, veja a documentação da API para:

* [`FlutterPlugin`][FlutterPlugin]
* [`PlatformViewRegistry`][PlatformViewRegistry]
* [`PlatformViewFactory`][PlatformViewFactory]
* [`PlatformView`][PlatformView]

[FlutterPlugin]: {{site.api}}/javadoc/io/flutter/embedding/engine/plugins/FlutterPlugin.html
[PlatformView]: {{site.api}}/javadoc/io/flutter/plugin/platform/PlatformView.html
[PlatformViewFactory]: {{site.api}}/javadoc/io/flutter/plugin/platform/PlatformViewFactory.html
[PlatformViewRegistry]: {{site.api}}/javadoc/io/flutter/plugin/platform/PlatformViewRegistry.html

Finalmente, modifique seu arquivo `build.gradle`
para requerer uma das versões mínimas do Android SDK:

```kotlin
android {
    defaultConfig {
        minSdk = 19 // if using hybrid composition
        minSdk = 20 // if using virtual display.
    }
}
```
### Surface Views

Lidar com SurfaceViews é problemático para o Flutter e deve ser evitado quando possível.

### Invalidação manual de view

Certas Android Views não se invalidam quando seu conteúdo muda.
Alguns exemplos de views incluem `SurfaceView` e `SurfaceTexture`.
Quando sua Platform View incluir essas views, você é obrigado a
invalidar manualmente a view depois que elas foram desenhadas
(ou mais especificamente: depois que a swap chain for invertida).
A invalidação manual de view é feita chamando `invalidate` na View
ou em uma de suas views pai.

[AndroidViewSurface]: {{site.api}}/flutter/widgets/AndroidViewSurface-class.html

### Issues

[Existing Platform View issues](https://github.com/flutter/flutter/issues?q=is%3Aopen+is%3Aissue+label%3A%22a%3A+platform-views%22)

{% render "docs/platform-view-perf.md", site: site %}
