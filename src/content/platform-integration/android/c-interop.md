---
ia-translate: true
title: "Vinculando ao código nativo Android usando dart:ffi"
description: "Para usar código C em seu programa Flutter, use a biblioteca dart:ffi."
---

<?code-excerpt path-base="platform_integration"?>

Aplicativos Flutter para mobile e desktop podem usar a biblioteca
[dart:ffi][] para chamar APIs C nativas.
_FFI_ significa [_interface de função estrangeira._][FFI]
Outros termos para funcionalidade similar incluem
_interface nativa_ e _vinculações de linguagem._

:::note
Esta página descreve o uso da biblioteca `dart:ffi`
em aplicativos Android. Para obter informações sobre iOS, consulte
[Vinculando ao código nativo iOS usando dart:ffi][ios-ffi].
Para obter informações em macOS, consulte
[Vinculando ao código nativo macOS usando dart:ffi][macos-ffi].
Este recurso ainda não é suportado para plugins web.
:::


[ios-ffi]: /platform-integration/ios/c-interop
[dart:ffi]: {{site.dart.api}}/dart-ffi/dart-ffi-library.html
[macos-ffi]: /platform-integration/macos/c-interop
[FFI]: https://en.wikipedia.org/wiki/Foreign_function_interface

Antes que sua biblioteca ou programa possa usar a biblioteca FFI
para vincular ao código nativo, você deve garantir que o
código nativo seja carregado e seus símbolos sejam visíveis para o Dart.
Esta página se concentra na compilação, empacotamento,
e carregamento de código nativo Android dentro de um plugin ou aplicativo Flutter.

Este tutorial demonstra como agrupar fontes C/C++
em um plugin Flutter e vinculá-los usando
a biblioteca Dart FFI em Android e iOS.
Neste passo a passo, você criará uma função C
que implementa a adição de 32 bits e, em seguida,
a expõe por meio de um plugin Dart chamado "native_add".

## Vinculação dinâmica vs estática

Uma biblioteca nativa pode ser vinculada a um aplicativo
dinamicamente ou estaticamente. Uma biblioteca vinculada estaticamente
é incorporada à imagem executável do aplicativo,
e é carregada quando o aplicativo é iniciado.

Símbolos de uma biblioteca vinculada estaticamente podem ser
carregados usando [`DynamicLibrary.executable`][] ou
[`DynamicLibrary.process`][].

Uma biblioteca vinculada dinamicamente, por outro lado, é distribuída
em um arquivo ou pasta separada dentro do aplicativo,
e carregada sob demanda. No Android, uma biblioteca dinamicamente
vinculada é distribuída como um conjunto de arquivos `.so` (ELF),
um para cada arquitetura.

Uma biblioteca vinculada dinamicamente pode ser carregada em
Dart via [`DynamicLibrary.open`][].

A documentação da API está disponível na
[Documentação de referência da API Dart][].

No Android, apenas bibliotecas dinâmicas são suportadas
(porque o executável principal é a JVM,
à qual não nos vinculamos estaticamente).


[Documentação de referência da API Dart]: {{site.dart.api}}
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
Você pode excluir plataformas de `--platforms` que você não
quer construir. No entanto, você precisa incluir a plataforma do
dispositivo em que você está testando.
:::

Isso criará um plugin com fontes C/C++ em `native_add/src`.
Essas fontes são construídas pelos arquivos de compilação nativos nas várias
pastas de compilação do sistema operacional.

A biblioteca FFI só pode vincular contra símbolos C,
então, em C++, esses símbolos são marcados com `extern "C"`.

Você também deve adicionar atributos para indicar que os
símbolos são referenciados a partir do Dart,
para impedir que o vinculador descarte os símbolos
durante a otimização em tempo de link.
`__attribute__((visibility("default"))) __attribute__((used))`.

No Android, o `native_add/android/build.gradle` vincula o código.

O código nativo é invocado do dart em `lib/native_add_bindings_generated.dart`.

