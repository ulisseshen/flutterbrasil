---
ia-translate: true
title: Eliminando Parâmetros nullOk
description: >
    Para eliminar parâmetros nullOk para ajudar na sanidade da API em
    face da null safety.
---

## Sumário

Este guia de migração descreve a conversão de código que usa o parâmetro
`nullOk` em múltiplos acessadores estáticos `of` e acessadores relacionados
para usar APIs alternativas com valores de retorno anuláveis.

## Contexto

O Flutter tem um padrão comum de permitir a consulta de alguns tipos de widgets
([`InheritedWidget`][]) usando funções de membro estáticas que são tipicamente
chamadas de `of`, e recebem um `BuildContext`.

Antes da não nulabilidade ser o padrão, era útil ter uma alternância nessas
APIs que trocava entre lançar uma exceção se o widget não estivesse presente na
árvore de widgets e retornar nulo se não fosse encontrado. Era útil e não
era confuso, já que toda variável era anulável.

Quando a não nulabilidade se tornou o padrão, tornou-se desejável que as APIs
mais usadas retornassem um valor não anulável. Isso ocorre porque dizer
`MediaQuery.of(context, nullOk: false)` e ainda exigir um operador `!` ou `?`
e um valor de fallback após essa chamada parecia estranho.

O parâmetro `nullOk` era uma forma barata de fornecer uma alternância de null
safety, que, diante do verdadeiro suporte de linguagem para não nulabilidade,
estava fornecendo sinais redundantes e talvez contraditórios para o
desenvolvedor.

Para resolver isso, os acessadores `of` (e alguns acessadores relacionados que
também usavam `nullOk`) foram divididos em duas chamadas: uma que retornava um
valor não anulável e lançava uma exceção quando o widget procurado não estava
presente, e outra que retornava um valor anulável que não lançava uma exceção
e retornava nulo se o widget não estivesse presente.

O documento de design para esta mudança é [Eliminando parâmetros nullOk][].

[Eliminando parâmetros nullOk]: /go/eliminating-nullok-parameters

## Descrição da mudança

A mudança real modificou essas APIs para não terem um parâmetro `nullOk` e
para retornar um valor não anulável:

*   [`MediaQuery.of`][]
*   [`Navigator.of`][]
*   [`ScaffoldMessenger.of`][]
*   [`Scaffold.of`][]
*   [`Router.of`][]
*   [`Localizations.localeOf`][]
*   [`FocusTraversalOrder.of`][]
*   [`FocusTraversalGroup.of`][]
*   [`Focus.of`][]
*   `Shortcuts.of`
*   [`Actions.handler`][]
*   [`Actions.find`][]
*   [`Actions.invoke`][]
*   [`AnimatedList.of`][]
*   [`SliverAnimatedList.of`][]
*   [`CupertinoDynamicColor.resolve`][]
*   [`CupertinoDynamicColor.resolveFrom`][]
*   [`CupertinoUserInterfaceLevel.of`][]
*   [`CupertinoTheme.brightnessOf`][]
*   [`CupertinoThemeData.resolveFrom`][]
*   [`NoDefaultCupertinoThemeData.resolveFrom`][]
*   [`CupertinoTextThemeData.resolveFrom`][]
*   [`MaterialBasedCupertinoThemeData.resolveFrom`][]

E introduziu essas novas APIs junto com essas, para retornar um valor
anulável:

*   [`MediaQuery.maybeOf`][]
*   [`Navigator.maybeOf`][]
*   [`ScaffoldMessenger.maybeOf`][]
*   [`Scaffold.maybeOf`][]
*   [`Router.maybeOf`][]
*   [`Localizations.maybeLocaleOf`][]
*   [`FocusTraversalOrder.maybeOf`][]
*   [`FocusTraversalGroup.maybeOf`][]
*   [`Focus.maybeOf`][]
*   `Shortcuts.maybeOf`
*   [`Actions.maybeFind`][]
*   [`Actions.maybeInvoke`][]
*   [`AnimatedList.maybeOf`][]
*   [`SliverAnimatedList.maybeOf`][]
*   [`CupertinoDynamicColor.maybeResolve`][]
*   [`CupertinoUserInterfaceLevel.maybeOf`][]
*   [`CupertinoTheme.maybeBrightnessOf`][]

## Guia de migração

Para modificar seu código para usar a nova forma das APIs, converta todas as
instâncias de chamadas que incluem `nullOk = true` como um parâmetro para
usar a forma `maybe` da API.

Então isso:

```dart
MediaQueryData? data = MediaQuery.of(context, nullOk: true);
```

se torna:

```dart
MediaQueryData? data = MediaQuery.maybeOf(context);
```

Você também precisa modificar todas as instâncias de chamada da API com `nullOk
= false` (geralmente o padrão), para aceitar valores de retorno não anuláveis
ou remover quaisquer operadores `!`:

Então qualquer um de:

```dart
MediaQueryData data = MediaQuery.of(context)!; // nullOk false por padrão.
MediaQueryData? data = MediaQuery.of(context); // nullOk false por padrão.
```

