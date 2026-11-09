---
title: Refatoração de Route e Navigator
description: >
  Algumas APIs e assinaturas de função das
  classes Route e Navigator foram alteradas.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

A classe `Route` não gerencia mais suas entries overlay no overlay,
e seu método `install()` não tem mais um parâmetro `insertionPoint`.
A propriedade `isInitialRoute` em `RouteSetting` foi descontinuada,
e `Navigator.pop()` não retorna mais um valor.

## Context

Refatoramos as APIs do navigator para preparar para a nova API de page
e a introdução do widget `Router` conforme descrito no
documento de design do [Router][].
Esta refatoração introduziu algumas mudanças de assinatura de função
para fazer as APIs do navigator existentes continuarem a funcionar
com a nova API de page.

## Description of change

O valor de retorno booleano de `Navigator.pop()` não era bem
definido, e o usuário poderia alcançar o mesmo resultado chamando
`Navigator.canPop()`.
Como a API para `Navigator.canPop()` era melhor definida,
simplificamos `Navigator.pop()` para não retornar um valor booleano.

Por outro lado, o navigator requer a capacidade
de reorganizar manualmente entries no overlay para permitir
que o usuário altere o histórico de rotas na nova API.
Mudamos para que a route apenas crie e destrua
suas overlay entries, enquanto o navigator insere ou
remove overlay entries do overlay.
Também removemos o argumento `insertionPoint` de
`Route.install()` porque ficou obsoleto após a mudança.

Finalmente, removemos a propriedade `isInitialRoute` de
`RouteSetting` como parte da refatoração, e fornecemos a
API `onGenerateInitialRoutes` para controle completo da
geração de rotas iniciais.

## Migration guide

Caso 1: Uma aplicação depende de `pop()` retornando um valor booleano.

```dart
TextField(
  onTap: () {
    if (Navigator.pop(context))
      print('There still is at least one route after pop');
    else
      print('Oops! No more routes.');
  }
)
```

Você poderia usar `Navigator.canPop()` em combinação com
`Navigator.pop()` para alcançar o mesmo resultado.

```dart
TextField(
  onTap: () {
    if (Navigator.canPop(context))
      print('There still is at least one route after pop');
    else
      print('Oops! No more routes.');
    // Our navigator pops the route anyway.
    Navigator.pop(context);
  }
)
```

Caso 2: Uma aplicação gera rotas baseadas em `isInitialRoute`.

```dart
MaterialApp(
  onGenerateRoute: (RouteSetting setting) {
    if (setting.isInitialRoute)
      return FakeSplashRoute();
    else
      return RealRoute(setting);
  }
)
```

Existem diferentes maneiras de migrar esta mudança.
Uma maneira é definir um valor explícito para `MaterialApp.initialRoute`.
Você pode então testar este valor no lugar de `isInitialRoute`.
Como `initialRoute` herda seu valor padrão fora do escopo do Flutter,
você deve definir um valor explícito para ele.

```dart
MaterialApp(
  initialRoute: '/', // Set this value explicitly. Default might be altered.
  onGenerateRoute: (RouteSetting setting) {
    if (setting.name == '/')
      return FakeSplashRoute();
    else
      return RealRoute(setting);
  }
)
```

Se houver um caso de uso mais complicado,
você pode usar a nova API, `onGenerateInitialRoutes`,
em `MaterialApp` ou `CupertinoApp`.

```dart
MaterialApp(
  onGenerateRoute: (RouteSetting setting) {
    return RealRoute(setting);
  },
  onGenerateInitialRoutes: (String initialRouteName) {
    return <Route>[FakeSplashRoute()];
  }
)
```

## Timeline

Landed in version: 1.16.3<br>
In stable release: 1.17

## References

Design doc:

* [Router][]

API documentation:

* [`Route`][]
* [`Route.install`][]
* [`RouteSetting.isInitialRoute`][]
* [`Navigator`][]
* [`Navigator.pop`][]
* [`Navigator.canPop`][]

Relevant issue:

* [Issue 45938: Router][]

Relevant PR:

* [PR 44930][] - Refactor the imperative api to continue working in the new navigation system


[Issue 45938: Router]: {{site.repo.flutter}}/issues/45938
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`Navigator.pop`]: {{site.api}}/flutter/widgets/Navigator/pop.html
[`Navigator.canPop`]: {{site.api}}/flutter/widgets/Navigator/canPop.html
[Router]: /go/navigator-with-router
[PR 44930]: {{site.repo.flutter}}/pull/44930
[`Route`]: {{site.api}}/flutter/widgets/Route-class.html
[`Route.install`]: {{site.api}}/flutter/widgets/Route/install.html
[`RouteSetting.isInitialRoute`]: {{site.api}}/flutter/widgets/RouteSettings/isInitialRoute.html
