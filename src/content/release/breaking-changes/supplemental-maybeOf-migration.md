---
ia-translate: true
title: Migre `of` para valores de retorno não-nulos e adicione `maybeOf`
description: >
  Para eliminar parâmetros nullOk e ajudar com a clareza da API
  diante do null safety.
---

{% render "docs/breaking-changes.md" %}

## Resumo

Este guia de migração descreve a conversão de código que usa várias funções
estáticas `of` para recuperar informações de um contexto que costumavam retornar
valores anuláveis, mas agora retornam valores não-nulos.

## Contexto

Flutter tem um padrão comum de permitir a busca de alguns tipos de widgets
(tipicamente [`InheritedWidget`][`InheritedWidget`]s, mas também outros) usando funções membro
estáticas que são tipicamente chamadas de `of`.

Quando a não-nulabilidade se tornou o padrão, foi desejável que as
APIs mais comumente usadas retornassem um valor não-nulo. Isso porque dizer
`Scrollable.of(context)` e ainda precisar de um operador `!` ou `?` e um
valor de fallback após essa chamada parecia desajeitado e não era idiomático para
código Dart não-nulo.

Grande parte dessa migração foi realizada quando eliminamos os parâmetros `nullOk` em
uma [migração anterior][previous migration], mas alguns métodos `of` foram perdidos nessa migração,
e alguns foram subsequentemente adicionados com tipos de retorno anuláveis, contrariando nosso
padrão comum.

Nesta migração, os acessores `of` afetados foram divididos em duas chamadas: uma
que retornava um valor não-nulo e lançava uma exceção quando o valor procurado
não estava presente (ainda chamada de `of`), e uma que retornava um valor anulável
que não lançava uma exceção, e retornava null se o valor não estivesse
presente (um novo método chamado `maybeOf`).

## Descrição da mudança

A mudança modificou estas APIs estáticas `of` para retornar valores não-nulos.
Se um valor não for encontrado, elas também agora farão assert em modo debug, e
lançarão uma exceção em modo release.

* [`AutofillGroup.of`]
* [`DefaultTabController.of`]
* [`DefaultTextHeightBehavior.of`]
* [`Form.of`]
* [`HeroControllerScope.of`]
* [`Material.of`]
* [`Overlay.of`]
* [`PageStorage.of`]
* [`PrimaryScrollController.of`]
* [`RenderAbstractViewport.of`]
* [`RestorationScope.of`]
* [`Scrollable.of`]
* [`ScrollNotificationObserver.of`]

Esta mudança também introduziu novas APIs estáticas `maybeOf` ao lado
das funções acima, que retornam uma versão anulável do mesmo valor, e
simplesmente retornam null se o valor não for encontrado, sem lançar exceções.

* [`AutofillGroup.maybeOf`]
* [`DefaultTabController.maybeOf`]
* [`DefaultTextHeightBehavior.maybeOf`]
* [`Form.maybeOf`]
* [`HeroControllerScope.maybeOf`]
* [`Material.maybeOf`]
* [`Overlay.maybeOf`]
* [`PageStorage.maybeOf`]
* [`PrimaryScrollController.maybeOf`]
* [`RenderAbstractViewport.maybeOf`]
* [`RestorationScope.maybeOf`]
* [`Scrollable.maybeOf`]
* [`ScrollNotificationObserver.maybeOf`]

## Guia de migração

Para modificar seu código para usar a nova forma das APIs, primeiro converta todas
as instâncias das funções estáticas `of` originais (onde sua anulabilidade é
importante) para usar a forma `maybeOf` em vez disso.

Código antes da migração:

```dart
ScrollController? controller = Scrollable.of(context);
```

Código após a migração:

```dart
ScrollController? controller = Scrollable.maybeOf(context);
```

Em seguida, para instâncias onde o código chama a API `of` seguida por
um ponto de exclamação, apenas remova o ponto de exclamação: ela não pode
mais retornar um valor anulável.

Código antes da migração:

```dart
ScrollController controller = Scrollable.of(context)!;
```

Código após a migração:

```dart
ScrollController controller = Scrollable.of(context);
```

O seguinte também pode ser útil:

* [`unnecessary_non_null_assertion`][`unnecessary_non_null_assertion`] (mensagem do linter) identifica
  lugares onde um operador `!` deve ser removido
* [`unnecessary_null_checks`][`unnecessary_null_checks`] (opção de análise) identifica lugares
  onde o operador `?` não é necessário
* [`unnecessary_null_in_if_null_operators`][`unnecessary_null_in_if_null_operators`] identifica lugares
  onde um operador `??` não é necessário
