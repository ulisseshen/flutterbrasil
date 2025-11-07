---
ia-translate: true
title: Compile e publique um app macOS
description: Como publicar um app Flutter na macOS App Store.
short-title: macOS
---

Este guia fornece um passo a passo detalhado para publicar um
app Flutter na [App Store][appstore].

## Preliminares

Antes de começar o processo de publicação do seu app,
certifique-se de que ele atenda às
[Diretrizes de Revisão de Apps][appreview] da Apple.

Para publicar seu app na App Store,
você deve primeiro se inscrever no
[Apple Developer Program][devprogram].
Você pode ler mais sobre as várias
opções de associação no guia
[Choosing a Membership][devprogram_membership] da Apple.

## Registre seu app no App Store Connect

Gerencie o ciclo de vida do seu app no
[App Store Connect][appstoreconnect_login] (anteriormente iTunes Connect).
Você define o nome e a descrição do seu app, adiciona capturas de tela,
define preços e gerencia publicações na App Store e no TestFlight.

Registrar seu app envolve duas etapas: registrar um
Bundle ID único e criar um registro de aplicativo no App Store Connect.

Para uma visão geral detalhada do App Store Connect, consulte o
guia [App Store Connect][appstoreconnect_guide].

### Registre um Bundle ID

Cada aplicação macOS está associada a um Bundle ID,
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
   Na seção Platforms, certifique-se de que macOS esteja marcado.
   Como o Flutter atualmente não suporta tvOS,
   deixe essa caixa de seleção desmarcada. Clique em **Create**.
1. Navegue até os detalhes do aplicativo do seu app e selecione
   **App Information** na barra lateral.
1. Na seção General Information, selecione o Bundle ID
   que você registrou na etapa anterior.

Para uma visão geral detalhada,
consulte [Add an app to your account][appstoreconnect_guide_register].

## Revise as configurações do projeto Xcode

Esta etapa cobre a revisão das configurações mais importantes
no workspace do Xcode.
Para procedimentos e descrições detalhadas, consulte
[Prepare for app distribution][distributionguide_config].

Navegue até as configurações do seu target no Xcode:

1. No Xcode, abra `Runner.xcworkspace` na pasta `macos` do seu app.
1. Para visualizar as configurações do seu app, selecione o projeto **Runner** no
   navegador de projetos do Xcode. Então, na barra lateral da visualização principal, selecione o
   target **Runner**.
1. Selecione a aba **General**.

Verifique as configurações mais importantes.

Na seção **Identity**:

`App Category`
: A categoria do app sob a qual seu app será listado na Mac App Store. Isso não pode ser none.

`Bundle Identifier`
: O App ID que você registrou no App Store Connect.

Na seção **Deployment info**:

`Deployment Target`
: A versão mínima do macOS que seu app suporta.
  O Flutter suporta a implantação de apps no macOS {{site.targetmin.macos}} e posterior.

Na seção **Signing & Capabilities**:

`Automatically manage signing`
: Se o Xcode deve gerenciar automaticamente a assinatura e
  o provisionamento do app. Isso é definido como `true` por padrão, o que deve
  ser suficiente para a maioria dos apps. Para cenários mais complexos,
  consulte o [Code Signing Guide][codesigning_guide].

`Team`
: Selecione a equipe associada à sua conta Apple Developer
  registrada. Se necessário, selecione **Add Account...**
  e atualize esta configuração.

A aba **General** das configurações do seu projeto deve ser semelhante
ao seguinte:

![Xcode Project Settings](/assets/images/docs/releaseguide/macos_xcode_settings.png){:width="100%"}

Para uma visão geral detalhada da assinatura de apps, consulte
[Create, export, and delete signing certificates][appsigning].

## Configurando o nome do app, bundle identifier e copyright

