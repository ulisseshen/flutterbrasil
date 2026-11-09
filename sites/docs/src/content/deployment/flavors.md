---
ia-translate: true
title: Configurar flavors Flutter para Android
shortTitle: Flavors (Android)
description: >
  Como criar flavors de build específicos para diferentes
  tipos de lançamento ou ambientes de desenvolvimento.
---

Este guia mostra como criar flavors Flutter para um
app Android.

## Visão geral

Um flavor Flutter quando usado com Android representa um
termo unificado para vários recursos específicos da plataforma. Por exemplo, um
flavor pode determinar qual ícone, nome do app, chave de API,
feature flag e nível de logging está associado a uma
versão específica do seu app.

Se você quiser criar flavors Flutter para um app Android,
você pode fazer isso no Flutter. No Android, um flavor Flutter é
referido como um [_product flavor_][].

O seguinte ilustra um exemplo das
[_build variants_] do Android que são criadas quando um app Android tem
dois product flavors (`staging`, `production`) e dois build
types (`debug`, `release`):

| Product flavors | Build types | Build variants resultantes |
| --- | --- | --- |
| staging | debug | stagingDebug<br>stagingRelease |
| production | release | productionDebug<br>productionRelease |

{:.table .table-striped}

[_product flavor_]: https://developer.android.com/build/build-variants#product-flavors
[_build variants_]: https://developer.android.com/build/build-variants

## Configure seus product flavors {: #using-flavors-in-android }

Complete os seguintes passos para adicionar dois product
flavors Android chamados `staging` e `production` a um novo projeto
Flutter chamado `flavors_example`, e então teste seu projeto
para garantir que os flavors funcionem como esperado.

1.  Crie um novo projeto Flutter chamado `flavors_example`
    com Kotlin como a linguagem Android preferida. Por
    padrão, o projeto inclui os tipos de build Android `debug` e
    `release`.

    ```console title="console"
    $ flutter create --android-language kotlin flavors_example
    ```

1.  Adicione os product flavors chamados `staging` e
    `production` ao projeto `flavors_example`.

    * No projeto `flavors_example`, navegue até o
      diretório `android/app/` e abra `build.gradle.kts`.

    * Adicione a propriedade `flavorDimensions` e as
      propriedades `productFlavors` dentro do
      bloco `android {}`. O template padrão define explicitamente
      o tipo de build `release`, enquanto o tipo de build `debug` é implícito:

      ```kotlin title="build.gradle.kts"
      android {
          ...
          buildTypes {
              release {
                  // TODO: Add your own signing config for the release build.
                  // Signing with the debug keys for now, so `flutter run --release` works.
                  signingConfig = signingConfigs.getByName("debug")
              }
          }
          ...
          flavorDimensions += "default"
          productFlavors {
              create("staging") {
                  dimension = "default"
                  applicationIdSuffix = ".staging"
              }
              create("production") {
                  dimension = "default"
                  applicationIdSuffix = ".production"
              }
          }
      }
      ```

1.  Para ter certeza de que você configurou tudo corretamente,
    execute seu app nos product flavors Android. Você não verá
    diferenças porque as configurações
    não mudaram, mas você quer ter certeza de que o
    app pode executar.

    * Inicie um emulador Android ou conecte um dispositivo físico
      com opções de desenvolvedor habilitadas.

    * No console, navegue até o diretório `flavors_example`
      e digite o seguinte comando para testar o
      flavor `staging`:

      ```console title="console"
      $ flutter run --flavor staging
      ```

    * Repita o passo anterior para o flavor `production`.

1.  Se tudo executar, você está pronto para personalizar suas
    configurações. Para mais informações, veja
    [Customize configurations][].

[Customize configurations]: #customize-configurations

## Iniciar um flavor {: #launching-your-app-flavors }

Depois de criar os product flavors para um app Android,
você pode iniciar um product flavor específico através do Flutter.

Você pode iniciar um product flavor com o Flutter CLI usando
os seguintes passos:

1.  Inicie um emulador Android ou conecte um dispositivo físico
    com opções de desenvolvedor habilitadas.

1. No console, navegue até o diretório `flavors_example`
e digite o seguinte comando:

```console title="console"
$ flutter (run | build <subcommand>) --flavor <flavor_name>
```

* `(run | build <subcommand>)`: Substitua isso por um dos seguintes:
  * `run`: Executa o app em modo debug.
  * `build`: Compila um APK ou um appbundle.
    * `<subcommand>`: Ou `apk` ou `appbundle`.

* `<flavor_name>`: Substitua isso pelo nome do seu
  product flavor Android (por exemplo: `staging`, `production`).

Exemplo:

```console title="console"
$ flutter build apk --flavor staging
```

