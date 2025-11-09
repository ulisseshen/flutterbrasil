---
ia-translate: true
title: Provedores de LLM personalizados
description: >
  Como integrar com outros recursos do Flutter.
prev:
  title: Feature integration
  path: /ai-toolkit/feature-integration
next:
  title: Chat client sample
  path: /ai-toolkit/chat-client-sample
---

O protocolo que conecta um LLM ao `LlmChatView`
é expresso na [interface `LlmProvider`][`LlmProvider` interface]:

```dart
abstract class LlmProvider implements Listenable {
  Stream<String> generateStream(String prompt, {Iterable<Attachment> attachments});
  Stream<String> sendMessageStream(String prompt, {Iterable<Attachment> attachments});
  Iterable<ChatMessage> get history;
  set history(Iterable<ChatMessage> history);
}
```

O LLM pode estar na nuvem ou local,
pode estar hospedado no Google Cloud Platform
ou em algum outro provedor de nuvem,
pode ser um LLM proprietário ou open source.
Qualquer LLM ou endpoint similar a LLM que possa ser usado
para implementar essa interface pode ser conectado à
view de chat como um provider de LLM. O AI Toolkit
vem com três providers prontos para uso,
todos implementam a interface `LlmProvider`
que é necessária para conectar o provider ao seguinte:

* O [provider Gemini][Gemini provider],
  que encapsula o pacote `google_generative_ai`
* O [provider Vertex][Vertex provider],
  que encapsula o pacote `firebase_vertexai`
* O [provider Echo][Echo provider],
  que é útil como um exemplo mínimo de provider

[Echo provider]: {{site.pub-api}}/flutter_ai_toolkit/latest/flutter_ai_toolkit/EchoProvider-class.html
[Gemini provider]: {{site.pub-api}}/flutter_ai_toolkit/latest/flutter_ai_toolkit/GeminiProvider-class.html
[`LlmProvider` interface]: {{site.pub-api}}/flutter_ai_toolkit/latest/flutter_ai_toolkit/LlmProvider-class.html
[Vertex provider]: {{site.pub-api}}/flutter_ai_toolkit/latest/flutter_ai_toolkit/VertexProvider-class.html

## Implementation

Para construir seu próprio provider, você precisa implementar
a interface `LlmProvider` com essas coisas em mente:

1. Provendo suporte completo para configuração
1. Lidando com o histórico
1. Traduzindo mensagens e anexos para o LLM subjacente
1. Chamando o LLM subjacente

1. Configuration
   Para suportar configurabilidade completa em seu provider personalizado,
   você deve permitir que o usuário crie o modelo subjacente
   e passe-o como um parâmetro, como o provider Gemini faz:

```dart
class GeminiProvider extends LlmProvider ... {
  @immutable
  GeminiProvider({
    required GenerativeModel model,
    ...
  })  : _model = model,
        ...

  final GenerativeModel _model;
  ...
}
```

Dessa forma, não importa quais mudanças venham
para o modelo subjacente no futuro,
os controles de configuração estarão todos disponíveis
para o usuário do seu provider personalizado.

2. History
  O histórico é uma grande parte de qualquer provider—não só
  o provider precisa permitir que o histórico seja
  manipulado diretamente, mas também tem que notificar os listeners
  conforme ele muda. Além disso, para suportar serialização
  e mudança de parâmetros do provider, ele também deve suportar
  salvar o histórico como parte do processo de construção.

  O provider Gemini lida com isso da seguinte forma:

```dart
class GeminiProvider extends LlmProvider with ChangeNotifier {
  @immutable
  GeminiProvider({
    required GenerativeModel model,
    Iterable<ChatMessage>? history,
    ...
  })  : _model = model,
        _history = history?.toList() ?? [],
        ... { ... }

  final GenerativeModel _model;
  final List<ChatMessage> _history;
  ...

  @override
  Stream<String> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final userMessage = ChatMessage.user(prompt, attachments);
    final llmMessage = ChatMessage.llm();
    _history.addAll([userMessage, llmMessage]);

    final response = _generateStream(
      prompt: prompt,
      attachments: attachments,
      contentStreamGenerator: _chat!.sendMessageStream,
    );

    yield* response.map((chunk) {
      llmMessage.append(chunk);
      return chunk;
    });

    notifyListeners();
  }

  @override
  Iterable<ChatMessage> get history => _history;

  @override
  set history(Iterable<ChatMessage> history) {
    _history.clear();
    _history.addAll(history);
    _chat = _startChat(history);
    notifyListeners();
  }

  ...
}
```

