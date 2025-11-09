---
ia-translate: true
title: Enviar dados para a internet
description: Como usar o pacote http para enviar dados pela internet.
---

<?code-excerpt path-base="cookbook/networking/send_data/"?>

Enviar dados para a internet é necessário para a maioria dos apps.
O pacote `http` também cobre isso.

Esta receita usa as seguintes etapas:

  1. Adicionar o pacote `http`.
  2. Enviar dados para um servidor usando o pacote `http`.
  3. Converter a resposta em um objeto Dart customizado.
  4. Obter um `title` da entrada do usuário.
  5. Exibir a resposta na tela.

## 1. Adicionar o pacote `http`

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

{% render "docs/cookbook/networking/internet-permission.md" %}

## 2. Enviar dados para o servidor

Esta receita cobre como criar um `Album`
enviando um título de álbum para o
[JSONPlaceholder][] usando o
método [`http.post()`][].

Importe `dart:convert` para acessar `jsonEncode` para codificar os dados:

<?code-excerpt "lib/create_album.dart (convert-import)"?>
```dart
import 'dart:convert';
```

Use o método `http.post()` para enviar os dados codificados:

<?code-excerpt "lib/create_album.dart (CreateAlbum)"?>
```dart
Future<http.Response> createAlbum(String title) {
  return http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'title': title}),
  );
}
```

O método `http.post()` retorna uma `Future` que contém uma `Response`.

* [`Future`][] é uma classe central do Dart para trabalhar com
  operações assíncronas. Um objeto Future representa um valor potencial
  ou erro que estará disponível em algum momento no futuro.
* A classe `http.Response` contém os dados recebidos de uma
  chamada http bem-sucedida.
* O método `createAlbum()` recebe um argumento `title`
  que é enviado para o servidor para criar um `Album`.

## 3. Converter a `http.Response` para um objeto Dart customizado

Embora seja fácil fazer uma requisição de rede,
trabalhar com uma `Future<http.Response>` bruta
não é muito conveniente. Para facilitar sua vida,
converta a `http.Response` em um objeto Dart.

### Criar uma classe Album

Primeiro, crie uma classe `Album` que contém
os dados da requisição de rede.
Ela inclui um construtor factory que
cria um `Album` a partir de JSON.

Converter JSON com [pattern matching][] é apenas uma opção.
Para mais informações, veja o artigo completo sobre
[JSON and serialization][].

<?code-excerpt "lib/main.dart (Album)"?>
```dart
class Album {
  final int id;
  final String title;

  const Album({required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'id': int id, 'title': String title} => Album(id: id, title: title),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
```

### Converter a `http.Response` para um `Album`

Use as seguintes etapas para atualizar a função `createAlbum()`
para retornar uma `Future<Album>`:

  1. Converter o corpo da resposta em um `Map` JSON com o
     pacote `dart:convert`.
  2. Se o servidor retornar uma resposta `CREATED` com um código de
     status 201, então converter o `Map` JSON em um `Album`
     usando o método factory `fromJson()`.
  3. Se o servidor não retornar uma resposta `CREATED` com um
     código de status 201, então lançar uma exceção.
     (Mesmo no caso de uma resposta do servidor "404 Not Found",
     lançar uma exceção. Não retornar `null`.
     Isso é importante ao examinar
     os dados em `snapshot`, como mostrado abaixo.)

<?code-excerpt "lib/main.dart (createAlbum)"?>
```dart
Future<Album> createAlbum(String title) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'title': title}),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}
```

Oba! Agora você tem uma função que envia o título para um
servidor para criar um álbum.

## 4. Obter um título da entrada do usuário

Em seguida, crie um `TextField` para inserir um título e
um `ElevatedButton` para enviar dados ao servidor.
Também defina um `TextEditingController` para ler a
entrada do usuário de um `TextField`.

Quando o `ElevatedButton` é pressionado, o `_futureAlbum`
é definido com o valor retornado pelo método `createAlbum()`.

<?code-excerpt "lib/main.dart (Column)" replace="/^return //g;/^\);$/)/g"?>
```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
    TextField(
      controller: _controller,
      decoration: const InputDecoration(hintText: 'Enter Title'),
    ),
    ElevatedButton(
      onPressed: () {
        setState(() {
          _futureAlbum = createAlbum(_controller.text);
        });
      },
      child: const Text('Create Data'),
    ),
  ],
)
```

Ao pressionar o botão **Create Data**, faça a requisição de rede,
que envia os dados no `TextField` para o servidor
como uma requisição `POST`.
A Future, `_futureAlbum`, é usada na próxima etapa.

## 5. Exibir a resposta na tela

Para exibir os dados na tela, use o
widget [`FutureBuilder`][].
O widget `FutureBuilder` vem com Flutter e
facilita o trabalho com fontes de dados assíncronas.
Você deve fornecer dois parâmetros:

  1. A `Future` com a qual você quer trabalhar. Neste caso,
     a future retornada da função `createAlbum()`.
  2. Uma função `builder` que diz ao Flutter o que renderizar,
     dependendo do estado da `Future`: carregando,
     sucesso ou erro.

Note que `snapshot.hasData` retorna `true` apenas quando
o snapshot contém um valor de dados não-nulo.
É por isso que a função `createAlbum()` deve lançar uma exceção
mesmo no caso de uma resposta do servidor "404 Not Found".
Se `createAlbum()` retornar `null`, então
`CircularProgressIndicator` será exibido indefinidamente.

<?code-excerpt "lib/main.dart (FutureBuilder)" replace="/^return //g;/^\);$/)/g"?>
```dart
FutureBuilder<Album>(
  future: _futureAlbum,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return Text(snapshot.data!.title);
    } else if (snapshot.hasError) {
      return Text('${snapshot.error}');
    }

    return const CircularProgressIndicator();
  },
)
```

## Exemplo completo

<?code-excerpt "lib/main.dart"?>
```dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> createAlbum(String title) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'title': title}),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

class Album {
  final int id;
  final String title;

  const Album({required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'id': int id, 'title': String title} => Album(id: id, title: title),
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
  final TextEditingController _controller = TextEditingController();
  Future<Album>? _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Create Data Example')),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: (_futureAlbum == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Enter Title'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureAlbum = createAlbum(_controller.text);
            });
          },
          child: const Text('Create Data'),
        ),
      ],
    );
  }

  FutureBuilder<Album> buildFutureBuilder() {
    return FutureBuilder<Album>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.title);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
```

[ConnectionState]: {{site.api}}/flutter/widgets/ConnectionState-class.html
[`didChangeDependencies()`]: {{site.api}}/flutter/widgets/State/didChangeDependencies.html
[Fetch Data]: /cookbook/networking/fetch-data
[`Future`]: {{site.api}}/flutter/dart-async/Future-class.html
[`FutureBuilder`]: {{site.api}}/flutter/widgets/FutureBuilder-class.html
[`http`]: {{site.pub-pkg}}/http
[`http.post()`]: {{site.pub-api}}/http/latest/http/post.html
[`http` package]: {{site.pub-pkg}}/http/install
[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[Introduction to unit testing]: /cookbook/testing/unit/introduction
[`initState()`]: {{site.api}}/flutter/widgets/State/initState.html
[JSONPlaceholder]: https://jsonplaceholder.typicode.com/
[JSON and serialization]: /data-and-backend/serialization/json
[Mock dependencies using Mockito]: /cookbook/testing/unit/mocking
[pattern matching]: {{site.dart-site}}/language/patterns
[`State`]: {{site.api}}/flutter/widgets/State-class.html
