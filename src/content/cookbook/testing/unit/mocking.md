---
ia-translate: true
title: Mock de dependências usando Mockito
description: >
  Use o pacote Mockito para simular o comportamento de serviços para testes.
shortTitle: Mocking
---

<?code-excerpt path-base="cookbook/testing/unit/mocking"?>

Às vezes, testes unitários podem depender de classes que buscam dados de
serviços web ao vivo ou bancos de dados. Isso é inconveniente por algumas razões:

  * Chamar serviços ou bancos de dados ao vivo torna a execução dos testes mais lenta.
  * Um teste que estava passando pode começar a falhar se um serviço web ou banco de dados retornar
    resultados inesperados. Isso é conhecido como "flaky test".
  * É difícil testar todos os cenários possíveis de sucesso e falha
    usando um serviço web ou banco de dados ao vivo.

Portanto, em vez de depender de um serviço web ou banco de dados ao vivo,
você pode fazer "mock" dessas dependências. Mocks permitem emular um serviço
web ou banco de dados ao vivo e retornar resultados específicos dependendo
da situação.

De modo geral, você pode fazer mock de dependências criando uma implementação
alternativa de uma classe. Escreva essas implementações alternativas manualmente
ou use o [pacote Mockito][Mockito package] como atalho.

Esta receita demonstra o básico de mocking com o
pacote Mockito usando os seguintes passos:

  1. Adicione as dependências do pacote.
  2. Crie uma função para testar.
  3. Crie um arquivo de teste com um mock `http.Client`.
  4. Escreva um teste para cada condição.
  5. Execute os testes.

Para mais informações, consulte a documentação do [pacote Mockito][Mockito package].

## 1. Adicione as dependências do pacote

Para usar o pacote `mockito`, adicione-o ao
arquivo `pubspec.yaml` junto com a dependência `flutter_test` na
seção `dev_dependencies`.

Este exemplo também usa o pacote `http`,
então defina essa dependência na seção `dependencies`.

O `mockito: 5.0.0` suporta null safety do Dart graças à geração de código.
Para executar a geração de código necessária, adicione a dependência `build_runner`
na seção `dev_dependencies`.

Para adicionar as dependências, execute `flutter pub add`:

```console
$ flutter pub add http dev:mockito dev:build_runner
```

## 2. Crie uma função para testar

Neste exemplo, faça um teste unitário da função `fetchAlbum` da
receita [Buscar dados da internet][Fetch data from the internet].
Para testar essa função, faça duas mudanças:

  1. Forneça um `http.Client` para a função. Isso permite fornecer o
     `http.Client` correto dependendo da situação.
     Para projetos Flutter e do lado do servidor, forneça um `http.IOClient`.
     Para apps de navegador, forneça um `http.BrowserClient`.
     Para testes, forneça um mock `http.Client`.
  2. Use o `client` fornecido para buscar dados da internet,
     em vez do método estático `http.get()`, que é difícil de fazer mock.

A função agora deve ficar assim:

<?code-excerpt "lib/main.dart (fetchAlbum)"?>
```dart
Future<Album> fetchAlbum(http.Client client) async {
  final response = await client.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
  );

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

No código do seu app, você pode fornecer um `http.Client` para o método `fetchAlbum`
diretamente com `fetchAlbum(http.Client())`. `http.Client()` cria um
`http.Client` padrão.

## 3. Crie um arquivo de teste com um mock `http.Client`

Em seguida, crie um arquivo de teste.

Seguindo o conselho da receita [Introdução a testes unitários][Introduction to unit testing],
crie um arquivo chamado `fetch_album_test.dart` na pasta raiz `test`.

Adicione a anotação
`@GenerateMocks([], customMocks: [MockSpec<http.Client>(as: #MockHttpClient)])`
à função main para gerar uma classe `MockHttpClient` com `mockito`.

A classe gerada `MockHttpClient` implementa a classe `http.Client`.
Isso permite que você passe o `MockHttpClient` para a função `fetchAlbum`,
e retorne diferentes respostas http em cada teste.

Os mocks gerados estarão localizados em `fetch_album_test.mocks.dart`.
Importe este arquivo para usá-los.

<?code-excerpt "test/fetch_album_test.dart (mockClient)" plaster="none"?>
```dart
import 'package:http/http.dart' as http;
import 'package:mocking/main.dart';
import 'package:mockito/annotations.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
// Note: Naming the generated mock `MockHttpClient` to avoid confusion with
// `MockClient` from `package:http/testing.dart`.
@GenerateMocks([], customMocks: [MockSpec<http.Client>(as: #MockHttpClient)])
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

Portanto, você quer testar essas duas condições.
Use a classe `MockHttpClient` para retornar uma resposta "Ok"
para o teste de sucesso, e uma resposta de erro para o teste de falha.
Teste essas condições usando a função `when()` fornecida pelo
Mockito:

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
// Note: Naming the generated mock `MockHttpClient` to avoid confusion with
// `MockClient` from `package:http/testing.dart`.
@GenerateMocks([], customMocks: [MockSpec<http.Client>(as: #MockHttpClient)])
void main() {
  group('fetchAlbum', () {
    test('returns an Album if the http call completes successfully', () async {
      final client = MockHttpClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(
        client.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')),
      ).thenAnswer(
        (_) async =>
            http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200),
      );

      expect(await fetchAlbum(client), isA<Album>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockHttpClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(
        client.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchAlbum(client), throwsException);
    });
  });
}
```

## 5. Execute os testes

Agora que você tem uma função `fetchAlbum()` com testes implementados,
execute os testes.

```console
$ flutter test test/fetch_album_test.dart
```

Você também pode executar os testes dentro do seu editor favorito seguindo as
instruções da receita [Introdução a testes unitários][Introduction to unit testing].

## Exemplo completo

##### lib/main.dart

<?code-excerpt "lib/main.dart"?>
```dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum(http.Client client) async {
  final response = await client.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
  );

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
        appBar: AppBar(title: const Text('Fetch Data Example')),
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
// Note: Naming the generated mock `MockHttpClient` to avoid confusion with
// `MockClient` from `package:http/testing.dart`.
@GenerateMocks([], customMocks: [MockSpec<http.Client>(as: #MockHttpClient)])
void main() {
  group('fetchAlbum', () {
    test('returns an Album if the http call completes successfully', () async {
      final client = MockHttpClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(
        client.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')),
      ).thenAnswer(
        (_) async =>
            http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200),
      );

      expect(await fetchAlbum(client), isA<Album>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockHttpClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(
        client.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchAlbum(client), throwsException);
    });
  });
}
```

## Resumo

Neste exemplo, você aprendeu como usar Mockito para testar funções ou classes
que dependem de serviços web ou bancos de dados. Esta é apenas uma breve introdução à
biblioteca Mockito e ao conceito de mocking. Para mais informações,
consulte a documentação fornecida pelo [pacote Mockito][Mockito package].


[Fetch data from the internet]: /cookbook/networking/fetch-data
[Introduction to unit testing]: /cookbook/testing/unit/introduction
[Mockito package]: {{site.pub-pkg}}/mockito
