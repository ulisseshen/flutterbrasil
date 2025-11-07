---
ia-translate: true
title: Compile e publique um app iOS
description: Como publicar um app Flutter na App Store.
short-title: iOS
---

Este guia fornece um passo a passo detalhado para publicar um
app Flutter na [App Store][appstore] e no [TestFlight][].

## Preliminares

O Xcode é necessário para compilar e publicar seu app. Você
deve usar um dispositivo executando macOS para seguir este guia.

Antes de começar o processo de publicação do seu app,
certifique-se de que ele atenda às [Diretrizes de Revisão de Apps][appreview] da Apple.

Para publicar seu app na App Store,
você deve primeiro se inscrever no [Apple Developer Program][devprogram].
Você pode ler mais sobre as várias opções de associação no guia
[Choosing a Membership][devprogram_membership] da Apple.

## Visão geral em vídeo

Para aqueles que preferem vídeo ao invés de texto,
o vídeo a seguir cobre o mesmo conteúdo deste guia.

{% ytEmbed 'iE2bpP56QKc', 'Release an iOS app built with Flutter in 7 steps' %}

## Registre seu app no App Store Connect

Gerencie o ciclo de vida do seu app no
[App Store Connect][appstoreconnect] (anteriormente iTunes Connect).
Você define o nome e a descrição do seu app, adiciona capturas de tela,
define preços e gerencia publicações na App Store e no TestFlight.

Registrar seu app envolve duas etapas: registrar um
Bundle ID único e criar um registro de aplicativo no App Store Connect.

Para uma visão geral detalhada do App Store Connect, consulte o
guia [App Store Connect][appstoreconnect_guide].

### Registre um Bundle ID

Cada aplicativo iOS está associado a um Bundle ID,
um identificador único registrado na Apple.
Para registrar um Bundle ID para seu app, siga estas etapas:

1. Abra a página [App IDs][devportal_appids] da sua conta de desenvolvedor.
1. Clique em **+** para criar um novo Bundle ID.
1. Digite um nome de app, selecione **Explicit App ID** e digite um ID.
1. Selecione os serviços que seu app usa e clique em **Continue**.
1. Na próxima página, confirme os detalhes e clique em **Register**
   para registrar seu Bundle ID.

### Crie um registro de aplicativo no App Store Connect

Registre seu app no App Store Connect:

1. Abra o [App Store Connect][appstoreconnect_login] no seu navegador.
1. Na página inicial do App Store Connect, clique em **My Apps**.
1. Clique em **+** no canto superior esquerdo da página My Apps
   e selecione **New App**.
1. Preencha os detalhes do seu app no formulário que aparece.
   Na seção Platforms, certifique-se de que iOS esteja marcado.
   Como o Flutter atualmente não suporta tvOS,
   deixe essa caixa de seleção desmarcada. Clique em **Create**.
1. Navegue até os detalhes do aplicativo do seu app e selecione
   **App Information** na barra lateral.
1. Na seção General Information, selecione o Bundle ID
   que você registrou na etapa anterior.

Para uma visão geral detalhada, consulte
[Add an app to your account][appstoreconnect_guide_register].

## Revise as configurações do projeto Xcode

Esta etapa cobre a revisão das configurações mais importantes
no workspace do Xcode.
Para procedimentos e descrições detalhadas, consulte
[Prepare for app distribution][distributionguide_config].

Navegue até as configurações do seu target no Xcode:

1. Abra o workspace padrão do Xcode em seu projeto executando
   `open ios/Runner.xcworkspace` em uma janela de terminal do
   diretório do projeto Flutter.
1. Para visualizar as configurações do seu app, selecione o target **Runner** no
   navegador do Xcode.

Verifique as configurações mais importantes.

Na seção **Identity** da aba **General**:

`Display Name`
: O nome de exibição do seu app.

`Bundle Identifier`
: O App ID que você registrou no App Store Connect.

Na aba **Signing & Capabilities**:

`Automatically manage signing`
: Se o Xcode deve gerenciar automaticamente a assinatura e
  o provisionamento do app. Isso é definido como `true` por padrão, o que deve
  ser suficiente para a maioria dos apps. Para cenários mais complexos,
  consulte o [Code Signing Guide][codesigning_guide].

`Team`
: Selecione a equipe associada à sua conta Apple Developer
  registrada. Se necessário, selecione **Add Account...**
  e atualize esta configuração.

Na seção **Deployment** da aba **Build Settings**:

`iOS Deployment Target`
: A versão mínima do iOS que seu app suporta.
  O Flutter suporta iOS 12 e posterior. Se seu app ou plugins
  incluem código Objective-C ou Swift que usa APIs mais recentes
  que o iOS 12, atualize esta configuração para a versão mais alta necessária.

