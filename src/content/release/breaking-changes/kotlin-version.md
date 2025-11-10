---
ia-translate: true
title: Versão obrigatória do Kotlin
description: >
    Apps Flutter construídos para a plataforma Android
    agora exigem Kotlin 1.5.31 ou superior.
---

{% render "docs/breaking-changes.md" %}

:::important
A partir do Flutter 3.16, os scripts padrão de compilação do Gradle
diferem entre versões do Flutter. Por exemplo, a versão do Kotlin
agora é configurada no arquivo `android/settings.gradle`.
Se você gerou seu projeto com uma versão mais antiga do Flutter,
é aconselhável atualizar seus scripts de compilação para a forma mais recente.
Para mais informações, consulte [Issue 10380][Issue 10380] e [Issue 135392][Issue 135392].
:::

[Issue 10380]:  {{site.github}}/flutter/website/issues/10380
[Issue 135392]: {{site.github}}/flutter/flutter/issues/135392

## Resumo

Para compilar um app Flutter para Android, é necessário o Kotlin 1.5.31 ou superior.

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

Flutter adicionou suporte para [dispositivos dobráveis][1] no Android.
Isso exigiu adicionar uma dependência do AndroidX ao embedding do Flutter que
requer que os apps usem Kotlin 1.5.31 ou superior.

## Descrição da mudança

Um app Flutter compilado para Android agora inclui a dependência do Gradle
`androidx.window:window-java`.

## Guia de migração

Abra `<app-src>/android/build.gradle` e altere `ext.kotlin_version`:

```groovy diff
  buildscript {
-     ext.kotlin_version = '1.3.50'
+     ext.kotlin_version = '1.5.31'
```

## Cronograma

Incluído na versão: v2.9.0 beta<br>
Lançamento estável: 2.10

## Referências

PR relevante:

* [PR 29585: Display Features support][PR 29585: Display Features support]


[PR 29585: Display Features support]: {{site.repo.engine}}/pull/29585

[1]: {{site.android-dev}}/guide/topics/large-screens/learn-about-foldables
