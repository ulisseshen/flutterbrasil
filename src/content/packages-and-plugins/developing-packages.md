---
ia-translate: true
title: Desenvolvimento de pacotes e plugins
short-title: Desenvolvimento
description: Como escrever pacotes e plugins para o Flutter.
---

## Introdução ao pacote

Pacotes possibilitam a criação de código modular que pode ser compartilhado facilmente. Um pacote mínimo consiste no seguinte:

**`pubspec.yaml`**
: Um arquivo de metadados que declara o nome do pacote, versão, autor e assim por diante.

**`lib`**
: O diretório `lib` contém o código público no pacote, no mínimo um único arquivo `<nome-do-pacote>.dart`.

:::note
Para uma lista de recomendações sobre o que fazer e o que não fazer ao escrever um plugin eficaz, veja o artigo do Medium de Mehmet Fidanboylu, [Writing a good plugin][].
:::

### Tipos de pacote {:#types}

Os pacotes podem conter mais de um tipo de conteúdo:

**Pacotes Dart**
: Pacotes gerais escritos em Dart, por exemplo, o pacote [`path`][]. Alguns deles podem conter funcionalidades específicas do Flutter e, portanto, ter uma dependência do framework Flutter, restringindo seu uso apenas ao Flutter, por exemplo, o pacote [`fluro`][].

**Pacotes de plugin**
: Um pacote Dart especializado que contém uma API escrita em código Dart combinada com uma ou mais implementações específicas da plataforma.

Pacotes de plugin podem ser escritos para Android (usando Kotlin ou Java), iOS (usando Swift ou Objective-C), web, macOS, Windows ou Linux, ou qualquer combinação deles.

Um exemplo concreto é o pacote de plugin [`url_launcher`][]. Para ver como usar o pacote `url_launcher` e como ele foi estendido para implementar suporte para a web, veja o artigo do Medium de Harry Terkelsen, [How to Write a Flutter Web Plugin, Part 1][].

**Pacotes de plugin FFI**
: Um pacote Dart especializado que contém uma API escrita em código Dart combinada com uma ou mais implementações específicas da plataforma que usam Dart FFI ([Android][Android], [iOS][iOS], [macOS][macOS]).

## Desenvolvimento de pacotes Dart {:#dart}

As instruções a seguir explicam como escrever um pacote Flutter.

### Passo 1: Criar o pacote

Para criar um pacote Flutter inicial, use o sinalizador `--template=package` com `flutter create`:

```console
$ flutter create --template=package hello
```

Isso cria um projeto de pacote na pasta `hello` com o seguinte conteúdo:

**LICENSE**
: Um arquivo de texto de licença (quase) vazio.

**test/hello_test.dart**
: Os [testes unitários][] para o pacote.

**hello.iml**
: Um arquivo de configuração usado pelos IDEs IntelliJ.

**.gitignore**
: Um arquivo oculto que diz ao Git quais arquivos ou pastas ignorar em um projeto.

**.metadata**
: Um arquivo oculto usado por IDEs para rastrear as propriedades do projeto Flutter.

**pubspec.yaml**
: Um arquivo yaml contendo metadados que especificam as dependências do pacote. Usado pela ferramenta pub.

**README.md**
: Um arquivo markdown inicial que descreve brevemente o propósito do pacote.

**lib/hello.dart**
: Um aplicativo inicial contendo código Dart para o pacote.

**.idea/modules.xml**, **.idea/workspace.xml**
: Uma pasta oculta contendo arquivos de configuração para os IDEs IntelliJ.

**CHANGELOG.md**
: Um arquivo markdown (quase) vazio para rastrear as alterações de versão do pacote.

### Passo 2: Implementar o pacote

Para pacotes Dart puros, basta adicionar a funcionalidade dentro do arquivo principal `lib/<nome do pacote>.dart`, ou em vários arquivos no diretório `lib`.

Para testar o pacote, adicione [testes unitários][] em um diretório `test`.

Para detalhes adicionais sobre como organizar o conteúdo do pacote, veja a documentação de [pacote de biblioteca Dart][].

## Desenvolvimento de pacotes de plugin {:#plugin}

Se você quiser desenvolver um pacote que chama APIs específicas da plataforma, você precisa desenvolver um pacote de plugin.

A API é conectada às implementações específicas da plataforma usando um [canal de plataforma][].

### Plugins federados

