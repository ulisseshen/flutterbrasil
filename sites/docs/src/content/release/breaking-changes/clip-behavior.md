---
title: Comportamento de Clip
description: >
  Flutter unifica clipBehavior e por padrão não faz clip na maioria dos casos.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

O Flutter agora não faz _clip_ por padrão, exceto para alguns widgets especializados
(como `ClipRect`). Para sobrescrever o padrão de não fazer clip,
defina explicitamente `clipBehavior` nas construções de widgets.

## Contexto {:#context}

O Flutter costumava ser lento por causa dos clips. Por exemplo,
o benchmark do aplicativo Flutter gallery tinha um tempo
médio de rasterização de quadros de cerca de 35ms em maio de 2018,
onde o orçamento para renderização suave de 60fps é 16ms.
Ao remover clips desnecessários e suas operações relacionadas,
vimos uma aceleração de quase 2x de 35ms/quadro para 17,5ms/quadro.

{% comment %}
The following two images are not visible.
![](https://lh5.googleusercontent.com/Pn8FxuW2W3Cgvw9kIUvLLenrwXti7WRm_zPif3VJILa325d1Njm8aP47DXfK1r2Du-FwLKhI9umw5nMG6eNqn5fLnQBIt6VIPZ7Q2ETiCuXgQPD1cUYOeA-2Ph_DpvL27fK7m_Af)

Here's a comparison of transition with and without clips.

![](https://lh5.googleusercontent.com/gSFKigrEoekji0juxTVjj29PlIizjuxJsetHsIegLt85zCHknRIUOeICjMdEBjBhPZDZXcEzFh1WCOrdmZa9KZ5vghgS7Uo9IDAKyBtEJ7h3tKfIHXf6A4vxrHfj1a_0kuT6f4r2)
{% endcomment %}

O maior custo associado ao clipping naquela época é que o Flutter
costumava adicionar uma chamada `saveLayer` após cada clip (a menos que fosse um
clip de retângulo simples alinhado ao eixo) para evitar os artefatos de borda sangrada
conforme descrito em [Issue 18057][]. Tais comportamentos eram universais para
aplicativos material através de widgets como `Card`, `Chip`, `Button`, e assim por diante,
o que resultava em `PhysicalShape` e `PhysicalModel` fazendo clip de seu conteúdo.

Uma chamada `saveLayer` é especialmente cara em dispositivos mais antigos porque
cria um alvo de renderização offscreen, e uma troca de alvo de renderização
pode às vezes custar cerca de 1ms.

Mesmo sem a chamada `saveLayer`, um clip ainda é caro
porque se aplica a todos os desenhos subsequentes até que seja restaurado.
Portanto, um único clip pode desacelerar o desempenho em
centenas de operações de desenho.

Além dos problemas de desempenho, o Flutter também sofreu de
alguns problemas de correção, pois o clip não era gerenciado e implementado
em um único lugar. Em vários lugares, `saveLayer` foi inserido
no lugar errado e, portanto, apenas aumentou o custo de desempenho
sem corrigir nenhum artefato de borda sangrada.

Então, unificamos o controle `clipBehavior` e sua implementação nesta
mudança disruptiva. O `clipBehavior` padrão é `Clip.none`
para a maioria dos widgets para economizar desempenho, exceto os seguintes:

* `ClipPath` tem padrão `Clip.antiAlias`
* `ClipRRect` tem padrão `Clip.antiAlias`
* `ClipRect` tem padrão `Clip.hardEdge`
* `Stack` tem padrão `Clip.hardEdge`
* `EditableText` tem padrão `Clip.hardEdge`
* `ListWheelScrollView` tem padrão `Clip.hardEdge`
* `SingleChildScrollView` tem padrão `Clip.hardEdge`
* `NestedScrollView` tem padrão `Clip.hardEdge`
* `ShrinkWrappingViewport` tem padrão `Clip.hardEdge`

## Guia de migração {:#migration-guide}

Você tem 4 opções para migrar seu código:

1. Deixe seu código como está se seu conteúdo não precisar
   ser cortado (por exemplo, nenhum dos filhos dos widgets
   se expande fora do limite de seu pai).
   Isso provavelmente terá um impacto positivo no
   desempenho geral do seu aplicativo.
2. Adicione `clipBehavior: Clip.hardEdge` se você precisar de clipping,
   e clipping sem anti-alias for bom o suficiente para seus
   (e dos seus clientes) olhos. Este é o caso comum
   quando você corta retângulos ou formas com áreas curvas muito pequenas
   (como os cantos de retângulos arredondados).
3. Adicione `clipBehavior: Clip.antiAlias` se você precisar de
   clipping com anti-alias. Isso fornece bordas mais suaves
   com um custo ligeiramente maior. Este é o caso comum ao
   lidar com círculos e arcos.
4. Adicione `clip.antiAliasWithSaveLayer` se você quiser o exato
   mesmo comportamento de antes (maio de 2018). Esteja ciente de que é
   muito custoso em termos de desempenho. É provável que seja necessário apenas
   raramente. Um caso em que você pode precisar disso é se
   você tiver uma imagem sobreposta em uma cor de fundo muito diferente.
   Nesses casos, considere se você pode evitar sobrepor
   várias cores em um ponto (por exemplo, tendo a
   cor de fundo presente apenas onde a imagem está ausente).

Para o widget `Stack` especificamente, se você usou anteriormente
`overflow: Overflow.visible`, substitua por `clipBehavior: Clip.none`.

Para o widget `ListWheelViewport`, se você especificou anteriormente
`clipToSize`, substitua pelo `clipBehavior` correspondente:
`Clip.none` para `clipToSize = false` e
`Clip.hardEdge` para `clipToSize = true`.

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

## Linha do tempo {:#timeline}

Implementado na versão: _várias_<br>
Na versão estável: 2.0.0

## Referências {:#references}

Documentação da API:

* [`Clip`][]

Issues relevantes:

* [Issue 13736][]
* [Issue 18057][]
* [Issue 21830][]

PRs relevantes:

* [PR 5420][]: Remover saveLayer desnecessário
* [PR 18576][]: Adicionar enum Clip ao Material e widgets relacionados
* [PR 18616][]: Remover saveLayer após clip do dart
* [PR 5647][]: Adicionar ClipMode às camadas ClipPath/ClipRRect e PhysicalShape
* [PR 5670][]: Adicionar switch de anti-alias às chamadas de clip do canvas
* [PR 5853][]: Renomear clip mode para clip behavior
* [PR 5868][]: Renomear clip para clipBehavior em compositing.dart
* [PR 5973][]: Chamar drawPaint em vez de drawPath se houver clip
* [PR 5952][]: Chamar drawPath sem clip se possível
* [PR 20205][]: Definir clipBehavior padrão como Clip.none e atualizar testes
* [PR 20538][]: Expor clipBehavior para mais Material Buttons
* [PR 20751][]: Adicionar customBorder ao InkWell para que possa fazer clip de ShapeBorder
* [PR 20752][]: Definir o clip padrão como Clip.none novamente
* [PR 21012][]: Adicionar testes de no-clip padrão para mais botões
* [PR 21703][]: clipBehavior padrão de ClipRect para hardEdge
* [PR 21826][]: Falta clip hardEdge padrão para ClipRectLayer

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
