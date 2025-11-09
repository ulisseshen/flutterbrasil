---
ia-translate: true
title: Perguntas frequentes sobre Web
description: Algumas pegadinhas e diferenças ao escrever ou executar apps web no Flutter.
---

## Perguntas

### Quais cenários são ideais para Flutter na web?

Nem toda página web faz sentido em Flutter, mas achamos que o Flutter é particularmente
adequado para experiências centradas em aplicativos:

* Progressive Web Apps
* Single Page Apps
* Apps Flutter mobile existentes

Neste momento, o Flutter não é adequado para sites estáticos com conteúdo
rico em texto baseado em fluxo. Por exemplo, artigos de blog se beneficiam do modelo
centrado em documentos no qual a web é construída, em vez dos serviços centrados
em aplicativos que um framework de UI como o Flutter pode oferecer. No entanto,
você _pode_ usar Flutter para incorporar experiências interativas nesses sites.

Para mais informações sobre como você pode usar Flutter na web,
consulte [Suporte web para Flutter][Web support for Flutter].

### Otimização para mecanismos de busca (SEO)

Em geral, o Flutter é voltado para experiências de aplicativos dinâmicos. O suporte
web do Flutter não é exceção. O Flutter web prioriza desempenho, fidelidade e
consistência. Isso significa que a saída do aplicativo não se alinha com o que os
mecanismos de busca precisam para indexar adequadamente. Para conteúdo web que é
estático ou semelhante a um documento, recomendamos usar HTML—assim como fazemos
em [flutter.dev]({{site.main-url}}), [dart.dev]({{site.dart-site}}) e
[pub.dev]({{site.pub}}). Você também deve considerar separar sua experiência
principal de aplicativo—criada em Flutter—de sua landing page, conteúdo de
marketing e conteúdo de ajuda—criados usando HTML otimizado para mecanismos de busca.

Dito isso, como mencionado no [roadmap][roadmap], a equipe Flutter planeja investigar a
indexabilidade de mecanismos de busca do Flutter web.

### O hot reload funciona com um app web?

Sim! Embora atualmente esteja atrás de uma flag experimental.
Para mais informações, confira
[hot reload na web][hot reload on the web].

[hot reload on the web]: /platform-integration/web/building#hot-reload-web

O hot restart não requer uma flag e é uma maneira rápida de ver suas
alterações sem ter que relançar seu app web e esperar que ele
compile e carregue. Isso funciona de forma semelhante ao
recurso de hot reload para desenvolvimento mobile Flutter.
A diferença é que o hot reload lembra seu estado e o hot
restart não.

### Quais navegadores web são suportados pelo Flutter?

Apps web Flutter podem ser executados nos seguintes navegadores:

* Chrome (mobile & desktop)
* Safari (mobile & desktop)
* Edge (mobile & desktop)
* Firefox (mobile & desktop)

Durante o desenvolvimento, Chrome (no macOS, Windows e Linux) e Edge (no Windows)
são suportados como navegadores padrão para depurar seu app.

### Posso compilar, executar e fazer deploy de apps web em qualquer uma das IDEs?

Você pode selecionar **Chrome** ou **Edge** como dispositivo de destino no
Android Studio/IntelliJ e VS Code.

O menu suspenso de dispositivos agora deve incluir a opção **Chrome (web)**
para todos os canais.

### Como faço para compilar um app responsivo para a web?

Consulte [Criando apps responsivos][Creating responsive apps].

### Posso usar `dart:io` com um app web?

Não. O sistema de arquivos não é acessível pelo navegador.
Para funcionalidade de rede, use o pacote [`http`][`http`].
Observe que a segurança funciona de forma um pouco
diferente porque o navegador (e não o app)
controla os headers em uma requisição HTTP.

### Como lido com imports específicos da web?

Alguns plugins requerem imports específicos de plataforma, particularmente se
eles usam o sistema de arquivos, que não é acessível pelo navegador. Para usar
esses plugins em seu app, consulte a
[documentação para imports condicionais][documentation for conditional imports]
em [dart.dev]({{site.dart-site}}).

### O Flutter web suporta concorrência?

O suporte de concorrência do Dart via [isolates][isolates]
não é atualmente suportado no Flutter web.

Apps web Flutter podem potencialmente contornar isso
usando [web workers][web workers],
embora nenhum suporte desse tipo esteja integrado.

### Como faço para fazer deploy de um app web?

Consulte [Preparando um app web para lançamento][Preparing a web app for release].

