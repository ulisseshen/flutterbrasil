---
ia-translate: true
title: Migrar `of` para valores de retorno não nulos e adicionar `maybeOf`
description: >
  Para eliminar parâmetros nullOk e ajudar na sanidade da API em face
  da segurança nula.
---

## Resumo

Este guia de migração descreve a conversão de código que usa várias funções
estáticas `of` para recuperar informações de um contexto que costumava retornar
valores anuláveis, mas agora retorna valores não nulos.

## Contexto

O Flutter tem um padrão comum de permitir a pesquisa de alguns tipos de widgets
(normalmente [`InheritedWidget`][], mas também outros) usando funções de membro
estáticas que normalmente são chamadas de `of`.

Quando a não nulidade se tornou o padrão, então se tornou desejável que as APIs
mais usadas retornassem um valor não nulo. Isso ocorre porque dizer
`Scrollable.of(context)` e ainda exigir um operador `!` ou `?` e um valor de
fallback após essa chamada parecia estranho e não era idiomático para código
Dart não anulável.

Grande parte dessa migração foi realizada quando eliminamos os parâmetros
`nullOk` em uma [migração anterior][], mas alguns métodos `of` foram perdidos
nessa migração e alguns foram adicionados posteriormente com tipos de retorno
anuláveis, contrariando nosso padrão comum.

Nesta migração, os acessadores `of` afetados foram divididos em duas chamadas:
uma que retornava um valor não nulo e lançava uma exceção quando o valor
procurado não estava presente (ainda chamado de `of`) e uma que retornava um
valor anulável que não lançava uma exceção e retornava nulo se o valor não
estivesse presente (um novo método chamado `maybeOf`).

## Descrição da mudança

A mudança modificou essas APIs estáticas `of` para retornar valores não nulos.
Se um valor não for encontrado, eles agora também farão uma asserção no modo de
depuração e lançarão uma exceção no modo de release.

*   [`AutofillGroup.of`]
*   [`DefaultTabController.of`]
*   [`DefaultTextHeightBehavior.of`]
*   [`Form.of`]
*   [`HeroControllerScope.of`]
*   [`Material.of`]
*   [`Overlay.of`]
*   [`PageStorage.of`]
*   [`PrimaryScrollController.of`]
*   [`RenderAbstractViewport.of`]
*   [`RestorationScope.of`]
*   [`Scrollable.of`]
*   [`ScrollNotificationObserver.of`]

Essa mudança também introduziu novas APIs estáticas `maybeOf` junto com as
funções acima, que retornam uma versão anulável do mesmo valor e simplesmente
retornam nulo se o valor não for encontrado, sem lançar nenhuma exceção.

*   [`AutofillGroup.maybeOf`]
*   [`DefaultTabController.maybeOf`]
*   [`DefaultTextHeightBehavior.maybeOf`]
*   [`Form.maybeOf`]
*   [`HeroControllerScope.maybeOf`]
*   [`Material.maybeOf`]
*   [`Overlay.maybeOf`]
*   [`PageStorage.maybeOf`]
*   [`PrimaryScrollController.maybeOf`]
*   [`RenderAbstractViewport.maybeOf`]
*   [`RestorationScope.maybeOf`]
*   [`Scrollable.maybeOf`]
*   [`ScrollNotificationObserver.maybeOf`]

## Guia de migração

Para modificar seu código para usar a nova forma das APIs, primeiro converta
todas as instâncias das funções estáticas originais `of` (onde sua nulidade é
importante) para usar a forma `maybeOf` em vez disso.

Código antes da migração:

```dart
ScrollController? controller = Scrollable.of(context);
```

Código após a migração:

```dart
ScrollController? controller = Scrollable.maybeOf(context);
```

Em seguida, para instâncias em que o código chama a API `of` seguido por um ponto
de exclamação, basta remover o ponto de exclamação: ele não pode mais retornar
um valor anulável.

Código antes da migração:

```dart
ScrollController controller = Scrollable.of(context)!;
```

Código após a migração:

```dart
ScrollController controller = Scrollable.of(context);
```

O seguinte também pode ser útil:

*   [`unnecessary_non_null_assertion`][] (mensagem do linter) identifica
    locais onde um operador `!` deve ser removido
*   [`unnecessary_null_checks`][] (opção de análise) identifica locais onde o
    operador `?` não é necessário
*   [`unnecessary_null_in_if_null_operators`][] identifica locais onde um
    operador `??` não é necessário
*   [`unnecessary_nullable_for_final_variable_declarations`][] (opção de
    análise) encontra operadores de ponto de interrogação desnecessários em
    variáveis `final` e `const`

## Linha do tempo

Na versão estável: 3.7

## Referências

Documentação da API:

*   [`Material.of`][]

PRs relevantes:

*   [Adicionar `maybeOf` para todos os casos quando `of` retorna anulável][]
*   [Adicionar `Overlay.maybeOf`, fazer `Overlay.of` retornar uma instância não
    anulável][]

[migração anterior]: /release/breaking-changes/eliminating-nullok-parameters
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
[Adicionar `maybeOf` para todos os casos quando `of` retorna anulável]: {{site.repo.flutter}}/pull/114120
[Adicionar `Overlay.maybeOf`, fazer `Overlay.of` retornar uma instância não anulável]: {{site.repo.flutter}}/pull/110811
