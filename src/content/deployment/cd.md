---
ia-translate: true
title: Entrega contínua com Flutter
description: >
  Como automatizar a compilação e lançamento contínuo do seu app Flutter.
---

Siga as melhores práticas de entrega contínua com Flutter para garantir que sua
aplicação seja entregue aos seus beta testers e validada de forma frequente
sem recorrer a fluxos de trabalho manuais.

## Opções de CI/CD

Existem várias opções de integração contínua (CI) e entrega contínua (CD)
disponíveis para ajudar a automatizar a entrega da sua aplicação.

### Opções completas com funcionalidade Flutter integrada

* [Codemagic][]
* [Bitrise][]
* [Appcircle][]

### Integrando fastlane com fluxos de trabalho existentes

Você pode usar fastlane com as seguintes ferramentas:

* [GitHub Actions][]
  * Exemplo: [Github Action in Flutter Project][]
* [Cirrus][]
* [Travis][]
* [GitLab][]
* [CircleCI][]
   * [Building and deploying Flutter apps with Fastlane][]

Este guia mostra como configurar fastlane e então integrá-lo com
seus fluxos de trabalho de teste e integração contínua (CI) existentes.
Para mais informações, veja "Integrating fastlane with existing workflow".

## fastlane

[fastlane][] é um conjunto de ferramentas open-source para automatizar lançamentos e implantações
para o seu app.

### Configuração local

É recomendado que você teste o processo de build e implantação localmente antes
de migrar para um sistema baseado em nuvem. Você também pode optar por realizar entrega contínua
a partir de uma máquina local.

1. Instale fastlane `gem install fastlane` ou `brew install fastlane`.
Visite a [documentação do fastlane][fastlane] para mais informações.
1. Crie uma variável de ambiente chamada `FLUTTER_ROOT`,
    e defina-a para o diretório raiz do seu Flutter SDK.
    (Isso é necessário para os scripts que fazem deploy para iOS.)
1. Crie seu projeto Flutter, e quando estiver pronto, certifique-se de que seu projeto compila via
    * ![Android](/assets/images/docs/cd/android.png) `flutter build appbundle`; e
    * ![iOS](/assets/images/docs/cd/ios.png) `flutter build ipa`.
1. Inicialize os projetos fastlane para cada plataforma.
    * ![Android](/assets/images/docs/cd/android.png) No seu diretório `[project]/android`
    , execute `fastlane init`.
    * ![iOS](/assets/images/docs/cd/ios.png) No seu diretório `[project]/ios`,
    execute `fastlane init`.
1. Edite os `Appfile`s para garantir que eles tenham metadados adequados para seu app.
    * ![Android](/assets/images/docs/cd/android.png) Verifique se `package_name` em
    `[project]/android/fastlane/Appfile` corresponde ao seu package name em AndroidManifest.xml.
    * ![iOS](/assets/images/docs/cd/ios.png) Verifique se `app_identifier` em
    `[project]/ios/fastlane/Appfile` também corresponde ao bundle identifier do Info.plist. Preencha
    `apple_id`, `itc_team_id`, `team_id` com as respectivas informações da sua conta.
1. Configure suas credenciais de login local para as stores.
    * ![Android](/assets/images/docs/cd/android.png) Siga as [etapas de configuração do Supply][Supply setup steps]
    e garanta que `fastlane supply init` sincronize com sucesso os dados do seu
    console da Play Store. _Trate o arquivo .json como sua senha e não o envie
    para nenhum repositório de controle de código fonte público._
    * ![iOS](/assets/images/docs/cd/ios.png) Seu nome de usuário do iTunes Connect já está
    no campo `apple_id` do seu `Appfile`. Defina a variável de ambiente shell `FASTLANE_PASSWORD`
    com sua senha do iTunes Connect. Caso contrário, você será
    solicitado ao fazer upload para iTunes/TestFlight.
