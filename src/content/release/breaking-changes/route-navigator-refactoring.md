---
ia-translate: true
title: Refatoração de Rotas e Navigator
description: >
  Algumas APIs e assinaturas de função das classes
  Route e Navigator foram alteradas.
---

## Resumo

A classe `Route` não gerencia mais suas entradas de overlay no overlay, e seu método `install()` não possui mais um parâmetro `insertionPoint`. A propriedade `isInitialRoute` em `RouteSetting` foi depreciada e `Navigator.pop()` não retorna mais um valor.

## Contexto

Refatoramos as APIs do navigator para preparar para a nova API de página e a introdução do widget `Router`, conforme descrito no documento de design [Router][]. Essa refatoração introduziu algumas mudanças na assinatura da função para que as APIs existentes do navigator continuem funcionando com a nova API de página.

## Descrição da mudança

O valor booleano de retorno de `Navigator.pop()` não era bem definido e o usuário poderia obter o mesmo resultado chamando `Navigator.canPop()`. Como a API para `Navigator.canPop()` foi melhor definida, simplificamos `Navigator.pop()` para não retornar um valor booleano.

Por outro lado, o navigator exige a capacidade de reorganizar manualmente as entradas no overlay para permitir que o usuário altere o histórico de rotas na nova API. Alteramos para que a rota apenas crie e destrua suas entradas de overlay, enquanto o navigator insere ou remove entradas de overlay do overlay. Também removemos o argumento `insertionPoint` de `Route.install()` porque estava obsoleto após a alteração.

Finalmente, removemos a propriedade `isInitialRoute` de `RouteSetting` como parte da refatoração e fornecemos a API `onGenerateInitialRoutes` para controle total da geração de rotas iniciais.

## Guia de migração

Caso 1: Um aplicativo depende de `pop()` retornando um valor booleano.

```dart
TextField(
  onTap: () {
    if (Navigator.pop(context))
      print('Ainda há pelo menos uma rota após o pop');
    else
      print('Ops! Não há mais rotas.');
  }
)
```

Você pode usar `Navigator.canPop()` em combinação com `Navigator.pop()` para obter o mesmo resultado.

```dart
TextField(
  onTap: () {
    if (Navigator.canPop(context))
      print('Ainda há pelo menos uma rota após o pop');
    else
      print('Ops! Não há mais rotas.');
    // Nosso navigator remove a rota de qualquer forma.
    Navigator.pop(context);
  }
)
```

Caso 2: Um aplicativo gera rotas com base em `isInitialRoute`.

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

Existem diferentes maneiras de migrar essa mudança. Uma maneira é definir um valor explícito para `MaterialApp.initialRoute`. Você pode então testar esse valor no lugar de `isInitialRoute`. Como `initialRoute` herda seu valor padrão fora do escopo do Flutter, você deve definir um valor explícito para ele.

```dart
MaterialApp(
  initialRoute: '/', // Defina este valor explicitamente. O padrão pode ser alterado.
  onGenerateRoute: (RouteSetting setting) {
    if (setting.name == '/')
      return FakeSplashRoute();
    else
      return RealRoute(setting);
  }
)
```

Se houver um caso de uso mais complicado, você pode usar a nova API, `onGenerateInitialRoutes`, em `MaterialApp` ou `CupertinoApp`.

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

## Cronograma

Implementado na versão: 1.16.3<br>
Na versão estável: 1.17

## Referências

Documento de design:

* [Router][]

Documentação da API:

* [`Route`][]
* [`Route.install`][]
* [`RouteSetting.isInitialRoute`][]
* [`Navigator`][]
* [`Navigator.pop`][]
* [`Navigator.canPop`][]

Issue relevante:

* [Issue 45938: Router][]

PR relevante:

* [PR 44930][] - Refatorar a api imperativa para continuar funcionando no novo sistema de navegação


[Issue 45938: Router]: {{site.repo.flutter}}/issues/45938
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`Navigator.pop`]: {{site.api}}/flutter/widgets/Navigator/pop.html
[`Navigator.canPop`]: {{site.api}}/flutter/widgets/Navigator/canPop.html
[Router]: /go/navigator-with-router
[PR 44930]: {{site.repo.flutter}}/pull/44930
[`Route`]: {{site.api}}/flutter/widgets/Route-class.html
[`Route.install`]: {{site.api}}/flutter/widgets/Route/install.html
[`RouteSetting.isInitialRoute`]: {{site.api}}/flutter/widgets/RouteSettings/isInitialRoute.html