As vinculações são geradas com [package:ffigen]({{site.pub-pkg}}/ffigen).

## Outros casos de uso

### Biblioteca da plataforma

Para vincular a uma biblioteca da plataforma,
use as seguintes instruções:

 1. Encontre a biblioteca desejada na [APIs Nativas do Android NDK][]
    lista na documentação do Android. Isso lista APIs nativas estáveis.
 1. Carregue a biblioteca usando [`DynamicLibrary.open`][].
    Por exemplo, para carregar OpenGL ES (v3):

    ```dart
    DynamicLibrary.open('libGLES_v3.so');
    ```

Pode ser necessário atualizar o arquivo de manifesto do Android
do aplicativo ou plugin, se indicado pela
documentação.


[APIs Nativas do Android NDK]: {{site.android-dev}}/ndk/guides/stable_apis

#### Biblioteca própria

O processo para incluir código nativo no código
fonte ou forma binária é o mesmo para um aplicativo ou
plugin.

#### Terceiros de código aberto

Siga as instruções [Adicionar código C e C++ ao seu projeto][]
na documentação do Android para
adicionar código nativo e suporte para o nativo
cadeia de ferramentas de código (CMake ou `ndk-build`).


[Adicionar código C e C++ ao seu projeto]: {{site.android-dev}}/studio/projects/add-native-code

#### Biblioteca de terceiros de código fechado

Para criar um plugin Flutter que inclua Dart
código fonte, mas distribua a biblioteca C/C++
em forma binária, use as seguintes instruções:

1. Abra o arquivo `android/build.gradle` para o seu
   projeto.
2. Adicione o artefato AAR como uma dependência.
   **Não** inclua o artefato em seu
   pacote Flutter. Em vez disso, ele deve ser
   baixado de um repositório, como
   JCenter.


## Tamanho do APK do Android (compressão de objeto compartilhado)

As [diretrizes do Android][] geralmente recomendam
distribuir objetos compartilhados nativos não compactados
porque isso realmente economiza espaço no dispositivo.
Objetos compartilhados podem ser carregados diretamente do APK
em vez de descompactá-los no dispositivo em um
local temporário e depois carregar.
Os APKs são adicionalmente compactados em trânsito&mdash;é por isso
que você deve estar olhando para o tamanho do download.

Os APKs Flutter, por padrão, não seguem essas diretrizes
e compactam `libflutter.so` e `libapp.so`&mdash;isso
leva a um tamanho menor de APK, mas um tamanho maior no dispositivo.

Objetos compartilhados de terceiros podem alterar essa configuração padrão
com `android:extractNativeLibs="true"` em seu
`AndroidManifest.xml` e interromper a compactação de `libflutter.so`,
`libapp.so` e quaisquer objetos compartilhados adicionados pelo usuário.
Para reabilitar a compressão, substitua a configuração em
`your_app_name/android/app/src/main/AndroidManifest.xml`
da seguinte forma.

```xml diff
  <manifest xmlns:android="http://schemas.android.com/apk/res/android"
-     package="com.example.your_app_name">
+     xmlns:tools="http://schemas.android.com/tools"
+     package="com.example.your_app_name" >
      <!-- io.flutter.app.FlutterApplication é um android.app.Application que
           chama FlutterMain.startInitialization(this); em seu método onCreate.
           Na maioria dos casos, você pode deixar isso como está, mas se você quiser fornecer
           funcionalidade adicional, não há problema em subclassificar ou reimplementar
           FlutterApplication e coloque sua classe personalizada aqui. -->

      <application
          android:name="io.flutter.app.FlutterApplication"
          android:label="your_app_name"
-         android:icon="@mipmap/ic_launcher">
+         android:icon="@mipmap/ic_launcher"
+         android:extractNativeLibs="true"
+         tools:replace="android:extractNativeLibs">
```

[diretrizes do Android]: {{site.android-dev}}/topic/performance/reduce-apk-size#extract-false

{% include docs/resource-links/ffi-video-resources.md %}

