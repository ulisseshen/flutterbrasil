---
ia-translate: true
title: Começando com o SDK GenUI para Flutter
shortTitle: Começando com o SDK GenUI
breadcrumb: Começando
description: >-
  Saiba como usar o SDK GenUI para Flutter e adicioná-lo
  ao seu app Flutter existente.
next:
  title: Entrada e eventos
  path: /ai/genui/input-events
prev:
  title: Componentes principais e conceitos do SDK GenUI
  path: /ai/genui/components
---

Este guia explica como começar com o SDK GenUI para Flutter
e sua série de pacotes.
Os componentes principais do SDK
são descritos na página [componentes principais][main components].

:::experimental
O pacote `genui` está em
alfa e provavelmente vai mudar.
:::

Use as instruções a seguir para adicionar o [`genui`][`genui`] ao seu app Flutter.
Os exemplos de código mostram como executar as instruções em um app novo criado
com o comando [`flutter create`][`flutter create`], mas você pode seguir os mesmos
passos para o seu app Flutter existente.

[`genui`]: {{site.pub-pkg}}/genui
[main components]: /ai/genui/components
[`flutter create`]: /reference/create-new-app

## Configure seu provedor de agente {:#configure-your-agent-provider}

O pacote `genui` pode se conectar a vários provedores de agentes.
Os provedores disponíveis incluem:

**Firebase AI Logic**
: Útil para apps de produção em que as interações com o LLM ficam
  todas no seu cliente Flutter, sem precisar de um servidor.
  O Firebase também facilita o envio seguro dos seus
  recursos de IA, já que o Firebase cuida do
  gerenciamento da sua chave de API do Gemini.

**GenUI A2UI**
: Útil para arquiteturas cliente/servidor em que o seu
  agente roda no servidor.

**Crie o seu próprio**
: Você também pode criar o seu próprio adaptador
  para se conectar ao provedor de LLM de sua preferência.
  Em breve, esperamos trazer mais novidades, junto com a comunidade.

<Tabs key="agent-provider" wrapped="true">

<Tab name="Firebase AI Logic">

