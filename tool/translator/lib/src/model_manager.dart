import 'dart:io';

import 'model.dart';

class ModelManager {
  ModelManager();

  /// Método para obter o modelo de tradução
  TranslateModel getTranslateModel() {
    return TranslateModel(_fetchAPIKey());
  }

  /// Método para obter o modelo de link
  LinkModel getLinkModel() {
    return LinkModel(_fetchAPIKey());
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
