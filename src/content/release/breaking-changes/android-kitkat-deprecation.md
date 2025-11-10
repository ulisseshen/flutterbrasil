---
title: Descontinuando suporte para Android KitKat
description: >-
  O Flutter está aumentando a versão mínima suportada do Android de
  KitKat (API 19) para Lollipop (API 21).
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

A versão mínima suportada do Android pelo Flutter agora é Lollipop (API 21).
Começando com o lançamento estável 3.22 do Flutter,
o Flutter não funcionará mais em dispositivos executando Android KitKat (API 19).

## Context

O contexto, propósito e descrição desta descontinuação podem ser encontrados no
documento de design [go/rfc-android-k-deprecation][].

## Migration guide

Desenvolvedores Flutter direcionando Android precisarão aumentar o
`minSdkVersion` nos seus arquivos `build.gradle` e `AndroidManifest.xml`
de `19` para pelo menos `21`.

## Timeline

No lançamento estável: 3.22

[go/rfc-android-k-deprecation]: {{site.main-url}}/go/rfc-android-k-deprecation
