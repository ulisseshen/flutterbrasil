import 'package:google_generative_ai/google_generative_ai.dart';

abstract class GeminiModel {
  final String apiKey;
  final String model;
  final String systemInstruction;
  final GenerationConfig generationConfig;

  GeminiModel({
    required this.apiKey,
    required this.model,
    required this.systemInstruction,
    required this.generationConfig,
  });

  Future<String> getResponse(String text);
}

class TranslateModel extends GeminiModel {
  TranslateModel(String apiKey)
      : super(
          apiKey: apiKey,
          model: 'gemini-2.0-flash-exp', // Modelo específico para tradução
          systemInstruction:
              '''Traduza o seguinte texto técnico sobre desenvolvimento de aplicativos Flutter do inglês para o português brasileiro, mantendo a formatação, as quebras de linha originais e os recuos do documento. Identifique-os e trate cada tipo de formatação como cada um exige (HTML, YAML, Markdown, etc). Preserve a terminologia técnica no idioma original sempre que necessário para garantir clareza e precisão, especialmente termos como 'widget', 'bundle', 'asset', 'design patterns', 'SUT', 'flag' e outros termos técnicos específicos. Não traduza esses termos para o inglês. Certifique-se de que o texto traduzido seja fluido, claro e adequado para desenvolvedores brasileiros. Caso o texto contenha links ou referências ancoradas, traduza os textos de exibição (anchors) para o português somente quando necessário para manter a coerência do conteúdo, mas mantenha as URLs intactas no formato original. Não altere a estrutura ou os elementos específicos do documento, como cabeçalhos, listas e imagens.

O importante é manter o número de linhas equivalentes ao original, preservando a formatação do texto e os recuos.  O limite de largura dos blocos de texto deve ser ajustado para que a saída tenha a mesma quantidade de linhas do bloco de texto original.  Blocos de texto geralmente estão separados por quebras de linha vazias; mantenha essas linhas vazias.

Observe a quatidade de quebras de linhas para manter igual o original. Isso implica em deixar linhas curtas muitas vezse entre 50 e 120 chars, porém se atente soment ao número de linhas do bloco em tradução

Mantenha o contexto técnico preciso e a formatação original, evitando traduções literais que soem estranhas ou pouco naturais no português brasileiro, priorizando a fluidez e clareza.  Traduza termos técnicos apenas se houver equivalentes amplamente reconhecidos no Brasil, e forneça a primeira tradução entre parênteses para guiar o leitor. Omita termos como 'underlying' e semelhantes que são específicos do inglês e que podem ser omitidos em português sem alterar o sentido original.

Links devem ser mantidos funcionais e ancorados corretamente. Não traduza as referências dos links que ficam no rodapé ou logo após a seção adjacente.

Preste atenção a expressões idiomáticas que não possuem tradução direta; adapte o significado para se alinhar ao contexto brasileiro. Exemplos, como trechos de código e formatações de console, devem permanecer idênticos para evitar confusões no uso técnico. No caso de instruções, como comandos no terminal, mantenha o texto em inglês para não interferir no funcionamento, mas explique em português quando necessário.
''',
          generationConfig: GenerationConfig(
            temperature: 1,
            topK: 40,
            topP: 0.95,
            maxOutputTokens: 8192,
            responseMimeType: 'text/plain',
          ),
        );

  @override
  Future<String> getResponse(String text) async {
    final chat = startChat();
    final content = Content.text(text);
    final response = await chat.sendMessage(content);
    return response.text ?? '';
  }

  // Método para iniciar a conversa com o modelo (comunicação com o modelo Gemini)
  dynamic startChat() {
    return GenerativeModel(
      model: model,
      apiKey: apiKey,
      generationConfig: generationConfig,
      systemInstruction: Content.system(systemInstruction),
    ).startChat(history: []);
  }
}

class LinkModel extends GeminiModel {
  LinkModel(String apiKey)
      : super(
          apiKey: apiKey,
          model: 'gemini-2.0-flash-exp', // Modelo específico para links
          systemInstruction: '''
Cruzar as referências e links fornecidos para identificar correspondências entre textos em português e inglês. 
Retorne os resultados preenchendo os textos equivalentes encontrados no formato `[Texto em Português][Texto em Inglês]`. Para encontrar a referência traduza os textos em portugues ao fazer as comparações. Caso não encontre uma correspondência, ignore a referência.

**Formato de entrada:**  
- **Referências:** Lista de textos (as vezesportuguês).  
- **Links:** Lista de textos (em inglês ou português) associados a URLs.  

**Formato esperado de saída:**  
```json
[
{
before: [visão geral do Dart][]  
after: [visão geral do Dart][Dart overview]  
}
]
```

**Instruções para o cruzamento:**  
1. Compare semanticamente as references com os links para poder fazer o cruzamento corretamente. 
2. Preserve qualquer formatação especial, como crases (\`), itálico ou negrito.  
3. Inclua no resultado apenas as correspondências encontradas.  
4. Os textos que não tiverem correspondência devem ser ignorados.  

**Exemplo de entrada:**  
```plaintext
Referências:  
[visão geral do Dart][]  
[Flutter para desenvolvedores iOS][]  
[`dart fix`][]  

Links:  
[Dart overview.]: /resources/language/dart-overview  
[Flutter for iOS developers]: /resources/flutter-for-ios-developers  
[`dart fix`]: /resources/dart-fix  
```

**Exemplo de saída esperada:**  
```json
[
    {
        "before": "[visão geral do Dart][]",
        "after": "[visão geral do Dart][Dart overview.]"
    },
    {
        "before": "[Flutter para desenvolvedores iOS][]",
        "after": "[Flutter para desenvolvedores iOS][Flutter for iOS developers]"
    },
    {
        "before": "[`dart fix`][]",
        "after": "[`dart fix`][`dart fix`]"
    }
]
```
''',
          generationConfig: GenerationConfig(
            temperature: 1,
            topK: 40,
            topP: 0.95,
            maxOutputTokens: 8192,
            responseMimeType: 'application/json',
          ),
        );

  @override
  Future<String> getResponse(String text) async {
    final chat = startChat();
    final content = Content.text(text);
    final response = await chat.sendMessage(content);
    return response.text ?? '';
  }

  // Método para iniciar a conversa com o modelo (comunicação com o modelo Gemini)
  ChatSession startChat() {
    return GenerativeModel(
      model: model,
      apiKey: apiKey,
      generationConfig: generationConfig,
      systemInstruction: Content.system(systemInstruction),
    ).startChat(history: [
      Content.multi([
        TextPart(
            'input: references:\n[limitação de taxa do GitHub][]\n\nlinks:\n[GitHub rate limiting.]:\n[browser]:\n[chrome-cookies]:\n[new-issue]: '),
      ]),
      Content.model([
        TextPart(
            '```json\n[\n    {\n        "before": "[limitação de taxa do GitHub][]",\n        "after": "[limitação de taxa do GitHub][GitHub rate limiting.]"\n    }\n]\n```\n'),
      ]),
    ]);
  }
}
