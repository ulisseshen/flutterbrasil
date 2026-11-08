---
ia-translate: true
title: Migração para o Kotlin integrado para desenvolvedores de apps
description: >-
  Migre apps Flutter para usar o Kotlin integrado.
---

Este guia descreve os passos de migração específicos para desenvolvedores de apps.

Estas instruções pressupõem que você está atualizando de
uma versão do AGP anterior à 9.0.0 para uma versão 9.0.0 ou superior do AGP.
Você também deve usar as versões mínimas compatíveis de dependências
listadas na [documentação do Android Gradle Plugin][AGP block].

:::warning
Este guia se aplica apenas a apps que já usam o
Kotlin Gradle Plugin (KGP).

Para verificar se o seu app aplica o KGP,
procure o plugin `kotlin-android`
(ou o plugin `org.jetbrains.kotlin.android`).
Ele provavelmente está localizado no arquivo
`<app-src>/android/app/build.gradle` ou
`<app-src>/android/app/build.gradle.kts`.
Para ver o código de aplicação do KGP,
consulte [Atualizar o arquivo Gradle](#update-the-gradle-file).

Se o seu app não aplica o KGP atualmente,
não migre para o Kotlin integrado.
:::

:::note
Para atualizar os plugins Flutter para usar o Kotlin integrado,
siga o [guia de migração para autores de plugins][migration guide for plugin authors].
:::

[AGP block]: {{site.android-dev}}/build/releases/gradle-plugin
[migration guide for plugin authors]: /release/breaking-changes/migrate-to-built-in-kotlin/for-plugin-authors

<a id="verify-flags-in-properties-file" aria-hidden="true"></a>

## Verificar as flags no arquivo de propriedades do Gradle {:#verify-flags-in-the-gradle-properties-file}

O Flutter define o comportamento padrão para usar o Kotlin Gradle Plugin (KGP)
legado e os tipos antigos de DSL do AGP, para dar suporte a projetos que ainda não migraram.
A ferramenta de migração do Flutter adiciona automaticamente `android.builtInKotlin=false`
e `android.newDsl=false` ao seu arquivo `gradle.properties`.

Se essas flags não estiverem no seu arquivo `gradle.properties`,
a ferramenta do Flutter as adiciona automaticamente na próxima vez que você
compilar ou executar o seu app com `flutter run` ou `flutter build apk`.

Como alternativa, compilar o projeto usando as ferramentas do Android Studio
também adiciona essas flags automaticamente.
Ao concluir o processo, verifique se as flags foram adicionadas.
Para mais detalhes, consulte a [issue #183910][issue-183910] do Flutter.

Todos os projetos add-to-app devem adicionar manualmente
`android.builtInKotlin=false` e `android.newDsl=false` ao arquivo
`gradle.properties` do app host Android.
A ferramenta de migração do Flutter não pode ser executada durante a compilação
do app host Android em add-to-app, porque o app host é um projeto Android puramente nativo.

```properties diff title="<host-app-project>/gradle.properties"
# ...
+ android.newDsl=false
+ android.builtInKotlin=false
```

:::note
Se o seu app não aplica o plugin `kotlin-android` (também chamado de Kotlin Gradle Plugin),
então você só precisa adicionar `android.newDsl=false` e
não precisa concluir nenhum outro passo de migração.
:::

## Atualizar o arquivo Gradle {:#update-the-gradle-file}

Primeiro, encontre o plugin `kotlin-android`
(ou o plugin `org.jetbrains.kotlin.android`).
Ele provavelmente está no bloco `plugins` do
arquivo `<app-src>/android/app/build.gradle` ou do arquivo
`<app-src>/android/app/build.gradle.kts`.
Se você usa a sintaxe legada `apply`, ele estará no
arquivo `<app-src>/android/app/build.gradle` baseado em Groovy,
já que essa sintaxe não é suportada no Kotlin DSL.

Os exemplos a seguir demonstram como
migrar um app Android Flutter e um app host Android em add-to-app:

### Migrar o seu app Android Flutter {:#migrate-your-flutter-android-app}

<Tabs key="modern-legacy-apply">
<Tab name="plugins block">

**Antes**:

```kotlin title="<app-src>/android/app/build.gradle(.kts)"
plugins {
    id("com.android.application")
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

```kotlin diff title="<app-src>/android/app/build.gradle.kts"
  plugins {
      id("com.android.application")
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

```kotlin diff title="<app-src>/android/app/build.gradle.kts"
+ kotlin {
+     compilerOptions {
+         jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
+     }
+ }
```

Veja como o arquivo deve ficar no final:

**Depois**:

```kotlin title="<app-src>/android/app/build.gradle(.kts)"
plugins {
    id("com.android.application")
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
<Tab name="legacy apply">

**Antes**:

```groovy title="<app-src>/android/app/build.gradle"
apply plugin: 'com.android.application'
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

```groovy diff title="<app-src>/android/app/build.gradle"
  apply plugin: 'com.android.application'
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

```groovy diff title="<app-src>/android/app/build.gradle"
+ kotlin {
+     compilerOptions {
+         jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
+     }
+ }
```

Veja como o arquivo deve ficar no final:

**Depois**:

```groovy title="<app-src>/android/app/build.gradle"
apply plugin: 'com.android.application'
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

### Migrar o seu app host Android em add-to-app {:#migrate-your-add-to-app-android-host-app}

Apps Android nativos usam a palavra-chave `alias` para aplicar plugins,
o que é incompatível com a sintaxe legada `apply()`.
Por isso, apenas as instruções do bloco `plugins {}` estão incluídas.

**Antes**:

```kotlin title="<app-src>/android/app/build.gradle(.kts)"
plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
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

```kotlin diff title="<app-src>/android/app/build.gradle.kts"
  plugins {
      alias(libs.plugins.android.application)
-     alias(libs.plugins.kotlin.android)
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

```kotlin diff title="<app-src>/android/app/build.gradle.kts"
+ kotlin {
+     compilerOptions {
+         jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
+     }
+ }
```

Veja como o arquivo deve ficar no final:

**Depois**:

```kotlin title="<app-src>/android/app/build.gradle(.kts)"
plugins {
    alias(libs.plugins.android.application)
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

## Validar {:#validate}

Antes de ativar o Kotlin integrado,
confirme que você migrou o seu aplicativo
e quaisquer plugins Flutter que ele usa.
Também confirme que você atualizou o seu app
para o AGP 9+, porque o Kotlin integrado exige o AGP 9+.

Para ativar o Kotlin integrado,
defina a propriedade `android.builtInKotlin` como `true`
no seu arquivo `gradle.properties`:

```properties diff title="<flutter-project>/android/gradle.properties"
# ...
+ android.builtInKotlin=true
```

:::version-note
O Flutter 3.44 adicionou suporte ao AGP 9 com o Kotlin integrado desativado
(`android.builtInKotlin=false`),
enquanto ativar o Kotlin integrado (`android.builtInKotlin=true`)
exige o Flutter 3.47 ou superior.
:::

Depois de ativar o Kotlin integrado,
execute `flutter run` ou `flutter build apk`
para confirmar que o seu app compila e inicia
em um dispositivo Android conectado ou em um emulador.

Se o seu app não compilar porque
você está usando um plugin Flutter que não migrou,
siga as instruções abaixo:

## Relatar uso incompatível do Kotlin Gradle Plugin aos autores de plugins {:#report-incompatible-kotlin-gradle-plugin-usage-to-plugin-authors}

Siga estas instruções apenas se o seu app usa um plugin Flutter
que ainda não migrou para o Kotlin integrado.

1.  Encontre o repositório do plugin Flutter não migrado pesquisando
    o nome do plugin em [pub.dev]({{site.pub}}) ou na internet.
1.  Verifique o changelog do plugin para confirmar que
    nenhuma versão existente migrou para o Kotlin integrado.
1.  Abra uma issue para os autores do plugin,
    informando que o Kotlin Gradle Plugin é incompatível e
    não será suportado em uma versão futura do Flutter.

Você pode usar o seguinte modelo para a issue:

**Título da issue:** Migrate plugin to built-in Kotlin

**Corpo da issue:**

```markdown
I am using `<plugin-name>` in my Flutter app.

Starting with Android Gradle Plugin (AGP) 9.0,
support for applying the Kotlin Gradle Plugin (KGP) has been removed.
Because this plugin applies KGP,
it causes a compilation error that prevents my app from building.
Flutter [issue #181383](https://github.com/flutter/flutter/issues/181383)
includes an example of the error.

Flutter has temporarily added support to allow KGP
while apps and plugins migrate to AGP 9.0 or later,
but this support will be removed in a future version of Flutter.

Please migrate this plugin to use built-in Kotlin to
ensure your plugin users can successfully
build their apps in future versions of Flutter.

Here is the Flutter
[migration guide for plugin authors](https://docs.flutter.dev/release/breaking-changes/migrate-to-built-in-kotlin/for-plugin-authors).
```

Seja respeitoso e atento às regras e ao código de conduta do repositório do plugin
ao relatar issues e interagir com os autores dos plugins.

Como referência, consulte o [Código de Conduta do Flutter][Code of Conduct].

[Code of Conduct]: {{site.repo.flutter}}/blob/main/CODE_OF_CONDUCT.md

## Próximos passos {:#next-steps}

Para os próximos passos,
consulte a [visão geral da migração para o Kotlin integrado][migration-overview].

[migration-overview]: /release/breaking-changes/migrate-to-built-in-kotlin

## Referências {:#references}

Issues relevantes:

- [Issue #183910][issue-183910]: Adicionar migradores para desativar o Kotlin integrado e o novo DSL
- [Issue #181383][issue-181383]: Plugins Flutter devem oferecer suporte ao AGP 9.0.0

Os arquivos de build Gradle do seu app variam de acordo com
a versão do Flutter usada quando o app foi criado.
Considere manter os arquivos de build atualizados
executando periodicamente `flutter upgrade`
no diretório raiz do seu app.

[issue-183910]: {{site.repo.flutter}}/issues/183910
[issue-181383]: {{site.repo.flutter}}/issues/181383
