---
ia-translate: true
title: Perguntas frequentes sobre Web
description: >-
  Algumas pegadinhas e diferenças ao escrever ou executar apps web no Flutter.
---

## Perguntas {:#questions}

### Quais cenários são ideais para Flutter na web? {:#what-scenarios-are-ideal-for-flutter-on-the-web}

Nem toda página web faz sentido em Flutter,
mas achamos que o Flutter é particularmente adequado para experiências centradas em aplicativos:

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

### Otimização para mecanismos de busca (SEO) {:#search-engine-optimization-seo}

Em geral, o Flutter é voltado para experiências de aplicativos dinâmicos.
O suporte web do Flutter não é exceção.
O Flutter web prioriza desempenho, fidelidade e consistência.
Isso significa que a saída do aplicativo não se alinha com o que os
mecanismos de busca precisam para indexar adequadamente.

No entanto, um pacote Dart lançado pela comunidade, o [Jaspr][], _suporta_
sites estáticos.
Na verdade, os sites da [documentação do Dart][Dart documentation], da [documentação do Flutter][Flutter documentation] e de
[marketing do Flutter][Flutter marketing] foram migrados para usar o pacote Jaspr.

Resumindo, para conteúdo web que é estático ou semelhante a um documento,
recomendamos usar _ou_:

1. [Jaspr][], se você quer usar Dart mas deseja um site mais tradicional
   baseado em DOM. Observe também que o Jaspr faz o SEO funcionar da
   mesma forma que em um site tradicional.
1. HTML—neste caso, considere separar sua experiência principal de
   aplicativo (criada em Flutter) de sua landing page,
   conteúdo de marketing e conteúdo de ajuda (criados usando
   HTML otimizado para mecanismos de busca).

[Dart documentation]: {{site.dart-site}}
[Flutter documentation]: /
[Flutter marketing]: {{site.main-url}}
[Jaspr]: https://jaspr.site/

### O hot reload funciona com um app web? {:#does-hot-reload-work-with-a-web-app}

Sim! Para mais informações,
confira [hot reload na web][hot reload on the web].

[hot reload on the web]: /platform-integration/web/building#hot-reload-web

### Quais navegadores web são suportados pelo Flutter? {:#which-web-browsers-are-supported-by-flutter}

Apps web Flutter podem ser executados nos seguintes navegadores:

* Chrome (mobile & desktop)
* Safari (mobile & desktop)
* Edge (mobile & desktop)
* Firefox (mobile & desktop)

Durante o desenvolvimento, Chrome (no macOS, Windows e Linux)
e Edge (no Windows) são suportados como navegadores padrão
para depurar seu app.

### Posso compilar, executar e fazer deploy de apps web em qualquer uma das IDEs? {:#can-i-build-run-and-deploy-web-apps-in-any-of-the-ides}

Você pode selecionar **Chrome** ou **Edge** como dispositivo de destino no
Android Studio/IntelliJ e VS Code.

O menu suspenso de dispositivos agora deve incluir a opção **Chrome (web)**
para todos os canais.

### Como faço para compilar um app responsivo para a web? {:#how-do-i-build-a-responsive-app-for-the-web}

Consulte [Criando apps responsivos][Creating responsive apps].

### Posso usar `dart:io` com um app web? {:#can-i-use-dart-io-with-a-web-app}

Não. O sistema de arquivos não é acessível pelo navegador.
Para funcionalidade de rede, use o pacote [`http`][`http`].
Observe que a segurança funciona de forma um pouco
diferente porque o navegador (e não o app)
controla os headers em uma requisição HTTP.

### Como lido com imports específicos da web? {:#how-do-i-handle-web-specific-imports}

Alguns plugins requerem imports específicos de plataforma, particularmente se
eles usam o sistema de arquivos, que não é acessível pelo navegador. Para usar
esses plugins em seu app, use imports condicionais.

Ao compilar para WebAssembly, verifique `dart.library.js_interop`
(em vez de `dart.library.js` ou `dart.library.html`,
que não são suportados no Wasm):

```dart
import 'fallback.dart'
  if (dart.library.js) 'legacy_web_interop.dart'
  if (dart.library.js_interop) 'wasm_web_interop.dart';
```

