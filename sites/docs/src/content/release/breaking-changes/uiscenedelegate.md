---
ia-translate: true
title: Adoção do UIScene
description: >-
  Aprenda como migrar seu app Flutter iOS, sua integração add-to-app ou seu plugin
  para o ciclo de vida UIScene exigido pela Apple.
---

{% render "docs/breaking-changes.md" %}

:::important
A partir da versão 3.41 do Flutter,
o suporte a `UIScene` é o padrão para apps iOS, e
apps elegíveis são migrados automaticamente.
:::

:::version-note
A partir do Xcode 27 (iOS 27 SDK), a Apple exige o ciclo de vida `UIScene`
para apps UIKit. Apps Flutter compilados com o Xcode 27 que
não adotarem `UIScene` falham ao iniciar.

No Flutter 3.41 e posteriores, se seu projeto usa um `AppDelegate` não modificado,
o Flutter o migra automaticamente. Se seu projeto usa um `AppDelegate` customizado
ou uma versão do Flutter anterior à 3.41, conclua os seguintes passos de
migração manual.
:::

## Resumo {:#summary}

A Apple agora exige que desenvolvedores iOS adotem o ciclo de vida `UIScene`.
Esta migração tem implicações na
[sequência de lançamento do app][app launch sequence] e no [ciclo de vida do app][app lifecycle].

[app launch sequence]: {{site.apple-dev}}/documentation/uikit/about-the-app-launch-sequence
[app lifecycle]: {{site.apple-dev}}/documentation/uikit/managing-your-app-s-life-cycle

## Contexto {:#background}

Durante a WWDC25, a Apple [anunciou][uiscene-announcement] o seguinte:

> No lançamento seguinte ao iOS 26, qualquer app UIKit compilado com o SDK mais recente será
> obrigado a usar o ciclo de vida UIScene, caso contrário não será iniciado.

Para adotar o ciclo de vida `UIScene`,
siga o guia que corresponde ao seu caso de uso:

* Para todos os apps Flutter que suportam iOS,
  siga o [guia de migração para apps Flutter][migration guide for Flutter apps].
* Para apps Flutter embarcados em apps nativos iOS existentes,
  siga o [guia de migração para add-to-app][migration guide for add-to-app].
* Para plugins Flutter que usam eventos do ciclo de vida da aplicação iOS,
  siga o [guia de migração para plugins Flutter][migration guide for Flutter plugins].

Migrar para `UIScene` altera o papel do `AppDelegate`:
o `UISceneDelegate` agora gerencia o ciclo de vida da UI,
enquanto o `AppDelegate` permanece responsável por
eventos de processo e pelo ciclo de vida geral da aplicação.

Mova toda a lógica relacionada à UI do `AppDelegate` para os
métodos `UISceneDelegate` correspondentes.
Após migrar para `UIScene`, o UIKit não chama mais
métodos do `AppDelegate` relacionados ao estado da UI.

[uiscene-announcement]: {{site.apple-dev}}/videos/play/wwdc2025/243/?time=1317
[migration guide for Flutter apps]: #migrate-a-flutter-app
[migration guide for add-to-app]: #migrate-an-add-to-app-integration
[migration guide for Flutter plugins]: #migrate-a-flutter-plugin

<a id="migration-guide-for-flutter-apps" aria-hidden="true"></a>

## Migrar um app Flutter {:#migrate-a-flutter-app}

### Migração automática {:#auto-migrate}

A partir do Flutter 3.41, `UIScene` é suportado por padrão.
Se seu `AppDelegate` não foi customizado,
a CLI do Flutter migra seu app automaticamente.

Para disparar a migração, compile ou execute seu app com
os comandos `flutter run` ou `flutter build ios`.
Se a migração for bem-sucedida,
a CLI exibe `Finished migration to UIScene lifecycle` e
nenhuma ação adicional é necessária.
Caso contrário, a CLI avisa você e
fornece instruções para migrar manualmente.

### Migrar AppDelegate {:#migrate-appdelegate}

