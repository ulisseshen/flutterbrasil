---
ia-translate: true
title: Exportar fonts de um package
description: Como exportar fonts de um package.
---

<?code-excerpt path-base="cookbook/design/package_fonts"?>

Em vez de declarar uma font como parte de um app,
você pode declarar uma font como parte de um package separado.
Esta é uma maneira conveniente de compartilhar a mesma font entre
vários projetos diferentes,
ou para programadores que publicam seus packages no [pub.dev][].
Esta receita usa os seguintes passos:

  1. Adicionar uma font a um package.
  2. Adicionar o package e a font ao app.
  3. Usar a font.

:::note
Confira o package [google_fonts][] para acesso direto
a quase 1000 famílias de fonts open-source.
:::

## 1. Adicionar uma font a um package

Para exportar uma font de um package, você precisa importar os arquivos de font para a
pasta `lib` do projeto do package. Você pode colocar arquivos de font diretamente na
pasta `lib` ou em um subdiretório, como `lib/fonts`.

Neste exemplo, assuma que você tem uma biblioteca Flutter chamada
`awesome_package` com fonts localizadas em uma pasta `lib/fonts`.

```plaintext
awesome_package/
  lib/
    awesome_package.dart
    fonts/
      Raleway-Regular.ttf
      Raleway-Italic.ttf
```

## 2. Adicionar o package e fonts ao app

Agora você pode usar as fonts no package
atualizando o `pubspec.yaml` no diretório raiz do *app*.

### Adicionar o package ao app

Para adicionar o package `awesome_package` como uma dependência,
execute `flutter pub add`:

```console
$ flutter pub add awesome_package
```

### Declarar os assets de font

Agora que você importou o package, diga ao Flutter onde
encontrar as fonts do `awesome_package`.

Para declarar fonts de package, prefixe o caminho para a font com
`packages/awesome_package`.
Isso diz ao Flutter para procurar na pasta `lib`
do package pela font.

```yaml
flutter:
  fonts:
    - family: Raleway
      fonts:
        - asset: packages/awesome_package/fonts/Raleway-Regular.ttf
        - asset: packages/awesome_package/fonts/Raleway-Italic.ttf
          style: italic
```

<a id="use" aria-hidden="true"></a>

## 3. Usar a font

Use um [`TextStyle`][] para mudar a aparência do texto.
Para usar fonts de package, declare qual font você gostaria de usar e
a qual package a font pertence.

<?code-excerpt "lib/main.dart (TextStyle)"?>
```dart
child: Text(
  'Using the Raleway font from the awesome_package',
  style: TextStyle(fontFamily: 'Raleway'),
),
```

## Exemplo completo

### Fonts

As fonts Raleway e RobotoMono foram baixadas do
[Google Fonts][].

### `pubspec.yaml`

```yaml
name: package_fonts
description: An example of how to use package fonts with Flutter

dependencies:
  awesome_package:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  fonts:
    - family: Raleway
      fonts:
        - asset: packages/awesome_package/fonts/Raleway-Regular.ttf
        - asset: packages/awesome_package/fonts/Raleway-Italic.ttf
          style: italic
  uses-material-design: true
```

### `main.dart`

<?code-excerpt "lib/main.dart"?>
```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Package Fonts', home: MyHomePage());
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The AppBar uses the app-default font.
      appBar: AppBar(title: const Text('Package Fonts')),
      body: const Center(
        // This Text widget uses the Raleway font.
        child: Text(
          'Using the Raleway font from the awesome_package',
          style: TextStyle(fontFamily: 'Raleway'),
        ),
      ),
    );
  }
}
```

![Package Fonts Demo](/assets/images/docs/cookbook/package-fonts.png){:.site-mobile-screenshot}

[Google Fonts]: https://fonts.google.com
[google_fonts]: {{site.pub-pkg}}/google_fonts
[pub.dev]: {{site.pub}}
[`TextStyle`]: {{site.api}}/flutter/painting/TextStyle-class.html
