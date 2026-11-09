---
ia-translate: true
title: Suporte para WebAssembly (Wasm)
description: >-
  Estado atual do suporte do Flutter para WebAssembly (Wasm).
shortTitle: Wasm
last-update: Oct 16, 2026
---

Flutter e Dart suportam
[WebAssembly](https://webassembly.org/)
como alvo de compilação ao construir
aplicações para a web.

[`stable`]: {{site.repo.flutter}}/blob/master/docs/releases/Flutter-build-release-channels.md#stable
[`package:web`]: {{site.pub-pkg}}/web
[`dart:js_interop`]: {{site.dart.api}}/dart-js_interop/dart-js_interop-library.html

## Começando {:#get-started}

Para testar um app web Flutter pré-construído usando Wasm, confira o
[app de demonstração Wonderous](https://wonderous.app/web/).

Para experimentar Wasm em seus próprios apps, use os seguintes passos.

### Mudar para a versão mais recente do Flutter {:#switch-to-the-latest-version-of-flutter}

Mude para a versão 3.24 ou superior do Flutter
para executar e compilar aplicações Flutter para WebAssembly.
Para garantir que você está executando a versão mais recente, execute `flutter upgrade`.

### Garantir que as dependências do seu app são compatíveis {:#ensure-that-your-apps-dependencies-are-compatible}

Experimente o [app de exemplo][sample app] do template padrão,
ou escolha qualquer aplicação Flutter
que foi migrada para ser
[compatível com Wasm](#js-interop-wasm).

[sample app]: /reference/create-new-app

### Modificar a página index {:#modify-the-index-page}

Certifique-se de que o `web/index.html` do seu app esteja atualizado para a
[inicialização de app web Flutter][Flutter web app initialization] mais recente para Flutter 3.22 e posterior.

Se você quiser usar o padrão, exclua o conteúdo do diretório `web/`
e execute o seguinte comando para regenerá-los:

```console
$ flutter create . --platforms web
```

[Flutter web app initialization]: /platform-integration/web/initialization

### Executar ou compilar seu app {:#run-or-build-your-app}

Para executar o app com Wasm para desenvolvimento ou teste,
use a flag `--wasm` com o comando `flutter run`.

```console
$ flutter run -d chrome --wasm
```

Para compilar uma aplicação web com Wasm, adicione a flag `--wasm` ao
comando `flutter build web` existente.

```console
$ flutter build web --wasm
```

O comando produz a saída no diretório `build/web` relativo à
raiz do pacote, assim como `flutter build web`.

:::note
Habilitar a compilação Wasm para um app Flutter web não usa carregamento adiado
(deferred loading) por padrão. O carregamento adiado em Wasm está disponível no Flutter 3.50 e posteriores e
pode ser habilitado usando a flag `--enable-wasm-deferred-loading`:

```console
$ flutter build web --wasm --enable-wasm-deferred-loading
```

Para personalizar como os módulos `.wasm` adiados são baixados em tempo de execução, forneça um
callback `wasmDeferredModulesLoader` na configuração de
[inicialização do app Flutter web][Flutter web app initialization].
:::

#### Depuração de Wasm em produção {:#wasm-production-debugging}

Por padrão, builds de release Wasm removem os símbolos de depuração e omitem source maps
para minimizar o tamanho do binário.

- **Para monitoramento de erros (recomendado)**: Passe `--source-maps` para gerar
  um arquivo `main.dart.wasm.map` para simbolização em serviços de rastreamento de erros.
  Para recomendações de segurança e avisos de implantação, consulte
  [Source maps](/deployment/web#source-maps).
- **Para builds de staging ou QA**: Passe `--no-strip-wasm` para preservar os nomes
  de funções Wasm diretamente nos stack traces do console do navegador, ao custo de
  um **aumento aproximado de 47%** no tamanho do binário Wasm.

```console
# Generate source maps for production error tracking:
$ flutter build web --wasm --source-maps

# Preserve Wasm function names for staging/QA debugging:
$ flutter build web --wasm --no-strip-wasm
```

### Abrir o app em um navegador web compatível {:#open-the-app-in-a-compatible-web-browser}
Mesmo com a flag `--wasm`, o Flutter ainda compilará a aplicação para
JavaScript. Se o suporte WasmGC não for detectado em tempo de execução, a saída
JavaScript é usada para que a aplicação continue funcionando em todos os principais navegadores.

Você pode verificar se o app está realmente executando com Wasm verificando a
variável de ambiente `dart2wasm`, definida durante a compilação (preferido).

```dart
const isRunningWithWasm = bool.fromEnvironment('dart.tool.dart2wasm');
```

Alternativamente, você pode usar diferenças nas representações de números
para testar se a representação de número nativa (Wasm) é usada.

```dart
final isRunningWithWasm = identical(double.nan, double.nan);
```

### Servir a saída construída com um servidor HTTP {:#serve-the-built-output-with-an-http-server}

Flutter web WebAssembly pode usar múltiplas threads para renderizar sua aplicação
mais rápido, com menos travamentos. Para fazer isso, o Flutter usa recursos avançados do navegador que
requerem headers de resposta HTTP específicos.

:::important
Aplicações web Flutter compiladas com WebAssembly não executarão com múltiplas threads
a menos que o servidor esteja configurado para enviar headers HTTP específicos.
:::

| Nome | Valor |
|-|-|
| `Cross-Origin-Embedder-Policy` | `credentialless` <br> ou <br> `require-corp` |
| `Cross-Origin-Opener-Policy` | `same-origin` |

{:.table}

Para saber mais sobre esses headers, confira
[Carregar recursos cross-origin sem headers CORP usando COEP: credentialless][coep].

[coep]: https://developer.chrome.com/blog/coep-credentialless-origin-trial

## Saiba mais sobre compatibilidade de navegadores {:#learn-more-about-browser-compatibility}

No Flutter 3.50 e posteriores, executar um app Flutter compilado para Wasm (`dart2wasm` +
`skwasm`) requer um navegador que suporte três recursos padronizados do
WebAssembly:

* [WasmGC][] (Garbage Collection)
* [JS String Builtins][wasm-js-string] (`wasm:js-string`)
* [Phase 4 Exception Handling][wasm-eh] (`try_table` / `exnref`)

Na inicialização, o `flutter_bootstrap.js` verifica se o engine WebAssembly do navegador
oferece esses recursos e confere a configuração `wasmAllowList` antes de selecionar o
build Wasm. Quando um navegador não suporta esses recursos ou não está habilitado em
`wasmAllowList`, o Flutter recorre automaticamente ao build JavaScript (`dart2js`)
com CanvasKit produzido por `flutter build web --wasm`.

| Engine do navegador | Versão mínima para Wasm | Comportamento padrão no Flutter 3.50 (`--wasm`) | Como habilitar Wasm |
| :--- | :--- | :--- | :--- |
| **Chromium** (Chrome, Edge, Opera, Brave) | **137+** (Desktop e Android) | Executa `dart2wasm` + `skwasm` por padrão; Chrome `< 137` recorre a `dart2js` + CanvasKit. | Habilitado por padrão (`wasmAllowList.blink: true`). |
| **WebKit** (Safari macOS e iOS, todos os navegadores iOS) | **Safari 26.2+** (macOS e iOS 26.2+) | Recorre a `dart2js` + CanvasKit por padrão (`wasmAllowList.webkit: false`). | Defina `wasmAllowList: { webkit: true }` na [inicialização do app Flutter web][Flutter web app initialization]. Safari `<= 26.1` recorre automaticamente a `dart2js` + CanvasKit por meio da detecção de recursos em tempo de execução. |
| **Gecko** (Firefox) | **Firefox 147+** | Recorre a `dart2js` + CanvasKit por padrão (`wasmAllowList.gecko: false`). | Defina `wasmAllowList: { gecko: true }` na [inicialização do app Flutter web][Flutter web app initialization]. Firefox `< 147` recorre automaticamente a `dart2js` + CanvasKit. |

{:.table}

[WasmGC]: https://github.com/WebAssembly/gc/tree/main/proposals/gc
[wasm-js-string]: https://github.com/WebAssembly/js-string-builtins
[wasm-eh]: https://github.com/WebAssembly/exception-handling

## Usando bibliotecas de JS interop compatíveis {:#js-interop-wasm}

Para suportar compilação para Wasm, Dart modernizou
como habilita interop com APIs de navegador e JavaScript.
As bibliotecas legadas de web e JS interop do Dart SDK (`dart:html`, `dart:js`,
`dart:js_util`, `dart:indexed_db`, `dart:svg`, `dart:web_audio` e
`dart:web_gl`) estão **descontinuadas e com remoção do Dart SDK planejada para uma
versão futura**, e nem essas bibliotecas nem o pacote descontinuado `package:js`
são suportados ao compilar para Wasm.

Em vez disso, Dart fornece soluções de interop leves construídas em torno
de JS interop estático que funcionam tanto para JavaScript quanto para WebAssembly:

- [`package:web`][`package:web`], que substitui `dart:html` (e outras bibliotecas web legadas)
- [`dart:js_interop`][`dart:js_interop`], que substitui `package:js`, `dart:js` e `dart:js_util`

Para um guia detalhado sobre como migrar código existente,
consulte o [guia de migração do `package:web`][`package:web` migration guide].

Ao compilar para Wasm, esteja ciente das diferenças em tempo de execução
nos tipos de JS interop (como casts de tipo com `is`/`as`
e a propagação de Zone em callbacks).
Para detalhes, confira a
[documentação de tipos de JS interop]({{site.dart-site}}/interop/js-interop/js-types#compatibility-type-checks-and-casts)
do Dart e a [seção sobre Zones do package:web]({{site.dart-site}}/interop/js-interop/package-web#zones).

Para saber mais sobre JS interop no Dart,
consulte a página de documentação [JS interop][JS interop] do Dart.

### Diagnosticar erros de compilação Wasm {:#diagnosing-wasm-compilation-errors}

Ao compilar um projeto Flutter web com `--wasm`, se sua aplicação ou seus
pacotes importarem APIs web não suportadas (como `dart:html` ou `package:js`),
a compilação falhará.

#### 1. Faça a detecção antecipada e imponha o JS interop moderno {:#1-perform-early-detection-and-enforce-modern-js-interop}

Você pode detectar incompatibilidades antecipadamente com avisos de dry run. Quando você executa
`flutter build web` sem a flag `--wasm`, um dry run de Wasm ainda é executado
automaticamente (passe `--no-wasm-dry-run` para suprimi-lo). Se forem encontradas
incompatibilidades, você verá um aviso não fatal como este:

```console
Wasm dry run failed:
Found incompatibilities with WebAssembly.

package:my_app/main.dart 1:1 - dart:html unsupported (0)
```

No Flutter 3.50 e posteriores, você também pode impor o JS interop moderno nos
builds JavaScript (`dart2js` e `ddc`). Isso garante a compatibilidade com Wasm e
prepara seu app para a futura remoção das bibliotecas web descontinuadas do
Dart SDK. Passe `--no-deprecated-js-interop` para `flutter build web`,
`flutter run`, `flutter drive` ou `flutter test --platform chrome`:

```console
$ flutter build web --no-deprecated-js-interop
```

Passar `--no-deprecated-js-interop` faz com que imports de bibliotecas web `dart:*`
descontinuadas (e de pacotes que as importam, como `package:js`) falhem em
tempo de compilação. Isso também avalia `dart.library.html`, `dart.library.js` e
`dart.library.js_util` como `false` em imports condicionais.

#### 2. Inspecione a árvore de dependências do compilador {:#2-inspect-the-compiler-dependency-tree}

Se você executar `flutter build web --wasm` e a compilação falhar devido a um
import não suportado, o `flutter_tools` imprime uma árvore `Context` estruturada mostrando qual
pacote e arquivo importou a biblioteca indisponível:

```console
Context: The unavailable library 'dart:html' is imported through these packages:

    main.dart => package:my_app => dart:html

Detailed import paths for (some of) these imports:

    main.dart => package:my_app/main.dart => dart:html
```

#### 3. Migre os imports legados {:#3-migrate-legacy-imports}

Para corrigir esses erros de compilação, você precisa migrar dos pacotes legados de JS interop
para alternativas modernas compatíveis com WebAssembly:

- Substitua `dart:html` e outras bibliotecas web legadas por [`package:web`][].
- Substitua `dart:js` e `package:js` por [`dart:js_interop`][].

Para instruções completas de migração, confira o
[guia de migração do `package:web` no dart.dev]({{site.dart-site}}/interop/js-interop/package-web)
e o [guia de uso de JS interop]({{site.dart-site}}/interop/js-interop) do Dart.

Se você precisar suportar ambientes legados e modernos durante a
migração, use imports condicionais verificando `dart.library.js_interop`:

```dart
import 'fallback.dart'
  if (dart.library.js) 'legacy_web_interop.dart'
  if (dart.library.js_interop) 'wasm_web_interop.dart';
```

Para saber mais sobre como selecionar implementações em tempo de compilação, consulte a
[documentação de imports condicionais no dart.dev]({{site.dart-site}}/interop/js-interop/package-web#conditional-imports).

[`package:url_launcher`]: {{site.pub-pkg}}/url_launcher
[`package:web` migration guide]: {{site.dart-site}}/interop/js-interop/package-web
[JS interop]: {{site.dart-site}}/interop/js-interop
[`wasm-ready`]: {{site.pub-pkg}}?q=is%3Awasm-ready
[pub.dev]: {{site.pub}}
