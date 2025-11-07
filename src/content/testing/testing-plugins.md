---
ia-translate: true
title: Testar plugins
description: Aprenda como testar seu pacote de plugin.
---

Todos os [tipos usuais de testes Flutter][usual types of Flutter tests] se aplicam a
pacotes de plugins também, mas como plugins contêm
código nativo, eles frequentemente também requerem outros tipos de testes
para testar toda sua funcionalidade.

[usual types of Flutter tests]: /testing/overview

:::note
Para aprender como testar o código do seu plugin, continue lendo.
Para aprender como evitar crashes de um plugin ao
testar seu app Flutter, confira
[Plugins in Flutter tests][].
:::

[Plugins in Flutter tests]: /testing/plugins-in-tests

## Tipos de testes de plugins

Para ver exemplos de cada um desses tipos de testes, você pode
[criar um novo plugin a partir do template de plugin][plugin-tests]
e olhar nos diretórios indicados.

* <strong>Dart [unit tests][] e [widget tests][]</strong>.
  Esses testes permitem que você teste a porção Dart do seu plugin
  assim como você testaria o código Dart de um pacote que não seja plugin.
  No entanto, o código nativo do plugin [não será carregado][won't be loaded],
  então quaisquer chamadas a canais de plataforma precisam ser [mockadas em testes][mocked in tests].

  Veja o diretório `test` para um exemplo.

* <strong>Dart [integration tests][]</strong>.
  Como integration tests executam no contexto de
  uma aplicação Flutter (o app de exemplo),
  eles podem testar tanto o código Dart quanto o nativo,
  bem como a interação entre eles.
  Eles também são úteis para unit testing de código de implementação web
  que precisa executar em um navegador.

  Esses são frequentemente os testes mais importantes para um plugin.
  No entanto, Dart integration tests não podem interagir com UI nativa,
  como diálogos nativos ou o conteúdo de platform views.

  Veja o diretório `example/integration_test` para um exemplo.

* <strong>Native unit tests.</strong>
  Assim como Dart unit tests podem testar as porções Dart
  de um plugin isoladamente, native unit tests podem
  testar as partes nativas isoladamente.
  Cada plataforma tem seu próprio sistema de unit test nativo,
  e os testes são escritos nas mesmas linguagens nativas
  que o código que está sendo testado.

  Native unit tests podem ser especialmente valiosos
  se você precisa mockar APIs envolvidas pelo código do seu plugin,
  o que não é possível em um Dart integration test.

  Você pode configurar e usar quaisquer frameworks de teste nativos
  com os quais você está familiarizado para cada plataforma,
  mas os seguintes já estão configurados no template de plugin:

  * <strong>Android</strong>:
    Testes [JUnit][] podem ser encontrados em `android/src/test/`.

  * <strong>iOS</strong> e <strong>macOS</strong>:
    Testes [XCTest][] podem ser encontrados em `example/ios/RunnerTests/`
    e `example/macos/RunnerTests/` respectivamente.
    Estes estão no diretório example,
    não no diretório do pacote de nível superior,
    porque eles são executados via projeto do app de exemplo.

  * <strong>Linux</strong> e <strong>Windows</strong>:
    Testes [GoogleTest][] podem ser encontrados em `linux/test/`
    e `windows/test/`, respectivamente.

Outros tipos de testes, que não estão atualmente pré-configurados
no template, são <strong>native UI tests</strong>.
Executar sua aplicação sob um framework de teste de UI nativo,
como [Espresso][] ou [XCUITest][],
habilita testes que interagem com elementos de UI tanto nativos quanto Flutter,
então podem ser úteis se seu plugin não pode ser testado sem
interações de UI nativa.


[Espresso]: {{site.repo.packages}}/tree/main/packages/espresso
[GoogleTest]: {{site.github}}/google/googletest
[integration tests]: /cookbook/testing/integration/introduction
[JUnit]: {{site.github}}/junit-team/junit4/wiki/Getting-started
[mocked in tests]: /testing/plugins-in-tests#mock-the-platform-channel
[plugin-tests]: /packages-and-plugins/developing-packages#step-1-create-the-package-1
[unit tests]: /cookbook/testing/unit/introduction
[widget tests]: /cookbook/testing/widget/introduction
[won't be loaded]: /testing/plugins-in-tests
[XCTest]: {{site.apple-dev}}/documentation/xctest
[XCUITest]: {{site.apple-dev}}/library/archive/documentation/DeveloperTools/Conceptual/testing_with_xcode/chapters/09-ui_testing.html

## Executar testes

### Dart unit tests

Esses podem ser executados como qualquer outro Flutter unit tests,
seja do seu IDE Flutter preferido,
ou usando `flutter test`.

### Integration tests

Para informações sobre execução deste tipo de teste, confira a
[documentação de integration test][integration test documentation].
Os comandos devem ser executados no diretório `example`.

[integration test documentation]: /cookbook/testing/integration/introduction

### Native unit tests

Para todas as plataformas, você precisa compilar a aplicação de exemplo
pelo menos uma vez antes de executar os unit tests,
para garantir que todos os arquivos de build
específicos da plataforma foram criados.

<strong>Android JUnit</strong><br>

Se você tem o exemplo aberto como um projeto Android
no Android Studio, você pode executar os unit tests usando
a [UI de teste do Android Studio][Android Studio test UI].

Para executar os testes da linha de comando,
use o seguinte comando no diretório `example/android`:

```sh
./gradlew testDebugUnitTest
```

<strong>iOS e macOS XCTest</strong><br>

Se você tem o app de exemplo aberto no Xcode,
você pode executar os unit tests usando a [UI de Teste do Xcode][Xcode Test UI].

Para executar os testes da linha de comando,
use o seguinte comando no diretório `example/ios` (para iOS)
ou `example/macos` (para macOS):

```sh
xcodebuild test -workspace Runner.xcworkspace -scheme Runner -configuration Debug
```

Para testes iOS, você pode precisar primeiro abrir
`Runner.xcworkspace` no Xcode para configurar a assinatura de código.

<strong>Linux GoogleTest</strong><br>

Para executar os testes da linha de comando,
use o seguinte comando no diretório example,
substituindo "my_plugin" pelo nome do projeto do seu plugin:

```sh
build/linux/plugins/x64/debug/my_plugin/my_plugin_test
```

Se você compilou o app de exemplo no modo release ao invés de
debug, substitua "debug" por "release".

<strong>Windows GoogleTest</strong><br>

Se você tem o app de exemplo aberto no Visual Studio,
você pode executar os unit tests usando a [UI de teste do Visual Studio][Visual Studio test UI].

Para executar os testes da linha de comando,
use o seguinte comando no diretório example,
substituindo "my_plugin" pelo nome do projeto do seu plugin:

```sh
build/windows/plugins/my_plugin/Debug/my_plugin_test.exe
```

Se você compilou o app de exemplo no modo release ao invés
de debug, substitua "Debug" por "Release".

## Quais tipos de testes adicionar

O [conselho geral para testar projetos Flutter][general advice]
se aplica a plugins também.
Algumas considerações extras para testes de plugins:

* Como apenas integration tests podem testar a comunicação
  entre Dart e as linguagens nativas,
  tente ter pelo menos um integration test de cada
  chamada de canal de plataforma.

* Se alguns fluxos não podem ser testados usando integration
  tests—por exemplo, se eles requerem interação com
  UI nativa ou mockar o estado do dispositivo—considere escrever
  testes "end to end" das duas metades usando unit tests:

  * Native unit tests que configuram os mocks necessários,
    então chamam o ponto de entrada do canal de método
    com uma chamada sintetizada e validam a resposta do método.

  * Dart unit tests que mockam o canal de plataforma,
    então chamam a API pública do plugin e validam os resultados.

[Android Studio test UI]: {{site.android-dev}}/studio/test/test-in-android-studio
[general advice]: /testing/overview
[Visual Studio test UI]: https://learn.microsoft.com/en-us/visualstudio/test/getting-started-with-unit-testing?view=vs-2022&tabs=dotnet%2Cmstest#run-unit-tests
[Xcode Test UI]: {{site.apple-dev}}/library/archive/documentation/DeveloperTools/Conceptual/testing_with_xcode/chapters/05-running_tests.html
