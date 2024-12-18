---
ia-translate: true
title: .flutter-plugins-dependencies substitui .flutter-plugins.
description: >-
  O arquivo de saída da ferramenta `.flutter-plugins`, agora obsoleto, foi
  substituído por `.flutter-plugins-dependencies`, e quaisquer scripts de build
  ou referências a ele também devem ser atualizados.
---

## Sumário

A ferramenta `flutter` não irá mais gerar o arquivo de metadados legado
`.flutter-plugins`, e emitirá apenas `.flutter-plugins-dependencies`. Ferramentas e
scripts de build, como configurações do Gradle (para apps Android) que
dependem da presença de `.flutter-plugins` precisarão ser atualizados.

## Contexto

[Em 2019][PR 45379], `.flutter-plugins-dependencies` foi adicionado como um formato
de arquivo mais novo que substitui `.flutter-plugins`.

Assim, um arquivo que se parecia com isto:

```txt
# Isto é .flutter-plugins
camera=/caminho/para/o/plugin/camera
shared_preferences=shared_preferences
```

... foi substituído por algo como isto:

```json
{
  "dependencyGraph": {
    "camera": {
      "name": "camera",
      "version": "0.10.0",
      "dependencies": {
        "flutter": "0.0.0"
      }
    },
    "shared_preferences": {
      "name": "shared_preferences",
      "version": "2.0.15",
      "dependencies": {
        "flutter": "0.0.0"
      }
    }
  },
  "flutter": {
    "frameworkRevision": "3a0f99d4f2",
    "channel": "stable"
  }
}
```

Ter ambos os arquivos gerados é uma fonte de dívida técnica que complica novos
conjuntos de recursos, como não incluir plugins `dev_dependency` em um app de
release.

## Guia de Migração

A maioria dos desenvolvedores Flutter não analisa ou usa este arquivo, mas as
configurações de build (como `settings.gradle`), conforme gerado por invocações
mais antigas de `flutter create --platforms android`. Estes arquivos legados ainda
podem referenciar `.flutter-plugins` e devem ser atualizados para um script de
build mais recente.

Por exemplo:

```groovy
include ':app'

def flutterProjectRoot = rootProject.projectDir.parentFile.toPath()

def plugins = new Properties()
// Note que lê explicitamente o arquivo legado '.flutter-plugins'.
def pluginsFile = new File(flutterProjectRoot.toFile(), '.flutter-plugins')
if (pluginsFile.exists()) {
    pluginsFile.withReader('UTF-8') { reader -> plugins.load(reader) }
}

plugins.each { name, path ->
    def pluginDirectory = flutterProjectRoot.resolve(path).resolve('android').toFile()
    include ":$name"
    project(":$name").projectDir = pluginDirectory
}
```

... pode ser atualizado para o seu equivalente em `settings.gradle.kts`:

```kts
pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk não definido em local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    // Note o uso do flutter-plugin-loader versus a leitura de '.flutter-plugins'
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.1.0" apply false
    id("org.jetbrains.kotlin.android") version "1.8.22" apply false
}

include(":app")
```

Veja [Aplicação imperativa obsoleta dos plugins Gradle do Flutter][imperative-apply]
para detalhes sobre a mudança para a DSL de plugin mais recente.

Para testar se seu build depende de um arquivo `.flutter-plugins`, você pode
usar a flag de recurso `explicit-package-dependencies`:

```sh
flutter config explicit-package-dependencies
```

Quaisquer ferramentas ou scripts de build que possam depender da saída desse
arquivo agora falharão.

## Cronograma

Não lançado

Não lançado + 1, o suporte a `.flutter-plugins` será removido.

## Referências

Issues relevantes:

- [Issue 48918][], onde `.flutter-plugins` foi (em 2020) programado para ser
  obsoleto.

PRs relevantes:

- [PR 45379][], onde `.flutter-plugins-dependencies` foi adicionado originalmente.
- [PR 157388][], onde um aviso foi adicionado aos scripts de build do Flutter Android.

[Issue 48918]: https://github.com/flutter/flutter/issues/48918
[PR 45379]: https://github.com/flutter/flutter/pull/45379
[PR 157388]: https://github.com/flutter/flutter/pull/157388
[imperative-apply]: https://docs.flutter.dev/release/breaking-changes/flutter-gradle-plugin-apply