## Usar flavors no código Flutter {:#use-flavors-in-flutter-code}

Depois de configurar seus product flavors, você pode mudar o comportamento do seu app—como apontar para diferentes endpoints de API ou mudar o tema—com base no flavor ativo.

O framework Flutter fornece a constante `appFlavor`, que recupera o nome do flavor atual como uma `String`. Esse valor corresponde ao nome do flavor passado para a flag `--flavor` durante o processo de `flutter run` ou `flutter build`.

### Acessar o flavor atual {:#access-the-current-flavor}

1.  **Importe a biblioteca services:**
    Para acessar a constante `appFlavor`,
    adicione o seguinte import ao seu arquivo Dart:

    ```dart
    import 'package:flutter/services.dart';
    ```

1.  **Verifique o valor do flavor:**
    Use a constante `appFlavor` na lógica da sua aplicação
    (geralmente em `main()`) para lidar com configurações específicas de cada flavor:

    ```dart
    void main() {
      // appFlavor will match the flavor name from build.gradle.kts
      if (appFlavor == 'production') {
        // Logic for production environment
        Config.apiUrl = 'https://api.flavors_example.com';
      } else if (appFlavor == 'staging') {
        // Logic for staging environment
        Config.apiUrl = 'https://staging.api.flavors_example.com';
      }

      runApp(const MyApp());
    }
    ```

    :::note
    O valor de `appFlavor` corresponde ao nome do product flavor que você definiu no seu arquivo `build.gradle.kts` (por exemplo, `staging` ou `production`). Se nenhum flavor for especificado durante a compilação, `appFlavor` retorna `null`.
    :::

## Personalizar configurações {:#customize-configurations}

Depois de adicionar product flavors, você pode personalizá-los
para seu app Android.

### Criar um nome de exibição de app distinto

Se você tem múltiplos product flavors, um nome de app distinto
pode identificar rapidamente qual flavor seu app implantado está
usando.

![Distinct app names in menu](/assets/images/docs/flavors/flavors-android-app-names-1.png){:width="40%"}

Os seguintes passos mostram como adicionar nomes de exibição de app distintos
para dois product flavors chamados `staging` e
`production` em um projeto chamado `flavors_example`.

1.  Crie diretórios de recursos específicos de cada flavor:

    * Navegue até o diretório `android/app/src`.

    * Crie um diretório chamado `staging/res/values`.

    * Navegue até o diretório `staging/res/values`.

    * Crie o seguinte arquivo `strings.xml`:

      ```xml title="strings.xml"
      <?xml version="1.0" encoding="utf-8"?>
      <resources>
          <string name="app_name">Flavors staging</string>
      </resources>
      ```

      :::note
      Se o seu projeto define `app_name` com `resValue()` em `build.gradle.kts`,
      compilações com o Android Gradle Plugin (AGP) 9.0 ou posterior falham por padrão
      com um erro como
      `Product Flavor <flavor_name> contains custom resource values, but the feature is disabled.`
      Para corrigir isso, remova essas chamadas `resValue()`
      e defina `app_name` em arquivos `strings.xml` como mostrado neste passo.
      :::
    
    * Repita os passos anteriores para o flavor `production`
      e defina o valor de `app_name` como `Flavors production`.

1.  Atualize `AndroidManifest.xml` no seu IDE:

    * No projeto `flavors_example`, navegue até
      `android/app/src/main` e abra `AndroidManifest.xml`.

    * Substitua o valor de `android:label` por
      `@string/app_name`.

      ```xml title="AndroidManifest.xml"
      <manifest xmlns:android="http://schemas.android.com/apk/res/android">
          <application
            android:label="@string/app_name"
            ...
          />
      />
      ```

1.  Inicie o app para cada product flavor (`staging`,
    `production`) e verifique para ter certeza de que o
    nome de exibição do app mudou para cada um.

    * Para iniciar um product flavor, veja os passos em
      [Launch a flavor][].

    * No Android App Emulator, vá para a lista de apps.
      Você deve ver um para `Flavors p...` e
      `Flavors s...`.

    * Para ver mais informações para `Flavors p...` ou
      `Flavors s...`, pressione longamente o ícone de um deles
      e selecione `App info`.

[Launch a flavor]: #launching-your-app-flavors

### Criar ícones distintos

Se você tem múltiplos product flavors, um ícone distinto para
cada configuração pode ajudá-lo a identificar rapidamente qual
flavor seu app implantado está usando.

![Distinct icons](/assets/images/docs/flavors/flavors-android-icons.png){:width="40%"}

Os seguintes passos mostram como adicionar um ícone distinto para dois
product flavors chamados `staging` e `production` em um
projeto chamado `flavors_example`.

