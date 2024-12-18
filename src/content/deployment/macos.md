---
ia-translate: true
title: Construir e lançar um aplicativo macOS
description: Como lançar um aplicativo Flutter na macOS App Store.
short-title: macOS
---

Este guia fornece um passo a passo de como lançar um
aplicativo Flutter na [App Store][appstore].

## Preliminares

Antes de iniciar o processo de lançamento do seu aplicativo,
certifique-se de que ele esteja em conformidade com as
[Diretrizes de Revisão de Aplicativos][appreview] da Apple.

Para publicar seu aplicativo na App Store,
você deve primeiro se inscrever no
[Programa de Desenvolvedores da Apple][devprogram].
Você pode ler mais sobre as diversas
opções de associação no guia da Apple
[Escolhendo uma Associação][devprogram_membership].

## Registre seu aplicativo no App Store Connect

Gerencie o ciclo de vida do seu aplicativo no
[App Store Connect][appstoreconnect_login] (anteriormente iTunes Connect).
Você define o nome e a descrição do seu aplicativo, adiciona capturas de tela,
define o preço e gerencia os lançamentos para a App Store e TestFlight.

O registro do seu aplicativo envolve duas etapas: registrar um
Bundle ID exclusivo e criar um registro de aplicativo no App Store Connect.

Para uma visão geral detalhada do App Store Connect, consulte o
guia [App Store Connect][appstoreconnect_guide].

### Registrar um Bundle ID

Cada aplicativo macOS está associado a um Bundle ID,
um identificador exclusivo registrado na Apple.
Para registrar um Bundle ID para seu aplicativo, siga estas etapas:

1. Abra a página [App IDs][devportal_appids] da sua conta de desenvolvedor.
2. Clique em **+** para criar um novo Bundle ID.
3. Insira um nome de aplicativo, selecione **Explicit App ID** e insira um ID.
4. Selecione os serviços que seu aplicativo usa e clique em **Continue**.
5. Na próxima página, confirme os detalhes e clique em **Register**
   para registrar seu Bundle ID.

### Criar um registro de aplicativo no App Store Connect

Registre seu aplicativo no App Store Connect:

1. Abra o [App Store Connect][appstoreconnect_login] no seu navegador.
2. Na página inicial do App Store Connect, clique em **My Apps**.
3. Clique em **+** no canto superior esquerdo da página My Apps,
   em seguida, selecione **New App**.
4. Preencha os detalhes do seu aplicativo no formulário que aparece.
   Na seção Platforms, certifique-se de que macOS esteja selecionado.
   Como o Flutter não oferece suporte atualmente ao tvOS,
   deixe essa caixa de seleção desmarcada. Clique em **Create**.
5. Navegue até os detalhes do aplicativo do seu aplicativo e selecione
   **App Information** na barra lateral.
6. Na seção General Information, selecione o Bundle ID
   que você registrou na etapa anterior.

Para uma visão geral detalhada,
consulte [Adicionar um aplicativo à sua conta][appstoreconnect_guide_register].

## Revisar as configurações do projeto Xcode

Esta etapa aborda a revisão das configurações mais importantes
no workspace do Xcode.
Para procedimentos e descrições detalhadas, consulte
[Prepare-se para a distribuição de aplicativos][distributionguide_config].

Navegue até as configurações do seu alvo no Xcode:

1. No Xcode, abra `Runner.xcworkspace` na pasta `macos` do seu aplicativo.
2. Para visualizar as configurações do seu aplicativo, selecione o projeto
   **Runner** no navegador de projetos do Xcode. Em seguida, na barra
   lateral da visualização principal, selecione o alvo **Runner**.
3. Selecione a guia **General**.

Verifique as configurações mais importantes.

Na seção **Identity**:

`App Category`
: A categoria de aplicativo sob a qual seu aplicativo será listado na Mac App Store. Esta opção não pode ser "nenhum".

