---
ia-translate: true
title: Construir e lançar um aplicativo Android
description: Como se preparar e lançar um aplicativo Android na Play Store.
short-title: Android
---

Para testar um aplicativo, você pode usar `flutter run` na linha de comando,
ou as opções **Run** e **Debug** na sua IDE.

Quando você estiver pronto para preparar uma versão de _release_ do seu aplicativo,
por exemplo para [publicar na Google Play Store][play],
esta página pode ajudar. Antes de publicar,
você pode querer dar alguns toques finais no seu aplicativo.
Este guia explica como executar as seguintes tarefas:

* [Adicionar um ícone de inicialização](#add-a-launcher-icon)
* [Habilitar Componentes Material](#enable-material-components)
* [Assinar o aplicativo](#signing-the-app)
* [Reduzir seu código com R8](#shrink-your-code-with-r8)
* [Habilitar suporte multidex](#enable-multidex-support)
* [Revisar o manifesto do aplicativo](#review-the-app-manifest)
* [Revisar a configuração de build](#review-the-gradle-build-configuration)
* [Construir o aplicativo para release](#build-the-app-for-release)
* [Publicar na Google Play Store](#publish-to-the-google-play-store)
* [Atualizar o número da versão do aplicativo](#update-the-apps-version-number)
* [FAQ sobre release Android](#android-release-faq)

:::note
Nesta página, `[projeto]` se refere ao
diretório onde seu aplicativo está. Ao seguir
estas instruções, substitua `[projeto]` pelo
diretório do seu aplicativo.
:::

## Adicionar um ícone de inicialização

Quando um novo aplicativo Flutter é criado, ele possui um ícone de inicialização padrão.
Para personalizar este ícone, você pode querer verificar o
pacote [flutter_launcher_icons][].

Alternativamente, você pode fazer isso manualmente usando os seguintes passos:

1. Revise as diretrizes de [ícones de produto Material Design][launchericons] para design de ícones.

2. No diretório `[projeto]/android/app/src/main/res/`,
   coloque seus arquivos de ícone em pastas nomeadas usando
   [qualificadores de configuração][].
   As pastas `mipmap-` padrão demonstram a convenção de
   nomeação correta.

3. Em `AndroidManifest.xml`, atualize o
   atributo `android:icon` da tag [`application`][applicationtag]
   para referenciar os ícones da etapa anterior
   (por exemplo,
   `<application android:icon="@mipmap/ic_launcher" ...`).

4. Para verificar se o ícone foi substituído,
   execute seu aplicativo e inspecione o ícone do aplicativo no Launcher.

## Habilitar Componentes Material

Se o seu aplicativo usar [Platform Views][], você pode querer habilitar
Componentes Material seguindo os passos descritos no
[Guia de Introdução para Android][].

Por exemplo:

1. Adicione a dependência no Material do Android em `<meu-app>/android/app/build.gradle`:

```kotlin
dependencies {
    // ...
    implementation("com.google.android.material:material:<versão>")
    // ...
}
```

Para descobrir a versão mais recente, visite [Google Maven][].

2. Defina o tema claro em `<meu-app>/android/app/src/main/res/values/styles.xml`:

```xml diff
- <style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar">
+ <style name="NormalTheme" parent="Theme.MaterialComponents.Light.NoActionBar">
```

3. Defina o tema escuro em `<meu-app>/android/app/src/main/res/values-night/styles.xml`

```xml diff
- <style name="NormalTheme" parent="@android:style/Theme.Black.NoTitleBar">
+ <style name="NormalTheme" parent="Theme.MaterialComponents.DayNight.NoActionBar">
```

<a id="signing-the-app"></a>
## Assinar o aplicativo

Para publicar na Play Store, você precisa
assinar seu aplicativo com um certificado digital.

O Android usa duas chaves de assinatura: _upload_ e _assinatura do aplicativo_.

* Desenvolvedores enviam um arquivo `.aab` ou `.apk` assinado com
  uma _chave de upload_ para a Play Store.
* Os usuários finais baixam o arquivo `.apk` assinado com uma _chave de assinatura do aplicativo_.

Para criar sua chave de assinatura do aplicativo, use a Assinatura de Aplicativo do Play
conforme descrito na [documentação oficial da Play Store][].

Para assinar seu aplicativo, use as seguintes instruções.

### Criar um keystore de upload

Se você já tem um keystore, pule para a próxima etapa.
Caso contrário, crie um usando um dos seguintes métodos:

1. Siga os [passos de geração de chave do Android Studio]({{site.android-dev}}/studio/publish/app-signing#generate-key)
2. Execute o seguinte comando na linha de comando:

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

   Este comando armazena o arquivo `upload-keystore.jks` no seu diretório home. Se você quiser armazená-lo em outro lugar, altere
   o argumento que você passa para o parâmetro `-keystore`.
   **No entanto, mantenha o arquivo `keystore` privado;
   não o coloque em um controle de versão público!**

   :::note
   * O comando `keytool` pode não estar no seu path&mdash;ele faz
     parte do Java, que é instalado como parte do
     Android Studio. Para o caminho concreto,
     execute `flutter doctor -v` e localize o caminho impresso após
     'Java binary at:'. Em seguida, use esse caminho completo
     substituindo `java` (no final) por `keytool`.
     Se o seu caminho incluir nomes separados por espaços,
     como `Arquivos de Programas`, use a notação apropriada
     para a plataforma. Por exemplo, no Mac/Linux,
     use `Program\ Files`, e no Windows, use
     `"Program Files"`.

   * A tag `-storetype JKS` é necessária apenas para Java 9
     ou mais recente. A partir do lançamento do Java 9,
     o tipo de keystore padrão é PKS12.
   :::

### Referenciar o keystore do aplicativo

Crie um arquivo chamado `[projeto]/android/key.properties`
que contenha uma referência ao seu keystore.
Não inclua os colchetes angulares (`< >`).
Eles indicam que o texto serve como um espaço reservado para seus valores.

```properties
storePassword=<senha-da-etapa-anterior>
keyPassword=<senha-da-etapa-anterior>
keyAlias=upload
storeFile=<local-do-arquivo-keystore>
```

O `storeFile` pode estar localizado em
`/Users/<nome-do-usuario>/upload-keystore.jks` no macOS
ou `C:\\Users\\<nome-do-usuario>\\upload-keystore.jks` no Windows.

:::warning
Mantenha o arquivo `key.properties` privado;
não o coloque em um controle de versão público.
:::

### Configurar a assinatura no gradle

Ao construir seu aplicativo no modo release, configure o gradle para usar sua chave de upload.
Para configurar o gradle, edite o arquivo `<projeto>/android/app/build.gradle`.

1. Defina e carregue o arquivo de propriedades do keystore antes do bloco de propriedades `android`.

2. Defina o objeto `keystoreProperties` para carregar o arquivo `key.properties`.

   ```kotlin diff title="[projeto]/android/app/build.gradle"
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

3. Adicione a configuração de assinatura antes do bloco de propriedades `buildTypes`
   dentro do bloco de propriedades `android`.

   ```kotlin diff title="[projeto]/android/app/build.gradle"
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
                 // TODO: Adicione sua própria configuração de assinatura para o build de release.
                 // Assinando com as chaves de debug por enquanto,
                 // para que `flutter run --release` funcione.
   -             signingConfig = signingConfigs.debug
   +             signingConfig = signingConfigs.release
             }
         }
     ...
     }
   ```

O Flutter agora assina todos os builds de release.

:::note
Você pode precisar executar `flutter clean` após alterar o arquivo gradle.
Isso evita que builds em cache afetem o processo de assinatura.
:::

Para saber mais sobre como assinar seu aplicativo, confira
[Assine seu aplicativo][] em developer.android.com.

## Reduzir seu código com R8

[R8][] é o novo redutor de código do Google.
Ele é habilitado por padrão quando você cria um APK ou AAB de release.
Para desabilitar o R8, passe a flag `--no-shrink` para
`flutter build apk` ou `flutter build appbundle`.

:::note
Ofuscação e minificação podem estender consideravelmente o tempo de compilação
do aplicativo Android.

A flag `--[no-]shrink` não tem efeito. A redução de código está sempre habilitada em builds de release.
Para saber mais, confira
[Reduza, ofusque e otimize seu aplicativo]({{site.android-dev}}/studio/build/shrink-code).
:::

## Habilitar suporte multidex

Ao escrever aplicativos grandes ou usar plugins grandes,
você pode encontrar o limite dex do Android de 64 mil métodos
ao segmentar uma API mínima de 20 ou abaixo.
Isso também pode ser encontrado ao executar versões de debug do seu aplicativo
usando `flutter run` que não têm a redução habilitada.

A ferramenta Flutter suporta facilmente a habilitação de multidex. A maneira mais simples é
optar pelo suporte multidex quando solicitado. A ferramenta detecta erros de build multidex
e pergunta antes de fazer alterações em seu projeto Android.
Optar permite que o Flutter dependa automaticamente de
`androidx.multidex:multidex` e use um
`FlutterMultiDexApplication` gerado como o aplicativo do projeto.

Quando você tenta construir e executar seu aplicativo com as opções **Run** e **Debug**
na sua IDE, seu build pode falhar com a seguinte mensagem:

<img src='/assets/images/docs/deployment/android/ide-build-failure-multidex.png' width="100%" alt='Falha no build porque o suporte Multidex é necessário'>

Para habilitar o multidex na linha de comando,
execute `flutter run --debug` e selecione um dispositivo Android:

<img src='/assets/images/docs/deployment/android/cli-select-device.png' width="100%" alt='Selecionando um dispositivo Android com o CLI do flutter.'>

Quando solicitado, insira `y`.
A ferramenta Flutter habilita o suporte multidex e tenta novamente o build:

<img src='/assets/images/docs/deployment/android/cli-multidex-added-build.png' width="100%" alt='A saída de um build bem-sucedido após adicionar multidex.'>

:::note
O suporte multidex é incluído nativamente ao segmentar
Android SDK 21 ou mais recente. No entanto, não recomendamos
segmentar API 21+ apenas para resolver o problema do multidex,
pois isso pode excluir inadvertidamente usuários que executam dispositivos mais antigos.
:::

Você também pode optar por suportar manualmente o multidex seguindo os guias do Android
e modificando a configuração do diretório Android do seu projeto.
Um [arquivo de keep multidex][multidex-keep] deve ser especificado para incluir:

```plaintext
io/flutter/embedding/engine/loader/FlutterLoader.class
io/flutter/util/PathUtils.class
```

Além disso, inclua quaisquer outras classes usadas na inicialização do aplicativo.
Para obter orientações mais detalhadas sobre como adicionar suporte multidex manualmente,
confira a [documentação oficial do Android][multidex-docs].

## Revisar o manifesto do aplicativo

Revise o arquivo [Manifesto do Aplicativo][manifest] padrão.

```xml title="[projeto]/android/app/src/main/AndroidManifest.xml"
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        [!android:label="[projeto]"!]
        ...
    </application>
    ...
    [!<uses-permission android:name="android.permission.INTERNET"/>!]
</manifest>
```

Verifique os seguintes valores:

| Tag                                | Atributo | Valor                                                                                                                                                                                                                          |
|------------------------------------|-----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [`application`][applicationtag]    | Edite o `android:label` na tag [`application`][applicationtag] para refletir o nome final do aplicativo. |
| [`uses-permission`][permissiontag] | Adicione o valor de [permissão][permissiontag] `android.permission.INTERNET` ao atributo `android:name` se seu aplicativo precisar de acesso à Internet. O modelo padrão não inclui esta tag, mas permite acesso à Internet durante o desenvolvimento para habilitar a comunicação entre as ferramentas Flutter e um aplicativo em execução. |

{:.table .table-striped}

## Revisar ou alterar a configuração de build do Gradle {:#review-the-gradle-build-configuration}

Para verificar a configuração de build do Android,
revise o bloco `android` no
[script de build Gradle][gradlebuild] padrão.
O script de build Gradle padrão é encontrado em `[projeto]/android/app/build.gradle`.
Você pode alterar os valores de qualquer uma dessas propriedades.

```kotlin title="[projeto]/android/app/build.gradle"
android {
    namespace = "com.example.[projeto]"
    // Qualquer valor que comece com "flutter." obtém seu valor de
    // o plugin Flutter Gradle.
    // Para alterar esses padrões, faça suas alterações neste arquivo.
    [!compileSdk = flutter.compileSdkVersion!]
    ndkVersion = flutter.ndkVersion

    ...

    defaultConfig {
        // TODO: Especifique seu próprio ID de Aplicativo exclusivo (https://developer.android.com/studio/build/application-id.html).
        [!applicationId = "com.example.[projeto]"!]
        // Você pode atualizar os seguintes valores para corresponder às necessidades do seu aplicativo.
        [!minSdk = flutter.minSdkVersion!]
        [!targetSdk = flutter.targetSdkVersion!]
        // Essas duas propriedades usam valores definidos em outros lugares neste arquivo.
        // Você pode definir esses valores na declaração de propriedade
        // ou use uma variável.
        [!versionCode = flutterVersionCode.toInteger()!]
        [!versionName = flutterVersionName!]
    }

    buildTypes {
        ...
    }
}
```

### Propriedades para ajustar em build.gradle

| Propriedade             | Objetivo                                                                                                                                                                                                                                                                 | Valor Padrão              |
|----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------|
| `compileSdk`         | O nível da API do Android em relação ao qual seu aplicativo é compilado. Esta deve ser a versão mais alta disponível. Se você definir esta propriedade como `31`, você executa seu aplicativo em um dispositivo que executa API `30` ou anterior, contanto que seu aplicativo não use APIs específicas para `31`. | |
| `defaultConfig`      | | |
| `.applicationId`     | O [ID do aplicativo][] final e exclusivo que identifica seu aplicativo.                                                                                                                                                                                              |                            |
| `.minSdk`            | O [nível mínimo da API do Android][] para o qual você projetou seu aplicativo para ser executado.                                                                                                                                                                         | `flutter.minSdkVersion`    |
| `.targetSdk`         | O nível da API do Android em relação ao qual você testou seu aplicativo para ser executado. Seu aplicativo deve ser executado em todos os níveis da API do Android até este.                                                                                                 | `flutter.targetSdkVersion` |
| `.versionCode`       | Um número inteiro positivo que define um [número de versão interno][]. Este número apenas determina qual versão é mais recente do que outra. Números maiores indicam versões mais recentes. Os usuários do aplicativo nunca veem este valor.                                          |                            |
| `.versionName`       | Uma string que seu aplicativo exibe como seu número de versão. Defina esta propriedade como uma string bruta ou como uma referência a um recurso de string.                                                                                                                   |                            |
| `.buildToolsVersion` | O plugin Gradle especifica a versão padrão das ferramentas de build do Android que seu projeto usa. Para especificar uma versão diferente das ferramentas de build, altere este valor.                                                                                    |                            |

{:.table .table-striped}

Para saber mais sobre Gradle, confira a seção de build de nível de módulo no [arquivo de build do Gradle][gradlebuild].

:::note
Se você usar uma versão recente do SDK do Android, poderá receber avisos de depreciação sobre `compileSdkVersion`, `minSdkVersion` ou `targetSdkVersion`.
Você pode renomear essas propriedades para `compileSdk`, `minSdk` e `targetSdk`, respectivamente.
:::
  
## Construir o aplicativo para release

Você tem dois formatos de release possíveis ao publicar no
Play Store.

* App bundle (preferencial)
* APK

:::note
A Google Play Store prefere o formato app bundle.
Para saber mais, confira [Sobre Android App Bundles][bundle].
:::

### Construir um app bundle

Esta seção descreve como construir um app bundle de release.
Se você concluiu os passos de assinatura,
o app bundle será assinado.
Neste ponto, você pode considerar [ofuscar seu código Dart][]
para torná-lo mais difícil de fazer engenharia reversa. Ofuscar
seu código envolve adicionar algumas flags ao seu comando de build,
e manter arquivos adicionais para de-ofuscar stack traces.

Na linha de comando:

1. Insira `cd [projeto]`<br>
2. Execute `flutter build appbundle`<br>
   (Executar `flutter build` tem como padrão um build de release.)

O bundle de release para seu aplicativo é criado em
`[projeto]/build/app/outputs/bundle/release/app.aab`.

Por padrão, o app bundle contém seu código Dart e o Flutter
runtime compilado para [armeabi-v7a][] (ARM 32-bit), [arm64-v8a][]
(ARM 64-bit) e [x86-64][] (x86 64-bit).

### Testar o app bundle

Um app bundle pode ser testado de várias maneiras.
Esta seção descreve duas.

#### Offline usando a ferramenta bundle

1. Se você ainda não fez isso, baixe `bundletool` do
   [repositório GitHub][].
2. [Gere um conjunto de APKs][apk-set] a partir do seu app bundle.
3. [Implante os APKs][apk-deploy] em dispositivos conectados.

#### Online usando o Google Play

1. Envie seu bundle para o Google Play para testá-lo.
   Você pode usar o track de teste interno,
   ou os canais alfa ou beta para testar o bundle antes
   de lançá-lo em produção.
2. Siga [estes passos para enviar seu bundle][upload-bundle]
   para a Play Store.

### Construir um APK

Embora os app bundles sejam preferidos em relação aos APKs, existem lojas
que ainda não suportam app bundles. Nesse caso, construa um release
APK para cada ABI de destino (Application Binary Interface).

Se você concluiu os passos de assinatura, o APK será assinado.
Neste ponto, você pode considerar [ofuscar seu código Dart][]
para torná-lo mais difícil de fazer engenharia reversa. Ofuscar
seu código envolve adicionar algumas flags ao seu comando de build.

Na linha de comando:

1. Insira `cd [projeto]`.

2. Execute `flutter build apk --split-per-abi`.
   (O comando `flutter build` tem como padrão `--release`.)

Este comando resulta em três arquivos APK:

* `[projeto]/build/app/outputs/apk/release/app-armeabi-v7a-release.apk`
* `[projeto]/build/app/outputs/apk/release/app-arm64-v8a-release.apk`
* `[projeto]/build/app/outputs/apk/release/app-x86_64-release.apk`

Remover a flag `--split-per-abi` resulta em um APK fat que contém
seu código compilado para _todas_ as ABIs de destino. Esses APKs são maiores
em tamanho do que suas contrapartes divididas, fazendo com que o usuário baixe
binários nativos que não são aplicáveis à arquitetura do seu dispositivo.

### Instalar um APK em um dispositivo

Siga estes passos para instalar o APK em um dispositivo Android conectado.

Na linha de comando:

1. Conecte seu dispositivo Android ao seu computador com um cabo USB.
2. Insira `cd [projeto]`.
3. Execute `flutter install`.

## Publicar na Google Play Store

Para obter instruções detalhadas sobre como publicar seu aplicativo na Google Play Store,
confira a documentação de [lançamento no Google Play][play].

## Atualizar o número da versão do aplicativo

O número da versão padrão do aplicativo é `1.0.0`.
Para atualizá-lo, navegue até o arquivo `pubspec.yaml`
e atualize a seguinte linha:

`version: 1.0.0+1`

O número da versão são três números separados por pontos,
como `1.0.0` no exemplo acima, seguido por um número de build opcional,
como `1` no exemplo acima, separado por um `+`.

Tanto a versão quanto o número de build podem ser substituídos no build do Flutter
especificando `--build-name` e `--build-number`, respectivamente.

No Android, `build-name` é usado como `versionName`, enquanto
`build-number` usado como `versionCode`. Para obter mais informações,
confira [Versionar seu aplicativo][] na documentação do Android.

Quando você recompila o aplicativo para Android, quaisquer atualizações no número da versão
do arquivo pubspec atualizará o `versionName` e `versionCode`
no arquivo `local.properties`.

## FAQ sobre release Android

Aqui estão algumas perguntas frequentes sobre a implantação para
aplicativos Android.

### Quando devo construir app bundles em vez de APKs?

A Google Play Store recomenda que você implante app bundles
em vez de APKs, porque eles permitem uma entrega mais eficiente do
aplicativo para seus usuários. No entanto, se você estiver distribuindo
seu aplicativo por meios que não sejam a Play Store,
um APK pode ser sua única opção.

### O que é um APK fat?

Um [APK fat][] é um único APK que contém binários para múltiplas
ABIs incorporadas nele. Isso tem o benefício de que o único APK
é executado em várias arquiteturas e, portanto, tem compatibilidade mais ampla,
mas tem a desvantagem de que seu tamanho de arquivo é muito maior,
fazendo com que os usuários baixem e armazenem mais bytes ao instalar
seu aplicativo. Ao construir APKs em vez de app bundles,
é altamente recomendável construir APKs divididos,
conforme descrito em [construir um APK](#build-an-apk) usando o
flag `--split-per-abi`.

### Quais são as arquiteturas de destino suportadas?

Ao construir seu aplicativo no modo release,
aplicativos Flutter podem ser compilados para [armeabi-v7a][] (ARM 32-bit),
[arm64-v8a][] (ARM 64-bit) e [x86-64][] (x86 64-bit).

### Como assino o app bundle criado por `flutter build appbundle`?

Consulte [Assinar o aplicativo](#signing-the-app).

### Como faço um build de release de dentro do Android Studio?

No Android Studio, abra a pasta `android/` existente
na pasta do seu aplicativo. Em seguida,
selecione **build.gradle (Module: app)** no painel do projeto:

<img src='/assets/images/docs/deployment/android/gradle-script-menu.png' width="100%" alt='O menu de script de build do Gradle no Android Studio.'>

Em seguida, selecione a variante de build. Clique em **Build > Selecionar Variante de Build**
no menu principal. Selecione qualquer uma das variantes no painel **Variantes de Build**
(debug é o padrão):

<img src='/assets/images/docs/deployment/android/build-variant-menu.png' width="100%" alt='O menu de variante de build no Android Studio com Release selecionado.'>

O app bundle resultante ou os arquivos APK estão localizados em
`build/app/outputs` na pasta do seu aplicativo.

{% comment %}
### Há alguma consideração especial com add-to-app?
{% endcomment %}

[apk-deploy]: {{site.android-dev}}/studio/command-line/bundletool#deploy_with_bundletool
[apk-set]: {{site.android-dev}}/studio/command-line/bundletool#generate_apks
[ID do aplicativo]: {{site.android-dev}}/studio/build/application-id
[applicationtag]: {{site.android-dev}}/guide/topics/manifest/application-element
[arm64-v8a]: {{site.android-dev}}/ndk/guides/abis#arm64-v8a
[armeabi-v7a]: {{site.android-dev}}/ndk/guides/abis#v7a
[bundle]: {{site.android-dev}}/guide/app-bundle
[qualificadores de configuração]: {{site.android-dev}}/guide/topics/resources/providing-resources#AlternativeResources
[APK fat]: https://en.wikipedia.org/wiki/Fat_binary
[flutter_launcher_icons]: {{site.pub}}/packages/flutter_launcher_icons
[Guia de Introdução para Android]: {{site.material}}/develop/android/mdc-android
[repositório GitHub]: {{site.github}}/google/bundletool/releases/latest
[Google Maven]: https://maven.google.com/web/index.html#com.google.android.material:material
[gradlebuild]: {{site.android-dev}}/studio/build/#module-level
[internal version number]: {{site.android-dev}}/studio/publish/versioning
[launchericons]: {{site.material}}/styles/icons
[manifest]: {{site.android-dev}}/guide/topics/manifest/manifest-intro
[nível mínimo da API do Android]: {{site.android-dev}}/studio/publish/versioning#minsdk
[multidex-docs]: {{site.android-dev}}/studio/build/multidex
[multidex-keep]: {{site.android-dev}}/studio/build/multidex#keep
[ofuscar seu código Dart]: /deployment/obfuscate
[documentação oficial da Play Store]: https://support.google.com/googleplay/android-developer/answer/7384423?hl=en
[permissiontag]: {{site.android-dev}}/guide/topics/manifest/uses-permission-element
[Platform Views]: /platform-integration/android/platform-views
[play]: {{site.android-dev}}/distribute
[R8]: {{site.android-dev}}/studio/build/shrink-code
[Assine seu aplicativo]: {{site.android-dev}}/studio/publish/app-signing.html#generate-key
[upload-bundle]: {{site.android-dev}}/studio/publish/upload-bundle
[Versionar seu aplicativo]: {{site.android-dev}}/studio/publish/versioning
[x86-64]: {{site.android-dev}}/ndk/guides/abis#86-64
