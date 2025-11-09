---
ia-translate: true
title: Gerenciamento de estado no Flutter
description: Instruções sobre como gerenciar estado com ChangeNotifiers.
permalink: /tutorial/change-notifier/
sitemap: false
---

Quando desenvolvedores falam sobre gerenciamento de estado no Flutter, eles estão
essencialmente se referindo ao padrão pelo qual seu app atualiza os
dados que precisa para renderizar corretamente, e então informa ao Flutter para re-renderizar
a UI com esses novos dados.

No MVVM, essa responsabilidade cabe à camada ViewModel, que fica
entre e conecta sua UI à sua camada Model. No Flutter,
ViewModels usam a classe `ChangeNotifier` do Flutter para
notificar a UI quando os dados mudam.

Para usar [ChangeNotifier][ChangeNotifier], estenda-a em sua classe de gerenciamento de estado para
obter acesso ao método `notifyListeners()`, que dispara reconstruções da UI
quando chamado.

## Crie a estrutura básica do ViewModel

Crie a classe `ArticleViewModel` com sua estrutura básica e propriedades de estado:

```dart
class ArticleViewModel extends ChangeNotifier {
  final ArticleModel model;
  Summary? summary;
  String? errorMessage;
  bool loading = false;

  ArticleViewModel(this.model);
}
```

O ViewModel mantém três pedaços de estado:

- `summary`: Os dados atuais do artigo da Wikipedia.
- `errorMessage`: Qualquer erro que ocorreu durante a busca de dados.
- `loading`: Uma flag para mostrar indicadores de progresso.

## Adicione a inicialização do construtor

Atualize o construtor para buscar conteúdo automaticamente quando o
ViewModel é criado:

```dart
class ArticleViewModel extends ChangeNotifier {
  final ArticleModel model;
  Summary? summary;
  String? errorMessage;
  bool loading = false;

  ArticleViewModel(this.model) {
    getRandomArticleSummary();
  }

  // Method will be added next
}
```

Essa inicialização do construtor fornece conteúdo imediato quando o
ViewModel é criado. Como construtores não podem ser assíncronos,
ele delega a busca de conteúdo inicial para um método separado.

## Crie o método getRandomArticleSummary

Adicione o método que busca dados e gerencia atualizações de estado:

```dart
class ArticleViewModel extends ChangeNotifier {
  final ArticleModel model;
  Summary? summary;
  String? errorMessage;
  bool loading = false;

  ArticleViewModel(this.model) {
    getRandomArticleSummary();
  }

  Future<void> getRandomArticleSummary() async {
    loading = true;
    notifyListeners();

    // TODO: Add data fetching logic

    loading = false;
    notifyListeners();
  }
}
```
O ViewModel atualiza a propriedade `loading` e chama
`notifyListeners()` para informar a UI. Quando a operação completa, ele
alterna a propriedade de volta. Quando você construir a UI, você usará essa
propriedade `loading` para mostrar um indicador de carregamento enquanto busca um novo
artigo.

## Recupere um artigo do ArticleModel

Complete o método `getRandomArticleSummary` para buscar um resumo de artigo.
Use um [bloco try-catch][try-catch block] para lidar graciosamente com erros de rede,
e armazene mensagens de erro que a UI pode exibir aos usuários. O
método limpa erros anteriores em caso de sucesso e limpa o resumo do
artigo anterior em caso de erro para manter um estado consistente.

```dart
class ArticleViewModel extends ChangeNotifier {
  final ArticleModel model;
  Summary? summary;
  String? errorMessage;
  bool loading = false;

  ArticleViewModel(this.model) {
    getRandomArticleSummary();
  }

  Future<void> getRandomArticleSummary() async {
    loading = true;
    notifyListeners();
    try {
      summary = await model.getRandomArticleSummary();
      errorMessage = null; // Clear any previous errors
    } on HttpException catch (error) {
      errorMessage = error.message;
      summary = null;
    }
    loading = false;
    notifyListeners();
  }
}
```

## Teste o ViewModel

Antes de construir a UI completa, teste se suas requisições HTTP funcionam
imprimindo resultados no console. Primeiro, atualize o método
`getRandomArticleSummary` do seu `ArticleViewModel` para imprimir os
resultados:

```dart
Future<void> getRandomArticleSummary() async {
  loading = true;
  notifyListeners();
  try {
    summary = await model.getRandomArticleSummary();
    print('Article loaded: ${summary!.titles.normalized}'); // Temporary
    errorMessage = null;
  } on HttpException catch (error) {
    print('Error loading article: ${error.message}'); // Temporary
    errorMessage = error.message;
    summary = null;
  }
  loading = false;
  notifyListeners();
}
```

Então, atualize o widget `MainApp` para criar o ViewModel, que chama
o método `getRandomArticleSummary` na criação:

```dart
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create ViewModel to test HTTP requests
    final viewModel = ArticleViewModel(ArticleModel());

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Wikipedia Flutter'),
        ),
        body: const Center(
          child: Text('Check console for article data'),
        ),
      ),
    );
  }
}
```

Faça hot reload do seu app e verifique a saída do console. Você deve ver
ou um título de artigo ou uma mensagem de erro, o que confirma que seu
Model e ViewModel estão conectados corretamente.

[ChangeNotifier]: {{site.api}}/flutter/foundation/ChangeNotifier-class.html
[try-catch block]: https://dart.dev/language/error-handling