ambos se tornam:

```dart
MediaQueryData data = MediaQuery.of(context); // Sem operador ! ou ? aqui agora.
```

A opção de análise `unnecessary_non_null_assertion` pode ser muito útil para
encontrar os lugares onde o operador `!` deve ser removido, e a opção de
análise `unnecessary_nullable_for_final_variable_declarations` pode ser útil
para encontrar operadores de ponto de interrogação desnecessários em variáveis
`final` e `const`.

## Cronograma

Implementado na versão: 1.24.0<br>
Em versão estável: 2.0.0

## Referências

Documentação da API:

*   [`MediaQuery.of`][]
*   [`Navigator.of`][]
*   [`ScaffoldMessenger.of`][]
*   [`Scaffold.of`][]
*   [`Router.of`][]
*   [`Localizations.localeOf`][]
*   [`FocusTraversalOrder.of`][]
*   [`FocusTraversalGroup.of`][]
*   [`Focus.of`][]
*   `Shortcuts.of`
*   [`Actions.handler`][]
*   [`Actions.find`][]
*   [`Actions.invoke`][]
*   [`AnimatedList.of`][]
*   [`SliverAnimatedList.of`][]
*   [`CupertinoDynamicColor.resolve`][]
*   [`CupertinoDynamicColor.resolveFrom`][]
*   [`CupertinoUserInterfaceLevel.of`][]
*   [`CupertinoTheme.brightnessOf`][]
*   [`CupertinoThemeData.resolveFrom`][]
*   [`NoDefaultCupertinoThemeData.resolveFrom`][]
*   [`CupertinoTextThemeData.resolveFrom`][]
*   [`MaterialBasedCupertinoThemeData.resolveFrom`][]
*   [`MediaQuery.maybeOf`][]
*   [`Navigator.maybeOf`][]
*   [`ScaffoldMessenger.maybeOf`][]
*   [`Scaffold.maybeOf`][]
*   [`Router.maybeOf`][]
*   [`Localizations.maybeLocaleOf`][]
*   [`FocusTraversalOrder.maybeOf`][]
*   [`FocusTraversalGroup.maybeOf`][]
*   [`Focus.maybeOf`][]
*   `Shortcuts.maybeOf`
*   [`Actions.maybeFind`][]
*   [`Actions.maybeInvoke`][]
*   [`AnimatedList.maybeOf`][]
*   [`SliverAnimatedList.maybeOf`][]
*   [`CupertinoDynamicColor.maybeResolve`][]
*   [`CupertinoUserInterfaceLevel.maybeOf`][]
*   [`CupertinoTheme.maybeBrightnessOf`][]

Issue relevante:

*   [Issue 68637][]

PRs relevantes:

*   [Remover `nullOk` em `MediaQuery.of`][]
*   [Remover `nullOk` em `Navigator.of`][]
*   [Remover parâmetro `nullOk` de `AnimatedList.of` e `SliverAnimatedList.of`][]
*   [Remover parâmetro `nullOk` de `Shortcuts.of`, `Actions.find` e `Actions.handler`][]
*   [Remover parâmetro `nullOk` de `Focus.of`, `FocusTraversalOrder.of` e `FocusTraversalGroup.of`][]
*   [Remover parâmetro `nullOk` de `Localizations.localeOf`][]
*   [Remover parâmetro `nullOk` de `Router.of`][]
*   [Remover `nullOk` de `Scaffold.of` e `ScaffoldMessenger.of`][]
*   [Remover parâmetro `nullOk` das APIs de resolução de cor Cupertino][]
*   [Remover parâmetro vestigial `nullOk` de `Localizations.localeOf`][]
*   [Remover `nullOk` de `Actions.invoke`, adicionar `Actions.maybeInvoke`][]

