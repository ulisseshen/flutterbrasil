---
ia-translate: true
title: Chamadas de ferramentas (também conhecidas como chamadas de função)
shortTitle: Chamadas de ferramentas
description: >
  Aprenda a implementar chamadas de ferramentas, gerenciar loops agênticos e incorporar
  interações com humanos no loop usando o SDK Firebase AI Logic.
prev:
  title: Estrutura e saída
  path: /ai/best-practices/structure-output
next:
  title: Modo de interação
  path: /ai/best-practices/mode-of-interaction
---


Embora seja verdade que os LLMs são treinados essencialmente com a internet inteira, eles
não sabem tudo. Eles sabem o que estava na internet pública no dia em que foram
treinados, mas não sabem nada mais recente do que isso. Eles não
sabem nada que seja privado para você ou sua organização. E mesmo as coisas
que eles sabem podem facilmente se misturar com outras coisas que eles também sabem.

Para esses cenários, e muitos outros, costumamos fornecer a um LLM uma ou mais
ferramentas.

### Ferramenta definida {:#tool-defined}

Uma ferramenta é um nome, uma descrição e um JSON schema para o formato dos dados de
entrada quando o LLM "chama" a ferramenta. Por exemplo, se pedirmos ao LLM para "Reduzir
os carboidratos da receita do café da manhã All America da vovó", ele não saberá qual é
a receita da vovó, a menos que lhe demos uma ferramenta "lookupRecipe" que recebe uma
string de consulta que podemos usar para buscar a receita.

Conceitualmente, uma ferramenta é algo que damos ao LLM para chamar quando ele precisa
desses dados ou serviços. A forma como um LLM chama uma ferramenta é respondendo à
requisição do app com uma mensagem especialmente formatada que significa "chamada de ferramenta". Uma mensagem de
chamada de ferramenta inclui o nome e os argumentos JSON da ferramenta. O app processa a
chamada da ferramenta e envia o resultado em outra requisição ao LLM, à qual o LLM então
responde.

Isso pode continuar por um tempo. Um app pode configurar uma instância de modelo com qualquer
número de ferramentas (embora o LLM funcione melhor com um conjunto menor de
ferramentas direcionadas que não se sobreponham em funcionalidade). O LLM pode agrupar qualquer número de
chamadas de ferramenta em sua resposta e pode receber qualquer número de resultados de ferramentas em uma requisição.
O LLM consolida várias idas e vindas de prompts e resultados de chamadas de ferramentas por
meio de uma pilha de mensagens que forma um histórico de pares de requisição/resposta.

Quando termina as chamadas de ferramentas, o LLM retorna sua resposta final, por
exemplo "Aqui está uma versão da receita do café da manhã All American da vovó que é
rica em proteínas e pobre em carboidratos…".

### Funções do Gemini {:#gemini-functions}

No SDK Firebase AI Logic, uma ferramenta é chamada de "function", mas é a mesma
coisa. No exemplo, o modelo resolvedor de pistas é configurado com uma função para
buscar detalhes de palavras. Se o LLM quiser detalhes sobre uma palavra para ajudar
no processo de resolução, chamar a função fornece a ele dados da [API Free
Dictionary][dictionary-api]:

```json
[
  {
    "word": "tool",
    "phonetic": "/tuːl/",
    "phonetics": [
      {
        "text": "/tuːl/",
        "audio": "https://api.dictionaryapi.dev/media/pronunciations/en/tool-uk.mp3",
        "sourceUrl": "https://commons.wikimedia.org/w/index.php?curid=94709459",
        "license": {
          "name": "BY-SA 4.0",
          "url": "https://creativecommons.org/licenses/by-sa/4.0"
        }
      }
    ],
    "meanings": [
      {
        "partOfSpeech": "noun",
        "definitions": [
          {
            "definition": "A mechanical device intended to make a task easier.",
            "synonyms": [],
            "antonyms": [],
            "example": "Hand me that tool, would you?   I don't have the right tools to start fiddling around with the engine."
          },
...
```

O app tem uma função Dart que faz a busca:

```dart
// Look up the metadata for a word in the dictionary API.
Future<Map<String, dynamic>> _getWordMetadataFromApi(String word) async {
  final url = Uri.parse(
    'https://api.dictionaryapi.dev/api/v2/entries/en/${Uri.encodeComponent(word)}',
  );

  final response = await http.get(url);
  return response.statusCode == 200
      ? {'result': jsonDecode(response.body)}
      : {'error': 'Could not find a definition for "$word".'};
}
```

O modelo é configurado com a função de busca como parte da inicialização:

```dart
// The model for solving clues.
_clueSolverModel = FirebaseAI.googleAI().generativeModel(
  model: 'gemini-2.5-flash',
  systemInstruction: Content.text(clueSolverSystemInstruction),
  tools: [
    Tool.functionDeclarations([
      FunctionDeclaration(
        'getWordMetadata',
        'Gets grammatical metadata for a word, like its part of speech. '
        'Best used to verify a candidate answer against a clue that implies a '
        'grammatical constraint.',
        parameters: {
           'word': Schema(SchemaType.string, description: 'The word to look up.'),
         },
       ),
    ]),
  ],
);
```

Para mais confiabilidade, também é uma boa ideia listar as ferramentas na instrução
de sistema:

````dart
static String get clueSolverSystemInstruction =>
    '''
You are an expert crossword puzzle solver.

...

### Tool: `getWordMetadata`

You have a tool to get grammatical information about a word.

**When to use:**
- This tool is most helpful as a verification step after you have a likely answer.
- Consider using this tool when a clue contains a grammatical hint that could be ambiguous.
- **Good candidates for verification:**
  - Clues that seem to be verbs (e.g., "To run," "Waving").
  - Clues that are adverbs (e.g., "Happily," "Quickly").
  - Clues that specify a plural form.
- **Try to avoid using the tool for:**
  - Simple definitions (e.g., "A small dog").
  - Fill-in-the-blank clues (e.g., "___ and flow").
  - Proper nouns (e.g., "Capital of France").

**Function signature:**
```json
${jsonEncode(_getWordMetadataFunction.toJson())}
```
''';
````

Quando o app faz uma requisição, o modelo agora tem uma ferramenta para usar quando decidir
que ela será útil. Para oferecer suporte a chamadas de ferramentas, precisamos implementar um
loop agêntico.

## O loop agêntico {:#the-agentic-loop}

Um LLM é funcionalmente sem estado, o que significa que você precisa fornecer todos os
dados de que ele precisa a cada requisição. Para uma requisição que é apenas o prompt e
quaisquer arquivos que você queira enviar junto, o SDK Firebase AI Logic expõe o
método `generateContent` na sua instância de modelo.

No entanto, a chamada de ferramentas exige um histórico de mensagens que forme o prompt
inicial, bem como os pares de resposta/requisição que compõem as chamadas de ferramentas e os
resultados das ferramentas. Para oferecer suporte a isso, o Firebase Logic AI fornece um objeto "chat"
para reunir o histórico. Usamos esse objeto para construir o loop agêntico:

- Inicie um chat para manter o histórico de mensagens em vários pares de requisição/resposta  
- Reúna os resultados das ferramentas para quaisquer chamadas de ferramenta fornecidas  
- Agrupe os resultados das ferramentas em uma nova requisição  
- Repita até que o modelo forneça uma resposta sem chamadas de ferramenta  
- Retorne o texto acumulado em todas as respostas

Aqui está esse algoritmo expresso como um método de extensão da classe `GenerativeModel`, para que possamos chamá-lo da mesma forma que chamamos `generateContent`:

```dart
extension on GenerativeModel {
  Future<String> generateContentWithFunctions({
    required String prompt,
    required Future<Map<String, dynamic>> Function(FunctionCall) onFunctionCall,
  }) async {
    // Use a chat session to support multiple request/response pairs, which is
    // needed to support function calls.
    final chat = startChat();
    final buffer = StringBuffer();
    var response = await chat.sendMessage(Content.text(prompt));

    while (true) {
      // Append the response text to the buffer.
      buffer.write(response.text ?? '');

      // If no function calls were collected, we're done
      if (response.functionCalls.isEmpty) break;

      // Append a newline to separate responses.
      buffer.write('\n');

      // Execute all function calls
      final functionResponses = <FunctionResponse>[];
      for (final functionCall in response.functionCalls) {
        try {
          functionResponses.add(
            FunctionResponse(
              functionCall.name,
              await onFunctionCall(functionCall),
            ),
          );
        } catch (ex) {
          functionResponses.add(
            FunctionResponse(functionCall.name, {'error': ex.toString()}),
          );
        }
      }

      // Get the next response stream with function results
      response = await chat.sendMessage(
        Content.functionResponses(functionResponses),
      );
    }

    return buffer.toString();
  }
}
```

Esse método recebe um prompt e um callback para tratar as chamadas de ferramentas específicas,
que o exemplo usa para tratar a função de busca de palavras:

```dart
await _clueSolverModel.generateContentWithFunctions(
  prompt: getSolverPrompt(clue, length, pattern),
  onFunctionCall: (functionCall) async => switch (functionCall.name) {
    'getWordMetadata' => await _getWordMetadataFromApi(
      functionCall.args['word'] as String,
    ),
    _ => throw Exception('Unknown function call: ${functionCall.name}'),
  },
);
```