Plugins federados são uma forma de dividir o suporte para diferentes plataformas em pacotes separados. Portanto, um plugin federado pode usar um pacote para iOS, outro para Android, outro para web e outro para um carro (como exemplo de um dispositivo IoT). Entre outros benefícios, essa abordagem permite que um especialista em um domínio estenda um plugin existente para funcionar na plataforma que ele melhor conhece.

Um plugin federado requer os seguintes pacotes:

**pacote voltado para o aplicativo**
: O pacote do qual os usuários do plugin dependem para usar o plugin. Este pacote especifica a API usada pelo aplicativo Flutter.

**pacote(s) de plataforma**
: Um ou mais pacotes que contêm o código de implementação específico da plataforma. O pacote voltado para o aplicativo chama esses pacotes - eles não são incluídos em um aplicativo, a menos que contenham funcionalidades específicas da plataforma acessíveis ao usuário final.

**pacote de interface de plataforma**
: O pacote que une o pacote voltado para o aplicativo ao(s) pacote(s) de plataforma. Este pacote declara uma interface que qualquer pacote de plataforma deve implementar para suportar o pacote voltado para o aplicativo. Ter um único pacote que define essa interface garante que todos os pacotes de plataforma implementem a mesma funcionalidade de maneira uniforme.

#### Plugin federado endossado

Idealmente, ao adicionar uma implementação de plataforma a um plugin federado, você se coordenará com o autor do pacote para incluir sua implementação. Desta forma, o autor original _endossa_ sua implementação.

Por exemplo, digamos que você escreva uma implementação `foobar_windows` para o plugin `foobar` (imaginário). Em um plugin endossado, o autor original do `foobar` adiciona sua implementação do Windows como uma dependência no pubspec do pacote voltado para o aplicativo. Então, quando um desenvolvedor inclui o plugin `foobar` em seu aplicativo Flutter, a implementação do Windows, assim como as outras implementações endossadas, ficam automaticamente disponíveis para o aplicativo.

#### Plugin federado não endossado

Se você não puder, por qualquer motivo, fazer com que sua implementação seja adicionada pelo autor original do plugin, seu plugin _não_ será endossado. Um desenvolvedor ainda pode usar sua implementação, mas deve adicionar manualmente o plugin ao arquivo `pubspec.yaml` do aplicativo:

```yaml
dependencies:
  foobar: ^1.0.0
  foobar_windows: ^1.0.0 # Implementação de plugin não endossada
```

Essa abordagem também funciona para substituir uma implementação de plugin já endossada de `foobar`.

Para obter mais informações sobre plugins federados, por que eles são úteis e como são implementados, veja o artigo do Medium de Harry Terkelsen, [How To Write a Flutter Web Plugin, Part 2][].

### Especificando as plataformas suportadas de um plugin {:#plugin-platforms}

Os plugins podem especificar as plataformas que suportam adicionando chaves ao mapa `platforms` no arquivo `pubspec.yaml`. Por exemplo, o seguinte arquivo pubspec mostra o mapa `flutter:` para o plugin `hello`, que suporta apenas iOS e Android:

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

Ao adicionar implementações de plugin para mais plataformas, o mapa `platforms` deve ser atualizado de acordo. Por exemplo, aqui está o mapa no arquivo pubspec para o plugin `hello`, quando atualizado para adicionar suporte para macOS e web:

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

#### Pacotes de plataforma federados

Um pacote de plataforma usa o mesmo formato, mas inclui uma entrada `implements` indicando qual pacote voltado para o aplicativo ele implementa. Por exemplo, um plugin `hello_windows` contendo a implementação do Windows para `hello` teria o seguinte mapa `flutter:`:

```yaml
flutter:
  plugin:
    implements: hello
    platforms:
      windows:
        pluginClass: HelloPlugin
```

#### Implementações endossadas

Um pacote voltado para o aplicativo pode endossar um pacote de plataforma adicionando uma dependência nele e incluindo-o como um `default_package` no mapa `platforms:`. Se o plugin `hello` acima endossasse `hello_windows`, ele ficaria assim:

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

Observe que, como mostrado aqui, um pacote voltado para o aplicativo pode ter algumas plataformas implementadas dentro do pacote e outras em implementações federadas endossadas.

#### Implementações compartilhadas para iOS e macOS

Muitos frameworks suportam iOS e macOS com APIs idênticas ou quase idênticas, tornando possível implementar alguns plugins para iOS e macOS com o mesmo código. Normalmente, a implementação de cada plataforma está em sua própria pasta, mas a opção `sharedDarwinSource` permite que iOS e macOS usem a mesma pasta:

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
  # Versões do Flutter anteriores à 3.7 não suportavam a
  # opção sharedDarwinSource.
  flutter: ">=3.7.0"
