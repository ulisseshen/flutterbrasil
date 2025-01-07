import 'dart:io';

class MarkdownSplitter {
  final int maxBytes;
  final List<String> _partil = [];

  MarkdownSplitter({this.maxBytes = 20480}); // Tamanho padrão de 20 KB

  /// Divide o texto Markdown em partes respeitando os cabeçalhos ###.
  List<String> splitMarkdown(String content) {
    final List<String> sections =
        content.split(RegExp(r'(?=^### )', multiLine: true));

    String currentChunk = '';
    int currentSize = 0;

    for (final section in sections) {
      final sectionSize = section.codeUnits.length;

      if (currentSize + sectionSize > maxBytes && currentChunk.isNotEmpty) {
        _partil.add(currentChunk);
        currentChunk = '';
        currentSize = 0;
      }

      currentChunk += section;
      currentSize += sectionSize;
    }

    if (currentChunk.isNotEmpty) {
      _partil.add(currentChunk);
    }
    return _partil;
  }

  String getEnterily() {
    return _partil.join();
  }
}

void main() async {
  final filePath = './site.md';
  final file = File(filePath);

  if (!file.existsSync()) {
    print('Arquivo não encontrado: $filePath');
    exit(1);
  }

  final content = await file.readAsString();
  final splitter = MarkdownSplitter(maxBytes: 20480); // 20 KB

  final chunks = splitter.splitMarkdown(content);

  print('Divisão concluída: ${chunks.length} partes.');

  for (int i = 0; i < chunks.length; i++) {
    final outputFile = File('${filePath}_part_$i.md');
    await outputFile.writeAsString(chunks[i]);
    print('Parte $i salva em: ${outputFile.path}');
  }

  final full = File('${filePath}_full.md');
  full.writeAsString(splitter.getEnterily());
}
