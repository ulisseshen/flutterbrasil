---
ia-translate: true
title: Hospede views nativas do iOS em seu aplicativo Flutter com platform views
short-title: Platform views do iOS
description: >-
  Aprenda como hospedar views nativas do iOS em seu aplicativo Flutter com
  platform views.
---

<?code-excerpt path-base="platform_integration/platform_views"?>

Platform views permitem que você incorpore views nativas em um aplicativo
Flutter, para que você possa aplicar transformações, recortes e opacidade à
view nativa a partir do Dart.

Isso permite que você, por exemplo, use o Google Maps nativo dos SDKs do
Android e iOS diretamente dentro do seu aplicativo Flutter.

:::note
Esta página discute como hospedar suas próprias views nativas do iOS em um
aplicativo Flutter. Se você quiser incorporar views nativas do Android em
seu aplicativo Flutter, consulte [Hospedando views nativas do Android][].
Se você quiser incorporar views nativas do macOS em seu aplicativo Flutter,
consulte [Hospedando views nativas do macOS][].
:::

[Hospedando views nativas do Android]: /platform-integration/android/platform-views
[Hospedando views nativas do macOS]: /platform-integration/macos/platform-views

O iOS usa apenas a composição híbrida, o que significa que a `UIView` nativa
é anexada à hierarquia de views.

Para criar uma platform view no iOS, use as seguintes instruções:

## No lado do Dart

No lado do Dart, crie um `Widget` e adicione a implementação do build,
conforme mostrado nas etapas a seguir.

No arquivo de widget Dart, faça alterações semelhantes às mostradas em
`native_view_example.dart`:

<ol>
<li>

Adicione as seguintes importações:

<?code-excerpt "lib/native_view_example_3.dart (import)"?>
```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
```

</li>

<li>

Implemente um método `build()`:

<?code-excerpt "lib/native_view_example_3.dart (ios-composition)"?>
```dart
Widget build(BuildContext context) {
  // Isso é usado no lado da plataforma para registrar a view.
  const String viewType = '<platform-view-type>';
  // Passe parâmetros para o lado da plataforma.
  final Map<String, dynamic> creationParams = <String, dynamic>{};

  return UiKitView(
    viewType: viewType,
    layoutDirection: TextDirection.ltr,
    creationParams: creationParams,
    creationParamsCodec: const StandardMessageCodec(),
  );
}
```

</li>
</ol>

Para mais informações, consulte a documentação da API para:
[`UIKitView`][].

[`UIKitView`]: {{site.api}}/flutter/widgets/UiKitView-class.html

## No lado da plataforma

No lado da plataforma, use Swift ou Objective-C:

{% tabs "darwin-language" %}
{% tab "Swift" %}

Implemente a factory e a platform view. A `FLNativeViewFactory` cria a
platform view, e a platform view fornece uma referência para a `UIView`.
Por exemplo, `FLNativeView.swift`:

```swift
import Flutter
import UIKit

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }

    /// A implementação desse método só é necessária quando os `argumentos` em `createWithFrame` não forem `nil`.
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        super.init()
        // Views do iOS podem ser criadas aqui
        createNativeView(view: _view)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView){
        _view.backgroundColor = UIColor.blue
        let nativeLabel = UILabel()
        nativeLabel.text = "Native text from iOS"
        nativeLabel.textColor = UIColor.white
        nativeLabel.textAlignment = .center
        nativeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
        _view.addSubview(nativeLabel)
    }
}
```

Finalmente, registre a platform view. Isso pode ser feito em um aplicativo ou
um plugin.

Para registro de aplicativo, modifique o `AppDelegate.swift` do aplicativo:

```swift
import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        guard let pluginRegistrar = self.registrar(forPlugin: "plugin-name") else { return false }

        let factory = FLNativeViewFactory(messenger: pluginRegistrar.messenger())
        pluginRegistrar.register(
            factory,
            withId: "<platform-view-type>")
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

Para registro de plugin, modifique o arquivo principal do plugin (por
exemplo, `FLPlugin.swift`):

```swift
import Flutter
import UIKit

class FLPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = FLNativeViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "<platform-view-type>")
    }
}
```

{% endtab %}
{% tab "Objective-C" %}

Em Objective-C, adicione os cabeçalhos para a factory e a platform view.
Por exemplo, como mostrado em `FLNativeView.h`:

```objc
#import <Flutter/Flutter.h>

@interface FLNativeViewFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end

@interface FLNativeView : NSObject <FlutterPlatformView>

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

