---
ia-translate: true
title: TextInputClient currentTextEditingValue
description: >
  Adiciona um novo campo à interface TextInputClient para
  obter o TextEditingValue atual de um cliente.
---

## Resumo

Adiciona um campo, `currentTextEditingValue`, à interface
`TextInputClient` para obter o valor atual de um campo de texto
editável a partir de um cliente de plataforma.

## Contexto

A classe `TextInputClient` é usada pelo framework Flutter para
comunicar com o código da plataforma sobre o estado atual de
widgets de entrada de texto como `EditableText`.

O lado da plataforma pode perder seu estado quando um aplicativo
Android vai para o segundo plano. A partir desta alteração, o
aplicativo pode solicitar ao framework o último estado conhecido.
Para obter essas informações, o `TextEditingValue` foi exposto
para o `TextInputClient`.

## Descrição da mudança

Em algumas plataformas suportadas, o aplicativo pode ser movido
para o segundo plano, onde espera-se que consuma menos recursos.
Por exemplo, um aplicativo em segundo plano no Android deve evitar
consumir memória desnecessária e não precisa manter referências
a views. Antes desta alteração, o código de plataforma específico
do Android poderia perder informações de estado sobre campos de
texto editáveis quando o aplicativo voltava para o primeiro plano.
Isso é visto, por exemplo, quando o texto inserido em um widget
`TextField` é perdido para o código Java, mas ainda é lembrado
no código Dart.

A partir desta mudança, o lado da plataforma agora envia uma
mensagem de canal `textInput` chamada `TextInput.requestExistingState`.
Isso notifica o código Dart que, quando o aplicativo é ativado, ele
deve restabelecer quaisquer conexões de entrada de texto e notificar
a plataforma sobre seu estado de edição conhecido mais recente.

A classe `TextInput` interage com os widgets clientes usando a
interface `TextInputClient`. Essa interface anteriormente não
fornecia nenhuma informação sobre o valor atual que um cliente
tinha. Para permitir que a classe `TextInput` responda
adequadamente a `TextInput.requestExistingState`, um novo getter
foi adicionado a `TextInputClient` chamado `currentTextEditingValue`.
Você não pode usar com segurança o último valor passado para
`TextInputConnection.setEditingState`, uma vez que o cliente
só chama esse método sob circunstâncias específicas, como quando o
código Dart modifica diretamente o valor de um `TextEditingController`
de uma maneira que não espelha diretamente o tratamento nativo da
plataforma de uma resposta a um evento de entrada de tecla. É assim
que um `TextInputFormatter` geralmente funciona, ou o que acontece
quando o código Dart define diretamente `TextEditingController.value`.

## Guia de migração

Se você implementou ou estendeu `TextEditingClient` anteriormente,
agora você deve adicionar a substituição apropriada para
`currentTextEditingValue`.

Este valor pode ser nulo.

Se você deseja migrar _antes_ que essa mudança seja implementada,
você pode adicionar uma classe à sua classe semelhante à seguinte:

```dart
abstract class _TemporaryTextEditingClient {
  TextEditingValue get currentTextEditingValue;
}
```

Isso permite que você adicione o novo membro com uma anotação
`@override` antes que a alteração seja implementada no framework.
Mais tarde, você pode remover a definição de interface temporária.

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

## Cronograma

Implementado na versão: 1.16.3<br>
Na versão estável: 1.17

## Referências

Documentação da API:

*   [`TextInput`][]
*   [`TextInputClient`][]
*   [`EditableText`][]
*   [`SystemChannels.textInput`][]

Issue relevante:

*   [Issue 47137][]

PR relevante:

*   [Fix requestExistingInputState response][]

[`EditableText`]: {{site.api}}/flutter/widgets/EditableText-class.html
[Fix requestExistingInputState response]: {{site.repo.flutter}}/pull/47472
[Issue 47137]: {{site.repo.flutter}}/issues/47137
[`TextInput`]: {{site.api}}/flutter/services/TextInput-class.html
[`TextInputClient`]: {{site.api}}/flutter/services/TextInputClient-class.html
[`SystemChannels.textInput`]: {{site.api}}/flutter/services/SystemChannels/textInput-constant.html
