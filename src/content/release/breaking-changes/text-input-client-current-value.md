---
title: TextInputClient currentTextEditingValue
description: >
  Adiciona um novo campo à interface TextInputClient para
  obter o TextEditingValue atual de um cliente.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

Adiciona um campo, `currentTextEditingValue`, à interface `TextInputClient`
para obter o valor atual de um campo de texto editável
de um cliente de plataforma.

## Contexto

A classe `TextInputClient` é usada pelo framework Flutter para
comunicar com código de plataforma sobre o estado atual de widgets
de entrada de texto como `EditableText`.

O lado da plataforma pode perder seu estado quando um app Android
vai para o background. A partir desta mudança,
o app pode pedir ao framework pelo último estado conhecido.
Para obter esta informação,
o `TextEditingValue` foi exposto para o `TextInputClient`.

## Descrição da mudança

Em algumas plataformas suportadas, a aplicação pode ser movida para
o background onde é esperado que consuma menos recursos.
Por exemplo, uma aplicação em background no Android deve evitar consumir
memória desnecessária e não tem necessidade de manter referências a views.
Antes desta mudança, o código de plataforma específico do Android podia
perder informações de estado sobre campos de texto editáveis quando
o app voltava para o foreground.
Isso é visto, por exemplo,
quando texto digitado em um widget `TextField` é perdido para
o código Java, mas ainda é lembrado no código Dart.

A partir desta mudança,
o lado da plataforma agora envia uma mensagem de canal `textInput`
chamada `TextInput.requestExistingState`.
Isso notifica o código Dart que, quando o app acorda,
ele deve re-estabelecer quaisquer conexões de entrada de texto
e notificar a plataforma de seu estado de edição
mais recentemente conhecido.

A classe `TextInput` interage com widgets cliente usando
a interface `TextInputClient`. Esta interface anteriormente
não fornecia nenhuma visão do valor atual que um cliente tinha.
Para permitir que a classe `TextInput` responda apropriadamente a
`TextInput.requestExistingState`, um novo getter foi adicionado a
`TextInputClient` chamado `currentTextEditingValue`.
Você não pode usar com segurança o último valor passado para
`TextInputConnection.setEditingState`, já que o cliente
só chama esse método sob circunstâncias específicas,
como quando código Dart modifica diretamente o valor de um
`TextEditingController` de uma forma que não espelha diretamente
o tratamento nativo da plataforma de uma resposta a um evento de entrada de tecla.
É assim que um `TextInputFormatter` geralmente funciona,
ou o que acontece quando código Dart define diretamente
`TextEditingController.value`.

## Guia de migração

Se você implementou ou estendeu `TextEditingClient` anteriormente,
você deve agora adicionar o override apropriado para `currentTextEditingValue`.

Este valor pode ser null.

Se você quer migrar _antes_ desta mudança ser lançada,
você pode adicionar uma classe à sua classe
similar ao seguinte:

```dart
abstract class _TemporaryTextEditingClient {
  TextEditingValue get currentTextEditingValue;
}
```

Isso permite que você adicione o novo membro com uma
anotação `@override` antes da mudança ser lançada
no framework. Mais tarde, você pode remover a
definição de interface temporária.

Código antes da migração:

```dart
class _MyCustomTextWidgetState extends State<MyCustomWidget> implements TextEditingClient {
  ...

  @override
  void updateEditingValue(TextEditingValue value) {
    ...
  }

  @override
  void performAction(TextInputAction action) {
    ...
  }

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) {
    ...
  }
}
```

Código após a migração:

```dart
class _MyCustomTextWidgetState extends State<MyCustomWidget> implements TextEditingClient {
  ...

  @override
  TextEditingValue get currentTextEditingValue => widget.textEditingController.value;

  @override
  void updateEditingValue(TextEditingValue value) {
    ...
  }

  @override
  void performAction(TextInputAction action) {
    ...
  }

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) {
    ...
  }
}
```

## Linha do tempo

Lançado na versão: 1.16.3<br>
Na versão estável: 1.17

## Referências

Documentação da API:

* [`TextInput`][]
* [`TextInputClient`][]
* [`EditableText`][]
* [`SystemChannels.textInput`][]

Issue relevante:

* [Issue 47137][]

PR relevante:

* [Fix requestExistingInputState response][]


[`EditableText`]: {{site.api}}/flutter/widgets/EditableText-class.html
[Fix requestExistingInputState response]: {{site.repo.flutter}}/pull/47472
[Issue 47137]: {{site.repo.flutter}}/issues/47137
[`TextInput`]: {{site.api}}/flutter/services/TextInput-class.html
[`TextInputClient`]: {{site.api}}/flutter/services/TextInputClient-class.html
[`SystemChannels.textInput`]: {{site.api}}/flutter/services/SystemChannels/textInput-constant.html