A aba **General** das configurações do seu projeto deve ser semelhante
ao seguinte:

![Xcode Project Settings](/assets/images/docs/releaseguide/xcode_settings.png){:width="100%"}

Para uma visão geral detalhada da assinatura de apps, consulte
[Create, export, and delete signing certificates][appsigning].

## Atualizando a versão de deployment do app

Se você alterou o `Deployment Target` no seu projeto Xcode,
abra `ios/Flutter/AppframeworkInfo.plist` no seu app Flutter
e atualize o valor `MinimumOSVersion` para corresponder.

<a id="add-an-app-icon"></a>
## Adicione um ícone de app

Quando um novo app Flutter é criado, um conjunto de ícones placeholder é criado.
Esta etapa cobre a substituição desses ícones placeholder pelos
ícones do seu app:

1. Revise as diretrizes [iOS App Icon][app-icon] e,
   em particular, os conselhos sobre
   [criar ícones light, dark e tinted][icon-modes] para seu app.
1. No navegador de projetos do Xcode, selecione `Assets.xcassets` na
   pasta `Runner`. Atualize os ícones placeholder com os ícones do seu próprio app.
1. Verifique se o ícone foi substituído executando seu app usando
   `flutter run`.

[app-icon]: {{site.apple-dev}}/design/human-interface-guidelines/app-icons/
[icon-modes]: {{site.apple-dev}}/design/human-interface-guidelines/app-icons#iOS-iPadOS

## Adicione uma imagem de lançamento

Semelhante ao ícone do app,
você também pode substituir a imagem de lançamento placeholder:

1. No navegador de projetos do Xcode,
   selecione `Assets.xcassets` na pasta `Runner`.
   Atualize a imagem de lançamento placeholder com sua própria imagem de lançamento.
1. Verifique a nova imagem de lançamento fazendo hot restart do seu app.
   (Não use `hot reload`.)

## Crie um archive de build e faça upload para o App Store Connect

Durante o desenvolvimento, você tem compilado, depurado e testado
com builds _debug_. Quando estiver pronto para enviar seu app aos usuários
na App Store ou no TestFlight, você precisa preparar um build _release_.

<a id="update-the-apps-build-and-version-numbers"></a>
### Atualize os números de build e versão do app

O número de versão padrão do app é `1.0.0`.
Para atualizá-lo, navegue até o arquivo `pubspec.yaml`
e atualize a seguinte linha:

```yaml
version: 1.0.0+1
```

O número de versão é composto por três números separados por pontos,
como `1.0.0` no exemplo acima, seguido por um número opcional
de build como `1` no exemplo acima, separado por um `+`.

Tanto a versão quanto o número de build podem ser sobrescritos em
`flutter build ipa` especificando `--build-name` e `--build-number`,
respectivamente.

No iOS, `build-name` usa `CFBundleShortVersionString`
enquanto `build-number` usa `CFBundleVersion`.
Leia mais sobre versionamento no iOS em [Core Foundation Keys][]
no site do Apple Developer.

Você também pode sobrescrever o nome de build e o número no `pubspec.yaml` no Xcode:

1. Abra `Runner.xcworkspace` na pasta `ios` do seu app.
1. Selecione **Runner** no navegador de projetos do Xcode e, em seguida, selecione o
   target **Runner** na barra lateral de visualização de configurações.
1. Na seção Identity, atualize a **Version** para o número de
   versão voltado ao usuário que você deseja publicar.
1. Na seção Identity, atualize o identificador **Build** para um número
   de build único usado para rastrear este build no App Store Connect.
   Cada upload requer um número de build único.

### Crie um app bundle

Execute `flutter build ipa` para produzir um archive de build do Xcode (arquivo `.xcarchive`)
no diretório `build/ios/archive/` do seu projeto e um app
bundle da App Store (arquivo `.ipa`) em `build/ios/ipa`.

Considere adicionar as flags `--obfuscate` e `--split-debug-info` para
[ofuscar seu código Dart][obfuscate your Dart code] para tornar mais difícil
fazer engenharia reversa.

Se você não está distribuindo para a App Store, você pode opcionalmente
escolher um [método de exportação][app_bundle_export_method] diferente adicionando
a opção `--export-method ad-hoc`,
`--export-method development` ou `--export-method enterprise`.

:::note
Em versões do Flutter onde `flutter build ipa --export-method` não está disponível,
abra `build/ios/archive/MyApp.xcarchive` e siga as instruções abaixo
para validar e distribuir o app pelo Xcode.
:::

### Faça upload do app bundle para o App Store Connect

Depois que o app bundle for criado, faça upload para
[App Store Connect][appstoreconnect_login] usando uma das opções:

<ol>
<li>

