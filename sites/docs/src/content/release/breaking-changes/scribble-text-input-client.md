---
title: Cliente de entrada de texto Scribble
description: >
  Adiciona novos métodos à interface TextInputClient para permitir que o Scribble
  insira ou remova placeholders de texto e exiba a barra de ferramentas.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Adiciona três métodos, `showToolbar`, `insertTextPlaceholder` e
`removeTextPlaceholder`, à interface `TextInputClient` para permitir que o
recurso Scribble do iOS 14 insira e remova placeholders de texto e exiba a
barra de ferramentas.

## Contexto {:#background}

A partir do iOS 14, os iPads oferecem suporte ao recurso Scribble ao usar o
Apple Pencil. Esse recurso permite que o usuário use a caneta para interagir
com campos de texto e adicionar, apagar, selecionar e modificar texto.

## Descrição da mudança {:#change-description}

Em widgets de texto nativos, a barra de ferramentas de texto é exibida quando
o usuário usa a caneta para selecionar texto em um iPad com iOS 14 ou superior.
Para replicar esse comportamento, a plataforma envia uma mensagem do canal
`textInput` chamada `TextInputClient.showToolbar`. Isso notifica o código Dart
de que a barra de ferramentas deve ser exibida.

Quando o usuário pressiona a caneta, um espaço visual é exibido no texto para
dar ao usuário espaço extra para escrever. Para replicar esse comportamento, a
plataforma envia mensagens do canal `textInput` chamadas
`TextInputClient.insertTextPlaceholder` e
`TextInputClient.removeTextPlaceholder`. Entradas de texto multilinha devem ter
placeholders que forneçam espaço vertical, enquanto entradas de linha única
devem fornecer espaço horizontal.

## Guia de migração {:#migration-guide}

Se você já implementava `TextEditingClient`, precisa sobrescrever
`showToolbar`, `insertTextPlaceholder` e `removeTextPlaceholder`, para oferecer
suporte a esses recursos do Scribble ou fornecer uma implementação vazia.

Para migrar, implemente `showToolbar`, `insertTextPlaceholder` e
`removeTextPlaceholder`.

Código antes da migração:

```dart
class MyCustomTextInputClient implements TextInputClient {
  ...
}
```

Código depois da migração:

```dart
class MyCustomTextInputClient implements TextInputClient {
  ...
  @override
  void showToolbar() {
    ...
  }

  @override
  void insertTextPlaceholder(Size size) {
    ...
  }

  @override
  void removeTextPlaceholder() {
    ...
  }
}
```

## Linha do tempo {:#timeline}

Incluído na versão: 2.9.0-1.0.pre<br>
Na versão estável: 2.10

## Referências {:#references}

Documentação da API:

* [`TextInputClient`]({{site.api}}/flutter/services/TextInputClient-class.html)

Issues relevantes:

* [Issue 61278]({{site.repo.flutter}}/issues/61278)

PRs relevantes:

* [24224: Support Scribble Handwriting (engine)][]
* [75472: Support Scribble Handwriting][]
* [97437: Re-land Support Scribble Handwriting][]

[24224: Support Scribble Handwriting (engine)]: {{site.repo.engine}}/pull/24224
[97437: Re-land Support Scribble Handwriting]: {{site.repo.flutter}}/pull/97437
[75472: Support Scribble Handwriting]: {{site.repo.flutter}}/pull/75472
