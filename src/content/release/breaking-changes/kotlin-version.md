---
ia-translate: true
title: Versão do Kotlin Necessária
description: >
    Aplicativos Flutter construídos para a plataforma
    Android agora requerem Kotlin 1.5.31 ou superior.
---

## Sumário

Para construir um aplicativo Flutter para Android, é necessário Kotlin 1.5.31 ou superior.

Se seu aplicativo usa uma versão inferior,
você receberá a seguinte mensagem de erro:

```plaintext noHighlight
┌─ Flutter Fix ────────────────────────────────────────────────────────────┐
│                                                                          │
│ [!] Seu projeto requer uma versão mais recente do plugin Kotlin do Gradle. │
│ Encontre a versão mais recente em                                          │
│ https://kotlinlang.org/docs/gradle.html#plugin-and-versions, então atualize │
│ <caminho-para-o-app>/android/build.gradle:                                 │
│ ext.kotlin_version = '<versão-mais-recente>'                             │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

## Contexto

O Flutter adicionou suporte para [dispositivos dobráveis][1] no Android.
Isso exigiu a adição de uma dependência AndroidX à incorporação do Flutter, que
requer que os aplicativos usem Kotlin 1.5.31 ou superior.

## Descrição da mudança

Um aplicativo Flutter compilado para Android agora inclui a dependência Gradle
`androidx.window:window-java`.

## Guia de migração

Abra `<app-src>/android/build.gradle` e altere `ext.kotlin_version`:

```groovy diff
  buildscript {
-     ext.kotlin_version = '1.3.50'
+     ext.kotlin_version = '1.5.31'
```

## Cronograma

Implementado na versão: v2.9.0 beta<br>
Na versão estável: 2.10

## Referências

PR relevante:

* [PR 29585: Suporte a Display Features][]


[PR 29585: Suporte a Display Features]: {{site.repo.engine}}/pull/29585

[1]: {{site.android-dev}}/guide/topics/large-screens/learn-about-foldables

