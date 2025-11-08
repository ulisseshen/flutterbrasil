---
ia-translate: true
title: Web FAQ
description: Algumas pegadinhas e diferenças ao escrever ou executar apps web no Flutter.
---

## Perguntas

### Quais cenários são ideais para Flutter na web?

Nem toda página web faz sentido no Flutter, mas acreditamos que Flutter é particularmente
adequado para experiências centradas em apps:

* Progressive Web Apps
* Single Page Apps
* Apps Flutter mobile existentes

Neste momento, Flutter não é adequado para sites estáticos com conteúdo
rico em texto e baseado em fluxo. Por exemplo, artigos de blog se beneficiam do modelo centrado em documentos
no qual a web é construída, em vez dos serviços centrados em apps que um
framework de UI como Flutter pode oferecer. No entanto, você _pode_ usar Flutter para incorporar
experiências interativas nesses sites.

Para mais informações sobre como você pode usar Flutter na web,
consulte [Suporte web para Flutter][Web support for Flutter].

### Search Engine Optimization (SEO)

Em geral, Flutter é voltado para experiências de aplicações dinâmicas. O
suporte web do Flutter não é exceção. Flutter web prioriza performance, fidelidade e
consistência. Isso significa que a saída da aplicação não se alinha com o que os motores de
busca precisam para indexar adequadamente. Para conteúdo web que é estático ou semelhante a documento,
recomendamos usar HTML—assim como fazemos em [flutterbrasil.dev]({{site.main-url}}),
[dart.dev]({{site.dart-site}}), e [pub.dev]({{site.pub}}). Você também deve
considerar separar sua experiência de aplicação principal—criada em Flutter—de
sua landing page, conteúdo de marketing e conteúdo de ajuda—criados usando
HTML otimizado para motores de busca.

Dito isso, como mencionado no [roadmap][], a equipe Flutter planeja
investigar a indexabilidade de motores de busca do Flutter web.

### Hot reload funciona com um web app?

Não, mas você pode usar hot restart. Hot restart é uma maneira rápida de ver suas
mudanças sem ter que relançar seu web app e esperar que ele compile e
carregue. Isso funciona de forma semelhante ao recurso de hot reload para desenvolvimento
Flutter mobile. A única diferença é que hot reload lembra seu estado e hot
restart não.

### Quais web browsers são suportados pelo Flutter?

Apps Flutter web podem executar nos seguintes browsers:

* Chrome (mobile & desktop)
* Safari (mobile & desktop)
* Edge (mobile & desktop)
* Firefox (mobile & desktop)

Durante o desenvolvimento, Chrome (no macOS, Windows e Linux) e Edge (no Windows)
são suportados como os browsers padrão para depurar seu app.

### Posso compilar, executar e fazer deploy de web apps em qualquer uma das IDEs?

Você pode selecionar **Chrome** ou **Edge** como o dispositivo alvo no
Android Studio/IntelliJ e VS Code.

O menu suspenso de dispositivos agora deve incluir a opção **Chrome (web)**
para todos os canais.

### Como construo um app responsivo para a web?

Consulte [Criando apps responsivos][Creating responsive apps].

### Posso usar `dart:io` com um web app?

Não. O sistema de arquivos não é acessível a partir do browser.
Para funcionalidade de rede, use o pacote [`http`][].
Note que a segurança funciona de forma um pouco
diferente porque o browser (e não o app)
controla os headers em uma requisição HTTP.

### Como lido com imports específicos da web?

Alguns plugins requerem imports específicos de plataforma, particularmente se eles usam o
sistema de arquivos, que não é acessível a partir do browser. Para usar esses plugins
no seu app, consulte a [documentação para imports condicionais][documentation for conditional imports]
em [dart.dev]({{site.dart-site}}).

### Flutter web suporta concorrência?

O suporte de concorrência do Dart via [isolates][]
não é atualmente suportado no Flutter web.

Apps Flutter web podem potencialmente contornar isso
usando [web workers][],
embora nenhum suporte seja integrado.

### Como faço deploy de um web app?

Consulte [Preparando um web app para release][Preparing a web app for release].

### `Platform.is` funciona na web?

Não atualmente.

### Por que meu app não atualiza imediatamente após o deploy?

Você pode precisar configurar o header `Cache-Control` retornado pelo seu web server.
Por exemplo, se este header estiver definido como 3600, então o browser
e CDN irão cachear o asset por 1 hora, e seus usuários podem ver uma versão
desatualizada do seu app até 1 hora após você fazer deploy de uma nova versão. Para
mais informações sobre caching na web,
confira [Previna requisições de rede desnecessárias com o HTTP Cache][http-cache].

É uma boa ideia estar ciente desse comportamento para evitar uma experiência de usuário indesejável.
Após você fazer deploy do seu app, os usuários podem usar uma
versão em cache do seu app (em cache pelo browser ou CDN)
pela duração definida pelos seus headers de cache.
Isso pode levar os usuários a usar uma versão do seu app que
é incompatível com mudanças que foram deployadas nos serviços de backend.

### Como limpo o cache web após um deploy e forço um download do app?
Se você deseja superar esses headers de cache após cada deploy, uma técnica
comum é anexar um ID de build de algum tipo aos links de seus recursos
estáticos, ou atualizar os próprios nomes de arquivo.
Por exemplo, `logo.png` pode se tornar `logo.v123.png`.

```html
<!-- Option 1, append build ID as a query parameter in your links -->
<script src="flutter_bootstrap.js?v=123" async></script>

<!-- Option 2, update the filename and update your links -->
<script src="flutter_bootstrap.v123.js" async></script>
```

Flutter não suporta atualmente anexar IDs de build aos recursos
automaticamente.

### Como configuro meus headers de cache?

Se você está usando Firebase Hosting,
o cache compartilhado (CDN) é invalidado quando você faz deploy de uma nova versão do seu
app. Mas você pode escolher configurar seus headers de cache da seguinte forma,
para que o cache do browser não faça cache dos scripts da aplicação,
mas o cache compartilhado faça.

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

Se você gostaria de continuar usando um service worker, você pode
[construir o seu próprio][using-service-workers] ou experimentar ferramentas de terceiros
como [Workbox][workbox].

Se seu service worker não está atualizando,
configure seu CDN e cache do browser definindo
o header `Cache-Control` para um valor pequeno como 0 ou 60 segundos.

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
