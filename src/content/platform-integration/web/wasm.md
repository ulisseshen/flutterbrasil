---
ia-translate: true
title: Suporte para WebAssembly (Wasm)
description: >-
  Status atual do suporte do Flutter para WebAssembly (Wasm).
short-title: Wasm
last-update: 6 de nov de 2024
---

O Flutter e o Dart suportam
[WebAssembly](https://webassembly.org/)
como um alvo de compilação ao construir
aplicativos para a web.

[`stable`]: {{site.github}}/flutter/flutter/blob/master/docs/releases/Flutter-build-release-channels.md#stable
[`package:web`]: {{site.pub-pkg}}/web
[`dart:js_interop`]: {{site.dart.api}}/{{site.dart.sdk.channel}}/dart-js_interop

## Primeiros passos

Para experimentar um aplicativo web Flutter pré-construído usando Wasm, confira
o [aplicativo de demonstração Wonderous](https://wonderous.app/web/).

Para experimentar o Wasm em seus próprios aplicativos, siga os seguintes passos.

### Mude para a versão mais recente do Flutter

Mude para a versão 3.24 ou superior do Flutter
para executar e compilar aplicativos Flutter para WebAssembly.
Para garantir que você está executando a versão mais recente, execute `flutter upgrade`.

### Certifique-se de que as dependências do seu aplicativo são compatíveis

Experimente o [aplicativo de exemplo][] do template padrão,
ou escolha qualquer aplicativo Flutter
que tenha sido migrado para ser
[compatível com Wasm](#js-interop-wasm).

[aplicativo de exemplo]: /get-started/test-drive

### Modifique a página index

Certifique-se de que o `web/index.html` do seu aplicativo esteja atualizado para a
[inicialização mais recente do aplicativo web Flutter][] para Flutter 3.22 e posterior.

Se você quiser usar o padrão, exclua o conteúdo do diretório `web/`
e execute o seguinte comando para regenerá-los:

```console
$ flutter create . --platforms web
```

[inicialização mais recente do aplicativo web Flutter]: /platform-integration/web/initialization

### Execute ou compile seu aplicativo

Para executar o aplicativo com Wasm para desenvolvimento ou teste,
use o sinalizador `--wasm` com o comando `flutter run`.

```console
$ flutter run -d chrome --wasm
```

Para construir um aplicativo web com Wasm, adicione o sinalizador `--wasm` ao
comando existente `flutter build web`.

```console
$ flutter build web --wasm
```

O comando produz saída no diretório `build/web` relativo à raiz do
pacote, assim como `flutter build web`.

### Abra o aplicativo em um navegador compatível
Mesmo com o sinalizador `--wasm`, o Flutter ainda compilará o aplicativo para
JavaScript. Se o suporte a WasmGC não for detectado em tempo de execução, a saída
JavaScript será usada para que o aplicativo continue funcionando em todos os
principais navegadores.

Você pode verificar se o aplicativo está realmente executando com Wasm verificando a
variável de ambiente `dart2wasm`, definida durante a compilação (preferencial).

```dart
const isRunningWithWasm = bool.fromEnvironment('dart.tool.dart2wasm');
```

Alternativamente, você pode usar diferenças nas representações de números
para testar se a representação de número nativo (Wasm) está sendo usada.

```dart
final isRunningWithWasm = identical(double.nan, double.nan);
```

### Sirva a saída construída com um servidor HTTP

O Flutter web WebAssembly usa várias threads para renderizar seu aplicativo
mais rápido, com menos travamentos. Para fazer isso, o Flutter usa recursos
avançados do navegador que exigem cabeçalhos de resposta HTTP específicos.

:::warning
Aplicativos web Flutter não serão executados com WebAssembly a menos que o
servidor esteja configurado para enviar cabeçalhos HTTP específicos.
:::

| Nome | Valor |
|-|-|
| `Cross-Origin-Embedder-Policy` | `credentialless` <br> ou <br> `require-corp` |
| `Cross-Origin-Opener-Policy` | `same-origin` |

{:.table}

Para saber mais sobre esses cabeçalhos, confira
[Carregue recursos de origem cruzada sem cabeçalhos CORP usando COEP: sem credenciais][coep].

[coep]: https://developer.chrome.com/blog/coep-credentialless-origin-trial

## Saiba mais sobre a compatibilidade do navegador
Para executar um aplicativo Flutter que foi compilado para Wasm,
você precisa de um navegador que suporte [WasmGC][].

[Chromium and V8][] suportam WasmGC desde a versão 119.
O Chrome no iOS usa o WebKit, que ainda não [suporta WasmGC][].
O Firefox anunciou suporte estável para WasmGC no Firefox 120,
mas atualmente não funciona devido a uma limitação conhecida (veja detalhes abaixo).

[WasmGC]: {{site.github}}/WebAssembly/gc/tree/main/proposals/gc
[Chromium and V8]: https://chromestatus.com/feature/6062715726462976
[support WasmGC]: https://bugs.webkit.org/show_bug.cgi?id=247394
[issue]: https://bugzilla.mozilla.org/show_bug.cgi?id=1788206

- **Por que não o Firefox?**
  As versões 120 e posteriores do Firefox eram capazes de executar o Flutter/Wasm, mas
  estão enfrentando um bug que está bloqueando a compatibilidade com o renderizador Wasm
  do Flutter. Siga [este bug][firefox-bug] para mais detalhes.
- **Por que não o Safari?**
  O Safari agora suporta WasmGC, mas está enfrentando um bug semelhante que está
  bloqueando a compatibilidade com o renderizador Wasm do Flutter.
  Siga [este bug][safari-bug] para mais detalhes.

[firefox-bug]: https://bugzilla.mozilla.org/show_bug.cgi?id=1788206
[safari-bug]: https://bugs.webkit.org/show_bug.cgi?id=267291

:::warning
O Flutter compilado para Wasm não pode ser executado na versão iOS de nenhum
navegador. Todos os navegadores no iOS são obrigados a usar o WebKit,
e não podem usar seu próprio mecanismo de navegador.
:::

## Usando bibliotecas JS interop compatíveis {:#js-interop-wasm}

Para oferecer suporte à compilação para Wasm, o Dart mudou
como ele habilita a interoperação com o navegador e as APIs JavaScript.
Isso impede que o código Dart que usa `dart:html` ou `package:js`
seja compilado para Wasm.

Em vez disso, o Dart agora fornece novas soluções de interoperação leves, construídas em torno
da interoperação JS estática:

- [`package:web`][], que substitui `dart:html` (e outras bibliotecas da web)
- [`dart:js_interop`][], que substitui `package:js` e `dart:js`

Para saber mais sobre a interoperação JS no Dart,
veja a página de documentação [JS interop][] do Dart.

[`package:url_launcher`]: {{site.pub-pkg}}/url_launcher
[`package:web` migration guide]: {{site.dart-site}}/interop/js-interop/package-web
[JS interop]: {{site.dart-site}}/interop/js-interop
[`wasm-ready`]: {{site.pub-pkg}}?q=is%3Awasm-ready
[pub.dev]: {{site.pub}}
