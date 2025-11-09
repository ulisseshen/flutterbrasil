---
ia-translate: true
title: Usando packages
description: Como usar packages no seu app Flutter.
---

<?code-excerpt path-base="platform_integration/plugin_api_migration"?>

Flutter suporta o uso de packages compartilhados contribuídos por outros desenvolvedores
para os ecossistemas Flutter e Dart. Isso permite construir rapidamente
um app sem ter que desenvolver tudo do zero.

:::note Diferença entre packages e plugins
Um plugin é um _tipo_ de
package&mdash;a designação completa é _plugin package_,
que geralmente é abreviada para _plugin_.

**Packages**
: No mínimo, um package Dart é um diretório
  contendo um arquivo `pubspec.yaml`. Adicionalmente,
  um package pode conter dependências
  (listadas no pubspec), bibliotecas Dart, apps,
  recursos, testes, imagens, fontes e exemplos.
  O site [pub.dev][] lista muitos packages—desenvolvidos por engenheiros da Google
  e membros generosos da comunidade Flutter e Dart—
  que você pode usar no seu app.

**Plugins**
: Um plugin package é um tipo especial de package que torna
  funcionalidades de plataforma disponíveis para o app.
  Plugin packages podem ser escritos para Android (usando Kotlin ou Java),
  iOS (usando Swift ou Objective-C), web, macOS, Windows, Linux,
  ou qualquer combinação destes.
  Por exemplo, um plugin pode fornecer aos apps Flutter
  a capacidade de usar a câmera de um dispositivo.

<YouTubeEmbed id="Y9WifT8aN6o" title="Packages versus plugins | Decoding Flutter"></YouTubeEmbed>
:::

Packages existentes habilitam muitos casos de uso—por exemplo,
fazer requisições de rede ([`http`][]),
navegação/manipulação de rotas ([`go_router`][]),
integração com APIs de dispositivos
([`url_launcher`][] e [`battery_plus`][]),
e usar SDKs de plataforma de terceiros como Firebase
([FlutterFire][]).

Para escrever um novo package, veja [developing packages][].
Para adicionar assets, imagens ou fontes,
sejam armazenados em arquivos ou packages,
veja [Adding assets and images][].

[Adding assets and images]: /ui/assets/assets-and-images
[`battery_plus`]: {{site.pub-pkg}}/battery_plus
[developing packages]: /packages-and-plugins/developing-packages
[FlutterFire]: {{site.github}}/firebase/flutterfire

[`go_router`]: {{site.pub-pkg}}/go_router
[`http`]: /cookbook/networking/fetch-data
[pub.dev]: {{site.pub}}
[`url_launcher`]: {{site.pub-pkg}}/url_launcher

## Using packages

A seção seguinte descreve como usar
packages publicados existentes.

### Searching for packages

Packages são publicados no [pub.dev][].

A [Flutter landing page][] no pub.dev exibe
os principais packages que são compatíveis com Flutter
(aqueles que declaram dependências geralmente compatíveis com Flutter),
e suporta busca entre todos os packages publicados.

A página [Flutter Favorites][] no pub.dev lista
os plugins e packages que foram identificados como
packages que você deveria considerar usar primeiro ao escrever
seu app. Para mais informações sobre o que significa
ser um Flutter Favorite, veja o
[Flutter Favorites program][].

Você também pode navegar pelos packages no pub.dev filtrando
por [Android][], [iOS][], [web][],
[Linux][], [Windows][], [macOS][],
ou qualquer combinação destes.

