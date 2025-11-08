---
title: Migration guide for `RouteInformation.location`
description: Deprecation of `RouteInformation.location` and its related APIs.
ia-translate: true
---

## Resumo

`RouteInformation.location` and related APIs were deprecated
in the favor of `RouteInformation.uri`.

## Contextoo

The [`RouteInformation`][] needs the authority information to
handle mobile deeplinks from different web domains.
The `uri` field was added to `RouteInformation` that captures
the entire deeplink information and route-related parameters
were converted to the full [`Uri`][] format.
This led to deprecation of incompatible APIs.

## Descrição da mudança

* The `RouteInformation.location` was replaced by `RouteInformation.uri`.
* The `WidgetBindingObserver.didPushRoute` was deprecated.
* The `location` parameter of `SystemNavigator.routeInformationUpdated` was
  replaced by the newly added `uri` parameter.

## Guia de migração

Código antes da migração:

```dart
const RouteInformation myRoute = RouteInformation(location: '/myroute');
```

Código após a migração:

```dart
final RouteInformation myRoute = RouteInformation(uri: Uri.parse('/myroute'));
```

Código antes da migração:

```dart
final String myPath = myRoute.location;
```

Código após a migração:

```dart
final String myPath = myRoute.uri.path;
```

Código antes da migração:

```dart
class MyObserverState extends State<MyWidget> with WidgetsBindingObserver {
  @override
  Future<bool> didPushRoute(String route) => _handleRoute(route);
}
```

Código após a migração:

```dart
class MyObserverState extends State<MyWidget> with WidgetsBindingObserver {
  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) => _handleRoute(
    Uri.decodeComponent(
      Uri(
        path: uri.path.isEmpty ? '/' : uri.path,
        queryParameters: uri.queryParametersAll.isEmpty ? null : uri.queryParametersAll,
        fragment: uri.fragment.isEmpty ? null : uri.fragment,
      ).toString(),
    )
  );
}
```

Código antes da migração:

```dart
SystemNavigator.routeInformationUpdated(location: '/myLocation');
```

Código após a migração:

```dart
SystemNavigator.routeInformationUpdated(uri: Uri.parse('/myLocation'));
```

## Linha do tempo

Lançado na versão: 3.10.0-13.0.pre<br>
Na versão estável: 3.13.0

## Referências

PRs relevantes:

* [PR 119968][]: Implement url support for
  RouteInformation and didPushRouteInformation.

[PR 119968]: {{site.repo.flutter}}/pull/119968
[`RouteInformation`]: {{site.api}}/flutter/widgets/RouteInformation-class.html
[`Uri`]: {{site.api}}/flutter/dart-core/Uri-class.html
