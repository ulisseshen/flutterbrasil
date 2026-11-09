---
ia-translate: true
title: Buscar dados da internet
description: Instruções sobre como fazer requisições HTTP e analisar respostas.
layout: tutorial
---

Aprenda o padrão de arquitetura MVVM e como construir requisições HTTP com async/await.

<SummaryCard>
title: O que você vai realizar
items:
  - title: Entender o padrão de arquitetura MVVM
    icon: layers
  - title: Construir requisições HTTP com async/await
    icon: cloud_download
  - title: Lidar com erros e analisar respostas JSON
    icon: data_object
</SummaryCard>

---

### Introdução {:#introduction}

O padrão abrangente que este tutorial implementa é chamado
_Model-View-ViewModel_ ou _MVVM_.
MVVM é um [padrão de arquitetura][architectural pattern] usado em apps cliente que
separa seu app em três camadas:

- **Model**: Lida com operações de dados.
- **View**: Exibe a UI.
- **ViewModel**: Gerencia o estado e conecta os dois.

O princípio central do MVVM (e de muitos outros padrões) é a *separação de responsabilidades*.
Gerenciar estado em classes separadas (fora dos seus widgets de UI) torna
seu código mais testável, reutilizável e fácil de manter.

Uma única funcionalidade no seu app contém cada um dos componentes MVVM.
Neste tutorial, além de widgets Flutter,
você criará `ArticleModel`, `ArticleViewModel` e `ArticleView`.

[architectural pattern]: /app-architecture/guide

### Definir o Model {:#define-the-model}

O Model é a fonte da verdade para os dados do seu app e é responsável por
tarefas de baixo nível como fazer requisições HTTP, cachear dados ou
gerenciar recursos do sistema, como os usados por um plugin Flutter.
Um model geralmente não precisa importar bibliotecas Flutter.

Crie uma classe `ArticleModel` vazia no seu arquivo `main.dart`:

<?code-excerpt "fwe/wikipedia_reader/lib/step2a_main.dart (ArticleModel)"?>
```dart
class ArticleModel {
  // Properties and methods will be added here.
}
```

### Construir a requisição HTTP {:#build-the-http-request}

A Wikipedia fornece uma API REST que retorna dados JSON sobre artigos.
Para este app, você usará o endpoint que retorna um resumo de artigo aleatório.

```text
https://en.wikipedia.org/api/rest_v1/page/random/summary
```

Adicione um método para buscar um resumo de artigo aleatório da Wikipedia:

<?code-excerpt "fwe/wikipedia_reader/lib/step2b_main.dart (ArticleModel)"?>
```dart
class ArticleModel {
  Future<Summary> getRandomArticleSummary() async {
    final uri = Uri.https(
      'en.wikipedia.org',
      '/api/rest_v1/page/random/summary',
    );
    final response = await get(uri);

    // TODO: Add error handling and JSON parsing.
    throw UnimplementedError();
  }
}
```

Use as palavras-chave [`async` e `await`][`async` and `await`] para lidar com operações assíncronas.
A palavra-chave `async` marca um método como assíncrono, e
`await` aguarda expressões que retornam um [`Future`][].

O construtor `Uri.https` constrói URLs com segurança
lidando com codificação e formatação.
Esta abordagem é mais confiável que concatenação de strings,
especialmente ao lidar com caracteres especiais ou parâmetros de query.

[`async` and `await`]: {{site.dart-site}}/language/async
[`Future`]: {{site.api}}/flutter/dart-async/Future-class.html

### Lidar com erros de rede {:#handle-network-errors}

Sempre lide com erros ao fazer requisições HTTP.
Um código de status **200** indica sucesso, enquanto outros códigos indicam erros.
Se o código de status não for **200**, o model lança um erro para
a UI exibir aos usuários.

<?code-excerpt "fwe/wikipedia_reader/lib/step2c_main.dart (ArticleModel)"?>
```dart
class ArticleModel {
  Future<Summary> getRandomArticleSummary() async {
    final uri = Uri.https(
      'en.wikipedia.org',
      '/api/rest_v1/page/random/summary',
    );
    final response = await get(uri);

    if (response.statusCode != 200) {
      throw const HttpException('Failed to update resource');
    }

    // TODO: Parse JSON and return Summary.
    throw UnimplementedError();
  }
}
```

