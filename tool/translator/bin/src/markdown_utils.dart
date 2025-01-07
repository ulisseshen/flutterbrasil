class MarkdownUtils {
   static bool hasMarwdown(String line) =>
    (line.contains('```markdown') || line.contains('```'));
}