[Android]: {{site.pub-pkg}}?q=sdk%3Aflutter+platform%3Aandroid
[Flutter Favorites]: {{site.pub}}/flutter/favorites
[Flutter Favorites program]: /packages-and-plugins/favorites
[Flutter landing page]: {{site.pub}}/flutter
[Linux]: {{site.pub-pkgs}}?q=sdk%3Aflutter+platform%3Alinux
[iOS]: {{site.pub-pkg}}?q=sdk%3Aflutter+platform%3Aios
[macOS]: {{site.pub-pkg}}?q=sdk%3Aflutter+platform%3Amacos
[web]: {{site.pub-pkg}}?q=sdk%3Aflutter+platform%3Aweb
[Windows]: {{site.pub-pkg}}?q=sdk%3Aflutter+platform%3Awindows

### Adding a package dependency to an app using `flutter pub add`

Para adicionar o package `css_colors` a um app:

1. Use o comando [`pub add`][] de dentro do diretório do projeto
   * `flutter pub add css_colors`

1. Importe-o
   * Adicione uma declaração `import` correspondente no código Dart.

1. Pare e reinicie o app, se necessário
   * Se o package traz código específico de plataforma
     (Kotlin/Java para Android, Swift/Objective-C para iOS),
     esse código deve ser compilado no seu app.
     Hot reload e hot restart apenas atualizam o código Dart,
     então uma reinicialização completa do app pode ser necessária para evitar
     erros como `MissingPluginException` ao usar o package.

[`pub add`]: {{site.dart-site}}/tools/pub/cmd/pub-add

### Adding a package dependency to an app

Para adicionar o package `css_colors` a um app:

1. Depend on it
   * Abra o arquivo `pubspec.yaml` localizado dentro da pasta do app,
     e adicione `css_colors: ^1.0.0` em `dependencies`.

1. Install it
   * Do terminal: Execute `flutter pub get`.<br/>
   **OU**
   * Do VS Code: Clique em **Get Packages** localizado no lado direito da faixa de ação
     no topo do `pubspec.yaml` indicado pelo ícone de Download.
   * Do Android Studio/IntelliJ: Clique em **Pub get** na faixa de ação
     no topo do `pubspec.yaml`.

1. Import it
   * Adicione uma declaração `import` correspondente no código Dart.

1. Stop and restart the app, if necessary
   * Se o package traz código específico de plataforma
     (Kotlin/Java para Android, Swift/Objective-C para iOS),
     esse código deve ser compilado no seu app.
     Hot reload e hot restart apenas atualizam o código Dart,
     então uma reinicialização completa do app pode ser necessária para evitar
     erros como `MissingPluginException` ao usar o package.

### Removing a package dependency to an app using `flutter pub remove`

Para remover o package `css_colors` de um app:

1. Use o comando [`pub remove`][] de dentro do diretório do projeto
   * `flutter pub remove css_colors`

A [Installing tab][],
disponível em qualquer página de package no pub.dev,
é uma referência útil para esses passos.

Para um exemplo completo,
veja o [css_colors example][] abaixo.

[css_colors example]: #css-example
[Installing tab]: {{site.pub-pkg}}/css_colors/install
[`pub remove`]: {{site.dart-site}}/tools/pub/cmd/pub-remove

### Conflict resolution

Suponha que você queira usar `some_package` e
`another_package` em um app,
e ambos dependem de `url_launcher`,
mas em versões diferentes.
Isso causa um conflito potencial.
A melhor maneira de evitar isso é que os autores de packages usem
[version ranges][] ao invés de versões específicas ao
especificar dependências.

```yaml
dependencies:
  url_launcher: ^5.4.0    # Good, any version >= 5.4.0 but < 6.0.0
  image_picker: '5.4.3'   # Not so good, only version 5.4.3 works.
```

Se `some_package` declara as dependências acima
e `another_package` declara uma dependência
`url_launcher` compatível como `'5.4.6'` ou
`^5.5.0`, pub resolve o problema automaticamente.
Dependências específicas de plataforma em
[Gradle modules][] e/ou [CocoaPods][]
são resolvidas de maneira similar.

