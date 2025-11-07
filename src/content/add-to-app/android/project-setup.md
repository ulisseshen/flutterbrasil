---
ia-translate: true
title: Integre um módulo Flutter ao seu projeto Android
short-title: Integre Flutter
description: Aprenda como integrar um módulo Flutter ao seu projeto Android existente.
---

O Flutter pode ser incorporado ao seu aplicativo
Android existente de forma incremental, como um subprojeto
Gradle de código-fonte ou como AARs.

O fluxo de integração pode ser feito usando a
IDE Android Studio com o [plugin Flutter][Flutter plugin] ou manualmente.

:::warning
Seu app Android existente pode suportar arquiteturas
como `mips` ou `x86`. O Flutter atualmente [suporta apenas][only supports]
a construção de bibliotecas compiladas ahead-of-time (AOT)
para `x86_64`, `armeabi-v7a` e `arm64-v8a`.

Considere usar a API [`abiFilters`][] do Android Gradle
Plugin para limitar as arquiteturas suportadas em seu APK.
Fazer isso evita um crash de runtime de `libflutter.so` ausente,
por exemplo:

{% tabs "android-build-language" %}
{% tab "Kotlin" %}

```kotlin title="MyApp/app/build.gradle.kts"
android {
    //...
    defaultConfig {
        ndk {
            // Filter for architectures supported by Flutter
            abiFilters += listOf("armeabi-v7a", "arm64-v8a", "x86_64")
        }
    }
}
```

{% endtab %}
{% tab "Groovy" %}

```groovy title="MyApp/app/build.gradle"
android {
    // ...
    defaultConfig {
        ndk {
            // Filter for architectures supported by Flutter
            abiFilters "armeabi-v7a", "arm64-v8a", "x86_64"
        }
    }
}
```

{% endtab %}
{% endtabs %}

O engine Flutter também tem uma versão `x86_64`.
Ao usar um emulador em modo debug Just-In-Time (JIT),
o módulo Flutter ainda é executado corretamente.
:::

## Integre seu módulo Flutter

{% tabs %}
{% tab "With Android Studio" %}

### Integre com Android Studio {:.no_toc}

A IDE Android Studio pode ajudar a integrar seu módulo Flutter.
Usando o Android Studio, você pode editar tanto seu código Android quanto Flutter
na mesma IDE.

Você também pode usar funcionalidades do plugin Flutter do IntelliJ como
autocompletar código Dart, hot reload e widget inspector.

Para construir seu app, o plugin do Android Studio configura seu
projeto Android para adicionar seu módulo Flutter como uma dependência.

1. Abra seu projeto Android no Android Studio.

1. Vá para **File** > **New** > **New Project...**.
    O diálogo **New Project** é exibido.

1. Clique em **Flutter**.

1. Se solicitado a fornecer seu **Flutter SDK path**, faça isso e clique em **Next**.

1. Complete a configuração do seu módulo Flutter.

    * Se você tem um projeto existente:

        {: type="a"}
        1. Para escolher um projeto existente, clique em **...**
           à direita da caixa **Project location**.
        1. Navegue até o diretório do seu projeto Flutter.
        1. Clique em **Open**.

    * Se você precisa criar um novo projeto Flutter:

        {: type="a"}
        1. Complete o diálogo de configuração.
        1. No menu **Project type**, selecione **Module**.

1. Clique em **Finish**.

:::tip
Por padrão, o painel Project do seu projeto pode mostrar a visualização 'Android'.
Se você não consegue ver seus novos arquivos Flutter no painel Project,
configure seu painel Project para exibir **Project Files**.
Isso mostra todos os arquivos sem filtragem.
:::

{% endtab %}
{% tab "Without Android Studio" %}

### Integre sem Android Studio {:.no_toc}

Para integrar um módulo Flutter com um app Android existente
manualmente, sem usar o plugin Android Studio do Flutter,
siga estes passos:

#### Crie um módulo Flutter

Vamos assumir que você tem um app Android existente em
`some/path/MyApp`, e que você quer seu projeto
Flutter como um irmão:

```console
cd some/path/
flutter create -t module --org com.example flutter_module
```

Isso cria um projeto de módulo Flutter `some/path/flutter_module/`
com algum código Dart para você começar e uma subpasta
oculta `.android/`. A pasta `.android` contém um
projeto Android que pode tanto ajudá-lo a executar uma versão
standalone básica do seu módulo Flutter via `flutter run`
quanto também é um wrapper que ajuda a fazer o bootstrap do módulo
Flutter em uma biblioteca Android incorporável.

:::note
Adicione código Android personalizado ao projeto de sua própria
aplicação existente ou a um plugin,
não ao módulo em `.android/`.
Mudanças feitas no diretório `.android/` do seu módulo
não aparecerão em seu projeto Android existente
usando o módulo.

Não coloque o diretório `.android/` no controle de versão,
pois ele é gerado automaticamente. Antes de construir o
módulo em uma nova máquina, execute `flutter pub get`
no diretório `flutter_module` primeiro para regenerar
o diretório `.android/` antes de construir o
projeto Android usando o módulo Flutter.
:::

