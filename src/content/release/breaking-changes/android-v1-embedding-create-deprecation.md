---
title: Depreciação da criação de apps e plugins com Android v1 embedding
description: Depreciação gradual do Android v1 embedding.
ia-translate: true
---

## Resumo

Os templates do `flutter create` para apps e plugins
não criam mais wrappers Android baseados no
v1 Android embedding como parte do nosso processo gradual de
depreciação do Android v1 embedding descrito em nosso
[Android Migration Summary][].

Projetos de aplicativos usando o v1 Android embedding
são encorajados a migrar seguindo os passos descritos em
[Upgrading pre 1.12 Android projects][].

Plugins direcionados ao v1 Android embedding são encorajados
a migrar seguindo as instruções em
[Supporting the new Android plugins APIs][].

[Android Migration Summary]: /go/android-migration-summary
[Upgrading pre 1.12 Android projects]: {{site.repo.flutter}}/blob/main/docs/platforms/android/Upgrading-pre-1.12-Android-projects.md
[Supporting the new Android plugins APIs]: /release/breaking-changes/plugin-api-migration

## Contexto

No Flutter versão 1.12, lançamos um conjunto v2 de
APIs Android baseadas no pacote [`io.flutter.embedding`][]
para habilitar o fluxo de trabalho [add-to-app][]
no Android.

Com o tempo, depreciamos gradualmente os
v1 Android embeddings mais antigos baseados no
pacote [`io.flutter.app`][].

Em Q2 2020, apenas 26% dos aplicativos usavam os v1 embeddings.

Como os v2 embeddings foram fortemente estabelecidos ao longo
dos 7 meses desde o lançamento do Flutter v1.12,
desabilitamos a criação de novos projetos de app e plugin
usando os v1 embeddings.

[add-to-app]: /add-to-app
[`io.flutter.embedding`]: https://cs.opensource.google/flutter/engine/+/master:shell/platform/android/io/flutter/embedding/
[`io.flutter.app`]: https://cs.opensource.google/flutter/engine/+/master:shell/platform/android/io/flutter/app/.

## Descrição da mudança

O comando `flutter config` não tem mais uma
flag alternável `enable-android-embedding-v2`
(que era padrão como true desde v1.12).
Todos os projetos criados com `flutter create`
e `flutter create -t plugin` usam exclusivamente o
Android v2 embedding.

Aplicativos v1 existentes continuam a funcionar.

Aplicativos v1 existentes consumindo plugins agora recebem
um aviso para migrar para v2 embedding.

Aplicativos v1 existentes consumindo um plugin que visa
apenas o v2 embedding não compilarão e devem migrar.
Este tem sido o caso desde v1.12. No entanto,
a probabilidade de encontrar isso aumenta conforme
desenvolvedores de plugins criam e publicam plugins apenas v2.

Aplicativos v2 existentes continuam a funcionar com ou sem
plugins.

Aplicativos v2 existentes consumindo plugins que apenas
visam o v1 embedding continuam a receber um aviso.
A probabilidade de encontrar isso diminui
conforme desenvolvedores de plugins criam e publicam plugins v2.

## Guia de migração

Para mais informações,
veja [Upgrading pre 1.12 Android projects][].

## Linha do tempo

Implementado na versão: 1.20.0-8.0<br>
Na versão estável: 1.22
