---
title: Sidenav
description: >-
  Aprenda sobre como adicionar e configurar o sidenav do
  site de documentação Dart e Flutter.
ia-translate: true
sitemap: false
noindex: true
showBreadcrumbs: true
---

:::warning
Este documento é um trabalho em andamento.
:::

O sidenav apresenta a arquitetura geral de informações do site
e fornece aos desenvolvedores acesso à documentação por tópico.

Os conteúdos do sidenav são configurados em
arquivos [YAML][] no diretório `/src/data/sidenav/`.
Cada arquivo nesse diretório define um sidenav nomeado,
com o nome do arquivo (sem extensão) servindo como chave.
As páginas selecionam qual sidenav exibir através do campo `sidenav` do front matter.
Se nenhum sidenav for especificado, o sidenav `default` é usado.

[YAML]: https://yaml.org/

## Add a page

## Remove a page

## Hide pages unless open

## Icons for top-level sections

Entradas de seção de nível superior suportam um campo opcional `icon` para renderizar um ícone do Material Symbols à esquerda do título da seção. Use o identificador do ícone (por exemplo, `flag`, `download` ou `build`). Esse ícone aparece apenas para os itens de primeiro nível.

Os ícones usam a fonte Material Symbols do site. Escolha identificadores no [catálogo do Material Symbols](https://fonts.google.com/icons) do Google.

## Infrastructure
