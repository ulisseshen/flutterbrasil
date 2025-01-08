import 'dart:io';

import 'model.dart';

enum ModelType { translate, linker }

class ModelManager {
  final ModelType type;
  ModelManager(this.type);

  /// Método para obter o modelo de tradução
  TranslateModel getTranslateModel() {
    return TranslateModel(_fetchAPIKey());
  }

  /// Método para obter o modelo de link
  GeminiModel getModel() {
    if (type == ModelType.linker) {
      return LinkModel(_fetchAPIKey());
    }

    if (type == ModelType.translate) {
      return TranslateModel(_fetchAPIKey());
    }

    throw Exception("Model inválido");
  }

  String _fetchAPIKey() {
    final apiKey = Platform.environment['GEMINI_API_KEY'];
    if (apiKey == null) {
      stderr.writeln(r'No $GEMINI_API_KEY environment variable');
      exit(1);
    }
    return apiKey;
  }
}
