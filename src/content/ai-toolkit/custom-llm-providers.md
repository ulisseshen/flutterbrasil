---
ia-translate: true
title: Provedores de LLM Personalizados
description: >
  Como integrar com outros recursos do Flutter.
prev:
  title: Integração de recursos
  path: /ai-toolkit/feature-integration
next:
  title: Amostra de cliente de chat
  path: /ai-toolkit/chat-client-sample
---

O protocolo que conecta um LLM e a `LlmChatView`
é expresso na [`interface LlmProvider`][]:

```dart
abstract class LlmProvider implements Listenable {
  Stream<String> generateStream(String prompt, {Iterable<Attachment> attachments});
  Stream<String> sendMessageStream(String prompt, {Iterable<Attachment> attachments});
  Iterable<ChatMessage> get history;
  set history(Iterable<ChatMessage> history);
}
```

O LLM pode estar na nuvem ou local,
pode ser hospedado no Google Cloud Platform
ou em algum outro provedor de nuvem,
pode ser um LLM proprietário ou de código aberto.
Qualquer LLM ou endpoint semelhante a LLM que possa ser usado
para implementar esta interface pode ser conectado
à visualização de chat como um provedor de LLM. O AI Toolkit
vem com três provedores prontos para uso,
todos os quais implementam a interface `LlmProvider`
que é necessária para conectar o provedor no seguinte:

* O [provedor Gemini][],
  que envolve o pacote `google_generative_ai`
* O [provedor Vertex][],
  que envolve o pacote `firebase_vertexai`
* O [provedor Echo][],
  que é útil como um exemplo de provedor mínimo

[Provedor Echo]: {{site.pub-api}}/flutter_ai_toolkit/latest/flutter_ai_toolkit/EchoProvider-class.html
[Provedor Gemini]: {{site.pub-api}}/flutter_ai_toolkit/latest/flutter_ai_toolkit/GeminiProvider-class.html
[`interface LlmProvider`]: {{site.pub-api}}/flutter_ai_toolkit/latest/flutter_ai_toolkit/LlmProvider-class.html
[Provedor Vertex]: {{site.pub-api}}/flutter_ai_toolkit/latest/flutter_ai_toolkit/VertexProvider-class.html

## Implementação

Para construir seu próprio provedor, você precisa implementar
a interface `LlmProvider` tendo estas coisas em mente:

1. Fornecer suporte completo para configuração
2. Lidar com o histórico
3. Traduzir mensagens e anexos para o modelo base do LLM
4. Chamar o modelo base do LLM

1. Configuração
   Para oferecer suporte total à configuração em seu provedor personalizado,
   você deve permitir que o usuário crie o modelo subjacente
   e o passe como um parâmetro, como faz o provedor Gemini:

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
os controles de configuração estarão todos disponíveis
para o usuário do seu provedor personalizado.

2. Histórico
  O histórico é uma grande parte de qualquer provedor — não apenas
  o provedor precisa permitir que o histórico seja
  manipulado diretamente, mas ele tem que notificar os ouvintes
  à medida que ele muda. Além disso, para oferecer suporte à serialização
  e à alteração dos parâmetros do provedor, ele também deve oferecer suporte
  para salvar o histórico como parte do processo de construção.

  O provedor Gemini lida com isso como mostrado:

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
* O uso de `ChangeNotifier` para implementar os requisitos do método
  `Listenable` da interface `LlmProvider`
* A capacidade de passar o histórico inicial como um parâmetro do construtor
* Notificar os ouvintes (listeners) quando há um novo par
  de prompt do usuário/resposta LLM
* Notificar os ouvintes quando o histórico é alterado manualmente
* Criar um novo chat quando o histórico muda, usando o novo histórico

Essencialmente, um provedor personalizado gerencia o histórico
para uma única sessão de chat com o modelo base do LLM.
À medida que o histórico muda, o chat subjacente ou
precisa ser mantido atualizado automaticamente
(como o Gemini AI SDK para Dart faz quando você chama
os métodos subjacentes específicos do chat) ou recriado manualmente
(como o provedor Gemini faz sempre que o histórico é definido manualmente).

3. Mensagens e anexos

Os anexos devem ser mapeados da classe
`ChatMessage` padrão exposta pelo tipo `LlmProvider`
para o que for tratado pelo modelo base do LLM.
Por exemplo, o provedor Gemini mapeia a partir da classe
`ChatMessage` do AI Toolkit para o tipo
`Content` fornecido pelo Gemini AI SDK para Dart,
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
precisa ser enviado para o modelo base do LLM.
Cada provedor precisa fornecer seu próprio mapeamento.

4. Chamando o LLM

Como você chama o modelo base do LLM para implementar
os métodos `generateStream` e `sendMessageStream`
depende do protocolo que ele expõe.
O provedor Gemini no AI Toolkit
lida com a configuração e o histórico, mas as chamadas para
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

## Exemplos

As implementações de [provedor Gemini][] e [provedor Vertex][]
são quase idênticas e fornecem
um bom ponto de partida para seu próprio provedor personalizado.
Se você gostaria de ver um exemplo de implementação de provedor com
todas as chamadas para o modelo base do LLM removidas,
confira o [aplicativo de exemplo Echo][], que simplesmente formata
o prompt e os anexos do usuário como Markdown
para enviar de volta ao usuário como sua resposta.

[aplicativo de exemplo Echo]: {{site.github}}/flutter/ai/blob/main/lib/src/providers/implementations/echo_provider.dart
