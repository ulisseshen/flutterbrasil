---
ia-translate: true
title: Uma introdução a testes unitários
description: Como escrever testes unitários.
short-title: Introdução
---

<?code-excerpt path-base="cookbook/testing/unit/counter_app"?>

Como você pode garantir que seu aplicativo continue funcionando à medida que
adiciona mais recursos ou altera funcionalidades existentes?
Escrevendo testes.

Testes unitários são úteis para verificar o comportamento de uma única função,
método ou classe. O pacote [`test`][] fornece a
estrutura principal para escrever testes unitários, e o pacote [`flutter_test`][]
fornece utilitários adicionais para testar widgets.

Esta receita demonstra os recursos principais fornecidos pelo pacote `test`
usando as seguintes etapas:

  1. Adicione a dependência `test` ou `flutter_test`.
  2. Crie um arquivo de teste.
  3. Crie uma classe para testar.
  4. Escreva um `test` para nossa classe.
  5. Combine vários testes em um `group`.
  6. Execute os testes.

Para mais informações sobre o pacote test,
veja a [documentação do pacote test][].

## 1. Adicione a dependência test

O pacote `test` fornece a funcionalidade principal para
escrever testes em Dart. Esta é a melhor abordagem quando
escrevendo pacotes consumidos por web, servidor e aplicativos Flutter.

Para adicionar o pacote `test` como uma dependência de desenvolvimento,
execute `flutter pub add`:

```console
$ flutter pub add dev:test
```

## 2. Crie um arquivo de teste

Neste exemplo, crie dois arquivos: `counter.dart` e `counter_test.dart`.

O arquivo `counter.dart` contém uma classe que você deseja testar e
reside na pasta `lib`. O arquivo `counter_test.dart` contém
os próprios testes e reside dentro da pasta `test`.

Em geral, os arquivos de teste devem residir dentro de uma pasta `test`
localizada na raiz do seu aplicativo ou pacote Flutter.
Arquivos de teste sempre devem terminar com `_test.dart`,
esta é a convenção usada pelo executor de testes ao procurar testes.

Quando terminar, a estrutura de pastas deve ser assim:

```plaintext
counter_app/
  lib/
    counter.dart
  test/
    counter_test.dart
```

## 3. Crie uma classe para testar

Em seguida, você precisa de uma "unidade" para testar. Lembre-se: "unidade" é outro nome para uma
função, método ou classe. Para este exemplo, crie uma classe `Counter`
dentro do arquivo `lib/counter.dart`. Ela é responsável por incrementar
e decrementar um `value` começando em `0`.

<?code-excerpt "lib/counter.dart"?>
```dart
class Counter {
  int value = 0;

  void increment() => value++;

  void decrement() => value--;
}
```

**Nota:** Para simplificar, este tutorial não segue a abordagem de "Desenvolvimento Orientado a Testes" (Test Driven Development). Se você estiver mais confortável com esse estilo de
desenvolvimento, você sempre pode seguir esse caminho.

## 4. Escreva um teste para nossa classe

Dentro do arquivo `counter_test.dart`, escreva o primeiro teste unitário. Testes são
definidos usando a função de nível superior `test`, e você pode verificar se os resultados
estão corretos usando a função de nível superior `expect`.
Ambas as funções vêm do pacote `test`.

<?code-excerpt "test/counter_test.dart"?>
```dart
// Importe o pacote test e a classe Counter
import 'package:counter_app/counter.dart';
import 'package:test/test.dart';

void main() {
  test('O valor do contador deve ser incrementado', () {
    final counter = Counter();

    counter.increment();

    expect(counter.value, 1);
  });
}
```

## 5. Combine vários testes em um `group`

Se você deseja executar uma série de testes relacionados,
use a função [`group`][] do pacote `flutter_test` para categorizar os testes.
Uma vez colocados em um grupo, você pode chamar `flutter test` em todos os testes
desse grupo com um comando.

<?code-excerpt "test/group.dart"?>
```dart
import 'package:counter_app/counter.dart';
import 'package:test/test.dart';

void main() {
  group('Testar início, incremento e decremento', () {
    test('o valor deve começar em 0', () {
      expect(Counter().value, 0);
    });

    test('o valor deve ser incrementado', () {
      final counter = Counter();

      counter.increment();

      expect(counter.value, 1);
    });

    test('o valor deve ser decrementado', () {
      final counter = Counter();

      counter.decrement();

      expect(counter.value, -1);
    });
  });
}
```

## 6. Execute os testes

Agora que você tem uma classe `Counter` com testes em vigor,
você pode executar os testes.

### Execute testes usando IntelliJ ou VSCode

Os plugins Flutter para IntelliJ e VSCode suportam a execução de testes.
Essa é geralmente a melhor opção ao escrever testes porque fornece o
loop de feedback mais rápido, bem como a capacidade de definir pontos de interrupção.

-   **IntelliJ**

    1.  Abra o arquivo `counter_test.dart`
    2.  Vá para **Run** > **Run 'tests in counter_test.dart'**.
        Você também pode pressionar o atalho de teclado apropriado para sua plataforma.

-   **VSCode**

    1.  Abra o arquivo `counter_test.dart`
    2.  Vá para **Run** > **Start Debugging**.
        Você também pode pressionar o atalho de teclado apropriado para sua plataforma.

### Execute testes em um terminal

Para executar todos os testes do terminal,
execute o seguinte comando na raiz do projeto:

```console
flutter test test/counter_test.dart
```

Para executar todos os testes que você colocou em um `group`,
execute o seguinte comando na raiz do projeto:

```console
flutter test --plain-name "Testar início, incremento e decremento"
```

Este exemplo usa o `group` criado na **seção 5**.

Para saber mais sobre testes unitários, você pode executar este comando:

```console
flutter test --help
```

[`group`]: {{site.api}}/flutter/flutter_test/group.html
[`flutter_test`]: {{site.api}}/flutter/flutter_test/flutter_test-library.html
[`test`]: {{site.pub-pkg}}/test
[documentação do pacote test]: {{site.pub}}/packages/test
