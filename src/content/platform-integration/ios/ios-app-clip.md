---
ia-translate: true
title: Adicionando um target App Clip iOS
description: Como adicionar um target App Clip iOS ao seu projeto Flutter.
---

:::important
Ter como target o iOS 16 aumenta o limite de tamanho de payload IPA descompactado
para 15MB. Dependendo do tamanho do seu app, você pode atingir o limite. ([#71098][#71098]).
:::

Este guia descreve como adicionar manualmente outro
target App Clip iOS que renderiza Flutter ao seu
projeto Flutter existente ou projeto [add-to-app][add-to-app].

[#71098]: {{site.repo.flutter}}/issues/71098
[add-to-app]: /add-to-app

:::warning
Este é um guia avançado e é mais adequado
para um público com conhecimento prático de desenvolvimento iOS.
:::

Para ver um exemplo funcional, consulte o [exemplo App Clip][App Clip sample] no GitHub.

[App Clip sample]: {{site.repo.samples}}/tree/main/ios_app_clip

## Step 1 - Open project

Abra seu projeto iOS Xcode, como
`ios/Runner.xcworkspace` para apps Flutter completos.

## Step 2 - Add an App Clip target

**2.1**

Clique no seu projeto no Project Navigator para mostrar
as configurações do projeto.

Pressione **+** na parte inferior da lista de targets para adicionar um novo target.

<DashImage figure image="development/platform-integration/ios-app-clip/add-target.png" />

**2.2**

Selecione o tipo **App Clip** para o seu novo target.

<DashImage figure image="development/platform-integration/ios-app-clip/add-app-clip.png" />

**2.3**

Insira os detalhes do seu novo target no diálogo.

Selecione **Storyboard** para Interface.

Selecione o mesmo idioma do seu target original para **Language**.

(Em outras palavras, para simplificar a configuração,
não crie um target App Clip Swift para
um target principal Objective-C, e vice-versa.)

<DashImage figure image="development/platform-integration/ios-app-clip/app-clip-details.png" />

**2.4**

No diálogo seguinte,
ative o novo esquema para o novo target.

<DashImage figure image="development/platform-integration/ios-app-clip/activate-scheme.png" />

**2.5**

De volta às configurações do projeto, abra a aba **Build Phases**.
Arraste **Embedded App Clips** para acima de **Thin Binary**.

<DashImage figure image="development/platform-integration/ios-app-clip/embedded-app-clips.png" />

<a id="step-3"></a>
## Step 3 - Remove unneeded files

**3.1**

No Project Navigator, no grupo App Clip recém-criado,
delete tudo exceto `Info.plist` e
`<app clip target>.entitlements`.

:::tip
Para usuários add-to-app, cabe ao leitor decidir
quanto deste template manter para invocar
APIs `FlutterViewController` ou `FlutterEngine`
deste código posteriormente.
:::

<DashImage figure image="development/platform-integration/ios-app-clip/clean-files.png" />

Mova os arquivos para a lixeira.

**3.2**

Se você não usa o arquivo `SceneDelegate.swift`,
remova a referência a ele no `Info.plist`.

Abra o arquivo `Info.plist` no grupo App Clip.
Delete toda a entrada do dicionário para
**Application Scene Manifest**.

<DashImage figure image="development/platform-integration/ios-app-clip/scene-manifest.png" />

## Step 4 - Share build configurations

Este passo não é necessário para projetos add-to-app,
pois projetos add-to-app têm suas configurações de compilação
e versões personalizadas.

**4.1**

De volta às configurações do projeto,
selecione a entrada do projeto agora em vez de qualquer target.

Na aba **Info**, sob o grupo expansível **Configurations**,
expanda as entradas
**Debug**, **Profile** e **Release**.

Para cada uma, selecione o mesmo valor do menu suspenso
para o target App Clip como a entrada selecionada para o
target do app normal.

Isso dá ao seu target App Clip acesso às
configurações de compilação necessárias do Flutter.

Defina **iOS Deployment Target** para pelo menos **16.0** para aproveitar o
limite de tamanho de 15MB.

<DashImage figure image="development/platform-integration/ios-app-clip/configuration.png" />

**4.2**

No arquivo `Info.plist` do grupo App Clip, defina:

* `Build version string (short)` para `$(FLUTTER_BUILD_NAME)`
* `Bundle version` para `$(FLUTTER_BUILD_NUMBER)`

## Step 5 - Share code and assets

### Option 1 - Share everything

Assumindo que a intenção é mostrar a mesma UI Flutter
no app padrão como no App Clip,
compartilhe o mesmo código e assets.

Para cada um dos seguintes: `Main.storyboard`, `Assets.xcassets`,
`LaunchScreen.storyboard`, `GeneratedPluginRegistrant.m`, e
`AppDelegate.swift` (e `Supporting Files/main.m` se usar Objective-C),
selecione o arquivo, depois na primeira aba do inspetor,
também inclua o target App Clip no grupo de checkboxes
`Target Membership`.

<DashImage figure image="development/platform-integration/ios-app-clip/add-target-membership.png" />

### Option 2 - Customize Flutter launch for App Clip

Neste caso,
não delete tudo listado no [Step 3](#step-3).
Em vez disso, use o scaffolding e as [APIs iOS add-to-app][iOS add-to-app APIs]
para realizar uma inicialização personalizada do Flutter.
Por exemplo, para mostrar uma [rota Flutter personalizada][custom Flutter route].

[custom Flutter route]: /add-to-app/ios/add-flutter-screen#route
[iOS add-to-app APIs]: /add-to-app/ios/add-flutter-screen

## Step 6 - Add App Clip associated domains

Este é um passo padrão para o desenvolvimento de App Clip.
Consulte a [documentação oficial da Apple][official Apple documentation].

[official Apple documentation]: {{site.apple-dev}}/documentation/app_clips/creating_an_app_clip_with_xcode#3604097

**6.1**

Abra o arquivo `<app clip target>.entitlements`.
Adicione um tipo Array `Associated Domains`.
Adicione uma linha ao array com `appclips:<your bundle id>`.

<DashImage figure image="development/platform-integration/ios-app-clip/app-clip-entitlements.png" />

**6.2**

O mesmo entitlement de domínios associados precisa ser adicionado
ao seu app principal também.

Copie o arquivo `<app clip target>.entitlements` do seu
grupo App Clip para o seu grupo de app principal e renomeie-o para
o mesmo nome do seu target principal,
como `Runner.entitlements`.

Abra o arquivo e delete a entrada
`Parent Application Identifiers`
do arquivo de entitlement do app principal
(deixe essa entrada para o arquivo de entitlement do App Clip).

<DashImage figure image="development/platform-integration/ios-app-clip/main-app-entitlements.png" />

**6.3**

De volta às configurações do projeto, selecione o target do app principal,
abra a aba **Build Settings**.
Defina a configuração **Code Signing Entitlements** para o
caminho relativo do segundo arquivo de entitlements
criado para o app principal.

<DashImage figure image="development/platform-integration/ios-app-clip/main-app-entitlements-setting.png" />

## Step 7 - Integrate Flutter

Estes passos não são necessários para add-to-app.

**7.1**

Para o target Swift,
defina a configuração de compilação `Objective-C Bridging Header`
para `Runner/Runner-Bridging-Header.h`

Em outras palavras,
o mesmo que as configurações de compilação do target do app principal.

<DashImage figure image="development/platform-integration/ios-app-clip/bridge-header.png" />

**7.2**

Agora abra a aba **Build Phases**. Pressione o sinal **+**
e selecione **New Run Script Phase**.

<DashImage figure image="development/platform-integration/ios-app-clip/new-build-phase.png" />

Arraste essa nova fase para abaixo da fase **Dependencies**.

Expanda a nova fase e adicione esta linha ao conteúdo do script:

```bash
/bin/sh "$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" build
```

Desmarque **Based on dependency analysis**.

Em outras palavras,
o mesmo que as fases de compilação do target do app principal.

<DashImage figure image="development/platform-integration/ios-app-clip/xcode-backend-build.png" />

Isso garante que seu código Dart Flutter seja compilado
ao executar o target App Clip.

**7.3**

Pressione o sinal **+** e selecione **New Run Script Phase** novamente.
Deixe-o como a última fase.

Desta vez, adicione:

```bash
/bin/sh "$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" embed_and_thin
```

Desmarque **Based on dependency analysis**.

Em outras palavras,
o mesmo que as fases de compilação do target do app principal.

<DashImage figure image="development/platform-integration/ios-app-clip/xcode-backend-embed.png" />

Isso garante que seu app Flutter e engine sejam incorporados
ao bundle App Clip.

## Step 8 - Integrate plugins

**8.1**

Abra o `Podfile` do seu projeto Flutter
ou projeto host add-to-app.

Para apps Flutter completos, substitua a seguinte seção:

```ruby
target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end
```

por:

```ruby
use_frameworks!
use_modular_headers!
flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))

target 'Runner'
target '<name of your App Clip target>'
```

No topo do arquivo,
também descomente `platform :ios, '13.0'` e defina a
versão para o menor dos iOS Deployment Target dos dois targets.

Para add-to-app, adicione a:

```ruby
target 'MyApp' do
  install_all_flutter_pods(flutter_application_path)
end
```

com:

```ruby
target 'MyApp' do
  install_all_flutter_pods(flutter_application_path)
end

target '<name of your App Clip target>'
  install_all_flutter_pods(flutter_application_path)
end
```

**8.2**

Da linha de comando,
entre no diretório do seu projeto Flutter
e então instale o pod:

```console
cd ios
pod install
```

## Run

Agora você pode executar seu target App Clip do Xcode
selecionando seu target App Clip do menu suspenso de esquema,
selecionando um dispositivo iOS 16 ou superior e pressionando executar.

<DashImage figure image="development/platform-integration/ios-app-clip/run-select.png" />

Para testar o lançamento de um App Clip do início,
também consulte a documentação da Apple sobre
[Testando a Experiência de Lançamento do seu App Clip][testing].

[testing]: {{site.apple-dev}}/documentation/app_clips/testing_your_app_clip_s_launch_experience

## Debugging, hot reload

Infelizmente, `flutter attach` não pode descobrir automaticamente
a sessão Flutter em um App Clip devido a
restrições de permissão de rede.

Você deve então copiar e colar de volta no
comando `flutter attach` para conectar.

Por exemplo:

```console
flutter attach --debug-uri <copied URI>
```
