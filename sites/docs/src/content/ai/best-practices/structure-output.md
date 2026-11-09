---
ia-translate: true
title: Estrutura e saída
description: >
  Aprenda a usar esquemas estruturados de entrada e saída para
  receber dados JSON confiáveis e analisáveis de um LLM.
prev:
  title: Prompting
  path: /ai/best-practices/prompting
next:
  title: Tool calls (aka function calls)
  path: /ai/best-practices/tool-calls
---


Quando você escreve programas que usam um LLM, quer fornecer uma entrada sem
ambiguidades e obter uma saída sem ambiguidades.

### Entrada estruturada {:#structured-input}

Como entrada, um LLM pode receber praticamente qualquer coisa que você consiga
renderizar como texto. Isso inclui texto livre e texto semiestruturado, como
Markdown, mas também formatos estruturados como CSV, JSON e XML. Se você tem
dados com estrutura, formate-os com essa estrutura e o LLM vai dar melhores
resultados.

Além de texto estruturado, você também pode enviar dados binários, como imagens
ou PDFs. No exemplo, o app envia as capturas de tela do quebra-cabeça de palavras
cruzadas para o Gemini, para que ele infira os dados da grade:

```dart
final imageParts = <Part>[];
for (final image in images) {
  final imageBytes = await image.readAsBytes();
  final mimeType = lookupMimeType(image.path, headerBytes: imageBytes)!;
  imageParts.add(InlineDataPart(mimeType, imageBytes));
}

final content = [
  Content.multi([
    TextPart(_crosswordPrompt),
    ...imageParts,
  ]),
];

final response = await _crosswordModel.generateContent(content);
...
```

Este código envia o prompt e as imagens para o Gemini na mesma
requisição.

### Saída estruturada {:#structured-output}

Um LLM pode ter mais dificuldade com saída estruturada do que com entrada
estruturada. Você precisa ser claro e detalhado ao pedir ao modelo uma saída
JSON, para garantir que receba algo que possa ser analisado de forma confiável
nos seus apps.

Comece inicializando a instância do modelo com o formato de saída esperado:

```dart
// the schema for the clue solver output
static final _crosswordSchema = Schema(
  SchemaType.object,
  properties: {
    'width': Schema(SchemaType.integer),
    'height': Schema(SchemaType.integer),
    'grid': Schema(
      SchemaType.array,
      items: Schema(
        SchemaType.array,
        items: Schema(
          SchemaType.object,
          properties: {
            'color': Schema(SchemaType.string),
            'clueNumber': Schema(SchemaType.integer, nullable: true),
          },
        ),
      ),
    ),
    'clues': Schema(
      SchemaType.object,
      properties: {
        'across': Schema(
          SchemaType.array,
          items: Schema(
            SchemaType.object,
            properties: {
              'number': Schema(SchemaType.integer),
              'text': Schema(SchemaType.string),
            },
          ),
        ),
        'down': Schema(
          SchemaType.array,
          items: Schema(
            SchemaType.object,
            properties: {
              'number': Schema(SchemaType.integer),
              'text': Schema(SchemaType.string),
            },
          ),
        ),
      },
    ),
  },
);

// The model for inferring crossword data from images.
_crosswordModel = FirebaseAI.googleAI().generativeModel(
  model: 'gemini-2.5-pro',
  generationConfig: GenerationConfig(
    responseMimeType: 'application/json',
    responseSchema: _crosswordSchema,
  ),
);
```

Embora isso possa ser suficiente, os resultados mais confiáveis surgem quando
você também especifica o esquema de saída na instrução do sistema:

```dart
final _crosswordPrompt =
'''
Analyze the following crossword puzzle images and return a JSON object
representing the grid size, contents, and clues. The images may contain
different parts of the same puzzle (e.g., the grid the across clues, the down
clues). Combine them to form a complete puzzle.

The JSON schema is as follows: ${jsonEncode(_crosswordSchema.toJson())}
'''
```

Agora você pode analisar a resposta de texto do modelo como JSON:

```dart
final response = await _crosswordModel.generateContent(content);

final json = jsonDecode(response.text!);
final width = json['width'] as int;
final height = json['height'] as int;
final gridData = json['grid'] as List;
final cluesData = json['clues'] as Map<String, dynamic>;
...
```

Uma saída JSON confiável do modelo é o que torna possível integrar IA ao seu
app. Os dados podem estar corretos ou não, mas virão em um formato com o qual
seu app consegue trabalhar.
