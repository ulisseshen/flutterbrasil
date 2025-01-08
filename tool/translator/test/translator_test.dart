// import 'dart:io';
// import 'package:test/test.dart';
// import 'package:translator/translator.dart'; // Importando o pacote de tradução (assumido como parte do seu código)
// import '../bin/translator.dart';

// void main() {
//   group('Testes de Tradução', () {
//     test('Deve traduzir arquivos pequenos com sucesso', () async {
//       final file = await createTestFile('small_file.md', 'This is a test content');
//       final translatedFile = await translateFiles([file], false);

//       // Verifique se o arquivo foi traduzido e o conteúdo foi alterado
//       final content = await file.readAsString();
//       expect(content, contains('translated: This is a test content'));
//     });

//     test('Deve dividir arquivos grandes e traduzir', () async {
//       final longContent = 'a' * 30 * 1024; // 30KB, maior que kMaxKbSize
//       final file = await createTestFile('large_file.md', longContent);

//       final translatedFile = await translateFiles([file], true);

//       // Verifique se o conteúdo do arquivo foi traduzido
//       final content = await file.readAsString();
//       expect(content, contains('translated: aaaaaaaaaaaaaaaaaaaaaaaaaaaaa'));
//     });

//     test('Deve coletar todos os arquivos Markdown para tradução', () async {
//       final dir = Directory('test_dir');
//       await dir.create();
//       final smallFile = await createTestFile('test_dir/small_file.md', 'Test content');
//       final largeFile = await createTestFile('test_dir/large_file.md', 'a' * 30 * 1024);

//       final filesToTranslate = await collectFiles(dir, 28, false, '.md');
//       expect(filesToTranslate, hasLength(2)); // Verifica se encontrou os dois arquivos
//     });

//     test('Deve limpar os arquivos com marcações Markdown', () async {
//       final file = await createTestFile('file_with_markdown.md', '''
// \`\`\`markdown
// Content with markdown syntax
// \`\`\`
// ''');

//       final cleanedContent = ensureDontHaveMarkdown(await file.readAsString());
//       expect(cleanedContent, isNot(contains('```markdown'))); // Verifica se a marcação foi removida
//     });

//     test('Deve substituir links corretamente no conteúdo', () async {
//       final file = await createTestFile('file_with_links.md', '[text][]');

//       final transformedContent = transformLinks(await file.readAsString());
//       expect(transformedContent, equals('[text][text]')); // Verifica a substituição do link
//     });
//   });

//   group('Testes de Coleta de Links', () {
//     test('Deve coletar ancoragens corretamente de um arquivo', () async {
//       final file = await createTestFile('file_with_anchors.md', '''
// #anchor1
// Some text here

// #anchor2
// Another section
// ''');

//       final anchors = await collectAllAnchors(file);
//       expect(anchors, contains('#anchor1'));
//       expect(anchors, contains('#anchor2'));
//     });
//   });

//   group('Testes de Substituição de Links', () {
//     test('Deve substituir todos os links em um arquivo', () async {
//       final file = await createTestFile('file_with_links.md', '''
// [text1][]
// [text2][]
// ''');

//       await replaceLinkAtFile(file);

//       final content = await file.readAsString();
//       expect(content, contains('[text1][text1]'));
//       expect(content, contains('[text2][text2]'));
//     });
//   });
// }

// Future<File> createTestFile(String path, String content) async {
//   final file = File(path);
//   if (await file.exists()) {
//     await file.delete();
//   }
//   await file.create(recursive: true);
//   await file.writeAsString(content);
//   return file;
// }
