---
ia-translate: true
title: Enviar dados para a internet
description: Como usar o pacote http para enviar dados pela internet.
---

<?code-excerpt path-base="cookbook/networking/send_data/"?>

Enviar dados para a internet é necessário para a maioria dos aplicativos. O pacote `http` também cobre isso.

Esta receita usa os seguintes passos:

  1. Adicionar o pacote `http`.
  2. Enviar dados para um servidor usando o pacote `http`.
  3. Converter a resposta em um objeto Dart personalizado.
  4. Obter um `title` da entrada do usuário.
  5. Exibir a resposta na tela.

## 1. Adicionar o pacote `http`

Para adicionar o pacote `http` como uma dependência, execute `flutter pub add`:

```console
$ flutter pub add http
```

Importe o pacote `http`.

<?code-excerpt "lib/main.dart (Http)"?>
```dart
import 'package:http/http.dart' as http;
```

{% render docs/cookbook/networking/internet-permission.md %}

## 2. Enviando dados para o servidor

Esta receita aborda como criar um `Album` enviando um título de álbum para o [JSONPlaceholder][] usando o método [`http.post()`][].

Importe `dart:convert` para acesso a `jsonEncode` para codificar os dados:

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
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );
}
```

O método `http.post()` retorna um `Future` que contém um `Response`.

* [`Future`][] é uma classe Dart central para trabalhar com
  operações assíncronas. Um objeto Future representa um valor ou erro potencial que estará disponível em algum momento no futuro.
* A classe `http.Response` contém os dados recebidos de uma chamada
  http bem-sucedida.
* O método `createAlbum()` recebe um argumento `title`
  que é enviado ao servidor para criar um `Album`.

## 3. Converter o `http.Response` em um objeto Dart personalizado

Embora seja fácil fazer uma requisição de rede, trabalhar com um `Future<http.Response>` bruto não é muito conveniente. Para tornar sua vida mais fácil, converta o `http.Response` em um objeto Dart.

### Criar uma classe Album

Primeiro, crie uma classe `Album` que contenha os dados da requisição de rede. Ela inclui um construtor de fábrica que cria um `Album` a partir de JSON.

Converter JSON com [pattern matching][] é apenas uma opção. Para mais informações, consulte o artigo completo sobre [JSON e serialização][].

<?code-excerpt "lib/main.dart (Album)"?>
```dart
class Album {
  final int id;
  final String title;

  const Album({required this.id, required this.title});

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
      _ => throw const FormatException('Falha ao carregar álbum.'),
    };
  }
}
```

### Converter o `http.Response` para um `Album`

Use os seguintes passos para atualizar a função `createAlbum()` para retornar um `Future<Album>`:

  1. Converta o corpo da resposta em um `Map` JSON com o pacote
     `dart:convert`.
  2. Se o servidor retornar uma resposta `CREATED` com um código de
     status 201, então converta o `Map` JSON em um `Album` usando o método
     de fábrica `fromJson()`.
  3. Se o servidor não retornar uma resposta `CREATED` com um código de
     status 201, então lance uma exceção.
     (Mesmo no caso de uma resposta de servidor "404 Not Found",
     lance uma exceção. Não retorne `null`. Isso é importante ao examinar
     os dados em `snapshot`, como mostrado abaixo.)

<?code-excerpt "lib/main.dart (createAlbum)"?>
```dart
Future<Album> createAlbum(String title) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  if (response.statusCode == 201) {
    // Se o servidor retornou uma resposta 201 CREATED,
    // então parse o JSON.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // Se o servidor não retornou uma resposta 201 CREATED,
    // então lance uma exceção.
    throw Exception('Falha ao criar álbum.');
  }
}
```

Ótimo! Agora você tem uma função que envia o título para um
servidor para criar um álbum.

## 4. Obter um título da entrada do usuário

Em seguida, crie um `TextField` para inserir um título e um
`ElevatedButton` para enviar dados para o servidor.
Também defina um `TextEditingController` para ler a entrada do usuário de um `TextField`.

Quando o `ElevatedButton` é pressionado, o `_futureAlbum` é definido com o valor retornado pelo método `createAlbum()`.

<?code-excerpt "lib/main.dart (Column)" replace="/^return //g;/^\);$/)/g"?>
```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
    TextField(
      controller: _controller,
      decoration: const InputDecoration(hintText: 'Insira o Título'),
    ),
    ElevatedButton(
      onPressed: () {
        setState(() {
          _futureAlbum = createAlbum(_controller.text);
        });
      },
      child: const Text('Criar Dados'),
    ),
  ],
)
```

Ao pressionar o botão **Criar Dados**, faça a requisição de rede,
que envia os dados no `TextField` para o servidor
como uma requisição `POST`.
O Future, `_futureAlbum`, é usado no próximo passo.

## 5. Exibir a resposta na tela

Para exibir os dados na tela, use o widget [`FutureBuilder`][].
O widget `FutureBuilder` vem com o Flutter e facilita o trabalho com fontes de dados assíncronas. Você deve fornecer dois parâmetros:

  1. O `Future` com o qual você deseja trabalhar. Neste caso,
     o future retornado da função `createAlbum()`.
  2. Uma função `builder` que diz ao Flutter o que renderizar,
     dependendo do estado do `Future`: carregando, sucesso ou erro.

Observe que `snapshot.hasData` só retorna `true` quando o snapshot contém um valor de dados não-nulo. É por isso que a função `createAlbum()` deve lançar uma exceção, mesmo no caso de uma resposta do servidor "404 Não Encontrado". Se `createAlbum()` retornar `null`, então `CircularProgressIndicator` é exibido indefinidamente.

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
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  if (response.statusCode == 201) {
    // Se o servidor retornou uma resposta 201 CREATED,
    // então parse o JSON.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // Se o servidor não retornou uma resposta 201 CREATED,
    // então lance uma exceção.
    throw Exception('Falha ao criar álbum.');
  }
}

class Album {
  final int id;
  final String title;

  const Album({required this.id, required this.title});

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
      _ => throw const FormatException('Falha ao carregar álbum.'),
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
      title: 'Exemplo de Criar Dados',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Exemplo de Criar Dados'),
        ),
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
          decoration: const InputDecoration(hintText: 'Insira o Título'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureAlbum = createAlbum(_controller.text);
            });
          },
          child: const Text('Criar Dados'),
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
