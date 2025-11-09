---
ia-translate: true
title: "Opções do pubspec do Flutter"
description: "Descreve os campos exclusivos do Flutter no arquivo pubspec."
---

Esta página é voltada principalmente para pessoas que escrevem
apps Flutter. Se você escreve packages ou plugins,
(talvez você queira criar um plugin federado),
você deve consultar a página
[Developing packages and plugins][Developing packages and plugins].

## Visão geral

Todo projeto Flutter inclui um arquivo `pubspec.yaml`,
frequentemente referido como _o pubspec_.
Um pubspec básico é gerado quando você cria
um novo projeto Flutter. Ele está localizado no topo
da árvore do projeto e contém metadados sobre
o projeto que as ferramentas Dart e Flutter
precisam saber. O pubspec é escrito em
[YAML][YAML], que é legível por humanos, mas esteja ciente
de que _espaço em branco (tabs vs espaços) importa_.

O pubspec especifica dependências
que o projeto requer, tais como:

+ Packages específicos e suas versões
+ Fontes
+ Imagens
+ Packages de desenvolvedor (como packages de teste ou mock)
+ Restrições específicas na versão do Flutter SDK

Campos comuns a projetos Dart e Flutter
são descritos em [the pubspec file][the pubspec file] em [dartbrasil.dev][dartbrasil.dev].
Esta página lista campos e packages _específicos do Flutter_
que são válidos apenas para um projeto Flutter.

[YAML]: https://yaml.org/
[the pubspec file]: {{site.dart-site}}/tools/pub/pubspec
[dartbrasil.dev]: {{site.dart-site}}

## Exemplo

Quando você cria um novo projeto com o
comando `flutter create` (ou usando o
botão equivalente em sua IDE), ele cria
um pubspec para um app Flutter básico.

Na primeira vez que você compila seu projeto, ele
também cria um arquivo `pubspec.lock` que contém
versões específicas dos packages incluídos.
Isso garante que você obtenha a mesma versão
na próxima vez que o projeto for compilado.

Aqui está um exemplo de um arquivo pubspec de projeto Flutter.
Os campos e packages exclusivos do Flutter estão destacados.

```yaml title="pubspec.yaml"
name: <project name>
description: A new Flutter project.

publish_to: none
version: 1.0.0+1

environment:
  sdk: ^3.9.0

dependencies:
  [!flutter:!]       # Required for every Flutter project
    [!sdk: flutter!] # Required for every Flutter project
  [!flutter_localizations:!] # Required to enable localization
    [!sdk: flutter!]         # Required to enable localization

  [!cupertino_icons: ^1.0.8!] # Only required if you use Cupertino (iOS style) icons

dev_dependencies:
  [!flutter_test:!]
    [!sdk: flutter!] # Required for a Flutter project that includes tests

  [!flutter_lints: ^6.0.0!] # Contains a set of recommended lints for Flutter code

[!flutter:!]

  [!uses-material-design: true!] # Required if you use the Material icon font

  [!generate: true!] # Enables generation of localized strings from arb files

  [!config:!] # App-specific configuration flags that mirror `flutter config`
    [!enable-swift-package-manager: true!]

  [!assets:!]  # Lists assets, such as image files
    [!- images/a_dot_burr.png!]
    [!- images/a_dot_ham.png!]

  [!licenses:!] # Lists additional license files to be bundled with the app
    [!- assets/my_license.txt!]

  [!fonts:!]              # Required if your app uses custom fonts
    [!- family: Schyler!]
      [!fonts:!]
        [!- asset: fonts/Schyler-Regular.ttf!]
        [!- asset: fonts/Schyler-Italic.ttf!]
          [!style: italic!]
    [!- family: Trajan Pro!]
      [!fonts:!]
        [!- asset: fonts/TrajanPro.ttf!]
        [!- asset: fonts/TrajanPro_Bold.ttf!]
          [!weight: 700!]
```

## Campos

