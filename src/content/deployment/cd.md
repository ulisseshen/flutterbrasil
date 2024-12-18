---
ia-translate: true
title: Entrega contínua com Flutter
description: >
  Como automatizar a construção e liberação contínuas do seu aplicativo Flutter.
---

Siga as melhores práticas de entrega contínua com Flutter para garantir que seu
aplicativo seja entregue aos seus testadores beta e validado frequentemente,
sem recorrer a fluxos de trabalho manuais.

## Opções de CI/CD

Há várias opções de integração contínua (CI) e entrega contínua (CD)
disponíveis para ajudar a automatizar a entrega do seu aplicativo.

### Opções tudo-em-um com funcionalidade Flutter integrada

* [Codemagic][]
* [Bitrise][]
* [Appcircle][]

### Integrando fastlane com fluxos de trabalho existentes

Você pode usar o fastlane com as seguintes ferramentas:

* [GitHub Actions][]
  * Exemplo: [Github Action in Flutter Project][]
* [Cirrus][]
* [Travis][]
* [GitLab][]
* [CircleCI][]
   * [Building and deploying Flutter apps with Fastlane][]

Este guia mostra como configurar o fastlane e, em seguida, integrá-lo aos
seus fluxos de trabalho de teste e integração contínua (CI) existentes.
Para obter mais informações, consulte "Integrando fastlane com fluxo de trabalho existente".

## fastlane

[fastlane][] é um conjunto de ferramentas de código aberto para automatizar lançamentos e implantações
para seu aplicativo.

### Configuração local

É recomendável testar o processo de compilação e implantação localmente antes de
migrar para um sistema baseado em nuvem. Você também pode optar por executar a entrega contínua
de uma máquina local.

1. Instale o fastlane `gem install fastlane` ou `brew install fastlane`.
   Visite a [documentação do fastlane][fastlane] para mais informações.
2. Crie uma variável de ambiente chamada `FLUTTER_ROOT` e
   defina-a para o diretório raiz do seu Flutter SDK.
   (Isso é necessário para os scripts que implantam para iOS.)
3. Crie seu projeto Flutter e, quando estiver pronto, certifique-se de que seu projeto seja compilado via
    * ![Android](/assets/images/docs/cd/android.png) `flutter build appbundle`; e
    * ![iOS](/assets/images/docs/cd/ios.png) `flutter build ipa`.
4. Inicialize os projetos fastlane para cada plataforma.
    * ![Android](/assets/images/docs/cd/android.png) No seu diretório `[projeto]/android`, execute `fastlane init`.
    * ![iOS](/assets/images/docs/cd/ios.png) No seu diretório `[projeto]/ios`, execute `fastlane init`.
5. Edite os `Appfile`s para garantir que eles tenham metadados adequados para seu aplicativo.
    * ![Android](/assets/images/docs/cd/android.png) Verifique se `package_name` em
   `[projeto]/android/fastlane/Appfile` corresponde ao nome do seu pacote em AndroidManifest.xml.
    * ![iOS](/assets/images/docs/cd/ios.png) Verifique se `app_identifier` em
   `[projeto]/ios/fastlane/Appfile` também corresponde ao identificador do pacote do Info.plist. Preencha
   `apple_id`, `itc_team_id`, `team_id` com as informações da sua respectiva conta.
6. Configure suas credenciais de login locais para as lojas.
    * ![Android](/assets/images/docs/cd/android.png) Siga as [etapas de configuração do Supply][]
   e certifique-se de que `fastlane supply init` sincronize com sucesso os dados do seu
   console da Play Store. _Trate o arquivo .json como sua senha e não o inclua
   em nenhum repositório de controle de versão público._
    * ![iOS](/assets/images/docs/cd/ios.png) Seu nome de usuário do iTunes Connect já está
   no campo `apple_id` do seu `Appfile`. Defina a variável de ambiente do shell `FASTLANE_PASSWORD`
   com sua senha do iTunes Connect. Caso contrário, você será solicitado ao fazer o upload para o iTunes/TestFlight.