```

Quando `sharedDarwinSource` está habilitado, em vez de um diretório `ios` para iOS e um diretório `macos` para macOS, ambas as plataformas usam um diretório `darwin` compartilhado para todo o código e recursos. Ao habilitar esta opção, você precisa mover todos os arquivos existentes de `ios` e `macos` para o diretório compartilhado. Você também precisa atualizar o arquivo podspec para definir as dependências e os targets de implantação para ambas as plataformas, por exemplo:

```ruby
  s.ios.dependency 'Flutter'
  s.osx.dependency 'FlutterMacOS'
  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '10.14'
```

### Passo 1: Criar o pacote

Para criar um pacote de plugin, use o sinalizador `--template=plugin` com `flutter create`.

Use a opção `--platforms=` seguida por uma lista separada por vírgulas para especificar as plataformas que o plugin suporta. As plataformas disponíveis são: `android`, `ios`, `web`, `linux`, `macos` e `windows`. Se nenhuma plataforma for especificada, o projeto resultante não suporta nenhuma plataforma.

Use a opção `--org` para especificar sua organização, usando a notação de nome de domínio reverso. Este valor é usado em vários identificadores de pacote e bundle no código do plugin gerado.

Por padrão, o projeto de plugin usa Swift para código iOS e Kotlin para código Android. Se você preferir Objective-C ou Java, pode especificar o idioma iOS usando `-i` e o idioma Android usando `-a`. Escolha **uma** das seguintes opções:

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

Isso cria um projeto de plugin na pasta `hello` com o seguinte conteúdo especializado:

**`lib/hello.dart`**
: A API Dart para o plugin.

**`android/src/main/java/com/example/hello/HelloPlugin.kt`**
: A implementação específica da plataforma Android da API do plugin em Kotlin.

**`ios/Classes/HelloPlugin.m`**
: A implementação específica da plataforma iOS da API do plugin em Objective-C.

**`example/`**
: Um aplicativo Flutter que depende do plugin e ilustra como usá-lo.

### Passo 2: Implementar o pacote {:#edit-plugin-package}

Como um pacote de plugin contém código para várias plataformas escrito em várias linguagens de programação, algumas etapas específicas são necessárias para garantir uma experiência tranquila.

#### Passo 2a: Definir a API do pacote (.dart)

A API do pacote de plugin é definida em código Dart. Abra a pasta principal `hello/` em seu [editor Flutter][] favorito. Localize o arquivo `lib/hello.dart`.

#### Passo 2b: Adicionar código da plataforma Android (.kt/.java)

Recomendamos que você edite o código Android usando o Android Studio.

Antes de editar o código da plataforma Android no Android Studio, certifique-se primeiro de que o código foi construído pelo menos uma vez (em outras palavras, execute o aplicativo de exemplo do seu IDE/editor ou em um terminal execute `cd hello/example; flutter build apk --config-only`).

Em seguida, use os seguintes passos:

1. Inicie o Android Studio.
2. Selecione **Open an existing Android Studio Project** na caixa de diálogo **Welcome to Android Studio**, ou selecione **File > Open** no menu e selecione o arquivo `hello/example/android/build.gradle`.
3. Na caixa de diálogo **Gradle Sync**, selecione **OK**.
4. Na caixa de diálogo **Android Gradle Plugin Update**, selecione **Don't remind me again for this project**.

O código da plataforma Android do seu plugin está localizado em `hello/java/com.example.hello/HelloPlugin`.

Você pode executar o aplicativo de exemplo no Android Studio pressionando o botão executar (&#9654;).

#### Passo 2c: Adicionar código da plataforma iOS (.swift/.h+.m)

Recomendamos que você edite o código iOS usando o Xcode.

Antes de editar o código da plataforma iOS no Xcode, certifique-se primeiro de que o código foi construído pelo menos uma vez (em outras palavras, execute o aplicativo de exemplo do seu IDE/editor ou em um terminal execute `cd hello/example; flutter build ios --no-codesign --config-only`).

Em seguida, use os seguintes passos:

1. Inicie o Xcode.
2. Selecione **File > Open** e selecione o arquivo `hello/example/ios/Runner.xcworkspace`.

O código da plataforma iOS para o seu plugin está localizado em `Pods/Development Pods/hello/../../example/ios/.symlinks/plugins/hello/ios/Classes` no Project Navigator. (Se você estiver usando `sharedDarwinSource`, o caminho terminará com `hello/darwin/Classes` em vez disso.)

Você pode executar o aplicativo de exemplo pressionando o botão executar (&#9654;).

##### Adicionar dependências CocoaPod

:::warning
O Flutter está migrando para o [Swift Package Manager][] para gerenciar as dependências nativas do iOS e macOS. O suporte do Flutter para o Swift Package Manager está em desenvolvimento. A implementação pode mudar no futuro. O suporte ao Swift Package Manager está disponível apenas no canal [`main`] do Flutter. O Flutter continua a suportar o CocoaPods.
:::

[Swift Package Manager]: https://www.swift.org/documentation/package-manager/
[`main` channel]: /release/upgrade#switching-flutter-channels

Use as seguintes instruções para adicionar `HelloPod` com a versão `0.0.1`:

1. Especifique a dependência no final de `ios/hello.podspec`:

   ```ruby
   s.dependency 'HelloPod', '0.0.1'
   ```

   Para pods privados, consulte [Private CocoaPods][] para garantir o acesso ao repositório:

   ```ruby
   s.source = {
       # Para pods hospedados no GitHub
       :git => "https://github.com/path/to/HelloPod.git",
       # Alternativamente, para pods hospedados localmente
       # :path => "file:///path/to/private/repo",
       :tag => s.version.to_s
     }`
   ```