A saída estruturada torna um LLM útil para programar, mas são as ferramentas que
transformam um LLM em um "agente" (mais sobre isso na seção Modo de interação).

### Saída estruturada e chamadas de ferramentas {:#structured-output-and-tool-calls}

Combinar saída estruturada e chamadas de ferramentas produz uma combinação poderosa. No
exemplo, o resolvedor de pistas tem uma ferramenta para buscar detalhes de palavras. Ele também é
solicitado a retornar um JSON que reúne a solução com uma pontuação de confiança, ambas
exibidas na lista de tarefas do app:

<img
src="/assets/images/docs/ai-best-practices/app-task-list-showing-crossword-clues-fo.png"
alt="Lista de tarefas do app mostrando pistas de palavras cruzadas seguidas de respostas
em negrito e pontuações de confiança entre parênteses">

Infelizmente, até a redação deste texto, combinar saída estruturada e funções
ao usar o SDK Firebase AI Logic gera uma exceção:

```plaintext
Function calling with a response mime type: 'application/json' is unsupported
```

Como uma solução alternativa (esperamos que temporária) para esse problema, o exemplo remove
a configuração de saída estruturada e, em vez disso, usa uma ferramenta chamada `returnResult` para
simular a saída estruturada:

```dart
 // The model for solving clues.
_clueSolverModel = FirebaseAI.googleAI().generativeModel(
  model: 'gemini-2.5-flash',
  systemInstruction: Content.text(clueSolverSystemInstruction),
  tools: [
    Tool.functionDeclarations([
      ...,
      FunctionDeclaration(
        'returnResult',
        'Returns the final result of the clue solving process.',
        parameters: {
        'answer': Schema(
          SchemaType.string,
          description: 'The answer to the clue.',
        ),
        'confidence': Schema(
          SchemaType.number,
          description: 'The confidence score in the answer from 0.0 to 1.0.',
          ),
        },
      ),
    ]),
  ],
);
```

O método `returnResult` também é mencionado na instrução de sistema:

````dart
static String get clueSolverSystemInstruction =>
    '''
You are an expert crossword puzzle solver.

...

### Tool: `returnResult`

You have a tool to return the final result of the clue solving process.

**When to use:**
- Use this tool when you have a final answer and confidence score to return. You
must use this tool exactly once, and only once, to return the final result.

**Function signature:**
```json
${jsonEncode(_returnResultFunction.toJson())}
```
''';
````

Quando o modelo chama `returnResult`, o exemplo armazena o resultado em cache, que o
`solveClue` consulta depois de chamar `generateContentWithFunctions`:

```dart
// Buffer for the result of the clue solving process.
final _returnResult = <String, dynamic>{};

// Cache the return result of the clue solving process via a function call.
// This is how we get JSON responses from the model with functions, since the
// model cannot return JSON directly when tools are used.
Map<String, dynamic> _cacheReturnResult(Map<String, dynamic> returnResult) {
  assert(_returnResult.isEmpty);
  _returnResult.addAll(returnResult);
  return {'status': 'success'};
}

Future<ClueAnswer?> solveClue(Clue clue, int length, String pattern) async {
  // Clear the return result cache; this is where the result will be stored.
  _returnResult.clear();

  // Generate JSON response with functions and schema.
  await _clueSolverModel.generateContentWithFunctions(
    prompt: getSolverPrompt(clue, length, pattern),
    onFunctionCall: (functionCall) async => switch (functionCall.name) {
      'getWordMetadata' => ...,
      'returnResult' => _cacheReturnResult(functionCall.args),
      _ => throw Exception('Unknown function call: ${functionCall.name}'),
    },
  );

  // Use the structured output that the LLM has called function with
  assert(_returnResult.isNotEmpty);
  return ClueAnswer(
    answer: _returnResult['answer'] as String,
    confidence: (_returnResult['confidence'] as num).toDouble(),
  );
}
```

Precisamos nos esforçar um pouco mais para obter a combinação de saída estruturada e
chamadas de ferramentas usando o Firebase AI Logic, mas os resultados valem a pena!

### Humano no loop {:#human-in-the-loop}

Até agora, vimos ferramentas sendo usadas para coletar dados e formatar a saída. Também
podemos usá-las para envolver uma pessoa.

Por exemplo, às vezes, quando o exemplo passa um padrão que a solução
deve seguir – como "_R_Y" – o modelo quer sugerir uma resposta que não se
encaixa nesse padrão – como "RENT". Um conflito como esse é um bom momento para pedir
ajuda ao usuário:  
<img
src="/assets/images/docs/ai-best-practices/crossword-companion-app-displaying-a-con.png"
alt="App Crossword Companion exibindo uma caixa de diálogo Conflito detectado pedindo
a entrada do usuário para resolver um padrão de pista">  
Isso se chama colocar o "humano no loop" e é mais uma forma de
humanos e LLMs colaborarem. O Flutter e o SDK Firebase AI Logic tornam isso
fácil de fazer. Primeiro, o exemplo define uma função e configura o modelo:

