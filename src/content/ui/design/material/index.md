---
title: Material Design para Flutter
description: Aprenda sobre Material Design para Flutter.
ia-translate: true
---

Material Design é um sistema de design de código aberto construído
e mantido por designers e desenvolvedores do Google.

A versão mais recente, Material 3, permite experiências pessoais,
adaptativas e expressivas—desde cor dinâmica
e acessibilidade aprimorada, até fundações para
layouts de telas grandes e design tokens.

:::warning
A partir do lançamento do Flutter 3.16, **Material 3 está
ativado por padrão**. Por enquanto, você pode optar por sair
do Material 3 definindo a propriedade [`useMaterial3`][] como
`false`. Mas esteja ciente de que a propriedade `useMaterial3`
e o suporte para Material 2 eventualmente serão descontinuados de acordo com
a [política de descontinuação][deprecation policy] do Flutter.
:::

Para _a maioria_ dos widgets do Flutter, a atualização para Material 3
é perfeita. Mas _alguns_ widgets não puderam ser
atualizados—implementações totalmente novas foram necessárias,
como [`NavigationBar`][].
Você deve fazer essas alterações no seu código manualmente.
Até que seu aplicativo esteja totalmente atualizado,
a UI pode parecer ou se comportar de forma um pouco estranha.
Você pode encontrar os componentes Material totalmente novos visitando
a página [Affected widgets][].

[Affected widgets]: {{site.api}}/flutter/material/ThemeData/useMaterial3.html#affected-widgets
[deprecation policy]: /release/compatibility-policy#deprecation-policy
[demo]: https://flutter.github.io/samples/web/material_3_demo/#/
[`NavigationBar`]: {{site.api}}/flutter/material/NavigationBar-class.html
[`useMaterial3`]: {{site.api}}/flutter/material/ThemeData/useMaterial3.html

Explore os componentes atualizados, tipografia, sistema de cores
e suporte de elevação com a
[demonstração interativa do Material 3][demo]:

<iframe src="https://flutter.github.io/samples/web/material_3_demo/#/" width="100%" height="600px" title="Material 3 Demo App"></iframe>

## Mais informações {:.no_toc}

Para aprender mais sobre Material Design e Flutter,
confira:

* [Documentação para desenvolvedores do Material.io][Material.io developer documentation]
* Post no blog [Migrating a Flutter app to Material 3][] por Taha Tesser
* [Umbrella issue on GitHub][]

[Material.io developer documentation]: {{site.material}}/develop/flutter
[Migrating a Flutter app to Material 3]: https://blog.codemagic.io/migrating-a-flutter-app-to-material-3/
[Umbrella issue on GitHub]: {{site.github}}//flutter/flutter/issues/91605
