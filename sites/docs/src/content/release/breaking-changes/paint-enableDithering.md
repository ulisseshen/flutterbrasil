---
title: '`Paint.enableDithering` agora é `true` por padrão.'
description: >-
  Descontinuação do `Paint.enableDithering` configurável pelo usuário.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

[`Paint.enableDithering`][] agora é `true` por padrão (antes era `false`) e
está _descontinuado_ para remoção futura: o Flutter não oferece mais suporte a
configurações de dithering definidas pelo usuário.

Além disso, a documentação de dithering afirma que o suporte é _somente_ para
gradientes.

## Contexto {:#background}

[`Paint.enableDithering`][] foi adicionado como uma opção global em
[PR 13868][], em resposta à [Issue 44134][], que relatava que os gradientes no
Flutter apresentavam artefatos visíveis de banding:

> Atualmente os gradientes apresentam muito color banding em todos os
> dispositivos, e fica muito estranho quando se usa também a animação de
> pulsação. Uma solução é tornar os gradientes opacos e usar gradientes com
> dithering no Skia. Gradientes com dithering não são expostos atualmente, então
> seria bom adicionar um parâmetro de dither à classe Paint do dart:ui.
> Poderíamos desenhar nossos gradientes manualmente com um CustomPainter.

![Exemplo de banding](https://user-images.githubusercontent.com/30870216/210907719-4f4a1a8d-e28a-4d39-9e99-3635a26a0c74.png)

A [Issue 118073][] relatou que os gradientes no nosso novo backend
[Impeller][] exibiam artefatos visíveis de banding em alguns casos.
Depois descobriu-se que o Impeller não oferecia suporte à propriedade
[`Paint.enableDithering`][] (pouco usada).

Após adicionar suporte a dithering ao Impeller ([PR 44181][], [PR 44331][],
[PR 44522][]) e revisar o impacto de desempenho do dithering (desprezível), foram
feitas as seguintes observações:

1. Consenso de que os gradientes ficam bons por padrão: [Issue 112498][].
1. A intenção era que a opção global fosse descontinuada: [PR 13868][].

Isso resultou nas seguintes decisões:

1. Habilitar o dithering por padrão.
1. Descontinuar a opção global.
1. Remover a opção global em uma versão futura.

Como parte desse processo, a capacidade de o dithering afetar qualquer coisa
além de gradientes foi removida em [PR 44730][] e [PR 44912][]. Isso foi feito
para facilitar a migração, porque o Impeller nunca vai oferecer suporte a
dithering para algo que não seja gradiente.

## Guia de migração {:#migration-guide}

A maioria dos usuários e bibliotecas não precisará fazer nenhuma alteração.

Para usuários que mantêm testes golden, pode ser necessário atualizar suas
imagens golden para refletir o novo padrão. Por exemplo, se você usa
[`matchesGoldenFile`][] para testar um widget que contém um gradiente:

```console
$ flutter test --update-goldens
```

Embora não seja um caso comum, você pode desabilitar o dithering
temporariamente definindo a propriedade `enableDithering` no seu método
`main()` (em um app ou em um teste):

```dart diff
  void main() {
+   // TODO: Remove this after XYZ.
+   Paint.enableDithering = false;

    runApp(MyApp());
  }
```

Como o plano é remover _permanentemente_ a propriedade `enableDithering`,
envie seu feedback na [Issue 112498][] caso tenha um caso de uso que exija
desabilitar o dithering (por desempenho ou travamentos).

Se você precisar desenhar gradientes sem dithering, pode escrever um fragment
shader personalizado. Descrever como escrever shaders está fora do escopo deste
guia de migração. Para mais informações, consulte
[Escrevendo e usando fragment shaders](/ui/design/graphics/fragment-shaders).

**NOTA**: o Flutter web não oferece suporte a dithering: [Issue 134250][].

## Linha do tempo {:#timeline}

Incluído na versão: 3.14.0-0.1.pre<br>
Na versão estável: 3.16

## Referências {:#references}

Documentação da API:

- [`Paint.enableDithering`][]
- [`matchesGoldenFile`]

Issues relevantes:

- [Issue 44134][]
- [Issue 112498][]
- [Issue 118073][]

PRs relevantes:

- [PR 13868][]
- [PR 44181][]
- [PR 44331][]
- [PR 44522][]
- [PR 44730][]
- [PR 44912][]

[`Paint.enableDithering`]: {{site.api}}/flutter/dart-ui/Paint/enableDithering.html
[`matchesGoldenFile`]: {{site.api}}/flutter_test/matchesGoldenFile.html
[Impeller]: /perf/impeller
[PR 13868]: {{site.repo.engine}}/pull/13868
[PR 44181]: {{site.repo.engine}}/pull/44181
[PR 44331]: {{site.repo.engine}}/pull/44331
[PR 44522]: {{site.repo.engine}}/pull/44522
[PR 44730]: {{site.repo.engine}}/pull/44730
[PR 44912]: {{site.repo.engine}}/pull/44912
[Issue 44134]: {{site.repo.flutter}}/issues/44134
[Issue 112498]: {{site.repo.flutter}}/issues/112498
[Issue 118073]: {{site.repo.flutter}}/issues/118073
[Issue 134250]: {{site.repo.flutter}}/issues/134250
