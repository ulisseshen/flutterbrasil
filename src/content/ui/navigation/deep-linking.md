---
title: Deep linking
description: Navegar para rotas quando a aplicação recebe uma nova URL.
ia-translate: true
---

Deep links são links que não apenas abrem uma aplicação, mas também levam o
usuário a uma localização específica "profunda" dentro da aplicação. Por exemplo,
um deep link de um anúncio para um par de tênis pode abrir
uma aplicação de compras e exibir a página do produto para esses tênis em particular.

Flutter suporta deep linking no iOS, Android e web.
Abrir uma URL exibe essa tela em sua aplicação.
Com os seguintes passos,
você pode lançar e exibir rotas usando rotas nomeadas
(seja com o parâmetro [`routes`][routes] ou
[`onGenerateRoute`][onGenerateRoute]), ou usando
o widget [`Router`][Router].

:::note
Rotas nomeadas não são mais recomendadas para a maioria
das aplicações. Para mais informações, veja
[Limitações][Limitations] na página de [visão geral de navegação][navigation overview].
:::

[Limitations]: /ui/navigation#limitations
[navigation overview]: /ui/navigation

Se você está executando a aplicação em um navegador web, não há configuração adicional
necessária. Caminhos de rota são tratados da mesma forma que um deep
link do iOS ou Android. Por padrão, aplicações web leem o caminho do deep link do fragmento de url usando
o padrão: `/#/path/to/app/screen`, mas isso pode ser alterado
[configurando a estratégia de URL][configuring the URL strategy] para sua aplicação.

Se você é um aprendiz visual, confira o seguinte vídeo:

<YouTubeEmbed id="KNAb2XL7k2g" title="Deep linking in Flutter"></YouTubeEmbed>

## Get started

Para começar, veja nossos cookbooks para Android e iOS:

<div class="card-grid">
  <a class="card outlined-card" href="/cookbook/navigation/set-up-app-links">
    <div class="card-header text-center">
      <span class="card-title">Android</span>
    </div>
  </a>
  <a class="card outlined-card" href="/cookbook/navigation/set-up-universal-links">
    <div class="card-header text-center">
      <span class="card-title">iOS</span>
    </div>
  </a>
</div>

## Migrating from plugin-based deep linking

Se você escreveu um plugin para lidar com deep links, como descrito em
[Deep Links and Flutter applications][plugin-linking]
(um artigo gratuito no Medium),
você deve optar por não usar o manipulador de deep link padrão do Flutter.
Para fazer isso, defina `FlutterDeepLinkingEnabled` como false em `Info.plist` _ou_
`flutter_deeplinking_enabled` como false em `AndroidManifest.xml`.

## Behavior

O comportamento varia ligeiramente com base na plataforma e se a aplicação está
lançada e em execução.

| Platform / Scenario      | Using Navigator                                                     | Using Router                                                                                                                                                                                               |
|--------------------------|---------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| iOS (not launched)       | App gets initialRoute ("/") and a short time after gets a pushRoute | App gets initialRoute ("/") and a short time after uses the RouteInformationParser to parse the route and call RouterDelegate.setNewRoutePath, which configures the Navigator with the corresponding Page. |
| Android - (not launched) | App gets initialRoute containing the route ("/deeplink")            | App gets initialRoute ("/deeplink") and passes it to the RouteInformationParser to parse the route and call RouterDelegate.setNewRoutePath, which configures the Navigator with the corresponding Pages.   |
| iOS (launched)           | pushRoute is called                                                 | Path is parsed, and the Navigator is configured with a new set of Pages.                                                                                                                                   |
| Android (launched)       | pushRoute is called                                                 | Path is parsed, and the Navigator is configured with a new set of Pages.                                                                                                                                   |

{:.table .table-striped}

Ao usar o widget [`Router`][Router],
sua aplicação tem a capacidade de substituir o
conjunto atual de páginas quando um novo deep link
é aberto enquanto a aplicação está em execução.

## To learn more

* [Learning Flutter's new navigation and routing system][] fornece uma
introdução ao sistema Router.
* [Deep dive into Flutter deep linking][io-dl] vídeo do Google I/O 2023
* [Flutter Deep Linking: The Ultimate Guide][],
   um tutorial passo a passo mostrando como implementar deep links no Flutter.

[io-dl]: {{site.yt.watch}}?v=6RxuDcs6jVw&t=3s
[Learning Flutter's new navigation and routing system]: {{site.flutter-blog}}/learning-flutters-new-navigation-and-routing-system-7c9068155ade
[routes]: {{site.api}}/flutter/material/MaterialApp/routes.html
[onGenerateRoute]: {{site.api}}/flutter/material/MaterialApp/onGenerateRoute.html
[Router]: {{site.api}}/flutter/widgets/Router-class.html
[plugin-linking]: {{site.medium}}/flutter-community/deep-links-and-flutter-applications-how-to-handle-them-properly-8c9865af9283
[Flutter Deep Linking: The Ultimate Guide]: https://codewithandrea.com/articles/flutter-deep-links/

[configuring the URL strategy]: /ui/navigation/url-strategies
