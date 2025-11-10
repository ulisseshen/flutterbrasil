---
title: Flutter agora define `abiFilters` padrão em builds Android
description: >-
  O Flutter Gradle Plugin agora configura automaticamente abiFilters
  para builds Android, o que pode quebrar configurações personalizadas de abiFilters.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

A partir do Flutter 3.35, o Flutter Gradle Plugin define automaticamente
[`abiFilters`][] para builds Android para evitar a inclusão de arquiteturas
não suportadas em APKs de release. Esta alteração pode quebrar
`abiFilters` personalizados especificados no arquivo `build.gradle` do seu aplicativo.

## Contexto

Esta alteração foi introduzida para resolver um problema em que dependências
de terceiros com bibliotecas nativas x86 fariam o Google Play
identificar incorretamente aplicativos Flutter como suportando dispositivos x86. Quando usuários
com dispositivos x86 instalavam esses aplicativos, eles travavam em tempo de execução
porque as bibliotecas nativas do Flutter não estão disponíveis para x86.

O Flutter Gradle Plugin agora configura automaticamente `abiFilters` para
incluir apenas as arquiteturas que o Flutter suporta. Isso impede
o Google Play de disponibilizar aplicativos para dispositivos incompatíveis.

## Descrição da alteração

O Flutter Gradle Plugin agora define programaticamente `abiFilters` para
builds não-debuggable quando a opção `--splits-per-abi` não está habilitada
por padrão para:
- `armeabi-v7a`
- `arm64-v8a`
- `x86_64`

Como essa configuração automática acontece antes dos seus arquivos `build.gradle`
serem processados, ela pode quebrar configurações personalizadas de `abiFilters` que dependem do
conjunto estar vazio.

## Guia de migração
Se seu aplicativo não personaliza `abiFilters`, nenhuma alteração é necessária.

Se seu aplicativo precisa personalizar quais arquiteturas são incluídas, você tem
várias opções:

### Opção 1: Use a flag splits-per-abi

Se você quiser controlar a inclusão de arquitetura, use a opção integrada do Flutter
`--splits-per-abi` em vez de configurar manualmente `abiFilters`:

```console
flutter build apk --splits-per-abi
```

Isso cria APKs separados para cada arquitetura e automaticamente desabilita
a configuração automática de `abiFilters`.

### Opção 2: Limpar e reconfigurar abiFilters

Se você deve usar um único APK com filtros de arquitetura personalizados, limpe os
filtros definidos automaticamente e configure os seus próprios no seu `build.gradle`.
Por exemplo:

```kotlin
android {
    buildTypes {
        release {
            // Clear the automatically set filters.
            ndk.abiFilters.clear()
            // Set your custom filters.
            ndk.abiFilters.addAll(listOf("arm64-v8a"))
        }
    }
}
```

## Linha do tempo

Disponibilizado na versão: 3.35.0<br>
Na versão estável: 3.35

Issues relevantes:
* [Issue #174004]({{site.repo.flutter}}/issues/174004)
* [Issue #153476]({{site.repo.flutter}}/issues/153476)

PRs relevantes:
* [PR #168293]({{site.repo.flutter}}/pull/168293)

[`abiFilters`]: https://developer.android.com/reference/tools/gradle-api/8.7/com/android/build/api/dsl/Ndk#abiFilters()
