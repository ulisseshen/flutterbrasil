---
ia-translate: true
title: Testando apps Flutter
description: >-
  Aprenda mais sobre os diferentes tipos de testes e como escrevê-los.
---

Quanto mais funcionalidades seu app tiver, mais difícil será testá-lo manualmente.
Testes automatizados ajudam a garantir que seu app funcione corretamente antes
de publicá-lo, mantendo a velocidade de desenvolvimento de funcionalidades e correções de bugs.

:::note
Para praticar testes de apps Flutter, veja o
codelab [Como testar um app Flutter][How to test a Flutter app].
:::

Testes automatizados se dividem em algumas categorias:

* Um [_unit test_](#unit-tests) testa uma única função, método ou classe.
* Um [_widget test_](#widget-tests) (em outros frameworks de UI referido
  como _component test_) testa um único widget.
* Um [_integration test_](#integration-tests)
  testa um app completo ou uma grande parte de um app.

De modo geral, um app bem testado possui muitos testes unitários e de widget,
rastreados por [cobertura de código][code coverage], além de testes de integração suficientes
para cobrir todos os casos de uso importantes. Este conselho é baseado no
fato de que existem trade-offs entre diferentes tipos de testes,
vistos abaixo.

| Tradeoff             | Unit   | Widget | Integration |
|----------------------|--------|--------|-------------|
| **Confidence**       | Low    | Higher | Highest     |
| **Maintenance cost** | Low    | Higher | Highest     |
| **Dependencies**     | Few    | More   | Most        |
| **Execution speed**  | Quick  | Quick  | Slow        |

{:.table .table-striped}

## Unit tests

Um _unit test_ testa uma única função, método ou classe.
O objetivo de um unit test é verificar a corretude de uma
unidade de lógica sob uma variedade de condições.
Dependências externas da unidade sob teste são geralmente
[mockadas][mocked out].
Unit tests geralmente não leem ou escrevem
no disco, renderizam na tela, ou recebem ações do usuário de
fora do processo que está executando o teste.
Para mais informações sobre unit tests,
você pode ver as seguintes receitas
ou executar `flutter test --help` no seu terminal.

:::note
Se você está escrevendo unit tests para código que
usa plugins e quer evitar crashes,
confira [Plugins em testes Flutter][Plugins in Flutter tests].
Se você quer testar seu plugin Flutter,
confira [Testando plugins][Testing plugins].
:::

[Plugins in Flutter tests]: /testing/plugins-in-tests
[Testing plugins]: /testing/testing-plugins

### Recipes {:.no_toc}

- [Introdução a unit testing](/cookbook/testing/unit/introduction)
- [Mock de dependências usando Mockito](/cookbook/testing/unit/mocking)

## Widget tests

Um _widget test_ (em outros frameworks de UI referido como _component test_)
testa um único widget. O objetivo de um widget test é verificar que a
UI do widget se parece e interage como esperado. Testar um widget envolve
múltiplas classes e requer um ambiente de teste que forneça o
contexto apropriado do ciclo de vida do widget.

Por exemplo, o Widget sendo testado deve ser capaz de receber e
responder a ações e eventos do usuário, executar layout, e instanciar widgets
filhos. Um widget test é portanto mais abrangente do que um unit test.
No entanto, como um unit test, o ambiente de um widget test é substituído por
uma implementação muito mais simples do que um sistema de UI completo.

### Recipes {:.no_toc}

- [Introdução a widget testing](/cookbook/testing/widget/introduction)
- [Encontrar widgets usando finders](/cookbook/testing/widget/finders)
- [Manipulando scroll em widget tests](/cookbook/testing/widget/scrolling)
- [Tocar, arrastar e inserir texto em widget tests](/cookbook/testing/widget/tap-drag)
- [Testar diferentes orientações](/cookbook/testing/widget/orientation)

## Integration tests

Um _integration test_ testa um app completo ou uma grande parte de um app.
O objetivo de um integration test é verificar que todos os widgets
e serviços sendo testados funcionam juntos como esperado.
Além disso, você pode usar integration
tests para verificar a performance do seu app.

Geralmente, um _integration test_ é executado em um dispositivo real ou um emulador de SO,
como iOS Simulator ou Android Emulator.
O app sob teste é tipicamente isolado
do código do driver de teste para evitar distorcer os resultados.

Para mais informações sobre como escrever integration tests, veja a [página de
testes de integração][integration testing page].

### Recipes {:.no_toc}

- [Conceitos de integration testing](/cookbook/testing/integration/introduction)
- [Medir performance com um integration test](/cookbook/testing/integration/profiling)

## Continuous integration services

Serviços de integração contínua (CI) permitem executar seus
testes automaticamente ao enviar novas mudanças de código.
Isso fornece feedback oportuno sobre se as mudanças de código
funcionam como esperado e não introduzem bugs.

Para informações sobre executar testes em vários
serviços de integração contínua, veja o seguinte:

* [Entrega contínua usando fastlane com Flutter][Continuous delivery using fastlane with Flutter]
* [Testar apps Flutter no Appcircle][Test Flutter apps on Appcircle]
* [Testar apps Flutter no Travis][Test Flutter apps on Travis]
* [Testar apps Flutter no Cirrus][Test Flutter apps on Cirrus]
* [Codemagic CI/CD para Flutter][Codemagic CI/CD for Flutter]
* [Flutter CI/CD com Bitrise][Flutter CI/CD with Bitrise]

[code coverage]: https://en.wikipedia.org/wiki/Code_coverage
[Codemagic CI/CD for Flutter]: https://blog.codemagic.io/getting-started-with-codemagic/
[Continuous delivery using fastlane with Flutter]: /deployment/cd#fastlane
[Flutter CI/CD with Bitrise]: https://devcenter.bitrise.io/en/getting-started/quick-start-guides/getting-started-with-flutter-apps
[How to test a Flutter app]: {{site.codelabs}}/codelabs/flutter-app-testing
[Test Flutter apps on Appcircle]: https://blog.appcircle.io/article/flutter-ci-cd-github-ios-android-web#
[Test Flutter apps on Cirrus]: https://cirrus-ci.org/examples/#flutter
[Test Flutter apps on Travis]: {{site.flutter-blog}}/test-flutter-apps-on-travis-3fd5142ecd8c
[integration testing page]: /testing/integration-tests
[mocked out]: /cookbook/testing/unit/mocking
