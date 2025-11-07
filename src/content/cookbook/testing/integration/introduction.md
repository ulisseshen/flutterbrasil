---
title: Conceitos de testes de integração
description: Aprenda sobre testes de integração no Flutter.
short-title: Introdução
ia-translate: true
---

<?code-excerpt path-base="cookbook/testing/integration/introduction/"?>

Testes unitários e testes de widget validam classes, funções ou widgets individuais.
Eles não validam como as peças individuais funcionam juntas como um todo ou capturam o desempenho
de um aplicativo rodando em um dispositivo real.
Para realizar essas tarefas, use *testes de integração*.

Testes de integração verificam o comportamento do aplicativo completo.
Este teste também pode ser chamado de teste end-to-end ou teste de GUI.

O Flutter SDK inclui o pacote [integration_test][].

## Terminologia

**host machine**
: O sistema no qual você desenvolve seu aplicativo, como um computador desktop.

**target device**
: O dispositivo móvel, navegador ou aplicativo desktop que executa
seu aplicativo Flutter.

  Se você executar seu aplicativo em um navegador web ou como um aplicativo desktop,
  a host machine e o target device são os mesmos.

## Pacote dependente

Para executar testes de integração, adicione o pacote `integration_test`
como uma dependência para o arquivo de teste do seu aplicativo Flutter.

Para migrar projetos existentes que usam `flutter_driver`,
consulte o guia [Migrating from flutter_driver][].

Testes escritos com o pacote `integration_test`
podem realizar as seguintes tarefas.

* Executar no target device.
  Para testar múltiplos dispositivos Android ou iOS, use Firebase Test Lab.
* Executar da host machine com `flutter test integration_test`.
* Usar APIs do `flutter_test`. Isso torna os testes de integração
  similares a escrever [widget tests][].

## Casos de uso para testes de integração

Os outros guias nesta seção explicam como usar testes de integração para validar
[funcionalidade][functionality] e [desempenho][performance].

[functionality]: /testing/integration-tests/
[performance]: /cookbook/testing/integration/profiling/
[integration_test]: {{site.repo.flutter}}/tree/main/packages/integration_test
[Migrating from flutter_driver]:
    /release/breaking-changes/flutter-driver-migration
[widget tests]: /testing/overview#widget-tests
