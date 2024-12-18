---
ia-translate: true
title: Usando packages
description: Como usar packages no seu aplicativo Flutter.
---

<?code-excerpt path-base="platform_integration/plugin_api_migration"?>

O Flutter oferece suporte ao uso de packages compartilhados contribuídos por outros desenvolvedores
para os ecossistemas Flutter e Dart. Isso permite construir rapidamente
um aplicativo sem ter que desenvolver tudo do zero.

:::note Diferença entre packages e plugins
Um plugin é um _tipo_ de
package&mdash;a designação completa é _plugin package_,
que geralmente é abreviada para _plugin_.

**Packages**
: No mínimo, um package Dart é um diretório
  contendo um arquivo `pubspec.yaml`. Além disso,
  um package pode conter dependências
  (listadas no pubspec), bibliotecas Dart, aplicativos,
  recursos, testes, imagens, fontes e exemplos.
  O site [pub.dev][] lista muitos packages—desenvolvidos por engenheiros do Google
  e membros generosos da comunidade Flutter e Dart—
  que você pode usar no seu aplicativo.

**Plugins**
: Um plugin package é um tipo especial de package que disponibiliza
  funcionalidades de plataforma para o aplicativo.
  Plugin packages podem ser escritos para Android (usando Kotlin ou Java),
  iOS (usando Swift ou Objective-C), web, macOS, Windows, Linux,
  ou qualquer combinação destes.
  Por exemplo, um plugin pode fornecer a aplicativos Flutter
  a capacidade de usar a câmera de um dispositivo.

{% ytEmbed 'Y9WifT8aN6o', 'Packages versus plugins | Decoding Flutter' %}
:::

Packages existentes possibilitam muitos casos de uso—por exemplo,
fazer requisições de rede ([`http`][]),
manipulação de navegação/rotas ([`go_router`][]),
integração com APIs de dispositivos
([`url_launcher`][] e [`battery_plus`][]),
e usar SDKs de plataforma de terceiros como o Firebase
([FlutterFire][]).

Para escrever um novo package, consulte [desenvolvendo packages][].
Para adicionar assets, imagens ou fontes,
sejam armazenados em arquivos ou packages,
consulte [Adicionando assets e imagens][].

[Adicionando assets e imagens]: /ui/assets/assets-and-images
[`battery_plus`]: {{site.pub-pkg}}/battery_plus
[desenvolvendo packages]: /packages-and-plugins/developing-packages
[FlutterFire]: {{site.github}}/firebase/flutterfire
[`go_router`]: {{site.pub-pkg}}/go_router
[`http`]: /cookbook/networking/fetch-data
[pub.dev]: {{site.pub}}
[`url_launcher`]: {{site.pub-pkg}}/url_launcher

## Usando packages

A seção a seguir descreve como usar
packages publicados existentes.

### Pesquisando packages

Packages são publicados no [pub.dev][].

A [página inicial do Flutter][] no pub.dev exibe
os principais packages que são compatíveis com o Flutter
(aqueles que declaram dependências geralmente compatíveis com o Flutter),
e oferece suporte à pesquisa entre todos os packages publicados.

A página [Favoritos do Flutter][] no pub.dev lista
os plugins e packages que foram identificados como
packages que você deve considerar usar primeiro ao escrever
seu aplicativo. Para mais informações sobre o que significa
ser um Favorito do Flutter, consulte o
[Programa Favoritos do Flutter][].

Você também pode navegar pelos packages no pub.dev filtrando
por [Android][], [iOS][], [web][],
[Linux][], [Windows][], [macOS][],
ou qualquer combinação destes.

[Android]: {{site.pub-pkg}}?q=sdk%3Aflutter+platform%3Aandroid
[Favoritos do Flutter]: {{site.pub}}/flutter/favorites
[Programa Favoritos do Flutter]: /packages-and-plugins/favorites
[Página inicial do Flutter]: {{site.pub}}/flutter
[Linux]: {{site.pub-pkgs}}?q=sdk%3Aflutter+platform%3Alinux
[iOS]: {{site.pub-pkg}}?q=sdk%3Aflutter+platform%3Aios
[macOS]: {{site.pub-pkg}}?q=sdk%3Aflutter+platform%3Amacos
[web]: {{site.pub-pkg}}?q=sdk%3Aflutter+platform%3Aweb
[Windows]: {{site.pub-pkg}}?q=sdk%3Aflutter+platform%3Awindows

