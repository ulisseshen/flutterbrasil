---
ia-translate: true
title: Compilar e lançar um app macOS
description: Como lançar um app Flutter na macOS App Store.
shortTitle: macOS
---

Este guia fornece um passo a passo detalhado para lançar um
app Flutter na [App Store][appstore].

## Preliminares

Antes de iniciar o processo de lançamento do seu app,
garanta que ele atende às
[Diretrizes de Revisão de App][appreview] da Apple.

Para publicar seu app na App Store,
você deve primeiro se inscrever no
[Apple Developer Program][devprogram].
Você pode ler mais sobre as várias
opções de associação no guia
[Choosing a Membership][devprogram_membership] da Apple.

## Registre seu app no App Store Connect

Gerencie o ciclo de vida do seu app no
[App Store Connect][appstoreconnect_login] (anteriormente iTunes Connect).
Você define o nome e descrição do seu app, adiciona capturas de tela,
define preços e gerencia lançamentos para a App Store e TestFlight.

Registrar seu app envolve dois passos: registrar um
Bundle ID único e criar um registro de aplicação no App Store Connect.

Para uma visão geral detalhada do App Store Connect, veja o
guia [App Store Connect][appstoreconnect_guide].

### Registrar um Bundle ID

Toda aplicação macOS é associada com um Bundle ID,
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
1. Na página inicial do App Store Connect, clique em **My Apps**.
1. Clique em **+** no canto superior esquerdo da página My Apps,
   depois selecione **New App**.
1. Preencha os detalhes do seu app no formulário que aparece.
   Na seção Platforms, garanta que macOS esteja marcado.
   Como Flutter não suporta atualmente tvOS,
   deixe essa caixa de seleção desmarcada. Clique em **Create**.
1. Navegue até os detalhes da aplicação para seu app e selecione
   **App Information** na barra lateral.
1. Na seção General Information, selecione o Bundle ID
   que você registrou no passo anterior.

Para uma visão geral detalhada,
veja [Add an app to your account][appstoreconnect_guide_register].

## Revisar configurações do projeto Xcode

Este passo cobre a revisão das configurações mais importantes
no workspace do Xcode.
Para procedimentos e descrições detalhadas, veja
[Prepare for app distribution][distributionguide_config].

Navegue até as configurações do seu target no Xcode:

1. No Xcode, abra `Runner.xcworkspace` na pasta `macos` do seu app.
1. Para ver as configurações do seu app, selecione o projeto **Runner** no navegador de
   projetos do Xcode. Depois, na barra lateral de visualização principal, selecione o
   target **Runner**.
1. Selecione a aba **General**.

Verifique as configurações mais importantes.

Na seção **Identity**:

`App Category`
: A categoria de app sob a qual seu app será listado na Mac App Store. Isso não pode ser none.

`Bundle Identifier`
: O App ID que você registrou no App Store Connect.

Na seção **Deployment info**:

`Deployment Target`
: A versão mínima do macOS que seu app suporta.
  Para verificar quais versões do macOS o Flutter suporta para deployment,
  confira as [Plataformas de deployment suportadas][Supported deployment platforms] do Flutter.

Na seção **Signing & Capabilities**:

`Automatically manage signing`
: Se o Xcode deve gerenciar automaticamente a assinatura do app
  e provisionamento. Isso é definido como `true` por padrão, o que deve
  ser suficiente para a maioria dos apps. Para cenários mais complexos,
  veja o [Code Signing Guide][codesigning_guide].

`Team`
: Selecione o time associado com sua conta Apple Developer
  registrada. Se necessário, selecione **Add Account...**,
  depois atualize esta configuração.

A aba **General** das configurações do seu projeto deve se parecer com
o seguinte:

![Xcode Project Settings](/assets/images/docs/releaseguide/macos_xcode_settings.png){:width="100%"}

Para uma visão geral detalhada de assinatura de app, veja
[Create, export, and delete signing certificates][appsigning].

[Supported deployment platforms]: /reference/supported-platforms

## Configurando o nome, bundle identifier e copyright do app

A configuração para os identificadores de produto está centralizada
em `macos/Runner/Configs/AppInfo.xcconfig`. Para o nome do app,
defina `PRODUCT_NAME`, para o copyright defina `PRODUCT_COPYRIGHT`,
e finalmente defina `PRODUCT_BUNDLE_IDENTIFIER` para o
bundle identifier do app.

## Atualizar o número de versão do app

O número de versão padrão do app é `1.0.0`.
Para atualizá-lo, navegue até o arquivo `pubspec.yaml`
e atualize a seguinte linha:

`version: 1.0.0+1`

O número de versão são três números separados por pontos,
como `1.0.0` no exemplo acima, seguido por um
número de build opcional como `1` no exemplo acima, separado por um `+`.

