---
title: O widget Form não suporta mais ser um sliver.
description: >-
  O widget Form agora inclui um widget Semantics,
  o que impede que ele seja usado diretamente como sliver.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Anteriormente, o widget Form atuava essencialmente como um wrapper direto
do seu filho. Esse design permitia que um Form contendo um filho sliver
(por exemplo, Form(child: outro sliver)) fosse tratado como um sliver
dentro de um CustomScrollView ou de um pai rolável semelhante.

No entanto, este PR introduziu um novo widget Semantics
na estrutura interna do widget Form. Essa mudança altera
o comportamento de renderização, o que significa que Form não pode mais
funcionar diretamente como um sliver.

## Contexto {:#context}

Esta mudança faz parte de um esforço contínuo para melhorar a
acessibilidade e a compreensão semântica dos widgets do Flutter.
Ao incorporar um widget Semantics diretamente em Form, o framework
pode fornecer informações melhores aos serviços de acessibilidade.

## Descrição da mudança {:#description-of-change}

A mudança principal é a integração de um widget Semantics
ao método build do widget Form.

## Guia de migração {:#migration-guide}

Se o seu app não usa atualmente o widget Form diretamente
como sliver dentro de uma lista rolável
(por exemplo, como filho direto da propriedade slivers de um CustomScrollView),
então nenhuma alteração é necessária.

Se o seu app usa Form como sliver, você precisará envolver o widget Form
em um SliverToBoxAdapter. SliverToBoxAdapter é um
sliver que contém um único widget de caixa, convertendo um
widget comum em um sliver que pode ser colocado em um CustomScrollView.

Código antes da migração:

```dart
sliver: Form(
    key: controller.formKey,
    child: SomeWidgetWithFormFields(),
)
```

Código após a migração:

```dart
sliver: SliverToBoxAdapter(
    child: Form(
        key: controller.formKey,
        child: SomeWidgetWithFormFields(),
    )
)
```

## Linha do tempo {:#timeline}

Incluído na versão: 3.35.0-pre<br>
Na versão estável: 3.35

## Referências {:#references}

Documentação da API:

* [`Form`]({{site.api}}/flutter/widgets/Form-class.html)

Issues relevantes:

* [Issue 161628]({{site.repo.flutter}}/issues/161628)

PRs relevantes:

* [PR 170709: Adiciona papel de semântica para form]({{site.repo.flutter}}/pull/170709)