:::note
Para evitar problemas de mesclagem Dex, `flutter.androidPackage` não deve
ser idêntico ao nome do pacote do seu app hospedeiro.
:::

#### Requisito de versão Java

O Flutter requer que seu projeto declare compatibilidade com Java 11 ou posterior.

Antes de tentar conectar seu projeto de módulo Flutter
ao seu app Android hospedeiro, certifique-se de que seu app
Android hospedeiro declara a seguinte compatibilidade de fonte dentro do
arquivo `build.gradle` do seu app, sob o bloco `android { }`.

```groovy title="MyApp/app/build.gradle"
android {
    // ...
    compileOptions {
        sourceCompatibility = 11 // The minimum value
        targetCompatibility = 11 // The minimum value
    }
}
```

#### Centralize configurações de repositório

A partir do Gradle 7, o Android recomenda usar declarações de repositório
centralizadas em `settings.gradle` em vez de declarações de nível de projeto
ou módulo em arquivos `build.gradle`.

Antes de tentar conectar seu projeto de módulo Flutter ao seu
app Android hospedeiro, faça as seguintes mudanças.

1. Remova o bloco `repositories` em todos os arquivos `build.gradle` do seu app.

   ```groovy
   // Remove the following block, starting on the next line
       repositories {
           google()
           mavenCentral()
       }
   // ...to the previous line
   ```

1. Adicione o `dependencyResolutionManagement` exibido neste passo ao
   arquivo `settings.gradle`.

   ```groovy
   dependencyResolutionManagement {
      repositoriesMode = RepositoriesMode.PREFER_SETTINGS
      repositories {
          google()
          mavenCentral()
      }
   }
   ```

{% endtab %}
{% endtabs %}

## Adicione o módulo Flutter como uma dependência

Adicione o módulo Flutter como uma dependência do seu
app existente no Gradle. Você pode fazer isso de duas maneiras.

1. **Android archive**
    O mecanismo AAR cria AARs Android genéricos como
    intermediários que empacotam seu módulo Flutter.
    Isso é bom quando seus construtores de app downstream não
    querem ter o Flutter SDK instalado. Mas,
    adiciona mais um passo de build se você constrói frequentemente.

1. **Código-fonte do módulo**
    O mecanismo de subprojeto de código-fonte é um
    processo de build de um clique conveniente, mas requer o Flutter SDK.
    Este é o mecanismo usado pelo plugin IDE do Android Studio.

{% tabs %}
{% tab "Android Archive" %}

### Dependa do Android Archive (AAR) {:.no_toc}

Esta opção empacota sua biblioteca Flutter como um repositório
Maven local genérico composto de artefatos AARs e POMs.
Esta opção permite que sua equipe construa o app hospedeiro sem
instalar o Flutter SDK. Você pode então distribuir os
artefatos de um repositório local ou remoto.

Vamos assumir que você construiu um módulo Flutter em
`some/path/flutter_module`, e então execute:

```console
cd some/path/flutter_module
flutter build aar
```

Em seguida, siga as instruções na tela para integrar.

{% render docs/app-figure.md, image:"development/add-to-app/android/project-setup/build-aar-instructions.png" %}

Mais especificamente, este comando cria
(por padrão todos os modos debug/profile/release)
um [repositório local][local repository], com os seguintes arquivos:

```plaintext
build/host/outputs/repo
└── com
    └── example
        └── flutter_module
            ├── flutter_release
            │   ├── 1.0
            │   │   ├── flutter_release-1.0.aar
            │   │   ├── flutter_release-1.0.aar.md5
            │   │   ├── flutter_release-1.0.aar.sha1
            │   │   ├── flutter_release-1.0.pom
            │   │   ├── flutter_release-1.0.pom.md5
            │   │   └── flutter_release-1.0.pom.sha1
            │   ├── maven-metadata.xml
            │   ├── maven-metadata.xml.md5
            │   └── maven-metadata.xml.sha1
            ├── flutter_profile
            │   ├── ...
            └── flutter_debug
                └── ...
```

Para depender do AAR, o app hospedeiro deve ser capaz
de encontrar esses arquivos.

Para fazer isso, edite `settings.gradle` em seu app hospedeiro
para que ele inclua o repositório local e a dependência:

{% tabs "settings.gradle.kts" %}
{% tab "Kotlin" %}

```kotlin title="settings.gradle.kts"
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)
    repositories {
        google()
        mavenCentral()
        maven("https://storage.googleapis.com/download.flutter.io")
    }
}
```

{% endtab %}
{% tab "Groovy" %}

```groovy title="settings.gradle"
dependencyResolutionManagement {
    repositoriesMode = RepositoriesMode.PREFER_SETTINGS
    repositories {
        google()
        mavenCentral()

        // Add the new repositories starting on the next line...
        maven {
            url = uri("some/path/flutter_module/build/host/outputs/repo")
            // This is relative to the location of the build.gradle file
            // if using a relative path.
        }

        maven {
            url = uri("https://storage.googleapis.com/download.flutter.io")
        }
        // ...to before this line
    }
}
```

{% endtab %}
{% endtabs %}

<br>

### Projeto Android baseado em Kotlin DSL