7. Configure a assinatura de código.
    * ![Android](/assets/images/docs/cd/android.png) Siga as [etapas de assinatura de aplicativos Android][].
    * ![iOS](/assets/images/docs/cd/ios.png) No iOS, crie e assine usando um
      certificado de distribuição em vez de um certificado de desenvolvimento quando estiver
      pronto para testar e implantar usando o TestFlight ou a App Store.
        * Crie e baixe um certificado de distribuição em seu
          [console da conta de desenvolvedor da Apple][].
        * `open [projeto]/ios/Runner.xcworkspace/` e selecione a distribuição
          certificado no painel de configurações do seu destino.
8. Crie um script `Fastfile` para cada plataforma.
    * ![Android](/assets/images/docs/cd/android.png) No Android, siga o
      [guia de implantação beta do fastlane para Android][].
      Sua edição pode ser tão simples quanto adicionar um `lane` que chama
      `upload_to_play_store`.
      Defina o argumento `aab` como `../build/app/outputs/bundle/release/app-release.aab`
      para usar o pacote de aplicativos `flutter build` já construído.
    * ![iOS](/assets/images/docs/cd/ios.png) No iOS, siga o
      [guia de implantação beta do fastlane para iOS][].
      Você pode especificar o caminho do arquivo para evitar a reconstrução do projeto. Por exemplo:

      ```ruby
      build_app(
        skip_build_archive: true,
        archive_path: "../build/ios/archive/Runner.xcarchive",
      )
      upload_to_testflight
      ```

Agora você está pronto para realizar implantações localmente ou migrar o
processo de implantação para um sistema de integração contínua (CI).

### Executando a implantação localmente

1. Crie o aplicativo no modo de lançamento.
    * ![Android](/assets/images/docs/cd/android.png) `flutter build appbundle`.
    * ![iOS](/assets/images/docs/cd/ios.png) `flutter build ipa`.
2. Execute o script Fastfile em cada plataforma.
    * ![Android](/assets/images/docs/cd/android.png) `cd android` então
   `fastlane [nome do lane que você criou]`.
    * ![iOS](/assets/images/docs/cd/ios.png) `cd ios` então
   `fastlane [nome do lane que você criou]`.

### Configuração de construção e implantação na nuvem

Primeiro, siga a seção de configuração local descrita em 'Configuração local' para ter certeza de que
o processo funciona antes de migrar para um sistema em nuvem como o Travis.

O principal a considerar é que, como as instâncias em nuvem são efêmeras e
não confiáveis, você não deixará suas credenciais como o serviço Play Store
conta JSON ou seu certificado de distribuição do iTunes no servidor.

Os sistemas de Integração Contínua (CI) geralmente oferecem suporte a variáveis de ambiente
criptografadas para armazenar dados privados. Você pode passar essas variáveis de ambiente
usando `--dart-define MY_VAR=MY_VALUE` ao construir o aplicativo.

**Tome cuidado para não ecoar esses valores de variáveis de volta no console em
seus scripts de teste**. Essas variáveis também não estão disponíveis em pull requests
até que sejam mesclados para garantir que atores maliciosos não possam criar um pull
request que imprima esses segredos. Tenha cuidado com as interações com esses
segredos em pull requests que você aceita e mescla.

1. Torne as credenciais de login efêmeras.
    * ![Android](/assets/images/docs/cd/android.png) No Android:
        * Remova o campo `json_key_file` de `Appfile` e armazene a string
          conteúdo do JSON na variável criptografada do seu sistema de CI.
          Leia a variável de ambiente diretamente em seu `Fastfile`.
          ```plaintext
          upload_to_play_store(
            ...
            json_key_data: ENV['<nome da variável>']
          )
          ```
        * Serialize sua chave de upload (por exemplo, usando base64) e salve-a como
          uma variável de ambiente criptografada. Você pode deserializá-la em seu sistema de CI
          durante a fase de instalação com
          ```bash
          echo "$PLAY_STORE_UPLOAD_KEY" | base64 --decode > [caminho para seu keystore de upload]
          ```
    * ![iOS](/assets/images/docs/cd/ios.png) No iOS:
        * Mova a variável de ambiente local `FASTLANE_PASSWORD` para usar
          variáveis de ambiente criptografadas no sistema de CI.
        * O sistema de CI precisa acessar seu certificado de distribuição.
          O sistema [Match][] do fastlane é
          recomendado para sincronizar seus certificados entre máquinas.
