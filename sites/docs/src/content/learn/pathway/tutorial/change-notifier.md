---
ia-translate: true
title: Gerenciamento de estado no Flutter
description: Instruções sobre como gerenciar estado com ChangeNotifiers.
layout: tutorial
---

Aprenda a criar um ViewModel com ChangeNotifier e a gerenciar estados de carregamento, sucesso e erro.

<SummaryCard>
title: O que você vai realizar
items:
  - title: Criar um ViewModel com ChangeNotifier
    icon: layers
  - title: Gerenciar estados de carregamento, sucesso e erro
    icon: toggle_on
  - title: Sinalizar atualizações da UI com notifyListeners
    icon: notifications_active
</SummaryCard>

---

### Introdução {:#introduction}

Quando desenvolvedores falam sobre gerenciamento de estado no Flutter,
eles estão essencialmente se referindo ao padrão pelo qual seu app
atualiza os dados que precisa para renderizar corretamente e então
informa ao Flutter para re-renderizar a UI com esses novos dados.

No MVVM, essa responsabilidade cabe à camada ViewModel,
que fica entre e conecta sua UI à sua camada Model.
No Flutter, ViewModels usam a classe `ChangeNotifier` do Flutter para
notificar a UI quando os dados mudam.

Para usar [`ChangeNotifier`][], estenda-a em sua classe de gerenciamento de estado para
obter acesso ao método `notifyListeners()`,
que dispara reconstruções da UI quando chamado.

[`ChangeNotifier`]: {{site.api}}/flutter/foundation/ChangeNotifier-class.html

### Crie a estrutura básica do view model {:#create-the-basic-view-model-structure}

Crie a classe `ArticleViewModel` com sua
estrutura básica e propriedades de estado:

<?code-excerpt "fwe/wikipedia_reader/lib/step3a_main.dart (ArticleViewModel)"?>
```dart
class ArticleViewModel extends ChangeNotifier {
  final ArticleModel model;
  Summary? summary;
  Exception? error;
  bool isLoading = false;

  ArticleViewModel(this.model);
}
```

O `ArticleViewModel` mantém três pedaços de estado:

- `summary`: Os dados atuais do artigo da Wikipedia.
- `error`: Qualquer erro que ocorreu durante a busca de dados.
- `isLoading`: Uma flag para mostrar indicadores de progresso.

### Adicione a inicialização do construtor {:#add-constructor-initialization}

Atualize o construtor para buscar conteúdo automaticamente quando o
`ArticleViewModel` é criado:

<?code-excerpt "fwe/wikipedia_reader/lib/step3b_main.dart (ArticleViewModel)"?>
```dart
class ArticleViewModel extends ChangeNotifier {
  final ArticleModel model;
  Summary? summary;
  Exception? error;
  bool isLoading = false;

  ArticleViewModel(this.model) {
    fetchArticle();
  }

  // Methods will be added next.
  Future<void> fetchArticle() async {}
}
```

Essa inicialização do construtor fornece conteúdo imediato quando
um objeto `ArticleViewModel` é criado.
Como construtores não podem ser assíncronos,
ele delega a busca de conteúdo inicial para um método separado.

### Configure o método `fetchArticle` {:#set-up-the-fetcharticle-method}

Adicione o método `fetchArticle`, que busca dados e gerencia atualizações de estado:

<?code-excerpt "fwe/wikipedia_reader/lib/step3c_main.dart (ArticleViewModel)"?>
```dart
class ArticleViewModel extends ChangeNotifier {
  final ArticleModel model;
  Summary? summary;
  Exception? error;
  bool isLoading = false;

  ArticleViewModel(this.model) {
    fetchArticle();
  }

  Future<void> fetchArticle() async {
    isLoading = true;
    notifyListeners();

    // TODO: Add data fetching logic

    isLoading = false;
    notifyListeners();
  }
}
```

O ViewModel atualiza a propriedade `isLoading` e
chama `notifyListeners()` para informar a UI da atualização.
Quando a operação completa, ele alterna a propriedade de volta.
Quando você construir a UI, você usará essa propriedade `isLoading` para
mostrar um indicador de carregamento enquanto busca um novo artigo.

### Recupere um artigo do `ArticleModel` {:#retrieve-an-article-from-the-articlemodel}

Complete o método `fetchArticle` para buscar um resumo de artigo.
Use um [bloco try-catch][try-catch block] para lidar graciosamente com erros de rede e
armazenar mensagens de erro que a UI pode exibir aos usuários.
O método limpa erros anteriores em caso de sucesso e
limpa o resumo do artigo anterior em caso de erro para manter um estado consistente.

