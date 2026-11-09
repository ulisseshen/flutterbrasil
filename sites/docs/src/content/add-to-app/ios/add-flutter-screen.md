---
ia-translate: true
title: Adicione uma tela Flutter a um app iOS
shortTitle: Adicione uma tela Flutter
description: >-
  Aprenda como adicionar uma única tela Flutter ao seu app iOS existente.
---

Este guia descreve como adicionar uma única tela Flutter a um app iOS existente.

## Inicie um FlutterEngine e FlutterViewController {:#start-a-flutterengine-and-flutterviewcontroller}

Para iniciar uma tela Flutter de um app iOS existente, você inicia um
[`FlutterEngine`][`FlutterEngine`] e um [`FlutterViewController`][`FlutterViewController`].

:::note
O `FlutterEngine` serve como um host para a Dart VM e seu runtime Flutter,
e o `FlutterViewController` se anexa a um `FlutterEngine` para passar
eventos de entrada para o Flutter e exibir frames renderizados pelo
`FlutterEngine`.
:::

O `FlutterEngine` pode ter o mesmo tempo de vida que seu
`FlutterViewController` ou sobreviver ao seu `FlutterViewController`.

:::tip
Geralmente é recomendado pré-aquecer um `FlutterEngine` de longa duração
para seu aplicativo porque:

* O primeiro frame aparece mais rápido ao mostrar o `FlutterViewController`.
* Seu estado Flutter e Dart sobreviverá a um `FlutterViewController`.
* Seu aplicativo e seus plugins podem interagir com Flutter e sua lógica
  Dart antes de mostrar a UI.
:::

Veja [Sequência de carregamento e desempenho][Loading sequence and performance]
para mais análise sobre a latência e compensações de memória
de pré-aquecer um engine.

### Crie um FlutterEngine {:#create-a-flutterengine}

Onde você cria um `FlutterEngine` depende do seu app host.

<Tabs key="darwin-framework">
<Tab name="SwiftUI">

O exemplo a seguir cria um objeto `FlutterEngine` dentro de um objeto SwiftUI
[`Observable`][`Observable`] chamado `FlutterDependencies`.
Pré-aqueça o engine chamando `run()`, e então injete este objeto
em uma `ContentView` usando o modificador de view `environment()`.

 ```swift title="MyApp.swift"
import SwiftUI
import Flutter
// The following library connects plugins with iOS platform code to this app.
import FlutterPluginRegistrant

@Observable
class FlutterDependencies {
  let flutterEngine = FlutterEngine(name: "my flutter engine")
  init() {
    // Runs the default Dart entrypoint with a default Flutter route.
    flutterEngine.run()
    // Connects plugins with iOS platform code to this app.
    GeneratedPluginRegistrant.register(with: self.flutterEngine);
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
<Tab name="UIKit-Swift">

O exemplo a seguir demonstra a criação de um
`FlutterEngine`, exposto como uma propriedade, na inicialização do app no
app delegate.

```swift title="AppDelegate.swift"
import UIKit
import Flutter
// The following library connects plugins with iOS platform code to this app.
import FlutterPluginRegistrant

@UIApplicationMain
class AppDelegate: FlutterAppDelegate { // More on FlutterAppDelegate and FlutterSceneDelegate below.
  lazy var flutterEngine = FlutterEngine(name: "my flutter engine")

  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Runs the default Dart entrypoint with a default Flutter route.
    flutterEngine.run();
    // Connects plugins with iOS platform code to this app.
    GeneratedPluginRegistrant.register(with: self.flutterEngine);
    return super.application(application, didFinishLaunchingWithOptions: launchOptions);
  }
}
```

</Tab>
<Tab name="UIKit-ObjC">

O seguinte exemplo demonstra criar um `FlutterEngine`,
exposto como uma propriedade, na inicialização do app no app delegate.

```objc title="AppDelegate.h"
@import UIKit;
@import Flutter;

@interface AppDelegate : FlutterAppDelegate // More on FlutterAppDelegate and FlutterSceneDelegate below.
@property (nonatomic,strong) FlutterEngine *flutterEngine;
@end
```

```objc title="AppDelegate.m"
// The following library connects plugins with iOS platform code to this app.
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
  self.flutterEngine = [[FlutterEngine alloc] initWithName:@"my flutter engine"];
  // Runs the default Dart entrypoint with a default Flutter route.
  [self.flutterEngine run];
  // Connects plugins with iOS platform code to this app.
  [GeneratedPluginRegistrant registerWithRegistry:self.flutterEngine];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
