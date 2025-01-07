import 'package:test/test.dart';
import 'package:translator/linker_model.dart';
import 'package:translator/src/model_manager.dart';

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
      final updatedText = LinkerImp(ModelManager()).reconciliate(originalText, jsonResponse);

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
      final updatedText = LinkerImp(ModelManager()).reconciliate(originalText, jsonResponse);

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
      final updatedText = LinkerImp(ModelManager()).reconciliate(originalText, jsonResponse);

      // Valida que o texto original permanece inalterado
      expect(updatedText, expectedText);
    });
  });
}