### `Platform.is` funciona na web?

Atualmente não.

### Por que meu app não atualiza imediatamente após ser implantado?

Pode ser necessário configurar o header `Cache-Control` retornado pelo seu servidor web.
Por exemplo, se este header estiver definido como 3600, então o navegador
e o CDN farão cache do recurso por 1 hora, e seus usuários podem ver uma versão
desatualizada do seu app até 1 hora após você fazer deploy de uma nova versão. Para
mais informações sobre cache na web,
confira [Previna requisições de rede desnecessárias com o HTTP Cache][http-cache].

É uma boa ideia estar ciente desse comportamento para evitar uma experiência
de usuário indesejável. Depois de fazer deploy do seu app, os usuários podem usar uma
versão em cache do seu app (em cache pelo navegador ou CDN)
pela duração definida pelos seus headers de cache.
Isso pode levar os usuários a usar uma versão do seu app que
é incompatível com mudanças que foram implantadas em serviços de backend.

### Como limpo o cache da web após um deploy e forço o download de um app?
Se você deseja contornar esses headers de cache após cada deploy, uma técnica
comum é anexar um ID de build de algum tipo aos links de seus recursos
estáticos, ou atualizar os nomes dos arquivos em si.
Por exemplo, `logo.png` pode se tornar `logo.v123.png`.

```html
<!-- Opção 1, anexe o ID de build como um parâmetro de query em seus links -->
<script src="flutter_bootstrap.js?v=123" async></script>

<!-- Opção 2, atualize o nome do arquivo e atualize seus links -->
<script src="flutter_bootstrap.v123.js" async></script>
```

O Flutter atualmente não suporta anexar IDs de build aos recursos
automaticamente.

### Como configuro meus headers de cache?

Se você está usando Firebase Hosting,
o cache compartilhado (CDN) é invalidado quando você faz deploy de uma nova versão
do seu app. Mas você pode optar por configurar seus headers de cache da seguinte
forma, para que o cache do navegador não faça cache dos scripts do aplicativo,
mas o cache compartilhado sim.

```json
{
  "hosting": {
    "headers": [
      {
        "source":
          "**/*.@(jpg|jpeg|gif|png|svg|webp|css|eot|otf|ttf|ttc|woff|woff2|font.css)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=3600,s-maxage=604800"
          }
        ]
      },
      {
        "source":
          "**/*.@(mjs|js|wasm|json)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=0,s-maxage=604800"
          }
        ]
      }
    ]
  }
}
```

### Como configuro um service worker?

O service worker gerado por `flutter build web` está obsoleto,
e você pode desabilitá-lo definindo a flag `--pwa-strategy` como `none`
ao executar o comando `flutter build web`.

```console
flutter build web --pwa-strategy=none
```

Se você quiser continuar a usar um service worker, pode
[construir o seu próprio][using-service-workers] ou tentar ferramentas de terceiros
como [Workbox][workbox].

Se seu service worker não estiver atualizando,
configure seu CDN e cache do navegador definindo
o header `Cache-Control` para um valor pequeno, como 0 ou 60 segundos.

[building a web app with Flutter]: /platform-integration/web/building
[Creating responsive apps]: /ui/adaptive-responsive
[documentation for conditional imports]: {{site.dart-site}}/guides/libraries/create-library-packages#conditionally-importing-and-exporting-library-files
[Embedding Flutter web]: /platform-integration/web/embedding-flutter-web
[file an issue]: {{site.repo.flutter}}/issues/new?title=[web]:+%3Cdescribe+issue+here%3E&labels=%E2%98%B8+platform-web&body=Describe+your+issue+and+include+the+command+you%27re+running,+flutter_web%20version,+browser+version
[`http`]: {{site.pub}}/packages/http
[http-cache]: https://web.dev/articles/http-cache
[`iframe`]: https://html.com/tags/iframe/
[isolates]: {{site.dart-site}}/guides/language/concurrency
[Issue 32248]: {{site.repo.flutter}}/issues/32248
[Preparing a web app for release]: /deployment/web
[roadmap]: {{site.github}}/flutter/flutter/blob/master/docs/roadmap/Roadmap.md#web-platform
[run your web apps in any supported browser]: /platform-integration/web/building#create-and-run
[using-service-workers]: https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API/Using_Service_Workers
[Web content in Flutter]: /platform-integration/web/web-content-in-flutter
[Web support for Flutter]: /platform-integration/web
[web workers]: https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers
[workbox]: https://github.com/GoogleChrome/workbox
