---
title: Substituir AnimationSheetBuilder.display por collate
description: >
  AnimationSheetBuilder.display e sheetSize
  foram descontinuados em favor de collate.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

Os métodos `AnimationSheetBuilder.display` e `sheetSize`
foram descontinuados, e devem ser substituídos por
`AnimationSheetBuilder.collate`.

## Contexto

[`AnimationSheetBuilder`][] é uma classe utilitária
de testes que grava frames de um widget animado,
e depois compõe os frames em uma única
folha de animação para [testes golden][golden testing]. A forma antiga
de compor envolve `display` para listar as imagens
em um widget tipo tabela, ajustando a superfície
de teste com `sheetSize`, e capturando o widget
de tabela para comparação. Uma nova forma, `collate`, foi
adicionada que coloca diretamente os frames juntos
em uma imagem para comparação, o que requer menos
código boilerplate e produz uma imagem menor sem
comprometimento na qualidade. APIs para a forma antiga são assim
descontinuadas.

A razão pela qual `collate` produz uma imagem menor,
é porque a forma antiga captura em uma superfície de teste
com proporção de pixel 3.0, o que significa que usa um bloco de pixel
3x3 exatamente da mesma cor para representar 1 pixel
real, tornando a imagem 9 vezes maior do que o necessário
(antes da compressão PNG).

## Descrição da mudança

As seguintes mudanças foram feitas na
classe [`AnimationSheetBuilder`][]:

* 'display' foi descontinuado e não deve ser usado
* 'sheetSize' foi descontinuado e não deve ser usado

## Guia de migração

Para migrar para a nova API, mude o processo de definir
tamanho de superfície e exibir o widget para
[`AnimationSheetBuilder.collate`][].

### Derivar células por linha

O `collate` requer um argumento `cellsPerRow`
explícito, que é o número de frames por
linha na imagem de saída. Pode ser contado manualmente,
ou calculado da seguinte forma:

* Encontre a largura do frame, especificada ao construir
  `AnimationSheetBuilder`. Por exemplo, no seguinte
  snippet é 80:

```dart
final AnimationSheetBuilder animationSheet = AnimationSheetBuilder(frameSize: const Size(80, 30));
```

* Encontre a largura do tamanho da superfície, especificada ao
  definir o tamanho da superfície; o padrão é 800.
  Por exemplo, no seguinte snippet é 600:

```dart
tester.binding.setSurfaceSize(animationSheet.sheetSize(600));
```

* Os frames por linha devem ser o resultado dos dois
  números divididos, arredondados para baixo. Por exemplo,
  600 / 80 = 7 (arredondado para baixo), portanto

```dart
animationSheet.collate(7)
```

### Migrar código

Código antes da migração:

```dart
  testWidgets('Indeterminate CircularProgressIndicator', (WidgetTester tester) async {
    final AnimationSheetBuilder animationSheet = AnimationSheetBuilder(frameSize: const Size(40, 40));

    await tester.pumpFrames(animationSheet.record(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Padding(
          padding: EdgeInsets.all(4),
          child: CircularProgressIndicator(),
        ),
      ),
    ), const Duration(seconds: 2));

    // The code starting here needs migration.

    tester.binding.setSurfaceSize(animationSheet.sheetSize());

    final Widget display = await animationSheet.display();
    await tester.pumpWidget(display);

    await expectLater(
      find.byWidget(display),
      matchesGoldenFile('material.circular_progress_indicator.indeterminate.png'),
    );
  }, skip: isBrowser); // https://github.com/flutter/flutter/issues/42767
```

Código após a migração (`cellsPerRow` é 20, derivado de 800 / 40):

```dart
  testWidgets('Indeterminate CircularProgressIndicator', (WidgetTester tester) async {
    final AnimationSheetBuilder animationSheet = AnimationSheetBuilder(frameSize: const Size(40, 40));

    await tester.pumpFrames(animationSheet.record(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Padding(
          padding: EdgeInsets.all(4),
          child: CircularProgressIndicator(),
        ),
      ),
    ), const Duration(seconds: 2));

    await expectLater(
      animationSheet.collate(20),
      matchesGoldenFile('material.circular_progress_indicator.indeterminate.png'),
    );
  }, skip: isBrowser); // https://github.com/flutter/flutter/issues/42767
```

É esperado que imagens de referência de testes golden relacionados
sejam invalidadas, que devem todas ser atualizadas. As novas
imagens devem ser idênticas às antigas exceto
em escala 1/3.

## Linha do tempo

Lançado na versão: v2.3.0-13.0.pre<br>
Na versão estável: 2.5

## Referências

Documentação da API:

* [`AnimationSheetBuilder`][]
* [`AnimationSheetBuilder.collate`][]

PR relevante:

* [Test WidgetTester handling test pointers][]

[`AnimationSheetBuilder`]: {{site.api}}/flutter/flutter_test/AnimationSheetBuilder-class.html
[`AnimationSheetBuilder.collate`]: {{site.api}}/flutter/flutter_test/AnimationSheetBuilder/collate.html
[golden testing]: {{site.api}}/flutter/flutter_test/matchesGoldenFile.html
[Test WidgetTester handling test pointers]: {{site.repo.flutter}}/pull/83337