Mesmo se `some_package` e `another_package`
declararem versões incompatíveis para `url_launcher`,
eles podem na verdade usar `url_launcher` de
maneiras compatíveis. Nesta situação,
o conflito pode ser resolvido adicionando
uma declaração de dependency override ao arquivo
`pubspec.yaml` do app, forçando o uso de uma versão particular.

Por exemplo, para forçar o uso da versão `5.4.0` de `url_launcher`,
faça as seguintes alterações no arquivo `pubspec.yaml` do app:

```yaml
dependencies:
  some_package:
  another_package:
dependency_overrides:
  url_launcher: '5.4.0'
```

Se a dependência conflitante não for ela mesma um package,
mas uma biblioteca específica do Android como `guava`,
a declaração de dependency override deve ser adicionada à
lógica de build do Gradle.

Para forçar o uso da versão `28.0` de `guava`, faça as seguintes
alterações no arquivo `android/build.gradle` do app:

```groovy
configurations.all {
    resolutionStrategy {
        force 'com.google.guava:guava:28.0-android'
    }
}
```

CocoaPods atualmente não oferece funcionalidade de
dependency override.

[CocoaPods]: https://guides.cocoapods.org/syntax/podspec.html#dependency
[Gradle modules]: https://docs.gradle.org/current/userguide/declaring_dependencies.html
[version ranges]: {{site.dart-site}}/tools/pub/dependencies#version-constraints

## Developing new packages

Se nenhum package existe para seu caso de uso específico,
você pode [write a custom package][].

[write a custom package]: /packages-and-plugins/developing-packages

## Managing package dependencies and versions

Para minimizar o risco de colisões de versão,
especifique um intervalo de versão no arquivo `pubspec.yaml`.

### Package versions

Todos os packages têm um número de versão, especificado no
arquivo `pubspec.yaml` do package. A versão atual de um package
é exibida ao lado de seu nome (por exemplo,
veja o package [`url_launcher`][]), bem como
uma lista de todas as versões anteriores
(veja [`url_launcher` versions][]).

Para garantir que o app não quebre quando você atualizar um package,
especifique um intervalo de versão usando um dos seguintes formatos.

* **Ranged constraints:** Especifique uma versão mínima e máxima.

  ```yaml
  dependencies:
    url_launcher: '>=5.4.0 <6.0.0'
  ```

* **Ranged constraints using the [caret syntax][]:**
  Especifique a versão que serve como a versão mínima inclusiva.
  Isso cobre todas as versões dessa versão até a próxima versão principal.

  ```yaml
  dependencies:
    collection: '^5.4.0'
  ```

  Esta sintaxe significa o mesmo que a mencionada no primeiro item.

Para saber mais, confira o [package versioning guide][].

[caret syntax]: {{site.dart-site}}/tools/pub/dependencies#caret-syntax
[package versioning guide]: {{site.dart-site}}/tools/pub/versioning
[`url_launcher` versions]: {{site.pub-pkg}}/url_launcher/versions

### Updating package dependencies

Ao executar `flutter pub get`
pela primeira vez após adicionar um package,
Flutter salva a versão concreta do package encontrada no `pubspec.lock`
[lockfile][]. Isso garante que você obtenha a mesma versão novamente
se você, ou outro desenvolvedor na sua equipe, executar `flutter pub get`.

Para atualizar para uma nova versão do package,
por exemplo para usar novos recursos nesse package,
execute `flutter pub upgrade`
para recuperar a versão mais alta disponível do package
que é permitida pela restrição de versão especificada em
`pubspec.yaml`.
Note que este é um comando diferente de
`flutter upgrade` ou `flutter update-packages`,
que ambos atualizam o próprio Flutter.

[lockfile]: {{site.dart-site}}/tools/pub/glossary#lockfile

### Dependencies on unpublished packages

Packages podem ser usados mesmo quando não publicados no pub.dev.
Para packages privados, ou para packages não prontos para publicação,
opções adicionais de dependência estão disponíveis:

