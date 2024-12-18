---
ia-translate: true
title: Exportar fontes de um pacote
description: Como exportar fontes de um pacote.
---

<?code-excerpt path-base="cookbook/design/package_fonts"?>

Em vez de declarar uma fonte como parte de um aplicativo,
você pode declarar uma fonte como parte de um pacote separado.
Esta é uma forma conveniente de compartilhar a mesma fonte entre
vários projetos diferentes,
ou para programadores publicando seus pacotes no [pub.dev][].
Esta receita usa as seguintes etapas:

  1. Adicionar uma fonte a um pacote.
  2. Adicionar o pacote e a fonte ao aplicativo.
  3. Usar a fonte.

:::note
Confira o pacote [google_fonts][] para acesso direto
a quase 1000 famílias de fontes de código aberto.
:::

## 1. Adicionar uma fonte a um pacote

Para exportar uma fonte de um pacote, você precisa importar os arquivos de fonte para a
pasta `lib` do projeto do pacote. Você pode colocar os arquivos de fonte diretamente na
pasta `lib` ou em um subdiretório, como `lib/fonts`.

Neste exemplo, suponha que você tenha uma biblioteca Flutter chamada
`awesome_package` com fontes localizadas em uma pasta `lib/fonts`.

```plaintext
awesome_package/
  lib/
    awesome_package.dart
    fonts/
      Raleway-Regular.ttf
      Raleway-Italic.ttf
```

## 2. Adicionar o pacote e as fontes ao aplicativo

Agora você pode usar as fontes no pacote,
atualizando o `pubspec.yaml` no diretório raiz do *aplicativo*.

### Adicionar o pacote ao aplicativo

Para adicionar o pacote `awesome_package` como uma dependência,
execute `flutter pub add`:

```console
$ flutter pub add awesome_package
```

### Declarar os assets da fonte

Agora que você importou o pacote, diga ao Flutter onde
encontrar as fontes do `awesome_package`.

Para declarar fontes de pacote, adicione o prefixo `packages/awesome_package` ao caminho da fonte.
Isso diz ao Flutter para procurar na pasta `lib`
do pacote pela fonte.

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

## 3. Usar a fonte

Use um [`TextStyle`][] para alterar a aparência do texto.
Para usar fontes de pacote, declare qual fonte você gostaria de usar e
a qual pacote a fonte pertence.

<?code-excerpt "lib/main.dart (TextStyle)"?>
```dart
child: Text(
  'Usando a fonte Raleway do awesome_package',
  style: TextStyle(
    fontFamily: 'Raleway',
  ),
),
```

## Exemplo completo

### Fontes

As fontes Raleway e RobotoMono foram baixadas de
[Google Fonts][].

### `pubspec.yaml`

```yaml
name: package_fonts
description: Um exemplo de como usar fontes de pacote com Flutter

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
    return const MaterialApp(
      title: 'Package Fonts',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // O AppBar usa a fonte padrão do aplicativo.
      appBar: AppBar(title: const Text('Package Fonts')),
      body: const Center(
        // Este widget Text usa a fonte Raleway.
        child: Text(
          'Usando a fonte Raleway do awesome_package',
          style: TextStyle(
            fontFamily: 'Raleway',
          ),
        ),
      ),
    );
  }
}
```

![Demonstração de Fontes de Pacote](/assets/images/docs/cookbook/package-fonts.png){:.site-mobile-screenshot}

[Google Fonts]: https://fonts.google.com
[google_fonts]: {{site.pub-pkg}}/google_fonts
[pub.dev]: {{site.pub}}
[`TextStyle`]: {{site.api}}/flutter/painting/TextStyle-class.html
