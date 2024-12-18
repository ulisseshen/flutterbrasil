---
ia-translate: true
title: Descontinuação da criação de aplicativos e plugins com Android v1 embedding
description: Descontinuação gradual do Android v1 embedding.
---

## Resumo

Os templates do `flutter create` para aplicativos e plugins
não criam mais o wrapper Android baseado no
v1 Android embedding como parte do nosso processo gradual de
descontinuação do Android v1 embedding, descrito no nosso
[Resumo da Migração do Android][].

Projetos de aplicativos usando o v1 Android embedding
são encorajados a migrar seguindo os passos descritos em
[Atualizando projetos Android pré-1.12][].

Plugins que têm como alvo o v1 Android embedding são encorajados
a migrar seguindo as instruções em
[Suportando as novas APIs de plugins Android][].

[Resumo da Migração do Android]: /go/android-migration-summary
[Atualizando projetos Android pré-1.12]: {{site.repo.flutter}}/blob/master/docs/platforms/android/Upgrading-pre-1.12-Android-projects.md
[Suportando as novas APIs de plugins Android]: /release/breaking-changes/plugin-api-migration

## Contexto

Na versão 1.12 do Flutter, lançamos um conjunto v2 de
APIs Android baseadas no pacote [`io.flutter.embedding`][]
para habilitar o fluxo de trabalho [add-to-app][]
no Android.

Com o tempo, descontinuamos gradualmente os antigos
v1 Android embeddings baseados no pacote
[`io.flutter.app`][].

No 2º trimestre de 2020, apenas 26% dos aplicativos usavam os v1 embeddings.

Como os v2 embeddings foram fortemente estabelecidos ao longo de
7 meses desde o lançamento do Flutter v1.12,
desabilitamos a criação de novos projetos de aplicativos e plugins
usando os v1 embeddings.

[add-to-app]: /add-to-app
[`io.flutter.embedding`]: https://cs.opensource.google/flutter/engine/+/master:shell/platform/android/io/flutter/embedding/
[`io.flutter.app`]: https://cs.opensource.google/flutter/engine/+/master:shell/platform/android/io/flutter/app/.

## Descrição da mudança

O comando `flutter config` não tem mais um
flag alternável `enable-android-embedding-v2`
(que era `true` por padrão desde a v1.12).
Todos os projetos criados com `flutter create`
e `flutter create -t plugin` usam exclusivamente o
Android v2 embedding.

Aplicativos v1 existentes continuam funcionando.

Aplicativos v1 existentes que consomem plugins agora recebem
um aviso solicitando a migração para o v2 embedding.

Aplicativos v1 existentes que consomem um plugin que tem como alvo
apenas o v2 embedding não serão compilados e devem migrar.
Este tem sido o caso desde a v1.12. No entanto,
a probabilidade de encontrar isso aumenta à medida que
os desenvolvedores de plugins criam e publicam plugins apenas v2.

Aplicativos v2 existentes continuam funcionando com ou sem
plugins.

Aplicativos v2 existentes que consomem plugins que têm como alvo
apenas o v1 embedding continuam a receber um aviso.
A probabilidade de encontrar isso diminui
à medida que os desenvolvedores de plugins criam e publicam plugins v2.

## Guia de migração

Para mais informações,
veja [Atualizando projetos Android pré-1.12][].

## Cronograma

Implementado na versão: 1.20.0-8.0<br>
Na versão estável: 1.22