1. Configure a assinatura de código.
    * ![Android](/assets/images/docs/cd/android.png) Siga as [etapas de assinatura de app Android][Android app signing steps].
    * ![iOS](/assets/images/docs/cd/ios.png) No iOS, crie e assine usando um
      certificado de distribuição em vez de um certificado de desenvolvimento quando você
      estiver pronto para testar e implantar usando TestFlight ou App Store.
        * Crie e baixe um certificado de distribuição no seu
          [console da conta Apple Developer][Apple Developer Account console].
        * `open [project]/ios/Runner.xcworkspace/` e selecione o certificado de distribuição
          nas configurações do seu target.
1. Crie um script `Fastfile` para cada plataforma.
    * ![Android](/assets/images/docs/cd/android.png) No Android, siga o
      [guia de implantação beta Android do fastlane][fastlane Android beta deployment guide].
      Sua edição pode ser tão simples quanto adicionar uma `lane` que chama
      `upload_to_play_store`.
      Defina o argumento `aab` como `../build/app/outputs/bundle/release/app-release.aab`
      para usar o app bundle que `flutter build` já construiu.
    * ![iOS](/assets/images/docs/cd/ios.png) No iOS, siga o
      [guia de implantação beta iOS do fastlane][fastlane iOS beta deployment guide].
      Você pode especificar o caminho do archive para evitar reconstruir o projeto. Por exemplo:

      ```ruby
      build_app(
        skip_build_archive: true,
        archive_path: "../build/ios/archive/Runner.xcarchive",
      )
      upload_to_testflight
      ```

Você está agora pronto para realizar implantações localmente ou migrar o processo de implantação
para um sistema de integração contínua (CI).

### Executando implantação localmente

1. Compile o app em modo release.
    * ![Android](/assets/images/docs/cd/android.png) `flutter build appbundle`.
    * ![iOS](/assets/images/docs/cd/ios.png) `flutter build ipa`.
1. Execute o script Fastfile em cada plataforma.
    * ![Android](/assets/images/docs/cd/android.png) `cd android` e então
    `fastlane [name of the lane you created]`.
    * ![iOS](/assets/images/docs/cd/ios.png) `cd ios` e então
    `fastlane [name of the lane you created]`.

### Configuração de build e deploy em nuvem

Primeiro, siga a seção de configuração local descrita em 'Local setup' para garantir que
o processo funcione antes de migrar para um sistema em nuvem como Travis.

A principal coisa a considerar é que, como instâncias em nuvem são efêmeras e
não confiáveis, você não deixará suas credenciais como seu JSON de conta de serviço da Play Store
ou seu certificado de distribuição do iTunes no servidor.

Sistemas de Integração Contínua (CI) geralmente suportam variáveis de ambiente
criptografadas para armazenar dados privados. Você pode passar essas variáveis de ambiente
usando `--dart-define MY_VAR=MY_VALUE` ao compilar o app.

**Tome precauções para não re-ecoar esses valores de variáveis de volta para o console em
seus scripts de teste**. Essas variáveis também não estão disponíveis em pull requests
até que sejam mescladas para garantir que atores maliciosos não possam criar um pull
request que imprima esses segredos. Tenha cuidado com interações com esses
segredos em pull requests que você aceita e mescla.

1. Torne as credenciais de login efêmeras.
    * ![Android](/assets/images/docs/cd/android.png) No Android:
        * Remova o campo `json_key_file` do `Appfile` e armazene o conteúdo string
          do JSON na variável criptografada do seu sistema CI.
          Leia a variável de ambiente diretamente no seu `Fastfile`.
          ```plaintext
          upload_to_play_store(
            ...
            json_key_data: ENV['<variable name>']
          )
          ```
        * Serialize sua chave de upload (por exemplo, usando base64) e salve-a como
          uma variável de ambiente criptografada. Você pode desserializá-la no seu sistema CI
          durante a fase de instalação com
          ```bash
          echo "$PLAY_STORE_UPLOAD_KEY" | base64 --decode > [path to your upload keystore]
          ```
    * ![iOS](/assets/images/docs/cd/ios.png) No iOS:
        * Mova a variável de ambiente local `FASTLANE_PASSWORD` para usar
          variáveis de ambiente criptografadas no sistema CI.
        * O sistema CI precisa de acesso ao seu certificado de distribuição.
          O sistema [Match][] do fastlane é
          recomendado para sincronizar seus certificados entre máquinas.

