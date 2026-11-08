---
ia-translate: true
title: Restrições de orientação e redimensionamento em telas grandes ignoradas no Android 17
description: >-
  Para apps que têm como alvo o Android 17 ou superior,
  as restrições de orientação, redimensionamento e proporção deixam de
  ser aplicadas em telas grandes com largura de 600dp ou mais.
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Para apps que têm como alvo o Android 17 ou superior,
as restrições de orientação, redimensionamento e proporção deixam de
ser aplicadas em telas com largura igual ou maior que 600dp.
Isso significa que [`SystemChrome.setPreferredOrientations`][`SystemChrome.setPreferredOrientations`] é
ignorado nesses dispositivos.

## Contexto {:#background}

O Android está caminhando para um modelo em que os apps devem se adaptar
a diversas orientações, tamanhos de tela e proporções.
Restrições como orientação fixa ou redimensionamento limitado
dificultam essa adaptabilidade.
Para mais detalhes, consulte [Comportamentos de mudança do Android 17][Android 17 behavior changes].

No Android 16, esse comportamento foi introduzido como padrão,
mas permitia que os apps optassem temporariamente por não usá-lo
com a propriedade de manifesto `PROPERTY_COMPAT_ALLOW_RESTRICTED_RESIZABILITY`.
O Android 17 remove essa opção de exclusão.

## Descrição da mudança {:#description-of-change}

Se você depende de [`SystemChrome.setPreferredOrientations`][`SystemChrome.setPreferredOrientations`]
para travar o seu app em uma orientação específica,
essa configuração é ignorada em telas grandes (largura de 600dp ou mais)
caso o seu app tenha como alvo o Android 17 ou superior.
Se o seu app oferece suporte ao Android 16
e você não optou por sair desse comportamento,
ele se comporta da mesma forma no Android 17.

Se o seu app depende de travar a orientação,
torne-o adaptável para suportar diferentes tamanhos de tela e orientações.
Veja as orientações sobre como fazer isso para telas grandes
em [UI adaptável e responsiva][Adaptive and responsive UI].

## Referências {:#references}

* [Comportamentos de mudança do Android 17][Android 17 behavior changes]
* [Comportamentos de mudança do Android 16][Android 16 behavior changes]
* [`SystemChrome.setPreferredOrientations`][`SystemChrome.setPreferredOrientations`]
* [UI adaptável e responsiva][Adaptive and responsive UI]

[Android 17 behavior changes]: https://developer.android.com/about/versions/17/changes/ff-restrictions-ignored
[Android 16 behavior changes]: https://developer.android.com/about/versions/16/behavior-changes-16#ignore-orientation
[`SystemChrome.setPreferredOrientations`]: {{site.api}}/flutter/services/SystemChrome/setPreferredOrientations.html
[Adaptive and responsive UI]: /ui/adaptive-responsive/large-screens
