---
ia-translate: true
title: Uma introdução aos testes unitários
description: Como escrever testes unitários.
shortTitle: Introdução
---

<?code-excerpt path-base="cookbook/testing/unit/counter_app"?>

Como você pode garantir que seu app continue funcionando conforme você
adiciona mais recursos ou muda funcionalidades existentes?
Escrevendo testes.

Testes unitários são úteis para verificar o comportamento de uma única função,
método ou classe. O pacote [`test`][`test`] fornece o
framework principal para escrever testes unitários, e o pacote [`flutter_test`][`flutter_test`]
fornece utilitários adicionais para testar widgets.

Esta receita demonstra os recursos principais fornecidos pelo pacote `test`
usando os seguintes passos:

  1. Adicionar a dependência `test` ou `flutter_test`.
  2. Criar um arquivo de teste.
  3. Criar uma classe para testar.
  4. Escrever um `test` para nossa classe.
  5. Combinar múltiplos testes em um `group`.
  6. Executar os testes.

Para mais informações sobre o pacote test,
veja a [documentação do pacote test][test package documentation].

## 1. Adicionar a dependência test

O pacote `test` fornece a funcionalidade principal para
escrever testes em Dart. Esta é a melhor abordagem quando
escrevendo pacotes consumidos por apps web, server e Flutter.

Para adicionar o pacote `test` como uma dependência de desenvolvimento,
execute `flutter pub add`:

```console
$ flutter pub add dev:test
```

## 2. Criar um arquivo de teste

Neste exemplo, crie dois arquivos: `counter.dart` e `counter_test.dart`.

O arquivo `counter.dart` contém uma classe que você quer testar e
reside na pasta `lib`. O arquivo `counter_test.dart` contém
os testes em si e fica dentro da pasta `test`.

Em geral, arquivos de teste devem residir dentro de uma pasta `test`
localizada na raiz de sua aplicação ou pacote Flutter.
Arquivos de teste devem sempre terminar com `_test.dart`,
esta é a convenção usada pelo test runner ao procurar por testes.

Quando você terminar, a estrutura de pastas deve ficar assim:

```plaintext
counter_app/
  lib/
    counter.dart
  test/
    counter_test.dart
```

## 3. Criar uma classe para testar

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

**Nota:** Para simplicidade, este tutorial não segue a abordagem "Test Driven
Development". Se você se sente mais confortável com esse estilo de
desenvolvimento, você pode sempre seguir essa rota.

## 4. Escrever um teste para nossa classe

Dentro do arquivo `counter_test.dart`, escreva o primeiro teste unitário. Testes são
definidos usando a função top-level `test`, e você pode verificar se os resultados
estão corretos usando a função top-level `expect`.
Ambas essas funções vêm do pacote `test`.

<?code-excerpt "test/counter_test.dart"?>
```dart
// Import the test package and Counter class
import 'package:counter_app/counter.dart';
import 'package:test/test.dart';

void main() {
  test('Counter value should be incremented', () {
    final counter = Counter();

    counter.increment();

    expect(counter.value, 1);
  });
}
```

## 5. Combinar múltiplos testes em um `group`

Se você quer executar uma série de testes relacionados,
use a função [`group`][`group`] do pacote `flutter_test` para categorizar os testes.
Uma vez colocados em um grupo, você pode chamar `flutter test` em todos os testes
naquele grupo com um único comando.

<?code-excerpt "test/group.dart"?>
```dart
import 'package:counter_app/counter.dart';
import 'package:test/test.dart';

void main() {
  group('Test start, increment, decrement', () {
    test('value should start at 0', () {
      expect(Counter().value, 0);
    });

    test('value should be incremented', () {
      final counter = Counter();

      counter.increment();

      expect(counter.value, 1);
    });

    test('value should be decremented', () {
      final counter = Counter();

      counter.decrement();

      expect(counter.value, -1);
    });
  });
}
```

## 6. Executar os testes

Agora que você tem uma classe `Counter` com testes no lugar,
você pode executar os testes.

### Executar testes usando IntelliJ ou VSCode

Os plugins Flutter para IntelliJ e VSCode suportam executar testes.
Esta é frequentemente a melhor opção ao escrever testes porque fornece o
loop de feedback mais rápido assim como a habilidade de definir breakpoints.

- **IntelliJ**

  1. Abra o arquivo `counter_test.dart`
  1. Vá para **Run** > **Run 'tests in counter_test.dart'**.
     Você também pode pressionar o atalho de teclado apropriado para sua plataforma.

- **VSCode**

  1. Abra o arquivo `counter_test.dart`
  1. Vá para **Run** > **Start Debugging**.
     Você também pode pressionar o atalho de teclado apropriado para sua plataforma.

### Executar testes em um terminal

Para executar todos os testes do terminal,
execute o seguinte comando da raiz do projeto:

```console
flutter test test/counter_test.dart
```

Para executar todos os testes que você colocou em um `group`,
execute o seguinte comando da raiz do projeto:

```console
flutter test --plain-name "Test start, increment, decrement"
```

Este exemplo usa o `group` criado na **seção 5**.

Para aprender mais sobre testes unitários, você pode executar este comando:

```console
flutter test --help
```

[`group`]: {{site.api}}/flutter/flutter_test/group.html
[`flutter_test`]: {{site.api}}/flutter/flutter_test/flutter_test-library.html
[`test`]: {{site.pub-pkg}}/test
[test package documentation]: {{site.pub}}/packages/test
