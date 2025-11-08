---
ia-translate: true
title: "Flutter e o arquivo pubspec"
description: "Descreve os campos exclusivos do Flutter no arquivo pubspec."
---

:::note
Esta página é voltada principalmente para pessoas que escrevem
apps Flutter. Se você escreve packages ou plugins,
(talvez você queira criar um plugin federado),
você deve consultar a página
[Developing packages and plugins][].
:::

Todo projeto Flutter inclui um arquivo `pubspec.yaml`,
frequentemente chamado de _the pubspec_.
Um pubspec básico é gerado quando você cria
um novo projeto Flutter. Ele está localizado no topo
da árvore do projeto e contém metadados sobre
o projeto que as ferramentas Dart e Flutter
precisam saber. O pubspec é escrito em
[YAML][], que é legível por humanos, mas esteja ciente
de que _espaços em branco (tabs v espaços) importam_.

[YAML]: https://yaml.org/

O arquivo pubspec especifica dependências
que o projeto requer, como packages específicos
(e suas versões), fontes ou arquivos de imagem.
Ele também especifica outros requisitos, como
dependências de packages de desenvolvedor (como
packages de teste ou mock), ou restrições
específicas na versão do Flutter SDK.

Campos comuns a projetos Dart e Flutter
são descritos em [the pubspec file][] em [dart.dev][].
Esta página lista campos _específicos do Flutter_
que são válidos apenas para um projeto Flutter.

:::note
A primeira vez que você compila seu projeto, ele
cria um arquivo `pubspec.lock` que contém
versões específicas dos packages incluídos.
Isso garante que você obtenha a mesma versão
na próxima vez que o projeto for compilado.
:::

[the pubspec file]: {{site.dart-site}}/tools/pub/pubspec
[dart.dev]: {{site.dart-site}}

Quando você cria um novo projeto com o
comando `flutter create` (ou usando o
botão equivalente na sua IDE), ele cria
um pubspec para um app Flutter básico.

Aqui está um exemplo de um arquivo pubspec de projeto Flutter.
Os campos exclusivos do Flutter estão destacados.

```yaml
name: <project name>
description: A new Flutter project.

publish_to: none

version: 1.0.0+1

environment:
  sdk: ^3.6.0

dependencies:
  [!flutter:!]       # Required for every Flutter project
    [!sdk: flutter!] # Required for every Flutter project
  [!flutter_localizations:!] # Required to enable localization
    [!sdk: flutter!]         # Required to enable localization

  [!cupertino_icons: ^1.0.8!] # Only required if you use Cupertino (iOS style) icons

dev_dependencies:
  [!flutter_test:!]
    [!sdk: flutter!] # Required for a Flutter project that includes tests

  [!flutter_lints: ^5.0.0!] # Contains a set of recommended lints for Flutter code

[!flutter:!]

  [!uses-material-design: true!] # Required if you use the Material icon font

  [!generate: true!] # Enables generation of localized strings from arb files

  [!assets:!]  # Lists assets, such as image files
    [!- images/a_dot_burr.png!]
    [!- images/a_dot_ham.png!]

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

## Assets

Tipos comuns de assets incluem dados estáticos
(por exemplo, arquivos JSON), arquivos de configuração,
ícones e imagens (JPEG, WebP, GIF,
WebP/GIF animado, PNG, BMP e WBMP).

Além de listar as imagens incluídas no
pacote do app, um asset de imagem também pode se referir a uma ou mais
"variantes" específicas de resolução. Para mais informações,
consulte a seção [resolution aware][] da
página [Assets and images][].
Para informações sobre como adicionar assets de dependências de
packages, consulte a seção
[asset images in package dependencies][]
na mesma página.

[Assets and images]: /ui/assets/assets-and-images
[asset images in package dependencies]: /ui/assets/assets-and-images#from-packages
[resolution aware]: /ui/assets/assets-and-images#resolution-aware

## Fonts

Conforme mostrado no exemplo acima,
cada entrada na seção fonts deve ter uma
chave `family` com o nome da família da fonte,
e uma chave `fonts` com uma lista especificando o
asset e outros descritores para a fonte.

Para exemplos de uso de fontes
consulte as receitas [Use a custom font][] e
[Export fonts from a package][] no
[Flutter cookbook][].

[Export fonts from a package]: /cookbook/design/package-fonts
[Flutter cookbook]: /cookbook
[Use a custom font]: /cookbook/design/fonts

## Mais informações

Para mais informações sobre packages, plugins,
e arquivos pubspec, consulte o seguinte:

* [Creating packages][] em dart.dev
* [Glossary of package terms][] em dart.dev
* [Package dependencies][] em dart.dev
* [Using packages][]
* [What not to commit][] em dart.dev

[Creating packages]: {{site.dart-site}}/guides/libraries/create-library-packages
[Developing packages and plugins]: /packages-and-plugins/developing-packages
[Federated plugins]: /packages-and-plugins/developing-packages#federated-plugins
[Glossary of package terms]: {{site.dart-site}}/tools/pub/glossary
[Package dependencies]: {{site.dart-site}}/tools/pub/dependencies
[Using packages]: /packages-and-plugins/using-packages
[What not to commit]: {{site.dart-site}}/guides/libraries/private-files#pubspeclock
