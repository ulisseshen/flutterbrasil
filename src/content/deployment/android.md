---
ia-translate: true
title: Compilar e lançar um app Android
description: Como preparar e lançar um app Android na Play Store.
short-title: Android
---

Para testar um app, você pode usar `flutter run` na linha de comando,
ou as opções **Run** e **Debug** no seu IDE.

Quando você estiver pronto para preparar uma versão _release_ do seu app,
por exemplo para [publicar na Google Play Store][play],
esta página pode ajudar. Antes de publicar,
você pode querer dar alguns toques finais no seu app.
Este guia explica como realizar as seguintes tarefas:

* [Adicionar um ícone do launcher](#add-a-launcher-icon)
* [Habilitar Material Components](#enable-material-components)
* [Assinar o app](#sign-the-app)
* [Reduzir seu código com R8](#shrink-your-code-with-r8)
* [Habilitar suporte multidex](#enable-multidex-support)
* [Revisar o manifesto do app](#review-the-app-manifest)
* [Revisar a configuração de build](#review-the-gradle-build-configuration)
* [Compilar o app para release](#build-the-app-for-release)
* [Publicar na Google Play Store](#publish-to-the-google-play-store)
* [Atualizar o número de versão do app](#update-the-apps-version-number)
* [FAQ de release Android](#android-release-faq)

:::note
Ao longo desta página, `[project]` refere-se ao
diretório em que sua aplicação está. Ao seguir
estas instruções, substitua `[project]` pelo
diretório do seu app.
:::

[play]: {{site.android-dev}}/distribute

<a id="add-a-launcher-icon"></a>
## Adicionar um ícone do launcher

Quando um novo app Flutter é criado, ele tem um ícone de launcher padrão.
Para personalizar este ícone, você pode querer conferir o
pacote [flutter_launcher_icons][].

Alternativamente, você pode fazer isso manualmente usando os seguintes passos:

1. Revise as
   diretrizes [Material Design product icons][launchericons] para design de ícones.

1. No diretório `[project]/android/app/src/main/res/`,
   coloque seus arquivos de ícone em pastas nomeadas usando
   [configuration qualifiers][].
   As pastas padrão `mipmap-` demonstram a convenção de nomenclatura
   correta.

1. Em `AndroidManifest.xml`, atualize o atributo `android:icon` da
   tag [`application`][applicationtag] para referenciar ícones do passo
   anterior (por exemplo,
   `<application android:icon="@mipmap/ic_launcher" ...`).

1. Para verificar se o ícone foi substituído,
   execute seu app e inspecione o ícone do app no Launcher.

[flutter_launcher_icons]: {{site.pub}}/packages/flutter_launcher_icons
[launchericons]: {{site.material}}/styles/icons
[configuration qualifiers]: {{site.android-dev}}/guide/topics/resources/providing-resources#AlternativeResources
[applicationtag]: {{site.android-dev}}/guide/topics/manifest/application-element

<a id="enable-material-components"></a>
## Habilitar Material Components

Se seu app usa [platform views][], você pode querer habilitar
Material Components seguindo os passos descritos no
[Getting Started guide for Android][].

Por exemplo:

1. Adicione a dependência no Material do Android em `<my-app>/android/app/build.gradle`:

   ```groovy
   dependencies {
       // ...
       implementation("com.google.android.material:material:<version>")
       // ...
   }
   ```

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
<a id="sign-the-app"></a>
## Assinar o app

Para publicar na Play Store, você precisa
assinar seu app com um certificado digital.

O Android usa duas chaves de assinatura: _upload_ e _app signing_.

* Desenvolvedores fazem upload de um arquivo `.aab` ou `.apk` assinado com
  uma chave de _upload_ para a Play Store.
* Os usuários finais baixam o arquivo `.apk` assinado com uma chave de _app signing_.

Para criar sua chave de assinatura de app, use Play App Signing
conforme descrito na [documentação oficial da Play Store][official Play Store documentation].

Para assinar seu app, use as seguintes instruções.

[official Play Store documentation]: https://support.google.com/googleplay/android-developer/answer/7384423?hl=en

### Criar um upload keystore

Se você tem um keystore existente, pule para o próximo passo.
Se não, crie um usando um dos seguintes métodos:

1. Siga as [etapas de geração de chave do Android Studio][Android Studio key generation steps].
1. Execute o seguinte comando na linha de comando:

   No macOS ou Linux, use o seguinte comando:

   ```console
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA \
           -keysize 2048 -validity 10000 -alias upload
   ```

   No Windows, use o seguinte comando no PowerShell:

   ```powershell
   keytool -genkey -v -keystore $env:USERPROFILE\upload-keystore.jks `
           -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 `
           -alias upload
   ```

   Este comando armazena o arquivo `upload-keystore.jks` no seu diretório home.
   Se você quiser armazená-lo em outro lugar, altere
   o argumento que você passa para o parâmetro `-keystore`.
   **No entanto, mantenha o arquivo `keystore` privado;
   não o envie para controle de código fonte público!**

   :::note
   * O comando `keytool` pode não estar no seu path&mdash;ele faz
     parte do Java, que é instalado como parte do Android Studio.
     Para o caminho concreto, execute `flutter doctor -v` e
     localize o caminho impresso após 'Java binary at:'.
     Em seguida, use esse caminho totalmente qualificado
     substituindo `java` (no final) por `keytool`.
     Se seu caminho incluir nomes separados por espaços, como `Program Files`,
     use notação apropriada para a plataforma para os nomes.
     Por exemplo, no macOS e Linux use `Program\ Files`, e
     no Windows use `"Program Files"`.

   * A tag `-storetype JKS` é necessária apenas para Java 9
     ou mais recente. A partir do lançamento do Java 9,
     o tipo de keystore padrão é PKS12.
   :::

[Android Studio key generation steps]: {{site.android-dev}}/studio/publish/app-signing#generate-key

### Referenciar o keystore do app

Crie um arquivo chamado `[project]/android/key.properties`
que contenha uma referência ao seu keystore.
Não inclua os colchetes angulares (`< >`).
Eles indicam que o texto serve como um placeholder para seus valores.

```properties
storePassword=<password-from-previous-step>
keyPassword=<password-from-previous-step>
keyAlias=upload
storeFile=<keystore-file-location>
```

O `storeFile` pode estar localizado em
`/Users/<user name>/upload-keystore.jks` no macOS
ou `C:\\Users\\<user name>\\upload-keystore.jks` no Windows.

:::warning
Mantenha o arquivo `key.properties` privado;
não o envie para controle de código fonte público.
:::

### Configurar assinatura no Gradle

Ao compilar seu app em modo release, configure o Gradle para usar sua chave de upload.
Para configurar o Gradle, edite o arquivo `<project>/android/app/build.gradle`.

1. Defina e carregue o arquivo de propriedades do keystore antes do bloco de propriedade `android`.

1. Defina o objeto `keystoreProperties` para carregar o arquivo `key.properties`.

   ```groovy diff title="[project]/android/app/build.gradle"
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

1. Adicione a configuração de assinatura antes do bloco de propriedade `buildTypes`
   dentro do bloco de propriedade `android`.

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

O Flutter agora assina todos os builds de release.

:::note
Você pode precisar executar `flutter clean` após alterar o arquivo Gradle.
Isso evita que builds em cache afetem o processo de assinatura.
:::

Para saber mais sobre como assinar seu app, confira
[Sign your app][] na documentação do desenvolvedor Android.

[Sign your app]: {{site.android-dev}}/studio/publish/app-signing.html#generate-key

<a id="shrink-your-code-with-r8"></a>
## Reduzir seu código com R8

[R8][] é o novo code shrinker do Google.
Ele está habilitado por padrão quando você compila um APK ou AAB de release.
Para desabilitar o R8, passe a flag `--no-shrink` para
`flutter build apk` ou `flutter build appbundle`.

:::note
Ofuscação e minificação podem estender consideravelmente
o tempo de compilação de uma aplicação Android.

A flag `--[no-]shrink` não tem efeito.
A redução de código está sempre habilitada em builds de release.
Para saber mais, confira [Shrink, obfuscate, and optimize your app][].
:::

[R8]: {{site.android-dev}}/studio/build/shrink-code
[Shrink, obfuscate, and optimize your app]: {{site.android-dev}}/studio/build/shrink-code

<a id="enable-multidex-support"></a>
## Habilitar suporte multidex

Ao escrever apps grandes ou fazer uso de plugins grandes,
você pode encontrar o limite de dex do Android de 64k métodos
ao direcionar uma API mínima de 20 ou inferior.
Isso também pode ser encontrado ao executar versões debug do seu app
usando `flutter run` que não tem shrinking habilitado.

A ferramenta Flutter suporta habilitar multidex facilmente.
A maneira mais simples é optar pelo suporte multidex quando solicitado.
A ferramenta detecta erros de build multidex e
pergunta antes de fazer alterações no seu projeto Android.
Optar permite que o Flutter dependa automaticamente de
`androidx.multidex:multidex` e use um
`FlutterMultiDexApplication` gerado como aplicação do projeto.

Quando você tenta compilar e executar seu app com as opções **Run** e **Debug**
no seu IDE, seu build pode falhar com a seguinte mensagem:

<img src='/assets/images/docs/deployment/android/ide-build-failure-multidex.png' width="100%" alt='Build failure because Multidex support is required'>

Para habilitar multidex da linha de comando,
execute `flutter run --debug` e selecione um dispositivo Android:

<img src='/assets/images/docs/deployment/android/cli-select-device.png' width="100%" alt='Selecting an Android device with the flutter CLI.'>

Quando solicitado, digite `y`.
A ferramenta Flutter habilita o suporte multidex e tenta o build novamente:

<img src='/assets/images/docs/deployment/android/cli-multidex-added-build.png' width="100%" alt='The output of a successful build after adding multidex.'>

:::note
O suporte multidex está incluído nativamente ao direcionar
Android SDK 21 ou posterior.
:::

Você também pode optar por suportar multidex manualmente seguindo os guias do Android
e modificando a configuração do diretório Android do seu projeto.
Um [arquivo keep multidex][multidex-keep] deve ser especificado para incluir:

```plaintext
io/flutter/embedding/engine/loader/FlutterLoader.class
io/flutter/util/PathUtils.class
```

Além disso, inclua quaisquer outras classes usadas na inicialização do app.
Para orientação mais detalhada sobre adicionar suporte multidex manualmente,
confira a [documentação oficial do Android][multidex-docs].

[multidex-keep]: {{site.android-dev}}/studio/build/multidex#keep
[multidex-docs]: {{site.android-dev}}/studio/build/multidex

<a id="review-the-app-manifest"></a>
## Revisar o manifesto do app

Revise o arquivo padrão [App Manifest][manifest].

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
| [`uses-permission`][permissiontag] | Adicione o valor de [permissão][permissiontag] `android.permission.INTERNET` ao atributo `android:name` se seu app precisa de acesso à Internet. O modelo padrão não inclui esta tag, mas permite acesso à Internet durante o desenvolvimento para permitir comunicação entre ferramentas Flutter e um app em execução. |

{:.table .table-striped}

[manifest]: {{site.android-dev}}/guide/topics/manifest/manifest-intro
[applicationtag]: {{site.android-dev}}/guide/topics/manifest/application-element
[permissiontag]: {{site.android-dev}}/guide/topics/manifest/uses-permission-element

## Revisar ou alterar a configuração de build do Gradle {#review-the-gradle-build-configuration}

Para verificar a configuração de build do Android,
revise o bloco `android` no
[script de build Gradle][gradlebuild] padrão.
O script de build Gradle padrão está em `[project]/android/app/build.gradle`.
Você pode alterar os valores de qualquer uma dessas propriedades.

```groovy title="[project]/android/app/build.gradle"
android {
    namespace = "com.example.[project]"
    // Any value starting with "flutter." gets its value from
    // the Flutter Gradle plugin.
    // To change from these defaults, make your changes in this file.
    [!compileSdk = flutter.compileSdkVersion!]
    ndkVersion = flutter.ndkVersion

    ...

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        [!applicationId = "com.example.[project]"!]
        // You can update the following values to match your application needs.
        [!minSdk = flutter.minSdkVersion!]
        [!targetSdk = flutter.targetSdkVersion!]
        // These two properties use values defined elsewhere in this file.
        // You can set these values in the property declaration
        // or use a variable.
        [!versionCode = flutterVersionCode.toInteger()!]
        [!versionName = flutterVersionName!]
    }

    buildTypes {
        ...
    }
}
```

[gradlebuild]: {{site.android-dev}}/studio/build/#module-level

### Propriedades para ajustar em build.gradle

| Propriedade          | Propósito                                                                                                                                                                                                                                                     | Valor Padrão              |
|----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------|
| `compileSdk`         | O nível de API do Android contra o qual seu app é compilado. Deve ser a versão mais alta disponível. Se você definir esta propriedade como `31`, você executa seu app em um dispositivo rodando API `30` ou anterior desde que seu app não use APIs específicas de `31`. | |
| `defaultConfig`      |  |  |
| `.applicationId`     | O [application ID][] final e único que identifica seu app.                                                                                                              |                            |
| `.minSdk`            | O [nível mínimo de API do Android][minimum Android API level] para o qual você projetou seu app para rodar.                                                                                                                                                                                   | `flutter.minSdkVersion`    |
| `.targetSdk`         | O nível de API do Android contra o qual você testou seu app para rodar. Seu app deve rodar em todos os níveis de API do Android até este.                                                                                                                               | `flutter.targetSdkVersion` |
| `.versionCode`       | Um número inteiro positivo que define um [número de versão interno][internal version number]. Este número determina apenas qual versão é mais recente que outra. Números maiores indicam versões mais recentes. Os usuários do app nunca veem este valor.                                          |                            |
| `.versionName`       | Uma string que seu app exibe como seu número de versão. Defina esta propriedade como uma string bruta ou como uma referência a um recurso de string.                                                                                                                            |                            |
| `.buildToolsVersion` | O plugin Gradle especifica a versão padrão das ferramentas de build do Android que seu projeto usa. Para especificar uma versão diferente das ferramentas de build, altere este valor.                                                                                    |                            |

{:.table .table-striped}

Para saber mais sobre Gradle, confira a seção de build em nível de módulo
no [Gradle build file][gradlebuild].

:::note
Se você usa uma versão recente do Android SDK,
você pode receber avisos de depreciação sobre
`compileSdkVersion`, `minSdkVersion`, ou `targetSdkVersion`.
Você pode renomear essas propriedades para
`compileSdk`, `minSdk`, e `targetSdk` respectivamente.
:::

[application ID]: {{site.android-dev}}/studio/build/application-id
[minimum Android API level]: {{site.android-dev}}/studio/publish/versioning#minsdk
[internal version number]: {{site.android-dev}}/studio/publish/versioning
[gradlebuild]: {{site.android-dev}}/studio/build/#module-level

<a id="build-the-app-for-release"></a>
## Compilar o app para release

Você tem dois formatos de release possíveis ao
publicar na Play Store.

* App bundle (preferido)
* APK

:::note
A Google Play Store prefere o formato app bundle.
Para saber mais, confira [About Android App Bundles][bundle].
:::

[bundle]: {{site.android-dev}}/guide/app-bundle

### Compilar um app bundle

Esta seção descreve como compilar um app bundle de release.
Se você completou as etapas de assinatura,
o app bundle será assinado.
Neste ponto, você pode considerar [ofuscar seu código Dart][obfuscating your Dart code]
para torná-lo mais difícil de fazer engenharia reversa.
Ofuscar seu código envolve adicionar flags ao seu comando de build e
manter arquivos adicionais para desofuscar stack traces.

Da linha de comando:

1. Digite `cd [project]`<br>
1. Execute `flutter build appbundle`<br>
   (Executar `flutter build` padrão para um build de release.)

O bundle de release para seu app é criado em
`[project]/build/app/outputs/bundle/release/app.aab`.

Por padrão, o app bundle contém seu código Dart e o runtime Flutter
compilado para [armeabi-v7a][] (ARM 32-bit), [arm64-v8a][]
(ARM 64-bit), e [x86-64][] (x86 64-bit).

[obfuscating your Dart code]: /deployment/obfuscate
[arm64-v8a]: {{site.android-dev}}/ndk/guides/abis#arm64-v8a
[armeabi-v7a]: {{site.android-dev}}/ndk/guides/abis#v7a
[x86-64]: {{site.android-dev}}/ndk/guides/abis#86-64

### Testar o app bundle

Um app bundle pode ser testado de várias maneiras.
Esta seção descreve duas.

#### Offline usando a ferramenta bundle

1. Se você ainda não o fez, baixe `bundletool` do
   seu [repositório GitHub][bundletool-github].
1. [Gere um conjunto de APKs][apk-set] do seu app bundle.
1. [Implante os APKs][apk-deploy] em dispositivos conectados.

[bundletool-github]: {{site.github}}/google/bundletool/releases/latest
[apk-set]: {{site.android-dev}}/studio/command-line/bundletool#generate_apks
[apk-deploy]: {{site.android-dev}}/studio/command-line/bundletool#deploy_with_bundletool

#### Online usando Google Play

1. Faça upload do seu bundle para Google Play para testá-lo.
   Você pode usar o track de teste interno,
   ou os canais alfa ou beta para testar o bundle antes
   de lançá-lo em produção.
2. Siga as etapas para [fazer upload do seu bundle][upload-bundle]
   para a Play Store.

[upload-bundle]: {{site.android-dev}}/studio/publish/upload-bundle

<a id="build-an-apk"></a>
### Compilar um APK

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
   (O comando `flutter build` padrão é `--release`.)

Este comando resulta em três arquivos APK:

* `[project]/build/app/outputs/apk/release/app-armeabi-v7a-release.apk`
* `[project]/build/app/outputs/apk/release/app-arm64-v8a-release.apk`
* `[project]/build/app/outputs/apk/release/app-x86_64-release.apk`

Remover a flag `--split-per-abi` resulta em um APK gordo que contém
seu código compilado para _todos_ os ABIs alvo.
Tais APKs são maiores em tamanho do que suas contrapartes divididas,
fazendo com que o usuário baixe binários nativos que
não são aplicáveis à arquitetura do dispositivo deles.

[obfuscating your Dart code]: /deployment/obfuscate

### Instalar um APK em um dispositivo

Siga estas etapas para instalar o APK em um dispositivo Android conectado.

Da linha de comando:

1. Conecte seu dispositivo Android ao seu computador com um cabo USB.
1. Digite `cd [project]`.
1. Execute `flutter install`.

<a id="publish-to-the-google-play-store"></a>
## Publicar na Google Play Store

Para instruções detalhadas sobre como publicar seu app na Google Play Store,
confira a documentação de [lançamento do Google Play][play].

<a id="update-the-apps-version-number"></a>
## Atualizar o número de versão do app

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
`build-number` é usado como `versionCode`. Para mais informações,
confira [Version your app][] na documentação do Android.

Quando você reconstrói o app para Android, quaisquer atualizações no
número de versão do arquivo pubspec irão
atualizar `versionName` e `versionCode` no arquivo `local.properties`.

[Version your app]: {{site.android-dev}}/studio/publish/versioning

<a id="android-release-faq"></a>
## FAQ de release Android

Aqui estão algumas perguntas comuns sobre implantação para
apps Android.

### Quando devo compilar app bundles versus APKs?

A Google Play Store recomenda que você implante app bundles
em vez de APKs porque permitem uma entrega mais eficiente da
aplicação para seus usuários. No entanto, se você estiver distribuindo
sua aplicação por meios diferentes da Play Store,
um APK pode ser sua única opção.

### O que é um fat APK?

Um [fat APK][] é um único APK que contém binários para múltiplos
ABIs incorporados nele. Isso tem o benefício de que o único APK
funciona em múltiplas arquiteturas e, portanto, tem maior compatibilidade,
mas tem a desvantagem de que seu tamanho de arquivo é muito maior,
fazendo com que usuários baixem e armazenem mais bytes ao instalar
sua aplicação. Ao compilar APKs em vez de app bundles,
é fortemente recomendado compilar APKs divididos,
conforme descrito em [compilar um APK](#build-an-apk) usando a
flag `--split-per-abi`.

[fat APK]: https://en.wikipedia.org/wiki/Fat_binary

### Quais são as arquiteturas alvo suportadas?

Ao compilar sua aplicação em modo release,
apps Flutter podem ser compilados para [armeabi-v7a][] (ARM 32-bit),
[arm64-v8a][] (ARM 64-bit), e [x86-64][] (x86 64-bit).

### Como faço para assinar o app bundle criado por `flutter build appbundle`?

Confira [Assinar o app](#sign-the-app).

### Como faço para compilar um release de dentro do Android Studio?

No Android Studio, abra a pasta `android/`
existente sob a pasta do seu app. Em seguida,
selecione **build.gradle (Module: app)** no painel de projeto:

<img src='/assets/images/docs/deployment/android/gradle-script-menu.png' alt='The Gradle build script menu in Android Studio.' style="max-height: 20rem">

Em seguida, selecione a variante de build. Clique em **Build > Select Build Variant**
no menu principal. Selecione qualquer uma das variantes no painel **Build Variants**
(debug é o padrão):

<img src='/assets/images/docs/deployment/android/build-variant-menu.png' alt='The build variant menu in Android Studio with Release selected.' style="max-height: 20rem">

Os arquivos de app bundle ou APK resultantes estão localizados em
`build/app/outputs` dentro da pasta do seu app.

{% comment %}
### Are there any special considerations with add-to-app?
{% endcomment %}
