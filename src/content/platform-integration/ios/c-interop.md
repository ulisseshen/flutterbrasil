---
ia-translate: true
title: "Vinculando ao código nativo iOS usando dart:ffi"
description: "Para usar código C em seu programa Flutter, use a biblioteca dart:ffi."
---

<?code-excerpt path-base="platform_integration"?>

Aplicativos Flutter para dispositivos móveis e desktop podem usar a biblioteca
[dart:ffi][] para chamar APIs C nativas. _FFI_ significa
[_interface de função estrangeira._][FFI] Outros termos para funcionalidade
semelhante incluem _interface nativa_ e _vinculações de linguagem_.

:::note
Esta página descreve o uso da biblioteca `dart:ffi` em aplicativos iOS.
Para informações sobre Android, consulte
[Vinculando ao código nativo Android usando dart:ffi][android-ffi].
Para informações sobre macOS, consulte
[Vinculando ao código nativo macOS usando dart:ffi][macos-ffi].
Este recurso ainda não é compatível com plugins da web.
:::

[android-ffi]: /platform-integration/android/c-interop
[macos-ffi]: /platform-integration/macos/c-interop
[dart:ffi]: {{site.dart.api}}/dart-ffi/dart-ffi-library.html
[FFI]: https://en.wikipedia.org/wiki/Foreign_function_interface

Antes que sua biblioteca ou programa possa usar a biblioteca FFI para vincular
ao código nativo, você deve garantir que o código nativo seja carregado e seus
símbolos estejam visíveis para o Dart. Esta página se concentra em compilar,
empacotar e carregar código nativo iOS em um plugin ou aplicativo Flutter.

Este tutorial demonstra como agrupar fontes C/C++ em um plugin Flutter e
vinculá-las usando a biblioteca Dart FFI no iOS. Neste passo a passo, você
criará uma função C que implementa a adição de 32 bits e, em seguida, a
expõe por meio de um plugin Dart chamado "native_add".

## Vinculação dinâmica vs estática

Uma biblioteca nativa pode ser vinculada a um aplicativo de forma dinâmica ou
estática. Uma biblioteca vinculada estaticamente é incorporada na imagem
executável do aplicativo e é carregada quando o aplicativo é iniciado.

Os símbolos de uma biblioteca vinculada estaticamente podem ser carregados usando
`DynamicLibrary.executable` ou `DynamicLibrary.process`.

Uma biblioteca vinculada dinamicamente, por outro lado, é distribuída em um
arquivo ou pasta separado dentro do aplicativo e carregada sob demanda. No iOS, a
biblioteca vinculada dinamicamente é distribuída como uma pasta `.framework`.

Uma biblioteca vinculada dinamicamente pode ser carregada no Dart usando
`DynamicLibrary.open`.

A documentação da API está disponível na
[documentação de referência da API Dart][].

[Dart API reference documentation]: {{site.dart.api}}

## Crie um plugin FFI

Para criar um plugin FFI chamado "native_add", faça o seguinte:

```console
$ flutter create --platforms=android,ios,macos,windows,linux --template=plugin_ffi native_add
$ cd native_add
```

:::note
Você pode excluir plataformas de `--platforms` que não deseja construir.
No entanto, você precisa incluir a plataforma do dispositivo no qual está
testando.
:::

Isso criará um plugin com fontes C/C++ em `native_add/src`. Essas fontes são
construídas pelos arquivos de construção nativos nas várias pastas de
construção do sistema operacional.

A biblioteca FFI só pode ser vinculada a símbolos C, portanto, em C++, esses
símbolos são marcados como `extern "C"`.

Você também deve adicionar atributos para indicar que os símbolos são
referenciados do Dart, para evitar que o vinculador descarte os símbolos
durante a otimização em tempo de vinculação.
`__attribute__((visibility("default"))) __attribute__((used))`.

No iOS, o `native_add/ios/native_add.podspec` vincula o código.

O código nativo é invocado do Dart em
`lib/native_add_bindings_generated.dart`.

As vinculações são geradas com [package:ffigen]({{site.pub-pkg}}/ffigen).

## Outros casos de uso

### iOS e macOS

