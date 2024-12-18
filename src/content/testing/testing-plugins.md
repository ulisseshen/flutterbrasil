---
title: Testando plugins
description: Aprenda como testar seu pacote de plugin.
ia-translate: true
---

Todos os [tipos usuais de testes do Flutter][] se aplicam a pacotes de plugin também, mas como plugins contêm código nativo, eles geralmente também requerem outros tipos de testes para testar toda a sua funcionalidade.

[tipos usuais de testes do Flutter]: /testing/overview

:::note
Para aprender como testar o código do seu plugin, continue lendo.
Para aprender como evitar falhas de um plugin ao
testar seu aplicativo Flutter, confira
[Plugins em testes Flutter][].
:::

[Plugins em testes Flutter]: /testing/plugins-in-tests

## Tipos de testes de plugin

Para ver exemplos de cada um desses tipos de testes, você pode
[criar um novo plugin a partir do template de plugin][plugin-tests]
e procurar nos diretórios indicados.

*   <strong>[Unit tests][] Dart e [widget tests][]</strong>.
    Esses testes permitem que você teste a parte Dart do seu plugin
    assim como você testaria o código Dart de um pacote não-plugin.
    No entanto, o código nativo do plugin [não será carregado][],
    portanto, quaisquer chamadas para canais de plataforma precisam ser [simuladas em testes][].

    Veja o diretório `test` para um exemplo.

*   <strong>[Integration tests][] Dart</strong>.
    Como os testes de integração são executados no contexto de um
    aplicativo Flutter (o app de exemplo),
    eles podem testar tanto o código Dart quanto o nativo,
    bem como a interação entre eles.
    Eles também são úteis para testar unitariamente o código de implementação web
    que precisa ser executado em um navegador.

    Esses são frequentemente os testes mais importantes para um plugin.
    No entanto, os testes de integração Dart não podem interagir com a UI nativa,
    como diálogos nativos ou o conteúdo de visualizações de plataforma.

    Veja o diretório `example/integration_test` para um exemplo.

*   <strong>Unit tests nativos.</strong>
    Assim como os testes unitários Dart podem testar as partes Dart
    de um plugin isoladamente, os testes unitários nativos podem
    testar as partes nativas isoladamente.
    Cada plataforma tem seu próprio sistema de teste unitário nativo,
    e os testes são escritos nas mesmas linguagens nativas
    que o código que está sendo testado.

    Testes unitários nativos podem ser especialmente valiosos
    se você precisar simular APIs envolvidas pelo código do seu plugin,
    o que não é possível em um teste de integração Dart.

    Você pode configurar e usar quaisquer frameworks de teste nativos
    com os quais você esteja familiarizado para cada plataforma,
    mas os seguintes já estão configurados no template de plugin:

    *   <strong>Android</strong>:
        Testes [JUnit][] podem ser encontrados em `android/src/test/`.

    *   <strong>iOS</strong> e <strong>macOS</strong>:
        Testes [XCTest][] podem ser encontrados em `example/ios/RunnerTests/`
        e `example/macos/RunnerTests/`, respectivamente.
        Estes estão no diretório de exemplo,
        não no diretório do pacote de nível superior,
        porque eles são executados através do projeto do aplicativo de exemplo.

    *   <strong>Linux</strong> e <strong>Windows</strong>:
        Testes [GoogleTest][] podem ser encontrados em `linux/test/`
        e `windows/test/`, respectivamente.

Outros tipos de testes, que não estão atualmente pré-configurados
no template, são <strong>testes de UI nativos</strong>.
Executar seu aplicativo sob um framework de teste de UI nativo,
como [Espresso][] ou [XCUITest][],
permite testes que interagem com elementos de UI nativos e Flutter,
portanto, pode ser útil se seu plugin não puder ser testado sem
interações de UI nativa.

[Espresso]: {{site.repo.packages}}/tree/main/packages/espresso
[GoogleTest]: {{site.github}}/google/googletest
[integration tests]: /cookbook/testing/integration/introduction
[JUnit]: {{site.github}}/junit-team/junit4/wiki/Getting-started
[simuladas em testes]: /testing/plugins-in-tests#mock-the-platform-channel
[plugin-tests]: /packages-and-plugins/developing-packages#step-1-create-the-package-1
[unit tests]: /cookbook/testing/unit/introduction
[widget tests]: /cookbook/testing/widget/introduction
[não será carregado]: /testing/plugins-in-tests
[XCTest]: {{site.apple-dev}}/documentation/xctest
[XCUITest]: {{site.apple-dev}}/library/archive/documentation/DeveloperTools/Conceptual/testing_with_xcode/chapters/09-ui_testing.html