```

</Tab>
</Tabs>

### Mostre um FlutterViewController com seu FlutterEngine {:#show-a-flutterviewcontroller-with-your-flutterengine}

<Tabs key="darwin-framework">
<Tab name="SwiftUI">

O seguinte exemplo mostra uma `ContentView` genérica com um
[`NavigationLink`][`NavigationLink`] conectado a uma tela flutter.
Primeiro, crie um `FlutterViewControllerRepresentable` para representar o
`FlutterViewController`. O construtor `FlutterViewController` recebe
o `FlutterEngine` pré-aquecido como argumento, que é injetado através
do ambiente da view.

```swift title="ContentView.swift"
import SwiftUI
import Flutter

struct FlutterViewControllerRepresentable: UIViewControllerRepresentable {
  // Flutter dependencies are passed in through the view environment.
  @Environment(FlutterDependencies.self) var flutterDependencies

  func makeUIViewController(context: Context) -> some UIViewController {
    return FlutterViewController(
      engine: flutterDependencies.flutterEngine,
      nibName: nil,
      bundle: nil)
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
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

Agora, você tem uma tela Flutter incorporada em seu app iOS.

:::note
Neste exemplo, sua função `main()` do Dart é executada
quando o observável `FlutterDependencies` é inicializado.
:::

</Tab>
<Tab name="UIKit-Swift">

O seguinte exemplo mostra um `ViewController` genérico com um
`UIButton` conectado para apresentar um [`FlutterViewController`][`FlutterViewController`].
O `FlutterViewController` usa a instância `FlutterEngine`
criada no `AppDelegate`.

```swift title="ViewController.swift"
import UIKit
import Flutter

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    // Make a button to call the showFlutter function when pressed.
    let button = UIButton(type:UIButton.ButtonType.custom)
    button.addTarget(self, action: #selector(showFlutter), for: .touchUpInside)
    button.setTitle("Show Flutter!", for: UIControl.State.normal)
    button.frame = CGRect(x: 80.0, y: 210.0, width: 160.0, height: 40.0)
    button.backgroundColor = UIColor.blue
    self.view.addSubview(button)
  }

  @objc func showFlutter() {
    let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
    let flutterViewController =
        FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
    present(flutterViewController, animated: true, completion: nil)
  }
}
```

Agora, você tem uma tela Flutter incorporada em seu app iOS.

:::note
Usando o exemplo anterior, a função `main()` padrão
do ponto de entrada da sua biblioteca Dart padrão
seria executada ao chamar `run` no
`FlutterEngine` criado no `AppDelegate`.
:::


</Tab>
<Tab name="UIKit-ObjC">

O seguinte exemplo mostra um `ViewController` genérico com um
`UIButton` conectado para apresentar um [`FlutterViewController`][`FlutterViewController`].
O `FlutterViewController` usa a instância `FlutterEngine`
criada no `AppDelegate`.

```objc title="ViewController.m"
@import Flutter;
#import "AppDelegate.h"
#import "ViewController.h"

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    // Make a button to call the showFlutter function when pressed.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(showFlutter)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Show Flutter!" forState:UIControlStateNormal];
    button.backgroundColor = UIColor.blueColor;
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:button];
}

- (void)showFlutter {
    FlutterEngine *flutterEngine =
        ((AppDelegate *)UIApplication.sharedApplication.delegate).flutterEngine;
    FlutterViewController *flutterViewController =
        [[FlutterViewController alloc] initWithEngine:flutterEngine nibName:nil bundle:nil];
    [self presentViewController:flutterViewController animated:YES completion:nil];
}
@end
```

Agora, você tem uma tela Flutter incorporada em seu app iOS.

:::note
Usando o exemplo anterior, a função `main()` padrão
do ponto de entrada da sua biblioteca Dart padrão
seria executada ao chamar `run` no
`FlutterEngine` criado no `AppDelegate`.
:::


</Tab>
</Tabs>

### _Alternativamente_ - Crie um FlutterViewController com um FlutterEngine implícito {:#alternatively-create-a-flutterviewcontroller-with-an-implicit-flutterengine}

Como alternativa ao exemplo anterior, você pode deixar o
`FlutterViewController` criar implicitamente seu próprio `FlutterEngine` sem
pré-aquecer um antecipadamente.

Isso geralmente não é recomendado porque criar um
`FlutterEngine` sob demanda pode introduzir uma latência
perceptível entre quando o `FlutterViewController` é
apresentado e quando ele renderiza seu primeiro frame. Isso, no entanto, pode ser
útil se a tela Flutter for raramente mostrada, quando não houver boas
heurísticas para determinar quando a Dart VM deve ser iniciada, e quando o Flutter
não precisa persistir estado entre view controllers.

Para deixar o `FlutterViewController` apresentar sem um
`FlutterEngine` existente, omita a construção do `FlutterEngine`, e crie o
`FlutterViewController` sem uma referência ao engine.

<Tabs key="darwin-framework">
<Tab name="SwiftUI">

```swift title="ContentView.swift"
import SwiftUI
import Flutter

struct FlutterViewControllerRepresentable: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> some UIViewController {
    return FlutterViewController(
      project: nil,
      nibName: nil,
      bundle: nil)
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
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

</Tab>
<Tab name="UIKit-Swift">

```swift title="ViewController.swift"
// Existing code omitted.
func showFlutter() {
  let flutterViewController = FlutterViewController(project: nil, nibName: nil, bundle: nil)
  present(flutterViewController, animated: true, completion: nil)
}
```

</Tab>
<Tab name="UIKit-ObjC">

```objc title="ViewController.m"
// Existing code omitted.
- (void)showFlutter {
  FlutterViewController *flutterViewController =
      [[FlutterViewController alloc] initWithProject:nil nibName:nil bundle:nil];
  [self presentViewController:flutterViewController animated:YES completion:nil];
}
@end
```

</Tab>
</Tabs>

Veja [Sequência de carregamento e desempenho][Loading sequence and performance]
para mais explorações sobre latência e uso de memória.

<a id="using-the-flutterappdelegate" aria-hidden="true"></a>

## Usando FlutterAppDelegate e FlutterSceneDelegate {:#using-flutterappdelegate-and-flutterscenedelegate}

A partir do Flutter 3.41, o suporte a `UIScene` é o padrão para apps iOS,
e a Apple exige que apps UIKit compilados com SDKs iOS recentes
usem o ciclo de vida `UIScene`.

Nesta arquitetura, as responsabilidades são divididas entre dois delegates:

* `FlutterAppDelegate`:
  Lida com eventos do processo e com o ciclo de vida geral do aplicativo
  (como notificações remotas e execução em segundo plano),
  e mantém a conexão de debug do Flutter aberta
  quando o dispositivo é bloqueado.
* `FlutterSceneDelegate`:
  Lida com eventos de UI e do ciclo de vida da cena,
  encaminhando callbacks como [`scene(_:openURLContexts:)`][]
  e [`scene(_:continue:)`][] para plugins
  como [`local_auth`][].

Para garantir que os plugins Flutter recebam todos os eventos de ciclo de vida necessários,
adote tanto o `FlutterAppDelegate` (ou `FlutterAppLifeCycleProvider`)
quanto o `FlutterSceneDelegate` (ou `FlutterSceneLifeCycleProvider`).

Para mais detalhes sobre a migração para o ciclo de vida `UIScene`,
consulte o [guia de migração para UIScene][UIScene migration guide].

### Usando o FlutterAppDelegate {:#using-the-flutterappdelegate}

Criar uma subclasse de `FlutterAppDelegate` no seu `UIApplicationDelegate`
é recomendado, mas não obrigatório.

#### Criar uma subclasse de FlutterAppDelegate {:#create-a-flutterappdelegate-subclass}

Criar uma subclasse do `FlutterAppDelegate` em apps UIKit foi mostrado
na [seção Inicie um FlutterEngine e FlutterViewController][Start a FlutterEngine and FlutterViewController section].

Em um app SwiftUI, você pode criar uma subclasse de `FlutterAppDelegate`,
implementar `application(_:configurationForConnecting:options:)`
para especificar o `FlutterSceneDelegate`,
e anotar a classe com a macro [`Observable()`][`Observable()`]:

```swift title="MyApp.swift"
import SwiftUI
import Flutter
import FlutterPluginRegistrant

@Observable
class AppDelegate: FlutterAppDelegate {
  let flutterEngine = FlutterEngine(name: "my flutter engine")

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Runs the default Dart entrypoint with a default Flutter route.
    flutterEngine.run()
    // Used to connect plugins (only if you have plugins with iOS platform code).
    GeneratedPluginRegistrant.register(with: self.flutterEngine)
    return true
  }

  override func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    let configuration = UISceneConfiguration(
      name: nil,
      sessionRole: connectingSceneSession.role
    )
    configuration.delegateClass = FlutterSceneDelegate.self
    return configuration
  }
}

