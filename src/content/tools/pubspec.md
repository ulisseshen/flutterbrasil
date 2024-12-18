---
ia-translate: true
title: "Flutter e o arquivo pubspec"
description: "Descreve os campos exclusivos do Flutter no arquivo pubspec."
---

:::note
Esta página é destinada principalmente a pessoas que escrevem
aplicativos Flutter. Se você escreve pacotes ou plugins,
(talvez você queira criar um plugin federado),
você deve verificar a página
[Desenvolvendo pacotes e plugins][].
:::

Todo projeto Flutter inclui um arquivo `pubspec.yaml`,
frequentemente referenciado como _o pubspec_.
Um pubspec básico é gerado quando você cria
um novo projeto Flutter. Ele está localizado no topo
da árvore de projeto e contém metadados sobre
o projeto que as ferramentas Dart e Flutter
precisam saber. O pubspec é escrito em
[YAML][], que é legível por humanos, mas esteja ciente
de que _espaço em branco (tabs vs espaços) importa_.

[YAML]: https://yaml.org/

O arquivo pubspec especifica dependências
que o projeto requer, como pacotes específicos
(e suas versões), fontes ou arquivos de imagem.
Ele também especifica outros requisitos, como
dependências de pacotes de desenvolvedor (como
pacotes de teste ou mocking), ou restrições
específicas sobre a versão do Flutter SDK.

Os campos comuns a projetos Dart e Flutter
são descritos em [o arquivo pubspec][] em [dart.dev][].
Esta página lista campos _específicos do Flutter_
que são válidos apenas para um projeto Flutter.

:::note
Na primeira vez que você compila seu projeto, ele
cria um arquivo `pubspec.lock` que contém
versões específicas dos pacotes incluídos.
Isso garante que você obtenha a mesma versão
na próxima vez que o projeto for compilado.
:::

[o arquivo pubspec]: {{site.dart-site}}/tools/pub/pubspec
[dart.dev]: {{site.dart-site}}

Quando você cria um novo projeto com o
comando `flutter create` (ou usando o botão
equivalente em seu IDE), ele cria
um pubspec para um aplicativo Flutter básico.

Aqui está um exemplo de um arquivo pubspec de projeto Flutter.
Os campos exclusivos do Flutter estão destacados.

```yaml
name: <nome do projeto>
description: Um novo projeto Flutter.

publish_to: none

version: 1.0.0+1

environment:
  sdk: ^3.6.0

dependencies:
  [!flutter:!]       # Necessário para todo projeto Flutter
    [!sdk: flutter!] # Necessário para todo projeto Flutter
  [!flutter_localizations:!] # Necessário para habilitar a localização
    [!sdk: flutter!]         # Necessário para habilitar a localização

  [!cupertino_icons: ^1.0.8!] # Necessário apenas se você usar ícones Cupertino (estilo iOS)

dev_dependencies:
  [!flutter_test:!]
    [!sdk: flutter!] # Necessário para um projeto Flutter que inclui testes

  [!flutter_lints: ^5.0.0!] # Contém um conjunto de lints recomendados para código Flutter

[!flutter:!]

  [!uses-material-design: true!] # Necessário se você usar a fonte de ícones Material

  [!generate: true!] # Habilita a geração de strings localizadas a partir de arquivos arb

  [!assets:!]  # Lista assets, como arquivos de imagem
    [!- images/a_dot_burr.jpeg!]
    [!- images/a_dot_ham.jpeg!]

  [!fonts:!]              # Necessário se seu aplicativo usa fontes personalizadas
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

Além de listar as imagens que estão incluídas no
pacote do aplicativo, um asset de imagem também pode se referir a uma ou mais
"variantes" específicas de resolução. Para mais informações,
consulte a seção [resolution aware][] da
página [Assets e imagens][].
Para obter informações sobre como adicionar assets de dependências de pacotes, consulte a
seção [imagens de assets em dependências de pacotes][]
na mesma página.

[Assets e imagens]: /ui/assets/assets-and-images
[imagens de assets em dependências de pacotes]: /ui/assets/assets-and-images#from-packages
[resolution aware]: /ui/assets/assets-and-images#resolution-aware

## Fontes

Como mostrado no exemplo acima,
cada entrada na seção de fontes deve ter uma
chave `family` com o nome da família da fonte,
e uma chave `fonts` com uma lista especificando o
asset e outros descritores para a fonte.

Para exemplos de uso de fontes
consulte as receitas [Usar uma fonte personalizada][] e
[Exportar fontes de um pacote][] no
[Livro de receitas do Flutter][].

[Exportar fontes de um pacote]: /cookbook/design/package-fonts
[Livro de receitas do Flutter]: /cookbook
[Usar uma fonte personalizada]: /cookbook/design/fonts

## Mais informações

Para mais informações sobre pacotes, plugins,
e arquivos pubspec, veja o seguinte:

* [Criando pacotes][] em dart.dev
* [Glossário de termos de pacote][] em dart.dev
* [Dependências de pacotes][] em dart.dev
* [Usando pacotes][]
* [O que não commitar][] em dart.dev

[Criando pacotes]: {{site.dart-site}}/guides/libraries/create-library-packages
[Desenvolvendo pacotes e plugins]: /packages-and-plugins/developing-packages
[Plugins federados]: /packages-and-plugins/developing-packages#federated-plugins
[Glossário de termos de pacote]: {{site.dart-site}}/tools/pub/glossary
[Dependências de pacotes]: {{site.dart-site}}/tools/pub/dependencies
[Usando pacotes]: /packages-and-plugins/using-packages
[O que não commitar]: {{site.dart-site}}/guides/libraries/private-files#pubspeclock

