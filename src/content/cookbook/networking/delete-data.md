---
title: Delete dados na internet
description: Como usar o pacote http para deletar dados na internet.
ia-translate: true
---

<?code-excerpt path-base="cookbook/networking/delete_data/"?>

Esta receita cobre como deletar dados através
da internet usando o pacote `http`.

Esta receita usa os seguintes passos:

  1. Adicione o pacote `http`.
  2. Delete dados no servidor.
  3. Atualize a tela.

## 1. Adicione o pacote `http`

Para adicionar o pacote `http` como uma dependência,
execute `flutter pub add`:

```console
$ flutter pub add http
```

Importe o pacote `http`.

<?code-excerpt "lib/main.dart (Http)"?>
```dart
import 'package:http/http.dart' as http;
```

{% render docs/cookbook/networking/internet-permission.md %}

## 2. Delete dados no servidor

Esta receita cobre como deletar um álbum do
[JSONPlaceholder][] usando o método `http.delete()`.
Note que isso requer o `id` do álbum que
você deseja deletar. Para este exemplo,
use algo que você já conhece, por exemplo `id = 1`.

<?code-excerpt "lib/main_step1.dart (deleteAlbum)"?>
```dart
Future<http.Response> deleteAlbum(String id) async {
  final http.Response response = await http.delete(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  return response;
}
```

O método `http.delete()` retorna um `Future` que contém um `Response`.

* [`Future`][] é uma classe central do Dart para trabalhar com
  operações assíncronas. Um objeto Future representa um valor potencial
  ou erro que estará disponível em algum momento no futuro.
* A classe `http.Response` contém os dados recebidos de uma chamada
  http bem-sucedida.
* O método `deleteAlbum()` recebe um argumento `id` que
  é necessário para identificar os dados a serem deletados do servidor.

## 3. Atualize a tela

Para verificar se os dados foram deletados ou não,
primeiro busque os dados do [JSONPlaceholder][]
usando o método `http.get()` e os exiba na tela.
(Veja a receita [Fetch Data][] para um exemplo completo.)
Agora você deve ter um botão **Delete Data** que,
quando pressionado, chama o método `deleteAlbum()`.

<?code-excerpt "lib/main.dart (Column)" replace="/return //g"?>
```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
    Text(snapshot.data?.title ?? 'Deleted'),
    ElevatedButton(
      child: const Text('Delete Data'),
      onPressed: () {
        setState(() {
          _futureAlbum =
              deleteAlbum(snapshot.data!.id.toString());
        });
      },
    ),
  ],
);
```
Agora, quando você clicar no botão ***Delete Data***,
o método `deleteAlbum()` é chamado e o id
que você está passando é o id dos dados que você recuperou
da internet. Isso significa que você vai deletar
os mesmos dados que você buscou da internet.

### Retornando uma resposta do método deleteAlbum()
Uma vez que a requisição de delete foi feita,
você pode retornar uma resposta do método `deleteAlbum()`
para notificar sua tela que os dados foram deletados.

<?code-excerpt "lib/main.dart (deleteAlbum)"?>
```dart
Future<Album> deleteAlbum(String id) async {
  final http.Response response = await http.delete(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then return an empty Album. After deleting,
    // you'll get an empty JSON `{}` response.
    // Don't return `null`, otherwise `snapshot.hasData`
    // will always return false on `FutureBuilder`.
    return Album.empty();
  } else {
    // If the server did not return a "200 OK response",
    // then throw an exception.
    throw Exception('Failed to delete album.');
  }
}
```

`FutureBuilder()` agora reconstrói quando recebe uma resposta.
Como a resposta não terá nenhum dado em seu corpo
se a requisição for bem-sucedida,
o método `Album.fromJson()` cria uma instância do
objeto `Album` com um valor padrão (`null` no nosso caso).
Este comportamento pode ser alterado da maneira que você desejar.

É isso!
Agora você tem uma função que deleta dados da internet.

## Exemplo completo

<?code-excerpt "lib/main.dart"?>
```dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<Album> deleteAlbum(String id) async {
  final http.Response response = await http.delete(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then return an empty Album. After deleting,
    // you'll get an empty JSON `{}` response.
    // Don't return `null`, otherwise `snapshot.hasData`
    // will always return false on `FutureBuilder`.
    return Album.empty();
  } else {
    // If the server did not return a "200 OK response",
    // then throw an exception.
    throw Exception('Failed to delete album.');
  }
}

class Album {
  int? id;
  String? title;

  Album({this.id, this.title});

  Album.empty();

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'title': String title,
      } =>
        Album(
          id: id,
          title: title,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  late Future<Album> _futureAlbum;

  @override
  void initState() {
    super.initState();
    _futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delete Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Delete Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: _futureAlbum,
            builder: (context, snapshot) {
              // If the connection is done,
              // check for response data or an error.
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(snapshot.data?.title ?? 'Deleted'),
                      ElevatedButton(
                        child: const Text('Delete Data'),
                        onPressed: () {
                          setState(() {
                            _futureAlbum =
                                deleteAlbum(snapshot.data!.id.toString());
                          });
                        },
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
```

[Fetch Data]: /cookbook/networking/fetch-data
[ConnectionState]: {{site.api}}/flutter/widgets/ConnectionState-class.html
[`didChangeDependencies()`]: {{site.api}}/flutter/widgets/State/didChangeDependencies.html
[`Future`]: {{site.api}}/flutter/dart-async/Future-class.html
[`FutureBuilder`]: {{site.api}}/flutter/widgets/FutureBuilder-class.html
[JSONPlaceholder]: https://jsonplaceholder.typicode.com/
[`http`]: {{site.pub-pkg}}/http
[`http.delete()`]: {{site.pub-api}}/http/latest/http/delete.html
[`http` package]: {{site.pub-pkg}}/http/install
[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[Introduction to unit testing]: /cookbook/testing/unit/introduction
[`initState()`]: {{site.api}}/flutter/widgets/State/initState.html
[Mock dependencies using Mockito]: /cookbook/testing/unit/mocking
[JSON and serialization]: /data-and-backend/serialization/json
[`State`]: {{site.api}}/flutter/widgets/State-class.html
