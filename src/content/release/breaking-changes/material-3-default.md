---
title: O flag ThemeData.useMaterial3 é true por padrão
description: >-
   O flag ThemeData.useMaterial3 agora está definido como true por padrão.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

A biblioteca Material foi atualizada para corresponder
à especificação mais recente do Material Design.
As mudanças incluem novos componentes, novos temas de componentes,
e visuais de componentes atualizados.
A partir desta versão, [`ThemeData.useMaterial3`][] está definido como `true` por padrão.

## Background

Os widgets Material do Flutter agora suportam totalmente o Material 3 e,
a partir do Flutter 3.16, o Material 3 agora é o estilo padrão.

A aparência dos componentes Material 3 é determinada principalmente pelos
valores de [`ThemeData.colorScheme`][] e [`ThemeData.textTheme`][].
ColorScheme facilita a criação de esquemas escuros e claros para que
seu app seja esteticamente agradável e
em conformidade com os requisitos de acessibilidade.
Para personalizar ainda mais a aparência dos componentes Material 3,
adicione temas de componentes ao seu `ThemeData`,
como [`ThemeData.segmentedButtonTheme`][] ou [`ThemeData.snackBarTheme`][].

Além disso, o Material 3 melhora o movimento usando tokens de easing e duração.
Isso significa que as curvas do Material 2 foram renomeadas para incluir
a palavra "legacy" e eventualmente serão descontinuadas e removidas.

Confira a [Material 3 gallery][] para testar
todos os novos componentes e compará-los com o Material 2.

[`ThemeData.colorScheme`]: {{site.api}}/flutter/material/ThemeData/colorScheme.html
[`ThemeData.textTheme`]: {{site.api}}/flutter/material/ThemeData/textTheme.html
[`ThemeData.segmentedButtonTheme`]: {{site.api}}/flutter/material/ThemeData/segmentedButtonTheme.html
[`ThemeData.snackBarTheme`]: {{site.api}}/flutter/material/ThemeData/snackBarTheme.html

## Migration guide

Antes da versão 3.16, as mudanças eram "opt-in"
usando a propriedade de tema `useMaterial3` em `ThemeData`.
A partir desta versão, `useMaterial3` é `true` por padrão.
Você ainda pode optar por não usar a versão Material 3 da biblioteca Material
especificando `useMaterial3: false` no tema do seu `MaterialApp`.

:::note
O suporte para Material 2 e a configuração da propriedade `useMaterial3`
eventualmente será descontinuado e removido.
:::

Além disso, alguns dos widgets não puderam simplesmente ser atualizados,
mas precisaram de uma implementação completamente nova.
Por esse motivo, sua UI pode parecer um pouco estranha quando
você a vir executando com Material 3.
Para corrigir isso, migre manualmente para os novos widgets, como [`NavigationBar`][].

Para mais detalhes, confira a [Material 3 umbrella issue][] no GitHub.

[`NavigationBar`]: {{site.api}}/flutter/material/NavigationBar-class.html

## Timeline

Adicionado na versão: 3.13.0-4.0.pre<br>
Na versão estável: 3.16

## References

Documentação:

* [Material Design for Flutter][]

Documentação da API:

* [`ThemeData.useMaterial3`][]

Issues relevantes:

* [Material 3 umbrella issue][]
* [Add support for M3 motion][]

PRs relevantes:

* [Change the default for `ThemeData.useMaterial3` to true][]
* [Updated `ThemeData.useMaterial3` API doc, default is true][]


[Material 3 gallery]: https://github.com/flutter/samples/tree/main/material_3_demo
[Material 3 umbrella issue]: {{site.repo.flutter}}/issues/91605
[Material Design for Flutter]: /ui/design/material
[`ThemeData.useMaterial3`]: {{site.api}}/flutter/material/ThemeData/useMaterial3.html
[Add support for M3 motion]: {{site.repo.flutter}}/issues/129942
[Change the default for `ThemeData.useMaterial3` to true]: {{site.repo.flutter}}/pull/129724
[Updated `ThemeData.useMaterial3` API doc, default is true]: {{site.repo.flutter}}/pull/130764
