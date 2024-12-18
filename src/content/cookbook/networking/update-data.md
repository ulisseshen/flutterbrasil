---
ia-translate: true
# Atualizar dados pela internet
description: Como usar o pacote http para atualizar dados pela internet.
---

<?code-excerpt path-base="cookbook/networking/update_data/"?>

Atualizar dados pela internet é necessário para a maioria dos aplicativos.
O pacote `http` resolve isso!

Esta receita usa os seguintes passos:

  1. Adicione o pacote `http`.
  2. Atualize dados pela internet usando o pacote `http`.
  3. Converta a resposta em um objeto Dart personalizado.
  4. Obtenha os dados da internet.
  5. Atualize o `title` existente a partir da entrada do usuário.
  6. Atualize e exiba a resposta na tela.

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

## 2. Atualizando dados pela internet usando o pacote `http`

Esta receita aborda como atualizar o título de um álbum no
[JSONPlaceholder][] usando o método [`http.put()`][].

<?code-excerpt "lib/main_step2.dart (updateAlbum)"?>
```dart
Future<http.Response> updateAlbum(String title) {
  return http.put(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );
}
```

O método `http.put()` retorna um `Future` que contém uma `Response`.

* [`Future`][] é uma classe central do Dart para trabalhar com
  operações assíncronas. Um objeto `Future` representa um valor
  ou erro potencial que estará disponível em algum momento no futuro.
* A classe `http.Response` contém os dados recebidos de uma chamada
  http bem-sucedida.
* O método `updateAlbum()` recebe um argumento, `title`,
  que é enviado ao servidor para atualizar o `Album`.

## 3. Converter a `http.Response` em um objeto Dart personalizado

Embora seja fácil fazer uma requisição de rede,
trabalhar com um `Future<http.Response>` bruto
não é muito conveniente. Para facilitar sua vida,
converta a `http.Response` em um objeto Dart.

### Crie uma classe Album

Primeiro, crie uma classe `Album` que contenha os dados da
requisição de rede. Ela inclui um construtor factory que
cria um `Album` a partir de JSON.