Instale e abra o [app Apple Transport para macOS][apple_transport_app].
Arraste e solte o app bundle `build/ios/ipa/*.ipa` no app.

</li>

<li>

Ou faça upload do app bundle pela linha de comando executando:

```bash
xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey your_api_key --apiIssuer your_issuer_id
```

Execute `man altool` para detalhes sobre como autenticar com a chave de API do App Store Connect.

</li>

<li>

Ou abra `build/ios/archive/MyApp.xcarchive` no Xcode.

Clique no botão **Validate App**. Se algum problema for relatado,
resolva-o e produza outro build. Você pode reutilizar o mesmo
build ID até fazer upload de um archive.

Após o archive ser validado com sucesso, clique em
**Distribute App**.

:::note
Quando você exportar seu app no final de **Distribute App**,
o Xcode criará um diretório contendo
um IPA do seu app e um arquivo `ExportOptions.plist`.
Você pode criar novos IPAs com as mesmas opções sem iniciar
o Xcode executando
`flutter build ipa --export-options-plist=path/to/ExportOptions.plist`.
Consulte `xcodebuild -h` para detalhes sobre as chaves nesta property list.
:::

</li>
</ol>

Você pode acompanhar o status do seu build na
aba Activities da página de detalhes do seu app no
[App Store Connect][appstoreconnect_login].
Você deve receber um e-mail em até 30 minutos notificando que
seu build foi validado e está disponível para publicação para testadores
no TestFlight. Neste ponto, você pode escolher se publica
no TestFlight ou se prossegue e publica seu app na App Store.

Para mais detalhes, consulte
[Upload an app to App Store Connect][distributionguide_upload].

## Crie um archive de build com Codemagic CLI tools

Esta etapa cobre a criação de um archive de build e o upload
do seu build para o App Store Connect usando comandos de build do Flutter
e [Codemagic CLI Tools][codemagic_cli_tools] executados em um terminal
no diretório do projeto Flutter. Isso permite criar um archive de build
com controle total de certificados de distribuição em um keychain temporário
isolado do seu keychain de login.

<ol>
<li>

Instale as Codemagic CLI tools:

```bash
pip3 install codemagic-cli-tools
```

</li>
<li>

Você precisará gerar uma [chave de API do App Store Connect][appstoreconnect_api_key]
com acesso App Manager para automatizar operações com o App Store Connect. Para tornar
os comandos subsequentes mais concisos, defina as seguintes variáveis de ambiente da
nova chave: issuer id, key id e arquivo de chave API.

```bash
export APP_STORE_CONNECT_ISSUER_ID=aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee
export APP_STORE_CONNECT_KEY_IDENTIFIER=ABC1234567
export APP_STORE_CONNECT_PRIVATE_KEY=`cat /path/to/api/key/AuthKey_XXXYYYZZZ.p8`
```

</li>
<li>

Você precisa exportar ou criar um certificado iOS Distribution para assinar o código e empacotar um archive de build.

Se você tiver [certificados][devportal_certificates] existentes, você pode exportar as
chaves privadas executando o seguinte comando para cada certificado:

```bash
openssl pkcs12 -in <certificate_name>.p12 -nodes -nocerts | openssl rsa -out cert_key
```

Ou você pode criar uma nova chave privada executando o seguinte comando:

```bash
ssh-keygen -t rsa -b 2048 -m PEM -f cert_key -q -N ""
```

Posteriormente, você pode fazer com que as CLI tools criem automaticamente um novo iOS Distribution a partir da chave privada.

</li>
<li>

Configure um novo keychain temporário para ser usado na assinatura de código:

```bash
keychain initialize
```

:::note Restaure o Login Keychain!
Após executar `keychain initialize` você **deve** executar o seguinte:<br>

`keychain use-login`

Isso define seu keychain de login como padrão para evitar potenciais
problemas de autenticação com apps na sua máquina.
:::

</li>
<li>

Busque os arquivos de assinatura de código do App Store Connect:

```bash
app-store-connect fetch-signing-files $(xcode-project detect-bundle-id) \
    --platform IOS \
    --type IOS_APP_STORE \
    --certificate-key=@file:/path/to/cert_key \
    --create
```

Onde `cert_key` é a chave privada do seu certificado iOS Distribution exportado
ou uma nova chave privada que gera automaticamente um novo certificado. O certificado
será criado a partir da chave privada se não existir no App Store Connect.

</li>
<li>

Agora adicione os certificados buscados ao seu keychain:

```bash
keychain add-certificates
```

</li>
<li>

Atualize as configurações do projeto Xcode para usar os perfis de assinatura de código buscados:

```bash
xcode-project use-profiles
```

</li>
<li>

Instale as dependências do Flutter:

```bash
flutter packages pub get
```

</li>
<li>

