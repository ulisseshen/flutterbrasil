import 'dart:io';
import 'app.dart';

class LinkProcessorImpl implements LinkProcessor {
  @override
  Future<List<String>> collectLinks(IFileWrapper file) async {
    final regex = RegExp(r'(?<!//.*)(#[a-z0-9\-\_]+)');
    final regex2 = RegExp(r'\((#[a-zA-Z\-\_]+)\)');
    final lines = await file.readAsLines();
    final matches = <String>[];

    for (var line in lines) {
      for (var match in regex.allMatches(line)) {
        matches.add(match.group(0)!);
      }
      for (var match in regex2.allMatches(line)) {
        matches.add(match.group(1)!);
      }
    }
    return matches;
  }

  Future<int> _replaceLinksInFile(IFileWrapper file) async {
    final content = await file.readAsString();
    int countLinks = 0;
    final transformedContent =
        content.replaceAllMapped(RegExp(r'(\[([^\[\]]+)\]\[\])'), (match) {
      countLinks++; // Contar cada substituição realizada
      String linkText = match.group(2) ?? '';
      return '[$linkText][$linkText]';
    });
    if (transformedContent != content) {
      await file.writeAsString(transformedContent);
      print('✅ Arquivo atualizado: ${file.path}');
    }
    return countLinks;
  }

  @override
  Future<List<String>> collectAllAnchors(IFileWrapper file) async {
    // Definir a regex para capturar os links desejados
    final regex = RegExp(r'(?<!//.*)(#[a-z0-9\-\_]+)');
    final regex2 = RegExp(r'\((#[a-zA-Z\-\_]+)\)');

    // Ler o arquivo linha por linha
    final lines = await file.readAsLines();

    // Lista para armazenar os matches encontrados
    List<String> matches = [];

    for (var line in lines) {
      // Procurar por todos os matches na linha
      final match = regex.allMatches(line);

      // Adicionar os matches encontrados à lista
      for (var m in match) {
        matches.add(m.group(0)!);
      }

      for (var m in regex2.allMatches(line)) {
        matches.add(m.group(1)!);
      }
    }

    // Salvar os matches em um novo arquivo, linha por linha
    // await outputFile.create();
    // final content = outputFile.readAsStringSync();
    // final filtered = matches.where((m) => !content.contains(m)).toList();
    return matches;
  }

  @override
  Future<void> replaceLinksInAllFiles(
    Directory directory,
    String extension,
  ) async {
    final allFiles =
        await DirectoryProcessorImpl().collectAllFiles(directory, extension);

    int fileCount = 0;
    int linksReplacedInFile = 0;

    for (var file in allFiles) {
      linksReplacedInFile += await _replaceLinksInFile(file);
      fileCount++;
    }

    print('\n📊 Estatísticas de Links Substituídos:');
    print('Arquivos modificados: $fileCount');
    print('Total de links substituídos: $linksReplacedInFile');
  }

  @override
  Future<void> replaceLinksInFile(IFileWrapper file) async {
    final linksReplacedInFile = await _replaceLinksInFile(file);
    print('\n📊 Estatísticas de Links Substituídos:');
    print('Arquivo modificado: ${Utils.getFileName(file)}');
    print('Total de links substituídos: $linksReplacedInFile');
  }
}
