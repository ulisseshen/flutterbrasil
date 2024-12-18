---
ia-translate: true
title: Rolagem Multitoque Padrão
description: >
  ScrollBehaviors agora configurarão como Scrollables respondem a
  gestos multitoque.
---

## Resumo

`ScrollBehavior`s agora permitem ou proíbem que as velocidades de rolagem sejam
afetadas pelo número de ponteiros na tela.
`ScrollBehavior.multitouchDragStrategy`, por padrão, impede que vários ponteiros
interagindo com o scrollable ao mesmo tempo afetem a velocidade da rolagem.

## Contexto

Antes desta mudança, para cada ponteiro arrastando um widget `Scrollable`, a
velocidade de rolagem aumentaria. Isso não correspondia às expectativas da
plataforma ao interagir com aplicações Flutter.

Agora, o `ScrollBehavior` herdado gerencia como vários ponteiros afetam os
widgets de rolagem, conforme especificado por
`ScrollBehavior.multitouchDragStrategy`. Este enum, `MultitouchDragStrategy`,
também pode ser configurado para o comportamento anterior.

## Descrição da mudança

Esta mudança corrigiu a capacidade inesperada de aumentar as velocidades de
rolagem arrastando com mais de um dedo.

Se você dependeu do comportamento anterior em sua aplicação, existem várias
maneiras de controlar e configurar este recurso.

- Estenda `ScrollBehavior`, `MaterialScrollBehavior` ou
  `CupertinoScrollBehavior` para modificar o comportamento padrão,
  substituindo `ScrollBehavior.multitouchDragStrategy`.

    - Com seu próprio `ScrollBehavior`, você pode aplicá-lo em toda a aplicação
      definindo `MaterialApp.scrollBehavior` ou `CupertinoApp.scrollBehavior`.
    - Ou, se você deseja aplicá-lo apenas a widgets específicos, adicione uma
      `ScrollConfiguration` acima do widget em questão com seu `ScrollBehavior`
      personalizado.

Seus widgets roláveis então herdam e refletem este comportamento.

- Em vez de criar seu próprio `ScrollBehavior`, outra opção para alterar o
  comportamento padrão é copiar o `ScrollBehavior` existente e definir uma
  `multitouchDragStrategy` diferente.
    - Crie um `ScrollConfiguration` em sua árvore de widgets e forneça uma cópia
      modificada do `ScrollBehavior` existente no contexto atual usando
      `copyWith`.

Para acomodar a nova configuração, `DragGestureRecognizer` foi atualizado para
suportar `MultitouchDragStrategy` também em outros contextos de arrasto.

## Guia de Migração

### Definindo um `ScrollBehavior` personalizado para sua aplicação

Código antes da migração:

```dart
MaterialApp(
  // ...
);
```

Código após a migração:

```dart
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Substitua métodos de comportamento e getters como multitouchDragStrategy
  @override
  MultitouchDragStrategy getMultitouchDragStrategy(BuildContext context) => MultitouchDragStrategy.sumAllPointers;
}

// Define ScrollBehavior para uma aplicação inteira.
MaterialApp(
  scrollBehavior: MyCustomScrollBehavior(),
  // ...
);
```

### Definindo um `ScrollBehavior` personalizado para um widget específico

Código antes da migração:

```dart
final ScrollController controller = ScrollController();
ListView.builder(
  controller: controller,
  itemBuilder: (BuildContext context, int index) {
    return Text('Item $index');
  },
);
```

Código após a migração:

```dart
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Substitua métodos de comportamento e getters como multitouchDragStrategy
  @override
  MultitouchDragStrategy getMultitouchDragStrategy(BuildContext context) => MultitouchDragStrategy.sumAllPointers;
}

// ScrollBehavior pode ser definido para um widget específico.
final ScrollController controller = ScrollController();
ScrollConfiguration(
  behavior: MyCustomScrollBehavior(),
  child: ListView.builder(
    controller: controller,
    itemBuilder: (BuildContext context, int index) {
      return Text('Item $index');
    },
  ),
);
```

### Copiar e modificar `ScrollBehavior` existente

Código antes da migração:

```dart
final ScrollController controller = ScrollController();
ListView.builder(
  controller: controller,
  itemBuilder: (BuildContext context, int index) {
    return Text('Item $index');
  },
);
```

Código após a migração:

```dart
// ScrollBehavior pode ser copiado e ajustado.
final ScrollController controller = ScrollController();
ScrollConfiguration(
  behavior: ScrollConfiguration.of(context).copyWith(
    multitouchDragStrategy: MultitouchDragStrategy.sumAllPointers,
  ),
  child: ListView.builder(
    controller: controller,
    itemBuilder: (BuildContext context, int index) {
      return Text('Item $index');
    },
  ),
);
```

## Linha do tempo

Implementado na versão: 3.18.0-4.0.pre<br>
Na versão estável: 3.19.0

## Referências

Documentação da API:

* [`ScrollConfiguration`][]
* [`ScrollBehavior`][]
* [`MaterialScrollBehavior`][]
* [`CupertinoScrollBehavior`][]
* [`MultitouchDragStrategy`][]
* [`DragGestureRecognizer`][]

Issue relevante:

* [Issue #11884][]

PRs relevantes:

* [Introduce multi-touch drag strategies for DragGestureRecognizer][]

[`ScrollConfiguration`]: {{site.api}}/flutter/widgets/ScrollConfiguration-class.html
[`ScrollBehavior`]: {{site.api}}/flutter/widgets/ScrollBehavior-class.html
[`MaterialScrollBehavior`]: {{site.api}}/flutter/material/MaterialScrollBehavior-class.html
[`CupertinoScrollBehavior`]: {{site.api}}/flutter/cupertino/CupertinoScrollBehavior-class.html
[`MultitouchDragStrategy`]: {{site.api}}/flutter/gestures/MultitouchDragStrategy.html
[`DragGestureRecognizer`]: {{site.api}}/flutter/gestures/DragGestureRecognizer-class.html
[Issue #11884]: {{site.repo.flutter}}/issues/11884
[Introduce multi-touch drag strategies for DragGestureRecognizer]: {{site.repo.flutter}}/pull/136708
