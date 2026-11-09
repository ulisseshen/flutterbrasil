---
ia-translate: true
title: Escalonamento de fonte não linear do Android 14 habilitado
description: >-
  O novo recurso de escalonamento de fonte não linear do Android 14
  está habilitado no Flutter após a v3.14.
---

{% render "docs/breaking-changes.md" %}

## Resumo

O Android 14 introduziu escalonamento de fonte não linear de até 200%.
Isso pode alterar a aparência do seu app quando o usuário muda
o escalonamento de texto de acessibilidade nas preferências do sistema.

## Contexto

O recurso de [escalonamento de fonte não linear do Android 14][Android 14 nonlinear font scaling] evita
o escalonamento excessivo da fonte de acessibilidade ao escalonar texto maior em uma taxa menor
quando o usuário aumenta o valor de escalonamento de texto nas preferências do sistema.

## Guia de migração

Como a
[visão geral de recursos do Android 14][Android 14 nonlinear font scaling] sugere,
teste sua UI com o tamanho máximo de fonte habilitado (`200%`).
Isso deve verificar que seu app pode aplicar os tamanhos de fonte corretamente
e pode acomodar tamanhos de fonte maiores sem impactar a usabilidade.

Para adotar o escalonamento de fonte não linear em seu app e widgets personalizados,
considere migrar de `textScaleFactor` para `TextScaler`.
Para aprender como migrar para `TextScaler`,
confira o guia de migração
[Deprecate `textScaleFactor` in favor of `TextScaler`][Deprecate `textScaleFactor` in favor of `TextScaler`].

**Optando por não participar temporariamente**

Para desativar o escalonamento de texto não linear no Android 14 até você migrar seu app,
adicione um `MediaQuery` modificado no topo da árvore de widgets do seu app:

```dart
runApp(
  Builder(builder: (context) {
    final mediaQueryData = MediaQuery.of(context);
    final mediaQueryDataWithLinearTextScaling = mediaQueryData
      .copyWith(textScaler: TextScaler.linear(mediaQueryData.textScaler.textScaleFactor));
    return MediaQuery(data: mediaQueryDataWithLinearTextScaling, child: realWidgetTree);
  }),
);
```

Isso usa a API `textScaleFactor` obsoleta.
Isso deixará de funcionar assim que essa API for removida da API Flutter.

## Linha do tempo

Incluído na versão: 3.14.0-11.0.pre<br>
No lançamento estável: 3.16

## Referências

Documentação da API:

* [`TextScaler`][`TextScaler`]

Issues relevantes:

* [New font scaling system (Issue 116231)][New font scaling system (Issue 116231)]

PRs relevantes:

* [Implementing TextScaler for nonlinear text scaling][Implementing TextScaler for nonlinear text scaling]

Veja também:

* [Deprecate `textScaleFactor` in favor of `TextScaler`][Deprecate `textScaleFactor` in favor of `TextScaler`]

[Android 14 nonlinear font scaling]: {{site.android-dev}}/about/versions/14/features#non-linear-font-scaling
[Deprecate `textScaleFactor` in favor of `TextScaler`]: /release/breaking-changes/deprecate-textscalefactor
[`TextScaler`]: {{site.api}}/flutter/painting/TextScaler-class.html
[New font scaling system (Issue 116231)]: {{site.repo.flutter}}/issues/116231
[Implementing TextScaler for nonlinear text scaling]: {{site.repo.engine}}/pull/44907
