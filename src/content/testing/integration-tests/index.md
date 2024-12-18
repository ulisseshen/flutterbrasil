---
title: Verifique a funcionalidade do app com um teste de integração
description: Aprenda como escrever testes de integração
ia-translate: true
---

<?code-excerpt path-base="testing/integration_tests/how_to"?>

Esta receita descreve como usar o pacote
[`integration_test`][] para executar testes de integração.
O SDK Flutter inclui o pacote `integration_test`.
Testes de integração usando este pacote têm as seguintes
propriedades.

* Use o comando `flutter drive` para executar testes
  em um dispositivo físico ou emulador.
* Execute no [Firebase Test Lab][],
  para automatizar testes em uma variedade de dispositivos.
* Use as APIs [flutter_test][] para permitir que os testes sejam escritos em um estilo semelhante aos [widget tests][]

Nesta receita, aprenda como testar um aplicativo de contador.

* como configurar testes de integração
* como verificar se um aplicativo exibe um texto específico
* como tocar em widgets específicos
* como executar testes de integração

Esta receita usa as seguintes etapas:

  1. Crie um aplicativo para testar.
  2. Adicione a dependência `integration_test`.
  3. Crie os arquivos de teste.
  4. Escreva o teste de integração.
  5. Execute o teste de integração.

## Crie um novo aplicativo para testar

Testes de integração requerem um aplicativo para testar.
Este exemplo usa o exemplo integrado **Counter App**
que o Flutter produz quando você executa o comando `flutter create`.
O aplicativo de contador permite que um usuário toque em um botão para aumentar um contador.

1. Para criar uma instância do aplicativo Flutter integrado,
   execute o seguinte comando em seu terminal:

   ```console
   $ flutter create counter_app
   ```

1. Vá para o diretório `counter_app`.

1. Abra `lib/main.dart` em seu IDE preferido.

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

1. Salve seu arquivo `lib/main.dart`.

Após essas alterações,
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
        // Forneça uma Key para este botão. Isso permite encontrar este
        // botão específico dentro do conjunto de testes e tocá-lo.
        key: const Key('increment'),
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## Adicione a dependência `integration_test`

Você precisa adicionar os pacotes de teste ao seu novo aplicativo.

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
  # ... dependências adicionadas
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  [!integration_test:!]
    [!sdk: flutter!]
# ...
```

## Crie os arquivos de teste de integração

Os testes de integração residem em um diretório separado dentro
do seu projeto Flutter.

1. Crie um novo diretório chamado `integration_test`.
2. Adicione um arquivo vazio chamado `app_test.dart` nesse diretório.

A árvore de diretórios resultante deve ser semelhante à seguinte:

```plaintext
counter_app/
  lib/
    main.dart
  integration_test/
    app_test.dart
```

## Escreva o teste de integração

O arquivo de teste de integração consiste em um arquivo de código Dart
com dependências em `integration_test`, `flutter_test`,
e o arquivo Dart do seu aplicativo.

1. Abra seu arquivo `integration_test/app_test.dart` em seu IDE preferido.

1. Copie o código a seguir e cole-o em seu
   arquivo `integration_test/app_test.dart`.
   A última importação deve apontar para o arquivo `main.dart`
   do seu `counter_app`.
   (Essa `import` aponta para o aplicativo de exemplo chamado `introduction`.)

    <?code-excerpt "integration_test/counter_test.dart (initial)" replace="/introduction/counter_app/g"?>
    ```dart title="integration_test/counter_test.dart"
    import 'package:flutter/material.dart';
    import 'package:flutter_test/flutter_test.dart';
    import 'package:how_to/main.dart';
    import 'package:integration_test/integration_test.dart';
    
    void main() {
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    
      group('teste end-to-end', () {
        testWidgets('tocar no botão de ação flutuante, verificar contador',
            (tester) async {
          // Carregar o widget do aplicativo.
          await tester.pumpWidget(const MyApp());
    
          // Verificar se o contador começa em 0.
          expect(find.text('0'), findsOneWidget);
    
          // Encontrar o botão de ação flutuante para tocar.
          final fab = find.byKey(const ValueKey('increment'));
    
          // Simular um toque no botão de ação flutuante.
          await tester.tap(fab);
    
          // Acionar um frame.
          await tester.pumpAndSettle();
    
          // Verificar se o contador é incrementado em 1.
          expect(find.text('1'), findsOneWidget);
        });
      });
    }
    ```

Este exemplo passa por três etapas:

1. Inicialize `IntegrationTestWidgetsFlutterBinding`.
   Este serviço singleton executa testes em um dispositivo físico.

2. Interaja e teste widgets usando a classe `WidgetTester`.

3. Teste os cenários importantes.

## Execute testes de integração

Os testes de integração que são executados variam dependendo do
plataforma na qual você testa.

* Para testar uma plataforma de desktop, use a linha de comando ou um sistema CI.
* Para testar uma plataforma móvel, use a linha de comando ou o Firebase Test Lab.
* Para testar em um navegador da web, use a linha de comando.

---

### Testar em uma plataforma de desktop

<details markdown="1">
<summary>Expandir se você testar aplicativos Linux usando um sistema CI</summary>

Para testar um aplicativo Linux, seu sistema CI deve invocar um servidor X primeiro.
No GitHub Action, GitLab Runner ou arquivo de configuração semelhante,
configure o teste de integração para funcionar _com_ a ferramenta `xvfb-run`.

Fazer isso invoca um sistema X Window no qual o Flutter pode
iniciar e testar seu aplicativo Linux.

Como um exemplo usando o GitHub Actions, seus `jobs.setup.steps` devem
incluir uma etapa semelhante à seguinte:

```yaml
      - name: Executar Testes de Integração
        uses: username/xvfb-action@v1.1.2
        with:
          run: flutter test integration_test -d linux -r github