<?code-excerpt "fwe/wikipedia_reader/lib/step3d_main.dart (ArticleViewModel)"?>
```dart
class ArticleViewModel extends ChangeNotifier {
  final ArticleModel model;
  Summary? summary;
  Exception? error;
  bool isLoading = false;

  ArticleViewModel(this.model) {
    fetchArticle();
  }

  Future<void> fetchArticle() async {
    isLoading = true;
    notifyListeners();
    try {
      summary = await model.getRandomArticleSummary();
      error = null; // Clear any previous errors.
    } on HttpException catch (e) {
      error = e;
      summary = null;
    }
    isLoading = false;
    notifyListeners();
  }
}
```

[try-catch block]: {{site.dart-site}}/language/error-handling#catch

### Teste o ViewModel {:#test-the-viewmodel}

Antes de construir a UI completa, teste se suas requisições HTTP funcionam
imprimindo resultados no console.
Primeiro, atualize o método `fetchArticle` para
imprimir os resultados:

<?code-excerpt "fwe/wikipedia_reader/lib/step3e_main.dart (fetchArticle)"?>
```dart
Future<void> fetchArticle() async {
  isLoading = true;
  notifyListeners();
  try {
    summary = await model.getRandomArticleSummary();
    print('Article loaded: ${summary!.titles.normalized}'); // Temporary
    error = null; // Clear any previous errors.
  } on HttpException catch (e) {
    print('Error loading article: ${e.message}'); // Temporary
    error = e;
    summary = null;
  }
  isLoading = false;
  notifyListeners();
}
```

Então, atualize o widget `MainApp` para criar o `ArticleViewModel`,
que chama o método `fetchArticle` na criação:

<?code-excerpt "fwe/wikipedia_reader/lib/step3f_main.dart (MainApp)"?>
```dart
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate your `ArticleViewModel` to test its HTTP requests.
    final viewModel = ArticleViewModel(ArticleModel());

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Wikipedia Flutter')),
        body: const Center(child: Text('Check console for article data')),
      ),
    );
  }
}
```

Faça hot reload do seu app e verifique a saída do console.
Você deve ver ou um título de artigo ou uma mensagem de erro,
o que confirma que seu Model e ViewModel estão conectados corretamente.

### Revisão {:#review}

<SummaryCard>
title: O que você realizou
subtitle: Aqui está um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Criou o ArticleViewModel com ChangeNotifier
    icon: layers
    details: >-
      O ViewModel fica entre sua UI e o Model,
      gerenciando o estado e conectando as duas camadas.
      Ao estender `ChangeNotifier`, seu ViewModel ganha a capacidade de
      notificar listeners quando os dados mudam.
  - title: Gerenciou estados de carregamento, sucesso e erro
    icon: toggle_on
    details: >-
      Seu ViewModel acompanha três pedaços de estado:
      `isLoading`, `summary` e `error`.
      Usando `try` e `catch`, você lida graciosamente com erros de rede e
      mantém um estado consistente para cada resultado possível.
  - title: Usou notifyListeners para sinalizar atualizações da UI
    icon: notifications_active
    details: >-
      Chamar `notifyListeners()` informa a todos os widgets que estão ouvindo para se reconstruírem.
      Você o chama depois de definir `loading = true` e novamente
      depois que a operação completa.
      É assim que você pode implementar atualizações reativas da UI no Flutter.
</SummaryCard>

### Teste seus conhecimentos {:#test-yourself}

<Quiz title="Quiz de gerenciamento de estado">
- question: O que é um ChangeNotifier?
  options:
    - text: Um widget que exibe notificações para o usuário.
      correct: false
      explanation: ChangeNotifier não é um widget; é uma classe para gerenciar estado.
    - text: Uma classe que pode notificar listeners quando seus dados mudam, permitindo atualizações reativas da UI.
      correct: true
      explanation: ChangeNotifier fornece o método notifyListeners para sinalizar aos widgets que se reconstruam quando o estado muda.
    - text: Uma classe embutida do Dart para enviar notificações push.
      correct: false
      explanation: ChangeNotifier é para gerenciamento de estado dentro do app, não para notificações push.
    - text: Um tipo de animation controller no Flutter.
      correct: false
      explanation: Animation controllers são separados; ChangeNotifier é para gerenciamento de estado.
- question: "O que chamar `notifyListeners()` faz em um ChangeNotifier?"
  options:
    - text: Salva o estado atual no armazenamento local.
      correct: false
      explanation: "`notifyListeners()` sinaliza atualizações da UI; persistência requer uma implementação separada."
    - text: Informa a todos os widgets que estão ouvindo para se reconstruírem e refletirem o novo estado.
      correct: true
      explanation: "Chamar `notifyListeners()` dispara uma reconstrução de todos os widgets que estão ouvindo este ChangeNotifier."
    - text: Registra a mudança de estado no console para depuração.
      correct: false
      explanation: Ele não registra nada; ele sinaliza aos listeners que se reconstruam.
    - text: Redefine todas as propriedades de estado para seus valores padrão.
      correct: false
      explanation: "`notifyListeners()` não modifica o estado; ele apenas sinaliza que o estado mudou."
</Quiz>