[Private CocoaPods]: https://guides.cocoapods.org/making/private-cocoapods.html

2. Instalando o plugin

   - Adicione o plugin nas dependências `pubspec.yaml` do projeto.
   - Execute `flutter pub get`.
   - No diretório `ios/` do projeto, execute `pod install`.

O pod deve aparecer no resumo da instalação.

Se o seu plugin exigir um manifesto de privacidade, por exemplo, se ele usar alguma **API de motivo obrigatório**, atualize o arquivo `PrivacyInfo.xcprivacy` para descrever o impacto na privacidade do seu plugin e adicione o seguinte na parte inferior do seu arquivo podspec:

```ruby
s.resource_bundles = {'your_plugin_privacy' => ['your_plugin/Sources/your_plugin/Resources/PrivacyInfo.xcprivacy']}
```

Para obter mais informações, consulte [Privacy manifest files][] no site de desenvolvedores da Apple.

[Privacy manifest files]: {{site.apple-dev}}/documentation/bundleresources/privacy_manifest_files

#### Passo 2d: Adicionar código da plataforma Linux (.h+.cc)

Recomendamos que você edite o código Linux usando um IDE com integração C++. As instruções abaixo são para Visual Studio Code com as extensões "C/C++" e "CMake" instaladas, mas podem ser ajustadas para outros IDEs.

Antes de editar o código da plataforma Linux em um IDE, certifique-se primeiro de que o código foi construído pelo menos uma vez (em outras palavras, execute o aplicativo de exemplo do seu IDE/editor Flutter ou em um terminal execute `cd hello/example; flutter build linux`).

Em seguida, use os seguintes passos:

1. Inicie o Visual Studio Code.
2. Abra o diretório `hello/example/linux/`.
3. Escolha **Yes** no prompt perguntando: `Would you like to configure project "linux"?`. Isso permitirá que o autocomplete C++ funcione.

O código da plataforma Linux para o seu plugin está localizado em `flutter/ephemeral/.plugin_symlinks/hello/linux/`.

Você pode executar o aplicativo de exemplo usando `flutter run`. **Observação:** Criar um aplicativo Flutter executável no Linux requer etapas que fazem parte da ferramenta `flutter`, portanto, mesmo que seu editor forneça integração CMake, a construção e a execução dessa forma não funcionarão corretamente.

#### Passo 2e: Adicionar código da plataforma macOS (.swift)

Recomendamos que você edite o código macOS usando o Xcode.

Antes de editar o código da plataforma macOS no Xcode, certifique-se primeiro de que o código foi construído pelo menos uma vez (em outras palavras, execute o aplicativo de exemplo do seu IDE/editor ou em um terminal execute `cd hello/example; flutter build macos --config-only`).

Em seguida, use os seguintes passos:

1. Inicie o Xcode.
2. Selecione **File > Open** e selecione o arquivo `hello/example/macos/Runner.xcworkspace`.

