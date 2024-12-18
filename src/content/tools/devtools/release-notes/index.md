---
ia-translate: true
title: Notas de lançamento do DevTools
description: Saiba mais sobre as últimas alterações no Dart e no Flutter DevTools.
toc: false
---

Esta página resume as alterações nas versões estáveis oficiais do DevTools.
Para ver uma lista completa de alterações, consulte o
[log do git do DevTools]({{site.repo.organization}}/devtools/commits/master).

Os SDKs do Dart e Flutter incluem o DevTools.
Para verificar sua versão atual do DevTools,
execute o seguinte em sua linha de comando:

```console
$ dart devtools --version
```

### Notas de lançamento

{% comment %}
Ao adicionar as notas de lançamento para uma nova versão do DevTools,
certifique-se de adicionar o número da versão como uma entrada na lista
encontrada em `/src/_data/devtools_releases.yml`.
{% endcomment -%}

{% assign releases = devtools_releases.releases %}

{% for release in releases -%}
* [Notas de lançamento da versão {{release}}](/tools/devtools/release-notes/release-notes-{{release}})
{% endfor -%}
