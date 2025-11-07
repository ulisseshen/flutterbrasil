---
ia-translate: true
title: Gerenciamento de estado
description: Como estruturar um app para gerenciar o estado dos dados que fluem através dele.
next:
  title: Start thinking declaratively
  path: /development/data-and-backend/state-mgmt/declarative
---

:::note
Se você escreveu um aplicativo móvel usando Flutter
e se pergunta por que o estado do seu app é perdido
em uma reinicialização, confira [Restaurar estado no Android][Restore state on Android]
ou [Restaurar estado no iOS][Restore state on iOS].
:::

[Restore state on Android]: /platform-integration/android/restore-state-android
[Restore state on iOS]: /platform-integration/ios/restore-state-ios

_Se você já está familiarizado com gerenciamento de estado em apps reativos,
você pode pular esta seção, embora você possa querer revisar a
[lista de diferentes abordagens][list of different approaches]._

<img src='/assets/images/docs/development/data-and-backend/state-mgmt/state-management-explainer.gif' width="100%" alt="A short animated gif that shows the workings of a simple declarative state management system. This is explained in full in one of the following pages. Here it's just a decoration.">

{% comment %}
Source of the above animation tracked internally as b/122314402
{% endcomment %}

Conforme você explora o Flutter,
chega um momento em que você precisa compartilhar o estado do aplicativo
entre telas, em todo o seu app.
Existem muitas abordagens que você pode adotar,
e muitas perguntas para pensar.

Nas páginas a seguir,
você aprenderá o básico de lidar com estado em apps Flutter.

[list of different approaches]: /data-and-backend/state-mgmt/options