1.  Prepare seus ícones:

    * Projete seu ícone de `staging` e ícone de `production` na
      ferramenta de design de sua escolha.

    * Gere versões do ícone de `staging` e
      ícone de `production` nos seguintes tamanhos e salve-os em
      formato `PNG`:

      * mipmap-mdpi (48x48 pixels)
      * mipmap-hdpi (72x72 pixels)
      * mipmap-xhdpi (96x96 pixels)
      * mipmap-xxhdpi (144x144 pixels)
      * mipmap-xxxhdpi (192x192 pixels)

    :::note
    Você pode usar uma ferramenta como [App Icon Generator][]
    para gerar as versões de seus ícones.
    :::

1.  Crie diretórios de recursos específicos de flavor:

    * Navegue até o diretório `android/app/src`.

    * Crie um diretório chamado `staging/res`.

    * Navegue até o diretório `staging/res`.

    * Crie os seguintes diretórios `mipmap` e mova as
      versões do ícone de `staging` para eles:

      * `mipmap-mdpi/48x48_staging.png`
      * `mipmap-hdpi/72x72_staging.png`
      * `mipmap-xhdpi/96x96_staging.png`
      * `mipmap-xxhdpi/144x144_staging.png`
      * `mipmap-xxxhdpi/192x192_staging.png`

    * Repita os passos anteriores para os diretórios e ícones
      do flavor `production`.

    * Renomeie todos os ícones para `ic_launcher.png`.

1.  Verifique novamente as configurações em `AndroidManifest.xml`
    no seu IDE:

    * No projeto `flavors_example`, navegue até
      `android/app/src/main` e abra `AndroidManifest.xml`.

    * Certifique-se de que o valor de `android:icon` é
      `@mipmap/ic_launcher`.

1.  Inicie o app para cada product flavor (`staging`,
    `production`) e verifique para ter certeza de que o ícone do app
    mudou para cada um. Para iniciar um product flavor, veja
    os passos em [Launch a flavor][].

[Launch a flavor]: #launching-your-app-flavors
[App Icon Generator]: https://www.appicon.co/

### Bundle de assets

Se você tem assets que são usados apenas em um flavor específico
no seu app, você pode configurá-los para serem incluídos no bundle
apenas quando iniciar esse flavor. Isso evita que o
tamanho do bundle do seu app seja inflado por assets não utilizados. Para
incluir assets no bundle para cada flavor, adicione o subcampo `flavors`
ao campo `assets` no pubspec do seu projeto. Para saber
mais, veja o [campo `assets`][`assets` field] em
[opções pubspec do Flutter][Flutter pubspec options].

[`assets` field]: /tools/pubspec#assets
[Flutter pubspec options]: /tools/pubspec

### Definir um flavor padrão

Você pode fazer com que seu app use um flavor específico quando você
iniciar seu app sem especificar um flavor. Para fazer isso,
você precisa adicionar o campo `default-flavor` ao pubspec do seu projeto.
Para saber mais, veja o [campo `default-flavor`][`default-flavor` field]
em [opções pubspec do Flutter][Flutter pubspec options].

[`default-flavor` field]: /tools/pubspec#default-flavor

### Adicionar configurações de build únicas

Se você tem configurações de build adicionais que gostaria de
configurar para um product flavor Android específico, veja o
[Configure build variants][] do Android.

Embora seja possível definir `abiFilters` em product flavors, isso não é
recomendado. Prefira configurar `abiFilters` em `defaultConfig` quando possível.
Ao definir `abiFilters` em product flavors, passe
`-Pdisable-abi-filtering=true` ao executar `flutter build` ou `flutter run`.

[Configure build variants]: https://developer.android.com/build/build-variants

## Mais informações

Para mais informações sobre como criar e usar flavors, confira
os seguintes recursos:

* [Set up Flutter flavors for iOS and macOS][]
* [Set up Flutter flavors for Linux][]
* [Set up Flutter flavors for Windows][]
* [Build flavors in Flutter (Android and iOS) with Firebase][]
* [How to Setup Flutter & Firebase with Multiple Flavors using the FlutterFire CLI][flutterfireCLI]

[Set up Flutter flavors for iOS and macOS]: /deployment/flavors-ios
[Set up Flutter flavors for Linux]:   /deployment/flavors-linux
[Set up Flutter flavors for Windows]: /deployment/flavors-windows
[Build flavors in Flutter (Android and iOS) with Firebase]: https://medium.com/@animeshjain/build-flavors-in-flutter-android-and-ios-with-different-firebase-projects-per-flavor-27c5c5dac10b
[flutterfireCLI]: https://codewithandrea.com/articles/flutter-firebase-multiple-flavors-flutterfire-cli/
