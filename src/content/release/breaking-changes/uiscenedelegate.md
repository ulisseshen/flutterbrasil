---
ia-translate: true
title: Adoção do UISceneDelegate
description: >
  Um guia para desenvolvedores Flutter iOS adotarem o protocolo UISceneDelegate da Apple.
---

{% render "docs/breaking-changes.md" %}

:::note
Esta é uma breaking change futura que ainda não foi finalizada ou
implementada. Os detalhes atuais são provisórios e podem ser alterados. Novos
anúncios serão feitos conforme a mudança se aproxima da implementação.
:::

## Resumo

A Apple agora exige que desenvolvedores iOS adotem o ciclo de vida UIScene.
Esta migração tem implicações na [sequência de lançamento do
app]({{site.apple-dev}}/documentation/uikit/about-the-app-launch-sequence)
e no [ciclo de vida do
app]({{site.apple-dev}}/documentation/uikit/managing-your-app-s-life-cycle).

## Contexto

Durante a WWDC25, a Apple
[anunciou]({{site.apple-dev}}/videos/play/wwdc2025/243/?time=1317)
o seguinte:
> No lançamento seguinte ao iOS 26, qualquer app UIKit compilado com o SDK mais recente será
> obrigado a usar o ciclo de vida UIScene, caso contrário não será iniciado.

