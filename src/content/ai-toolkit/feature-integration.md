---
title: Integração de recursos
description: >
  Como integrar com outros recursos do Flutter.
ia-translate: true
prev:
  title: User experience
  path: /ai-toolkit/user-experience
next:
  title: Custom LLM providers
  path: /ai-toolkit/custom-llm-providers
---

Além dos recursos fornecidos automaticamente pelo [`LlmChatView`][],
diversos pontos de integração permitem que seu aplicativo se
integre perfeitamente com outros recursos para fornecer
funcionalidades adicionais:

* **Mensagens de boas-vindas**: Exiba uma saudação inicial aos usuários.
* **Prompts sugeridos**: Ofereça aos usuários prompts predefinidos para guiar as interações.
* **Instruções do sistema**: Forneça ao LLM uma entrada específica para influenciar suas respostas.
* **Desabilitar anexos e entrada de áudio**: Remova partes opcionais da interface de chat.
* **Gerenciar comportamento de cancelamento ou erro**: Altere o comportamento de cancelamento do usuário ou erro do LLM.
* **Gerenciar histórico**: Cada provider LLM permite gerenciar o histórico do chat,
  o que é útil para limpá-lo,
  alterá-lo dinamicamente e armazená-lo entre sessões.
* **Serialização/desserialização de chat**: Armazene e recupere conversas
  entre sessões do aplicativo.
* **Widgets de resposta personalizados**: Introduza componentes de interface especializados
  para apresentar respostas do LLM.
* **Estilização personalizada**: Defina estilos visuais únicos para combinar a aparência do chat
  com o aplicativo geral.
* **Chat sem interface**: Interaja diretamente com os providers LLM sem
  afetar a sessão de chat atual do usuário.
* **Providers LLM personalizados**: Construa seu próprio provider LLM para integração do chat
  com seu próprio backend de modelo.
* **Reroteamento de prompts**: Depure, registre ou redirecione mensagens destinadas ao provider
  para rastrear problemas ou rotear prompts dinamicamente.

[`LlmChatView`]: {{site.pub-api}}/flutter_ai_toolkit/latest/flutter_ai_toolkit/LlmChatView-class.html

## Mensagens de boas-vindas

O chat view permite que você forneça uma mensagem de boas-vindas personalizada
para definir o contexto para o usuário:

![Example welcome message](/assets/images/docs/ai-toolkit/example-of-welcome-message.png)

Você pode inicializar o `LlmChatView` com uma mensagem de boas-vindas
definindo o parâmetro `welcomeMessage`:

```dart
class ChatPage extends StatelessWidget {
 const ChatPage({super.key});

 @override
 Widget build(BuildContext context) => Scaffold(
       appBar: AppBar(title: const Text(App.title)),
       body: LlmChatView(
         welcomeMessage: 'Hello and welcome to the Flutter AI Toolkit!',
         provider: GeminiProvider(
           model: GenerativeModel(
             model: 'gemini-2.0-flash',
             apiKey: geminiApiKey,
           ),
         ),
       ),
     );
}
```

Para ver um exemplo completo de configuração da mensagem de boas-vindas,
confira o [welcome example][].

[welcome example]: {{site.github}}/flutter/ai/blob/main/example/lib/welcome/welcome.dart

## Prompts sugeridos

Você pode fornecer um conjunto de prompts sugeridos para dar
ao usuário uma ideia do que a sessão de chat foi otimizada:

![Example suggested prompts](/assets/images/docs/ai-toolkit/example-of-suggested-prompts.png)

As sugestões são mostradas apenas quando não há histórico de
chat existente. Clicar em uma copia o texto para a
área de edição de prompt do usuário. Para definir a lista de sugestões,
construa o `LlmChatView` com o parâmetro `suggestions`:

```dart
class ChatPage extends StatelessWidget {
 const ChatPage({super.key});

 @override
 Widget build(BuildContext context) => Scaffold(
       appBar: AppBar(title: const Text(App.title)),
       body: LlmChatView(
         suggestions: [
           'I\'m a Star Wars fan. What should I wear for Halloween?',
           'I\'m allergic to peanuts. What candy should I avoid at Halloween?',
           'What\'s the difference between a pumpkin and a squash?',
         ],
         provider: GeminiProvider(
           model: GenerativeModel(
             model: 'gemini-2.0-flash',
             apiKey: geminiApiKey,
           ),
         ),
       ),
     );
}
```

Para ver um exemplo completo de configuração de sugestões para o usuário,
dê uma olhada no [suggestions example][].

[suggestions example]: {{site.github}}/flutter/ai/blob/main/example/lib/suggestions/suggestions.dart