### Analisar JSON da Wikipedia {:#parse-json-from-wikipedia}

A [API da Wikipedia][Wikipedia API] retorna dados [JSON][] que
você decodifica em uma classe `Summary`.
Complete o método `getRandomArticleSummary`:

<?code-excerpt "fwe/wikipedia_reader/lib/step2_main.dart (ArticleModel)"?>
```dart
class ArticleModel {
  Future<Summary> getRandomArticleSummary() async {
    final uri = Uri.https(
      'en.wikipedia.org',
      '/api/rest_v1/page/random/summary',
    );
    final response = await get(uri);

    if (response.statusCode != 200) {
      throw const HttpException('Failed to update resource');
    }

    return Summary.fromJson(jsonDecode(response.body) as Map<String, Object?>);
  }
}
```

A classe `Summary` é definida em `summary.dart`.
Se você não está familiarizado com parsing de JSON,
confira o tutorial [Getting started with Dart][].

[Wikipedia API]: https://en.wikipedia.org/api/rest_v1/
[JSON]: {{site.dart-site}}/tutorial/json
[Getting started with Dart]: {{site.dart-site}}/tutorial

### Revisão {:#review}

<SummaryCard>
title: O que você realizou
subtitle: Aqui está um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Entendeu o padrão de arquitetura MVVM
    icon: layers
    details: >-
      O MVVM separa seu app em Model (operações de dados),
      View (interface do usuário) e ViewModel (gerenciamento de estado).
      Essa separação de responsabilidades torna seu código mais
      testável, reutilizável e fácil de manter.
  - title: Construiu uma requisição HTTP para buscar dados da Wikipedia
    icon: cloud_download
    details: >-
      Você criou uma classe `ArticleModel` com um método que
      usa `async` e `await` para buscar dados da API da Wikipedia.
      Para construir as URLs das requisições com segurança,
      você usou o construtor `Uri.https`, que
      lida com codificação e caracteres especiais para você.
  - title: Lidou com erros e analisou respostas JSON
    icon: data_object
    details: >-
      Você verificou o código de status HTTP para detectar erros e
      usou `jsonDecode` para analisar o corpo da resposta.
      Em seguida, para converter o JSON bruto em um objeto Dart tipado,
      você usou o construtor nomeado `Summary.fromJson`.
</SummaryCard>

### Teste seus conhecimentos {:#test-yourself}

<Quiz title="Quiz de requisições HTTP">
- question: "O que as palavras-chave `async` e `await` fazem em Dart?"
  options:
    - text: Elas fazem o código executar em uma thread separada.
      correct: false
      explanation: Dart é single-threaded; async/await lida com operações assíncronas sem threads.
    - text: Elas marcam uma função como assíncrona e pausam a execução até que um Future seja concluído.
      correct: true
      explanation: "A palavra-chave `async` marca uma função como assíncrona, e `await` pausa a execução até que o Future seja resolvido."
    - text: Elas armazenam automaticamente em cache os resultados das chamadas de função.
      correct: false
      explanation: Cache requer implementação separada; async/await serve para lidar com operações assíncronas.
    - text: Elas convertem código síncrono para executar em segundo plano.
      correct: false
      explanation: Elas não movem o código para segundo plano; elas gerenciam o fluxo de execução assíncrona.
- question: "Por que `Uri.https` é preferível à concatenação de strings ao construir URLs em Dart?"
  options:
    - text: Ele deixa o código mais curto.
      correct: false
      explanation: O tamanho do código não é o principal benefício; a codificação correta é.
    - text: Ele lida com codificação e formatação com segurança, especialmente para caracteres especiais e parâmetros de query.
      correct: true
      explanation: Uri.https codifica corretamente caracteres especiais e formata URLs, evitando erros comuns.
    - text: Ele é exigido pelo pacote http.
      correct: false
      explanation: Você pode usar strings, mas Uri.https é mais seguro e confiável.
    - text: Ele valida automaticamente que a URL existe.
      correct: false
      explanation: Uri.https constrói a URL; ele não verifica se o endpoint existe.
</Quiz>
