---
ia-translate: true
title: Escala de fonte não linear do Android 14 habilitada
description: >-
  O novo recurso de escala de fonte não linear do Android 14
  está habilitado no Flutter após a v3.14.
---

## Sumário

O Android 14 introduziu a escala de fonte não linear até 200%. Isso pode
mudar a aparência do seu aplicativo quando o usuário altera a escala de
texto de acessibilidade nas preferências do sistema.

## Contexto

O recurso de [escala de fonte não linear do Android 14][] impede o
dimensionamento excessivo da fonte de acessibilidade, dimensionando textos
maiores a uma taxa menor quando o usuário aumenta o valor de escala de
texto nas preferências do sistema.

## Guia de migração

Como a [visão geral dos recursos do Android 14][] sugere, teste sua UI com o
tamanho máximo de fonte habilitado (`200%`). Isso deve verificar se seu
aplicativo pode aplicar os tamanhos de fonte corretamente e pode acomodar
tamanhos de fonte maiores sem afetar a usabilidade.

Para adotar a escala de fonte não linear em seu aplicativo e widgets
personalizados, considere migrar de `textScaleFactor` para `TextScaler`.
Para aprender como migrar para `TextScaler`, confira o guia de migração
[Descontinuar `textScaleFactor` em favor de `TextScaler`][].

**Desativação temporária**

Para desativar a escala de texto não linear no Android 14 até que você
migre seu aplicativo, adicione um `MediaQuery` modificado na parte
superior da árvore de widgets do seu aplicativo:

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

Isso usa a API `textScaleFactor` que está obsoleta. Ela deixará de
funcionar quando essa API for removida da API do Flutter.

## Cronograma

Implementado na versão: 3.14.0-11.0.pre<br>
Na versão estável: 3.16

## Referências

Documentação da API:

*   [`TextScaler`][]

Problemas relevantes:

*   [Novo sistema de escala de fonte (Issue 116231)][]

PRs relevantes:

*   [Implementando TextScaler para escala de texto não linear][]

Veja também:

*   [Descontinuar `textScaleFactor` em favor de `TextScaler`][]

[escala de fonte não linear do Android 14]: {{site.android-dev}}/about/versions/14/features#non-linear-font-scaling
[Descontinuar `textScaleFactor` em favor de `TextScaler`]: /release/breaking-changes/deprecate-textscalefactor
[`TextScaler`]: {{site.api}}/flutter/painting/TextScaler-class.html
[Novo sistema de escala de fonte (Issue 116231)]: {{site.repo.flutter}}/issues/116231
[Implementando TextScaler para escala de texto não linear]: {{site.repo.engine}}/pull/44907
[visão geral dos recursos do Android 14]: {{site.android-dev}}/about/versions/14/features#non-linear-font-scaling
