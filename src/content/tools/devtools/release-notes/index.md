---
ia-translate: true
title: Notas de lançamento do DevTools
description: Conheça as últimas alterações no Dart e Flutter DevTools.
toc: false
---

Esta página resume as alterações em lançamentos estáveis oficiais do DevTools.
Para ver uma lista completa de alterações, confira o
[log do git do DevTools]({{site.repo.organization}}/devtools/commits/master).

Os SDKs Dart e Flutter incluem DevTools.
Para verificar sua versão atual do DevTools,
execute o seguinte na sua linha de comando:

```console
$ dart devtools --version
```

### Notas de lançamento

{% comment %}
When adding the release notes for a new DevTools release,
make sure to add the version number as an entry to the list
found at `/src/_data/devtools_releases.yml`.
{% endcomment -%}

{% assign releases = devtools_releases.releases %}

{% for release in releases -%}
* [Notas de lançamento {{release}}](/tools/devtools/release-notes/release-notes-{{release}})
{% endfor -%}