## Instruções do LLM

Para otimizar as respostas de um LLM com base nas necessidades
do seu aplicativo, você vai querer fornecer instruções.
Por exemplo, o [recipes example app][] usa o
parâmetro `systemInstructions` da classe `GenerativeModel`
para adaptar o LLM para se concentrar em fornecer receitas
com base nas instruções do usuário:

```dart
class _HomePageState extends State<HomePage> {
  ...
  // create a new provider with the given history and the current settings
  LlmProvider _createProvider([List<ChatMessage>? history]) => GeminiProvider(
      history: history,
        ...,
        model: GenerativeModel(
          model: 'gemini-2.0-flash',
          apiKey: geminiApiKey,
          ...,
          systemInstruction: Content.system('''
You are a helpful assistant that generates recipes based on the ingredients and
instructions provided as well as my food preferences, which are as follows:
${Settings.foodPreferences.isEmpty ? 'I don\'t have any food preferences' : Settings.foodPreferences}

You should keep things casual and friendly. You may generate multiple recipes in a single response, but only if asked. ...
''',
          ),
        ),
      );
  ...
}
```

Definir instruções do sistema é único para cada provider;
tanto o `GeminiProvider` quanto o `VertexProvider`
permitem que você as forneça através do parâmetro `systemInstruction`.

Observe que, neste caso, estamos trazendo as preferências do usuário
como parte da criação do provider LLM passado para o
construtor `LlmChatView`. Definimos as instruções como parte
do processo de criação cada vez que o usuário altera suas preferências.
O aplicativo de receitas permite que o usuário altere suas preferências alimentares
usando um drawer no scaffold:

![Example of refining prompt](/assets/images/docs/ai-toolkit/setting-food-preferences.png)

Sempre que o usuário altera suas preferências alimentares,
o aplicativo de receitas cria um novo modelo para usar as novas preferências:

```dart
class _HomePageState extends State<HomePage> {
  ...
  void _onSettingsSave() => setState(() {
        // move the history over from the old provider to the new one
        final history = _provider.history.toList();
        _provider = _createProvider(history);
      });
}
```

## Desabilitar anexos e entrada de áudio

Se você gostaria de desabilitar anexos (o botão **+**) ou entrada de áudio (o botão do microfone),
você pode fazer isso com os parâmetros `enableAttachments` e `enableVoiceNotes` no
construtor `LlmChatView`:

```dart
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ...

    return Scaffold(
      appBar: AppBar(title: const Text('Restricted Chat')),
      body: LlmChatView(
        // ...
        enableAttachments: false,
        enableVoiceNotes: false,
      ),
    );
  }
}
```

Ambos esses sinalizadores têm o padrão `true`.

## Gerenciar comportamento de cancelamento ou erro

Por padrão, quando o usuário cancela uma solicitação do LLM, a resposta do LLM será
anexada com a string "CANCEL" e uma mensagem aparecerá informando que o usuário
cancelou a solicitação. Da mesma forma, no caso de um erro do LLM, como uma conexão de
rede perdida, a resposta do LLM será anexada com a
string "ERROR" e uma caixa de diálogo de alerta aparecerá com os detalhes do erro.

Você pode substituir o comportamento de cancelamento e erro com os parâmetros `cancelMessage`,
`errorMessage`, `onCancelCallback` e `onErrorCallback` do
`LlmChatView`. Por exemplo, o seguinte código substitui o comportamento de tratamento de
cancelamento padrão:

```dart
class ChatPage extends StatelessWidget {
  // ...

  void _onCancel(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Chat cancelled')));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text(App.title)),
    body: LlmChatView(
      // ...
      onCancelCallback: _onCancel,
      cancelMessage: 'Request cancelled',
    ),
  );
}
```

Você pode substituir qualquer um ou todos esses parâmetros e o `LlmChatView` usará
seus padrões para qualquer coisa que você não substituir.

## Gerenciar histórico

A [interface padrão que define todos os providers LLM][providerIF]
que podem se conectar ao chat view inclui a capacidade de
obter e definir o histórico para o provider:

```dart
abstract class LlmProvider implements Listenable {
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments,
  });

  Stream<String> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments,
  });

  Iterable<ChatMessage> get history;
  set history(Iterable<ChatMessage> history);
}
```

[providerIF]: {{site.pub-api}}/flutter_ai_toolkit/latest/flutter_ai_toolkit/LlmProvider-class.html

Quando o histórico de um provider muda,
ele chama o método `notifyListener` exposto pela
classe base `Listenable`. Isso significa que você pode se
inscrever/cancelar a inscrição manualmente com os métodos `add` e `remove`
ou usá-lo para construir uma instância da classe `ListenableBuilder`.