`Bundle Identifier`
: O App ID que você registrou no App Store Connect.

Na seção **Deployment info**:

`Deployment Target`
: A versão mínima do macOS que seu aplicativo suporta.
  O Flutter suporta a implantação de aplicativos no macOS {{site.targetmin.macos}} e versões posteriores.

Na seção **Signing & Capabilities**:

`Automatically manage signing`
: Se o Xcode deve gerenciar automaticamente a assinatura do aplicativo
  e o provisionamento. Isso é definido como `true` por padrão, o que deve
  ser suficiente para a maioria dos aplicativos. Para cenários mais complexos,
  consulte o [Guia de Assinatura de Código][codesigning_guide].

`Team`
: Selecione a equipe associada à sua conta de desenvolvedor Apple
  registrada. Se necessário, selecione **Add Account...**,
  e atualize esta configuração.

A guia **General** das configurações do seu projeto deve ser semelhante a
seguinte:

![Configurações do projeto Xcode](/assets/images/docs/releaseguide/macos_xcode_settings.png){:width="100%"}

Para uma visão geral detalhada da assinatura de aplicativos, consulte
[Criar, exportar e excluir certificados de assinatura][appsigning].

## Configurando o nome do aplicativo, o identificador do pacote e os direitos autorais

A configuração para os identificadores do produto está centralizada
em `macos/Runner/Configs/AppInfo.xcconfig`. Para o nome do aplicativo,
defina `PRODUCT_NAME`, para os direitos autorais, defina `PRODUCT_COPYRIGHT`,
e, finalmente, defina `PRODUCT_BUNDLE_IDENTIFIER` para o
identificador do pacote do aplicativo.

## Atualizando o número da versão do aplicativo

O número de versão padrão do aplicativo é `1.0.0`.
Para atualizá-lo, navegue até o arquivo `pubspec.yaml`
e atualize a seguinte linha:

`version: 1.0.0+1`

O número da versão é composto por três números separados por pontos,
como `1.0.0` no exemplo acima, seguido por um número
de build opcional, como `1` no exemplo acima, separado por um `+`.

Tanto a versão quanto o número de build podem ser substituídos no build
do Flutter especificando `--build-name` e `--build-number`,
respectivamente.

No macOS, `build-name` usa `CFBundleShortVersionString`,
enquanto `build-number` usa `CFBundleVersion`.
Leia mais sobre o versionamento do iOS em [Chaves do Core Foundation][]
no site da Apple Developer.

## Adicionar um ícone de aplicativo

Quando um novo aplicativo Flutter é criado, um conjunto de ícones
de espaço reservado é criado.
Esta etapa aborda a substituição desses ícones de espaço reservado
pelos ícones do seu aplicativo:

1. Revise as diretrizes do [Ícone de Aplicativo macOS][appicon].
2. No navegador de projetos do Xcode, selecione `Assets.xcassets`
   na pasta `Runner`. Atualize os ícones de espaço reservado
   com os ícones do seu próprio aplicativo.
3. Verifique se o ícone foi substituído executando seu aplicativo usando
   `flutter run -d macos`.

## Criar um arquivo de build com o Xcode

Esta etapa aborda a criação de um arquivo de build e o envio
do seu build para o App Store Connect usando o Xcode.

Durante o desenvolvimento, você tem construído, depurado e testado
com builds de _debug_. Quando você estiver pronto para enviar seu aplicativo para
usuários na App Store ou TestFlight, você precisa preparar um build de _release_.
Nesse ponto, você pode considerar [obfuscar seu código Dart][]
para torná-lo mais difícil de fazer engenharia reversa. Obfuscar
seu código envolve adicionar algumas flags ao seu comando de build.

No Xcode, configure a versão e o build do aplicativo:

1. Abra `Runner.xcworkspace` na pasta `macos` do seu aplicativo. Para fazer
   isso na linha de comando, execute o seguinte comando no diretório base do seu
   projeto de aplicativo.
   ```console
   open macos/Runner.xcworkspace
   ```
