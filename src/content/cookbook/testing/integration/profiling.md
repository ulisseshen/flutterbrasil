---
ia-translate: true
title: Medir performance com um teste de integração
description: Como fazer o profiling de performance para um app Flutter.
---

<?code-excerpt path-base="cookbook/testing/integration/profiling/"?>

Quando se trata de apps móveis, performance é crucial para a experiência do usuário.
Usuários esperam que apps tenham rolagem suave e animações significativas livres de
travamentos ou frames pulados, conhecidos como "jank". Como garantir que seu app
esteja livre de jank em uma ampla variedade de dispositivos?

Existem duas opções: primeiro, testar manualmente o app em diferentes dispositivos.
Embora essa abordagem possa funcionar para um app menor, ela se torna mais
trabalhosa conforme um app cresce em tamanho. Alternativamente, execute um teste de integração
que executa uma tarefa específica e registra uma timeline de performance.
Então, examine os resultados para determinar se uma seção específica do
app precisa ser melhorada.

Nesta receita, aprenda como escrever um teste que registra uma timeline de performance
enquanto executa uma tarefa específica e salva um resumo dos
resultados em um arquivo local.

:::note
Gravar timelines de performance não é suportado na web.
Para profiling de performance na web, veja
[Debugging performance for web apps][Debugging performance for web apps]
:::

Esta receita usa os seguintes passos:

  1. Escrever um teste que rola através de uma lista de itens.
  2. Gravar a performance do app.
  3. Salvar os resultados no disco.
  4. Executar o teste.
  5. Revisar os resultados.

## 1. Escrever um teste que rola através de uma lista de itens

Nesta receita, grave a performance de um app enquanto ele rola através de uma
lista de itens. Para focar no profiling de performance, esta receita se baseia
na receita [Scrolling][Scrolling] em testes de widget.

Siga as instruções naquela receita para criar um app e escrever um teste para
verificar que tudo funciona como esperado.

## 2. Gravar a performance do app

Em seguida, grave a performance do app enquanto ele rola através da
lista. Execute esta tarefa usando o método [`traceAction()`][`traceAction()`]
fornecido pela classe [`IntegrationTestWidgetsFlutterBinding`][`IntegrationTestWidgetsFlutterBinding`].

Este método executa a função fornecida e grava uma [`Timeline`][`Timeline`]
com informações detalhadas sobre a performance do app. Este exemplo
fornece uma função que rola através da lista de itens,
garantindo que um item específico seja exibido. Quando a função completa,
o `traceAction()` cria um `Map` de dados de relatório que contém a `Timeline`.

Especifique o `reportKey` ao executar mais de um `traceAction`.
Por padrão todas as `Timelines` são armazenadas com a chave `timeline`,
neste exemplo o `reportKey` é alterado para `scrolling_timeline`.

<?code-excerpt "integration_test/scrolling_test.dart (traceAction)"?>
```dart
await binding.traceAction(() async {
  // Scroll until the item to be found appears.
  await tester.scrollUntilVisible(
    itemFinder,
    500.0,
    scrollable: listFinder,
  );
}, reportKey: 'scrolling_timeline');
```

## 3. Salvar os resultados no disco

Agora que você capturou uma timeline de performance, você precisa de uma forma de revisá-la.
O objeto `Timeline` fornece informações detalhadas sobre todos os eventos
que ocorreram, mas não fornece uma forma conveniente de revisar os resultados.

Portanto, converta a `Timeline` em um [`TimelineSummary`][`TimelineSummary`].
O `TimelineSummary` pode executar duas tarefas que facilitam
a revisão dos resultados:

  1. Escrever um documento json no disco que resume os dados contidos
     dentro da `Timeline`. Este resumo inclui informações sobre o
     número de frames pulados, tempos de build mais lentos e mais.
  2. Salvar a `Timeline` completa como um arquivo json no disco.
     Este arquivo pode ser aberto com as ferramentas de tracing do navegador Chrome
     encontradas em `chrome://tracing`.

Para capturar os resultados, crie um arquivo chamado `perf_driver.dart`
na pasta `test_driver` e adicione o seguinte código:

<?code-excerpt "test_driver/perf_driver.dart"?>
```dart
import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() {
  return integrationDriver(
    responseDataCallback: (data) async {
      if (data != null) {
        final timeline = driver.Timeline.fromJson(
          data['scrolling_timeline'] as Map<String, dynamic>,
        );

        // Convert the Timeline into a TimelineSummary that's easier to
        // read and understand.
        final summary = driver.TimelineSummary.summarize(timeline);

        // Then, write the entire timeline to disk in a json format.
        // This file can be opened in the Chrome browser's tracing tools
        // found by navigating to chrome://tracing.
        // Optionally, save the summary to disk by setting includeSummary
        // to true
        await summary.writeTimelineToFile(
          'scrolling_timeline',
          pretty: true,
          includeSummary: true,
        );
      }
    },
  );
}
```

