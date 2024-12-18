---
ia-translate: true
title: Construir e lançar um aplicativo iOS
description: Como lançar um aplicativo Flutter na App Store.
short-title: iOS
---

Este guia fornece um passo a passo de como lançar um
aplicativo Flutter na [App Store][appstore] e [TestFlight][].

## Preliminares

O Xcode é necessário para construir e lançar seu aplicativo. Você
deve usar um dispositivo executando macOS para seguir este guia.

Antes de começar o processo de lançamento do seu aplicativo,
certifique-se de que ele atenda às [Diretrizes de Revisão de Aplicativos][appreview] da Apple.

Para publicar seu aplicativo na App Store,
você deve primeiro se inscrever no [Apple Developer Program][devprogram].
Você pode ler mais sobre as várias opções de associação no guia da Apple
[Escolhendo uma Associação][devprogram_membership].

## Visão geral em vídeo

Para aqueles que preferem vídeo a texto,
o seguinte vídeo cobre o mesmo material deste guia.

{% ytEmbed 'iE2bpP56QKc', 'Lançar um aplicativo iOS construído com Flutter em 7 passos' %}

## Registre seu aplicativo no App Store Connect

Gerencie o ciclo de vida do seu aplicativo no
[App Store Connect][appstoreconnect] (anteriormente iTunes Connect).
Você define o nome e a descrição do seu aplicativo, adiciona screenshots,
define preços e gerencia lançamentos para a App Store e TestFlight.

O registro do seu aplicativo envolve duas etapas: registrar um
Bundle ID exclusivo e criar um registro de aplicativo no App Store Connect.

Para uma visão geral detalhada do App Store Connect, consulte o guia
[App Store Connect][appstoreconnect_guide].

### Registrar um Bundle ID

Cada aplicativo iOS está associado a um Bundle ID,
um identificador único registrado na Apple.
Para registrar um Bundle ID para seu aplicativo, siga estas etapas:

1. Abra a página [App IDs][devportal_appids] da sua conta de desenvolvedor.
1. Clique em **+** para criar um novo Bundle ID.
1. Insira um nome de aplicativo, selecione **Explicit App ID** e insira um ID.
1. Selecione os serviços que seu aplicativo usa e clique em **Continue**.
1. Na próxima página, confirme os detalhes e clique em **Register**
   para registrar seu Bundle ID.

### Criar um registro de aplicativo no App Store Connect

Registre seu aplicativo no App Store Connect:

1. Abra o [App Store Connect][appstoreconnect_login] no seu navegador.
1. Na página inicial do App Store Connect, clique em **My Apps**.
1. Clique em **+** no canto superior esquerdo da página My Apps,
   em seguida, selecione **New App**.
1. Preencha os detalhes do seu aplicativo no formulário que aparece.
   Na seção Platforms, certifique-se de que iOS esteja marcado.
   Como o Flutter atualmente não oferece suporte a tvOS,
   deixe essa caixa de seleção desmarcada. Clique em **Create**.
1. Navegue até os detalhes do aplicativo para seu aplicativo e selecione
   **App Information** na barra lateral.
1. Na seção General Information, selecione o Bundle ID
   que você registrou na etapa anterior.

Para uma visão geral detalhada, consulte
[Adicionar um aplicativo à sua conta][appstoreconnect_guide_register].

## Revisar as configurações do projeto Xcode

Esta etapa aborda a revisão das configurações mais importantes
no workspace do Xcode.
Para procedimentos e descrições detalhadas, consulte
[Preparar para distribuição de aplicativos][distributionguide_config].

Navegue até as configurações do seu alvo no Xcode:

1. Abra o workspace padrão do Xcode no seu projeto executando
   `open ios/Runner.xcworkspace` em uma janela de terminal a partir do seu
   diretório do projeto Flutter.
1. Para visualizar as configurações do seu aplicativo, selecione o alvo **Runner** no
   navegador do Xcode.

Verifique as configurações mais importantes.

Na seção **Identity** da aba **General**:

`Display Name`
: O nome de exibição do seu aplicativo.

`Bundle Identifier`
: O App ID que você registrou no App Store Connect.

Na aba **Signing & Capabilities**:

`Automatically manage signing`
: Se o Xcode deve gerenciar automaticamente a assinatura de aplicativos
  e provisionamento. Isso é definido como `true` por padrão, o que deve
  ser suficiente para a maioria dos aplicativos. Para cenários mais complexos,
  consulte o [Guia de Assinatura de Código][codesigning_guide].

