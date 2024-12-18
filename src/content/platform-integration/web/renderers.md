---
ia-translate: true
title: Renderizadores Web
description: Escolhendo modos de build e renderizadores para um aplicativo Flutter web.
---

O Flutter web oferece dois _modos de build_ e dois _renderizadores_.
Os dois modos de build são o **padrão** e o **WebAssembly**,
e os dois renderizadores são **canvaskit** e **skwasm**.

O Flutter escolhe o modo de build ao construir o aplicativo,
e determina quais renderizadores estão disponíveis em tempo de execução.

Para um build padrão,
o Flutter escolhe o renderizador `canvaskit` em tempo de execução.
Para um build WebAssembly,
o Flutter escolhe o renderizador `skwasm` em tempo de execução,
e volta para `canvaskit` se o navegador não suportar `skwasm`.

## Modos de build

### Modo de build padrão

O Flutter escolhe o modo padrão quando os comandos
`flutter run` ou `flutter build web` são
usados sem passar `--wasm`, ou ao passar `--no-wasm`.

Este modo de build usa apenas o renderizador `canvaskit`.

Para executar no Chrome usando o modo de build padrão:

```console
flutter run -d chrome
```

Para construir seu aplicativo para lançamento usando o modo de build padrão:

```console
flutter build web
```

### Modo de build WebAssembly

Este modo é habilitado passando `--wasm` para os comandos `flutter run` e
`flutter build web`.

Este modo torna tanto `skwasm` quanto `canvaskit` disponíveis. `skwasm` requer
[WasmGC][], que ainda não é suportado por todos os navegadores modernos.
Portanto, em tempo de execução, o Flutter escolhe `skwasm` se a coleta de lixo
for suportada e volta para `canvaskit` caso contrário. Isso permite que aplicativos compilados no
modo WebAssembly ainda sejam executados em todos os navegadores modernos.

A flag `--wasm` não é suportada por plataformas não-web.

Para executar no Chrome usando o modo WebAssembly:

```console
flutter run -d chrome --wasm
```

Para construir seu aplicativo para lançamento usando o modo WebAssembly:

```console
flutter build web --wasm
```

## Renderizadores

O Flutter possui dois renderizadores (`canvaskit` e `skwasm`)
que reimplementam o motor do Flutter para rodar no navegador.
O renderizador converte primitivas da UI (armazenadas como objetos `Scene`) em
pixels.

### canvaskit

O renderizador `canvaskit` é compatível com todos os navegadores modernos, e é o
renderizador que é usado no modo de build _padrão_.

Ele inclui uma cópia do Skia compilada para WebAssembly, o que adiciona
cerca de 1,5 MB no tamanho do download.

### skwasm

O renderizador `skwasm` é uma versão mais compacta do Skia
que é compilada para WebAssembly e suporta a renderização em uma thread separada.

Este renderizador deve ser usado com o modo de build _WebAssembly_,
que compila o código Dart para WebAssembly.

Para aproveitar várias threads,
o servidor web deve atender aos [requisitos de segurança do SharedArrayBuffer][].
Neste modo,
o Flutter usa um [web worker][] dedicado para descarregar parte da carga de
trabalho de renderização para uma thread separada,
aproveitando vários núcleos da CPU.
Se o navegador não atender a esses requisitos,
o renderizador `skwasm` é executado em uma configuração de thread único.

Este renderizador inclui uma versão mais compacta do Skia compilada para WebAssembly,
adicionando cerca de 1,1 MB no tamanho do download.

## Escolhendo um renderizador em tempo de execução

Por padrão, ao construir no modo WebAssembly, o Flutter decidirá quando
usar `skwasm` e quando voltar para `canvaskit`. Isso pode ser substituído passando
um objeto de configuração para o carregador, da seguinte forma:

 1. Construa o aplicativo com a flag `--wasm` para tornar os renderizadores
    `skwasm` e `canvaskit` disponíveis para o aplicativo.
 1. Configure a inicialização personalizada do aplicativo web conforme descrito em
    [Escreva um `flutter_bootstrap.js` personalizado][custom-bootstrap].
 1. Prepare um objeto de configuração com a propriedade `renderer` definida como
    `"canvaskit"` ou `"skwasm"`.
 1. Passe seu objeto de configuração preparado como a propriedade `config` de
    um novo objeto para o método `_flutter.loader.load` que é
    fornecido pelo código injetado anteriormente.

Exemplo:

```html highlightLines=9-14
<body>
  <script>
    {% raw %}{{flutter_js}}{% endraw %}
    {% raw %}{{flutter_build_config}}{% endraw %}

    // TODO: Substitua isso pelo seu próprio código para determinar qual renderizador usar.
    const useCanvasKit = true;

    const config = {
      renderer: useCanvasKit ? "canvaskit" : "skwasm",
    };
    _flutter.loader.load({
      config: config,
    });
  </script>
</body>
```

O renderizador web não pode ser alterado após chamar o método `load`. Portanto,
quaisquer decisões sobre qual renderizador usar devem ser tomadas antes de chamar
`_flutter.loader.load`.

[custom-bootstrap]: /platform-integration/web/initialization#custom-bootstrap-js
[customizing-web-init]: /platform-integration/web/initialization

## Escolhendo qual modo de build usar

Para compilar Dart para WebAssembly,
seu aplicativo e seus plugins / packages devem atender aos seguintes requisitos:

- **Use o novo JS Interop** -
  O código deve usar apenas a nova biblioteca JS interop `dart:js_interop`. Os
  estilos antigos `dart:js`, `dart:js_util` e `package:js` não são mais suportados.
- **Use novas APIs Web** -
  O código que usa APIs da Web deve usar o novo `package:web` em vez de
  `dart:html`.
- **Compatibilidade de números** -
  WebAssembly implementa os tipos numéricos do Dart `int` e `double` exatamente
  como a VM do Dart. Em JavaScript, esses tipos são emulados usando o tipo JS
  `Number`. É possível que seu código, acidentalmente ou propositalmente,
  dependa do comportamento JS para números. Se for esse o caso, esse código
  precisa ser atualizado para se comportar corretamente com o comportamento da VM
  do Dart.

Use estas dicas para decidir qual modo usar:

* **Suporte a packages** - Escolha o modo padrão se seu aplicativo depender de plugins e packages que
  ainda não suportam WebAssembly.
* **Performance** -
  Escolha o modo WebAssembly se o código e packages do seu aplicativo forem
  compatíveis com WebAssembly e o desempenho do aplicativo for importante.
  `skwasm` tem um tempo de inicialização do aplicativo e desempenho de frame
  notavelmente melhores em comparação com `canvaskit`.
  `skwasm` é particularmente eficaz no modo multithread, então considere
  configurar o servidor para que ele atenda aos
  [requisitos de segurança do SharedArrayBuffer][].

[canvaskit]: https://skia.org/docs/user/modules/canvaskit/
[file an issue]: {{site.repo.flutter}}/issues/new?title=[web]:+%3Cdescreva+o+problema+aqui%3E&labels=%E2%98%B8+platform-web&body=Descreva+seu+problema+e+inclua+o+comando+que+voc%C3%AA+est%C3%A1+executando,+flutter_web%20vers%C3%A3o,+vers%C3%A3o+do+navegador
[web worker]: https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API
[WasmGC]: https://developer.chrome.com/blog/wasmgc
[SharedArrayBuffer security requirements]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/SharedArrayBuffer#security_requirements
