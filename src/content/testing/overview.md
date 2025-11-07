---
ia-translate: true
title: Testar apps Flutter
description:
  Saiba mais sobre os diferentes tipos de testes e como escrevê-los.
---

Quanto mais recursos seu app tiver, mais difícil será testar manualmente.
Testes automatizados ajudam a garantir que seu app funcione corretamente antes
de você publicá-lo, mantendo sua velocidade de desenvolvimento de recursos e correção de bugs.

:::note
Para prática prática de testes de apps Flutter, veja o
codelab [How to test a Flutter app][].
:::

Testes automatizados se dividem em algumas categorias:

* Um [_unit test_](#unit-tests) testa uma única função, método ou classe.
* Um [_widget test_](#widget-tests) (em outros frameworks de UI chamado de
  _component test_) testa um único widget.
* Um [_integration test_](#integration-tests)
  testa um app completo ou uma grande parte de um app.

De modo geral, um app bem testado tem muitos testes de unidade e widget,
rastreados por [cobertura de código][code coverage], além de testes de integração suficientes
para cobrir todos os casos de uso importantes. Este conselho é baseado no
fato de que existem trade-offs entre diferentes tipos de teste,
vistos abaixo.

| Trade-off            | Unit   | Widget | Integration |
|----------------------|--------|--------|-------------|
| **Confiança**        | Baixa  | Maior  | Máxima      |
| **Custo de manutenção** | Baixo  | Maior  | Máximo      |
| **Dependências**     | Poucas | Mais   | Muitas      |
| **Velocidade de execução**  | Rápido | Rápido | Lento       |

{:.table .table-striped}

## Unit tests

Um _unit test_ testa uma única função, método ou classe.
O objetivo de um unit test é verificar a corretude de uma
unidade de lógica sob uma variedade de condições.
Dependências externas da unidade sob teste são geralmente
[mockadas][/cookbook/testing/unit/mocking].
Unit tests geralmente não leem ou escrevem
no disco, renderizam na tela ou recebem ações do usuário de
fora do processo executando o teste.
Para mais informações sobre unit tests,
você pode ver as seguintes receitas
ou executar `flutter test --help` no seu terminal.

:::note
Se você está escrevendo unit tests para código que
usa plugins e quer evitar crashes,
confira [Plugins in Flutter tests][].
Se você quer testar seu plugin Flutter,
confira [Testing plugins][].
:::

[Plugins in Flutter tests]: /testing/plugins-in-tests
[Testing plugins]: /testing/testing-plugins

### Receitas {:.no_toc}

{% include docs/testing-toc.md type='unit' %}

## Widget tests

Um _widget test_ (em outros frameworks de UI chamado de _component test_)
testa um único widget. O objetivo de um widget test é verificar que a
UI do widget parece e interage como esperado. Testar um widget envolve
múltiplas classes e requer um ambiente de teste que forneça o
contexto apropriado do ciclo de vida do widget.

Por exemplo, o Widget sendo testado deve ser capaz de receber e
responder a ações e eventos do usuário, realizar layout e instanciar widgets
filhos. Um widget test é, portanto, mais abrangente do que um unit test.
No entanto, como um unit test, o ambiente de um widget test é substituído por
uma implementação muito mais simples do que um sistema de UI completo.

### Receitas {:.no_toc}

{% include docs/testing-toc.md type='widget' %}

## Integration tests

Um _integration test_ testa um app completo ou uma grande parte de um app.
O objetivo de um integration test é verificar que todos os widgets
e serviços sendo testados funcionam juntos como esperado.
Além disso, você pode usar integration
tests para verificar o desempenho do seu app.

Geralmente, um _integration test_ executa em um dispositivo real ou em um emulador de SO,
como iOS Simulator ou Android Emulator.
O app sob teste é tipicamente isolado
do código do driver de teste para evitar distorcer os resultados.

Para mais informações sobre como escrever integration tests, veja a [página de
testes de integração][integration testing page].

### Receitas {:.no_toc}

{% include docs/testing-toc.md type='integration' %}

## Serviços de integração contínua

Serviços de integração contínua (CI) permitem que você execute seus
testes automaticamente ao fazer push de novas mudanças de código.
Isso fornece feedback oportuno sobre se as mudanças de código
funcionam como esperado e não introduzem bugs.

Para informações sobre execução de testes em vários
serviços de integração contínua, veja o seguinte:

* [Continuous delivery using fastlane with Flutter][]
* [Test Flutter apps on Appcircle][]
* [Test Flutter apps on Travis][]
* [Test Flutter apps on Cirrus][]
* [Codemagic CI/CD for Flutter][]
* [Flutter CI/CD with Bitrise][]

[code coverage]: https://en.wikipedia.org/wiki/Code_coverage
[Codemagic CI/CD for Flutter]: https://blog.codemagic.io/getting-started-with-codemagic/
[Continuous delivery using fastlane with Flutter]: /deployment/cd#fastlane
[Flutter CI/CD with Bitrise]: https://devcenter.bitrise.io/en/getting-started/quick-start-guides/getting-started-with-flutter-apps
[How to test a Flutter app]: {{site.codelabs}}/codelabs/flutter-app-testing
[Test Flutter apps on Appcircle]: https://blog.appcircle.io/article/flutter-ci-cd-github-ios-android-web#
[Test Flutter apps on Cirrus]: https://cirrus-ci.org/examples/#flutter
[Test Flutter apps on Travis]: {{site.flutter-medium}}/test-flutter-apps-on-travis-3fd5142ecd8c
[integration testing page]: /testing/integration-tests
