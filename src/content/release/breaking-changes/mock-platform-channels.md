---
title: Transição de interfaces de teste de canal de plataforma para o pacote flutter_test
description: >
   Os métodos relacionados à API setMockMessageHandler foram
   movidos de package:flutter para package:flutter_test
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

Os seguintes métodos foram substituídos por APIs
no pacote `flutter_test`:

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

Como parte de uma refatoração da arquitetura de comunicação de plugins de baixo nível,
mudamos da lógica anterior `onPlatformMessage`/`handlePlatformMessage`
para um sistema de buffer por canal implementado no
motor na classe `ChannelBuffers`.
Para manter a compatibilidade com o código existente,
a API `BinaryMessenger.setMessageHandler` existente
foi refatorada para usar a nova API `ChannelBuffers`.

Uma diferença entre a API `ChannelBuffers` e a
API anterior é que a nova API é mais consistente em
sua abordagem à assincronicidade. Como efeito colateral,
as APIs em torno da passagem de mensagens agora são totalmente assíncronas.

Isso representou um problema para a implementação das APIs de teste legadas,
que, por razões históricas,
estavam anteriormente no pacote `flutter`.
Como elas dependiam da lógica subjacente ser parcialmente síncrona,
elas exigiram refatoração.
Para evitar adicionar ainda mais lógica de teste no pacote `flutter`,
foi tomada a decisão de mover essa lógica para o pacote `flutter_test`.

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

Essas substituições estão disponíveis apenas para código usando o
novo `TestDefaultBinaryMessengerBinding`
(como qualquer código usando `testWidgets` em um teste `flutter_test`).
Não há substituição para código de produção que estava usando
essas APIs, pois elas não eram destinadas ao uso em código de produção.

Testes usando `checkMessageHandler` não têm equivalente na
nova API, já que o registro do manipulador de mensagens é tratado
diretamente pelo objeto `ChannelBuffers`, que não
expõe o ouvinte atualmente registrado para um canal.
(Testes verificando o registro do manipulador parecem ser raros.)

Código que precisa migração pode ver erros como os seguintes:

```plaintext
  error - The method 'setMockMessageHandler' isn't defined for the type 'BinaryMessenger' at test/sensors_test.dart:64:8 - (undefined_method)

  error • The method 'setMockMethodCallHandler' isn't defined for the type 'MethodChannel' • test/widgets/editable_text_test.dart:5623:30 • undefined_method

[error] The method 'setMockMessageHandler' isn't defined for the type 'BasicMessageChannel' (test/material/feedback_test.dart:37:36)
```

Além disso, o callback `onPlatformMessage`,
que anteriormente era conectado pelo framework para
receber mensagens de plugins, não é mais usado
(e será removido no devido tempo). Como resultado,
chamar esse callback para injetar mensagens no
framework não tem mais efeito.

## Guia de migração

O pacote `flutter_test` fornece alguns shims para que
usos dos métodos obsoletos `setMock...` e `checkMock...`
continuem a funcionar.
Testes que anteriormente não importavam
`package:flutter_test/flutter_test.dart` podem
fazê-lo para habilitar esses shims;
isso deve ser suficiente para migrar a maioria do código.

No entanto, essas APIs shim estão obsoletas. Em vez disso,
em código usando `WidgetTester` (por exemplo, usando `testWidgets`),
é recomendado usar os seguintes padrões para
substituir chamadas para esses métodos
(onde `tester` é a instância `WidgetTester`):

```dart
// old code
ServicesBinding.defaultBinaryMessenger.setMockMessageHandler(...);
ServicesBinding.defaultBinaryMessenger.checkMockMessageHandler(...);
// new code
tester.binding.defaultBinaryMessenger.setMockMessageHandler(...);
tester.binding.defaultBinaryMessenger.checkMockMessageHandler(...);
```

```dart
// old code
myChannel.setMockMessageHandler(...);
myChannel.checkMockMessageHandler(...);
// new code
tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler(myChannel, ...);
tester.binding.defaultBinaryMessenger.checkMockMessageHandler(myChannel, ...);
```

```dart
// old code
myMethodChannel.setMockMethodCallHandler(...);
myMethodChannel.checkMockMethodCallHandler(...);
// new code
tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(myMethodChannel, ...);
tester.binding.defaultBinaryMessenger.checkMockMessageHandler(myMethodChannel, ...);
```

Testes que usam `package:test` e `test()`
podem ser alterados para usar `package:flutter_test` e `testWidgets()`
para obter acesso a um `WidgetTester`.

Código que não tem acesso a um `WidgetTester` pode se referir a
`TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger`
em vez de `tester.binding.defaultBinaryMessenger`.

Testes que não usam o binding de teste de widgets padrão
(`AutomatedTestWidgetsFlutterBinding`,
que é inicializado por `testWidgets`) podem misturar o
mixin `TestDefaultBinaryMessengerBinding` em seu
binding para obter os mesmos resultados.

Testes que manipulam `onPlatformMessage` não funcionarão mais
como projetado. Para enviar mensagens simuladas para o framework,
considere usar `ChannelBuffers.push`.
Não há mecanismo para interceptar mensagens dos plugins
e encaminhá-las para o framework na nova API.
Se seu caso de uso requer tal mecanismo, por favor, registre um bug.

## Linha do tempo

Lançado na versão: 2.3.0-17.0.pre.1<br>
Na versão estável: 2.5

## Referências

Documentação da API:

* [`TestDefaultBinaryMessenger`][]
* [`TestDefaultBinaryMessengerBinding`][]

PR relevante:

* [PR #76288: Migrate to ChannelBuffers.push][]

[`TestDefaultBinaryMessenger`]: {{site.api}}/flutter/flutter_test/TestDefaultBinaryMessenger-class.html
[`TestDefaultBinaryMessengerBinding`]: {{site.api}}/flutter/flutter_test/TestDefaultBinaryMessengerBinding-mixin.html

[PR #76288: Migrate to ChannelBuffers.push]: {{site.repo.flutter}}/pull/76288
