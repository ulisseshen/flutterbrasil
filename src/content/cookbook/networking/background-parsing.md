---
ia-translate: true
title: Analisar JSON em Segundo Plano
description: Como executar uma tarefa em segundo plano.
---

<?code-excerpt path-base="cookbook/networking/background_parsing/"?>

Por padrão, os aplicativos Dart realizam todo o seu trabalho em uma única thread.
Em muitos casos, este modelo simplifica a codificação e é rápido o suficiente
para que não resulte em baixo desempenho do aplicativo ou animações gaguejantes,
muitas vezes chamadas de "jank".

No entanto, você pode precisar executar uma computação dispendiosa,
como analisar um documento JSON muito grande.
Se este trabalho levar mais de 16 milissegundos,
seus usuários experimentarão jank.

Para evitar jank, você precisa executar computações dispendiosas
como esta em segundo plano.
No Android, isso significa agendar o trabalho em uma thread diferente.
No Flutter, você pode usar um [Isolate][] separado.
Esta receita usa as seguintes etapas:

  1. Adicione o pacote `http`.
  2. Faça uma requisição de rede usando o pacote `http`.
  3. Converta a resposta em uma lista de fotos.
  4. Mova este trabalho para um isolate separado.

## 1. Adicione o pacote `http`

Primeiro, adicione o pacote [`http`][] ao seu projeto.
O pacote `http` facilita a execução de requisições de rede,
como buscar dados de um endpoint JSON.

Para adicionar o pacote `http` como uma dependência,
execute `flutter pub add`:

```console
$ flutter pub add http
```

## 2. Faça uma requisição de rede

Este exemplo aborda como buscar um grande documento JSON
que contém uma lista de 5000 objetos de fotos do
[JSONPlaceholder REST API][],
usando o método [`http.get()`][].

<?code-excerpt "lib/main_step2.dart (fetchPhotos)"?>
```dart
Future<http.Response> fetchPhotos(http.Client client) async {
  return client.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
}
```

:::note
Você está fornecendo um `http.Client` para a função neste exemplo.
Isso torna a função mais fácil de testar e usar em diferentes ambientes.
:::

## 3. Analise e converta o JSON em uma lista de fotos

Em seguida, seguindo as orientações da receita
[Buscar dados da internet][],
converta o `http.Response` em uma lista de objetos Dart.
Isso torna os dados mais fáceis de trabalhar.

### Crie uma classe `Photo`

Primeiro, crie uma classe `Photo` que contém dados sobre uma foto.
Inclua um método factory `fromJson()` para facilitar a criação de uma
`Photo` a partir de um objeto JSON.

<?code-excerpt "lib/main_step3.dart (Photo)"?>
```dart
class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  const Photo({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}
```

### Converta a resposta em uma lista de fotos

Agora, use as seguintes instruções para atualizar a
função `fetchPhotos()` para que ela retorne um
`Future<List<Photo>>`:

  1. Crie uma função `parsePhotos()` que converta o corpo da resposta
     em uma `List<Photo>`.
  2. Use a função `parsePhotos()` na função `fetchPhotos()`.

<?code-excerpt "lib/main_step3.dart (parsePhotos)"?>
```dart
// Uma função que converte o corpo de uma resposta em uma List<Photo>.
List<Photo> parsePhotos(String responseBody) {
  final parsed =
      (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

  // Execute parsePhotos de forma síncrona no isolate principal.
  return parsePhotos(response.body);
}
```

## 4. Mova este trabalho para um isolate separado

Se você executar a função `fetchPhotos()` em um dispositivo mais lento,
você pode notar que o aplicativo congela por um breve momento enquanto ele analisa e
converte o JSON. Isso é jank, e você quer se livrar dele.

Você pode remover o jank movendo a análise e a conversão
para um isolate em segundo plano usando a função [`compute()`][]
fornecida pelo Flutter. A função `compute()` executa funções dispendiosas
em um isolate em segundo plano e retorna o resultado. Neste caso,
execute a função `parsePhotos()` em segundo plano.

<?code-excerpt "lib/main.dart (fetchPhotos)"?>
```dart
Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

  // Use a função compute para executar parsePhotos em um isolate separado.
  return compute(parsePhotos, response.body);
}
```

## Notas sobre como trabalhar com isolates

Isolates se comunicam passando mensagens de um lado para o outro. Essas mensagens podem
ser valores primitivos, como `null`, `num`, `bool`, `double` ou `String`, ou
objetos simples como `List<Photo>` neste exemplo.

Você pode experimentar erros se tentar passar objetos mais complexos,
como um `Future` ou `http.Response` entre isolates.

Como solução alternativa, confira os pacotes [`worker_manager`][] ou
[`workmanager`][] para processamento em segundo plano.

[`worker_manager`]:  {{site.pub}}/packages/worker_manager
[`workmanager`]: {{site.pub}}/packages/workmanager

## Exemplo completo

<?code-excerpt "lib/main.dart"?>
```dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

  // Use a função compute para executar parsePhotos em um isolate separado.
  return compute(parsePhotos, response.body);
}

// Uma função que converte o corpo de uma resposta em uma List<Photo>.
List<Photo> parsePhotos(String responseBody) {
  final parsed =
      (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  const Photo({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Demonstração de Isolate';

    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Photo>> futurePhotos;

  @override
  void initState() {
    super.initState();
    futurePhotos = fetchPhotos(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Photo>>(
        future: futurePhotos,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Ocorreu um erro!'),
            );
          } else if (snapshot.hasData) {
            return PhotosList(photos: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  const PhotosList({super.key, required this.photos});

  final List<Photo> photos;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Image.network(photos[index].thumbnailUrl);
      },
    );
  }
}
```

![Demonstração de Isolate](/assets/images/docs/cookbook/isolate.gif){:.site-mobile-screenshot}

[`compute()`]: {{site.api}}/flutter/foundation/compute.html
[Buscar dados da internet]: /cookbook/networking/fetch-data
[`http`]: {{site.pub-pkg}}/http
[`http.get()`]: {{site.pub-api}}/http/latest/http/get.html
[Isolate]: {{site.api}}/flutter/dart-isolate/Isolate-class.html
[JSONPlaceholder REST API]: https://jsonplaceholder.typicode.com
