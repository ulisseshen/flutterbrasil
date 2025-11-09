---
ia-translate: true
title: Amostra de cliente de chat
description: >
  Aprenda sobre a amostra de cliente de chat incluída no AI Toolkit.
prev:
  title: Custom LLM providers
  path: /ai-toolkit/custom-llm-providers
---

A amostra AI Chat é projetada para ser um app de chat completo
construído usando o Flutter AI Toolkit e Vertex AI para Firebase.
Além de todos os recursos multi-shot, multimídia e de
streaming que obtém do AI Toolkit,
a amostra AI Chat mostra como armazenar e gerenciar
múltiplos chats de uma vez em seus próprios apps.
Em fatores de forma desktop, a amostra AI Chat se parece com o seguinte:

![Desktop app UI](/assets/images/docs/ai-toolkit/desktop-pluto-convo.png)


Em fatores de forma mobile, ela se parece com isto:

![Mobile app UI](/assets/images/docs/ai-toolkit/mobile-pluto-convo.png)

Os chats são armazenados em um banco de dados
Cloud Firestore autenticado; qualquer usuário
autenticado pode ter quantos chats quiser.

Além disso, para cada novo chat, enquanto o usuário pode
titulá-lo manualmente como quiser,
o prompt e resposta iniciais são usados para perguntar
ao LLM qual seria um título apropriado.
De fato, os títulos dos chats nas
capturas de tela nesta página foram definidos automaticamente.

Para construir e executar a amostra,
siga as instruções no [AI Chat README][].

{% comment %}
TODO: If Mit agrees, move this to an official Flutter repo
  Chris didn't want to do it so close to release
{% endcomment %}

[AI Chat README]: {{site.github}}/csells/flutter_ai_chat