- (UIView*)view;
@end
```

Implemente a factory e a platform view. A `FLNativeViewFactory` cria a
platform view, e a platform view fornece uma referência para a `UIView`.
Por exemplo, `FLNativeView.m`:

```objc
#import "FLNativeView.h"

@implementation FLNativeViewFactory {
  NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
  return [[FLNativeView alloc] initWithFrame:frame
                              viewIdentifier:viewId
                                   arguments:args
                             binaryMessenger:_messenger];
}

/// A implementação desse método só é necessária quando os `argumentos` em `createWithFrame` não forem `nil`.
- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

@end

@implementation FLNativeView {
   UIView *_view;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  if (self = [super init]) {
    _view = [[UIView alloc] init];
  }
  return self;
}

- (UIView*)view {
  return _view;
}

@end
```

Finalmente, registre a platform view. Isso pode ser feito em um aplicativo ou
um plugin.

Para registro de aplicativo, modifique o `AppDelegate.m` do aplicativo:

```objc
#import "AppDelegate.h"
#import "FLNativeView.h"
#import "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];

   NSObject<FlutterPluginRegistrar>* registrar =
      [self registrarForPlugin:@"plugin-name"];

  FLNativeViewFactory* factory =
      [[FLNativeViewFactory alloc] initWithMessenger:registrar.messenger];

  [[self registrarForPlugin:@"<plugin-name>"] registerViewFactory:factory
                                                          withId:@"<platform-view-type>"];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
```

Para registro de plugin, modifique o arquivo principal do plugin (por
exemplo, `FLPlugin.m`):

```objc
#import <Flutter/Flutter.h>
#import "FLNativeView.h"

@interface FLPlugin : NSObject<FlutterPlugin>
@end

@implementation FLPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FLNativeViewFactory* factory =
      [[FLNativeViewFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:factory withId:@"<platform-view-type>"];
}

@end
```

{% endtab %}
{% endtabs %}

Para mais informações, consulte a documentação da API para:

*   [`FlutterPlatformViewFactory`][]
*   [`FlutterPlatformView`][]
*   [`PlatformView`][]

[`FlutterPlatformView`]: {{site.api}}/ios-embedder/protocol_flutter_platform_view-p.html
[`FlutterPlatformViewFactory`]: {{site.api}}/ios-embedder/protocol_flutter_platform_view_factory-p.html
[`PlatformView`]: {{site.api}}/javadoc/io/flutter/plugin/platform/PlatformView.html

## Juntando tudo

Ao implementar o método `build()` em Dart, você pode usar
[`defaultTargetPlatform`][] para detectar a plataforma e decidir qual
widget usar:

<?code-excerpt "lib/native_view_example_3.dart (together-widget)"?>
```dart
Widget build(BuildContext context) {
  // Isso é usado no lado da plataforma para registrar a view.
  const String viewType = '<platform-view-type>';
  // Passe parâmetros para o lado da plataforma.
  final Map<String, dynamic> creationParams = <String, dynamic>{};

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
    // retorne widget no Android.
    case TargetPlatform.iOS:
    // retorne widget no iOS.
    case TargetPlatform.macOS:
    // retorne widget no macOS.
    default:
      throw UnsupportedError('Platform view não suportada');
  }
}
```

## Desempenho

As platform views no Flutter vêm com compensações de desempenho.

Para casos complexos, existem algumas técnicas que podem ser usadas para
mitigar problemas de desempenho.

Por exemplo, você pode usar uma textura de espaço reservado enquanto uma
animação está acontecendo em Dart. Em outras palavras, se uma animação
estiver lenta enquanto uma platform view estiver sendo renderizada,
considere tirar uma captura de tela da view nativa e renderizá-la como
uma textura.

## Limitações de composição

Existem algumas limitações ao compor Platform Views do iOS.

-   Os widgets [`ShaderMask`][] e [`ColorFiltered`][] não são suportados.
-   O widget [`BackdropFilter`][] é suportado, mas existem algumas
    limitações sobre como ele pode ser usado. Para mais detalhes,
    consulte o [documento de design do iOS Platform View Backdrop Filter
    Blur][design-doc].

[`ShaderMask`]: {{site.api}}/flutter/foundation/ShaderMask.html
[`ColorFiltered`]: {{site.api}}/flutter/foundation/ColorFiltered.html
[`BackdropFilter`]: {{site.api}}/flutter/foundation/BackdropFilter.html
[`defaultTargetPlatform`]: {{site.api}}/flutter/foundation/defaultTargetPlatform.html
[design-doc]: {{site.main-url}}/go/ios-platformview-backdrop-filter-blur
