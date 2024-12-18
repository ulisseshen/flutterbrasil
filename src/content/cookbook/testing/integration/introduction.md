---
ia-translate: true
title: Conceitos de testes de integração
description: Aprenda sobre testes de integração no Flutter.
short-title: Introdução
---

<?code-excerpt path-base="cookbook/testing/integration/introduction/"?>

Testes unitários e testes de widget validam classes individuais,
funções ou widgets.
Eles não validam como as peças individuais funcionam
juntas no todo ou capturam o desempenho
de um aplicativo em execução em um dispositivo real.
Para realizar essas tarefas, use *testes de integração*.

Testes de integração verificam o comportamento do aplicativo completo.
Este teste também pode ser chamado de teste de ponta a ponta ou teste de GUI.

O SDK do Flutter inclui o pacote [integration_test][].

## Terminologia

**máquina host**
: O sistema no qual você desenvolve seu aplicativo, como um computador desktop.

**dispositivo alvo**
: O dispositivo móvel, navegador ou aplicativo de desktop que executa
seu aplicativo Flutter.

  Se você executar seu aplicativo em um navegador da web ou como um aplicativo de desktop,
  a máquina host e o dispositivo alvo são os mesmos.

## Pacote Dependente

Para executar testes de integração, adicione o pacote `integration_test`
como uma dependência para o seu arquivo de teste do aplicativo Flutter.

Para migrar projetos existentes que usam `flutter_driver`,
consulte o guia [Migrando do flutter_driver][].

Testes escritos com o pacote `integration_test`
podem realizar as seguintes tarefas.

* Executar no dispositivo alvo.
  Para testar vários dispositivos Android ou iOS, use o Firebase Test Lab.
* Executar a partir da máquina host com `flutter test integration_test`.
* Usar APIs `flutter_test`. Isso torna os testes de integração
  semelhantes à escrita de [testes de widget][].

## Casos de uso para testes de integração

Os outros guias nesta seção explicam como usar testes de integração para validar
[funcionalidade][] e [desempenho][].

[funcionalidade]: /testing/integration-tests/
[desempenho]: /cookbook/testing/integration/profiling/
[integration_test]: {{site.repo.flutter}}/tree/main/packages/integration_test
[Migrando do flutter_driver]:
    /release/breaking-changes/flutter-driver-migration
[testes de widget]: /testing/overview#widget-tests