2. Selecione **Runner** no navegador de projetos do Xcode e, em seguida,
   selecione o alvo **Runner** na barra lateral da visualização de configurações.
3. Na seção Identity, atualize a **Version** para o número de versão
   voltado para o usuário que você deseja publicar.
4. Na seção Identity, atualize o identificador **Build** para um número
   de build exclusivo usado para rastrear este build no App Store Connect.
   Cada upload requer um número de build exclusivo.

Finalmente, crie um arquivo de build e envie-o para o App Store Connect:

1. Crie um Arquivo de lançamento do seu aplicativo. No diretório base do
   seu projeto de aplicativo, execute o seguinte.
   ```console
   flutter build macos
   ```
2. Abra o Xcode e selecione **Product > Archive** para abrir o arquivo
   criado na etapa anterior.
3. Clique no botão **Validate App**. Se algum problema for relatado,
   resolva-o e produza outro build. Você pode reutilizar o mesmo
   ID de build até enviar um arquivo.
4. Depois que o arquivo for validado com sucesso, clique em
   **Distribute App**. Você pode acompanhar o status do seu build
   na guia Activities da página de detalhes do seu aplicativo no
   [App Store Connect][appstoreconnect_login].

Você deve receber um e-mail em até 30 minutos informando que
seu build foi validado e está disponível para lançamento para
testadores no TestFlight. Neste ponto, você pode escolher se deseja
lançar no TestFlight ou prosseguir e lançar seu aplicativo na App Store.

Para mais detalhes, veja
[Enviar um aplicativo para o App Store Connect][distributionguide_upload].

## Criar um arquivo de build com ferramentas Codemagic CLI

Esta etapa aborda a criação de um arquivo de build e o envio
do seu build para o App Store Connect usando comandos de build
do Flutter e [Ferramentas Codemagic CLI][codemagic_cli_tools] executadas em um terminal no diretório do projeto Flutter.

<ol>
<li>

Instale as ferramentas Codemagic CLI:

```bash
pip3 install codemagic-cli-tools
```

</li>
<li>

Você precisará gerar uma [Chave de API do App Store Connect][appstoreconnect_api_key]
com acesso de App Manager para automatizar as operações com o App Store Connect. Para tornar
os comandos subsequentes mais concisos, defina as seguintes variáveis de ambiente
da nova chave: ID do emissor, ID da chave e arquivo de chave API.

```bash
export APP_STORE_CONNECT_ISSUER_ID=aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee
export APP_STORE_CONNECT_KEY_IDENTIFIER=ABC1234567
export APP_STORE_CONNECT_PRIVATE_KEY=`cat /caminho/para/api/chave/AuthKey_XXXYYYZZZ.p8`
```

</li>
<li>

Você precisa exportar ou criar um certificado de Distribuição de Aplicativos Mac e um certificado de Distribuição de Instaladores Mac para realizar a assinatura de código e empacotar um arquivo de build.

Se você tiver [certificados][devportal_certificates] existentes, você pode exportar as
chaves privadas executando o seguinte comando para cada certificado:

```bash
openssl pkcs12 -in <nome_certificado>.p12 -nodes -nocerts | openssl rsa -out cert_key
```

Ou você pode criar uma nova chave privada executando o seguinte comando:

```bash
ssh-keygen -t rsa -b 2048 -m PEM -f cert_key -q -N ""
```

Posteriormente, você pode fazer com que as ferramentas CLI criem automaticamente um novo certificado de Distribuição de Aplicativos Mac e Distribuição de Instaladores Mac. Você pode usar a mesma chave privada para cada novo certificado.

</li>
<li>

Busque os arquivos de assinatura de código do App Store Connect:

```bash
app-store-connect fetch-signing-files SEU.APP.BUNDLE_ID \
    --platform MAC_OS \
    --type MAC_APP_STORE \
    --certificate-key=@file:/caminho/para/cert_key \
    --create
```

