---
ia-translate: true
title: Provedores LLM personalizados
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
é expresso na [interface `LlmProvider`][]:

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
pode ser um LLM proprietário ou código aberto.
Qualquer LLM ou endpoint similar a LLM que possa ser usado
para implementar esta interface pode ser conectado à
view de chat como um provedor LLM. O AI Toolkit
vem com três provedores prontos para uso,
todos implementando a interface `LlmProvider`
que é necessária para conectar o provedor ao seguinte:

* O [provedor Gemini][Gemini provider],
  que encapsula o pacote `google_generative_ai`
* O [provedor Vertex][Vertex provider],
  que encapsula o pacote `firebase_vertexai`
* O [provedor Echo][Echo provider],
  que é útil como um exemplo mínimo de provedor

[Echo provider]: {{site.pub-api}}/flutter_ai_toolkit/latest/flutter_ai_toolkit/EchoProvider-class.html
[Gemini provider]: {{site.pub-api}}/flutter_ai_toolkit/latest/flutter_ai_toolkit/GeminiProvider-class.html
[`LlmProvider` interface]: {{site.pub-api}}/flutter_ai_toolkit/latest/flutter_ai_toolkit/LlmProvider-class.html
[Vertex provider]: {{site.pub-api}}/flutter_ai_toolkit/latest/flutter_ai_toolkit/VertexProvider-class.html

## Implementação

Para construir seu próprio provedor, você precisa implementar
a interface `LlmProvider` com estas considerações em mente:

1. Fornecer suporte completo de configuração
1. Gerenciar histórico
1. Traduzir mensagens e anexos para o LLM subjacente
1. Chamar o LLM subjacente

1. Configuração
   Para suportar configurabilidade completa em seu provedor personalizado,
   você deve permitir que o usuário crie o modelo subjacente
   e o passe como parâmetro, como o provedor Gemini faz:

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
ao modelo subjacente no futuro,
todos os controles de configuração estarão disponíveis
para o usuário do seu provedor personalizado.

2. Histórico
  O histórico é uma grande parte de qualquer provedor—não apenas
  o provedor precisa permitir que o histórico seja
  manipulado diretamente, mas também deve notificar os ouvintes
  quando ele muda. Além disso, para suportar serialização
  e mudança de parâmetros do provedor, ele também deve suportar
  salvar o histórico como parte do processo de construção.

  O provedor Gemini trata isso conforme mostrado:

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
* A capacidade de passar o histórico inicial como parâmetro do construtor
* Notificar ouvintes quando há um novo par de
  prompt do usuário/resposta do LLM
* Notificar ouvintes quando o histórico é alterado manualmente
* Criar um novo chat quando o histórico muda, usando o novo histórico

Essencialmente, um provedor personalizado gerencia o histórico
de uma única sessão de chat com o LLM subjacente.
À medida que o histórico muda, o chat subjacente precisa
ser mantido atualizado automaticamente
(como o Gemini AI SDK for Dart faz quando você chama
os métodos específicos do chat subjacente) ou recriado manualmente
(como o provedor Gemini faz sempre que o histórico é definido manualmente).

3. Mensagens e anexos

Anexos devem ser mapeados da classe padrão
`ChatMessage` exposta pelo tipo `LlmProvider`
para o que for tratado pelo LLM subjacente.
Por exemplo, o provedor Gemini mapeia da
classe `ChatMessage` do AI Toolkit para o
tipo `Content` fornecido pelo Gemini AI SDK for Dart,
como mostrado no exemplo a seguir:

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
Cada provedor precisa fornecer seu próprio mapeamento.

4. Chamando o LLM

Como você chama o LLM subjacente para implementar
os métodos `generateStream` e `sendMessageStream`
depende do protocolo que ele expõe.
O provedor Gemini no AI Toolkit
trata a configuração e o histórico, mas as chamadas para
`generateStream` e `sendMessageStream` terminam
em uma chamada a uma API do Gemini AI SDK for Dart:

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

## Exemplos

As implementações do [provedor Gemini][Gemini provider] e [provedor Vertex][Vertex provider]
são quase idênticas e fornecem
um bom ponto de partida para seu próprio provedor personalizado.
Se você quiser ver um exemplo de implementação de provedor com
todas as chamadas ao LLM subjacente removidas,
confira o [aplicativo de exemplo Echo][Echo example app], que simplesmente formata
o prompt e anexos do usuário como Markdown
para enviar de volta ao usuário como resposta.

[Echo example app]: {{site.github}}/flutter/ai/blob/main/lib/src/providers/implementations/echo_provider.dart

