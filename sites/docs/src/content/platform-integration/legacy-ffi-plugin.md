---
ia-translate: true
title: Vincular-se a código nativo usando o template legado de plugin FFI
description: >-
  Use o template legado plugin_ffi e dart:ffi para vincular código C nativo
  no seu plugin ou app Flutter.
---

:::warning
Esta página documenta a abordagem legada `plugin_ffi` para interop com C.

Desde o Flutter 3.38, recomendamos usar o template `package_ffi`
com [build hooks][] para interop com C.

No entanto, o template legado de plugin FFI (`plugin_ffi`) documentado aqui
continua útil se você precisar:

- Acessar a API de Plugins do Flutter.
- Usar linkagem estática (no iOS e no macOS).
- Configurar um runtime do Google Play services no Android.
:::

Apps Flutter mobile e desktop podem usar a biblioteca [`dart:ffi`][]
para chamar APIs C nativas.
_FFI_ significa [_interface de função estrangeira._][FFI]
Outros termos para funcionalidades semelhantes incluem
_native interface_ e _language bindings._

[build hooks]: /interop/bind-native-code
[`dart:ffi`]: {{site.dart.api}}/dart-ffi/dart-ffi-library.html
[FFI]: https://en.wikipedia.org/wiki/Foreign_function_interface

Antes que sua biblioteca ou programa possa usar a biblioteca FFI
para vincular-se a código nativo, você precisa garantir que o código nativo
seja carregado e que seus símbolos fiquem visíveis para o Dart.
Esta página foca em compilar, empacotar e carregar código nativo
dentro de um plugin ou app Flutter.

Este tutorial mostra como empacotar fontes C/C++ em um plugin Flutter
e vincular-se a elas usando a biblioteca Dart FFI.
Neste passo a passo, você criará uma função C que implementa uma soma
de 32 bits e a exporá por meio de um plugin Dart chamado `native_add`.

## Linkagem dinâmica versus estática {:#dynamic-versus-static-linking}

Uma biblioteca nativa pode ser linkada a um app de forma dinâmica ou estática.
Uma biblioteca linkada estaticamente é incorporada à imagem executável do app
e é carregada quando o app inicia.

Símbolos de uma biblioteca linkada estaticamente podem ser carregados usando
[`DynamicLibrary.executable`][] ou [`DynamicLibrary.process`][].

Uma biblioteca linkada dinamicamente, por outro lado, é distribuída em um
arquivo ou pasta separada dentro do app e é carregada sob demanda.
O formato de distribuição depende da plataforma:

- No Android, uma biblioteca linkada dinamicamente é distribuída como um
  conjunto de arquivos `.so` (ELF), um para cada arquitetura.
  Apenas bibliotecas dinâmicas são suportadas, porque o executável principal
  é a JVM, à qual o Flutter não linka estaticamente.
- No iOS e no macOS, a biblioteca linkada dinamicamente é distribuída
  como uma pasta `.framework`.

Uma biblioteca linkada dinamicamente pode ser carregada no Dart
usando [`DynamicLibrary.open`][].

[`DynamicLibrary.executable`]: {{site.dart.api}}/dart-ffi/DynamicLibrary/DynamicLibrary.executable.html
[`DynamicLibrary.open`]: {{site.dart.api}}/dart-ffi/DynamicLibrary/DynamicLibrary.open.html
[`DynamicLibrary.process`]: {{site.dart.api}}/dart-ffi/DynamicLibrary/DynamicLibrary.process.html

## Criar um plugin FFI {:#create-an-ffi-plugin}

Para criar um plugin FFI chamado `native_add`,
use `flutter create` com o template `plugin_ffi`:

```console
$ flutter create --platforms=android,ios,macos,windows,linux --template=plugin_ffi native_add
```

:::note
Você pode excluir de `--platforms` as plataformas para as quais não quer compilar.
No entanto, é necessário incluir a plataforma do dispositivo em que você vai testar.
:::

Isso cria um plugin com fontes C/C++ em `native_add/src`.
Essas fontes são compiladas pelos arquivos de build nativos
nas várias pastas de build de cada sistema operacional.

A biblioteca FFI só consegue vincular símbolos C,
por isso, em C++, esses símbolos são marcados com `extern "C"`.