2. É recomendável usar um Gemfile em vez de usar um indeterminístico
   `gem install fastlane` no sistema CI cada vez para garantir que o fastlane
   dependências são estáveis e reproduzíveis entre máquinas locais e em nuvem.
   No entanto, esta etapa é opcional.
    * Em suas pastas `[projeto]/android` e `[projeto]/ios`, crie um
      `Gemfile` contendo o seguinte conteúdo:
        ```plaintext
        source "https://rubygems.org"

        gem "fastlane"
        ```
    * Em ambos os diretórios, execute `bundle update` e marque `Gemfile` e
      `Gemfile.lock` no controle de versão.
    * Ao executar localmente, use `bundle exec fastlane` em vez de `fastlane`.
3. Crie o script de teste de CI, como `.travis.yml` ou `.cirrus.yml` em seu
   raiz do repositório.
    * Consulte a [documentação do fastlane CI][] para configuração específica de CI.
    * Divida seu script para ser executado nas plataformas Linux e macOS.
    * Durante a fase de configuração da tarefa de CI, faça o seguinte:
        * Certifique-se de que o Bundler esteja disponível usando `gem install bundler`.
        * Execute `bundle install` em `[projeto]/android` ou `[projeto]/ios`.
        * Certifique-se de que o Flutter SDK esteja disponível e definido em `PATH`.
        * Para Android, certifique-se de que o Android SDK esteja disponível e o `ANDROID_SDK_ROOT`
          caminho está definido.
        * Para iOS, pode ser necessário especificar uma dependência do Xcode
          (por exemplo, `osx_image: xcode9.2`).
    * Na fase de script da tarefa de CI:
        * Execute `flutter build appbundle` ou
          `flutter build ios --release --no-codesign`,
          dependendo da plataforma.
        * `cd android` ou `cd ios`
        * `bundle exec fastlane [nome do lane]`

## Xcode Cloud

[Xcode Cloud][] é um serviço de integração e entrega contínuas para construir,
testar e distribuir aplicativos e estruturas para plataformas Apple.

### Requisitos

* Xcode 13.4.1 ou superior.
* Esteja inscrito no [Programa de desenvolvedor da Apple][].

### Script de construção personalizado

O Xcode Cloud reconhece [scripts de construção personalizados][] que podem ser
usados para executar tarefas adicionais em um horário designado. Também inclui um conjunto
de [variáveis de ambiente predefinidas][], como `$CI_WORKSPACE`, que é o
localização do seu repositório clonado.

:::note
O ambiente de construção temporário que o Xcode Cloud usa inclui ferramentas que fazem parte
do macOS e Xcode — por exemplo, Python — e, adicionalmente, o Homebrew para
dar suporte à instalação de dependências e ferramentas de terceiros.
:::

#### Script pós-clone

Aproveite o script de construção personalizado pós-clone que é executado após
Xcode Cloud clona seu repositório Git usando as seguintes instruções:

Crie um arquivo em `ios/ci_scripts/ci_post_clone.sh` e adicione o conteúdo abaixo.

<?code-excerpt "deployment/xcode_cloud/ci_post_clone.sh"?>
```sh
#!/bin/sh

# Falhe neste script se algum subcomando falhar.
set -e

# O diretório de execução padrão deste script é o diretório ci_scripts.
cd $CI_PRIMARY_REPOSITORY_PATH # altere o diretório de trabalho para a raiz do seu repositório clonado.

# Instale o Flutter usando git.
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# Instale artefatos do Flutter para plataformas iOS (--ios) ou macOS (--macos).
flutter precache --ios

# Instale as dependências do Flutter.
flutter pub get

# Instale o CocoaPods usando o Homebrew.
HOMEBREW_NO_AUTO_UPDATE=1 # desabilita as atualizações automáticas do homebrew.
brew install cocoapods

# Instale as dependências do CocoaPods.
cd ios && pod install # execute `pod install` no diretório `ios`.

exit 0
```

Este arquivo deve ser adicionado ao seu repositório git e marcado como executável.

```console
$ git add --chmod=+x ios/ci_scripts/ci_post_clone.sh
```

### Configuração do fluxo de trabalho

Um [fluxo de trabalho do Xcode Cloud][] define as etapas executadas no processo de CI/CD
quando seu fluxo de trabalho é acionado.

