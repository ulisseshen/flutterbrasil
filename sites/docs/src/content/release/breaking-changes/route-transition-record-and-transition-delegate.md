---
ia-translate: true
title: Atualizações de registro de transição de rota e delegado de transição
description: >
  Mudanças na regra de como o delegado de transição resolve a transição de rota.
---

{% render "docs/breaking-changes.md" %}

## Resumo

Um novo getter booleano `isWaitingForExitingDecision` foi adicionado
ao registro de transição de rota e o getter `isEntering`
foi renomeado para `isWaitingForEnteringDecision`.
No método `resolve()` para o delegado de transição,
use o `isWaitingForExitingDecision` para verificar se uma rota de saída
realmente precisa de uma decisão explícita sobre como fazer a transição
para fora da tela. Se você tentar tomar uma decisão para uma rota existente
que _não_ está esperando por uma decisão, Flutter lança um erro de asserção.

## Contexto

Quando o navigator recebe uma nova lista de páginas, ele tenta atualizar sua
pilha de rotas atual para corresponder à lista. No entanto, ele requer decisões
explícitas sobre como fazer a transição da rota para dentro e para fora da tela.
Anteriormente, rotas que não estavam na nova lista exigiam decisões
sobre como fazer a transição para fora da tela. No entanto, descobrimos mais tarde
que isso nem sempre é verdade. Se uma rota é removida com pop,
mas ainda está esperando a animação de pop terminar,
essa rota ficaria na pilha de rotas do navigator até
que a animação fosse concluída. Se uma atualização de página ocorresse durante esse tempo,
essa rota sai mas não requer uma decisão
sobre como fazer a transição para fora da tela. Portanto,
`isWaitingForExitingDecision` foi adicionado para cobrir esse caso.

O getter `isEntering` também foi renomeado para
`isWaitingForEnteringDecision` para ser mais descritivo,
e também para tornar a nomenclatura mais consistente.

## Guia de migração

Se você implementar seu próprio delegado de transição, você precisa verificar as
rotas de saída usando o getter `isWaitingForExitingDecision` antes de
chamar `markForPop`, `markForComplete`, ou `markForRemove` nelas.
Você também precisa renomear todas as referências de `isEntering` para
`isWaitingForEnteringDecision`.

Código antes da migração:

```dart
import 'package:flutter/widgets.dart';

class NoAnimationTransitionDelegate extends TransitionDelegate<void> {
  @override
  Iterable<RouteTransitionRecord> resolve({
    List<RouteTransitionRecord> newPageRouteHistory,
    Map<RouteTransitionRecord, RouteTransitionRecord> locationToExitingPageRoute,
    Map<RouteTransitionRecord, List<RouteTransitionRecord>> pageRouteToPagelessRoutes,
  }) {
    final List<RouteTransitionRecord> results = <RouteTransitionRecord>[];

    for (final RouteTransitionRecord pageRoute in newPageRouteHistory) {
      if (pageRoute.isEntering) {
        pageRoute.markForAdd();
      }
      results.add(pageRoute);

    }
    for (final RouteTransitionRecord exitingPageRoute in locationToExitingPageRoute.values) {
      exitingPageRoute.markForRemove();
      final List<RouteTransitionRecord> pagelessRoutes = pageRouteToPagelessRoutes[exitingPageRoute];
      if (pagelessRoutes != null) {
        for (final RouteTransitionRecord pagelessRoute in pagelessRoutes) {
          pagelessRoute.markForRemove();
        }
      }
      results.add(exitingPageRoute);

    }
    return results;
  }
}
```

Código após a migração:

```dart
import 'package:flutter/widgets.dart';

class NoAnimationTransitionDelegate extends TransitionDelegate<void> {
  @override
  Iterable<RouteTransitionRecord> resolve({
    List<RouteTransitionRecord> newPageRouteHistory,
    Map<RouteTransitionRecord, RouteTransitionRecord> locationToExitingPageRoute,
    Map<RouteTransitionRecord, List<RouteTransitionRecord>> pageRouteToPagelessRoutes,
  }) {
    final List<RouteTransitionRecord> results = <RouteTransitionRecord>[];

    for (final RouteTransitionRecord pageRoute in newPageRouteHistory) {
      // Renames isEntering to isWaitingForEnteringDecision.
      if (pageRoute.isWaitingForEnteringDecision) {
        pageRoute.markForAdd();
      }
      results.add(pageRoute);

    }
    for (final RouteTransitionRecord exitingPageRoute in locationToExitingPageRoute.values) {
      // Checks the isWaitingForExitingDecision before calling the markFor methods.
      if (exitingPageRoute.isWaitingForExitingDecision) {
        exitingPageRoute.markForRemove();
        final List<RouteTransitionRecord> pagelessRoutes = pageRouteToPagelessRoutes[exitingPageRoute];
        if (pagelessRoutes != null) {
          for (final RouteTransitionRecord pagelessRoute in pagelessRoutes) {
            pagelessRoute.markForRemove();
          }
        }
      }
      results.add(exitingPageRoute);

    }
    return results;
  }
}
```

## Cronograma

Landed in version: 1.18.0<br>
In stable release: 1.20

## Referências

Documentação da API:

* [`Navigator`][`Navigator`]
* [`TransitionDelegate`][`TransitionDelegate`]
* [`RouteTransitionRecord`][`RouteTransitionRecord`]

Issue relevante:

* [Issue 45938: Navigator 2.0][Issue 45938: Navigator 2.0]

PR relevante:

* [PR 55998][PR 55998]: Corrige a falha de atualização de páginas do navigator
  quando ainda há uma rota esperando


[Issue 45938: Navigator 2.0]: {{site.repo.flutter}}/issues/45938
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[PR 55998]: {{site.repo.flutter}}/pull/55998
[`TransitionDelegate`]: {{site.api}}/flutter/widgets/TransitionDelegate-class.html
[`RouteTransitionRecord`]: {{site.api}}/flutter/widgets/RouteTransitionRecord-class.html
