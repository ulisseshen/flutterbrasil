---
ia-translate: true
title: Compilar e publicar um app Android
description: Como preparar e publicar um app Android na Play Store.
shortTitle: Android
---

Para testar um app, você pode usar `flutter run` na linha de comando,
ou as opções **Run** e **Debug** em sua IDE.

Quando estiver pronto para preparar uma versão _release_ do seu app,
por exemplo para [publicar na Google Play Store][play],
esta página pode ajudar. Antes de publicar,
você pode querer adicionar alguns toques finais ao seu app.
Este guia explica como realizar as seguintes tarefas:

* [Adicionar um ícone de launcher](#add-a-launcher-icon)
* [Habilitar Material Components](#enable-material-components)
* [Assinar o app](#sign-the-app)
* [Reduzir seu código com R8](#shrink-your-code-with-r8)
* [Habilitar suporte a multidex](#enable-multidex-support)
* [Revisar o manifest do app](#review-the-app-manifest)
* [Revisar a configuração de build](#review-the-gradle-build-configuration)
* [Compilar o app para release](#build-the-app-for-release)
* [Publicar na Google Play Store](#publish-to-the-google-play-store)
* [Atualizar o número de versão do app](#update-the-apps-version-number)
* [FAQ de release Android](#android-release-faq)

:::note
Ao longo desta página, `[project]` refere-se ao
diretório que contém sua aplicação.
Ao seguir estas instruções,
substitua `[project]` pelo diretório do seu app.
:::

[play]: {{site.android-dev}}/distribute

## Add a launcher icon

Quando um novo app Flutter é criado, ele tem um ícone de launcher padrão.
Para saber como personalizar este ícone, confira o
pacote [flutter_launcher_icons][].

Alternativamente, você pode fazer isso manualmente usando as seguintes etapas:

1. Revise as [diretrizes de ícones adaptativos][adaptive-icons] do Android
   para especificações de design e dimensionamento de ícones.

1. No diretório `[project]/android/app/src/main/res/`,
   coloque seus arquivos de ícone em pastas nomeadas usando
   [configuration qualifiers][config-qual].
   As pastas padrão `mipmap-` demonstram a
   convenção de nomenclatura correta.

1. No `AndroidManifest.xml`, atualize o
   atributo `android:icon` da tag [`application`][applicationtag]
   para referenciar ícones da etapa
   anterior (por exemplo,
   `<application android:icon="@mipmap/ic_launcher" ...`).

1. Para verificar se o ícone foi substituído,
   execute seu app e inspecione o ícone do app no Launcher.

[flutter_launcher_icons]: {{site.pub}}/packages/flutter_launcher_icons
[adaptive-icons]:
  {{site.android-dev}}/develop/ui/views/launch/icon_design_adaptive
[config-qual]: {{site.android-dev}}/guide/topics/resources/providing-resources#AlternativeResources
[applicationtag]: {{site.android-dev}}/guide/topics/manifest/application-element

## Enable Material Components

Se seu app usa [platform views][], você pode querer habilitar
Material Components seguindo as etapas descritas no
[Getting Started guide for Android][].

Por exemplo:

1. Adicione a dependência no Material do Android em `<my-app>/android/app/build.gradle.kts`:

<Tabs key="android-material-dependency">
<Tab name="Kotlin">

```kotlin
dependencies {
    // ...
    implementation("com.google.android.material:material:<version>")
    // ...
}
```

</Tab>
<Tab name="Groovy">

```groovy
dependencies {
    // ...
    implementation 'com.google.android.material:material:<version>'
    // ...
}
```

</Tab>
</Tabs>

   Para descobrir a versão mais recente, visite [Google Maven][maven-material].

1. Defina o tema claro em `<my-app>/android/app/src/main/res/values/styles.xml`:

   ```xml diff
   - <style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar">
   + <style name="NormalTheme" parent="Theme.MaterialComponents.Light.NoActionBar">
   ```

1. Defina o tema escuro em `<my-app>/android/app/src/main/res/values-night/styles.xml`:

   ```xml diff
   - <style name="NormalTheme" parent="@android:style/Theme.Black.NoTitleBar">
   + <style name="NormalTheme" parent="Theme.MaterialComponents.DayNight.NoActionBar">
   ```

[platform views]: /platform-integration/android/platform-views
[Getting Started guide for Android]: {{site.material}}/develop/android/mdc-android
[maven-material]: https://maven.google.com/web/index.html#com.google.android.material:material

<a id="signing-the-app"></a>
## Sign the app

Para publicar na Play Store, você deve
assinar seu app com um certificado digital.

Android usa duas chaves de assinatura: _upload_ e _app signing_.

* Desenvolvedores fazem upload de um arquivo `.aab` ou `.apk` assinado com
  uma _chave de upload_ para a Play Store.
* Os usuários finais baixam o arquivo `.apk` assinado com uma _chave de assinatura do app_.

Para criar sua chave de assinatura do app, use Play App Signing
conforme descrito na [documentação oficial da Play Store][official Play Store documentation].

Para assinar seu app, use as seguintes instruções.

[official Play Store documentation]: https://support.google.com/googleplay/android-developer/answer/7384423?hl=en

### Create an upload keystore

Se você tem um keystore existente, pule para a próxima etapa.
Caso contrário, crie um usando um dos seguintes métodos:

1. Siga as [etapas de geração de chave do Android Studio][as-key-steps].
1. Execute o seguinte comando na linha de comando:

   No macOS ou Linux, use o seguinte comando:

   ```console
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA \
           -storetype JKS -keysize 2048 -validity 10000 -alias upload
   ```

   No Windows, use o seguinte comando no PowerShell:

   ```ps
   keytool -genkey -v -keystore $env:USERPROFILE\upload-keystore.jks `
           -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 `
           -alias upload
   ```

   Este comando armazena o arquivo `upload-keystore.jks` em seu diretório home.
   Se você quiser armazená-lo em outro lugar, altere
   o argumento que você passa para o parâmetro `-keystore`.
   **No entanto, mantenha o arquivo `keystore` privado;
   não o envie para controle de código público!**

   :::note
   * O comando `keytool` pode não estar em seu path&mdash;ele faz
     parte do Java, que é instalado como parte do Android Studio.
     Para o caminho concreto, execute `flutter doctor -v` e
     localize o caminho impresso após 'Java binary at:'.
     Em seguida, use esse caminho totalmente qualificado
     substituindo `java` (no final) por `keytool`.
     Se seu caminho incluir nomes separados por espaços, como `Program Files`,
     use notação apropriada da plataforma para os nomes.
     Por exemplo, no macOS e Linux use `Program\ Files`, e
     no Windows use `"Program Files"`.

   * A tag `-storetype JKS` só é necessária para Java 9
     ou mais recente. A partir da versão Java 9,
     o tipo de keystore padrão é PKS12.
   :::

[as-key-steps]: {{site.android-dev}}/studio/publish/app-signing#generate-key

### Reference the keystore from the app

Crie um arquivo chamado `[project]/android/key.properties`
que contenha uma referência ao seu keystore.
Não inclua os colchetes angulares (`< >`),
que indicam que o texto serve como espaço reservado para seus valores:

```properties
storePassword=<password-from-previous-step>
keyPassword=<password-from-previous-step>
keyAlias=upload
storeFile=<keystore-file-location>
```

O `storeFile` pode estar localizado em
`/Users/<user name>/upload-keystore.jks` no macOS
ou `C:\\Users\\<user name>\\upload-keystore.jks` no Windows.

:::note
O caminho do Windows para `keystore.jks` deve ser especificado com barras invertidas duplas: `\\`.
:::

:::warning
Mantenha o arquivo `key.properties` privado;
não o envie para controle de código público.
:::

### Configure signing in Gradle

Ao compilar seu app em modo release, configure o Gradle para usar sua chave de upload.
Para configurar o Gradle, edite o arquivo `<project>/android/app/build.gradle.kts`.

1. Defina e carregue o arquivo de propriedades do keystore antes do bloco de propriedade `android`.

1. Defina o objeto `keystoreProperties` para carregar o arquivo `key.properties`:

<Tabs key="android-keystore-properties">
<Tab name="Kotlin">

```kotlin diff title="[project]/android/app/build.gradle.kts"
+ import java.util.Properties
+ import java.io.FileInputStream
+
  plugins {
     ...
  }
+
+ val keystoreProperties = Properties()
+ val keystorePropertiesFile = rootProject.file("key.properties")
+ if (keystorePropertiesFile.exists()) {
+     keystoreProperties.load(FileInputStream(keystorePropertiesFile))
+ }
+
  android {
     ...
  }
```

</Tab>
<Tab name="Groovy">

```groovy diff title="[project]/android/app/build.gradle"
+ import java.util.Properties
+ import java.io.FileInputStream
+
  plugins {
     ...
  }
+
+ def keystoreProperties = new Properties()
+ def keystorePropertiesFile = rootProject.file('key.properties')
+ if (keystorePropertiesFile.exists()) {
+     keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
+ }
+
  android {
     ...
  }
```

</Tab>
</Tabs>

1. Adicione a configuração de assinatura antes do bloco de propriedade `buildTypes`
   dentro do bloco de propriedade `android`:

<Tabs key="android-signing-config">
<Tab name="Kotlin">

```kotlin diff title="[project]/android/app/build.gradle.kts"
  android {
      // ...

+     signingConfigs {
+         create("release") {
+             keyAlias = keystoreProperties.getProperty("keyAlias")
+             keyPassword = keystoreProperties.getProperty("keyPassword")
+             storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
+             storePassword = keystoreProperties.getProperty("storePassword")
+         }
+     }
      buildTypes {
          release {
              // TODO: Add your own signing config for the release build.
              // Signing with the debug keys for now,
              // so `flutter run --release` works.
-             signingConfig = signingConfigs.getByName("debug")
+             signingConfig = signingConfigs.getByName("release")
          }
      }
  ...
  }
```

</Tab>
<Tab name="Groovy">

```groovy diff title="[project]/android/app/build.gradle"
  android {
      // ...

+     signingConfigs {
+         release {
+             keyAlias = keystoreProperties['keyAlias']
+             keyPassword = keystoreProperties['keyPassword']
+             storeFile = keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
+             storePassword = keystoreProperties['storePassword']
+         }
+     }
      buildTypes {
          release {
              // TODO: Add your own signing config for the release build.
              // Signing with the debug keys for now,
              // so `flutter run --release` works.
-             signingConfig = signingConfigs.debug
+             signingConfig = signingConfigs.release
          }
      }
  ...
  }
```

</Tab>
</Tabs>

Flutter agora assina todos os builds de release.

:::note
Você pode precisar executar `flutter clean` após alterar o arquivo Gradle.
Isso evita que builds em cache afetem o processo de assinatura.
:::

Para saber como assinar seu app, confira
[Sign your app][] na documentação do desenvolvedor Android.

[Sign your app]: {{site.android-dev}}/studio/publish/app-signing.html#generate-key

### Post-quantum cryptography (PQC) hybrid signing (Android 17+)

Android 17 introduces the v3.2 APK Signature Scheme.
This scheme combines classical signatures (such as RSA or EC)
with ML-DSA signatures to enable post-quantum cryptography (PQC) hybrid signing.
This future-proofs your app's signing identity against the potential threat of
attacks that make use of quantum computing.

* **Apps using Play App Signing**:
  If you use Play App Signing,
  you can wait for Google Play to give you the option to upgrade to a hybrid
  signature using a PQC key generated by Google Play.
* **Apps using self-managed keys**:
  If you manage your own signing keys,
  you can use updated Android build tools (such as `apksigner`)
  to rotate to a hybrid identity,
  combining a PQC key with a new classical key.
  Note that you must create a new classical key;
  you cannot reuse the older one.

For details, consult the
[Android documentation on PQC APK signing][android-doc].

[android-doc]: {{site.android-dev}}/about/versions/17/features#pqc-apk-signing

## Shrink your code with R8

[R8][] é o novo redutor de código do Google.
Ele é habilitado por padrão quando você compila um APK ou AAB de release.
Para desabilitar o R8, passe a flag `--no-shrink` para
`flutter build apk` ou `flutter build appbundle`.

:::note
Ofuscação e minificação podem estender consideravelmente
o tempo de compilação de uma aplicação Android.

A flag `--[no-]shrink` não tem efeito.
A redução de código está sempre habilitada em builds de release.
Para detalhes, visite [Shrink, obfuscate, and optimize your app][].
:::

[R8]: {{site.android-dev}}/studio/build/shrink-code
[Shrink, obfuscate, and optimize your app]: {{site.android-dev}}/studio/build/shrink-code

## Enable multidex support

Ao escrever apps grandes ou usar plugins grandes,
você pode encontrar o limite dex do Android de 64k métodos
ao ter como alvo uma API mínima de 20 ou inferior.
Isso também pode ser encontrado ao executar versões debug do seu app
usando `flutter run` que não tem redução habilitada.

A ferramenta Flutter suporta habilitar multidex facilmente.
A maneira mais simples é optar pelo suporte multidex quando solicitado.
A ferramenta detecta erros de build multidex e
pergunta antes de fazer alterações no seu projeto Android.
Optar permite que o Flutter dependa automaticamente de
`androidx.multidex:multidex` e use um
`FlutterMultiDexApplication` gerado como aplicação do projeto.

Quando você tenta compilar e executar seu app com as opções **Run** e **Debug**
em sua IDE, seu build pode falhar com a seguinte mensagem:

<img src='/assets/images/docs/deployment/android/ide-build-failure-multidex.png'
  width="100%" alt='Build failure because Multidex support is required'>

Para habilitar multidex da linha de comando,
execute `flutter run --debug` e selecione um dispositivo com Android:

<img src='/assets/images/docs/deployment/android/cli-select-device.png'
  width="100%" alt='Selecting an Android device with the flutter CLI.'>

Quando solicitado, digite `y`.
A ferramenta Flutter habilita o suporte multidex e tenta novamente o build:

<img src='/assets/images/docs/deployment/android/cli-multidex-added-build.png'
  width="100%" alt='The output of a successful build after adding multidex.'>

:::version-note
O suporte multidex é incluído nativamente ao ter como alvo
Android SDK 21 ou posterior.
:::

Você também pode optar por suportar multidex manualmente seguindo os guias do Android
e modificando a configuração do diretório Android do seu projeto.
Um [arquivo multidex keep][multidex-keep] deve ser especificado para incluir:

```plaintext
io/flutter/embedding/engine/loader/FlutterLoader.class
io/flutter/util/PathUtils.class
```

Além disso, inclua quaisquer outras classes usadas na inicialização do app.
Para saber como adicionar suporte multidex manualmente,
consulte a [documentação oficial do Android][multidex-docs].

[multidex-keep]: {{site.android-dev}}/studio/build/multidex#keep
[multidex-docs]: {{site.android-dev}}/studio/build/multidex

## Review the app manifest

Revise o arquivo [App Manifest][manifest] padrão:

```xml title="[project]/android/app/src/main/AndroidManifest.xml"
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        [!android:label="[project]"!]
        ...
    </application>
    ...
    [!<uses-permission android:name="android.permission.INTERNET"/>!]
</manifest>
```

Verifique os seguintes valores:

| Tag                                | Atributo | Valor                                                                                                   |
|------------------------------------|-----------|-----------------------------------------------------------------------------------------------------------|
| [`application`][applicationtag]    | Edite o `android:label` na tag [`application`][applicationtag] para refletir o nome final do app. |
| [`uses-permission`][permissiontag] | Adicione o valor de [permissão][permissiontag] `android.permission.INTERNET` ao atributo `android:name` se seu app precisa de acesso à Internet. O template padrão não inclui esta tag, mas permite acesso à Internet durante o desenvolvimento para habilitar comunicação entre as ferramentas Flutter e um app em execução. |

{:.table .table-striped}

[manifest]: {{site.android-dev}}/guide/topics/manifest/manifest-intro
[applicationtag]: {{site.android-dev}}/guide/topics/manifest/application-element
[permissiontag]: {{site.android-dev}}/guide/topics/manifest/uses-permission-element

## Review the Gradle build configuration {:#review-the-gradle-build-configuration}

Para verificar a configuração de build do Android,
revise o bloco `android` no
[script de build Gradle][gradlebuild] padrão,
encontrado em `[project]/android/app/build.gradle.kts`:

```kotlin title="[project]/android/app/build.gradle.kts"
android {
    namespace = "com.example.[project]"
    // Any value starting with "flutter." gets its value from
    // the Flutter Gradle plugin.
    // To change from these defaults, make your changes in this file.
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    ...

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.[project]"
        // You can update the following values to match your application needs.
        // For details, see https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        ...
    }
}
```

[gradlebuild]: {{site.android-dev}}/studio/build/#module-level

### Application ID

O `applicationId` é o identificador único do seu app na Google Play Store
e nos dispositivos dos desenvolvedores.

:::important
Revise o `applicationId` em `defaultConfig` e garanta que ele seja único.
Normalmente, ele é um nome de domínio reverso, como `com.example.myapp`.
Depois de enviar seu app para a Play Store, você não pode alterar o Application ID.
:::

Se você atualizar as propriedades `applicationId` e `namespace`,
também deve atualizar a declaração `package` no seu arquivo `MainActivity.kt`
ou `MainActivity.java` e mover o arquivo
para a estrutura de diretórios correspondente.

Por exemplo:

- Em Kotlin, se seu novo ID for `com.example.myapp`,
  mova seu arquivo `MainActivity` para
  `android/app/src/main/kotlin/com/example/myapp/MainActivity.kt`
  e garanta que a primeira linha seja `package com.example.myapp`.
- Em Java, mova seu arquivo `MainActivity` para
  `android/app/src/main/java/com/example/myapp/MainActivity.java`
  e garanta que a primeira linha seja `package com.example.myapp`.

[application-id]: {{site.android-dev}}/studio/build/application-id

### Android SDK versions

The Flutter tooling sets default values for the Android SDK versions:

* **`compileSdk`**: The version of the Android SDK used to
  compile the app.
* **`minSdk`**: The minimum Android version that the
  app supports.
* **`targetSdk`**: The Android version the app is designed and
  tested to run on.

These default values (`flutter.compileSdkVersion`, etc.) are managed by Flutter
to ensure compatibility with the framework and plugins.
You typically **do not** need to change these unless:

1. **You need a newer API**: If you are using a plugin or feature that requires a higher
   `minSdk` than Flutter's default, you can manually set it to a higher version number
   (for example, `minSdk = 24`).
2. **You need to lock versions**: If you want to prevent automatic updates to these versions
   when upgrading Flutter, you can replace the default variables with specific integer values.

### Version code and name

The `versionCode` and `versionName` are automatically set from your `pubspec.yaml` file
(using the `version: 1.0.0+1` field). You generally don't need to modify these in the Gradle file.

[Version your app]: {{site.android-dev}}/studio/publish/versioning

## Build the app for release

Você tem dois formatos de release possíveis ao
publicar na Play Store.

* App bundle (preferido)
* APK

:::note
A Google Play Store prefere o formato de app bundle.
Para saber mais sobre Android App Bundles, visite
[About Android App Bundles][bundle].
:::

[bundle]: {{site.android-dev}}/guide/app-bundle

### Build an app bundle

Esta seção descreve como compilar um app bundle de release.
Se você completou as etapas de assinatura,
o app bundle será assinado.
Neste ponto, você pode considerar [ofuscar seu código Dart][obfuscating your Dart code]
para torná-lo mais difícil de fazer engenharia reversa.
Ofuscar seu código envolve adicionar flags ao seu comando de build e
manter arquivos adicionais para desobfuscar stack traces.

Da linha de comando:

1. Digite `cd [project]`<br>
1. Execute `flutter build appbundle`<br>
   (Executar `flutter build` tem como padrão um build de release.)

O bundle de release para seu app é criado em
`[project]/build/app/outputs/bundle/release/app.aab`.

Por padrão, o app bundle contém seu código Dart e o
runtime Flutter compilado para [armeabi-v7a][] (ARM 32-bit), [arm64-v8a][]
(ARM 64-bit) e [x86-64][] (x86 64-bit).

[obfuscating your Dart code]: /deployment/obfuscate
[arm64-v8a]: {{site.android-dev}}/ndk/guides/abis#arm64-v8a
[armeabi-v7a]: {{site.android-dev}}/ndk/guides/abis#v7a
[x86-64]: {{site.android-dev}}/ndk/guides/abis#86-64

### Test the app bundle

Um app bundle pode ser testado de várias maneiras.
Esta seção descreve duas.

#### Offline using the bundle tool

1. Se você ainda não fez isso, baixe `bundletool` de
   seu [repositório GitHub][bundletool-github].
1. [Gere um conjunto de APKs][apk-set] a partir do seu app bundle.
1. [Implante os APKs][apk-deploy] em dispositivos conectados.

[bundletool-github]: https://github.com/google/bundletool/releases/latest
[apk-set]: {{site.android-dev}}/studio/command-line/bundletool#generate_apks
[apk-deploy]: {{site.android-dev}}/studio/command-line/bundletool#deploy_with_bundletool

#### Online using Google Play

1. Faça upload do seu bundle para o Google Play para testá-lo.
   Você pode usar a trilha de teste interno,
   ou os canais alfa ou beta para testar o bundle antes
   de lançá-lo em produção.
2. Siga as etapas para [fazer upload do seu bundle][upload-bundle]
   para a Play Store.

[upload-bundle]: {{site.android-dev}}/studio/publish/upload-bundle

### Build an APK

Embora app bundles sejam preferidos em relação a APKs,
existem lojas que ainda não suportam app bundles.
Neste caso, compile um APK de release para
cada ABI alvo (Application Binary Interface).

Se você completou as etapas de assinatura, o APK será assinado.
Neste ponto, você pode considerar [ofuscar seu código Dart][obfuscating your Dart code]
para torná-lo mais difícil de fazer engenharia reversa.
Ofuscar seu código envolve adicionar flags ao seu comando de build.

Da linha de comando:

1. Digite `cd [project]`.

1. Execute `flutter build apk --split-per-abi`.
   (O comando `flutter build` tem como padrão `--release`.)

Este comando resulta em três arquivos APK:

* `[project]/build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`
* `[project]/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`
* `[project]/build/app/outputs/flutter-apk/app-x86_64-release.apk`

Remover a flag `--split-per-abi` resulta em um APK "fat" que contém
seu código compilado para _todos_ os ABIs alvo.
Tais APKs são maiores em tamanho do que suas contrapartes divididas,
fazendo com que o usuário baixe binários nativos que
não são aplicáveis à arquitetura de seu dispositivo.

When using split APKs, the framework adds `ABI_VERSION * 1000`
to the version code. This is because the Google Play Store
[doesn't allow](https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
multiple APKs for the same app to have the same version code.
To force the default version code, specify the
`-P force-version-code-ignoring-abi=true` flag during the build.

[obfuscating your Dart code]: /deployment/obfuscate

### Install an APK on a device

Siga estas etapas para instalar o APK em um dispositivo Android conectado.

Da linha de comando:

1. Conecte seu dispositivo Android ao seu computador com um cabo USB.
1. Digite `cd [project]`.
1. Execute `flutter install`.

## Publish to the Google Play Store

Para saber como publicar seu app na Google Play Store,
consulte a documentação de [lançamento no Google Play][play].

## Update the app's version number

O número de versão padrão do app é `1.0.0`.
Para atualizá-lo, navegue até o arquivo `pubspec.yaml`
e atualize a seguinte linha:

```yaml
version: 1.0.0+1
```

O número de versão são três números separados por pontos,
como `1.0.0` no exemplo anterior,
seguido por um número de build opcional,
como `1` no exemplo anterior, separado por um `+`.

Tanto a versão quanto o número de build podem ser substituídos no
build do Flutter especificando `--build-name` e `--build-number`, respectivamente.

No Android, `build-name` é usado como `versionName` enquanto
`build-number` é usado como `versionCode`. Para detalhes,
consulte [Version your app][] na documentação do Android.

Quando você recompila o app para Android, quaisquer atualizações no
número de versão do arquivo pubspec irão
atualizar o `versionName` e `versionCode` no arquivo `local.properties`.

[Version your app]: {{site.android-dev}}/studio/publish/versioning

## Android release FAQ

Aqui estão algumas perguntas comumente feitas sobre implantação para
apps Android.

### When should I build app bundles versus APKs?

A Google Play Store recomenda que você implante app bundles
em vez de APKs porque eles permitem uma entrega mais eficiente da
aplicação aos seus usuários. No entanto, se você está distribuindo
sua aplicação por outros meios que não a Play Store,
um APK pode ser sua única opção.

### What is a fat APK?

Um [fat APK][] é um único APK que contém binários para múltiplos
ABIs incorporados nele. Isso tem o benefício de que o único APK
executa em múltiplas arquiteturas e assim tem compatibilidade mais ampla,
mas tem a desvantagem de que seu tamanho de arquivo é muito maior,
fazendo com que os usuários baixem e armazenem mais bytes ao instalar
sua aplicação. Ao compilar APKs em vez de app bundles,
é fortemente recomendado compilar APKs divididos,
conforme descrito em [build an APK](#build-an-apk) usando a
flag `--split-per-abi`.

[fat APK]: https://en.wikipedia.org/wiki/Fat_binary

### What are the supported target architectures?

Ao compilar sua aplicação em modo release,
apps Flutter podem ser compilados para [armeabi-v7a][] (ARM 32-bit),
[arm64-v8a][] (ARM 64-bit) e [x86-64][] (x86 64-bit).

### How do I sign the app bundle created by `flutter build appbundle`?

Confira [Sign the app](#sign-the-app).

### How do I build a release from within Android Studio?

No Android Studio, abra a pasta `android/`
existente dentro da pasta do seu app. Em seguida,
selecione **build.gradle (Module: app)** no painel do projeto:

<img src='/assets/images/docs/deployment/android/gradle-script-menu.png'
  alt='The Gradle build script menu in Android Studio.' style="max-height: 20rem">

Em seguida, selecione a variante de build. Clique em **Build > Select Build Variant**
no menu principal. Selecione qualquer uma das variantes no painel **Build Variants**
(debug é o padrão):

<img src='/assets/images/docs/deployment/android/build-variant-menu.png'
  alt='The build variant menu in Android Studio with Release selected.'
  style="max-height: 20rem">

Os arquivos resultantes de app bundle ou APK estão localizados em
`build/app/outputs` dentro da pasta do seu app.

### How to tell if an apk uses Flutter?

You can use the [`apkanalyzer`][] tool and list the files:

```sh
apkanalyzer files list --files-only <SOME-APK> files list --files-only <SOME-APK>
```

Then look for a file in `/lib/<ARCH>/libflutter.so`.

For example, the following should return a number greater than 0:

```sh
apkanalyzer files list some-flutter-app.apk | grep flutter.so | wc -l
```

**Why this works**

Flutter depends on C++ code used by the Flutter engine. In Android,
this code is bundled with the Flutter framework and the developer's
Dart code as a native library called `libflutter.so`.
The Java/Android tooling renames the `flutter` library with the `lib` prefix
and handles library location across architectures.
This is how some reverse engineer an APK to identify it as a Flutter app.

[`apkanalyzer`]: {{site.android-dev}}/tools/apkanalyzer

#### Secondary Evaluation:

Run `apkanalyzer manifest print <SOME-APK>` and look for a `<meta-data>`
tag with `android:name="flutterEmbedding"`.
The value can be `1` or `2`.

This command,
`apkanalyzer manifest print some-flutter-app.apk | grep flutterEmbedding -C 2`,
returns the following output:
```
<meta-data
   android:name="flutterEmbedding"
   android:value="2" />
```

**Why this works**

Flutter has had two different embedders,
and this flag was read to determine which embedder was used.
[Flutter 3.22][] removed the ability of v1 embedder apps to build.
This mechanism is not recommended because it's
unclear how long the `flutterEmbedding` value will
continue to be included in all Flutter apps.
Additionally, this won't work for all libraries written
in Flutter that are imported into Android apps as AAR dependencies.

[Flutter 3.22]: {{site.flutter-blog}}/whats-new-in-flutter-3-22-fbde6c164fe3

#### Non-technical evaluation

* Download [Flutter Shark][] on a device and let it scan local apps.
* Visit the [Flutter Hunt][] website.

[Flutter Hunt]: https://flutterhunt.com/
[Flutter Shark]: https://play.google.com/store/apps/details?id=com.fluttershark.fluttersharkapp&pli=1

{% comment %}
### Are there any special considerations with add-to-app?
{% endcomment %}
