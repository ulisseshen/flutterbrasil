import 'dart:convert';

import 'src/model_manager.dart';

abstract class LinkerModel {
  Future<String> linker(List<String> links, List<String> references);
  String reconciliate(String originalText, String jsonResponse);
}

class LinkerImp implements LinkerModel {
  final ModelManager modelManager;

  LinkerImp(this.modelManager);

  @override
  Future<String> linker(List<String> links, List<String> references) async {
    final input =
        'references:\n${references.join('\n')}\n\nlinks:\n${links.join('\n')}';
    print('input: $input');
    // Obtém o modelo para o processo de link
    final model = modelManager.getLinkModel();
    final response = await model.getResponse(input);
    print('Reponse: $response');
    return response;
  }

  @override
  String reconciliate(String originalText, String jsonResponse) {
    try {
      // Decodifica o JSON
      final replacements = jsonDecode(jsonResponse) as List<dynamic>;

      // Itera sobre os itens e substitui cada referência
      for (final replacement in replacements) {
        final before = replacement['before'] as String?;
        final after = replacement['after'] as String?;

        if (before == null || after == null) continue;
        originalText = originalText.replaceAll(before, after);
      }

      return originalText;
    } catch (e) {
      print(e);
      print('Result $jsonResponse');
      rethrow;
    }
  }
}
