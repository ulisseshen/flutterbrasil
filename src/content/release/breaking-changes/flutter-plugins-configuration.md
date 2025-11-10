---
title: .flutter-plugins-dependencies substitui .flutter-plugins.
description: >-
  A saída do arquivo de ferramenta `.flutter-plugins` obsoleta foi substituída por
  `.flutter-plugins-dependencies`, e quaisquer scripts de build ou referências a ele
  também devem ser atualizados.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

A ferramenta `flutter` não gerará mais o arquivo de metadados `.flutter-plugins`,
e somente gerará `.flutter-plugins-dependencies`.

Ferramentas e scripts de build, como configurações Gradle (para apps Android) que
dependem da presença de `.flutter-plugins` precisam ser atualizados.

## Background

[Em 2019][PR 45379], `.flutter-plugins-dependencies` foi adicionado como um formato de arquivo
mais recente que substitui `.flutter-plugins`.

Então um arquivo que parecia algo assim:

```plaintext title=".flutter-plugins"
camera=/path/to/camera/plugin
shared_preferences=shared_preferences
```

Foi substituído por algo assim:

```json title=".flutter-plugins-dependencies"
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

Gerar ambos os arquivos é uma fonte de dívida técnica que
complica novos conjuntos de recursos, como
não incluir plugins `dev_dependency` em um app de release.

## Migration guide

A maioria dos desenvolvedores Flutter não analisa ou usa este arquivo, mas
configurações de build podem fazê-lo, incluindo o arquivo `settings.gradle` como
gerado por invocações antigas de `flutter create --platforms android`.
Esses arquivos legados ainda podem referenciar `.flutter-plugins` e
devem ser atualizados para um script de build mais recente.

Por exemplo:

```groovy title="settings.gradle"
include ':app'

def flutterProjectRoot = rootProject.projectDir.parentFile.toPath()

def plugins = new Properties()
// Note explicitly reading the legacy '.flutter-plugins' file.
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

Pode ser atualizado para seu equivalente `settings.gradle.kts`:

```kts title="settings.gradle.kts"
pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
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
    // Note the use of the flutter-plugin-loader versus reading '.flutter-plugins'
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.1.0" apply false
    id("org.jetbrains.kotlin.android") version "1.8.22" apply false
}

include(":app")
```

Para ajuda na mudança para o DSL de plugin mais recente, confira
[Deprecated imperative apply of Flutter's Gradle plugins][imperative-apply].

Para fazer um smoke test sobre se seu build depende de um arquivo `.flutter-plugins`,
você pode usar a feature flag `explicit-package-dependencies`:

```console
$ flutter config --explicit-package-dependencies
```

Quaisquer ferramentas ou scripts de build que possam depender do arquivo `.flutter-plugins`
sendo gerado agora falharão.

## Timeline

Landed in version: 3.28.0-0.0.pre<br>
Stable release: 3.32

Um lançamento estável após esta mudança chegar,
`.flutter-plugins` não será mais gerado.

## References

Issues relevantes:

- [Issue 48918][], onde `.flutter-plugins` foi (em 2020)
  programado para descontinuação.

PRs relevantes:

- [PR 45379][], onde `.flutter-plugins-dependencies` foi originalmente adicionado.
- [PR 157388][], onde um aviso foi adicionado aos scripts de build Android do Flutter.

[Issue 48918]: {{site.repo.flutter}}/issues/48918
[PR 45379]: {{site.repo.flutter}}/pull/45379
[PR 157388]: {{site.repo.flutter}}/pull/157388
[imperative-apply]: /release/breaking-changes/flutter-gradle-plugin-apply
