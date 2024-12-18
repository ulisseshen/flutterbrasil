---
ia-translate: true
title: FAQ da Web
description: Algumas armadilhas e diferenças ao escrever ou executar aplicativos da web no Flutter.
---

## Perguntas

### Quais cenários são ideais para Flutter na web?

Nem toda página da web faz sentido no Flutter, mas achamos que o Flutter é
particularmente adequado para experiências centradas em aplicativos:

* Progressive Web Apps
* Single Page Apps
* Aplicativos móveis Flutter existentes

Neste momento, o Flutter não é adequado para sites estáticos com conteúdo rico em
texto e baseado em fluxo. Por exemplo, artigos de blog se beneficiam do modelo
centrado em documentos em que a web é construída, em vez dos serviços centrados em
aplicativos que uma estrutura de UI como o Flutter pode fornecer. No entanto, você
_pode_ usar o Flutter para incorporar experiências interativas nesses sites.

Para obter mais informações sobre como você pode usar o Flutter na web, consulte
[Suporte Web para Flutter][].

### Otimização para Mecanismos de Busca (SEO)

Em geral, o Flutter é voltado para experiências de aplicativos dinâmicos. O suporte
do Flutter para a web não é exceção. A web do Flutter prioriza desempenho,
fidelidade e consistência. Isso significa que a saída do aplicativo não se alinha
com o que os mecanismos de pesquisa precisam para indexar adequadamente. Para
conteúdo da web que seja estático ou semelhante a um documento, recomendamos o uso
de HTML—assim como fazemos em [flutter.dev]({{site.main-url}}),
[dart.dev]({{site.dart-site}}) e [pub.dev]({{site.pub}}). Você também deve
considerar separar sua experiência primária do aplicativo — criada no Flutter — de
sua landing page, conteúdo de marketing e conteúdo de ajuda — criados usando HTML
otimizado para mecanismos de pesquisa.

Dito isso, como mencionado no [roadmap][], a equipe do Flutter planeja investigar
a indexabilidade em mecanismos de busca da web do Flutter.

### O hot reload funciona com um aplicativo web?

Não, mas você pode usar o hot restart. Hot restart é uma maneira rápida de ver
suas alterações sem ter que relançar seu aplicativo da web e esperar que ele
compile e carregue. Isso funciona de forma semelhante ao recurso de hot reload para
desenvolvimento móvel Flutter. A única diferença é que o hot reload se lembra do
seu estado e o hot restart não.

### Quais navegadores da web são compatíveis com o Flutter?

Aplicativos web do Flutter podem ser executados nos seguintes navegadores:

* Chrome (mobile e desktop)
* Safari (mobile e desktop)
* Edge (mobile e desktop)
* Firefox (mobile e desktop)

Durante o desenvolvimento, Chrome (em macOS, Windows e Linux) e Edge (no Windows)
são suportados como os navegadores padrão para depurar seu aplicativo.

### Posso construir, executar e implantar aplicativos da web em qualquer IDE?

Você pode selecionar **Chrome** ou **Edge** como o dispositivo de destino no
Android Studio/IntelliJ e VS Code.

O menu suspenso do dispositivo agora deve incluir a opção **Chrome (web)** para
todos os canais.

### Como faço para construir um aplicativo responsivo para a web?

Consulte [Criando aplicativos responsivos][].

### Posso usar `dart:io` com um aplicativo da web?

Não. O sistema de arquivos não é acessível pelo navegador. Para funcionalidade de
rede, use o pacote [`http`][]. Observe que a segurança funciona de forma um
tanto diferente porque o navegador (e não o aplicativo) controla os cabeçalhos em
uma solicitação HTTP.

### Como lido com importações específicas da web?

Alguns plugins exigem importações específicas da plataforma, principalmente se
usarem o sistema de arquivos, que não é acessível pelo navegador. Para usar esses
plugins em seu aplicativo, consulte a [documentação para importações condicionais][]
em [dart.dev]({{site.dart-site}}).

### A web do Flutter suporta concorrência?

O suporte de concorrência do Dart por meio de [isolates][] não é atualmente
suportado na web do Flutter.

Aplicativos web do Flutter podem potencialmente contornar isso usando [web
workers][], embora nenhum suporte desse tipo esteja integrado.

### Como faço para implantar um aplicativo da web?

Consulte [Preparando um aplicativo da web para lançamento][].

