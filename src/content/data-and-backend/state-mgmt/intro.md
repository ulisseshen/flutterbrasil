---
ia-translate: true
title: Gerenciamento de estado
description: Como estruturar um aplicativo para gerenciar o estado dos dados que fluem através dele.
next:
  title: Comece a pensar declarativamente
  path: /development/data-and-backend/state-mgmt/declarative
---

:::note
Se você escreveu um aplicativo móvel usando Flutter e se pergunta por que o estado do seu aplicativo é perdido ao reiniciar, confira [Restaurar estado no Android][] ou [Restaurar estado no iOS][].
:::

[Restaurar estado no Android]: /platform-integration/android/restore-state-android
[Restaurar estado no iOS]: /platform-integration/ios/restore-state-ios

_Se você já está familiarizado com gerenciamento de estado em aplicativos reativos, pode pular esta seção, embora talvez queira revisar a [lista de diferentes abordagens][]._

<img src='/assets/images/docs/development/data-and-backend/state-mgmt/state-management-explainer.gif' width="100%" alt="Um pequeno gif animado que mostra o funcionamento de um sistema simples de gerenciamento de estado declarativo. Isso é explicado em detalhes em uma das páginas seguintes. Aqui é apenas uma decoração.">

{% comment %}
Fonte da animação acima rastreada internamente como b/122314402
{% endcomment %}

Ao explorar o Flutter, chega um momento em que você precisa compartilhar o estado do aplicativo entre as telas, em todo o seu aplicativo. Há muitas abordagens que você pode adotar e muitas perguntas a serem pensadas.

Nas páginas seguintes, você aprenderá o básico sobre como lidar com o estado em aplicativos Flutter.

[lista de diferentes abordagens]: /data-and-backend/state-mgmt/options
