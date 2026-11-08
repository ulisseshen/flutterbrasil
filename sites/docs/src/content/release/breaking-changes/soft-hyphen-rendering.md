---
ia-translate: true
title: Hifens suaves são renderizados nas quebras de linha
description: >-
  O texto agora exibe um hífen quando uma linha quebra em um hífen suave (U+00AD),
  e TextStyle.getParagraphStyle tem um novo parâmetro hyphens.
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Quando uma linha de texto quebra em um hífen suave (U+00AD),
o Flutter agora desenha um hífen visível no final da linha.
Um novo enum [`Hyphens`][] controla isso,
e [`TextStyle.getParagraphStyle`][] tem um novo parâmetro `hyphens`.
Classes que sobrescrevem `getParagraphStyle` devem adicionar o parâmetro.

## Contexto {:#background}

Um hífen suave marca um lugar onde uma palavra pode ser quebrada entre linhas.
O Flutter já quebrava linhas nos hifens suaves,
mas nunca desenhava o hífen, então palavras quebradas pareciam cortadas.

O novo parâmetro `hyphens` em [`Text`][], [`RichText`][], [`TextPainter`][]
e no [`ParagraphStyle`][] de `dart:ui` recebe um valor `Hyphens`:

* `Hyphens.manual` (o padrão) desenha um hífen na quebra.
* `Hyphens.hidden` não desenha um hífen.
  O hífen suave continua sendo um lugar onde a linha pode quebrar.

Esta mudança afeta os apps de duas formas.

**Renderização.** O texto agora exibe um hífen
sempre que uma linha quebra em um hífen suave.
As linhas continuam quebrando nos mesmos lugares,
mas o hífen deixa a sua linha mais larga,
então pode alterar `Paragraph.longestLine` e o tamanho do texto
disposto com [`TextWidthBasis.longestLine`][].
Testes de imagem golden que contenham esse tipo de texto podem precisar de atualização.

Isso se aplica a todas as plataformas, exceto a web,
onde hifens suaves serão renderizados em uma versão posterior.
Widgets baseados em `EditableText`, como `TextField` e `SelectableText`,
também renderizam o hífen, mas ainda não têm um parâmetro `hyphens`,
então não há como optar por não usar o recurso neles.

No Flutter 3.50, o hífen tem alguns problemas conhecidos,
que uma versão posterior corrige:

* Ele pode aparecer onde a linha não quebra no hífen suave,
  como no final do texto ou antes de um espaço ou quebra de linha.
* Ele pode ultrapassar um pouco a largura do parágrafo.
  Com a correção, a linha passa a quebrar antes quando o hífen não couber.
* Ele não é destacado quando o texto é selecionado.

Para evitar esses problemas na 3.50,
defina `hyphens: Hyphens.hidden` em `Text`, `RichText` ou `TextPainter`.

**API.** `TextStyle.getParagraphStyle` ganhou um parâmetro opcional `hyphens`.
Como o Dart exige que uma sobrescrita aceite todos os parâmetros
do método que sobrescreve, uma classe que sobrescreve `getParagraphStyle`
deixa de compilar até adicionar o parâmetro.
Isso afeta principalmente test doubles e proxies de `TextStyle`,
e não o código típico de apps.

## Guia de migração {:#migration-guide}

### Mantenha a renderização antiga {:#keep-the-old-rendering}

Para manter os hifens suaves invisíveis, passe `Hyphens.hidden`.

Código antes da migração:

```dart
Text('inter­national')
```

Código após a migração:

```dart
Text('inter­national', hyphens: Hyphens.hidden)
```

### Atualize sobrescritas de `getParagraphStyle` {:#update-overrides}

Se você sobrescreve `TextStyle.getParagraphStyle`, adicione o novo parâmetro.

Código antes da migração:

```dart
@override
ui.ParagraphStyle getParagraphStyle({
  TextAlign? textAlign,
  // ...other parameters...
  StrutStyle? strutStyle,
}) {
  // ...
}
```

Código após a migração:

```dart
@override
ui.ParagraphStyle getParagraphStyle({
  TextAlign? textAlign,
  // ...other parameters...
  StrutStyle? strutStyle,
  Hyphens? hyphens,
}) {
  // ...
}
```

Se a sua sobrescrita repassa a chamada para outro `getParagraphStyle`
ou constrói um `ParagraphStyle`, passe `hyphens` adiante.
Caso contrário, aceitar e ignorar o parâmetro é suficiente.

## Linha do tempo {:#timeline}

Incluído na versão: 3.49.0-1.0.pre-294<br>
Na web, incluído na versão: 3.50.0-1.0.pre-109<br>
Na versão estável: Ainda não

## Referências {:#references}

Documentação da API:

* [`Hyphens`][]
* [`ParagraphStyle`][]
* [`RichText`][]
* [`Text`][]
* [`TextPainter`][]
* [`TextStyle.getParagraphStyle`][]

Issues relevantes:

* [Support soft hyphenation][issue-18443]

PRs relevantes:

* [Support soft hyphen (U+00AD) rendering with a Hyphens API][]
* [Render soft hyphens on Skwasm][pr-193850]
* [Render soft hyphens on CanvasKit][pr-194339]

[`Hyphens`]: {{site.api}}/flutter/dart-ui/Hyphens.html
[`ParagraphStyle`]: {{site.api}}/flutter/dart-ui/ParagraphStyle-class.html
[`RichText`]: {{site.api}}/flutter/widgets/RichText-class.html
[`Text`]: {{site.api}}/flutter/widgets/Text-class.html
[`TextPainter`]: {{site.api}}/flutter/painting/TextPainter-class.html
[`TextStyle.getParagraphStyle`]: {{site.api}}/flutter/painting/TextStyle/getParagraphStyle.html
[`TextWidthBasis.longestLine`]: {{site.api}}/flutter/painting/TextWidthBasis.html
[issue-18443]: {{site.repo.flutter}}/issues/18443
[Support soft hyphen (U+00AD) rendering with a Hyphens API]: {{site.repo.flutter}}/pull/185152
[pr-193850]: {{site.repo.flutter}}/pull/193850
[pr-194339]: {{site.repo.flutter}}/pull/194339
