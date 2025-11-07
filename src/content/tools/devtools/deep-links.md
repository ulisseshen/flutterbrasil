---
ia-translate: true
title: Validar deep links
description: Aprenda como validar deep links no seu app.
---

:::note
A partir da versão 3.27, a ferramenta validadora de deep link
funciona para _Android e iOS_.

Para ver uma demonstração do validador de deep link,
confira o vídeo do Google I/O 2024,
[No more broken links: Deep linking success in Flutter][].
:::

[No more broken links: Deep linking success in Flutter]: {{site.youtube-site}}/watch?v=d7sZL6h1Elw

A visualização de deep link valida quaisquer deep links
que estão definidos no seu app.

Para usar este recurso, abra DevTools,
clique na aba **Deep Links**
e importe um projeto Flutter que contenha deep links.

![Screenshot of the Deep Link Validator](/assets/images/docs/tools/devtools/deep-link-validator.png){:width="100%"}

Esta ferramenta ajuda você a identificar e solucionar quaisquer erros
na sua configuração de deep link mobile,
desde configuração de website até arquivos de manifesto.
DevTools fornece instruções sobre como corrigir quaisquer problemas,
tornando o processo de implementação mais fácil.
