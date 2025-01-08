import 'package:translator/markdown_spliter.dart';
import 'app.dart';


class MarkdownProcessorImpl implements MarkdownProcessor {
  @override
  List<String> splitMarkdownContent(String content, {required int maxBytes}) {
    final splitter = MarkdownSplitter(maxBytes: maxBytes);
    return splitter.splitMarkdown(content);
  }

  @override
  String removeMarkdownSyntax(String content) {
    // Lógica para limpar o conteúdo Markdown
    final lines = content.split('\n');
    if (lines.isNotEmpty && lines.first.contains('```markdown')) {
      lines.removeAt(0);
    }
    return lines.join('\n');
  }
}
