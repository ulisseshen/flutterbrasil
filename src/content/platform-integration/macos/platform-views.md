---
ia-translate: true
title: Hospedando views nativas do macOS em seu aplicativo Flutter com Platform Views
short-title: platform-views do macOS
description: Aprenda como hospedar views nativas do macOS em seu aplicativo Flutter com Platform Views.
---

<?code-excerpt path-base="platform_integration/platform_views"?>

As platform views permitem que você incorpore views nativas em um aplicativo
Flutter, para que você possa aplicar transformações, recortes e opacidade à
view nativa a partir do Dart.

Isso permite, por exemplo, usar as web views nativas diretamente dentro do seu
aplicativo Flutter.

:::note
Esta página discute como hospedar suas próprias views nativas do macOS dentro de
um aplicativo Flutter.
Se você quiser incorporar views nativas do Android em seu aplicativo Flutter,
consulte [Hospedando views nativas do Android][].
Se você quiser incorporar views nativas do iOS em seu aplicativo Flutter,
consulte [Hospedando views nativas do iOS][].
:::

[Hospedando views nativas do Android]: /platform-integration/android/platform-views
[Hospedando views nativas do iOS]: /platform-integration/ios/platform-views

:::note Version note
O suporte a platform view no macOS não está totalmente funcional na versão
atual.
Por exemplo, o suporte a gestos ainda não está disponível no macOS.
Fique atento para uma futura versão estável.
:::
O macOS usa composição híbrida, o que significa que o `NSView` nativo é anexado
à hierarquia de views.

Para criar uma platform view no macOS, use as seguintes instruções:

## No lado Dart

No lado Dart, crie um `Widget` e adicione a implementação de build, conforme
mostrado nas etapas a seguir.

No arquivo de widget Dart, faça alterações semelhantes às mostradas em
`native_view_example.dart`:

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
  // Isso é usado no lado da plataforma para registrar a view.
  const String viewType = '<platform-view-type>';
  // Passe parâmetros para o lado da plataforma.
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

Para obter mais informações, consulte a documentação da API para: [`AppKitView`][].

[`AppKitView`]: {{site.api}}/flutter/widgets/AppKitView-class.html

## No lado da plataforma

Implemente a fábrica e a platform view. A `NativeViewFactory` cria a
platform view, e a platform view fornece uma referência ao `NSView`. Por
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

  /// Implementar este método só é necessário quando os `arguments` em `createWithFrame` não são `nil`.
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
    // As views do macOS podem ser criadas aqui
    createNativeView(view: self)
  }
    
    required init?(coder nsCoder: NSCoder) {
        super.init(coder: nsCoder)
    }
    
  func createNativeView(view _view: NSView) {
    let nativeLabel = NSTextField()
    nativeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
    nativeLabel.stringValue = "Texto nativo do macOS"
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

Finalmente, registre a platform view. Isso pode ser feito em um aplicativo ou
plugin.

Para registro de aplicativo, modifique `MainFlutterWindow.swift` do App:

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

Para registro de plugin, modifique o arquivo principal do plugin (por exemplo,
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

Para obter mais informações, consulte a documentação da API para:

* [`FlutterPlatformViewFactory`][]
* [`FlutterPlatformView`][]
* [`PlatformView`][]

[`FlutterPlatformView`]: {{site.api}}/ios-embedder/protocol_flutter_platform_view-p.html
[`FlutterPlatformViewFactory`]: {{site.api}}/ios-embedder/protocol_flutter_platform_view_factory-p.html
[`PlatformView`]: {{site.api}}/javadoc/io/flutter/plugin/platform/PlatformView.html

## Juntando tudo

Ao implementar o método `build()` em Dart, você pode usar
[`defaultTargetPlatform`][] para detectar a plataforma e decidir qual widget
usar:

<?code-excerpt "lib/native_view_example_4.dart (together-widget)"?>
```dart
Widget build(BuildContext context) {
  // Isso é usado no lado da plataforma para registrar a view.
  const String viewType = '<platform-view-type>';
  // Passe parâmetros para o lado da plataforma.
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

## Desempenho
As platform views no Flutter vêm com compensações de desempenho.

Por exemplo, em um aplicativo Flutter típico, a UI do Flutter é composta em um
thread raster dedicado. Isso permite que os aplicativos Flutter sejam rápidos,
pois esse thread raramente é bloqueado.

Quando uma platform view é renderizada com composição híbrida, a UI do Flutter
continua a ser composta a partir do thread raster dedicado, mas a platform view
executa operações gráficas no thread da plataforma. Para rasterizar o conteúdo
combinado, o Flutter executa a sincronização entre seu thread raster e o thread
da plataforma. Como tal, quaisquer operações lentas ou de bloqueio no thread da
plataforma podem afetar negativamente o desempenho gráfico do Flutter.
