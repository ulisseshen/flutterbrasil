import 'dart:io';

import 'app.dart';

class Utils {
  static String getFileName(IFileWrapper file) {
    final parts = file.path.split(Platform.pathSeparator);

    // Se o arquivo estiver na raiz (não tiver subdiretórios), retornamos diretamente o nome
    if (parts.length == 1) {
      return parts.last;
    }

    final isNameIndex = parts.last.contains('index');
    if (isNameIndex) {
      return '${parts[parts.length - 2]}/${parts.last}';
    }
    return parts.last;
  }
}
