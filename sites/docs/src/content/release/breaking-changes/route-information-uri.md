---
title: Guia de migração para `RouteInformation.location`
description: Descontinuação de `RouteInformation.location` e das APIs relacionadas.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

`RouteInformation.location` e as APIs relacionadas foram descontinuadas
em favor de `RouteInformation.uri`.

## Contexto

O [`RouteInformation`][] precisa das informações de autoridade para
tratar deep links de aplicativos móveis vindos de domínios web diferentes.
O campo `uri` foi adicionado a `RouteInformation` para capturar
todas as informações do deep link, e os parâmetros relacionados à rota
foram convertidos para o formato completo [`Uri`][].
Isso levou à descontinuação de APIs incompatíveis.

## Descrição da mudança

* `RouteInformation.location` foi substituído por `RouteInformation.uri`.
* `WidgetBindingObserver.didPushRoute` foi descontinuado.
* O parâmetro `location` de `SystemNavigator.routeInformationUpdated` foi
  substituído pelo parâmetro `uri`, recém-adicionado.

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

Incluído na versão: 3.10.0-13.0.pre<br>
Na versão estável: 3.13.0

## Referências

PRs relevantes:

* [PR 119968][]: Implementa suporte a URL para
  RouteInformation e didPushRouteInformation.

[PR 119968]: {{site.repo.flutter}}/pull/119968
[`RouteInformation`]: {{site.api}}/flutter/widgets/RouteInformation-class.html
[`Uri`]: {{site.api}}/flutter/dart-core/Uri-class.html