Você notará várias coisas neste código:
* O uso de `ChangeNotifier` para implementar os requisitos
  do método `Listenable` da interface `LlmProvider`
* A habilidade de passar o histórico inicial como um parâmetro do construtor
* Notificar os listeners quando há um novo par de
  prompt do usuário/resposta do LLM
* Notificar os listeners quando o histórico é alterado manualmente
* Criar um novo chat quando o histórico muda, usando o novo histórico

Essencialmente, um provider personalizado gerencia o histórico
para uma única sessão de chat com o LLM subjacente.
À medida que o histórico muda, o chat subjacente
precisa ser mantido atualizado automaticamente
(como o Gemini AI SDK para Dart faz quando você chama
os métodos específicos de chat subjacentes) ou recriado manualmente
(como o provider Gemini faz sempre que o histórico é definido manualmente).

3. Messages and attachments

Os anexos devem ser mapeados da classe
`ChatMessage` padrão exposta pelo tipo `LlmProvider`
para o que for manipulado pelo LLM subjacente.
Por exemplo, o provider Gemini mapeia da classe
`ChatMessage` do AI Toolkit para o tipo
`Content` fornecido pelo Gemini AI SDK para Dart,
conforme mostrado no exemplo a seguir:

```dart
import 'package:google_generative_ai/google_generative_ai.dart';
...

class GeminiProvider extends LlmProvider with ChangeNotifier {
  ...
  static Part _partFrom(Attachment attachment) => switch (attachment) {
        (final FileAttachment a) => DataPart(a.mimeType, a.bytes),
        (final LinkAttachment a) => FilePart(a.url),
      };

  static Content _contentFrom(ChatMessage message) => Content(
        message.origin.isUser ? 'user' : 'model',
        [
          TextPart(message.text ?? ''),
          ...message.attachments.map(_partFrom),
        ],
      );
}
```

O método `_contentFrom` é chamado sempre que um prompt do usuário
precisa ser enviado ao LLM subjacente.
Todo provider precisa fornecer seu próprio mapeamento.

4. Calling the LLM

Como você chama o LLM subjacente para implementar
os métodos `generateStream` e `sendMessageStream`
depende do protocolo que ele expõe.
O provider Gemini no AI Toolkit
lida com configuração e histórico, mas as chamadas para
`generateStream` e `sendMessageStream` acabam
em uma chamada para uma API do Gemini AI SDK para Dart:

```dart
class GeminiProvider extends LlmProvider with ChangeNotifier {
  ...

  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) =>
      _generateStream(
        prompt: prompt,
        attachments: attachments,
        contentStreamGenerator: (c) => _model.generateContentStream([c]),
      );

  @override
  Stream<String> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final userMessage = ChatMessage.user(prompt, attachments);
    final llmMessage = ChatMessage.llm();
    _history.addAll([userMessage, llmMessage]);

    final response = _generateStream(
      prompt: prompt,
      attachments: attachments,
      contentStreamGenerator: _chat!.sendMessageStream,
    );

    yield* response.map((chunk) {
      llmMessage.append(chunk);
      return chunk;
    });

    notifyListeners();
  }

  Stream<String> _generateStream({
    required String prompt,
    required Iterable<Attachment> attachments,
    required Stream<GenerateContentResponse> Function(Content)
        contentStreamGenerator,
  }) async* {
    final content = Content('user', [
      TextPart(prompt),
      ...attachments.map(_partFrom),
    ]);

    final response = contentStreamGenerator(content);
    yield* response
        .map((chunk) => chunk.text)
        .where((text) => text != null)
        .cast<String>();
  }

  @override
  Iterable<ChatMessage> get history => _history;

  @override
  set history(Iterable<ChatMessage> history) {
    _history.clear();
    _history.addAll(history);
    _chat = _startChat(history);
    notifyListeners();
  }
}
```

## Examples

As implementações do [provider Gemini][Gemini provider] e do [provider Vertex][Vertex provider]
são quase idênticas e fornecem
um bom ponto de partida para seu próprio provider personalizado.
Se você quiser ver um exemplo de implementação de provider com
todas as chamadas ao LLM subjacente removidas,
confira o [app de exemplo Echo][Echo example app], que simplesmente formata
o prompt e os anexos do usuário como Markdown
para enviar de volta ao usuário como sua resposta.

[Echo example app]: {{site.github}}/flutter/ai/blob/main/lib/src/providers/implementations/echo_provider.dart
