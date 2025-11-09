---
ia-translate: true
title: Faça requisições autenticadas
description: Como buscar dados autorizados de um serviço web.
---

<?code-excerpt path-base="cookbook/networking/authenticated_requests/"?>

Para buscar dados da maioria dos serviços web, você precisa fornecer
autorização. Existem muitas maneiras de fazer isso,
mas talvez a mais comum use o cabeçalho HTTP `Authorization`.

## Adicione cabeçalhos de autorização

O pacote [`http`][] fornece uma
maneira conveniente de adicionar cabeçalhos às suas requisições.
Alternativamente, use a classe [`HttpHeaders`][]
da biblioteca `dart:io`.

<?code-excerpt "lib/main.dart (get)"?>
```dart
final response = await http.get(
  Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
  // Send authorization headers to the backend.
  headers: {HttpHeaders.authorizationHeader: 'Basic your_api_token_here'},
);
```

## Exemplo completo

Este exemplo se baseia na
receita [Fetching data from the internet][].

<?code-excerpt "lib/main.dart"?>
```dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
    // Send authorization headers to the backend.
    headers: {HttpHeaders.authorizationHeader: 'Basic your_api_token_here'},
  );
  final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

  return Album.fromJson(responseJson);
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({required this.userId, required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'userId': int userId, 'id': int id, 'title': String title} => Album(
        userId: userId,
        id: id,
        title: title,
      ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
```


[Fetching data from the internet]: /cookbook/networking/fetch-data
[`http`]: {{site.pub-pkg}}/http
[`HttpHeaders`]: {{site.dart.api}}/dart-io/HttpHeaders-class.html
