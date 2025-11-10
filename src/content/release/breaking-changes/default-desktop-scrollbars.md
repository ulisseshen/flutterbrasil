---
title: Scrollbars padrão no Desktop
description: >
  ScrollBehaviors agora constroem automaticamente Scrollbars em plataformas Desktop.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

`ScrollBehavior`s agora aplicam automaticamente `Scrollbar`s aos
widgets de rolagem em plataformas desktop - Mac, Windows e Linux.

## Context

Antes desta mudança, `Scrollbar`s eram aplicadas aos widgets de rolagem
manualmente pelo desenvolvedor em todas as plataformas. Isso não correspondia
às expectativas do desenvolvedor ao executar aplicações Flutter em plataformas desktop.

Agora, o `ScrollBehavior` herdado aplica uma `Scrollbar` automaticamente
à maioria dos widgets de rolagem. Isso é semelhante a como `GlowingOverscrollIndicator`
é criado por `ScrollBehavior`. Os poucos widgets que são isentos deste
comportamento estão listados abaixo.

Para fornecer melhor gerenciamento e controle deste recurso, `ScrollBehavior`
também foi atualizado. O método `buildViewportChrome`, que aplicava
um `GlowingOverscrollIndicator`, foi descontinuado. Em vez disso, `ScrollBehavior`
agora suporta métodos individuais para decorar o viewport, `buildScrollbar`
e `buildOverscrollIndicator`. Esses métodos podem ser sobrescritos para controlar
o que é construído ao redor do scrollable.

Além disso, as subclasses de `ScrollBehavior`, `MaterialScrollBehavior` e
`CupertinoScrollBehavior`, foram tornadas públicas, permitindo que desenvolvedores estendam
e construam sobre os outros `ScrollBehavior`s existentes no framework. Essas
subclasses eram anteriormente privadas.


## Description of change

A abordagem anterior exigia que desenvolvedores criassem suas próprias `Scrollbar`s em
todas as plataformas. Em alguns casos de uso, um `ScrollController` precisaria ser fornecido
à `Scrollbar` e ao widget scrollable.

```dart
final ScrollController controller = ScrollController();
Scrollbar(
  controller: controller,
  child: ListView.builder(
    controller: controller,
    itemBuilder: (BuildContext context, int index) {
      return Text('Item $index');
    }
  )
);
```

O `ScrollBehavior` agora aplica a `Scrollbar` automaticamente
ao executar no desktop, e gerencia o fornecimento do `ScrollController`
à `Scrollbar` para você.

```dart
final ScrollController controller = ScrollController();
ListView.builder(
  controller: controller,
  itemBuilder: (BuildContext context, int index) {
   return Text('Item $index');
 }
);
```

Alguns widgets no framework são isentos desta
aplicação automática de `Scrollbar`.
Eles são:

- `EditableText`, quando `maxLines` é 1.
- `ListWheelScrollView`
- `PageView`
- `NestedScrollView`

Como esses widgets sobrescrevem manualmente o `ScrollBehavior` herdado
para remover `Scrollbar`s, todos esses widgets agora têm um parâmetro `scrollBehavior`
para que um possa ser fornecido para usar em vez da sobrescrita.

Esta mudança não causou nenhuma falha de teste, crash ou mensagens de erro
durante o desenvolvimento, mas pode resultar em duas `Scrollbar`s
sendo renderizadas em sua aplicação se você estiver adicionando manualmente `Scrollbar`s
em plataformas desktop.

Se você está vendo isso em sua aplicação, existem várias maneiras de
controlar e configurar este recurso.

- Remova as `Scrollbar`s aplicadas manualmente em sua
  aplicação ao executar no desktop.

- Estenda `ScrollBehavior`, `MaterialScrollBehavior`,
  ou `CupertinoScrollBehavior` para modificar o comportamento padrão.

  - Com seu próprio `ScrollBehavior`, você pode aplicá-lo em toda a aplicação configurando
    `MaterialApp.scrollBehavior` ou `CupertinoApp.scrollBehavior`.
  - Ou, se você deseja aplicá-lo apenas a widgets específicos, adicione uma
    `ScrollConfiguration` acima do widget em questão com seu
    `ScrollBehavior` customizado.

