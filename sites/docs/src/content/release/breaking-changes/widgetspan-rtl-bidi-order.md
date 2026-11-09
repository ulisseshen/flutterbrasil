---
ia-translate: true
title: Ordem de WidgetSpan em texto da direita para a esquerda
description: >-
  Os WidgetSpans agora seguem a ordem visual bidirecional em textos da direita para a esquerda.
  Remova os workarounds que compensavam o layout anterior.
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Os widgets `WidgetSpan` em texto da direita para a esquerda (RTL) e em texto
de direção mista agora seguem a ordem visual determinada pelo algoritmo
bidirecional Unicode. Apps que compensavam a ordem incorreta anterior
podem exibir widgets inline em posições erradas após a atualização.

## Contexto {:#background}

O layout de parágrafos do Skia colocava os placeholders de widgets inline
na ordem do código-fonte, mesmo quando o texto ao redor era reordenado visualmente.
Isso fazia com que widgets inline em árabe, hebraico e texto de direção mista
aparecessem em posições erradas.

O layout de parágrafos agora coloca os placeholders de widgets inline na ordem
visual bidirecional. Os filhos do seu `WidgetSpan` continuam na ordem lógica
de leitura no código Dart, e o layout retorna as caixas de placeholder com as
coordenadas visuais corrigidas. Nenhuma assinatura pública da API foi alterada.

O exemplo a seguir mostra as posições corrigidas dos widgets inline
em texto de direção mista:

| Antes | Depois |
| :---: | :---: |
| ![Ordem incorreta dos widgets][before] | ![Ordem correta dos widgets][after] |

## Guia de migração {:#migration-guide}

Se o seu app usa widgets `WidgetSpan` sem compensar o layout antigo,
nenhuma mudança de código é necessária.
Caso contrário, remova os workarounds adicionados especificamente para esse problema:

* Traduzir ou trocar widgets na mesma linha usando deslocamentos de
  `Transform.translate` ou medições com `GlobalKey`.
* Inverter a ordem de código dos widgets `WidgetSpan` para texto RTL.
  Mantenha os spans na ordem lógica do conteúdo e deixe o layout de texto
  determinar as posições visuais.
* Espelhar as coordenadas x das caixas de placeholder em código de layout customizado.
  Use as coordenadas retornadas diretamente.

Por exemplo, remova uma translação que compensava a ordem RTL antiga.
Aqui, `rtlSwapOffset` é um deslocamento calculado pelo workaround do app,
e `inlineWidget` é o widget incorporado ao texto.

Código antes da migração:

```dart
WidgetSpan(
  child: Transform.translate(
    offset: rtlSwapOffset,
    child: inlineWidget,
  ),
)
```

Código após a migração:

```dart
WidgetSpan(child: inlineWidget)
```

Também remova o código que calculava os deslocamentos compensatórios.
Verifique texto RTL e de direção mista, incluindo linhas quebradas,
e atualize os golden tests que capturaram o layout incorreto.

## Linha do tempo {:#timeline}

Incluído na versão: 3.50.0-0.1.pre<br>
Na versão estável: 3.50

## Referências {:#references}

Issue no GitHub:

* [Issue 54400][Issue 54400]

PRs relevantes:

* [Skia CL 1366676][Skia CL 1366676]

[after]: /assets/images/docs/breaking-changes/widgetspan-rtl-after.webp
[before]: /assets/images/docs/breaking-changes/widgetspan-rtl-before.webp
[Issue 54400]: {{site.repo.flutter}}/issues/54400
[Skia CL 1366676]: https://skia-review.googlesource.com/c/skia/+/1366676
