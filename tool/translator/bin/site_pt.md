---
title: Testando aplicativos Flutter
description:
  Saiba mais sobre os diferentes tipos de teste e como escrevê-los.
---

Quanto mais recursos seu aplicativo possui, mais difícil é testá-lo manualmente.
Testes automatizados ajudam a garantir que seu aplicativo funcione corretamente antes
de você publicá-lo, mantendo sua velocidade de recursos e correção de bugs.

:::note
Para prática de testes de aplicativos Flutter, veja o
[Codelab Como testar um aplicativo Flutter][].
:::

O teste automatizado se divide em algumas categorias:

* Um _teste unitário_](#unit-tests) testa uma única função, método ou classe.
* Um _teste de widget_](#widget-tests) (em outros frameworks de UI, referidos
  como _teste de componente_) testa um único widget.
* Um _teste de integração_](#integration-tests)
  testa um aplicativo completo ou uma grande parte de um aplicativo.

De modo geral, um aplicativo bem testado tem muitos testes unitários e de widget,
rastreados pela [cobertura de código][], além de testes de integração suficientes
para cobrir todos os casos de uso importantes. Este conselho é baseado no
fato de que existem trade-offs entre diferentes tipos de teste,
vistos abaixo.

| Tradeoff             | Unitário | Widget | Integração |
|----------------------|----------|--------|-------------|
| **Confiança**       | Baixa    | Maior  | Mais alta   |
| **Custo de manutenção** | Baixo    | Maior  | Mais alto   |
| **Dependências**     | Poucas   | Mais   | Muitas      |
| **Velocidade de execução** | Rápida  | Rápida | Lenta       |

{:.table .table-striped}

## Testes unitários

Um _teste unitário_ testa uma única função, método ou classe.
O objetivo de um teste unitário é verificar a correção de uma
unidade de lógica sob uma variedade de condições.
Dependências externas da unidade em teste são geralmente
[simuladas](/cookbook/testing/unit/mocking).
Testes unitários geralmente não leem ou gravam
em disco, renderizam na tela ou recebem ações do usuário de
fora do processo que executa o teste.
Para mais informações sobre testes unitários,
você pode ver as seguintes receitas
ou executar `flutter test --help` no seu terminal.

:::note
Se você estiver escrevendo testes unitários para código que
usa plugins e você deseja evitar crashes,
confira [Plugins em testes Flutter][].
Se você quiser testar seu plugin Flutter,
confira [Testando plugins][].
:::

[Plugins em testes Flutter]: /testing/plugins-in-tests
[Testando plugins]: /testing/testing-plugins

### Receitas {:.no_toc}

{% include docs/testing-toc.md type='unit' %}

## Testes de widget

Um _teste de widget_ (em outros frameworks de UI, referidos como _teste de componente_)
testa um único widget. O objetivo de um teste de widget é verificar se a
UI do widget tem a aparência e interage como esperado. Testar um widget envolve
várias classes e requer um ambiente de teste que forneça o
contexto apropriado do ciclo de vida do widget.

Por exemplo, o Widget sendo testado deve ser capaz de receber e
responder a ações e eventos do usuário, realizar layout e instanciar filhos
widgets. Um teste de widget é, portanto, mais abrangente do que um teste unitário.
No entanto, como um teste unitário, o ambiente de um teste de widget é substituído por
uma implementação muito mais simples do que um sistema de UI completo.

### Receitas {:.no_toc}

{% include docs/testing-toc.md type='widget' %}

## Testes de integração

Um _teste de integração_ testa um aplicativo completo ou uma grande parte de um aplicativo.
O objetivo de um teste de integração é verificar se todos os widgets
e serviços sendo testados funcionam juntos conforme o esperado.
Além disso, você pode usar testes de integração
para verificar o desempenho do seu aplicativo.

Geralmente, um _teste de integração_ é executado em um dispositivo real ou em um emulador de SO,
como o iOS Simulator ou o Android Emulator.
O aplicativo em teste é normalmente isolado
do código do driver de teste para evitar que os resultados sejam enviesados.

Para mais informações sobre como escrever testes de integração, consulte a [página de testes de integração][].

### Receitas {:.no_toc}

{% include docs/testing-toc.md type='integration' %}

## Serviços de integração contínua

Serviços de integração contínua (CI) permitem que você execute seus
testes automaticamente ao enviar novas mudanças de código.
Isso fornece feedback oportuno sobre se as mudanças de código
funcionam como esperado e não introduzem bugs.

Para informações sobre como executar testes em vários serviços de integração contínua, consulte o seguinte:

* [Entrega contínua usando fastlane com Flutter][]
* [Teste aplicativos Flutter no Appcircle][]
* [Teste aplicativos Flutter no Travis][]
* [Teste aplicativos Flutter no Cirrus][]
* [Codemagic CI/CD para Flutter][]
* [Flutter CI/CD com Bitrise][]

[cobertura de código]: https://en.wikipedia.org/wiki/Code_coverage
[Codemagic CI/CD para Flutter]: https://blog.codemagic.io/getting-started-with-codemagic/
[Entrega contínua usando fastlane com Flutter]: /deployment/cd#fastlane
[Flutter CI/CD com Bitrise]: https://devcenter.bitrise.io/en/getting-started/quick-start-guides/getting-started-with-flutter-apps
[Codelab Como testar um aplicativo Flutter]: {{site.codelabs}}/codelabs/flutter-app-testing
[Teste aplicativos Flutter no Appcircle]: https://blog.appcircle.io/article/flutter-ci-cd-github-ios-android-web#
[Teste aplicativos Flutter no Cirrus]: https://cirrus-ci.org/examples/#flutter
[Teste aplicativos Flutter no Travis]: {{site.flutter-medium}}/test-flutter-apps-on-travis-3fd5142ecd8c
[página de testes de integração]: /testing/integration-tests
