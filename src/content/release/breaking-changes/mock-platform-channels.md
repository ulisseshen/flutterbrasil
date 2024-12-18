---
ia-translate: true
title: Transição das interfaces de teste de canais de plataforma para o pacote flutter_test
description: >
   Os métodos setMockMessageHandler relacionados às APIs foram movidos
   do package:flutter para o package:flutter_test
---

## Sumário

Os seguintes métodos foram substituídos por APIs no pacote
`flutter_test`:

* `BinaryMessenger.checkMessageHandler`
* `BinaryMessenger.setMockMessageHandler`
* `BinaryMessenger.checkMockMessageHandler`
* `BasicMessageChannel.setMockMessageHandler`
* `MethodChannel.checkMethodCallHandler`
* `MethodChannel.setMockMethodCallHandler`
* `MethodChannel.checkMockMethodCallHandler`

O callback `onPlatformMessage` não é mais usado
pelo framework Flutter.

## Contexto

Como parte de uma refatoração da arquitetura de comunicação de plugin
de baixo nível, passamos da lógica anterior
`onPlatformMessage`/`handlePlatformMessage` para um sistema de
buffering por canal implementado no engine na classe
`ChannelBuffers`. Para manter a compatibilidade com o código
existente, a API existente `BinaryMessenger.setMessageHandler`
foi refatorada para usar a nova API `ChannelBuffers`.

Uma diferença entre a API `ChannelBuffers` e a
API anterior é que a nova API é mais consistente em sua
abordagem à assincronia. Como efeito colateral,
as APIs em torno da passagem de mensagens agora são inteiramente
assíncronas.

Isso representou um problema para a implementação das APIs de teste
legadas que, por razões históricas, estavam anteriormente no
pacote `flutter`. Como elas dependiam da lógica subjacente sendo
parcialmente síncrona, elas exigiram refatoração.
Para evitar adicionar ainda mais lógica de teste no pacote
`flutter`, foi tomada a decisão de mover essa lógica para o pacote
`flutter_test`.

## Descrição da mudança

Especificamente, as seguintes APIs foram afetadas:

* `BinaryMessenger.checkMessageHandler`: Obsoleto.
* `BinaryMessenger.setMockMessageHandler`: Substituído por
   `TestDefaultBinaryMessenger.setMockMessageHandler`.
* `BinaryMessenger.checkMockMessageHandler`: Substituído
   por `TestDefaultBinaryMessenger.checkMockMessageHandler`.
* `BasicMessageChannel.setMockMessageHandler`: Substituído
   por `TestDefaultBinaryMessenger.setMockDecodedMessageHandler`.
* `MethodChannel.checkMethodCallHandler`: Obsoleto.
* `MethodChannel.setMockMethodCallHandler`: Substituído por
   `TestDefaultBinaryMessenger.setMockMethodCallHandler`.
* `MethodChannel.checkMockMethodCallHandler`: Substituído
   por `TestDefaultBinaryMessenger.checkMockMessageHandler`.

Essas substituições estão disponíveis apenas para o código que
utiliza o novo `TestDefaultBinaryMessengerBinding`
(como qualquer código que use `testWidgets` em um teste
`flutter_test`). Não há substituição para o código de produção que
estava usando essas APIs, pois elas não se destinavam ao uso em
código de produção.

Testes que usam `checkMessageHandler` não têm equivalente na nova
API, já que o registro do manipulador de mensagens é tratado
diretamente pelo objeto `ChannelBuffers`, que não expõe o listener
atualmente registrado para um canal. (Testes que verificam o
registro do manipulador parecem ser raros.)

O código que precisa ser migrado pode ver erros como os seguintes:

```plaintext
  error - O método 'setMockMessageHandler' não está definido para o tipo 'BinaryMessenger' em test/sensors_test.dart:64:8 - (undefined_method)

  error • O método 'setMockMethodCallHandler' não está definido para o tipo 'MethodChannel' • test/widgets/editable_text_test.dart:5623:30 • undefined_method

[error] O método 'setMockMessageHandler' não está definido para o tipo 'BasicMessageChannel' (test/material/feedback_test.dart:37:36)
```

Além disso, o callback `onPlatformMessage`, que anteriormente era
conectado pelo framework para receber mensagens de plugins, não é
mais usado (e será removido em breve). Como resultado,
chamar esse callback para injetar mensagens no framework não tem mais
efeito.

## Guia de migração

O pacote `flutter_test` fornece alguns shims para que
o uso dos métodos obsoletos `setMock...` e `checkMock...`
continue funcionando. Testes que anteriormente não importavam
`package:flutter_test/flutter_test.dart` podem
fazê-lo para habilitar esses shims;
isso deve ser suficiente para migrar a maior parte do código.

Essas APIs de shim estão obsoletas, no entanto. Em vez disso,
no código que usa `WidgetTester` (por exemplo, usando `testWidgets`),
é recomendado usar os seguintes padrões para
substituir as chamadas para esses métodos
(onde `tester` é a instância `WidgetTester`):

```dart
// código antigo
ServicesBinding.defaultBinaryMessenger.setMockMessageHandler(...);
ServicesBinding.defaultBinaryMessenger.checkMockMessageHandler(...);
// código novo
tester.binding.defaultBinaryMessenger.setMockMessageHandler(...);
tester.binding.defaultBinaryMessenger.checkMockMessageHandler(...);
```

```dart
// código antigo
myChannel.setMockMessageHandler(...);
myChannel.checkMockMessageHandler(...);
// código novo
tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler(myChannel, ...);
tester.binding.defaultBinaryMessenger.checkMockMessageHandler(myChannel, ...);
```

```dart
// código antigo
myMethodChannel.setMockMethodCallHandler(...);
myMethodChannel.checkMockMethodCallHandler(...);
// código novo
tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(myMethodChannel, ...);
tester.binding.defaultBinaryMessenger.checkMockMessageHandler(myMethodChannel, ...);
```

Testes que usam `package:test` e `test()`
podem ser alterados para usar `package:flutter_test` e `testWidgets()`
para obter acesso a um `WidgetTester`.

O código que não tem acesso a um `WidgetTester` pode se referir a
`TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger`
em vez de `tester.binding.defaultBinaryMessenger`.

Testes que não usam o binding de widgets de teste padrão
(`AutomatedTestWidgetsFlutterBinding`,
que é inicializado por `testWidgets`) podem mixar o
mixin `TestDefaultBinaryMessengerBinding` em seu
binding para obter os mesmos resultados.

Testes que manipulam `onPlatformMessage` não funcionarão mais
como projetado. Para enviar mensagens mock para o framework,
considere usar `ChannelBuffers.push`.
Não há mecanismo para interceptar mensagens dos plugins
e encaminhá-las para o framework na nova API.
Se seu caso de uso exigir tal mecanismo, por favor, registre um bug.

## Cronograma

Implementado na versão: 2.3.0-17.0.pre.1<br>
Na versão estável: 2.5

## Referências

Documentação da API:

* [`TestDefaultBinaryMessenger`][]
* [`TestDefaultBinaryMessengerBinding`][]

PR relevante:

* [PR #76288: Migrar para ChannelBuffers.push][]

[`TestDefaultBinaryMessenger`]: {{site.api}}/flutter/flutter_test/TestDefaultBinaryMessenger-class.html
[`TestDefaultBinaryMessengerBinding`]: {{site.api}}/flutter/flutter_test/TestDefaultBinaryMessengerBinding-mixin.html

[PR #76288: Migrar para ChannelBuffers.push]: {{site.repo.flutter}}/pull/76288
