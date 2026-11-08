---
ia-translate: true
title: Adicione uma tela Flutter a um app macOS
shortTitle: Adicione uma tela Flutter
description: Aprenda a adicionar uma única tela Flutter ao seu app macOS existente.
---

Este guia descreve como adicionar uma única tela Flutter a um app macOS existente.

## Inicie um FlutterEngine e um FlutterViewController {:#start-a-flutterengine-and-flutterviewcontroller}

Para abrir uma tela Flutter a partir de um app macOS existente,
você inicia um [`FlutterEngine`][`FlutterEngine`] e um [`FlutterViewController`][`FlutterViewController`].

:::note
O `FlutterEngine` serve como host para a Dart VM e para o seu runtime Flutter,
e o `FlutterViewController` se conecta a um `FlutterEngine`
para passar eventos de entrada para o Flutter
e exibir os frames renderizados pelo `FlutterEngine`.
:::

O `FlutterEngine` pode ter o mesmo ciclo de vida
do seu `FlutterViewController` ou sobreviver a ele.

:::tip
Geralmente é recomendado pré-aquecer um `FlutterEngine` de longa duração
para o seu app, porque:

* O primeiro frame aparece mais rápido ao exibir o `FlutterViewController`.
* O estado do seu Flutter e do Dart sobrevive a um `FlutterViewController`.
* Seu app e seus plugins podem interagir com o Flutter
  e com a lógica Dart antes de exibir a UI.
:::

Consulte [Sequência de carregamento e desempenho][Loading sequence and performance]
para uma análise mais detalhada das trocas de latência e memória
ao pré-aquecer um engine.

### Crie um FlutterEngine {:#create-a-flutterengine}

Onde você cria um `FlutterEngine` depende do seu app host.

<Tabs key="macos-framework">
<Tab name="SwiftUI">

Neste exemplo, criamos um objeto `FlutterEngine`
dentro de um objeto [`Observable`][`Observable`] do SwiftUI chamado `FlutterDependencies`.
Pré-aqueça o engine chamando `run()` e, em seguida, injete este objeto
em um `ContentView` usando o modificador de view `environment()`.

 ```swift title="MyApp.swift"
import SwiftUI
import FlutterMacOS
// The following library connects plugins with macOS platform code to this app.
import FlutterPluginRegistrant

@Observable
class FlutterDependencies {
  let flutterEngine = FlutterEngine(name: "my flutter engine", project: nil)
  init() {
    // Runs the default Dart entrypoint with a default Flutter route.
    flutterEngine.run(withEntrypoint: nil)
    // Connects plugins with macOS platform code to this app.
    RegisterGeneratedPlugins(registry: self.flutterEngine)
  }
}

@main
struct MyApp: App {
    // flutterDependencies will be injected through the view environment.
    @State var flutterDependencies = FlutterDependencies()
    var body: some Scene {
      WindowGroup {
        ContentView()
          .environment(flutterDependencies)
      }
    }
}
```

</Tab>
<Tab name="AppKit-Swift">

Como exemplo, demonstramos a criação de um `FlutterEngine`,
exposto como uma propriedade, na inicialização do app, no app delegate.

```swift title="AppDelegate.swift"
import Cocoa
import FlutterMacOS
// The following library connects plugins with macOS platform code to this app.
import FlutterPluginRegistrant

@main
class AppDelegate: FlutterAppDelegate {
  lazy var flutterEngine = FlutterEngine(name: "my flutter engine", project: nil)

  override func applicationDidFinishLaunching(_ aNotification: Notification) {
    flutterEngine.run(withEntrypoint: nil)
    RegisterGeneratedPlugins(registry: self.flutterEngine)
  }
}
```

</Tab>
</Tabs>

### Exiba um FlutterViewController com seu FlutterEngine {:#show-a-flutterviewcontroller-with-your-flutterengine}

