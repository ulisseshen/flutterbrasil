---
ia-translate: true
title: Cliente de Entrada de Texto Scribble
description: >
  Adiciona novos métodos à interface TextInputClient para permitir que o Scribble
  insira ou remova espaços reservados de texto e mostre a barra de ferramentas.
---

## Resumo

Adiciona três métodos, `showToolbar`, `insertTextPlaceholder` e
`removeTextPlaceholder` à interface `TextInputClient` para permitir que o recurso
Scribble do iOS 14 insira e remova espaços reservados de texto e mostre a barra
de ferramentas.

## Contexto

A partir do iOS 14, iPads suportam o recurso Scribble ao usar o Apple Pencil.
Este recurso permite que os usuários usem o lápis para interagir com campos de
texto para adicionar, excluir, selecionar e modificar o texto.

## Descrição da mudança

Em widgets de texto nativos, a barra de ferramentas de texto é mostrada quando
um usuário usa o lápis para selecionar texto em um iPad executando iOS 14 ou
superior. Para replicar esse comportamento, a plataforma envia uma mensagem de
canal `textInput` chamada `TextInputClient.showToolbar`. Isso notifica o código
Dart que a barra de ferramentas deve ser mostrada.

Quando um usuário mantém o lápis pressionado, uma lacuna visual no texto é
mostrada para permitir que o usuário tenha espaço extra para escrever. Para
replicar esse comportamento, a plataforma envia mensagens de canal `textInput`
chamadas `TextInputClient.insertTextPlaceholder` e
`TextInputClient.removeTextPlaceholder`. As entradas de texto multilinha devem
ter espaços reservados que fornecem espaço vertical, enquanto as entradas de
linha única devem fornecer espaço horizontal.

## Guia de migração

Se você implementou anteriormente `TextEditingClient`, você deve substituir
`showToolbar`, `insertTextPlaceholder` e `removeTextPlaceholder` para suportar
esses recursos do Scribble ou fornecer uma implementação vazia.

Para migrar, implemente `showToolbar`, `insertTextPlaceholder` e
`removeTextPlaceholder`.

Código antes da migração:

```dart
class MyCustomTextInputClient implements TextInputClient {
  ...
}
```

Código após a migração:

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

## Linha do tempo

Incluído na versão: 2.9.0-1.0.pre<br>
Na versão estável: 2.10

## Referências

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
