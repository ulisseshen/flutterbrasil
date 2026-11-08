---
ia-translate: true
title: Frontmatter
description: >-
  Aprenda sobre o frontmatter YAML com o qual cada documento
  nos sites de documentação Dart e Flutter começa.
sitemap: false
noindex: true
showBreadcrumbs: true
---

:::warning
Este documento é um trabalho em andamento.
:::

Cada documento Markdown no site começa com [YAML][] frontmatter.
Você pode editar o frontmatter para personalizar
a página gerada e seus metadados.

No mínimo, um `title` e uma `description` são necessários para cada página.

```yaml
---
title: Build a Flutter app
description: >-
  Learn how to build a basic Flutter app with interactive code samples.
---
```

[YAML]: https://yaml.org/

## Acessar dados do frontmatter em templates

Layouts, templates e arquivos fonte podem acessar valores do frontmatter
como dados de nível superior com templating.

Por exemplo, o seguinte frontmatter define uma variável `showData` com valor `value`:

```yaml
---
# ...
showDate: false
---
```

O valor configurado de `showDate` pode ser acessado em templates:

```md
Should show date: {{showDate}}
{% if showDate %}
  The current data is...
{% endif %}
```

Se você adicionar um novo valor ao frontmatter,
prefira usar `lowerCamelCase` para o nome.

## Campos do frontmatter

Além de `title` e `description`,
os sites suportam uma variedade de outros campos opcionais
para personalizar a geração de páginas.

### `title`

### `description`

### `shortTitle`

### `js`

### `toc`

### `layout`

### `showBreadcrumbs`

### `showBanner`

### `sitemap`
