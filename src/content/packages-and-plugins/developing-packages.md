---
ia-translate: true
title: Developing packages & plugins
short-title: Developing
description: Como escrever packages e plugins para Flutter.
---

## Package introduction

Packages permitem a criação de código modular que pode ser compartilhado facilmente.
Um package mínimo consiste no seguinte:

**`pubspec.yaml`**
: Um arquivo de metadata que declara o nome do package,
  versão, autor, e assim por diante.

**`lib`**
: O diretório `lib` contém o código público no
  package, minimamente um único arquivo `<package-name>.dart`.

:::note
Para uma lista de práticas recomendadas ao escrever um plugin eficaz,
veja o artigo no Medium por Mehmet Fidanboylu,
[Writing a good plugin][].
:::

### Package types {:#types}

Packages podem conter mais de um tipo de conteúdo:

**Dart packages**
: Packages gerais escritos em Dart,
  por exemplo o package [`path`][].
  Alguns destes podem conter funcionalidades específicas do Flutter
  e portanto ter uma dependência no
  framework Flutter, restringindo seu uso apenas ao Flutter,
  por exemplo o package [`fluro`][].

**Plugin packages**
: Um Dart package especializado que contém uma API escrita em
  código Dart combinada com uma ou mais implementações
  específicas de plataforma.

  Plugin packages podem ser escritos para Android
  (usando Kotlin ou Java), iOS (usando Swift ou Objective-C),
  web, macOS, Windows, ou Linux, ou qualquer combinação
  destes.

  Um exemplo concreto é o plugin package [`url_launcher`][].
  Para ver como usar o package `url_launcher`, e como ele
  foi estendido para implementar suporte para web,
  veja o artigo no Medium por Harry Terkelsen,
  [How to Write a Flutter Web Plugin, Part 1][].

**FFI Plugin packages**
: Um Dart package especializado que contém uma API escrita em
  código Dart combinada com uma ou mais implementações
  específicas de plataforma que usam Dart FFI([Android][Android], [iOS][iOS], [macOS][macOS]).

## Developing Dart packages {:#dart}

As instruções a seguir explicam como escrever um Flutter
package.

### Step 1: Create the package

Para criar um Flutter package inicial,
use a flag `--template=package` com `flutter create`:

```console
$ flutter create --template=package hello
```

Isto cria um projeto de package na pasta `hello`
com o seguinte conteúdo:

**LICENSE**
: Um arquivo de texto de licença (em sua maioria) vazio.

**test/hello_test.dart**
: Os [unit tests][] para o package.

**hello.iml**
: Um arquivo de configuração usado pelas IDEs IntelliJ.

**.gitignore**
: Um arquivo oculto que informa ao Git quais arquivos ou
  pastas ignorar em um projeto.

**.metadata**
: Um arquivo oculto usado pelas IDEs para rastrear as propriedades
  do projeto Flutter.

**pubspec.yaml**
: Um arquivo yaml contendo metadata que especifica
  as dependências do package. Usado pela ferramenta pub.

**README.md**
: Um arquivo markdown inicial que descreve brevemente
  o propósito do package.

**lib/hello.dart**
: Um app inicial contendo código Dart para o package.

**.idea/modules.xml**, **.idea/workspace.xml**
: Uma pasta oculta contendo arquivos de configuração
  para as IDEs IntelliJ.

**CHANGELOG.md**
: Um arquivo markdown (em sua maioria) vazio para rastrear
  mudanças de versão no package.

### Step 2: Implement the package

Para packages Dart puros, simplesmente adicione a funcionalidade
dentro do arquivo principal `lib/<package name>.dart`,
ou em vários arquivos no diretório `lib`.

Para testar o package, adicione [unit tests][]
em um diretório `test`.

Para detalhes adicionais sobre como organizar o
conteúdo do package,
veja a documentação [Dart library package][].

## Developing plugin packages {:#plugin}

Se você deseja desenvolver um package que chama
APIs específicas de plataforma,
você precisa desenvolver um plugin package.

A API é conectada à(s) implementação(ões)
específica(s) de plataforma usando um [platform channel][].

### Federated plugins

Federated plugins são uma forma de dividir o suporte para
diferentes plataformas em packages separados.
Então, um federated plugin pode usar um package para iOS,
outro para Android, outro para web,
e ainda outro para um carro (como um exemplo de um dispositivo IoT).
Entre outros benefícios, esta abordagem permite que um especialista no domínio
estenda um plugin existente para funcionar na plataforma que ele conhece melhor.

