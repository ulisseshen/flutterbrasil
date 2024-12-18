---
ia-translate: true
title: Ler e escrever arquivos
description: Como ler e escrever arquivos no disco.
---

<?code-excerpt path-base="cookbook/persistence/reading_writing_files/"?>

Em alguns casos, você precisa ler e gravar arquivos no disco.
Por exemplo, você pode precisar persistir dados entre inicializações do aplicativo,
ou baixar dados da internet e salvá-los para uso offline posterior.

Para salvar arquivos em disco em aplicativos móveis ou desktop,
combine o plugin [`path_provider`][] com a biblioteca [`dart:io`][].

Esta receita usa os seguintes passos:

  1. Encontre o caminho local correto.
  2. Crie uma referência para o local do arquivo.
  3. Escreva dados no arquivo.
  4. Leia dados do arquivo.

Para saber mais, assista a este vídeo do Package of the Week
sobre o pacote `path_provider`:

{% ytEmbed 'Ci4t-NkOY3I', 'path_provider | Pacote Flutter da semana' %}

:::note
Esta receita não funciona com aplicativos web neste momento.
Para acompanhar a discussão sobre este problema,
verifique `flutter/flutter` [issue #45296]({{site.repo.flutter}}/issues/45296).
:::

## 1. Encontre o caminho local correto

Este exemplo exibe um contador. Quando o contador muda,
escreva dados no disco para que você possa lê-los novamente quando o aplicativo carregar.
Onde você deve armazenar esses dados?

O pacote [`path_provider`][]
fornece uma maneira independente de plataforma para acessar locais comumente usados no
sistema de arquivos do dispositivo. O plugin atualmente oferece suporte ao acesso a
dois locais do sistema de arquivos:

*Diretório temporário*
: Um diretório temporário (cache) que o sistema pode
  limpar a qualquer momento. No iOS, isso corresponde a
  [`NSCachesDirectory`][]. No Android, este é o valor que
  [`getCacheDir()`][] retorna.

*Diretório de documentos*
: Um diretório para o aplicativo armazenar arquivos que apenas
  ele pode acessar. O sistema limpa o diretório somente quando o aplicativo
  é excluído.
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

## 2. Crie uma referência para o local do arquivo

Depois de saber onde armazenar o arquivo, crie uma referência para o
local completo do arquivo. Você pode usar a classe [`File`][]
da biblioteca [`dart:io`][] para realizar isso.

<?code-excerpt "lib/main.dart (localFile)"?>
```dart
Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/counter.txt');
}
```

## 3. Escreva dados no arquivo

Agora que você tem um `File` para trabalhar,
use-o para ler e escrever dados.
Primeiro, escreva alguns dados no arquivo.
O contador é um inteiro, mas é escrito no
arquivo como uma string usando a sintaxe `'$counter'`.

<?code-excerpt "lib/main.dart (writeCounter)"?>
```dart
Future<File> writeCounter(int counter) async {
  final file = await _localFile;

  // Escreve o arquivo
  return file.writeAsString('$counter');
}
```

## 4. Leia dados do arquivo

Agora que você tem alguns dados no disco, você pode lê-los.
Mais uma vez, use a classe `File`.

<?code-excerpt "lib/main.dart (readCounter)"?>
```dart
Future<int> readCounter() async {
  try {
    final file = await _localFile;

    // Lê o arquivo
    final contents = await file.readAsString();

    return int.parse(contents);
  } catch (e) {
    // Se ocorrer um erro, retorna 0
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
      title: 'Leitura e Escrita de Arquivos',
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

      // Lê o arquivo
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // Se ocorrer um erro, retorna 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Escreve o arquivo
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

    // Escreve a variável como uma string no arquivo.
    return widget.storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leitura e Escrita de Arquivos'),
      ),
      body: Center(
        child: Text(
          'Botão pressionado $_counter vez${_counter == 1 ? '' : 'es'}.',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Incrementar',
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
