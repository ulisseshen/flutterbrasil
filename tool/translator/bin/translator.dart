import 'dart:io';
import 'package:translator/translator.dart'; // O pacote translator será usado

void main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('Usage: flutter-translate <directory> [--info]');
    exit(1);
  }

  final directoryPath = arguments.first;
  final directory = Directory(directoryPath);
  if (!directory.existsSync()) {
    print('Directory does not exist: ${directory.path}');
    exit(1);
  }

  final showInfo = arguments.contains('--info');

  if (showInfo) {
    // Mostrar informações dos arquivos no diretório
    print('Listing files in directory: $directoryPath');
    await for (var entity
        in directory.list(recursive: true, followLinks: false)) {
      if (entity is File && entity.path.endsWith('.md')) {
        final fileSizeKB = (await entity.length()) / 1024;
        if (fileSizeKB > 40) {
          print(
              'File: ${entity.path}, Size: ${fileSizeKB.toStringAsFixed(2)} KB');
        }
      }
    }
    exit(0); // Finalizar após mostrar as informações
  }

  int fileFoundCount = 0;
  int skippedCount = 0;
  int fileGreater = 0;
  const int limiteSizeFile = 40;

  // Contar os arquivos .md antes de começar a tradução
  await for (var entity
      in directory.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.md')) {
      final content = await entity.readAsString();

      if (content.contains('ia-translate: true')) {
        skippedCount++; // Incrementar contador de arquivos ignorados
        continue; // Ignorar este arquivo
      }

      // Verificar se o arquivo tem o header 'ia-translate: true'
      final fileSizeKB = (await entity.length()) / 1024;
      if (fileSizeKB > limiteSizeFile) {
        print('Skipping file > ${limiteSizeFile}KB: ${entity.path}');
        fileGreater++;
        continue;
      }

      fileFoundCount++;
    }
  }

  print('arquivos encontrado: ${skippedCount + fileFoundCount + fileGreater}');
  print('arquivos já traduzidos: $skippedCount');
  print('arquivos maior que ${limiteSizeFile}kb: $fileGreater');
  print('--- arquivos para traduzir: $fileFoundCount ---');
  final translator = Translator();

  final filesToTranslate = <File>[];
  int totalSizeKB = 0;
  // Contar arquivos e filtrar aqueles que devem ser traduzidos
  await for (var entity
      in directory.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.md')) {
      final content = await entity.readAsString();

      // Ignorar arquivos com `ia-translate: true`
      if (content.contains('ia-translate: true')) {
        print('Skipping file (ia-translate: true): ${entity.path}');
        continue;
      }

      // Ignorar arquivos maiores que 75 KB
      final fileSizeKB = (await entity.length()) / 1024;
      if (fileSizeKB > limiteSizeFile) {
        print('Skipping file > ${limiteSizeFile}KB: ${entity.path}');
        continue;
      }

      filesToTranslate.add(entity);
      totalSizeKB += fileSizeKB.round();
    }
  }

  int fileCount = 0;

  final stopwatchTotal = Stopwatch()..start();

  // Processar arquivos em lotes de 10
  const batchSize = 10;
  for (var i = 0; i < filesToTranslate.length; i += batchSize) {
    final batch = filesToTranslate.skip(i).take(batchSize).toList();

    final stopwatchBatch = Stopwatch()..start();

    try {
      // Executar as traduções em paralelo
      await Future.wait([
        ...batch.map((file) async {
          final fileSizeKB = (await file.length()) / 1024;
          print(
              'Processing file: ${file.path} (${fileSizeKB.toStringAsFixed(2)} KB)');
          final stopwatchFile = Stopwatch()..start();

          try {
            final content = await file.readAsString();
            final translated =
                await translator.translate(content, onFirstModelError: () {
              print(
                  'Erro no primeiro modelo: ${file.path} (${fileSizeKB.toStringAsFixed(2)} KB)');
              print('---');
            });

            final updatedContent = translated.replaceFirst(
              '---',
              '---\nia-translate: true',
            );
            await file.writeAsString(updatedContent);

            // Incrementar contador de arquivos finalizados
            fileCount++;
            print(
                '🚀 File $fileCount/${filesToTranslate.length} translated in ${stopwatchFile.elapsedMilliseconds} ms 🔥');
            print('Arquivo traduzido: ${file.path}');
            print('---');
          } catch (e) {
            print('❌ Error translating file ${file.path}: $e');
          } finally {
            stopwatchFile.stop();
          }
        }),
        Future.delayed(Duration(minutes: 1))
      ]);
    } catch (e) {
      print('❌ Error in batch processing: $e');
    } finally {
      print('Batch processed in ${stopwatchBatch.elapsedMilliseconds} ms');
      stopwatchBatch.stop();
    }
  }

  stopwatchTotal.stop();

  print('\n📔Translation Summary:');
  print('---------------------');
  print('Total files translated: $fileCount');
  print('Total size of files: ${totalSizeKB.toStringAsFixed(2)} KB');
  print('Total translation time: ${stopwatchTotal.elapsed.inSeconds} seconds');

  print('Translation completed for directory: ${directory.path}');
}