## Executando testes

### Unit tests Dart

Estes podem ser executados como quaisquer outros testes unitários do Flutter,
seja a partir do seu IDE Flutter preferido,
ou usando `flutter test`.

### Testes de integração

Para obter informações sobre a execução desse tipo de teste, confira a
[documentação de testes de integração][].
Os comandos devem ser executados no diretório `example`.

[documentação de testes de integração]: /cookbook/testing/integration/introduction

### Unit tests nativos

Para todas as plataformas, você precisa compilar o aplicativo de exemplo
pelo menos uma vez antes de executar os testes unitários,
para garantir que todos os arquivos de compilação específicos da plataforma
tenham sido criados.

<strong>JUnit Android</strong><br>

Se você tiver o exemplo aberto como um projeto Android
no Android Studio, você pode executar os testes unitários usando
a [interface de testes do Android Studio][].

Para executar os testes a partir da linha de comando,
use o seguinte comando no diretório `example/android`:

```sh
./gradlew testDebugUnitTest
```

<strong>XCTest iOS e macOS</strong><br>

Se você tiver o aplicativo de exemplo aberto no Xcode,
você pode executar os testes unitários usando a [interface de teste do Xcode][].

Para executar os testes a partir da linha de comando,
use o seguinte comando no diretório `example/ios` (para iOS)
ou `example/macos` (para macOS):

```sh
xcodebuild test -workspace Runner.xcworkspace -scheme Runner -configuration Debug
```

Para testes iOS, você pode precisar primeiro abrir
`Runner.xcworkspace` no Xcode para configurar a assinatura de código.

<strong>GoogleTest Linux</strong><br>

Para executar os testes a partir da linha de comando,
use o seguinte comando no diretório de exemplo,
substituindo "my_plugin" pelo nome do projeto do seu plugin:

```sh
build/linux/plugins/x64/debug/my_plugin/my_plugin_test
```

Se você compilou o aplicativo de exemplo no modo release em vez de
debug, substitua "debug" por "release".

<strong>GoogleTest Windows</strong><br>

Se você tiver o aplicativo de exemplo aberto no Visual Studio,
você pode executar os testes unitários usando a [interface de teste do Visual Studio][].

Para executar os testes a partir da linha de comando,
use o seguinte comando no diretório de exemplo,
substituindo "my_plugin" pelo nome do projeto do seu plugin:

```sh
build/windows/plugins/my_plugin/Debug/my_plugin_test.exe
```

Se você compilou o aplicativo de exemplo no modo release em vez
de debug, substitua "Debug" por "Release".

## Quais tipos de testes adicionar

O [conselho geral para testar projetos Flutter][conselho geral]
se aplica a plugins também.
Algumas considerações extras para testar plugins:

*   Como apenas os testes de integração podem testar a comunicação
    entre Dart e as linguagens nativas,
    tente ter pelo menos um teste de integração de cada
    chamada de canal de plataforma.

*   Se alguns fluxos não puderem ser testados usando a integração
    testes — por exemplo, se eles exigirem interação com
    UI nativa ou simulação de estado do dispositivo — considere escrever
    testes "ponta a ponta" das duas metades usando unit tests:

    *   Unit tests nativos que configuram as simulações necessárias,
        então chamam o ponto de entrada do canal de método
        com uma chamada sintetizada e validam a resposta do método.

    *   Unit tests Dart que simulam o canal de plataforma,
        então chamam a API pública do plugin e validam os resultados.

[interface de testes do Android Studio]: {{site.android-dev}}/studio/test/test-in-android-studio
[conselho geral]: /testing/overview
[interface de teste do Visual Studio]: https://learn.microsoft.com/en-us/visualstudio/test/getting-started-with-unit-testing?view=vs-2022&tabs=dotnet%2Cmstest#run-unit-tests
[interface de teste do Xcode]: {{site.apple-dev}}/library/archive/documentation/DeveloperTools/Conceptual/testing_with_xcode/chapters/05-running_tests.html
