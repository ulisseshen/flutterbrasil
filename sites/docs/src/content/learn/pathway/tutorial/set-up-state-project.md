---
ia-translate: true
title: Configure seu projeto
description: Instruções sobre como criar um novo app Flutter.
layout: tutorial
---

Visualize o app leitor da Wikipedia que você vai construir e configure o projeto inicial com os pacotes necessários.

<SummaryCard>
title: O que você vai realizar
items:
  - title: Visualizar o app leitor da Wikipedia que você vai construir
    icon: preview
  - title: Adicionar pacotes para lidar com requisições HTTP e dados da Wikipedia
    icon: inventory_2
  - title: Configurar a estrutura inicial do projeto
    icon: code
</SummaryCard>

---

### Introdução {:#introduction}

Nas próximas lições, você aprenderá como trabalhar com dados em um app Flutter.
Você construirá um app que busca e exibe resumos de artigos da
[API da Wikipedia][Wikipedia API].

<img src="/assets/images/docs/tutorial/wikipedia_app.png" width="320px" height="500px"
style="border:1px solid black" alt="Uma captura de tela do app leitor
da Wikipedia completo mostrando um artigo com imagem, título,
descrição e texto de extrato.">

Estas lições exploram:

- Fazer requisições HTTP no Flutter.
- Gerenciar o estado da aplicação com `ChangeNotifier`.
- Usar o padrão de arquitetura MVVM.
- Criar interfaces de usuário responsivas que
  atualizam automaticamente quando os dados mudam.

Este tutorial assume que você completou os tutoriais
[Getting started with Dart][] e [Introduction to Flutter UI][],
e portanto não explica conceitos como HTTP, JSON ou fundamentos de widgets.

:::recommend Apoie a Wikipedia

A [Wikipedia][] é um recurso valioso, fornecendo acesso gratuito
ao conhecimento humano através de milhões de artigos escritos
colaborativamente por voluntários em todo o mundo.
Considere [doar para a Wikipedia][donating to Wikipedia] para ajudar a manter este recurso incrível
gratuito e acessível para todos.

:::

[Wikipedia API]: https://en.wikipedia.org/api/rest_v1/
[Getting started with Dart]: {{site.dart-site}}/learn/tutorial
[Introduction to Flutter UI]: /learn/pathway/tutorial/create-an-app
[Wikipedia]: https://wikipedia.org/
[donating to Wikipedia]: https://donate.wikimedia.org/

### Crie um novo projeto Flutter {:#create-a-new-flutter-project}

Crie um novo projeto Flutter usando a [Flutter CLI][Flutter CLI].
No seu terminal preferido, execute o seguinte comando para
criar um app Flutter mínimo:

```console
$ flutter create wikipedia_reader --empty
```

[Flutter CLI]: /reference/flutter-cli

### Adicione as dependências necessárias {:#add-required-dependencies}

Seu app precisa do [pacote `http`][`http` package] para fazer requisições HTTP,
e do [pacote `material_ui`][`material_ui` package] para alguns componentes de UI.
Adicione-os ao seu projeto:

```console
$ cd wikipedia_reader && flutter pub add http material_ui && flutter pub get
```

[`http` package]: {{site.pub}}/packages/http
[`material_ui` package]: {{site.pub}}/packages/material_ui

### Examine o código inicial {:#examine-the-starter-code}

Primeiro, crie um novo arquivo `lib/summary.dart` para definir o modelo de dados
dos resumos de artigos da Wikipedia. Este arquivo não tem nenhuma lógica especial e é
simplesmente uma coleção de classes que representam os dados retornados pela
API da Wikipedia. Basta copiar o código abaixo para o arquivo e depois ignorá-lo.
Se você não se sente confortável com classes Dart básicas, leia primeiro o tutorial [Dart Getting Started][].