Para se conectar ao Gemini usando o SDK Firebase AI Logic,
siga estas instruções:

 1. [Crie um novo projeto Firebase][Create a new Firebase project] usando o Firebase Console.

 2. [Ative a API Gemini][Enable the Gemini API] para esse projeto.

 3. Siga os três primeiros passos do [guia de configuração do Flutter no Firebase][Firebase's Flutter setup guide]
    para adicionar o Firebase ao seu app.

 4. Use `dart pub add` para adicionar `genui` e `firebase_ai` como
    dependências no seu arquivo `pubspec.yaml`:

    ```console
    $ dart pub add genui firebase_ai
    ```

 5. No método `main` do seu app, garanta que os bindings de widgets
    estejam inicializados e depois inicialize o Firebase:

    ```dart
    import 'package:material_ui/material_ui.dart';
    import 'package:firebase_core/firebase_core.dart';
    import 'firebase_options.dart';

    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      runApp(const MyApp());
    }
    ```

 6. Crie uma instância do modelo generativo do Firebase AI Logic e
    envolva-a com o seu `SurfaceController` e o `A2uiTransportAdapter`:

    ```dart
    import 'package:genui/genui.dart';
    import 'package:firebase_ai/firebase_ai.dart';

    final catalog = Catalog([
      // ...
    ]);
    final catalogs = [catalog];

    final surfaceController = SurfaceController(catalogs: catalogs);
    
    final promptBuilder = PromptBuilder.chat(
      catalog: catalog,
      systemPromptFragments: ['You are a helpful assistant.'],
    );

    final model = FirebaseAI.vertexAI().generativeModel(
      model: 'gemini-3.5-flash',
      systemInstruction: Content.system(promptBuilder.systemPromptJoined()),
    );

    // The Conversation wires transport -> controller internally.
    late final A2uiTransportAdapter transportAdapter;
    transportAdapter = A2uiTransportAdapter(onSend: (message) async {
      // final stream = model.generateContentStream(...);
      // await for (final chunk in stream) {
      //   transportAdapter.addChunk(chunk.text ?? '');
      // }
    });

    final conversation = Conversation(
      controller: surfaceController,
      transport: transportAdapter,
    );
    ```

[Create a new Firebase project]: https://support.google.com/appsheet/answer/10104995
[Enable the Gemini API]: https://firebase.google.com/docs/gemini-in-firebase/set-up-gemini
[Firebase's Flutter setup guide]: https://firebase.google.com/docs/flutter/setup
[`firebase_ai_logic`]: {{site.pub-pkg}}/firebase_ai_logic

</Tab>

<Tab name="GenUI A2UI">

Um pacote de integração para o [`genui`][`genui`] e o
[Protocolo de UI em streaming A2UI][A2UI Streaming UI Protocol]. Este pacote permite que
apps Flutter se conectem a um servidor Agent-to-Agent (A2UI) e renderizem
interfaces de usuário dinâmicas geradas por um agente de IA
usando o framework `genui`.

Os principais componentes deste pacote incluem:

* `A2uiAgentConnector`:
  Cuida da comunicação de baixo nível via web socket com o
  servidor A2A, incluindo o envio de mensagens e a análise
  dos eventos do stream.
* `AgentCard`:
  Uma classe de dados que guarda metadados sobre o agente de IA conectado.

Siga estas instruções:

 1. Configure as dependências:
    Use `dart pub add` para adicionar `genui` e `genui_a2a` como
    dependências no seu arquivo `pubspec.yaml`.

    ```console
    $ dart pub add genui genui_a2a
    ```

 2. Inicialize o `SurfaceController`:
    Configure o `SurfaceController` com os seus `Catalog`s de widgets.

 3. Crie o `A2uiTransportAdapter`:
    Instancie o `A2uiTransportAdapter` para analisar as mensagens.

 4. Crie o `A2uiAgentConnector`:
    Instancie o `A2uiAgentConnector`, informando a URI do servidor A2A.

 5. Crie o `Conversation`:
    Passe o adaptador e o controlador para o `Conversation`.

 6. Renderize com `Surface`:
    Use widgets `Surface` na sua UI para exibir
    o conteúdo gerado pelo agente.

 7. Envie mensagens:
    Use `connector.connectAndSend` ou `Conversation.sendMessage` para enviar
    a entrada do usuário ao agente.

    ```dart
    import 'package:material_ui/material_ui.dart';
    import 'package:genui/genui.dart';
    import 'package:genui_a2a/genui_a2a.dart';
    import 'package:logging/logging.dart';

    void main() {
      // Setup logging.
      Logger.root.level = Level.ALL;
      Logger.root.onRecord.listen((record) {
        print('${record.level.name}: ${record.time}: ${record.message}');
        if (record.error != null) {
          print(record.error);
        }
        if (record.stackTrace != null) {
          print(record.stackTrace);
        }
      });

      runApp(const GenUIExampleApp());
    }

    class GenUIExampleApp extends StatelessWidget {
      const GenUIExampleApp({super.key});

      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'A2UI Example',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const ChatScreen(),
        );
      }
    }

    class ChatScreen extends StatefulWidget {
      const ChatScreen({super.key});

      @override
      State<ChatScreen> createState() => _ChatScreenState();
    }

    class _ChatScreenState extends State<ChatScreen> {
      final TextEditingController _textController = TextEditingController();
      final SurfaceController _surfaceController =
          SurfaceController(catalogs: [BasicCatalogItems.asCatalog()]);
      late final A2uiTransportAdapter _transportAdapter;
      late final Conversation _uiAgent;
      late final A2uiAgentConnector _connector;
      final List<ChatMessage> _messages = [];

      @override
      void initState() {
        super.initState();
        
        // The Conversation wires transport -> controller internally.
        _transportAdapter = A2uiTransportAdapter(onSend: (message) async {
          // Implement sending to LLM if needed, or handled by connector
        });
        
        _connector = A2uiAgentConnector(
          // TODO: Replace with your A2A server URL.
          url: Uri.parse('http://localhost:8080'),
        );
        _uiAgent = Conversation(
          controller: _surfaceController,
          transport: _transportAdapter,
        );

        // Listen for messages from the remote agent.
        _connector.stream.listen(_surfaceController.handleMessage);

      }

      @override
      void dispose() {
        _textController.dispose();
        _uiAgent.dispose();
        _transportAdapter.dispose();
        _surfaceController.dispose();
        _connector.dispose();
        super.dispose();
      }

      void _handleSubmitted(String text) async {
        if (text.isEmpty) return;
        _textController.clear();
        final message = ChatMessage.user(text);
        setState(() {
          _messages.insert(0, message);
        });
        
        final responseText = await _connector.connectAndSend(message);
        
        // Handling response depends on your app's logic
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('A2UI Example'),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) =>
                      _buildMessage(_messages[index]),
                  itemCount: _messages.length,
                ),
              ),
              const Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
              // Surface for the main AI-generated UI:
              SizedBox(
                height: 300,
                child: Surface(
                  surfaceContext: _surfaceController.contextFor('main_surface'),
                ),
              ),
            ],
          ),
        );
      }

      Widget _buildMessage(ChatMessage message) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(child: Text(message.role == ChatMessageRole.user ? 'U' : 'A')),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(message.role == ChatMessageRole.user ? 'User' : 'Agent',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: Text(message.parts.whereType<TextPart>().map((e) => e.text).join('\n')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      Widget _buildTextComposer() {
        return IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                    controller: _textController,
                    onSubmitted: _handleSubmitted,
                    decoration:
                        const InputDecoration.collapsed(hintText: 'Send a message'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _handleSubmitted(_textController.text),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    ```

O diretório [exemplo][example] no pub.dev contém um aplicativo completo
que demonstra como usar este pacote.

[example]: {{site.pub-pkg}}/genui_a2a/example
[A2UI Streaming UI Protocol]: https://a2ui.org/

</Tab>

<Tab name="Crie o seu próprio">

Para usar o `genui` com outro provedor de agentes,
siga a documentação do SDK desse provedor para implementar uma conexão
e transmita os resultados para um `A2uiTransportAdapter`.

:::warning
`PromptBuilder.chat()` gera um prompt de sistema que pode ter
**3.000–5.000+ tokens**, o que pode exceder a janela de contexto
de modelos on-device ou pequenos.
Se você estiver mirando um LLM on-device, considere:

- Escrever um prompt de sistema personalizado e compacto que cubra apenas o
  fluxo A2UI de `createSurface` até `updateComponents`.
- Usar `systemPromptFragments` para passar apenas as partes do
  esquema que o seu caso de uso exige.
:::

</Tab>

</Tabs>

## Crie a conexão com um agente {:#create-the-connection-to-an-agent}

Se você compilar o seu projeto Flutter para iOS ou macOS,
adicione esta chave no(s) arquivo(s) `{ios,macos}/Runner/*.entitlements`
para habilitar requisições de rede de saída:

```xml
<dict>
...
<key>com.apple.security.network.client</key>
<true/>
</dict>
```

Em seguida, use as instruções a seguir para conectar o seu app
ao provedor de agente escolhido.

 1. Crie um `SurfaceController` e forneça a ele os catálogos
    de widgets que você quer disponibilizar ao agente.
    Crie um `A2uiTransportAdapter` para analisar as mensagens e conecte-o.

 2. Crie um `PromptBuilder` e forneça a ele uma
    instrução de sistema e as ferramentas (funções
    que você quer que o agente possa invocar).
    Você deve sempre incluir as ferramentas fornecidas pelo `SurfaceController`,
    mas pode incluir outras. Adicione isso ao prompt de sistema do seu LLM.

 3. Crie um `Conversation` usando as instâncias de
    `SurfaceController` e `A2uiTransportAdapter`. O seu app vai
    interagir principalmente com esse objeto para realizar as tarefas.

    Por exemplo:

    ```dart
    class _MyHomePageState extends State<MyHomePage> {
      late final SurfaceController _surfaceController;
      late final A2uiTransportAdapter _transportAdapter;
      late final Conversation _conversation;

      @override
      void initState() {
        super.initState();

        // Create a SurfaceController with a widget catalog.
        // The BasicCatalogItems contain basic widgets for text, markdown, and images.
        _surfaceController = SurfaceController(catalogs: [BasicCatalogItems.asCatalog()]);

        // The Conversation wires transport -> controller internally.
        _transportAdapter = A2uiTransportAdapter(onSend: (message) async {
          // Implement sending to LLM and pipe chunks back.
        });

        final catalog = BasicCatalogItems.asCatalog();
        final promptBuilder = PromptBuilder.chat(
          catalog: catalog,
          systemPromptFragments: [
            '''
            You are an expert in creating funny riddles. Every time I give you a word,
            you should generate UI that displays one new riddle related to that word.
            Each riddle should have both a question and an answer.
            '''
          ],
        );

        // ... initialize your LLM Client of choice using promptBuilder.systemPromptJoined()

        // Create the Conversation to orchestrate everything.
        _conversation = Conversation(
          controller: _surfaceController,
          transport: _transportAdapter,
        );
        
        // Listen for surface lifecycle events:
        _conversation.events.listen((event) {
          if (event is ConversationSurfaceAdded) {
            _onSurfaceAdded(event);
          } else if (event is ConversationSurfaceRemoved) {
            _onSurfaceDeleted(event);
          }
        });
      }

      @override
      void dispose() {
        _textController.dispose();
        _conversation.dispose();
        _transportAdapter.dispose();
    
        super.dispose();
      }
    }
    ```
   
## Envie mensagens e exiba as respostas do agente {:#send-messages-and-display-the-agents-responses}

Envie uma requisição ao agente usando o método `sendRequest` da classe `Conversation`,
ou transmitindo diretamente para o seu cliente LLM e enviando o stream
de resultados ao adaptador usando `_transportAdapter.addChunk`.

Para receber e exibir a UI gerada:

  1. Escute o stream `events` em `Conversation` para acompanhar a adição
     e a remoção das superfícies de UI conforme são geradas.
     Esses eventos incluem um _ID de superfície_ para cada superfície.

  2. Crie um widget `Surface` para cada superfície ativa, usando
     os IDs de superfície recebidos no passo anterior.

     Por exemplo:

     ```dart
     class _MyHomePageState extends State<MyHomePage> {
       // ...

       final _textController = TextEditingController();
       final _surfaceIds = <String>[];

       // Send a request containing the user's [text] to the agent.
       void _sendMessage(String text) async {
         if (text.trim().isEmpty) return;
         // await _conversation.sendRequest(ChatMessage.user(TextPart(text)));
       }

       // Invoked by the events stream listener when a new
       // UI surface is generated. Here, the ID is stored so the
       // build method can create a Surface to display it.
       void _onSurfaceAdded(ConversationSurfaceAdded update) {
         setState(() {
           _surfaceIds.add(update.surfaceId);
         });
       }

       // Invoked by the events stream listener when a UI surface is removed.
       void _onSurfaceDeleted(ConversationSurfaceRemoved update) {
         setState(() {
           _surfaceIds.remove(update.surfaceId);
         });
       }

       @override
       Widget build(BuildContext context) {
         return Scaffold(
           appBar: AppBar(
             backgroundColor: Theme.of(context).colorScheme.inversePrimary,
             title: Text(widget.title),
           ),
           body: Column(
             children: [
               Expanded(
                 child: ListView.builder(
                   itemCount: _surfaceIds.length,
                   itemBuilder: (context, index) {
                     // For each surface, create a Surface to display it.
                     final id = _surfaceIds[index];
                     return Surface(surfaceContext: _surfaceController.contextFor(id));
                   },
                 ),
               ),
               SafeArea(
                 child: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                   child: Row(
                     children: [
                       Expanded(
                         child: TextField(
                           controller: _textController,
                           decoration: const InputDecoration(
                             hintText: 'Enter a message',
                           ),
                         ),
                       ),
                       const SizedBox(width: 16),
                       ElevatedButton(
                         onPressed: () {
                           // Send the user's text to the agent.
                           _sendMessage(_textController.text);
                           _textController.clear();
                         },
                         child: const Text('Send'),
                       ),
                     ],
                   ),
                 ),
               ),
             ],
           ),
         );
       }
     }
     ```

## Adicione seus próprios widgets ao catálogo {:#custom-widgets}

Para sua conveniência, você pode usar o catálogo principal de widgets fornecido.
No entanto, a maioria dos apps de produção vai querer definir um
catálogo personalizado de widgets.

Para adicionar seus próprios widgets, use as instruções a seguir.

 1. Dependa do pacote `json_schema_builder`

    Use `dart pub add` para adicionar `json_schema_builder` como
    dependência no seu arquivo `pubspec.yaml`:
   
    ```console
    $ dart pub add json_schema_builder
    ```

 2. Crie o esquema do novo widget

    Cada item do catálogo precisa de um esquema que defina os dados
    necessários para preenchê-lo. Usando o pacote `json_schema_builder`,
    defina um esquema para o novo widget.

    ```dart
    import 'package:json_schema_builder/json_schema_builder.dart';
    import 'package:material_ui/material_ui.dart';
    import 'package:genui/genui.dart';

    final _schema = S.object(
      properties: {
        'question': S.string(description: 'The question part of a riddle.'),
        'answer': S.string(description: 'The answer part of a riddle.'),
      },
      required: ['question', 'answer'],
    );
    ```

 3. Crie um `CatalogItem`

    Cada `CatalogItem` representa um tipo de widget que o agente
    pode gerar. Para isso, ele combina um nome, um esquema e uma
    função builder que produz os widgets que compõem a UI gerada.

    ```dart
    final riddleCard = CatalogItem(
      name: 'RiddleCard',
      dataSchema: _schema,
      widgetBuilder:
          (itemContext) {
            final json = itemContext.data as Map<String, Object?>;
            final question = json['question'] as String;
            final answer = json['answer'] as String;

            final context = itemContext.buildContext;
    
            return Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(border: Border.all()),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(question, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8.0),
                  Text(answer, style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
            );
          },
    );
    ```

 4. Adicione o `CatalogItem` ao catálogo

     Inclua seus itens de catálogo ao instanciar o `SurfaceController`.

    ```dart
    _surfaceController = SurfaceController(
      catalogs: [BasicCatalogItems.asCatalog().copyWith(newItems: [riddleCard])],
    );
    ```

 5. Atualize a instrução de sistema para usar o novo widget

    Para garantir que o agente saiba usar o seu novo widget,
    informe à instrução de sistema como e quando fazer isso.
    Forneça o nome do `CatalogItem` ao fazer isso.

    ```dart
    final promptBuilder = PromptBuilder.chat(
      catalog: catalog,
      systemPromptFragments: [
        '''
        You are an expert in creating funny riddles. Every time I give you a word,
        generate a RiddleCard that displays one new riddle related to that word.
        Each riddle should have both a question and an answer.
        '''
      ],
    );
    
    // Pass promptBuilder.systemPromptJoined() to your LLM Config
    ```

{:.steps}

## Modelo de dados e vinculação de dados {:#data-model-and-data-binding}

Um conceito central no `genui` é o `DataModel`, um armazenamento centralizado
e observável para todo o estado dinâmico da UI. Em vez de cada widget
gerenciar o próprio estado, o estado fica armazenado no `DataModel`.

Os widgets são _vinculados_ aos dados desse modelo.
Quando os dados no modelo mudam, somente os widgets que dependem
daquele dado específico são reconstruídos.
Isso é feito por meio de um objeto `DataContext` passado para a
função builder de cada widget.

### Vinculação ao modelo de dados {:#binding-to-the-data-model}

Para vincular a propriedade de um widget ao modelo de dados,
especifique um objeto JSON especial nos dados enviados pela IA.
Esse objeto pode conter primitivos JSON padrão
(para valores estáticos) ou um objeto com uma propriedade `path`
(para vincular a um valor no modelo de dados).

Por exemplo, para exibir o nome de um usuário em um widget `Text`,
a IA geraria:

```json
{
  "id": "welcome-text",
  "component": "Text",
  "text": "Welcome to GenUI",
  "variant": "h1"
}
```

### Imagem {:#image}

```json
{
  "id": "image",
  "component": "Image",
  "url": "https://example.com/image.png",
  "variant": "mediumFeature"
}
```

### Atualizando o modelo de dados {:#updating-the-data-model}

Widgets de entrada, como `TextField`, atualizam o `DataModel` diretamente.
Quando o usuário digita em um campo de texto vinculado a `/user/name`,
o `DataModel` é atualizado e qualquer outro widget vinculado ao mesmo
caminho é reconstruído automaticamente para mostrar o novo valor.

Esse fluxo de dados reativo simplifica o gerenciamento de estado e cria
um ciclo de interação poderoso e de alta largura de banda entre
o usuário, a UI e a IA.

## Próximos passos {:#next-steps}

Confira os [exemplos][examples] incluídos no repositório do `genui`.
O [app de viagens][travel app] mostra como definir um catálogo
de widgets próprio, que o agente pode usar para gerar uma UI
específica do domínio.

Se algo estiver confuso ou faltando, por favor [crie uma issue][create an issue].

[examples]: {{site.repo.organization}}/genui/blob/main/examples
[travel app]: {{site.repo.organization}}/genui/blob/main/examples/travel_app
[create an issue]: {{site.repo.organization}}/genui/issues/new/choose

## Instruções do sistema {:#system-instructions}

O pacote `genui` fornece ao LLM um conjunto de ferramentas que ele pode usar
para gerar UI. Para que o LLM use essas ferramentas,
as instruções de sistema fornecidas por meio do `PromptBuilder` devem
dizer isso explicitamente.

É por isso que o [exemplo anterior][instruction-example] inclui uma
instrução de sistema para o agente com a linha
"Every time I give you a word, you should generate UI that...":

```dart highlightLines=5-6
final promptBuilder = PromptBuilder.chat(
  catalog: catalog,
  systemPromptFragments: [
    '''
    You are an expert in creating funny riddles.
    Every time I give you a word, you should generate UI that
    displays one new riddle related to that word.
    Each riddle should have both a question and an answer.
    '''
  ],
);
```

[instruction-example]: /ai/genui/get-started#create-the-connection-to-an-agent

## Solução de problemas/FAQ {:#troubleshoot}

### Como posso configurar o log? {:#how-can-i-configure-logging}

Para observar a comunicação entre o seu app e o agente,
ative o log no seu método `main`.

```dart
import 'package:logging/logging.dart';
import 'package:genui/genui.dart';

final logger = configureLogging(level: Level.ALL);

void main() async {
  logger.onRecord.listen((record) {
    debugPrint('${record.loggerName}: ${record.message}');
  });

  // Additional initialization of bindings and Firebase.
}
```

### Estou recebendo erros sobre a minha versão mínima do macOS/iOS {:#im-getting-errors-about-my-minimum-macosios-version}

O Firebase tem um [requisito de versão mínima][minimum version requirement]
para as plataformas da Apple, que pode ser maior que o padrão do Flutter.
Verifique o seu `Podfile` (para iOS) e o `CMakeLists.txt` (para macOS)
para garantir que você esteja mirando uma versão que atenda ou
supere os requisitos do Firebase.

[Create a new Firebase project]: https://support.google.com/appsheet/answer/10104995
[create an issue]: {{site.repo.organization}}/genui/issues/new/choose
[Enable the Gemini API]: https://firebase.google.com/docs/gemini-in-firebase/set-up-gemini
[examples]: {{site.repo.organization}}/genui/blob/main/examples
[Firebase's Flutter setup guide]: https://firebase.google.com/docs/flutter/setup
[`genui`]: {{site.pub-pkg}}/genui
[Key components]: /ai/genui/components
[minimum version requirement]: https://firebase.google.com/support/release-notes/ios
