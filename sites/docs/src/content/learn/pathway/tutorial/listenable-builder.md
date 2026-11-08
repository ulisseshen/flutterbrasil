---
ia-translate: true
title: Reconstrua a UI quando o estado muda
description: Instruções sobre como gerenciar estado com ChangeNotifiers.
layout: tutorial
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g;"?>

Aprenda a usar ListenableBuilder para reconstruir a UI automaticamente e
lidar com todos os estados possíveis com expressões switch.

<SummaryCard>
title: O que você vai realizar
items:
  - title: Usar ListenableBuilder para reconstruir a UI automaticamente
    icon: sync
  - title: Lidar com todos os estados possíveis com expressões switch
    icon: alt_route
  - title: Construir a camada View completa com estilização apropriada
    icon: article
</SummaryCard>

---

### Introdução {:#introduction}

A camada de visualização é sua UI, e no Flutter,
isso se refere aos widgets do seu app.
No que diz respeito a este tutorial, a parte importante é
conectar sua UI para responder a mudanças de dados do ViewModel.
[`ListenableBuilder`][] é um widget que pode "ouvir" um
[`ChangeNotifier`][], e reconstrói automaticamente quando o
`ChangeNotifier` fornecido chama `notifyListeners()`.

[`ListenableBuilder`]: {{site.api}}/flutter/widgets/ListenableBuilder-class.html
[`ChangeNotifier`]: {{site.api}}/flutter/foundation/ChangeNotifier-class.html

### Crie o widget de visualização do artigo {:#create-the-article-view-widget}

Crie o widget `ArticleView` que
gerencia o layout da sua página e o ciclo de vida do ViewModel.
Como ele precisa inicializar explicitamente a busca de dados antes de renderizar,
implemente-o como um `StatefulWidget`.

Comece criando a estrutura stateful básica:

<?code-excerpt "fwe/wikipedia_reader/lib/step4a_main.dart"?>
```dart
import 'package:material_ui/material_ui.dart';

class ArticleView extends StatefulWidget {
  const ArticleView({super.key});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  // The view model will be instantiated here next.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wikipedia Flutter')),
      body: const Center(child: Text('Loading...')),
    );
  }
}
```

### Instancie o view model do artigo {:#instantiate-the-article-view-model}

Em seguida, inicialize seu `ArticleViewModel` associando-o ao ciclo de vida do state.
Forneça o ViewModel e execute `fetchArticle()` dentro de `initState()`:

<?code-excerpt "fwe/wikipedia_reader/lib/step4b_main.dart (view-model)"?>
```dart highlightLines=2-8
class ArticleView extends StatefulWidget {
  const ArticleView({super.key});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  final ArticleViewModel viewModel = ArticleViewModel(ArticleModel());

  @override
  void initState() {
    super.initState();
    viewModel.fetchArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wikipedia Flutter')),
      body: const Center(child: Text('Loading...')),
    );
  }
}
```

### Atualize seu app para incluir a visualização do artigo {:#update-your-app-to-include-the-article-view}

Conecte tudo atualizando seu `MainApp` para
incluir seu `ArticleView` completo.

Substitua seu `MainApp` existente por esta versão atualizada:

<?code-excerpt "fwe/wikipedia_reader/lib/step4_main.dart (main-app)"?>
```dart highlightLines=6
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ArticleView());
  }
}
```

Esta mudança alterna do teste baseado em console para a experiência completa da UI
com gerenciamento de estado apropriado.

### Ouça mudanças de estado {:#listen-for-state-changes}

Envolva sua UI em um [`ListenableBuilder`][] para ouvir mudanças de estado,
e passe a ele um objeto `ChangeNotifier`.
Neste caso, o `ArticleViewModel` estende `ChangeNotifier`.

<?code-excerpt "fwe/wikipedia_reader/lib/step4c_main.dart (view-model)"?>
```dart highlightLines=21-26
class ArticleView extends StatefulWidget {
  const ArticleView({super.key});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  final ArticleViewModel viewModel = ArticleViewModel(ArticleModel());

  @override
  void initState() {
    super.initState();
    viewModel.fetchArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wikipedia Flutter')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          return const Center(child: Text('Loading...'));
        },
      ),
    );
  }
}
```

`ListenableBuilder` usa o padrão *builder*,
que requer um callback em vez de um widget `child` para
construir a árvore de widgets abaixo dele.
Esses widgets são flexíveis porque você pode
executar operações dentro do callback,
construindo widgets diferentes com base no estado.

[`ListenableBuilder`]: {{site.api}}/flutter/widgets/ListenableBuilder-class.html

### Lide com os possíveis estados do view model {:#handle-possible-view-model-states}

Lembre-se do `ArticleViewModel`, que tem três propriedades nas quais
a UI está interessada:

- `Summary? summary`
- `bool isLoading`
- `Exception? error`

