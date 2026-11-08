---
ia-translate: true
title: Threads mescladas no macOS e Windows
description: >-
  Aprenda sobre mudanças de threading no macOS e Windows no Flutter 3.35.
---

{% render "docs/breaking-changes.md" %}

## Resumo

O Flutter 3.35 mescla as threads de UI e de plataforma por padrão no macOS e Windows.

## Contexto

Originalmente, o Flutter tinha threads separadas para produzir frames de UI e para
interagir com a plataforma nativa.

O design de threads separadas impedia que apps e plugins Flutter usassem Dart FFI
para interoperar com APIs nativas que devem ser chamadas na thread da plataforma.

## Descrição da mudança

O Flutter 3.35 mescla as threads de UI e de plataforma por padrão no macOS e Windows.

Isso espelha iOS e Android, cujas threads foram mescladas por padrão no
Flutter 3.29.

## Guia de migração

As threads mescladas não devem afetar seu app.

Se você suspeitar que as threads mescladas causaram uma regressão no seu app, entre em contato em
[Issue 150525][Issue 150525].

## Linha do tempo

Disponível na versão: 3.33.0-0.0.pre<br>
Na versão estável: 3.35

## Referências

Issue relevante:

* [Issue 150525][Issue 150525]

PRs relevantes:

* [PR 166536][PR 166536]
* [PR 167472][PR 167472]

[Issue 150525]: {{site.repo.flutter}}/issues/150525
[PR 166536]: {{site.repo.flutter}}/pull/166536
[PR 167472]: {{site.repo.flutter}}/pull/167472
