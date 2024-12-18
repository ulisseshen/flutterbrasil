---
ia-translate: true
title: Validar deep links
description: Aprenda como validar deep links em seu app.
---

:::note
O validador de deep links foi adicionado ao DevTools
no Flutter SDK 3.19. Atualmente, ele funciona apenas para
Android, mas será expandido para cobrir iOS
em uma versão futura.

Para ver uma demonstração do validador de deep links,
confira o vídeo do Google I/O 2024,
[No more broken links: Deep linking success in Flutter][].
:::

[No more broken links: Deep linking success in Flutter]: {{site.youtube-site}}/watch?v=d7sZL6h1Elw

A visualização de deep links valida quaisquer deep links
que estejam definidos em seu app.

Para usar esse recurso, abra o DevTools,
clique na aba **Deep Links** e importe um projeto
Flutter que contenha deep links.

![Captura de tela do Validador de Deep Link](/assets/images/docs/tools/devtools/deep-link-validator.png){:width="100%"}

Essa ferramenta ajuda você a identificar e solucionar quaisquer erros
na sua configuração de deep link no Android,
desde a configuração do site até os arquivos manifest do Android.
O DevTools fornece instruções sobre como corrigir quaisquer problemas,
tornando o processo de implementação mais fácil.
