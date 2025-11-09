---
ia-translate: true
title: "Vinculando a código Android nativo usando dart:ffi"
description: "Para usar código C em seu programa Flutter, use a biblioteca dart:ffi."
---

<?code-excerpt path-base="platform_integration"?>

Apps Flutter mobile e desktop podem usar a
biblioteca [dart:ffi][dart:ffi] para chamar APIs C nativas.
_FFI_ significa [_foreign function interface._][FFI]
Outros termos para funcionalidade similar incluem
_native interface_ e _language bindings._

:::note
Esta página descreve o uso da biblioteca `dart:ffi`
em apps Android. Para informações sobre iOS, veja
[Vinculando a código iOS nativo usando dart:ffi][ios-ffi].
Para informações sobre macOS, veja
[Vinculando a código macOS nativo usando dart:ffi][macos-ffi].
Este recurso ainda não é suportado para plugins web.
:::


[ios-ffi]: /platform-integration/ios/c-interop
[dart:ffi]: {{site.dart.api}}/dart-ffi/dart-ffi-library.html
[macos-ffi]: /platform-integration/macos/c-interop
[FFI]: https://en.wikipedia.org/wiki/Foreign_function_interface

Antes que sua biblioteca ou programa possa usar a biblioteca FFI
para vincular a código nativo, você deve garantir que o
código nativo esteja carregado e seus símbolos estejam visíveis para Dart.
Esta página foca em compilar, empacotar
e carregar código nativo Android dentro de um plugin ou app Flutter.

Este tutorial demonstra como empacotar fontes C/C++
em um plugin Flutter e vincular a eles usando
a biblioteca Dart FFI tanto em Android quanto em iOS.
Neste passo a passo, você criará uma função C
que implementa adição de 32 bits e então
a expõe através de um plugin Dart chamado "native_add".

## Vinculação dinâmica vs estática

Uma biblioteca nativa pode ser vinculada a um app de forma
dinâmica ou estática. Uma biblioteca vinculada estaticamente
é incorporada na imagem executável do app
e é carregada quando o app inicia.

Símbolos de uma biblioteca vinculada estaticamente podem ser
carregados usando [`DynamicLibrary.executable`][DynamicLibrary.executable] ou
[`DynamicLibrary.process`][DynamicLibrary.process].

Uma biblioteca vinculada dinamicamente, por outro lado, é distribuída
em um arquivo ou pasta separado dentro do app
e carregada sob demanda. No Android, uma biblioteca
vinculada dinamicamente é distribuída como um conjunto de arquivos `.so` (ELF),
um para cada arquitetura.

Uma biblioteca vinculada dinamicamente pode ser carregada em
Dart via [`DynamicLibrary.open`][DynamicLibrary.open].

A documentação da API está disponível na
[documentação de referência da API Dart][Dart API reference documentation].

No Android, apenas bibliotecas dinâmicas são suportadas
(porque o executável principal é a JVM,
à qual não vinculamos estaticamente).


[Dart API reference documentation]: {{site.dart.api}}
[`DynamicLibrary.executable`]: {{site.dart.api}}/dart-ffi/DynamicLibrary/DynamicLibrary.executable.html
[`DynamicLibrary.open`]: {{site.dart.api}}/dart-ffi/DynamicLibrary/DynamicLibrary.open.html
[`DynamicLibrary.process`]: {{site.dart.api}}/dart-ffi/DynamicLibrary/DynamicLibrary.process.html

## Criar um plugin FFI

Para criar um plugin FFI chamado "native_add",
faça o seguinte:

```console
$ flutter create --platforms=android,ios,macos,windows,linux --template=plugin_ffi native_add
$ cd native_add
```

:::note
Você pode excluir plataformas de `--platforms` para as quais não deseja
fazer build. No entanto, você precisa incluir a plataforma do
dispositivo no qual está testando.
:::

Isso criará um plugin com fontes C/C++ em `native_add/src`.
Essas fontes são construídas pelos arquivos de build nativos nas várias
pastas de build do sistema operacional.

A biblioteca FFI só pode vincular a símbolos C,
então em C++ esses símbolos são marcados `extern "C"`.