Tanto a versão quanto o número de build podem ser sobrescritos no build do
Flutter especificando `--build-name` e `--build-number`,
respectivamente.

No macOS, `build-name` usa `CFBundleShortVersionString`
enquanto `build-number` usa `CFBundleVersion`.
Leia mais sobre versionamento iOS em [Core Foundation Keys][]
no site do Apple Developer.

## Adicionar um ícone de app

Quando um novo app Flutter é criado, um conjunto de ícones placeholder é criado.
Este passo cobre substituir esses ícones placeholder pelos
ícones do seu app:

1. Revise as diretrizes de [ícone de app macOS][appicon].
1. No navegador de projetos do Xcode, selecione `Assets.xcassets` na
   pasta `Runner`. Atualize os ícones placeholder com seus próprios ícones de app.
1. Verifique se o ícone foi substituído executando seu app usando
   `flutter run -d macos`.

## Criar um arquivo de compilação com Xcode

Este passo cobre criar um arquivo de compilação e fazer upload
do seu build para App Store Connect usando Xcode.

Durante o desenvolvimento, você tem compilado, depurado e testado
com builds _debug_. Quando estiver pronto para enviar seu app para usuários
na App Store ou TestFlight, você precisa preparar um build _release_.
Neste ponto, você pode considerar [ofuscar seu código Dart][obfuscating your Dart code]
para torná-lo mais difícil de fazer engenharia reversa. Ofuscar
seu código envolve adicionar algumas flags ao seu comando de build.

No Xcode, configure a versão e build do app:

1. Abra `Runner.xcworkspace` na pasta `macos` do seu app. Para fazer isso da
   linha de comando, execute o seguinte comando do diretório base do seu
   projeto de aplicação.
   ```console
   open macos/Runner.xcworkspace
   ```
1. Selecione **Runner** no navegador de projetos do Xcode, depois selecione o
   target **Runner** na barra lateral de visualização de configurações.
1. Na seção Identity, atualize a **Version** para o número de
   versão visível ao usuário que você deseja publicar.
1. Na seção Identity, atualize o identificador **Build** para um
   número de build único usado para rastrear este build no App Store Connect.
   Cada upload requer um número de build único.

Finalmente, crie um arquivo de compilação e faça upload dele para App Store Connect:

1. Crie um Archive release da sua aplicação. Do diretório base do
   seu projeto de aplicação, execute o seguinte.
   ```console
   flutter build macos
   ```
1. Abra Xcode e selecione **Product > Archive** para abrir o arquivo criado
   no passo anterior.
1. Clique no botão **Validate App**. Se algum problema for relatado,
   resolva-os e produza outro build. Você pode reutilizar o mesmo
   ID de build até fazer upload de um arquivo.
1. Depois que o arquivo foi validado com sucesso, clique em
   **Distribute App**. Você pode acompanhar o status do seu build na
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

Você precisa exportar ou criar um certificado de Distribuição Mac App e um
certificado de Distribuição Mac Installer para executar assinatura de código e empacotar um arquivo de compilação.

Se você tem [certificados][devportal_certificates] existentes, você pode exportar as
chaves privadas executando o seguinte comando para cada certificado:

```bash
openssl pkcs12 -in <certificate_name>.p12 -nodes -nocerts | openssl rsa -out cert_key
```

Ou você pode criar uma nova chave privada executando o seguinte comando:

```bash
ssh-keygen -t rsa -b 2048 -m PEM -f cert_key -q -N ""
```

Posteriormente, você pode fazer com que as CLI tools criem automaticamente um novo certificado de Distribuição Mac App e
Distribuição Mac Installer. Você pode usar a mesma chave privada para
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

Onde `cert_key` é sua chave privada de certificado de Distribuição Mac App exportada
ou uma nova chave privada que gera automaticamente um novo certificado.

</li>
<li>

Se você não tem um certificado de Distribuição Mac Installer,
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

Busque os certificados de Distribuição Mac Installer:

```bash
app-store-connect certificates list \
    --type MAC_INSTALLER_DISTRIBUTION \
    --certificate-key=@file:/path/to/cert_key \
    --save
```

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
como o padrão para evitar problemas de autenticação
com apps na sua máquina:

```bash
keychain use-login
```

</li>
</ol>

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

## Distribuir para dispositivos registrados

Veja o [guia de distribuição][distributionguide_macos]
para preparar um arquivo para distribuição para computadores Mac designados.

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

## Recursos adicionais

Para aprender como empacotar e distribuir seu app desktop Flutter
para macOS da maneira open source, sem usar uma conta Apple Developer
paga, confira o
[guia de empacotamento macOS][macos_packaging_guide] passo a passo.

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