`Team`
: Selecione a equipe associada à sua conta de desenvolvedor da Apple
  registrada. Se necessário, selecione **Add Account...**,
  em seguida, atualize esta configuração.

Na seção **Deployment** da aba **Build Settings**:

`iOS Deployment Target`
: A versão mínima do iOS que seu aplicativo suporta.
  O Flutter suporta iOS 12 e posterior. Se seu aplicativo ou plugins
  incluírem código Objective-C ou Swift que use APIs mais recentes
  que o iOS 12, atualize esta configuração para a versão mais alta necessária.

A aba **General** das configurações do seu projeto deve se parecer
com o seguinte:

![Configurações do Projeto Xcode](/assets/images/docs/releaseguide/xcode_settings.png){:width="100%"}

Para uma visão geral detalhada da assinatura de aplicativos, consulte
[Criar, exportar e excluir certificados de assinatura][appsigning].

## Atualizando a versão de implantação do aplicativo

Se você alterou `Deployment Target` no seu projeto Xcode,
abra `ios/Flutter/AppframeworkInfo.plist` no seu aplicativo Flutter
e atualize o valor `MinimumOSVersion` para corresponder.

## Adicionar um ícone de aplicativo

Quando um novo aplicativo Flutter é criado, um conjunto de ícones de espaço reservado é criado.
Esta etapa aborda a substituição desses ícones de espaço reservado pelos
ícones do seu aplicativo:

1. Revise as diretrizes de [Ícone de Aplicativo iOS][app-icon] e,
   em particular, o aconselhamento sobre
   [criação de ícones claros, escuros e coloridos][icon-modes] para seu aplicativo.
1. No navegador do projeto Xcode, selecione `Assets.xcassets` na pasta
   `Runner`. Atualize os ícones de espaço reservado com seus próprios ícones de aplicativo.
1. Verifique se o ícone foi substituído executando seu aplicativo usando
   `flutter run`.

[app-icon]: {{site.apple-dev}}/design/human-interface-guidelines/app-icons/
[icon-modes]: {{site.apple-dev}}/design/human-interface-guidelines/app-icons#iOS-iPadOS

## Adicionar uma imagem de lançamento

Semelhante ao ícone do aplicativo,
você também pode substituir a imagem de lançamento do espaço reservado:

1. No navegador do projeto Xcode,
   selecione `Assets.xcassets` na pasta `Runner`.
   Atualize a imagem de lançamento do espaço reservado com sua própria imagem de lançamento.
1. Verifique a nova imagem de lançamento reiniciando seu aplicativo.
   (Não use `hot reload`.)

## Criar um arquivo de build e fazer o upload para o App Store Connect

Durante o desenvolvimento, você tem construído, depurado e testado
com builds _debug_. Quando você estiver pronto para enviar seu aplicativo para os usuários
na App Store ou TestFlight, você precisa preparar um build _release_.

### Atualizar os números de build e versão do aplicativo

O número de versão padrão do aplicativo é `1.0.0`.
Para atualizá-lo, navegue até o arquivo `pubspec.yaml`
e atualize a seguinte linha:

```yaml
version: 1.0.0+1
```

O número da versão é três números separados por pontos,
como `1.0.0` no exemplo acima, seguido por um número de build opcional
como `1` no exemplo acima, separado por um `+`.

Tanto a versão quanto o número de build podem ser substituídos em
`flutter build ipa` especificando `--build-name` e `--build-number`,
respectivamente.

No iOS, `build-name` usa `CFBundleShortVersionString`
enquanto `build-number` usa `CFBundleVersion`.
Leia mais sobre o versionamento do iOS em [Core Foundation Keys][]
no site da Apple Developer.

Você também pode substituir o nome e o número de build do `pubspec.yaml` no Xcode:

1. Abra `Runner.xcworkspace` na pasta `ios` do seu aplicativo.
1. Selecione **Runner** no navegador do projeto Xcode e, em seguida, selecione o
   alvo **Runner** na barra lateral de visualização de configurações.
1. Na seção Identity, atualize a **Version** para o número de versão voltado para o usuário
   que você deseja publicar.
