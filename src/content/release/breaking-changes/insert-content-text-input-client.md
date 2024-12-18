---
ia-translate: true
title: Inserir conteúdo de texto do cliente
description: >
  Adicione um novo método à interface TextInputClient para permitir que
  teclados virtuais Android insiram conteúdo rich em TextFields Flutter.
---

## Sumário

Adicionado um método `insertContent` à interface `TextInputClient` para permitir que o recurso de teclado de imagem do Android insira conteúdo em um `TextField` do Flutter.

## Contexto

A partir do Android 7.1, os IMEs (editores de método de entrada ou teclados virtuais) podem enviar imagens e conteúdo rich para um editor de texto. Isso permite que os usuários insiram gifs, stickers ou conteúdo rich sensível ao contexto em um campo de texto.

## Descrição da mudança

Quando o usuário insere conteúdo rich no IME, a plataforma envia uma mensagem de canal `TextInputClient.commitContent`, notificando o código Dart de que o IME inseriu conteúdo rich. A mensagem do canal contém o tipo MIME, URI e bytedata para o conteúdo inserido em formato JSON.

## Guia de migração

Se você implementou a interface `TextInputClient` anteriormente, substitua `insertContent` para suportar a inserção de conteúdo rich ou forneça uma implementação vazia.

Para migrar, implemente `insertContent`.

Código antes da migração:

```dart
class MyCustomTextInputClient implements TextInputClient {
  // ...
}
```

Código após a migração:

```dart
class MyCustomTextInputClient implements TextInputClient {
  // ...
  @override
  void insertContent() {
    // ...
  }
  // ...
}
```

Sua implementação de `TextInputClient` pode não exigir a capacidade de receber conteúdo rich inserido do IME. Nesse caso, você pode deixar a implementação de `insertContent` vazia sem consequências.

```dart
class MyCustomTextInputClient implements TextInputClient {
  // ...
  @override
  void insertContent() {}
  // ...
}
```

Como alternativa, você pode usar uma implementação semelhante ao `TextInputClient` padrão. Para saber como fazer isso, confira a [implementação insertContent][].

Para evitar breaking changes em uma interface, use `with TextInputClient` em vez de `implements TextInputClient`.

[implementação insertContent]: {{site.api}}/flutter/services/TextInputClient/insertContent.html

## Cronograma

Implementado na versão: 3.8.0-1.0.pre<br>
Na versão estável: 3.10.0

## Referências

Documentação da API:

* [`TextInputClient`]({{site.api}}/flutter/services/TextInputClient-class.html)

Issue relevante:

* [Issue 20796]({{site.repo.flutter}}/issues/20796)

PRs relevantes:

* [24224: Suporte à Inserção de Imagem no Android (engine)]({{site.repo.engine}}/pull/35619)
* [97437: Suporte à Inserção de Imagem no Android]({{site.repo.flutter}}/pull/110052)