### O `Platform.is` funciona na web?

Não atualmente.

### Por que meu aplicativo não é atualizado imediatamente após a implantação?

Você pode precisar configurar o cabeçalho `Cache-Control` retornado pelo seu
servidor web. Por exemplo, se este cabeçalho estiver definido como 3600, o
navegador e a CDN armazenarão em cache o recurso por 1 hora, e seus usuários
poderão ver uma versão desatualizada do seu aplicativo até 1 hora após a
implantação de uma nova versão. Para obter mais informações sobre o cache na web,
confira [Evite solicitações de rede desnecessárias com o Cache HTTP][http-cache].

É uma boa ideia estar ciente desse comportamento para evitar uma experiência de
usuário indesejável. Depois de implantar seu aplicativo, os usuários podem usar
uma versão em cache do seu aplicativo (armazenada em cache pelo navegador ou CDN)
pela duração definida pelos seus cabeçalhos de cache. Isso pode levar os usuários a
usar uma versão do seu aplicativo que é incompatível com as alterações que foram
implantadas nos serviços de backend.

### Como faço para limpar o cache da web após uma implantação e forçar o download de um aplicativo?
Se você deseja anular esses cabeçalhos de cache após cada implantação, uma técnica
comum é anexar um ID de build de algum tipo aos links de seus recursos estáticos
ou atualizar os próprios nomes de arquivos. Por exemplo, `logo.png` pode se tornar
`logo.v123.png`.

```html
<!-- Opção 1, anexar ID de build como um parâmetro de consulta em seus links -->
<script src="flutter_bootstrap.js?v=123" async></script>

<!-- Opção 2, atualizar o nome do arquivo e atualizar seus links -->
<script src="flutter_bootstrap.v123.js" async></script>
```

O Flutter atualmente não oferece suporte para anexar IDs de build aos recursos
automaticamente.

### Como faço para configurar meus cabeçalhos de cache?

Se você estiver usando o Firebase Hosting, o cache compartilhado (CDN) será
invalidado quando você implantar uma nova versão do seu aplicativo. Mas você pode
optar por configurar seus cabeçalhos de cache da seguinte forma, para que o cache
do navegador não armazene em cache scripts de aplicativos, mas o cache compartilhado
o faça.

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

### Como faço para configurar um service worker?

O service worker gerado por `flutter build web` foi descontinuado e você pode
desativá-lo definindo o sinalizador `--pwa-strategy` como `none` ao executar o
comando `flutter build web`.

```console
flutter build web --pwa-strategy=none
```

Se você quiser continuar usando um service worker, você pode [criar o seu próprio][using-service-workers] ou experimentar ferramentas de terceiros como o
[Workbox][workbox].

Se o seu service worker não estiver sendo atualizado, configure seu CDN e cache do
navegador definindo o cabeçalho `Cache-Control` para um valor pequeno, como 0 ou
60 segundos.

[building a web app with Flutter]: /platform-integration/web/building
[Criando aplicativos responsivos]: /ui/adaptive-responsive
[documentação para importações condicionais]: {{site.dart-site}}/guides/libraries/create-library-packages#conditionally-importing-and-exporting-library-files
[Embedding Flutter web]: /platform-integration/web/embedding-flutter-web
[file an issue]: {{site.repo.flutter}}/issues/new?title=[web]:+%3Cdescreva+o+problema+aqui%3E&labels=%E2%98%B8+platform-web&body=Descreva+seu+problema+e+inclua+o+comando+que+voc%C3%AA+est%C3%A1+executando,+flutter_web%20version,+browser+version
[`http`]: {{site.pub}}/packages/http
[http-cache]: https://web.dev/articles/http-cache
[`iframe`]: https://html.com/tags/iframe/
[isolates]: {{site.dart-site}}/guides/language/concurrency
[Issue 32248]: {{site.repo.flutter}}/issues/32248
[Preparando um aplicativo da web para lançamento]: /deployment/web
[roadmap]: {{site.github}}/flutter/flutter/blob/master/docs/roadmap/Roadmap.md#web-platform
[run your web apps in any supported browser]: /platform-integration/web/building#create-and-run
[using-service-workers]: https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API/Using_Service_Workers
[Web content in Flutter]: /platform-integration/web/web-content-in-flutter
[Web support for Flutter]: /platform-integration/web
[web workers]: https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers
[workbox]: https://github.com/GoogleChrome/workbox
