---
ia-translate: true
title: Medir o desempenho com um teste de integração
description: Como criar um perfil de desempenho para um aplicativo Flutter.
---

<?code-excerpt path-base="cookbook/testing/integration/profiling/"?>

Quando se trata de aplicativos móveis, o desempenho é fundamental para a experiência do usuário.
Os usuários esperam que os aplicativos tenham rolagem suave e animações significativas, livres de
travamentos ou quadros perdidos, conhecidos como "jank." Como garantir que seu aplicativo
esteja livre de jank em uma grande variedade de dispositivos?

Existem duas opções: primeiro, testar manualmente o aplicativo em diferentes dispositivos.
Embora essa abordagem possa funcionar para um aplicativo menor, ela se torna mais
complicada à medida que um aplicativo cresce em tamanho. Alternativamente, execute um teste de integração
que realize uma tarefa específica e registre uma linha do tempo de desempenho.
Em seguida, examine os resultados para determinar se uma seção específica do
aplicativo precisa ser aprimorada.

Nesta receita, aprenda como escrever um teste que registra uma linha do tempo de desempenho
ao realizar uma tarefa específica e salva um resumo dos
resultados em um arquivo local.

:::note
O registro de linhas do tempo de desempenho não é compatível com a web.
Para criação de perfil de desempenho na web, consulte
[Depurando o desempenho para aplicativos da web][]
:::

Esta receita usa as seguintes etapas:

  1. Escreva um teste que role por uma lista de itens.
  2. Registre o desempenho do aplicativo.
  3. Salve os resultados no disco.
  4. Execute o teste.
  5. Analise os resultados.

## 1. Escreva um teste que role por uma lista de itens

Nesta receita, registre o desempenho de um aplicativo enquanto ele rola por uma
lista de itens. Para se concentrar na criação de perfil de desempenho, esta receita se baseia
na receita [Rolagem][] em testes de widget.

Siga as instruções dessa receita para criar um aplicativo e escrever um teste para
verificar se tudo funciona como esperado.

## 2. Registre o desempenho do aplicativo

Em seguida, registre o desempenho do aplicativo enquanto ele rola pela
lista. Execute esta tarefa usando o método [`traceAction()`][]
fornecido pela classe [`IntegrationTestWidgetsFlutterBinding`][].

Este método executa a função fornecida e registra uma [`Timeline`][]
com informações detalhadas sobre o desempenho do aplicativo. Este exemplo
fornece uma função que rola pela lista de itens,
garantindo que um item específico seja exibido. Quando a função é concluída,
o `traceAction()` cria um `Map` de dados de relatório que contém a `Timeline`.

Especifique o `reportKey` ao executar mais de um `traceAction`.
Por padrão, todas as `Timelines` são armazenadas com a chave `timeline`,
neste exemplo, a `reportKey` é alterada para `scrolling_timeline`.

<?code-excerpt "integration_test/scrolling_test.dart (traceAction)"?>
```dart
await binding.traceAction(
  () async {
    // Role até que o item a ser encontrado apareça.
    await tester.scrollUntilVisible(
      itemFinder,
      500.0,
      scrollable: listFinder,
    );
  },
  reportKey: 'scrolling_timeline',
);
```

## 3. Salve os resultados no disco

Agora que você capturou uma linha do tempo de desempenho, precisa de uma maneira de analisá-la.
O objeto `Timeline` fornece informações detalhadas sobre todos os eventos
que ocorreram, mas não fornece uma maneira conveniente de analisar os resultados.

