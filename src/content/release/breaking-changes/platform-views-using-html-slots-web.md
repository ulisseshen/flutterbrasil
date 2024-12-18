---
ia-translate: true
title: Usando slots HTML para renderizar visualizações de plataforma na web
description: >
  iframes no Flutter web costumavam recarregar, devido à forma como
  algumas operações DOM eram feitas.
  Uma mudança na forma como os aplicativos Flutter web renderizam visualizações
  de plataforma os torna estáveis (impedindo recarregamentos de iframe e
  outros problemas com tags de vídeo ou formulários que potencialmente
  perdem seu estado).
---

## Resumo

O Flutter agora renderiza todas as visualizações de plataforma web em um local
consistente do DOM, como filhos diretos de `flt-glass-pane` (independentemente
do backend de renderização: `html` ou `canvaskit`). As visualizações de
plataforma são então _"encaixadas"_ na posição correta do DOM do App com
recursos HTML padrão.

Até esta alteração, o Flutter web mudava o estilo do conteúdo renderizado de
visualizações de plataforma para posicioná-lo/dimensioná-lo para o espaço
disponível. **Este não é mais o caso.** Os usuários agora podem decidir como
desejam utilizar o espaço alocado para sua visualização de plataforma pelo
framework.

## Contexto

O framework Flutter frequentemente ajusta sua árvore de renderização para
otimizar as operações de pintura que são feitas por frame. Na web, essas
mudanças na árvore de renderização geralmente resultam em operações DOM.

O Flutter web costumava renderizar suas visualizações de plataforma
([widgets `HtmlElementView`][]) diretamente em sua posição correspondente no
DOM.

Usar certos elementos DOM como "alvo" de algumas operações DOM faz com que
esses elementos percam seu estado interno. Na prática, isso significa que tags
`iframe` vão recarregar, players de `video` podem reiniciar ou um formulário
editável pode perder suas edições.

O Flutter agora renderiza visualizações de plataforma usando [elementos slot][]
dentro de um único [shadow root][] em todo o aplicativo. Elementos slot podem
ser adicionados/removidos/movidos no Shadow DOM sem afetar o conteúdo encaixado
subjacente (que é renderizado em um local constante).

Essa mudança foi feita para:

* Estabilizar o comportamento das visualizações de plataforma no Flutter web.
* Unificar como as visualizações de plataforma são renderizadas na web para
  ambos os backends de renderização (`html` e `canvaskit`).
* Fornecer um local previsível no DOM que permita aos desenvolvedores usar CSS
  de forma confiável para estilizar suas visualizações de plataforma e usar
  outras APIs DOM padrão, como `querySelector` e `getElementById`.

## Descrição da mudança

Um aplicativo Flutter web agora é renderizado dentro de um [shadow root][]
comum no qual [elementos slot][] representam visualizações de plataforma. O
conteúdo real de cada visualização de plataforma é renderizado como um
**irmão do dito shadow root**.

### Antes

```html
...

<flt-glass-pane>
  ...
  <div id="platform-view">Conteúdo</div> <!-- canvaskit -->
  <!-- OU -->
  <flt-platform-view>
    #shadow-root
    | <div id="platform-view">Conteúdo</div> <!-- html -->
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
    <div id="platform-view">Conteúdo</div>
  </flt-platform-view>
  ...
</flt-glass-pane>

...
```

Após essa alteração, quando o framework precisa mover nós DOM, ele opera sobre
`flt-platform-view-slot`s, que contêm apenas um elemento `slot`. O slot
_projeta_ o conteúdo definido em elementos `flt-platform-view` fora do shadow
root. Elementos `flt-platform-view` nunca são o alvo de operações DOM do
framework, evitando assim os problemas de recarregamento.

Do ponto de vista de um aplicativo, essa mudança é transparente.
**No entanto**, isso é considerado uma _mudança incompatível_ porque alguns
testes fazem suposições sobre o DOM interno de um aplicativo Flutter web e
quebram.

