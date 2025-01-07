import 'dart:io';

import 'app.dart';

class DirectoryProcessorImpl implements DirectoryProcessor {
  @override
  Future<List<IFileWrapper>> collectFilesToTranslate(
    Directory directory,
    int maxKbSize,
    bool translateLargeFiles,
    String extension,
  ) async {
    final filesToTranslate = <IFileWrapper>[];

    int skippedCount = 0;
    int fileGreater = 0;

    await for (var entity
        in directory.list(recursive: true, followLinks: false)) {
      if (entity is File && entity.path.endsWith(extension)) {
        final content = await entity.readAsString();
        final fileSizeKB = (await entity.length()) / 1024;

        if (content.contains('ia-translate: true')) {
          skippedCount++;
          continue;
        }

        if (translateLargeFiles && fileSizeKB > maxKbSize) {
          filesToTranslate.add(FileWrapper.fromFile(entity));
          continue;
        }

        if (fileSizeKB > maxKbSize) {
          print('🚧 Skipping greater file > ${maxKbSize}KB: ${entity.path}');
          fileGreater++;
          continue;
        }

        filesToTranslate.add(FileWrapper.fromFile(entity));
      }
    }

  final total = skippedCount + filesToTranslate.length + fileGreater;
  print('================= I N I C I A N D O =================');
  print('📂 Total de arquivos encontrados: $total');
  print('✅ Arquivos já traduzidos: $skippedCount');
  print('📏 Arquivos maiores que ${maxKbSize}KB: $fileGreater');
  print('📜 Arquivos para traduzir: ${filesToTranslate.length}');
  print('=====================================================');
    return filesToTranslate;
  }

  @override
  Future<void> displayDirectoryInfo(
      Directory directory, int maxKbSize, String extension) async {
    await for (var entity
        in directory.list(recursive: true, followLinks: false)) {
      if (entity is File && entity.path.endsWith(extension)) {
        final fileSizeKB = await entity.length() / 1024;
        if (fileSizeKB > maxKbSize) {
          print(
              'File: ${entity.path}, Size: ${fileSizeKB.toStringAsFixed(2)} KB');
        }
      }
    }
  }

  @override
  Future<List<IFileWrapper>> collectAllFiles(
    Directory directory,
    String extension,
  ) async {
    final allFiles = <IFileWrapper>[];
    int skippedCount = 0;

    await for (var entity
        in directory.list(recursive: true, followLinks: false)) {
      if (entity is File && entity.path.endsWith(extension)) {
        allFiles.add(FileWrapper.fromFile(entity));
      }
    }

    print('Arquivos: $skippedCount');
    return allFiles;
  }
}
