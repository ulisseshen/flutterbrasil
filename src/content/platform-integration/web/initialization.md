---
ia-translate: true
title: Inicialização de apps Flutter web
description: Personalize como apps Flutter são inicializados na web.
---

Esta página detalha o processo de inicialização para apps Flutter web e
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

## Personalize a inicialização

Por padrão, `flutter build web` gera um arquivo `flutter_bootstrap.js` que
faz uma inicialização simples do seu app Flutter.
No entanto, em alguns cenários, você pode ter uma razão para
personalizar este processo de inicialização, como:

* Configurar uma configuração Flutter customizada para seu app.
* Alterar as configurações do service worker do Flutter.
* Escrever código JavaScript customizado para
  executar em diferentes estágios do processo de inicialização.

Para escrever sua própria lógica de bootstrapping customizada em vez de
usar o script padrão produzido pela etapa de build, você pode
colocar um arquivo `flutter_bootstrap.js` no subdiretório `web` do seu projeto,
que é copiado e usado em vez do
script padrão produzido pela build.
Este arquivo também é transformado em template, e você pode inserir vários tokens especiais que
a etapa de build substitui no momento da build ao copiar
o arquivo `flutter_bootstrap.js` para o diretório de saída.
A tabela a seguir lista os tokens que a etapa de build irá
substituir nos arquivos `flutter_bootstrap.js` ou `index.html`:

| Token | Substituído por |
|---|---|
| `{% raw %}{{flutter_js}}{% endraw %}` | O código JavaScript que torna o objeto `FlutterLoader` disponível na variável global `_flutter.loader`. (Veja a seção `_flutter.loader.load() API` abaixo para mais detalhes.) |
| `{% raw %}{{flutter_build_config}}{% endraw %}` | Uma declaração JavaScript que define metadados produzidos pelo processo de build que dá ao `FlutterLoader` informações necessárias para inicializar adequadamente sua aplicação. |
| `{% raw %}{{flutter_service_worker_version}}{% endraw %}` | Um número único representando a versão de build do service worker, que pode ser passado como parte da configuração do service worker (veja a tabela "Service Worker Settings" abaixo). |
| `{% raw %}{{flutter_bootstrap_js}}{% endraw %}` | Como mencionado acima, isso incorpora o conteúdo do arquivo `flutter_bootstrap.js` diretamente no arquivo `index.html`. Note que este token só pode ser usado no `index.html` e não no próprio arquivo `flutter_bootstrap.js`. |

{:.table}

<a id="write-a-custom-flutter_bootstrap-js" aria-hidden="true"></a>

## Escreva um script bootstrap customizado {:#custom-bootstrap-js}

Qualquer script `flutter_bootstrap.js` customizado precisa ter três componentes para
iniciar com sucesso seu app Flutter:

* Um token `{% raw %}{{flutter_js}}{% endraw %}`,
  para tornar `_flutter.loader` disponível.
* Um token `{% raw %}{{flutter_build_config}}{% endraw %}`,
  que fornece informações sobre a build para o
  `FlutterLoader` necessárias para iniciar seu app.
* Uma chamada para `_flutter.loader.load()`, que realmente inicia o app.

O arquivo `flutter_bootstrap.js` mais básico seria algo assim:

```js
{% raw %}{{flutter_js}}{% endraw %}
{% raw %}{{flutter_build_config}}{% endraw %}

_flutter.loader.load();
```

## Personalize o Flutter Loader

A API JavaScript `_flutter.loader.load()` pode ser invocada com
argumentos opcionais para personalizar o comportamento de inicialização:

| Nome                    | Descrição                                                                                                                   | Tipo&nbsp;JS |
|-------------------------|-----------------------------------------------------------------------------------------------------------------------------|--------------|
| `config`                | A configuração Flutter do seu app.                                                                                        | `Object`     |
| `onEntrypointLoaded`    | A função chamada quando o engine está pronto para ser inicializado. Recebe um objeto `engineInitializer` como seu único parâmetro. | `Function`   |

{:.table}

O argumento `config` é um objeto que pode ter os seguintes campos opcionais:

| Nome | Descrição | Tipo&nbsp;Dart |
|---|---|---|
|`assetBase`| A URL base do diretório `assets` do app. Adicione isso quando Flutter carrega de um domínio ou subdiretório diferente do web app real. Você pode precisar disso ao incorporar Flutter web em outro app, ou quando fazer deploy de seus assets para um CDN. |`String`|
|`canvasKitBaseUrl`| A URL base de onde `canvaskit.wasm` é baixado. |`String`|
|`canvasKitVariant`| A variante CanvasKit a ser baixada. Suas opções cobrem:<br><br>1. `auto`: Baixa a variante ideal para o browser. A opção usa este valor como padrão.<br>2. `full`: Baixa a variante completa do CanvasKit que funciona em todos os browsers.<br>3. `chromium`: Baixa uma variante menor do CanvasKit que usa APIs compatíveis com Chromium. **_Aviso_**: Não use a opção `chromium` a menos que você planeje usar apenas browsers baseados em Chromium. |`String`|
|`canvasKitForceCpuOnly`| Quando `true`, força renderização somente por CPU no CanvasKit (o engine não usará WebGL). |`bool`|
|`canvasKitMaximumSurfaces`| O número máximo de superfícies de overlay que o renderizador CanvasKit pode usar. |`double`|
|`debugShowSemanticNodes`| Se `true`, Flutter renderiza visivelmente a árvore de semântica na tela (para debugging).  |`bool`|
|`entryPointBaseUrl`| A URL base do entrypoint do seu app Flutter. O padrão é "/".  |`String`|
|`hostElement`| Elemento HTML no qual Flutter renderiza o app. Quando não definido, Flutter web assume a página inteira. |`HtmlElement`|
|`renderer`| Especifica o [renderizador web][web-renderers] para a aplicação Flutter atual, seja `"canvaskit"` ou `"skwasm"`. |`String`|

{:.table}

[web-renderers]: /platform-integration/web/renderers

## Exemplo: Personalizando a configuração Flutter com base em parâmetros de query da URL

O exemplo a seguir mostra um `flutter_bootstrap.js` customizado que permite
ao usuário selecionar um renderizador fornecendo um parâmetro de query `renderer`,
por exemplo `?renderer=skwasm`, na URL do seu site:

```js
{% raw %}{{flutter_js}}{% endraw %}
{% raw %}{{flutter_build_config}}{% endraw %}

const searchParams = new URLSearchParams(window.location.search);
const renderer = searchParams.get('renderer');
const userConfig = renderer ? {'renderer': renderer} : {};
_flutter.loader.load({
  config: userConfig,
});
```

Este script avalia os `URLSearchParams` da página para determinar se
o usuário passou um parâmetro de query `renderer` e então
altera a configuração do usuário do app Flutter.

## O callback onEntrypointLoaded

Você também pode passar um callback `onEntrypointLoaded` na API `load` para
executar lógica customizada em diferentes partes do processo de inicialização.
O processo de inicialização é dividido nos seguintes estágios:

**Carregando o script de entrypoint**
: A função `load` chama o callback `onEntrypointLoaded` uma vez que o
  Service Worker é inicializado, e o entrypoint `main.dart.js` foi
  baixado e executado pelo browser.
  Flutter também chama `onEntrypointLoaded` em
  cada hot restart durante o desenvolvimento.

**Inicializando o engine Flutter**
: O callback `onEntrypointLoaded` recebe um
  objeto **engine initializer** como seu único parâmetro.
  Use a função `initializeEngine()` do engine initializer para
  definir a configuração de tempo de execução, como `multiViewEnabled: true`,
  e iniciar o engine Flutter web.

**Executando o app**
: A função `initializeEngine()` retorna uma [`Promise`][js-promise]
  que resolve com um objeto **app runner**. O app runner tem um
  único método, `runApp()`, que executa o app Flutter.

**Adicionando views a (ou removendo views de) um app**
: O método `runApp()` retorna um objeto **flutter app**.
  No modo multi-view, os métodos `addView` e `removeView`
  podem ser usados para gerenciar views de app a partir do app host.
  Para aprender mais, confira [Modo incorporado][embedded-mode].

[embedded-mode]: {{site.docs}}/platform-integration/web/embedding-flutter-web/#embedded-mode
[js-promise]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise

## Exemplo: Exibir um indicador de progresso

Para dar feedback ao usuário de sua aplicação
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
    const appRunner = await engineInitializer.initializeEngine();

    loading.textContent = "Running app...";
    await appRunner.runApp();
  }
});
```