<?code-excerpt "fwe/wikipedia_reader/lib/summary.dart (All)"?>
```dart title="lib/summary.dart" collapsed
/// Representation of the JSON data returned by the Wikipedia API.
class Summary {
  /// Returns a new [Summary] instance.
  Summary({
    required this.titles,
    required this.pageId,
    required this.extract,
    required this.extractHtml,
    required this.lang,
    required this.dir,
    required this.url,
    this.description,
    this.thumbnail,
    this.originalImage,
  });

  /// The title information of this article.
  final TitlesSet titles;

  /// The page ID of this article.
  final int pageId;

  /// The first few sentences of the article in plain text.
  final String extract;

  /// The first few sentences of the article in HTML format.
  final String extractHtml;

  /// The language code of the article's content, such as "en" for English.
  final String lang;

  /// The text directionality of the article's content, such as "ltr" or "rtl".
  final String dir;

  /// The URL of the page.
  final String url;

  /// A description of the article, if available.
  final String? description;

  /// A thumbnail-sized version of the article's primary image, if available.
  final ImageFile? thumbnail;

  /// The original full-sized article's primary image, if available.
  final ImageFile? originalImage;

  /// Whether this article has an image.
  bool get hasImage => originalImage != null && thumbnail != null;

  /// Returns a new [Summary] instance and imports its values from a JSON map
  static Summary fromJson(Map<String, Object?> json) {
    return switch (json) {
      {
        'titles': final Map<String, Object?> titles,
        'pageid': final int pageId,
        'extract': final String extract,
        'extract_html': final String extractHtml,
        'thumbnail': final Map<String, Object?> thumbnail,
        'originalimage': final Map<String, Object?> originalImage,
        'lang': final String lang,
        'dir': final String dir,
        'description': final String description,
        'content_urls': {
          'desktop': {'page': final String url},
          'mobile': {'page': String _},
        },
      } =>
        Summary(
          titles: TitlesSet.fromJson(titles),
          pageId: pageId,
          extract: extract,
          extractHtml: extractHtml,
          thumbnail: ImageFile.fromJson(thumbnail),
          originalImage: ImageFile.fromJson(originalImage),
          lang: lang,
          dir: dir,
          description: description,
          url: url,
        ),
      {
        'titles': final Map<String, Object?> titles,
        'pageid': final int pageId,
        'extract': final String extract,
        'extract_html': final String extractHtml,
        'lang': final String lang,
        'dir': final String dir,
        'description': final String description,
        'content_urls': {
          'desktop': {'page': final String url},
          'mobile': {'page': String _},
        },
      } =>
        Summary(
          titles: TitlesSet.fromJson(titles),
          pageId: pageId,
          extract: extract,
          extractHtml: extractHtml,
          lang: lang,
          dir: dir,
          description: description,
          url: url,
        ),
      {
        'titles': final Map<String, Object?> titles,
        'pageid': final int pageId,
        'extract': final String extract,
        'extract_html': final String extractHtml,
        'lang': final String lang,
        'dir': final String dir,
        'content_urls': {
          'desktop': {'page': final String url},
          'mobile': {'page': String _},
        },
      } =>
        Summary(
          titles: TitlesSet.fromJson(titles),
          pageId: pageId,
          extract: extract,
          extractHtml: extractHtml,
          lang: lang,
          dir: dir,
          url: url,
        ),
      _ => throw FormatException('Could not deserialize Summary, json=$json'),
    };
  }

  @override
  String toString() =>
      'Summary['
      'titles=$titles, '
      'pageId=$pageId, '
      'extract=$extract, '
      'extractHtml=$extractHtml, '
      'thumbnail=${thumbnail ?? 'null'}, '
      'originalImage=${originalImage ?? 'null'}, '
      'lang=$lang, '
      'dir=$dir, '
      'description=$description'
      ']';
}

// Image path and size, but doesn't contain any Wikipedia descriptions.
class ImageFile {
  /// Returns a new [ImageFile] instance.
  ImageFile({required this.source, required this.width, required this.height});

  /// The URI of the original image.
  final String source;

  /// The width of the original image.
  final int width;

  /// The height of the original image.
  final int height;

  /// The file extension of the image, or 'err' if one can't be determined.
  String get extension {
    final extension = getFileExtension(source);
    // By default, return a non-viable image extension.
    return extension ?? 'err';
  }

  /// Returns a JSON map representation of this [ImageFile].
  Map<String, Object?> toJson() {
    return <String, Object?>{
      'source': source,
      'width': width,
      'height': height,
    };
  }

  /// Returns a new [ImageFile] instance with its values populated from [json].
  static ImageFile fromJson(Map<String, Object?> json) {
    if (json case {
      'source': final String source,
      'height': final int height,
      'width': final int width,
    }) {
      return ImageFile(source: source, width: width, height: height);
    }
    throw FormatException('Could not deserialize OriginalImage, json=$json');
  }

  @override
  String toString() =>
      'OriginalImage[source_=$source, width=$width, height=$height]';
}

class TitlesSet {
  /// Returns a new [TitlesSet] instance.
  TitlesSet({
    required this.canonical,
    required this.normalized,
    required this.display,
  });

  /// The non-prefixed DB key for the article.
  ///
  /// Might contain changes such as underscores instead of spaces.
  /// Best suited for making request URIs, but still requires percent-encoding.
  final String canonical;

  /// The [normalized title](https://www.mediawiki.org/wiki/API:Query#Example_2:_Title_normalization)
  /// of the article.
  final String normalized;

  /// The title as it should be displayed to the user.
  final String display;

  /// Returns a new [TitlesSet] instance with its values populated from [json].
  static TitlesSet fromJson(Map<String, Object?> json) {
    if (json case {
      'canonical': final String canonical,
      'normalized': final String normalized,
      'display': final String display,
    }) {
      return TitlesSet(
        canonical: canonical,
        normalized: normalized,
        display: display,
      );
    }
    throw FormatException('Could not deserialize TitleSet, json=$json');
  }

  @override
  String toString() =>
      'TitlesSet['
      'canonical=$canonical, '
      'normalized=$normalized, '
      'display=$display'
      ']';
}

String? getFileExtension(String file) {
  final segments = file.split('.');
  if (segments.isNotEmpty) return segments.last;
  return null;
}

const acceptableImageFormats = ['png', 'jpg', 'jpeg'];
```

