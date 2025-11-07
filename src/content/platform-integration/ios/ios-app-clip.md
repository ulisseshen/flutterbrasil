---
ia-translate: true
title: Adicionando um target iOS App Clip
description: Como adicionar um target iOS App Clip ao seu projeto Flutter.
---

:::important
Direcionar para iOS 16 aumenta o limite de tamanho do payload IPA descompactado
para 15MB. Dependendo do tamanho do seu app, você pode atingir o limite. ([#71098][]).
:::

Este guia descreve como adicionar manualmente outro
target iOS App Clip de renderização Flutter ao seu
projeto Flutter existente ou projeto [add-to-app][].

[#71098]: {{site.repo.flutter}}/issues/71098
[add-to-app]: /add-to-app

:::warning
Este é um guia avançado e é mais adequado
para audiência com conhecimento prático de desenvolvimento iOS.
:::

Para ver um exemplo funcional, veja o [App Clip sample][] no GitHub.

[App Clip sample]: {{site.repo.samples}}/tree/main/ios_app_clip

## Etapa 1 - Abrir projeto

Abra seu projeto iOS do Xcode, como
`ios/Runner.xcworkspace` para apps Flutter completos.

## Etapa 2 - Adicionar um target App Clip

**2.1**

Clique no seu projeto no Project Navigator para mostrar
as configurações do projeto.

Pressione **+** na parte inferior da lista de targets para adicionar um novo target.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/add-target.png" %}

**2.2**

Selecione o tipo **App Clip** para seu novo target.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/add-app-clip.png" %}

**2.3**

Digite os detalhes do seu novo target no diálogo.

Selecione **Storyboard** para Interface.

Selecione a mesma linguagem do seu target original para **Language**.

(Em outras palavras, para simplificar a configuração,
não crie um target App Clip Swift para
um target principal Objective-C, e vice-versa.)

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/app-clip-details.png" %}

**2.4**

No diálogo seguinte,
ative o novo scheme para o novo target.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/activate-scheme.png" %}

**2.5**

De volta às configurações do projeto, abra a aba **Build Phases**.
Arraste **Embedded App Clips** para acima de **Thin Binary**.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/embedded-app-clips.png" %}

<a id="step-3"></a>
## Etapa 3 - Remover arquivos desnecessários

**3.1**

No Project Navigator, no grupo App Clip recém-criado,
exclua tudo exceto `Info.plist` e
`<app clip target>.entitlements`.

:::tip
Para usuários add-to-app, fica a critério do leitor decidir
quanto deste template manter para invocar
APIs `FlutterViewController` ou `FlutterEngine`
deste código mais tarde.
:::

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/clean-files.png" %}

Mova os arquivos para o lixo.

**3.2**

Se você não usar o arquivo `SceneDelegate.swift`,
remova a referência a ele no `Info.plist`.

Abra o arquivo `Info.plist` no grupo App Clip.
Exclua toda a entrada de dicionário para
**Application Scene Manifest**.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/scene-manifest.png" %}

## Etapa 4 - Compartilhar configurações de build

Esta etapa não é necessária para projetos add-to-app
já que projetos add-to-app têm suas próprias configurações
de build e versões personalizadas.

**4.1**

De volta às configurações do projeto,
selecione a entrada do projeto agora em vez de qualquer target.

Na aba **Info**, sob o grupo expansível **Configurations**,
expanda as entradas **Debug**, **Profile** e **Release**.

Para cada uma, selecione o mesmo valor do menu dropdown
para o target App Clip como a entrada selecionada para o
target do app normal.

Isso dá ao seu target App Clip acesso às
configurações de build necessárias do Flutter.

Defina **iOS Deployment Target** para pelo menos **16.0** para aproveitar o
limite de tamanho de 15MB.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/configuration.png" %}

**4.2**

No arquivo `Info.plist` do grupo App Clip, defina:

* `Build version string (short)` para `$(FLUTTER_BUILD_NAME)`
* `Bundle version` para `$(FLUTTER_BUILD_NUMBER)`

## Etapa 5 - Compartilhar código e assets

### Opção 1 - Compartilhar tudo

Assumindo que a intenção é mostrar a mesma UI Flutter
no app padrão como no App Clip,
compartilhe o mesmo código e assets.

Para cada um dos seguintes: `Main.storyboard`, `Assets.xcassets`,
`LaunchScreen.storyboard`, `GeneratedPluginRegistrant.m` e
`AppDelegate.swift` (e `Supporting Files/main.m` se usar Objective-C),
selecione o arquivo, então na primeira aba do inspetor,
também inclua o target App Clip no grupo de checkboxes
`Target Membership`.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/add-target-membership.png" %}

### Opção 2 - Personalizar lançamento Flutter para App Clip

Neste caso,
não exclua tudo listado na [Etapa 3](#step-3).
Em vez disso, use o scaffolding e as [APIs iOS add-to-app][iOS add-to-app APIs]
para realizar um lançamento personalizado do Flutter.
Por exemplo, para mostrar uma [rota Flutter personalizada][custom Flutter route].

[custom Flutter route]: /add-to-app/ios/add-flutter-screen#route
[iOS add-to-app APIs]: /add-to-app/ios/add-flutter-screen

## Etapa 6 - Adicionar domínios associados do App Clip

Esta é uma etapa padrão para desenvolvimento de App Clip.
Veja a [documentação oficial da Apple][official Apple documentation].

[official Apple documentation]: {{site.apple-dev}}/documentation/app_clips/creating_an_app_clip_with_xcode#3604097

**6.1**

Abra o arquivo `<app clip target>.entitlements`.
Adicione um tipo Array `Associated Domains`.
Adicione uma linha ao array com `appclips:<your bundle id>`.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/app-clip-entitlements.png" %}

**6.2**

O mesmo entitlement de domínios associados precisa ser adicionado
ao seu app principal, também.

Copie o arquivo `<app clip target>.entitlements` do seu
grupo App Clip para seu grupo de app principal e renomeie-o para
o mesmo nome do seu target principal
como `Runner.entitlements`.

Abra o arquivo e exclua a entrada
`Parent Application Identifiers`
do arquivo de entitlement do app principal
(deixe essa entrada para o arquivo de entitlement do App Clip).

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/main-app-entitlements.png" %}

**6.3**

De volta às configurações do projeto, selecione o target do app principal,
abra a aba **Build Settings**.
Defina a configuração **Code Signing Entitlements** para o
caminho relativo do segundo arquivo entitlements
criado para o app principal.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/main-app-entitlements-setting.png" %}

## Etapa 7 - Integrar Flutter

Estas etapas não são necessárias para add-to-app.

**7.1**

Para o target Swift,
defina a configuração de build `Objective-C Bridging Header`
para `Runner/Runner-Bridging-Header.h`

Em outras palavras,
o mesmo que as configurações de build do target do app principal.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/bridge-header.png" %}

**7.2**

Agora abra a aba **Build Phases**. Pressione o sinal **+**
e selecione **New Run Script Phase**.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/new-build-phase.png" %}

Arraste essa nova fase para abaixo da fase **Dependencies**.

Expanda a nova fase e adicione esta linha ao conteúdo do script:

```bash
/bin/sh "$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" build
```

Desmarque **Based on dependency analysis**.

Em outras palavras,
o mesmo que as fases de build do target do app principal.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/xcode-backend-build.png" %}

Isso garante que seu código Dart Flutter seja compilado
ao executar o target App Clip.

**7.3**

Pressione o sinal **+** e selecione **New Run Script Phase** novamente.
Deixe-a como a última fase.

Desta vez, adicione:

```bash
/bin/sh "$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" embed_and_thin
```

Desmarque **Based on dependency analysis**.

Em outras palavras,
o mesmo que as fases de build do target do app principal.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/xcode-backend-embed.png" %}

Isso garante que seu app e engine Flutter sejam incorporados
ao bundle do App Clip.

## Etapa 8 - Integrar plugins

**8.1**

Abra o `Podfile` para seu projeto Flutter
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
também descomente `platform :ios, '12.0'` e defina a
versão para a menor dos dois iOS
Deployment Targets dos targets.

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

## Executar

Agora você pode executar seu target App Clip do Xcode
selecionando seu target App Clip do dropdown de scheme,
selecionando um dispositivo iOS 16 ou superior e pressionando executar.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/run-select.png" %}

Para testar o lançamento de um App Clip desde o início,
também consulte a documentação da Apple sobre
[Testing Your App Clip's Launch Experience][testing].

[testing]: {{site.apple-dev}}/documentation/app_clips/testing_your_app_clip_s_launch_experience

## Debug, hot reload

Infelizmente `flutter attach` não consegue auto-descobrir
a sessão Flutter em um App Clip devido a
restrições de permissão de rede.

Para debugar seu App Clip e usar funcionalidades
como hot reload, você deve procurar o Observatory URI
na saída do console no Xcode após executar.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/observatory-uri.png" %}

Você deve então copiá-lo e colá-lo de volta no
comando `flutter attach` para conectar.

Por exemplo:

```console
flutter attach --debug-uri <copied URI>
```
