---
ia-translate: true
title: Verifique a funcionalidade do app com um teste de integração
description: Aprenda como escrever testes de integração
---

<?code-excerpt path-base="testing/integration_tests/how_to"?>

Esta receita descreve como usar o
pacote [`integration_test`][] para executar testes de integração.
O Flutter SDK inclui o pacote `integration_test`.
Testes de integração usando este pacote têm as seguintes
propriedades.

* Use o comando `flutter drive` para executar testes
  em um dispositivo físico ou emulador.
* Execute no [Firebase Test Lab][],
  para automatizar testes em uma variedade de dispositivos.
* Use APIs do [flutter_test][] para permitir que testes sejam escritos em um estilo similar aos [widget tests][]

Nesta receita, aprenda como testar um app contador.

* como configurar testes de integração
* como verificar se um app exibe texto específico
* como tocar em widgets específicos
* como executar testes de integração

Esta receita usa os seguintes passos:

  1. Criar um app para testar.
  2. Adicionar a dependência `integration_test`.
  3. Criar os arquivos de teste.
  4. Escrever o teste de integração.
  5. Executar o teste de integração.

## Criar um novo app para testar

Testes de integração requerem um app para testar.
Este exemplo usa o exemplo integrado **Counter App**
que o Flutter produz quando você executa o comando `flutter create`.
O app contador permite que um usuário toque em um botão para aumentar um contador.

1. Para criar uma instância do app Flutter integrado,
   execute o seguinte comando no seu terminal:

   ```console
   $ flutter create counter_app
   ```

1. Mude para o diretório `counter_app`.

1. Abra `lib/main.dart` no seu IDE preferido.

1. Adicione um parâmetro `key` ao widget `floatingActionButton()`
   com uma instância de uma classe `Key` com um valor de string `increment`.

   ```dart
    floatingActionButton: FloatingActionButton(
      [!key: const ValueKey('increment'),!]
      onPressed: _incrementCounter,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    ),
   ```

1. Salve o seu arquivo `lib/main.dart`.

Após essas mudanças,
o arquivo `lib/main.dart` deve se parecer com o código a seguir.

<?code-excerpt "lib/main.dart"?>
```dart title="lib/main.dart"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Counter App',
      home: MyHomePage(title: 'Counter App Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Provide a Key to this button. This allows finding this
        // specific button inside the test suite, and tapping it.
        key: const Key('increment'),
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## Adicionar a dependência `integration_test`

Você precisa adicionar os pacotes de teste ao seu novo app.

Para adicionar os pacotes `integration_test` e `flutter_test` como
`dev_dependencies` usando `sdk: flutter`, execute o seguinte comando.

```console
$ flutter pub add 'dev:integration_test:{"sdk":"flutter"}'
```

Saída:

```console
Building flutter tool...
Resolving dependencies...
Got dependencies.
Resolving dependencies...
+ file 7.0.0
+ flutter_driver 0.0.0 from sdk flutter
+ fuchsia_remote_debug_protocol 0.0.0 from sdk flutter
+ integration_test 0.0.0 from sdk flutter
...
  test_api 0.6.1 (0.7.1 available)
  vm_service 13.0.0 (14.2.1 available)
+ webdriver 3.0.3
Changed 8 dependencies!
7 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
```

Arquivo `pubspec.yaml` atualizado:

```yaml title="pubspec.yaml"
# ...
dev_dependencies:
  # ... added dependencies
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  [!integration_test:!]
    [!sdk: flutter!]
# ...
```

## Criar os arquivos de teste de integração

Testes de integração residem em um diretório separado dentro
do seu projeto Flutter.

1. Crie um novo diretório chamado `integration_test`.
1. Adicione um arquivo vazio chamado `app_test.dart` nesse diretório.

A árvore de diretórios resultante deve se parecer com o seguinte:

```plaintext
counter_app/
  lib/
    main.dart
  integration_test/
    app_test.dart
