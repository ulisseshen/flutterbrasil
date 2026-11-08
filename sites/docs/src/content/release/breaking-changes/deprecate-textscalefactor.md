---
title: Descontinuação de textScaleFactor em favor de TextScaler
description: >-
  A nova classe TextScaler substitui o escalar textScaleFactor em
  preparação para o suporte de escala de texto não linear do Android 14.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

Em preparação para adotar o recurso [Android 14 nonlinear font scaling][],
todas as ocorrências de `textScaleFactor` no framework Flutter foram
descontinuadas e substituídas por `TextScaler`.

## Context

Muitas plataformas permitem que os usuários escalem conteúdos textuais para cima ou para baixo globalmente nas preferências do sistema. No passado, a estratégia de escala era capturada como um único valor `double` chamado `textScaleFactor`, já que a escala de texto era proporcional:
`scaledFontSize = textScaleFactor x unScaledFontSize`. Por exemplo, quando
`textScaleFactor` é 2.0 e o tamanho da fonte especificado pelo desenvolvedor é 14.0, o tamanho real da fonte é 2.0 x 14.0 = 28.0.

Com a introdução do [Android 14 nonlinear font scaling][], textos maiores são escalados a uma taxa menor em comparação com textos menores, para evitar escala excessiva de texto que já é grande. O valor escalar `textScaleFactor` usado pela escala "proporcional" não é suficiente para representar essa nova estratégia de escala.
O pull request [Replaces `textScaleFactor` with `TextScaler`][] introduziu uma
nova classe `TextScaler` para substituir `textScaleFactor` em preparação para este novo recurso. A escala de texto não linear é introduzida em um pull request diferente.

## Description of change

Introduzindo uma nova interface `TextScaler`, que
representa uma estratégia de escala de texto.

```dart
abstract class TextScaler {
  double scale(double fontSize);
  double get textScaleFactor; // Deprecated.
}
```

Use o método `scale` para escalar tamanhos de fonte em vez de `textScaleFactor`.
O getter `textScaleFactor` fornece um valor estimado de `textScaleFactor`, é
para fins de compatibilidade com versões anteriores e já está marcado como descontinuado, e
será removido em uma versão futura do Flutter.

A nova classe substituiu
`double textScaleFactor` (`double textScaleFactor` -> `TextScaler textScaler`),
nas seguintes APIs:

### Painting library

| Affected APIs                                                                     | Error Message                                          |
|-----------------------------------------------------------------------------------|--------------------------------------------------------|
| `InlineSpan.build({ double textScaleFactor = 1.0 })` argument                     | The named parameter 'textScaleFactor' isn't defined.   |
| `TextStyle.getParagraphStyle({ double TextScaleFactor = 1.0 })` argument          | The named parameter 'textScaleFactor' isn't defined.   |
| `TextStyle.getTextStyle({ double TextScaleFactor = 1.0 })`  argument              | 'textScaleFactor' is deprecated and shouldn't be used. |
| `TextPainter({ double TextScaleFactor = 1.0 })` constructor argument              | 'textScaleFactor' is deprecated and shouldn't be used. |
| `TextPainter.textScaleFactor` getter and setter                                   | 'textScaleFactor' is deprecated and shouldn't be used. |
| `TextPainter.computeWidth({ double TextScaleFactor = 1.0 })` argument             | 'textScaleFactor' is deprecated and shouldn't be used. |
| `TextPainter.computeMaxIntrinsicWidth({ double TextScaleFactor = 1.0 })` argument | 'textScaleFactor' is deprecated and shouldn't be used. |

### Rendering library

| Affected APIs                                                            | Error Message                                          |
|--------------------------------------------------------------------------|--------------------------------------------------------|
| `RenderEditable({ double TextScaleFactor = 1.0 })` constructor argument  | 'textScaleFactor' is deprecated and shouldn't be used. |
| `RenderEditable.textScaleFactor` getter and setter                       | 'textScaleFactor' is deprecated and shouldn't be used. |
| `RenderParagraph({ double TextScaleFactor = 1.0 })` constructor argument | 'textScaleFactor' is deprecated and shouldn't be used. |
| `RenderParagraph.textScaleFactor` getter and setter                      | 'textScaleFactor' is deprecated and shouldn't be used. |

