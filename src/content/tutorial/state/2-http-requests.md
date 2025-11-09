---
ia-translate: true
title: Buscar dados da internet
description: Instruções sobre como fazer requisições HTTP e analisar respostas.
permalink: /tutorial/http-request/
sitemap: false
---

O padrão abrangente que este tutorial implementa é chamado
*Model-View-ViewModel* ou *MVVM*. MVVM é um [padrão de arquitetura][architectural pattern]
usado em apps cliente que separa seu app em três camadas: o
Model lida com operações de dados, a View exibe a UI, e o
ViewModel gerencia o estado e os conecta. O princípio central do MVVM
(e muitos outros padrões) é a *separação de responsabilidades*. Gerenciar estado
em classes separadas (fora dos seus widgets de UI) torna seu código mais
testável, reutilizável e fácil de manter.

<img src="/assets/images/docs/tutorial/simple_mvvm.png" width="100%"
alt="Um diagrama que mostra as três camadas da arquitetura MVVM: Model, ViewModel e View.">

Uma única funcionalidade no seu app contém cada um dos componentes MVVM. Neste
tutorial, você criará um `ArticleModel`, `ArticleViewModel` e
`ArticleView`, além de widgets Flutter.

## Definir o Model

O Model é a fonte da verdade para os dados do seu app, e é
responsável por tarefas de baixo nível como fazer requisições HTTP,
cachear dados, ou gerenciar recursos do sistema como um plugin.
Um model geralmente não precisa importar bibliotecas Flutter.

Crie uma classe `ArticleModel` vazia no seu arquivo `main.dart`:

```dart
class ArticleModel {
  // Properties and methods will be added here.
}
```

## Construir a requisição HTTP

A Wikipedia fornece uma API REST que retorna dados JSON sobre artigos.
Para este app, você usará o endpoint que retorna um resumo de artigo
aleatório.

```txt
https://en.wikipedia.org/api/rest_v1/page/random/summary
```

Adicione um método para buscar resumos de artigos aleatórios da Wikipedia:

```dart
class ArticleModel {
  Future<Summary> getRandomArticleSummary() async {
    final uri = Uri.https(
      'en.wikipedia.org',
      '/api/rest_v1/page/random/summary',
    );
    final response = await get(uri);

    // TODO: Add error handling and JSON parsing.
  }
}
```

Use as palavras-chave [`async` e `await`][`async` and `await`] para lidar com operações assíncronas.
A palavra-chave `async` marca um método como assíncrono, e `await` marca
expressões que retornam um [`Future`][`Future`].

O construtor `Uri.https()` constrói URLs com segurança lidando com codificação
e formatação. Esta abordagem é mais confiável que concatenação de strings,
especialmente ao lidar com caracteres especiais ou
parâmetros de query.

## Lidar com erros de rede

Sempre lide com erros ao fazer requisições HTTP. Um código de status 200 indica
sucesso, enquanto outros códigos indicam erros. Se o
código de status não for 200, o model lança um erro para a UI
exibir aos usuários.

```dart
class ArticleModel {
  Future<Summary> getRandomArticleSummary() async {
    final uri = Uri.https(
      'en.wikipedia.org',
      '/api/rest_v1/page/random/summary',
    );
    final response = await get(uri);

    if (response.statusCode != 200) {
      throw HttpException('Failed to update resource');
    }

    // TODO: Parse JSON and return Summary.
  }
}
```

## Analisar JSON da Wikipedia

A [API da Wikipedia][Wikipedia API] retorna dados [JSON][JSON] que você decodifica em
uma classe `Summary`. Complete o método `getRandomArticleSummary`:

```dart
class ArticleModel {
  Future<Summary> getRandomArticleSummary() async {
    final uri = Uri.https(
      'en.wikipedia.org',
      '/api/rest_v1/page/random/summary',
    );
    final response = await get(uri);

    if (response.statusCode != 200) {
      throw HttpException('Failed to update resource');
    }

    return Summary.fromJson(jsonDecode(response.body));
  }
}
```

O pacote `dartpedia` fornece a classe `Summary`. Se você não está
familiarizado com parsing de JSON, veja o [tutorial Getting Started
do Dart][Dart Getting Started tutorial].

[architectural pattern]: /architecture/guide
[JSON]: {{site.dart-site}}/tutorial/json
[`async` and `await`]: https://dart.dev/language/async
[`Future`]: https://api.dart.dev/stable/dart-async/Future-class.html
[Wikipedia API]: https://en.wikipedia.org/api/rest_v1/
[Dart Getting Started tutorial]: {{site.dart-site}}/tutorial/json