A função `integrationDriver` tem um `responseDataCallback`
que você pode customizar.
Por padrão, ela escreve os resultados no arquivo `integration_response_data.json`,
mas você pode customizá-la para gerar um resumo como neste exemplo.

## 4. Executar o teste

Depois de configurar o teste para capturar uma `Timeline` de performance e salvar um
resumo dos resultados no disco, execute o teste com o seguinte comando:

```console
flutter drive \
  --driver=test_driver/perf_driver.dart \
  --target=integration_test/scrolling_test.dart \
  --profile
```

A opção `--profile` significa compilar o app para o "profile mode"
ao invés do "debug mode", para que o resultado do benchmark seja mais próximo
do que será experimentado pelos usuários finais.

:::note
Execute o comando com `--no-dds` ao executar em um dispositivo móvel ou emulador.
Esta opção desabilita o Dart Development Service (DDS), que não estará
acessível do seu computador.
:::

## 5. Revisar os resultados

Depois que o teste completa com sucesso, o diretório `build` na raiz do
projeto contém dois arquivos:

  1. `scrolling_summary.timeline_summary.json` contém o resumo. Abra
     o arquivo com qualquer editor de texto para revisar as informações contidas
     dentro.  Com uma configuração mais avançada, você poderia salvar um resumo toda
     vez que o teste executar e criar um gráfico dos resultados.
  2. `scrolling_timeline.timeline.json` contém os dados completos da timeline.
     Abra o arquivo usando as ferramentas de tracing do navegador Chrome encontradas em
     `chrome://tracing`. As ferramentas de tracing fornecem uma
     interface conveniente para inspecionar os dados da timeline para descobrir
     a fonte de um problema de performance.

### Exemplo de resumo

```json
{
  "average_frame_build_time_millis": 4.2592592592592595,
  "worst_frame_build_time_millis": 21.0,
  "missed_frame_build_budget_count": 2,
  "average_frame_rasterizer_time_millis": 5.518518518518518,
  "worst_frame_rasterizer_time_millis": 51.0,
  "missed_frame_rasterizer_budget_count": 10,
  "frame_count": 54,
  "frame_build_times": [
    6874,
    5019,
    3638
  ],
  "frame_rasterizer_times": [
    51955,
    8468,
    3129
  ]
}
```

## Exemplo completo

**integration_test/scrolling_test.dart**

<?code-excerpt "integration_test/scrolling_test.dart" replace="/your_integration_test/your_package/g;"?>
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:your_package/main.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Counter increments smoke test', (tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MyApp(items: List<String>.generate(10000, (i) => 'Item $i')),
    );

    final listFinder = find.byType(Scrollable);
    final itemFinder = find.byKey(const ValueKey('item_50_text'));

    await binding.traceAction(() async {
      // Scroll until the item to be found appears.
      await tester.scrollUntilVisible(
        itemFinder,
        500.0,
        scrollable: listFinder,
      );
    }, reportKey: 'scrolling_timeline');
  });
}
```

**test_driver/perf_driver.dart**

<?code-excerpt "test_driver/perf_driver.dart"?>
```dart
import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() {
  return integrationDriver(
    responseDataCallback: (data) async {
      if (data != null) {
        final timeline = driver.Timeline.fromJson(
          data['scrolling_timeline'] as Map<String, dynamic>,
        );

        // Convert the Timeline into a TimelineSummary that's easier to
        // read and understand.
        final summary = driver.TimelineSummary.summarize(timeline);

        // Then, write the entire timeline to disk in a json format.
        // This file can be opened in the Chrome browser's tracing tools
        // found by navigating to chrome://tracing.
        // Optionally, save the summary to disk by setting includeSummary
        // to true
        await summary.writeTimelineToFile(
          'scrolling_timeline',
          pretty: true,
          includeSummary: true,
        );
      }
    },
  );
}
```


[`IntegrationTestWidgetsFlutterBinding`]: {{site.api}}/flutter/package-integration_test_integration_test/IntegrationTestWidgetsFlutterBinding-class.html
[Scrolling]: /cookbook/testing/widget/scrolling
[`Timeline`]: {{site.api}}/flutter/flutter_driver/Timeline-class.html
[`TimelineSummary`]: {{site.api}}/flutter/flutter_driver/TimelineSummary-class.html
[`traceAction()`]: {{site.api}}/flutter/flutter_driver/FlutterDriver/traceAction.html
[Debugging performance for web apps]: /perf/web-performance
