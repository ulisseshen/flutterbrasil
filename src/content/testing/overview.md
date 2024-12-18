---
ia-translate: true
title: Testando aplicativos Flutter
description:
  Aprenda mais sobre os diferentes tipos de testes e como escrevê-los.
---

Quanto mais recursos seu aplicativo tiver, mais difícil será testá-lo
manualmente. Testes automatizados ajudam a garantir que seu aplicativo funcione
corretamente antes de publicá-lo, enquanto mantém sua velocidade de
desenvolvimento de recursos e correção de bugs.

:::note
Para a prática de testar aplicativos Flutter, consulte o
codelab [How to test a Flutter app][].
:::

O teste automatizado se enquadra em algumas categorias:

* Um [_teste de unidade_](#testes-de-unidade) testa uma única função, método ou
  classe.
* Um [_teste de widget_](#testes-de-widget) (em outras *frameworks* de UI é
  referido como _teste de componente_) testa um único *widget*.
* Um [_teste de integração_](#testes-de-integração) testa um aplicativo
  completo ou uma grande parte de um aplicativo.

De um modo geral, um aplicativo bem testado tem muitos testes de unidade e de
*widget*, rastreados por [code coverage][], além de testes de integração
suficientes para cobrir todos os casos de uso importantes. Este conselho é
baseado no fato de que existem *trade-offs* entre os diferentes tipos de teste,
como pode ser visto abaixo.

| Tradeoff             | Unidade | Widget    | Integração |
|----------------------|---------|-----------|------------|
| **Confiança**        | Baixa   | Maior     | Mais alta  |
| **Custo de manutenção** | Baixa   | Maior     | Mais alta  |
| **Dependências**     | Poucas  | Mais      | Muitas     |
| **Velocidade de execução** | Rápida | Rápida    | Lenta      |

{:.table .table-striped}

## Testes de unidade

Um _teste de unidade_ testa uma única função, método ou classe.
O objetivo de um teste de unidade é verificar a exatidão de uma
unidade de lógica sob uma variedade de condições.
As dependências externas da unidade em teste são geralmente
simuladas usando *mocks*.
Os testes de unidade geralmente não leem ou gravam em disco,
não renderizam na tela, nem recebem ações do usuário de
fora do processo que executa o teste.
Para mais informações sobre testes de unidade,
você pode ver as seguintes receitas
ou executar `flutter test --help` em seu terminal.

:::note
Se você estiver escrevendo testes de unidade para código que
usa *plugins* e quiser evitar falhas,
consulte [*Plugins* em testes do Flutter][].
Se você quiser testar seu *plugin* do Flutter,
consulte [Testando *plugins*][].
:::

[Plugins in Flutter tests]: /testing/plugins-in-tests
[Testing plugins]: /testing/testing-plugins

### Receitas {:.no_toc}

{% include docs/testing-toc.md type='unit' %}

## Testes de widget

Um _teste de widget_ (em outras *frameworks* de UI, é chamado de _teste de
componente_) testa um único *widget*. O objetivo de um teste de *widget* é
verificar se a interface do usuário do *widget* tem a aparência e interage
conforme o esperado. Testar um *widget* envolve várias classes e requer um
ambiente de teste que forneça o contexto de ciclo de vida do *widget*
apropriado.

Por exemplo, o *widget* sendo testado deve ser capaz de receber e responder a
ações e eventos do usuário, executar o *layout* e instanciar *widgets* filhos.
Um teste de *widget* é, portanto, mais abrangente do que um teste de unidade.
No entanto, como um teste de unidade, o ambiente de um teste de *widget* é
substituído por uma implementação muito mais simples do que um sistema de UI
completo.

### Receitas {:.no_toc}

{% include docs/testing-toc.md type='widget' %}

## Testes de integração

Um _teste de integração_ testa um aplicativo completo ou uma grande parte de um
aplicativo. O objetivo de um teste de integração é verificar se todos os
*widgets* e serviços testados funcionam juntos conforme o esperado.
Além disso, você pode usar testes de integração para verificar o desempenho do
seu aplicativo.

Geralmente, um _teste de integração_ é executado em um dispositivo real ou em
um emulador de sistema operacional, como o *iOS Simulator* ou o *Android
Emulator*. O aplicativo em teste é normalmente isolado do código do *driver* de
teste para evitar distorcer os resultados.

Para obter mais informações sobre como escrever testes de integração, consulte a
[página de testes de integração][].

### Receitas {:.no_toc}

{% include docs/testing-toc.md type='integration' %}

## Serviços de integração contínua

Os serviços de integração contínua (CI) permitem que você execute seus testes
automaticamente ao enviar novas alterações de código. Isso fornece *feedback*
oportuno sobre se as alterações de código funcionam conforme o esperado e se
não introduzem *bugs*.

Para obter informações sobre como executar testes em vários serviços de
integração contínua, consulte o seguinte:

*   [Entrega contínua usando *fastlane* com Flutter][]
*   [Teste aplicativos Flutter no Appcircle][]
*   [Teste aplicativos Flutter no Travis][]
*   [Teste aplicativos Flutter no Cirrus][]
*   [Codemagic CI/CD para Flutter][]
*   [Flutter CI/CD com Bitrise][]

[code coverage]: https://en.wikipedia.org/wiki/Code_coverage
[Codemagic CI/CD for Flutter]: https://blog.codemagic.io/getting-started-with-codemagic/
[Continuous delivery using fastlane with Flutter]: /deployment/cd#fastlane
[Flutter CI/CD with Bitrise]: https://devcenter.bitrise.io/en/getting-started/quick-start-guides/getting-started-with-flutter-apps
[How to test a Flutter app]: {{site.codelabs}}/codelabs/flutter-app-testing
[Test Flutter apps on Appcircle]: https://blog.appcircle.io/article/flutter-ci-cd-github-ios-android-web#
[Test Flutter apps on Cirrus]: https://cirrus-ci.org/examples/#flutter
[Test Flutter apps on Travis]: {{site.flutter-medium}}/test-flutter-apps-on-travis-3fd5142ecd8c
[página de testes de integração]: /testing/integration-tests
