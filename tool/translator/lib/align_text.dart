import 'dart:io';
import "package:path/path.dart" show dirname, join;

void main(List<String> args) async {
  //pegar file site.md e site_pt.md
  final originalContent = File(
    join(dirname(Platform.script.toFilePath()), 'site.md'),
  ).readAsStringSync();
  final translatedContent =
      File(join(dirname(Platform.script.toFilePath()), 'site_pt.md'))
          .readAsStringSync();
  // e salve em test.md
  final alignText = AlignText();
  final alignedContent =
      await alignText.alignTranslation(originalContent, translatedContent);
  File(join(dirname(Platform.script.toFilePath()), 'test.md'))
      .writeAsStringSync(alignedContent);
}

class AlignText {
  Future<String> alignTranslation(
      String originalContent, String translatedContent) async {
    final originalBody = getBody(originalContent);
    final translatedBody = getBody(translatedContent);

    // cada lista é um bloco tambe;
    final originalBlocks = originalBody.split(RegExp(r'\r?\n\r?\n'));
    final translatedBlocks = translatedBody.split(RegExp(r'\r?\n\r?\n'));

    if (originalBlocks.length != translatedBlocks.length) {
      throw Exception('Número de blocos diferentes entre original e traduzido');
    }

    // Alinhar blocos traduzidos
    final alignedBlocks = <String>[];

    for (int i = 0; i < originalBlocks.length; i++) {
      final block = originalBlocks[i];
      final translatedBlock = translatedBlocks[i];
 
      if (block.startsWith('*')) {
        final newBlock = block.split(RegExp(r'\n(?=\*)'));
        final newTranslatedBlock = translatedBlock.split(RegExp(r'\n(?=\*)'));

        final temp = <String>[];
        for (int j = 0; j < newBlock.length; j++) {
          final listBlock = newBlock[j];
          final translatedListBlock = newTranslatedBlock[j];

          final translet = buildAlignedListBloc(listBlock, translatedListBlock);
          if (translet.isEmpty) {
            continue;
          }
          if (translet.length == 1) {
            temp.add(translet.first);
            continue;
          }
          temp.add(translet.join('\n'));
        }
        alignedBlocks.add(temp.join('\n'));
        continue;
      }

      List<String> newBlock = buildAlignedBlock(block, translatedBlock);

      alignedBlocks.add(newBlock.join('\n'));
    }

    // Combinar resultado com o front matter
    final frontMatter = getFrontMatter(translatedContent);
    final outputContent = '$frontMatter\n${alignedBlocks.join('\n\n')}';

    // Salvar em arquivo
    return outputContent;
  }

  List<String> buildAlignedListBloc(String block, String translatedBlock) {
      //this is a list bloc:
      //* **Welcome messages**: Display an initial greeting to users.
      //* **Suggested prompts**: Offer users predefined prompts to guide interactions.
      //* **System instructions**: Provide the LLM with specific input to influence its responses.
      //* **Managing history**: Every LLM provider allows for
      //  managing chat history,
      //  which is useful for clearing it,

      //pegar cada item da lista
      final originalLines = block.split('\n');
      final translatedLines = translatedBlock.split('\n');

      if (originalLines.length == translatedLines.length) {
        return translatedLines;
      }

      //pegar a quantidade de palavras de cada item da lista
      final alignedBlock = buildAlignedBlock(block, translatedBlock);

      //adicionat \t no inicio apartir do segundo
      return alignedBlock.fold(<String>[], (acc, line) {
        if (acc.isEmpty) {
          acc.add(line);
          return acc;
        }
        acc.add('  $line');
        return acc;
      });
      


  }

  List<String> buildAlignedBlock(String block, String translatedBlock) {
    final originalLines = block.split('\n').length;
    int wordIndex = 0;

    // Dividir em palavras \n e espaço
    final translatedWords = translatedBlock.split(RegExp(r'\s+'));
    final wordCount = translatedWords.length;

    // Pegar as palavras correspondentes no traduzido
    final wordsByLine = (wordCount / originalLines).ceil();

    //agora quero um novo bloco traduzido com a queantidad de palavras [wordsByLine]
    final newBlock = <String>[];
    for (int j = 0; j < originalLines; j++) {
      if (wordIndex >= translatedWords.length) {
        break;
      }
      //pegar as palavras de [wordIndex] até [wordIndex + wordsByLine]
      // sem estourar o range
      var end = wordIndex + wordsByLine;
      if (end > translatedWords.length) {
        end = translatedWords.length;
      }
      print(
          'wordIndex: $wordIndex, end: $end, wordsByLine: $wordsByLine, translatedWords.length: ${translatedWords.length}');
      final words = translatedWords.sublist(wordIndex, end);
      newBlock.add(words.join(' '));
      wordIndex += wordsByLine;
    }
    return newBlock;
  }

  String getBody(String content) {
    final frontMatterEndIndex = content.indexOf('---', 3);
    return content.substring(frontMatterEndIndex + 5).trim();
  }

  String getFrontMatter(String content) {
    final frontMatterEndIndex = content.indexOf('\n---\n', 3);
    return content.substring(0, frontMatterEndIndex + 5);
  }
}