Campos específicos do Flutter e específicos do Dart podem ser adicionados ao
pubspec do Flutter. Para aprender mais sobre campos específicos do Flutter,
veja as seguintes seções. Para aprender mais sobre
campos específicos do Dart, veja [campos suportados do pubspec do Dart][Dart's pubspec supported fields].

:::note
O pubspec pode ter campos adicionais auto-gerados do Flutter
que não estão listados aqui.
:::

[Dart's pubspec supported fields]: {{site.dart-site}}/tools/pub/pubspec#supported-fields

### campo assets {: #assets }

Uma lista de caminhos de assets que seu app usa. Esses assets são
empacotados com sua aplicação. Tipos comuns de assets
incluem dados estáticos (por exemplo, `JSON`),
arquivos de configuração, ícones e imagens (`JPEG`, `WebP`,
`GIF`, `WebP/GIF` animados, `PNG`, `BMP` e `WBMP`).

Além de listar as imagens que são incluídas no
pacote do app, um asset de imagem também pode se referir a uma ou mais
"variantes" específicas de resolução. Para mais informações,
veja a seção [resolution aware][resolution aware] da
página [Assets and images][Assets and images].
Para informações sobre como adicionar assets de dependências de package,
veja a seção
[imagens de assets em dependências de package][asset images in package dependencies]
na mesma página.

O campo `asset` tem esta estrutura:

```yaml title="pubspec.yaml"
flutter:
  assets:
    - [ path_to_file | path_to_directory ]
      [ flavor_path_field ]
    [...]
```

```yaml
# estrutura path_to_file
- path/to/directory/file
```

```yaml
# estrutura path_to_directory
- path/to/directory/
```

```yaml
# estrutura flavor_path_field
- path: path/to/directory
  flavors:
  - flavor_name
```

Subcampos de `assets`:

* `path_to_file`: Uma string que representa o caminho para
  um arquivo.
* `path_to_directory`: Uma string que representa o caminho para
  um diretório.
* `flavor_path_field`: Um campo de caminho e seus subcampos
  de flavor.
* `path`: O caminho para um diretório.
* `flavors`: Uma lista de flavors do flutter para usar com assets
  em um caminho específico. Para aprender mais sobre
  flavors, veja [Set up flavors for iOS and macOS][Set up flavors for iOS and macOS] e
  [Set up flavors for Android][Set up flavors for Android].

Você pode passar um caminho para um arquivo:

```yaml title="pubspec.yaml"
flutter:
  assets:
    - assets/images/my_image_a.png
    - assets/images/my_image_b.png
```

Você pode passar um caminho para um diretório:

```yaml title="pubspec.yaml"
flutter:
  assets:
    - assets/images/
    - assets/icons/
```

Você pode passar um caminho para um diretório para
flavors específicos:

```yaml title="pubspec.yaml"
flutter:
  assets:
    - path: assets/flavor_a_and_b/images
      flavors:
      - flavor_a
      - flavor_b
    - path: assets/flavor_c/images
      flavors:
      - flavor_c
```

[Set up flavors for iOS and macOS]: /deployment/flavors-ios
[Set up flavors for Android]: /deployment/flavors
[Assets and images]: /ui/assets/assets-and-images
[asset images in package dependencies]: /ui/assets/assets-and-images#from-packages
[resolution aware]: /ui/assets/assets-and-images#resolution-aware

### campo config {: #config }

Um mapa de chaves para flags (`true` ou `false`) que influencia como o CLI `flutter`
é executado.

> NOTA: Este recurso está disponível apenas a partir de
> [#167953]({{site.github}}/flutter/flutter/pull/167953) no canal `main`.

As chaves disponíveis espelham aquelas disponíveis em `flutter config --list`.

```yaml title="pubspec.yaml"
flutter:
  config:
    cli-animations: false
    enable-swift-package-manager: true
```

Use `flutter config --help` para uma descrição de cada flag.

Flags são lidas apenas do package de _aplicação_ atual, e não têm efeito
no contexto de um package ou dependência.

### campo default-flavor {:#default-flavor-field}

Atribua um flavor padrão do Flutter para um app.
Quando usado, você não precisa incluir o nome deste
flavor no comando de execução do Flutter.

```yaml title="pubspec.yaml"
flutter:
  default-flavor: flavor_name
```

No exemplo a seguir, um app Flutter Android tem um
flavor chamado `staging` e `production`. O flavor `production`
é o flavor padrão. Quando esse flavor é executado,
você não precisa incluí-lo no comando de execução.

```yaml title="pubspec.yaml"
flutter:
  default-flavor: production
```

```console title="console"
// Use este comando para executar o flavor padrão (production).
flutter run

// Use este comando para executar flavors não-padrão (staging).
flutter run --flavor staging
```

Para aprender como criar flavors do Flutter,
veja [Set up Flutter flavors for Android][Set up Flutter flavors for Android] e
[Set up Flutter flavors for iOS and macOS][Set up Flutter flavors for iOS and macOS].

[Set up Flutter flavors for Android]: /deployment/flavors
[Set up Flutter flavors for iOS and macOS]: /deployment/flavors-ios

### campo deferred-components

Adie o tamanho inicial de download de um app Android. Mais
frequentemente usado com aplicações grandes, aplicações modularizadas,
e aplicações com recursos sob demanda.

O campo `deferred-components` tem esta estrutura:

```yaml title="pubspec.yaml"
flutter:
  deferred-components:
    name: component_name
      libraries:
        - string_expression
        [...]
      assets:
        - string_expression
        [...]
    [...]
```

Subcampos de componente diferido:

* `name`: O identificador único para um componente
  diferido específico.
* `libraries`: Uma lista de bibliotecas Dart que fazem parte do
  componente diferido.
* `assets`: Uma lista de caminhos de assets que estão associados ao
  componente diferido.

Exemplo:

```yaml title="pubspec.yaml"
flutter:
  deferred-components:
    - name: box_component
      libraries:
        - package:testdeferredcomponents/box.dart
    - name: gallery_feature
      libraries:
        - package:testdeferredcomponents/gallery_feature.dart
      assets:
        - assets/gallery_images/gallery_feature.png
```

Para aprender mais sobre como você pode usar componentes diferidos com
um app Flutter Android, veja
[Deferred components for Android][Deferred components for Android].

[Deferred components for Android]: /perf/deferred-components

### campo disable-swift-package-manager

Desabilite o uso do Swift Package Manager (SPM) para que
ele não gerencie mais dependências em seus projetos
Flutter iOS e macOS.

```yaml title="pubspec.yaml"
flutter:
  disable-swift-package-manager: true
```

> NOTA: A partir de [#168433]({{site.github}}/flutter/flutter/pull/168433) no
> canal `main`, esta propriedade foi movida para a seção [`config`][config]:
>
> ```yaml title="pubspec.yaml"
> flutter:
>   config:
>     enable-swift-package-manager: false
> ```

[config]: #config

### campo flutter

Um campo que contém configurações específicas do Flutter para seu
app.

```yaml title="pubspec.yaml"
flutter:
  [flutter_field]
  [...]
```

### campo fonts {: #fonts }

Configure e inclua fontes customizadas em sua aplicação
Flutter.

Para exemplos de uso de fontes
veja as receitas [Use a custom font][Use a custom font] e
[Export fonts from a package][Export fonts from a package] no
Flutter cookbook.

O campo `fonts` tem esta estrutura:

```yaml title="pubspec.yaml"
flutter:
  fonts:
    -  { font_family_field | font_asset_field }
    [...]
```

```yaml
# estrutura font_family_field
- family: font_name
      fonts:
        - font_asset_field
        [...]
```

```yaml
# estrutura font_asset_field
- asset: path/to/directory/font_name
  weight: int_expression # Opcional
  style: string_expression # Opcional
```

Subcampos de `fonts`:

+ `family`: Opcional. O nome da família da fonte. Pode ter
  múltiplos assets de fonte.
+ `asset`: A fonte a ser usada.
+ `weight`: Opcional. O peso da fonte. Pode ser
  `100`, `200`, `300`, `400`, `500`, `600`, `700`, `800` ou
  `900`.
+ `style`: Opcional. O estilo da fonte. Pode ser
  `italic`.

Use uma fonte que não faz parte de uma família de fontes:

```yaml title="pubspec.yaml"
flutter:
  fonts:
    - asset: fonts/Roboto-Regular.ttf
      weight: 900 # Opcional
      style: italic # Opcional
```

Use uma família de fontes:

```yaml title="pubspec.yaml"
flutter:
  fonts:
  - family: Roboto # Opcional
        fonts:
          - asset: fonts/Roboto-Regular.ttf
          - asset: fonts/Roboto-Bold.ttf
            weight: 700 # Opcional
            style: italic # Opcional
```

Alternativamente, se você tiver uma fonte que não requer família,
peso ou requisitos de estilo, você pode declará-la como um asset
simples:

```yaml title="pubspec.yaml"
flutter:
  assets:
    - fonts/Roboto-Regular.ttf
```

[Export fonts from a package]: /cookbook/design/package-fonts
[Use a custom font]: /cookbook/design/fonts

### campo generate

Lida com tarefas de localização. Este campo pode aparecer como um
subcampo de `flutter` e `material`.

Habilitar localização geral:

```yaml title="pubspec.yaml"
flutter:
  generate: true
```

### campo licenses {: #licenses}

Uma lista de caminhos de arquivos de licença adicionais que devem ser empacotados com sua
aplicação. Esses arquivos são normalmente encontrados dentro do diretório `assets`
do seu projeto.

O campo `licenses` tem esta estrutura:

```yaml title="pubspec.yaml"
flutter:
  licenses:
    - [path_to_file]
```

### campo plugin

Configure definições especificamente para plugins Flutter.

O campo `plugin` tem esta estrutura:

```yaml title="pubspec.yaml"
flutter:
  plugin:
    platforms:
      android: # Opcional
        package: com.example.my_plugin
        pluginClass: MyPlugin
        dartPluginClass: MyPluginClassName
        ffiPlugin: true
        default_package: my_plugin_name
        fileName: my_file.dart
      ios: # Opcional
        pluginClass: MyPlugin
        dartPluginClass: MyPluginClassName
        ffiPlugin: true
        default_package: my_plugin_name
        fileName: my_file.dart
        sharedDarwinSource: true
      macos: # Opcional
        pluginClass: MyPlugin
        dartPluginClass: MyPluginClassName
        ffiPlugin: true
        default_package: my_plugin_name
        fileName: my_file.dart
        sharedDarwinSource: true
      windows: # Opcional
        pluginClass: MyPlugin
        dartPluginClass: MyPluginClassName
        ffiPlugin: true
        default_package: my_plugin_name
        fileName: my_file.dart
      linux: # Opcional
        pluginClass: MyPlugin
        dartPluginClass: MyPluginClassName
        ffiPlugin: true
        default_package: my_plugin_name
        fileName: my_file.dart
      web: # Opcional
        ffiPlugin: true
        default_package: my_plugin_name
        fileName: my_file.dart
    implements: # Opcional
      - example_platform_interface
```

Subcampos de `plugin`:

* `platforms`: Uma lista de plataformas que terão
  configurações.
* `package`: O nome do package Android do plugin. Isso
  pode ser usado com a plataforma Android e é obrigatório.
* `pluginClass`: O nome da classe do plugin. Opcional se
  `dartPluginClass` for usado para a mesma plataforma. Isso
  pode ser usado com as plataformas Android, iOS, Linux, macOS e
  Windows.
* `default_package`: Opcional. O package que deve ser
  usado como a implementação padrão de uma interface de
  plataforma. Aplicável apenas a plugins federados, onde a
  implementação do plugin é dividida em múltiplos
  packages específicos de plataforma.
* `dartPluginClass`: Opcional. A classe Dart que serve
  como o ponto de entrada para um plugin Flutter. Isso
  pode ser usado com as plataformas Android, iOS, Linux, macOS e
  Windows.
* `sharedDarwinSource`: Opcional. Indica que o plugin
  compartilha código nativo entre iOS e macOS. Isso
  pode ser usado com as plataformas iOS e macOS.
* `fileName`: Opcional. O arquivo que contém a classe do
  plugin.
* `ffiPlugin`: Opcional. True se o plugin usa uma
  Foreign Function Interface (FFI).
* `implements`: Opcional. As interfaces de plataforma que um
  plugin Flutter implementa.

Para aprender mais sobre plugins, veja
[Developing packages & plugins][Developing packages & plugins].

[Developing packages & plugins]: /packages-and-plugins/developing-packages

### campo shaders

Shaders GLSL com a extensão `FRAG`, devem ser declarados na
seção shaders do arquivo `pubspec.yaml` do seu projeto.
A ferramenta de linha de comando Flutter compila o shader para seu
formato de backend apropriado, e gera seus
metadados de tempo de execução necessários. O shader compilado é então incluído na
aplicação como um asset.

O campo `shaders` tem esta estrutura:

```yaml title="pubspec.yaml"
flutter:
  shaders:
    -  { path_to_file | path_to_directory }
    [...]
```

```yaml
# estrutura path_to_file
- assets/shaders/file
```

```yaml
# estrutura path_to_directory
- assets/shaders/
```

Adicionar shaders específicos:

```yaml title="pubspec.yaml"
flutter:
  shaders:
    - assets/shaders/shader_a.frag
    - assets/shaders/shader_b.frag
```

Adicionar um diretório de shaders:

```yaml title="pubspec.yaml"
flutter:
  shaders:
    - assets/shaders/
```

Alternativamente, você pode adicionar seu diretório de shader ao
campo `assets`:

```yaml title="pubspec.yaml"
flutter:
  assets:
    - assets/shaders/my_shader.frag
```

### campo uses-material-design

Use componentes Material Design em seu app Flutter.

```yaml title="pubspec.yaml"
flutter:
  uses-material-design: true
```

## Packages

Os seguintes packages específicos do Flutter podem ser adicionados ao
pubspec. Se você adicionar um package, execute `flutter pub get` em seu
terminal para instalar o package.

### package flutter

Um package que representa o próprio Flutter SDK e
pode ser adicionado ao campo `dependencies`. Use isso se
seu projeto depende do Flutter SDK, não de um package
regular do pub.dev.

```yaml title="pubspec.yaml"
dependencies:
  flutter:
    sdk: flutter
```

### package flutter_localizations

Um package que representa o próprio Flutter SDK e
pode ser adicionado ao campo `dependencies`. Use isso para
habilitar a localização de arquivos `ARB`. Frequentemente usado com
o package `intl`.

```yaml title="pubspec.yaml"
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any
```

### package flutter_test

Um package que representa o próprio Flutter SDK e
pode ser adicionado ao campo `dependencies`. Use isso se você
tiver testes de unidade, widget ou integração para seu
app Flutter.

```yaml title="pubspec.yaml"
dependencies:
  flutter_test:
    sdk: flutter
```

### package flutter_lints

Um package que fornece um conjunto de lints recomendados para
projetos Flutter. Este package pode ser adicionado ao
campo `dev_dependency` no pubspec.

```yaml title="pubspec.yaml"
dev_dependencies:
  flutter_lints: ^6.0.0
```

### cupertino_icons

Um package que fornece um conjunto de ícones Cupertino da Apple
para uso em aplicações Flutter. Este package pode ser adicionado
ao campo `dependency` no pubspec.

```yaml title="pubspec.yaml"
dependencies:
  cupertino_icons: ^1.0.0
```

## Mais informações

Para mais informações sobre packages, plugins,
e arquivos pubspec, veja o seguinte:

* [Creating packages][Creating packages] em dartbrasil.dev
* [Glossary of package terms][Glossary of package terms] em dartbrasil.dev
* [Package dependencies][Package dependencies] em dartbrasil.dev
* [Using packages][Using packages]
* [What not to commit][What not to commit] em dartbrasil.dev

[Creating packages]: {{site.dart-site}}/guides/libraries/create-library-packages
[Developing packages and plugins]: /packages-and-plugins/developing-packages
[Federated plugins]: /packages-and-plugins/developing-packages#federated-plugins
[Glossary of package terms]: {{site.dart-site}}/tools/pub/glossary
[Package dependencies]: {{site.dart-site}}/tools/pub/dependencies
[Using packages]: /packages-and-plugins/using-packages
[What not to commit]: {{site.dart-site}}/guides/libraries/private-files#pubspeclock
