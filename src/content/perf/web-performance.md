---
ia-translate: true
title: Depurar desempenho para apps web
description: Aprenda a usar Chrome DevTools para depurar problemas de desempenho web.
---

:::note
Fazer profiling de apps Flutter web requer Flutter versão 3.14 ou posterior.
:::

O framework Flutter emite eventos de timeline enquanto trabalha para construir frames,
desenhar cenas, e rastrear outras atividades como coletas de lixo.
Esses eventos são expostos no
[painel de performance do Chrome DevTools][Chrome DevTools performance panel] para depuração.

:::note
Para informações sobre como otimizar a velocidade de carregamento web,
confira o artigo (gratuito) no Medium,
[Best practices for optimizing Flutter web loading speed][article].

[article]: {{site.flutter-medium}}/best-practices-for-optimizing-flutter-web-loading-speed-7cc0df14ce5c
:::

Você também pode emitir seus próprios eventos de timeline usando as APIs
[Timeline][] e [TimelineTask][] do `dart:developer` para análise de desempenho adicional.

[Chrome DevTools performance panel]: https://developer.chrome.com/docs/devtools/performance
[Timeline]: {{site.api}}/flutter/dart-developer/Timeline-class.html
[TimelineTask]: {{site.api}}/flutter/dart-developer/TimelineTask-class.html

![Screenshot of the Chrome DevTools performance panel](/assets/images/docs/tools/devtools/chrome-devtools-performance-panel.png)

## Flags opcionais para melhorar o rastreamento

Para configurar quais eventos de timeline são rastreados, defina qualquer uma das seguintes propriedades de nível superior como `true`
no método `main` do seu app.

- [debugProfileBuildsEnabled][]: Adiciona eventos `Timeline` para cada `Widget` construído.
- [debugProfileBuildsEnabledUserWidgets][]: Adiciona eventos `Timeline` para cada `Widget` criado pelo usuário construído.
- [debugProfileLayoutsEnabled][]: Adiciona eventos `Timeline` para cada layout de `RenderObject`.
- [debugProfilePaintsEnabled][]: Adiciona eventos `Timeline` para cada `RenderObject` pintado.

[debugProfileBuildsEnabled]: {{site.api}}/flutter/widgets/debugProfileBuildsEnabled.html
[debugProfileBuildsEnabledUserWidgets]: {{site.api}}/flutter/widgets/debugProfileBuildsEnabledUserWidgets.html
[debugProfileLayoutsEnabled]: {{site.api}}/flutter/rendering/debugProfileLayoutsEnabled.html
[debugProfilePaintsEnabled]: {{site.api}}/flutter/rendering/debugProfilePaintsEnabled.html

## Instruções

1. _[Opcional]_ Defina quaisquer flags de rastreamento desejadas como true no método main do seu app.
2. Execute seu app Flutter web em [modo profile][profile mode].
3. Abra o [painel Performance do Chrome DevTools][Chrome DevTools performance panel] para sua aplicação,
    e [comece a gravar][start recording] para capturar eventos de timeline.

[start recording]: https://developer.chrome.com/docs/devtools/performance/#record

[profile mode]: /testing/build-modes#profile
[Chrome DevTools performance panel]: https://developer.chrome.com/docs/devtools/performance
