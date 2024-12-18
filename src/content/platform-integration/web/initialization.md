---
ia-translate: true
title: Inicialização de aplicativos web Flutter
description: Personalize como os aplicativos Flutter são inicializados na web.
---

Esta página detalha o processo de inicialização para aplicativos web Flutter e como ele pode ser personalizado.

## Inicialização

O comando `flutter build web` produz um script chamado `flutter_bootstrap.js` no diretório de saída da build (`build/web`). Este arquivo contém o código JavaScript necessário para inicializar e executar seu aplicativo Flutter. Você pode usar este script colocando uma tag async-script para ele em seu arquivo `index.html` no subdiretório `web` do seu aplicativo Flutter:

```html highlightLines=3
<html>
  <body>
    <script src="flutter_bootstrap.js" async></script>
  </body>
</html>
```

Alternativamente, você pode inserir todo o conteúdo do arquivo `flutter_bootstrap.js` inserindo o token de modelo `{% raw %}{{flutter_bootstrap_js}}{% endraw %}` no seu arquivo `index.html`:

```html highlightLines=4
<html>
  <body>
    <script>
      {% raw %}{{flutter_bootstrap_js}}{% endraw %}
    </script>
  </body>
</html>
```

O token `{% raw %}{{flutter_bootstrap_js}}{% endraw %}` é substituído pelo conteúdo do arquivo `flutter_bootstrap.js` quando o arquivo `index.html` é copiado para o diretório de saída (`build/web`) durante a etapa de build.

<a id="customizing-initialization" aria-hidden="true"></a>

## Personalizar a inicialização

Por padrão, `flutter build web` gera um arquivo `flutter_bootstrap.js` que faz uma inicialização simples do seu aplicativo Flutter. No entanto, em alguns cenários, você pode ter um motivo para personalizar este processo de inicialização, como:

*   Definir uma configuração Flutter personalizada para seu aplicativo.
*   Alterar as configurações para o service worker do Flutter.
*   Escrever código JavaScript personalizado para executar em diferentes estágios do processo de inicialização.

Para escrever sua própria lógica de inicialização personalizada em vez de usar o script padrão produzido pela etapa de build, você pode colocar um arquivo `flutter_bootstrap.js` no subdiretório `web` do seu projeto, que é copiado e usado em vez do script padrão produzido pela build. Este arquivo também é modelado, e você pode inserir vários tokens especiais que a etapa de build substitui no momento da build ao copiar o arquivo `flutter_bootstrap.js` para o diretório de saída. A tabela a seguir lista os tokens que a etapa de build substituirá nos arquivos `flutter_bootstrap.js` ou `index.html`:

| Token | Substituído por |
|---|---|
| `{% raw %}{{flutter_js}}{% endraw %}` | O código JavaScript que torna o objeto `FlutterLoader` disponível na variável global `_flutter.loader`. (Consulte a seção `_flutter.loader.load() API` abaixo para obter mais detalhes.) |
| `{% raw %}{{flutter_build_config}}{% endraw %}` | Uma instrução JavaScript que define metadados produzidos pelo processo de build, que fornece ao `FlutterLoader` as informações necessárias para inicializar adequadamente seu aplicativo. |
| `{% raw %}{{flutter_service_worker_version}}{% endraw %}` | Um número exclusivo que representa a versão de build do service worker, que pode ser passada como parte da configuração do service worker (consulte a tabela "Configurações do Service Worker" abaixo). |
| `{% raw %}{{flutter_bootstrap_js}}{% endraw %}` | Como mencionado acima, isso insere o conteúdo do arquivo `flutter_bootstrap.js` diretamente no arquivo `index.html`. Observe que este token só pode ser usado no `index.html` e não no próprio arquivo `flutter_bootstrap.js`. |

{:.table}

<a id="write-a-custom-flutter_bootstrap-js" aria-hidden="true"></a>

## Escrever um script de bootstrap personalizado {:#custom-bootstrap-js}

Qualquer script `flutter_bootstrap.js` personalizado precisa ter três componentes para iniciar com sucesso seu aplicativo Flutter:

*   Um token `{% raw %}{{flutter_js}}{% endraw %}`, para disponibilizar `_flutter.loader`.
*   Um token `{% raw %}{{flutter_build_config}}{% endraw %}`, que fornece informações sobre a build para o `FlutterLoader` necessárias para iniciar seu aplicativo.
*   Uma chamada para `_flutter.loader.load()`, que realmente inicia o aplicativo.

O arquivo `flutter_bootstrap.js` mais básico teria a seguinte aparência:

```js
{% raw %}{{flutter_js}}{% endraw %}
{% raw %}{{flutter_build_config}}{% endraw %}

_flutter.loader.load();
```

## Personalizar o Flutter Loader

A API JavaScript `_flutter.loader.load()` pode ser invocada com argumentos opcionais para personalizar o comportamento de inicialização:

| Nome                    | Descrição                                                                                                                   | Tipo&nbsp;JS |
|-------------------------|-------------------------------------------------------------------------------------------------------------------------------|--------------|
| `config`                | A configuração Flutter do seu aplicativo.                                                                                      | `Object`     |
| `onEntrypointLoaded`    | A função chamada quando o engine está pronto para ser inicializado. Recebe um objeto `engineInitializer` como seu único parâmetro. | `Function`   |

