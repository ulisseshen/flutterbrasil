---
title: Aplicação imperativa descontinuada dos plugins Gradle do Flutter
description: >-
  Como migrar os arquivos de build Gradle do Android do seu app Flutter para o
  novo formato declarativo.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

Para construir um app Flutter para Android, os plugins Gradle do Flutter devem ser aplicados.
Historicamente, isso era feito imperativamente com o
[legacy, imperative apply script method][] do Gradle.

No Flutter 3.16, foi adicionado suporte para aplicar esses plugins com o
[declarative plugins {} block][] do Gradle (também chamado de Plugin DSL) e agora é
a abordagem recomendada. Desde o Flutter 3.16, projetos gerados com
`flutter create` usam o Plugin DSL para aplicar plugins Gradle. Projetos criados
com versões do Flutter anteriores à 3.16 precisam ser migrados manualmente.

Aplicar plugins Gradle usando o bloco `plugins {}` executa o mesmo código de
antes e deve produzir binários de app equivalentes.

Para aprender sobre as vantagens que a nova sintaxe Plugin DSL tem sobre a sintaxe de script `apply`
legada, veja [Gradle docs][plugins block].

Migrar o ecossistema de apps para usar a nova abordagem também facilitará para
a equipe do Flutter desenvolver plugins Gradle do Flutter e habilitar novos
recursos empolgantes no futuro, como usar Kotlin em vez de Groovy em buildscripts
Gradle.

## Migrate

### android/settings.gradle

Primeiro, encontre os valores do Android Gradle Plugin (AGP)
e Kotlin que o projeto atualmente usa.
A menos que tenham sido movidos,
eles provavelmente estão definidos no bloco buildscript do
arquivo `<app-src>/android/build.gradle`.
Como exemplo, considere o arquivo `build.gradle` de
um novo app Flutter criado antes desta alteração:

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
`classpath 'com.android.tools.build:gradle:7.3.0'`, então `7.3.0`
neste caso. Similarmente, a versão do Kotlin vem no final da linha
`ext.kotlin_version = '1.7.10'`, neste caso `1.7.10`.

A seguir, substitua o conteúdo de
`<app-src>/android/settings.gradle` pelo seguinte,
lembrando de substituir `{agpVersion}` e `{kotlinVersion}` pelos valores
identificados anteriormente:

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
    id "dev.flutter.flutter-plugin-loader" version "1.0.0" // apply true
    id "com.android.application" version "{agpVersion}" apply false
    id "org.jetbrains.kotlin.android" version "{kotlinVersion}" apply false
}

include ":app"
```

Se você fez algumas alterações neste arquivo, certifique-se de que elas estejam colocadas após
os blocos `pluginManagement {}` e `plugins {}`, pois o Gradle exige
que nenhum outro código possa ser colocado antes desses blocos.

O settings Flutter Gradle Plugin (`dev.flutter.flutter-plugin-loader`)
não deve ter apply false (o padrão é true) ou deve ser explicitamente
definido como true.


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

Aqui está como esse arquivo provavelmente ficará:

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

As seguintes alterações no código que, por padrão,
é encontrado em `<app-src>/android/app/build.gradle`, também precisam ser feitas.
Primeiro, remova os seguintes 2 trechos de código que usam o
método apply imperativo legado:

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

Agora aplique os plugins novamente,
mas desta vez usando a sintaxe Plugin DSL.
No topo do seu arquivo, adicione:

```groovy
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
}
```
`"dev.flutter.flutter-gradle-plugin"` é o project Flutter
Gradle Plugin, que é uma string diferente do valor aplicado
em settings.gradle(.kts) (`"dev.flutter.flutter-plugin-loader"`).

Finalmente, se seu bloco `dependencies` contém uma dependência
em `"org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"`,
então remova essa dependência.

```groovy diff
  dependencies {
-     implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
  }
```
Se foi a única dependência no bloco `dependencies`,
então você pode remover o bloco inteiramente.

### Validation

Execute `flutter run` para confirmar que seu app constrói e
inicia em um dispositivo Android conectado ou emulador.

## Examples

### Google Mobile Services and Crashlytics

Se seu app estava usando Google Mobile Services e Crashlytics,
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

Então remova estas 2 linhas de `<app-src>/android/app/build.gradle`:

```groovy diff
- apply plugin: 'com.google.gms.google-services'
- apply plugin: 'com.google.firebase.crashlytics'
```

Para migrar para a nova sintaxe declarative-apply para
os plugins GMS e Crashlytics, adicione-os ao bloco `plugins`
no arquivo `<app-src>/android/settings.gradle` do seu app.
As adições devem se parecer com o seguinte,
mas com as versões de plugin desejadas, provavelmente correspondendo
às que você removeu do arquivo `<app-src>/android/build.gradle`.

```groovy diff
  plugins {
      id "dev.flutter.flutter-plugin-loader" version "1.0.0"
      id "com.android.application" version "{agpVersion}" apply false
      id "org.jetbrains.kotlin.android" version "{kotlinVersion}" apply false
+     id "com.google.gms.google-services" version "4.4.0" apply false
+     id "com.google.firebase.crashlytics" version "2.9.9" apply false
  }
```

Adicione as seguintes linhas a `<app-src>/android/app/build.gradle`:

```groovy diff
  plugins {
      id "com.android.application"
      id "dev.flutter.flutter-gradle-plugin"
      id "org.jetbrains.kotlin.android"
+     id "com.google.gms.google-services"
+     id "com.google.firebase.crashlytics"
  }
```

## Timeline

Support in stable release: 3.16.0
Recommended in stable release: 3.19.0

## References

Gradle build files generated by `flutter create`
differ across Flutter versions.
For a detailed overview, see [issue #135392][].
You should consider using the
latest versions of build files.

[legacy, imperative apply script method]: https://docs.gradle.org/8.5/userguide/plugins.html#sec:script_plugins
[declarative plugins {} block]: https://docs.gradle.org/8.5/userguide/plugins.html#sec:plugins_block
[plugins block]: https://docs.gradle.org/current/userguide/plugins.html#plugins_dsl_limitations
[issue #135392]: {{site.github}}/flutter/flutter/issues/135392
