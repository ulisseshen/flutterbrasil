---
title: Material Design para Flutter
description: Aprenda sobre Material Design para Flutter.
ia-translate: true
---

Material Design é um sistema de design de código aberto construído
e suportado por designers e desenvolvedores do Google.

A versão mais recente, Material 3, permite experiências pessoais,
adaptativas e expressivas—desde cores dinâmicas e acessibilidade
aprimorada, até fundações para layouts de telas grandes e tokens de design.

:::warning
A partir da versão Flutter 3.16, **Material 3 está
ativado por padrão**. Por enquanto, você pode optar por não usar o
Material 3 definindo a propriedade [`useMaterial3`][]
como `false`. Mas esteja ciente de que a propriedade `useMaterial3`
e o suporte para Material 2 eventualmente serão descontinuados de acordo com
a [política de descontinuação][] do Flutter.
:::

Para a _maioria_ dos widgets Flutter, a atualização para Material 3
é transparente. Mas _alguns_ widgets não puderam ser
atualizados—implementações totalmente novas foram necessárias,
como [`NavigationBar`][].
Você deve fazer essas alterações no seu código manualmente.
Até que seu aplicativo esteja totalmente atualizado,
a interface do usuário pode parecer ou agir um pouco estranha.
Você pode encontrar os componentes Material totalmente novos visitando
a página [Widgets afetados][].

[Widgets afetados]: {{site.api}}/flutter/material/ThemeData/useMaterial3.html#affected-widgets
[política de descontinuação]: /release/compatibility-policy#deprecation-policy
[demo]: {{site.github}}/flutter/samples/blob/main/material_3_demo/
[`NavigationBar`]: {{site.api}}/flutter/material/NavigationBar-class.html
[`useMaterial3`]: {{site.api}}/flutter/material/ThemeData/useMaterial3.html

Explore os componentes atualizados, tipografia, sistema de cores
e suporte de elevação com a
[demonstração do Material 3][demo].

## Mais informações {:.no_toc}

Para saber mais sobre Material Design e Flutter,
confira:

* [Documentação para desenvolvedores Material.io][]
* Post do blog [Migrating a Flutter app to Material 3][] por Taha Tesser
* [Umbrella issue no GitHub][]

[Documentação para desenvolvedores Material.io]: {{site.material}}/develop/flutter
[Migrating a Flutter app to Material 3]: https://blog.codemagic.io/migrating-a-flutter-app-to-material-3/
[Umbrella issue no GitHub]: {{site.github}}/flutter/flutter/issues/91605
