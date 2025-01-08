import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:test/test.dart';
import 'package:translator/linker_model.dart';
import 'package:translator/src/model.dart';
import 'package:translator/src/model_manager.dart';

import '../bin/src/app.dart';

class LinkerModelStub implements LinkerModel {
  final String _stubbedResponse;

  LinkerModelStub(this._stubbedResponse);

  @override
  Future<String> linker(List<String> links, List<String> references) async {
    // Captura o contexto para verificação.
    return Future.value(_stubbedResponse);
  }

  @override
  String reconciliate(String originalText, String jsonResponse) {
    // TODO: implement reconciliate
    throw UnimplementedError();
  }
}

void main() {
  group('reconcileReferences', () {
    test('should replace all references correctly', () {
      // Texto original
      final originalText = '''
      Dart suporta [Variáveis][] e [Tipos built-in][]. Ele também tem suporte a [Strings][] e outros tipos.
      ''';

      // Mock do JSON de resposta
      final jsonResponse = '''
      [
        {"before": "[Variáveis][]", "after": "[Variáveis][Variables section]"},
        {"before": "[Tipos built-in][]", "after": "[Tipos built-in][Built-in types]"}
      ]
      ''';

      // Texto esperado
      final expectedText = '''
      Dart suporta [Variáveis][Variables section] e [Tipos built-in][Built-in types]. Ele também tem suporte a [Strings][] e outros tipos.
      ''';

      // Executa a função
      final updatedText =
          LinkerImp(ModelManager(ModelType.linker)).reconciliate(originalText, jsonResponse);

      // Valida o resultado
      expect(updatedText, expectedText);
    });

    test('should not modify text if no matches found', () {
      // Texto original
      final originalText = '''
      Dart suporta [Strings][] e outros tipos.
      ''';

      // Mock do JSON de resposta sem referências que correspondem
      final jsonResponse = '''
      [
        {"before": "[Variáveis][]", "after": "[Variáveis][Variables section]"},
        {"before": "[Tipos built-in][]", "after": "[Tipos built-in][Built-in types]"}
      ]
      ''';

      // Texto esperado (não modificado)
      final expectedText = originalText;

      // Executa a função
      final updatedText =
          LinkerImp(ModelManager(ModelType.linker)).reconciliate(originalText, jsonResponse);

      // Valida que o texto original permanece inalterado
      expect(updatedText, expectedText);
    });

    test('should handle empty jsonResponse gracefully', () {
      // Texto original
      final originalText = '''
      Dart suporta [Variáveis][] e [Tipos built-in][].
      ''';

      // Mock do JSON de resposta vazio
      final jsonResponse = '[]';

      // Texto esperado (não modificado)
      final expectedText = originalText;

      // Executa a função
      final updatedText =
          LinkerImp(ModelManager(ModelType.linker)).reconciliate(originalText, jsonResponse);

      // Valida que o texto original permanece inalterado
      expect(updatedText, expectedText);
    });

    test('should replace references with \\n correctly', () async {

      final file = FileWrapper('test/file.md');
      // final originalText = file;
      // Texto esperado
      final expectedText = '''
Flutter é um framework para construir aplicações multiplataforma que usa
a linguagem de programação Dart. Para entender algumas diferenças entre a
programação com Dart e a programação com Swift, consulte [Aprendendo Dart
como um Desenvolvedor Swift][Learning Dart as a Swift Developer] e [Concorrência Flutter para desenvolvedores
Swift][Flutter concurrency for Swift developers].

Para saber mais maneiras de gerenciar o estado, confira [Gerenciamento de
estado][State management].''';

      final linker = LinkerProcessor(LinkerImp(MockModelManager()));



      // Executa a função
      final updatedText = await linker.processFile(file);

      // Valida o resultado
      expect(updatedText, expectedText);
    });
  });
}


class MockModelManager extends ModelManager {
  MockModelManager() : super(ModelType.linker);

  @override
  GeminiModel getModel() {
    return MockLinkModel(
      apiKey: '',
      model: '',
      systemInstruction: '',
      generationConfig: GenerationConfig()
    );
  }

  @override
  TranslateModel getTranslateModel() {
    // Caso precise de um mock para TranslateModel, implemente semelhante ao LinkModel
    throw UnimplementedError();
  }
}

class MockLinkModel extends GeminiModel {
  MockLinkModel({required super.apiKey, required super.model, required super.systemInstruction, required super.generationConfig});

  @override
  Future<String> getResponse(String text) async {
    return '''
    [
      {
        "before": "[Aprendendo Dart\\ncomo um Desenvolvedor Swift][]",
        "after": "[Aprendendo Dart\\ncomo um Desenvolvedor Swift][Learning Dart as a Swift Developer]"
      },
      {
        "before": "[Concorrência Flutter para desenvolvedores\\nSwift][]",
        "after": "[Concorrência Flutter para desenvolvedores\\nSwift][Flutter concurrency for Swift developers]"
      },
      {
        "before": "[Gerenciamento de\\nestado][]",
        "after": "[Gerenciamento de\\nestado][State management]"
      }
    ]
    ''';
  }
}
