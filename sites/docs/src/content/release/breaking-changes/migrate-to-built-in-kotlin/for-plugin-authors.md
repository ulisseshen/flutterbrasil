---
ia-translate: true
title: Migração para Kotlin integrado para autores de plugins
description: >-
  Migre plugins Flutter para usar o Kotlin integrado.
---

Este guia descreve os passos de migração específicos para autores de plugins.

:::warning
Migrar para o Kotlin integrado exige uma versão mínima do Flutter de 3.44.

Esta migração usa `kotlin.compilerOptions {}`,
que exige o Kotlin Gradle Plugin (KGP) 2.0.0 ou superior.
A partir do Flutter 3.44, o Flutter exige uma versão mínima do KGP de 2.0.0.
Autores de plugins devem atualizar a versão mínima do Flutter
do plugin para pelo menos 3.44 em `pubspec.yaml` ao migrar.

Este guia se aplica somente a plugins que já usam o
Kotlin Gradle Plugin (KGP).

Para verificar se o seu plugin aplica o KGP,
procure o plugin `kotlin-android`
(ou o plugin `org.jetbrains.kotlin.android`).
Ele provavelmente está no arquivo
`<plugin-project>/android/build.gradle` ou
`<plugin-project>/android/build.gradle.kts`.
Para ver o código de aplicação do KGP,
consulte [Atualize o arquivo Gradle](#update-the-gradle-file).

Se o projeto do seu plugin não aplica o KGP,
não migre para o Kotlin integrado.
:::

:::note
Para atualizar apps Flutter para usar o Kotlin integrado,
siga o [guia de migração para desenvolvedores de apps][migration guide for app developers].
:::

[migration guide for app developers]: /release/breaking-changes/migrate-to-built-in-kotlin/for-app-developers

## Atualize o arquivo Gradle {:#update-the-gradle-file}

Primeiro, procure o plugin `kotlin-android`
(ou o plugin `org.jetbrains.kotlin.android`).
Ele provavelmente está no bloco `plugins` do
arquivo `<plugin-project>/android/build.gradle` ou `<plugin-project>/android/build.gradle.kts`.
Se você usa a sintaxe legada `apply`,
ele estará no arquivo `<plugin-project>/android/build.gradle` baseado em Groovy,
pois essa sintaxe não é suportada no Kotlin DSL.

Os exemplos a seguir mostram como migrar um plugin Flutter:

<Tabs key="modern-legacy-apply">
<Tab name="Bloco plugins">

**Antes**:

```kotlin title="<app-src>/android/build.gradle(.kts)"
plugins {
    id("com.android.library")
    id("kotlin-android")
    // ...
}

android {
    // ...
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }
    // ...
}

// ...
```

Em seguida, remova o plugin `kotlin-android` e o bloco `kotlinOptions`:

```kotlin diff title="<app-src>/android/build.gradle.kts"
  plugins {
      id("com.android.library")
-     id("kotlin-android")
      // ...
  }

  android {
      // ...
-     kotlinOptions {
-         jvmTarget = JavaVersion.VERSION_17.toString()
-     }
      // ...
  }
```

Adicione o bloco DSL `kotlin.compilerOptions{}` com o seguinte:

```kotlin diff title="<app-src>/android/build.gradle.kts"
+ kotlin {
+     compilerOptions {
+         jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
+     }
+ }
```

Veja como o arquivo deve ficar:

**Depois**:

```kotlin title="<app-src>/android/build.gradle(.kts)"
plugins {
    id("com.android.library")
    // ...
}

android {
    // ...
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

// ...
```

</Tab>
<Tab name="Apply legado">

**Antes**:

```groovy title="<app-src>/android/build.gradle"
apply plugin: 'com.android.library'
apply plugin: 'kotlin-android'
// ...

android {
    // ...
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }
    // ...
}

// ...
```

Em seguida, remova o plugin `kotlin-android` e o bloco `kotlinOptions`:

```groovy diff title="<app-src>/android/build.gradle"
  apply plugin: 'com.android.library'
- apply plugin: 'kotlin-android'
// ...

  android {
      // ...
-     kotlinOptions {
-         jvmTarget = JavaVersion.VERSION_17.toString()
-     }
      // ...
  }
```

Adicione o bloco DSL `kotlin.compilerOptions{}` com o seguinte:

```groovy diff title="<app-src>/android/build.gradle"
+ kotlin {
+     compilerOptions {
+         jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
+     }
+ }
```

Veja como o arquivo deve ficar:

**Depois**:

```groovy title="<app-src>/android/build.gradle"
apply plugin: 'com.android.library'
// ...

android {
    // ...
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

// ...
```
</Tab>
</Tabs>

## Atualize o `pubspec.yaml` do plugin {:#update-the-plugins-pubspecyaml}

Usar o bloco DSL `kotlin.compilerOptions {}` exige
uma versão mínima do Kotlin Gradle Plugin (KGP) de 2.0.0.
A partir do Flutter 3.44, a versão mínima exigida do KGP é 2.0.0.
Para garantir que apps que usam seu plugin possam compilar no AGP 9,
exija uma versão mínima do Flutter de 3.44 para a versão do plugin.
Isso permite que apps que usam seu plugin compilem no AGP 9 com
o Kotlin integrado desabilitado (`android.builtInKotlin=false`).

:::note
Habilitar o Kotlin integrado (`android.builtInKotlin=true`)
no app de exemplo do plugin exige Flutter 3.47 ou superior.
:::

Como você está atualizando a versão mínima do Flutter,
também deve atualizar a versão mínima correspondente do Dart.

Atualize a versão mínima do Flutter e a versão mínima do Dart:

```yaml diff title="<plugin-project>/pubspec.yaml"
# ...

  environment:
-   sdk: ^<previous-dart-minimum>
+   sdk: ^3.12.0
-   flutter: ">=<previous-flutter-minimum>"
+   flutter: ">=3.44.0"

# ...
```

Veja como o arquivo deve ficar:

```yaml title="<plugin-project>/pubspec.yaml"
# ...

environment:
  sdk: ^3.12.0
  flutter: ">=3.44.0"

# ...
```

<a id="update-the-plugins-changelog-md" aria-hidden="true"></a>

## Atualize o CHANGELOG do plugin

Inclua as suas mudanças no arquivo `CHANGELOG.md` da
nova versão do plugin lançada:

```markdown diff title="<plugin-project>/CHANGELOG.md"
+ ## <new-plugin-release-version>

+ - Atualiza a versão mínima do SDK suportada para Flutter 3.44/Dart 3.12.
+ - Migra para o Kotlin integrado.

// ...
```

## Valide {:#validate}

Antes de habilitar o Kotlin integrado,
confirme que você migrou o app de exemplo do seu plugin
e quaisquer plugins Flutter que ele usa.
Também confirme que você atualizou o app de exemplo do plugin
para o AGP 9+, pois o Kotlin integrado exige AGP 9+.

Para habilitar o Kotlin integrado,
defina a propriedade `android.builtInKotlin` como `true`
no arquivo `gradle.properties`:

```properties diff title="<flutter-project>/android/gradle.properties"
# ...
+ android.builtInKotlin=true
```

:::version-note
O Flutter 3.44 adicionou suporte ao AGP 9 com o Kotlin integrado desabilitado
(`android.builtInKotlin=false`),
enquanto habilitar o Kotlin integrado (`android.builtInKotlin=true`)
exige Flutter 3.47 ou superior.
:::

Depois de habilitar o Kotlin integrado,
execute `flutter run` ou `flutter build apk`
para confirmar que o app de exemplo do seu plugin compila e inicia
em um dispositivo Android conectado ou em um emulador.

Se o app de exemplo do seu plugin também aplica o KGP,
você também terá que migrar o app de exemplo.
Para isso,
siga o [guia de migração para desenvolvedores de apps][app-migration-guide].

[app-migration-guide]: /release/breaking-changes/migrate-to-built-in-kotlin/for-app-developers