```

## Escrever o teste de integração

O arquivo de teste de integração consiste em um arquivo de código Dart
com dependências em `integration_test`, `flutter_test`,
e o arquivo Dart do seu app.

1. Abra o seu arquivo `integration_test/app_test.dart` no seu IDE preferido.

1. Copie o código a seguir e cole-o no seu
   arquivo `integration_test/app_test.dart`.
   O último import deve apontar para o arquivo `main.dart`
   do seu `counter_app`.
   (Este `import` aponta para o app de exemplo chamado `introduction`.)

    <?code-excerpt "integration_test/counter_test.dart (initial)" replace="/introduction/counter_app/g"?>
    ```dart title="integration_test/counter_test.dart"
    import 'package:flutter/material.dart';
    import 'package:flutter_test/flutter_test.dart';
    import 'package:how_to/main.dart';
    import 'package:integration_test/integration_test.dart';
    
    void main() {
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    
      group('end-to-end test', () {
        testWidgets('tap on the floating action button, verify counter',
            (tester) async {
          // Load app widget.
          await tester.pumpWidget(const MyApp());
    
          // Verify the counter starts at 0.
          expect(find.text('0'), findsOneWidget);
    
          // Finds the floating action button to tap on.
          final fab = find.byKey(const ValueKey('increment'));
    
          // Emulate a tap on the floating action button.
          await tester.tap(fab);
    
          // Trigger a frame.
          await tester.pumpAndSettle();
    
          // Verify the counter increments by 1.
          expect(find.text('1'), findsOneWidget);
        });
      });
    }
    ```

Este exemplo passa por três etapas:

1. Inicializar `IntegrationTestWidgetsFlutterBinding`.
   Este serviço singleton executa testes em um dispositivo físico.

2. Interagir e testar widgets usando a classe `WidgetTester`.

3. Testar os cenários importantes.

## Executar testes de integração

Os testes de integração executados variam dependendo da
plataforma na qual você testa.

* Para testar uma plataforma desktop, use a linha de comando ou um sistema de CI.
* Para testar uma plataforma mobile, use a linha de comando ou Firebase Test Lab.
* Para testar em um navegador web, use a linha de comando.

---

### Testar em uma plataforma desktop

<details markdown="1">
<summary>Expandir se você testa apps Linux usando um sistema de CI</summary>

Para testar um app Linux, seu sistema de CI deve invocar um servidor X primeiro.
No GitHub Action, GitLab Runner ou arquivo de configuração similar,
configure o teste de integração para funcionar _com_ a ferramenta `xvfb-run`.

Fazer isso invoca um sistema X Window no qual o Flutter pode
iniciar e testar seu app Linux.

Como exemplo usando GitHub Actions, seu `jobs.setup.steps` deve
incluir um passo semelhante ao seguinte:

```yaml
      - name: Run Integration Tests
        uses: username/xvfb-action@v1.1.2
        with:
          run: flutter test integration_test -d linux -r github
