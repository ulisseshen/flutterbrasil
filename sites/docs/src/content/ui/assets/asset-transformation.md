---
ia-translate: true
title: Transformando assets no momento da compilação
description: Como configurar a transformação automática de imagens (e outros assets) em seu app Flutter.
shortTitle: Transformação de assets
---

Você pode configurar seu projeto para transformar automaticamente assets
no momento da compilação usando pacotes Dart compatíveis.

## Especificando transformações de assets

No arquivo `pubspec.yaml`, liste os assets a serem transformados e o pacote
transformador associado.

```yaml
flutter:
  assets:
    - path: assets/logo.svg
      transformers:
        - package: vector_graphics_compiler
```

Com esta configuração, `assets/logo.svg` é transformado pelo pacote
[`vector_graphics_compiler`][`vector_graphics_compiler`] conforme é copiado para a saída da compilação. Este
pacote pré-compila arquivos SVG em arquivos binários otimizados que podem ser
exibidos usando o pacote [`vector_graphics`][`vector_graphics`], assim:

<?code-excerpt "ui/assets_and_images/lib/logo.dart (TransformedAsset)"?>
```dart
import 'package:vector_graphics/vector_graphics.dart';

const Widget logo = VectorGraphic(loader: AssetBytesLoader('assets/logo.svg'));
```

### Passando argumentos para transformadores de assets

Para passar uma string de argumentos para um transformador de assets,
especifique isso também no pubspec:

```yaml
flutter:
  assets:
    - path: assets/logo.svg
      transformers:
        - package: vector_graphics_compiler
          args: ['--tessellate', '--font-size=14']
```

### Encadeando transformadores de assets

Transformadores de assets podem ser encadeados e são aplicados na
ordem em que são declarados.
Considere o seguinte exemplo usando pacotes imaginários:

```yaml
flutter:
  assets:
    - path: assets/bird.png
      transformers:
        - package: grayscale_filter
        - package: png_optimizer
```

Aqui, `bird.png` é transformado pelo pacote `grayscale_filter`.
A saída é então transformada pelo pacote `png_optimizer` antes de ser
empacotada no app compilado.

## Escrevendo pacotes transformadores de assets

Um transformador de assets é um [command-line app][command-line app] Dart que é invocado com
`dart run` com pelo menos dois argumentos: `--input`, que contém o caminho para
o arquivo a ser transformado e `--output`, que é o local onde o
código do transformador deve escrever sua saída.

Se o transformador termina com um código de saída diferente de zero, a compilação da aplicação
falha com uma mensagem de erro explicando que a transformação do asset falhou.
Qualquer coisa escrita no stream [`stderr`][`stderr`] do processo pelo transformador é
incluída na mensagem de erro.

Durante a invocação do transformador, a variável de ambiente
`FLUTTER_BUILD_MODE` será definida para o nome CLI do modo de compilação sendo usado.
Por exemplo, se você executar seu app com `flutter run -d macos --release`, então
`FLUTTER_BUILD_MODE` será definida para `release`.

## Exemplo

Para um projeto Flutter de exemplo que usa transformação de assets e inclui um pacote
Dart customizado que é usado como transformador, confira o
[asset_transformers project in the Flutter samples repo][asset_transformers project in the Flutter samples repo].

[command-line app]: {{site.dart-site}}/tutorials/server/cmdline
[asset_transformers project in the Flutter samples repo]: {{site.repo.samples}}/tree/main/asset_transformation
[`vector_graphics_compiler`]: {{site.pub}}/packages/vector_graphics_compiler
[`vector_graphics`]: {{site.pub-pkg}}/vector_graphics
[`stderr`]: {{site.api}}/flutter/dart-io/Process/stderr.html