<Tabs key="macos-framework">
<Tab name="SwiftUI">

O exemplo a seguir mostra um `ContentView` genérico com um
[`NavigationLink`][`NavigationLink`] conectado a uma tela Flutter.
Primeiro, crie um `FlutterViewControllerRepresentable`
para representar o `FlutterViewController`.
O construtor do `FlutterViewController` recebe
o `FlutterEngine` pré-aquecido como argumento,
que é injetado por meio do environment da view.

```swift title="ContentView.swift"
import SwiftUI
import FlutterMacOS

struct FlutterViewControllerRepresentable: NSViewControllerRepresentable {
  // Flutter dependencies are passed in through the view environment.
  @Environment(FlutterDependencies.self) var flutterDependencies

  func makeNSViewController(context: Context) -> FlutterViewController {
    return FlutterViewController(
      engine: flutterDependencies.flutterEngine,
      nibName: nil,
      bundle: nil
    )
  }

  func updateNSViewController(_ nsViewController: FlutterViewController, context: Context) {}
}

struct ContentView: View {
  var body: some View {
    NavigationStack {
      NavigationLink("My Flutter Feature") {
        FlutterViewControllerRepresentable()
      }
    }
  }
}
```

Agora, você tem uma tela Flutter incorporada ao seu app macOS.

:::note
Neste exemplo, a função `main()` do seu entrypoint Dart é executada
quando o observable `FlutterDependencies` é inicializado.
:::

</Tab>
<Tab name="AppKit-Swift">

O exemplo a seguir mostra um `ViewController` genérico com um
`NSButton` configurado para apresentar um [`FlutterViewController`][`FlutterViewController`].
O `FlutterViewController` usa a instância de `FlutterEngine`
criada no `AppDelegate`.

```swift title="ViewController.swift"
import Cocoa
import FlutterMacOS

class ViewController: NSViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Make a button to call the showFlutter function when pressed.
    let button =  NSButton(title: "Show Flutter!", target: self, action: #selector(showFlutter))
    button.frame = CGRect(x: 202, y: 187, width: 160.0, height: 40.0)
    self.view.addSubview(button)
  }

  @objc func showFlutter() {
    let flutterEngine = (NSApplication.shared.delegate as! AppDelegate).flutterEngine
    let flutterViewController =
        FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
    self.addChild(flutterViewController)
    flutterViewController.view.frame = self.view.bounds
    presentAsModalWindow(flutterViewController)
  }
}
```

Agora, você tem uma tela Flutter incorporada ao seu app macOS.

:::note
Usando o exemplo anterior, a função `main()` padrão
da sua biblioteca Dart padrão é executada
ao chamar `run` no `FlutterEngine` criado no `AppDelegate`.
:::

</Tab>
</Tabs>

### _Alternativamente_ - Crie um FlutterViewController com um FlutterEngine implícito {:#alternatively-create-a-flutterviewcontroller-with-an-implicit-flutterengine}

Como alternativa ao exemplo anterior,
você pode deixar o `FlutterViewController` criar implicitamente
seu próprio `FlutterEngine`, sem pré-aquecer um antecipadamente.

Isso geralmente não é recomendado,
porque criar um `FlutterEngine` sob demanda pode introduzir uma latência perceptível
entre o momento em que o `FlutterViewController` é apresentado
e o momento em que ele renderiza o primeiro frame.
No entanto, isso pode ser útil se a tela Flutter for raramente exibida,
quando não há boas heurísticas
para determinar quando a Dart VM deve ser iniciada,
e quando o Flutter não precisa persistir o estado entre view controllers.

Para permitir que o `FlutterViewController` seja apresentado sem um `FlutterEngine` existente,
omita a construção do `FlutterEngine`
e crie o `FlutterViewController` sem uma referência ao engine.

<Tabs key="macos-framework">
<Tab name="SwiftUI">