### Adicionando uma dependência de package a um aplicativo

Para adicionar o package, `css_colors`, a um aplicativo:

1. Dependa dele
   * Abra o arquivo `pubspec.yaml` localizado dentro da pasta do aplicativo,
     e adicione `css_colors:` em `dependencies`.

1. Instale-o
   * No terminal: Execute `flutter pub get`.<br/>
   **OU**
   * No VS Code: Clique em **Get Packages** localizado no lado direito da barra de ação
     na parte superior de `pubspec.yaml` indicado pelo ícone de Download.
   * No Android Studio/IntelliJ: Clique em **Pub get** na barra de ação
     na parte superior de `pubspec.yaml`.

1. Importe-o
   * Adicione uma instrução `import` correspondente no código Dart.

1. Pare e reinicie o aplicativo, se necessário
   * Se o package trouxer código específico da plataforma
     (Kotlin/Java para Android, Swift/Objective-C para iOS),
     esse código deve ser construído no seu aplicativo.
     Hot reload e hot restart atualizam apenas o código Dart,
     portanto, uma reinicialização completa do aplicativo pode ser necessária para evitar
     erros como `MissingPluginException` ao usar o package.

### Adicionando uma dependência de package a um aplicativo usando `flutter pub add`

Para adicionar o package, `css_colors`, a um aplicativo:

1. Execute o comando enquanto estiver dentro do diretório do projeto
   * `flutter pub add css_colors`

1. Importe-o
   * Adicione uma instrução `import` correspondente no código Dart.

1. Pare e reinicie o aplicativo, se necessário
   * Se o package trouxer código específico da plataforma
     (Kotlin/Java para Android, Swift/Objective-C para iOS),
     esse código deve ser construído no seu aplicativo.
     Hot reload e hot restart atualizam apenas o código Dart,
     portanto, uma reinicialização completa do aplicativo pode ser necessária para evitar
     erros como `MissingPluginException` ao usar o package.

### Removendo uma dependência de package de um aplicativo usando `flutter pub remove`

Para remover o package, `css_colors`, de um aplicativo:

1. Execute o comando enquanto estiver dentro do diretório do projeto
   * `flutter pub remove css_colors`

A aba [Instalando][],
disponível em qualquer página de package no pub.dev,
é uma referência útil para estas etapas.

Para um exemplo completo,
veja o [exemplo css_colors][] abaixo.

[exemplo css_colors]: #css-example
[Instalando tab]: {{site.pub-pkg}}/css_colors/install

### Resolução de conflitos

Suponha que você queira usar `some_package` e
`another_package` em um aplicativo,
e ambos dependem de `url_launcher`,
mas em versões diferentes.
Isso causa um conflito potencial.
A melhor maneira de evitar isso é que os autores de packages usem
[intervalos de versão][] em vez de versões específicas ao
especificar dependências.

```yaml
dependencies:
  url_launcher: ^5.4.0    # Bom, qualquer versão >= 5.4.0 mas < 6.0.0
  image_picker: '5.4.3'   # Não tão bom, apenas a versão 5.4.3 funciona.
```

Se `some_package` declarar as dependências acima
e `another_package` declarar uma dependência
`url_launcher` compatível como `'5.4.6'` ou
`^5.5.0`, o pub resolve o problema automaticamente.
Dependências específicas da plataforma em
[módulos Gradle][] e/ou [CocoaPods][]
são resolvidas de maneira semelhante.

Mesmo que `some_package` e `another_package`
declarem versões incompatíveis para `url_launcher`,
eles podem realmente usar `url_launcher` de
maneiras compatíveis. Nesta situação,
o conflito pode ser resolvido adicionando
uma declaração de substituição de dependência ao arquivo
`pubspec.yaml` do aplicativo, forçando o uso de uma versão específica.

Por exemplo, para forçar o uso da versão `5.4.0` de `url_launcher`,
faça as seguintes alterações no arquivo `pubspec.yaml` do aplicativo:

```yaml
dependencies:
  some_package:
  another_package:
dependency_overrides:
  url_launcher: '5.4.0'
```