O código da plataforma macOS para o seu plugin está localizado em `Pods/Development Pods/hello/../../example/macos/Flutter/ephemeral/.symlinks/plugins/hello/macos/Classes` no Project Navigator. (Se você estiver usando `sharedDarwinSource`, o caminho terminará com `hello/darwin/Classes` em vez disso.)

Você pode executar o aplicativo de exemplo pressionando o botão executar (&#9654;).

#### Passo 2f: Adicionar código da plataforma Windows (.h+.cpp)

Recomendamos que você edite o código Windows usando o Visual Studio.

Antes de editar o código da plataforma Windows no Visual Studio, certifique-se primeiro de que o código foi construído pelo menos uma vez (em outras palavras, execute o aplicativo de exemplo do seu IDE/editor ou em um terminal execute `cd hello/example; flutter build windows`).

Em seguida, use os seguintes passos:

1. Inicie o Visual Studio.
2. Selecione **Open a project or solution** e selecione o arquivo `hello/example/build/windows/hello_example.sln`.

O código da plataforma Windows para o seu plugin está localizado em `hello_plugin/Source Files` e `hello_plugin/Header Files` no Solution Explorer.

Você pode executar o aplicativo de exemplo clicando com o botão direito em `hello_example` no Solution Explorer e selecionando **Set as Startup Project**, em seguida, pressionando o botão executar (&#9654;). **Importante:** Depois de fazer alterações no código do plugin, você deve selecionar **Build > Build Solution** antes de executar novamente, caso contrário, uma cópia desatualizada do plugin construído será executada em vez da versão mais recente contendo suas alterações.

#### Passo 2g: Conectar a API e o código da plataforma

Finalmente, você precisa conectar a API escrita em código Dart com as implementações específicas da plataforma. Isso é feito usando um [canal de plataforma][], ou através das interfaces definidas em um pacote de interface de plataforma.

### Adicionar suporte para plataformas em um projeto de plugin existente

Para adicionar suporte para plataformas específicas a um projeto de plugin existente, execute `flutter create` com o sinalizador `--template=plugin` novamente no diretório do projeto. Por exemplo, para adicionar suporte à web em um plugin existente, execute:

```console
$ flutter create --template=plugin --platforms=web .
```

Se este comando exibir uma mensagem sobre a atualização do arquivo `pubspec.yaml`, siga as instruções fornecidas.

### Implementações de plataforma Dart

Em muitos casos, as implementações de plataforma não web usam apenas a linguagem de implementação específica da plataforma, conforme mostrado acima. No entanto, as implementações de plataforma também podem usar o Dart específico da plataforma.

:::note
Os exemplos abaixo se aplicam apenas a plataformas não web. As implementações de plugin da web são sempre escritas em Dart e usam `pluginClass` e `fileName` para suas implementações Dart, conforme mostrado acima.
:::

#### Implementações de plataforma somente Dart

Em alguns casos, algumas plataformas podem ser implementadas inteiramente em Dart (por exemplo, usando FFI). Para uma implementação de plataforma somente Dart em uma plataforma diferente da web, substitua `pluginClass` em pubspec.yaml por `dartPluginClass`. Aqui está o exemplo `hello_windows` acima modificado para uma implementação somente Dart:

```yaml
flutter:
  plugin:
    implements: hello
    platforms:
      windows:
        dartPluginClass: HelloPluginWindows
```

Nesta versão, você não teria código C++ do Windows e, em vez disso, faria uma subclasse da classe de interface de plataforma Dart do plugin `hello` com uma classe `HelloPluginWindows` que inclui um método estático `registerWith()`. Este método é chamado durante a inicialização e pode ser usado para registrar a implementação Dart:

```dart
class HelloPluginWindows extends HelloPluginPlatform {
  /// Registra esta classe como a instância padrão de [HelloPluginPlatform].
  static void registerWith() {
    HelloPluginPlatform.instance = HelloPluginWindows();
  }
```

#### Implementações de plataforma híbrida

As implementações de plataforma também podem usar Dart e uma linguagem específica da plataforma. Por exemplo, um plugin pode usar um canal de plataforma diferente para cada plataforma para que os canais possam ser personalizados por plataforma.

Uma implementação híbrida usa ambos os sistemas de registro descritos acima. Aqui está o exemplo `hello_windows` acima modificado para uma implementação híbrida:

```yaml
flutter:
  plugin:
    implements: hello
    platforms:
      windows:
        dartPluginClass: HelloPluginWindows
        pluginClass: HelloPlugin
```

A classe Dart `HelloPluginWindows` usaria o `registerWith()` mostrado acima para implementações somente Dart, enquanto a classe C++ `HelloPlugin` seria a mesma de uma implementação somente C++.

### Testar seu plugin

Incentivamos você a testar seu plugin com testes automatizados para garantir que a funcionalidade não regrida conforme você faz alterações em seu código.

Para saber mais sobre como testar seus plugins, consulte [Testando plugins][]. Se você estiver escrevendo testes para seu aplicativo Flutter e os plugins estiverem causando falhas, consulte [Flutter em testes de plugin][].

[Flutter in plugin tests]: /testing/plugins-in-tests
[Testing plugins]: /testing/testing-plugins

## Desenvolvimento de pacotes de plugin FFI {:#plugin-ffi}

Se você quiser desenvolver um pacote que chama APIs nativas usando o FFI do Dart, você precisa desenvolver um pacote de plugin FFI.

Tanto os pacotes de plugin FFI quanto os pacotes de plugin não FFI suportam o agrupamento de código nativo. No entanto, os pacotes de plugin FFI não suportam canais de método, mas _suportam_ código de registro de canal de método. Para implementar um plugin que usa canais de método _e_ FFI, use um plugin não FFI. Cada plataforma pode usar uma plataforma FFI ou não FFI.

### Passo 1: Criar o pacote

Para criar um pacote de plugin FFI inicial, use o sinalizador `--template=plugin_ffi` com `flutter create`:

```console
$ flutter create --template=plugin_ffi hello
```

Isso cria um projeto de plugin FFI na pasta `hello` com o seguinte conteúdo especializado:

**lib**: O código Dart que define a API do plugin e que chama o código nativo usando `dart:ffi`.

**src**: O código-fonte nativo e um arquivo `CMakeLists.txt` para criar esse código-fonte em uma biblioteca dinâmica.

**pastas de plataforma** (`android`, `ios`, `windows`, etc.): Os arquivos de compilação para construir e agrupar a biblioteca de código nativo com o aplicativo de plataforma.

### Passo 2: Construir e agrupar código nativo

O `pubspec.yaml` especifica plugins FFI da seguinte forma:

```yaml
  plugin:
    platforms:
      some_platform:
        ffiPlugin: true
```

Esta configuração invoca a compilação nativa para as várias plataformas de destino e agrupa os binários em aplicativos Flutter usando esses plugins FFI.

Isso pode ser combinado com `dartPluginClass`, como quando o FFI é usado para a implementação de uma plataforma em um plugin federado:

```yaml
  plugin:
    implements: some_other_plugin
    platforms:
      some_platform:
        dartPluginClass: SomeClass
        ffiPlugin: true
```

Um plugin pode ter FFI e canais de método:

```yaml
  plugin:
    platforms:
      some_platform:
        pluginClass: SomeName
        ffiPlugin: true
```

Os sistemas de compilação nativa que são invocados por plugins FFI (e canais de método) são:

* Para Android: Gradle, que invoca o Android NDK para compilações nativas.
   * Veja a documentação em `android/build.gradle`.
* Para iOS e macOS: Xcode, usando CocoaPods.
  * Veja a documentação em `ios/hello.podspec`.
  * Veja a documentação em `macos/hello.podspec`.
* Para Linux e Windows: CMake.
  * Veja a documentação em `linux/CMakeLists.txt`.
  * Veja a documentação em `windows/CMakeLists.txt`.

### Passo 3: Vinculando ao código nativo

Para usar o código nativo, são necessárias vinculações em Dart.

Para evitar escrevê-los manualmente, eles são gerados a partir do arquivo de cabeçalho (`src/hello.h`) por [`package:ffigen`][]. Consulte os [docs ffigen][] para obter informações sobre como instalar este pacote.

Para regenerar as vinculações, execute o seguinte comando:

```console
$ dart run ffigen --config ffigen.yaml
```

### Passo 4: Invocando o código nativo

Funções nativas de execução muito curta podem ser invocadas diretamente de qualquer isolate. Para um exemplo, veja `sum` em `lib/hello.dart`.

Funções de execução mais longa devem ser invocadas em um [isolate auxiliar][] para evitar quedas de frames em aplicativos Flutter. Para um exemplo, veja `sumAsync` em `lib/hello.dart`.

## Adicionando documentação

É uma prática recomendada adicionar a seguinte documentação a todos os pacotes:

1. Um arquivo `README.md` que apresenta o pacote
2. Um arquivo `CHANGELOG.md` que documenta as mudanças em cada versão
3. Um arquivo [`LICENSE`] contendo os termos sob os quais o pacote é licenciado
4. Documentação da API para todas as APIs públicas (veja abaixo para detalhes)

### Documentação da API

Quando você publica um pacote, a documentação da API é gerada automaticamente e publicada em pub.dev/documentation. Por exemplo, veja os docs para [`device_info_plus`][].

Se você deseja gerar documentação da API localmente em sua máquina de desenvolvimento, use os seguintes comandos:

<ol>
<li>

Mude o diretório para o local do seu pacote:

```console
cd ~/dev/meupacote
```

</li>

<li>

Diga à ferramenta de documentação onde o Flutter SDK está localizado (altere os seguintes comandos para refletir onde você o colocou):

```console
   export FLUTTER_ROOT=~/dev/flutter  # no macOS ou Linux

   set FLUTTER_ROOT=~/dev/flutter     # no Windows
```
</li>

<li>Execute a ferramenta `dart doc` (incluída como parte do Flutter SDK), da seguinte forma:

```console
   $FLUTTER_ROOT/bin/cache/dart-sdk/bin/dart doc   # no macOS ou Linux

   %FLUTTER_ROOT%\bin\cache\dart-sdk\bin\dart doc  # no Windows
```
</li>
</ol>

Para dicas sobre como escrever documentação da API, consulte [Documentação Dart Eficaz][].

### Adicionando licenças ao arquivo LICENSE

As licenças individuais dentro de cada arquivo LICENSE devem ser separadas por 80 hífens em sua própria linha.

Se um arquivo LICENSE contiver mais de uma licença de componente, cada licença de componente deverá começar com os nomes dos pacotes aos quais a licença do componente se aplica, com cada nome de pacote em sua própria linha, e a lista de nomes de pacotes separados do texto da licença real por uma linha em branco. (Os pacotes não precisam corresponder aos nomes do pacote pub. Por exemplo, um pacote pode conter código de várias fontes de terceiros e pode precisar incluir uma licença para cada um.)

O exemplo a seguir mostra um arquivo de licença bem organizado:

```plaintext
pacote_1

<algum texto de licença>

--------------------------------------------------------------------------------
pacote_2

<algum texto de licença>
```

Aqui está outro exemplo de um arquivo de licença bem organizado:

```plaintext
pacote_1

<algum texto de licença>

--------------------------------------------------------------------------------
pacote_1
pacote_2

<algum texto de licença>
```

Aqui está um exemplo de um arquivo de licença mal organizado:

```plaintext
<algum texto de licença>

--------------------------------------------------------------------------------
<algum texto de licença>
```

Outro exemplo de um arquivo de licença mal organizado:

```plaintext
pacote_1

<algum texto de licença>
--------------------------------------------------------------------------------
<algum texto de licença>
```

## Publicando seu pacote {:#publish}

:::tip
Você percebeu que alguns dos pacotes e plugins no pub.dev são designados como [Flutter Favorites][]? Estes são os pacotes publicados por desenvolvedores verificados e são identificados como os pacotes e plugins que você deve considerar usar primeiro ao escrever seu aplicativo. Para saber mais, veja o [programa Flutter Favorites][].
:::

Depois de implementar um pacote, você pode publicá-lo no [pub.dev][], para que outros desenvolvedores possam usá-lo facilmente.

Antes de publicar, certifique-se de revisar os arquivos `pubspec.yaml`, `README.md` e `CHANGELOG.md` para garantir que seu conteúdo esteja completo e correto. Além disso, para melhorar a qualidade e a usabilidade do seu pacote (e para torná-lo mais propenso a atingir o status de um Flutter Favorite), considere incluir os seguintes itens:

* Exemplos diversos de uso do código
* Capturas de tela, gifs animados ou vídeos
* Um link para o repositório de código correspondente

Em seguida, execute o comando de publicação no modo `dry-run` para ver se tudo passa na análise:

```console
$ flutter pub publish --dry-run
```

A próxima etapa é publicar no pub.dev, mas certifique-se de que você está pronto porque [publicar é para sempre][]:

```console
$ flutter pub publish
```

Para obter mais detalhes sobre a publicação, consulte os [docs de publicação][] em dart.dev.

## Tratamento de interdependências de pacotes {:#dependencies}

Se você estiver desenvolvendo um pacote `hello` que depende da API Dart exposta por outro pacote, você precisa adicionar esse pacote à seção `dependencies` do seu arquivo `pubspec.yaml`. O código abaixo torna a API Dart do plugin `url_launcher` disponível para `hello`:

```yaml
dependencies:
  url_launcher: ^5.0.0
```

Agora você pode `import 'package:url_launcher/url_launcher.dart'` e `launch(someUrl)` no código Dart de `hello`.

Isso não é diferente de como você inclui pacotes em aplicativos Flutter ou qualquer outro projeto Dart.

Mas se `hello` for um pacote de _plugin_ cujo código específico da plataforma precisa de acesso às APIs específicas da plataforma expostas por `url_launcher`, você também precisa adicionar declarações de dependência adequadas aos seus arquivos de compilação específicos da plataforma, conforme mostrado abaixo.

### Android

O exemplo a seguir define uma dependência para `url_launcher` em `hello/android/build.gradle`:

```groovy
android {
    // linhas ignoradas
    dependencies {
        compileOnly rootProject.findProject(":url_launcher")
    }
}
```

Agora você pode `import io.flutter.plugins.urllauncher.UrlLauncherPlugin` e acessar a classe `UrlLauncherPlugin` no código-fonte em `hello/android/src`.

Para obter mais informações sobre arquivos `build.gradle`, consulte a [Documentação do Gradle][] sobre scripts de compilação.

### iOS

O exemplo a seguir define uma dependência para `url_launcher` em `hello/ios/hello.podspec`:

```ruby
Pod::Spec.new do |s|
  # linhas ignoradas
  s.dependency 'url_launcher'
```

Agora você pode `#import "UrlLauncherPlugin.h"` e acessar a classe `UrlLauncherPlugin` no código-fonte em `hello/ios/Classes`.

Para obter detalhes adicionais sobre arquivos `.podspec`, consulte a [Documentação do CocoaPods][].

### Web

Todas as dependências da web são tratadas pelo arquivo `pubspec.yaml`, como qualquer outro pacote Dart.

{% comment %}
<!-- Remover até termos um texto melhor. -->
### MacOS

PENDENTE
{% endcomment %}

[Documentação do CocoaPods]: https://guides.cocoapods.org/syntax/podspec.html  
[pacote de biblioteca Dart]: {{site.dart-site}}/guides/libraries/create-library-packages  
[`device_info_plus`]: {{site.pub-api}}/device_info_plus  
[Documentação Dart Eficaz]: {{site.dart-site}}/guides/language/effective-dart/documentation  
[federated plugins]: #federated-plugins  
[docs ffigen]: {{site.pub-pkg}}/ffigen/install  
[Android]: /platform-integration/android/c-interop  
[iOS]: /platform-integration/ios/c-interop  
[macOS]: /platform-integration/macos/c-interop  
[`fluro`]: {{site.pub}}/packages/fluro  
[editor Flutter]: /get-started/editor  
[Flutter Favorites]: {{site.pub}}/flutter/favorites  
[programa Flutter Favorites]: /packages-and-plugins/favorites  
[Documentação do Gradle]: https://docs.gradle.org/current/userguide/tutorial_using_tasks.html  
[isolate auxiliar]: {{site.dart-site}}/guides/language/concurrency#background-workers  
[How to Write a Flutter Web Plugin, Part 1]: {{site.flutter-medium}}/how-to-write-a-flutter-web-plugin-5e26c689ea1  
[How To Write a Flutter Web Plugin, Part 2]: {{site.flutter-medium}}/how-to-write-a-flutter-web-plugin-part-2-afdddb69ece6  
[issue #33302]: {{site.repo.flutter}}/issues/33302  
[`LICENSE`]: #adding-licenses-to-the-license-file  
[`path`]: {{site.pub}}/packages/path  
[`package:ffigen`]: {{site.pub}}/packages/ffigen  
[canal de plataforma]: /platform-integration/platform-channels  
[pub.dev]: {{site.pub}}  
[docs de publicação]: {{site.dart-site}}/tools/pub/publishing  
[publicar é para sempre]: {{site.dart-site}}/tools/pub/publishing#publishing-is-forever  
[supported-platforms]: #plugin-platforms  
[Testando plugins]: #testing-your-plugin  
[Flutter em testes de plugin]: {{site.flutter-medium}}/writing-a-good-flutter-plugin-1a561b986c9c  
[unit tests]: /testing/overview#unit-tests  
[`url_launcher`]: {{site.pub}}/packages/url_launcher  
[Writing a good plugin]: {{site.flutter-medium}}/writing-a-good-flutter-plugin-1a561b986c9c  
