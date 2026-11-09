---
ia-translate: true
title: Conceitos de testes de integração
description: Aprenda sobre testes de integração no Flutter.
shortTitle: Introdução
---

<?code-excerpt path-base="cookbook/testing/integration/introduction/"?>

Testes unitários e testes de widget validam classes individuais,
funções ou widgets.
Eles não validam como peças individuais funcionam
juntas em um todo ou capturam a performance
de um app rodando em um dispositivo real.
Para executar essas tarefas, use *testes de integração*.

Testes de integração verificam o comportamento do app completo.
Este teste também pode ser chamado de teste end-to-end ou teste de GUI.

## Frameworks de teste {:#testing-frameworks}

Dois pacotes são comumente usados para realizar testes de integração no Flutter.
São eles:

- Pacote [integration_test][integration_test]: O pacote oficial
de testes de integração que faz parte do Flutter SDK. Testes escritos
com `integration_test` podem executar as seguintes tarefas: executar no
target device, executar a partir da host machine com `flutter test integration_test`,
e usar APIs do `flutter_test`. Isso torna os testes de integração similares a escrever
[widget tests][widget tests]. No entanto, `integration_test` não consegue interagir com
a UI nativa da plataforma.

- Pacote [patrol][patrol]: Um pacote popular de terceiros para testes de integração que
tem muitas das funcionalidades suportadas pelo pacote `integration_test`,
mas que adicionalmente consegue interagir com a UI nativa da plataforma, como
diálogos de permissão, notificações ou o conteúdo de platform views.

## Terminologia {:#terminology}

**host machine**
: O sistema no qual você desenvolve seu app, como um computador desktop.

**target device**
: O dispositivo móvel, navegador ou aplicação desktop que
  executa seu app Flutter.

  Se você executa seu app em um navegador web ou como uma aplicação desktop,
  a host machine e o target device são os mesmos.

## Primeiros passos {:#getting-started}

Para usar o `integration_test`, adicione-o como uma dependência para seu
arquivo de teste do app Flutter.

Para migrar projetos existentes que usam `flutter_driver`,
consulte o guia [Migrating from flutter_driver][Migrating from flutter_driver].

Para usar o `patrol`, siga o [guia de configuração do Patrol][Patrol setup guide].

## Casos de uso para testes de integração {:#use-cases-for-integration-testing}

Os outros guias nesta seção explicam como usar testes de integração para validar
[funcionalidade][functionality] e [performance][performance].

[functionality]: /testing/integration-tests/
[integration_test]: {{site.repo.flutter}}/tree/main/packages/integration_test
[Migrating from flutter_driver]: /release/breaking-changes/flutter-driver-migration
[patrol]: {{site.pub-pkg}}/patrol
[Patrol setup guide]: https://patrol.leancode.co/getting-started
[performance]: /cookbook/testing/integration/profiling/
[widget tests]: /testing/overview#widget-tests
