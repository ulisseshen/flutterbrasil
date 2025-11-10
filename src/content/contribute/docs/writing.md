---
ia-translate: true
title: Escrevendo para os sites de documentação
short-tile: Writing
description: >-
  Aprenda sobre o guia de estilo de escrita e processos seguidos ao escrever
  para os sites de documentação Dart e Flutter.
sitemap: false
noindex: true
showBreadcrumbs: true
---

:::warning
Este documento é um trabalho em andamento.
:::

## Diretrizes de escrita

Ao escrever para os sites de documentação,
siga o [guia de estilo de documentação para desenvolvedores do Google][],
exceto nos casos em que as [diretrizes de documentação Dash][] conflitam com ele.

[guia de estilo de documentação para desenvolvedores do Google]: https://developers.google.com/style
[diretrizes de documentação Dash]: #dash-docs-styles

### Estilos de documentação Dash

:::warning
Esta seção é um trabalho em andamento.
Será adicionada ao longo do tempo.
:::

## Quebras semânticas

Para tornar a revisão de PR, resolução de diff e rastreamento de histórico mais fáceis,
use [quebras semânticas][] ao escrever Markdown.
Consulte a [especificação completa][sembr-spec] para ajudas,
mas siga aproximadamente estas diretrizes:

- Mantenha cada linha com 80 caracteres ou menos.
- Quebre linhas em sentenças e, a menos que a sentença seja muito curta,
  em frases dentro de sentenças.
- Quando for necessário dividir uma sentença em linhas,
  tente escolher uma quebra que deixe claro que
  a linha continua na próxima linha.
  Dessa forma, editores e revisores futuros são mais propensos a
  notar que a edição pode afetar outra linha.

Incorporar quebras semânticas em sua escrita pode parecer tedioso no início,
mas rapidamente se mostra útil e se torna natural.
Não se preocupe em tornar as quebras perfeitas ou completamente consistentes,
qualquer esforço em direção à sua natureza semântica é extremamente útil.

Para mais discussão sobre a origem desta técnica,
confira também a postagem [Semantic Linefeeds][] de Brandon Rhode.

[quebras semânticas]: https://sembr.org/
[sembr-spec]: https://sembr.org/#:~:text=seen%20by%20readers.-,Semantic%20Line%20Breaks%20Specification,-(SemBr)
[Semantic Linefeeds]: https://rhodesmill.org/brandon/2012/one-sentence-per-line/

## Links

### Escrever texto de link

Use texto de link descritivo que siga as
diretrizes do Google sobre [Referências cruzadas e links][].

[Referências cruzadas e links]: https://developers.google.com/style/cross-references

### Configurar destinos de link

Para edição mais fácil, linhas mais curtas e redução de duplicação,
prefira usar referências de link Markdown em vez de links inline.

Coloque as definições de link no final da
seção atual onde são usadas, antes do próximo cabeçalho.

Se uma definição de link for usada várias vezes em uma página,
você pode colocá-la no final do documento.

### Abrir o link em uma nova aba

Se você quiser que um link abra em uma nova aba por padrão,
adicione os atributos `target="_blank"` e `rel="noopener"`.

Para links Markdown:

```md
[Texto do link][link-ref]{: target="_blank" rel="noopener"}
```

Para links HTML:

```html
<a href="#link-ref" target="_blank" rel="noopener">Texto do link</a>
```