1. Na seção Identity, atualize o identificador **Build** para um único
   número de build usado para rastrear este build no App Store Connect.
   Cada upload requer um número de build exclusivo.

### Criar um pacote de aplicativo

Execute `flutter build ipa` para produzir um arquivo de build Xcode (`.xcarchive` file)
no diretório `build/ios/archive/` do seu projeto e um pacote de aplicativo da App Store
(`ipa` file) em `build/ios/ipa`.

Considere adicionar as flags `--obfuscate` e `--split-debug-info` para
[ofuscar seu código Dart][] para torná-lo mais difícil
de fazer engenharia reversa.

Se você não estiver distribuindo para a App Store, você pode opcionalmente
escolher um [método de exportação][app_bundle_export_method] diferente adicionando
a opção `--export-method ad-hoc`,
`--export-method development` ou `--export-method enterprise`.

:::note
Em versões do Flutter onde `flutter build ipa --export-method` não está disponível,
abra `build/ios/archive/MyApp.xcarchive` e siga as instruções abaixo
para validar e distribuir o aplicativo a partir do Xcode.
:::

### Fazer o upload do pacote do aplicativo para o App Store Connect

Depois que o pacote do aplicativo for criado, faça o upload para o
[App Store Connect][appstoreconnect_login] por meio de:

<ol>
<li>

Instale e abra o [aplicativo macOS Apple Transport][apple_transport_app].
Arraste e solte o pacote do aplicativo `build/ios/ipa/*.ipa` no aplicativo.

</li>

<li>

Ou faça o upload do pacote de aplicativos da linha de comando executando:

```bash
xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey your_api_key --apiIssuer your_issuer_id
```

Execute `man altool` para obter detalhes sobre como se autenticar com a chave da API do App Store Connect.

</li>

<li>

Ou abra `build/ios/archive/MyApp.xcarchive` no Xcode.

Clique no botão **Validate App**. Se algum problema for relatado,
resolva-os e produza outro build. Você pode reutilizar o mesmo
ID de build até fazer o upload de um arquivo.

Depois que o arquivo for validado com sucesso, clique em
**Distribute App**.

:::note
Quando você exportar seu aplicativo no final de **Distribute App**,
o Xcode criará um diretório contendo
um IPA do seu aplicativo e um arquivo `ExportOptions.plist`.
Você pode criar novos IPAs com as mesmas opções sem iniciar
o Xcode executando
`flutter build ipa --export-options-plist=path/to/ExportOptions.plist`.
Consulte `xcodebuild -h` para obter detalhes sobre as chaves nesta lista de propriedades.
:::

</li>
</ol>

Você pode acompanhar o status do seu build na aba
Activities da página de detalhes do seu aplicativo no
[App Store Connect][appstoreconnect_login].
Você deve receber um e-mail dentro de 30 minutos notificando que
seu build foi validado e está disponível para lançamento para testadores
no TestFlight. Neste ponto, você pode escolher se quer lançar
no TestFlight ou prosseguir e lançar seu aplicativo na App Store.

Para obter mais detalhes, consulte
[Fazer o upload de um aplicativo para o App Store Connect][distributionguide_upload].

## Criar um arquivo de build com as ferramentas Codemagic CLI

Esta etapa aborda a criação de um arquivo de build e o upload
do seu build para o App Store Connect usando comandos de build do Flutter
e [Ferramentas Codemagic CLI][codemagic_cli_tools] executadas em um terminal
no diretório do projeto Flutter. Isso permite criar um arquivo de build
com controle total dos certificados de distribuição em um keychain temporário
isolado do seu keychain de login.

<ol>
<li>

Instale as ferramentas Codemagic CLI:

```bash
pip3 install codemagic-cli-tools
```

</li>
<li>

Você precisará gerar uma [Chave de API do App Store Connect][appstoreconnect_api_key]
com acesso de App Manager para automatizar operações com o App Store Connect. Para tornar
os comandos subsequentes mais concisos, defina as seguintes variáveis de ambiente da
nova chave: ID do emissor, ID da chave e arquivo de chave de API.

```bash
export APP_STORE_CONNECT_ISSUER_ID=aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee
export APP_STORE_CONNECT_KEY_IDENTIFIER=ABC1234567
export APP_STORE_CONNECT_PRIVATE_KEY=`cat /path/to/api/key/AuthKey_XXXYYYZZZ.p8`
```

</li>
<li>

