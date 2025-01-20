import 'package:test/test.dart';

import '../lib/align_text.dart';

void main(){
  test('AlignText deve parsear texto normais e deixar a mensa quantidade de linhas do texto original', () async {
    final alignText = AlignText();
    final originalContent = '''---
title: Feature integration
description: >
  How to integrate with other Flutter features.
prev:
  title: User experience
  path: /ai-toolkit/user-experience
next:
  title: Custom LLM providers
  path: /ai-toolkit/custom-llm-providers
---

In addition to the features that are provided
automatically by the [`LlmChatView`][],
a number of integration points allow your app to
blend seamlessly with other features to provide
additional functionality:''';

    final translatedContent = '''---
ia-translate: true
title: Integração de funcionalidades
description: >
  Como integrar com outros recursos do Flutter.
prev:
  title: Experiência do usuário
  path: /ai-toolkit/user-experience
next:
  title: Provedores de LLM personalizados
  path: /ai-toolkit/custom-llm-providers
---

Além dos recursos que são fornecidos automaticamente pelo
[`LlmChatView`][], vários pontos de integração permitem que
seu aplicativo se misture perfeitamente com outros recursos para fornecer funcionalidades adicionais:''';
    final alignedContent = await alignText.alignTranslation(originalContent, translatedContent);

    expect(alignedContent, '''---
ia-translate: true
title: Integração de funcionalidades
description: >
  Como integrar com outros recursos do Flutter.
prev:
  title: Experiência do usuário
  path: /ai-toolkit/user-experience
next:
  title: Provedores de LLM personalizados
  path: /ai-toolkit/custom-llm-providers
---

Além dos recursos que são fornecidos
automaticamente pelo [`LlmChatView`][], vários pontos de
integração permitem que seu aplicativo se
misture perfeitamente com outros recursos para
fornecer funcionalidades adicionais:''');
  });

  test('deve separar lista como bloco',  () async {
    final originalContent = '''---
title: Feature integration
description: >
  How to integrate with other Flutter features.
---

* **Welcome messages**: Display an initial greeting to users.
* **Suggested prompts**: Offer users predefined prompts to guide interactions.
* **System instructions**: Provide the LLM with specific input to influence its responses.
* **Managing history**: Every LLM provider allows for managing chat history,
  which is useful for clearing it,
  changing it dynamically and storing it between sessions.''';

    final translatedContent = '''---
ia-translate: true
title: Integração de funcionalidades
description: >
  Como integrar com outros recursos do Flutter.
---

* **Mensagens de boas-vindas**: Exiba uma saudação inicial aos usuários.
* **Prompts sugeridos**: Ofereça aos usuários prompts predefinidos para orientar interações.
* **Instruções do sistema**: Forneça ao LLM uma entrada específica para influenciar suas respostas.
* **Gerenciando histórico**: Todo provedor de LLM permite gerenciar o histórico do chat, o que é útil para limpá-lo,
  alterá-lo dinamicamente e armazená-lo entre sessões.''';

    final alignText = AlignText();
    final alignedContent = await alignText.alignTranslation(originalContent, translatedContent);

    expect(alignedContent, '''---
ia-translate: true
title: Integração de funcionalidades
description: >
  Como integrar com outros recursos do Flutter.
---

* **Mensagens de boas-vindas**: Exiba uma saudação inicial aos usuários.
* **Prompts sugeridos**: Ofereça aos usuários prompts predefinidos para orientar interações.
* **Instruções do sistema**: Forneça ao LLM uma entrada específica para influenciar suas respostas.
* **Gerenciando histórico**: Todo provedor de LLM permite gerenciar
  o histórico do chat, o que é útil para
  limpá-lo, alterá-lo dinamicamente e armazená-lo entre sessões.''');
    
  });
}