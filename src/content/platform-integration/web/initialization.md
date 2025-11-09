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

## Personalizar a inicialização

Por padrão, `flutter build web` gera um arquivo `flutter_bootstrap.js` que
faz uma inicialização simples do seu app Flutter.
No entanto, em alguns cenários, você pode ter uma razão para
personalizar esse processo de inicialização, como:

* Definir uma configuração Flutter personalizada para seu app.
* Alterar as configurações do service worker Flutter.
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
| `{% raw %}{{flutter_service_worker_version}}{% endraw %}` | Um número único representando a versão de build do service worker, que pode ser passado como parte da configuração do service worker (consulte o aviso "Aviso comum" abaixo). |
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

## Personalizar o Flutter loader

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
|`debugShowSemanticNodes`| Se `true`, Flutter renderiza visivelmente a árvore de semântica na tela (para depuração).  |`bool`|
|`entrypointBaseUrl`| A URL base do entrypoint do seu app Flutter. O padrão é "/".  |`String`|
|`hostElement`| Elemento HTML no qual o Flutter renderiza o app. Quando não definido, o Flutter web assume a página inteira. |`HtmlElement`|
|`renderer`| Especifica o [renderizador web][web-renderers] para a aplicação Flutter atual, seja `"canvaskit"` ou `"skwasm"`. |`String`|

{:.table}

[web-renderers]: /platform-integration/web/renderers

## Exemplo: Personalizando a configuração Flutter com base em parâmetros de query da URL

O exemplo a seguir mostra um `flutter_bootstrap.js` personalizado que permite
ao usuário selecionar um renderizador fornecendo um parâmetro de query `renderer`,
por exemplo `?renderer=skwasm`, na URL do site:

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

Você também pode passar um callback `onEntrypointLoaded` para a API `load` para
executar lógica personalizada em diferentes partes do processo de inicialização.
O processo de inicialização é dividido nos seguintes estágios:

**Carregando o script entrypoint**
: A função `load` chama o callback `onEntrypointLoaded` quando o
  Service Worker é inicializado, e o entrypoint `main.dart.js` foi
  baixado e executado pelo navegador.
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

[embedded-mode]: {{site.docs}}/platform-integration/web/embedding-flutter-web/#embedded-mode
[js-promise]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise

## Exemplo: Exibir um indicador de progresso

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
    const appRunner = await engineInitializer.initializeEngine();

    loading.textContent = "Running app...";
    await appRunner.runApp();
  }
});
```

## Aviso comum

Se você encontrar um aviso semelhante ao seguinte:

```text
Warning: In index.html:37: Local variable for "serviceWorkerVersion" is deprecated.
Use "{{flutter_service_worker_version}}" template token instead.
```

Você pode corrigir isso excluindo a seguinte linha no arquivo `web/index.html`:

```html title="web/index.html"
var serviceWorkerVersion = null;
```
