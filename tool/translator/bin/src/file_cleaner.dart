import 'dart:io';
import 'app.dart';

class FileCleanerImpl implements FileCleaner {
  @override
  Future<List<FileWrapper>> collectFilesToClean(
      Directory directory, String extension) async {
    final filesToClean = <FileWrapper>[];
    int skippedCount = 0;

    await for (var entity
        in directory.list(recursive: true, followLinks: false)) {
      if (entity is File && entity.path.endsWith(extension)) {
        final content = await entity.readAsString();
        final lines = content.split('\n');
        if (lines.isNotEmpty && MarkdownUtils.hasMarwdown(lines.first)) {
          filesToClean.add(FileWrapper.fromFile(entity));
        } else {
          skippedCount++;
        }
      }
    }

    print('✅ Arquivos já limpos: $skippedCount');
    print('🗑️ Arquivos para limpar: ${filesToClean.length}');
    return filesToClean;
  }

  @override
  String ensureDontHaveMarkdown(String content) {
    // Dividir o conteúdo em linhas
    final lines = content.split('\n');

    // Remover ```markdown da primeira linha, se existir
    if (lines.isNotEmpty && MarkdownUtils.hasMarwdown(lines.first)) {
      lines.removeAt(0);
    }

    // Remover ``` da última linha, ou penúltima se a última for vazia
    if (lines.isNotEmpty) {
      final lastLineIndex = lines.length - 1;
      if (lines[lastLineIndex].trim().isEmpty) {
        // Se a última linha for vazia, verificar a penúltima
        if (lastLineIndex > 0 && lines[lastLineIndex - 1].contains('```')) {
          // lines[lastLineIndex - 1] =
          //     lines[lastLineIndex - 1].replaceFirst('```', '').trim();
          lines.removeAt(lastLineIndex - 1);
        }
      } else {
        // Se a última linha não for vazia, verificar a última linha
        if (lines[lastLineIndex].contains('```')) {
          // lines[lastLineIndex] =
          //     lines[lastLineIndex].replaceFirst('```', '').trim();
          lines.removeAt(lastLineIndex);
        }
      }
    }

    // Recriar o conteúdo com as linhas ajustadas
    return lines.join('\n');
  }
}