## Guia de migração

### Código

O engine pode imprimir uma mensagem de aviso no console semelhante a:

```bash
A altura do tipo de visualização de plataforma: [$viewType] pode não ser definida. Usando `height: 100%` por padrão.
Defina `style.height` para qualquer valor apropriado para interromper esta mensagem.
```

ou:

```bash
A largura do tipo de visualização de plataforma: [$viewType] pode não ser definida. Usando `width: 100%` por padrão.
Defina `style.width` para qualquer valor apropriado para interromper esta mensagem.
```

Anteriormente, o conteúdo retornado pelas funções [`PlatformViewFactory`][] era
redimensionado e posicionado pelo framework. Em vez disso, o Flutter agora
dimensiona e posiciona `<flt-platform-view-slot>`, que é o pai do slot onde o
conteúdo é projetado.

Para interromper o aviso acima, as visualizações de plataforma precisam definir
`style.width` e `style.height` de seu elemento raiz para qualquer valor
apropriado (não nulo).

Por exemplo, para fazer com que o `html.Element` raiz preencha todo o espaço
disponível alocado pelo framework, defina suas propriedades `style.width` e
`style.height` como `'100%'`:

```dart
ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
  final html.Element htmlElement = html.DivElement()
    // ..outras props
    ..style.width = '100%'
    ..style.height = '100%';
  // ...
  return htmlElement;
});
```

Se outras técnicas forem usadas para organizar a visualização da plataforma
(como `inset: 0`), um valor de `auto` para `width` e `height` é suficiente para
interromper o aviso.

Leia mais sobre [`CSS width`][] e [`CSS height`][].

### Testes

Após essa alteração, o código de teste do usuário **não** precisa inspecionar
profundamente o conteúdo do shadow root do aplicativo. Todo o conteúdo da
visualização de plataforma será colocado como filhos diretos de
`flt-glass-pane`, envolvido em um elemento `flt-platform-view`.

Evite olhar dentro do shadow root `flt-glass-pane`, ele é considerado um
**"detalhe de implementação privada"**, e sua marcação pode mudar a qualquer
momento, sem aviso prévio.

(Veja PRs relevantes abaixo para exemplos das "migrações" descritas acima).

## Cronograma

Implementado na versão: 2.3.0-16.0.pre<br>
Em versão estável: 2.5

## Referências

Documento de design:

* [Usando slot para incorporar visualizações de plataforma web][design doc]

Problemas relevantes:

* [Issue #80524][issue-80524]

PRs relevantes:

* [flutter/engine#25747][pull-25747]: Introduz o recurso.
* [flutter/flutter#82926][pull-82926]: Ajustes em testes do `flutter`.
* [flutter/plugins#3964][pull-3964]: Ajustes no código de `plugins`.
* [flutter/packages#364][pull-364]: Ajustes no código de `packages`.

[`CSS height`]: https://developer.mozilla.org/en-US/docs/Web/CSS/height
[`CSS width`]: https://developer.mozilla.org/en-US/docs/Web/CSS/width
[`HtmlElementView` widgets]: {{site.api}}/flutter/widgets/HtmlElementView-class.html
[`PlatformViewFactory` functions]: {{site.repo.engine}}/blob/58459a5e342f84c755919f2ad5029b22bcddd548/lib/web_ui/lib/src/engine/platform_views/content_manager.dart#L15-L18
[design doc]: /go/web-slot-content
[issue-80524]: {{site.repo.flutter}}/issues/80524
[pull-25747]: {{site.repo.engine}}/pull/25747
[pull-364]: {{site.repo.packages}}/pull/364
[pull-3964]: {{site.github}}/flutter/plugins/pull/3964
[pull-82926]: {{site.repo.flutter}}/pull/82926
[shadow root]: https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot
[slot elements]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/slot