Você também deve adicionar atributos para indicar que os símbolos são
referenciados pelo Dart, para evitar que o linker descarte os símbolos
durante a otimização em tempo de link:
`__attribute__((visibility("default"))) __attribute__((used))`.

O arquivo de build específico de cada plataforma faz a linkagem do código:

- No Android, `native_add/android/build.gradle`.
- No iOS, `native_add/ios/native_add.podspec`.
- No macOS, `native_add/macos/native_add.podspec`.
- No Linux, `native_add/linux/CMakeLists.txt`.
- No Windows, `native_add/windows/CMakeLists.txt`.

O código nativo é invocado a partir do Dart em
`lib/native_add_bindings_generated.dart`.

Os bindings são gerados com o [`package:ffigen`][].

[`package:ffigen`]: {{site.pub-pkg}}/ffigen

## Outros casos de uso {:#other-use-cases}

### iOS

O linker dinâmico carrega automaticamente as bibliotecas linkadas
dinamicamente quando o app inicia.
Seus símbolos constituintes podem ser resolvidos usando
[`DynamicLibrary.process`][].
Você também pode obter um handle para a biblioteca com
[`DynamicLibrary.open`][] para restringir o escopo da resolução de símbolos,
mas não está claro como o processo de revisão da Apple lida com isso.

Símbolos linkados estaticamente no binário do aplicativo podem ser resolvidos
usando [`DynamicLibrary.executable`][] ou [`DynamicLibrary.process`][].

#### Biblioteca de plataforma {:#ios-platform-library}

Para linkar a uma biblioteca de plataforma, use as instruções a seguir:

1.  No Xcode, abra o `Runner.xcworkspace`.
1.  Selecione a plataforma de destino.
1.  Clique em **+** na seção **Linked Frameworks and Libraries**.
1.  Selecione a biblioteca do sistema a ser linkada.

#### Biblioteca de primeira parte {:#ios-first-party-library}

Uma biblioteca nativa de primeira parte pode ser incluída como código-fonte
ou como um arquivo `.framework` (assinado).
Provavelmente também é possível incluir archives linkados estaticamente,
mas isso exige testes.

#### Código-fonte {:#ios-source-code}

Para linkar diretamente ao código-fonte, use as instruções a seguir:

1.  No Xcode, abra o `Runner.xcworkspace`.
1.  Adicione os arquivos-fonte C/C++/Objective-C/Swift ao projeto do Xcode.
1.  Adicione o prefixo a seguir às declarações de símbolos exportados
    para garantir que eles fiquem visíveis para o Dart:

    **C/C++/Objective-C:**

    ```objc
    extern "C" /* <= C++ only */ __attribute__((visibility("default"))) __attribute__((used))
    ```

    **Swift:**

    ```swift
    @_cdecl("myFunctionName")
    ```

#### Biblioteca compilada (dinâmica) {:#ios-compiled-dynamic-library}

Para linkar a uma biblioteca dinâmica compilada, use as instruções a seguir:

1.  Se houver um arquivo `Framework` devidamente assinado, abra o `Runner.xcworkspace`.
1.  Adicione o arquivo de framework à seção **Frameworks, Libraries, and Embedded Content**
    do target no Xcode.
1.  Na coluna **Embed**, selecione **Embed & Sign**.

#### Biblioteca de terceiros de código aberto {:#ios-open-source-third-party-library}

Para criar um plugin Flutter que inclua código C/C++/Objective-C _e_ código Dart,
use as instruções a seguir:

1.  No seu projeto de plugin, abra `ios/<myproject>.podspec`.
1.  Adicione o código nativo ao campo `source_files`.

O código nativo é então linkado estaticamente ao binário do aplicativo
de qualquer app que use este plugin.

#### Biblioteca de terceiros de código fechado {:#ios-closed-source-third-party-library}

Para criar um plugin Flutter que inclua código-fonte Dart,
mas distribua a biblioteca C/C++ em formato binário,
use as instruções a seguir:

1.  No seu projeto de plugin, abra `ios/<myproject>.podspec`.
1.  Adicione um campo `vendored_frameworks`.
    Consulte o [exemplo do CocoaPods][CocoaPods example].

:::warning
**Não** envie este plugin (nem qualquer plugin que contenha código binário)
para o pub.dev.
Em vez disso, este plugin deve ser baixado de um terceiro confiável,
como mostrado no exemplo do CocoaPods.
:::