O método `generateStream` chama o LLM subjacente
sem afetar o histórico. Chamar o método `sendMessageStream`
altera o histórico adicionando duas novas mensagens ao
histórico do provider—uma para a mensagem do usuário e uma para a
resposta do LLM—quando a resposta é concluída. O chat view usa
`sendMessageStream` quando processa um prompt de chat do usuário e
`generateStream` quando está processando a entrada de voz do usuário.

Para ver ou definir o histórico, você pode acessar a propriedade `history`:

```dart
void _clearHistory() => _provider.history = [];
```

A capacidade de acessar o histórico de um provider também é útil
quando se trata de recriar um provider mantendo o histórico:

```dart
class _HomePageState extends State<HomePage> {
  ...
  void _onSettingsSave() => setState(() {
        // move the history over from the old provider to the new one
        final history = _provider.history.toList();
        _provider = _createProvider(history);
      });
}
```

O método `_createProvider`
cria um novo provider com o histórico do
provider anterior _e_ as novas
preferências do usuário.
É transparente para o usuário; ele pode continuar conversando,
mas agora o LLM fornece respostas levando em conta suas
novas preferências alimentares.
Por exemplo:


```dart
class _HomePageState extends State<HomePage> {
  ...
  // create a new provider with the given history and the current settings
  LlmProvider _createProvider([List<ChatMessage>? history]) =>
    GeminiProvider(
      history: history,
      ...
    );
  ...
}
```

Para ver o histórico em ação,
confira o [recipes example app][] e o [history example app][].

[history example app]: {{site.github}}/flutter/ai/blob/main/example/lib/history/history.dart
[recipes example app]: {{site.github}}/flutter/ai/tree/main/example/lib/recipes

## Serialização/desserialização de chat

Para salvar e restaurar o histórico de chat entre sessões
de um aplicativo, é necessária a capacidade de serializar e
desserializar cada prompt do usuário, incluindo os anexos,
e cada resposta do LLM. Ambos os tipos de mensagens
(os prompts do usuário e as respostas do LLM)
são expostos na classe `ChatMessage`.
A serialização pode ser realizada usando o método `toJson`
de cada instância de `ChatMessage`.

```dart
Future<void> _saveHistory() async {
  // get the latest history
  final history = _provider.history.toList();

  // write the new messages
  for (var i = 0; i != history.length; ++i) {
    // skip if the file already exists
    final file = await _messageFile(i);
    if (file.existsSync()) continue;

    // write the new message to disk
    final map = history[i].toJson();
    final json = JsonEncoder.withIndent('  ').convert(map);
    await file.writeAsString(json);
  }
}
```

Da mesma forma, para desserializar, use o método estático `fromJson`
da classe `ChatMessage`:

```dart
Future<void> _loadHistory() async {
  // read the history from disk
  final history = <ChatMessage>[];
  for (var i = 0;; ++i) {
    final file = await _messageFile(i);
    if (!file.existsSync()) break;

    final map = jsonDecode(await file.readAsString());
    history.add(ChatMessage.fromJson(map));
  }

  // set the history on the controller
  _provider.history = history;
}
```

Para garantir uma resposta rápida ao serializar,
recomendamos escrever cada mensagem do usuário apenas uma vez.
Caso contrário, o usuário deve esperar que seu aplicativo
escreva todas as mensagens toda vez e,
diante de anexos binários,
isso pode levar um tempo.

Para ver isso em ação, confira o [history example app][].

[history example app]: {{site.github}}/flutter/ai/blob/main/example/lib/history/history.dart

## Widgets de resposta personalizados

Por padrão, a resposta do LLM mostrada pelo chat view é
Markdown formatado. No entanto, em alguns casos,
você quer criar um widget personalizado para mostrar a
resposta do LLM que seja específica e integrada ao seu aplicativo.
Por exemplo, quando o usuário solicita uma receita no
[recipes example app][], a resposta do LLM é usada
para criar um widget específico para mostrar receitas
assim como o resto do aplicativo faz e para fornecer um
botão **Add** caso o usuário queira adicionar
a receita ao seu banco de dados:

![Add recipe button](/assets/images/docs/ai-toolkit/add-recipe-button.png)

Isso é realizado definindo o parâmetro `responseBuilder`
do construtor `LlmChatView`:

```dart
LlmChatView(
  provider: _provider,
  welcomeMessage: _welcomeMessage,
  responseBuilder: (context, response) => RecipeResponseView(
    response,
  ),
),
```