Um federated plugin requer os seguintes packages:

**app-facing package**
: O package do qual os usuários do plugin dependem para usar o plugin.
  Este package especifica a API usada pelo app Flutter.

**platform package(s)**
: Um ou mais packages que contêm o
  código de implementação específico de plataforma. O app-facing package chama
  estes packages&mdash;eles não são incluídos em um app,
  a menos que contenham funcionalidade específica de plataforma
  acessível ao usuário final.

**platform interface package**
: O package que conecta o app-facing package
  ao(s) platform package(s). Este package declara uma
  interface que qualquer platform package deve implementar para
  suportar o app-facing package. Ter um único package
  que define esta interface garante que todos os platform
  packages implementem a mesma funcionalidade de maneira uniforme.

#### Endorsed federated plugin

Idealmente, ao adicionar uma implementação de plataforma a
um federated plugin, você coordenará com o autor
do package para incluir sua implementação.
Dessa forma, o autor original _endossa_ sua
implementação.

Por exemplo, digamos que você escreve uma implementação `foobar_windows`
para o plugin (imaginário) `foobar`.
Em um plugin endossado, o autor original do `foobar`
adiciona sua implementação Windows como uma dependência
no pubspec para o app-facing package.
Então, quando um desenvolvedor inclui o plugin `foobar`
em seu app Flutter, a implementação Windows,
bem como as outras implementações endossadas,
ficam automaticamente disponíveis para o app.

#### Non-endorsed federated plugin

Se você não pode, por qualquer razão, fazer com que sua implementação
seja adicionada pelo autor original do plugin, então seu plugin
_não está_ endossado. Um desenvolvedor ainda pode usar sua
implementação, mas deve adicionar manualmente o plugin
ao arquivo `pubspec.yaml` do app:

```yaml
dependencies:
  foobar: ^1.0.0
  foobar_windows: ^1.0.0 # Non-endorsed plugin implementation
```

Esta abordagem também funciona para sobrescrever uma implementação
de plugin já endossada de `foobar`.

Para mais informações sobre federated plugins,
por que eles são úteis, e como são
implementados, veja o artigo no Medium por Harry Terkelsen,
[How To Write a Flutter Web Plugin, Part 2][].

### Specifying a plugin's supported platforms {:#plugin-platforms}

Plugins podem especificar as plataformas que suportam
adicionando chaves ao mapa `platforms` no
arquivo `pubspec.yaml`. Por exemplo,
o seguinte arquivo pubspec mostra o
mapa `flutter:` para o plugin `hello`,
que suporta apenas iOS e Android:

```yaml
flutter:
  plugin:
    platforms:
      android:
        package: com.example.hello
        pluginClass: HelloPlugin
      ios:
        pluginClass: HelloPlugin
```

Ao adicionar implementações de plugin para mais plataformas,
o mapa `platforms` deve ser atualizado adequadamente.
Por exemplo, aqui está o mapa no arquivo pubspec
para o plugin `hello`,
quando atualizado para adicionar suporte para macOS e web:

```yaml
flutter:
  plugin:
    platforms:
      android:
        package: com.example.hello
        pluginClass: HelloPlugin
      ios:
        pluginClass: HelloPlugin
      macos:
        pluginClass: HelloPlugin
      web:
        pluginClass: HelloPlugin
        fileName: hello_web.dart
```

#### Federated platform packages

Um platform package usa o mesmo formato,
mas inclui uma entrada `implements` indicando
qual app-facing package ele implementa. Por exemplo,
um plugin `hello_windows` contendo a implementação Windows
para `hello`
teria o seguinte mapa `flutter:`:

```yaml
flutter:
  plugin:
    implements: hello
    platforms:
      windows:
        pluginClass: HelloPlugin
```

#### Endorsed implementations

Um app facing package pode endossar um platform package adicionando uma
dependência nele, e incluindo-o como um `default_package` no
mapa `platforms:`. Se o plugin `hello` acima endossasse `hello_windows`,
ele ficaria assim:


```yaml
flutter:
  plugin:
    platforms:
      android:
        package: com.example.hello
        pluginClass: HelloPlugin
      ios:
        pluginClass: HelloPlugin
      windows:
        default_package: hello_windows

dependencies:
  hello_windows: ^1.0.0
```

Note que conforme mostrado aqui, um app-facing package pode ter
algumas plataformas implementadas dentro do package,
e outras em implementações federadas endossadas.

#### Shared iOS and macOS implementations

