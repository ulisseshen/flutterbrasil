---
ia-translate: true
title: Depreciação de textScaleFactor em favor de TextScaler
description: >-
  A nova classe, TextScaler, substitui o escalar textScaleFactor em
  preparação para o suporte de escala de texto não linear do Android 14.
---

## Sumário

Em preparação para a adoção do recurso de [escala de fonte não linear do Android 14][], todas as ocorrências de `textScaleFactor` no framework Flutter foram depreciadas e substituídas por `TextScaler`.

## Contexto

Muitas plataformas permitem que os usuários aumentem ou diminuam o conteúdo textual globalmente nas preferências do sistema. No passado, a estratégia de escala era capturada como um único valor `double` chamado `textScaleFactor`, já que a escala de texto era proporcional: `scaledFontSize = textScaleFactor x unScaledFontSize`. Por exemplo, quando `textScaleFactor` é 2.0 e o tamanho da fonte especificado pelo desenvolvedor é 14.0, o tamanho real da fonte é 2.0 x 14.0 = 28.0.

Com a introdução da [escala de fonte não linear do Android 14][], textos maiores são escalados a uma taxa menor em comparação com textos menores, para evitar o dimensionamento excessivo de textos que já são grandes. O valor escalar `textScaleFactor` usado pela escala "proporcional" não é suficiente para representar esta nova estratégia de escala. O pull request [Substitui `textScaleFactor` por `TextScaler`][] introduziu uma nova classe `TextScaler` para substituir `textScaleFactor` em preparação para este novo recurso. A escala de texto não linear é introduzida em um pull request diferente.

## Descrição da mudança

Introduzindo uma nova interface `TextScaler`, que representa uma estratégia de escala de texto.

```dart
abstract class TextScaler {
  double scale(double fontSize);
  double get textScaleFactor; // Depreciado.
}
```

Use o método `scale` para escalar os tamanhos de fonte em vez de `textScaleFactor`. O getter `textScaleFactor` fornece um valor `textScaleFactor` estimado, é para fins de compatibilidade com versões anteriores e já está marcado como depreciado e será removido em uma versão futura do Flutter.

A nova classe substituiu `double textScaleFactor` (`double textScaleFactor` -> `TextScaler textScaler`), nas seguintes APIs:

### Biblioteca de Pintura

| APIs Afetadas                                                                     | Mensagem de Erro                                          |
|-----------------------------------------------------------------------------------|--------------------------------------------------------|
| Argumento `InlineSpan.build({ double textScaleFactor = 1.0 })`                     | O parâmetro nomeado 'textScaleFactor' não está definido.  |
| Argumento `TextStyle.getParagraphStyle({ double TextScaleFactor = 1.0 })`          | O parâmetro nomeado 'textScaleFactor' não está definido.  |
| Argumento `TextStyle.getTextStyle({ double TextScaleFactor = 1.0 })`               | 'textScaleFactor' está depreciado e não deve ser usado. |
| Argumento do construtor `TextPainter({ double TextScaleFactor = 1.0 })`              | 'textScaleFactor' está depreciado e não deve ser usado. |
| Getter e setter `TextPainter.textScaleFactor`                                   | 'textScaleFactor' está depreciado e não deve ser usado. |
| Argumento `TextPainter.computeWidth({ double TextScaleFactor = 1.0 })`             | 'textScaleFactor' está depreciado e não deve ser usado. |
| Argumento `TextPainter.computeMaxIntrinsicWidth({ double TextScaleFactor = 1.0 })` | 'textScaleFactor' está depreciado e não deve ser usado. |

### Biblioteca de Renderização

| APIs Afetadas                                                            | Mensagem de Erro                                          |
|--------------------------------------------------------------------------|--------------------------------------------------------|
| Argumento do construtor `RenderEditable({ double TextScaleFactor = 1.0 })`  | 'textScaleFactor' está depreciado e não deve ser usado. |
| Getter e setter `RenderEditable.textScaleFactor`                       | 'textScaleFactor' está depreciado e não deve ser usado. |
| Argumento do construtor `RenderParagraph({ double TextScaleFactor = 1.0 })` | 'textScaleFactor' está depreciado e não deve ser usado. |
| Getter e setter `RenderParagraph.textScaleFactor`                      | 'textScaleFactor' está depreciado e não deve ser usado. |