@main
struct MyApp: App {
  // Use this property wrapper to tell SwiftUI
  // it should use the AppDelegate class for the application delegate.
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
```

Então, na sua view,
o `AppDelegate` é acessível através do ambiente da view.

```swift title="ContentView.swift"
import SwiftUI
import Flutter

struct FlutterViewControllerRepresentable: UIViewControllerRepresentable {
  // Access the AppDelegate through the view environment.
  @Environment(AppDelegate.self) var appDelegate

  func makeUIViewController(context: Context) -> some UIViewController {
    return FlutterViewController(
      engine: appDelegate.flutterEngine,
      nibName: nil,
      bundle: nil
    )
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
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

#### Se você não pode criar uma subclasse de FlutterAppDelegate {:#if-you-cant-subclass-flutterappdelegate}

Se o delegate do seu app não pode ser uma subclasse de `FlutterAppDelegate`,
adote o protocolo `FlutterAppLifeCycleProvider`
e use um `FlutterPluginAppLifeCycleDelegate` para garantir que
os plugins recebam os callbacks no nível do aplicativo.

<Tabs key="darwin-language">
<Tab name="Swift">

```swift title="AppDelegate.swift"
import Foundation
import Flutter

@Observable
class AppDelegate: UIResponder, UIApplicationDelegate, FlutterAppLifeCycleProvider {

  private let lifecycleDelegate = FlutterPluginAppLifeCycleDelegate()

  let flutterEngine = FlutterEngine(name: "my flutter engine")

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    flutterEngine.run()
    return lifecycleDelegate.application(
      application,
      didFinishLaunchingWithOptions: launchOptions ?? [:]
    )
  }

  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    lifecycleDelegate.application(
      application,
      didRegisterForRemoteNotificationsWithDeviceToken: deviceToken
    )
  }

  func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    lifecycleDelegate.application(
      application,
      didFailToRegisterForRemoteNotificationsWithError: error
    )
  }

  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    lifecycleDelegate.application(
      application,
      didReceiveRemoteNotification: userInfo,
      fetchCompletionHandler: completionHandler
    )
  }

  func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    return lifecycleDelegate.application(app, open: url, options: options)
  }

  func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
    return lifecycleDelegate.application(application, handleOpen: url)
  }

  func application(
    _ application: UIApplication,
    open url: URL,
    sourceApplication: String?,
    annotation: Any
  ) -> Bool {
    return lifecycleDelegate.application(
      application,
      open: url,
      sourceApplication: sourceApplication ?? "",
      annotation: annotation
    )
  }

  func application(
    _ application: UIApplication,
    performActionFor shortcutItem: UIApplicationShortcutItem,
    completionHandler: @escaping (Bool) -> Void
  ) {
    lifecycleDelegate.application(
      application,
      performActionFor: shortcutItem,
      completionHandler: completionHandler
    )
  }

  func application(
    _ application: UIApplication,
    handleEventsForBackgroundURLSession identifier: String,
    completionHandler: @escaping () -> Void
  ) {
    lifecycleDelegate.application(
      application,
      handleEventsForBackgroundURLSession: identifier,
      completionHandler: completionHandler
    )
  }

  func application(
    _ application: UIApplication,
    performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    lifecycleDelegate.application(
      application,
      performFetchWithCompletionHandler: completionHandler
    )
  }

  func add(_ delegate: FlutterApplicationLifeCycleDelegate) {
    lifecycleDelegate.add(delegate)
  }
}
```

</Tab>
<Tab name="Objective-C">

```objc title="AppDelegate.h"
@import Flutter;
@import UIKit;
@import FlutterPluginRegistrant;

@interface AppDelegate : UIResponder <UIApplicationDelegate, FlutterAppLifeCycleProvider>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) FlutterEngine *flutterEngine;
@end
```

```objc title="AppDelegate.m"
#import "AppDelegate.h"

@interface AppDelegate ()
@property (nonatomic, strong) FlutterPluginAppLifeCycleDelegate *lifeCycleDelegate;
@end

@implementation AppDelegate

- (instancetype)init {
  if (self = [super init]) {
    _lifeCycleDelegate = [[FlutterPluginAppLifeCycleDelegate alloc] init];
  }
  return self;
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
  self.flutterEngine = [[FlutterEngine alloc] initWithName:@"io.flutter" project:nil];
  [self.flutterEngine runWithEntrypoint:nil];
  [GeneratedPluginRegistrant registerWithRegistry:self.flutterEngine];
  return [_lifeCycleDelegate application:application didFinishLaunchingWithOptions:launchOptions];
}

// Returns the key window's rootViewController, if it's a FlutterViewController.
// Otherwise, returns nil.
- (FlutterViewController *)rootFlutterViewController {
  UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
  if ([viewController isKindOfClass:[FlutterViewController class]]) {
    return (FlutterViewController *)viewController;
  }
  return nil;
}

- (void)application:(UIApplication *)application
    didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
  [_lifeCycleDelegate application:application
      didRegisterUserNotificationSettings:notificationSettings];
}

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [_lifeCycleDelegate application:application
      didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo
          fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
  [_lifeCycleDelegate application:application
     didReceiveRemoteNotification:userInfo
           fetchCompletionHandler:completionHandler];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
  return [_lifeCycleDelegate application:application openURL:url options:options];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
  return [_lifeCycleDelegate application:application handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  return [_lifeCycleDelegate application:application
                                 openURL:url
                       sourceApplication:sourceApplication
                              annotation:annotation];
}

- (void)application:(UIApplication *)application
    performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
               completionHandler:(void (^)(BOOL succeeded))completionHandler {
  [_lifeCycleDelegate application:application
     performActionForShortcutItem:shortcutItem
                completionHandler:completionHandler];
}

- (void)application:(UIApplication *)application
    handleEventsForBackgroundURLSession:(nonnull NSString *)identifier
                      completionHandler:(nonnull void (^)(void))completionHandler {
  [_lifeCycleDelegate application:application
      handleEventsForBackgroundURLSession:identifier
                        completionHandler:completionHandler];
}

- (void)application:(UIApplication *)application
    performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
  [_lifeCycleDelegate application:application performFetchWithCompletionHandler:completionHandler];
}

- (void)addApplicationLifeCycleDelegate:(NSObject<FlutterPlugin> *)delegate {
  [_lifeCycleDelegate addDelegate:delegate];
}
@end
```

</Tab>
</Tabs>

### Usando o FlutterSceneDelegate {:#using-the-flutterscenedelegate}

Assim como com o `FlutterAppDelegate`,
criar uma subclasse de `FlutterSceneDelegate` é recomendado, mas não obrigatório.
O `FlutterSceneDelegate` encaminha callbacks de cena,
como [`scene(_:openURLContexts:)`][] e [`scene(_:continue:)`][],
para plugins como [`local_auth`][].

#### Criar ou atualizar um SceneDelegate {:#create-or-update-a-scenedelegate}

Em apps UIKit, atualize seu `SceneDelegate` para ser uma subclasse de
`FlutterSceneDelegate`:

<Tabs key="ios-framework-switcher">
<Tab name="UIKit-Swift">

```swift title="SceneDelegate.swift" diff
  import UIKit
+ import Flutter

- class SceneDelegate: UIResponder, UIWindowSceneDelegate {
+ class SceneDelegate: FlutterSceneDelegate {
```

</Tab>
<Tab name="UIKit-ObjC">

```objc title="SceneDelegate.h" diff
  #import <UIKit/UIKit.h>
+ #import <Flutter/Flutter.h>

- @interface SceneDelegate : UIResponder <UIWindowSceneDelegate>
+ @interface SceneDelegate : FlutterSceneDelegate
```

</Tab>
<Tab name="SwiftUI">

Em apps SwiftUI, configure a classe do scene delegate
em `application(_:configurationForConnecting:options:)` conforme mostrado no
[exemplo SwiftUI do FlutterAppDelegate][FlutterAppDelegate SwiftUI example].

Se o seu app não suporta múltiplas cenas,
defina **Enable Multiple Scenes** (`UIApplicationSupportsMultipleScenes`)
como **NO** em **Application Scene Manifest** no `Info.plist` do seu target.

</Tab>
</Tabs>

#### Se você não pode criar uma subclasse de FlutterSceneDelegate {:#if-you-cant-subclass-flutterscenedelegate}

Se o seu `SceneDelegate` não pode ser uma subclasse de `FlutterSceneDelegate`,
adote o protocolo `FlutterSceneLifeCycleProvider` e use um
objeto `FlutterPluginSceneLifeCycleDelegate` para encaminhar
eventos do ciclo de vida da cena para o Flutter:

<Tabs key="ios-language-switcher">
<Tab name="Swift">

```swift title="SceneDelegate.swift" diff
  import UIKit
+ import Flutter

- class SceneDelegate: UIResponder, UIWindowSceneDelegate {
+ class SceneDelegate: UIResponder, UIWindowSceneDelegate, FlutterSceneLifeCycleProvider {
+   var sceneLifeCycleDelegate = FlutterPluginSceneLifeCycleDelegate()

    var window: UIWindow?

    func scene(
      _ scene: UIScene,
      willConnectTo session: UISceneSession,
      options connectionOptions: UIScene.ConnectionOptions
    ) {
+     sceneLifeCycleDelegate.scene(
+       scene,
+       willConnectTo: session,
+       options: connectionOptions
+     )
    }

    func sceneDidDisconnect(_ scene: UIScene) {
+     sceneLifeCycleDelegate.sceneDidDisconnect(scene)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
+     sceneLifeCycleDelegate.sceneWillEnterForeground(scene)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
+     sceneLifeCycleDelegate.sceneDidBecomeActive(scene)
    }

    func sceneWillResignActive(_ scene: UIScene) {
+     sceneLifeCycleDelegate.sceneWillResignActive(scene)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
+     sceneLifeCycleDelegate.sceneDidEnterBackground(scene)
    }

    func scene(
      _ scene: UIScene,
      openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
+     sceneLifeCycleDelegate.scene(scene, openURLContexts: URLContexts)
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
+     sceneLifeCycleDelegate.scene(scene, continue: userActivity)
    }

    func windowScene(
      _ windowScene: UIWindowScene,
      performActionFor shortcutItem: UIApplicationShortcutItem,
      completionHandler: @escaping (Bool) -> Void
    ) {
+     sceneLifeCycleDelegate.windowScene(
+       windowScene,
+       performActionFor: shortcutItem,
+       completionHandler: completionHandler
+     )
    }
  }
```

</Tab>
<Tab name="Objective-C">

```objc title="SceneDelegate.h" diff
  #import <UIKit/UIKit.h>
+ #import <Flutter/Flutter.h>

- @interface SceneDelegate : UIResponder <UIWindowSceneDelegate>
+ @interface SceneDelegate : UIResponder <UIWindowSceneDelegate, FlutterSceneLifeCycleProvider>

  @property (strong, nonatomic) UIWindow *window;

+ @property (nonatomic, strong) FlutterPluginSceneLifeCycleDelegate *sceneLifeCycleDelegate;

  @end
```

```objc title="SceneDelegate.m" diff
  #import "SceneDelegate.h"

  @implementation SceneDelegate

  - (instancetype)init {
    if (self = [super init]) {
+     _sceneLifeCycleDelegate = [[FlutterPluginSceneLifeCycleDelegate alloc] init];
    }
    return self;
  }

  - (void)scene:(UIScene *)scene
      willConnectToSession:(UISceneSession *)session
                   options:(UISceneConnectionOptions *)connectionOptions {
+   [self.sceneLifeCycleDelegate scene:scene willConnectToSession:session options:connectionOptions];
  }

  - (void)sceneDidDisconnect:(UIScene *)scene {
+   [self.sceneLifeCycleDelegate sceneDidDisconnect:scene];
  }

  - (void)sceneDidBecomeActive:(UIScene *)scene {
+   [self.sceneLifeCycleDelegate sceneDidBecomeActive:scene];
  }

  - (void)sceneWillResignActive:(UIScene *)scene {
+   [self.sceneLifeCycleDelegate sceneWillResignActive:scene];
  }

  - (void)sceneWillEnterForeground:(UIScene *)scene {
+   [self.sceneLifeCycleDelegate sceneWillEnterForeground:scene];
  }

  - (void)sceneDidEnterBackground:(UIScene *)scene {
+   [self.sceneLifeCycleDelegate sceneDidEnterBackground:scene];
  }

  - (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
+   [self.sceneLifeCycleDelegate scene:scene openURLContexts:URLContexts];
  }

  - (void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity {
+   [self.sceneLifeCycleDelegate scene:scene continueUserActivity:userActivity];
  }

  - (void)windowScene:(UIWindowScene *)windowScene
      performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
                 completionHandler:(void (^)(BOOL))completionHandler {
+   [self.sceneLifeCycleDelegate windowScene:windowScene
+               performActionForShortcutItem:shortcutItem
+                          completionHandler:completionHandler];
  }

  @end
```

</Tab>
</Tabs>

## Opções de lançamento {:#launch-options}

Os exemplos demonstram executar Flutter usando as configurações de lançamento padrão.

Para personalizar seu runtime Flutter,
você também pode especificar o ponto de entrada Dart, biblioteca e rota.

### Ponto de entrada Dart {:#dart-entrypoint}

Chamar `run` em um `FlutterEngine`, por padrão,
executa a função Dart `main()`
do seu arquivo `lib/main.dart`.

Você também pode executar uma função de ponto de entrada diferente usando
[`runWithEntrypoint`][`runWithEntrypoint`] com uma `NSString` especificando
uma função Dart diferente.

:::note
Funções de ponto de entrada Dart diferentes de `main()`
devem ser anotadas com o seguinte para
não serem [removidas por tree-shaking][tree-shaken] ao compilar:

```dart
@pragma('vm:entry-point')
void myOtherEntrypoint() { ... };
```
:::

### Biblioteca Dart {:#dart-library}

Além de especificar uma função Dart, você pode especificar uma função
de ponto de entrada em um arquivo específico.

Por exemplo, o seguinte executa `myOtherEntrypoint()`
em `lib/other_file.dart` em vez de `main()` em `lib/main.dart`:

<Tabs key="darwin-language">
<Tab name="Swift">

```swift
flutterEngine.run(withEntrypoint: "myOtherEntrypoint", libraryURI: "other_file.dart")
```

</Tab>
<Tab name="Objective-C">

```objc
[flutterEngine runWithEntrypoint:@"myOtherEntrypoint" libraryURI:@"other_file.dart"];
```

</Tab>
</Tabs>


### Rota {:#route}

A partir da versão 1.22 do Flutter, uma rota inicial pode ser definida para seu
[`WidgetsApp`][`WidgetsApp`] Flutter ao construir o FlutterEngine ou o
FlutterViewController.

<Tabs key="darwin-language">
<Tab name="Swift">

```swift
let flutterEngine = FlutterEngine()
// FlutterDefaultDartEntrypoint is the same as nil, which will run main().
engine.run(
  withEntrypoint: "main", initialRoute: "/onboarding")
```

</Tab>
<Tab name="Objective-C">

```objc
FlutterEngine *flutterEngine = [[FlutterEngine alloc] init];
// FlutterDefaultDartEntrypoint is the same as nil, which will run main().
[flutterEngine runWithEntrypoint:FlutterDefaultDartEntrypoint
                    initialRoute:@"/onboarding"];
```

</Tab>
</Tabs>

Este código define o [`PlatformDispatcher.defaultRouteName`][`PlatformDispatcher.defaultRouteName`] do seu `dart:ui`
para `"/onboarding"` em vez de `"/"`.

Alternativamente, para construir um FlutterViewController diretamente sem pré-aquecer
um FlutterEngine:

<Tabs key="darwin-language">
<Tab name="Swift">

```swift
let flutterViewController = FlutterViewController(
      project: nil, initialRoute: "/onboarding", nibName: nil, bundle: nil)
```

</Tab>
<Tab name="Objective-C">

```objc
FlutterViewController* flutterViewController =
      [[FlutterViewController alloc] initWithProject:nil
                                        initialRoute:@"/onboarding"
                                             nibName:nil
                                              bundle:nil];
```

</Tab>
</Tabs>

:::tip
Para alterar imperativamente sua rota Flutter atual
do lado da plataforma depois que o `FlutterEngine`
já está em execução, use [`pushRoute()`][`pushRoute()`]
ou [`popRoute()`][`popRoute()`] no `FlutterViewController`.

Para fazer pop na rota iOS do lado Flutter,
chame [`SystemNavigator.pop()`][`SystemNavigator.pop()`].
:::

Veja [Navegação e roteamento][Navigation and routing] para mais sobre rotas do Flutter.

### Outros {:#other}

O exemplo anterior ilustra apenas algumas maneiras de personalizar
como uma instância Flutter é iniciada. Usando [canais de plataforma][platform channels],
você é livre para enviar dados ou preparar seu ambiente Flutter
da maneira que desejar, antes de apresentar a UI Flutter usando um
`FlutterViewController`.

## Views dimensionadas pelo conteúdo {:#content-sized-views}

No iOS,
você também pode configurar sua `FlutterView` incorporada para se dimensionar com base em seu
conteúdo.

<Tabs key="darwin-language">
<Tab name="Swift">

```swift
let flutterViewController = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
flutterViewController.isAutoResizable = true
```

</Tab>
<Tab name="Objective-C">

```objc
_flutterViewController = [[FlutterViewController alloc] initWithEngine:engine nibName:nil bundle:nil];
_flutterViewController.autoResizable = YES;
```

</Tab>
</Tabs>

### Restrições {:#restrictions}

Para usar isso, seu widget raiz deve suportar constraints ilimitadas.
Evite usar widgets que exigem constraints limitadas (como `ListView` ou
`LayoutBuilder`) no topo da sua árvore,
pois eles podem entrar em conflito com a lógica de dimensionamento dinâmico.

Na prática, isso significa que vários widgets comuns não são suportados,
como `ScaffoldBuilder`, `CupertinoTimerPicker`,
ou qualquer widget que dependa internamente de um `LayoutBuilder`.
Em caso de dúvida, você pode usar um `UnconstrainedBox` para testar a usabilidade de
um widget em uma view dimensionada pelo conteúdo, como no exemplo a seguir:

```dart
import 'package:material_ui/material_ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  => MaterialApp(home: MyPage());
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: UnconstrainedBox(
          // TODO: Edit this line to check if a widget
          // can cause problems with content-sized views.
          child: Text('This works!'),
          // child: Column(children: [Column(children: [Expanded(child: Text('This blows up!'))])]),
          // child: ListView(children: [Text('This blows up!')]),
        )
    );
  }
}
```
Para um exemplo funcional, consulte este [projeto de exemplo][sample project].

[`FlutterEngine`]: {{site.api}}/ios-embedder/interface_flutter_engine.html
[`FlutterViewController`]:
{{site.api}}/ios-embedder/interface_flutter_view_controller.html
[Loading sequence and performance]: /add-to-app/performance
[local_auth]: {{site.pub}}/packages/local_auth
[Navigation and routing]: /ui/navigation
[Navigator]: {{site.api}}/flutter/widgets/Navigator-class.html
[`NavigatorState`]: {{site.api}}/flutter/widgets/NavigatorState-class.html
[`openURL`]:
{{site.apple-dev}}/documentation/uikit/uiapplicationdelegate/1623112-application
[platform channels]: /platform-integration/platform-channels
[`popRoute()`]:
{{site.api}}/ios-embedder/interface_flutter_view_controller.html#ac89c8010fbf7a39f7aaab64f68c013d2
[`pushRoute()`]:
{{site.api}}/ios-embedder/interface_flutter_view_controller.html#ac7cffbf03f9c8c0b28d1f0dafddece4e
[`runApp`]: {{site.api}}/flutter/widgets/runApp.html
[`runWithEntrypoint`]:
{{site.api}}/ios-embedder/interface_flutter_engine.html#a019d6b3037eff6cfd584fb2eb8e9035e
[`SystemNavigator.pop()`]:
{{site.api}}/flutter/services/SystemNavigator/pop.html
[`scene(_:openURLContexts:)`]:
{{site.apple-dev}}/documentation/uikit/uiscenedelegate/scene(_:openurlcontexts:)
[`scene(_:continue:)`]:
{{site.apple-dev}}/documentation/uikit/uiscenedelegate/scene(_:continue:)
[UIScene migration guide]:
/release/breaking-changes/uiscenedelegate#migration-guide-for-adding-flutter-to-existing-app-add-to-app
[FlutterAppDelegate SwiftUI example]: #create-a-flutterappdelegate-subclass
[`local_auth`]: {{site.pub}}/packages/local_auth
[tree-shaken]: https://en.wikipedia.org/wiki/Tree_shaking
[`WidgetsApp`]: {{site.api}}/flutter/widgets/WidgetsApp-class.html
[`PlatformDispatcher.defaultRouteName`]:
{{site.api}}/flutter/dart-ui/PlatformDispatcher/defaultRouteName.html
[Start a FlutterEngine and FlutterViewController section]: /add-to-app/ios/add-flutter-screen#start-a-flutterengine-and-flutterviewcontroller
[`Observable`]: {{site.apple-dev}}/documentation/observation/observable
[`NavigationLink`]: {{site.apple-dev}}/documentation/swiftui/navigationlink
[`Observable()`]: {{site.apple-dev}}/documentation/observation/observable()
[sample project]:
{{site.repo.samples}}/tree/main/add_to_app/ios_content_resizing
