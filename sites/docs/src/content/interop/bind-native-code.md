---
ia-translate: true
title: Vincular-se a código nativo usando FFI
description: Para usar código nativo no seu programa Flutter, use a biblioteca dart:ffi com o template package_ffi.
---

Apps Flutter podem usar a biblioteca [dart:ffi][] para chamar APIs nativas.
_FFI_ significa [_interface de função estrangeira_][FFI].
Outros termos para funcionalidades semelhantes incluem
_native interface_ e _language bindings._

Desde o Flutter 3.38, a forma recomendada de vincular código nativo
é usar o comando `flutter create --template=package_ffi`.
Esse template usa [build hooks][] para configurar a build nativa
em um script `build.dart` e não exige mais arquivos de build
específicos de cada sistema operacional.
Essa abordagem funciona tanto para projetos Flutter quanto para
projetos Dart standalone.

Se você precisar usar a API de Plugins do Flutter, ou configurar um runtime
do Google Play services no Android, use o template padrão de plugin
(`flutter create --template=plugin`).

:::note
Procurando o fluxo de trabalho anterior de plugin FFI? Consulte
[Vincular-se a código nativo usando o template legado de plugin FFI](/platform-integration/legacy-ffi-plugin),
que documenta o template `plugin_ffi` e os arquivos de build
específicos de cada sistema operacional.
:::

[build hooks]: {{site.dart-site}}/tools/hooks
[dart:ffi]: {{site.dart.api}}/dart-ffi/dart-ffi-library.html
[FFI]: https://en.wikipedia.org/wiki/Foreign_function_interface

## Criar um package FFI {:#create-an-ffi-package}

Para criar um package FFI, execute o comando a seguir:

```console
$ flutter create --template=package_ffi native_add
$ cd native_add
```

Isso cria um package com o seguinte conteúdo específico:

- **`lib/native_add.dart`**: o código Dart que define a API do package.
- **`lib/native_add_bindings_generated.dart`**: os bindings Dart gerados
  para o código nativo.
- **`src/native_add.c`**: o código-fonte nativo em C.
- **`src/native_add.h`**: o arquivo de header em C do código nativo.
- **`hook/build.dart`**: um script executado pelo SDK do Flutter
  para compilar o código nativo.
- **`ffigen.yaml`**: o arquivo de configuração do [`package:ffigen`][]
  para gerar os bindings Dart.
- **`pubspec.yaml`**: a definição do package, que habilita o hook
  `build.dart`.

[`package:ffigen`]: {{site.pub-pkg}}/ffigen

## O código nativo {:#the-native-code}

O código nativo está em `src/native_add.c` e `src/native_add.h`.
A função C `sum` é definida no arquivo `.c`, e sua assinatura está no
arquivo de header.
A função é marcada para exportação, para que possa ser chamada a partir do Dart.

## O build hook {:#the-build-hook}

O código nativo é compilado e empacotado com o seu app automaticamente.
Isso é feito pelo script `hook/build.dart`, que é um [build hook][build hooks].

Isso significa que você não precisa mais escrever arquivos de build específicos
de cada sistema operacional (como `CMakeLists.txt` para Linux/Windows,
`.podspec` para iOS/macOS ou `build.gradle` para Android)
para compilar o seu código nativo.

O build hook usa o `package:native_toolchain_c` para compilar o código C
em uma biblioteca dinâmica.
Você pode personalizar esse arquivo para compilar outras linguagens nativas
ou para baixar binários pré-compilados.

## O código Dart {:#the-dart-code}

O código Dart define a API pública do package.

### Gerando os bindings {:#generating-the-bindings}

Para vincular ao código nativo, o template usa o [`package:ffigen`][]
para gerar bindings a partir do arquivo de header (`src/native_add.h`).
A geração é configurada em `ffigen.yaml`.

Isso gera `lib/native_add_bindings_generated.dart`.

### Chamando a função nativa {:#calling-the-native-function}

Os bindings gerados em `lib/native_add_bindings_generated.dart` contêm
funções `@Native() external`.
Essas funções são resolvidas automaticamente em tempo de execução
contra o code asset gerado pelo build hook (que roda em tempo de build).
Isso significa que nenhuma lógica específica de sistema operacional
é necessária para fazer o `dlopen` das bibliotecas dinâmicas,
tornando o código Dart verdadeiramente multiplataforma.

O arquivo principal da biblioteca, `lib/native_add.dart`, expõe essas funções.
Seu app pode então chamá-las importando `package:native_add/native_add.dart`.

