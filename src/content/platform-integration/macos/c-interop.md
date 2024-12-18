---
ia-translate: true
title: "Vinculando ao código nativo do macOS usando dart:ffi"
description: "Para usar código C em seu programa Flutter, use a biblioteca dart:ffi."
---

<?code-excerpt path-base="platform_integration"?>

Aplicativos Flutter para mobile e desktop podem usar a biblioteca
[dart:ffi][] para chamar APIs C nativas.
_FFI_ significa [_foreign function interface._][FFI]
Outros termos para funcionalidades semelhantes incluem
_interface nativa_ e _language bindings._

:::note
Esta página descreve o uso da biblioteca `dart:ffi`
em aplicativos desktop macOS.
Para obter informações sobre Android, consulte
[Vinculando ao código nativo do Android usando dart:ffi][android-ffi].
Para obter informações sobre iOS, consulte
[Vinculando ao código nativo do iOS usando dart:ffi][ios-ffi].
Este recurso ainda não é suportado para plugins da web.
:::

[android-ffi]: /platform-integration/android/c-interop
[ios-ffi]: /platform-integration/ios/c-interop
[dart:ffi]: {{site.dart.api}}/dart-ffi/dart-ffi-library.html
[FFI]: https://en.wikipedia.org/wiki/Foreign_function_interface

Antes que sua biblioteca ou programa possa usar a biblioteca FFI
para vincular ao código nativo, você deve garantir que o
código nativo esteja carregado e seus símbolos estejam visíveis para o Dart.
Esta página se concentra na compilação, empacotamento,
e carregamento de código nativo macOS dentro de um plugin ou aplicativo Flutter.

Este tutorial demonstra como empacotar
fontes C/C++ em um plugin Flutter e vincular a eles usando
a biblioteca Dart FFI no macOS.
Neste passo a passo, você criará uma função C
que implementa a adição de 32 bits e, em seguida,
a expõe por meio de um plugin Dart chamado "native_add".

## Vinculação dinâmica vs. estática

Uma biblioteca nativa pode ser vinculada a um aplicativo
dinamicamente ou estaticamente. Uma biblioteca vinculada estaticamente
é incorporada à imagem executável do aplicativo,
e é carregada quando o aplicativo é iniciado.

Os símbolos de uma biblioteca vinculada estaticamente podem ser
carregados usando `DynamicLibrary.executable` ou
`DynamicLibrary.process`.

Uma biblioteca vinculada dinamicamente, por outro lado, é distribuída
em um arquivo ou pasta separado dentro do aplicativo,
e carregada sob demanda. No macOS, a biblioteca vinculada
dinamicamente é distribuída como uma pasta `.framework`.

Uma biblioteca vinculada dinamicamente pode ser carregada no
Dart usando `DynamicLibrary.open`.

A documentação da API está disponível na
[Documentação de referência da API do Dart][].

[Documentação de referência da API do Dart]: {{site.dart.api}}

## Crie um plugin FFI

Se você já tem um plugin, pule esta etapa.

Para criar um plugin chamado "native_add",
faça o seguinte:

```console
$ flutter create --platforms=macos --template=plugin_ffi native_add
$ cd native_add
```

:::note
Você pode excluir da opção `--platforms` as plataformas para as quais você não deseja
construir. No entanto, você precisa incluir a plataforma do
dispositivo em que você está testando.
:::

Isso criará um plugin com fontes C/C++ em `native_add/src`.
Essas fontes são construídas pelos arquivos de construção nativos nos vários
diretórios de construção do sistema operacional.

A biblioteca FFI só pode ser vinculada a símbolos C,
então em C++ esses símbolos são marcados como `extern "C"`.

Você também deve adicionar atributos para indicar que os
símbolos são referenciados pelo Dart,
para evitar que o vinculador descarte os símbolos
durante a otimização em tempo de vinculação.
`__attribute__((visibility("default"))) __attribute__((used))`.

No iOS, o arquivo `native_add/macos/native_add.podspec` vincula o código.

O código nativo é invocado do Dart em `lib/native_add_bindings_generated.dart`.

As ligações são geradas com [package:ffigen]({{site.pub-pkg}}/ffigen).

## Outros casos de uso

### iOS e macOS

Bibliotecas vinculadas dinamicamente são carregadas automaticamente pelo
vinculador dinâmico quando o aplicativo é iniciado. Seus símbolos
constituintes podem ser resolvidos usando [`DynamicLibrary.process`][].
Você também pode obter um identificador para a biblioteca com
[`DynamicLibrary.open`][] para restringir o escopo da
resolução de símbolos, mas não está claro como o
processo de revisão da Apple lida com isso.

Símbolos vinculados estaticamente ao binário do aplicativo
podem ser resolvidos usando [`DynamicLibrary.executable`][] ou
[`DynamicLibrary.process`][].

[`DynamicLibrary.executable`]: {{site.dart.api}}/dart-ffi/DynamicLibrary/DynamicLibrary.executable.html
[`DynamicLibrary.open`]: {{site.dart.api}}/dart-ffi/DynamicLibrary/DynamicLibrary.open.html
[`DynamicLibrary.process`]: {{site.dart.api}}/dart-ffi/DynamicLibrary/DynamicLibrary.process.html

