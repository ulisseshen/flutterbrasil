---
title: Eliminando parâmetros nullOk
description: >
    Eliminar os parâmetros nullOk para ajudar na clareza
    da API diante da null safety.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Este guia de migração descreve a conversão de código que usa o
parâmetro `nullOk` em vários acessores estáticos `of` e em acessores
relacionados, para que passe a usar APIs alternativas com valores de
retorno anuláveis.

## Contexto {:#context}

O Flutter tem um padrão comum que permite buscar alguns tipos de widgets
([`InheritedWidget`][]s) usando funções membro estáticas, normalmente
chamadas `of`, que recebem um `BuildContext`.

Antes de a não nulabilidade se tornar o padrão, era útil ter uma opção
nessas APIs que alternasse entre lançar uma exceção, caso o widget não
estivesse presente na árvore de widgets, e retornar null, caso não fosse
encontrado. Isso era útil e não causava confusão, já que toda variável
era anulável.

Quando a não nulabilidade passou a ser o padrão, tornou-se desejável que
as APIs mais usadas retornassem um valor não anulável. Isso porque escrever
`MediaQuery.of(context, nullOk: false)` e ainda precisar de um operador `!`
ou de `?` com um valor de fallback depois dessa chamada parecia estranho.

O parâmetro `nullOk` era uma forma simples de oferecer uma opção de null safety
que, diante do suporte real da linguagem à não nulabilidade, passou a fornecer
sinais redundantes e, talvez, contraditórios ao desenvolvedor.

Para resolver isso, os acessores `of` (e alguns acessores relacionados que
também usavam `nullOk`) foram divididos em duas chamadas: uma que retorna um
valor não anulável e lança uma exceção quando o widget procurado não está
presente, e outra que retorna um valor anulável, não lança exceção e retorna
null quando o widget não está presente.

O documento de design desta mudança é [Eliminating nullOk parameters][].

[Eliminating nullOk parameters]: /go/eliminating-nullok-parameters

## Descrição da mudança {:#description-of-change}

A mudança em si alterou essas APIs para que não tenham mais um parâmetro
`nullOk` e passem a retornar um valor não anulável:

* [`MediaQuery.of`][]
* [`Navigator.of`][]
* [`ScaffoldMessenger.of`][]
* [`Scaffold.of`][]
* [`Router.of`][]
* [`Localizations.localeOf`][]
* [`FocusTraversalOrder.of`][]
* [`FocusTraversalGroup.of`][]
* [`Focus.of`][]
* `Shortcuts.of`
* [`Actions.handler`][]
* [`Actions.find`][]
* [`Actions.invoke`][]
* [`AnimatedList.of`][]
* [`SliverAnimatedList.of`][]
* [`CupertinoDynamicColor.resolve`][]
* [`CupertinoDynamicColor.resolveFrom`][]
* [`CupertinoUserInterfaceLevel.of`][]
* [`CupertinoTheme.brightnessOf`][]
* [`CupertinoThemeData.resolveFrom`][]
* [`NoDefaultCupertinoThemeData.resolveFrom`][]
* [`CupertinoTextThemeData.resolveFrom`][]
* [`MaterialBasedCupertinoThemeData.resolveFrom`][]

E introduziu estas novas APIs ao lado delas, para
retornar um valor anulável:

* [`MediaQuery.maybeOf`][]
* [`Navigator.maybeOf`][]
* [`ScaffoldMessenger.maybeOf`][]
* [`Scaffold.maybeOf`][]
* [`Router.maybeOf`][]
* [`Localizations.maybeLocaleOf`][]
* [`FocusTraversalOrder.maybeOf`][]
* [`FocusTraversalGroup.maybeOf`][]
* [`Focus.maybeOf`][]
* `Shortcuts.maybeOf`
* [`Actions.maybeFind`][]
* [`Actions.maybeInvoke`][]
* [`AnimatedList.maybeOf`][]
* [`SliverAnimatedList.maybeOf`][]
* [`CupertinoDynamicColor.maybeResolve`][]
* [`CupertinoUserInterfaceLevel.maybeOf`][]
* [`CupertinoTheme.maybeBrightnessOf`][]

## Guia de migração {:#migration-guide}

Para modificar seu código e usar a nova forma das APIs, converta todas as
chamadas que incluem `nullOk = true` como parâmetro para usar a forma
`maybe` da API.

Portanto, isto:

```dart
MediaQueryData? data = MediaQuery.of(context, nullOk: true);
```

passa a ser:

```dart
MediaQueryData? data = MediaQuery.maybeOf(context);
```

Você também precisa modificar todas as chamadas da API com `nullOk =
false` (frequentemente o padrão), para aceitar valores de retorno não
anuláveis, ou remover quaisquer operadores `!`:

Então, qualquer um destes:

```dart
MediaQueryData data = MediaQuery.of(context)!; // nullOk false by default.
MediaQueryData? data = MediaQuery.of(context); // nullOk false by default.
```

passa a ser:

```dart
MediaQueryData data = MediaQuery.of(context); // No ! or ? operator here now.
```

A opção de análise `unnecessary_non_null_assertion` pode ser bastante útil
para encontrar os lugares em que o operador `!` deve ser removido, e a opção
de análise `unnecessary_nullable_for_final_variable_declarations` pode ajudar
a encontrar operadores de interrogação desnecessários em variáveis `final` e `const`.

## Linha do tempo {:#timeline}

Incluído na versão: 1.24.0<br>
Na versão estável: 2.0.0

## Referências {:#references}

Documentação da API:

* [`MediaQuery.of`][]
* [`Navigator.of`][]
* [`ScaffoldMessenger.of`][]
* [`Scaffold.of`][]
* [`Router.of`][]
* [`Localizations.localeOf`][]
* [`FocusTraversalOrder.of`][]
* [`FocusTraversalGroup.of`][]
* [`Focus.of`][]
* `Shortcuts.of`
* [`Actions.handler`][]
* [`Actions.find`][]
* [`Actions.invoke`][]
* [`AnimatedList.of`][]
* [`SliverAnimatedList.of`][]
* [`CupertinoDynamicColor.resolve`][]
* [`CupertinoDynamicColor.resolveFrom`][]
* [`CupertinoUserInterfaceLevel.of`][]
* [`CupertinoTheme.brightnessOf`][]
* [`CupertinoThemeData.resolveFrom`][]
* [`NoDefaultCupertinoThemeData.resolveFrom`][]
* [`CupertinoTextThemeData.resolveFrom`][]
* [`MaterialBasedCupertinoThemeData.resolveFrom`][]
* [`MediaQuery.maybeOf`][]
* [`Navigator.maybeOf`][]
* [`ScaffoldMessenger.maybeOf`][]
* [`Scaffold.maybeOf`][]
* [`Router.maybeOf`][]
* [`Localizations.maybeLocaleOf`][]
* [`FocusTraversalOrder.maybeOf`][]
* [`FocusTraversalGroup.maybeOf`][]
* [`Focus.maybeOf`][]
* `Shortcuts.maybeOf`
* [`Actions.maybeFind`][]
* [`Actions.maybeInvoke`][]
* [`AnimatedList.maybeOf`][]
* [`SliverAnimatedList.maybeOf`][]
* [`CupertinoDynamicColor.maybeResolve`][]
* [`CupertinoUserInterfaceLevel.maybeOf`][]
* [`CupertinoTheme.maybeBrightnessOf`][]

Issue relevante:

* [Issue 68637][]

PRs relevantes:

* [Remover `nullOk` em `MediaQuery.of`][Remove `nullOk` in `MediaQuery.of`]
* [Remover `nullOk` em `Navigator.of`][Remove `nullOk` in `Navigator.of`]
* [Remover o parâmetro `nullOk` de `AnimatedList.of` e `SliverAnimatedList.of`][Remove `nullOk` parameter from `AnimatedList.of` and `SliverAnimatedList.of`]
* [Remover o parâmetro `nullOk` de `Shortcuts.of`, `Actions.find` e `Actions.handler`][Remove `nullOk` parameter from `Shortcuts.of`, `Actions.find`, and `Actions.handler`]
* [Remover o parâmetro `nullOk` de `Focus.of`, `FocusTraversalOrder.of` e `FocusTraversalGroup.of`][Remove `nullOk` parameter from `Focus.of`, `FocusTraversalOrder.of`, and `FocusTraversalGroup.of`]
* [Remover o parâmetro `nullOk` de `Localizations.localeOf`][Remove `nullOk` parameter from `Localizations.localeOf`]
* [Remover o parâmetro `nullOk` de `Router.of`][Remove `nullOk` parameter from `Router.of`]
* [Remover `nullOk` de `Scaffold.of` e `ScaffoldMessenger.of`][Remove `nullOk` from `Scaffold.of` and `ScaffoldMessenger.of`]
* [Remover o parâmetro `nullOk` das APIs de resolução de cores do Cupertino][Remove `nullOk` parameter from Cupertino color resolution APIs]
* [Remover o parâmetro `nullOk` residual de `Localizations.localeOf`][Remove vestigial `nullOk` parameter from `Localizations.localeOf`]
* [Remover `nullOk` de `Actions.invoke` e adicionar `Actions.maybeInvoke`][Remove `nullOk` from `Actions.invoke`, add `Actions.maybeInvoke`]