Seus widgets scrollable então herdam isso e refletem este comportamento.

- Em vez de criar seu próprio `ScrollBehavior`, outra opção para mudar o
  comportamento padrão é copiar o `ScrollBehavior` existente, e alternar o
  recurso desejado.
  - Crie uma `ScrollConfiguration` em sua árvore de widgets, e
    forneça uma cópia modificada do `ScrollBehavior` existente no
    contexto atual usando `copyWith`.

## Migration guide

### Removendo `Scrollbar`s manuais no desktop

Code before migration:

```dart
final ScrollController controller = ScrollController();
Scrollbar(
  controller: controller,
  child: ListView.builder(
    controller: controller,
    itemBuilder: (BuildContext context, int index) {
      return Text('Item $index');
    }
  )
);
```

Code after migration:

```dart
final ScrollController controller = ScrollController();
final Widget child = ListView.builder(
  controller: controller,
  itemBuilder: (BuildContext context, int index) {
    return Text('Item $index');
  }
);
// Only manually add a `Scrollbar` when not on desktop platforms.
// Or, see other migrations for changing `ScrollBehavior`.
switch (currentPlatform) {
  case TargetPlatform.linux:
  case TargetPlatform.macOS:
  case TargetPlatform.windows:
    return child;
  case TargetPlatform.android:
  case TargetPlatform.fuchsia:
  case TargetPlatform.iOS:
    return Scrollbar(
      controller: controller,
      child: child;
    );
}
```

### Configurando um `ScrollBehavior` customizado para sua aplicação

Code before migration:

```dart
// MaterialApps previously had a private ScrollBehavior.
MaterialApp(
  // ...
);
```

Code after migration:

```dart
// MaterialApps previously had a private ScrollBehavior.
// This is available to extend now.
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods like buildOverscrollIndicator and buildScrollbar
}

// ScrollBehavior can now be configured for an entire application.
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
// MaterialApps previously had a private ScrollBehavior.
// This is available to extend now.
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods like buildOverscrollIndicator and buildScrollbar
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
  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
  child: ListView.builder(
    controller: controller,
    itemBuilder: (BuildContext context, int index) {
     return Text('Item $index');
    }
  ),
);
```

## Timeline

Landed in version: 2.2.0-10.0.pre<br>
In stable release: 2.2.0

## References

API documentation:

* [`ScrollConfiguration`][]
* [`ScrollBehavior`][]
* [`MaterialScrollBehavior`][]
* [`CupertinoScrollBehavior`][]
* [`Scrollbar`][]
* [`CupertinoScrollbar`][]

Relevant issues:

* [Issue #40107][]
* [Issue #70866][]

Relevant PRs:

* [Exposing ScrollBehaviors for app-wide settings][]
* [Automatically applying Scrollbars on desktop platforms with configurable ScrollBehaviors][]


[`ScrollConfiguration`]: {{site.api}}/flutter/widgets/ScrollConfiguration-class.html
[`ScrollBehavior`]: {{site.api}}/flutter/widgets/ScrollBehavior-class.html
[`MaterialScrollBehavior`]: {{site.api}}/flutter/material/MaterialScrollBehavior-class.html
[`CupertinoScrollBehavior`]: {{site.api}}/flutter/cupertino/CupertinoScrollBehavior-class.html
[`Scrollbar`]: {{site.api}}/flutter/material/Scrollbar-class.html
[`CupertinoScrollbar`]: {{site.api}}/flutter/cupertino/CupertinoScrollbar-class.html
[Issue #40107]: {{site.repo.flutter}}/issues/40107
[Issue #70866]: {{site.repo.flutter}}/issues/70866
[Exposing ScrollBehaviors for app-wide settings]: {{site.repo.flutter}}/pull/76739
[Automatically applying Scrollbars on desktop platforms with configurable ScrollBehaviors]: {{site.repo.flutter}}/pull/78588
