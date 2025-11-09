---
ia-translate: true
title: "Vinculação a código iOS nativo usando dart:ffi"
description: "Para usar código C em seu programa Flutter, use a biblioteca dart:ffi."
---

<?code-excerpt path-base="platform_integration"?>

Apps Flutter para dispositivos móveis e desktop podem usar a
biblioteca [dart:ffi][dart:ffi] para chamar APIs C nativas.
_FFI_ significa [_foreign function interface._][FFI]
Outros termos para funcionalidades similares incluem
_interface nativa_ e _language bindings._

:::note
Esta página descreve o uso da biblioteca `dart:ffi`
em apps iOS. Para informações sobre Android, consulte
[Vinculação a código Android nativo usando dart:ffi][android-ffi].
Para informações sobre macOS, consulte
[Vinculação a código macOS nativo usando dart:ffi][macos-ffi].
Este recurso ainda não é suportado para plugins web.
:::

[android-ffi]: /platform-integration/android/c-interop
[macos-ffi]: /platform-integration/macos/c-interop
[dart:ffi]: {{site.dart.api}}/dart-ffi/dart-ffi-library.html
[FFI]: https://en.wikipedia.org/wiki/Foreign_function_interface

Antes que sua biblioteca ou programa possa usar a biblioteca FFI
para vincular a código nativo, você deve garantir que o
código nativo esteja carregado e seus símbolos visíveis para o Dart.
Esta página se concentra em compilar, empacotar
e carregar código iOS nativo dentro de um plugin ou app Flutter.

Este tutorial demonstra como agrupar fontes C/C++
em um plugin Flutter e vinculá-las usando
a biblioteca Dart FFI no iOS.
Neste passo a passo, você criará uma função C
que implementa adição de 32 bits e depois
a expõe através de um plugin Dart chamado "native_add".

## Dynamic vs static linking

Uma biblioteca nativa pode ser vinculada a um app de forma
dinâmica ou estática. Uma biblioteca vinculada estaticamente
é incorporada à imagem executável do app
e é carregada quando o app inicia.

Símbolos de uma biblioteca vinculada estaticamente podem ser
carregados usando `DynamicLibrary.executable` ou
`DynamicLibrary.process`.

Uma biblioteca vinculada dinamicamente, por outro lado, é distribuída
em um arquivo ou pasta separada dentro do app,
e carregada sob demanda. No iOS, a biblioteca vinculada dinamicamente
é distribuída como uma pasta `.framework`.

Uma biblioteca vinculada dinamicamente pode ser carregada no
Dart usando `DynamicLibrary.open`.

A documentação da API está disponível na
[documentação de referência da API Dart][Dart API reference documentation].


[Dart API reference documentation]: {{site.dart.api}}

## Create an FFI plugin

Para criar um plugin FFI chamado "native_add",
faça o seguinte:

```console
$ flutter create --platforms=android,ios,macos,windows,linux --template=plugin_ffi native_add
$ cd native_add
```

:::note
Você pode excluir plataformas de `--platforms` para as quais não deseja
compilar. No entanto, você precisa incluir a plataforma do
dispositivo em que está testando.
:::

Isso criará um plugin com fontes C/C++ em `native_add/src`.
Essas fontes são compiladas pelos arquivos de compilação nativos nas várias
pastas de compilação do sistema operacional.

A biblioteca FFI só pode vincular símbolos C,
então em C++ esses símbolos são marcados como `extern "C"`.

Você também deve adicionar atributos para indicar que os
símbolos são referenciados pelo Dart,
para evitar que o linker descarte os símbolos
durante a otimização em tempo de link.
`__attribute__((visibility("default"))) __attribute__((used))`.

No iOS, o `native_add/ios/native_add.podspec` vincula o código.

O código nativo é invocado do dart em `lib/native_add_bindings_generated.dart`.

Os bindings são gerados com [package:ffigen]({{site.pub-pkg}}/ffigen).

## Other use cases

### iOS and macOS