Neste exemplo particular, o widget `RecipeReponseView`
é construído com o texto de resposta do provider LLM
e usa isso para implementar seu método `build`:

```dart
class RecipeResponseView extends StatelessWidget {
  const RecipeResponseView(this.response, {super.key});
  final String response;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    String? finalText;

    // created with the response from the LLM as the response streams in, so
    // many not be a complete response yet
    try {
      final map = jsonDecode(response);
      final recipesWithText = map['recipes'] as List<dynamic>;
      finalText = map['text'] as String?;

      for (final recipeWithText in recipesWithText) {
        // extract the text before the recipe
        final text = recipeWithText['text'] as String?;
        if (text != null && text.isNotEmpty) {
          children.add(MarkdownBody(data: text));
        }

        // extract the recipe
        final json = recipeWithText['recipe'] as Map<String, dynamic>;
        final recipe = Recipe.fromJson(json);
        children.add(const Gap(16));
        children.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(recipe.title, style: Theme.of(context).textTheme.titleLarge),
            Text(recipe.description),
            RecipeContentView(recipe: recipe),
          ],
        ));

        // add a button to add the recipe to the list
        children.add(const Gap(16));
        children.add(OutlinedButton(
          onPressed: () => RecipeRepository.addNewRecipe(recipe),
          child: const Text('Add Recipe'),
        ));
        children.add(const Gap(16));
      }
    } catch (e) {
      debugPrint('Error parsing response: $e');
    }

    ...

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
```

Este código analisa o texto para extrair o texto introdutório
e a receita do LLM, agrupando-os junto
com um botão **Add Recipe** para mostrar no lugar do Markdown.

Observe que estamos analisando a resposta do LLM como JSON.
É comum definir o provider no modo JSON e
fornecer um schema para restringir o formato de suas respostas
para garantir que tenhamos algo que possamos analisar.
Cada provider expõe essa funcionalidade à sua própria maneira,
mas tanto as classes `GeminiProvider` quanto `VertexProvider`
habilitam isso com um objeto `GenerationConfig` que o
exemplo de receitas usa da seguinte forma:

```dart
class _HomePageState extends State<HomePage> {
  ...

  // create a new provider with the given history and the current settings
  LlmProvider _createProvider([List<ChatMessage>? history]) => GeminiProvider(
        ...
        model: GenerativeModel(
          ...
          generationConfig: GenerationConfig(
            responseMimeType: 'application/json',
            responseSchema: Schema(...),
          systemInstruction: Content.system('''
...
Generate each response in JSON format
with the following schema, including one or more "text" and "recipe" pairs as
well as any trailing text commentary you care to provide:

{
  "recipes": [
    {
      "text": "Any commentary you care to provide about the recipe.",
      "recipe":
      {
        "title": "Recipe Title",
        "description": "Recipe Description",
        "ingredients": ["Ingredient 1", "Ingredient 2", "Ingredient 3"],
        "instructions": ["Instruction 1", "Instruction 2", "Instruction 3"]
      }
    }
  ],
  "text": "any final commentary you care to provide",
}
''',
          ),
        ),
      );
  ...
}
```

Este código inicializa o objeto `GenerationConfig`
definindo o parâmetro `responseMimeType` como `'application/json'`
e o parâmetro `responseSchema` para uma instância da
classe `Schema` que define a estrutura do JSON
que você está preparado para analisar. Além disso,
é uma boa prática também solicitar JSON e fornecer
uma descrição desse schema JSON nas instruções do sistema,
o que fizemos aqui.

Para ver isso em ação, confira o [recipes example app][].

## Estilização personalizada

O chat view vem pronto para uso com um conjunto de estilos padrão
para o plano de fundo, o campo de texto, os botões, os ícones,
as sugestões e assim por diante. Você pode personalizar completamente esses
estilos definindo os seus próprios usando o parâmetro `style` no
construtor `LlmChatView`:

```dart
LlmChatView(
  provider: GeminiProvider(...),
  style: LlmChatViewStyle(...),
),
```

Por exemplo, o [custom styles example app][custom-ex]
usa esse recurso para implementar um aplicativo com um tema de Halloween:

![Halloween-themed demo app](/assets/images/docs/ai-toolkit/demo-app.png)

Para uma lista completa dos estilos disponíveis na
classe `LlmChatViewStyle`, confira a [reference documentation][].
Para ver estilos personalizados em ação,
além do [custom styles example][custom-ex],
confira o [dark mode example][] e o [demo app][].

