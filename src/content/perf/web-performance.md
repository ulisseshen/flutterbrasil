---
ia-translate: true
title: Depuração de performance para aplicativos web
description: Aprenda como usar o Chrome DevTools para depurar problemas de performance web.
---

:::note
O profiling de aplicativos web Flutter requer a versão 3.14 ou mais recente do Flutter.
:::

O framework Flutter emite eventos de linha do tempo enquanto trabalha para construir frames, desenhar cenas e rastrear outras atividades como coletas de lixo. Esses eventos são expostos no [painel de performance do Chrome DevTools][] para depuração.

:::note
Para informações sobre como otimizar a velocidade de carregamento web, confira o artigo (gratuito) no Medium, [Melhores práticas para otimizar a velocidade de carregamento web do Flutter][article].

[article]: {{site.flutter-medium}}/best-practices-for-optimizing-flutter-web-loading-speed-7cc0df14ce5c
:::

Você também pode emitir seus próprios eventos de linha do tempo usando as APIs `dart:developer` [Timeline][] e [TimelineTask][] para análises de performance adicionais.

[painel de performance do Chrome DevTools]: https://developer.chrome.com/docs/devtools/performance
[Timeline]: {{site.api}}/flutter/dart-developer/Timeline-class.html
[TimelineTask]: {{site.api}}/flutter/dart-developer/TimelineTask-class.html

![Captura de tela do painel de performance do Chrome DevTools](/assets/images/docs/tools/devtools/chrome-devtools-performance-panel.png)

## Flags opcionais para aprimorar o rastreamento

Para configurar quais eventos da linha do tempo são rastreados, defina qualquer uma das seguintes propriedades de nível superior para `true` no método `main` do seu aplicativo.

- [debugProfileBuildsEnabled][]: Adiciona eventos `Timeline` para cada `Widget` construído.
- [debugProfileBuildsEnabledUserWidgets][]: Adiciona eventos `Timeline` para cada `Widget` criado pelo usuário construído.
- [debugProfileLayoutsEnabled][]: Adiciona eventos `Timeline` para cada layout de `RenderObject`.
- [debugProfilePaintsEnabled][]: Adiciona eventos `Timeline` para cada `RenderObject` pintado.

[debugProfileBuildsEnabled]: {{site.api}}/flutter/widgets/debugProfileBuildsEnabled.html
[debugProfileBuildsEnabledUserWidgets]: {{site.api}}/flutter/widgets/debugProfileBuildsEnabledUserWidgets.html
[debugProfileLayoutsEnabled]: {{site.api}}/flutter/rendering/debugProfileLayoutsEnabled.html
[debugProfilePaintsEnabled]: {{site.api}}/flutter/rendering/debugProfilePaintsEnabled.html

## Instruções

1. _[Opcional]_ Defina quaisquer flags de rastreamento desejadas como true a partir do método principal do seu aplicativo.
2. Execute seu aplicativo web Flutter em [modo de profile][].
3. Abra o [painel de performance do Chrome DevTools][] para seu aplicativo e [inicie a gravação][] para capturar eventos da linha do tempo.

[inicie a gravação]: https://developer.chrome.com/docs/devtools/performance/#record

[modo de profile]: /testing/build-modes#profile
[painel de performance do Chrome DevTools]: https://developer.chrome.com/docs/devtools/performance
