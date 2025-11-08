---
ia-translate: true
title: Suporte para WebAssembly (Wasm)
description: >-
  Status atual do suporte do Flutter para WebAssembly (Wasm).
short-title: Wasm
last-update: Nov 6, 2024
---

Flutter e Dart suportam
[WebAssembly](https://webassembly.org/)
como um target de compilação ao construir
aplicações para a web.

[`stable`]: {{site.github}}/flutter/flutter/blob/master/docs/releases/Flutter-build-release-channels.md#stable
[`package:web`]: {{site.pub-pkg}}/web
[`dart:js_interop`]: {{site.dart.api}}/{{site.dart.sdk.channel}}/dart-js_interop/dart-js_interop-library.html

## Comece

Para experimentar um app Flutter web pré-construído usando Wasm, confira o
[app de demo Wonderous](https://wonderous.app/web/).

Para experimentar com Wasm em seus próprios apps, use as seguintes etapas.

### Mude para a versão mais recente do Flutter

Mude para o Flutter versão 3.24 ou superior
para executar e compilar aplicações Flutter para WebAssembly.
Para garantir que você está executando a versão mais recente, execute `flutter upgrade`.

### Garanta que as dependências do seu app sejam compatíveis

Experimente o [app de exemplo][sample app] do template padrão,
ou escolha qualquer aplicação Flutter
que foi migrada para ser
[compatível com Wasm](#js-interop-wasm).

[sample app]: /get-started/test-drive

### Modifique a página index

Certifique-se de que o `web/index.html` do seu app esteja atualizado para a
[inicialização de app Flutter web][Flutter web app initialization] mais recente para Flutter 3.22 e posterior.

Se você quiser usar o padrão, exclua o conteúdo do diretório `web/`
e execute o seguinte comando para regenerá-los:

```console
$ flutter create . --platforms web
```

[Flutter web app initialization]: /platform-integration/web/initialization

### Execute ou construa seu app

Para executar o app com Wasm para desenvolvimento ou teste,
use a flag `--wasm` com o comando `flutter run`.

```console
$ flutter run -d chrome --wasm
```

Para construir uma aplicação web com Wasm, adicione a flag `--wasm` ao
comando `flutter build web` existente.

```console
$ flutter build web --wasm
```

O comando produz saída no diretório `build/web` relativo à
raiz do pacote, assim como `flutter build web`.

### Abra o app em um navegador web compatível
Mesmo com a flag `--wasm`, Flutter ainda compilará a aplicação para
JavaScript. Se o suporte a WasmGC não for detectado em runtime, a saída JavaScript
é usada para que a aplicação continue funcionando em todos os principais navegadores.

Você pode verificar se o app está realmente executando com Wasm verificando a
variável de ambiente `dart2wasm`, definida durante a compilação (preferido).

```dart
const isRunningWithWasm = bool.fromEnvironment('dart.tool.dart2wasm');
```

Alternativamente, você pode usar diferenças nas representações de números
para testar se a representação nativa (Wasm) de números é usada.

```dart
final isRunningWithWasm = identical(double.nan, double.nan);
```

### Sirva a saída construída com um servidor HTTP

Flutter web WebAssembly usa múltiplas threads para renderizar sua aplicação
mais rápido, com menos jank. Para fazer isso, Flutter usa recursos avançados do navegador que
requerem headers de resposta HTTP específicos.

:::warning
Aplicações Flutter web não funcionarão com WebAssembly a menos que o servidor esteja
configurado para enviar headers HTTP específicos.
:::

| Nome | Valor |
|-|-|
| `Cross-Origin-Embedder-Policy` | `credentialless` <br> ou <br> `require-corp` |
| `Cross-Origin-Opener-Policy` | `same-origin` |

{:.table}

Para saber mais sobre esses headers, confira
[Load cross-origin resources without CORP headers using COEP: credentialless][coep].

[coep]: https://developer.chrome.com/blog/coep-credentialless-origin-trial

## Saiba mais sobre compatibilidade de navegadores
Para executar um app Flutter que foi compilado para Wasm,
você precisa de um navegador que suporte [WasmGC][].

[Chromium e V8][] suportam WasmGC desde a versão 119.
Chrome no iOS usa WebKit, que ainda não [suporta WasmGC][support WasmGC].
Firefox anunciou suporte estável para WasmGC no Firefox 120,
mas atualmente não funciona devido a uma limitação conhecida (veja detalhes abaixo).

[WasmGC]: {{site.github}}/WebAssembly/gc/tree/main/proposals/gc
[Chromium and V8]: https://chromestatus.com/feature/6062715726462976
[Chromium e V8]: https://chromestatus.com/feature/6062715726462976
[support WasmGC]: https://bugs.webkit.org/show_bug.cgi?id=247394
[issue]: https://bugzilla.mozilla.org/show_bug.cgi?id=1788206

- **Por que não Firefox?**
  Versões Firefox 120 e posteriores conseguiram executar Flutter/Wasm anteriormente, mas
  estão enfrentando um bug que está bloqueando a compatibilidade com o
  renderer Wasm do Flutter. Acompanhe [este bug][firefox-bug] para detalhes.
- **Por que não Safari?**
  Safari agora suporta WasmGC, mas está enfrentando um bug similar que está
  bloqueando a compatibilidade com o renderer Wasm do Flutter.
  Acompanhe [este bug][safari-bug] para detalhes.

[firefox-bug]: https://bugzilla.mozilla.org/show_bug.cgi?id=1788206
[safari-bug]: https://bugs.webkit.org/show_bug.cgi?id=267291

:::warning
Flutter compilado para Wasm não pode executar na versão iOS de nenhum navegador.
Todos os navegadores no iOS são obrigados a usar WebKit,
e não podem usar seu próprio engine de navegador.
:::

## Usando bibliotecas de interop JS compatíveis {:#js-interop-wasm}

Para suportar compilação para Wasm, Dart mudou
como habilita interop com APIs do navegador e JavaScript.
Isso impede que código Dart que usa `dart:html` ou `package:js`
compile para Wasm.

Em vez disso, Dart agora fornece novas soluções de interop leves construídas em torno
de static JS interop:

- [`package:web`][], que substitui `dart:html` (e outras bibliotecas web)
- [`dart:js_interop`][], que substitui `package:js` e `dart:js`

Para saber mais sobre JS interop em Dart,
veja a página de documentação [JS interop][] do Dart.

[`package:url_launcher`]: {{site.pub-pkg}}/url_launcher
[`package:web` migration guide]: {{site.dart-site}}/interop/js-interop/package-web
[JS interop]: {{site.dart-site}}/interop/js-interop
[`wasm-ready`]: {{site.pub-pkg}}?q=is%3Awasm-ready
[pub.dev]: {{site.pub}}
