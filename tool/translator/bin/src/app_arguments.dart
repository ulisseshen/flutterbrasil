class AppArguments {
  final bool showHelp;
  final bool translateGreater;
  final bool useSecond;
  final bool translateOneFile;
  final bool collectLinks;
  final bool showInfo;
  final bool cleanMarkdown;
  final bool replaceLinks;
  final bool useV2;
  final String directoryPath;
  final String extension;
  final String? filePath;
  final bool? multiFiles;
  final List<String>? multipleFilePaths;

  AppArguments._({
    required this.showHelp,
    required this.translateGreater,
    required this.useSecond,
    required this.translateOneFile,
    required this.collectLinks,
    required this.showInfo,
    required this.cleanMarkdown,
    required this.replaceLinks,
    required this.useV2,
    required this.directoryPath,
    required this.extension,
    this.multiFiles,
    this.filePath,
    this.multipleFilePaths
  });

  factory AppArguments.parse(List<String> arguments) {
    if (arguments.isEmpty ||
        arguments.contains('-h') ||
        arguments.contains('--help')) {
      return AppArguments._(
        showHelp: true,
        translateGreater: false,
        useSecond: false,
        translateOneFile: false,
        collectLinks: false,
        showInfo: false,
        cleanMarkdown: false,
        replaceLinks: false,
        useV2: false,
        directoryPath: '',
        extension: '.md',
        filePath: null,
        multiFiles: false
      );
    }

    final translateGreater = arguments.contains('-g');
    final useSecond = arguments.contains('-s');
    final translateOneFile = arguments.contains('-f');
    final collectLinks = arguments.contains('-cl');
    final showInfo = arguments.contains('--info');
    final cleanMarkdown = arguments.contains('-c');
    final replaceLinks = arguments.contains('-l');
    final useV2 = arguments.contains('-v2');
    final multiFiles = arguments.contains('-mf');
     final mfIndex = arguments.indexOf('-mf');

     List<String> multiPaths=[];
    if (mfIndex != -1 && mfIndex + 1 < arguments.length) {
      final files = arguments.sublist(mfIndex + 1);
      multiPaths.addAll(files);
    }

    String extension = '.md'; // Valor padrão
    final extensionArgIndex = arguments.indexOf('-e');
    if (extensionArgIndex != -1 && extensionArgIndex + 1 < arguments.length) {
      extension = '.${arguments[extensionArgIndex + 1]}';
    }

    String? filePath;
    if (translateOneFile) {
      final fileIndex = arguments.indexWhere((arg) => arg.endsWith('.md'));
      if (fileIndex != -1) {
        filePath = arguments[fileIndex];
      }
    }

    final directoryPath =
        arguments.firstWhere((arg) => !arg.startsWith('-'), orElse: () => '');

    return AppArguments._(
      showHelp: false,
      translateGreater: translateGreater,
      useSecond: useSecond,
      translateOneFile: translateOneFile,
      collectLinks: collectLinks,
      showInfo: showInfo,
      cleanMarkdown: cleanMarkdown,
      replaceLinks: replaceLinks,
      useV2: useV2,
      directoryPath: directoryPath,
      extension: extension,
      filePath: filePath,
      multiFiles: multiFiles,
      multipleFilePaths: multiPaths
    );
  }

  void printHelp() {
    print('Usage: app [options] <directory>');
    print('Options:');
    print('-h, --help          Show this help message');
    print('-g                  Translate greater files');
    print('-s                  Use second translation');
    print('-f                  Translate a single file');
    print('-cl                 Collect links');
    print('--info              Show directory info');
    print('-c                  Clean Markdown files');
    print('-l                  Replace links');
    print('-v2                 Use the second version of the tool');
    print('-e <extension>      Specify file extension (default: .md)');
  }
}