## Testes {:#testing}

O package gerado inclui um teste de unidade em `test/native_add_test.dart`
que mostra como testar a função nativa.

## Outros casos de uso {:#other-use-cases}

### Bibliotecas do sistema {:#system-libraries}

Para vincular a uma biblioteca do sistema, você modifica o hook `build.dart`
para especificar o modo de linkagem.
Em vez de compilar código-fonte, você cria um `CodeAsset` e define seu `linkMode`.

Para muitas bibliotecas do sistema em Android, iOS, Linux e macOS,
você pode usar `LookupInProcess()` para encontrar símbolos no processo principal.

Para Windows, normalmente você usa `DynamicLoadingSystem()` e informa o nome da DLL.

:::note
Para orientações específicas de desktop sobre como chamar APIs do sistema,
incluindo packages wrapper como [`package:win32`]({{site.pub-pkg}}/win32) e
[pacotes Linux da Canonical]({{site.pub}}/publishers/canonical.com/packages),
consulte [Integração com Windows](/platform-integration/windows/building#integrating-with-windows)
e [Integrar com Linux](/platform-integration/linux/building#integrate-with-linux).
:::

Aqui está um exemplo de `build.dart` que faz a linkagem com bibliotecas do sistema
para obter o nome do host:

```dart
// hook/build.dart
import 'package:hooks/hooks.dart';
import 'package:code_assets/code_assets.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    final targetOS = input.target.os;
    switch (targetOS) {
      case OS.android || OS.iOS || OS.linux || OS.macOS:
        output.assets.code.add(
          CodeAsset(
            package: 'host_name',
            name: 'src/third_party/unix.dart',
            linkMode: LookupInProcess(),
          ),
        );
      case OS.windows:
        output.assets.code.add(
          CodeAsset(
            package: 'host_name',
            name: 'src/third_party/windows.dart',
            linkMode: DynamicLoadingSystem(Uri.file('ws2_32.dll')),
          ),
        );
      default:
        throw Exception('Unsupported target os: $targetOS');
    }
  });
}
```

Os arquivos Dart (`unix.dart`, `windows.dart`) conteriam então as funções
`external` que usam os símbolos dessas bibliotecas do sistema.

#### Empacotando o `libc++_shared.so` no Android {:#bundling-libcsharedso-on-android}

Embora o `libc++_shared.so` venha com o NDK do Android,
ele não é uma biblioteca do sistema.
Se o seu app ou package usar a [biblioteca padrão do C++][libcpp-support],
ou incluir [múltiplas bibliotecas compartilhadas][shared-libraries]
que dependem dela, o seu app precisa empacotar o `libc++_shared.so`.

Para empacotar a biblioteca no seu app,
adicione uma dependência ao [`package:android_libcpp_shared`][libcpp-shared],
que usa o próprio build hook para empacotar o `libc++_shared.so`
do NDK instalado localmente para cada arquitetura de destino.

[libcpp-support]: {{site.android-dev}}/ndk/guides/cpp-support#cs
[shared-libraries]: {{site.android-dev}}/ndk/guides/cpp-support#shared_runtimes
[libcpp-shared]: {{site.pub}}/packages/android_libcpp_shared

### Bibliotecas de código fechado {:#closed-source-libraries}

Você também pode usar build hooks para linkar bibliotecas pré-compiladas
de código fechado.
A abordagem recomendada é baixar os binários pré-compilados no momento da build
e verificar a integridade deles com um hash de arquivo.

No seu hook `build.dart`, você faria o seguinte:
1.  Baixar a biblioteca de uma URL.
2.  Verificar o hash do arquivo baixado.
3.  Colocar a biblioteca no diretório de saída da build.
4.  Criar um `CodeAsset` com `DynamicLoading` apontando para a biblioteca.

Aqui está um exemplo simplificado da criação do `CodeAsset`:

```dart
// hook/build.dart
import 'package:hooks/hooks.dart';
import 'package:code_assets/code_assets.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    // 1. Download the library from a URL.
    // 2. Verify the hash of the downloaded file.
    // 3. Place the library in the build output directory.
    
    output.assets.code.add(
      CodeAsset(
        package: input.packageName,
        name: 'src/my_lib.dart', // Dart file with bindings
        linkMode: DynamicLoadingBundled(),
        file: input.outputDirectory.resolve('my_lib.so'),
      ),
    );
  });
}
```
Você precisaria lidar com diferentes arquiteturas e plataformas,
tendo versões diferentes da biblioteca pré-compilada.

Para explorar outros exemplos, consulte os
[exemplos do `package:code_assets`]({{site.pub-pkg}}/code_assets/example).

## Diretrizes para nomes de bibliotecas dinâmicas {:#dynamic-library-naming-guidelines}

Ao implementar hooks `build.dart` para packages que empacotam code assets,
é fundamental garantir nomes consistentes para as bibliotecas dinâmicas
em todas as arquiteturas e SDKs de destino.

Em plataformas Apple (iOS e macOS), as bibliotecas dinâmicas são empacotadas
em frameworks.
O sistema de build do Flutter depende desses nomes para gerar metadados
e empacotar formatos distribuíveis, como XCFrameworks.

### Consistência entre arquiteturas {:#consistency-across-architectures}

Para um determinado asset ID, o seu hook será invocado várias vezes,
uma para cada arquitetura.
O hook deve produzir o mesmo nome de arquivo independentemente da arquitetura
de destino (por exemplo, `arm64` vs. `x64`).

*   **Por quê?** Dentro de uma única build do SDK, o Flutter combina binários
    específicos de cada arquitetura em um único binário universal (fat),
    usando `lipo`. Se as arquiteturas tiverem nomes de arquivo diferentes,
    a ferramenta escolhe um de forma não determinística e emite um aviso.
    Além disso, as mensagens de erro em tempo de execução ficam confusas
    para os usuários se as bibliotecas dinâmicas forem renomeadas.
*   **Ação recomendada**: evite adicionar sufixos de arquitetura aos nomes
    de arquivo (por exemplo, use `libsqlite3.dylib` em vez de
    `libsqlite3_arm64.dylib`). Em vez disso, escreva o arquivo em
    `input.outputDirectory` (que é único por arquitetura) ou em um subdiretório
    específico da arquitetura dentro de `input.outputDirectoryShared`
    (por exemplo, `input.outputDirectoryShared.resolve('$architecture/')`).

### Consistência entre SDKs (iOS) {:#consistency-across-sdks-ios}

Ao compilar para iOS, o seu hook será invocado várias vezes com valores
diferentes de SDK e arquitetura.
Tanto as invocações para dispositivo físico (`iphoneos`) quanto para
simulador (`iphonesimulator`) devem produzir o mesmo nome de framework
para o mesmo asset ID.

*   **Por quê?** O Flutter usa `xcodebuild -create-xcframework` para combinar
    essas saídas. O Xcode exige que todas as fatias de plataforma dentro de
    um XCFramework compartilhem o mesmo nome de framework para permitir a
    linkagem sem problemas. Se os nomes de arquivo forem diferentes, a
    ferramenta do Flutter não consegue criar um XCFramework correto, e comandos
    como `flutter build ios-framework` vão falhar.
*   **Ação recomendada**: não use sufixos como `_sim` ou `_simulator` na build
    do simulador. A estrutura do XCFramework já trata a separação de plataforma
    internamente (por exemplo,
    `MyLib.xcframework/ios-arm64_x86_64-simulator/MyLib.framework`).
    Em vez disso, escreva o arquivo em `input.outputDirectory` (que é único por
    SDK) ou em um subdiretório específico do SDK dentro de
    `input.outputDirectoryShared`.

### Consistência no conjunto de assets {:#consistency-in-the-set-of-assets}

O seu hook deve produzir o mesmo conjunto de Asset IDs em todos os SDKs
para uma determinada plataforma de destino.

*   **Por quê?** O sistema de build da Apple e a validação da App Store exigem
    que todos os frameworks incluídos em um aplicativo sejam compatíveis com o
    dispositivo de destino. Se você produzir um asset para o simulador
    (`iphonesimulator`), mas não para o dispositivo físico (`iphoneos`), o
    XCFramework resultante terá uma fatia sem correspondência no dispositivo.
    Isso pode levar a falhas de build ou à rejeição do aplicativo pela Apple,
    por incluir binários exclusivos de simulador em uma build de dispositivo.
*   **Ação recomendada**: garanta que a lógica do seu hook `build.dart` trate
    todos os SDKs suportados de forma consistente. Se você produzir um asset
    para um SDK, deve produzir um asset correspondente para todos os outros SDKs
    dessa plataforma. Para código específico de um SDK, você pode usar
    implementações stub nos demais SDKs.