{:.table}

O argumento `config` é um objeto que pode ter os seguintes campos opcionais:

| Nome | Descrição | Tipo&nbsp;Dart |
|---|---|---|
|`assetBase`| A URL base do diretório `assets` do aplicativo. Adicione isso quando o Flutter for carregado de um domínio ou subdiretório diferente do aplicativo web real. Você pode precisar disso quando incorporar o Flutter web em outro aplicativo ou quando implantar seus assets em uma CDN. |`String`|
|`canvasKitBaseUrl`| A URL base de onde `canvaskit.wasm` é baixado. |`String`|
|`canvasKitVariant`| A variante CanvasKit para baixar. Suas opções abrangem:<br><br>1. `auto`: Baixa a variante ideal para o navegador. A opção assume esse valor por padrão.<br>2. `full`: Baixa a variante completa do CanvasKit que funciona em todos os navegadores.<br>3. `chromium`: Baixa uma variante menor do CanvasKit que usa APIs compatíveis com Chromium. **_Aviso_**: Não use a opção `chromium` a menos que você planeje usar apenas navegadores baseados em Chromium. |`String`|
|`canvasKitForceCpuOnly`| Quando `true`, força a renderização somente por CPU no CanvasKit (o engine não usará WebGL). |`bool`|
|`canvasKitMaximumSurfaces`| O número máximo de superfícies de sobreposição que o renderizador CanvasKit pode usar. |`double`|
|`debugShowSemanticNodes`| Se `true`, o Flutter renderiza visivelmente a árvore semântica na tela (para depuração).  |`bool`|
|`entryPointBaseUrl`| A URL base do ponto de entrada do seu aplicativo Flutter. O padrão é "/".  |`String`|
|`hostElement`| Elemento HTML no qual o Flutter renderiza o aplicativo. Quando não definido, o Flutter web assume o controle de toda a página. |`HtmlElement`|
|`renderer`| Especifica o [renderizador web][web-renderers] para o aplicativo Flutter atual, `"canvaskit"` ou `"skwasm"`. |`String`|

{:.table}

[web-renderers]: /platform-integration/web/renderers

## Exemplo: Personalizando a configuração do Flutter com base nos parâmetros de consulta da URL

O exemplo a seguir mostra um `flutter_bootstrap.js` personalizado que permite que o usuário selecione um renderizador, fornecendo um parâmetro de consulta `renderer`, por exemplo, `?renderer=skwasm`, na URL do seu site:

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

Este script avalia o `URLSearchParams` da página para determinar se o usuário passou um parâmetro de consulta `renderer` e, em seguida, altera a configuração do usuário do aplicativo Flutter. Ele também passa as configurações do service worker para usar o service worker do Flutter, juntamente com a versão do service worker.

## O callback onEntrypointLoaded

Você também pode passar um callback `onEntrypointLoaded` para a API `load` para executar lógica personalizada em diferentes partes do processo de inicialização. O processo de inicialização é dividido nas seguintes etapas:

**Carregando o script de ponto de entrada**
: A função `load` chama o callback `onEntrypointLoaded` assim que o Service Worker é inicializado e o ponto de entrada `main.dart.js` é baixado e executado pelo navegador. O Flutter também chama `onEntrypointLoaded` em cada hot restart durante o desenvolvimento.

**Inicializando o engine Flutter**
: O callback `onEntrypointLoaded` recebe um objeto **inicializador de engine** como seu único parâmetro. Use a função `initializeEngine()` do inicializador de engine para definir a configuração de tempo de execução, como `multiViewEnabled: true`, e iniciar o engine web do Flutter.

**Executando o aplicativo**
: A função `initializeEngine()` retorna uma [`Promise`][js-promise] que é resolvida com um objeto **app runner**. O app runner tem um único método, `runApp()`, que executa o aplicativo Flutter.

**Adicionando visualizações a (ou removendo visualizações de) um aplicativo**
: O método `runApp()` retorna um objeto **aplicativo flutter**. No modo multi-view, os métodos `addView` e `removeView` podem ser usados para gerenciar as visualizações do aplicativo a partir do aplicativo host. Para saber mais, consulte [Modo Incorporado][embedded-mode].

[embedded-mode]: {{site.docs}}/platform-integration/web/embedding-flutter-web/#embedded-mode
[js-promise]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise

## Exemplo: Exibir um indicador de progresso

Para dar ao usuário do seu aplicativo feedback durante o processo de inicialização, use os hooks fornecidos para cada etapa para atualizar o DOM:

```js
{% raw %}{{flutter_js}}{% endraw %}
{% raw %}{{flutter_build_config}}{% endraw %}

const loading = document.createElement('div');
document.body.appendChild(loading);
loading.textContent = "Carregando Ponto de Entrada...";
_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    loading.textContent = "Inicializando o engine...";
    const appRunner = await engineInitializer.initializeEngine();

    loading.textContent = "Executando o aplicativo...";
    await appRunner.runApp();
  }
});
```