[`MediaQuery.of`]: {{site.api}}/flutter/widgets/MediaQuery/of.html
[`Navigator.of`]: {{site.api}}/flutter/widgets/Navigator/of.html
[`ScaffoldMessenger.of`]: {{site.material_ui}}/ScaffoldMessenger/of.html
[`Scaffold.of`]: {{site.material_ui}}/Scaffold/of.html
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
[`CupertinoDynamicColor.resolve`]: {{site.cupertino_ui}}/CupertinoDynamicColor/resolve.html
[`CupertinoDynamicColor.resolveFrom`]: {{site.cupertino_ui}}/CupertinoDynamicColor/resolveFrom.html
[`CupertinoUserInterfaceLevel.of`]: {{site.cupertino_ui}}/CupertinoUserInterfaceLevel/of.html
[`CupertinoTheme.brightnessOf`]: {{site.cupertino_ui}}/CupertinoTheme/brightnessOf.html
[`CupertinoThemeData.resolveFrom`]: {{site.cupertino_ui}}/CupertinoThemeData/resolveFrom.html
[`NoDefaultCupertinoThemeData.resolveFrom`]: {{site.cupertino_ui}}/NoDefaultCupertinoThemeData/resolveFrom.html
[`CupertinoTextThemeData.resolveFrom`]: {{site.cupertino_ui}}/CupertinoTextThemeData/resolveFrom.html
[`MaterialBasedCupertinoThemeData.resolveFrom`]: {{site.material_ui}}/MaterialBasedCupertinoThemeData/resolveFrom.html
[`MediaQuery.maybeOf`]: {{site.api}}/flutter/widgets/MediaQuery/maybeOf.html
[`Navigator.maybeOf`]: {{site.api}}/flutter/widgets/Navigator/maybeOf.html
[`ScaffoldMessenger.maybeOf`]: {{site.material_ui}}/ScaffoldMessenger/maybeOf.html
[`Scaffold.maybeOf`]: {{site.material_ui}}/Scaffold/maybeOf.html
[`Router.maybeOf`]: {{site.api}}/flutter/widgets/Router/maybeOf.html
[`Localizations.maybeLocaleOf`]: {{site.api}}/flutter/widgets/Localizations/maybeLocaleOf.html
[`FocusTraversalOrder.maybeOf`]: {{site.api}}/flutter/widgets/FocusTraversalOrder/maybeOf.html
[`FocusTraversalGroup.maybeOf`]: {{site.api}}/flutter/widgets/FocusTraversalGroup/maybeOf.html
[`Focus.maybeOf`]: {{site.api}}/flutter/widgets/Focus/maybeOf.html
[`Actions.maybeFind`]: {{site.api}}/flutter/widgets/Actions/maybeFind.html
[`Actions.maybeInvoke`]: {{site.api}}/flutter/widgets/Actions/maybeInvoke.html
[`AnimatedList.maybeOf`]: {{site.api}}/flutter/widgets/AnimatedList/maybeOf.html
[`SliverAnimatedList.maybeOf`]: {{site.api}}/flutter/widgets/SliverAnimatedList/maybeOf.html
[`CupertinoDynamicColor.maybeResolve`]: {{site.cupertino_ui}}/CupertinoDynamicColor/maybeResolve.html
[`CupertinoUserInterfaceLevel.maybeOf`]: {{site.cupertino_ui}}/CupertinoUserInterfaceLevel/maybeOf.html
[`CupertinoTheme.maybeBrightnessOf`]: {{site.cupertino_ui}}/CupertinoTheme/maybeBrightnessOf.html
[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[Issue 68637]: {{site.repo.flutter}}/issues/68637
[Remove `nullOk` in `MediaQuery.of`]: {{site.repo.flutter}}/pull/68736
[Remove `nullOk` in `Navigator.of`]: {{site.repo.flutter}}/pull/70726
[Remove `nullOk` parameter from `AnimatedList.of` and `SliverAnimatedList.of`]: {{site.repo.flutter}}/pull/68925
[Remove `nullOk` parameter from `Shortcuts.of`, `Actions.find`, and `Actions.handler`]: {{site.repo.flutter}}/pull/68921
[Remove `nullOk` parameter from `Focus.of`, `FocusTraversalOrder.of`, and `FocusTraversalGroup.of`]: {{site.repo.flutter}}/pull/68917
[Remove `nullOk` parameter from `Localizations.localeOf`]: {{site.repo.flutter}}/pull/68911
[Remove `nullOk` parameter from `Router.of`]: {{site.repo.flutter}}/pull/68910
[Remove `nullOk` from `Scaffold.of` and `ScaffoldMessenger.of`]: {{site.repo.flutter}}/pull/68908
[Remove `nullOk` parameter from Cupertino color resolution APIs]: {{site.repo.flutter}}/pull/68905
[Remove vestigial `nullOk` parameter from `Localizations.localeOf`]: {{site.repo.flutter}}/pull/74657
[Remove `nullOk` from `Actions.invoke`, add `Actions.maybeInvoke`]: {{site.repo.flutter}}/pull/74680
