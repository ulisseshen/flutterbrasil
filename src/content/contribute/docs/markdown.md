---
title: Criando Markdown
shortTitle: Markdown
description: >-
  Aprenda sobre as sintaxes Markdown que os sites de documentação Dart e Flutter
  suportam e suas diretrizes para usá-las.
sitemap: false
noindex: true
showBreadcrumbs: true
ia-translate: true
---

:::warning
Este documento é um trabalho em progresso.
:::

Nossos sites suportam a criação de conteúdo em [Markdown][],
com algumas adições do [GitHub Flavored Markdown][]
bem como outras sintaxes personalizadas.

Esta página descreve a sintaxe Markdown que suportamos
bem como nossas diretrizes de estilo para criar Markdown.

[Markdown]: https://commonmark.org/
[GitHub Flavored Markdown]: https://github.github.com/gfm/

## Diretrizes gerais

Prefira usar sintaxe Markdown ao invés de HTML e componentes personalizados.
Markdown puro é mais fácil de manter, mais fácil para ferramentas entenderem,
e mais fácil de migrar no futuro se necessário.

## Blocos de código

Não use blocos de código indentados do Markdown,
use apenas blocos de código cercados usando backticks
e sempre especifique uma linguagem. Por exemplo:

````markdown
```dart
void main() {
  print('Hello world!');
}
```
````

Para aprender mais sobre personalização de blocos de código,
confira a documentação dedicada sobre [Blocos de código][].

[Blocos de código]: /contribute/docs/code-blocks
