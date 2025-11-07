---
ia-translate: true
title: Exemplo de cliente de chat
description: >
  Aprenda sobre o exemplo de cliente de chat incluído no AI Toolkit.
prev:
  title: Custom LLM providers
  path: /ai-toolkit/custom-llm-providers
---

O exemplo AI Chat é um aplicativo de chat completo
construído usando o Flutter AI Toolkit e Vertex AI for Firebase.
Além de todos os recursos de multi-shot, multimídia e
streaming que obtém do AI Toolkit,
o exemplo AI Chat mostra como armazenar e gerenciar
múltiplos chats simultaneamente em seus próprios aplicativos.
Em dispositivos desktop, o exemplo AI Chat se parece com o seguinte:

![Desktop app UI](/assets/images/docs/ai-toolkit/desktop-pluto-convo.png)


Em dispositivos móveis, ele se parece com isto:

![Mobile app UI](/assets/images/docs/ai-toolkit/mobile-pluto-convo.png)

Os chats são armazenados em um banco de dados
Cloud Firestore autenticado; qualquer usuário
autenticado pode ter quantos chats quiser.

Além disso, para cada novo chat, embora o usuário possa
definir manualmente o título como quiser,
o prompt e resposta iniciais são usados para perguntar
ao LLM qual seria um título apropriado.
De fato, os títulos dos chats nas
capturas de tela desta página foram definidos automaticamente.

Para compilar e executar o exemplo,
siga as instruções no [AI Chat README][].

{% comment %}
TODO: If Mit agrees, move this to an official Flutter repo
  Chris didn't want to do it so close to release
{% endcomment %}

[AI Chat README]: {{site.github}}/csells/flutter_ai_chat