### Biblioteca de Widgets

| APIs Afetadas                                                           | Mensagem de Erro                                                 |
|-------------------------------------------------------------------------|---------------------------------------------------------------|
| Argumento do construtor `MediaQueryData({ double TextScaleFactor = 1.0 })` | 'textScaleFactor' está depreciado e não deve ser usado.        |
| Getter `MediaQueryData.textScaleFactor`                                 | 'textScaleFactor' está depreciado e não deve ser usado.        |
| Argumento `MediaQueryData.copyWith({ double? TextScaleFactor })`         | 'textScaleFactor' está depreciado e não deve ser usado.        |
| Método estático `MediaQuery.maybeTextScaleFactorOf(BuildContext context)` | 'maybeTextScaleFactorOf' está depreciado e não deve ser usado. |
| Método estático `MediaQuery.textScaleFactorOf(BuildContext context)`      | 'textScaleFactorOf' está depreciado e não deve ser usado.      |
| Argumento do construtor `RichText({ double TextScaleFactor = 1.0 })`       | 'textScaleFactor' está depreciado e não deve ser usado.        |
| Getter `RichText.textScaleFactor`                                       | 'textScaleFactor' está depreciado e não deve ser usado.        |
| Argumento do construtor `Text({ double? TextScaleFactor = 1.0 })`          | 'textScaleFactor' está depreciado e não deve ser usado.        |
| Argumento do construtor `Text.rich({ double? TextScaleFactor = 1.0 })`     | 'textScaleFactor' está depreciado e não deve ser usado.        |
| Getter `Text.textScaleFactor`                                           | 'textScaleFactor' está depreciado e não deve ser usado.        |
| Argumento do construtor `EditableText({ double? TextScaleFactor = 1.0 })`  | 'textScaleFactor' está depreciado e não deve ser usado.        |
| Getter `EditableText.textScaleFactor`                                   | 'textScaleFactor' está depreciado e não deve ser usado.        |

### Biblioteca Material

| APIs Afetadas                                                                 | Mensagem de Erro                                          |
|-------------------------------------------------------------------------------|--------------------------------------------------------|
| Argumento do construtor `SelectableText({ double? TextScaleFactor = 1.0 })`      | 'textScaleFactor' está depreciado e não deve ser usado. |
| Argumento do construtor `SelectableText.rich({ double? TextScaleFactor = 1.0 })` | 'textScaleFactor' está depreciado e não deve ser usado. |
| Getter `SelectableText.textScaleFactor`                                       | 'textScaleFactor' está depreciado e não deve ser usado. |

## Guia de Migração

Os widgets fornecidos pelo framework Flutter já foram migrados. A migração é necessária apenas se você estiver usando algum dos símbolos depreciados listados nas tabelas anteriores.

### Migrando suas APIs que expõem `textScaleFactor`

Antes:

```dart
abstract class _MyCustomPaintDelegate {
  void paint(PaintingContext context, Offset offset, double textScaleFactor) {
  }
}
```

Depois:

```dart
abstract class _MyCustomPaintDelegate {
  void paint(PaintingContext context, Offset offset, TextScaler textScaler) {
  }
}
```

### Migrando código que consome `textScaleFactor`

Se você não estiver usando `textScaleFactor` diretamente, mas sim passando-o para uma API diferente que recebe um `textScaleFactor`, e a API receptora já tiver sido migrada, então é relativamente simples:

Antes:

```dart
RichText(
  textScaleFactor: MediaQuery.textScaleFactorOf(context),
  ...
)
```

Depois:

```dart
RichText(
  textScaler: MediaQuery.textScalerOf(context),
  ...
)
```

Se a API que fornece `textScaleFactor` não tiver sido migrada, considere esperar pela versão migrada.

Se você deseja calcular o tamanho da fonte escalado você mesmo, use `TextScaler.scale` em vez do operador binário `*`:

Antes:

```dart
final scaledFontSize = textStyle.fontSize * MediaQuery.textScaleFactorOf(context);
```

Depois:

```dart
final scaledFontSize = MediaQuery.textScalerOf(context).scale(textStyle.fontSize);
```

Se você estiver usando `textScaleFactor` para escalar dimensões que não são tamanhos de fonte, não há regras genéricas para migrar o código para escala não linear, e pode ser necessário que a UI seja implementada de forma diferente.
Reutilizando o exemplo `MyTooltipBox`:

```dart
MyTooltipBox(
  size: chatBoxSize * textScaleFactor,
  child: RichText(..., style: TextStyle(fontSize: 20)),
)
```

Você pode optar por usar o fator de escala de texto "efetivo" aplicando o `TextScaler` no tamanho da fonte 20: `chatBoxSize * textScaler.scale(20) / 20`, ou redesenhar a UI e deixar o widget assumir seu próprio tamanho intrínseco.

### Sobrepondo a estratégia de escala de texto em uma subárvore de widgets

Para sobrepor o `TextScaler` existente usado em uma subárvore de widgets, sobreponha o `MediaQuery` da seguinte forma:

Antes:

```dart
MediaQuery(
  data: MediaQuery.of(context).copyWith(textScaleFactor: 2.0),
  child: child,
)
```

Depois:

```dart
MediaQuery(
  data: MediaQuery.of(context).copyWith(textScaler: _myCustomTextScaler),
  child: child,
)
```

No entanto, raramente é necessário criar uma subclasse `TextScaler` personalizada. `MediaQuery.withNoTextScaling` (que cria um widget que desabilita a escala de texto completamente para sua subárvore filho) e `MediaQuery.withClampedTextScaling` (que cria um widget que restringe o tamanho da fonte escalada dentro do intervalo `[minScaleFactor * fontSize, maxScaleFactor * fontSize]`), são métodos convenientes que cobrem casos comuns onde a estratégia de escala de texto precisa ser sobreposta.

#### Exemplos

**Desabilitando a Escala de Texto para Fontes de Ícones**

Antes:

```dart
MediaQuery(
  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
  child: IconTheme(
    data: ..,
    child: icon,
  ),
)
```

Depois:

```dart
MediaQuery.withNoTextScaling(
  child: IconTheme(
    data: ...
    child: icon,
  ),
)
```

**Impedindo que Conteúdos Sejam Super Escalados**

Antes:

```dart
final mediaQueryData = MediaQuery.of(context);
MediaQuery(
  data: mediaQueryData.copyWith(textScaleFactor: math.min(mediaQueryData.textScaleFactor, _kMaxTitleTextScaleFactor),
  child: child,
)
```

Depois:

```dart
MediaQuery.withClampedTextScaling(
  maxScaleFactor: _kMaxTitleTextScaleFactor,
  child: title,
)
```

**Desabilitando a Escala de Texto Não Linear**

Se você deseja desativar temporariamente a escala de texto não linear no Android 14 até que seu aplicativo seja totalmente migrado, coloque um `MediaQuery` modificado no topo da árvore de widgets do seu aplicativo:

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

Este truque usa a API `textScaleFactor` depreciada e deixará de funcionar assim que for removida da API Flutter.

## Cronograma

Implementado na versão: 3.13.0-4.0.pre<br>
Na versão estável: 3.16

## Referências

Documentação da API:

*   [`TextScaler`][]
*   [`MediaQuery.textScalerOf`][]
*   [`MediaQuery.maybeTextScalerOf`][]
*   [`MediaQuery.withNoTextScaling`][]
*   [`MediaQuery.withClampedTextScaling`][]

Problemas relevantes:

*   [Novo sistema de escala de fonte (Issue 116231)][]

PRs relevantes:

*   [Substitui `textScaleFactor` por `TextScaler`][]

[escala de fonte não linear do Android 14]: {{site.android-dev}}/about/versions/14/features#non-linear-font-scaling
[`TextScaler`]: {{site.api}}/flutter/painting/TextScaler-class.html
[`MediaQuery.textScalerOf`]: {{site.api}}/flutter/widgets/MediaQuery/textScalerOf.html
[`MediaQuery.maybeTextScalerOf`]: {{site.api}}/flutter/widgets/MediaQuery/maybeTextScalerOf.html
[`MediaQuery.withNoTextScaling`]: {{site.api}}/flutter/widgets/MediaQuery/withNoTextScaling.html
[`MediaQuery.withClampedTextScaling`]: {{site.api}}/flutter/widgets/MediaQuery/withClampedTextScaling.html
[Novo sistema de escala de fonte (Issue 116231)]: {{site.repo.flutter}}/issues/116231
[Substitui `textScaleFactor` por `TextScaler`]: {{site.repo.flutter}}/pull/128522