Onde `cert_key` é a sua chave privada de certificado de Distribuição de Aplicativos Mac exportada ou uma nova chave privada que gera automaticamente um novo certificado.

</li>
<li>

Se você não tiver um certificado de Distribuição de Instaladores Mac,
você pode criar um novo certificado executando o seguinte:

```bash
app-store-connect certificates create \
    --type MAC_INSTALLER_DISTRIBUTION \
    --certificate-key=@file:/caminho/para/cert_key \
    --save
```

Use `cert_key` da chave privada que você criou anteriormente.

</li>
<li>

Busque os certificados de Distribuição de Instaladores Mac:

```bash
app-store-connect certificates list \
    --type MAC_INSTALLER_DISTRIBUTION \
    --certificate-key=@file:/caminho/para/cert_key \
    --save
```

</li>
<li>

Configure um novo keychain temporário para ser usado para assinatura de código:

```bash
keychain initialize
```

:::note Restaurar Login Keychain!
Depois de executar `keychain initialize` você **deve** executar o seguinte:<br>

`keychain use-login`

Isso define seu keychain de login como o padrão para evitar possíveis
problemas de autenticação com aplicativos em sua máquina.
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

Crie o projeto Flutter macOS:

```bash
flutter build macos --release
```

</li>
<li>

Empacote o aplicativo:

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

Publique o aplicativo empacotado no App Store Connect:

```bash
app-store-connect publish \
    --path "$PACKAGE_NAME"
```

</li>
<li>

Como mencionado anteriormente, não se esqueça de definir seu keychain de login
como padrão para evitar problemas de autenticação
com aplicativos em sua máquina:

```bash
keychain use-login
```

</li>
</ol>

## Lance seu aplicativo no TestFlight

[TestFlight][] permite que desenvolvedores enviem seus aplicativos
para testadores internos e externos. Esta etapa opcional
aborda o lançamento do seu build no TestFlight.

1. Navegue até a aba TestFlight da página de detalhes do seu aplicativo
   no [App Store Connect][appstoreconnect_login].
2. Selecione **Internal Testing** na barra lateral.
3. Selecione o build para publicar para os testadores e clique em **Save**.
4. Adicione os endereços de e-mail de quaisquer testadores internos.
   Você pode adicionar usuários internos adicionais na página **Users and Roles**
   do App Store Connect,
   disponível no menu suspenso na parte superior da página.

## Distribuir para dispositivos registrados

Consulte o [guia de distribuição][distributionguide_macos]
para preparar um arquivo para distribuição para computadores Mac designados.

## Lance seu aplicativo na App Store

Quando você estiver pronto para lançar seu aplicativo para o mundo,
siga estas etapas para enviar seu aplicativo para revisão e
lançamento na App Store:

1. Selecione **Pricing and Availability** na barra lateral da página de
   detalhes do seu aplicativo no
   [App Store Connect][appstoreconnect_login] e preencha as
   informações necessárias.
2. Selecione o status na barra lateral. Se este for o primeiro
   lançamento deste aplicativo, seu status é
   **1.0 Prepare for Submission**. Preencha todos os campos obrigatórios.
3. Clique em **Submit for Review**.

A Apple notifica você quando o processo de revisão do aplicativo for concluído.
Seu aplicativo é lançado de acordo com as instruções que você
especificou na seção **Version Release**.

Para mais detalhes, veja
[Distribuir um aplicativo através da App Store][distributionguide_submit].

## Solução de problemas

O guia [Distribuir seu aplicativo][distributionguide] fornece uma
visão geral detalhada do processo de lançamento de um aplicativo na App Store.

## Recursos adicionais

Para saber como empacotar e distribuir seu aplicativo desktop
Flutter para macOS de forma open source, sem usar uma conta
de desenvolvedor Apple paga, confira o guia passo a passo
[guia de empacotamento macOS][macos_packaging_guide].

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