Bibliotecas vinculadas dinamicamente são carregadas automaticamente pelo
vinculador dinâmico quando o aplicativo é iniciado. Seus símbolos
constituintes podem ser resolvidos usando [`DynamicLibrary.process`][]. Você
também pode obter um identificador para a biblioteca com [`DynamicLibrary.open`][]
para restringir o escopo da resolução de símbolos, mas não está claro como o
processo de revisão da Apple lida com isso.

Símbolos vinculados estaticamente ao binário do aplicativo podem ser resolvidos
usando [`DynamicLibrary.executable`][] ou [`DynamicLibrary.process`][].

[`DynamicLibrary.executable`]: {{site.dart.api}}/dart-ffi/DynamicLibrary/DynamicLibrary.executable.html
[`DynamicLibrary.open`]: {{site.dart.api}}/dart-ffi/DynamicLibrary/DynamicLibrary.open.html
[`DynamicLibrary.process`]: {{site.dart.api}}/dart-ffi/DynamicLibrary/DynamicLibrary.process.html

#### Biblioteca de plataforma

Para vincular a uma biblioteca de plataforma, use as seguintes instruções:

1.  No Xcode, abra `Runner.xcworkspace`.
2.  Selecione a plataforma de destino.
3.  Clique em **+** na seção **Linked Frameworks and Libraries**.
4.  Selecione a biblioteca do sistema para vincular.

#### Biblioteca primária

Uma biblioteca nativa primária pode ser incluída como código-fonte ou como um
arquivo `.framework` (assinado). Provavelmente, é possível incluir arquivos
estaticamente vinculados também, mas isso requer testes.

#### Código fonte

Para vincular diretamente ao código-fonte, use as seguintes instruções:

 1. No Xcode, abra `Runner.xcworkspace`.
 2. Adicione os arquivos de origem C/C++/Objective-C/Swift ao projeto Xcode.
 3. Adicione o seguinte prefixo às declarações de símbolos exportados para
    garantir que eles estejam visíveis para o Dart:

    **C/C++/Objective-C**

    ```objc
    extern "C" /* <= C++ only */ __attribute__((visibility("default"))) __attribute__((used))
    ```

    **Swift**

    ```swift
    @_cdecl("myFunctionName")
    ```

#### Biblioteca (dinâmica) compilada

Para vincular a uma biblioteca dinâmica compilada, use as seguintes instruções:

1.  Se um arquivo `Framework` devidamente assinado estiver presente, abra
    `Runner.xcworkspace`.
2.  Adicione o arquivo de framework à seção **Embedded Binaries**.
3.  Adicione-o também à seção **Linked Frameworks & Libraries** do destino no
    Xcode.

#### Biblioteca de terceiros de código aberto

Para criar um plugin Flutter que inclua código C/C++/Objective-C _e_ Dart,
use as seguintes instruções:

1.  No projeto do seu plugin, abra
    `ios/<myproject>.podspec`.
2.  Adicione o código nativo ao campo `source_files`.

O código nativo é então vinculado estaticamente ao binário do aplicativo de
qualquer aplicativo que use este plugin.

#### Biblioteca de terceiros de código fechado

Para criar um plugin Flutter que inclua código-fonte Dart, mas distribua a
biblioteca C/C++ em formato binário, use as seguintes instruções:

1.  No projeto do seu plugin, abra
    `ios/<myproject>.podspec`.
2.  Adicione um campo `vendored_frameworks`. Consulte o
    [exemplo do CocoaPods][].

:::warning
**Não** carregue este plugin (ou qualquer plugin que contenha código binário)
para o pub.dev. Em vez disso, este plugin deve ser baixado de um terceiro
confiável, conforme mostrado no exemplo do CocoaPods.
:::

[CocoaPods example]: {{site.github}}/CocoaPods/CocoaPods/blob/master/examples/Vendored%20Framework%20Example/Example%20Pods/VendoredFrameworkExample.podspec

## Removendo símbolos iOS

Ao criar um arquivo de lançamento (IPA), os símbolos são removidos pelo Xcode.

1.  No Xcode, vá para **Target Runner > Build Settings > Strip Style**.
2.  Altere de **All Symbols** para **Non-Global Symbols**.

{% include docs/resource-links/ffi-video-resources.md %}