Muitos frameworks suportam tanto iOS quanto macOS com
APIs idênticas ou quase idênticas, tornando possível implementar
alguns plugins para iOS e macOS com a mesma base de código.
Normalmente a implementação de cada plataforma fica em sua própria
pasta, mas a opção `sharedDarwinSource` permite que iOS
e macOS usem a mesma pasta em vez disso:


```yaml
flutter:
  plugin:
    platforms:
      ios:
        pluginClass: HelloPlugin
        sharedDarwinSource: true
      macos:
        pluginClass: HelloPlugin
        sharedDarwinSource: true

environment:
  sdk: ^3.0.0
  # Flutter versions prior to 3.7 did not support the
  # sharedDarwinSource option.
  flutter: ">=3.7.0"
```

Quando `sharedDarwinSource` está habilitado, em vez de
um diretório `ios` para iOS e um diretório `macos`
para macOS, ambas as plataformas usam um diretório `darwin`
compartilhado para todo o código e recursos. Ao habilitar
esta opção, você precisa mover quaisquer arquivos existentes
de `ios` e `macos` para o diretório compartilhado. Você
também precisa atualizar o arquivo podspec para definir as
dependências e deployment targets para ambas as plataformas,
por exemplo:

```ruby
  s.ios.dependency 'Flutter'
  s.osx.dependency 'FlutterMacOS'
  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '10.14'
```

### Step 1: Create the package

Para criar um plugin package, use a flag `--template=plugin`
com `flutter create`.

Use a opção `--platforms=` seguida por uma
lista separada por vírgulas para especificar as plataformas
que o plugin suporta. Plataformas disponíveis são:
`android`, `ios`, `web`, `linux`, `macos`, e `windows`.
Se nenhuma plataforma for especificada, o
projeto resultante não suporta nenhuma plataforma.

Use a opção `--org` para especificar sua organização,
usando notação de nome de domínio reverso. Este valor é usado
em vários identificadores de package e bundle no
código do plugin gerado.

Por padrão, o projeto de plugin usa Swift para código iOS e
Kotlin para código Android. Se você preferir Objective-C ou Java,
pode especificar a linguagem iOS usando `-i` e a
linguagem Android usando `-a`.
Por favor escolha **uma** das seguintes opções:

```console
$ flutter create --org com.example --template=plugin --platforms=android,ios,linux,macos,windows -a kotlin hello
```
```console
$ flutter create --org com.example --template=plugin --platforms=android,ios,linux,macos,windows -a java hello
```
```console
$ flutter create --org com.example --template=plugin --platforms=android,ios,linux,macos,windows -i objc hello
```
```console
$ flutter create --org com.example --template=plugin --platforms=android,ios,linux,macos,windows -i swift hello
```

Isto cria um projeto de plugin na pasta `hello`
com o seguinte conteúdo especializado:

**`lib/hello.dart`**
: A API Dart para o plugin.

**`android/src/main/java/com/example/hello/HelloPlugin.kt`**
: A implementação específica da plataforma Android da API do plugin
  em Kotlin.

**`ios/Classes/HelloPlugin.m`**
: A implementação específica da plataforma iOS da API do plugin
  em Objective-C.

**`example/`**
: Um app Flutter que depende do plugin,
  e ilustra como usá-lo.

### Step 2: Implement the package {:#edit-plugin-package}

Como um plugin package contém código para várias plataformas
escrito em várias linguagens de programação,
alguns passos específicos são necessários para garantir uma experiência suave.

#### Step 2a: Define the package API (.dart)

A API do plugin package é definida em código Dart.
Abra a pasta principal `hello/` em seu [Flutter editor][] favorito.
Localize o arquivo `lib/hello.dart`.

#### Step 2b: Add Android platform code (.kt/.java)

Recomendamos que você edite o código Android usando Android Studio.

Antes de editar o código da plataforma Android no Android Studio,
primeiro certifique-se de que o código foi construído pelo menos uma vez
(em outras palavras, execute o app de exemplo de sua IDE/editor,
ou em um terminal execute
`cd hello/example; flutter build apk --config-only`).

Em seguida, use os seguintes passos:

1. Abra Android Studio.
1. Selecione **Open an existing Android Studio Project**
   no diálogo **Welcome to Android Studio**,
   ou selecione **File > Open** do menu,
   e selecione o arquivo `hello/example/android/build.gradle`.
1. No diálogo **Gradle Sync**, selecione **OK**.
1. No diálogo **Android Gradle Plugin Update**,
   selecione **Don't remind me again for this project**.

