---
ia-translate: true
title: Mock de dependências usando o Mockito
description: >
  Use o pacote Mockito para simular o comportamento de serviços para testes.
short-title: Mocking
---

<?code-excerpt path-base="cookbook/testing/unit/mocking"?>

Às vezes, os testes de unidade podem depender de classes que buscam dados de serviços da Web ou bancos de dados ativos. Isso é inconveniente por alguns motivos:

*   Chamar serviços da Web ou bancos de dados ativos torna a execução do teste mais lenta.
*   Um teste que estava passando pode começar a falhar se um serviço da Web ou banco de dados retornar resultados inesperados. Isso é conhecido como "teste instável".
*   É difícil testar todos os cenários possíveis de sucesso e falha usando um serviço da Web ou banco de dados ativo.

Portanto, em vez de depender de um serviço da Web ou banco de dados ativo, você pode "simular" (mock) essas dependências. Os mocks permitem emular um serviço da Web ou banco de dados ativo e retornar resultados específicos dependendo da situação.

De um modo geral, você pode simular dependências criando uma implementação alternativa de uma classe. Escreva essas implementações alternativas manualmente ou use o pacote [Mockito package][] como um atalho.

Esta receita demonstra os fundamentos do mocking com o pacote Mockito usando as seguintes etapas:

1. Adicione as dependências do pacote.
2. Crie uma função para testar.
3. Crie um arquivo de teste com um `http.Client` mock.
4. Escreva um teste para cada condição.
5. Execute os testes.

Para obter mais informações, consulte a documentação do [Mockito package][].

## 1. Adicione as dependências do pacote

Para usar o pacote `mockito`, adicione-o ao arquivo `pubspec.yaml` junto com a dependência `flutter_test` na seção `dev_dependencies`.

Este exemplo também usa o pacote `http`, portanto, defina essa dependência na seção `dependencies`.

O `mockito: 5.0.0` suporta a null safety do Dart graças à geração de código. Para executar a geração de código necessária, adicione a dependência `build_runner` na seção `dev_dependencies`.

Para adicionar as dependências, execute `flutter pub add`:

```console
$ flutter pub add http dev:mockito dev:build_runner
```

## 2. Crie uma função para testar

Neste exemplo, teste a função `fetchAlbum` da receita [Fetch data from the internet][]. Para testar esta função, faça duas alterações:

1. Forneça um `http.Client` para a função. Isso permite fornecer o `http.Client` correto dependendo da situação. Para projetos Flutter e do lado do servidor, forneça um `http.IOClient`. Para aplicativos de navegador, forneça um `http.BrowserClient`. Para testes, forneça um `http.Client` mock.
2. Use o `client` fornecido para buscar dados da Internet, em vez do método estático `http.get()`, que é difícil de simular.

A função deve ficar assim:

<?code-excerpt "lib/main.dart (fetchAlbum)"?>
```dart
Future<Album> fetchAlbum(http.Client client) async {
  final response = await client
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

No código do seu aplicativo, você pode fornecer um `http.Client` para o método `fetchAlbum` diretamente com `fetchAlbum(http.Client())`. `http.Client()` cria um `http.Client` padrão.

## 3. Crie um arquivo de teste com um `http.Client` mock

Em seguida, crie um arquivo de teste.

Seguindo o conselho da receita [Introduction to unit testing][], crie um arquivo chamado `fetch_album_test.dart` na pasta raiz `test`.

Adicione a anotação `@GenerateMocks([http.Client])` à função principal para gerar uma classe `MockClient` com `mockito`.

A classe `MockClient` gerada implementa a classe `http.Client`. Isso permite que você passe o `MockClient` para a função `fetchAlbum` e retorne diferentes respostas http em cada teste.

Os mocks gerados estarão localizados em `fetch_album_test.mocks.dart`. Importe este arquivo para usá-los.

<?code-excerpt "test/fetch_album_test.dart (mockClient)" plaster="none"?>
```dart
import 'package:http/http.dart' as http;
import 'package:mocking/main.dart';
import 'package:mockito/annotations.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
}
```

Em seguida, gere os mocks executando o seguinte comando:

```console
$ dart run build_runner build
```

## 4. Escreva um teste para cada condição

A função `fetchAlbum()` faz uma de duas coisas:

1. Retorna um `Album` se a chamada http for bem-sucedida
2. Lança uma `Exception` se a chamada http falhar

Portanto, você deseja testar essas duas condições. Use a classe `MockClient` para retornar uma resposta "Ok" para o teste de sucesso e uma resposta de erro para o teste malsucedido. Teste essas condições usando a função `when()` fornecida pelo Mockito:

<?code-excerpt "test/fetch_album_test.dart"?>
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocking/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fetch_album_test.mocks.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  group('fetchAlbum', () {
    test('returns an Album if the http call completes successfully', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client
              .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async =>
              http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200));

      expect(await fetchAlbum(client), isA<Album>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client
              .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchAlbum(client), throwsException);
    });
  });
}
```

## 5. Execute os testes

Agora que você tem uma função `fetchAlbum()` com testes em vigor, execute os testes.

```console
$ flutter test test/fetch_album_test.dart
```

Você também pode executar testes dentro do seu editor favorito seguindo as instruções na receita [Introduction to unit testing][].

## Exemplo completo

##### lib/main.dart

<?code-excerpt "lib/main.dart"?>
```dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum(http.Client client) async {
  final response = await client
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

  const Album({required this.userId, required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum(http.Client());
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

##### test/fetch_album_test.dart

<?code-excerpt "test/fetch_album_test.dart"?>
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocking/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fetch_album_test.mocks.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  group('fetchAlbum', () {
    test('returns an Album if the http call completes successfully', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client
              .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async =>
              http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200));

      expect(await fetchAlbum(client), isA<Album>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client
              .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchAlbum(client), throwsException);
    });
  });
}
```

## Resumo

Neste exemplo, você aprendeu como usar o Mockito para testar funções ou classes que dependem de serviços da Web ou bancos de dados. Esta é apenas uma breve introdução à biblioteca Mockito e ao conceito de mocking. Para obter mais informações, consulte a documentação fornecida pelo [Mockito package][].

[Fetch data from the internet]: /cookbook/networking/fetch-data
[Introduction to unit testing]: /cookbook/testing/unit/introduction
[Mockito package]: {{site.pub-pkg}}/mockito