:::note
Isso exige que seu projeto já esteja inicializado com o Git
e vinculado a um repositório remoto.
:::

Para criar um novo fluxo de trabalho no Xcode, use as seguintes instruções:

1. Escolha **Product > Xcode Cloud > Create Workflow** para abrir a
   planilha **Create Workflow**.

2. Selecione o produto (aplicativo) ao qual o fluxo de trabalho deve ser anexado e clique no
   botão **Next**.

3. A próxima planilha exibe uma visão geral do fluxo de trabalho padrão fornecido pelo Xcode,
    e pode ser personalizado clicando no botão **Edit Workflow**.

#### Alterações de branch

Por padrão, o Xcode sugere a condição de Alterações de Branch que inicia uma nova construção
para cada alteração no branch padrão do seu repositório Git.

Para a variante iOS do seu aplicativo, é razoável que você queira que o Xcode Cloud
dispare seu fluxo de trabalho depois de você fazer alterações nos seus pacotes flutter, ou
modificar os arquivos de origem Dart ou iOS nos diretórios `lib\` e `ios\`.

Isso pode ser alcançado usando as seguintes condições de Arquivos e Pastas:

![Xcode Workflow Branch Changes](/assets/images/docs/releaseguide/xcode_workflow_branch_changes.png){:width="100%"}

### Próximo número de compilação

O Xcode Cloud define o número de compilação para novos fluxos de trabalho como `1` e o incrementa
por compilação bem-sucedida. Se você estiver usando um aplicativo existente com um número de compilação maior
, você precisará configurar o Xcode Cloud para usar o número de compilação correto
para suas compilações, simplesmente especificando o `Next Build Number` na sua iteração.

Confira [Definindo o próximo número de compilação para as compilações do Xcode Cloud][] para mais
informações.

[etapas de assinatura de aplicativos Android]: /deployment/android#signing-the-app  
[Appcircle]: https://appcircle.io/blog/guide-to-automated-mobile-ci-cd-for-flutter-projects-with-appcircle/  
[console da conta de desenvolvedor da Apple]: {{site.apple-dev}}/account/ios/certificate/  
[Bitrise]: https://devcenter.bitrise.io/en/getting-started/quick-start-guides/getting-started-with-flutter-apps  
[CI Options and Examples]: #reference-and-examples  
[Cirrus]: https://cirrus-ci.org  
[Cirrus script]: {{site.repo.flutter}}/blob/master/.cirrus.yml  
[Codemagic]: https://blog.codemagic.io/getting-started-with-codemagic/  
[fastlane]: https://docs.fastlane.tools  
[guia de implantação beta do fastlane para Android]: https://docs.fastlane.tools/getting-started/android/beta-deployment/  
[guia de implantação beta do fastlane para iOS]: https://docs.fastlane.tools/getting-started/ios/beta-deployment/  
[documentação do fastlane CI]: https://docs.fastlane.tools/best-practices/continuous-integration  
[Github Action in Flutter Project]: {{site.github}}/nabilnalakath/flutter-githubaction  
[GitHub Actions]: {{site.github}}/features/actions  
[GitLab]: https://docs.gitlab.com/ee/ci/  
[CircleCI]: https://circleci.com  
[Building and deploying Flutter apps with Fastlane]: https://circleci.com/blog/deploy-flutter-android  
[Match]: https://docs.fastlane.tools/actions/match/  
[etapas de configuração do Supply]: https://docs.fastlane.tools/getting-started/android/setup/#setting-up-supply  
[Travis]: https://travis-ci.org/  
[Programa de desenvolvedor da Apple]: {{site.apple-dev}}/programs  
[Xcode Cloud]: {{site.apple-dev}}/xcode-cloud  
[fluxo de trabalho do Xcode Cloud]: {{site.apple-dev}}/documentation/xcode/xcode-cloud-workflow-reference  
[scripts de construção personalizados]: {{site.apple-dev}}/documentation/xcode/writing-custom-build-scripts  
[variáveis de ambiente predefinidas]: {{site.apple-dev}}/documentation/xcode/environment-variable-reference  
[Definindo o próximo número de compilação para as compilações do Xcode Cloud]: {{site.apple-dev}}/documentation/xcode/setting-the-next-build-number-for-xcode-cloud-builds#Set-the-next-build-number-to-a-custom-value  