* [`unnecessary_nullable_for_final_variable_declarations`][`unnecessary_nullable_for_final_variable_declarations`] (opção de análise)
  encontra operadores de interrogação desnecessários em variáveis `final` e `const`

## Linha do tempo

Na versão estável: 3.7

## Referências

Documentação da API:

* [`Material.of`][`Material.of`]

PRs relevantes:

* [Add `maybeOf` for all the cases when `of` returns nullable][Add `maybeOf` for all the cases when `of` returns nullable]
* [Add `Overlay.maybeOf`, make `Overlay.of` return a non-nullable instance][Add `Overlay.maybeOf`, make `Overlay.of` return a non-nullable instance]

[previous migration]: /release/breaking-changes/eliminating-nullok-parameters
[`unnecessary_non_null_assertion`]: {{site.dart-site}}/tools/diagnostic-messages#unnecessary_non_null_assertion
[`unnecessary_null_checks`]: {{site.dart-site}}/tools/linter-rules#unnecessary_null_checks
[`unnecessary_null_in_if_null_operators`]: {{site.dart-site}}/tools/linter-rules#unnecessary_null_in_if_null_operators
[`unnecessary_nullable_for_final_variable_declarations`]: {{site.dart-site}}/tools/linter-rules#unnecessary_nullable_for_final_variable_declarations
[`AutofillGroup.maybeOf`]: {{site.api}}/flutter/widgets/AutofillGroup/maybeOf.html
[`AutofillGroup.of`]: {{site.api}}/flutter/widgets/AutofillGroup/of.html
[`DefaultTabController.maybeOf`]: {{site.api}}/flutter/material/DefaultTabController/maybeOf.html
[`DefaultTabController.of`]: {{site.api}}/flutter/material/DefaultTabController/of.html
[`DefaultTextHeightBehavior.maybeOf`]: {{site.api}}/flutter/widgets/DefaultTextHeightBehavior/maybeOf.html
[`DefaultTextHeightBehavior.of`]: {{site.api}}/flutter/widgets/DefaultTextHeightBehavior/of.html
[`Form.maybeOf`]: {{site.api}}/flutter/widgets/Form/maybeOf.html
[`Form.of`]: {{site.api}}/flutter/widgets/Form/of.html
[`HeroControllerScope.maybeOf`]: {{site.api}}/flutter/widgets/HeroControllerScope/maybeOf.html
[`HeroControllerScope.of`]: {{site.api}}/flutter/widgets/HeroControllerScope/of.html
[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[`Material.maybeOf`]: {{site.api}}/flutter/material/Material/maybeOf.html
[`Material.of`]: {{site.api}}/flutter/material/Material/of.html
[`Overlay.maybeOf`]: {{site.api}}/flutter/widgets/Overlay/maybeOf.html
[`Overlay.of`]: {{site.api}}/flutter/widgets/Overlay/of.html
[`PageStorage.maybeOf`]: {{site.api}}/flutter/widgets/PageStorage/maybeOf.html
[`PageStorage.of`]: {{site.api}}/flutter/widgets/PageStorage/of.html
[`PrimaryScrollController.maybeOf`]: {{site.api}}/flutter/widgets/PrimaryScrollController/maybeOf.html
[`PrimaryScrollController.of`]: {{site.api}}/flutter/widgets/PrimaryScrollController/of.html
[`RenderAbstractViewport.maybeOf`]: {{site.api}}/flutter/rendering/RenderAbstractViewport/maybeOf.html
[`RenderAbstractViewport.of`]: {{site.api}}/flutter/rendering/RenderAbstractViewport/of.html
[`RestorationScope.maybeOf`]: {{site.api}}/flutter/widgets/RestorationScope/maybeOf.html
[`RestorationScope.of`]: {{site.api}}/flutter/widgets/RestorationScope/of.html
[`Scrollable.maybeOf`]: {{site.api}}/flutter/widgets/Scrollable/maybeOf.html
[`Scrollable.of`]: {{site.api}}/flutter/widgets/Scrollable/of.html
[`ScrollNotificationObserver.maybeOf`]: {{site.api}}/flutter/widgets/ScrollNotificationObserver/maybeOf.html
[`ScrollNotificationObserver.of`]: {{site.api}}/flutter/widgets/ScrollNotificationObserver/of.html
[Add `maybeOf` for all the cases when `of` returns nullable]: {{site.repo.flutter}}/pull/114120
[Add `Overlay.maybeOf`, make `Overlay.of` return a non-nullable instance]: {{site.repo.flutter}}/pull/110811
