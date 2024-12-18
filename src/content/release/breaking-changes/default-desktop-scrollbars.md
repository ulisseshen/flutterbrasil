---
ia-translate: true
title: Barras de Rolagem Padrão no Desktop
description: >
  ScrollBehaviors agora construirão automaticamente barras de rolagem em plataformas Desktop.
---

## Resumo

`ScrollBehavior`s agora aplicam automaticamente `Scrollbar`s a widgets
de rolagem em plataformas desktop - Mac, Windows e Linux.

## Contexto

Antes desta mudança, `Scrollbar`s eram aplicadas manualmente a widgets de
rolagem pelo desenvolvedor em todas as plataformas. Isso não correspondia
às expectativas dos desenvolvedores ao executar aplicativos Flutter em
plataformas desktop.

Agora, o `ScrollBehavior` herdado aplica um `Scrollbar` automaticamente
à maioria dos widgets de rolagem. Isso é semelhante a como
`GlowingOverscrollIndicator` é criado por `ScrollBehavior`. Os poucos
widgets que estão isentos desse comportamento estão listados abaixo.

Para fornecer melhor gerenciamento e controle desse recurso,
`ScrollBehavior` também foi atualizado. O método `buildViewportChrome`,
que aplicava um `GlowingOverscrollIndicator`, foi depreciado. Em vez
disso, `ScrollBehavior` agora oferece suporte a métodos individuais para
decorar o viewport, `buildScrollbar` e `buildOverscrollIndicator`. Esses
métodos podem ser sobrescritos para controlar o que é construído em
torno do rolável.

Além disso, as subclasses `ScrollBehavior` `MaterialScrollBehavior` e
`CupertinoScrollBehavior` foram tornadas públicas, permitindo que os
desenvolvedores estendam e construam sobre os outros `ScrollBehavior`s
existentes no framework. Essas subclasses eram anteriormente privadas.

## Descrição da mudança

A abordagem anterior exigia que os desenvolvedores criassem seus
próprios `Scrollbar`s em todas as plataformas. Em alguns casos de uso,
um `ScrollController` precisaria ser fornecido ao `Scrollbar` e ao
widget rolável.

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

O `ScrollBehavior` agora aplica o `Scrollbar` automaticamente ao
executar no desktop e gerencia o fornecimento do `ScrollController` ao
`Scrollbar` para você.

```dart
final ScrollController controller = ScrollController();
ListView.builder(
  controller: controller,
  itemBuilder: (BuildContext context, int index) {
   return Text('Item $index');
 }
);
```

Alguns widgets no framework estão isentos desta aplicação automática de
`Scrollbar`. Eles são:

- `EditableText`, quando `maxLines` é 1.
- `ListWheelScrollView`
- `PageView`
- `NestedScrollView`

Como esses widgets substituem manualmente o `ScrollBehavior` herdado
para remover `Scrollbar`s, todos esses widgets agora têm um parâmetro
`scrollBehavior` para que um possa ser fornecido para usar em vez da
substituição.

Esta alteração não causou falhas de teste, travamentos ou mensagens de
erro durante o desenvolvimento, mas pode resultar em dois `Scrollbar`s
sendo renderizados em seu aplicativo se você estiver adicionando
manualmente `Scrollbar`s em plataformas desktop.

Se você estiver vendo isso em seu aplicativo, há várias maneiras de
controlar e configurar esse recurso.

- Remova os `Scrollbar`s aplicados manualmente em seu aplicativo ao
  executar no desktop.

- Estenda `ScrollBehavior`, `MaterialScrollBehavior` ou
  `CupertinoScrollBehavior` para modificar o comportamento padrão.

  - Com seu próprio `ScrollBehavior`, você pode aplicá-lo em todo o
    aplicativo definindo `MaterialApp.scrollBehavior` ou
    `CupertinoApp.scrollBehavior`.
  - Ou, se você deseja aplicá-lo apenas a widgets específicos, adicione
    um `ScrollConfiguration` acima do widget em questão com seu
    `ScrollBehavior` personalizado.

Seus widgets roláveis herdarão isso e refletirão esse comportamento.

- Em vez de criar seu próprio `ScrollBehavior`, outra opção para
  alterar o comportamento padrão é copiar o `ScrollBehavior` existente e
  alternar o recurso desejado.

  - Crie um `ScrollConfiguration` em sua árvore de widgets e forneça
    uma cópia modificada do `ScrollBehavior` existente no contexto
    atual usando `copyWith`.

## Guia de migração

### Removendo `Scrollbar`s manuais no desktop

Código antes da migração:

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

Código após a migração:

```dart
final ScrollController controller = ScrollController();
final Widget child = ListView.builder(
  controller: controller,
  itemBuilder: (BuildContext context, int index) {
    return Text('Item $index');
  }
);
// Adicione manualmente um `Scrollbar` apenas quando não estiver em plataformas desktop.
// Ou, consulte outras migrações para alterar `ScrollBehavior`.
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

### Definindo um `ScrollBehavior` personalizado para seu aplicativo

Código antes da migração:

```dart
// MaterialApps tinham anteriormente um ScrollBehavior privado.
MaterialApp(
  // ...
);
```

Código após a migração:

```dart
// MaterialApps tinham anteriormente um ScrollBehavior privado.
// Isso está disponível para estender agora.
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Substitua os métodos de comportamento como buildOverscrollIndicator e buildScrollbar
}

// ScrollBehavior agora pode ser configurado para um aplicativo inteiro.
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
 }
);
```

Código após a migração:

```dart
// MaterialApps tinham anteriormente um ScrollBehavior privado.
// Isso está disponível para estender agora.
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Substitua os métodos de comportamento como buildOverscrollIndicator e buildScrollbar
}

// ScrollBehavior pode ser definido para um widget específico.
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

### Copiar e modificar o `ScrollBehavior` existente

Código antes da migração:

```dart
final ScrollController controller = ScrollController();
ListView.builder(
  controller: controller,
  itemBuilder: (BuildContext context, int index) {
   return Text('Item $index');
 }
);
```

Código após a migração:

```dart
// ScrollBehavior pode ser copiado e ajustado.
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

## Linha do tempo

Incluído na versão: 2.2.0-10.0.pre<br>
Na versão estável: 2.2.0

## Referências

Documentação da API:

* [`ScrollConfiguration`][]
* [`ScrollBehavior`][]
* [`MaterialScrollBehavior`][]
* [`CupertinoScrollBehavior`][]
* [`Scrollbar`][]
* [`CupertinoScrollbar`][]

Issues relevantes:

* [Issue #40107][]
* [Issue #70866][]

PRs relevantes:

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