2. É recomendado usar um Gemfile em vez de usar um indeterminístico
   `gem install fastlane` no sistema CI cada vez para garantir que as dependências do fastlane
   sejam estáveis e reproduzíveis entre máquinas locais e em nuvem.
   No entanto, este passo é opcional.
    * Em ambas as suas pastas `[project]/android` e `[project]/ios`, crie um
      `Gemfile` contendo o seguinte conteúdo:
        ```plaintext
        source "https://rubygems.org"

        gem "fastlane"
        ```
    * Em ambos os diretórios, execute `bundle update` e verifique tanto `Gemfile` quanto
      `Gemfile.lock` no controle de código fonte.
    * Ao executar localmente, use `bundle exec fastlane` em vez de `fastlane`.

3. Crie o script de teste CI como `.travis.yml` ou `.cirrus.yml` na raiz do seu
   repositório.
    * Veja a [documentação CI do fastlane][fastlane CI documentation] para configuração específica de CI.
    * Fragmente seu script para executar nas plataformas Linux e macOS.
    * Durante a fase de configuração da tarefa CI, faça o seguinte:
         * Garanta que o Bundler esteja disponível usando `gem install bundler`.
         * Execute `bundle install` em `[project]/android` ou `[project]/ios`.
         * Certifique-se de que o Flutter SDK esteja disponível e definido em `PATH`.
         * Para Android, garanta que o Android SDK esteja disponível e o caminho `ANDROID_SDK_ROOT`
           esteja definido.
         * Para iOS, você pode precisar especificar uma dependência no Xcode
           (por exemplo, `osx_image: xcode9.2`).
    * Na fase de script da tarefa CI:
         * Execute `flutter build appbundle` ou
           `flutter build ios --release --no-codesign`,
           dependendo da plataforma.
         * `cd android` ou `cd ios`
         * `bundle exec fastlane [name of the lane]`

## Xcode Cloud

[Xcode Cloud][] é um serviço de integração contínua e entrega para compilação,
teste e distribuição de apps e frameworks para plataformas Apple.

### Requisitos

* Xcode 13.4.1 ou superior.
* Estar inscrito no [Apple Developer Program][].

### Script de build personalizado

O Xcode Cloud reconhece [scripts de build personalizados][custom build scripts] que podem ser
usados para realizar tarefas adicionais em um momento designado. Ele também inclui um conjunto
de [variáveis de ambiente predefinidas][predefined environment variables], como `$CI_WORKSPACE`, que é a
localização do seu repositório clonado.

:::note
O ambiente de build temporário que o Xcode Cloud usa inclui ferramentas que fazem
parte do macOS e Xcode&mdash;por exemplo, Python&mdash;e adicionalmente Homebrew para
suportar a instalação de dependências e ferramentas de terceiros.
:::

#### Script pós-clone

Aproveite o script de build personalizado pós-clone que executa após
o Xcode Cloud clonar seu repositório Git usando as seguintes instruções:

Crie um arquivo em `ios/ci_scripts/ci_post_clone.sh` e adicione o conteúdo abaixo.

<?code-excerpt "deployment/xcode_cloud/ci_post_clone.sh"?>
```sh
#!/bin/sh

# Fail this script if any subcommand fails.
set -e

# The default execution directory of this script is the ci_scripts directory.
cd $CI_PRIMARY_REPOSITORY_PATH # change working directory to the root of your cloned repo.

# Install Flutter using git.
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# Install Flutter artifacts for iOS (--ios), or macOS (--macos) platforms.
flutter precache --ios

# Install Flutter dependencies.
flutter pub get

# Install CocoaPods using Homebrew.
HOMEBREW_NO_AUTO_UPDATE=1 # disable homebrew's automatic updates.
brew install cocoapods

# Install CocoaPods dependencies.
cd ios && pod install # run `pod install` in the `ios` directory.

exit 0
```

Este arquivo deve ser adicionado ao seu repositório git e marcado como executável.

