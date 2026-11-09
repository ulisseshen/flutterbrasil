---
ia-translate: true
title: Entrada e eventos
description: Como entrada e eventos são tratados em aplicações GenUI.
prev:
  title: Comece com o GenUI SDK para Flutter
  path: /ai/genui/get-started
---

Este guia explica como as interações do usuário são tratadas
dentro do pacote GenUI, desde a interação inicial com o widget
até o agente de IA receber o evento.

:::experimental
O pacote `genui` está em alfa e provavelmente vai mudar.
:::

## Visão geral {:#overview}

Na arquitetura do GenUI, a UI é conduzida pela IA,
mas as interações do usuário (como clicar em um botão
ou enviar um formulário) precisam ser comunicadas de volta
ao agente de IA.
Isso permite que o agente atualize a UI ou execute ações
em resposta à entrada do usuário.

O fluxo de um evento é o seguinte:

1. Interação: o usuário interage com um widget;
   por exemplo, toca em um botão.
2. Captura: a implementação do widget despacha um `UiEvent`.
3. Processamento: o framework adiciona contexto
   (como um `surfaceId` ou valores do modelo de dados)
   e encaminha o evento.
4. Transmissão: o widget Flutter gera o evento,
   adiciona o contexto apropriado e o roteia
   para a IA por meio do `ContentGenerator`,
   que o encaminha ao agente de IA.

## Definindo eventos {:#defining-events}

### Nível do protocolo {:#protocol-level}

O protocolo A2UI define uma mensagem `action` usada para reportar eventos.
Uma `action` contém:

* `name`: o nome da ação
  (definido pela IA ao gerar o componente).
* `surfaceId`: o ID da superfície de UI onde o evento ocorreu.
* `sourceComponentId`: o ID do componente que disparou o evento.
* `context`: um objeto JSON com dados relevantes ao evento.
* `timestamp`: quando o evento ocorreu.

### Implementação em Dart {:#dart-implementation}

No [`package:genui`][], os eventos do usuário são representados
pelo extension type `UiEvent` e por sua implementação concreta,
`UserActionEvent`.

[`package:genui`]: {{site.pub-pkg}}/genui

As estruturas a seguir são definidas em
`lib/src/model/ui_models.dart`:

```dart title="lib/src/model/ui_models.dart"
/// A data object that represents a user interaction event in the UI.
extension type UiEvent.fromMap(JsonMap _json) { ... }

/// A UI event that represents a user action.
extension type UserActionEvent.fromMap(JsonMap _json) implements UiEvent {
  UserActionEvent({
    String? surfaceId,
    required String name,
    required String sourceComponentId,
    JsonMap? context,
    // ...
  }) : ...
}
```

## Capturando eventos em widgets {:#capturing-events-in-widgets}

Widgets no GenUI são definidos em um `Catalog`,
que inclui informações sobre quais eventos o widget
pode enviar para a IA.
A IA pode então enviar informações sobre como
comunicar esses eventos de volta.
Ao implementar um widget customizado
(ou usar os widgets padrão),
você usa o método `dispatchEvent` em `CatalogItemContext`
para despachar eventos.

### Exemplo: implementação de Button {: #button-example}

O exemplo a seguir mostra como um widget `Button`
normalmente captura um toque e despacha um evento.
Ele recupera a definição da ação (fornecida pela IA)
a partir de suas propriedades, resolve quaisquer vínculos de dados
no contexto e envia o evento.

```dart
// Inside a CatalogItem widgetBuilder:
widgetBuilder: (itemContext) {
  // 1. Extract action data from the component properties.
  final buttonData = _ButtonData.fromMap(itemContext.data as JsonMap);
  final JsonMap actionData = buttonData.action;
  final actionName = actionData['name'] as String;

  // 2. Extract context definition (which data to send back).
  final List<Object?> contextDefinition =
      (actionData['context'] as List<Object?>?) ?? <Object?>[];

  return ElevatedButton(
    onPressed: () {
      // 3. Resolve the context values from the data model.
      final JsonMap resolvedContext = resolveContext(
        itemContext.dataContext,
        contextDefinition,
      );

      // 4. Dispatch the event.
      itemContext.dispatchEvent(
        UserActionEvent(
          name: actionName,
          sourceComponentId: itemContext.id,
          context: resolvedContext,
        ),
      );
    },
    child: /* ... */
  );
},
```

## Pipeline de processamento de eventos {:#event-processing-pipeline}

Depois que `dispatchEvent` é chamado,
o evento percorre as camadas centrais do GenUI.

### Surface {:#surface}

O widget `Surface` (em `lib/src/core/surface.dart`)
envolve os widgets renderizados.
Ele fornece a implementação do callback dispatchEvent.

Quando `_dispatchEvent` é chamado:

1. Ele injeta automaticamente o `surfaceId` no evento,
   garantindo que a IA saiba de qual superfície veio a interação.
2. Ele delega o tratamento ao `SurfaceHost`
   (implementado pelo `SurfaceController`).

```dart
// Surface implementation details
void _dispatchEvent(UiEvent event) {
  // ...
  final Map<String, Object?> eventMap = {
    ...event.toMap(),
    surfaceIdKey: widget.surfaceId, // Inject surfaceId
  };
  final UiEvent newEvent = UserActionEvent.fromMap(eventMap);
  widget.host.handleUiEvent(newEvent);
}
```

### SurfaceController {:#surfacecontroller}

O `SurfaceController` (em `lib/src/core/surface_controller.dart`)
é o hub central para o gerenciamento do estado da UI.

Quando `handleUiEvent` é chamado, ele faz o seguinte:

1.  Verifica o tipo do evento.
2.  Envolve o evento no envelope JSON `action`
   exigido pelo protocolo.
3.  Emite uma `UserUiInteractionMessage` no seu stream `onSubmit`.

```dart
// SurfaceController implementation details
@override
void handleUiEvent(UiEvent event) {
  if (event is! UserActionEvent) return;

  // Wrap in protocol 'action' envelope
  final String eventJsonString = jsonEncode({'action': event.toMap()});

  // Emit for listeners (like Conversation)
  _onSubmit.add(UserUiInteractionMessage.text(eventJsonString));
}
```

## Transmissão para a IA {:#transmission-to-ai}

A etapa final envia o evento ao agente de IA.
Isso normalmente é feito pelo `Conversation`
(em `lib/src/facade/conversation.dart`).
O `Conversation` escuta o stream `onSubmit`
do processador de mensagens.

```dart
// Conversation constructor
_userEventSubscription = surfaceController.onSubmit.listen(sendRequest);
```

Quando um evento é recebido, o método `sendRequest`:

1. Encapsula a `UserUiInteractionMessage` de volta
   para o código do cliente do desenvolvedor.
2. A integração customizada ou o adaptador de transporte predefinido
   encaminha a mensagem para o transporte de rede do agente LLM.

O agente de IA recebe essa mensagem JSON, processa a ação do usuário
e pode devolver novas mensagens `surfaceUpdate` ou `dataModelUpdate`
para modificar a UI, ou executar alguma outra ação,
completando o ciclo completo da interação.
