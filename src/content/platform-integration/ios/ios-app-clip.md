---
ia-translate: true
title: Adicionando um alvo App Clip do iOS
description: Como adicionar um alvo App Clip do iOS ao seu projeto Flutter.
---

:::important
Ter como alvo o iOS 16 aumenta o limite do tamanho do payload IPA não compactado
para 15 MB. Dependendo do tamanho do seu aplicativo, você pode atingir o limite. ([#71098][]).
:::

Este guia descreve como adicionar manualmente outro
alvo App Clip do iOS de renderização Flutter ao seu
projeto Flutter existente ou projeto [add-to-app][].

[#71098]: {{site.repo.flutter}}/issues/71098
[add-to-app]: /add-to-app

:::warning
Este é um guia avançado e é mais adequado
para um público com conhecimento prático de desenvolvimento iOS.
:::

Para ver um exemplo funcional, consulte o [exemplo App Clip][] no GitHub.

[exemplo App Clip]: {{site.repo.samples}}/tree/main/ios_app_clip

## Passo 1 - Abrir projeto

Abra seu projeto Xcode iOS, como
`ios/Runner.xcworkspace` para aplicativos full-Flutter.

## Passo 2 - Adicionar um alvo App Clip

**2.1**

Clique no seu projeto no Project Navigator para exibir
as configurações do projeto.

Pressione **+** na parte inferior da lista de alvos para adicionar um novo alvo.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/add-target.png" %}

**2.2**

Selecione o tipo **App Clip** para seu novo alvo.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/add-app-clip.png" %}

**2.3**

Insira os detalhes do seu novo alvo na caixa de diálogo.

Selecione **Storyboard** para Interface.

Selecione o mesmo idioma do seu alvo original para **Idioma**.

(Em outras palavras, para simplificar a configuração,
não crie um alvo App Clip Swift para
um alvo principal Objective-C e vice-versa.)

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/app-clip-details.png" %}

**2.4**

Na seguinte caixa de diálogo,
ative o novo esquema para o novo alvo.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/activate-scheme.png" %}

**2.5**

De volta às configurações do projeto, abra a aba **Build Phases**.
Arraste **Embedded App Clips** para cima de **Thin Binary**.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/embedded-app-clips.png" %}

<a id="step-3"></a>
## Passo 3 - Remover arquivos desnecessários

**3.1**

No Project Navigator, no grupo App Clip recém-criado,
exclua tudo, exceto `Info.plist` e
`<alvo app clip>.entitlements`.

:::tip
Para usuários add-to-app, cabe ao leitor decidir
quanto deste modelo manter para invocar
APIs `FlutterViewController` ou `FlutterEngine`
deste código mais tarde.
:::

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/clean-files.png" %}

Mova os arquivos para a lixeira.

**3.2**

Se você não usa o arquivo `SceneDelegate.swift`,
remova a referência a ele no `Info.plist`.

Abra o arquivo `Info.plist` no grupo App Clip.
Exclua toda a entrada do dicionário para
**Application Scene Manifest**.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/scene-manifest.png" %}

## Passo 4 - Compartilhar configurações de build

Esta etapa não é necessária para projetos add-to-app
já que projetos add-to-app têm seus builds
configurações e versões personalizadas.

**4.1**

De volta às configurações do projeto,
selecione a entrada do projeto agora em vez de qualquer alvo.

Na aba **Info**, sob o grupo expansível **Configurations**,
expanda as entradas
**Debug**, **Profile** e **Release**.

Para cada um, selecione o mesmo valor do menu suspenso
para o alvo App Clip que a entrada selecionada para o
alvo de aplicativo normal.

Isso dá ao seu alvo App Clip acesso às configurações
de build necessárias do Flutter.

Defina **iOS Deployment Target** para pelo menos **16.0** para
aproveitar o limite de tamanho de 15 MB.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/configuration.png" %}

**4.2**

No arquivo `Info.plist` do grupo App Clip, defina:

*   `Build version string (short)` para `$(FLUTTER_BUILD_NAME)`
*   `Bundle version` para `$(FLUTTER_BUILD_NUMBER)`

## Passo 5 - Compartilhar código e ativos

### Opção 1 - Compartilhar tudo

Assumindo que a intenção é mostrar a mesma UI Flutter
no aplicativo padrão como no App Clip,
compartilhe o mesmo código e ativos.

Para cada um dos seguintes: `Main.storyboard`, `Assets.xcassets`,
`LaunchScreen.storyboard`, `GeneratedPluginRegistrant.m` e
`AppDelegate.swift` (e `Supporting Files/main.m` se estiver usando Objective-C),
selecione o arquivo, então na primeira aba do inspetor,
inclua também o alvo App Clip no grupo de caixas de seleção `Target Membership`.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/add-target-membership.png" %}

### Opção 2 - Personalizar o lançamento do Flutter para App Clip

Neste caso,
não exclua tudo listado no [Passo 3](#step-3).
Em vez disso, use o scaffolding e as [APIs iOS add-to-app][]
para realizar um lançamento personalizado do Flutter.
Por exemplo, para mostrar uma [rota Flutter personalizada][].

[rota Flutter personalizada]: /add-to-app/ios/add-flutter-screen#route
[APIs iOS add-to-app]: /add-to-app/ios/add-flutter-screen

## Passo 6 - Adicionar domínios associados do App Clip

Este é um passo padrão para o desenvolvimento do App Clip.
Consulte a [documentação oficial da Apple][].

[documentação oficial da Apple]: {{site.apple-dev}}/documentation/app_clips/creating_an_app_clip_with_xcode#3604097

**6.1**

Abra o arquivo `<alvo app clip>.entitlements`.
Adicione um tipo Array `Associated Domains`.
Adicione uma linha ao array com `appclips:<seu id de bundle>`.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/app-clip-entitlements.png" %}

**6.2**

O mesmo direito de domínios associados precisa ser adicionado
ao seu aplicativo principal também.

Copie o arquivo `<alvo app clip>.entitlements` do seu
grupo App Clip para o grupo do seu aplicativo principal e renomeie-o para
o mesmo nome do seu alvo principal
como `Runner.entitlements`.

Abra o arquivo e exclua a entrada
`Parent Application Identifiers`
para o arquivo de direitos do aplicativo principal
(deixe essa entrada para o arquivo de direitos do App Clip).

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/main-app-entitlements.png" %}

**6.3**

De volta às configurações do projeto, selecione o alvo do aplicativo principal,
abra a aba **Build Settings**.
Defina a configuração **Code Signing Entitlements** para o
caminho relativo do segundo arquivo de direitos
criado para o aplicativo principal.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/main-app-entitlements-setting.png" %}

## Passo 7 - Integrar o Flutter

Estes passos não são necessários para add-to-app.

**7.1**

Para o alvo Swift,
defina a configuração de build `Objective-C Bridging Header`
para `Runner/Runner-Bridging-Header.h`

Em outras palavras,
o mesmo que as configurações de build do alvo do aplicativo principal.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/bridge-header.png" %}

**7.2**

Agora abra a aba **Build Phases**. Pressione o sinal **+**
e selecione **New Run Script Phase**.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/new-build-phase.png" %}

Arraste essa nova fase para baixo da fase **Dependencies**.

Expanda a nova fase e adicione esta linha ao conteúdo do script:

```bash
/bin/sh "$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" build
```

Desmarque **Based on dependency analysis**.

Em outras palavras,
o mesmo que as fases de build do alvo do aplicativo principal.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/xcode-backend-build.png" %}

Isso garante que seu código Flutter Dart seja compilado
ao executar o alvo App Clip.

**7.3**

Pressione o sinal **+** e selecione **New Run Script Phase** novamente.
Deixe-o como a última fase.

Desta vez, adicione:

```bash
/bin/sh "$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" embed_and_thin
```

Desmarque **Based on dependency analysis**.

Em outras palavras,
o mesmo que as fases de build do alvo do aplicativo principal.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/xcode-backend-embed.png" %}

Isso garante que seu aplicativo e engine Flutter sejam incorporados
no bundle do App Clip.

## Passo 8 - Integrar plugins

**8.1**

Abra o `Podfile` para seu projeto Flutter
ou projeto host add-to-app.

Para aplicativos full-Flutter, substitua a seguinte seção:

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
target '<nome do seu alvo App Clip>'
```

Na parte superior do arquivo,
descomente também `platform :ios, '12.0'` e defina a
versão para a mais baixa do iOS dos dois alvos
Deployment Target.

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

target '<nome do seu alvo App Clip>'
  install_all_flutter_pods(flutter_application_path)
end
```

**8.2**

A partir da linha de comando,
entre no diretório do seu projeto Flutter
e então instale o pod:

```console
cd ios
pod install
```

## Executar

Agora você pode executar seu alvo App Clip no Xcode,
selecionando seu alvo App Clip no menu suspenso do esquema,
selecionando um dispositivo iOS 16 ou superior e pressionando executar.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/run-select.png" %}

Para testar o lançamento de um App Clip desde o início,
consulte também o documento da Apple sobre
[Testando a Experiência de Lançamento do seu App Clip][testing].

[testing]: {{site.apple-dev}}/documentation/app_clips/testing_your_app_clip_s_launch_experience

## Depuração, hot reload

Infelizmente `flutter attach` não pode descobrir automaticamente
a sessão Flutter em um App Clip devido a
restrições de permissão de rede.

Para depurar seu App Clip e usar funcionalidades
como hot reload, você deve procurar o Observatory URI
na saída do console no Xcode após a execução.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/observatory-uri.png" %}

Você deve então copiar e colar de volta no
comando `flutter attach` para conectar.

Por exemplo:

```console
flutter attach --debug-uri <URI copiado>
```