```console
$ git add --chmod=+x ios/ci_scripts/ci_post_clone.sh
```

### Configuração de workflow

Um [workflow do Xcode Cloud][Xcode Cloud workflow] define as etapas realizadas no processo de CI/CD
quando seu workflow é acionado.

:::note
Isso requer que seu projeto já esteja inicializado com Git
e vinculado a um repositório remoto.
:::

Para criar um novo workflow no Xcode, use as seguintes instruções:

1. Escolha **Product > Xcode Cloud > Create Workflow** para abrir a
   folha **Create Workflow**.

2. Selecione o produto (app) ao qual o workflow deve ser anexado, então clique
   no botão **Next**.

3. A próxima folha exibe uma visão geral do workflow padrão fornecido pelo Xcode,
    e pode ser personalizada clicando no botão **Edit Workflow**.

#### Mudanças de branch

Por padrão, o Xcode sugere a condição Branch Changes que inicia um novo build
para cada mudança no branch padrão do seu repositório Git.

Para a variante iOS do seu app, é razoável que você queira que o Xcode Cloud
acione seu workflow após ter feito mudanças nos seus pacotes Flutter, ou
modificado os arquivos fonte Dart ou iOS dentro dos diretórios `lib\` e `ios\`.

Isso pode ser alcançado usando as seguintes condições de Files and Folders:

![Xcode Workflow Branch Changes](/assets/images/docs/releaseguide/xcode_workflow_branch_changes.png){:width="100%"}

### Próximo número de build

O Xcode Cloud define o número de build padrão para novos workflows como `1` e o incrementa
por build bem-sucedido. Se você está usando um app existente com um número de build maior,
você precisará configurar o Xcode Cloud para usar o número de build correto
para seus builds simplesmente especificando o `Next Build Number` na sua iteração.

Confira [Setting the next build number for Xcode Cloud builds][] para mais
informações.

[Android app signing steps]: /deployment/android#signing-the-app
[Appcircle]: https://appcircle.io/blog/guide-to-automated-mobile-ci-cd-for-flutter-projects-with-appcircle/
[Apple Developer Account console]: {{site.apple-dev}}/account/ios/certificate/
[Bitrise]: https://devcenter.bitrise.io/en/getting-started/quick-start-guides/getting-started-with-flutter-apps
[CI Options and Examples]: #reference-and-examples
[Cirrus]: https://cirrus-ci.org
[Codemagic]: https://blog.codemagic.io/getting-started-with-codemagic/
[fastlane]: https://docs.fastlane.tools
[fastlane Android beta deployment guide]: https://docs.fastlane.tools/getting-started/android/beta-deployment/
[fastlane CI documentation]: https://docs.fastlane.tools/best-practices/continuous-integration
[fastlane iOS beta deployment guide]: https://docs.fastlane.tools/getting-started/ios/beta-deployment/
[Github Action in Flutter Project]: {{site.github}}/nabilnalakath/flutter-githubaction
[GitHub Actions]: {{site.github}}/features/actions
[GitLab]: https://docs.gitlab.com/ee/ci/
[CircleCI]: https://circleci.com
[Building and deploying Flutter apps with Fastlane]: https://circleci.com/blog/deploy-flutter-android
[Match]: https://docs.fastlane.tools/actions/match/
[Supply setup steps]: https://docs.fastlane.tools/getting-started/android/setup/#setting-up-supply
[Travis]: https://travis-ci.org/
[Apple Developer Program]: {{site.apple-dev}}/programs
[Xcode Cloud]: {{site.apple-dev}}/xcode-cloud
[Xcode Cloud workflow]: {{site.apple-dev}}/documentation/xcode/xcode-cloud-workflow-reference
[custom build scripts]: {{site.apple-dev}}/documentation/xcode/writing-custom-build-scripts
[predefined environment variables]: {{site.apple-dev}}/documentation/xcode/environment-variable-reference
[Setting the next build number for Xcode Cloud builds]: {{site.apple-dev}}/documentation/xcode/setting-the-next-build-number-for-xcode-cloud-builds#Set-the-next-build-number-to-a-custom-value
