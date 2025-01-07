import 'dart:convert';
import 'dart:io';
import 'package:translator/linker_model.dart';
import 'package:translator/src/model_manager.dart';
import 'package:translator/translator.dart'; // O pacote translator será usado

import 'src/tools.dart' as tools;
import 'src/config.dart';

import 'src/app.dart';

void main(List<String> arguments) async {
  final args = AppArguments.parse(arguments);

  if (args.showHelp) {
    args.printHelp();
    exit(0);
  }

  final multipleFiles = args.multipleFilePaths;
  if (multipleFiles != null && multipleFiles.isNotEmpty) {
    int totalLinks = 0;
    int totalReferences = 0;
    int totalLinksReplaced = 0;

    final filteredFiles = multipleFiles.where((filePath) {
      final file = File(filePath);
      final content = file
          .readAsStringSync(); // Usa readAsStringSync para evitar await aqui
      final references = getReferences(content);
      return references
          .isNotEmpty; // Filtra arquivos com referências não vazias
    }).toList();

    print('Alguns arquivos já estão ok: ${filteredFiles.length - multipleFiles.length}');

    final batches = _splitIntoBatches(filteredFiles, 10);

    for (final batch in batches) {
      // Processar arquivos do batch atual
      await Future.wait([
        ...batch.map((filePath) async {
          final file = FileWrapper(filePath);
          final content = await file.readAsString();

          final links = getLinks(content);
          final references = getReferences(content);

          if (references.isEmpty) {
            print('>>> esse não precisa ${Utils.getFileName(file)}');
            return;
          }

          final linker = LinkerImp(ModelManager());
          print('🔍 Processando arquivo: $filePath');
          print('  - Total de links encontrados: ${links.length}');
          print('  - Total de referências encontradas: ${references.length}');

          final response = await linker.linker(links, references);
          final processed = linker.reconciliate(content, response);

          final linksReplacedInFile = links
              .where(
                (link) => processed.contains(link),
              )
              .length;

          // Exibir sumário individual para o arquivo
          printSummary(file, response, linksReplacedInFile);

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
    // Processamento único para um arquivo (como antes)
    final file = FileWrapper(args.filePath!);
    final content = await file.readAsString();

    final links = getLinks(content);
    final references = getReferences(content);

    final linker = LinkerImp(ModelManager());
    print('🔍 Processando arquivo único: ${args.filePath}');
    print('  - Total de links encontrados: ${links.length}');
    print('  - Total de referências encontradas: ${references.length}');

    final response = await linker.linker(links, references);
    final processed = linker.reconciliate(content, response);

    final linksReplacedInFile = links
        .where(
          (link) => processed.contains(link),
        )
        .length;

    // Exibir sumário individual
    printSummary(file, response, linksReplacedInFile);

    // Salvar o conteúdo processado no arquivo
    await file.writeAsString(processed);
  }
}

List<String> getLinks(String content) {
  final linkRegex = RegExp(r'(\[[^\]]+\]:)');
  final links = <String>[];
  for (final match in linkRegex.allMatches(content)) {
    final text = match.group(1)!;
    links.add(text);
  }
  return links;
}

List<String> getReferences(String content) {
  final referenRegex = RegExp(r'(\[[^\]]+\]\[\])');
  final references = <String>[];
  for (final match in referenRegex.allMatches(content)) {
    final text = match.group(1)!;
    references.add(text);
  }
  return references;
}

void printSummary(
  FileWrapper file,
  String response,
  int totalReplacements,
) {
  print('\n📊 Estatísticas de Links Substituídos:');
  print('Arquivo processado: ${Utils.getFileName(file)}');
  print('Total de links substituídos: $totalReplacements');
  print(
      'Total de alterações geradas na resposta: ${response.split('\n').length}');
}

List<List<T>> _splitIntoBatches<T>(List<T> list, int batchSize) {
  final batches = <List<T>>[];
  for (var i = 0; i < list.length; i += batchSize) {
    batches.add(list.sublist(
        i, i + batchSize > list.length ? list.length : i + batchSize));
  }
  return batches;
}
