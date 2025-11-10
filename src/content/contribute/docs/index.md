---
ia-translate: true
title: Contribuir com a documentação
shortTitle: Docs
description: >-
  Aprenda sobre como contribuir com os sites de documentação do Dart e Flutter.
sitemap: false
noindex: true
showBreadcrumbs: true
---

:::warning
Este documento é um trabalho em andamento.
:::

## Guias de contribuição

- [Writing](/contribute/docs/writing)
- [Markdown](/contribute/docs/markdown)
- [Frontmatter](/contribute/docs/frontmatter)
- [Code blocks](/contribute/docs/code-blocks)
- [Code excerpts](/contribute/docs/excerpts)
- [Components](/contribute/docs/components)
- [Sidenav](/contribute/docs/sidenav)
- [Releases](/contribute/docs/releases)
- [Command-line tool](/contribute/docs/cli)

## Estrutura do repositório

- `.github/`

  Configuração para [actions][gh-actions] do GitHub,
  [templates][gh-templates] de issues e PRs, e [dependabot][dependabot].
- `cloud_build/`

  Configuração para Google [Cloud Build][Cloud Build] que é usado para staging
  e deploy do site.
- `diagrams/`

  Arquivos fonte para diagramas usados no site.
- `examples/`

  Os arquivos fonte para [trechos de código][code excerpts] usados em blocos de código da documentação.
- `src/`
  - `_11ty/`

    Extensões customizadas para [11ty][11ty], [Liquid][Liquid], e Markdown.
    - `plugins/`
    - `syntax/`

      Temas [Shiki][Shiki] para syntax highlighting.
    - `filters.ts`
    - `shortcodes.ts`
  - `_data/`

    Arquivos YAML e JSON usados para adicionar dados usados nos templates do site.
  - `_includes/`

    Arquivos parciais usados por declarações liquid de [render and include][render and include].
  - `_layouts/`

    Templates de layout usados pelas páginas do site.
  - `_sass/`

    Estilos para a documentação gerada, escritos com [sass][sass].
  - `content/`

    O diretório raiz para o conteúdo do site.
    - `assets/`

      O diretório para assets, incluindo imagens, usados pelo site.
    - `...`

      Os outros diretórios hospedando o conteúdo do site.
- `tool/`
  - `dash_site/`

    Os diretórios de implementação para as ferramentas `dash_site`.
- `dash_site`

  O script de entrypoint para a ferramenta CLI do site.
- `eleventy.config.ts`

  O entrypoint para a configuração de geração de site estático do [11ty][11ty].
- `firebase.json`

  Configuração para [Firebase Hosting][Firebase Hosting] que é usado para
  os sites de staging e produção.
- `package.json`

  Configuração das dependências [npm][npm] usadas.

[gh-actions]: https://docs.github.com/actions
[gh-templates]: https://docs.github.com/communities/using-templates-to-encourage-useful-issues-and-pull-requests
[dependabot]: https://docs.github.com/en/code-security/getting-started/dependabot-quickstart-guide

[Cloud Build]: https://cloud.google.com/build
[code excerpts]: /contribute/docs/excerpts

[Shiki]: https://shiki.style/
[render and include]: https://liquidjs.com/tags/render.html
[sass]: https://sass-lang.com/

[Liquid]: https://liquidjs.com/
[11ty]: https://www.11ty.dev/
[Firebase Hosting]: https://firebase.google.com/docs/hosting
[npm]: https://www.npmjs.com/