```

Isso inicia o teste de integração dentro de uma X Window.

Se você não configurar sua integração dessa forma,
Flutter retorna um erro.

```console
Building Linux application...
Error waiting for a debug connection: The log reader stopped unexpectedly, or never started.
```

</details>

Para testar em uma plataforma macOS, Windows ou Linux,
conclua as seguintes tarefas.

1. Execute o seguinte comando na raiz do projeto.

   ```console
   $ flutter test integration_test/app_test.dart
   ```

1. Se for oferecida uma opção de plataforma para testar,
   escolha a plataforma de desktop.
   Digite `1` para escolher a plataforma de desktop.

Com base na plataforma, o resultado do comando deve ser semelhante à seguinte saída.

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

### Testar em um dispositivo móvel

Para testar em um dispositivo iOS ou Android real,
conclua as seguintes tarefas.

1. Conecte o dispositivo.

1. Execute o seguinte comando na raiz do projeto.

   ```console
   $ flutter test integration_test/app_test.dart
   ```

   O resultado deve ser semelhante à seguinte saída. Este exemplo usa iOS.

   ```console
   $ flutter test integration_test/app_test.dart
   00:04 +0: loading /path/to/counter_app/integration_test/app_test.dart
   00:15 +0: loading /path/to/counter_app/integration_test/app_test.dart
   00:18 +0: loading /path/to/counter_app/integration_test/app_test.dart   2,387ms
   Xcode build done.                                           13.5s
   00:21 +1: All tests passed!
   ```

1. Verifique se o teste removeu o Counter App quando terminou.
   Caso contrário, os testes subsequentes falham. Se necessário, pressione o aplicativo e escolha
   **Remover Aplicativo** no menu de contexto.

---

### Testar em um navegador da web

{% comment %}
TODO(ryjohn): Adicionar novamente depois que outras versões do WebDriver forem suportadas:
https://github.com/flutter/flutter/issues/90158

Para testar na web,
determine qual navegador você deseja testar
e baixe o driver da web correspondente:

* Chrome: Baixe o [ChromeDriver][]
* Firefox: [Baixe o GeckoDriver][]
* Safari: O Safari só pode ser testado em um Mac;
  o SafariDriver já está instalado em máquinas Mac.
* Edge [Baixe o EdgeDriver][]
{% endcomment -%}

Para testar em um navegador da web, execute as seguintes etapas.

1. Instale o [ChromeDriver][] no diretório de sua escolha.

   ```console
   $ npx @puppeteer/browsers install chromedriver@stable
   ```

   Para simplificar a instalação, este comando usa a
   biblioteca Node [`@puppeteer/browsers`][puppeteer].

   [puppeteer]: https://www.npmjs.com/package/@puppeteer/browsers

1. Adicione o caminho para o ChromeDriver à sua variável de ambiente `$PATH`.

1. Verifique se a instalação do ChromeDriver foi bem-sucedida.

   ```console
   $ chromedriver --version
   ChromeDriver 124.0.6367.60 (8771130bd84f76d855ae42fbe02752b03e352f17-refs/branch-heads/6367@{#798})
   ```

1. No diretório do seu projeto `counter_app`,
   crie um novo diretório chamado `test_driver`.

   ```console
   $ mkdir test_driver
   ```

1. Neste diretório, crie um novo arquivo chamado `integration_test.dart`.

1. Copie o código a seguir e cole-o em seu arquivo `integration_test.dart`.

   <?code-excerpt "test_driver/integration_test.dart"?>
   ```dart title="test_driver/integration_test.dart"
   import 'package:integration_test/integration_test_driver.dart';
   
   Future<void> main() => integrationDriver();
   ```

1. Inicie o `chromedriver` da seguinte forma:

   ```console
   $ chromedriver --port=4444
   ```

1. Na raiz do projeto, execute o seguinte comando:

   ```console
   $ flutter drive \
     --driver=test_driver/integration_test.dart \
     --target=integration_test/app_test.dart \
     -d chrome
   ```

   A resposta deve ser semelhante à seguinte saída:

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
[Executando testes do Flutter driver com web][].

---

### Testar usando o Firebase Test Lab

Para testar os destinos Android e iOS,
você pode usar o Firebase Test Lab.

#### Configuração do Android

Siga as instruções na seção [Testes de Dispositivo Android][]
do README.

#### Configuração do iOS

Siga as instruções na seção [Testes de Dispositivo iOS][]
do README.

#### Configuração do projeto Test Lab

1. Inicie seu [Console do Firebase][].

1. Crie um novo projeto Firebase, se necessário.

1. Navegue até **Qualidade > Test Lab**.

   <img src='/assets/images/docs/integration-test/test-lab-1.png' class="mw-100" alt="Console do Firebase Test Lab">

#### Carregar um APK Android

1. Crie um APK usando o Gradle.

   ```console
   $ pushd android
   # flutter build gera arquivos em android/ para construir o aplicativo
   flutter build apk
   ./gradlew app:assembleAndroidTest
   ./gradlew app:assembleDebug -Ptarget=integration_test/<nome>_test.dart
   $ popd
   ```

   Onde `<nome>_test.dart` é o arquivo criado na seção
   **Configuração do Projeto**.

:::note
Para usar `--dart-define` com `gradlew`:

1. Codifique todos os parâmetros com `base64`.
2. Passe os parâmetros para o gradle em uma lista separada por vírgulas.

   ```console
   ./gradlew project:task -Pdart-defines="{base64   (key=value)},[...]"
   ```

:::

Para iniciar um teste Robo e executar outros testes, arraste o APK "debug" de
`<diretorio_do_projeto_flutter>/build/app/outputs/apk/debug`
para o destino **Android Robo Test** na página da web.

<img src='/assets/images/docs/integration-test/test-lab-2.png' class="mw-100" alt="Upload do Firebase Test Lab">

1. Clique em **Executar um teste**.

1. Selecione o tipo de teste **Instrumentação**.

1. Adicione o APK do aplicativo na caixa **APK do aplicativo ou AAB**.

   `<diretorio_do_projeto_flutter>/build/app/outputs/apk/debug/<arquivo>.apk`

1. Adicione o APK de teste na caixa **APK de teste**.

   `<diretorio_do_projeto_flutter>/build/app/outputs/apk/androidTest/debug/<arquivo>.apk`

<img src='/assets/images/docs/integration-test/test-lab-3.png' class="mw-100" alt="Upload de dois APKs no Firebase Test Lab">

Se ocorrer uma falha, clique no ícone vermelho para visualizar a saída:

<img src='/assets/images/docs/integration-test/test-lab-4.png' class="mw-100" alt="Resultados do teste do Firebase Test Lab">

#### Carregar um APK Android pela linha de comando

Consulte a [seção Firebase Test Lab do README][]
para obter instruções sobre como carregar os APKs pela linha de comando.

#### Carregar testes Xcode

Para saber como carregar o arquivo .zip,
consulte as [instruções do Firebase TestLab para iOS][]
na seção do Firebase TestLab do Console do Firebase.

#### Carregar testes Xcode pela linha de comando

Para saber como carregar o arquivo .zip pela linha de comando,
consulte a seção [Testes de Dispositivo iOS][] no README.

[`integration_test`]: {{site.repo.flutter}}/tree/main/packages/integration_test#integration_test
[Testes de Dispositivo Android]: {{site.repo.flutter}}/tree/main/packages/integration_test#android-device-testing
[ChromeDriver]: https://googlechromelabs.github.io/chrome-for-testing/
[Baixe o EdgeDriver]: https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/
[Baixe o GeckoDriver]: {{site.github}}/mozilla/geckodriver/releases
[Console do Firebase]: http://console.firebase.google.com/
[seção Firebase Test Lab do README]: {{site.repo.flutter}}/tree/main/packages/integration_test#firebase-test-lab
[Firebase Test Lab]: {{site.firebase}}/docs/test-lab
[instruções do Firebase TestLab para iOS]: {{site.firebase}}/docs/test-lab/ios/firebase-console
[flutter_test]: {{site.api}}/flutter/flutter_test/flutter_test-library.html
[Testes de integração]: /testing/integration-tests
[Testes de Dispositivo iOS]: {{site.repo.flutter}}/tree/main/packages/integration_test#ios-device-testing
[Executando testes do Flutter driver com web]: {{site.repo.flutter}}/blob/master/docs/contributing/testing/Running-Flutter-Driver-tests-with-Web.md
[widget tests]: /testing/overview#widget-tests

[flutter_driver]: {{site.api}}/flutter/flutter_driver/flutter_driver-library.html
[uso do integration_test]: {{site.repo.flutter}}/tree/main/packages/integration_test#usage
[samples]: {{site.repo.samples}}
[testing_app]: {{site.repo.samples}}/tree/main/testing_app/integration_test
[testWidgets]: {{site.api}}/flutter/flutter_test/testWidgets.html