[CocoaPods example]: https://github.com/CocoaPods/CocoaPods/blob/master/examples/Vendored%20Framework%20Example/Example%20Pods/VendoredFrameworkExample.podspec

#### Remoção de símbolos {:#ios-stripping-symbols}

Ao criar uma build de release, o Xcode remove os símbolos.

1.  No Xcode, selecione o target **Runner** e vá para **Build Settings > Strip Style**.
1.  Altere de **All Symbols** para **Non-Global Symbols**.

### macOS

O linker dinâmico carrega automaticamente as bibliotecas linkadas
dinamicamente quando o app inicia.
Seus símbolos constituintes podem ser resolvidos usando
[`DynamicLibrary.process`][].
Você também pode obter um handle para a biblioteca com
[`DynamicLibrary.open`][] para restringir o escopo da resolução de símbolos,
mas não está claro como o processo de revisão da Apple lida com isso.

Símbolos linkados estaticamente no binário do aplicativo podem ser resolvidos
usando [`DynamicLibrary.executable`][] ou [`DynamicLibrary.process`][].

#### Biblioteca de plataforma {:#macos-platform-library}

Para linkar a uma biblioteca de plataforma, use as instruções a seguir:

1.  No Xcode, abra o `Runner.xcworkspace`.
1.  Selecione a plataforma de destino.
1.  Clique em **+** na seção **Linked Frameworks and Libraries**.
1.  Selecione a biblioteca do sistema a ser linkada.

#### Biblioteca de primeira parte {:#macos-first-party-library}

Uma biblioteca nativa de primeira parte pode ser incluída como código-fonte
ou como um arquivo `.framework` (assinado).
Provavelmente também é possível incluir archives linkados estaticamente,
mas isso exige testes.

#### Código-fonte {:#macos-source-code}

Para linkar diretamente ao código-fonte, use as instruções a seguir:

1.  No Xcode, abra o `Runner.xcworkspace`.
1.  Adicione os arquivos-fonte C/C++/Objective-C/Swift ao projeto do Xcode.
1.  Adicione o prefixo a seguir às declarações de símbolos exportados
    para garantir que eles fiquem visíveis para o Dart:

    **C/C++/Objective-C:**

    ```objc
    extern "C" /* <= C++ only */ __attribute__((visibility("default"))) __attribute__((used))
    ```

    **Swift:**

    ```swift
    @_cdecl("myFunctionName")
    ```

#### Biblioteca compilada (dinâmica) {:#macos-compiled-dynamic-library}

Para linkar a uma biblioteca dinâmica compilada, use as instruções a seguir:

1.  Se houver um arquivo `Framework` devidamente assinado, abra o `Runner.xcworkspace`.
1.  Adicione o arquivo de framework à seção **Frameworks, Libraries, and Embedded Content**
    do target no Xcode.
1.  Na coluna **Embed**, selecione **Embed & Sign**.

#### Biblioteca compilada (dinâmica), código fechado {:#macos-compiled-dynamic-library-closed-source}

Para adicionar uma biblioteca de código fechado a um app
[Flutter macOS Desktop][], use as instruções a seguir:

1.  Siga as instruções para desktop do Flutter para criar um app desktop Flutter.
1.  Abra o `yourapp/macos/Runner.xcworkspace` no Xcode.
    1.  Arraste a sua biblioteca pré-compilada (`libyourlibrary.dylib`)
        para `Runner/Frameworks`.
    1.  Clique em `Runner` e vá para a aba `Build Phases`.
        1.  Arraste `libyourlibrary.dylib` para a lista `Copy Bundle Resources`.
        1.  Em `Embed Libraries`, marque `Code Sign on Copy`.
        1.  Em `Link Binary With Libraries`, defina o status como `Optional`.
            (Usamos linkagem dinâmica, então não é preciso linkar estaticamente.)
    1.  Clique em `Runner` e vá para a aba `General`.
        1.  Arraste `libyourlibrary.dylib` para a lista
            **Frameworks, Libraries, and Embedded Content**.
        1.  Selecione **Embed & Sign**.
    1.  Clique em **Runner** e vá para a aba **Build Settings**.
        1.  Na seção **Search Paths**, configure o **Library Search Paths**
            para incluir o caminho onde está o `libyourlibrary.dylib`.
