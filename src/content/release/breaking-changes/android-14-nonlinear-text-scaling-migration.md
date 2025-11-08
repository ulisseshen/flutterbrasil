---
title: Escala de fonte não linear do Android 14 habilitada
description: >-
  O novo recurso de escala de fonte não linear do Android 14 está
  habilitado no Flutter após v3.14.
ia-translate: true
---

## Resumo

O Android 14 introduziu escala de fonte não linear de até 200%.
Isso pode mudar a aparência do seu aplicativo quando o usuário altera
a escala de texto de acessibilidade nas preferências do sistema.

## Contexto

O recurso de [escala de fonte não linear do Android 14][Android 14 nonlinear font scaling] previne
escala de fonte de acessibilidade excessiva escalando textos maiores a uma taxa menor
quando o usuário aumenta o valor de escala de texto nas preferências do sistema.

## Guia de migração

Como a
[visão geral de recursos do Android 14][Android 14 nonlinear font scaling] sugere,
teste sua UI com o tamanho máximo de fonte habilitado (`200%`).
Isso deve verificar que seu aplicativo pode aplicar os tamanhos de fonte corretamente
e pode acomodar tamanhos de fonte maiores sem impactar a usabilidade.

Para adotar a escala de fonte não linear em seu aplicativo e widgets personalizados,
considere migrar de `textScaleFactor` para `TextScaler`.
Para aprender como migrar para `TextScaler`,
confira o
guia de migração [Deprecate `textScaleFactor` in favor of `TextScaler`][].

**Desativação temporária**

Para desativar a escala de texto não linear no Android 14 até você migrar seu aplicativo,
adicione um `MediaQuery` modificado no topo da árvore de widgets do seu aplicativo:

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

Isso usa a API `textScaleFactor` depreciada.
Isso deixará de funcionar assim que essa API for removida da API do Flutter.

## Linha do tempo

Implementado na versão: 3.14.0-11.0.pre<br>
Na versão estável: 3.16

## Referências

Documentação da API:

* [`TextScaler`][]

Issues relevantes:

* [New font scaling system (Issue 116231)][]

PRs relevantes:

* [Implementing TextScaler for nonlinear text scaling][]

Veja também:

* [Deprecate `textScaleFactor` in favor of `TextScaler`][]

[Android 14 nonlinear font scaling]: {{site.android-dev}}/about/versions/14/features#non-linear-font-scaling
[Deprecate `textScaleFactor` in favor of `TextScaler`]: /release/breaking-changes/deprecate-textscalefactor
[`TextScaler`]: {{site.api}}/flutter/painting/TextScaler-class.html
[New font scaling system (Issue 116231)]: {{site.repo.flutter}}/issues/116231
[Implementing TextScaler for nonlinear text scaling]: {{site.repo.engine}}/pull/44907
