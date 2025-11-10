---
title: Dispositivos de arrasto de rolagem padrão
description: >
  ScrollBehaviors agora configuram quais
  PointerDeviceKinds podem arrastar Scrollables.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

`ScrollBehavior`s agora permitem ou não permitem arrasto de rolagem de
`PointerDeviceKind`s especificados. `ScrollBehavior.dragDevices`, por padrão,
permite que widgets de rolagem sejam arrastados por todos os `PointerDeviceKind`s
exceto por `PointerDeviceKind.mouse`.

## Context

Antes desta mudança, todos os `PointerDeviceKind`s podiam arrastar um widget `Scrollable`.
Isso não correspondia às expectativas do desenvolvedor ao interagir com aplicações Flutter
usando dispositivos de entrada do tipo mouse. Isso também dificultava a execução de
outros gestos do mouse, como selecionar texto contido em um widget `Scrollable`.

Agora, o `ScrollBehavior` herdado gerencia quais dispositivos podem arrastar widgets de rolagem
conforme especificado por `ScrollBehavior.dragDevices`. Este conjunto de `PointerDeviceKind`s tem
permissão para arrastar.

## Description of change

Esta mudança corrigiu a capacidade inesperada de rolar arrastando com um mouse.

Se você dependeu do comportamento anterior em sua aplicação, existem várias maneiras de
controlar e configurar este recurso.

- Estenda `ScrollBehavior`, `MaterialScrollBehavior`, ou `CupertinoScrollBehavior`
para modificar o comportamento padrão, sobrescrevendo `ScrollBehavior.dragDevices`.

  - Com seu próprio `ScrollBehavior`, você pode aplicá-lo em toda a aplicação configurando
    `MaterialApp.scrollBehavior` ou `CupertinoApp.scrollBehavior`.
  - Ou, se você deseja aplicá-lo apenas a widgets específicos, adicione uma
    `ScrollConfiguration` acima do widget em questão com seu
    `ScrollBehavior` customizado.

Seus widgets scrollable então herdam e refletem este comportamento.

- Em vez de criar seu próprio `ScrollBehavior`, outra opção para mudar o
comportamento padrão é copiar o `ScrollBehavior` existente, e definir diferentes
`dragDevices`.
  - Crie uma `ScrollConfiguration` em sua árvore de widgets, e forneça uma cópia modificada
    do `ScrollBehavior` existente no contexto atual usando `copyWith`.

Para acomodar a nova configuração de dispositivos de arrasto em `ScrollBehavior`,
`GestureDetector.kind` foi descontinuado junto com
todas as instâncias subclassificadas do parâmetro.
Um flutter fix está disponível para migrar código existente
para todos os gesture detectors de `kind` para `supportedDevices`.
O parâmetro anterior `kind` permitia apenas um `PointerDeviceKind` para
ser usado para filtrar gestos.
A introdução de `supportedDevices` torna possível mais
de um `PointerDeviceKind` válido.

## Migration guide

### Configurando um `ScrollBehavior` customizado para sua aplicação

Code before migration:

```dart
MaterialApp(
  // ...
);
```

Code after migration:

```dart
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

// Set ScrollBehavior for an entire application.
MaterialApp(
  scrollBehavior: MyCustomScrollBehavior(),
  // ...
);
```

### Configurando um `ScrollBehavior` customizado para um widget específico

Code before migration:

```dart
final ScrollController controller = ScrollController();
ListView.builder(
  controller: controller,
  itemBuilder: (BuildContext context, int index) {
   return Text('Item $index');
 }
);
```

Code after migration:

```dart
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

// ScrollBehavior can be set for a specific widget.
final ScrollController controller = ScrollController();
ScrollConfiguration(
  behavior: MyCustomScrollBehavior(),
  child: ListView.builder(
    controller: controller,
    itemBuilder: (BuildContext context, int index) {
     return Text('Item $index');
    }
  ),
);
```

### Copiar e modificar `ScrollBehavior` existente

Code before migration:

```dart
final ScrollController controller = ScrollController();
ListView.builder(
  controller: controller,
  itemBuilder: (BuildContext context, int index) {
   return Text('Item $index');
 }
);
```

Code after migration:

```dart
// ScrollBehavior can be copied and adjusted.
final ScrollController controller = ScrollController();
ScrollConfiguration(
  behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  }),
  child: ListView.builder(
    controller: controller,
    itemBuilder: (BuildContext context, int index) {
     return Text('Item $index');
    }
  ),
);
```

### Migrar `GestureDetector`s de `kind` para `supportedDevices`

Code before migration:

```dart
VerticalDragGestureRecognizer(
  kind: PointerDeviceKind.touch,
);
```

Code after migration:

```dart
VerticalDragGestureRecognizer(
  supportedDevices: <PointerDeviceKind>{ PointerDeviceKind.touch },
);
```

## Timeline

Landed in version: 2.3.0-12.0.pre<br>
In stable release: 2.5

## References

API documentation:

* [`ScrollConfiguration`][]
* [`ScrollBehavior`][]
* [`MaterialScrollBehavior`][]
* [`CupertinoScrollBehavior`][]
* [`PointerDeviceKind`][]
* [`GestureDetector`][]

Relevant issue:

* [Issue #71322][]

Relevant PRs:

* [Reject mouse drags by default in scrollables][]
* [Deprecate GestureDetector.kind in favor of new supportedDevices][]


[`ScrollConfiguration`]: {{site.api}}/flutter/widgets/ScrollConfiguration-class.html
[`ScrollBehavior`]: {{site.api}}/flutter/widgets/ScrollBehavior-class.html
[`MaterialScrollBehavior`]: {{site.api}}/flutter/material/MaterialScrollBehavior-class.html
[`CupertinoScrollBehavior`]: {{site.api}}/flutter/cupertino/CupertinoScrollBehavior-class.html
[`PointerDeviceKind`]: {{site.api}}/flutter/dart-ui/PointerDeviceKind-class.html
[`GestureDetector`]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[Issue #71322]: {{site.repo.flutter}}/issues/71322
[Reject mouse drags by default in scrollables]: {{site.repo.flutter}}/pull/81569
[Deprecate GestureDetector.kind in favor of new supportedDevices]: {{site.repo.flutter}}/pull/81858