Em seguida, abra `lib/main.dart` e substitua o código existente por
esta estrutura básica, que adiciona as importações necessárias que o app usa:

<?code-excerpt "fwe/wikipedia_reader/lib/step1_main.dart (All)"?>
```dart title="lib/main.dart"
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:material_ui/material_ui.dart';

import 'summary.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Wikipedia Flutter')),
        body: const Center(child: Text('Loading...')),
      ),
    );
  }
}
```

Este código fornece uma estrutura básica do app com
uma barra de título e conteúdo placeholder.
As importações no topo incluem tudo que você precisa para
requisições HTTP, parsing de JSON e o modelo de dados da Wikipedia.

[Dart Getting Started]: {{site.dart-site}}/tutorial

### Execute seu app {:#run-your-app}

Teste se tudo funciona executando seu app:

```console
$ flutter run -d chrome
```

Você deverá ver um app simples com "Wikipedia Flutter" na barra do app
e "Loading..." no centro da tela.

### Revisão {:#review}

<SummaryCard>
title: O que você realizou
subtitle: Aqui está um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Visualizou o app leitor da Wikipedia
    icon: preview
    details: >-
      Você está começando uma nova seção do tutorial focada em trabalhar com dados.
      Você vai aprender requisições HTTP, gerenciamento de estado com `ChangeNotifier`
      e o padrão de arquitetura MVVM.
  - title: Adicionou o pacote http e criou um modelo de dados
    icon: inventory_2
    details: >-
      Você usou `flutter pub add` para instalar o pacote http para fazer requisições HTTP
      e criou a classe `Summary` para os dados da Wikipedia.
      Pacotes permitem aproveitar código existente construído pela comunidade
      em vez de construir tudo do zero.
  - title: Configurou a estrutura inicial do projeto
    icon: code
    details: >-
      Seu app tem a estrutura básica com todas as importações necessárias para
      requisições HTTP, parsing de JSON e dados da Wikipedia.
      Você está pronto para começar a buscar dados reais da API da Wikipedia!
</SummaryCard>

### Teste seus conhecimentos {:#test-yourself}

<Quiz title="Quiz de configuração do projeto">
- question: "O que a flag `--empty` faz ao executar `flutter create`?"
  options:
    - text: Cria um projeto sem nenhum arquivo.
      correct: false
      explanation: O projeto ainda tem os arquivos essenciais; ele apenas usa um template mínimo.
    - text: Cria um projeto Flutter mínimo com menos código boilerplate.
      correct: true
      explanation: "A flag `--empty` gera um template inicial mínimo sem o app contador padrão."
    - text: Cria um projeto sem nenhuma dependência.
      correct: false
      explanation: O projeto ainda inclui as dependências principais do Flutter.
    - text: Cria um projeto que só pode ser executado na web.
      correct: false
      explanation: A flag não restringe plataformas; ela afeta apenas o template inicial.
- question: Qual comando é usado para adicionar uma dependência de pacote a um projeto Flutter?
  options:
    - text: "`flutter install [package_name]`"
      correct: false
      explanation: "O comando correto usa `pub add`, não `install`."
    - text: "`flutter pub add [package_name]`"
      correct: true
      explanation: "Executar `flutter pub add` adiciona o pacote ao pubspec.yaml e o baixa."
    - text: "`dart get [package_name]`"
      correct: false
      explanation: "O comando para adicionar pacotes é `flutter pub add` ou editar o pubspec.yaml."
    - text: "`flutter package install [package_name]`"
      correct: false
      explanation: "Não existe o comando `flutter package`; use `flutter pub add`."
</Quiz>
