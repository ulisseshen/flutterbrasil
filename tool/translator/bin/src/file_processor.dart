import 'dart:io';

import 'package:translator/markdown_spliter.dart';
import 'package:translator/translator.dart';

import 'config.dart';
import 'app.dart';

class FileProcessorImpl implements FileProcessor {
  final Translator translator;
  final MarkdownProcessor markdownProcessor;

  FileProcessorImpl(this.translator, this.markdownProcessor);

  @override
  Future<String> readFile(IFileWrapper file) async {
    return await file.readAsString();
  }

  @override
  Future<void> writeFile(IFileWrapper file, String content) async {
    await file.writeAsString(content);
  }

  @override
  Future<void> translateOne(
    IFileWrapper file,
    bool processLargeFiles,
    Translator translator,
    bool useSecond,
  ) async {
    final fileSizeKB = (await file.length()) / 1024;

    //TODO mover para outro método
    // final swipeLink = arguments.contains('-l');

    // if (swipeLink) {
    //   int countLinks = await LinkProcessorImpl().replaceLinksInFile(file);
    //   print('\n📊 Estatísticas de Links Substituídos:');
    //   print('Total de links substituídos: $countLinks');
    //   return;
    // }

    // Verifica se deve traduzir arquivos grandes
    if (!processLargeFiles && fileSizeKB > kMaxKbSize) {
      print(
          'Skipping file > ${kMaxKbSize}KB. Use the -g flag to translate large files.');
      return;
    }

    print('🏁 Iniciando tradução: ${Utils.getFileName(file)} - ${fileSizeKB}KB');

    final stopwatchFile = Stopwatch()..start();
    try {
      final content = await file.readAsString();
      List<String> parts;

      if (processLargeFiles && fileSizeKB > kMaxKbSize) {
        print(
            '📜 Large file detected. ✂ Splitting: ${Utils.getFileName(file)}');
        final splitter = MarkdownSplitter(maxBytes: kMaxKbSize * 1024);
        parts = splitter.splitMarkdown(content);
      } else {
        parts = [content];
      }

      final translatedParts = <String>[];
      if (parts.length > 1) {
        print('⌛ - ${Utils.getFileName(file)} | partes: ${parts.length}');
      }
      for (int i = 0; i < parts.length; i++) {
        var part = parts[i];
        try {
          final translated = await translator.translate(
            part,
            onFirstModelError: () {
              print(
                  '🚨 Erro ao traduzir parte do arquivo:  ${Utils.getFileName(file)}');
            },
            useSecond: useSecond,
          );
          if (parts.length > 1) {
            print(
                '✍️ arquivo: ${Utils.getFileName(file)}, traduzido: ${i + 1}/${parts.length} 🔒');
          }
          translatedParts.add(translated);
        } catch (e) {
          print(
              '❌ Error translating part of file ${Utils.getFileName(file)}: $e');
          rethrow;
        }
      }

      // Concatenate translated parts and update the file
      final joinedParts = translatedParts.join('');
      String cleanedContent =
          FileCleanerImpl().ensureDontHaveMarkdown(joinedParts);

      String updatedContent;
      if (cleanedContent.contains('---')) {
        updatedContent = cleanedContent.replaceFirst(
          '---',
          '---\nia-translate: true',
        );
      } else {
        updatedContent = '<!-- ia-translate: true -->\n$cleanedContent';
      }

      await file.writeAsString(updatedContent);
      print(
          '✅🚀 File translated successfully: ${Utils.getFileName(file)}, em ${stopwatchFile.elapsedMilliseconds}ms 🔥🔥');
    } catch (e) {
      print('❌❌ Error translating file ${Utils.getFileName(file)}: ❌❌ $e');
    } finally {
      stopwatchFile.stop();
    }
  }

  @override
  Future<int> translateFiles(
    List<IFileWrapper> filesToTranslate,
    bool processLargeFiles, {
    bool useSecond = false,
  }) async {
    int fileCount = 0;
    const batchSize = 10;

    for (var i = 0; i < filesToTranslate.length; i += batchSize) {
      final batch = filesToTranslate.skip(i).take(batchSize).toList();
      final stopwatchBatch = Stopwatch()..start();

      try {
        // Processar arquivos em paralelo
        await Future.wait([
          Future.delayed(Duration(minutes: batch.length == 10 ? 1 : 0)),
          ...batch.map((file) async {
            await FileProcessorImpl(
              translator,
              MarkdownProcessorImpl(),
            ).translateOne(
              file,
              processLargeFiles,
              translator,
              useSecond,
            );
            fileCount++;
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
}
