---
ia-translate: true
title: Compilar e lançar um app iOS
description: Como lançar um app Flutter na App Store.
shortTitle: iOS
---

Este guia fornece um passo a passo detalhado para lançar um
app Flutter na [App Store][appstore] e [TestFlight][].

## Preliminares

Xcode é necessário para compilar e lançar seu app. Você
deve usar um dispositivo executando macOS para seguir este guia.

Antes de iniciar o processo de lançamento do seu app,
garanta que ele atende às [Diretrizes de Revisão de App][appreview] da Apple.

Para publicar seu app na App Store,
você deve primeiro se inscrever no [Apple Developer Program][devprogram].
Você pode ler mais sobre as várias opções de associação no guia
[Choosing a Membership][devprogram_membership] da Apple.

## Visão geral em vídeo

Para aqueles que preferem vídeo ao invés de texto,
o seguinte vídeo cobre o mesmo material que este guia.

<YouTubeEmbed id="iE2bpP56QKc" title="Release an iOS app built with Flutter in 7 steps"></YouTubeEmbed>

## Registre seu app no App Store Connect

Gerencie o ciclo de vida do seu app no
[App Store Connect][appstoreconnect] (anteriormente iTunes Connect).
Você define o nome e descrição do seu app, adiciona capturas de tela,
define preços e gerencia lançamentos para a App Store e TestFlight.

Registrar seu app envolve dois passos: registrar um
Bundle ID único e criar um registro de aplicação no App Store Connect.

Para uma visão geral detalhada do App Store Connect, veja o
guia [App Store Connect][appstoreconnect_guide].

### Registrar um Bundle ID

Toda aplicação iOS é associada com um Bundle ID,
um identificador único registrado na Apple.
Para registrar um Bundle ID para seu app, siga estes passos:

1. Abra a página [App IDs][devportal_appids] da sua conta de desenvolvedor.
1. Clique em **+** para criar um novo Bundle ID.
1. Digite um nome de app, selecione **Explicit App ID**, e digite um ID.
1. Selecione os serviços que seu app usa, depois clique em **Continue**.
1. Na próxima página, confirme os detalhes e clique em **Register**
   para registrar seu Bundle ID.

### Criar um registro de aplicação no App Store Connect

Registre seu app no App Store Connect:

1. Abra [App Store Connect][appstoreconnect_login] no seu navegador.
1. Na página inicial do App Store Connect, clique em **Apps**.
1. Clique em **+** no canto superior esquerdo,
   depois selecione **New App**.
1. Preencha os detalhes do seu app no formulário que aparece.
   Na seção Platforms, garanta que iOS esteja marcado.
   Como Flutter não suporta atualmente tvOS,
   deixe essa caixa de seleção desmarcada. Clique em **Create**.
1. Navegue até os detalhes da aplicação para seu app e selecione
   **App Information** na barra lateral.
1. Na seção General Information, selecione o Bundle ID
   que você registrou no passo anterior.

Para uma visão geral detalhada, veja
[Add an app to your account][appstoreconnect_guide_register].

## Revisar configurações do projeto Xcode

Este passo cobre a revisão das configurações mais importantes
no workspace do Xcode.
Para procedimentos e descrições detalhadas, veja
[Prepare for app distribution][distributionguide_config].

Navegue até as configurações do seu target no Xcode:

1. Abra o workspace padrão do Xcode no seu projeto executando
   `open ios/Runner.xcworkspace` em uma janela de terminal do seu
   diretório do projeto Flutter.
1. Para ver as configurações do seu app, selecione o target **Runner** no
   navegador do Xcode.

Verifique as configurações mais importantes.

Na seção **Identity** da aba **General**:

`Display Name`
: O nome de exibição do seu app.

`Bundle Identifier`
: O App ID que você registrou no App Store Connect.

Na aba **Signing & Capabilities**:

`Automatically manage signing`
: Se o Xcode deve gerenciar automaticamente a assinatura do app
  e provisionamento. Isso é definido como `true` por padrão, o que deve
  ser suficiente para a maioria dos apps. Para cenários mais complexos,
  veja o [Code Signing Guide][codesigning_guide].

`Team`
: Selecione o time associado com sua conta Apple Developer
  registrada. Se necessário, selecione **Add Account...**,
  depois atualize esta configuração.

Na seção **Deployment** da aba **Build Settings**:

`iOS Deployment Target`
: A versão mínima do iOS que seu app suporta.
  Flutter suporta iOS 13 e posterior. Se seu app ou plugins
  incluem código Objective-C ou Swift que faz uso de APIs mais recentes
  que iOS 12, atualize esta configuração para a versão mais alta necessária.

A aba **General** das configurações do seu projeto deve se parecer com
o seguinte:

![Xcode Project Settings](/assets/images/docs/releaseguide/xcode_settings.png){:width="100%"}

Para uma visão geral detalhada de assinatura de app, veja
[Create, export, and delete signing certificates][appsigning].

## Atualizar a versão de deployment do app

Se você mudou `Deployment Target` no seu projeto Xcode,
abra `ios/Flutter/AppframeworkInfo.plist` no seu app Flutter
e atualize o valor `MinimumOSVersion` para corresponder.