```swift title="ContentView.swift"
// Existing code omitted.
func makeNSViewController(context: Context) -> FlutterViewController {
  return FlutterViewController()
}
```

</Tab>
<Tab name="AppKit-Swift">

```swift title="ViewController.swift"
// Existing code omitted.
func showFlutter() {
  let flutterViewController = FlutterViewController()
  self.addChild(flutterViewController)
  flutterViewController.view.frame = self.view.bounds
  presentAsModalWindow(flutterViewController)
}
```

</Tab>
</Tabs>

Consulte [Sequência de carregamento e desempenho][Loading sequence and performance]
para mais explorações sobre latência e uso de memória.

## Usando o FlutterAppDelegate {:#using-the-flutterappdelegate}

Fazer com que a subclasse `UIApplicationDelegate` do seu aplicativo herde de
`FlutterAppDelegate` é recomendado, mas não obrigatório.

O `FlutterAppDelegate` executa funções como:

* Encaminhar callbacks do aplicativo, como [`openURLs`][`openURLs`],
  para plugins como o [google_sign_in][google_sign_in].

### Criando uma subclasse de FlutterAppDelegate {:#creating-a-flutterappdelegate-subclass}

A criação de uma subclasse de `FlutterAppDelegate` em apps UIKit foi mostrada
na [seção Inicie um FlutterEngine e um FlutterViewController][Start a FlutterEngine and FlutterViewController section].
Em um app SwiftUI, você pode criar uma subclasse de `FlutterAppDelegate`
e anotá-la com a macro [`Observable()`][`Observable()`] da seguinte forma:

```swift title="MyApp.swift"
import SwiftUI
import FlutterMacOS

@Observable
class AppDelegate: FlutterAppDelegate {
  let flutterEngine = FlutterEngine(name: "my flutter engine", project: nil)

  override func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Runs the default Dart entrypoint with a default Flutter route.
    flutterEngine.run(withEntrypoint: nil)
    // Used to connect plugins (only if you have plugins
    // with macOS platform code).
    RegisterGeneratedPlugins(registry: self.flutterEngine)
  }
}

@main
struct MyApp: App {
  // Use this property wrapper to tell SwiftUI
  // it should use the AppDelegate class for the application delegate
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
```

Depois, na sua view, o `AppDelegate` fica acessível
por meio do environment da view.

```swift title="ContentView.swift"
import SwiftUI
import FlutterMacOS

struct FlutterViewControllerRepresentable: NSViewControllerRepresentable {
  // Access the AppDelegate through the view environment.
  @Environment(AppDelegate.self) var appDelegate

  func makeNSViewController(context: Context) -> FlutterViewController {
    return FlutterViewController(
      engine: appDelegate.flutterEngine,
      nibName: nil,
      bundle: nil
    )
  }

  func updateNSViewController(_ nsViewController: FlutterViewController, context: Context) {}
}

struct ContentView: View {
  var body: some View {
    NavigationStack {
      NavigationLink("My Flutter Feature") {
        FlutterViewControllerRepresentable()
      }
    }
  }
}
```

[`FlutterEngine`]: {{site.api}}/macos-embedder/interface_flutter_engine.html
[`FlutterViewController`]: {{site.api}}/macos-embedder/interface_flutter_view_controller.html
[Loading sequence and performance]: /add-to-app/performance
[google_sign_in]: {{site.pub}}/packages/google_sign_in
[`openURLs`]: {{site.apple-dev}}/documentation/appkit/nsapplicationdelegate/application(_:open:)
[Start a FlutterEngine and FlutterViewController section]:/add-to-app/macos/add-flutter-screen/#start-a-flutterengine-and-flutterviewcontroller
[`Observable`]: {{site.apple-dev}}/documentation/observation/observable
[`NavigationLink`]: {{site.apple-dev}}/documentation/swiftui/navigationlink
[`Observable()`]: {{site.apple-dev}}/documentation/observation/observable()
