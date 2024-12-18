---
ia-translate: true
title: Livros sobre Flutter
description: Extra, extra! Aqui está uma coleção de livros sobre Flutter.
toc: false
---

Aqui está uma coleção de livros sobre Flutter,
em ordem alfabética.
Se você encontrar outro que devemos adicionar,
[abra uma issue][] e (sinta-se à vontade para)
enviar um PR ([exemplo][]) para adicioná-lo você mesmo.

Além disso, verifique a versão do Flutter sob a qual o livro
foi escrito. Qualquer coisa publicada antes do
Flutter 3.10/Dart 3 (Maio de 2023),
não refletirá a versão mais recente do Dart e
pode não incluir null safety;
qualquer coisa publicada antes do Flutter 3.16 (Novembro de 2023)
não refletirá que o Material 3 agora é o
tema padrão do Flutter.
Veja a página [novidades][]
para visualizar o último lançamento do Flutter.

[abra uma issue]: {{site.repo.this}}/issues/new
[exemplo]: {{site.repo.this}}/pull/6019
[novidades]: /release/whats-new

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

por {{book.authors | array_to_sentence_string}}
{:.authors.h4}

{{book.desc}}
</div>
</div>
{% endfor %}