O código da plataforma Android de seu plugin está localizado em
`hello/java/com.example.hello/HelloPlugin`.

Você pode executar o app de exemplo no Android Studio
pressionando o botão executar (&#9654;).

#### Step 2c: Add iOS platform code (.swift/.h+.m)

Recomendamos que você edite o código iOS usando Xcode.

Antes de editar o código da plataforma iOS no Xcode,
primeiro certifique-se de que o código foi construído pelo menos uma vez
(em outras palavras, execute o app de exemplo de sua IDE/editor,
ou em um terminal execute
`cd hello/example; flutter build ios --no-codesign --config-only`).

Em seguida, use os seguintes passos:

1. Abra Xcode.
1. Selecione **File > Open**, e selecione o
   arquivo `hello/example/ios/Runner.xcworkspace`.

O código da plataforma iOS para seu plugin está localizado em
`Pods/Development Pods/hello/../../example/ios/.symlinks/plugins/hello/ios/Classes`
no Project Navigator. (Se você está usando `sharedDarwinSource`,
o caminho terminará com `hello/darwin/Classes` em vez disso.)

Você pode executar o app de exemplo pressionando o botão executar (&#9654;).

##### Add CocoaPod dependencies

:::warning
Flutter está migrando para [Swift Package Manager][]
para gerenciar dependências nativas iOS e macOS.
O suporte do Flutter ao Swift Package Manager está em desenvolvimento.
A implementação pode mudar no futuro.
O suporte ao Swift Package Manager está disponível apenas
no [`main` channel][] do Flutter.
O Flutter continua a suportar CocoaPods.
:::

[Swift Package Manager]: https://www.swift.org/documentation/package-manager/
[`main` channel]: /release/upgrade#switching-flutter-channels

Use as seguintes instruções para adicionar `HelloPod` com a versão `0.0.1`:

1. Especifique a dependência no final de `ios/hello.podspec`:

   ```ruby
   s.dependency 'HelloPod', '0.0.1'
   ```

   Para pods privados, consulte
   [Private CocoaPods][] para garantir acesso ao repo:

   ```ruby
   s.source = {
       # For pods hosted on GitHub
       :git => "https://github.com/path/to/HelloPod.git",
       # Alternatively, for pods hosted locally
       # :path => "file:///path/to/private/repo",
       :tag => s.version.to_s
     }`
   ```

[Private CocoaPods]: https://guides.cocoapods.org/making/private-cocoapods.html

2. Installing the plugin

   - Add the plugin in the project's `pubspec.yaml` dependencies.
   - Run `flutter pub get`.
   - In the project's `ios/` directory, run `pod install`.

O pod deve aparecer no resumo de instalação.

Se seu plugin requer um privacy manifest, por exemplo,
se ele usa qualquer **required reason APIs**,
atualize o arquivo `PrivacyInfo.xcprivacy` para
descrever o impacto de privacidade do seu plugin,
e adicione o seguinte ao final do seu arquivo podspec:

```ruby
s.resource_bundles = {'your_plugin_privacy' => ['your_plugin/Sources/your_plugin/Resources/PrivacyInfo.xcprivacy']}
```

Para mais informações,
veja [Privacy manifest files][] no site de desenvolvedores da Apple.

[Privacy manifest files]: {{site.apple-dev}}/documentation/bundleresources/privacy_manifest_files

#### Step 2d: Add Linux platform code (.h+.cc)

Recomendamos que você edite o código Linux usando uma IDE com
integração C++. As instruções abaixo são para
Visual Studio Code com as extensões "C/C++" e "CMake"
instaladas, mas podem ser ajustadas para outras IDEs.

Antes de editar o código da plataforma Linux em uma IDE,
primeiro certifique-se de que o código foi construído pelo menos uma vez
(em outras palavras, execute o app de exemplo de sua
IDE/editor Flutter, ou em um terminal execute
`cd hello/example; flutter build linux`).

Em seguida, use os seguintes passos:

1. Abra Visual Studio Code.
1. Abra o diretório `hello/example/linux/`.
1. Escolha **Yes** no prompt perguntando:
   `Would you like to configure project "linux"?`.
   Isto permitirá que o autocomplete C++ funcione.

O código da plataforma Linux para seu plugin está localizado em
`flutter/ephemeral/.plugin_symlinks/hello/linux/`.

Você pode executar o app de exemplo usando `flutter run`.
**Nota:** Criar uma aplicação Flutter executável
no Linux requer passos que são parte da ferramenta `flutter`,
então mesmo se seu editor fornecer integração CMake
construir e executar dessa forma não funcionará
corretamente.

#### Step 2e: Add macOS platform code (.swift)

Recomendamos que você edite o código macOS usando Xcode.

Antes de editar o código da plataforma macOS no Xcode,
primeiro certifique-se de que o código foi construído pelo menos uma vez
(em outras palavras, execute o app de exemplo de sua IDE/editor,
ou em um terminal execute
`cd hello/example; flutter build macos --config-only`).

Em seguida, use os seguintes passos:

1. Abra Xcode.
1. Selecione **File > Open**, e selecione o
   arquivo `hello/example/macos/Runner.xcworkspace`.

O código da plataforma macOS para seu plugin está localizado em
`Pods/Development Pods/hello/../../example/macos/Flutter/ephemeral/.symlinks/plugins/hello/macos/Classes`
no Project Navigator. (Se você está usando `sharedDarwinSource`,
o caminho terminará com `hello/darwin/Classes` em vez disso.)

Você pode executar o app de exemplo pressionando o botão executar (&#9654;).

#### Step 2f: Add Windows platform code (.h+.cpp)

Recomendamos que você edite o código Windows usando Visual Studio.

Antes de editar o código da plataforma Windows no Visual Studio,
primeiro certifique-se de que o código foi construído pelo menos uma vez
(em outras palavras, execute o app de exemplo de sua IDE/editor,
ou em um terminal execute
`cd hello/example; flutter build windows`).

Em seguida, use os seguintes passos:

1. Abra Visual Studio.
1. Selecione **Open a project or solution**, e selecione o
   arquivo `hello/example/build/windows/hello_example.sln`.

O código da plataforma Windows para seu plugin está localizado em
`hello_plugin/Source Files` e `hello_plugin/Header Files` no
Solution Explorer.

Você pode executar o app de exemplo clicando com o botão direito em `hello_example` no
Solution Explorer e selecionando **Set as Startup Project**,
então pressionando o botão executar (&#9654;). **Importante:** Após
fazer mudanças no código do plugin, você deve selecionar
**Build > Build Solution** antes de executar novamente, caso contrário
uma cópia desatualizada do plugin construído será executada em vez
da versão mais recente contendo suas mudanças.

#### Step 2g: Connect the API and the platform code

Finalmente, você precisa conectar a API escrita em código Dart com
as implementações específicas de plataforma.
Isto é feito usando um [platform channel][],
ou através das interfaces definidas em um platform
interface package.

### Add support for platforms in an existing plugin project

Para adicionar suporte para plataformas específicas a um
projeto de plugin existente, execute `flutter create` com
a flag `--template=plugin` novamente no diretório do projeto.
Por exemplo, para adicionar suporte para web em um plugin existente, execute:

```console
$ flutter create --template=plugin --platforms=web .
```

Se este comando exibir uma mensagem sobre atualizar o
arquivo `pubspec.yaml`, siga as instruções fornecidas.

### Dart platform implementations

Em muitos casos, implementações de plataforma não-web usam apenas a
linguagem de implementação específica da plataforma, como mostrado acima. No entanto,
implementações de plataforma também podem usar Dart específico de plataforma.

:::note
Os exemplos abaixo se aplicam apenas a plataformas não-web. Implementações
de plugin web são sempre escritas em Dart, e usam
`pluginClass` e `fileName` para suas implementações Dart
como mostrado acima.
:::

#### Dart-only platform implementations

Em alguns casos, algumas plataformas podem ser
implementadas inteiramente em Dart (por exemplo, usando FFI).
Para uma implementação de plataforma apenas em Dart em uma plataforma que não seja web,
substitua o `pluginClass` no pubspec.yaml por um `dartPluginClass`.
Aqui está o exemplo `hello_windows` acima modificado para uma
implementação apenas em Dart:

```yaml
flutter:
  plugin:
    implements: hello
    platforms:
      windows:
        dartPluginClass: HelloPluginWindows
```

Nesta versão você não teria código C++ Windows, e em vez disso
faria uma subclasse da classe de interface de plataforma Dart do plugin `hello` com uma
classe `HelloPluginWindows` que inclui um método estático
`registerWith()`. Este método é chamado durante a inicialização,
e pode ser usado para registrar a implementação Dart:

```dart
class HelloPluginWindows extends HelloPluginPlatform {
  /// Registers this class as the default instance of [HelloPluginPlatform].
  static void registerWith() {
    HelloPluginPlatform.instance = HelloPluginWindows();
  }
```

#### Hybrid platform implementations

Implementações de plataforma também podem usar tanto Dart quanto uma linguagem
específica de plataforma. Por exemplo, um plugin poderia usar um platform channel
diferente para cada plataforma para que os channels possam ser customizados por plataforma.

Uma implementação híbrida usa ambos os sistemas de registro
descritos acima. Aqui está o exemplo `hello_windows` acima modificado para uma
implementação híbrida:

```yaml
flutter:
  plugin:
    implements: hello
    platforms:
      windows:
        dartPluginClass: HelloPluginWindows
        pluginClass: HelloPlugin
```

A classe Dart `HelloPluginWindows` usaria o `registerWith()`
mostrado acima para implementações apenas em Dart, enquanto a classe C++ `HelloPlugin`
seria a mesma que em uma implementação apenas em C++.

### Testing your plugin

Encorajamos que você teste seu plugin com testes automatizados
para garantir que a funcionalidade não regrida
conforme você faz mudanças no seu código.

Para aprender mais sobre testar seus plugins,
veja [Testing plugins][].
Se você está escrevendo testes para seu app Flutter
e plugins estão causando crashes,
veja [Flutter in plugin tests][].

[Flutter in plugin tests]: /testing/plugins-in-tests
[Testing plugins]: /testing/testing-plugins

## Developing FFI plugin packages {:#plugin-ffi}

Se você deseja desenvolver um package que chama APIs nativas usando
FFI do Dart, você precisa desenvolver um FFI plugin package.

Tanto FFI plugin packages quanto non-FFI plugin packages suportam
empacotar código nativo. No entanto, FFI plugin packages não
suportam method channels,
mas eles _suportam_ código de registro de method channel.
Para implementar um plugin que usa tanto method channels
_quanto_ FFI, use um non-FFI plugin.
Cada plataforma pode usar FFI ou non-FFI platform.

### Step 1: Create the package

Para criar um FFI plugin package inicial,
use a flag `--template=plugin_ffi` com `flutter create`:

```console
$ flutter create --template=plugin_ffi hello
```

Isto cria um projeto de FFI plugin na pasta `hello`
com o seguinte conteúdo especializado:

**lib**: O código Dart que define a API do plugin,
  e que chama o código nativo usando `dart:ffi`.

**src**: O código fonte nativo, e um arquivo `CMakeLists.txt`
  para construir esse código fonte em uma biblioteca dinâmica.

**platform folders** (`android`, `ios`, `windows`, etc.): Os
  arquivos de build para construir e empacotar a biblioteca
  de código nativo com a aplicação de plataforma.

### Step 2: Building and bundling native code

O `pubspec.yaml` especifica FFI plugins da seguinte forma:

```yaml
  plugin:
    platforms:
      some_platform:
        ffiPlugin: true
```

Esta configuração invoca o build nativo
para as várias plataformas de destino e empacota
os binários em aplicações Flutter usando estes FFI plugins.

Isto pode ser combinado com `dartPluginClass`,
como quando FFI é usado para a
implementação de uma plataforma em um federated plugin:

```yaml
  plugin:
    implements: some_other_plugin
    platforms:
      some_platform:
        dartPluginClass: SomeClass
        ffiPlugin: true
```

Um plugin pode ter tanto FFI quanto method channels:

```yaml
  plugin:
    platforms:
      some_platform:
        pluginClass: SomeName
        ffiPlugin: true
```

Os sistemas de build nativos que são invocados por FFI
(e method channels) plugins são:

* Para Android: Gradle, que invoca o Android NDK para builds nativos.
  * Veja a documentação em `android/build.gradle`.
* Para iOS e macOS: Xcode, usando CocoaPods.
  * Veja a documentação em `ios/hello.podspec`.
  * Veja a documentação em `macos/hello.podspec`.
* Para Linux e Windows: CMake.
  * Veja a documentação em `linux/CMakeLists.txt`.
  * Veja a documentação em `windows/CMakeLists.txt`.

### Step 3: Binding to native code

Para usar o código nativo, bindings em Dart são necessários.

Para evitar escrevê-los manualmente,
eles são gerados do arquivo de cabeçalho
(`src/hello.h`) por [`package:ffigen`][].
Consulte a [ffigen docs][] para informações
sobre como instalar este package.

Para regenerar os bindings, execute o seguinte comando:

```console
$ dart run ffigen --config ffigen.yaml
```

### Step 4: Invoking native code

Funções nativas de execução muito curta podem ser diretamente
invocadas de qualquer isolate.
Para um exemplo, veja `sum` em `lib/hello.dart`.

Funções de execução mais longa devem ser invocadas em um
[helper isolate][] para evitar perder frames em
aplicações Flutter.
Para um exemplo, veja `sumAsync` em `lib/hello.dart`.

## Adding documentation

É prática recomendada adicionar a seguinte documentação
a todos os packages:

1. Um arquivo `README.md` que introduz o package
1. Um arquivo `CHANGELOG.md` que documenta mudanças em cada versão
1. Um arquivo [`LICENSE`] contendo os termos sob os quais o package
   está licenciado
1. Documentação de API para todas as APIs públicas (veja abaixo para detalhes)

### API documentation

Quando você publica um package,
documentação de API é automaticamente gerada e
publicada em pub.dev/documentation.
Por exemplo, veja a documentação para [`device_info_plus`][].

Se você deseja gerar documentação de API localmente em
sua máquina de desenvolvimento, use os seguintes comandos:

<ol>
<li>

Mude o diretório para a localização do seu package:

```console
cd ~/dev/mypackage
```

</li>

<li>

Informe à ferramenta de documentação onde o
Flutter SDK está localizado (mude os seguintes comandos para refletir
onde você o colocou):

```console
   export FLUTTER_ROOT=~/dev/flutter  # on macOS or Linux

   set FLUTTER_ROOT=~/dev/flutter     # on Windows
```
</li>

<li>Execute a ferramenta `dart doc`
    (incluída como parte do Flutter SDK), da seguinte forma:

```console
   $FLUTTER_ROOT/bin/cache/dart-sdk/bin/dart doc   # on macOS or Linux

   %FLUTTER_ROOT%\bin\cache\dart-sdk\bin\dart doc  # on Windows
```
</li>
</ol>

Para dicas sobre como escrever documentação de API, veja
[Effective Dart Documentation][].

### Adding licenses to the LICENSE file

Licenças individuais dentro de cada arquivo LICENSE
devem ser separadas por 80 hífens
em sua própria linha.

Se um arquivo LICENSE contém mais de uma
licença de componente, então cada
licença de componente deve começar com os nomes dos
packages aos quais a licença de componente se aplica,
com cada nome de package em sua própria linha,
e a lista de nomes de package separada do
texto real da licença por uma linha em branco.
(Os packages não precisam corresponder aos nomes dos
packages pub. Por exemplo, um package pode conter
código de múltiplas fontes de terceiros,
e pode precisar incluir uma licença para cada um.)

O seguinte exemplo mostra um arquivo de licença bem organizado:

```plaintext
package_1

<some license text>

--------------------------------------------------------------------------------
package_2

<some license text>
```

Aqui está outro exemplo de um arquivo de licença bem organizado:

```plaintext
package_1

<some license text>

--------------------------------------------------------------------------------
package_1
package_2

<some license text>
```

Aqui está um exemplo de um arquivo de licença mal organizado:

```plaintext
<some license text>

--------------------------------------------------------------------------------
<some license text>
```

Outro exemplo de um arquivo de licença mal organizado:

```plaintext
package_1

<some license text>
--------------------------------------------------------------------------------
<some license text>
```

## Publishing your package {:#publish}

:::tip
Você notou que alguns dos packages e plugins
no pub.dev são designados como [Flutter Favorites][]?
Estes são os packages publicados por desenvolvedores verificados
e são identificados como os packages e plugins que você
deve considerar primeiro ao escrever seu app.
Para aprender mais,
veja o [Flutter Favorites program][].
:::

Uma vez que você implementou um package, pode publicá-lo no
[pub.dev][], para que outros desenvolvedores possam usá-lo facilmente.

Antes de publicar, certifique-se de revisar o `pubspec.yaml`,
`README.md`, e `CHANGELOG.md` para garantir que seu
conteúdo esteja completo e correto. Além disso, para melhorar a
qualidade e usabilidade do seu package (e torná-lo
mais provável de alcançar o status de Flutter Favorite),
considere incluir os seguintes itens:

* Exemplos diversos de uso de código
* Screenshots, gifs animados ou vídeos
* Um link para o repositório de código correspondente

Em seguida, execute o comando publish em modo `dry-run`
para ver se tudo passa na análise:

```console
$ flutter pub publish --dry-run
```

O próximo passo é publicar no pub.dev,
mas certifique-se de que você está pronto porque
[publishing is forever][]:

```console
$ flutter pub publish
```

Para mais detalhes sobre publicação, veja a
[publishing docs][] em dart.dev.

## Handling package interdependencies {:#dependencies}

Se você está desenvolvendo um package `hello` que depende da
API Dart exposta por outro package, você precisa adicionar
esse package à seção `dependencies` do seu
arquivo `pubspec.yaml`. O código abaixo torna a API Dart
do plugin `url_launcher` disponível para `hello`:

```yaml
dependencies:
  url_launcher: ^5.0.0
```

Você pode agora usar `import 'package:url_launcher/url_launcher.dart'`
e `launch(someUrl)` no código Dart de `hello`.

Isto não é diferente de como você inclui packages em
apps Flutter ou qualquer outro projeto Dart.

Mas se `hello` acontece de ser um package _plugin_
cujo código específico de plataforma precisa de acesso
às APIs específicas de plataforma expostas por `url_launcher`,
você também precisa adicionar declarações de dependência adequadas
aos seus arquivos de build específicos de plataforma, como mostrado abaixo.

### Android

O seguinte exemplo define uma dependência para
`url_launcher` em `hello/android/build.gradle`:

```groovy
android {
    // lines skipped
    dependencies {
        compileOnly rootProject.findProject(":url_launcher")
    }
}
```

Você pode agora usar `import io.flutter.plugins.urllauncher.UrlLauncherPlugin`
e acessar a classe `UrlLauncherPlugin`
no código fonte em `hello/android/src`.

Para mais informações sobre arquivos `build.gradle`, veja a
[Gradle Documentation][] sobre build scripts.

### iOS

O seguinte exemplo define uma dependência para
`url_launcher` em `hello/ios/hello.podspec`:

```ruby
Pod::Spec.new do |s|
  # lines skipped
  s.dependency 'url_launcher'
```

Você pode agora usar `#import "UrlLauncherPlugin.h"` e
acessar a classe `UrlLauncherPlugin` no código fonte
em `hello/ios/Classes`.

Para detalhes adicionais sobre arquivos `.podspec`, veja a
[CocoaPods Documentation][].

### Web

Todas as dependências web são tratadas pelo arquivo `pubspec.yaml`
como qualquer outro Dart package.

{% comment %}
<!-- Remove until we have better text. -->
### MacOS

PENDING
{% endcomment %}

[CocoaPods Documentation]: https://guides.cocoapods.org/syntax/podspec.html
[Dart library package]: {{site.dart-site}}/guides/libraries/create-library-packages
[`device_info_plus`]: {{site.pub-api}}/device_info_plus
[Effective Dart Documentation]: {{site.dart-site}}/guides/language/effective-dart/documentation
[federated plugins]: #federated-plugins
[ffigen docs]: {{site.pub-pkg}}/ffigen/install
[Android]: /platform-integration/android/c-interop
[iOS]: /platform-integration/ios/c-interop
[macOS]: /platform-integration/macos/c-interop
[`fluro`]: {{site.pub}}/packages/fluro
[Flutter editor]: /get-started/editor
[Flutter Favorites]: {{site.pub}}/flutter/favorites
[Flutter Favorites program]: /packages-and-plugins/favorites
[Gradle Documentation]: https://docs.gradle.org/current/userguide/tutorial_using_tasks.html
[helper isolate]: {{site.dart-site}}/guides/language/concurrency#background-workers
[How to Write a Flutter Web Plugin, Part 1]: {{site.flutter-medium}}/how-to-write-a-flutter-web-plugin-5e26c689ea1
[How To Write a Flutter Web Plugin, Part 2]: {{site.flutter-medium}}/how-to-write-a-flutter-web-plugin-part-2-afdddb69ece6
[issue #33302]: {{site.repo.flutter}}/issues/33302
[`LICENSE`]: #adding-licenses-to-the-license-file
[`path`]: {{site.pub}}/packages/path
[`package:ffigen`]: {{site.pub}}/packages/ffigen
[platform channel]: /platform-integration/platform-channels
[pub.dev]: {{site.pub}}
[publishing docs]: {{site.dart-site}}/tools/pub/publishing
[publishing is forever]: {{site.dart-site}}/tools/pub/publishing#publishing-is-forever
[supported-platforms]: #plugin-platforms
[test your plugin]: #testing-your-plugin
[unit tests]: /testing/overview#unit-tests
[`url_launcher`]: {{site.pub}}/packages/url_launcher
[Writing a good plugin]: {{site.flutter-medium}}/writing-a-good-flutter-plugin-1a561b986c9c
