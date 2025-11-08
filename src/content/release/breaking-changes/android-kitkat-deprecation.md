---
ia-translate: true
title: Descontinuando o suporte ao Android KitKat
description: >-
  O Flutter está elevando a versão mínima suportada do Android de
  KitKat (API 19) para Lollipop (API 21).
---

## Resumo

A versão mínima suportada do Android no Flutter agora é Lollipop (API 21).
A partir da versão stable 3.22 do Flutter,
o Flutter não funcionará mais em dispositivos executando Android KitKat (API 19).

## Contexto

O contexto, propósito e descrição desta descontinuação podem ser encontrados no
documento de design [go/rfc-android-k-deprecation][].

## Guia de migração

Desenvolvedores Flutter direcionando Android precisarão aumentar o
`minSdkVersion` em seus arquivos `build.gradle` e `AndroidManifest.xml`
de `19` para pelo menos `21`.

## Cronograma

Na versão stable: 3.22

[go/rfc-android-k-deprecation]: {{site.main-url}}/go/rfc-android-k-deprecation