Dependendo do estado combinado dessas propriedades,
a UI pode exibir widgets diferentes.
Use o suporte do Dart a [expressões switch][switch expressions]
para lidar com todas as combinações possíveis de maneira limpa e legível:

<?code-excerpt "fwe/wikipedia_reader/lib/step4_main.dart (view-model)"?>
```dart
class ArticleView extends StatefulWidget {
  const ArticleView({super.key});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  final ArticleViewModel viewModel = ArticleViewModel(ArticleModel());

  @override
  void initState() {
    super.initState();
    viewModel.fetchArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wikipedia Flutter')),
      body: Center(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return switch ((
              viewModel.isLoading,
              viewModel.summary,
              viewModel.error,
            )) {
              (true, _, _) => const CircularProgressIndicator(),
              (_, _, final Exception e) => Text('Error: $e'),
              (_, final summary?, _) => ArticlePage(
                summary: summary,
                nextArticleCallback: viewModel.fetchArticle,
              ),
              _ => const Text('Something went wrong!'),
            };
          },
        ),
      ),
    );
  }
}
```

Este é um excelente exemplo de como um
framework declarativo e reativo como Flutter e
um padrão como MVVM trabalham juntos:
A UI é renderizada com base no estado e atualiza quando
uma mudança de estado o exige, mas ela
não gerencia nenhum estado ou o processo de atualizar a si mesma.
A lógica de negócio e a renderização são completamente separadas uma da outra.

[switch expressions]: {{site.dart-site}}/language/branches#switch-expressions

### Complete a UI {:#complete-the-ui}

A única coisa restante é usar as propriedades e métodos fornecidos
pelo view model para construir a UI.

Agora crie um widget `ArticlePage` que exibe o conteúdo real do artigo.
Este widget reutilizável recebe dados de resumo e uma função callback:

<?code-excerpt "fwe/wikipedia_reader/lib/step4d_main.dart (page)"?>
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
    return const Center(
      child: Text('Article content will be displayed here...'),
    );
  }
}
```

### Adicione um layout rolável {:#add-a-scrollable-layout}

Substitua o placeholder por um layout de coluna rolável:

<?code-excerpt "fwe/wikipedia_reader/lib/step4e_main.dart (page)"?>
```dart highlightLines=13-16
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
    return const SingleChildScrollView(
      child: Column(
        children: [Text('Article content will be displayed here...')],
      ),
    );
  }
}
```

### Adicione conteúdo do artigo e botão {:#add-article-content-and-button}

Complete o layout com um widget de artigo e um botão de navegação:

<?code-excerpt "fwe/wikipedia_reader/lib/step4_main.dart (page)"?>
```dart highlightLines=16-20
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
          ArticleWidget(summary: summary),
          ElevatedButton(
            onPressed: nextArticleCallback,
            child: const Text('Next random article'),
          ),
        ],
      ),
    );
  }
}
```

### Crie o `ArticleWidget` {:#create-the-articlewidget}

O `ArticleWidget` lida com a exibição do conteúdo real do artigo
com estilização apropriada e renderização condicional.

#### Configure a estrutura básica do artigo {:#set-up-the-basic-article-structure}

Comece com o widget que aceita um parâmetro `summary`:

<?code-excerpt "fwe/wikipedia_reader/lib/step4f_main.dart (article)"?>
```dart
class ArticleWidget extends StatelessWidget {
  const ArticleWidget({super.key, required this.summary});

  final Summary summary;

  @override
  Widget build(BuildContext context) {
    return const Text('Article content will be displayed here...');
  }
}
```

#### Adicione padding e layout de coluna {:#add-padding-and-column-layout}

Envolva o conteúdo em padding e layout apropriados:

<?code-excerpt "fwe/wikipedia_reader/lib/step4g_main.dart (article)"?>
```dart highlightLines=8-14
class ArticleWidget extends StatelessWidget {
  const ArticleWidget({super.key, required this.summary});

  final Summary summary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        spacing: 10,
        children: [const Text('Article content will be displayed here...')],
      ),
    );
  }
}
```

#### Adicione exibição condicional de imagem {:#add-conditional-image-display}

Adicione a imagem do artigo que só é exibida quando disponível:

<?code-excerpt "fwe/wikipedia_reader/lib/step4h_main.dart (article)"?>
```dart highlightLines=13
class ArticleWidget extends StatelessWidget {
  const ArticleWidget({super.key, required this.summary});

  final Summary summary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        spacing: 10,
        children: [
          if (summary.hasImage) Image.network(summary.originalImage!.source),
          const Text('Article content will be displayed here...'),
        ],
      ),
    );
  }
}
```

#### Complete com conteúdo de texto estilizado {:#complete-with-styled-text-content}

Substitua o texto placeholder por
título, descrição e extrato devidamente estilizados:

<?code-excerpt "fwe/wikipedia_reader/lib/step4_main.dart (article)"?>
```dart highlightLines=14-25
class ArticleWidget extends StatelessWidget {
  const ArticleWidget({super.key, required this.summary});