Portanto, converta a `Timeline` em um [`TimelineSummary`][].
O `TimelineSummary` pode realizar duas tarefas que facilitam
a análise dos resultados:

  1. Gravar um documento json no disco que resume os dados contidos
     dentro da `Timeline`. Este resumo inclui informações sobre o
     número de quadros perdidos, tempos de construção mais lentos e muito mais.
  2. Salvar a `Timeline` completa como um arquivo json no disco.
     Este arquivo pode ser aberto com o
     ferramentas de rastreamento do navegador Chrome encontradas em `chrome://tracing`.

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

        // Converta a Timeline em um TimelineSummary que seja mais fácil de
        // ler e entender.
        final summary = driver.TimelineSummary.summarize(timeline);

        // Em seguida, grave toda a linha do tempo no disco em formato json.
        // Este arquivo pode ser aberto nas ferramentas de rastreamento do navegador Chrome
        // encontrado navegando para chrome://tracing.
        // Opcionalmente, salve o resumo no disco definindo includeSummary
        // para true
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
que você pode personalizar.
Por padrão, ele grava os resultados no arquivo `integration_response_data.json`,
mas você pode personalizá-lo para gerar um resumo como neste exemplo.

## 4. Execute o teste

Depois de configurar o teste para capturar uma `Timeline` de desempenho e salvar um
resumo dos resultados no disco, execute o teste com o seguinte comando:

```console
flutter drive \
  --driver=test_driver/perf_driver.dart \
  --target=integration_test/scrolling_test.dart \
  --profile
```

A opção `--profile` significa compilar o aplicativo para o "modo de perfil"
em vez do "modo de depuração", para que o resultado do benchmark seja mais próximo do
que será experimentado pelos usuários finais.

:::note
Execute o comando com `--no-dds` ao executar em um dispositivo móvel ou emulador.
Esta opção desativa o Dart Development Service (DDS), que não
será acessível do seu computador.
:::

## 5. Analise os resultados

Depois que o teste for concluído com sucesso, o diretório `build` na raiz do
projeto contém dois arquivos:

  1. `scrolling_summary.timeline_summary.json` contém o resumo. Abra
     o arquivo com qualquer editor de texto para analisar as informações contidas
     dentro. Com uma configuração mais avançada, você pode salvar um resumo sempre
     que o teste for executado e criar um gráfico dos resultados.
  2. `scrolling_timeline.timeline.json` contém os dados completos da linha do tempo.
     Abra o arquivo usando as ferramentas de rastreamento do navegador Chrome encontradas em
     `chrome://tracing`. As ferramentas de rastreamento fornecem uma
     interface conveniente para inspecionar os dados da linha do tempo para descobrir
     a origem de um problema de desempenho.

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

<?code-excerpt "integration_test/scrolling_test.dart"?>
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:scrolling/main.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Teste de fumaça de incrementos do contador', (tester) async {
    // Construa nosso aplicativo e acione um frame.
    await tester.pumpWidget(MyApp(
      items: List<String>.generate(10000, (i) => 'Item $i'),
    ));

    final listFinder = find.byType(Scrollable);
    final itemFinder = find.byKey(const ValueKey('item_50_text'));

    await binding.traceAction(
      () async {
        // Role até que o item a ser encontrado apareça.
        await tester.scrollUntilVisible(
          itemFinder,
          500.0,
          scrollable: listFinder,
        );
      },
      reportKey: 'scrolling_timeline',
    );
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

        // Converta a Timeline em um TimelineSummary que seja mais fácil de
        // ler e entender.
        final summary = driver.TimelineSummary.summarize(timeline);

        // Em seguida, grave toda a linha do tempo no disco em formato json.
        // Este arquivo pode ser aberto nas ferramentas de rastreamento do navegador Chrome
        // encontrado navegando para chrome://tracing.
        // Opcionalmente, salve o resumo no disco definindo includeSummary
        // para true
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
[Rolagem]: /cookbook/testing/widget/scrolling
[`Timeline`]: {{site.api}}/flutter/flutter_driver/Timeline-class.html
[`TimelineSummary`]: {{site.api}}/flutter/flutter_driver/TimelineSummary-class.html
[`traceAction()`]: {{site.api}}/flutter/flutter_driver/FlutterDriver/traceAction.html
[Depurando o desempenho para aplicativos da web]: /perf/web-performance
