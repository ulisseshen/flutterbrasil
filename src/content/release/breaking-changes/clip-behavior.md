---
ia-translate: true
title: Comportamento de Clip (Clip Behavior)
description: >
  Flutter unifica o clipBehavior e, por padrão, não faz clip na maioria dos
  casos.
---

## Resumo

O Flutter agora, por padrão, _não_ faz clip, exceto em alguns widgets
especializados (como `ClipRect`). Para substituir o padrão de "não clip",
defina explicitamente `clipBehavior` nas construções de widgets.

## Contexto

O Flutter costumava ser lento por causa dos clips. Por exemplo, o benchmark
do aplicativo de galeria do Flutter tinha um tempo médio de rasterização
de quadros de cerca de 35ms em maio de 2018, onde o orçamento para uma
renderização suave de 60fps é de 16ms. Ao remover clips desnecessários e
suas operações relacionadas, vimos uma aceleração de quase 2x, de 35ms/quadro
para 17,5ms/quadro.

{% comment %}
As duas imagens a seguir não são visíveis.
![](https://lh5.googleusercontent.com/Pn8FxuW2W3Cgvw9kIUvLLenrwXti7WRm_zPif3VJILa325d1Njm8aP47DXfK1r2Du-FwLKhI9umw5nMG6eNqn5fLnQBIt6VIPZ7Q2ETiCuXgQPD1cUYOeA-2Ph_DpvL27fK7m_Af)

Aqui está uma comparação da transição com e sem clips.

![](https://lh5.googleusercontent.com/gSFKigrEoekji0juxTVjj29PlIizjuxJsetHsIegLt85zCHknRIUOeICjMdEBjBhPZDZXcEzFh1WCOrdmZa9KZ5vghgS7Uo9IDAKyBtEJ7h3tKfIHXf6A4vxrHfj1a_0kuT6f4r2)
{% endcomment %}

O maior custo associado ao clipping naquela época é que o Flutter costumava
adicionar uma chamada `saveLayer` após cada clip (a menos que fosse um simples
clipe de retângulo alinhado ao eixo) para evitar os artefatos de borda
sangrando, conforme descrito na [Issue 18057][]. Tais comportamentos eram
universais para aplicativos Material através de widgets como `Card`,
`Chip`, `Button`, e assim por diante, o que resultava em `PhysicalShape` e
`PhysicalModel` cortando seu conteúdo.

Uma chamada `saveLayer` é especialmente cara em dispositivos mais antigos
porque cria um alvo de renderização fora da tela, e uma troca de alvo de
renderização pode às vezes custar cerca de 1ms.

Mesmo sem a chamada `saveLayer`, um clip ainda é caro porque se aplica a
todos os desenhos subsequentes até que seja restaurado. Portanto, um único
clip pode diminuir o desempenho em centenas de operações de desenho.

Além dos problemas de desempenho, o Flutter também sofria de alguns
problemas de correção, pois o clip não era gerenciado e implementado em um
único local. Em vários lugares, `saveLayer` era inserido no lugar errado e,
portanto, apenas aumentava o custo de desempenho sem corrigir nenhum
artefato de borda sangrando.

Então, unificamos o controle `clipBehavior` e sua implementação nesta
mudança de quebra. O `clipBehavior` padrão é `Clip.none` para a maioria dos
widgets para economizar desempenho, exceto os seguintes:

*   `ClipPath` padroniza para `Clip.antiAlias`
*   `ClipRRect` padroniza para `Clip.antiAlias`
*   `ClipRect` padroniza para `Clip.hardEdge`
*   `Stack` padroniza para `Clip.hardEdge`
*   `EditableText` padroniza para `Clip.hardEdge`
*   `ListWheelScrollView` padroniza para `Clip.hardEdge`
*   `SingleChildScrollView` padroniza para `Clip.hardEdge`
*   `NestedScrollView` padroniza para `Clip.hardEdge`
*   `ShrinkWrappingViewport` padroniza para `Clip.hardEdge`

## Guia de migração

Você tem 4 opções para migrar seu código:

1. Deixe seu código como está se o seu conteúdo não precisar ser cortado
    (por exemplo, nenhum dos filhos dos widgets se expande para fora dos
    limites de seu pai). Isso provavelmente terá um impacto positivo no
    desempenho geral do seu aplicativo.
2. Adicione `clipBehavior: Clip.hardEdge` se você precisar de clipping e o
    clipping sem anti-alias for bom o suficiente para seus olhos (e os de
    seus clientes). Este é o caso comum quando você corta retângulos ou
    formas com áreas curvas muito pequenas (como os cantos de retângulos
    arredondados).
3. Adicione `clipBehavior: Clip.antiAlias` se você precisar de clipping com
    anti-aliasing. Isso lhe dá bordas mais suaves a um custo ligeiramente
    maior. Este é o caso comum ao lidar com círculos e arcos.
4. Adicione `clip.antiAliasWithSaveLayer` se você quiser o mesmo
    comportamento de antes (maio de 2018). Esteja ciente de que é muito
    custoso em termos de desempenho. Isso provavelmente só será necessário
    raramente. Um caso em que você pode precisar disso é se você tiver uma
    imagem sobreposta a uma cor de fundo muito diferente. Nesses casos,
    considere se você pode evitar a sobreposição de várias cores em um
    ponto (por exemplo, fazendo com que a cor de fundo esteja presente
    apenas onde a imagem está ausente).

Para o widget `Stack` especificamente, se você usou anteriormente
`overflow: Overflow.visible`, substitua-o por `clipBehavior: Clip.none`.

Para o widget `ListWheelViewport`, se você especificou anteriormente
`clipToSize`, substitua-o pelo `clipBehavior` correspondente: `Clip.none`
para `clipToSize = false` e `Clip.hardEdge` para `clipToSize = true`.

Código antes da migração:

```dart
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: Stack(
            overflow: Overflow.visible,
            children: const <Widget>[
              SizedBox(
                width: 100,
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
```

Código após a migração:

```dart
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: const <Widget>[
              SizedBox(
                width: 100.0,
                height: 100.0,
              ),
            ],
          ),
        ),
      ),
    );
```

## Linha do tempo

Lançado na versão: *várias*<br>
Na versão estável: 2.0.0

## Referências

Documentação da API:

*   [`Clip`][]

Issues relevantes:

*   [Issue 13736][]
*   [Issue 18057][]
*   [Issue 21830][]

PRs relevantes:

*   [PR 5420][]: Remove unnecessary saveLayer
*   [PR 18576][]: Add Clip enum to Material and related widgets
*   [PR 18616][]: Remove saveLayer after clip from dart
*   [PR 5647][]: Add ClipMode to ClipPath/ClipRRect and PhysicalShape layers
*   [PR 5670][]: Add anti-alias switch to canvas clip calls
*   [PR 5853][]: Rename clip mode to clip behavior
*   [PR 5868][]: Rename clip to clipBehavior in compositing.dart
*   [PR 5973][]: Call drawPaint instead of drawPath if there's clip
*   [PR 5952][]: Call drawPath without clip if possible
*   [PR 20205][]: Set default clipBehavior to Clip.none and update tests
*   [PR 20538][]: Expose clipBehavior to more Material Buttons
*   [PR 20751][]: Add customBorder to InkWell so it can clip ShapeBorder
*   [PR 20752][]: Set the default clip to Clip.none again
*   [PR 21012][]: Add default-no-clip tests to more buttons
*   [PR 21703][]: Default clipBehavior of ClipRect to hardEdge
*   [PR 21826][]: Missing default hardEdge clip for ClipRectLayer

[PR 5420]:  {{site.repo.engine}}/pull/5420
[PR 5647]:  {{site.repo.engine}}/pull/5647
[PR 5670]:  {{site.repo.engine}}/pull/5670
[PR 5853]:  {{site.repo.engine}}/pull/5853
[PR 5868]:  {{site.repo.engine}}/pull/5868
[PR 5952]:  {{site.repo.engine}}/pull/5952
[PR 5973]:  {{site.repo.engine}}/pull/5937
[PR 18576]: {{site.repo.flutter}}/pull/18576
[PR 18616]: {{site.repo.flutter}}/pull/18616
[PR 20205]: {{site.repo.flutter}}/pull/20205
[PR 20538]: {{site.repo.flutter}}/pull/20538
[PR 20751]: {{site.repo.flutter}}/pull/20751
[PR 20752]: {{site.repo.flutter}}/pull/20752
[PR 21012]: {{site.repo.flutter}}/pull/21012
[PR 21703]: {{site.repo.flutter}}/pull/21703
[PR 21826]: {{site.repo.flutter}}/pull/21826

[`Clip`]: {{site.api}}/flutter/dart-ui/Clip.html
[Issue 13736]: {{site.repo.flutter}}/issues/13736
[Issue 18057]: {{site.repo.flutter}}/issues/18057
[Issue 21830]: {{site.repo.flutter}}/issues/21830