[custom-ex]: {{site.github}}/flutter/ai/blob/main/example/lib/custom_styles/custom_styles.dart
[dark mode example]: {{site.github}}/flutter/ai/blob/main/example/lib/dark_mode/dark_mode.dart
[demo app]: {{site.github}}/flutter/ai#online-demo
[reference documentation]: {{site.pub-api}}/flutter_ai_toolkit/latest/flutter_ai_toolkit/LlmChatViewStyle-class.html

## Chat sem interface

Você não precisa usar o chat view para acessar a
funcionalidade do provider subjacente.
Além de poder simplesmente chamá-lo com
qualquer interface proprietária que ele forneça,
você também pode usá-lo com a [LlmProvider interface][].

[LlmProvider interface]: {{site.pub-api}}/flutter_ai_toolkit/latest/flutter_ai_toolkit/LlmProvider-class.html

Como exemplo, o aplicativo de receitas fornece um
botão Magic na página de edição de receitas.
O propósito desse botão é atualizar uma receita existente
em seu banco de dados com suas preferências alimentares atuais.
Pressionar o botão permite que você visualize as alterações recomendadas e
decida se gostaria de aplicá-las ou não:

![User decides whether to update recipe in database](/assets/images/docs/ai-toolkit/apply-changes-decision.png)

Em vez de usar o mesmo provider que a parte de chat
do aplicativo usa, o que inseriria mensagens de usuário espúrias
e respostas do LLM no histórico de chat do usuário,
a página Edit Recipe cria seu próprio provider
e o usa diretamente:

```dart
class _EditRecipePageState extends State<EditRecipePage> {
  ...
  final _provider = GeminiProvider(...);
  ...
  Future<void> _onMagic() async {
    final stream = _provider.sendMessageStream(
      'Generate a modified version of this recipe based on my food preferences: '
      '${_ingredientsController.text}\n\n${_instructionsController.text}',
    );
    var response = await stream.join();
    final json = jsonDecode(response);

    try {
      final modifications = json['modifications'];
      final recipe = Recipe.fromJson(json['recipe']);

      if (!context.mounted) return;
      final accept = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(recipe.title),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Modifications:'),
              const Gap(16),
              Text(_wrapText(modifications)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(true),
              child: const Text('Accept'),
            ),
            TextButton(
              onPressed: () => context.pop(false),
              child: const Text('Reject'),
            ),
          ],
        ),
      );
      ...
    } catch (ex) {
      ...
      }
    }
  }
}
```

A chamada para `sendMessageStream` cria entradas no
histórico do provider, mas como não está associado a um chat view,
elas não serão mostradas. Se for conveniente,
você também pode fazer a mesma coisa chamando `generateStream`,
o que permite reutilizar um provider existente sem afetar
o histórico de chat.

Para ver isso em ação,
confira a [Edit Recipe page][] do exemplo de receitas.

[Edit Recipe page]: {{site.github}}/flutter/ai/blob/main/example/lib/recipes/pages/edit_recipe_page.dart

## Reroteamento de prompts

Se você gostaria de depurar, registrar ou manipular a conexão
entre o chat view e o provider subjacente,
você pode fazer isso com uma implementação de uma função [`LlmStreamGenerator`][].
Você então passa essa função para o `LlmChatView` no
parâmetro `messageSender`:

[`LlmStreamGenerator`]: {{site.pub-api}}/flutter_ai_toolkit/latest/flutter_ai_toolkit/LlmStreamGenerator.html

```dart
class ChatPage extends StatelessWidget {
  final _provider = GeminiProvider(...);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text(App.title)),
      body: LlmChatView(
        provider: _provider,
        messageSender: _logMessage,
      ),
    );

  Stream<String> _logMessage(
    String prompt, {
    required Iterable<Attachment> attachments,
  }) async* {
    // log the message and attachments
    debugPrint('# Sending Message');
    debugPrint('## Prompt\n$prompt');
    debugPrint('## Attachments\n${attachments.map((a) => a.toString())}');

    // forward the message on to the provider
    final response = _provider.sendMessageStream(
      prompt,
      attachments: attachments,
    );

    // log the response
    final text = await response.join();
    debugPrint('## Response\n$text');

    // return it
    yield text;
  }
}
```

Este exemplo registra os prompts do usuário e as respostas do LLM
conforme eles vão e voltam. Ao fornecer uma função
como `messageSender`, é sua responsabilidade chamar
o provider subjacente. Se você não fizer isso, ele não receberá a mensagem.
Essa capacidade permite que você faça coisas avançadas como rotear para
um provider dinamicamente ou Retrieval Augmented Generation (RAG).

Para ver isso em ação, confira o [logging example app][].

[logging example app]: {{site.github}}/flutter/ai/blob/main/example/lib/logging/logging.dart