1.  Edite `lib/main.dart`.
    1.  Use `DynamicLibrary.open('libyourlibrary.dylib')` para vincular
        dinamicamente aos símbolos.
    1.  Chame a sua função nativa em algum widget.
1.  Execute `flutter run` e verifique se a sua função nativa é chamada.
1.  Execute `flutter build macos` para compilar uma versão de release
    autocontida do seu app.

[Flutter macOS Desktop]: /platform-integration/macos/building

#### Remoção de símbolos {:#macos-stripping-symbols}

Ao criar uma build de release, o Xcode remove os símbolos.

1.  No Xcode, selecione o target **Runner** e vá para **Build Settings > Strip Style**.
1.  Altere de **All Symbols** para **Non-Global Symbols**.

### Android

#### Biblioteca de plataforma {:#android-platform-library}

Para linkar a uma biblioteca de plataforma, use as instruções a seguir:

1.  Encontre a biblioteca desejada na lista de [APIs nativas do NDK do Android][Android NDK Native APIs]
    na documentação do Android. Essa lista traz APIs nativas estáveis.
1.  Carregue a biblioteca usando [`DynamicLibrary.open`][].
    Por exemplo, para carregar o OpenGL ES (v3):

    ```dart
    DynamicLibrary.open('libGLES_v3.so');
    ```

Talvez seja necessário atualizar o arquivo de manifesto Android do app
ou do plugin, se a documentação indicar isso.

[Android NDK Native APIs]: {{site.android-dev}}/ndk/guides/stable_apis

#### Biblioteca de primeira parte {:#android-first-party-library}

O processo para incluir código nativo, em formato de código-fonte ou binário,
é o mesmo para um app ou um plugin.

#### Biblioteca de terceiros de código aberto {:#android-open-source-third-party-library}

Siga as instruções [Adicionar código C e C++ ao seu projeto][Add C and C++ code to your project]
na documentação do Android para adicionar código nativo e suporte
à toolchain de código nativo (CMake ou `ndk-build`).

[Add C and C++ code to your project]: {{site.android-dev}}/studio/projects/add-native-code

#### Biblioteca de terceiros de código fechado {:#android-closed-source-third-party-library}

Para criar um plugin Flutter que inclua código-fonte Dart,
mas distribua a biblioteca C/C++ em formato binário,
use as instruções a seguir:

1.  Abra o arquivo `android/build.gradle` do seu projeto.
1.  Adicione o artefato AAR como dependência.
    **Não** inclua o artefato no seu package Flutter.
    Em vez disso, ele deve ser baixado de um repositório, como o Maven Central.

#### Tamanho do APK Android (compressão de objetos compartilhados) {:#android-apk-size-shared-object-compression}

As [diretrizes do Android][Android guidelines] em geral recomendam distribuir
objetos compartilhados nativos sem compressão, porque isso de fato economiza
espaço no dispositivo.
Objetos compartilhados podem ser carregados diretamente do APK, em vez de
serem descompactados no dispositivo em um local temporário e só depois carregados.
Os APKs ainda são compactados durante a transferência&mdash;por isso
é o tamanho do download que você deve observar.

Por padrão, os APKs do Flutter comprimem `libflutter.so` e `libapp.so`,
o que resulta em um APK menor, mas em um tamanho maior no dispositivo.
Para controlar se as bibliotecas nativas são armazenadas comprimidas e
extraídas no momento da instalação, defina a opção `useLegacyPackaging`
do Android Gradle plugin.
Para as recomendações atuais, consulte as [diretrizes do Android][Android guidelines].

[Android guidelines]: {{site.android-dev}}/topic/performance/reduce-apk-size#extract-false

## Outros recursos {:#other-resources}

Para saber mais sobre interoperabilidade com C, confira estes vídeos:

- [Interoperabilidade com C usando Dart FFI][C interoperability with Dart FFI]
- [Como usar o Dart FFI para criar um player de áudio retrô][How to Use Dart FFI to Build a Retro Audio Player]

[C interoperability with Dart FFI]: {{site.yt.watch}}?v=2MMK7YoFgaA
[How to Use Dart FFI to Build a Retro Audio Player]: {{site.yt.watch}}?v=05Wn2oM_nWw
