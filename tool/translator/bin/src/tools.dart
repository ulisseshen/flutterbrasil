
import 'dart:io';
import "package:path/path.dart" show dirname, join;

import 'app.dart';

Future<void> substitute(List<String> arguments) async {
  final directoryPath = arguments.first;
  final directory = Directory(directoryPath);
  if (!directory.existsSync() && !arguments.contains('-f')) {
    print('Directory does not exist: ${directory.path}');
    exit(1);
  }

  final files = await File(join(dirname(Platform.script.toFilePath()),'matches.txt')).readAsString();

  // Sua lista de traduções em formato de string separada por pipe


  // Convertendo a string para um mapa
  final translations = convertToMap(files);

  final replaceOneFile = arguments.contains('-f');

  if (replaceOneFile) {
    final fileArgIndex = arguments.indexOf('-f');
    final filePath = arguments[fileArgIndex + 1];
    final file = FileWrapper(filePath);

    if (!file.exists()) {
      print('File does not exist: $filePath');
      exit(1);
    }
    await replaceTextInFile(file, translations);
    print('Substituições concluídas!');
    return;
  }

  // Coletando todos os arquivos
  final allFiles = await DirectoryProcessorImpl() .collectAllFiles(
      directory, '.md'); // ou qualquer extensão que você preferir

  // Realizando a substituição em todos os arquivos
  for (var file in allFiles) {
    await replaceTextInFile(file, translations);
  }

  print('Substituições concluídas!');
}


// Função para realizar a substituição de textos no arquivo
Future<void> replaceTextInFile(
    IFileWrapper file, Map<String, String> translations) async {
  try {
    // Lendo o conteúdo do arquivo
    final content = await file.readAsString();

    // Substituindo as palavras
    var updatedContent = content;
    translations.forEach((left, right) {
      updatedContent = updatedContent.replaceAll(left, right);
    });

    // Gravando o conteúdo atualizado de volta no arquivo
    await file.writeAsString(updatedContent);

    print('Arquivo atualizado: ${file.path}');
  } catch (e) {
    print('Erro ao processar o arquivo ${file.path}: $e');
  }
}

// Função para converter a string de pares separados por pipe em um mapa
Map<String, String> convertToMap(String input) {
  final map = <String, String>{};
  final pairs = input.trim().split('\n');

  for (var pair in pairs) {
    final parts = pair.split('|');
    if (parts.length == 2) {
      map[parts[0].trim()] = parts[1].trim();
    }
  }

  return map;
}





Future<void> ensureHeaderLinking(List<String> arguments) async {
  final directoryPath = arguments.first;
  final directory = Directory(directoryPath);

  if (!directory.existsSync() && !arguments.contains('-f')) {
    print('Directory does not exist: ${directory.path}');
    exit(1);
  }

  final replaceOneFile = arguments.contains('-f');

  if (replaceOneFile) {
    final fileArgIndex = arguments.indexOf('-f');
    final filePath = arguments[fileArgIndex + 1];
    final file = FileWrapper(filePath);

    if (!file.exists()) {
      print('File does not exist: $filePath');
      exit(1);
    }
    await processMarkdownFile(file);
    print('Atualização concluída para o arquivo!');
    return;
  }

  // Coletando todos os arquivos .md
  final allFiles = await DirectoryProcessorImpl().collectAllFiles(directory, '.md');

  // Processando cada arquivo Markdown
  for (var file in allFiles) {
    await processMarkdownFile(file);
  }

  print('Atualização concluída para todos os arquivos!');
}

// Função para processar um arquivo Markdown
Future<void> processMarkdownFile(IFileWrapper file) async {
  try {
    // Lendo o conteúdo do arquivo
    final content = await file.readAsLines();

    final updatedContent = content.map((line) {
      if (line.startsWith('#')) {
        return processHeaderLine(line);
      }
      return line;
    }).toList();

    // Gravando o conteúdo atualizado de volta no arquivo
    await file.writeAsString(updatedContent.join('\n'));
    print('Arquivo processado: ${file.path}');
  } catch (e) {
    print('Erro ao processar o arquivo ${file.path}: $e');
  }
}

// Função para processar uma linha de cabeçalho
String processHeaderLine(String line) {
  final headerPattern = RegExp(r'^(#{1,6})\s+(.+?)(\s+\{.*\})?$');
  final match = headerPattern.firstMatch(line);

  if (match != null) {
    final hashes = match.group(1)!;
    final headerText = match.group(2)!;
    final existingAttributes = match.group(3) ?? '';

    // Verificar se já existe um link {:#...} nos atributos
    if (existingAttributes.contains(RegExp(r'\{:#'))) {
      return line; // Mantém a linha original
    }

    // Gerando o link automático baseado no texto do cabeçalho
    final generatedLink = headerText
        .toLowerCase()
        .replaceAll(RegExp(r"[^a-z0-9_']+"), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '')
        .replaceAll(RegExp(r"'"), '');

    // Preservando atributos existentes e adicionando o link
    final updatedAttributes = existingAttributes.isNotEmpty
        ? '$existingAttributes {:#$generatedLink}'
        : '{:#$generatedLink}';

    return '$hashes $headerText $updatedAttributes';
  }

  //TODO deve verificar se o header gerará um link duplicado, se sim evitar linkar

  //TODO existe uma linkagem deferente feito no arquivo glossary.md junto ocm glossary.yml
  // na documentação do DART

  return line; // Retorna a linha original se não for um cabeçalho
}