---
ia-translate: true
title: Inicialização de app web Flutter
description: Personalize como apps Flutter são inicializados na web.
---

Esta página detalha o processo de inicialização para apps web Flutter e
como ele pode ser personalizado.

## Bootstrapping

O comando `flutter build web` produz
um script chamado `flutter_bootstrap.js` no
diretório de saída da build (`build/web`).
Este arquivo contém o código JavaScript necessário para inicializar e
executar seu app Flutter.
Você pode usar este script colocando uma tag async-script para ele em
seu arquivo `index.html` no subdiretório `web` do seu app Flutter:

```html highlightLines=3
<html>
  <body>
    <script src="flutter_bootstrap.js" async></script>
  </body>
</html>
```

Alternativamente, você pode incorporar todo o conteúdo do
arquivo `flutter_bootstrap.js` inserindo o
token de template `{% raw %}{{flutter_bootstrap_js}}{% endraw %}` no
seu arquivo `index.html`:

```html highlightLines=4
<html>
  <body>
    <script>
      {% raw %}{{flutter_bootstrap_js}}{% endraw %}
    </script>
  </body>
</html>
```

O token `{% raw %}{{flutter_bootstrap_js}}{% endraw %}` é
substituído pelo conteúdo do arquivo `flutter_bootstrap.js` quando
o arquivo `index.html` é copiado para o
diretório de saída (`build/web`) durante a etapa de build.

<a id="customizing-initialization" aria-hidden="true"></a>

## Personalizar a inicialização {:#customize-initialization}

Por padrão, `flutter build web` gera um arquivo `flutter_bootstrap.js` que
faz uma inicialização simples do seu app Flutter.
No entanto, em alguns cenários, você pode ter uma razão para
personalizar esse processo de inicialização, como:

* Definir uma configuração Flutter personalizada para seu app.
* Integrar um service worker personalizado para suporte offline ou cache.
* Escrever código JavaScript personalizado para
  executar em diferentes estágios do processo de inicialização.

Para escrever sua própria lógica de bootstrapping personalizada em vez de
usar o script padrão produzido pela etapa de build, você pode
colocar um arquivo `flutter_bootstrap.js` no subdiretório `web` do seu projeto,
que é copiado e usado em vez do
script padrão produzido pela build.
Este arquivo também é um template, e você pode inserir vários tokens especiais que
a etapa de build substitui em tempo de build ao copiar
o arquivo `flutter_bootstrap.js` para o diretório de saída.
A tabela a seguir lista os tokens que a etapa de build irá
substituir nos arquivos `flutter_bootstrap.js` ou `index.html`:

| Token | Substituído por |
|---|---|
| `{% raw %}{{flutter_js}}{% endraw %}` | O código JavaScript que torna o objeto `FlutterLoader` disponível na variável global `_flutter.loader`. (Consulte a seção `_flutter.loader.load() API` abaixo para mais detalhes.) |
| `{% raw %}{{flutter_build_config}}{% endraw %}` | Uma instrução JavaScript que define metadados produzidos pelo processo de build que dá ao `FlutterLoader` informações necessárias para fazer bootstrap adequadamente da sua aplicação. |
| `{% raw %}{{flutter_service_worker_version}}{% endraw %}` | **Descontinuado.** Anteriormente substituído por um número de versão de build para o carregador do service worker legado do Flutter. O Flutter não gera nem registra mais um service worker de cache; consulte [Descontinuação do service worker](#service-worker-version-deprecation) e o [FAQ da Web](/platform-integration/web/faq#how-do-i-configure-a-service-worker). |
| `{% raw %}{{flutter_bootstrap_js}}{% endraw %}` | Como mencionado acima, isso incorpora o conteúdo do arquivo `flutter_bootstrap.js` diretamente no arquivo `index.html`. Observe que este token só pode ser usado no `index.html` e não no próprio arquivo `flutter_bootstrap.js`. |

{:.table}

<a id="write-a-custom-flutter_bootstrap-js" aria-hidden="true"></a>

## Escrever um script de bootstrap personalizado {:#custom-bootstrap-js}

Qualquer script `flutter_bootstrap.js` personalizado precisa ter três componentes para
iniciar com sucesso seu app Flutter:

* Um token `{% raw %}{{flutter_js}}{% endraw %}`,
  para tornar `_flutter.loader` disponível.
* Um token `{% raw %}{{flutter_build_config}}{% endraw %}`,
  que fornece informações sobre a build ao
  `FlutterLoader` necessárias para iniciar seu app.
* Uma chamada para `_flutter.loader.load()`, que realmente inicia o app.

O arquivo `flutter_bootstrap.js` mais básico seria algo assim:

```js
{% raw %}{{flutter_js}}{% endraw %}
{% raw %}{{flutter_build_config}}{% endraw %}

_flutter.loader.load();
```

:::tip Compatibilidade com `--web-content-hash`
Quando você compila com [`flutter build web --web-content-hash`][web-content-hashing],
o Flutter injeta os nomes de arquivo de entrypoint com hash de conteúdo (`mainJsPath`,
`mainWasmPath`, `jsSupportRuntimePath`) e os mapeamentos do manifesto de assets com hash
(`assetManifest`, `fontManifest`, `extraAssets`) em
`{% raw %}{{flutter_build_config}}{% endraw %}`. Arquivos `web/index.html` ou
`web/flutter_bootstrap.js` personalizados devem incluir
`{% raw %}{{flutter_build_config}}{% endraw %}` e chamar `_flutter.loader.load()`
em vez de fixar `"main.dart.js"` no código ou chamar a API descontinuada
`FlutterLoader.loadEntrypoint()`.
:::

[web-content-hashing]: /deployment/web#web-content-hashing

## Personalizar o Flutter loader {:#customize-the-flutter-loader}

A API JavaScript `_flutter.loader.load()` pode ser invocada com
argumentos opcionais para personalizar o comportamento de inicialização:

| Nome                    | Descrição                                                                                                                   | Tipo&nbsp;JS |
|-------------------------|-----------------------------------------------------------------------------------------------------------------------------|--------------|
| `config`                | A configuração Flutter do seu app.                                                                                          | `Object`     |
| `onEntrypointLoaded`    | A função chamada quando o engine está pronto para ser inicializado. Recebe um objeto `engineInitializer` como seu único parâmetro. | `Function`   |

{:.table}

O argumento `config` é um objeto que pode ter os seguintes campos opcionais:

| Nome | Descrição | Tipo&nbsp;Dart |
|---|---|---|
|`assetBase`| A URL base do diretório `assets` do app. Adicione isso quando o Flutter carrega de um domínio ou subdiretório diferente do app web real. Você pode precisar disso quando incorpora o Flutter web em outro app, ou quando faz deploy de seus assets em um CDN. |`String`|
|`canvasKitBaseUrl`| A URL base de onde `canvaskit.wasm` é baixado. |`String`|
|`canvasKitVariant`| A variante CanvasKit para baixar. Suas opções cobrem:<br><br>1. `auto`: Baixa a variante ideal para o navegador. A opção usa este valor como padrão.<br>2. `full`: Baixa a variante completa do CanvasKit que funciona em todos os navegadores.<br>3. `chromium`: Baixa uma variante menor do CanvasKit que usa APIs compatíveis com Chromium. **_Aviso_**: Não use a opção `chromium` a menos que você planeje usar apenas navegadores baseados em Chromium. |`String`|
|`canvasKitForceCpuOnly`| Quando `true`, força renderização apenas por CPU no CanvasKit (o engine não usará WebGL). |`bool`|
|`canvasKitMaximumSurfaces`| O número máximo de superfícies overlay que o renderizador CanvasKit pode usar. |`double`|
|`debugShowSemanticsNodes`| Se `true`, Flutter renderiza visivelmente a árvore de semântica na tela (para depuração). |`bool`|
|`entrypointBaseUrl`| A URL base do entrypoint do seu app Flutter. O padrão é "/". |`String`|
|`fontFallbackBaseUrl`| URL base para baixar fontes de fallback quando as fontes incluídas não têm os glifos necessários. O padrão é `"https://fonts.gstatic.com/s/"`. |`String`|
|`forceSingleThreadedSkwasm`| Força o modo SkWasm de thread única para compatibilidade (afeta apenas apps compilados com `--wasm` quando [WebAssembly][wasm-support] é selecionado em tempo de execução). |`bool`|
|`hostElement`| Elemento HTML no qual o Flutter renderiza o app (consulte [incorporando views Flutter][embedding-flutter-web]). Quando não definido, o Flutter web assume a página inteira. |`HtmlElement`|
|`multiViewEnabled`| Habilita o modo multi-view para [incorporar views Flutter][embedding-flutter-web] em elementos DOM host dinamicamente. |`bool`|
|`nonce`| Uma string [nonce de Content Security Policy (CSP)][nonce-mdn] aplicada a scripts e estilos inline criados pelo engine. |`String`|
|`renderer`| Força explicitamente o renderizador para `'canvaskit'` ou `'skwasm'`. |`String`|
|`suppressMultithreadingWarning`| Quando `true`, suprime o aviso do console registrado quando o `skwasm` executa em thread única porque os headers `Cross-Origin-Opener-Policy` / `Cross-Origin-Embedder-Policy` estão ausentes. |`bool`|
|`verboseBuildSelection`| Quando `true`, registra diagnósticos detalhados com `console.warn` explicando por que cada build candidato em `_flutter.buildConfig.builds` foi selecionado ou ignorado. |`bool`|
|`wasmAllowList`| Lista de permissão de engines de navegador (`{ blink?: boolean, webkit?: boolean, gecko?: boolean, unknown?: boolean }`) que controla quais engines de navegador podem executar o build `skwasm` + `dart2wasm` quando as verificações de recursos WebAssembly em tempo de execução passam (consulte [Suporte a WebAssembly][wasm-support]). O padrão é `{ blink: true, gecko: false, webkit: false, unknown: false }`. |`Object`|
|`wasmDeferredModulesLoader`| Hook personalizado `(moduleNames: string[], onModuleLoaded: (moduleName: string, bytes: Uint8Array) => Promise<void>) => Promise<void>` usado para buscar módulos `.wasm` adiados quando `--enable-wasm-deferred-loading` está habilitado. |`Function`|

{:.table}

[embedding-flutter-web]: /platform-integration/web/embedding-flutter-web
[nonce-mdn]: https://developer.mozilla.org/docs/Web/HTML/Global_attributes/nonce
[wasm-support]: /platform-integration/web/wasm

## forceSingleThreadedSkwasm

Uma flag booleana para forçar o renderizador Skia WebAssembly (skwasm)
a executar em **modo de thread única**. Isso é útil se:

* Seu ambiente não suporta WASM multi-thread. Por exemplo,
  `SharedArrayBuffer` não está disponível ou os headers de
  segurança necessários estão ausentes.  
* Você deseja máxima compatibilidade com navegadores.
* Use `false` (padrão) para permitir renderização multi-thread quando
  suportada, o que melhora o desempenho.

## Exemplo de uso {:#example-usage}

```js
_flutter.loader.load({
  config: {
    forceSingleThreadedSkwasm: true,
    wasmAllowList: {
      blink: true,
      webkit: true,
      gecko: true,
    },
  },
});
```

## Exemplo: Personalizando a configuração Flutter com base em parâmetros de query da URL {:#example-customizing-flutter-configuration-based-on-url-query-parameters}

O exemplo a seguir mostra um `flutter_bootstrap.js` personalizado que habilita
o modo de thread única quando um parâmetro de query `force_st` está presente na URL:

```js
{% raw %}{{flutter_js}}{% endraw %}
{% raw %}{{flutter_build_config}}{% endraw %}

const searchParams = new URLSearchParams(window.location.search);
const forceSt = searchParams.has('force_st');
const userConfig = forceSt ? { forceSingleThreadedSkwasm: true } : {};
_flutter.loader.load({
  config: userConfig,
});
```

Este script avalia os `URLSearchParams` da página para determinar se
o usuário passou um parâmetro de query `force_st` e configura o app de acordo.

## O callback onEntrypointLoaded {:#the-onentrypointloaded-callback}

Você também pode passar um callback `onEntrypointLoaded` para a API `load` para
executar lógica personalizada em diferentes partes do processo de inicialização.
O processo de inicialização é dividido nos seguintes estágios:

**Carregando o script entrypoint**
: A função `load` chama o callback `onEntrypointLoaded` quando o
  script entrypoint principal foi baixado e executado pelo navegador.
  O Flutter também chama `onEntrypointLoaded` em
  cada hot restart durante o desenvolvimento.

**Inicializando o engine Flutter**
: O callback `onEntrypointLoaded` recebe um
  objeto **engine initializer** como seu único parâmetro.
  Use a função `initializeEngine()` do engine initializer para
  definir a configuração de tempo de execução, como `multiViewEnabled: true`,
  e iniciar o engine web Flutter.

**Executando o app**
: A função `initializeEngine()` retorna uma [`Promise`][js-promise]
  que resolve com um objeto **app runner**. O app runner tem um
  único método, `runApp()`, que executa o app Flutter.

**Adicionando views a (ou removendo views de) um app**
: O método `runApp()` retorna um objeto **flutter app**.
  No modo multi-view, os métodos `addView` e `removeView`
  podem ser usados para gerenciar views do app a partir do app host.
  Para saber mais, confira [Modo embedded][embedded-mode].

[embedded-mode]: /platform-integration/web/embedding-flutter-web#embedded-mode
[js-promise]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise

:::warning
Quando você fornece seu próprio callback `onEntrypointLoaded`, a `config`
que você passa para `_flutter.loader.load()` **não** é encaminhada ao
engine automaticamente. O Flutter só aplica essa `config` para você quando
você omite `onEntrypointLoaded` e deixa o loader iniciar o app.

Em um callback personalizado, passe a configuração para `initializeEngine()`
você mesmo, caso contrário ela é ignorada silenciosamente:

```js
_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine({
      // Set your run-time configuration here.
      renderer: 'canvaskit',
    });
    await appRunner.runApp();
  },
});
```

:::

## Exemplo: Exibir um indicador de progresso {:#example-display-a-progress-indicator}

Para dar feedback ao usuário do seu aplicativo
durante o processo de inicialização,
use os hooks fornecidos para cada estágio para atualizar o DOM:

```js
{% raw %}{{flutter_js}}{% endraw %}
{% raw %}{{flutter_build_config}}{% endraw %}

const loading = document.createElement('div');
document.body.appendChild(loading);
loading.textContent = "Loading Entrypoint...";
_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    loading.textContent = "Initializing engine...";
    // If you have a `config`, pass it here. The config given to `load()`
    // is not forwarded when you supply your own `onEntrypointLoaded`.
    const appRunner = await engineInitializer.initializeEngine();

    loading.textContent = "Running app...";
    await appRunner.runApp();
  }
});
```

## Avisos comuns {:#common-warnings}

Esta seção descreve avisos comuns de build e inicialização web
e como resolvê-los.

### Descontinuação do service worker {:#service-worker-version-deprecation}

Se você encontrar um aviso semelhante ao seguinte durante `flutter build web`:

```text
Warning: In index.html:37: Flutter's service worker is deprecated and will be removed in a future Flutter release.
See https://github.com/flutter/flutter/issues/156910 for more details.
```

Remova as variáveis legadas do service worker, as chamadas de registro e
`serviceWorkerSettings` do seu arquivo `web/index.html` ou do arquivo
`web/flutter_bootstrap.js` personalizado:

```js
// Remove legacy serviceWorkerVersion declarations:
var serviceWorkerVersion = null;
const serviceWorkerVersion = null;

// Remove legacy flutter_service_worker.js registration calls:
navigator.serviceWorker.register('flutter_service_worker.js');

// Remove serviceWorkerSettings from _flutter.loader.load():
_flutter.loader.load({
  serviceWorkerSettings: {
    serviceWorkerVersion: {% raw %}{{flutter_service_worker_version}}{% endraw %},
  },
});
```

Se o seu app requer um service worker personalizado, consulte o
[FAQ da Web](/platform-integration/web/faq#how-do-i-configure-a-service-worker)
e [Hash de conteúdo web (`precache_manifest.json`)][web-content-hashing].

### Descontinuação de FlutterLoader.loadEntrypoint {:#flutterloader-loadentrypoint-deprecation}

Se você encontrar um aviso semelhante ao seguinte:

```text
Warning: In index.html:40: "FlutterLoader.loadEntrypoint" is deprecated.
Use "FlutterLoader.load" instead.
```

Este aviso ocorre quando um arquivo `web/index.html` mais antigo usa
`_flutter.loader.loadEntrypoint()` em vez de `_flutter.loader.load()`.
A mensagem da CLI faz referência à interface `FlutterLoader`,
que o código JavaScript acessa por meio de `_flutter.loader`.

Se o seu app usa a inicialização padrão e não requer
bootstrapping personalizado, substitua o bloco de script legado em `web/index.html`
pela tag de script padrão:

```html title="web/index.html"
<script src="flutter_bootstrap.js" async></script>
```

Se você personalizou sua lógica de inicialização,
atualize seu código de bootstrap em `web/index.html`
(ou em um arquivo `web/flutter_bootstrap.js` personalizado)
para chamar `_flutter.loader.load()` em vez disso:

```js
_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine();
    await appRunner.runApp();
  }
});
```

Para ver um exemplo que atualiza elementos do DOM durante a inicialização,
consulte o [exemplo de indicador de progresso][progress indicator example].

[progress indicator example]: #example-display-a-progress-indicator