Instale as dependências do CocoaPods:

```bash
find . -name "Podfile" -execdir pod install \;
```

</li>
<li>

Compile o projeto iOS do Flutter:

```bash
flutter build ipa --release \
    --export-options-plist=$HOME/export_options.plist
```

Note que `export_options.plist` é a saída do comando `xcode-project use-profiles`.

</li>
<li>

Publique o app no App Store Connect:

```bash
app-store-connect publish \
    --path $(find $(pwd) -name "*.ipa")
```

</li>
<li>

Como mencionado anteriormente, não se esqueça de definir seu keychain de login
como padrão para evitar problemas de autenticação
com apps na sua máquina:

```bash
keychain use-login
```

</li>
</ol>

Você deve receber um e-mail em até 30 minutos notificando que
seu build foi validado e está disponível para publicação para testadores
no TestFlight. Neste ponto, você pode escolher se publica
no TestFlight ou se prossegue e publica seu app na App Store.

## Publique seu app no TestFlight

O [TestFlight][] permite que desenvolvedores enviem seus apps
para testadores internos e externos. Esta etapa opcional
cobre a publicação do seu build no TestFlight.

1. Navegue até a aba TestFlight da página de detalhes do aplicativo
   do seu app no [App Store Connect][appstoreconnect_login].
1. Selecione **Internal Testing** na barra lateral.
1. Selecione o build a ser publicado para testadores e clique em **Save**.
1. Adicione os endereços de e-mail de quaisquer testadores internos.
   Você pode adicionar usuários internos adicionais na página **Users and Roles**
   do App Store Connect,
   disponível no menu dropdown no topo da página.

Para mais detalhes, consulte
[Distribute an app using TestFlight][distributionguide_testflight].

## Publique seu app na App Store

Quando estiver pronto para publicar seu app para o mundo,
siga estas etapas para enviar seu app para revisão e
publicação na App Store:

1. Selecione **Pricing and Availability** na barra lateral da página de
   detalhes do aplicativo do seu app no
   [App Store Connect][appstoreconnect_login] e complete as
   informações necessárias.
1. Selecione o status na barra lateral. Se esta for a primeira
   publicação deste app, seu status é
   **1.0 Prepare for Submission**. Complete todos os campos obrigatórios.
1. Clique em **Submit for Review**.

A Apple notifica você quando o processo de revisão do app estiver completo.
Seu app é publicado de acordo com as instruções que você
especificou na seção **Version Release**.

Para mais detalhes, consulte
[Distribute an app through the App Store][distributionguide_submit].

## Solução de problemas

O guia [Distribute your app][distributionguide] fornece uma
visão geral detalhada do processo de publicação de um app na App Store.

[appreview]: {{site.apple-dev}}/app-store/review/
[appsigning]: https://help.apple.com/xcode/mac/current/#/dev154b28f09
[appstore]: {{site.apple-dev}}/app-store/submissions/
[appstoreconnect]: {{site.apple-dev}}/support/app-store-connect/
[appstoreconnect_api_key]: https://appstoreconnect.apple.com/access/api
[appstoreconnect_guide]: {{site.apple-dev}}/support/app-store-connect/
[appstoreconnect_guide_register]: https://help.apple.com/app-store-connect/#/dev2cd126805
[appstoreconnect_login]: https://appstoreconnect.apple.com/
[codemagic_cli_tools]: {{site.github}}/codemagic-ci-cd/cli-tools
[codesigning_guide]: {{site.apple-dev}}/library/content/documentation/Security/Conceptual/CodeSigningGuide/Introduction/Introduction.html
[Core Foundation Keys]: {{site.apple-dev}}/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
[devportal_appids]: {{site.apple-dev}}/account/ios/identifier/bundle
[devportal_certificates]: {{site.apple-dev}}/account/resources/certificates
[devprogram]: {{site.apple-dev}}/programs/
[devprogram_membership]: {{site.apple-dev}}/support/compare-memberships/
[distributionguide]: https://help.apple.com/xcode/mac/current/#/devac02c5ab8
[distributionguide_config]: https://help.apple.com/xcode/mac/current/#/dev91fe7130a
[distributionguide_submit]: https://help.apple.com/xcode/mac/current/#/dev067853c94
[distributionguide_testflight]: https://help.apple.com/xcode/mac/current/#/dev2539d985f
[distributionguide_upload]: https://help.apple.com/xcode/mac/current/#/dev442d7f2ca
[obfuscate your Dart code]: /deployment/obfuscate
[TestFlight]: {{site.apple-dev}}/testflight/
[app_bundle_export_method]: https://help.apple.com/xcode/mac/current/#/dev31de635e5
[apple_transport_app]: https://apps.apple.com/us/app/transporter/id1450874784