Se a dependência conflitante não for um package em si,
mas uma biblioteca específica do Android como `guava`,
a declaração de substituição de dependência deve ser adicionada à
lógica de build do Gradle.

Para forçar o uso da versão `28.0` de `guava`, faça as seguintes
alterações no arquivo `android/build.gradle` do aplicativo:

```groovy
configurations.all {
    resolutionStrategy {
        force 'com.google.guava:guava:28.0-android'
    }
}
```

O CocoaPods atualmente não oferece
funcionalidade de substituição de dependência.

[CocoaPods]: https://guides.cocoapods.org/syntax/podspec.html#dependency
[módulos Gradle]: https://docs.gradle.org/current/userguide/declaring_dependencies.html
[intervalos de versão]: {{site.dart-site}}/tools/pub/dependencies#version-constraints

## Desenvolvendo novos packages

Se nenhum package existir para o seu caso de uso específico,
você pode [escrever um package personalizado][].

[escrever um package personalizado]: /packages-and-plugins/developing-packages

## Gerenciando dependências e versões de packages

Para minimizar o risco de colisões de versão,
especifique um intervalo de versão no arquivo `pubspec.yaml`.

### Versões de packages

Todos os packages têm um número de versão, especificado no
arquivo `pubspec.yaml` do package. A versão atual de um package
é exibida ao lado de seu nome (por exemplo,
veja o package [`url_launcher`][]), bem como
uma lista de todas as versões anteriores
(veja [`url_launcher` versões][]).

Para garantir que o aplicativo não quebre ao atualizar um package,
especifique um intervalo de versão usando um dos seguintes formatos.

* **Restrições de intervalo:** Especifique uma versão mínima e máxima.

  ```yaml
  dependencies:
    url_launcher: '>=5.4.0 <6.0.0'
  ```

* **Restrições de intervalo usando a [sintaxe caret][]:**
  Especifique a versão que serve como a versão mínima inclusiva.
  Isso cobre todas as versões daquela versão até a próxima versão principal.

  ```yaml
  dependencies:
    collection: '^5.4.0'
  ```

  Essa sintaxe significa o mesmo que a notada no primeiro item.

Para saber mais, consulte o [guia de versionamento de packages][].

[sintaxe caret]: {{site.dart-site}}/tools/pub/dependencies#caret-syntax
[guia de versionamento de packages]: {{site.dart-site}}/tools/pub/versioning
[`url_launcher` versões]: {{site.pub-pkg}}/url_launcher/versions

### Atualizando dependências de package

Ao executar `flutter pub get`
pela primeira vez após adicionar um package,
o Flutter salva a versão concreta do package encontrada no `pubspec.lock`
[lockfile][]. Isso garante que você obtenha a mesma versão novamente
se você, ou outro desenvolvedor em sua equipe, executar `flutter pub get`.

Para atualizar para uma nova versão do package,
por exemplo, para usar novos recursos nesse package,
execute `flutter pub upgrade`
para recuperar a versão mais alta disponível do package
que é permitida pela restrição de versão especificada em
`pubspec.yaml`.
Observe que este é um comando diferente de
`flutter upgrade` ou `flutter update-packages`,
que ambos atualizam o próprio Flutter.

[lockfile]: {{site.dart-site}}/tools/pub/glossary#lockfile

### Dependências em packages não publicados

Packages podem ser usados mesmo quando não publicados no pub.dev.
Para packages privados ou para packages não prontos para publicação,
opções de dependência adicionais estão disponíveis:

**Dependência de caminho**
: Um aplicativo Flutter pode depender de um package usando um sistema de arquivos
  `path:` dependência. O caminho pode ser relativo ou absoluto.
  Caminhos relativos são avaliados em relação ao diretório
  que contém `pubspec.yaml`. Por exemplo, para depender de um
  package, packageA, localizado em um diretório próximo ao aplicativo,
  use a seguinte sintaxe:

  ```yaml
    dependencies:
    packageA:
      path: ../packageA/
  
  ```

**Dependência Git**
: Você também pode depender de um package armazenado em um repositório Git.
  Se o package estiver localizado na raiz do repositório,
  use a seguinte sintaxe:

  ```yaml
    dependencies:
      packageA:
        git:
          url: https://github.com/flutter/packageA.git
  ```

