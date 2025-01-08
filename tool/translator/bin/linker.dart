import 'dart:io';
import 'package:translator/linker_model.dart';
import 'package:translator/src/model_manager.dart';

import 'src/app.dart';

void main(List<String> arguments) async {
  final args = AppArguments.parse(arguments);

  if (args.showHelp) {
    args.printHelp();
    exit(0);
  }
  final linker = LinkerProcessor(LinkerImp(ModelManager(ModelType.linker)));

  final multipleFiles = args.multipleFilePaths;
  if (multipleFiles != null && multipleFiles.isNotEmpty) {
    int totalLinks = 0;
    int totalReferences = 0;
    int totalLinksReplaced = 0;

    final filteredFiles = multipleFiles.where((filePath) {
      final file = File(filePath);
      final content = file
          .readAsStringSync(); // Usa readAsStringSync para evitar await aqui
      final references = LinkerProcessor.getReferences(content);
      return references
          .isNotEmpty; // Filtra arquivos com referências não vazias
    }).toList();

    print(
        'Alguns arquivos já estão ok: ${filteredFiles.length - multipleFiles.length}');

    final batches = _splitIntoBatches(filteredFiles, 10);

    for (final batch in batches) {
      // Processar arquivos do batch atual
      await Future.wait([
        ...batch.map((filePath) async {
          final file = FileWrapper(filePath);
          final content = await file.readAsString();

          final links = LinkerProcessor.getLinks(content);
          final references = LinkerProcessor.getReferences(content);

          if (references.isEmpty) {
            print('>>> esse não precisa ${Utils.getFileName(file)}');
            return;
          }
          print('🔍 Processando arquivo: $filePath');
          print('  - Total de links encontrados: ${links.length}');
          print('  - Total de referências encontradas: ${references.length}');

          final processed = await linker.processFile(file);
          final linksReplacedInFile = links
              .where(
                (link) => processed.contains(link),
              )
              .length;

          // Salvar o conteúdo processado no arquivo
          await file.writeAsString(processed);

          // Retornar estatísticas do arquivo

          totalLinks += links.length;
          totalReferences += references.length;
          totalLinksReplaced += linksReplacedInFile;
        }),
        Future.delayed(Duration(minutes: batch.length == 10 ? 1 : 0))
      ]);
    }

    // Exibir sumário geral
    print('\n📊 Sumário Geral:');
    print('  - Total de arquivos processados: ${multipleFiles.length}');
    print('  - Total de links encontrados: $totalLinks');
    print('  - Total de referências encontradas: $totalReferences');
    print('  - Total de links substituídos: $totalLinksReplaced');
  } else {
    final filePath = args.filePath;
    final file = FileWrapper(filePath!);
    final processed = await linker.processFile(file);
    await file.writeAsString(processed);
  }
}

List<List<T>> _splitIntoBatches<T>(List<T> list, int batchSize) {
  final batches = <List<T>>[];
  for (var i = 0; i < list.length; i += batchSize) {
    batches.add(list.sublist(
        i, i + batchSize > list.length ? list.length : i + batchSize));
  }
  return batches;
}
