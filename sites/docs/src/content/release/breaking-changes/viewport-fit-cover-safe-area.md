---
ia-translate: true
title: Suporte a SafeArea com viewport-fit=cover na web
description: >-
  O Flutter web agora respeita viewport-fit=cover no index.html e preenche
  FlutterView.viewPadding com os valores CSS env(safe-area-inset-*).
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

O Flutter web agora respeita `viewport-fit=cover` na tag
`<meta name="viewport">` do seu `web/index.html` e preenche [`FlutterView.viewPadding`][],
[`MediaQuery.paddingOf`][] e [`SafeArea`][] com os valores CSS
`env(safe-area-inset-*)` do navegador.

Se um aplicativo web existente já inclui `viewport-fit=cover` em
`web/index.html`, ele agora é renderizado de ponta a ponta atrás de recortes,
entalhes e indicadores de tela inicial de dispositivos móveis, em vez de
ter o `viewport-fit=cover` removido pelo
engine web.

## Contexto {:#context}

Anteriormente, ao inicializar no modo de página inteira, o engine web do Flutter
substituía qualquer tag `<meta name="viewport">` em `web/index.html` por uma
tag de viewport padrão que omitia `viewport-fit=cover`, e sempre informava
[`FlutterView.viewPadding`][] como `ViewPadding.zero`.

Para permitir que aplicativos web móveis sejam renderizados de ponta a ponta em dispositivos
com recortes de tela e entalhes, o Flutter web agora inspeciona a tag `<meta name="viewport">`
em `web/index.html` antes de substituí-la:

* Quando `viewport-fit=cover` **não** está definido (o padrão), o Flutter web renderiza
  dentro da área segura do navegador (`viewport-fit=contain`) e informa
  `ViewPadding.zero`.
* Quando `viewport-fit=cover` **está** definido em `web/index.html`, o Flutter web
  preserva `viewport-fit=cover` na tag `<meta name="viewport" flt-viewport>`
  ativa. Em seguida, mede os valores CSS `env(safe-area-inset-*)`
  do navegador e os expõe por meio de [`FlutterView.viewPadding`][],
  [`MediaQuery.paddingOf`][] e [`SafeArea`][].

## Guia de migração {:#migration-guide}

Você é **afetado** apenas se o seu arquivo `web/index.html` já
especifica `viewport-fit=cover` na sua tag `<meta name="viewport">`.

### Opção 1: mantenha a renderização de ponta a ponta e envolva a interface em `SafeArea` {:#option-1-keep-edge-to-edge-rendering-and-wrap-ui-in-safearea}

Se você quer que o seu app web seja renderizado de ponta a ponta atrás de entalhes e
indicadores de tela inicial, envolva o conteúdo interativo em um widget [`SafeArea`][] (ou leia
[`MediaQuery.paddingOf`][]) para que os controles não fiquem ocultos por recortes do sistema:

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: MyAppContent(),
    ),
  );
}
```

### Opção 2: volte para `viewport-fit=contain` (padrão) {:#option-2-revert-to-viewport-fit-contain-default}

Se você não quer renderização de ponta a ponta em navegadores móveis, remova
`viewport-fit=cover` de `<meta name="viewport">` em `web/index.html`:

Código antes da migração:

```html title="web/index.html"
<meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
```

Código após a migração:

```html title="web/index.html"
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

## Linha do tempo {:#timeline}

Na versão estável: 3.50

## Referências {:#references}

Documentação da API:

* [`FlutterView.viewPadding`][]
* [`MediaQuery.paddingOf`][]
* [`SafeArea`][]

Issues relevantes:

* [Issue 84833][]

PRs relevantes:

* [PR 191647][]

[`FlutterView.viewPadding`]: {{site.api}}/flutter/dart-ui/FlutterView/viewPadding.html
[`MediaQuery.paddingOf`]: {{site.api}}/flutter/widgets/MediaQuery/paddingOf.html
[`SafeArea`]: {{site.api}}/flutter/widgets/SafeArea-class.html
[Issue 84833]: {{site.repo.flutter}}/issues/84833
[PR 191647]: {{site.repo.flutter}}/pull/191647
