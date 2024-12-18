---
ia-translate: true
title: Paint.enableDithering agora é true por padrão.
description: >-
  Depreciação de `Paint.enableDithering` configurável pelo usuário.
---

## Sumário

[`Paint.enableDithering`][] agora é `true` por padrão (anteriormente, `false`),
e está _depreciado_ pendente de remoção - o Flutter não oferece mais suporte a
configurações de dithering configuráveis pelo usuário.

Além disso, a documentação de dithering afirma que o suporte é _apenas_ para
gradientes.

## Contexto

[`Paint.enableDithering`][] foi adicionado como uma opção global no [PR 13868][]
como uma resposta ao [Issue 44134][], que relatou que os gradientes no Flutter
tinham artefatos visíveis de banding:

> Atualmente, os gradientes apresentam muito banding de cores em todos os
> dispositivos, e parece muito estranho quando se usa a animação de pulso também.
> Uma solução é tornar os gradientes opacos e usar gradientes com dithering com
> Skia. Os gradientes com dithering não são expostos atualmente, portanto,
> adicionar um parâmetro de dithering à classe Paint do dart:ui seria bom.
> Poderíamos desenhar manualmente nossos gradientes com um CustomPainter.

![Exemplo de banding](https://user-images.githubusercontent.com/30870216/210907719-4f4a1a8d-e28a-4d39-9e99-3635a26a0c74.png)

O [Issue 118073][] relatou que os gradientes em nosso novo backend [Impeller][]
exibiam artefatos visíveis de banding em alguns gradientes. Mais tarde,
descobriu-se que o Impeller não suportava a propriedade (raramente usada)
[`Paint.enableDithering`][].

Após adicionar suporte a dithering ao Impeller ([PR 44181][], [PR 44331][],
[PR 44522][]) e revisar o impacto de desempenho do dithering (insignificante),
as seguintes observações foram feitas:

1. Consenso de que os gradientes parecem bons por padrão: [Issue 112498][].
2. Ter uma opção global tinha a intenção de ser descontinuada: [PR 13868][].

Isso resultou nas seguintes decisões:

1. Tornar o dithering habilitado por padrão.
2. Descontinuar a opção global.
3. Remover a opção global em uma versão futura.

Como parte desse processo, a capacidade de o dithering afetar qualquer coisa
que não fosse gradientes foi removida no [PR 44730][] e [PR 44912][]. Isso foi
feito para facilitar o processo de migração, porque o Impeller nunca
suportará dithering para nada além de gradientes.

## Guia de migração

A maioria dos usuários e bibliotecas não precisará fazer nenhuma alteração.

Para usuários que mantêm testes golden, pode ser necessário atualizar suas
imagens golden para refletir o novo padrão. Por exemplo, se você usar
[`matchesGoldenFile`][] para testar um widget que contenha um gradiente:

```console
$ flutter test --update-goldens
```

Embora não seja esperado que seja um caso comum, você pode desabilitar
temporariamente o dithering definindo a propriedade `enableDithering` em seu
método `main()` (em um aplicativo ou teste):

```dart diff
  void main() {
+   // TODO: Remover isso depois de XYZ.
+   Paint.enableDithering = false;

    runApp(MyApp());
  }
```

Como o plano é remover _permanentemente_ a propriedade `enableDithering`,
forneça feedback no [Issue 112498][] se você tiver um caso de uso que exija
desabilitar o dithering (devido a desempenho, falhas).

Se por algum motivo você _precisar_ desenhar gradientes sem dithering, você
precisará escrever seu próprio shader personalizado. Descrever isso está fora
do escopo deste guia de migração, mas você pode encontrar alguns recursos e
exemplos:

- [Escrevendo e usando fragment shaders][]
- [`hsl_linear_gradient.frag`][]

**NOTA**: O Flutter web não suporta dithering: [Issue 134250][].

## Cronograma

Incluído na versão: 3.14.0-0.1.pre<br>
Na versão estável: 3.16

## Referências

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
[Escrevendo e usando fragment shaders]: /ui/design/graphics/fragment-shaders
[`hsl_linear_gradient.frag`]: https://github.com/jonahwilliams/awesome_gradients/blob/a4e09c47ef1760bd7073beb60f49dad8ede5bb2e/shaders/hsl_linear_gradient.frag
