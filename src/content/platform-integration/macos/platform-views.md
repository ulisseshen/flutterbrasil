---
ia-translate: true
title: Hospedando views nativas macOS no seu app Flutter com Platform Views
short-title: Platform-views macOS
description: Aprenda como hospedar views nativas macOS no seu app Flutter com Platform Views.
---

<?code-excerpt path-base="platform_integration/platform_views"?>

Platform views permitem que você incorpore views nativas em um app Flutter, para que você possa
aplicar transformações, clipes e opacidade à view nativa a partir do Dart.

Isso permite que você, por exemplo, use as web views nativas diretamente dentro do seu
app Flutter.

:::note
Esta página discute como hospedar suas próprias views nativas macOS dentro de um
app Flutter.
Se você deseja incorporar views nativas Android no seu app Flutter,
veja [Hosting native Android views][].
Se você deseja incorporar views nativas iOS no seu app Flutter,
veja [Hosting native iOS views][].
:::

[Hosting native Android views]: /platform-integration/android/platform-views
[Hosting native iOS views]: /platform-integration/ios/platform-views

:::note Nota de versão
O suporte a platform view no macOS não está totalmente funcional a partir da versão atual.
Por exemplo, o suporte a gestos ainda não está disponível no macOS.
Fique atento para uma futura versão estável.
:::
O macOS usa Hybrid composition, o que significa que a `NSView` nativa é anexada
à hierarquia de views.

Para criar uma platform view no macOS, use as seguintes instruções:

## No lado Dart

No lado Dart, crie um `Widget` e adicione a implementação do build, conforme mostrado
nas etapas a seguir.

No arquivo do widget Dart, faça alterações semelhantes às mostradas
em `native_view_example.dart`:

<ol>
<li>

Adicione as seguintes importações:

<?code-excerpt "lib/native_view_example_4.dart (import)"?>
```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
```

</li>

<li>

Implemente um método `build()`:

<?code-excerpt "lib/native_view_example_4.dart (macos-composition)"?>
```dart
Widget build(BuildContext context) {
  // This is used in the platform side to register the view.
  const String viewType = '<platform-view-type>';
  // Pass parameters to the platform side.
  final Map<String, dynamic> creationParams = <String, dynamic>{};

  return AppKitView(
    viewType: viewType,
    layoutDirection: TextDirection.ltr,
    creationParams: creationParams,
    creationParamsCodec: const StandardMessageCodec(),
  );
}
```

</li>
</ol>

Para mais informações, veja a documentação da API para: [`AppKitView`][].

[`AppKitView`]: {{site.api}}/flutter/widgets/AppKitView-class.html

## No lado da plataforma

Implemente a factory e a platform view. A `NativeViewFactory` cria a
platform view, e a platform view fornece uma referência à `NSView`. Por
exemplo, `NativeView.swift`:

```swift
import Cocoa
import FlutterMacOS

class NativeViewFactory: NSObject, FlutterPlatformViewFactory {
  private var messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

  func create(
    withViewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> NSView {
    return NativeView(
      viewIdentifier: viewId,
      arguments: args,
      binaryMessenger: messenger)
  }

  /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
  public func createArgsCodec() -> (FlutterMessageCodec & NSObjectProtocol)? {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}

class NativeView: NSView {

  init(
    viewIdentifier viewId: Int64,
    arguments args: Any?,
    binaryMessenger messenger: FlutterBinaryMessenger?
  ) {
    super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    wantsLayer = true
    layer?.backgroundColor = NSColor.systemBlue.cgColor
    // macOS views can be created here
    createNativeView(view: self)
  }

    required init?(coder nsCoder: NSCoder) {
        super.init(coder: nsCoder)
    }

  func createNativeView(view _view: NSView) {
    let nativeLabel = NSTextField()
    nativeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
    nativeLabel.stringValue = "Native text from macOS"
    nativeLabel.textColor = NSColor.black
    nativeLabel.font = NSFont.systemFont(ofSize: 14)
    nativeLabel.isBezeled = false
    nativeLabel.focusRingType = .none
    nativeLabel.isEditable = true
    nativeLabel.sizeToFit()
    _view.addSubview(nativeLabel)
  }
}

```

Finalmente, registre a platform view. Isso pode ser feito em um app ou em um plugin.

Para registro no app, modifique o `MainFlutterWindow.swift` do App:

```swift
import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    // ...

    let registrar = flutterViewController.registrar(forPlugin: "plugin-name")
    let factory = NativeViewFactory(messenger: registrar.messenger)
    registrar.register(
      factory,
      withId: "<platform-view-type>")
  }
}
```

Para registro no plugin, modifique o arquivo principal do plugin (por exemplo,
`Plugin.swift`):

```swift
import Cocoa
import FlutterMacOS

public class Plugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let factory = NativeViewFactory(messenger: registrar.messenger)
    registrar.register(factory, withId: "<platform-view-type>")
  }
}
```

Para mais informações, veja a documentação da API para:

* [`FlutterPlatformViewFactory`][]
* [`FlutterPlatformView`][]
* [`PlatformView`][]

[`FlutterPlatformView`]: {{site.api}}/ios-embedder/protocol_flutter_platform_view-p.html
[`FlutterPlatformViewFactory`]: {{site.api}}/ios-embedder/protocol_flutter_platform_view_factory-p.html
[`PlatformView`]: {{site.api}}/javadoc/io/flutter/plugin/platform/PlatformView.html

## Juntando tudo

Ao implementar o método `build()` em Dart,
você pode usar [`defaultTargetPlatform`][]
para detectar a plataforma e decidir qual widget usar:

<?code-excerpt "lib/native_view_example_4.dart (together-widget)"?>
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

[`defaultTargetPlatform`]: {{site.api}}/flutter/foundation/defaultTargetPlatform.html

## Performance
Platform views no Flutter vêm com trade-offs de performance.

Por exemplo, em um app Flutter típico, a UI Flutter é composta em uma thread raster
dedicada. Isso permite que apps Flutter sejam rápidos, pois essa thread raramente
é bloqueada.

Quando uma platform view é renderizada com hybrid composition, a UI Flutter
continua a ser composta a partir da thread raster dedicada, mas a platform view
executa operações gráficas na thread da plataforma. Para rasterizar o
conteúdo combinado, Flutter executa sincronização entre sua thread raster e a
thread da plataforma. Como tal, quaisquer operações lentas ou bloqueantes na thread da plataforma
podem impactar negativamente a performance gráfica do Flutter.
