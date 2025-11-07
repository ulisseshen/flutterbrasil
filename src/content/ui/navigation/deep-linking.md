---
title: Deep linking
description: Navegue para rotas quando o app recebe uma nova URL.
ia-translate: true
---
Deep links são links que não apenas abrem um app, mas também levam o
usuário para uma localização específica "dentro" do app. Por exemplo,
um deep link de um anúncio de um par de tênis pode abrir
um app de compras e exibir a página do produto para aqueles tênis específicos.

O Flutter suporta deep linking no iOS, Android e na web.
Abrir uma URL exibe aquela tela no seu app.
Com os seguintes passos,
você pode iniciar e exibir rotas usando rotas nomeadas
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

Se você está rodando o app em um navegador web, não há configuração adicional
necessária. Caminhos de rota são tratados da mesma forma que um deep
link do iOS ou Android. Por padrão, apps web leem o caminho do deep link a partir do fragmento da url usando
o padrão: `/#/path/to/app/screen`, mas isso pode ser mudado
[configurando a estratégia de URL][configuring the URL strategy] para o seu app.

Se você aprende melhor visualmente, confira o seguinte vídeo:

{% ytEmbed 'KNAb2XL7k2g', 'Deep linking in Flutter' %}

## Começando

Para começar, veja nossos cookbooks para Android e iOS:

<div class="card-grid">
  <a class="card" href="/cookbook/navigation/set-up-app-links">
    <div class="card-body">
      <header class="card-title text-center">
        Android
      </header>
    </div>
  </a>
  <a class="card" href="/cookbook/navigation/set-up-universal-links">
    <div class="card-body">
      <header class="card-title text-center">
        iOS
      </header>
    </div>
  </a>
</div>

## Migrando de deep linking baseado em plugin

Se você escreveu um plugin para lidar com deep links, como descrito em
[Deep Links and Flutter applications][plugin-linking]
(um artigo gratuito no Medium),
você deve desabilitar o manipulador padrão de deep link do Flutter.
Para fazer isso, defina `FlutterDeepLinkingEnabled` como false no `Info.plist` _ou_
`flutter_deeplinking_enabled` como false no `AndroidManifest.xml`.

## Comportamento

O comportamento varia ligeiramente com base na plataforma e se o app está
iniciado e rodando.

| Plataforma / Cenário     | Usando Navigator                                                    | Usando Router                                                                                                                                                                                              |
|--------------------------|---------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| iOS (não iniciado)       | App recebe initialRoute ("/") e logo após recebe um pushRoute | App recebe initialRoute ("/") e logo após usa o RouteInformationParser para analisar a rota e chamar RouterDelegate.setNewRoutePath, que configura o Navigator com a Page correspondente. |
| Android - (não iniciado) | App recebe initialRoute contendo a rota ("/deeplink")            | App recebe initialRoute ("/deeplink") e passa para o RouteInformationParser para analisar a rota e chamar RouterDelegate.setNewRoutePath, que configura o Navigator com as Pages correspondentes.   |
| iOS (iniciado)           | pushRoute é chamado                                                 | O caminho é analisado, e o Navigator é configurado com um novo conjunto de Pages.                                                                                                                                   |
| Android (iniciado)       | pushRoute é chamado                                                 | O caminho é analisado, e o Navigator é configurado com um novo conjunto de Pages.                                                                                                                                   |

{:.table .table-striped}

Quando usando o widget [`Router`][Router],
seu app tem a habilidade de substituir o
conjunto atual de páginas quando um novo deep link
é aberto enquanto o app está rodando.

## Para saber mais

* [Learning Flutter's new navigation and routing system][] fornece uma
introdução ao sistema Router.
* [Deep dive into Flutter deep linking][io-dl] vídeo do Google I/O 2023
* [Flutter Deep Linking: The Ultimate Guide][],
   um tutorial passo a passo mostrando como implementar deep links no Flutter.

[io-dl]: {{site.yt.watch}}?v=6RxuDcs6jVw&t=3s
[Learning Flutter's new navigation and routing system]: {{site.flutter-medium}}/learning-flutters-new-navigation-and-routing-system-7c9068155ade
[routes]: {{site.api}}/flutter/material/MaterialApp/routes.html
[onGenerateRoute]: {{site.api}}/flutter/material/MaterialApp/onGenerateRoute.html
[Router]: {{site.api}}/flutter/widgets/Router-class.html
[plugin-linking]: {{site.medium}}/flutter-community/deep-links-and-flutter-applications-how-to-handle-them-properly-8c9865af9283
[Flutter Deep Linking: The Ultimate Guide]: https://codewithandrea.com/articles/flutter-deep-links/

[configuring the URL strategy]: /ui/navigation/url-strategies
