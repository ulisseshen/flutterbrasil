---
ia-translate: true
title: Aplicação imperativa depreciada dos plugins Gradle do Flutter
description: >-
  Como migrar os arquivos de build do Android Gradle do seu aplicativo Flutter
  para o novo formato declarativo.
---

## Resumo

Para construir um aplicativo Flutter para Android, os plugins Gradle do Flutter
devem ser aplicados. Historicamente, isso era feito de forma imperativa com o
[método de script de aplicação imperativo legado][] do Gradle.

No Flutter 3.16, foi adicionado suporte para aplicar esses plugins com o
[bloco declarativo plugins {}][] do Gradle (também chamado de Plugin DSL) e
agora é a abordagem recomendada. Desde o Flutter 3.16, os projetos gerados com
`flutter create` usam o Plugin DSL para aplicar plugins Gradle. Projetos criados
com versões do Flutter anteriores à 3.16 precisam ser migrados manualmente.

Aplicar plugins Gradle usando o bloco `plugins {}` executa o mesmo código de
antes e deve produzir binários de aplicativo equivalentes.

Para saber mais sobre as vantagens que a nova sintaxe Plugin DSL tem sobre a
sintaxe de script `apply` legada, consulte [documentação do Gradle][plugins block].

Migrar o ecossistema de aplicativos para usar a nova abordagem também facilitará
para a equipe do Flutter desenvolver os plugins Gradle do Flutter e habilitar
novos recursos interessantes no futuro, como usar Kotlin em vez de Groovy em
buildscripts do Gradle.

## Migrar

### android/settings.gradle

Primeiro, encontre os valores do Android Gradle Plugin (AGP) e do Kotlin que o
projeto usa atualmente. A menos que tenham sido movidos, eles provavelmente
estão definidos no bloco buildscript do arquivo
`<app-src>/android/build.gradle`. Como exemplo, considere o arquivo
`build.gradle` de um novo aplicativo Flutter criado antes desta alteração:

```groovy
buildscript {
    ext.kotlin_version = '1.7.10'
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:7.3.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = '../build'
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(':app')
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}
```

A versão do AGP é o número que vem no final da linha
`classpath 'com.android.tools.build:gradle:7.3.0'`, então `7.3.0` neste caso.
Da mesma forma, a versão do Kotlin vem no final da linha
`ext.kotlin_version = '1.7.10'`, neste caso `1.7.10`.

Em seguida, substitua o conteúdo de
`<app-src>/android/settings.gradle` pelo seguinte, lembrando-se de substituir
`{agpVersion}` e `{kotlinVersion}` pelos valores identificados
anteriormente:

```groovy
pluginManagement {
    def flutterSdkPath = {
        def properties = new Properties()
        file("local.properties").withInputStream { properties.load(it) }
        def flutterSdkPath = properties.getProperty("flutter.sdk")
        assert flutterSdkPath != null, "flutter.sdk not set in local.properties"
        return flutterSdkPath
    }()

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "{agpVersion}" apply false
    id "org.jetbrains.kotlin.android" version "{kotlinVersion}" apply false
}

include ":app"
```

Se você fez algumas alterações neste arquivo, certifique-se de que elas sejam
colocadas após os blocos `pluginManagement {}` e `plugins {}`, pois o Gradle
impõe que nenhum outro código possa ser colocado antes desses blocos.

### android/build.gradle

Remova todo o bloco `buildscript` de `<app-src/android/build.gradle`:

```groovy diff
- buildscript {
-     ext.kotlin_version = '{kotlinVersion}'
-     repositories {
-         google()
-         mavenCentral()
-     }
-
-     dependencies {
-         classpath "org.jetbrains.kotlin:gradle-plugin:$kotlin_version"
-     }
- }
```

Veja como esse arquivo provavelmente ficará:

```groovy
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = '../build'
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(':app')
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}
```

### android/app/build.gradle

As seguintes alterações no código que, por padrão, são encontradas em
`<app-src>/android/app/build.gradle`, também precisam ser feitas. Primeiro,
remova os 2 seguintes blocos de código que usam o método de aplicação
imperativo legado:

```groovy diff
- def flutterRoot = localProperties.getProperty('flutter.sdk')
- if (flutterRoot == null) {
-     throw new GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file.")
- }
```

```groovy diff
- apply plugin: 'com.android.application'
- apply plugin: 'com.jetbrains.kotlin.android'
- apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"
```

Agora, aplique os plugins novamente, mas desta vez usando a sintaxe Plugin DSL.
No início do seu arquivo, adicione:

```groovy
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
}
```

Finalmente, se o seu bloco `dependencies` contém uma dependência
em `"org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"`, remova
essa dependência.

```groovy diff
  dependencies {
-     implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
  }
```
Se essa fosse a única dependência no bloco `dependencies`, então você pode remover o bloco inteiro.

### Validação

Execute `flutter run` para confirmar se seu aplicativo é compilado e
iniciado em um dispositivo Android conectado ou emulador.

## Exemplos

### Google Mobile Services e Crashlytics

Se o seu aplicativo estava usando o Google Mobile Services e o Crashlytics,
remova as seguintes linhas de `<app-src>/android/build.gradle`:

```groovy diff
  buildscript {
      // ...

      dependencies {
          // ...
-         classpath "com.google.gms:google-services:4.4.0"
-         classpath "com.google.firebase:firebase-crashlytics-gradle:2.9.9"
      }
  }
```

Em seguida, remova estas 2 linhas de `<app-src>/android/app/build.gradle`:

```groovy diff
- apply plugin: 'com.google.gms.google-services'
- apply plugin: 'com.google.firebase.crashlytics'
```

Para migrar para a nova sintaxe de aplicação declarativa para os plugins GMS e
Crashlytics, adicione-os ao bloco `plugins` no arquivo
`<app-src>/android/settings.gradle` do seu aplicativo. As adições devem ser
semelhantes às seguintes, mas com as versões de plugin desejadas,
provavelmente correspondendo às que você removeu do arquivo
`<app-src>/android/build.gradle`.

```groovy diff
  plugins {
      id "dev.flutter.flutter-plugin-loader" version "1.0.0"
      id "com.android.application" version "{agpVersion}" apply false
      id "org.jetbrains.kotlin.android" version "{kotlinVersion}" apply false
+     id "com.google.gms.google-services" version "4.4.0" apply false
+     id "com.google.firebase.crashlytics" version "2.9.9" apply false
  }
```

Adicione as seguintes linhas em `<app-src>/android/app/build.gradle`:

```groovy diff
  plugins {
      id "com.android.application"
      id "dev.flutter.flutter-gradle-plugin"
      id "org.jetbrains.kotlin.android"
+     id "com.google.gms.google-services"
+     id "com.google.firebase.crashlytics"
  }
```

## Cronograma

Suporte na versão estável: 3.16.0
Recomendado na versão estável: 3.19.0

## Referências

Os arquivos de build do Gradle gerados por `flutter create` diferem entre as
versões do Flutter. Para uma visão geral detalhada, consulte [issue #135392][].
Você deve considerar o uso das versões mais recentes dos arquivos de build.

[legacy, imperative apply script method]: https://docs.gradle.org/8.5/userguide/plugins.html#sec:script_plugins
[declarative plugins {} block]: https://docs.gradle.org/8.5/userguide/plugins.html#sec:plugins_block
[plugins block]: https://docs.gradle.org/current/userguide/plugins.html#plugins_dsl_limitations
[issue #135392]: {{site.github}}/flutter/flutter/issues/135392