A configuração para os identificadores de produto é centralizada
em `macos/Runner/Configs/AppInfo.xcconfig`. Para o nome do app,
defina `PRODUCT_NAME`, para o copyright defina `PRODUCT_COPYRIGHT`,
e finalmente defina `PRODUCT_BUNDLE_IDENTIFIER` para o
bundle identifier do app.

## Atualizando o número de versão do app

O número de versão padrão do app é `1.0.0`.
Para atualizá-lo, navegue até o arquivo `pubspec.yaml`
e atualize a seguinte linha:

`version: 1.0.0+1`

O número de versão é composto por três números separados por pontos,
como `1.0.0` no exemplo acima, seguido por um número opcional
de build como `1` no exemplo acima, separado por um `+`.

Tanto a versão quanto o número de build podem ser sobrescritos no build do Flutter
especificando `--build-name` e `--build-number`,
respectivamente.

No macOS, `build-name` usa `CFBundleShortVersionString`
enquanto `build-number` usa `CFBundleVersion`.
Leia mais sobre versionamento no iOS em [Core Foundation Keys][]
no site do Apple Developer.

## Adicione um ícone de app

Quando um novo app Flutter é criado, um conjunto de ícones placeholder é criado.
Esta etapa cobre a substituição desses ícones placeholder pelos
ícones do seu app:

1. Revise as diretrizes [macOS App Icon][appicon].
1. No navegador de projetos do Xcode, selecione `Assets.xcassets` na
   pasta `Runner`. Atualize os ícones placeholder com os ícones do seu próprio app.
1. Verifique se o ícone foi substituído executando seu app usando
   `flutter run -d macos`.

## Crie um archive de build com o Xcode

Esta etapa cobre a criação de um archive de build e o upload
do seu build para o App Store Connect usando o Xcode.

Durante o desenvolvimento, você tem compilado, depurado e testado
com builds _debug_. Quando estiver pronto para enviar seu app aos usuários
na App Store ou no TestFlight, você precisa preparar um build _release_.
Neste ponto, você pode considerar [ofuscar seu código Dart][obfuscating your Dart code]
para tornar mais difícil fazer engenharia reversa. Ofuscar
seu código envolve adicionar algumas flags ao seu comando de build.

No Xcode, configure a versão e o build do app:

1. Abra `Runner.xcworkspace` na pasta `macos` do seu app. Para fazer isso a partir
   da linha de comando, execute o seguinte comando do diretório base do seu
   projeto de aplicação.
   ```console
   open macos/Runner.xcworkspace
   ```
1. Selecione **Runner** no navegador de projetos do Xcode e, em seguida, selecione o
   target **Runner** na barra lateral de visualização de configurações.
1. Na seção Identity, atualize a **Version** para o número de
   versão voltado ao usuário que você deseja publicar.
1. Na seção Identity, atualize o identificador **Build** para um número
   de build único usado para rastrear este build no App Store Connect.
   Cada upload requer um número de build único.

Finalmente, crie um archive de build e faça upload para o App Store Connect:

1. Crie um Archive de release da sua aplicação. Do diretório base do
   seu projeto de aplicação, execute o seguinte.
   ```console
   flutter build macos
   ```
1. Abra o Xcode e selecione **Product > Archive** para abrir o archive criado
   na etapa anterior.
1. Clique no botão **Validate App**. Se algum problema for relatado,
   resolva-o e produza outro build. Você pode reutilizar o mesmo
   build ID até fazer upload de um archive.
1. Após o archive ser validado com sucesso, clique em
   **Distribute App**. Você pode acompanhar o status do seu build na
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
no diretório do projeto Flutter.

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

Você precisa exportar ou criar um certificado Mac App Distribution e um
Mac Installer Distribution para realizar assinatura de código e empacotar um archive de build.

Se você tiver [certificados][devportal_certificates] existentes, você pode exportar as
chaves privadas executando o seguinte comando para cada certificado:

```bash
openssl pkcs12 -in <certificate_name>.p12 -nodes -nocerts | openssl rsa -out cert_key
```

