import 'package:translator/linker_model.dart';

import 'app.dart';

class LinkerProcessor {
  final LinkerModel linker;

  LinkerProcessor(this.linker);

  Future<String> processFile(IFileWrapper file) async {
    final content = await file.readAsString();

    final links = getLinks(content);
    final references = getReferences(content);

    print('🔍 Processando arquivo único: ${file.path}');
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
    // await file.writeAsString(processed);

    // Opcional: Salvar o arquivo processado
    return processed;
  }

  static void printSummary(
      IFileWrapper file, String response, int linksReplacedInFile) {
    print('📄 Sumário do processamento:');
    print('  - Arquivo: ${file.path}');
    print('  - Links substituídos: $linksReplacedInFile');
    print('  - Resposta do linker: $response');
  }

  // Métodos utilitários (getLinks e getReferences) devem ser implementados aqui
  static List<String> getLinks(String content) {
    final linkRegex = RegExp(r'(\[[^\]]+\]:)');
    final links = <String>[];
    for (final match in linkRegex.allMatches(content)) {
      final text = match.group(1)!;
      links.add(text);
    }
    return links;
  }

  static List<String> getReferences(String content) {
    final referenRegex = RegExp(r'(\[[^\]]+\]\[\])');
    final references = <String>[];
    for (final match in referenRegex.allMatches(content)) {
      final text = match.group(1)!;
      references.add(text);
    }
    return references;
  }
}
