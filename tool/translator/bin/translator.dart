import 'dart:io';
import 'package:translator/translator.dart'; // O pacote translator será usado

void main(List<String> arguments) async {
  const int maxKbSize = 28;
  if (arguments.isEmpty) {
    print('Usage: flutter-translate <directory> [--info] [-g]');
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
    await printDirectoryInfo( directory, maxKbSize);
    exit(0);
  }

  final translateGreater = arguments.contains('-g');

  if (translateGreater){
    
  }
  
  final filesToTranslate = await collectFiles(directory, maxKbSize);

  final stopwatchTotal = Stopwatch()..start();

  int fileCount = await translateFIles(filesToTranslate);

  stopwatchTotal.stop();

  print('\n📔Translation Summary:');
  print('---------------------');
  print('Total files translated: $fileCount');
  print('Total translation time: ${stopwatchTotal.elapsed.inSeconds} seconds');
  print('Translation completed for directory: ${directory.path}');
}

Future<int> translateFIles(List<File> filesToTranslate) async {
   int fileCount = 0;
  const batchSize = 10;
  final translator = Translator();
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
  return fileCount;
}

Future<List<File>> collectFiles(Directory directory, int maxKbSize) async {
  final filesToTranslate = <File>[];
  int skippedCount = 0;
  int fileGreater = 0;

  await for (var entity in directory.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.md')) {
      final content = await entity.readAsString();
      final fileSizeKB = (await entity.length()) / 1024;

      if (content.contains('ia-translate: true')) {
        skippedCount++;
        continue;
      }
      if (fileSizeKB > maxKbSize) {
        print('Skipping file > ${maxKbSize}KB: ${entity.path}');
        fileGreater++;
        continue;
      }

      filesToTranslate.add(entity);
    }
  }

  print('arquivos encontrado: ${skippedCount + filesToTranslate.length + fileGreater}');
  print('arquivos já traduzidos: $skippedCount');
  print('arquivos maior que ${maxKbSize}kb: $fileGreater');
  print('--- arquivos para traduzir: ${filesToTranslate.length} ---');
  return filesToTranslate;
}

Future<void> printDirectoryInfo( Directory directory, int maxKbSize) async {
   // Mostrar informações dos arquivos no diretório
  print('Listing files in directory: ${directory.path}');
  await for (var entity
      in directory.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.md')) {
      final fileSizeKB = (await entity.length()) / 1024;
      if (fileSizeKB > maxKbSize) {
        print(
            'File: ${entity.path}, Size: ${fileSizeKB.toStringAsFixed(2)} KB');
      }
    }
  }
}
