---
ia-translate: true
title: Exemplo de cliente de chat
description: >
  Saiba mais sobre o exemplo de cliente de chat incluído no AI Toolkit.
prev:
  title: Provedores de LLM personalizados
  path: /ai-toolkit/custom-llm-providers
---

O exemplo de AI Chat tem como objetivo ser um aplicativo de chat completo
construído usando o Flutter AI Toolkit e o Vertex AI para Firebase.
Além de todos os recursos de multi-disparo, multi-mídia e
streaming que ele obtém do AI Toolkit,
o exemplo de AI Chat mostra como armazenar e gerenciar
vários chats de uma vez em seus próprios aplicativos.
Em formatos de desktop, o exemplo de AI Chat se parece com o seguinte:

![UI do aplicativo de desktop](/assets/images/docs/ai-toolkit/desktop-pluto-convo.png)


Em formatos mobile, ele se parece com isto:

![UI do aplicativo mobile](/assets/images/docs/ai-toolkit/mobile-pluto-convo.png)

Os chats são armazenados em um banco de dados autenticado do
Cloud Firestore; qualquer usuário autenticado
pode ter quantos chats quiser.

Além disso, para cada novo chat, embora o usuário possa
manualmente dar o título que quiser,
o prompt e a resposta iniciais são usados para perguntar
ao LLM qual seria um título apropriado.
Na verdade, os títulos dos chats nas
capturas de tela desta página foram definidos automaticamente.

Para construir e executar o exemplo,
siga as instruções no [README do AI Chat][].

{% comment %}
TODO: Se Mit concordar, mova isso para um repositório oficial do Flutter
  Chris não queria fazer isso tão perto do lançamento
{% endcomment %}

[README do AI Chat]: {{site.github}}/csells/flutter_ai_chat

