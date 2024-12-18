---
ia-translate: true
title: Buscar dados da internet
description: Como buscar dados pela internet usando o pacote http.
---

<?code-excerpt path-base="cookbook/networking/fetch_data/"?>

Buscar dados da internet é necessário para a maioria dos aplicativos. Felizmente, Dart e Flutter fornecem ferramentas, como o pacote `http`, para esse tipo de trabalho.

:::note
Você deve evitar usar diretamente `dart:io` ou `dart:html` para fazer requisições HTTP. Essas bibliotecas são dependentes de plataforma e estão vinculadas a uma única implementação.
:::

Esta receita usa os seguintes passos:

  1. Adicionar o pacote `http`.
  2. Fazer uma requisição de rede usando o pacote `http`.
  3. Converter a resposta em um objeto Dart personalizado.
  4. Buscar e exibir os dados com Flutter.

## 1. Adicionar o pacote `http`

O pacote [`http`][] fornece a maneira mais simples de buscar dados da internet.

Para adicionar o pacote `http` como uma dependência, execute `flutter pub add`:

```console
$ flutter pub add http
```

Importe o pacote http.

<?code-excerpt "lib/main.dart (Http)"?>
```dart
import 'package:http/http.dart' as http;
```

{% render docs/cookbook/networking/internet-permission.md %}

## 2. Fazer uma requisição de rede

Esta receita aborda como buscar um álbum de amostra do [JSONPlaceholder][] usando o método [`http.get()`][].

<?code-excerpt "lib/main_step1.dart (fetchAlbum)"?>
```dart
Future<http.Response> fetchAlbum() {
  return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
}
```

O método `http.get()` retorna um `Future` que contém uma `Response`.

* [`Future`][] é uma classe core do Dart para trabalhar com operações assíncronas. Um objeto Future representa um valor ou erro potencial que estará disponível em algum momento no futuro.
* A classe `http.Response` contém os dados recebidos de uma chamada http bem-sucedida.

## 3. Converter a resposta em um objeto Dart personalizado

Embora seja fácil fazer uma requisição de rede, trabalhar com um `Future<http.Response>` bruto não é muito conveniente. Para facilitar sua vida, converta o `http.Response` em um objeto Dart.

### Criar uma classe `Album`

Primeiro, crie uma classe `Album` que contenha os dados da requisição de rede. Ela inclui um construtor factory que cria um `Album` a partir de JSON.

Converter JSON usando [pattern matching][] é apenas uma opção. Para mais informações, veja o artigo completo sobre [JSON e serialização][].

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
      _ => throw const FormatException('Falha ao carregar álbum.'),
    };
  }
}
```

### Converter o `http.Response` para um `Album`

Agora, use os seguintes passos para atualizar a função `fetchAlbum()` para retornar um `Future<Album>`:

  1. Converta o corpo da resposta em um `Map` JSON com o pacote `dart:convert`.
  2. Se o servidor retornar uma resposta OK com um código de status 200, então converta o `Map` JSON em um `Album` usando o método factory `fromJson()`.
  3. Se o servidor não retornar uma resposta OK com um código de status 200, então lance uma exceção. (Mesmo no caso de uma resposta do servidor "404 Não Encontrado", lance uma exceção. Não retorne `null`. Isso é importante ao examinar os dados em `snapshot`, conforme mostrado abaixo.)

<?code-excerpt "lib/main.dart (fetchAlbum)"?>
```dart
Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // Se o servidor retornou uma resposta 200 OK,
    // então analise o JSON.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // Se o servidor não retornou uma resposta 200 OK,
    // então lance uma exceção.
    throw Exception('Falha ao carregar álbum');
  }
}
```

Hooray! Agora você tem uma função que busca um álbum da internet.

## 4. Buscar os dados

Chame o método `fetchAlbum()` nos métodos [`initState()`][] ou [`didChangeDependencies()`][].

O método `initState()` é chamado exatamente uma vez e nunca mais. Se você quiser ter a opção de recarregar a API em resposta a uma mudança de [`InheritedWidget`][], coloque a chamada no método `didChangeDependencies()`. Veja [`State`][] para mais detalhes.

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

## 5. Exibir os dados

Para exibir os dados na tela, use o widget [`FutureBuilder`][]. O widget `FutureBuilder` já vem com o Flutter e facilita o trabalho com fontes de dados assíncronas.

Você deve fornecer dois parâmetros:

  1. O `Future` com o qual você quer trabalhar. Neste caso, o future retornado da função `fetchAlbum()`.
  2. Uma função `builder` que diz ao Flutter o que renderizar, dependendo do estado do `Future`: carregando, sucesso ou erro.

Note que `snapshot.hasData` só retorna `true` quando o snapshot contém um valor de dados não nulo.

Como `fetchAlbum` só pode retornar valores não nulos, a função deve lançar uma exceção mesmo no caso de uma resposta do servidor "404 Não Encontrado". Lançar uma exceção define o `snapshot.hasError` como `true`, que pode ser usado para exibir uma mensagem de erro.

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

    // Por padrão, mostra um spinner de carregamento.
    return const CircularProgressIndicator();
  },
)
```

## Por que `fetchAlbum()` é chamado em `initState()`?

Embora seja conveniente, não é recomendado colocar uma chamada de API em um método `build()`.

O Flutter chama o método `build()` toda vez que precisa alterar algo na visualização, e isso acontece surpreendentemente com frequência. O método `fetchAlbum()`, se colocado dentro de `build()`, é repetidamente chamado em cada reconstrução, fazendo com que o aplicativo fique lento.

Armazenar o resultado de `fetchAlbum()` em uma variável de estado garante que o `Future` seja executado apenas uma vez e, em seguida, armazenado em cache para reconstruções subsequentes.

## Testando

Para informações sobre como testar essa funcionalidade, veja as seguintes receitas:

  * [Introdução a testes unitários][]
  * [Simular dependências usando Mockito][]

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
    // Se o servidor retornou uma resposta 200 OK,
    // então analise o JSON.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // Se o servidor não retornou uma resposta 200 OK,
    // então lance uma exceção.
    throw Exception('Falha ao carregar álbum');
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
      _ => throw const FormatException('Falha ao carregar álbum.'),
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
      title: 'Exemplo de Busca de Dados',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Exemplo de Busca de Dados'),
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

              // Por padrão, mostra um spinner de carregamento.
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
[Introdução a testes unitários]: /cookbook/testing/unit/introduction
[`initState()`]: {{site.api}}/flutter/widgets/State/initState.html
[Simular dependências usando Mockito]: /cookbook/testing/unit/mocking
[JSON e serialização]: /data-and-backend/serialization/json
[pattern matching]: {{site.dart-site}}/language/patterns
[`State`]: {{site.api}}/flutter/widgets/State-class.html