#### Biblioteca da plataforma

Para vincular a uma biblioteca da plataforma,
use as seguintes instruções:

1. No Xcode, abra `Runner.xcworkspace`.
1. Selecione a plataforma de destino.
1. Clique em **+** na seção **Linked Frameworks and Libraries**.
1. Selecione a biblioteca do sistema para vincular.

#### Biblioteca primária

Uma biblioteca nativa primária pode ser incluída
como fonte ou como um arquivo `.framework` (assinado).
Provavelmente também é possível incluir
arquivos vinculados estaticamente, mas isso requer testes.

#### Código fonte

Para vincular diretamente ao código-fonte,
use as seguintes instruções:

1. No Xcode, abra `Runner.xcworkspace`.
2. Adicione os arquivos de origem C/C++/Objective-C/Swift
    ao projeto Xcode.
3. Adicione o seguinte prefixo às
    declarações de símbolos exportados para garantir que eles
    estejam visíveis para o Dart:

    **C/C++/Objective-C**

    ```objc
    extern "C" /* <= C++ only */ __attribute__((visibility("default"))) __attribute__((used))
    ```

    **Swift**

    ```swift
    @_cdecl("myFunctionName")
    ```

#### Biblioteca compilada (dinâmica)

Para vincular a uma biblioteca dinâmica compilada,
use as seguintes instruções:

1. Se um arquivo `Framework` devidamente assinado estiver presente,
   abra `Runner.xcworkspace`.
1. Adicione o arquivo de estrutura à seção **Embedded Binaries**.
1. Adicione-o também à seção **Linked Frameworks & Libraries**
   do destino no Xcode.

#### Biblioteca compilada (dinâmica) (macOS)

Para adicionar uma biblioteca de código fechado a um
aplicativo [Flutter macOS Desktop][],
use as seguintes instruções:

1. Siga as instruções para Flutter desktop para criar
   um aplicativo Flutter desktop.
1. Abra o `yourapp/macos/Runner.xcworkspace` no Xcode.
   1. Arraste sua biblioteca pré-compilada (`libyourlibrary.dylib`)
      para `Runner/Frameworks`.
   1. Clique em `Runner` e vá para a guia `Build Phases`.
      1. Arraste `libyourlibrary.dylib` para a
         lista `Copy Bundle Resources`.
      1. Em `Embed Libraries`, marque `Code Sign on Copy`.
      1. Em `Link Binary With Libraries`,
         defina o status como `Optional`. (Usamos vinculação dinâmica,
         não há necessidade de vincular estaticamente.)
   1. Clique em `Runner` e vá para a guia `General`.
      1. Arraste `libyourlibrary.dylib` para a lista **Frameworks,
         Libraries and Embedded Content**.
      1. Selecione **Embed & Sign**.
   1. Clique em **Runner** e vá para a guia **Build Settings**.
      1. Na seção **Search Paths**, configure o
         **Library Search Paths** para incluir o caminho
         onde `libyourlibrary.dylib` está localizado.
1. Edite `lib/main.dart`.
   1. Use `DynamicLibrary.open('libyourlibrary.dylib')`
      para vincular dinamicamente aos símbolos.
   1. Chame sua função nativa em algum lugar em um widget.
1. Execute `flutter run` e verifique se sua função nativa é chamada.
1. Execute `flutter build macos` para construir uma
   versão de lançamento independente do seu aplicativo.

[Flutter macOS Desktop]: /platform-integration/macos/building

{% comment %}

#### Biblioteca de código aberto de terceiros

Para criar um plugin Flutter que inclui
código C/C++/Objective-C _e_ Dart,
use as seguintes instruções:

1. Em seu projeto de plugin,
   abra `macos/<myproject>.podspec`.
1. Adicione o código nativo ao
   campo `source_files`.

O código nativo é então vinculado estaticamente ao
binário do aplicativo de qualquer aplicativo que use
este plugin.

#### Biblioteca de código fechado de terceiros

Para criar um plugin Flutter que inclui
código-fonte Dart, mas distribui a biblioteca C/C++
em formato binário, use as seguintes instruções:

1. Em seu projeto de plugin,
   abra `macos/<myproject>.podspec`.
1. Adicione um campo `vendored_frameworks`.
   Veja o [exemplo do CocoaPods][].

:::warning
**Não** carregue este plugin
(ou qualquer plugin contendo código binário) para pub.dev.
Em vez disso, este plugin deve ser baixado
de um terceiro confiável,
como mostrado no exemplo do CocoaPods.
:::

[CocoaPods example]: {{site.github}}/CocoaPods/CocoaPods/blob/master/examples/Vendored%20Framework%20Example/Example%20Pods/VendoredFrameworkExample.podspec

## Removendo símbolos do macOS

Ao criar um arquivo de lançamento (IPA),
os símbolos são removidos pelo Xcode.

1. No Xcode, vá para **Target Runner > Build Settings > Strip Style**.
2. Mude de **All Symbols** para **Non-Global Symbols**.

{% endcomment %}

{% include docs/resource-links/ffi-video-resources.md %}
