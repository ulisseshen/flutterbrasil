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

O Flutter SDK inclui o pacote [integration_test][integration_test].

## Terminologia

**host machine**
: O sistema no qual você desenvolve seu app, como um computador desktop.

**target device**
: O dispositivo móvel, navegador ou aplicação desktop que
  executa seu app Flutter.

  Se você executa seu app em um navegador web ou como uma aplicação desktop,
  a host machine e o target device são os mesmos.

## Pacote dependente

Para executar testes de integração, adicione o pacote `integration_test`
como uma dependência para seu arquivo de teste do app Flutter.

Para migrar projetos existentes que usam `flutter_driver`,
consulte o guia [Migrating from flutter_driver][Migrating from flutter_driver].

Testes escritos com o pacote `integration_test`
podem executar as seguintes tarefas.

* Executar no target device.
  Para testar múltiplos dispositivos Android ou iOS, use Firebase Test Lab.
* Executar a partir da host machine com `flutter test integration_test`.
* Usar APIs do `flutter_test`. Isso torna os testes de integração
  similares a escrever [widget tests][widget tests].

## Casos de uso para testes de integração

Os outros guias nesta seção explicam como usar testes de integração para validar
[funcionalidade][functionality] e [performance][performance].

[functionality]: /testing/integration-tests/
[performance]: /cookbook/testing/integration/profiling/
[integration_test]: {{site.repo.flutter}}/tree/main/packages/integration_test
[Migrating from flutter_driver]: /release/breaking-changes/flutter-driver-migration
[widget tests]: /testing/overview#widget-tests
