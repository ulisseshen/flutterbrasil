---
ia-translate: true
title: A flag ThemeData.useMaterial3 é verdadeira por padrão
description: >-
  A flag ThemeData.useMaterial3 agora é definida como verdadeira por padrão.
---

## Resumo

A biblioteca Material foi atualizada para corresponder à mais recente especificação
do Material Design. As mudanças incluem novos componentes, novos temas de
componentes e visuais de componentes atualizados. A partir desta versão,
[`ThemeData.useMaterial3`][] é definida como `true` por padrão.

## Contexto

Os widgets Material do Flutter agora suportam totalmente o Material 3 e, a
partir do Flutter 3.16, o Material 3 agora é o estilo padrão.

A aparência dos componentes do Material 3 é determinada principalmente
pelos valores para [`ThemeData.colorScheme`][] e [`ThemeData.textTheme`][].
ColorScheme facilita a criação de esquemas claros e escuros para que seu aplicativo
seja esteticamente agradável e esteja em conformidade com os requisitos de
acessibilidade. Para personalizar ainda mais a aparência dos componentes do
Material 3, adicione temas de componentes ao seu `ThemeData`, como
[`ThemeData.segmentedButtonTheme`][] ou [`ThemeData.snackBarTheme`][].

Além disso, o Material 3 melhora o movimento usando tokens de easing e duração.
Isso significa que as curvas do Material 2 foram renomeadas para incluir a
palavra "legacy" e, eventualmente, serão descontinuadas e removidas.

Confira a [galeria do Material 3][] para testar todos os novos componentes
e compará-los com o Material 2.

[`ThemeData.colorScheme`]: {{site.api}}/flutter/material/ThemeData/colorScheme.html
[`ThemeData.textTheme`]: {{site.api}}/flutter/material/ThemeData/textTheme.html
[`ThemeData.segmentedButtonTheme`]: {{site.api}}/flutter/material/ThemeData/segmentedButtonTheme.html
[`ThemeData.snackBarTheme`]: {{site.api}}/flutter/material/ThemeData/snackBarTheme.html

## Guia de migração

Antes da versão 3.16, as mudanças eram "opt-in" usando a propriedade
de tema `useMaterial3` em `ThemeData`. A partir desta versão,
`useMaterial3` é `true` por padrão. Você ainda pode desativar a versão Material
3 da biblioteca Material especificando `useMaterial3: false` no seu tema
`MaterialApp`.

:::note
O suporte para Material 2 e a configuração da propriedade `useMaterial3`
serão eventualmente descontinuados e removidos.
:::

Além disso, alguns dos widgets não puderam ser simplesmente atualizados, mas
precisaram de uma implementação totalmente nova. Por esse motivo, sua interface
do usuário pode parecer um pouco estranha quando você a vê em execução com o
Material 3. Para corrigir isso, migre manualmente para os novos widgets, como
[`NavigationBar`][].

Para mais detalhes, confira a [questão guarda-chuva do Material 3][] no GitHub.

[`NavigationBar`]: {{site.api}}/flutter/material/NavigationBar-class.html

## Cronograma

Disponibilizado na versão: 3.13.0-4.0.pre<br>
Na versão estável: 3.16

## Referências

Documentação:

* [Material Design para Flutter][]

Documentação da API:

* [`ThemeData.useMaterial3`][]

Questões relevantes:

* [Questão guarda-chuva do Material 3][]
* [Adicionar suporte para movimento M3][]

PRs relevantes:

* [Alterar o padrão para `ThemeData.useMaterial3` para true][]
* [Documento da API `ThemeData.useMaterial3` atualizado, o padrão é true][]

[Material 3 gallery]: https://flutter.github.io/samples/web/material_3_demo/
[Questão guarda-chuva do Material 3]: {{site.repo.flutter}}/issues/91605
[Material Design para Flutter]: /ui/design/material
[`ThemeData.useMaterial3`]: {{site.api}}/flutter/material/ThemeData/useMaterial3.html
[Adicionar suporte para movimento M3]: {{site.repo.flutter}}/issues/129942
[Alterar o padrão para `ThemeData.useMaterial3` para true]: {{site.repo.flutter}}/pull/129724
[Documento da API `ThemeData.useMaterial3` atualizado, o padrão é true]: {{site.repo.flutter}}/pull/130764