Após uma build `aar` de um projeto Android baseado em Kotlin DSL,
siga estes passos para adicionar o flutter_module.

Inclua o módulo flutter como uma dependência no
arquivo `app/build.gradle` do projeto Android.

```kotlin title="MyApp/app/build.gradle.kts"
android {
    buildTypes {
        release {
          ...
        }
        debug {
          ...
        }
        create("profile") {
            initWith(getByName("debug"))
        }
}

dependencies {
  // ...
  debugImplementation("com.example.flutter_module:flutter_debug:1.0")
  releaseImplementation("com.example.flutter_module:flutter_release:1.0")
  add("profileImplementation", "com.example.flutter_module:flutter_profile:1.0")
}
```

O ID `profileImplementation` é uma `configuration` personalizada a ser
implementada no arquivo `app/build.gradle` de um projeto hospedeiro.

```kotlin title="host-project/app/build.gradle.kts"
configurations {
    getByName("profileImplementation") {
    }
}
```

```kotlin title="MyApp/settings.gradle.kts"
include(":app")

dependencyResolutionManagement {
    repositories {
        maven(url = "https://storage.googleapis.com/download.flutter.io")
        maven(url = "some/path/flutter_module_project/build/host/outputs/repo")
    }
}
```

:::important
Se você está localizado na China, use um site espelho em vez do
domínio `storage.googleapis.com`. Para saber mais sobre sites espelho,
consulte a página [Usando Flutter na China][Using Flutter in China].
:::

:::tip
Você também pode construir um AAR para seu módulo Flutter no Android Studio usando
o menu **Build > Flutter > Build AAR**.

{% render docs/app-figure.md, image:"development/add-to-app/android/project-setup/ide-build-aar.png" %}
:::

{% endtab %}
{% tab "Module source code" %}

### Dependa do código-fonte do módulo {:.no_toc}

Esta opção habilita uma build de uma etapa para tanto seu
projeto Android quanto seu projeto Flutter. Esta opção é
conveniente quando você trabalha em ambas as partes simultaneamente
e itera rapidamente, mas sua equipe deve instalar o
Flutter SDK para construir o app hospedeiro.

:::tip
Por padrão, o app hospedeiro fornece o projeto Gradle `:app`.
Para mudar o nome deste projeto, configure
`flutter.hostAppProjectName` no arquivo
`gradle.properties` do módulo Flutter.
Inclua este projeto no arquivo `settings.gradle` do app hospedeiro.
:::

#### Atualizando `settings.gradle`

Inclua o módulo Flutter como um subprojeto no
`settings.gradle` do app hospedeiro. Este exemplo assume que `flutter_module` e `MyApp`
existem no mesmo diretório

Se você está usando Kotlin, aplique as seguintes mudanças:

```kotlin title="MyApp/settings.gradle.kts"
// Include the host app project. Assumed existing content.
include(":app")
// Replace "flutter_module" with whatever package_name you supplied when you ran:
// `$ flutter create -t module [package_name]
val filePath = settingsDir.parentFile.toString() + "/flutter_module/.android/include_flutter.groovy"
apply(from = File(filePath))
```

:::warning
A capacidade de invocar `include_flutter.groovy` do código Kotlin
requer Flutter 3.27.
Para determinar sua versão atual do Flutter,
execute `flutter --version`. Se não for pelo menos a versão 3.27,
considere mudar para os canais `main` ou `beta`.
:::

Se você está usando Groovy, aplique as seguintes mudanças:

```groovy title="MyApp/settings.gradle"
// Include the host app project.
include(":app")                                   // assumed existing content
setBinding(new Binding([gradle: this]))           // new
def filePath = settingsDir.parentFile.toString() + "/flutter_module/.android/include_flutter.groovy" // new
apply from: filePath                              // new
```

O binding e avaliação de script permite que o módulo
Flutter `include` a si mesmo (como `:flutter`) e quaisquer
plugins Flutter usados pelo módulo (como `:package_info` e `:video_player`)
no contexto de avaliação do seu `settings.gradle`.

#### Atualizando `app/build.gradle`

Introduza uma dependência `implementation` no módulo
Flutter do seu app:

```groovy title="MyApp/app/build.gradle"
dependencies {
    implementation(project(":flutter"))
}
```

:::note
Este código é idêntico entre Groovy e Kotlin.
:::

{% endtab %}
{% endtabs %}

Seu app agora inclui o módulo Flutter como uma dependência.

Continue para o guia [Adicionando uma tela Flutter a um app Android][Adding a Flutter screen to an Android app].

[`abiFilters`]: {{site.android-dev}}/reference/tools/gradle-api/4.2/com/android/build/api/dsl/Ndk#abiFilters:kotlin.collections.MutableSet
[Adding a Flutter screen to an Android app]: /add-to-app/android/add-flutter-screen
[Flutter plugin]: https://plugins.jetbrains.com/plugin/9212-flutter
[local repository]: https://docs.gradle.org/current/userguide/declaring_repositories.html#sub:maven_local
[only supports]: /resources/faq#what-devices-and-os-versions-does-flutter-run-on
[Using Flutter in China]: /community/china
