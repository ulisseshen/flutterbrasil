---
ia-translate: true
title: Material Design para Flutter
description: Aprenda sobre Material Design para Flutter.
---

Material Design é um sistema de design de código aberto
construído e mantido por designers e desenvolvedores do Google.

A versão mais recente, Material 3, possibilita experiências
pessoais, adaptáveis e expressivas—desde cores dinâmicas
e acessibilidade aprimorada, até bases para layouts de
telas grandes e _design tokens_.

:::warning
A partir do lançamento do Flutter 3.16, **Material 3
está habilitado por padrão**. Por enquanto, você pode
desabilitar o Material 3 definindo a propriedade
[`useMaterial3`][] como `false`. Mas esteja ciente de que
a propriedade `useMaterial3` e o suporte para Material 2
serão eventualmente descontinuados, de acordo com a
[política de descontinuação][] do Flutter.
:::

Para _a maioria_ dos widgets Flutter, a atualização para
Material 3 é perfeita. Mas _alguns_ widgets não puderam ser
atualizados—implementações totalmente novas foram
necessárias, como [`NavigationBar`][].
Você deve fazer essas alterações em seu código manualmente.
Até que seu aplicativo seja totalmente atualizado,
a interface do usuário pode parecer ou agir de forma
um pouco estranha. Você pode encontrar os componentes
Material totalmente novos visitando a página [Widgets afetados][].

[Widgets afetados]: {{site.api}}/flutter/material/ThemeData/useMaterial3.html#affected-widgets
[política de descontinuação]: /release/compatibility-policy#deprecation-policy
[demo]: https://flutter.github.io/samples/web/material_3_demo/#/
[`NavigationBar`]: {{site.api}}/flutter/material/NavigationBar-class.html
[`useMaterial3`]: {{site.api}}/flutter/material/ThemeData/useMaterial3.html

Explore os componentes atualizados, tipografia, sistema de cores
e suporte de elevação com a
[demo interativa do Material 3][demo]:

<iframe src="https://flutter.github.io/samples/web/material_3_demo/#/" width="100%" height="600px" title="Aplicativo de Demonstração Material 3"></iframe>

## Mais informações {:.no_toc}

Para saber mais sobre Material Design e Flutter,
confira:

* [Documentação para desenvolvedores Material.io][]
* Postagem no blog [Migrando um aplicativo Flutter para Material 3][] por Taha Tesser
* [Issue guarda-chuva no GitHub][]

[Documentação para desenvolvedores Material.io]: {{site.material}}/develop/flutter
[Migrando um aplicativo Flutter para Material 3]: https://blog.codemagic.io/migrating-a-flutter-app-to-material-3/
[Issue guarda-chuva no GitHub]: {{site.github}}//flutter/flutter/issues/91605
