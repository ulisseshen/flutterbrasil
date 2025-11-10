---
ia-translate: true
title: Usando slots HTML para renderizar platform views na web
description: >
  iframes no Flutter web costumavam recarregar, devido à
  forma como algumas operações DOM eram feitas.
  Uma mudança na forma como apps Flutter web renderizam platform views
  os torna estáveis (prevenindo recarregamentos de iframe, e outros problemas
  com tags de vídeo ou formulários potencialmente perdendo seu estado).
---

{% render "docs/breaking-changes.md" %}

## Resumo

O Flutter agora renderiza todas as platform views web em uma localização consistente do DOM,
como filhos diretos de `flt-glass-pane` (independentemente do backend de renderização:
`html` ou `canvaskit`). As platform views são então _"slotted"_ (encaixadas) na posição correta
do DOM do App com recursos HTML padrão.

Até esta mudança, o Flutter web mudaria o estilo dos
conteúdos renderizados de uma platform view para posicioná-la/dimensioná-la ao espaço disponível. **Isto
não é mais o caso.** Os usuários agora podem decidir como querem utilizar o espaço
alocado para sua platform view pelo framework.

## Contexto

O framework Flutter frequentemente ajusta sua árvore de renderização para otimizar as operações
de pintura que são finalmente feitas por frame. Na web, essas mudanças na árvore de renderização
frequentemente resultam em operações DOM.

O Flutter web costumava renderizar suas platform views ([widgets `HtmlElementView`][HtmlElementView widgets])
diretamente na sua posição correspondente do DOM.

Usar certos elementos DOM como "alvo" de algumas operações DOM faz com que esses
elementos percam seu estado interno. Na prática, isso significa que tags `iframe`
vão recarregar, players de `video` podem reiniciar, ou um formulário editável
pode perder suas edições.

O Flutter agora renderiza platform views usando [elementos slot][slot elements] dentro de um único
[shadow root][shadow root] para todo o app. Elementos slot podem ser adicionados/removidos/movidos pelo
Shadow DOM sem afetar o conteúdo slotted subjacente (que é renderizado
em uma localização constante)

Esta mudança foi feita para:

* Estabilizar o comportamento de platform views no Flutter web.
* Unificar como platform views são renderizadas na web para ambos os
   backends de renderização (`html` e `canvaskit`).
* Fornecer uma localização previsível no DOM que permite aos desenvolvedores usar
   CSS de forma confiável para estilizar suas platform views, e usar outras APIs DOM padrão,
   como `querySelector`, e `getElementById`.

## Descrição da mudança

Um app Flutter web agora é renderizado dentro de um [shadow root][shadow root] comum no qual
[elementos slot][slot elements] representam platform views. O conteúdo real de
cada platform view é renderizado como um **irmão de dito shadow root**.

### Antes

```html
...

<flt-glass-pane>
  ...
  <div id="platform-view">Contents</div> <!-- canvaskit -->
  <!-- OR -->
  <flt-platform-view>
    #shadow-root
    | <div id="platform-view">Contents</div> <!-- html -->
  </flt-platform-view>
  ...
</flt-glass-pane>

...
```

### Depois

```html
...

<flt-glass-pane>
  #shadow-root
  | ...
  | <flt-platform-view-slot>
  |   <slot name="platform-view-1" />
  | </flt-platform-view-slot>
  | ...
  <flt-platform-view slot="platform-view-1">
    <div id="platform-view">Contents</div>
  </flt-platform-view>
  ...
</flt-glass-pane>

...
```

Após esta mudança, quando o framework precisa mover nós DOM, ele
opera sobre `flt-platform-view-slot`s, que contêm apenas um elemento `slot`.
O slot _projeta_ os conteúdos definidos em elementos `flt-platform-view` fora
do shadow root. Elementos `flt-platform-view` nunca são o alvo de operações
DOM do framework, prevenindo assim os problemas de recarregamento.

Da perspectiva de um app, esta mudança é transparente. **No entanto**, isto é
considerado uma _breaking change_ porque alguns testes fazem suposições
sobre o DOM interno de um app Flutter web, e quebram.

## Guia de migração

### Código

O engine pode imprimir uma mensagem de aviso no console similar a:

```bash
Height of Platform View type: [$viewType] may not be set. Defaulting to `height: 100%`.
Set `style.height` to any appropriate value to stop this message.
```

ou:

```bash
Width of Platform View type: [$viewType] may not be set. Defaulting to `width: 100%`.
Set `style.width` to any appropriate value to stop this message.
```

Anteriormente, o conteúdo retornado pelas [funções `PlatformViewFactory`][PlatformViewFactory functions] era
redimensionado e posicionado pelo framework. Em vez disso, o Flutter agora dimensiona e
posiciona `<flt-platform-view-slot>`, que é o pai do slot onde o
conteúdo é projetado.

Para parar o aviso acima, platform views precisam definir o `style.width` e
`style.height` de seu elemento raiz para qualquer valor apropriado (não-null).

Por exemplo, para fazer o `html.Element` raiz preencher todo o espaço disponível
alocado pelo framework, defina suas propriedades `style.width` e `style.height`
para `'100%'`:

```dart
ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
  final html.Element htmlElement = html.DivElement()
    // ..other props
    ..style.width = '100%'
    ..style.height = '100%';
  // ...
  return htmlElement;
});
```

Se outras técnicas são usadas para fazer o layout da platform view (como `inset: 0`) um
valor de `auto` para `width` e `height` é suficiente para parar o aviso.

Leia mais sobre [`CSS width`][CSS width] e [`CSS height`][CSS height].

### Testes

Após esta mudança, o código de teste do usuário **não** precisa inspecionar profundamente os
conteúdos do shadow root do App. Todos os conteúdos da platform view serão
colocados como filhos diretos de `flt-glass-pane`, envoltos em um
elemento `flt-platform-view`.

Evite olhar dentro do shadow root de `flt-glass-pane`, ele é considerado um
**"detalhe de implementação privado"**, e sua marcação pode mudar a qualquer momento,
sem aviso.

(Veja PRs relevantes abaixo para exemplos das "migrações" descritas acima).

## Cronograma

Disponibilizado na versão: 2.3.0-16.0.pre<br>
Na versão estável: 2.5

## Referências

Documento de design:

* [Using slot to embed web Platform Views][design doc]

Issues relevantes:

* [Issue #80524][issue-80524]

PRs relevantes:

* [flutter/engine#25747][pull-25747]: Introduces the feature.
* [flutter/flutter#82926][pull-82926]: Tweaks `flutter` tests.
* [flutter/plugins#3964][pull-3964]: Tweaks to `plugins` code.
* [flutter/packages#364][pull-364]: Tweaks to `packages` code.

[CSS height]: https://developer.mozilla.org/en-US/docs/Web/CSS/height
[CSS width]: https://developer.mozilla.org/en-US/docs/Web/CSS/width
[HtmlElementView widgets]: {{site.api}}/flutter/widgets/HtmlElementView-class.html
[PlatformViewFactory functions]: {{site.repo.engine}}/blob/58459a5e342f84c755919f2ad5029b22bcddd548/lib/web_ui/lib/src/engine/platform_views/content_manager.dart#L15-L18
[design doc]: /go/web-slot-content
[issue-80524]: {{site.repo.flutter}}/issues/80524
[pull-25747]: {{site.repo.engine}}/pull/25747
[pull-364]: {{site.repo.packages}}/pull/364
[pull-3964]: {{site.github}}/flutter/plugins/pull/3964
[pull-82926]: {{site.repo.flutter}}/pull/82926
[shadow root]: https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot
[slot elements]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/slot
