---
ia-translate: true
title: Valide deep links
description: Aprenda como validar deep links no seu app.
---

:::note
A partir da versão 3.27, a ferramenta de validação de deep link
funciona para _ambos_ Android e iOS.

Para ver uma demonstração do validador de deep link,
confira o vídeo do Google I/O 2024,
[No more broken links: Deep linking success in Flutter][No more broken links: Deep linking success in Flutter].
:::

[No more broken links: Deep linking success in Flutter]: {{site.youtube-site}}/watch?v=d7sZL6h1Elw

A view de deep link valida quaisquer deep links
que estão definidos no seu app.

Para usar este recurso, abra DevTools,
clique na aba **Deep Links**,
e importe um projeto Flutter que contém deep links.

![Screenshot of the Deep Link Validator](/assets/images/docs/tools/devtools/deep-link-validator.png){:width="100%"}

Esta ferramenta ajuda você a identificar e solucionar quaisquer erros
na configuração de deep link mobile do seu app,
desde a configuração do site até arquivos de manifest.
DevTools fornece instruções sobre como corrigir quaisquer problemas,
tornando o processo de implementação mais fácil.
