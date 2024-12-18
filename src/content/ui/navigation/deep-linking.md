---
ia-translate: true
title: Deep linking
description: Navegue para rotas quando o aplicativo recebe uma nova URL.
---
Deep links são links que não apenas abrem um aplicativo, mas também levam o
usuário para um local específico "profundamente" dentro do aplicativo. Por exemplo,
um deep link de um anúncio de um par de tênis pode abrir
um aplicativo de compras e exibir a página do produto para aqueles sapatos em
particular.

O Flutter suporta deep linking no iOS, Android e na web.
Abrir uma URL exibe essa tela em seu aplicativo.
Com os seguintes passos,
você pode iniciar e exibir rotas usando rotas nomeadas
(seja com o parâmetro [`routes`][routes] ou
[`onGenerateRoute`][onGenerateRoute]), ou usando o widget [`Router`][Router].

:::note
Rotas nomeadas não são mais recomendadas para a maioria
das aplicações. Para mais informações, veja
[Limitações][] na página de [visão geral da navegação][].
:::

[Limitações]: /ui/navigation#limitations
[visão geral da navegação]: /ui/navigation

Se você estiver executando o aplicativo em um navegador da web, não há configuração
adicional necessária. Os caminhos de rota são tratados da mesma forma que um deep
link iOS ou Android. Por padrão, aplicativos web leem o caminho de deep link do
fragmento de URL usando o padrão: `/#/path/to/app/screen`, mas isso pode ser
alterado [configurando a estratégia de URL][] para seu aplicativo.

Se você é um aprendiz visual, confira o seguinte vídeo:

{% ytEmbed 'KNAb2XL7k2g', 'Deep linking no Flutter' %}

## Começar

Para começar, veja nossos livros de receitas para Android e iOS:

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

Se você escreveu um plugin para lidar com deep links, conforme descrito em
[Deep Links and Flutter applications][plugin-linking]
(um artigo gratuito no Medium),
você deve desativar o manipulador de deep link padrão do Flutter.
Para fazer isso, defina `FlutterDeepLinkingEnabled` como false em `Info.plist` _ou_
`flutter_deeplinking_enabled` como false em `AndroidManifest.xml`.

## Comportamento

O comportamento varia ligeiramente com base na plataforma e se o aplicativo é
iniciado e está em execução.

| Plataforma / Cenário      | Usando Navigator                                                  | Usando Router                                                                                                                                                                                          |
|--------------------------|-------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| iOS (não iniciado)       | O aplicativo recebe initialRoute ("/") e um pouco depois recebe um pushRoute | O aplicativo recebe initialRoute ("/") e um pouco depois usa o RouteInformationParser para analisar a rota e chamar RouterDelegate.setNewRoutePath, que configura o Navigator com a Page correspondente. |
| Android - (não iniciado) | O aplicativo recebe initialRoute contendo a rota ("/deeplink")     | O aplicativo recebe initialRoute ("/deeplink") e a passa para o RouteInformationParser analisar a rota e chamar RouterDelegate.setNewRoutePath, que configura o Navigator com as Pages correspondentes. |
| iOS (iniciado)            | pushRoute é chamado                                                | O caminho é analisado e o Navigator é configurado com um novo conjunto de Pages.                                                                                                                   |
| Android (iniciado)        | pushRoute é chamado                                                | O caminho é analisado e o Navigator é configurado com um novo conjunto de Pages.                                                                                                                   |

{:.table .table-striped}

Ao usar o widget [`Router`][Router],
seu aplicativo tem a capacidade de substituir o
conjunto atual de páginas quando um novo deep link
é aberto enquanto o aplicativo está em execução.

## Para aprender mais

* [Learning Flutter's new navigation and routing system][] fornece uma
introdução ao sistema Router.
* Vídeo [Deep dive into Flutter deep linking][io-dl] do Google I/O 2023
* [Flutter Deep Linking: The Ultimate Guide][],
   um tutorial passo a passo mostrando como implementar deep links no Flutter.

[io-dl]: {{site.yt.watch}}?v=6RxuDcs6jVw&t=3s
[Learning Flutter's new navigation and routing system]: {{site.flutter-medium}}/learning-flutters-new-navigation-and-routing-system-7c9068155ade
[routes]: {{site.api}}/flutter/material/MaterialApp/routes.html
[onGenerateRoute]: {{site.api}}/flutter/material/MaterialApp/onGenerateRoute.html
[Router]: {{site.api}}/flutter/widgets/Router-class.html
[plugin-linking]: {{site.medium}}/flutter-community/deep-links-and-flutter-applications-how-to-handle-them-properly-8c9865af9283
[Flutter Deep Linking: The Ultimate Guide]: https://codewithandrea.com/articles/flutter-deep-links/

[configurando a estratégia de URL]: /ui/navigation/url-strategies