**Path dependency**
: Um app Flutter pode depender de um package usando uma dependência
  `path:` de sistema de arquivos. O path pode ser relativo ou absoluto.
  Paths relativos são avaliados relativamente ao diretório
  contendo `pubspec.yaml`. Por exemplo, para depender de um
  package, packageA, localizado em um diretório ao lado do app,
  use a seguinte sintaxe:

  ```yaml
    dependencies:
    packageA:
      path: ../packageA/

  ```

**Git dependency**
: Você também pode depender de um package armazenado em um repositório Git.
  Se o package está localizado na raiz do repositório,
  use a seguinte sintaxe:

  ```yaml
    dependencies:
      packageA:
        git:
          url: https://github.com/flutter/packageA.git
  ```

**Git dependency using SSH**
: Se o repositório é privado e você pode conectar a ele usando SSH,
  dependa do package usando a URL SSH do repositório:

  ```yaml
    dependencies:
      packageA:
        git:
          url: git@github.com:flutter/packageA.git
  ```

**Git dependency on a package in a folder**
: Pub assume que o package está localizado na
  raiz do repositório Git. Se não for
  o caso, especifique a localização com o argumento `path`.
  Por exemplo:

  ```yaml
  dependencies:
    packageA:
      git:
        url: https://github.com/flutter/packages.git
        path: packages/packageA
  ```

  Finalmente, use o argumento `ref` para fixar a dependência a um
  commit, branch ou tag git específico. Para mais detalhes, veja
  [Package dependencies][].

[Package dependencies]: {{site.dart-site}}/tools/pub/dependencies

## Examples

Os exemplos seguintes percorrem os passos necessários para
usar packages.

### Example: Using the css_colors package {:#css-example}

O package [`css_colors`][]
define constantes de cor para cores CSS, então use as constantes
onde quer que o framework Flutter espere o tipo `Color`.

Para usar este package:

1. Crie um novo projeto chamado `cssdemo`.

1. Abra `pubspec.yaml`, e adicione a dependência `css-colors`:

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
        return const MaterialApp(home: DemoPage());
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

1. Execute o app. O fundo do app agora deve estar laranja.

[`css_colors`]: {{site.pub-pkg}}/css_colors

### Example: Using the url_launcher package to launch the browser {:#url-example}

O plugin package [`url_launcher`][] habilita abrir
o navegador padrão na plataforma móvel para exibir
uma URL fornecida, e é suportado em Android, iOS, web,
Windows, Linux e macOS.
Este package é um package Dart especial chamado
_plugin package_ (ou _plugin_),
que inclui código específico de plataforma.

Para usar este plugin:

1. Crie um novo projeto chamado `launchdemo`.

1. Abra `pubspec.yaml`, e adicione a dependência `url_launcher`:

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     url_launcher: ^5.4.0
   ```

1. Execute `flutter pub get` no terminal,
   ou clique em **Get Packages get** no VS Code.

1. Abra `lib/main.dart` e substitua todo o seu conteúdo pelo
   seguinte:

    <?code-excerpt "lib/url_launcher.dart (url-launcher)"?>
    ```dart
    import 'package:flutter/material.dart';
    import 'package:url_launcher/url_launcher.dart';

    void main() {
      runApp(const MyApp());
    }

    class MyApp extends StatelessWidget {
      const MyApp({super.key});

      @override
      Widget build(BuildContext context) {
        return const MaterialApp(home: DemoPage());
      }
    }

    class DemoPage extends StatelessWidget {
      const DemoPage({super.key});

      void launchURL() {
        launchUrl(Uri.parse('https://flutter.dev'));
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: launchURL,
              child: const Text('Show Flutter homepage'),
            ),
          ),
        );
      }
    }
    ```

1. Execute o app (ou pare e reinicie, se ele já estava executando
   antes de adicionar o plugin). Clique em **Show Flutter homepage**.
   Você deveria ver o navegador padrão abrir no dispositivo,
   exibindo a homepage do flutter.dev.
