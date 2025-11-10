---
title: Quando uma rota é removida da pilha, os futuros associados devem ser completados
description: >
  Antes desta alteração incompatível, rotas criadas pelo Navigator e aguardadas por
  resultados podiam nunca ser completadas se a rota fosse removida em vez de fechada (popped).
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

Quando rotas são pushed, desenvolvedores podem aguardá-las para serem notificados quando forem
popped. No entanto, isso não funcionava quando eram removidas porque o future
associado nunca era completado.

## Contexto

Todos os métodos Navigator que chamam `remove` tinham esse problema. Ao usar `complete`,
o problema é devidamente resolvido, permitindo que desenvolvedores passem um resultado.

## Descrição da alteração

Todos os métodos Navigator foram atualizados para não mais chamar `remove`, mas em vez disso
usar `complete`. Menus de contexto agora são construídos a partir do parâmetro
`contextMenuBuilder`.

Todos os métodos que usam diretamente `complete` agora aceitam um parâmetro `result`
opcional para retorná-lo ao future associado. Outros métodos que indiretamente
usam `remove` atualmente retornam `null`. No futuro, podemos estender esses
métodos com uma função de callback opcional para permitir que desenvolvedores lidem com a lógica de pop
em cenários indiretos (como `removeUntil`).

Antes deste PR, os métodos abaixo não podiam retornar um resultado:

```dart
Navigator.of(context).removeRoute(route);
Navigator.of(context).removeRouteBelow(route);
```

Após este PR, os métodos podem retornar um resultado:

```dart
Navigator.of(context).removeRoute(route, result);
Navigator.of(context).removeRouteBelow(route, result);
```

## Guia de migração

Se você implementou `RouteTransitionRecord` e usou `markForRemove`,
você precisa usar `markForComplete` no lugar. `markForRemove` agora está descontinuado.

Para outros desenvolvedores, nenhuma alteração é necessária. O navigator continua a funcionar
como esperado com novas capacidades.

## Linha do tempo

Disponibilizado na versão: 3.31.0-0.0.pre<br>
Na versão estável: 3.32

## Referências

### Documentação da API:

* [`RouteTransitionRecord`]({{site.api}}/flutter/widgets/RouteTransitionRecord-class.html)
* [`Navigator`]({{site.api}}/flutter/widgets/Navigator-class.html)

### Issues relevantes:

* [removeRoute unresolved future]({{site.repo.flutter}}/issues/157505)

### PRs relevantes:

* [feat: removeRoute now calls didComplete]({{site.repo.flutter}}/pull/157725)