Ou você pode criar uma nova chave privada executando o seguinte comando:

```bash
ssh-keygen -t rsa -b 2048 -m PEM -f cert_key -q -N ""
```

Posteriormente, você pode fazer com que as CLI tools criem automaticamente um novo certificado Mac App Distribution e
Mac Installer Distribution. Você pode usar a mesma chave privada para
cada novo certificado.

</li>
<li>

Busque os arquivos de assinatura de código do App Store Connect:

```bash
app-store-connect fetch-signing-files YOUR.APP.BUNDLE_ID \
    --platform MAC_OS \
    --type MAC_APP_STORE \
    --certificate-key=@file:/path/to/cert_key \
    --create
```

Onde `cert_key` é a chave privada do seu certificado Mac App Distribution exportado
ou uma nova chave privada que gera automaticamente um novo certificado.

</li>
<li>

Se você não tiver um certificado Mac Installer Distribution,
você pode criar um novo certificado executando o seguinte:

```bash
app-store-connect certificates create \
    --type MAC_INSTALLER_DISTRIBUTION \
    --certificate-key=@file:/path/to/cert_key \
    --save
```

Use `cert_key` da chave privada que você criou anteriormente.

</li>
<li>

Busque os certificados Mac Installer Distribution:

```bash
app-store-connect certificates list \
    --type MAC_INSTALLER_DISTRIBUTION \
    --certificate-key=@file:/path/to/cert_key \
    --save
```

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

Compile o projeto macOS do Flutter:

```bash
flutter build macos --release
```

</li>
<li>

Empacote o app:

```bash
APP_NAME=$(find $(pwd) -name "*.app")
PACKAGE_NAME=$(basename "$APP_NAME" .app).pkg
xcrun productbuild --component "$APP_NAME" /Applications/ unsigned.pkg

INSTALLER_CERT_NAME=$(keychain list-certificates \
          | jq '[.[]
            | select(.common_name
            | contains("Mac Developer Installer"))
            | .common_name][0]' \
          | xargs)
xcrun productsign --sign "$INSTALLER_CERT_NAME" unsigned.pkg "$PACKAGE_NAME"
rm -f unsigned.pkg
```

</li>
<li>

Publique o app empacotado no App Store Connect:

```bash
app-store-connect publish \
    --path "$PACKAGE_NAME"
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

## Distribua para dispositivos registrados

Consulte o [guia de distribuição][distributionguide_macos]
para preparar um archive para distribuição em computadores Mac designados.

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

## Recursos adicionais

Para aprender como empacotar e distribuir seu app desktop Flutter
para macOS da forma open source, sem usar uma conta paga de desenvolvedor Apple,
confira o [guia de empacotamento macOS][macos_packaging_guide]
passo a passo.

[appicon]: {{site.apple-dev}}/design/human-interface-guidelines/macos/icons-and-images/app-icon/
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
[devportal_appids]: {{site.apple-dev}}/account/resources/identifiers/list
[devportal_certificates]: {{site.apple-dev}}/account/resources/certificates/list
[devprogram]: {{site.apple-dev}}/programs/
[devprogram_membership]: {{site.apple-dev}}/support/compare-memberships/
[distributionguide]: https://help.apple.com/xcode/mac/current/#/dev8b4250b57
[distributionguide_config]: https://help.apple.com/xcode/mac/current/#/dev91fe7130a
[distributionguide_macos]: https://help.apple.com/xcode/mac/current/#/dev295cc0fae
[distributionguide_submit]: https://help.apple.com/xcode/mac/current/#/dev067853c94
[distributionguide_upload]: https://help.apple.com/xcode/mac/current/#/dev442d7f2ca
[obfuscating your Dart code]: /deployment/obfuscate
[TestFlight]: {{site.apple-dev}}/testflight/
[macos_packaging_guide]: https://medium.com/@fluttergems/packaging-and-distributing-flutter-desktop-apps-the-missing-guide-part-1-macos-b36438269285