  final Summary summary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        spacing: 10,
        children: [
          if (summary.hasImage) Image.network(summary.originalImage!.source),
          Text(
            summary.titles.normalized,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          if (summary.description != null)
            Text(
              summary.description!,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          Text(summary.extract),
        ],
      ),
    );
  }
}
```

Este widget demonstra alguns conceitos importantes de UI:

- **Renderização condicional**:
  As instruções `if` mostram conteúdo apenas quando disponível.
- **Estilização de texto**:
  Diferentes estilos de texto criam hierarquia visual usando o sistema de tema do Flutter.
- **Espaçamento apropriado**:
  O parâmetro `spacing` fornece espaçamento vertical consistente.
- **Tratamento de overflow**:
  `TextOverflow.ellipsis` evita que o texto quebre o layout.

### Execute o app completo {:#run-the-complete-app}

Faça hot reload do seu app uma última vez. Você deve ver agora:

1.  Um spinner de carregamento enquanto o artigo inicial carrega.
1.  O título, a descrição e o extrato de resumo do artigo.
1.  Uma imagem (se o artigo tiver uma).
1.  Um botão para carregar outro artigo aleatório.

Para ver a UI reativa em ação,
clique no botão **Next random article**.
O app mostra um estado de carregamento, busca novos dados e
atualiza a exibição automaticamente.

### Revisão {:#review}

<SummaryCard>
title: O que você realizou
subtitle: Aqui está um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Usou ListenableBuilder para reconstruir a UI automaticamente
    icon: sync
    details: >-
      `ListenableBuilder` ouve seu ViewModel e reconstrói automaticamente
      seus filhos sempre que `notifyListeners()` é chamado.
      No padrão MVVM,
      essa é a conexão principal entre seu ViewModel e a View.
  - title: Lidou com todos os estados possíveis com expressões switch
    icon: alt_route
    details: >-
      Usando uma expressão switch, você tratou
      as possíveis combinações de estado com uma interface de usuário apropriada,
      exibindo condicionalmente um spinner de carregamento, uma mensagem de erro
      ou o conteúdo real do artigo.
      Com esse tratamento, a UI agora está mais robusta e completa.
  - title: Construiu a camada View completa com estilização apropriada
    icon: article
    details: >-
      Você criou `ArticleView`, `ArticlePage` e
      `ArticleWidget` com renderização condicional, estilização de texto,
      espaçamento apropriado e tratamento de overflow.
      Esses são padrões de UI essenciais que você usará em todo app Flutter.
  - title: Completou a arquitetura MVVM
    icon: celebration
    details: >-
      Você construiu um app completo com as camadas Model (operações de dados),
      ViewModel (gerenciamento de estado) e View (UI reativa).
      Essa separação de responsabilidades ajuda seu código a ser
      mais testável, manutenível e escalável.
</SummaryCard>

### Teste seus conhecimentos {:#test-yourself}

<Quiz title="Quiz de ListenableBuilder">
- question: Qual é o propósito do ListenableBuilder no Flutter?
  options:
    - text: Criar animações baseadas em um ChangeNotifier.
      correct: false
      explanation: ListenableBuilder reconstrói a UI em mudanças de estado, não especificamente para animações.
    - text: "Ouvir um ChangeNotifier e reconstruir automaticamente seus widgets filhos quando `notifyListeners()` é chamado."
      correct: true
      explanation: ListenableBuilder ouve um Listenable e reconstrói sua função builder quando notificado.
    - text: Controlar manualmente quando os widgets devem ser reconstruídos.
      correct: false
      explanation: A reconstrução é automática quando notifyListeners() é chamado; você não a controla manualmente.
    - text: Fazer cache de builds de widgets para melhor performance.
      correct: false
      explanation: ListenableBuilder trata de atualizações reativas, não de cache.
- question: Quando o ListenableBuilder reconstrói seus widgets filhos?
  options:
    - text: Toda vez que o frame do app é atualizado.
      correct: false
      explanation: ListenableBuilder só reconstrói quando notificado, não a cada frame.
    - text: Quando o Listenable que ele está ouvindo chama notifyListeners().
      correct: true
      explanation: "ListenableBuilder se inscreve no Listenable e reconstrói sua função builder sempre que `notifyListeners()` é chamado."
    - text: Apenas quando o widget é montado pela primeira vez.
      correct: false
      explanation: "Ele reconstrói sempre que `notifyListeners()` é chamado, não apenas na montagem."
    - text: Quando o widget pai é reconstruído.
      correct: false
      explanation: "ListenableBuilder reconstrói com base no Listenable, não em reconstruções do pai."
</Quiz>
