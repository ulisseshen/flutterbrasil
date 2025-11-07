---
title: Busque dados da internet
description: Como buscar dados pela internet usando o pacote http.
ia-translate: true
---

<?code-excerpt path-base="cookbook/networking/fetch_data/"?>

Buscar dados da internet é necessário para a maioria dos aplicativos.
Felizmente, Dart e Flutter fornecem ferramentas, como o
pacote `http`, para este tipo de trabalho.

:::note
Você deve evitar usar diretamente `dart:io` ou `dart:html`
para fazer requisições HTTP.
Essas bibliotecas são dependentes de plataforma
e vinculadas a uma única implementação.
:::

Esta receita usa os seguintes passos:

  1. Adicione o pacote `http`.
  2. Faça uma requisição de rede usando o pacote `http`.
  3. Converta a resposta em um objeto Dart customizado.
  4. Busque e exiba os dados com Flutter.

## 1. Adicione o pacote `http`

O pacote [`http`][] fornece a
maneira mais simples de buscar dados da internet.

Para adicionar o pacote `http` como uma dependência,
execute `flutter pub add`:

```console
$ flutter pub add http
```

Importe o pacote http.

<?code-excerpt "lib/main.dart (Http)"?>
```dart
import 'package:http/http.dart' as http;
```

{% render docs/cookbook/networking/internet-permission.md %}

## 2. Faça uma requisição de rede

Esta receita cobre como buscar um álbum de exemplo do
[JSONPlaceholder][] usando o método [`http.get()`][].

<?code-excerpt "lib/main_step1.dart (fetchAlbum)"?>
```dart
Future<http.Response> fetchAlbum() {
  return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
}
```

O método `http.get()` retorna um `Future` que contém um `Response`.

* [`Future`][] é uma classe central do Dart para trabalhar com
  operações assíncronas. Um objeto Future representa um valor potencial
  ou erro que estará disponível em algum momento no futuro.
* A classe `http.Response` contém os dados recebidos de uma chamada
  http bem-sucedida.

## 3. Converta a resposta em um objeto Dart customizado

Embora seja fácil fazer uma requisição de rede, trabalhar com um
`Future<http.Response>` bruto não é muito conveniente.
Para facilitar sua vida,
converta o `http.Response` em um objeto Dart.

### Crie uma classe `Album`

Primeiro, crie uma classe `Album` que contém os dados da
requisição de rede. Ela inclui um construtor factory que
cria um `Album` a partir de JSON.

Converter JSON usando [pattern matching][] é apenas uma opção.
Para mais informações, veja o artigo completo sobre
[JSON and serialization][].

<?code-excerpt "lib/main.dart (Album)"?>
```dart
class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'userId': int userId,
        'id': int id,
        'title': String title,
      } =>
        Album(
          userId: userId,
          id: id,
          title: title,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
```

### Converta o `http.Response` em um `Album`

Agora, use os seguintes passos para atualizar a função `fetchAlbum()`
para retornar um `Future<Album>`:

  1. Converta o corpo da resposta em um `Map` JSON com
     o pacote `dart:convert`.
  2. Se o servidor retornar uma resposta OK com um código de status de
     200, então converta o `Map` JSON em um `Album`
     usando o método factory `fromJson()`.
  3. Se o servidor não retornar uma resposta OK com um código de status de 200,
     então lance uma exceção.
     (Mesmo no caso de uma resposta do servidor "404 Not Found",
     lance uma exceção. Não retorne `null`.
     Isso é importante ao examinar
     os dados em `snapshot`, conforme mostrado abaixo.)

<?code-excerpt "lib/main.dart (fetchAlbum)"?>
```dart
Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
```

Viva!
Agora você tem uma função que busca um álbum da internet.

## 4. Busque os dados

Chame o método `fetchAlbum()` nos métodos
[`initState()`][] ou [`didChangeDependencies()`][].

O método `initState()` é chamado exatamente uma vez e nunca mais.
Se você quiser ter a opção de recarregar a API em resposta a um
[`InheritedWidget`][] mudando, coloque a chamada no método
`didChangeDependencies()`.
Veja [`State`][] para mais detalhes.

<?code-excerpt "lib/main.dart (State)"?>
```dart
class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }
  // ···
}
```

Este Future é usado no próximo passo.

## 5. Exiba os dados

Para exibir os dados na tela, use o
widget [`FutureBuilder`][].
O widget `FutureBuilder` vem com Flutter e
facilita trabalhar com fontes de dados assíncronas.

Você deve fornecer dois parâmetros:

  1. O `Future` com o qual você deseja trabalhar.
     Neste caso, o future retornado da
     função `fetchAlbum()`.
  2. Uma função `builder` que diz ao Flutter
     o que renderizar, dependendo do
     estado do `Future`: loading, success, ou error.

Note que `snapshot.hasData` retorna `true` apenas
quando o snapshot contém um valor de dados não-nulo.

Como `fetchAlbum` só pode retornar valores não-nulos,
a função deve lançar uma exceção
mesmo no caso de uma resposta do servidor "404 Not Found".
Lançar uma exceção define `snapshot.hasError` como `true`
que pode ser usado para exibir uma mensagem de erro.

Caso contrário, o spinner será exibido.

<?code-excerpt "lib/main.dart (FutureBuilder)" replace="/^child: //g;/^\),$/)/g"?>
```dart
FutureBuilder<Album>(
  future: futureAlbum,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return Text(snapshot.data!.title);
    } else if (snapshot.hasError) {
      return Text('${snapshot.error}');
    }

    // By default, show a loading spinner.
    return const CircularProgressIndicator();
  },
)
```

## Por que fetchAlbum() é chamado em initState()?

Embora seja conveniente,
não é recomendado colocar uma chamada de API em um método `build()`.

Flutter chama o método `build()` toda vez que precisa
mudar algo na view,
e isso acontece surpreendentemente com frequência.
O método `fetchAlbum()`, se colocado dentro de `build()`, é repetidamente
chamado em cada reconstrução causando lentidão no app.

Armazenar o resultado de `fetchAlbum()` em uma variável de estado garante que
o `Future` seja executado apenas uma vez e então armazenado em cache para
reconstruções subsequentes.

## Testando

Para informações sobre como testar esta funcionalidade,
veja as seguintes receitas:

  * [Introduction to unit testing][]
  * [Mock dependencies using Mockito][]

## Exemplo completo

<?code-excerpt "lib/main.dart"?>
```dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'userId': int userId,
        'id': int id,
        'title': String title,
      } =>
        Album(
          userId: userId,
          id: id,
          title: title,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.title);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
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


[`didChangeDependencies()`]: {{site.api}}/flutter/widgets/State/didChangeDependencies.html
[`Future`]: {{site.api}}/flutter/dart-async/Future-class.html
[`FutureBuilder`]: {{site.api}}/flutter/widgets/FutureBuilder-class.html
[JSONPlaceholder]: https://jsonplaceholder.typicode.com/
[`http`]: {{site.pub-pkg}}/http
[`http.get()`]: {{site.pub-api}}/http/latest/http/get.html
[`http` package]: {{site.pub-pkg}}/http/install
[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[Introduction to unit testing]: /cookbook/testing/unit/introduction
[`initState()`]: {{site.api}}/flutter/widgets/State/initState.html
[Mock dependencies using Mockito]: /cookbook/testing/unit/mocking
[JSON and serialization]: /data-and-backend/serialization/json
[pattern matching]: {{site.dart-site}}/language/patterns
[`State`]: {{site.api}}/flutter/widgets/State-class.html
