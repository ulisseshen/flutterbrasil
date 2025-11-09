---
ia-translate: true
title: Suporte para WebAssembly (Wasm)
description: >-
  Estado atual do suporte do Flutter para WebAssembly (Wasm).
shortTitle: Wasm
last-update: Nov 6, 2024
---

Flutter e Dart suportam
[WebAssembly](https://webassembly.org/)
como alvo de compilação ao construir
aplicações para a web.

[`stable`]: {{site.github}}/flutter/flutter/blob/master/docs/releases/Flutter-build-release-channels.md#stable
[`package:web`]: {{site.pub-pkg}}/web
[`dart:js_interop`]: {{site.dart.api}}/dart-js_interop/dart-js_interop-library.html

## Começando

Para testar um app web Flutter pré-construído usando Wasm, confira o
[app de demonstração Wonderous](https://wonderous.app/web/).

Para experimentar Wasm em seus próprios apps, use os seguintes passos.

### Mudar para a versão mais recente do Flutter

Mude para a versão 3.24 ou superior do Flutter
para executar e compilar aplicações Flutter para WebAssembly.
Para garantir que você está executando a versão mais recente, execute `flutter upgrade`.

### Garantir que as dependências do seu app são compatíveis

Experimente o [app de exemplo][sample app] do template padrão,
ou escolha qualquer aplicação Flutter
que foi migrada para ser
[compatível com Wasm](#js-interop-wasm).

[sample app]: /reference/create-new-app

### Modificar a página index

Certifique-se de que o `web/index.html` do seu app esteja atualizado para a
[inicialização de app web Flutter][Flutter web app initialization] mais recente para Flutter 3.22 e posterior.

Se você quiser usar o padrão, exclua o conteúdo do diretório `web/`
e execute o seguinte comando para regenerá-los:

```console
$ flutter create . --platforms web
```

[Flutter web app initialization]: /platform-integration/web/initialization

### Executar ou compilar seu app

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

### Abrir o app em um navegador web compatível
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

### Servir a saída construída com um servidor HTTP

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

## Saiba mais sobre compatibilidade de navegadores
Para executar um app Flutter que foi compilado para Wasm,
você precisa de um navegador que suporte [WasmGC][WasmGC].

[Chromium e V8][Chromium and V8] suportam WasmGC desde a versão 119.
Chrome no iOS usa WebKit, que ainda não [suporta WasmGC][support WasmGC].
Firefox anunciou suporte estável para WasmGC no Firefox 120,
mas atualmente não funciona devido a uma limitação conhecida (veja detalhes abaixo).

[WasmGC]: {{site.github}}/WebAssembly/gc/tree/main/proposals/gc
[Chromium and V8]: https://chromestatus.com/feature/6062715726462976
[support WasmGC]: https://bugs.webkit.org/show_bug.cgi?id=247394
[issue]: https://bugzilla.mozilla.org/show_bug.cgi?id=1788206

- **Por que não Firefox?**
  Firefox versões 120 e posteriores eram anteriormente capazes de executar Flutter/Wasm, mas
  estão enfrentando um bug que está bloqueando a compatibilidade com o renderizador
  Wasm do Flutter. Acompanhe [este bug][firefox-bug] para detalhes.
- **Por que não Safari?**
  Safari agora suporta WasmGC, mas está enfrentando um bug semelhante que está
  bloqueando a compatibilidade com o renderizador Wasm do Flutter.
  Acompanhe [este bug][safari-bug] para detalhes.

[firefox-bug]: https://bugzilla.mozilla.org/show_bug.cgi?id=1788206
[safari-bug]: https://bugs.webkit.org/show_bug.cgi?id=267291

:::warning
Flutter compilado para Wasm não pode executar na versão iOS de nenhum navegador.
Todos os navegadores no iOS são obrigados a usar WebKit,
e não podem usar seu próprio engine de navegador.
:::

## Usando bibliotecas de JS interop compatíveis {:#js-interop-wasm}

Para suportar compilação para Wasm, Dart mudou
como habilita interop com APIs de navegador e JavaScript.
Isso impede que código Dart que usa `dart:html` ou `package:js`
seja compilado para Wasm.

Em vez disso, Dart agora fornece novas soluções de interop leves construídas em torno
de JS interop estático:

- [`package:web`][`package:web`], que substitui `dart:html` (e outras bibliotecas web)
- [`dart:js_interop`][`dart:js_interop`], que substitui `package:js` e `dart:js`

Para saber mais sobre JS interop no Dart,
consulte a página de documentação [JS interop][JS interop] do Dart.

[`package:url_launcher`]: {{site.pub-pkg}}/url_launcher
[`package:web` migration guide]: {{site.dart-site}}/interop/js-interop/package-web
[JS interop]: {{site.dart-site}}/interop/js-interop
[`wasm-ready`]: {{site.pub-pkg}}?q=is%3Awasm-ready
[pub.dev]: {{site.pub}}
