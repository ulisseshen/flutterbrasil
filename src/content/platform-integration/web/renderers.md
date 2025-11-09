---
ia-translate: true
title: Renderizadores web
description: Escolhendo modos de build e renderizadores para um app web Flutter.
---

Flutter web oferece dois _modos de build_, e dois _renderizadores_.
Os dois modos de build são o **padrão** e **WebAssembly**,
e os dois renderizadores são **canvaskit** e **skwasm**.

Flutter escolhe o modo de build ao compilar o app,
e determina quais renderizadores estão disponíveis em tempo de execução.

Para uma build padrão,
Flutter escolhe o renderizador `canvaskit` em tempo de execução.
Para uma build WebAssembly,
Flutter escolhe o renderizador `skwasm` em tempo de execução,
e faz fallback para `canvaskit` se o navegador não suportar `skwasm`.

## Modos de build

### Modo de build padrão

Flutter escolhe o modo padrão quando os
comandos `flutter run` ou `flutter build web` são
usados sem passar `--wasm`, ou quando passando `--no-wasm`.

Este modo de build usa apenas o renderizador `canvaskit`.

Para executar em Chrome usando o modo de build padrão:

```console
flutter run -d chrome
```

Para compilar seu app para lançamento usando o modo de build padrão:

```console
flutter build web
```

### Modo de build WebAssembly

Este modo é habilitado passando `--wasm` para os comandos `flutter run` e
`flutter build web`.

Este modo torna tanto `skwasm` quanto `canvaskit` disponíveis. `skwasm` requer
[WasmGC][WasmGC], que ainda não é suportado por todos os navegadores modernos.
Portanto, em tempo de execução o Flutter escolhe `skwasm` se a coleta de lixo é
suportada, e faz fallback para `canvaskit` se não. Isso permite que apps compilados no
modo WebAssembly ainda sejam executados em todos os navegadores modernos.

A flag `--wasm` não é suportada por plataformas não-web.

Para executar em Chrome usando o modo WebAssembly:

```console
flutter run -d chrome --wasm
```

Para compilar seu app para lançamento usando o modo WebAssembly:

```console
flutter build web --wasm
```

## Renderizadores {:#renderers}

Flutter tem dois renderizadores (`canvaskit` e `skwasm`)
que reimplementam o engine Flutter para rodar no navegador.
O renderizador converte primitivas de UI (armazenadas como objetos `Scene`) em
pixels.

### canvaskit

O renderizador `canvaskit` é compatível com todos os navegadores modernos, e é o
renderizador que é usado no modo de build _padrão_.

Ele inclui uma cópia do Skia compilada para WebAssembly, que adiciona
cerca de 1,5MB em tamanho de download.

### skwasm

O renderizador `skwasm` é uma versão mais compacta do Skia
que é compilada para WebAssembly e suporta renderização em uma thread separada.

Este renderizador deve ser usado com o modo de build _WebAssembly_,
que compila o código Dart para WebAssembly.

Para aproveitar múltiplas threads,
o servidor web deve atender aos [requisitos de segurança do SharedArrayBuffer][SharedArrayBuffer security requirements].
Neste modo,
Flutter usa um [web worker][web worker] dedicado para descarregar parte da carga de
renderização para uma thread separada,
aproveitando múltiplos núcleos de CPU.
Se o navegador não atender a esses requisitos,
o renderizador `skwasm` executa em uma configuração de thread única.

Este renderizador inclui uma versão mais compacta do Skia compilada para WebAssembly,
adicionando cerca de 1,1MB em tamanho de download.

## Escolhendo um renderizador em tempo de execução

Por padrão, ao compilar no modo WebAssembly, Flutter decidirá quando usar
`skwasm`, e quando fazer fallback para `canvaskit`. Isso pode ser sobrescrito
passando um objeto de configuração para o loader, da seguinte forma:

 1. Compile o app com a flag `--wasm` para tornar ambos os renderizadores `skwasm` e `canvaskit`
    disponíveis para o app.
 1. Configure a inicialização personalizada do app web conforme descrito em
    [Escrever um `flutter_bootstrap.js` personalizado][custom-bootstrap].
 1. Prepare um objeto de configuração com a propriedade `renderer` definida como
    `"canvaskit"` ou `"skwasm"`.
 1. Passe seu objeto config preparado como a propriedade `config` de
    um novo objeto para o método `_flutter.loader.load` que é
    fornecido pelo código injetado anteriormente.

Exemplo:

```html highlightLines=9-14
<body>
  <script>
    {% raw %}{{flutter_js}}{% endraw %}
    {% raw %}{{flutter_build_config}}{% endraw %}

    // TODO: Replace this with your own code to determine which renderer to use.
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

O renderizador web não pode ser alterado depois de chamar o método `load`. Portanto,
quaisquer decisões sobre qual renderizador usar devem ser tomadas antes de chamar
`_flutter.loader.load`.

[custom-bootstrap]: /platform-integration/web/initialization#custom-bootstrap-js
[customizing-web-init]: /platform-integration/web/initialization

## Escolhendo qual modo de build usar

Para compilar Dart para WebAssembly,
seu app e seus plugins / pacotes devem atender aos seguintes requisitos:

- **Usar nova JS Interop** -
  O código deve usar apenas a nova biblioteca de interop JS `dart:js_interop`. O estilo antigo
  `dart:js`, `dart:js_util`, e `package:js` não são mais suportados.
- **Usar novas Web APIs** -
  Código usando Web APIs deve usar o novo `package:web` em vez de `dart:html`.
- **Compatibilidade de números** -
  WebAssembly implementa os tipos numéricos do Dart `int` e `double` exatamente da
  mesma forma que a Dart VM. Em JavaScript esses tipos são emulados usando o
  tipo `Number` do JS. É possível que seu código acidental ou propositalmente
  dependa do comportamento JS para números. Se for o caso, tal código precisa ser atualizado para
  se comportar corretamente com o comportamento da Dart VM.

Use estas dicas para decidir qual modo usar:

* **Suporte de pacotes** - Escolha o modo padrão se seu app depende de plugins e pacotes que ainda
  não suportam WebAssembly.
* **Performance** -
  Escolha o modo WebAssembly se o código do seu app e pacotes são compatíveis
  com WebAssembly e a performance do app é importante. `skwasm` tem notavelmente
  melhor tempo de inicialização do app e performance de frames comparado ao `canvaskit`.
  `skwasm` é particularmente eficaz no modo multi-threaded, então considere
  configurar o servidor de forma que ele atenda aos
  [requisitos de segurança do SharedArrayBuffer][SharedArrayBuffer security requirements].

[canvaskit]: https://skia.org/docs/user/modules/canvaskit/
[file an issue]: {{site.repo.flutter}}/issues/new?title=[web]:+%3Cdescribe+issue+here%3E&labels=%E2%98%B8+platform-web&body=Describe+your+issue+and+include+the+command+you%27re+running,+flutter_web%20version,+browser+version
[web worker]: https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API
[WasmGC]: https://developer.chrome.com/blog/wasmgc
[SharedArrayBuffer security requirements]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/SharedArrayBuffer#security_requirements
