---
ia-translate: true
title: Threads unificadas no Linux
description: >-
  Saiba sobre as mudanças de threads no Linux no Flutter 3.39.
---

## Resumo {:#summary}

O Flutter 3.39 unifica, por padrão, as threads de UI e de plataforma no Linux.

## Contexto {:#context}

Originalmente, o Flutter tinha threads separadas para produzir os frames da UI e
para interagir com a plataforma nativa.

O design de threads separadas impedia que apps e plugins Flutter usassem o Dart FFI
para interoperar com APIs nativas que precisam ser chamadas na thread de plataforma.

## Descrição da mudança {:#description-of-change}

A versão 3.39 do Flutter unifica, por padrão, as threads de UI e de plataforma no Linux.

Isso segue o que já acontece em todas as outras plataformas, cujas threads foram
unificadas por padrão no Flutter 3.29 (iOS e Android) e 3.35 (macOS e Windows).

## Guia de migração {:#migration-guide}

Threads unificadas não devem afetar o seu app.

Se você suspeitar que as threads unificadas causaram regressões no seu app,
entre em contato na [Issue 150525][Issue 150525].

## Linha do tempo {:#timeline}

Incluído na versão: 3.39.0-0.1.pre<br>
Na versão estável: 3.41

## Referências {:#references}

Issue relevante:

* [Issue 150525][Issue 150525]

PRs relevantes:

* [PR 176759][PR 176759]

[Issue 150525]: {{site.repo.flutter}}/issues/150525
[PR 176759]: {{site.repo.flutter}}/pull/176759