## Adicionar um ícone de app {:#add-an-app-icon}

Quando um novo app Flutter é criado, um conjunto de ícones placeholder é criado.
Este passo cobre substituir esses ícones placeholder pelos
ícones do seu app:

1. Revise as diretrizes de [ícone de app iOS][app-icon] e,
   em particular, o conselho sobre
   [criar ícones light, dark e tinted][icon-modes] para seu app.
1. No navegador de projetos do Xcode, selecione `Assets.xcassets` na
   pasta `Runner`. Atualize os ícones placeholder com seus próprios ícones de app.
1. Verifique se o ícone foi substituído executando seu app usando
   `flutter run`.

[app-icon]: {{site.apple-dev}}/design/human-interface-guidelines/app-icons/
[icon-modes]: {{site.apple-dev}}/design/human-interface-guidelines/app-icons#iOS-iPadOS

## Adicionar uma imagem de lançamento

Similar ao ícone do app,
você também pode substituir a imagem de lançamento placeholder:

1. No navegador de projetos do Xcode,
   selecione `Assets.xcassets` na pasta `Runner`.
   Atualize a imagem de lançamento placeholder com sua própria imagem de lançamento.
1. Verifique a nova imagem de lançamento reiniciando seu app com hot restart.
   (Não use `hot reload`.)

## Criar um arquivo de compilação e fazer upload para App Store Connect

Durante o desenvolvimento, você tem compilado, depurado e testado
com builds _debug_. Quando estiver pronto para enviar seu app para usuários
na App Store ou TestFlight, você precisa preparar um build _release_.

### Atualizar os números de build e versão do app {:#update-the-apps-build-and-version-numbers}

O número de versão padrão do app é `1.0.0`.
Para atualizá-lo, navegue até o arquivo `pubspec.yaml`
e atualize a seguinte linha:

```yaml
version: 1.0.0+1
```

O número de versão são três números separados por pontos,
como `1.0.0` no exemplo acima, seguido por um
número de build opcional como `1` no exemplo acima, separado por um `+`.

Tanto a versão quanto o número de build podem ser sobrescritos em
`flutter build ipa` especificando `--build-name` e `--build-number`,
respectivamente.

No iOS, `build-name` usa `CFBundleShortVersionString`
enquanto `build-number` usa `CFBundleVersion`.
Leia mais sobre versionamento iOS em [Core Foundation Keys][]
no site do Apple Developer.

Você também pode sobrescrever o nome de build e número do `pubspec.yaml` no Xcode:

1. Abra `Runner.xcworkspace` na pasta `ios` do seu app.
1. Selecione **Runner** no navegador de projetos do Xcode, depois selecione o
   target **Runner** na barra lateral de visualização de configurações.
1. Na seção Identity, atualize a **Version** para o número de
   versão visível ao usuário que você deseja publicar.
1. Na seção Identity, atualize o identificador **Build** para um
   número de build único usado para rastrear este build no App Store Connect.
   Cada upload requer um número de build único.

### Criar um bundle de app

Execute `flutter build ipa` para produzir um arquivo de compilação do Xcode (arquivo `.xcarchive`)
no diretório `build/ios/archive/` do seu projeto e um bundle de app
da App Store (arquivo `.ipa`) em `build/ios/ipa`.

Considere adicionar as flags `--obfuscate` e `--split-debug-info` para
[ofuscar seu código Dart][obfuscate your Dart code] para torná-lo mais difícil
de fazer engenharia reversa.

Se você não está distribuindo para a App Store, você pode opcionalmente
escolher um [método de exportação][app_bundle_export_method] diferente
adicionando a opção `--export-method ad-hoc`,
`--export-method development` ou `--export-method enterprise`.

:::note
Em versões do Flutter onde `flutter build ipa --export-method` não está disponível,
abra `build/ios/archive/MyApp.xcarchive` e siga as instruções abaixo
para validar e distribuir o app do Xcode.
:::

### Fazer upload do bundle de app para App Store Connect

Uma vez que o bundle de app é criado, faça upload dele para
[App Store Connect][appstoreconnect_login] por meio de:

<ol>
<li>

Instale e abra o [app Apple Transport macOS][apple_transport_app].
Arraste e solte o bundle de app `build/ios/ipa/*.ipa` no app.

</li>

<li>

Ou faça upload do bundle de app da linha de comando executando:

```bash
xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey your_api_key --apiIssuer your_issuer_id
```

Execute `man altool` para detalhes sobre como autenticar com a chave de API do App Store Connect.

</li>

<li>

Ou abra `build/ios/archive/MyApp.xcarchive` no Xcode.

Clique no botão **Validate App**. Se algum problema for relatado,
resolva-os e produza outro build. Você pode reutilizar o mesmo
ID de build até fazer upload de um arquivo.

Depois que o arquivo foi validado com sucesso, clique em
**Distribute App**.

