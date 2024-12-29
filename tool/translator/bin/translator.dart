import 'dart:io';
import 'package:translator/markdown_spliter.dart';
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
    await printDirectoryInfo(directory, maxKbSize);
    exit(0);
  }

  final cleanMarkDown = arguments.contains('-c');

  if (cleanMarkDown) {
    final all = await collectFilesToclean(directory);
    for (var i = 0; i < all.length; i++) {
      final file = all[i];
      final content = await file.readAsString();
      final cleanedContent = ensureDontHaveMarkdown(content);
      // Escrever o conteúdo atualizado no arquivo
      await file.writeAsString(cleanedContent);
    }
    print('ARQUIVOS LIMPO');
    return;
  }

  final translateGreater = arguments.contains('-g');

  final filesToTranslate =
      await collectFiles(directory, maxKbSize, translateGreater);

  final stopwatchTotal = Stopwatch()..start();

  int fileCount = await translateFiles(filesToTranslate, translateGreater);

  stopwatchTotal.stop();

  print('\n📔Translation Summary:');
  print('---------------------');
  print('Total files translated: $fileCount');
  print('Total translation time: ${stopwatchTotal.elapsed.inSeconds} seconds');
  print('Translation completed for directory: ${directory.path}');
}

Future<int> translateFiles(
    List<File> filesToTranslate, bool processLargeFiles) async {
  int fileCount = 0;
  const batchSize = 10;
  final translator = Translator();

  for (var i = 0; i < filesToTranslate.length; i += batchSize) {
    final batch = filesToTranslate.skip(i).take(batchSize).toList();
    final stopwatchBatch = Stopwatch()..start();

    try {
      // Processar arquivos em paralelo
      await Future.wait([
        Future.delayed(Duration(minutes: batch.length == 10 ? 1 : 0)),
        ...batch.map((file) async {
          final stopwatchFile = Stopwatch()..start();
          try {
            final fileSizeKB = (await file.length()) / 1024;
            print(
                'Processing file: ${file.path} (${fileSizeKB.toStringAsFixed(2)} KB)');

            final content = await file.readAsString();
            List<String> parts;

            // Verificar se o arquivo é grande e precisa ser dividido
            if (processLargeFiles && fileSizeKB > 28) {
              print('Large file detected. Splitting: ${file.path}');
              final splitter = MarkdownSplitter(maxBytes: 28 * 1024);
              parts = splitter.splitMarkdown(content);
            } else {
              parts = [content];
            }

            final translatedParts = <String>[];

            for (var part in parts) {
              try {
                final translated = await translator.translate(
                  part,
                  onFirstModelError: () {
                    print(
                        'Erro no primeiro modelo ao traduzir parte do arquivo: ${file.path}');
                  },
                );
                translatedParts.add(translated);
              } catch (e) {
                print('❌ Error translating part of file ${file.path}: $e');
                translatedParts
                    .add(part); // Fallback para manter o conteúdo original
              }
            }

            // Concatenar as partes traduzidas e atualizar o arquivo original
            final updatedContent = translatedParts.join('').replaceFirst(
                  '---',
                  '---\nia-translate: true',
                );

            // Remover as marcações de markdown
            final cleanedContent = ensureDontHaveMarkdown(updatedContent);

            // Escrever o conteúdo atualizado no arquivo
            await file.writeAsString(cleanedContent);

            fileCount++;
            print(
                '🚀 File $fileCount/${filesToTranslate.length} translated in ${stopwatchFile.elapsedMilliseconds} ms 🔥');
          } catch (e) {
            print('❌❌ Error translating file ${file.path}: ❌❌ $e ');
          } finally {
            stopwatchFile.stop();
          }
        })
      ]);

      print('Batch processed in ${stopwatchBatch.elapsedMilliseconds} ms');
    } catch (e) {
      print('❌❌❌ Error in batch processing: ❌❌❌ $e');
    } finally {
      stopwatchBatch.stop();
    }
  }

  return fileCount;
}

Future<List<File>> collectFiles(
    Directory directory, int maxKbSize, bool greater) async {
  final filesToTranslate = <File>[];
  int skippedCount = 0;
  int fileGreater = 0;

  await for (var entity
      in directory.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.md')) {
      final content = await entity.readAsString();
      final fileSizeKB = (await entity.length()) / 1024;

      if (content.contains('ia-translate: true')) {
        skippedCount++;
        continue;
      }

      if (greater && fileSizeKB > maxKbSize) {
        filesToTranslate.add(entity);
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

  print(
      'arquivos encontrado: ${skippedCount + filesToTranslate.length + fileGreater}');
  print('arquivos já traduzidos: $skippedCount');
  print('arquivos maior que ${maxKbSize}kb: $fileGreater');
  print('--- arquivos para traduzir: ${filesToTranslate.length} ---');
  return filesToTranslate;
}

Future<void> printDirectoryInfo(Directory directory, int maxKbSize) async {
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

/// Remove as marcações ```markdown da primeira linha e ``` da última ou penúltima linha do conteúdo.
String ensureDontHaveMarkdown(String content) {
  // Dividir o conteúdo em linhas
  final lines = content.split('\n');

  // Remover ```markdown da primeira linha, se existir
  if (lines.isNotEmpty && hasMarwdown(lines.first)) {
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

Future<List<File>> collectFilesToclean(Directory directory) async {
  final filesToClean = <File>[];
  int skippedCount = 0;

  await for (var entity
      in directory.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.md')) {
      final content = await entity.readAsString();
      final lines = content.split('\n');
      if (lines.isNotEmpty && hasMarwdown(lines.first)) {
        filesToClean.add(entity);
      } else {
        skippedCount++;
      }
    }
  }

  print('jã limpos: $skippedCount');
  print('--- arquivos para limpar: ${filesToClean.length} ---');
  return filesToClean;
}

bool hasMarwdown(String line) =>
    (line.contains('```markdown') || line.contains('```'));
