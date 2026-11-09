---
ia-translate: true
title: Hospede views iOS nativas no seu app Flutter com platform views
shortTitle: Platform views iOS
description: >-
  Aprenda como hospedar views iOS nativas no seu app Flutter com platform views.
---

<?code-excerpt path-base="platform_integration/platform_views"?>

Platform views permitem que você incorpore views nativas em um app Flutter,
para que você possa aplicar transformações, clipes e opacidade à view nativa
a partir do Dart.

Isso permite que você, por exemplo, use o
Google Maps nativo dos SDKs Android e iOS
diretamente dentro do seu app Flutter.

:::note
Esta página discute como hospedar suas próprias views iOS nativas
dentro de um app Flutter.
Se você deseja incorporar views Android nativas no seu app Flutter,
consulte [Hospedando views Android nativas][Hosting native Android views].
Se você deseja incorporar views macOS nativas no seu app Flutter,
consulte [Hospedando views macOS nativas][Hosting native macOS views].
:::

[Hosting native Android views]: /platform-integration/android/platform-views
[Hosting native macOS views]: /platform-integration/macos/platform-views


iOS usa apenas Hybrid composition,
o que significa que a
`UIView` nativa é anexada à hierarquia de views.

Para criar uma platform view no iOS,
use as seguintes instruções:

## On the Dart side

No lado Dart, crie um `Widget`
e adicione a implementação de build,
conforme mostrado nas etapas a seguir.

No arquivo de widget Dart, faça alterações semelhantes às
mostradas em `native_view_example.dart`:

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
  // This is used in the platform side to register the view.
  const String viewType = '<platform-view-type>';
  // Pass parameters to the platform side.
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
[`UIKitView`][`UIKitView`].

[`UIKitView`]: {{site.api}}/flutter/widgets/UiKitView-class.html

## On the platform side

No lado da plataforma, use Swift ou Objective-C:

<Tabs key="darwin-language">
<Tab name="Swift">

Implemente a factory e a platform view.
A `FLNativeViewFactory` cria a platform view,
e a platform view fornece uma referência à `UIView`.

Por exemplo, implemente a classe factory:

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

    /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}
```

Dependendo do framework de UI que você está usando,
escolha uma das seguintes implementações para `FLNativeView`:

<Tabs key="swift-ui-framework">
<Tab name="UIKit">

Para UIKit, implemente a classe `FLNativeView`:

```swift
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
        // iOS views can be created here
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

</Tab>
<Tab name="SwiftUI">

Para exibir views SwiftUI dentro de uma platform view no iOS,
envolva a view SwiftUI dentro de um `UIHostingController`.
Como `UIHostingController` é um view controller,
você pode recuperar sua view usando a propriedade `view`,
e retorná-la a partir do método `view()` da platform view.

Para evitar desalocação prematura, armazene a instância de `UIHostingController`
como uma propriedade de `FLNativeView`. Use o `frame`
passado para o inicializador para definir o frame da view do
hosting controller para que o Flutter a dimensione corretamente.

Para SwiftUI, implemente a classe `FLNativeView` e sua view SwiftUI:

```swift
import SwiftUI

class FLNativeView: NSObject, FlutterPlatformView {
    private let hostingController: UIHostingController<MySwiftUIView>

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        hostingController = UIHostingController(rootView: MySwiftUIView())
        super.init()
        hostingController.view.frame = frame
    }

    func view() -> UIView {
        return hostingController.view
    }
}

struct MySwiftUIView: View {
    var body: some View {
        Text("Native text from iOS (SwiftUI)")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
    }
}
```

</Tab>
</Tabs>

Finalmente, registre a platform view.
Isso pode ser feito em um app ou em um plugin.

:::version-note
No Flutter 3.41 e posteriores,
apps iOS usam o ciclo de vida `UIScene` por padrão.
Para apps que usam `UIScene`,
você deve implementar `FlutterImplicitEngineDelegate`
e registrar suas platform views dentro de
`didInitializeImplicitFlutterEngine(_:)`.
Para mais informações,
consulte o [guia de adoção do UISceneDelegate][UISceneDelegate adoption guide].
:::

Para registro no app,
modifique o `AppDelegate.swift` do App:

```swift
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
   
    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

        guard let pluginRegistrar = engineBridge.pluginRegistry.registrar(forPlugin: "plugin-name") else { return }

        let factory = FLNativeViewFactory(messenger: pluginRegistrar.messenger())
        pluginRegistrar.register(
            factory,
            withId: "<platform-view-type>")
    }
}
```

Para registro de plugin,
modifique o arquivo principal do plugin
(por exemplo, `FLPlugin.swift`):

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

</Tab>
<Tab name="Objective-C">