Bibliotecas vinculadas dinamicamente são carregadas automaticamente pelo
linker dinâmico quando o app inicia. Seus símbolos constituintes
podem ser resolvidos usando [`DynamicLibrary.process`][`DynamicLibrary.process`].
Você também pode obter um handle para a biblioteca com
[`DynamicLibrary.open`][`DynamicLibrary.open`] para restringir o escopo de
resolução de símbolos, mas não está claro como o
processo de revisão da Apple lida com isso.

Símbolos vinculados estaticamente ao binário do aplicativo
podem ser resolvidos usando [`DynamicLibrary.executable`][`DynamicLibrary.executable`] ou
[`DynamicLibrary.process`][`DynamicLibrary.process`].


[`DynamicLibrary.executable`]: {{site.dart.api}}/dart-ffi/DynamicLibrary/DynamicLibrary.executable.html
[`DynamicLibrary.open`]: {{site.dart.api}}/dart-ffi/DynamicLibrary/DynamicLibrary.open.html
[`DynamicLibrary.process`]: {{site.dart.api}}/dart-ffi/DynamicLibrary/DynamicLibrary.process.html

#### Platform library

Para vincular a uma biblioteca de plataforma,
use as seguintes instruções:

1. No Xcode, abra `Runner.xcworkspace`.
1. Selecione a plataforma de destino.
1. Clique em **+** na seção **Linked Frameworks and Libraries**.
1. Selecione a biblioteca do sistema para vincular.

#### First-party library

Uma biblioteca nativa de primeira parte pode ser incluída como
código fonte ou como um arquivo `.framework` (assinado).
Provavelmente é possível incluir arquivos
estáticos vinculados também, mas requer testes.

#### Source code

Para vincular diretamente ao código fonte,
use as seguintes instruções:

 1. No Xcode, abra `Runner.xcworkspace`.
 2. Adicione os arquivos de código fonte C/C++/Objective-C/Swift
    ao projeto Xcode.
 3. Adicione o seguinte prefixo às
    declarações de símbolos exportados para garantir que eles
    sejam visíveis para o Dart:

    **C/C++/Objective-C**

    ```objc
    extern "C" /* <= C++ only */ __attribute__((visibility("default"))) __attribute__((used))
    ```

    **Swift**

    ```swift
    @_cdecl("myFunctionName")
    ```

#### Compiled (dynamic) library

Para vincular a uma biblioteca dinâmica compilada,
use as seguintes instruções:

1. Se um arquivo `Framework` devidamente assinado estiver presente,
   abra `Runner.xcworkspace`.
1. Adicione o arquivo framework à seção **Embedded Binaries**.
1. Adicione-o também à seção **Linked Frameworks & Libraries**
   do target no Xcode.

#### Open-source third-party library

Para criar um plugin Flutter que inclua
código C/C++/Objective-C _e_ Dart,
use as seguintes instruções:

1. No seu projeto de plugin,
   abra `ios/<myproject>.podspec`.
1. Adicione o código nativo ao campo
   `source_files`.

O código nativo é então vinculado estaticamente ao
binário do aplicativo de qualquer app que usa
este plugin.

#### Closed-source third-party library

Para criar um plugin Flutter que inclua código
fonte Dart, mas distribua a biblioteca C/C++
em formato binário, use as seguintes instruções:

1. No seu projeto de plugin,
   abra `ios/<myproject>.podspec`.
1. Adicione um campo `vendored_frameworks`.
   Consulte o [exemplo CocoaPods][CocoaPods example].

:::warning
**Não** envie este plugin
(ou qualquer plugin contendo código binário) para o pub.dev.
Em vez disso, este plugin deve ser baixado
de uma fonte terceira confiável,
conforme mostrado no exemplo CocoaPods.
:::

[CocoaPods example]: {{site.github}}/CocoaPods/CocoaPods/blob/master/examples/Vendored%20Framework%20Example/Example%20Pods/VendoredFrameworkExample.podspec

## Stripping iOS symbols

Ao criar um arquivo de release (IPA),
os símbolos são removidos pelo Xcode.

1. No Xcode, vá para **Target Runner > Build Settings > Strip Style**.
2. Mude de **All Symbols** para **Non-Global Symbols**.

{% render "docs/resource-links/ffi-video-resources.md", site: site %}
