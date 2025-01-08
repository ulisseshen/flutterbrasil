import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

abstract class Translator {
  Future<String> translate(String text,
      {required Function onFirstModelError, bool useSecond = false});
}



class TranslatorImp implements Translator {


  final List<String> _models = [
    'gemini-2.0-flash-thinking-exp-1219',
    'gemini-2.0-flash-exp',
    'gemini-1.5-flash',
    'gemini-exp-1206'
  ];

  /// Função de tradução que aceita texto e retorna o texto traduzido
  @override
  Future<String> translate(String text,
      {required Function onFirstModelError, bool useSecond = false}) async {
    ensureAPIKeyExists();

    try {
      return await getResponse(useSecond ? _models.last : _models[1], text);
    } catch (e) {
      if (useSecond) rethrow;
      print('🍀 Erro com ${_models[1]}, tentando com ${_models.last} 🚫');
      print('🚫🚫 $e 🚫🚫');
      onFirstModelError();
      return await getResponse(_models.last, text);
    }
  }

  Future<String> getResponse(String modelType, String text) async {
    final model = getModel(modelType);

    final chat = model.startChat(history: []);

    final content = Content.text(text);

    final response = await chat.sendMessage(content);

    // Retorna o texto traduzido
    return response.text ?? '';
  }

  GenerativeModel getModel(String model) {
    final apiKey = Platform.environment['GEMINI_API_KEY']!;
    return GenerativeModel(
      model: model,
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
      systemInstruction: Content.system(
          '''Traduza o seguinte texto técnico sobre desenvolvimento de aplicativos Flutter do inglês para o português brasileiro, mantendo a formatação, as quebras de linha originais e os recuos do documento. Identifique-os e trate cada tipo de formatação como cada um exige (HTML, YAML, Markdown, etc). Preserve a terminologia técnica no idioma original sempre que necessário para garantir clareza e precisão, especialmente termos como 'widget', 'bundle', 'asset', 'design patterns', 'SUT', 'flag' e outros termos técnicos específicos. Não traduza esses termos para o inglês. Certifique-se de que o texto traduzido seja fluido, claro e adequado para desenvolvedores brasileiros. Caso o texto contenha links ou referências ancoradas, traduza os textos de exibição (anchors) para o português somente quando necessário para manter a coerência do conteúdo, mas mantenha as URLs intactas no formato original. Não altere a estrutura ou os elementos específicos do documento, como cabeçalhos, listas e imagens.

O importante é manter o número de linhas equivalentes ao original, preservando a formatação do texto e os recuos.  O limite de largura dos blocos de texto deve ser ajustado para que a saída tenha a mesma quantidade de linhas do bloco de texto original.  Blocos de texto geralmente estão separados por quebras de linha vazias; mantenha essas linhas vazias.

Observe a quatidade de quebras de linhas para manter igual o original. Isso implica em deixar linhas curtas muitas vezse entre 50 e 120 chars, porém se atente soment ao número de linhas do bloco em tradução

Mantenha o contexto técnico preciso e a formatação original, evitando traduções literais que soem estranhas ou pouco naturais no português brasileiro, priorizando a fluidez e clareza.  Traduza termos técnicos apenas se houver equivalentes amplamente reconhecidos no Brasil, e forneça a primeira tradução entre parênteses para guiar o leitor. Omita termos como 'underlying' e semelhantes que são específicos do inglês e que podem ser omitidos em português sem alterar o sentido original.

Links devem ser mantidos funcionais e ancorados corretamente. Não traduza as referências dos links que ficam no rodapé ou logo após a seção adjacente.

Preste atenção a expressões idiomáticas que não possuem tradução direta; adapte o significado para se alinhar ao contexto brasileiro. Exemplos, como trechos de código e formatações de console, devem permanecer idênticos para evitar confusões no uso técnico. No caso de instruções, como comandos no terminal, mantenha o texto em inglês para não interferir no funcionamento, mas explique em português quando necessário.
'''),
    );
  }

  void ensureAPIKeyExists() {
    final apiKey = Platform.environment['GEMINI_API_KEY'];
    if (apiKey == null) {
      stderr.writeln(r'No $GEMINI_API_KEY environment variable');
      exit(1);
    }
  }
}
