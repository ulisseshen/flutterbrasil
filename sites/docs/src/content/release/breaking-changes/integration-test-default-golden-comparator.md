---
ia-translate: true
title: Comparadores padrão de golden-file em testes de integração alterados no Android e iOS.
description: >-
  Ao usar `package:integration_test` para executar um teste _em_ um dispositivo
  ou emulador Android, ou dispositivo ou simulador iOS, o `goldenFileComparator`
  padrão mudou, e agora usa corretamente o sistema de arquivos do host.
---

{% render "docs/breaking-changes.md" %}

## Resumo

A menos que um [`goldenFileComparator`][`goldenFileComparator`] definido pelo usuário seja configurado,
seja manualmente em um teste ou usando um arquivo `flutter_test_config.dart`,
dispositivos e emuladores/simuladores Android e iOS têm um novo padrão que faz
proxy para o sistema de arquivos do host local, corrigindo um bug antigo
([#143299][Issue 143299]).

## Contexto

O pacote [`integration_test`][`integration_test`], e sua integração com [`flutter_test`][`flutter_test`],
historicamente tinha um bug onde ao usar [`matchesGoldenFile`][`matchesGoldenFile`] ou APIs similares
uma `FileSystemException` era lançada.

Alguns usuários podem ter contornado esse problema escrevendo e usando um
[`goldenFileComparator`][`goldenFileComparator`] personalizado:

```dart
import 'package:integration_test/integration_test.dart';
import 'package:my_integration_test/custom_golden_file_comparator.dart';

void main() {
  goldenFileComparator = CustomGoldenFileComparatorThatWorks();

  // ...
}
```

Tais soluções alternativas não são mais necessárias, e se fizer verificação de tipo
do padrão, não funcionará mais como antes:

```dart
if (goldenFileComparator is ...) {
  // The new default is a new (hidden) type that has not existed before.
}
```

## Guia de migração

Na maioria dos casos, esperamos que os usuários não precisem fazer nada - esta será,
em certo sentido, uma funcionalidade _nova_ que substituiu uma funcionalidade que não
funcionava e causava uma exceção não tratada que falharia em um teste.

Nos casos em que os usuários escreveram infraestrutura de teste e comparadores
personalizados, considere remover as substituições de [`goldenFileComparator`][`goldenFileComparator`],
e confiar no padrão (novo) que deve funcionar como esperado:

```dart diff
  import 'package:integration_test/integration_test.dart';
- import 'package:my_integration_test/custom_golden_file_comparator.dart';

  void main() {
-   goldenFileComparator = CustomGoldenFileComparatorThatWorks();

    // ...
  }
```

_Curiosidade_: O código existente que foi usado para a plataforma _web_
foi [reutilizado][PR 160484].

## Cronograma

Disponível na versão: 3.29.0-0.0.pre<br>
Versão estável: 3.32

## Referências

APIs relevantes:

- [`flutter_test`][`flutter_test`], que fala sobre `flutter_test_config.dart` e suas capacidades.
- [`goldenFileComparator`][`goldenFileComparator`], que implementa comparação, e é configurável pelo usuário.

Issues relevantes:

- [Issue 143299][Issue 143299], um dos muitos relatos de usuários sobre o bug antigo.
- [Issue 160043][Issue 160043], que explica em detalhes técnicos por que [`matchesGoldenFile`][`matchesGoldenFile`] falhou.

PRs relevantes:

- [PR 160215][PR 160215], onde a implementação da ferramenta web foi refatorada para torná-la genérica.
- [PR 160484][PR 160484], que usa o protocolo de serviço da Dart VM para fazer proxy entre dispositivo e host.

[`flutter_test`]: {{site.api}}/flutter/flutter_test
[`goldenFileComparator`]: {{site.api}}/flutter/flutter_test/goldenFileComparator.html
[`integration_test`]: {{site.api}}/flutter/package-integration_test_integration_test/
[Issue 143299]: {{site.repo.flutter}}/issues/143299
[Issue 160043]: {{site.repo.flutter}}/issues/160043
[`matchesGoldenFile`]: {{site.api}}/flutter/flutter_test/MatchesGoldenFile-class.html
[PR 160215]: {{site.repo.flutter}}/pull/160215
[PR 160484]: {{site.repo.flutter}}/pull/160484