Você também deve adicionar atributos para indicar que os
símbolos são referenciados do Dart,
para evitar que o linker descarte os símbolos
durante a otimização em tempo de vinculação.
`__attribute__((visibility("default"))) __attribute__((used))`.

No Android, o `native_add/android/build.gradle` vincula o código.

O código nativo é invocado do dart em `lib/native_add_bindings_generated.dart`.

Os bindings são gerados com [package:ffigen]({{site.pub-pkg}}/ffigen).

## Outros casos de uso

### Biblioteca de plataforma

Para vincular a uma biblioteca de plataforma,
use as seguintes instruções:

 1. Encontre a biblioteca desejada na lista de [Android NDK Native APIs][Android NDK Native APIs]
    na documentação Android. Isso lista APIs nativas estáveis.
 1. Carregue a biblioteca usando [`DynamicLibrary.open`][DynamicLibrary.open].
    Por exemplo, para carregar OpenGL ES (v3):

    ```dart
    DynamicLibrary.open('libGLES_v3.so');
    ```

Você pode precisar atualizar o arquivo de manifesto Android
do app ou plugin se indicado pela
documentação.


[Android NDK Native APIs]: {{site.android-dev}}/ndk/guides/stable_apis

#### Biblioteca de primeira parte

O processo para incluir código nativo em forma de
código fonte ou binária é o mesmo para um app ou
plugin.

#### Terceiros open-source

Siga as instruções [Add C and C++ code to your project][Add C and C++ code to your project]
na documentação Android para
adicionar código nativo e suporte para a
toolchain de código nativo (tanto CMake quanto `ndk-build`).


[Add C and C++ code to your project]: {{site.android-dev}}/studio/projects/add-native-code

#### Biblioteca de terceiros closed-source

Para criar um plugin Flutter que inclua código
fonte Dart, mas distribua a biblioteca C/C++
em forma binária, use as seguintes instruções:

1. Abra o arquivo `android/build.gradle` para seu
   projeto.
1. Adicione o artefato AAR como uma dependência.
   **Não** inclua o artefato em seu
   pacote Flutter. Em vez disso, ele deve ser
   baixado de um repositório, como
   JCenter.


## Tamanho do APK Android (compressão de shared object)

As [diretrizes Android][Android guidelines] em geral recomendam
distribuir shared objects nativos descomprimidos
porque isso na verdade economiza espaço no dispositivo.
Shared objects podem ser carregados diretamente do APK
em vez de desempacotá-los no dispositivo em uma
localização temporária e então carregá-los.
APKs são adicionalmente empacotados em trânsito&mdash;é por isso
que você deve estar olhando para o tamanho de download.

APKs Flutter por padrão não seguem essas diretrizes
e comprimem `libflutter.so` e `libapp.so`&mdash;isso
leva a um APK menor, mas maior tamanho no dispositivo.

Shared objects de terceiros podem alterar essa configuração padrão
com `android:extractNativeLibs="true"` em seu
`AndroidManifest.xml` e parar a compressão de `libflutter.so`,
`libapp.so` e quaisquer shared objects adicionados pelo usuário.
Para reabilitar a compressão, sobrescreva a configuração em
`your_app_name/android/app/src/main/AndroidManifest.xml`
da seguinte forma.

```xml diff
 <manifest xmlns:android="http://schemas.android.com/apk/res/android"
-     package="com.example.your_app_name">
+     xmlns:tools="http://schemas.android.com/tools"
+     package="com.example.your_app_name" >
     <!-- io.flutter.app.FlutterApplication is an android.app.Application that
          calls FlutterMain.startInitialization(this); in its onCreate method.
          In most cases you can leave this as-is, but you if you want to provide
          additional functionality it is fine to subclass or reimplement
          FlutterApplication and put your custom class here. -->

     <application
         android:name="io.flutter.app.FlutterApplication"
         android:label="your_app_name"
-         android:icon="@mipmap/ic_launcher">
+         android:icon="@mipmap/ic_launcher"
+         android:extractNativeLibs="true"
+         tools:replace="android:extractNativeLibs">
```

[Android guidelines]: {{site.android-dev}}/topic/performance/reduce-apk-size#extract-false

{% render "docs/resource-links/ffi-video-resources.md", site: site %}
