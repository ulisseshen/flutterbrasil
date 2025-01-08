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
    // Obtém o modelo para o processo de link
    final model = modelManager.getModel();
    final response = await model.getResponse(input);
    return response;
  }

  @override
  String reconciliate(String originalText, String jsonResponse) {
    try {
      originalText = normalizeLineBreaks(originalText);
      final replacements = jsonDecode(jsonResponse) as List<dynamic>;

      // Itera sobre os itens e substitui cada referência
      for (final replacement in replacements) {
        String? before = replacement['before'] as String?;
        String? after = replacement['after'] as String?;

        if (before == null || after == null) continue;

        if (!originalText.contains(before.trim())) {
          print("O before $before nâo foi encontrado no texto original");
        }
        originalText = originalText.replaceAll(before.trim(), after);
      }

      return originalText;
    } catch (e) {
      print(e);
      print('Result $jsonResponse');
      rethrow;
    }
  }

  String normalizeLineBreaks(String text) {
    return text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  }
}
