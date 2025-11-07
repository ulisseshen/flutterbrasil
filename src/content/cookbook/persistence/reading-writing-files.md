---
title: Ler e escrever arquivos
description: Como ler e escrever arquivos em disco.
ia-translate: true
---

<?code-excerpt path-base="cookbook/persistence/reading_writing_files/"?>

Em alguns casos, você precisa ler e escrever arquivos em disco.
Por exemplo, você pode precisar persistir dados entre inicializações do app,
ou baixar dados da internet e salvá-los para uso offline posterior.

Para salvar arquivos em disco em apps mobile ou desktop,
combine o plugin [`path_provider`][] com a biblioteca [`dart:io`][].

Esta receita usa os seguintes passos:

  1. Encontrar o caminho local correto.
  2. Criar uma referência para a localização do arquivo.
  3. Escrever dados no arquivo.
  4. Ler dados do arquivo.

Para aprender mais, assista a este vídeo Package of the Week
sobre o pacote `path_provider`:

{% ytEmbed 'Ci4t-NkOY3I', 'path_provider | Flutter package of the week' %}

:::note
Esta receita não funciona com apps web no momento.
Para acompanhar a discussão sobre este assunto,
confira o `flutter/flutter` [issue #45296]({{site.repo.flutter}}/issues/45296).
:::

## 1. Encontrar o caminho local correto

Este exemplo exibe um contador. Quando o contador muda,
escreva dados em disco para que você possa lê-los novamente quando o app carregar.
Onde você deve armazenar esses dados?

O pacote [`path_provider`][]
fornece uma maneira independente de plataforma para acessar localizações comumente usadas no
sistema de arquivos do dispositivo. O plugin atualmente suporta acesso a
dois locais do sistema de arquivos:

*Diretório temporário*
: Um diretório temporário (cache) que o sistema pode
  limpar a qualquer momento. No iOS, isso corresponde ao
  [`NSCachesDirectory`][]. No Android, este é o valor que
  [`getCacheDir()`][] retorna.

*Diretório de documentos*
: Um diretório para o app armazenar arquivos que apenas
  ele pode acessar. O sistema limpa o diretório apenas quando o app
  é deletado.
  No iOS, isso corresponde ao `NSDocumentDirectory`.
  No Android, este é o diretório `AppData`.

Este exemplo armazena informações no diretório de documentos.
Você pode encontrar o caminho para o diretório de documentos da seguinte forma:

<?code-excerpt "lib/main.dart (localPath)"?>
```dart
import 'package:path_provider/path_provider.dart';
  // ···
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
```

## 2. Criar uma referência para a localização do arquivo

Depois de saber onde armazenar o arquivo, crie uma referência para a
localização completa do arquivo. Você pode usar a classe [`File`][]
da biblioteca [`dart:io`][] para conseguir isso.

<?code-excerpt "lib/main.dart (localFile)"?>
```dart
Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/counter.txt');
}
```

## 3. Escrever dados no arquivo

Agora que você tem um `File` para trabalhar,
use-o para ler e escrever dados.
Primeiro, escreva alguns dados no arquivo.
O contador é um inteiro, mas é escrito no
arquivo como uma string usando a sintaxe `'$counter'`.

<?code-excerpt "lib/main.dart (writeCounter)"?>
```dart
Future<File> writeCounter(int counter) async {
  final file = await _localFile;

  // Write the file
  return file.writeAsString('$counter');
}
```

## 4. Ler dados do arquivo

Agora que você tem alguns dados em disco, você pode lê-los.
Mais uma vez, use a classe `File`.

<?code-excerpt "lib/main.dart (readCounter)"?>
```dart
Future<int> readCounter() async {
  try {
    final file = await _localFile;

    // Read the file
    final contents = await file.readAsString();

    return int.parse(contents);
  } catch (e) {
    // If encountering an error, return 0
    return 0;
  }
}
```

## Exemplo completo

<?code-excerpt "lib/main.dart"?>
```dart
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Reading and Writing Files',
      home: FlutterDemo(storage: CounterStorage()),
    ),
  );
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}

class FlutterDemo extends StatefulWidget {
  const FlutterDemo({super.key, required this.storage});

  final CounterStorage storage;

  @override
  State<FlutterDemo> createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((value) {
      setState(() {
        _counter = value;
      });
    });
  }

  Future<File> _incrementCounter() {
    setState(() {
      _counter++;
    });

    // Write the variable as a string to the file.
    return widget.storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading and Writing Files'),
      ),
      body: Center(
        child: Text(
          'Button tapped $_counter time${_counter == 1 ? '' : 's'}.',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

[`dart:io`]: {{site.api}}/flutter/dart-io/dart-io-library.html
[`File`]: {{site.api}}/flutter/dart-io/File-class.html
[`getCacheDir()`]: {{site.android-dev}}/reference/android/content/Context#getCacheDir()
[`NSCachesDirectory`]: {{site.apple-dev}}/documentation/foundation/nssearchpathdirectory/nscachesdirectory
[`path_provider`]: {{site.pub-pkg}}/path_provider
