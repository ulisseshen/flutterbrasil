---
ia-translate: true
title: Compilar e lançar um app web
description: Como preparar e lançar um app web.
shortTitle: Web
---

Durante um ciclo típico de desenvolvimento,
você testa um app usando `flutter run -d chrome`
(por exemplo) na linha de comando.
Isso compila uma versão _debug_ do seu app.

Esta página ajuda você a preparar uma versão _release_
do seu app e cobre os seguintes tópicos:

* [Compilando o app para release](#building-the-app-for-release)
* [Hashing de conteúdo web e cache HTTP](#web-content-hashing)
* [Deploy para a web](#deploying-to-the-web)
* [Deploy para Firebase Hosting](#deploying-to-firebase-hosting)
* [Manipulando imagens na web](#handling-images-on-the-web)
* [Optando pelo WebAssembly](#opting-in-to-webassembly)
* [Minificação](#minification)
* [Viewport de navegadores móveis e SafeArea](#mobile-browser-viewport-and-safearea)

## Compilando o app para release {:#building-the-app-for-release}

Compile o app para deployment usando o comando `flutter build web`.

```console
flutter build web
```

Para compilar sua aplicação com WebAssembly (Wasm), passe a flag `--wasm`:

```console
flutter build web --wasm
```

Isso
gera o app, incluindo os assets, e coloca os arquivos no
diretório `/build/web` do projeto.

Para validar o build release do seu app,
inicie um servidor web (por exemplo,
`python -m http.server 8000`,
ou usando o package [dhttpd][]),
e abra o diretório /build/web. Navegue até
`localhost:8000` no seu navegador
(dado o exemplo python SimpleHTTPServer)
para visualizar a versão release do seu app.

## Flags de build adicionais {:#additional-build-flags}
Você pode precisar fazer deploy de um build profile ou debug para testes.
Para fazer isso, passe a flag `--profile` ou `--debug`
para o comando `flutter build web`.
Builds profile são especializados para profiling de performance usando Chrome DevTools,
e builds debug podem ser usados para configurar dart2js
para respeitar assertions e mudar o nível de otimização (usando a flag `-O`.)

### Source maps

Para gerar source maps para simbolização em serviços de relatório de falhas,
passe a flag `--source-maps`:

```console
flutter build web --source-maps
```

Gerar source maps cria arquivos `.js.map` ou `.wasm.map` separados
(ou ambos, dependendo do seu alvo de build) no diretório `build/web`
sem adicionar sobrecarga binária à saída compilada.

:::warning Exclua source maps da hospedagem pública
Por padrão, ferramentas padrão de deploy web fazem upload de todos os arquivos em `build/web/`.
Se os source maps forem publicados publicamente, o DevTools do navegador
os baixará automaticamente, expondo nomes de símbolos não minificados,
hierarquias de classes e caminhos de arquivos locais.

Faça upload dos arquivos `.map` para seu serviço privado de monitoramento de erros
(como Sentry ou Datadog) durante o CI/CD, e exclua os arquivos `*.map`
da hospedagem web pública (por exemplo, usando `"ignore": ["**/*.map"]`
no `firebase.json` ou removendo-os antes do deploy).
:::

### Hashing de conteúdo web (--web-content-hash) {:#web-content-hashing}

:::version-note
O hashing de conteúdo web (`--web-content-hash`) requer Flutter 3.50 ou posterior.
:::

Para habilitar o cache busting automático baseado em conteúdo entre deploys, passe
`--web-content-hash` para `flutter build web`:

```console
flutter build web --wasm --web-content-hash
```

Quando `--web-content-hash` está habilitado, o Flutter incorpora um hash de conteúdo
SHA-256 truncado em 8 caracteres nos entrypoints compilados e em todos os arquivos sob
`build/web/assets/**`, e registra os caminhos com hash em `flutter_bootstrap.js`
(`_flutter.buildConfig`):

* **Arquivos imutáveis com hash (`Cache-Control: public, max-age=31536000, immutable`)**:
  * Entrypoints compilados: `main.dart.<hash>.js`, `main.dart.<hash>.wasm` e
    `main.dart.<hash>.mjs` (além de `main.dart.<hash>.js.map` e
    `main.dart.<hash>.mjs.map` se `--source-maps` estiver habilitado).
  * Todos os arquivos sob `assets/**`: incluindo `AssetManifest.<hash>.bin`,
    `AssetManifest.bin.<hash>.json`, `FontManifest.<hash>.json`,
    `NOTICES.<hash>`, fontes, imagens e `shaders/**`.
* **Arquivos de bootstrap e raiz sem hash (`Cache-Control: max-age=0, must-revalidate` ou `no-cache`)**:
  * `index.html`, `flutter_bootstrap.js`, `flutter.js`, `manifest.json`,
    `version.json`, `404.html` e `icons/**`.
  * Arquivos `canvaskit/**` empacotados ao compilar com `--no-web-resources-cdn`.
  * `main.dart.wasm.map` ao compilar com `--source-maps` (a seção personalizada
    `sourceMappingURL` do binário `.wasm` referencia o nome de arquivo
    `.wasm.map` sem hash).

Para um exemplo completo de `firebase.json`, consulte o [FAQ da Web][web-faq-caching].

:::note
`--web-content-hash` ainda não suporta imports adiados (`deferred as`) em
builds JavaScript (`dart2js`) nem WebAssembly (`dart2wasm` /
`--enable-wasm-deferred-loading`).
:::

#### Deploys sobrepostos para abas ativas do navegador {:#overlay-deployments-for-active-browser-tabs}

Quando você faz deploy de uma nova versão (`N`), usuários com uma aba do navegador já aberta
executando a versão anterior (`N-1`) podem buscar sob demanda um asset, fonte ou
imagem cujo nome de arquivo carrega o hash de conteúdo da versão `N-1`.

Para evitar erros `404` no meio da sessão durante rollouts, use uma estratégia de
**deploy sobreposto** (overlay deployment):

* Mantenha pelo menos os arquivos `main.dart.*` e `assets/**` com hash da versão
  anterior (`N-1`) no seu CDN ou bucket de armazenamento junto com os arquivos
  com hash da versão `N` (ou remova hashes antigos após uma janela de tolerância de 24–72 horas).
* Atualize `index.html` e `flutter_bootstrap.js` atomicamente por último.
* Exclua `/assets/**`, `/canvaskit/**`, `/icons/**` e `/main.dart.*` das
  regras de rewrite catch-all para `/index.html` de single-page applications (SPA),
  para que assets ausentes retornem um `404` genuíno em vez de `200 text/html`.

#### Service workers personalizados (`precache_manifest.json`) {:#custom-service-workers-precache-manifest-json}

Quando `--web-content-hash` está habilitado, `flutter build web` grava uma lista de
materiais em `build/web/precache_manifest.json`:

```json title="build/web/precache_manifest.json"
{
  "version": 1,
  "entries": [
    {
      "url": "flutter_bootstrap.js",
      "hash": "a1b2c3d4",
      "size": 10432,
      "urlHashed": false
    },
    {
      "url": "main.dart.f215ce97.wasm",
      "hash": "f215ce97",
      "size": 1842104,
      "urlHashed": true
    }
  ]
}
```

Service workers de PWA personalizados ou pipelines do [Workbox][] podem consumir
`precache_manifest.json` diretamente (passando `revision: entry.urlHashed ? null : entry.hash`
para que arquivos com hash na URL não sejam armazenados em cache duas vezes com parâmetros de query).

## Optando pelo WebAssembly {:#opting-in-to-webassembly}

Para compilar e otimizar seu app para WebAssembly,
use a flag `--wasm` ao executar ou compilar.

Para mais informações, veja [Suporte para WebAssembly (Wasm)][Wasm support].

:::important Servindo builds WebAssembly
Builds WebAssembly usam múltiplas threads para melhorar a performance de renderização
e exigem que seu servidor web retorne cabeçalhos de resposta HTTP COEP/COOP específicos
(`Cross-Origin-Embedder-Policy: credentialless` e
`Cross-Origin-Opener-Policy: same-origin`).
Para todos os detalhes, veja [Suporte para WebAssembly (Wasm)][Wasm support].
:::

## Deploy para a web {:#deploying-to-the-web}

Quando estiver pronto para fazer deploy do seu app,
faça upload do bundle release
para Firebase, nuvem, ou um serviço similar.
Aqui estão algumas possibilidades, mas há
muitas outras:

* [Firebase Hosting][]
* [GitHub Pages][]
* [Google Cloud Hosting][]

## Deploy para Firebase Hosting {:#deploying-to-firebase-hosting}

Você pode usar o Firebase CLI para compilar e lançar seu app Flutter com Firebase
Hosting.

### Antes de começar {:#before-you-begin}

Para começar, [instale ou atualize][install-firebase-cli] o Firebase CLI:

```console
npm install -g firebase-tools
```

### Inicializar Firebase {:#initialize-firebase}

1. Habilite o preview de web frameworks para o [CLI framework-aware do Firebase][Firebase framework-aware CLI]:

    ```console
    firebase experiments:enable webframeworks
    ```

2. Em um diretório vazio ou um projeto Flutter existente, execute o comando de
inicialização:

    ```console
    firebase init hosting
    ```

3. Responda `yes` quando perguntado se você quer usar um web framework.

4. Se você está em um diretório vazio,
    você será perguntado para escolher seu web framework. Escolha `Flutter Web`.

5. Escolha seu diretório fonte de hospedagem; isso pode ser um app flutter existente.

6. Selecione uma região para hospedar seus arquivos.

7. Escolha se deseja configurar builds e deploys automáticos com GitHub.

8. Faça deploy do app para Firebase Hosting:

    ```console
    firebase deploy
    ```

    Executar este comando automaticamente executa `flutter build web --release`,
    então você não precisa compilar seu app em um passo separado.

Para saber mais, visite a documentação oficial do [Firebase Hosting][] para
Flutter na web.

## Manipulando imagens na web {:#handling-images-on-the-web}

A web suporta o widget `Image` padrão para exibir imagens.
Por design, navegadores web executam código não confiável sem prejudicar o computador host.
Isso limita o que você pode fazer com imagens comparado a plataformas mobile e desktop.

Para mais informações, veja [Displaying images on the web][].

## Minificação {:#minification}

Para melhorar o start-up do app, o compilador reduz o tamanho do código compilado
removendo código não utilizado (conhecido como _tree shaking_), e renomeando símbolos de código para
strings mais curtas (por exemplo, renomeando `AlignmentGeometryTween` para algo como
`ab`). Quais dessas duas otimizações são aplicadas depende do modo de build:

| Tipo de build de app web | Código minificado? | Tree shaking executado? |
|-----------------------|----------------|-------------------------|
| debug                 | Não             | Não                      |
| profile               | Não             | Sim                     |
| release               | Sim            | Sim                     |

## Viewport de navegadores móveis e SafeArea {:#mobile-browser-viewport-and-safearea}

:::version-note
O suporte a insets de `SafeArea` com `viewport-fit=cover` e a preservação da
codificação percentual de URLs no histórico do navegador requerem Flutter 3.50 ou posterior.
:::

Em navegadores móveis (como o Safari do iOS e o Chrome do Android) com recortes de tela,
notches ou indicadores de início, o Flutter web por padrão renderiza dentro da
área segura do navegador (`viewport-fit=contain`).

Para renderizar de borda a borda em toda a tela e preencher o [`SafeArea`][]
e o [`MediaQuery.paddingOf`][] do Flutter com os insets CSS
`env(safe-area-inset-*)` do navegador, adicione uma tag `<meta name="viewport">` com
`viewport-fit=cover` dentro do `<head>` do seu arquivo `web/index.html` (incluída
como uma opção comentada nos templates `web/index.html` recém-criados):

```html title="web/index.html"
<meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
```

:::note
Se um web app existente já inclui `viewport-fit=cover` em
`web/index.html`, o Flutter 3.50 e posterior o respeita em vez de removê-lo,
o que faz o app renderizar atrás dos recortes do dispositivo, a menos que os controles de UI estejam
envolvidos em um widget [`SafeArea`][]. Para detalhes de migração, consulte o
[guia da breaking change de SafeArea com `viewport-fit=cover`][viewport-fit-breaking].
:::

### Codificação percentual de URLs no histórico do navegador {:#url-percent-encoding-in-browser-history}

No Flutter 3.50 e posterior, strings de rota passadas para
`SystemNavigator.routeInformationUpdated` preservam sequências codificadas em porcentagem
(como `%2F`, `%26`, `%23` e `%20`) quando gravadas na barra de URL do navegador
e no histórico, em vez de decodificá-las usando `Uri.decodeComponent`.

## Incorporando um app Flutter em uma página HTML {:#embedding-a-flutter-app-into-an-html-page}

Veja [Embedding Flutter web][].

[Embedding Flutter web]: /platform-integration/web/embedding-flutter-web

[dhttpd]: {{site.pub}}/packages/dhttpd
[Displaying images on the web]: /platform-integration/web/web-images
[Firebase Hosting]: {{site.firebase}}/docs/hosting/frameworks/flutter
[Firebase framework-aware CLI]: {{site.firebase}}/docs/hosting/frameworks/frameworks-overview
[install-firebase-cli]: {{site.firebase}}/docs/cli#install_the_firebase_cli
[GitHub Pages]: https://pages.github.com/
[give us feedback]: {{site.repo.flutter}}/issues/new?title=%5Bweb%5D:+%3Cdescribe+issue+here%3E&labels=%E2%98%B8+platform-web&body=Describe+your+issue+and+include+the+command+you%27re+running,+flutter_web%20version,+browser+version
[Google Cloud Hosting]: https://cloud.google.com/solutions/web-hosting
[`MediaQuery.paddingOf`]: {{site.api}}/flutter/widgets/MediaQuery/paddingOf.html
[`SafeArea`]: {{site.api}}/flutter/widgets/SafeArea-class.html
[viewport-fit-breaking]: /release/breaking-changes/viewport-fit-cover-safe-area
[Wasm support]: /platform-integration/web/wasm
[web-faq-caching]: /platform-integration/web/faq#how-do-i-configure-my-cache-headers
[Workbox]: https://github.com/GoogleChrome/workbox