:::note
Quando você exportar seu app no final de **Distribute App**,
Xcode criará um diretório contendo
um IPA do seu app e um arquivo `ExportOptions.plist`.
Você pode criar novos IPAs com as mesmas opções sem iniciar
Xcode executando
`flutter build ipa --export-options-plist=path/to/ExportOptions.plist`.
Veja `xcodebuild -h` para detalhes sobre as chaves nesta lista de propriedades.
:::

</li>
</ol>

Você pode acompanhar o status do seu build na
aba Activities da página de detalhes do seu app no
[App Store Connect][appstoreconnect_login].
Você deve receber um e-mail dentro de 30 minutos notificando que
seu build foi validado e está disponível para lançamento para testadores
no TestFlight. Neste ponto você pode escolher se lança
no TestFlight, ou prosseguir e lançar seu app na App Store.

Para mais detalhes, veja
[Upload an app to App Store Connect][distributionguide_upload].

## Criar um arquivo de compilação com Codemagic CLI tools

Este passo cobre criar um arquivo de compilação e fazer upload
do seu build para App Store Connect usando comandos de build Flutter
e [Codemagic CLI Tools][codemagic_cli_tools] executados em um terminal
no diretório do projeto Flutter. Isso permite que você crie um arquivo de compilação
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
com acesso App Manager para automatizar operações com App Store Connect. Para tornar
comandos subsequentes mais concisos, defina as seguintes variáveis de ambiente a partir
da nova chave: issuer id, key id, e arquivo de chave de API.

```bash
export APP_STORE_CONNECT_ISSUER_ID=aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee
export APP_STORE_CONNECT_KEY_IDENTIFIER=ABC1234567
export APP_STORE_CONNECT_PRIVATE_KEY=`cat /path/to/api/key/AuthKey_XXXYYYZZZ.p8`
```

</li>
<li>

Você precisa exportar ou criar um certificado de Distribuição iOS para assinar código e empacotar um arquivo de compilação.

Se você tem [certificados][devportal_certificates] existentes, você pode exportar as
chaves privadas executando o seguinte comando para cada certificado:

```bash
openssl pkcs12 -in <certificate_name>.p12 -nodes -nocerts | openssl rsa -out cert_key
```

Ou você pode criar uma nova chave privada executando o seguinte comando:

```bash
ssh-keygen -t rsa -b 2048 -m PEM -f cert_key -q -N ""
```

Posteriormente, você pode fazer com que as CLI tools criem automaticamente uma nova Distribuição iOS a partir da chave privada.

</li>
<li>

Configure um novo keychain temporário para ser usado para assinatura de código:

```bash
keychain initialize
```

:::note Restaure o Login Keychain!
Depois de executar `keychain initialize` você **deve** executar o seguinte:<br>

`keychain use-login`

Isso define seu keychain de login como o padrão para evitar possíveis
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

Onde `cert_key` é sua chave privada de certificado de Distribuição iOS exportada
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

Atualize as configurações do projeto Xcode para usar perfis de assinatura de código buscados:

```bash
xcode-project use-profiles
```

</li>
<li>

Instale as dependências Flutter:

```bash
flutter packages pub get
```

</li>
<li>

Instale as dependências CocoaPods:

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
como o padrão para evitar problemas de autenticação
com apps na sua máquina:

```bash
keychain use-login
```

</li>
</ol>

Você deve receber um e-mail dentro de 30 minutos notificando que
seu build foi validado e está disponível para lançamento para testadores
no TestFlight. Neste ponto você pode escolher se lança
no TestFlight, ou prosseguir e lançar seu app na App Store.

## Lançar seu app no TestFlight

[TestFlight][] permite que desenvolvedores enviem seus apps
para testadores internos e externos. Este passo opcional
cobre lançar seu build no TestFlight.

1. Navegue até a aba TestFlight da página de detalhes da aplicação
   do seu app no [App Store Connect][appstoreconnect_login].
1. Selecione **Internal Testing** na barra lateral.
1. Selecione o build para publicar para testadores, depois clique em **Save**.
1. Adicione os endereços de e-mail de quaisquer testadores internos.
   Você pode adicionar usuários internos adicionais na página **Users and Roles**
   do App Store Connect,
   disponível no menu dropdown no topo da página.

Para mais detalhes, veja
[Distribute an app using TestFlight][distributionguide_testflight].

## Lançar seu app na App Store

Quando estiver pronto para lançar seu app para o mundo,
siga estes passos para enviar seu app para revisão e
lançamento na App Store:

1. Selecione **Pricing and Availability** na barra lateral da página de
   detalhes da aplicação do seu app no
   [App Store Connect][appstoreconnect_login] e complete as
   informações necessárias.
1. Selecione o status na barra lateral. Se este é o primeiro
   lançamento deste app, seu status é
   **1.0 Prepare for Submission**. Complete todos os campos obrigatórios.
1. Clique em **Submit for Review**.

A Apple notifica você quando o processo de revisão do app está completo.
Seu app é lançado de acordo com as instruções que você
especificou na seção **Version Release**.

Para mais detalhes, veja
[Distribute an app through the App Store][distributionguide_submit].

## Solução de problemas

O guia [Distribute your app][distributionguide] fornece uma
visão geral detalhada do processo de lançar um app na App Store.

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