**Dependência Git usando SSH**
: Se o repositório for privado e você puder se conectar a ele usando SSH,
  dependa do package usando o url SSH do repositório:

  ```yaml
    dependencies:
      packageA:
        git:
          url: git@github.com:flutter/packageA.git
  ```

**Dependência Git em um package em uma pasta**
: O Pub assume que o package está localizado em
  a raiz do repositório Git. Se esse não for o
  caso, especifique a localização com o argumento `path`.
  Por exemplo:

  ```yaml
  dependencies:
    packageA:
      git:
        url: https://github.com/flutter/packages.git
        path: packages/packageA
  ```

  Finalmente, use o argumento `ref` para fixar a dependência em um
  commit, branch ou tag git específico. Para mais detalhes, veja
  [Dependências de Package][].

[Dependências de Package]: {{site.dart-site}}/tools/pub/dependencies

## Exemplos

Os exemplos a seguir abordam as etapas necessárias para
usar packages.

### Exemplo: Usando o package css_colors {:#css-example}

O package [`css_colors`][]
define constantes de cor para cores CSS, portanto, use as constantes
onde quer que a estrutura do Flutter espere o tipo `Color`.

Para usar este package:

1. Crie um novo projeto chamado `cssdemo`.

1. Abra `pubspec.yaml` e adicione a dependência `css-colors`:

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     css_colors: ^1.0.0
   ```

1. Execute `flutter pub get` no terminal,
   ou clique em **Get Packages** no VS Code.

1. Abra `lib/main.dart` e substitua todo o seu conteúdo por:

    <?code-excerpt "lib/css_colors.dart (css-colors)"?>
    ```dart
    import 'package:css_colors/css_colors.dart';
    import 'package:flutter/material.dart';
    
    void main() {
      runApp(const MyApp());
    }
    
    class MyApp extends StatelessWidget {
      const MyApp({super.key});
    
      @override
      Widget build(BuildContext context) {
        return const MaterialApp(
          home: DemoPage(),
        );
      }
    }
    
    class DemoPage extends StatelessWidget {
      const DemoPage({super.key});
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(body: Container(color: CSSColors.orange));
      }
    }
    ```

[`css_colors`]: {{site.pub-pkg}}/css_colors

1. Execute o aplicativo. O fundo do aplicativo agora deve estar laranja.

### Exemplo: Usando o package url_launcher para abrir o navegador {:#url-example}

O plugin package [`url_launcher`][] permite abrir
o navegador padrão na plataforma móvel para exibir
uma determinada URL e tem suporte no Android, iOS, web,
Windows, Linux e macOS.
Este package é um package Dart especial chamado
_plugin package_ (ou _plugin_),
que inclui código específico da plataforma.

Para usar este plugin:

1. Crie um novo projeto chamado `launchdemo`.

1. Abra `pubspec.yaml` e adicione a dependência `url_launcher`:

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     url_launcher: ^5.4.0
   ```

1. Execute `flutter pub get` no terminal,
   ou clique em **Get Packages** no VS Code.

1. Abra `lib/main.dart` e substitua todo o seu conteúdo pelo
   seguinte:

    <?code-excerpt "lib/url_launcher.dart (url-launcher)"?>
    ```dart
    import 'package:flutter/material.dart';
    import 'package:path/path.dart' as p;
    import 'package:url_launcher/url_launcher.dart';
    
    void main() {
      runApp(const MyApp());
    }
    
    class MyApp extends StatelessWidget {
      const MyApp({super.key});
    
      @override
      Widget build(BuildContext context) {
        return const MaterialApp(
          home: DemoPage(),
        );
      }
    }
    
    class DemoPage extends StatelessWidget {
      const DemoPage({super.key});
    
      void launchURL() {
        launchUrl(p.toUri('https://flutter.dev'));
      }
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: launchURL,
              child: const Text('Mostrar página inicial do Flutter'),
            ),
          ),
        );
      }
    }
    ```

1. Execute o aplicativo (ou pare e reinicie-o, se já estava em execução
   antes de adicionar o plugin). Clique em **Mostrar página inicial do Flutter**.
   Você deve ver o navegador padrão abrir no dispositivo,
   exibindo a página inicial para flutter.dev.