[`MediaQuery.of`]: {{site.api}}/flutter/widgets/MediaQuery/of.html
[`Navigator.of`]: {{site.api}}/flutter/widgets/Navigator/of.html
[`ScaffoldMessenger.of`]: {{site.api}}/flutter/material/ScaffoldMessenger/of.html
[`Scaffold.of`]: {{site.api}}/flutter/material/Scaffold/of.html
[`Router.of`]: {{site.api}}/flutter/widgets/Router/of.html
[`Localizations.localeOf`]: {{site.api}}/flutter/widgets/Localizations/localeOf.html
[`FocusTraversalOrder.of`]: {{site.api}}/flutter/widgets/FocusTraversalOrder/of.html
[`FocusTraversalGroup.of`]: {{site.api}}/flutter/widgets/FocusTraversalGroup/of.html
[`Focus.of`]: {{site.api}}/flutter/widgets/Focus/of.html
[`Actions.handler`]: {{site.api}}/flutter/widgets/Actions/handler.html
[`Actions.find`]: {{site.api}}/flutter/widgets/Actions/find.html
[`Actions.invoke`]: {{site.api}}/flutter/widgets/Actions/invoke.html
[`AnimatedList.of`]: {{site.api}}/flutter/widgets/AnimatedList/of.html
[`SliverAnimatedList.of`]: {{site.api}}/flutter/widgets/SliverAnimatedList/of.html
[`CupertinoDynamicColor.resolve`]: {{site.api}}/flutter/cupertino/CupertinoDynamicColor/resolve.html
[`CupertinoDynamicColor.resolveFrom`]: {{site.api}}/flutter/cupertino/CupertinoDynamicColor/resolveFrom.html
[`CupertinoUserInterfaceLevel.of`]: {{site.api}}/flutter/cupertino/CupertinoUserInterfaceLevel/of.html
[`CupertinoTheme.brightnessOf`]: {{site.api}}/flutter/cupertino/CupertinoTheme/brightnessOf.html
[`CupertinoThemeData.resolveFrom`]: {{site.api}}/flutter/cupertino/CupertinoThemeData/resolveFrom.html
[`NoDefaultCupertinoThemeData.resolveFrom`]: {{site.api}}/flutter/cupertino/NoDefaultCupertinoThemeData/resolveFrom.html
[`CupertinoTextThemeData.resolveFrom`]: {{site.api}}/flutter/cupertino/CupertinoTextThemeData/resolveFrom.html
[`MaterialBasedCupertinoThemeData.resolveFrom`]: {{site.api}}/flutter/material/MaterialBasedCupertinoThemeData/resolveFrom.html
[`MediaQuery.maybeOf`]: {{site.api}}/flutter/widgets/MediaQuery/maybeOf.html
[`Navigator.maybeOf`]: {{site.api}}/flutter/widgets/Navigator/maybeOf.html
[`ScaffoldMessenger.maybeOf`]: {{site.api}}/flutter/material/ScaffoldMessenger/maybeOf.html
[`Scaffold.maybeOf`]: {{site.api}}/flutter/material/Scaffold/maybeOf.html
[`Router.maybeOf`]: {{site.api}}/flutter/widgets/Router/maybeOf.html
[`Localizations.maybeLocaleOf`]: {{site.api}}/flutter/widgets/Localizations/maybeLocaleOf.html
[`FocusTraversalOrder.maybeOf`]: {{site.api}}/flutter/widgets/FocusTraversalOrder/maybeOf.html
[`FocusTraversalGroup.maybeOf`]: {{site.api}}/flutter/widgets/FocusTraversalGroup/maybeOf.html
[`Focus.maybeOf`]: {{site.api}}/flutter/widgets/Focus/maybeOf.html
[`Actions.maybeFind`]: {{site.api}}/flutter/widgets/Actions/maybeFind.html
[`Actions.maybeInvoke`]: {{site.api}}/flutter/widgets/Actions/maybeInvoke.html
[`AnimatedList.maybeOf`]: {{site.api}}/flutter/widgets/AnimatedList/maybeOf.html
[`SliverAnimatedList.maybeOf`]: {{site.api}}/flutter/widgets/SliverAnimatedList/maybeOf.html
[`CupertinoDynamicColor.maybeResolve`]: {{site.api}}/flutter/cupertino/CupertinoDynamicColor/maybeResolve.html
[`CupertinoUserInterfaceLevel.maybeOf`]: {{site.api}}/flutter/cupertino/CupertinoUserInterfaceLevel/maybeOf.html
[`CupertinoTheme.maybeBrightnessOf`]: {{site.api}}/flutter/cupertino/CupertinoTheme/maybeBrightnessOf.html
[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[Issue 68637]: {{site.repo.flutter}}/issues/68637
[Remover `nullOk` em `MediaQuery.of`]: {{site.repo.flutter}}/pull/68736
[Remover `nullOk` em `Navigator.of`]: {{site.repo.flutter}}/pull/70726
[Remover parâmetro `nullOk` de `AnimatedList.of` e `SliverAnimatedList.of`]: {{site.repo.flutter}}/pull/68925
[Remover parâmetro `nullOk` de `Shortcuts.of`, `Actions.find` e `Actions.handler`]: {{site.repo.flutter}}/pull/68921
[Remover parâmetro `nullOk` de `Focus.of`, `FocusTraversalOrder.of` e `FocusTraversalGroup.of`]: {{site.repo.flutter}}/pull/68917
[Remover parâmetro `nullOk` de `Localizations.localeOf`]: {{site.repo.flutter}}/pull/68911
[Remover parâmetro `nullOk` de `Router.of`]: {{site.repo.flutter}}/pull/68910
[Remover `nullOk` de `Scaffold.of` e `ScaffoldMessenger.of`]: {{site.repo.flutter}}/pull/68908
[Remover parâmetro `nullOk` das APIs de resolução de cor Cupertino]: {{site.repo.flutter}}/pull/68905
[Remover parâmetro vestigial `nullOk` de `Localizations.localeOf`]: {{site.repo.flutter}}/pull/74657
[Remover `nullOk` de `Actions.invoke`, adicionar `Actions.maybeInvoke`]: {{site.repo.flutter}}/pull/74680
