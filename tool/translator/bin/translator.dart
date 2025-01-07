import 'dart:io';
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

  final fileProcessor = FileProcessorImpl(
    TranslatorImp(),
    MarkdownProcessorImpl(),
  );

  final fileCleaner = FileCleanerImpl();

  if (args.useV2) {
    return await tools
        .ensureHeaderLinking(arguments.where((a) => a != '-v2').toList());
  }

  if (args.translateOneFile) {
    final file = _getFileFromArgs(arguments);

    if (!file.exists()) {
      print('File does not exist: ${file.path}');
      exit(1);
    }
    await fileProcessor.translateOne(
        file, args.translateGreater, TranslatorImp(), args.useSecond);

    return;
  }

  final directoryPath = arguments.first;
  final directory = Directory(directoryPath);
  if (!directory.existsSync()) {
    print('Directory does not exist: ${directory.path}');
    exit(1);
  }

  String extension = '.md'; // Valor padrão
  final extensionArgIndex = arguments.indexOf('-e');
  if (extensionArgIndex != -1 && extensionArgIndex + 1 < arguments.length) {
    extension = '.${arguments[extensionArgIndex + 1]}';
    print('Nova extension: $extension');
  }

  if (args.collectLinks) {
    final allFiles =
        await DirectoryProcessorImpl().collectAllFiles(directory, extension);
    List<String> matches = [];
    for (var file in allFiles) {
      final m = await LinkProcessorImpl().collectAllAnchors(file);
      matches.addAll(m);
    }

    final outputFile = File('./matches_encontrados.txt');

    matches.sort((a, b) => b.length.compareTo(a.length));

    final excluded = Set.from(matches).toList();

    await outputFile.writeAsString(excluded.join('\n'), mode: FileMode.write);

    print('Matches encontrados e salvos em ${outputFile.path}');
    print('Finalizado collectAllAnchors');

    return;
  }

  if (args.showInfo) {
    await printDirectoryInfo(directory, kMaxKbSize, extension);
    exit(0); // Finalizar após mostrar as informações
  }

  // Checando se o parâmetro -l foi passado
  if (arguments.contains('-l')) {
    await LinkProcessorImpl().replaceLinksInAllFiles(directory, extension);
    return;
  }

  if (args.cleanMarkdown) {
    final all = await fileCleaner.collectFilesToClean(directory, extension);
    for (var i = 0; i < all.length; i++) {
      final file = all[i];
      final content = await file.readAsString();
      final cleanedContent = FileCleanerImpl().ensureDontHaveMarkdown(content);
      // Escrever o conteúdo atualizado no arquivo
      await file.writeAsString(cleanedContent);
    }

    final singularOrPlural = all.isEmpty || all.length > 1 ? 'S' : '';
    print('🧹 ${all.length} ARQUIVO$singularOrPlural LIMPO$singularOrPlural');
    return;
  }

  final directoryProcessor = DirectoryProcessorImpl();
  final filesToTranslate = await directoryProcessor.collectFilesToTranslate(
    directory,
    kMaxKbSize,
    args.translateGreater,
    extension,
  );

  final stopwatchTotal = Stopwatch()..start();

  int fileCount = await fileProcessor.translateFiles(
    filesToTranslate,
    args.translateGreater,
    useSecond: args.useSecond,
  );

  stopwatchTotal.stop();

  final durationIsSeconds = stopwatchTotal.elapsed.inSeconds;
  print('\n📔 Resumo da Tradução:');
  print('---------------------');
  print('Total de arquivos traduzidos: $fileCount');
  print('Tempo total de tradução: $durationIsSeconds segundos');
  print('Tradução concluída para o diretório: ${directory.path}');
}

FileWrapper _getFileFromArgs(List<String> arguments) {
  final fileArgIndex = arguments.indexOf('-f');
  final filePath = arguments[fileArgIndex + 1];
  final file = FileWrapper(filePath);
  return file;
}

Future<void> printDirectoryInfo(
    Directory directory, int maxKbSize, String extension) async {
  // Mostrar informações dos arquivos no diretório
  print('Listing files in directory: ${directory.path}');
  await for (var entity
      in directory.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith(extension)) {
      final fileSizeKB = (await entity.length()) / 1024;
      if (fileSizeKB > maxKbSize) {
        print(
            'File: ${entity.path}, Size: ${fileSizeKB.toStringAsFixed(2)} KB');
      }
    }
  }
}

void printHelp() {
  print('''
Uso: flutter-translate <diretório> [opções]

Opções:
  <diretório>           O diretório a ser processado (obrigatório)
  -h, --help            Exibe esta mensagem de ajuda
  --info                Exibe informações sobre o diretório e o tamanho dos arquivos
  -e <extensão>         Especifica a extensão dos arquivos a serem processados (padrão: .md)
  -g                    Processa arquivos maiores que 28KB
  -l                    Substitui todos os links nos arquivos Markdown
  -c                    Limpa os arquivos Markdown removendo tags específicas

Descrição:
Esta ferramenta de linha de comando traduz arquivos Markdown no diretório especificado.

Exemplos:
  flutter-translate /caminho/para/diretorio       # Traduz arquivos .md no diretório
  flutter-translate /caminho/para/diretorio --info # Exibe informações sobre os arquivos
  flutter-translate /caminho/para/diretorio -e .txt # Traduz arquivos .txt
  flutter-translate /caminho/para/diretorio -g     # Traduz apenas arquivos maiores que 28KB
  flutter-translate /caminho/para/diretorio -l     # Substitui links em todos os arquivos Markdown
  flutter-translate /caminho/para/diretorio -c     # Limpa arquivos Markdown

Notas:
  - Os arquivos serão processados apenas se contiverem a string 'ia-translate: true' em seus metadados.
  - Use a opção '-e' para especificar uma extensão de arquivo personalizada (o padrão é .md).
''');
}