```

Isso inicia o teste de integração dentro de uma X Window.

Se você não configurar sua integração dessa forma,
o Flutter retorna um erro.

```console
Building Linux application...
Error waiting for a debug connection: The log reader stopped unexpectedly, or never started.
```

</details>

Para testar em uma plataforma macOS, Windows ou Linux,
complete as seguintes tarefas.

1. Execute o seguinte comando a partir da raiz do projeto.

   ```console
   $ flutter test integration_test/app_test.dart
   ```

1. Se for oferecida uma escolha de plataforma para testar,
   escolha a plataforma desktop.
   Digite `1` para escolher a plataforma desktop.

Com base na plataforma, o resultado do comando deve se parecer com a seguinte saída.

{% tabs %}
{% tab "Windows" %}

{% render docs/test/integration/windows-example.md %}

{% endtab %}
{% tab "macOS" %}

{% render docs/test/integration/macos-example.md %}

{% endtab %}
{% tab "Linux" %}

{% render docs/test/integration/linux-example.md %}

{% endtab %}
{% endtabs %}

---

### Testar em um dispositivo mobile

Para testar em um dispositivo iOS ou Android real,
complete as seguintes tarefas.

1. Conecte o dispositivo.

1. Execute o seguinte comando a partir da raiz do projeto.

   ```console
   $ flutter test integration_test/app_test.dart
   ```

   O resultado deve se parecer com a seguinte saída. Este exemplo usa iOS.

   ```console
   $ flutter test integration_test/app_test.dart
   00:04 +0: loading /path/to/counter_app/integration_test/app_test.dart
   00:15 +0: loading /path/to/counter_app/integration_test/app_test.dart
   00:18 +0: loading /path/to/counter_app/integration_test/app_test.dart   2,387ms
   Xcode build done.                                           13.5s
   00:21 +1: All tests passed!
   ```

1. Verifique se o teste removeu o Counter App quando terminou.
   Caso contrário, testes subsequentes falham. Se necessário, pressione no app e escolha
   **Remove App** do menu de contexto.

---

<a id="test-in-a-web-browser"></a>
### Testar em um navegador web

{% comment %}
TODO(ryjohn): Add back after other WebDriver versions are supported:
https://github.com/flutter/flutter/issues/90158

To test for web,
determine which browser you want to test against
and download the corresponding web driver:

* Chrome: Download [ChromeDriver][]
* Firefox: [Download GeckoDriver][]
* Safari: Safari can only be tested on a Mac;
  the SafariDriver is already installed on Mac machines.
* Edge [Download EdgeDriver][]
{% endcomment -%}

Para testar em um navegador web, execute os seguintes passos.

1. Instale [ChromeDriver][] no diretório de sua escolha.

   ```console
   $ npx @puppeteer/browsers install chromedriver@stable
   ```

   Para simplificar a instalação, este comando usa a
   biblioteca Node [`@puppeteer/browsers`][puppeteer].

   [puppeteer]: https://www.npmjs.com/package/@puppeteer/browsers

1. Adicione o caminho para ChromeDriver à sua variável de ambiente `$PATH`.

1. Verifique se a instalação do ChromeDriver foi bem-sucedida.

   ```console
   $ chromedriver --version
   ChromeDriver 124.0.6367.60 (8771130bd84f76d855ae42fbe02752b03e352f17-refs/branch-heads/6367@{:#798})
   ```

1. No diretório do projeto `counter_app`,
   crie um novo diretório chamado `test_driver`.

   ```console
   $ mkdir test_driver
   ```

1. Neste diretório, crie um novo arquivo chamado `integration_test.dart`.

1. Copie o código a seguir e cole-o no seu arquivo `integration_test.dart`.

   <?code-excerpt "test_driver/integration_test.dart"?>
   ```dart title="test_driver/integration_test.dart"
   import 'package:integration_test/integration_test_driver.dart';
   
   Future<void> main() => integrationDriver();
   ```

1. Inicie `chromedriver` da seguinte forma:

   ```console
   $ chromedriver --port=4444
   ```

1. A partir da raiz do projeto, execute o seguinte comando:

   ```console
   $ flutter drive \
     --driver=test_driver/integration_test.dart \
     --target=integration_test/app_test.dart \
     -d chrome
   ```

   A resposta deve se parecer com a seguinte saída:

   ```console
   Resolving dependencies...
     leak_tracker 10.0.0 (10.0.5 available)
     leak_tracker_flutter_testing 2.0.1 (3.0.5 available)
     leak_tracker_testing 2.0.1 (3.0.1 available)
     material_color_utilities 0.8.0 (0.11.1 available)
     meta 1.11.0 (1.14.0 available)
     test_api 0.6.1 (0.7.1 available)
     vm_service 13.0.0 (14.2.1 available)
   Got dependencies!
   7 packages have newer versions incompatible with dependency constraints.
   Try `flutter pub outdated` for more information.
   Launching integration_test/app_test.dart on Chrome in debug mode...
   Waiting for connection from debug service on Chrome...             10.9s
   This app is linked to the debug service: ws://127.0.0.1:51523/3lofIjIdmbs=/ws
   Debug service listening on ws://127.0.0.1:51523/3lofIjIdmbs=/ws
   00:00 +0: end-to-end test tap on the floating action button, verify counter
   00:01 +1: (tearDownAll)
   00:01 +2: All tests passed!
   All tests passed.
   Application finished.
   ```

   Para executar isso como um teste headless, execute `flutter drive`
   com a opção `-d web-server`:

   ```console
   $ flutter drive \
     --driver=test_driver/integration_test.dart \
     --target=integration_test/app_test.dart \
     -d web-server
   ```

Para saber mais, consulte a página wiki
[Running Flutter driver tests with web][].

---

### Testar usando o Firebase Test Lab

Para testar ambos os targets Android e iOS,
você pode usar o Firebase Test Lab.

#### Configuração Android

Siga as instruções na seção [Android Device Testing][]
do README.

#### Configuração iOS

Siga as instruções na seção [iOS Device Testing][]
do README.

#### Configuração do projeto Test Lab

1. Inicie o seu [Firebase Console][].

1. Crie um novo projeto Firebase se necessário.

1. Navegue até **Quality > Test Lab**.

   <img src='/assets/images/docs/integration-test/test-lab-1.png' class="mw-100" alt="Firebase Test Lab Console">

#### Fazer upload de um APK Android

1. Crie um APK usando Gradle.

   ```console
   $ pushd android
   # flutter build generates files in android/ for building the app
   flutter build apk
   ./gradlew app:assembleAndroidTest
   ./gradlew app:assembleDebug -Ptarget=integration_test/<name>_test.dart
   $ popd
   ```

   Onde `<name>_test.dart` é o arquivo criado na
   seção **Project Setup**.

:::note
Para usar `--dart-define` com `gradlew`:

1. Codifique todos os parâmetros com `base64`.
1. Passe os parâmetros para gradle em uma lista separada por vírgulas.

   ```console
   ./gradlew project:task -Pdart-defines="{base64   (key=value)},[...]"
   ```

:::

Para iniciar um teste Robo e executar outros testes, arraste o APK "debug" de
`<flutter_project_directory>/build/app/outputs/apk/debug`
para o target **Android Robo Test** na página web.

<img src='/assets/images/docs/integration-test/test-lab-2.png' class="mw-100" alt="Firebase Test Lab upload">

1. Clique em **Run a test**.

1. Selecione o tipo de teste **Instrumentation**.

1. Adicione o App APK à caixa **App APK or AAB**.

   `<flutter_project_directory>/build/app/outputs/apk/debug/<file>.apk`

1. Adicione o Test APK à caixa **Test APK**.

   `<flutter_project_directory>/build/app/outputs/apk/androidTest/debug/<file>.apk`

<img src='/assets/images/docs/integration-test/test-lab-3.png' class="mw-100" alt="Firebase Test Lab upload two APKs">

Se ocorrer uma falha, clique no ícone vermelho para ver a saída:

<img src='/assets/images/docs/integration-test/test-lab-4.png' class="mw-100" alt="Firebase Test Lab test results">

#### Fazer upload de um APK Android pela linha de comando

Consulte a [seção Firebase Test Lab do README][Firebase Test Lab section of the README]
para instruções sobre como fazer upload dos APKs pela linha de comando.

#### Fazer upload de testes Xcode

Para aprender como fazer upload do arquivo .zip,
consulte as [instruções do Firebase TestLab iOS][Firebase TestLab iOS instructions]
na seção Firebase TestLab do Firebase Console.

#### Fazer upload de testes Xcode pela linha de comando

Para aprender como fazer upload do arquivo .zip pela linha de comando,
consulte a seção [iOS Device Testing][] no README.

[`integration_test`]: {{site.repo.flutter}}/tree/main/packages/integration_test#integration_test
[Android Device Testing]: {{site.repo.flutter}}/tree/main/packages/integration_test#android-device-testing
[ChromeDriver]: https://googlechromelabs.github.io/chrome-for-testing/
[Download EdgeDriver]: https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/
[Download GeckoDriver]: {{site.github}}/mozilla/geckodriver/releases
[Firebase Console]: http://console.firebase.google.com/
[Firebase Test Lab section of the README]: {{site.repo.flutter}}/tree/main/packages/integration_test#firebase-test-lab
[Firebase Test Lab]: {{site.firebase}}/docs/test-lab
[Firebase TestLab iOS instructions]: {{site.firebase}}/docs/test-lab/ios/firebase-console
[flutter_test]: {{site.api}}/flutter/flutter_test/flutter_test-library.html
[Integration testing]: /testing/integration-tests
[iOS Device Testing]: {{site.repo.flutter}}/tree/main/packages/integration_test#ios-device-testing
[Running Flutter driver tests with web]: {{site.repo.flutter}}/blob/main/docs/contributing/testing/Running-Flutter-Driver-tests-with-Web.md
[widget tests]: /testing/overview#widget-tests

[flutter_driver]: {{site.api}}/flutter/flutter_driver/flutter_driver-library.html
[integration_test usage]: {{site.repo.flutter}}/tree/main/packages/integration_test#usage
[samples]: {{site.repo.samples}}
[testing_app]: {{site.repo.samples}}/tree/main/testing_app/integration_test
[testWidgets]: {{site.api}}/flutter/flutter_test/testWidgets.html
