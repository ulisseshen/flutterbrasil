import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class Translator {

  final List<String> _models = ['gemini-2.0-flash-thinking-exp-1219','gemini-2.0-flash-exp','gemini-exp-1206'];
  /// Função de tradução que aceita texto e retorna o texto traduzido
  Future<String> translate(String text,{ required Function onFirstModelError}) async {
    ensureAPIKeyExists();

    try {
      return await getResponse(_models[1], text);
    } catch (e) {
      print('🍀 Erro com ${_models[1]}, tentando com ${_models.last} 🚫');
      onFirstModelError();
      return await getResponse(_models.last, text);
    }
  }

  Future<String> getResponse(String modelType, String text) async {
    final model = getModel(modelType);

    // Prepara o conteúdo para envio
    final content = [Content.text(text)];
    final response = await model.generateContent(content);

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
          '''Traduza o seguinte texto técnico sobre desenvolvimento de aplicativos Flutter do inglês para o português brasileiro.
Mantenha a formatação e as quebras de linha o mais originais posssível.
Limite a largura do bloco de texto para condizer a quantidade de linhas do bloco de texto original em inglês ou limite em 80-100 caractes, o importante é ter o número de linhas equivalentes.
Traduza o texto fornecido para o português brasileiro, mantendo o contexto técnico preciso e preservando a formatação original em markdown (md).
Certifique-se de que termos técnicos como 'widget', 'bundle', 'asset' sejam traduzidos apenas se houver equivalentes amplamente reconhecidos no Brasil.
Omita 'underlying' e termos semelhantes que fazem sentidos apenas em inglês e que muitas vezes podem ser omitidos em português sem perder o sentido original.
Links devem ser mantidos funcionais e ancorados adequadamente. Por exemplo, [Flutter SDK][] deve permanecer no formato original.
Preste atenção a expressões idiomáticas que não possuem tradução direta; adapte o significado para se alinhar ao contexto brasileiro.
Evite traduções literais que soem estranhas ou pouco naturais no português brasileiro, priorizando fluidez e clareza.
Preserve quebras de linha e recuos, especialmente para listas, blocos de código, e dicas (:::tip).
No caso de instruções, como comandos no terminal, mantenha o texto em inglês para não interferir no funcionamento, mas explique em português quando necessário.
Exemplos, como trechos de código e formatações de console, devem permanecer idênticos para evitar confusões no uso técnico."'''),
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
