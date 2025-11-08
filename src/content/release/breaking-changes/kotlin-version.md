---
ia-translate: true
title: Versão necessária do Kotlin
description: >
    Apps Flutter compilados para a plataforma Android
    agora requerem Kotlin 1.5.31 ou superior.
---

## Resumo

Para compilar um app Flutter para Android, é necessário Kotlin 1.5.31 ou superior.

Se seu app usar uma versão inferior,
você receberá a seguinte mensagem de erro:

```plaintext noHighlight
┌─ Flutter Fix ────────────────────────────────────────────────────────────┐
│                                                                          │
│ [!] Your project requires a newer version of the Kotlin Gradle plugin.   │
│ Find the latest version on                                               │
│ https://kotlinlang.org/docs/gradle.html#plugin-and-versions, then update │
│ <path-to-app>/android/build.gradle:                                      │
│ ext.kotlin_version = '<latest-version>'                                  │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

## Contexto

O Flutter adicionou suporte para [dispositivos dobráveis][1] no Android.
Isso exigiu adicionar uma dependência AndroidX ao embedding do Flutter que
requer que os apps usem Kotlin 1.5.31 ou superior.

## Descrição da mudança

Um app Flutter compilado para Android agora inclui a dependência Gradle
`androidx.window:window-java`.

## Guia de migração

Abra `<app-src>/android/build.gradle`, e altere `ext.kotlin_version`:

```groovy diff
  buildscript {
-     ext.kotlin_version = '1.3.50'
+     ext.kotlin_version = '1.5.31'
```

## Cronograma

Adicionado na versão: v2.9.0 beta<br>
Na versão stable: 2.10

## Referências

PR relevante:

* [PR 29585: Display Features support][]


[PR 29585: Display Features support]: {{site.repo.engine}}/pull/29585

[1]: {{site.android-dev}}/guide/topics/large-screens/learn-about-foldables