````dart

// The new function to let the LLM resolve solution conflicts
static final _resolveConflictFunction = FunctionDeclaration(
  'resolveConflict',
  'Asks the user to resolve a conflict between the letter pattern and the '
  'proposed answer. Use this BEFORE calling returnResult if the answer you '
  'want to propose does not match the letter pattern.',
  parameters: {
    'proposedAnswer': Schema(
      SchemaType.string,
      description: 'The answer the LLM wants to suggest.',
    ),
    'pattern': Schema(
      SchemaType.string,
      description: 'The current letter pattern from the grid.',
    ),
    'clue': Schema(SchemaType.string, description: 'The clue text.'),
  },
);

// Pass the new tool to the model for solving clues.
final _clueSolverModel = FirebaseAI.googleAI().generativeModel(
  model: 'gemini-2.5-flash',
  systemInstruction: Content.text(clueSolverSystemInstruction),
  tools: [
    Tool.functionDeclarations([
      ...
      _resolveConflictFunction,
    ]),
  ],
);
// Let the LLM know that it has a new tool.
static String get clueSolverSystemInstruction =>
    '''
You are an expert crossword puzzle solver.

...

### Tool: `resolveConflict`

You have a tool to ask the user to resolve a conflict.

**When to use:**
- Use this tool **BEFORE** `returnResult` if your proposed answer conflicts with the provided letter pattern.
- For example, if the pattern is `_ R _ Y` and you want to suggest `RENT` (which fits the clue), there is a conflict at the second letter (`R` vs `E`). You should call `resolveConflict(proposedAnswer: "RENT", pattern: "_ R _ Y", clue: "...")`.
- The tool will return the user's decision (either your proposed answer or a new one). You should then use that result to call `returnResult`.

**Function signature:**
```json
${jsonEncode(_resolveConflictFunction.toJson())}
```
''';
````

Agora, quando o modelo vê um conflito, ele chama a ferramenta:

```dart
// handle the LLM's request to resolve the conflict
await _clueSolverModel.generateContentWithFunctions(
  prompt: getSolverPrompt(clue, length, pattern),
  onFunctionCall: (functionCall) async => switch (functionCall.name) {
    ...
    'resolveConflict' => await _handleResolveConflict(
      functionCall.args,
      onConflict,
    ),
  },
);

// Show the dialog to gather the user's input
Future<Map<String, dynamic>> _handleResolveConflict(
  Map<String, dynamic> args,
  Future<String> Function(String clue, String proposedAnswer, String pattern)?
  onConflict,
) async {
  final proposedAnswer = args['proposedAnswer'] as String;
  final pattern = args['pattern'] as String;
  final clue = args['clue'] as String;

  if (onConflict != null) {
    final result = await onConflict(clue, proposedAnswer, pattern);
    return {'result': result};
  }

  return {'result': proposedAnswer};
}
```

O exemplo trata a ferramenta com uma implementação do método `onConflict`, que
chama `showDialog` para coletar dados do usuário. Tudo isso acontece no
meio do loop agêntico, mas tudo bem – o modelo não está esperando; ele
já enviou sua resposta à requisição inicial do app. O usuário pode
levar o tempo que precisar com a UI enquanto o exemplo aguarda o `Future` retornado
pelo `showDialog`. Quando terminar, o modelo continua de onde parou, usando o
histórico de mensagens e a requisição mais recente, que neste caso são os
dados coletados interativamente do usuário.

Uma caixa de diálogo modal é uma forma simples de colocar o humano no loop, mas não é a
única maneira no Flutter de fazer isso. Se preferir, uma instância de [um
`Completer`][completer] permite definir algum estado no seu app que o coloca no modo
"coletando dados do usuário". Quando o app tiver os dados, ele pode chamar
`complete` no `Completer` e retomar o loop agêntico.

Ou, como você é o dono do loop agêntico, pode verificar se há uma chamada para uma função "especial"
que indica que você precisa coletar dados do usuário. Esse tipo de
função especial às vezes é chamado de "interrupção", e você "retoma" a
conversa com o modelo quando tiver os dados do usuário.

Lembre-se de que o LLM é sem estado. Ele não
está esperando por você, então você pode tratar o loop agêntico da forma que fizer mais sentido para
o seu app. Você pode voltar ao LLM com um histórico de mensagens atualizado e um novo
prompt a qualquer momento, seja depois de um minuto ou de um mês.



[dictionary-api]: https://dictionaryapi.dev/
[completer]: {{site.api}}/flutter/dart-async/Completer-class.html