Converter JSON com [pattern matching][] é apenas uma opção.
Para mais informações, veja o artigo completo sobre
[JSON e serialização][].

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
      _ => throw const FormatException('Falha ao carregar o álbum.'),
    };
  }
}
```

### Converta a `http.Response` em um `Album`

Agora, use os seguintes passos para atualizar a função `updateAlbum()`
para retornar um `Future<Album>`:

  1. Converta o corpo da resposta em um `Map` JSON com o
     pacote `dart:convert`.
  2. Se o servidor retornar uma resposta `UPDATED` com um código
     de status 200, então converta o `Map` JSON em um `Album`
     usando o método factory `fromJson()`.
  3. Se o servidor não retornar uma resposta `UPDATED` com um
     código de status 200, então lance uma exceção.
     (Mesmo no caso de uma resposta do servidor "404 Não Encontrado",
     lance uma exceção. Não retorne `null`.
     Isso é importante ao examinar
     os dados em `snapshot`, como mostrado abaixo.)

<?code-excerpt "lib/main.dart (updateAlbum)"?>
```dart
Future<Album> updateAlbum(String title) async {
  final response = await http.put(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  if (response.statusCode == 200) {
    // Se o servidor retornar uma resposta 200 OK,
    // então faça o parse do JSON.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // Se o servidor não retornar uma resposta 200 OK,
    // então lance uma exceção.
    throw Exception('Falha ao atualizar o álbum.');
  }
}
```

Parabéns!
Agora você tem uma função que atualiza o título de um álbum.

### Obtenha os dados da internet

Obtenha os dados da internet antes de poder atualizá-los.
Para um exemplo completo, veja a receita [Buscar dados][].

<?code-excerpt "lib/main.dart (fetchAlbum)"?>
```dart
Future<Album> fetchAlbum() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
  );

  if (response.statusCode == 200) {
    // Se o servidor retornou uma resposta 200 OK,
    // então faça o parse do JSON.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // Se o servidor não retornou uma resposta 200 OK,
    // então lance uma exceção.
    throw Exception('Falha ao carregar o álbum');
  }
}
```

Idealmente, você usará este método para definir
`_futureAlbum` durante `initState` para buscar
os dados da internet.

## 4. Atualize o título existente a partir da entrada do usuário

Crie um `TextField` para inserir um título e um `ElevatedButton`
para atualizar os dados no servidor.
Defina também um `TextEditingController` para
ler a entrada do usuário de um `TextField`.

Quando o `ElevatedButton` é pressionado,
o `_futureAlbum` é definido com o valor retornado pelo
método `updateAlbum()`.

<?code-excerpt "lib/main_step5.dart (Column)"?>
```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: 'Digite o Título'),
      ),
    ),
    ElevatedButton(
      onPressed: () {
        setState(() {
          _futureAlbum = updateAlbum(_controller.text);
        });
      },
      child: const Text('Atualizar Dados'),
    ),
  ],
);
```

Ao pressionar o botão **Atualizar Dados**, uma requisição de rede
envia os dados no `TextField` para o servidor como uma requisição `PUT`.
A variável `_futureAlbum` é usada no próximo passo.

## 5. Exiba a resposta na tela

Para exibir os dados na tela, use o
widget [`FutureBuilder`][].
O widget `FutureBuilder` vem com o Flutter e
facilita o trabalho com fontes de dados assíncronas.
Você deve fornecer dois parâmetros:

  1. O `Future` com o qual você deseja trabalhar. Neste caso,
     o future retornado pela função `updateAlbum()`.
  2. Uma função `builder` que diz ao Flutter o que renderizar,
     dependendo do estado do `Future`: carregando,
     sucesso ou erro.

Observe que `snapshot.hasData` só retorna `true` quando
o snapshot contém um valor de dados não nulo.
É por isso que a função `updateAlbum` deve lançar uma exceção
mesmo no caso de uma resposta do servidor "404 Não Encontrado".
Se `updateAlbum` retornar `null`, então o
`CircularProgressIndicator` será exibido indefinidamente.

<?code-excerpt "lib/main_step5.dart (FutureBuilder)"?>
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
);
```

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
    // Se o servidor retornou uma resposta 200 OK,
    // então faça o parse do JSON.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // Se o servidor não retornou uma resposta 200 OK,
    // então lance uma exceção.
    throw Exception('Falha ao carregar o álbum');
  }
}

Future<Album> updateAlbum(String title) async {
  final response = await http.put(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  if (response.statusCode == 200) {
    // Se o servidor retornou uma resposta 200 OK,
    // então faça o parse do JSON.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // Se o servidor não retornou uma resposta 200 OK,
    // então lance uma exceção.
    throw Exception('Falha ao atualizar o álbum.');
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
      _ => throw const FormatException('Falha ao carregar o álbum.'),
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
  late Future<Album> _futureAlbum;

  @override
  void initState() {
    super.initState();
    _futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo de Atualização de Dados',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Exemplo de Atualização de Dados'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: FutureBuilder<Album>(
            future: _futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(snapshot.data!.title),
                      TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Digite o Título',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _futureAlbum = updateAlbum(_controller.text);
                          });
                        },
                        child: const Text('Atualizar Dados'),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
```

[ConnectionState]: {{site.api}}/flutter/widgets/ConnectionState-class.html
[`didChangeDependencies()`]: {{site.api}}/flutter/widgets/State/didChangeDependencies.html
[Buscar dados]: /cookbook/networking/fetch-data
[`Future`]: {{site.api}}/flutter/dart-async/Future-class.html
[`FutureBuilder`]: {{site.api}}/flutter/widgets/FutureBuilder-class.html
[`http`]: {{site.pub-pkg}}/http
[`http.put()`]: {{site.pub-api}}/http/latest/http/put.html
[`http` package]: {{site.pub}}/packages/http/install
[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[Introduction to unit testing]: /cookbook/testing/unit/introduction
[`initState()`]: {{site.api}}/flutter/widgets/State/initState.html
[JSONPlaceholder]: https://jsonplaceholder.typicode.com/
[JSON e serialização]: /data-and-backend/serialization/json
[Mock dependencies using Mockito]: /cookbook/testing/unit/mocking
[pattern matching]: {{site.dart-site}}/language/patterns
[`State`]: {{site.api}}/flutter/widgets/State-class.html