No Objective-C, adicione os headers para a factory e a platform view.
Por exemplo, conforme mostrado em `FLNativeView.h`:

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

Implemente a factory e a platform view.
A `FLNativeViewFactory` cria a platform view,
e a platform view fornece uma referência à
`UIView`. Por exemplo, `FLNativeView.m`:

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

/// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
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

Finalmente, registre a platform view.
Isso pode ser feito em um app ou em um plugin.

:::version-note
No Flutter 3.41 e posteriores,
apps iOS usam o ciclo de vida `UIScene` por padrão.
Para apps que usam `UIScene`,
você deve implementar `FlutterImplicitEngineDelegate`
e registrar suas platform views dentro de
`didInitializeImplicitFlutterEngine:`.
Para mais informações,
consulte o [guia de adoção do UISceneDelegate][UISceneDelegate adoption guide].
:::

Para registro no app,
modifique o `AppDelegate.m` do App:

```objc
#import "AppDelegate.h"
#import "FLNativeView.h"
#import "GeneratedPluginRegistrant.h"

@interface AppDelegate () <FlutterImplicitEngineDelegate>
@end

@implementation AppDelegate

- (void)didInitializeImplicitFlutterEngine:(NSObject<FlutterImplicitEngineBridge>*)engineBridge {
  [GeneratedPluginRegistrant registerWithRegistry:engineBridge.pluginRegistry];

  NSObject<FlutterPluginRegistrar>* registrar =
      [engineBridge.pluginRegistry registrarForPlugin:@"plugin-name"];

  FLNativeViewFactory* factory =
      [[FLNativeViewFactory alloc] initWithMessenger:registrar.messenger];

  [registrar registerViewFactory:factory withId:@"<platform-view-type>"];
}

@end
```

Para registro de plugin,
modifique o arquivo principal do plugin
(por exemplo, `FLPlugin.m`):

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

</Tab>
</Tabs>

Para mais informações, consulte a documentação da API para:

* [`FlutterPlatformViewFactory`][`FlutterPlatformViewFactory`]
* [`FlutterPlatformView`][`FlutterPlatformView`]
* [`PlatformView`][`PlatformView`]

[`FlutterPlatformView`]: {{site.api}}/ios-embedder/protocol_flutter_platform_view-p.html
[`FlutterPlatformViewFactory`]: {{site.api}}/ios-embedder/protocol_flutter_platform_view_factory-p.html
[`PlatformView`]: {{site.api}}/javadoc/io/flutter/plugin/platform/PlatformView.html

## Putting it together

Ao implementar o método `build()` no Dart,
você pode usar [`defaultTargetPlatform`][defaultTargetPlatform]
para detectar a plataforma e decidir qual widget usar:

<?code-excerpt "lib/native_view_example_3.dart (together-widget)"?>
```dart
Widget build(BuildContext context) {
  // This is used in the platform side to register the view.
  const String viewType = '<platform-view-type>';
  // Pass parameters to the platform side.
  final Map<String, dynamic> creationParams = <String, dynamic>{};

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
    // return widget on Android.
    case TargetPlatform.iOS:
    // return widget on iOS.
    case TargetPlatform.macOS:
    // return widget on macOS.
    default:
      throw UnsupportedError('Unsupported platform view');
  }
}
```

## Performance

Platform views no Flutter vêm com trade-offs de desempenho.

Para casos complexos, existem algumas técnicas que podem ser usadas
para mitigar problemas de desempenho.

Por exemplo, você pode usar uma texture de placeholder enquanto uma
animação está acontecendo no Dart.
Em outras palavras, se uma animação está lenta enquanto uma platform view é renderizada,
considere tirar uma captura de tela da view nativa e
renderizá-la como uma texture.

## Composition limitations

Existem algumas limitações ao compor iOS Platform Views.

- Os widgets [`ShaderMask`][`ShaderMask`] e [`ColorFiltered`][`ColorFiltered`] não são suportados.
- O widget [`BackdropFilter`][`BackdropFilter`] é suportado,
  mas existem algumas limitações sobre como ele pode ser usado.
  Para mais detalhes, consulte o
  [documento de design iOS Platform View Backdrop Filter Blur][design-doc].

[`ShaderMask`]: {{site.api}}/flutter/foundation/ShaderMask.html
[`ColorFiltered`]: {{site.api}}/flutter/foundation/ColorFiltered.html
[`BackdropFilter`]: {{site.api}}/flutter/foundation/BackdropFilter.html
[defaultTargetPlatform]: {{site.api}}/flutter/foundation/defaultTargetPlatform.html
[design-doc]: {{site.main-url}}/go/ios-platformview-backdrop-filter-blur
[UISceneDelegate adoption guide]: /release/breaking-changes/uiscenedelegate#migrate-appdelegate
