---
ia-translate: true
title: Livros sobre Flutter
description: Extra, extra! Aqui está uma coleção de livros sobre Flutter.
toc: false
---

Aqui está uma coleção de livros sobre Flutter,
em ordem alfabética.
Se você encontrar outro que devamos adicionar,
[file an issue][] e (fique à vontade para)
enviar um PR ([sample][]) para adicioná-lo você mesmo.

Além disso, verifique a versão do Flutter para a qual o livro
foi escrito. Qualquer coisa publicada antes do
Flutter 3.10/Dart 3 (maio de 2023),
não refletirá a versão mais recente do Dart e
pode não incluir null safety;
qualquer coisa publicada antes do Flutter 3.16 (novembro de 2023)
não refletirá que o Material 3 agora é
o tema padrão do Flutter.
Veja a página [what's new][]
para visualizar o lançamento mais recente do Flutter.

[file an issue]: {{site.repo.this}}/issues/new
[sample]: {{site.repo.this}}/pull/6019
[what's new]: /release/whats-new

{% for book in books -%}
* [{{book.title}}]({{book.link}})
{% endfor -%}

<p>
  As seções a seguir têm mais informações sobre cada livro.
</p>

{% for book in books %}
<div class="book-img-with-details row">
<a href="{{book.link}}" title="{{book.title}}" class="col-sm-3">
  <img src="/assets/images/docs/cover/{{book.cover}}" alt="{{book.title}}">
</a>
<div class="details col-sm-9">

### [{{book.title}}]({{book.link}})
{:.title}

by {{book.authors | array_to_sentence_string}}
{:.authors.h4}

{{book.desc}}
</div>
</div>
{% endfor %}
