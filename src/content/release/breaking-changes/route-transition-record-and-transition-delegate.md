---
ia-translate: true
title: Registro de transição de rota e atualizações do delegate de transição
description: >
  Alterações na regra de como o delegate de transição resolve a transição de rota.
---

## Resumo

Um novo getter booleano `isWaitingForExitingDecision` foi adicionado ao registro de transição
de rota e o getter `isEntering` foi renomeado para `isWaitingForEnteringDecision`.
No método `resolve()` para o delegate de transição, use o `isWaitingForExitingDecision`
para verificar se uma rota de saída realmente precisa de uma decisão explícita sobre como
fazer a transição para fora da tela. Se você tentar tomar uma decisão para uma rota existente
que _não_ está esperando por uma decisão, o Flutter gera um erro de asserção.

## Contexto

Quando o navegador recebe uma nova lista de páginas, ele tenta atualizar sua pilha de rotas
atual para corresponder à lista. No entanto, requer decisões explícitas sobre como fazer
a transição da rota para dentro e para fora da tela. Anteriormente, as rotas que não
estavam na nova lista exigiam decisões sobre como fazer a transição para fora da tela.
No entanto, descobrimos mais tarde que nem sempre é verdade. Se uma rota é retirada,
mas ainda está esperando que a animação de retirada termine, essa rota permaneceria na
pilha de rotas do navegador até que a animação fosse concluída. Se uma atualização de
página ocorresse durante esse tempo, essa rota sairia, mas não exigiria uma decisão
sobre como fazer a transição para fora da tela. Portanto, `isWaitingForExitingDecision`
foi adicionado para cobrir esse caso.

O getter `isEntering` também foi renomeado para `isWaitingForEnteringDecision` para ser
mais descritivo e também para tornar a nomenclatura mais consistente.

## Guia de migração

Se você implementar seu próprio delegate de transição, você precisa verificar as rotas
de saída usando o getter `isWaitingForExitingDecision` antes de chamar `markForPop`,
`markForComplete` ou `markForRemove` nelas. Você também precisa renomear todas as
referências de `isEntering` para `isWaitingForEnteringDecision`.

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
      // Renomeia isEntering para isWaitingForEnteringDecision.
      if (pageRoute.isWaitingForEnteringDecision) {
        pageRoute.markForAdd();
      }
      results.add(pageRoute);

    }
    for (final RouteTransitionRecord exitingPageRoute in locationToExitingPageRoute.values) {
      // Verifica o isWaitingForExitingDecision antes de chamar os métodos markFor.
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

## Cronologia

Incluído na versão: 1.18.0<br>
Na versão estável: 1.20

## Referências

Documentação da API:

* [`Navigator`][]
* [`TransitionDelegate`][]
* [`RouteTransitionRecord`][]

Problema relevante:

* [Issue 45938: Navigator 2.0][]

PR relevante:

* [PR 55998][]: Corrige a falha na atualização de páginas do navegador
  quando ainda há uma rota esperando


[Issue 45938: Navigator 2.0]: {{site.repo.flutter}}/issues/45938
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[PR 55998]: {{site.repo.flutter}}/pull/55998
[`TransitionDelegate`]: {{site.api}}/flutter/widgets/TransitionDelegate-class.html
[`RouteTransitionRecord`]: {{site.api}}/flutter/widgets/RouteTransitionRecord-class.html