Para mais detalhes, consulte a
[documentação para imports condicionais][documentation for conditional imports]
em [dart.dev]({{site.dart-site}}). Para ajuda com falhas de compilação Wasm
devido a imports não suportados, confira
[Diagnosticar erros de compilação Wasm](/platform-integration/web/wasm#diagnosing-wasm-compilation-errors).

### O Flutter web suporta concorrência? {:#does-flutter-web-support-concurrency}

O suporte de concorrência do Dart que usa [isolates][isolates]
não é atualmente suportado no Flutter web.

Apps web Flutter podem potencialmente contornar isso
usando [web workers][web workers],
embora esse suporte não esteja integrado.

### Como faço para fazer deploy de um app web? {:#how-do-i-deploy-a-web-app}

Consulte [Preparando um app web para lançamento][Preparing a web app for release].

### `Platform.is` funciona na web? {:#does-platform-is-work-on-the-web}

Não. Embora tecnicamente você possa importar `dart:io` ao compilar para a web,
chamar qualquer método `Platform.isXYZ` lança um `UnsupportedError`.
Além disso, importar `dart:io` em um pacote
(exceto por meio de imports condicionais) faz com que o pub.dev
pontue o pacote como sem suporte à web.

* Se você está desenvolvendo um app Flutter, considere usar [`kIsWeb`][].
* Se você está desenvolvendo um pacote
  (especialmente um sem dependência do Flutter),
  considere usar o pacote [`os_detect`][].

[`kIsWeb`]: {{site.api}}/flutter/foundation/kIsWeb-constant.html

### Por que meu app não atualiza imediatamente após ser implantado? {:#why-doesnt-my-app-update-immediately-after-its-deployed}

Pode ser necessário configurar o header `Cache-Control`
retornado pelo seu servidor web.
Por exemplo, se este header estiver definido como 3600,
então o navegador e o CDN farão cache do recurso por 1 hora,
e seus usuários podem ver uma versão
desatualizada do seu app até 1 hora após você fazer deploy de uma nova versão.
Para mais informações sobre cache na web, confira
[Previna requisições de rede desnecessárias com o HTTP Cache][http-cache].

É uma boa ideia estar ciente desse comportamento para evitar uma
experiência de usuário indesejável.
Depois de fazer deploy do seu app, os usuários podem usar uma
versão em cache do seu app (em cache pelo navegador ou CDN)
pela duração definida pelos seus headers de cache.
Isso pode levar ao uso de uma versão do seu app que
é incompatível com mudanças que foram implantadas
em serviços de backend.

### Como limpo o cache da web após um deploy e forço o download de um app? {:#how-do-i-clear-the-web-cache-after-a-deployment-and-force-an-app-download}

No Flutter 3.50 e posteriores, passe `--web-content-hash` ao compilar seu app web:

```console
$ flutter build web --web-content-hash
```

A flag `--web-content-hash` incorpora um hash de conteúdo SHA-256 de 8 caracteres nos
entrypoints compilados, nos source maps JavaScript e em todos os arquivos em
`build/web/assets/**`, e atualiza suas referências em `flutter_bootstrap.js`
automaticamente. Para a lista completa de arquivos com hash e orientações de implantação gradual,
consulte [Hash de conteúdo web](/deployment/web#web-content-hashing).

Se você não está usando `--web-content-hash`, pode anexar manualmente um parâmetro de query
com o ID de build ou um nome de arquivo versionado à tag do seu script de bootstrap:

```html
<!-- Opção 1, anexe o ID de build como um parâmetro de query em seus links -->
<script src="flutter_bootstrap.js?v=123" async></script>

<!-- Opção 2, atualize o nome do arquivo e atualize seus links -->
<script src="flutter_bootstrap.v123.js" async></script>
```

### Como configuro meus headers de cache? {:#how-do-i-configure-my-cache-headers}

Se você está usando Firebase Hosting,
o cache compartilhado (CDN) é invalidado quando você faz deploy de uma
nova versão do seu app.
No entanto, por padrão o Firebase Hosting define `Cache-Control: max-age=3600`
em arquivos estáticos, o que significa que os navegadores podem servir versões desatualizadas de `index.html`,
`flutter_bootstrap.js` ou arquivos de manifesto por até uma hora após um deploy.

Se você compila com `flutter build web --web-content-hash`, configure o
`firebase.json` para que `index.html`, `flutter_bootstrap.js` e `404.html`
sejam revalidados a cada carregamento (`max-age=0, must-revalidate`) enquanto os
entrypoints com hash e `assets/**` ficam em cache de forma imutável por um ano
(`public, max-age=31536000, immutable`):

```json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**",
      "**/*.map"
    ],
    "headers": [
      {
        "source": "**",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=0, must-revalidate"
          }
        ]
      },
      {
        "source": "assets/**",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "public, max-age=31536000, immutable"
          }
        ]
      },
      {
        "source": "main.dart.*.+(js|wasm|mjs)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "public, max-age=31536000, immutable"
          }
        ]
      },
      {
        "source": "404.html",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=0, must-revalidate"
          }
        ]
      }
    ],
    "rewrites": [
      {
        "source": "!(/assets/**|/canvaskit/**|/icons/**|/main.dart.*)",
        "destination": "/index.html"
      }
    ]
  }
}
```

Se você compila sem `--web-content-hash`, omita as regras `immutable` para
`assets/**` e `main.dart.*.+(js|wasm|mjs)` para que todos os arquivos sejam revalidados via
`"source": "**"` e `"source": "404.html"` (`max-age=0, must-revalidate`),
recebendo respostas rápidas `304 Not Modified` da borda do CDN quando não houver mudanças.

A exclusão de rewrite de `/index.html`
(`!(/assets/**|/canvaskit/**|/icons/**|/main.dart.*)`) garante que requisições
para assets ausentes ou entry points compilados retornem um status `404` real em vez
de `index.html` com status `200 OK`, e a regra de `404.html` impede que o
CDN faça cache de respostas 404 sob TTLs curinga.

### Como configuro um service worker? {:#how-do-i-configure-a-service-worker}

O Flutter não gera nem gerencia mais um service worker de cache por padrão
(em versões mais recentes, ele grava um stub de autolimpeza para remover
service workers legados).

Se sua aplicação requer suporte offline ou cache avançado,
você precisa configurar um service worker por conta própria usando ferramentas web
padrão ou soluções de terceiros como o [Workbox][workbox].
Ao compilar com `--web-content-hash`, o Flutter gera
`build/web/precache_manifest.json` contendo entradas `{url, hash, size, urlHashed}`
que você pode usar no pipeline de build do seu service worker personalizado.

Para mais informações sobre como construir service workers personalizados,
confira [Usando service workers][Using service workers].

[building a web app with Flutter]: /platform-integration/web/building
[Creating responsive apps]: /ui/adaptive-responsive
[documentation for conditional imports]: {{site.dart-site}}/interop/js-interop/package-web#conditional-imports
[Embedding Flutter web]: /platform-integration/web/embedding-flutter-web
[file an issue]: {{site.repo.flutter}}/issues/new?title=[web]:+%3Cdescribe+issue+here%3E&labels=%E2%98%B8+platform-web&body=Describe+your+issue+and+include+the+command+you%27re+running,+flutter_web%20version,+browser+version
[`http`]: {{site.pub}}/packages/http
[http-cache]: https://web.dev/articles/http-cache
[`iframe`]: https://html.com/tags/iframe/
[isolates]: {{site.dart-site}}/guides/language/concurrency
[Issue 32248]: {{site.repo.flutter}}/issues/32248
[Preparing a web app for release]: /deployment/web
[roadmap]: {{site.repo.flutter}}/blob/master/docs/roadmap/Roadmap.md#web-platform
[run your web apps in any supported browser]: /platform-integration/web/building#create-and-run
[Using service workers]: https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API/Using_Service_Workers
[Web content in Flutter]: /platform-integration/web/web-content-in-flutter
[Web support for Flutter]: /platform-integration/web
[web workers]: https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers
[workbox]: https://github.com/GoogleChrome/workbox
[`os_detect`]: {{site.pub}}/packages/os_detect
