import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class Translator {
  /// Função de tradução que aceita texto e retorna o texto traduzido
  Future<String> translate(String text,{ required Function onFirstModelError}) async {
    ensureAPIKeyExists();

    try {
      return await getResponse('gemini-2.0-flash-exp', text);
    } catch (e) {
      print('🍀 Erro com flash-exp, tentando com exp-1206 🚫');
      onFirstModelError();
      return await getResponse('gemini-exp-1206', text);
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
          Quando for texto limitar a largura que o texto tiver, que é aproximadamente 80. 
          É um texto provindo de uma arquivo .md da plataforma jekyll.
          Preserve a terminologia técnica no idioma original sempre que necessário para garantir clareza e precisão.  
          Nâo traduzir parao ingles os termos a seguir, pois são técnicos e recogniciveis: "design patterns".
          Certifique-se de que o texto traduzido seja fluido, claro e adequado para desenvolvedores brasileiros.
          Sempre que texto contenha links ou referências ancoradas, traduza os textos de exibição (anchors) para o português,
          mas mantenha as URLs intactas no formato original. Não altere a estrutura ou os elementos específicos do Markdown, como cabeçalhos, listas e imagens.'''),
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