Para usar o ciclo de vida UIScene com Flutter, migre o seguinte suporte:
* Todos os apps Flutter que suportam iOS - Veja o [guia de migração para apps
  Flutter](/release/breaking-changes/uiscenedelegate/#migration-guide-for-flutter-apps)
* Flutter embarcado em apps nativos iOS - Veja o [guia de migração para adicionar
  Flutter a um app
  existente](/release/breaking-changes/uiscenedelegate/#migration-guide-for-adding-flutter-to-existing-app-add-to-app)
* Plugins Flutter que usam eventos do ciclo de vida da aplicação iOS - Veja o [guia de migração para
  plugins](/release/breaking-changes/uiscenedelegate/#migration-guide-for-flutter-plugins)

Migrar para UIScene altera o papel do AppDelegate—o ciclo de vida da UI agora é
gerenciado pelo UISceneDelegate. O AppDelegate
permanece responsável por eventos de processo e pelo ciclo de vida geral da aplicação. Toda a lógica relacionada à UI deve ser movida do AppDelegate para os
métodos UISceneDelegate correspondentes. Após migrar para UIScene,
o UIKit não chamará mais métodos do AppDelegate relacionados ao estado da UI.

## Guia de migração para apps Flutter {:#migration-guide-for-flutter-apps}

### Auto-Migração (Experimental)

A CLI do Flutter pode migrar automaticamente seu app se o AppDelegate não foi
customizado.

1. Habilite a funcionalidade de migração UIScene

```console
flutter config --enable-uiscene-migration
```

2. Compile ou execute seu app

```console
flutter run
ou
flutter build ios
```

Se a migração for bem-sucedida, você verá um log que diz "Finished migration to
UIScene lifecycle". Caso contrário, ele avisará para migrar manualmente usando as
instruções incluídas. Se a migração for bem-sucedida, nenhuma ação adicional é necessária!

### Migrar AppDelegate

Anteriormente, plugins Flutter eram registrados em
`application:didFinishLaunchingWithOptions:`. Para acomodar a nova sequência de lançamento do
app, o registro de plugins agora deve ser tratado em um novo callback chamado
`didInitializeImplicitFlutterEngine`.

1. Adicione `FlutterImplicitEngineDelegate` e mova `GeneratedPluginRegistrant`.

```swift  title="my_app/ios/Runner/AppDelegate.swift" diff
- @objc class AppDelegate: FlutterAppDelegate {
+ @objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
    override func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
-     GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
  }

+ func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
+   GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
+ }
}
```
```objc title="my_app/ios/Runner/AppDelegate.h" diff
- @interface AppDelegate : FlutterAppDelegate
+ @interface AppDelegate : FlutterAppDelegate <FlutterImplicitEngineDelegate>
```
```objc title="my_app/ios/Runner/AppDelegate.m" diff
  - (BOOL)application:(UIApplication *)application
      didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
-    [GeneratedPluginRegistrant registerWithRegistry:self];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
  }

+ - (void)didInitializeImplicitFlutterEngine:(NSObject<FlutterImplicitEngineBridge>*)engineBridge {
+   [GeneratedPluginRegistrant registerWithRegistry:engineBridge.pluginRegistry];
+ }
```

2. Crie method channels e platform views em
`didInitializeImplicitFlutterEngine`, se aplicável.

Se você criou anteriormente [method channels][platform-views-docs] ou
[platform views][platform-views-docs] em
`application:didFinishLaunchingWithOptions:`,
mova essa lógica para `didInitializeImplicitFlutterEngine`.

```swift
  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    // Register plugins with `engineBridge.pluginRegistry`
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    // Create method channels with `engineBridge.applicationRegistrar.messenger()`
    let batteryChannel = FlutterMethodChannel(
      name: "samples.flutterbrasil.dev/battery",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )

    // Create platform views with `engineBridge.applicationRegistrar.messenger()`
    let factory = FLNativeViewFactory(messenger: engineBridge.applicationRegistrar.messenger())
  }
```

```objc
  func didInitializeImplicitFlutterEngine:(NSObject<FlutterImplicitEngineBridge>*)engineBridge {
    // Register plugins with `engineBridge.pluginRegistry`
    [GeneratedPluginRegistrant registerWithRegistry:engineBridge.pluginRegistry];

    // Create method channels with `engineBridge.applicationRegistrar.messenger`
    FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
                                          methodChannelWithName:@"samples.flutterbrasil.dev/battery"
                                          binaryMessenger:engineBridge.applicationRegistrar.messenger];

    // Create platform views with `engineBridge.applicationRegistrar.messenger`
    FLNativeViewFactory* factory =
      [[FLNativeViewFactory alloc] initWithMessenger:engineBridge.applicationRegistrar.messenger];
  }
```

:::warning
Se você tentar acessar o `FlutterViewController` em
`application:didFinishLaunchingWithOptions:`, isso pode resultar em um crash.
Use o protocolo `FlutterImplicitEngineDelegate` em vez disso.

```swift
// BAD
let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
```

Para acessar o `FlutterViewController` diretamente, visite
[Uso customizado de
FlutterViewController](/release/breaking-changes/uiscenedelegate/#bespoke-flutterviewcontroller-usage).
:::

3. Migre qualquer lógica customizada dentro dos eventos do ciclo de vida da aplicação.

A Apple descontinuou eventos do ciclo de vida da aplicação relacionados ao estado da UI. Após
migrar para o ciclo de vida UIScene, o UIKit não chamará mais esses eventos.

Se você estava usando uma dessas APIs descontinuadas, como
[`applicationDidBecomeActive`]({{site.apple-dev}}/documentation/uikit/uiapplicationdelegate/applicationdidbecomeactive(_:)),
provavelmente você precisará criar um SceneDelegate e migrar para os eventos do ciclo de vida
de cena. Veja a [documentação da
Apple]({{site.apple-dev}}/documentation/technotes/tn3187-migrating-to-the-uikit-scene-based-life-cycle)
sobre migração.

Se você implementar seu próprio SceneDelegate, você deve criar uma subclasse dele com
`FlutterSceneDelegate` ou estar em conformidade com o protocolo `FlutterSceneLifeCycleProvider`.
Veja os [exemplos a
seguir](/release/breaking-changes/uiscenedelegate/#createupdate-a-scenedelegate-uikit).

### Migrar Info.plist

Para completar a migração para o ciclo de vida UIScene, adicione um `Application Scene
Manifest` ao seu Info.plist.

Como visto no editor do Xcode:

![Editor plist do Xcode para
UIApplicationSceneManifest](/assets/images/docs/breaking-changes/uiscenedelegate-plist.png)

Como XML:

```xml title="Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "https://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
 <key>UIApplicationSceneManifest</key>
 <dict>
  <key>UIApplicationSupportsMultipleScenes</key>
  <false/>
  <key>UISceneConfigurations</key>
  <dict>
  <key>UIWindowSceneSessionRoleApplication</key>
    <array>
      <dict>
        <key>UISceneClassName</key>
        <string>UIWindowScene</string>
        <key>UISceneDelegateClassName</key>
        <string>FlutterSceneDelegate</string>
        <key>UISceneConfigurationName</key>
        <string>flutter</string>
        <key>UISceneStoryboardFile</key>
        <string>Main</string>
      </dict>
    </array>
   </dict>
 </dict>
</dict>
```

### Criar um SceneDelegate (Opcional)

Se você precisar de acesso ao `SceneDelegate`, você pode criar um criando uma
subclasse de `FlutterSceneDelegate`.

1. Abra seu app no Xcode
2. Clique com o botão direito na pasta **Runner** e selecione **New Empty File**

![Opção New Empty File no Xcode](/assets/images/docs/breaking-changes/uiscene-new-file.png)

Para projetos Swift, crie um `SceneDelegate.swift`:

```swift title=my_app/ios/Runner/SceneDelegate.swift
import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {

}
```

Para projetos Objective-C, crie um `SceneDelegate.h` e `SceneDelegate.m`:

```objc title=my_app/ios/Runner/SceneDelegate.h
#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>

@interface SceneDelegate : FlutterSceneDelegate

@end
```

```objc title=my_app/ios/Runner/SceneDelegate.m
#import "SceneDelegate.h"

@implementation SceneDelegate

@end
```

3. Altere o "Delegate Class Name" (`UISceneDelegateClassName`) no
Info.plist de `FlutterSceneDelegate` para
`$(PRODUCT_MODULE_NAME).SceneDelegate`.

## Guia de migração para adicionar Flutter a app existente (Add to App) {:#migration-guide-for-adding-flutter-to-existing-app-add-to-app}

Semelhante ao `FlutterAppDelegate`, o `FlutterSceneDelgate` é recomendado
mas não obrigatório. O `FlutterSceneDelgate` encaminha callbacks de cena, como
[`openURL`][`openURL`] para plugins como [local_auth][local_auth].

### Criar/Atualizar um SceneDelegate (UIKit) {:#createupdate-a-scenedelegate-uikit}

```swift diff
  import UIKit
+ import Flutter

- class SceneDelegate: UIResponder, UIWindowSceneDelegate {
+ class SceneDelegate: FlutterSceneDelegate {
```

```objc diff
- @interface SceneDelegate : UIResponder <UIWindowSceneDelegate>
+ @interface SceneDelegate : FlutterSceneDelegate
```


### Criar/Atualizar um SceneDelegate (SwiftUI)

Ao usar Flutter em um app SwiftUI, você pode [opcionalmente usar um
FlutterAppDelegate](/add-to-app/ios/add-flutter-screen#using-the-flutterappdelegate)
para receber eventos da aplicação. Para migrar isso para usar eventos UIScene, você pode
fazer as seguintes alterações:

1. Defina o Scene Delegate como `FlutterSceneDelegate` em
`application:configurationForConnecting:options:`.

```swift diff
  @Observable
  class AppDelegate: FlutterAppDelegate {
    ...
+   override func application(
+     _ application: UIApplication,
+     configurationForConnecting connectingSceneSession: UISceneSession,
+     options: UIScene.ConnectionOptions
+   ) -> UISceneConfiguration {
+     let configuration = UISceneConfiguration(
+       name: nil,
+       sessionRole: connectingSceneSession.role
+     )
+     configuration.delegateClass = FlutterSceneDelegate.self
+     return configuration
+   }
  }
```

2. Se seu app não suporta múltiplas cenas, defina `Enable Multiple Scenes`
como `NO` em `Application Scene Manifest` nas propriedades Info do seu target.
Isso é habilitado por padrão para apps SwiftUI.

![Editor plist do Xcode para
UIApplicationSceneManifest](/assets/images/docs/breaking-changes/uiscenedelegate-swiftui-info-plist.png)

Caso contrário, veja [Se seu app suporta múltiplas
cenas](/release/breaking-changes/uiscenedelegate/#if-your-app-supports-multiple-scenes)
para mais instruções.
### Se você não pode tornar FlutterSceneDelegate diretamente uma subclasse

Se você não pode tornar `FlutterSceneDelegate` diretamente uma subclasse, você pode usar o
protocolo `FlutterSceneLifeCycleProvider` e o
objeto `FlutterPluginSceneLifeCycleDelegate` para encaminhar eventos do ciclo de vida de cena
para o Flutter.

```swift title="SceneDelegate.swift" diff
  import Flutter
  import UIKit

- class SceneDelegate: UIResponder, UIWindowSceneDelegate
+ class SceneDelegate: UIResponder, UIWindowSceneDelegate, FlutterSceneLifeCycleProvider
  {
+   var sceneLifeCycleDelegate: FlutterPluginSceneLifeCycleDelegate =
+     FlutterPluginSceneLifeCycleDelegate()

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
```objc title="SceneDelegate.h" diff
- @interface SceneDelegate : UIResponder <UIWindowSceneDelegate>
+ @interface SceneDelegate : UIResponder <UIWindowSceneDelegate, FlutterSceneLifeCycleProvider>

  @property(strong, nonatomic) UIWindow* window;

+ @property (nonatomic,strong) FlutterPluginSceneLifeCycleDelegate *sceneLifeCycleDelegate;

  @end
```
```objc title="SceneDelegate.m" diff
  @implementation SceneDelegate

  - (instancetype)init {
      if (self = [super init]) {
+         _sceneLifeCycleDelegate = [[FlutterPluginSceneLifeCycleDelegate alloc] init];
      }
      return self;
  }

  - (void)scene:(UIScene*)scene
      willConnectToSession:(UISceneSession*)session
                  options:(UISceneConnectionOptions*)connectionOptions {
+   [self.sceneLifeCycleDelegate scene:scene willConnectToSession:session options:connectionOptions];
  }

  - (void)sceneDidDisconnect:(UIScene*)scene {
+   [self.sceneLifeCycleDelegate sceneDidDisconnect:scene];
  }

  - (void)sceneDidBecomeActive:(UIScene*)scene {
+   [self.sceneLifeCycleDelegate sceneDidBecomeActive:scene];
  }

  - (void)sceneWillResignActive:(UIScene*)scene {
+   [self.sceneLifeCycleDelegate sceneWillResignActive:scene];
  }

  - (void)sceneWillEnterForeground:(UIScene*)scene {
+   [self.sceneLifeCycleDelegate sceneWillEnterForeground:scene];
  }

  - (void)sceneDidEnterBackground:(UIScene*)scene {
+   [self.sceneLifeCycleDelegate sceneDidEnterBackground:scene];
  }

  - (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
+   [self.sceneLifeCycleDelegate scene:scene openURLContexts:URLContexts];
  }

  - (void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity {
+   [self.sceneLifeCycleDelegate scene:scene continueUserActivity:userActivity];
  }

  - (void)windowScene:(UIWindowScene *)windowScene performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
+   [self.sceneLifeCycleDelegate windowScene:windowScene performActionForShortcutItem:shortcutItem completionHandler:completionHandler];
  }
```

### Se seu app suporta múltiplas cenas {:#if-your-app-supports-multiple-scenes}

Quando múltiplas cenas estão habilitadas (UIApplicationSupportsMultipleScenes), o Flutter não pode automaticamente associar um
`FlutterEngine` com uma cena durante a fase de conexão da cena. Para que
os plugins recebam informações de conexão de lançamento, o `FlutterEngine` deve ser
registrado manualmente com o `FlutterSceneDelegate` ou
`FlutterPluginSceneLifeCycleDelegate` durante
`scene:willConnectToSession:options:`. Caso contrário, uma vez que a view, criada pelo
`FlutterViewController` e `FlutterEngine`, seja adicionada à hierarquia de view,
o `FlutterEngine` se registrará automaticamente para eventos de cena.

```swift title="SceneDelegate.swift"
import Flutter
import FlutterPluginRegistrant
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  let flutterEngine = FlutterEngine(name: "my flutter engine")

  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = scene as? UIWindowScene else { return }
    window = UIWindow(windowScene: windowScene)

    flutterEngine.run()
    GeneratedPluginRegistrant.register(with: flutterEngine)

    // If using FlutterSceneDelegate:
    self.registerSceneLifeCycle(with: flutterEngine)

    // If using FlutterSceneLifeCycleProvider:
    // sceneLifeCycleDelegate.registerSceneLifeCycle(with: flutterEngine)

    let viewController = ViewController(engine: flutterEngine)
    window?.rootViewController = viewController
    window?.makeKeyAndVisible()
    super.scene(scene, willConnectTo: session, options: connectionOptions)
  }
}
```
```objc title="SceneDelegate.h"
#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>

@interface SceneDelegate : FlutterSceneDelegate
@property (nonatomic, strong) FlutterEngine *flutterEngine;
@end
```
```objc title="SceneDelegate.m"
#import "SceneDelegate.h"
#import "ViewController.h"

@implementation SceneDelegate

  - (instancetype)init {
      if (self = [super init]) {
         _flutterEngine = [[FlutterEngine alloc] initWithName:@"my flutter engine"];
      }
      return self;
  }

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session
                                            options:(UISceneConnectionOptions *)connectionOptions {
    if (![scene isKindOfClass:[UIWindowScene class]]) {
        return;
    }
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];

    [self.flutterEngine run];
    [GeneratedPluginRegistrant registerWithRegistry:self.flutterEngine];

    // If using FlutterSceneDelegate:
    [self registerSceneLifeCycleWithFlutterEngine:self.flutterEngine];

    // If using FlutterSceneLifeCycleProvider:
    // [self.sceneLifeCycleDelegate registerSceneLifeCycleWithFlutterEngine:self.flutterEngine];

    ViewController *viewController = [[ViewController alloc] initWithEngine:self.flutterEngine];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    [super scene:scene willConnectToSession:session options:connectionOptions];
}
@end
```

Se você registrar manualmente um `FlutterEngine` com uma cena, você também deve
cancelar o registro se a view criada pelo `FlutterEngine` mudar de cena.

```swift
// If using FlutterSceneDelegate:
self.unregisterSceneLifeCycle(with: flutterEngine)

// If using FlutterSceneLifeCycleProvider:
sceneLifeCycleDelegate.unregisterSceneLifeCycle(with: flutterEngine)
```

```objc
// If using FlutterSceneDelegate:
[self unregisterSceneLifeCycleWithFlutterEngine:self.flutterEngine];

// If using FlutterSceneLifeCycleProvider:
[self.sceneLifeCycleDelegate unregisterSceneLifeCycleWithFlutterEngine:self.flutterEngine];
```

## Guia de migração para plugins Flutter {:#migration-guide-for-flutter-plugins}

Nem todos os plugins usam eventos de ciclo de vida. Se o seu plugin usa, porém, você precisará
migrar para o ciclo de vida baseado em cena do UIKit.

1. Atualize as versões do Dart e Flutter SDK no seu pubspec.yaml

```yaml
environment:
  sdk: ^3.10.0-290.1.beta
  flutter: ">=3.38.0-0.1.pre"
```

:::warning
As APIs Flutter abaixo estão disponíveis no beta 3.38.0-0.1.pre, mas ainda não estão
disponíveis na versão stable. Você pode considerar publicar uma
[prerelease](https://dartbrasil.dev/tools/pub/publishing#publishing-prereleases) ou
[preview](https://dartbrasil.dev/tools/pub/publishing#publish-preview-versions)
versão do seu plugin para migrar antecipadamente.
:::

2. Adote o protocolo `FlutterSceneLifeCycleDelegate`

```swift diff
- public final class MyPlugin: NSObject, FlutterPlugin {
+ public final class MyPlugin: NSObject, FlutterPlugin, FlutterSceneLifeCycleDelegate {
```

```objc diff
- @interface MyPlugin : NSObject<FlutterPlugin>
+ @interface MyPlugin : NSObject<FlutterPlugin, FlutterSceneLifeCycleDelegate>
```

3. Registre o plugin como receptor de chamadas `UISceneDelegate`.

Para continuar suportando apps que ainda não migraram para o ciclo de vida UIScene,
você pode considerar permanecer registrado no App Delegate e manter os eventos do App
Delegate também.

```swift diff
  public static func register(with registrar: FlutterPluginRegistrar) {
    ...
    registrar.addApplicationDelegate(instance)
+   registrar.addSceneDelegate(instance)
  }
```

```objc diff
  + (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    ...
    [registrar addApplicationDelegate:instance];
+   [registrar addSceneDelegate:instance];
  }
```

4. Adicione um ou mais dos seguintes eventos de cena que são necessários para seu
plugin.

A maioria dos eventos de UI do App Delegate tem uma substituição 1-para-1. Para ver detalhes de cada
evento, visite a documentação da Apple sobre
[`UISceneDelegate`][`UISceneDelegate`] e [`UIWindowSceneDelegate`][`UIWindowSceneDelegate`].

[`UISceneDelegate`]: {{site.apple-dev}}/documentation/uikit/uiscenedelegate
[`UIWindowSceneDelegate`]: {{site.apple-dev}}/documentation/uikit/uiwindowscenedelegate


```swift
public func scene(
  _ scene: UIScene,
  willConnectTo session: UISceneSession,
  options connectionOptions: UIScene.ConnectionOptions?
) -> Bool { }

public func sceneDidDisconnect(_ scene: UIScene) { }

public func sceneWillEnterForeground(_ scene: UIScene) { }

public func sceneDidBecomeActive(_ scene: UIScene) { }

public func sceneWillResignActive(_ scene: UIScene) { }

public func sceneDidEnterBackground(_ scene: UIScene) { }

public func scene(
    _ scene: UIScene,
    openURLContexts URLContexts: Set<UIOpenURLContext>
  ) -> Bool { }

public func scene(_ scene: UIScene, continue userActivity: NSUserActivity)
    -> Bool { }

public func windowScene(
    _ windowScene: UIWindowScene,
    performActionFor shortcutItem: UIApplicationShortcutItem,
    completionHandler: @escaping (Bool) -> Void
  ) -> Bool { }
```

```objc
- (BOOL)scene:(UIScene*)scene
    willConnectToSession:(UISceneSession*)session
                 options:(nullable UISceneConnectionOptions*)connectionOptions { }

- (void)sceneDidDisconnect:(UIScene*)scene { }

- (void)sceneWillEnterForeground:(UIScene*)scene { }

- (void)sceneDidBecomeActive:(UIScene*)scene { }

- (void)sceneWillResignActive:(UIScene*)scene { }

- (void)sceneDidEnterBackground:(UIScene*)scene { }

- (BOOL)scene:(UIScene*)scene openURLContexts:(NSSet<UIOpenURLContext*>*)URLContexts { }

- (BOOL)scene:(UIScene*)scene continueUserActivity:(NSUserActivity*)userActivity { }

- (BOOL)windowScene:(UIWindowScene*)windowScene
    performActionForShortcutItem:(UIApplicationShortcutItem*)shortcutItem
               completionHandler:(void (^)(BOOL succeeded))completionHandler { }
```

5. Mova a lógica de lançamento de `application:willFinishLaunchingWithOptions:` e
`application:didFinishLaunchingWithOptions:` para
`scene:willConnectToSession:options:`.

Apesar de `application:willFinishLaunchingWithOptions:` e
`application:didFinishLaunchingWithOptions:` não estarem descontinuados, após
migrar para o ciclo de vida `UIScene`, as opções de lançamento serão `nil`. Qualquer lógica
executada aqui relacionada às opções de lançamento deve ser movida para o
evento `scene:willConnectToSession:options:`.

## Uso customizado de FlutterViewController {:#bespoke-flutterviewcontroller-usage}

Para apps que usam um `FlutterViewController` instanciado a partir de Storyboards em
`application:didFinishLaunchingWithOptions:` por razões diferentes de
criar platform channels, é responsabilidade deles
acomodar a nova ordem de inicialização.

Opções de migração:

- Criar subclasse de `FlutterViewController` e colocar a lógica no
  `awakeFromNib` da subclasse.
- Especificar um `UISceneDelegate` no `Info.plist` ou
  no `UIApplicationDelegate` e
  colocar a lógica em `scene:willConnectToSession:options:`.
  Para mais informações, confira a [documentação da Apple][apple-delegate-docs].

[apple-delegate-docs]: {{site.apple-dev}}/documentation/uikit/specifying-the-scenes-your-app-supports

#### Exemplo

```swift
@objc class MyViewController: FlutterViewController {
  override func awakeFromNib() {
    self.awakeFromNib()
    doSomethingWithFlutterViewController(self)
  }
}
```

## Ocultar aviso de migração
Para ocultar o aviso da CLI do Flutter sobre migrar para UIScene, adicione o seguinte
ao seu pubspec.yaml:

```yaml file="pubspec.yaml" diff
  flutter:
    config:
+     enable-uiscene-migration: false
```


## Cronograma

- Incluído na main: A definir
- Incluído na stable: A definir
- Desconhecido: A Apple muda seu aviso para um assert e apps Flutter que
  não adotaram `UISceneDelegate` começarão a travar na inicialização com o
  SDK mais recente.

## Referências

- [Issue 167267][Issue 167267] - A issue inicial relatada.

[Issue 167267]: {{site.github}}/flutter/flutter/issues/167267
[apple-delegate-docs]: {{site.apple-dev}}/documentation/uikit/specifying-the-scenes-your-app-supports
[method-channels-docs]: /platform-integration/platform-channels
[platform-views-docs]: /platform-integration/ios/platform-views
[`openURL`]: {{site.apple-dev}}/documentation/uikit/uiapplicationdelegate/1623112-application
[local_auth]: {{site.pub}}/packages/local_auth
