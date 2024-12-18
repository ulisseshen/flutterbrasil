---
ia-translate: true
title: Hospedando visualizações nativas do Android em seu aplicativo Flutter com Platform Views
short-title: Platform-views do Android
description: Aprenda como hospedar visualizações nativas do Android em seu aplicativo Flutter com Platform Views.
---

<?code-excerpt path-base="platform_integration/platform_views"?>

Platform views permitem incorporar visualizações nativas em um aplicativo Flutter,
para que você possa aplicar transformações, recortes e opacidade à visualização nativa
do Dart.

Isso permite, por exemplo, usar o
Google Maps nativo do SDK do Android
diretamente dentro do seu aplicativo Flutter.

:::note
Esta página discute como hospedar suas próprias visualizações nativas do Android
dentro de um aplicativo Flutter.
Se você quiser incorporar visualizações nativas do iOS em seu aplicativo Flutter,
consulte [Hospedando visualizações nativas do iOS][].
Se você quiser incorporar visualizações nativas do macOS em seu aplicativo Flutter,
consulte [Hospedando visualizações nativas do macOS][].
:::

[Hospedando visualizações nativas do iOS]: /platform-integration/ios/platform-views
[Hospedando visualizações nativas do macOS]: /platform-integration/macos/platform-views

As Platform Views no Android possuem duas implementações. Elas vêm com vantagens e desvantagens,
tanto em termos de desempenho quanto de fidelidade.
As Platform views exigem Android API 23+.

## [Hybrid Composition](#hybrid-composition)

As Platform Views são renderizadas como normalmente. O conteúdo do Flutter é renderizado em uma textura.
O SurfaceFlinger compõe o conteúdo do Flutter e as Platform views.

* `+` melhor desempenho e fidelidade das visualizações do Android.
* `-` O desempenho do Flutter é prejudicado.
* `-` O FPS do aplicativo será menor.
* `-` Certas transformações que podem ser aplicadas aos widgets do Flutter não funcionarão quando aplicadas às platform views.

## [Texture Layer](#texturelayerhybridcomposition) (ou Texture Layer Hybrid Composition)

As Platform Views são renderizadas em uma textura.
O Flutter desenha as platform views (via textura).
O conteúdo do Flutter é renderizado diretamente em uma Surface.

* `+` bom desempenho para visualizações do Android
* `+` melhor desempenho para renderização do Flutter.
* `+` todas as transformações funcionam corretamente.
* `-` a rolagem rápida (por exemplo, uma visualização da web) será instável
* `-` SurfaceViews são problemáticos neste modo e serão movidos para uma exibição virtual (quebrando o a11y)
* `-` A lupa de texto será quebrada, a menos que o Flutter seja renderizado em uma TextureView.

Para criar uma platform view no Android,
siga estas etapas:

## No lado do Dart

No lado do Dart, crie um `Widget`
e adicione uma das seguintes implementações de build.

### Hybrid composition

Em seu arquivo Dart,
por exemplo, `native_view_example.dart`,
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
     // Isso é usado no lado da plataforma para registrar a visualização.
     const String viewType = '<platform-view-type>';
     // Passe os parâmetros para o lado da plataforma.
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

Para obter mais informações, consulte a documentação da API para:

* [`PlatformViewLink`][]
* [`AndroidViewSurface`][]
* [`PlatformViewsService`][]

[`AndroidViewSurface`]: {{site.api}}/flutter/widgets/AndroidViewSurface-class.html
[`PlatformViewLink`]: {{site.api}}/flutter/widgets/PlatformViewLink-class.html
[`PlatformViewsService`]: {{site.api}}/flutter/services/PlatformViewsService-class.html

### TextureLayerHybridComposition

Em seu arquivo Dart,
por exemplo, `native_view_example.dart`,
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
     // Isso é usado no lado da plataforma para registrar a visualização.
     const String viewType = '<platform-view-type>';
     // Passe os parâmetros para o lado da plataforma.
     final Map<String, dynamic> creationParams = <String, dynamic>{};
   
     return AndroidView(
       viewType: viewType,
       layoutDirection: TextDirection.ltr,
       creationParams: creationParams,
       creationParamsCodec: const StandardMessageCodec(),
     );
   }
   ```

Para obter mais informações, consulte a documentação da API para:

* [`AndroidView`][]

[`AndroidView`]: {{site.api}}/flutter/widgets/AndroidView-class.html

## No lado da plataforma

No lado da plataforma, use o padrão
pacote `io.flutter.plugin.platform`
em Kotlin ou Java:

{% tabs "android-language" %}
{% tab "Kotlin" %}

Em seu código nativo, implemente o seguinte:

Estenda `io.flutter.plugin.platform.PlatformView`
para fornecer uma referência ao `android.view.View`
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
        textView.text = "Renderizado em uma visualização nativa do Android (id: $id)"
    }
}
```

Crie uma classe de fábrica que cria uma instância do
`NativeView` criado anteriormente
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
Você pode fazer isso em um aplicativo ou um plugin.

Para registro de aplicativo,
modifique a atividade principal do aplicativo
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

{% endtab %}
{% tab "Java" %}

Em seu código nativo, implemente o seguinte:

Estenda `io.flutter.plugin.platform.PlatformView`
para fornecer uma referência ao `android.view.View`
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
        textView.setText("Renderizado em uma visualização nativa do Android (id: " + id + ")");
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

Crie uma classe de fábrica que cria um
instância do `NativeView` criado anteriormente
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
Você pode fazer isso em um aplicativo ou um plugin.

Para registro de aplicativo,
modifique a atividade principal do aplicativo
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

{% endtab %}
{% endtabs %}

Para obter mais informações, consulte a documentação da API para:

* [`FlutterPlugin`][]
* [`PlatformViewRegistry`][]
* [`PlatformViewFactory`][]
* [`PlatformView`][]

[`FlutterPlugin`]: {{site.api}}/javadoc/io/flutter/embedding/engine/plugins/FlutterPlugin.html
[`PlatformView`]: {{site.api}}/javadoc/io/flutter/plugin/platform/PlatformView.html
[`PlatformViewFactory`]: {{site.api}}/javadoc/io/flutter/plugin/platform/PlatformViewFactory.html
[`PlatformViewRegistry`]: {{site.api}}/javadoc/io/flutter/plugin/platform/PlatformViewRegistry.html

Finalmente, modifique seu arquivo `build.gradle`
para exigir uma das versões mínimas do SDK do Android:

```kotlin
android {
    defaultConfig {
        minSdk = 19 // se estiver usando a hybrid composition
        minSdk = 20 // se estiver usando a exibição virtual.
    }
}
```
### Surface Views

O tratamento de SurfaceViews é problemático para o Flutter e deve ser evitado sempre que possível.

### Invalidação manual da view

Certas Views do Android não se invalidam quando seu conteúdo é alterado.
Algumas views de exemplo incluem `SurfaceView` e `SurfaceTexture`.
Quando sua Platform View inclui essas views, você é obrigado a
invalidar manualmente a view depois que elas foram desenhadas para
(ou mais especificamente: depois que a cadeia de troca é invertida).
A invalidação manual da view é feita chamando `invalidate` na View
ou uma de suas views pai.

[`AndroidViewSurface`]: {{site.api}}/flutter/widgets/AndroidViewSurface-class.html

### Problemas

[Problemas existentes da Platform View](https://github.com/flutter/flutter/issues?q=is%3Aopen+is%3Aissue+label%3A%22a%3A+platform-views%22)

{% include docs/platform-view-perf.md %}