Anteriormente, plugins Flutter eram registrados em
`application:didFinishLaunchingWithOptions:`.
Para acomodar a nova sequência de lançamento do app,
agora você deve registrar plugins em um
novo callback `didInitializeImplicitFlutterEngine`.

 1. Faça seu `AppDelegate` estar em conformidade com o protocolo
    `FlutterImplicitEngineDelegate` e mova o registro do `GeneratedPluginRegistrant` para
    `didInitializeImplicitFlutterEngine`.

    <Tabs key="ios-language-switcher">
    <Tab name="Swift">

    ```swift title="my_app/ios/Runner/AppDelegate.swift" diff
    - @objc class AppDelegate: FlutterAppDelegate {
    + @objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
        override func application(
          _ application: UIApplication,
          didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
    -     GeneratedPluginRegistrant.register(with: self)
          return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }

    +   func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    +     GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    +   }
      }
    ```

    </Tab>
    <Tab name="Objective-C">

    ```objc title="my_app/ios/Runner/AppDelegate.h" diff
    - @interface AppDelegate : FlutterAppDelegate
    + @interface AppDelegate : FlutterAppDelegate <FlutterImplicitEngineDelegate>
    ```

    ```objc title="my_app/ios/Runner/AppDelegate.m" diff
      - (BOOL)application:(UIApplication *)application
          didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    -   [GeneratedPluginRegistrant registerWithRegistry:self];
        return [super application:application didFinishLaunchingWithOptions:launchOptions];
      }

    + - (void)didInitializeImplicitFlutterEngine:(NSObject<FlutterImplicitEngineBridge>*)engineBridge {
    +   [GeneratedPluginRegistrant registerWithRegistry:engineBridge.pluginRegistry];
    + }
    ```

    </Tab>
    </Tabs>

 1. Se aplicável, crie method channels e platform views em
    `didInitializeImplicitFlutterEngine`.

    Se você criou anteriormente [method channels][] ou [platform views][]
    em `application:didFinishLaunchingWithOptions:`,
    mova essa lógica para `didInitializeImplicitFlutterEngine`.

    <Tabs key="ios-language-switcher">
    <Tab name="Swift">

    ```swift
    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
      // Register plugins with `engineBridge.pluginRegistry`:
      GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

      // Create method channels with `engineBridge.applicationRegistrar.messenger()`:
      let batteryChannel = FlutterMethodChannel(
        name: "samples.flutter.dev/battery",
        binaryMessenger: engineBridge.applicationRegistrar.messenger()
      )

      // Create platform views with `engineBridge.applicationRegistrar.messenger()`:
      let factory = FLNativeViewFactory(messenger: engineBridge.applicationRegistrar.messenger())
    }
    ```

    </Tab>
    <Tab name="Objective-C">

    ```objc
    - (void)didInitializeImplicitFlutterEngine:(NSObject<FlutterImplicitEngineBridge>*)engineBridge {
      // Register plugins with `engineBridge.pluginRegistry`:
      [GeneratedPluginRegistrant registerWithRegistry:engineBridge.pluginRegistry];

      // Create method channels with `engineBridge.applicationRegistrar.messenger`:
      FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
          methodChannelWithName:@"samples.flutter.dev/battery"
                binaryMessenger:engineBridge.applicationRegistrar.messenger];

      // Create platform views with `engineBridge.applicationRegistrar.messenger`:
      FLNativeViewFactory* factory =
          [[FLNativeViewFactory alloc] initWithMessenger:engineBridge.applicationRegistrar.messenger];
    }
    ```

    </Tab>
    </Tabs>

    :::warning
    Se você tentar acessar o `FlutterViewController` em
    `application:didFinishLaunchingWithOptions:`, seu app pode travar.
    Use o protocolo `FlutterImplicitEngineDelegate` em vez disso.

    ```swift
    // BAD
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    ```

    Para acessar o `FlutterViewController` diretamente,
    confira [Uso customizado de FlutterViewController][Bespoke FlutterViewController usage].
    :::

 1. Migre qualquer lógica customizada dentro dos eventos do ciclo de vida da aplicação.

    A Apple descontinuou eventos do ciclo de vida da aplicação relacionados ao estado da UI.
    Após migrar para o ciclo de vida `UIScene`,
    o UIKit não chama mais esses eventos.

    Se você usou uma dessas APIs descontinuadas,
    como [`applicationDidBecomeActive`][],
    provavelmente precisará criar um `SceneDelegate` e
    migrar para os eventos do ciclo de vida de cena.
    Para saber mais, veja a [documentação da Apple][Apple's documentation] sobre migração.

    Se você implementar seu próprio `SceneDelegate`,
    você deve criar uma subclasse de `FlutterSceneDelegate` ou
    estar em conformidade com o protocolo `FlutterSceneLifeCycleProvider`.
    Para exemplos, veja [Criar ou atualizar um SceneDelegate][Create or update a SceneDelegate].

[method channels]: /platform-integration/platform-channels
[platform views]: /platform-integration/ios/platform-views
[Bespoke FlutterViewController usage]: #bespoke-flutterviewcontroller-usage
[`applicationDidBecomeActive`]: {{site.apple-dev}}/documentation/uikit/uiapplicationdelegate/applicationdidbecomeactive
[Apple's documentation]: {{site.apple-dev}}/documentation/technotes/tn3187-migrating-to-the-uikit-scene-based-life-cycle
[Create or update a SceneDelegate]: #create-or-update-a-scenedelegate

### Migrar Info.plist {:#migrate-info-plist}

Para completar a migração para o ciclo de vida `UIScene`,
adicione uma entrada **Application Scene Manifest** ao seu `Info.plist`.

Como mostrado no editor do Xcode:

![Editor plist do Xcode para UIApplicationSceneManifest](/assets/images/docs/breaking-changes/uiscenedelegate-plist.png)

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
</plist>
```

### Criar um SceneDelegate (opcional) {:#create-a-scenedelegate-optional}

Se você precisar de acesso ao `SceneDelegate`,
você pode criar um criando uma subclasse de `FlutterSceneDelegate`:

 1. Abra seu app no Xcode.

 1. Clique com o botão direito na pasta **Runner** e selecione **New Empty File**.

    ![Opção New Empty File no Xcode](/assets/images/docs/breaking-changes/uiscene-new-file.png)

 1. Crie sua classe `SceneDelegate`.

    <Tabs key="ios-language-switcher">
    <Tab name="Swift">

    Para projetos Swift,
    crie um arquivo `SceneDelegate.swift`:

    ```swift title="my_app/ios/Runner/SceneDelegate.swift"
    import Flutter
    import UIKit

    class SceneDelegate: FlutterSceneDelegate {}
    ```

    </Tab>
    <Tab name="Objective-C">

    Para projetos Objective-C,
    crie um arquivo `SceneDelegate.h` e um `SceneDelegate.m`:

    ```objc title="my_app/ios/Runner/SceneDelegate.h"
    #import <Flutter/Flutter.h>
    #import <UIKit/UIKit.h>

    @interface SceneDelegate : FlutterSceneDelegate

    @end
    ```

    ```objc title="my_app/ios/Runner/SceneDelegate.m"
    #import "SceneDelegate.h"

    @implementation SceneDelegate

    @end
    ```

    </Tab>
    </Tabs>

 1. No seu arquivo `Info.plist`,
    altere o valor de **Delegate Class Name** (`UISceneDelegateClassName`)
    de `FlutterSceneDelegate` para sua nova classe.

    <Tabs key="ios-language-switcher">
    <Tab name="Swift">

    Para projetos Swift, use `$(PRODUCT_MODULE_NAME).SceneDelegate`:

    ```xml title="Info.plist" highlightLines=10-11
    <key>UIApplicationSceneManifest</key>
    <dict>
      <!-- ... -->
      <key>UISceneConfigurations</key>
      <dict>
        <key>UIWindowSceneSessionRoleApplication</key>
        <array>
          <dict>
            <!-- ... -->
            <key>UISceneDelegateClassName</key>
            <string>$(PRODUCT_MODULE_NAME).SceneDelegate</string>
            <!-- ... -->
          </dict>
        </array>
      </dict>
    </dict>
    ```

    </Tab>
    <Tab name="Objective-C">

    Para projetos Objective-C, use `SceneDelegate`:

    ```xml title="Info.plist" highlightLines=10-11
    <key>UIApplicationSceneManifest</key>
    <dict>
      <!-- ... -->
      <key>UISceneConfigurations</key>
      <dict>
        <key>UIWindowSceneSessionRoleApplication</key>
        <array>
          <dict>
            <!-- ... -->
            <key>UISceneDelegateClassName</key>
            <string>SceneDelegate</string>
            <!-- ... -->
          </dict>
        </array>
      </dict>
    </dict>
    ```

    </Tab>
    </Tabs>

<a id="migration-guide-for-adding-flutter-to-existing-app-add-to-app" aria-hidden="true"></a>

## Migrar uma integração add-to-app {:#migrate-an-add-to-app-integration}

Semelhante ao `FlutterAppDelegate`,
o `FlutterSceneDelegate` é recomendado, mas não obrigatório.
O `FlutterSceneDelegate` encaminha callbacks de cena,
como [`openURL`][], para plugins como [`local_auth`][].

[`openURL`]: {{site.apple-dev}}/documentation/uikit/uiapplicationdelegate/1623112-application
[`local_auth`]: {{site.pub}}/packages/local_auth

<a id="createupdate-a-scenedelegate" aria-hidden="true"></a>

### Criar ou atualizar um SceneDelegate {:#create-or-update-a-scenedelegate}

<Tabs key="ios-framework-switcher">
<Tab name="UIKit-Swift">

```swift diff
  import UIKit
+ import Flutter

- class SceneDelegate: UIResponder, UIWindowSceneDelegate {
+ class SceneDelegate: FlutterSceneDelegate {
```

</Tab>
<Tab name="UIKit-ObjC">

```objc diff
- @interface SceneDelegate : UIResponder <UIWindowSceneDelegate>
+ @interface SceneDelegate : FlutterSceneDelegate
```

</Tab>
<Tab name="SwiftUI">

Ao usar Flutter em um app SwiftUI,
você pode [opcionalmente usar um `FlutterAppDelegate`][flutter-app-delegate]
para receber eventos da aplicação.
Para migrá-lo para receber eventos `UIScene`,
faça as seguintes alterações:

 1. Defina o scene delegate como `FlutterSceneDelegate` em
    `application:configurationForConnecting:options:`:

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

 1. Se seu app não suporta múltiplas cenas,
    defina **Enable Multiple Scenes** como **NO** em
    **Application Scene Manifest** nas propriedades Info do seu target.
    O suporte a múltiplas cenas é habilitado por padrão para apps SwiftUI.

    ![Editor plist do Xcode para UIApplicationSceneManifest](/assets/images/docs/breaking-changes/uiscenedelegate-swiftui-info-plist.png)

    Se seu app suporta múltiplas cenas,
    veja [Se seu app suporta múltiplas cenas][If your app supports multiple scenes] para mais instruções.

</Tab>
</Tabs>

[flutter-app-delegate]: /add-to-app/ios/add-flutter-screen#using-the-flutterappdelegate
[If your app supports multiple scenes]: #if-your-app-supports-multiple-scenes

<a id="if-you-cant-directly-make-flutterscenedelegate-a-subclass" aria-hidden="true"></a>

### Se você não pode criar uma subclasse de FlutterSceneDelegate {:#if-you-cant-subclass-flutterscenedelegate}

Se você não pode criar uma subclasse de `FlutterSceneDelegate`,
use o protocolo `FlutterSceneLifeCycleProvider` e um
objeto `FlutterPluginSceneLifeCycleDelegate` para
encaminhar eventos do ciclo de vida de cena para o Flutter.

<Tabs key="ios-language-switcher">
<Tab name="Swift">

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

</Tab>
<Tab name="Objective-C">

```objc title="SceneDelegate.h" diff
- @interface SceneDelegate : UIResponder <UIWindowSceneDelegate>
+ @interface SceneDelegate : UIResponder <UIWindowSceneDelegate, FlutterSceneLifeCycleProvider>

  @property(strong, nonatomic) UIWindow* window;

+ @property(nonatomic, strong) FlutterPluginSceneLifeCycleDelegate* sceneLifeCycleDelegate;

  @end
```

```objc title="SceneDelegate.m" diff
  @implementation SceneDelegate

  - (instancetype)init {
    if (self = [super init]) {
+     _sceneLifeCycleDelegate = [[FlutterPluginSceneLifeCycleDelegate alloc] init];
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

  - (void)scene:(UIScene*)scene openURLContexts:(NSSet<UIOpenURLContext*>*)URLContexts {
+   [self.sceneLifeCycleDelegate scene:scene openURLContexts:URLContexts];
  }

  - (void)scene:(UIScene*)scene continueUserActivity:(NSUserActivity*)userActivity {
+   [self.sceneLifeCycleDelegate scene:scene continueUserActivity:userActivity];
  }

  - (void)windowScene:(UIWindowScene*)windowScene
      performActionForShortcutItem:(UIApplicationShortcutItem*)shortcutItem
                 completionHandler:(void (^)(BOOL))completionHandler {
+   [self.sceneLifeCycleDelegate windowScene:windowScene
+             performActionForShortcutItem:shortcutItem completionHandler:completionHandler];
  }
```

</Tab>
</Tabs>

### Se seu app suporta múltiplas cenas {:#if-your-app-supports-multiple-scenes}

O Flutter ainda não suporta totalmente múltiplas cenas,
mas o suporte está em andamento.

<a id="migration-guide-for-flutter-plugins" aria-hidden="true"></a>

## Migrar um plugin Flutter {:#migrate-a-flutter-plugin}

Nem todos os plugins usam eventos de ciclo de vida.
No entanto, se o seu plugin usa,
migre-o para o ciclo de vida baseado em cena do UIKit da seguinte forma:

 1. Atualize as versões do Dart e do Flutter SDK no seu `pubspec.yaml`.

    As APIs necessárias para esta migração estão disponíveis
    a partir do Flutter 3.38:

    ```yaml title="pubspec.yaml"
    environment:
      sdk: ^3.10.0
      flutter: ">=3.38.0"
    ```

 1. Adote o protocolo `FlutterSceneLifeCycleDelegate`.

    <Tabs key="ios-language-switcher">
    <Tab name="Swift">

    ```swift diff
    - public final class MyPlugin: NSObject, FlutterPlugin {
    + public final class MyPlugin: NSObject, FlutterPlugin, FlutterSceneLifeCycleDelegate {
    ```

    </Tab>
    <Tab name="Objective-C">

    ```objc diff
    - @interface MyPlugin : NSObject<FlutterPlugin>
    + @interface MyPlugin : NSObject<FlutterPlugin, FlutterSceneLifeCycleDelegate>
    ```

    </Tab>
    </Tabs>

 1. Registre o plugin como receptor de chamadas `UISceneDelegate`.

    Para continuar suportando apps que ainda não
    migraram para o ciclo de vida `UIScene`,
    considere permanecer registrado no application delegate e
    manter os eventos do `AppDelegate` também.

    <Tabs key="ios-language-switcher">
    <Tab name="Swift">

    ```swift diff
      public static func register(with registrar: FlutterPluginRegistrar) {
        ...
        registrar.addApplicationDelegate(instance)
    +   registrar.addSceneDelegate(instance)
      }
    ```

    </Tab>
    <Tab name="Objective-C">

    ```objc diff
      + (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
        ...
        [registrar addApplicationDelegate:instance];
    +   [registrar addSceneDelegate:instance];
      }
    ```

    </Tab>
    </Tabs>

 1. Adicione os eventos de cena de que seu plugin precisa.

    A maioria dos eventos de UI do `AppDelegate` tem uma substituição de um para um,
    como mostrado na tabela a seguir.
    Para detalhes sobre cada evento, visite a documentação da Apple sobre
    [`UISceneDelegate`][] e [`UIWindowSceneDelegate`][].

    | Método do app delegate                                            | Equivalente no scene delegate                                     |
    |:------------------------------------------------------------------|:------------------------------------------------------------------|
    | [`applicationDidBecomeActive`][]                                  | [`sceneDidBecomeActive`][]                                        |
    | [`applicationWillResignActive`][]                                 | [`sceneWillResignActive`][]                                       |
    | [`applicationWillEnterForeground`][]                              | [`sceneWillEnterForeground`][]                                    |
    | [`applicationDidEnterBackground`][]                               | [`sceneDidEnterBackground`][]                                     |
    | [`application:continueUserActivity:restorationHandler:`][]        | [`scene:continueUserActivity:`][]                                 |
    | [`application:performActionForShortcutItem:completionHandler:`][] | [`windowScene:performActionForShortcutItem:completionHandler:`][] |
    | [`application:openURL:options:`][]                                | [`scene:openURLContexts:`][]                                      |
    | [`application:willFinishLaunchingWithOptions:`][]                 | [`scene:willConnectToSession:options:`][]                         |
    | [`application:didFinishLaunchingWithOptions:`][]                  | [`scene:willConnectToSession:options:`][]                         |

    {:.table}

    Depois de identificar os eventos de cena que substituem os
    eventos de aplicação dos quais seu plugin dependia,
    implemente os métodos `FlutterSceneLifeCycleDelegate` correspondentes.
    Os trechos a seguir mostram a assinatura de cada
    evento de cena que o `FlutterSceneLifeCycleDelegate` suporta;
    implemente apenas os que seu plugin precisa.

    <Tabs key="ios-language-switcher">
    <Tab name="Swift">

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

    public func scene(
      _ scene: UIScene,
      continue userActivity: NSUserActivity
    ) -> Bool { }

    public func windowScene(
      _ windowScene: UIWindowScene,
      performActionFor shortcutItem: UIApplicationShortcutItem,
      completionHandler: @escaping (Bool) -> Void
    ) -> Bool { }
    ```

    </Tab>
    <Tab name="Objective-C">

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

    </Tab>
    </Tabs>

 1. Mova a lógica de lançamento de `application:willFinishLaunchingWithOptions:`
    e `application:didFinishLaunchingWithOptions:` para
    `scene:willConnectToSession:options:`.

    Apesar de `application:willFinishLaunchingWithOptions:` e
    `application:didFinishLaunchingWithOptions:` não estarem descontinuados,
    suas opções de lançamento são `nil` após você migrar para o ciclo de vida `UIScene`.
    Mova qualquer lógica que dependa das opções de lançamento para o
    evento `scene:willConnectToSession:options:`.

 1. Se seu plugin usa uma API que deve ser chamada antes de
    `application:didFinishLaunchingWithOptions:` terminar,
    você deve expor um método público que os desenvolvedores de apps
    possam chamar diretamente no AppDelegate deles.

    As seguintes APIs da Apple devem ser configuradas antes de o lançamento do app terminar:

    - [`BGTaskScheduler.registerForTaskWithIdentifier:usingQueue:launchHandler:`][]
    - [`UNUserNotificationCenterDelegate`][]
    - [`HKHealthStore.enableBackgroundDeliveryForType:frequency:withCompletion:`][]

    Por exemplo, para suportar `BGTaskScheduler`:

    <Tabs key="ios-language-switcher">
    <Tab name="Swift">

    ```swift diff
      // Plugin

      public class BGTaskPlugin: NSObject, FlutterPlugin {
        public static let shared =  BGTaskPlugin()
        public static func register(with registrar: FlutterPluginRegistrar) {
          let channel = ...
          registrar.addMethodCallDelegate(shared, channel: channel)
          registrar.addApplicationDelegate(shared)
        }
    +   // A new API for apps to call in their `AppDelegate`'s `application:didFinishLaunchingWithOptions:`
    +   public func registerBackgroundHandler(identifier: String) {
    +     BGTaskScheduler.register(forTaskWithIdentifier: identifier, using: .main) { task in
    +       // Handle background task execution
    +     }
    +   }
    -   public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
    -     BGTaskScheduler.register(forTaskWithIdentifier: identifier, using: .main) { task in
    -       // Handle background task execution
    -     }
    -     return true
    -   }
      }

      // App

      class AppDelegate: FlutterAppDelegate {
        override func application(
          _ application: UIApplication,
          didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
    +     BGTaskPlugin.shared.registerBackgroundHandler(identifier: "com.example.task")
          return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
      }
    ```

    </Tab>
    <Tab name="Objective-C">

    ```objc diff
      // Plugin

      @interface BGTaskPlugin : NSObject <FlutterPlugin>
    + + (instancetype)sharedInstance;
    + - (void)registerBackgroundHandlerWithIdentifier:(NSString *)identifier;
      @end

      @implementation BGTaskPlugin

    + + (instancetype)sharedInstance {
    +   static BGTaskPlugin *sharedInstance = nil;
    +   static dispatch_once_t onceToken;
    +   dispatch_once(&onceToken, ^{
    +     sharedInstance = [[BGTaskPlugin alloc] init];
    +   });
    +   return sharedInstance;
    + }

      + (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
        FlutterMethodChannel *channel = ...
        [registrar addMethodCallDelegate:[BGTaskPlugin sharedInstance] channel:channel];
        [registrar addApplicationDelegate:[BGTaskPlugin sharedInstance]];
      }

    + // A new API for apps to call in their `AppDelegate`'s `application:didFinishLaunchingWithOptions:`
    + - (void)registerBackgroundHandlerWithIdentifier:(NSString *)identifier {
    +   [[BGTaskScheduler sharedScheduler] registerForTaskWithIdentifier:identifier
    +                                                         usingQueue:dispatch_get_main_queue()
    +                                                      launchHandler:^(BGTask *task) {
    +     // Handle background task execution
    +   }];
    + }

    - - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    -   [[BGTaskScheduler sharedScheduler] registerForTaskWithIdentifier:identifier
    -                                                         usingQueue:dispatch_get_main_queue()
    -                                                      launchHandler:^(BGTask *task) {
    -     // Handle background task execution
    -   }];
    -   return YES;
    - }
      @end

      // App

      @implementation AppDelegate
      - (BOOL)application:(UIApplication *)application
          didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    +   [[BGTaskPlugin sharedInstance] registerBackgroundHandlerWithIdentifier:@"com.example.task"];
        return [super application:application didFinishLaunchingWithOptions:launchOptions];
      }
      @end
    ```

    </Tab>
    </Tabs>

    Esta mudança é necessária porque o UIScene altera a sequência de
    lançamento do app. Para apps que adotam `UIScene`, o Flutter chama
    `application:willFinishLaunchingWithOptions:` e
    `application:didFinishLaunchingWithOptions:` do plugin durante o
    callback `scene:willConnectToSession:options:`, depois que o
    `application:didFinishLaunchingWithOptions:` do UIKit retorna.

    Os métodos de registro de plugins também são adiados até depois que o
    `application:didFinishLaunchingWithOptions:` do UIKit retorna.

 1. Migre outras APIs descontinuadas para acessar corretamente
    o `viewController`, a `screen` ou a `window`.

    | API descontinuada                  | Substituto no UIScene         |
    |:-----------------------------------|:------------------------------|
    | [`UIScreen mainScreen`][]          | [`UIWindowScene screen`][]    |
    | [`UIApplication keyWindow`][]      | [`UIWindowScene keyWindow`][] |
    | [`UIApplication windows`][]        | [`UIWindowScene windows`][]   |
    | [`UIApplicationDelegate window`][] | [`UIView window`][]           |

    {:.table}

    Como `UIApplication.shared.delegate.window` é `nil`
    após adotar `UIScene`,
    você deve acessar o `viewController`
    por meio da propriedade `viewController` do registrar do plugin
    e obter a window ou a `windowScene` a partir dele,
    como mostrado nos exemplos a seguir.

    <Tabs key="ios-language-switcher">
    <Tab name="Swift">

    ```swift diff
      public class MyPlugin: NSObject, FlutterPlugin {
    +   weak var registrar: FlutterPluginRegistrar?

    +   init(registrar: FlutterPluginRegistrar) {
    +     self.registrar = registrar
    +   }

        public static func register(with registrar: FlutterPluginRegistrar) {
    -     let instance = MyPlugin()
    +     let instance = MyPlugin(registrar: registrar)
        }

        func someMethod() {
    -     let screen = UIScreen.main
    +     let screen = self.registrar?.viewController?.view.window?.windowScene?.screen

    -     let window = UIApplication.shared.delegate?.window
    +     let window = self.registrar?.viewController?.view.window

    -     let keyWindow = UIApplication.shared.keyWindow
    +     if #available(iOS 15.0, *) {
    +       let keyWindow = self.registrar?.viewController?.view.window?.windowScene?.keyWindow
    +     } else {
    +       let keyWindow = self.registrar?.viewController?.view.window?.windowScene?.windows
    +         .filter({ $0.isKeyWindow }).first
    +     }

    -     let windows = UIApplication.shared.windows
    +     let windows = self.registrar?.viewController?.view.window?.windowScene?.windows
        }
      }
    ```

    </Tab>
    <Tab name="Objective-C">

    ```objc diff
      @interface MyPlugin ()
    + @property(nonatomic, weak) NSObject<FlutterPluginRegistrar> *registrar;
    + - (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar;
      @end

      @implementation MyPlugin

    + - (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    +   self = [super init];
    +   if (self) {
    +     _registrar = registrar;
    +   }
    +   return self;
    + }

      + (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    -   MyPlugin *instance = [[MyPlugin alloc] init];
    +   MyPlugin *instance = [[MyPlugin alloc] initWithRegistrar:registrar];
      }

      - (void)someMethod {
    -   UIScreen *screen = [UIScreen mainScreen];
    +   UIScreen *screen = self.registrar.viewController.view.window.windowScene.screen;

    -   UIWindow *window = [UIApplication sharedApplication].delegate.window;
    +   UIWindow *window = self.registrar.viewController.view.window;

    -   UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    +   if (@available(iOS 15.0, *)) {
    +     UIWindow *keyWindow = self.registrar.viewController.view.window.windowScene.keyWindow;
    +   } else {
    +     for (UIWindow *window in self.registrar.viewController.view.window.windowScene.windows) {
    +       if (window.isKeyWindow) {
    +         UIWindow *keyWindow = window;
    +       }
    +     }
    +   }

    -   NSArray<UIWindow *> *windows = [UIApplication sharedApplication].windows;
    +   NSArray<UIWindow *> *windows = self.registrar.viewController.view.window.windowScene.windows;
      }
    ```

    </Tab>
    </Tabs>

[`UISceneDelegate`]: {{site.apple-dev}}/documentation/uikit/uiscenedelegate
[`UIWindowSceneDelegate`]: {{site.apple-dev}}/documentation/uikit/uiwindowscenedelegate
[`applicationWillResignActive`]: {{site.apple-dev}}/documentation/uikit/uiapplicationdelegate/1622950-applicationwillresignactive
[`applicationWillEnterForeground`]: {{site.apple-dev}}/documentation/uikit/uiapplicationdelegate/1623076-applicationwillenterforeground
[`applicationDidEnterBackground`]: {{site.apple-dev}}/documentation/uikit/uiapplicationdelegate/1622997-applicationdidenterbackground
[`application:continueUserActivity:restorationHandler:`]: {{site.apple-dev}}/documentation/uikit/uiapplicationdelegate/1623072-application
[`application:performActionForShortcutItem:completionHandler:`]: {{site.apple-dev}}/documentation/uikit/uiapplicationdelegate/application(_:performactionfor:completionhandler:)
[`application:openURL:options:`]: {{site.apple-dev}}/documentation/uikit/uiapplicationdelegate/1623112-application
[`application:willFinishLaunchingWithOptions:`]: {{site.apple-dev}}/documentation/uikit/uiapplicationdelegate/1623032-application
[`application:didFinishLaunchingWithOptions:`]: {{site.apple-dev}}/documentation/uikit/uiapplicationdelegate/1622921-application
[`sceneDidBecomeActive`]: {{site.apple-dev}}/documentation/uikit/uiscenedelegate/3197915-scenedidbecomeactive
[`sceneWillResignActive`]: {{site.apple-dev}}/documentation/uikit/uiscenedelegate/3197919-scenewillresignactive
[`sceneWillEnterForeground`]: {{site.apple-dev}}/documentation/uikit/uiscenedelegate/3197918-scenewillenterforeground
[`sceneDidEnterBackground`]: {{site.apple-dev}}/documentation/uikit/uiscenedelegate/3197917-scenedidenterbackground
[`scene:continueUserActivity:`]: {{site.apple-dev}}/documentation/uikit/uiscenedelegate/scene(_:continue:)
[`windowScene:performActionForShortcutItem:completionHandler:`]: {{site.apple-dev}}/documentation/uikit/uiwindowscenedelegate/3238088-windowscene
[`scene:openURLContexts:`]: {{site.apple-dev}}/documentation/uikit/uiscenedelegate/3238059-scene
[`scene:willConnectToSession:options:`]: {{site.apple-dev}}/documentation/uikit/uiscenedelegate/3197914-scene
[`UIScreen mainScreen`]: {{site.apple-dev}}/documentation/uikit/uiscreen/1617815-mainscreen
[`UIWindowScene screen`]: {{site.apple-dev}}/documentation/uikit/uiwindowscene/screen?language=objc
[`UIApplication keyWindow`]: {{site.apple-dev}}/documentation/uikit/uiapplication/1622924-keywindow
[`UIWindowScene keyWindow`]: {{site.apple-dev}}/documentation/uikit/uiwindowscene/keywindow?language=objc
[`UIApplication windows`]: {{site.apple-dev}}/documentation/uikit/uiapplication/windows
[`UIWindowScene windows`]: {{site.apple-dev}}/documentation/uikit/uiwindowscene/windows?language=objc
[`UIApplicationDelegate window`]: {{site.apple-dev}}/documentation/uikit/uiapplicationdelegate/window
[`UIView window`]: {{site.apple-dev}}/documentation/uikit/uiview/window?language=objc
[`BGTaskScheduler.registerForTaskWithIdentifier:usingQueue:launchHandler:`]: <{{site.apple-dev}}/documentation/backgroundtasks/bgtaskscheduler/register(fortaskwithidentifier:using:launchhandler:)?language=objc>
[`UNUserNotificationCenterDelegate`]: {{site.apple-dev}}/documentation/usernotifications/unusernotificationcenterdelegate?language=objc
[`HKHealthStore.enableBackgroundDeliveryForType:frequency:withCompletion:`]: <{{site.apple-dev}}/documentation/healthkit/hkhealthstore/enablebackgrounddelivery(for:frequency:withcompletion:)?language=objc>

## Uso customizado de FlutterViewController {:#bespoke-flutterviewcontroller-usage}

Se seu app instancia um `FlutterViewController` a partir de
storyboards em `application:didFinishLaunchingWithOptions:` por
razões diferentes de criar platform channels,
você deve acomodar a nova ordem de inicialização.
Para isso, use uma das seguintes opções de migração:

- Crie uma subclasse de `FlutterViewController` e coloque a lógica no
  método `awakeFromNib` da subclasse.
- Especifique um `UISceneDelegate` no `Info.plist` ou
  no `UIApplicationDelegate` e
  coloque a lógica em `scene:willConnectToSession:options:`.
  Para saber mais, confira a [documentação da Apple][apple-delegate-docs].

[apple-delegate-docs]: {{site.apple-dev}}/documentation/uikit/specifying-the-scenes-your-app-supports

### Exemplo {:#example}

```swift
@objc class MyViewController: FlutterViewController {
  override func awakeFromNib() {
    super.awakeFromNib()
    doSomethingWithFlutterViewController(self)
  }
}
```

## Ocultar aviso de migração {:#hide-migration-warning}

Para ocultar o aviso da CLI do Flutter sobre migrar para `UIScene`,
adicione o seguinte ao seu `pubspec.yaml`:

```yaml title="pubspec.yaml" diff
  flutter:
    config:
+     enable-uiscene-migration: false
```

## Desabilitar UIScene temporariamente {:#temporarily-disable-uiscene}

Para desabilitar _temporariamente_ o suporte a `UIScene`, adicione um underscore (`_`)
na frente de **Application Scene Manifest** no seu `Info.plist`:

![Editor plist do Xcode com um underscore na frente de Application Scene Manifest](/assets/images/docs/breaking-changes/disable-ui-scene.png)

Quando você estiver pronto para reabilitar o suporte a `UIScene`, remova o underscore.

## Cronograma {:#timeline}

Disponibilizado na versão: 3.38.0-0.1.pre<br>
Na versão stable: 3.38

Apps Flutter que não adotaram o ciclo de vida `UIScene`
travarão na inicialização quando compilados com o Xcode 27 (iOS 27 SDK).

## Referências {:#references}

- [Issue 167267][]: A issue inicial relatada.

[Issue 167267]: {{site.repo.flutter}}/issues/167267
