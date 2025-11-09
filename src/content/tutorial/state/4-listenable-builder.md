---
ia-translate: true
title: Reconstrua a UI quando o estado muda
description: Instruções sobre como gerenciar estado com ChangeNotifiers.
permalink: /tutorial/listenables/
sitemap: false
---

A camada de visualização é sua UI, e no Flutter, isso se refere aos
widgets do seu app. No que diz respeito a este tutorial, a parte importante é conectar
sua UI para responder a mudanças de dados do ViewModel.
[`ListenableBuilder`][ListenableBuilder] é um widget que pode "ouvir" um
`ChangeNotifier`, e reconstrói automaticamente quando o
`ChangeNotifier` fornecido chama `notifyListeners()`.

## Crie o widget ArticleView

Crie o widget `ArticleView` que gerencia o layout geral da página
e o tratamento de estado. Comece com a estrutura básica da classe e widgets:

```dart
class ArticleView extends StatelessWidget {
  ArticleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wikipedia Flutter'),
      ),
      body: const Center(
        child: Text('UI will update here'),
      ),
    );
  }
}
```

## Crie o ViewModel

Crie o ViewModel neste widget.

```dart
class ArticleView extends StatelessWidget {
  ArticleView({super.key});

  final viewModel = ArticleViewModel(ArticleModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wikipedia Flutter'),
      ),
      body: const Center(
        child: Text('UI will update here'),
      ),
    );
  }
}
```

## Adicione ListenableBuilder

Envolva sua UI em um `ListenableBuilder` para ouvir mudanças de estado, e
passe a ele um objeto `ChangeNotifier`. Neste caso, o
`ArticleViewModel` estende `ChangeNotifier`.

```dart
class ArticleView extends StatelessWidget {
  ArticleView({super.key});

  final ArticleViewModel viewModel = ArticleViewModel(ArticleModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wikipedia Flutter'),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          return const Center(child: Text('UI will update here'));
        },
      ),
    );
  }
}
```

`ListenableBuilder` usa o padrão *builder*, que requer um
callback em vez de um widget `child` para construir a árvore de widgets abaixo
dele. Esses widgets são flexíveis porque você pode executar operações
dentro do callback.


## Lide com todos os estados com expressão switch

Lembre-se do `ArticleViewModel`, que tem três propriedades nas quais a UI
está interessada:
* `Summary? summary`
* `bool loading`
* `String? errorMessage`

A UI precisa exibir widgets diferentes com base na combinação de
estados de todas essas três propriedades. Use expressões switch do Dart
para lidar com todas as combinações possíveis de maneira limpa e legível:

```dart
class ArticleView extends StatelessWidget {
  ArticleView({super.key});

  final ArticleViewModel viewModel = ArticleViewModel(ArticleModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wikipedia Flutter'),
        actions: [],
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          return switch ((
            viewModel.loading,
            viewModel.summary,
            viewModel.errorMessage,
          )) {
            (true, _, _) => CircularProgressIndicator(),
            (false, _, String message) => Center(child: Text(message)),
            (false, null, null) => Center(
              child: Text('An unknown error has occurred'),
            ),
            // summary must be non-null in this swich case
            (false, Summary _, null) => ArticlePage(
              summary: viewModel.summary!,
              onPressed: viewModel.getRandomArticleSummary,
            ),
          };
        },
      ),
    );
  }
}
```

Este é um excelente exemplo de como um framework declarativo e reativo
como Flutter e um padrão como MVVM trabalham juntos: A UI é renderizada
com base no estado, e atualiza quando uma mudança de estado o exige, mas
ela não gerencia nenhum estado ou o processo de atualizar a si mesma. A
lógica de negócio e a renderização são completamente separadas uma da outra.


## Complete a UI

A única coisa restante é usar as propriedades e métodos fornecidos
pelo ViewModel.

Agora crie o widget `ArticlePage` que exibe o conteúdo real do artigo.
Este widget reutilizável recebe dados de resumo
e uma função callback.

Crie um widget simples que aceita os parâmetros necessários:

```dart
class ArticlePage extends StatelessWidget {
  const ArticlePage({
    super.key,
    required this.summary,
    required this.nextArticleCallback,
  });

  final Summary summary;
  final VoidCallback nextArticleCallback;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Article content will be displayed here'));
  }
}
```

## Adicione layout rolável

Substitua o placeholder por um layout de coluna rolável:

```dart
class ArticlePage extends StatelessWidget {
  const ArticlePage({
    super.key,
    required this.summary,
    required this.nextArticleCallback,
  });

  final Summary summary;
  final VoidCallback nextArticleCallback;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('Article content will be displayed here'),
        ],
      ),
    );
  }
}
```

## Adicione conteúdo do artigo e botão

Complete o layout com o widget do artigo e botão de navegação:

```dart
class ArticlePage extends StatelessWidget {
  const ArticlePage({
    super.key,
    required this.summary,
    required this.onPressed,
  });

  final Summary summary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Flexible(
            child: ArticleWidget(
              summary: summary,
            ),
          ),
          ElevatedButton(
            onPressed: nextArticleCallback,
            child: Text('Next random article'),
          ),
        ],
      ),
    );
  }
}
```

## Crie o ArticleWidget

O `ArticleWidget` lida com a exibição do conteúdo real do artigo
com estilização apropriada e renderização condicional.

## Crie a estrutura básica do ArticleWidget

Comece com o widget que aceita um parâmetro summary:

```dart
class ArticleWidget extends StatelessWidget {
  const ArticleWidget({super.key, required this.summary});

  final Summary summary;

  @override
  Widget build(BuildContext context) {
    return Text('Article content will be displayed here');
  }
}
```

## Adicione padding e layout de coluna

Envolva o conteúdo em padding e layout apropriados:

```dart
class ArticleWidget extends StatelessWidget {
  const ArticleWidget({super.key, required this.summary});

  final Summary summary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 10.0,
        children: [
          Text('Article content will be displayed here'),
        ],
      ),
    );
  }
}
```

## Adicione exibição condicional de imagem

Adicione a imagem do artigo que só é exibida quando disponível:

```dart
class ArticleWidget extends StatelessWidget {
  const ArticleWidget({super.key, required this.summary});

  final Summary summary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 10.0,
        children: [
          if (summary.hasImage)
            Image.network(
              summary.originalImage!.source,
            ),
          Text('Article content will be displayed here'),
        ],
      ),
    );
  }
}
```

## Complete com conteúdo de texto estilizado

Substitua o placeholder por título, descrição e
extrato devidamente estilizados:

```dart
class ArticleWidget extends StatelessWidget {
  const ArticleWidget({super.key, required this.summary});

  final Summary summary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 10.0,
        children: [
          if (summary.hasImage)
            Image.network(
              summary.originalImage!.source,
            ),
          Text(
            summary.titles.normalized,
            overflow: TextOverflow.ellipsis,
            style: TextTheme.of(context).displaySmall,
          ),
          if (summary.description != null)
            Text(
              summary.description!,
              overflow: TextOverflow.ellipsis,
              style: TextTheme.of(context).bodySmall,
            ),
          Text(
            summary.extract,
          ),
        ],
      ),
    );
  }
}
```

Este widget demonstra esses conceitos importantes de UI:

- **Renderização condicional**: As instruções `if` mostram conteúdo apenas
  quando disponível.
- **Estilização de texto**: Diferentes estilos de texto criam hierarquia visual
  usando o sistema de tema do Flutter.
- **Espaçamento apropriado**: O parâmetro `spacing` fornece
  espaçamento vertical consistente.
- **Tratamento de overflow**: `TextOverflow.ellipsis` evita que o texto
  quebre o layout.

## Atualize MainApp para usar ArticleView

Conecte tudo junto atualizando seu `MainApp` para usar o
`ArticleView` completo.

Substitua seu `MainApp` existente por esta versão atualizada:

```dart
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ArticleView(),
    );
  }
}
```

Esta mudança alterna do teste baseado em console para a experiência completa da UI
com gerenciamento de estado apropriado.

## Execute o app completo

Faça hot reload do seu app uma última vez. Você deve ver agora:

1. Um spinner de carregamento enquanto o artigo inicial carrega
2. O conteúdo do artigo com título, descrição e texto completo
3. Uma imagem (se o artigo tiver uma)
4. Um botão para carregar outro artigo aleatório

Clique no botão "Next random article" para ver a UI reativa em
ação. O app mostra um estado de carregamento, busca novos dados, e atualiza
a exibição automaticamente.

[ListenableBuilder]: https://api.flutter.dev/flutter/widgets/ListenableBuilder-class.html
[widget]: https://docs.flutter.dev/ui/widgets-intro
[`ListView`]: https://api.flutter.dev/flutter/widgets/ListView-class.html
[try-catch block]: https://dart.dev/language/error-handling