### Widgets library

| Affected APIs                                                           | Error Message                                                 |
|-------------------------------------------------------------------------|---------------------------------------------------------------|
| `MediaQueryData({ double TextScaleFactor = 1.0 })` constructor argument | 'textScaleFactor' is deprecated and shouldn't be used.        |
| `MediaQueryData.textScaleFactor` getter                                 | 'textScaleFactor' is deprecated and shouldn't be used.        |
| `MediaQueryData.copyWith({ double? TextScaleFactor })` argument         | 'textScaleFactor' is deprecated and shouldn't be used.        |
| `MediaQuery.maybeTextScaleFactorOf(BuildContext context)` static method | 'maybeTextScaleFactorOf' is deprecated and shouldn't be used. |
| `MediaQuery.textScaleFactorOf(BuildContext context)` static method      | 'textScaleFactorOf' is deprecated and shouldn't be used.      |
| `RichText({ double TextScaleFactor = 1.0 })` constructor argument       | 'textScaleFactor' is deprecated and shouldn't be used.        |
| `RichText.textScaleFactor` getter                                       | 'textScaleFactor' is deprecated and shouldn't be used.        |
| `Text({ double? TextScaleFactor = 1.0 })` constructor argument          | 'textScaleFactor' is deprecated and shouldn't be used.        |
| `Text.rich({ double? TextScaleFactor = 1.0 })` constructor argument     | 'textScaleFactor' is deprecated and shouldn't be used.        |
| `Text.textScaleFactor` getter                                           | 'textScaleFactor' is deprecated and shouldn't be used.        |
| `EditableText({ double? TextScaleFactor = 1.0 })` constructor argument  | 'textScaleFactor' is deprecated and shouldn't be used.        |
| `EditableText.textScaleFactor` getter                                   | 'textScaleFactor' is deprecated and shouldn't be used.        |

### Material library

| Affected APIs                                                                 | Error Message                                          |
|-------------------------------------------------------------------------------|--------------------------------------------------------|
| `SelectableText({ double? TextScaleFactor = 1.0 })` constructor argument      | 'textScaleFactor' is deprecated and shouldn't be used. |
| `SelectableText.rich({ double? TextScaleFactor = 1.0 })` constructor argument | 'textScaleFactor' is deprecated and shouldn't be used. |
| `SelectableText.textScaleFactor` getter                                       | 'textScaleFactor' is deprecated and shouldn't be used. |

## Migration guide

Os widgets fornecidos pelo framework Flutter já foram migrados.
A migração é necessária apenas se você estiver usando algum dos
símbolos descontinuados listados nas tabelas anteriores.

### Migrando suas APIs que expõem `textScaleFactor`

Before:

```dart
abstract class _MyCustomPaintDelegate {
  void paint(PaintingContext context, Offset offset, double textScaleFactor) {
  }
}
```

After:

```dart
abstract class _MyCustomPaintDelegate {
  void paint(PaintingContext context, Offset offset, TextScaler textScaler) {
  }
}
```

### Migrando código que consome `textScaleFactor`

Se você não está usando `textScaleFactor` diretamente, mas sim passando-o
para uma API diferente que recebe um `textScaleFactor`, e a API receptora já
foi migrada, então é relativamente simples:

Before:

```dart
RichText(
  textScaleFactor: MediaQuery.textScaleFactorOf(context),
  ...
)
```

After:

```dart
RichText(
  textScaler: MediaQuery.textScalerOf(context),
  ...
)
```

Se a API que fornece `textScaleFactor` não foi migrada, considere
aguardar pela versão migrada.

Se você deseja calcular o tamanho da fonte escalado você mesmo, use `TextScaler.scale`
em vez do operador binário `*`:

Before:

```dart
final scaledFontSize = textStyle.fontSize * MediaQuery.textScaleFactorOf(context);
```

After:

```dart
final scaledFontSize = MediaQuery.textScalerOf(context).scale(textStyle.fontSize);
```

Se você está usando `textScaleFactor` para escalar dimensões que não são tamanhos de fonte,
não há regras genéricas para migrar o código para escala não linear, e pode
ser necessário que a UI seja implementada de forma diferente.
Reutilizando o exemplo `MyTooltipBox`:

