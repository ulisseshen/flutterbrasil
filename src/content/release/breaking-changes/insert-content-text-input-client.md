---
title: Inserção de conteúdo no cliente de entrada de texto
description: >
  Adiciona um novo método à interface TextInputClient para permitir
  que teclados virtuais Android insiram conteúdo rico em TextFields Flutter.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Foi adicionado um método `insertContent` à interface `TextInputClient` para
permitir que o recurso de teclado de imagem do Android
insira conteúdo em um `TextField` Flutter.

## Contexto {:#context}

A partir do Android 7.1, IMEs (editores de método de entrada ou teclados virtuais) podem enviar
imagens e conteúdo rico para um editor de texto.
Isso permite que os usuários insiram gifs, adesivos ou
conteúdo rico contextual em um campo de texto.

## Descrição da mudança {:#description-of-change}

Quando o usuário insere conteúdo rico no IME, a plataforma
envia uma mensagem de canal `TextInputClient.commitContent`,
notificando o código Dart de que o IME inseriu conteúdo rico.
A mensagem de canal contém o tipo mime, URI e bytedata para
o conteúdo inserido em formato JSON.

## Guia de migração {:#migration-guide}

Se você implementou a interface `TextInputClient` anteriormente, sobrescreva
`insertContent` para suportar a inserção de conteúdo rico
ou forneça uma implementação vazia.

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

Sua implementação de `TextInputClient` pode não exigir
a capacidade de receber conteúdo rico inserido do IME.
Nesse caso, você pode deixar a implementação de
`insertContent` vazia sem consequências.

```dart
class MyCustomTextInputClient implements TextInputClient {
  // ...
  @override
  void insertContent() {}
  // ...
}
```

Como alternativa, você pode usar uma implementação similar à
do `TextInputClient` padrão.
Para saber como fazer isso, confira a [insertContent implementation][].

Para evitar mudanças quebradas em uma interface,
use `with TextInputClient` em vez de `implements TextInputClient`.

[insertContent implementation]: {{site.api}}/flutter/services/TextInputClient/insertContent.html

## Cronograma {:#timeline}

Implementado na versão: 3.8.0-1.0.pre<br>
Na versão estável: 3.10.0

## Referências {:#references}

Documentação da API:

* [`TextInputClient`]({{site.api}}/flutter/services/TextInputClient-class.html)

Issue relevante:

* [Issue 20796]({{site.repo.flutter}}/issues/20796)

PRs relevantes:

* [24224: Support Image Insertion on Android (engine)]({{site.repo.engine}}/pull/35619)
* [97437: Support Image Insertion on Android]({{site.repo.flutter}}/pull/110052)