Você precisa exportar ou criar um certificado de distribuição iOS para assinar o código e empacotar um arquivo de build.

Se você tiver [certificados][devportal_certificates] existentes, você pode exportar as
chaves privadas executando o seguinte comando para cada certificado:

```bash
openssl pkcs12 -in <certificate_name>.p12 -nodes -nocerts | openssl rsa -out cert_key
```

Ou você pode criar uma nova chave privada executando o seguinte comando:

```bash
ssh-keygen -t rsa -b 2048 -m PEM -f cert_key -q -N ""
```

Mais tarde, você pode ter as ferramentas CLI criando automaticamente uma nova Distribuição iOS a partir da chave privada.

</li>
<li>

Configure um novo keychain temporário para ser usado para assinatura de código:

```bash
keychain initialize
```

:::note Restaurar Keychain de Login!
Depois de executar `keychain initialize` você **deve** executar o seguinte:<br>

`keychain use-login`

Isso define seu keychain de login como padrão para evitar possíveis
problemas de autenticação com aplicativos em sua máquina.
:::

</li>
<li>

Obtenha os arquivos de assinatura de código do App Store Connect:

```bash
app-store-connect fetch-signing-files $(xcode-project detect-bundle-id) \
    --platform IOS \
    --type IOS_APP_STORE \
    --certificate-key=@file:/path/to/cert_key \
    --create
```

Onde `cert_key` é sua chave privada de certificado de distribuição iOS exportada
ou uma nova chave privada que gera automaticamente um novo certificado. O certificado
será criado a partir da chave privada se ela não existir no App Store Connect.

</li>
<li>

Agora adicione os certificados obtidos ao seu keychain:

```bash
keychain add-certificates
```

</li>
<li>

Atualize as configurações do projeto Xcode para usar os perfis de assinatura de código obtidos:

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

Construa o projeto Flutter do iOS:

```bash
flutter build ipa --release \
    --export-options-plist=$HOME/export_options.plist
```

Observe que `export_options.plist` é a saída do comando `xcode-project use-profiles`.

</li>
<li>

Publique o aplicativo no App Store Connect:

```bash
app-store-connect publish \
    --path $(find $(pwd) -name "*.ipa")
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

Você deve receber um e-mail dentro de 30 minutos notificando que
seu build foi validado e está disponível para lançamento para testadores
no TestFlight. Neste ponto, você pode escolher se quer lançar
no TestFlight ou prosseguir e lançar seu aplicativo na App Store.

## Lançar seu aplicativo no TestFlight

[TestFlight][] permite que os desenvolvedores enviem seus aplicativos
para testadores internos e externos. Esta etapa opcional
cobre o lançamento do seu build no TestFlight.

1. Navegue até a aba TestFlight da página de detalhes do aplicativo
   do seu aplicativo no [App Store Connect][appstoreconnect_login].
1. Selecione **Internal Testing** na barra lateral.
1. Selecione o build para publicar para testadores e clique em **Save**.
1. Adicione os endereços de e-mail de quaisquer testadores internos.
   Você pode adicionar usuários internos adicionais na página **Users and Roles**
   do App Store Connect,
   disponível no menu suspenso na parte superior da página.

Para obter mais detalhes, consulte
[Distribuir um aplicativo usando o TestFlight][distributionguide_testflight].

## Lançar seu aplicativo na App Store

Quando estiver pronto para lançar seu aplicativo para o mundo,
siga estas etapas para enviar seu aplicativo para análise e
lançamento na App Store:

1. Selecione **Pricing and Availability** na barra lateral do seu aplicativo
   na página de detalhes do aplicativo
   [App Store Connect][appstoreconnect_login] e complete as
   informações necessárias.
1. Selecione o status na barra lateral. Se este for o primeiro
   lançamento deste aplicativo, seu status é
   **1.0 Prepare for Submission**. Preencha todos os campos obrigatórios.
1. Clique em **Submit for Review**.

A Apple notifica você quando o processo de análise do aplicativo for concluído.
Seu aplicativo é lançado de acordo com as instruções que você
especificou na seção **Version Release**.

Para obter mais detalhes, consulte
[Distribuir um aplicativo pela App Store][distributionguide_submit].

## Solução de problemas

O guia [Distribuir seu aplicativo][distributionguide] fornece um
visão geral detalhada do processo de lançamento de um aplicativo na App Store.

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