```dart
MyTooltipBox(
  size: chatBoxSize * textScaleFactor,
  child: RichText(..., style: TextStyle(fontSize: 20)),
)
```

Você pode escolher usar o fator de escala de texto "efetivo" aplicando o
`TextScaler` no tamanho de fonte 20: `chatBoxSize * textScaler.scale(20) / 20`, ou
redesenhar a UI e deixar o widget assumir seu próprio tamanho intrínseco.

### Sobrescrevendo a estratégia de escala de texto em uma subárvore de widget

Para sobrescrever o `TextScaler` existente usado em uma subárvore de widget, sobrescreva
o `MediaQuery` assim:

Before:

```dart
MediaQuery(
  data: MediaQuery.of(context).copyWith(textScaleFactor: 2.0),
  child: child,
)
```

After:

```dart
MediaQuery(
  data: MediaQuery.of(context).copyWith(textScaler: _myCustomTextScaler),
  child: child,
)
```

No entanto, raramente é necessário criar uma subclasse `TextScaler` personalizada.
`MediaQuery.withNoTextScaling` (que cria um widget que desabilita a escala de texto
completamente para sua subárvore filha), e `MediaQuery.withClampedTextScaling` (que
cria um widget que restringe o tamanho da fonte escalado dentro do intervalo
`[minScaleFactor * fontSize, maxScaleFactor * fontSize]`), são métodos de conveniência
que cobrem casos comuns onde a estratégia de escala de texto precisa ser sobrescrita.

#### Examples

**Desabilitando a Escala de Texto Para Fontes de Ícones**

Before:

```dart
MediaQuery(
  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
  child: IconTheme(
    data: ..,
    child: icon,
  ),
)
```

After:

```dart
MediaQuery.withNoTextScaling(
  child: IconTheme(
    data: ...
    child: icon,
  ),
)
```

**Evitando que Conteúdos Tenham Escala Excessiva**

Before:

```dart
final mediaQueryData = MediaQuery.of(context);
MediaQuery(
  data: mediaQueryData.copyWith(textScaleFactor: math.min(mediaQueryData.textScaleFactor, _kMaxTitleTextScaleFactor),
  child: child,
)
```

After:

```dart
MediaQuery.withClampedTextScaling(
  maxScaleFactor: _kMaxTitleTextScaleFactor,
  child: title,
)
```

**Desabilitando a Escala de Texto Não Linear**

Se você deseja optar temporariamente por não usar a escala de texto não linear no Android 14 até que seu aplicativo esteja totalmente migrado, coloque um `MediaQuery` modificado no topo da árvore de widgets do seu aplicativo:

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

Este truque usa a API descontinuada `textScaleFactor` e vai parar de funcionar uma vez que
seja removida da API do Flutter.

## Timeline

Landed in version: 3.13.0-4.0.pre<br>
In stable release: 3.16

## References

API documentation:

* [`TextScaler`][]
* [`MediaQuery.textScalerOf`][]
* [`MediaQuery.maybeTextScalerOf`][]
* [`MediaQuery.withNoTextScaling`][]
* [`MediaQuery.withClampedTextScaling`][]

Relevant issues:

* [New font scaling system (Issue 116231)][]

Relevant PRs:

* [Replaces `textScaleFactor` with `TextScaler`][]


[Android 14 nonlinear font scaling]: {{site.android-dev}}/about/versions/14/features#non-linear-font-scaling
[`TextScaler`]: {{site.api}}/flutter/painting/TextScaler-class.html
[`MediaQuery.textScalerOf`]: {{site.api}}/flutter/widgets/MediaQuery/textScalerOf.html
[`MediaQuery.maybeTextScalerOf`]: {{site.api}}/flutter/widgets/MediaQuery/maybeTextScalerOf.html
[`MediaQuery.withNoTextScaling`]: {{site.api}}/flutter/widgets/MediaQuery/withNoTextScaling.html
[`MediaQuery.withClampedTextScaling`]: {{site.api}}/flutter/widgets/MediaQuery/withClampedTextScaling.html

[New font scaling system (Issue 116231)]: {{site.repo.flutter}}/issues/116231
[Replaces `textScaleFactor` with `TextScaler`]: {{site.repo.flutter}}/pull/128522
