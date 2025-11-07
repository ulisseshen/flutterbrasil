---
title: Persistir dados com SQLite
description: Como usar SQLite para armazenar e recuperar dados.
ia-translate: true
---

<?code-excerpt path-base="cookbook/persistence/sqlite/"?>

:::note
Este guia usa o [sqflite package][].
Este pacote suporta apenas apps que rodam em
macOS, iOS ou Android.
:::

[sqflite package]: {{site.pub-pkg}}/sqflite

Se você está escrevendo um app que precisa persistir e consultar grandes quantidades de dados no
dispositivo local, considere usar um banco de dados ao invés de um arquivo local ou
armazenamento de chave-valor. Em geral, bancos de dados fornecem inserções, atualizações,
e consultas mais rápidas comparado a outras soluções de persistência local.

Apps Flutter podem fazer uso de bancos de dados SQLite através do
plugin [`sqflite`][] disponível no pub.dev.
Esta receita demonstra o básico de usar `sqflite`
para inserir, ler, atualizar e remover dados sobre vários Dogs.

Se você é novo no SQLite e instruções SQL, revise o
[SQLite Tutorial][] para aprender o básico antes
de completar esta receita.

Esta receita usa os seguintes passos:

  1. Adicionar as dependências.
  2. Definir o modelo de dados `Dog`.
  3. Abrir o banco de dados.
  4. Criar a tabela `dogs`.
  5. Inserir um `Dog` no banco de dados.
  6. Recuperar a lista de dogs.
  7. Atualizar um `Dog` no banco de dados.
  7. Deletar um `Dog` do banco de dados.

## 1. Adicionar as dependências

Para trabalhar com bancos de dados SQLite, importe os pacotes `sqflite` e
`path`.

  * O pacote `sqflite` fornece classes e funções para
    interagir com um banco de dados SQLite.
  * O pacote `path` fornece funções para
    definir a localização para armazenar o banco de dados em disco.

Para adicionar os pacotes como uma dependência,
execute `flutter pub add`:

```console
$ flutter pub add sqflite path
```

Certifique-se de importar os pacotes no arquivo em que você trabalhará.

<?code-excerpt "lib/main.dart (imports)"?>
```dart
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
```

## 2. Definir o modelo de dados Dog

Antes de criar a tabela para armazenar informações sobre Dogs, reserve alguns momentos para
definir os dados que precisam ser armazenados. Para este exemplo, defina uma classe Dog
que contém três pedaços de dados:
Um `id` único, o `name`, e a `age` de cada dog.

<?code-excerpt "lib/step2.dart"?>
```dart
class Dog {
  final int id;
  final String name;
  final int age;

  const Dog({
    required this.id,
    required this.name,
    required this.age,
  });
}
```

## 3. Abrir o banco de dados

Antes de ler e escrever dados no banco de dados, abra uma conexão
com o banco de dados. Isso envolve dois passos:

  1. Defina o caminho para o arquivo de banco de dados usando `getDatabasesPath()` do
  pacote `sqflite`, combinado com a função `join` do pacote `path`.
  2. Abra o banco de dados com a função `openDatabase()` do `sqflite`.

:::note
Para usar a palavra-chave `await`, o código deve ser colocado
dentro de uma função `async`. Você deve colocar todas as seguintes
funções de tabela dentro de `void main() async {}`.
:::

<?code-excerpt "lib/step3.dart (openDatabase)"?>
```dart
// Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.
WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
final database = openDatabase(
  // Set the path to the database. Note: Using the `join` function from the
  // `path` package is best practice to ensure the path is correctly
  // constructed for each platform.
  join(await getDatabasesPath(), 'doggie_database.db'),
);
```

## 4. Criar a tabela `dogs`

Em seguida, crie uma tabela para armazenar informações sobre vários Dogs.
Para este exemplo, crie uma tabela chamada `dogs` que define os dados
que podem ser armazenados. Cada `Dog` contém um `id`, `name` e `age`.
Portanto, estes são representados como três colunas na tabela `dogs`.

  1. O `id` é um `int` Dart, e é armazenado como um `INTEGER` SQLite
     Datatype. Também é uma boa prática usar um `id` como a chave primária
     da tabela para melhorar os tempos de consulta e atualização.
  2. O `name` é uma `String` Dart, e é armazenado como um `TEXT` SQLite
     Datatype.
  3. A `age` também é um `int` Dart, e é armazenado como um `INTEGER`
     Datatype.

Para mais informações sobre os Datatypes disponíveis que podem ser armazenados em um
banco de dados SQLite, veja a [official SQLite Datatypes documentation][].

<?code-excerpt "lib/main.dart (openDatabase)"?>
```dart
final database = openDatabase(
  // Set the path to the database. Note: Using the `join` function from the
  // `path` package is best practice to ensure the path is correctly
  // constructed for each platform.
  join(await getDatabasesPath(), 'doggie_database.db'),
  // When the database is first created, create a table to store dogs.
  onCreate: (db, version) {
    // Run the CREATE TABLE statement on the database.
    return db.execute(
      'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
    );
  },
  // Set the version. This executes the onCreate function and provides a
  // path to perform database upgrades and downgrades.
  version: 1,
);
```

## 5. Inserir um Dog no banco de dados

Agora que você tem um banco de dados com uma tabela adequada para armazenar informações
sobre vários dogs, é hora de ler e escrever dados.

Primeiro, insira um `Dog` na tabela `dogs`. Isso envolve dois passos:

1. Converter o `Dog` em um `Map`
2. Usar o método [`insert()`][] para armazenar o
   `Map` na tabela `dogs`.

<?code-excerpt "lib/main.dart (Dog)"?>
```dart
class Dog {
  final int id;
  final String name;
  final int age;

  Dog({
    required this.id,
    required this.name,
    required this.age,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}
```

<?code-excerpt "lib/main.dart (insertDog)"?>
```dart
// Define a function that inserts dogs into the database
Future<void> insertDog(Dog dog) async {
  // Get a reference to the database.
  final db = await database;

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'dogs',
    dog.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
```

<?code-excerpt "lib/main.dart (fido)"?>
```dart
// Create a Dog and add it to the dogs table
var fido = Dog(
  id: 0,
  name: 'Fido',
  age: 35,
);

await insertDog(fido);
```

## 6. Recuperar a lista de Dogs

Agora que um `Dog` está armazenado no banco de dados, consulte o banco de dados
para um dog específico ou uma lista de todos os dogs. Isso envolve dois passos:

  1. Execute uma `query` contra a tabela `dogs`. Isso retorna um `List<Map>`.
  2. Converta o `List<Map>` em um `List<Dog>`.

<?code-excerpt "lib/main.dart (dogs)"?>
```dart
// A method that retrieves all the dogs from the dogs table.
Future<List<Dog>> dogs() async {
  // Get a reference to the database.
  final db = await database;

  // Query the table for all the dogs.
  final List<Map<String, Object?>> dogMaps = await db.query('dogs');

  // Convert the list of each dog's fields into a list of `Dog` objects.
  return [
    for (final {
          'id': id as int,
          'name': name as String,
          'age': age as int,
        } in dogMaps)
      Dog(id: id, name: name, age: age),
  ];
}
```

<?code-excerpt "lib/main.dart (print)"?>
```dart
// Now, use the method above to retrieve all the dogs.
print(await dogs()); // Prints a list that include Fido.
```

## 7. Atualizar um `Dog` no banco de dados

Depois de inserir informações no banco de dados,
você pode querer atualizar essa informação em um momento posterior.
Você pode fazer isso usando o método [`update()`][]
da biblioteca `sqflite`.

Isso envolve dois passos:

  1. Converter o Dog em um Map.
  2. Usar uma cláusula `where` para garantir que você atualize o Dog correto.

<?code-excerpt "lib/main.dart (update)"?>
```dart
Future<void> updateDog(Dog dog) async {
  // Get a reference to the database.
  final db = await database;

  // Update the given Dog.
  await db.update(
    'dogs',
    dog.toMap(),
    // Ensure that the Dog has a matching id.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [dog.id],
  );
}
```

<?code-excerpt "lib/main.dart (update2)"?>
```dart
// Update Fido's age and save it to the database.
fido = Dog(
  id: fido.id,
  name: fido.name,
  age: fido.age + 7,
);
await updateDog(fido);

// Print the updated results.
print(await dogs()); // Prints Fido with age 42.
```

:::warning
Sempre use `whereArgs` para passar argumentos para uma instrução `where`.
Isso ajuda a proteger contra ataques de injeção SQL.

Não use interpolação de string, como `where: "id = ${dog.id}"`!
:::


## 8. Deletar um `Dog` do banco de dados

Além de inserir e atualizar informações sobre Dogs,
você também pode remover dogs do banco de dados. Para deletar dados,
use o método [`delete()`][] da biblioteca `sqflite`.

Nesta seção, crie uma função que pega um id e deleta o dog com
um id correspondente do banco de dados. Para fazer isso funcionar, você deve fornecer uma cláusula `where`
para limitar os registros sendo deletados.

<?code-excerpt "lib/main.dart (deleteDog)"?>
```dart
Future<void> deleteDog(int id) async {
  // Get a reference to the database.
  final db = await database;

  // Remove the Dog from the database.
  await db.delete(
    'dogs',
    // Use a `where` clause to delete a specific dog.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );
}
```

## Exemplo

Para executar o exemplo:

  1. Crie um novo projeto Flutter.
  2. Adicione os pacotes `sqflite` e `path` ao seu `pubspec.yaml`.
  3. Cole o código a seguir em um novo arquivo chamado `lib/db_test.dart`.
  4. Execute o código com `flutter run lib/db_test.dart`.

<?code-excerpt "lib/main.dart"?>
```dart
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'doggie_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  // Define a function that inserts dogs into the database
  Future<void> insertDog(Dog dog) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Dog>> dogs() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all the dogs.
    final List<Map<String, Object?>> dogMaps = await db.query('dogs');

    // Convert the list of each dog's fields into a list of `Dog` objects.
    return [
      for (final {
            'id': id as int,
            'name': name as String,
            'age': age as int,
          } in dogMaps)
        Dog(id: id, name: name, age: age),
    ];
  }

  Future<void> updateDog(Dog dog) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'dogs',
      dog.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'dogs',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  // Create a Dog and add it to the dogs table
  var fido = Dog(
    id: 0,
    name: 'Fido',
    age: 35,
  );

  await insertDog(fido);

  // Now, use the method above to retrieve all the dogs.
  print(await dogs()); // Prints a list that include Fido.

  // Update Fido's age and save it to the database.
  fido = Dog(
    id: fido.id,
    name: fido.name,
    age: fido.age + 7,
  );
  await updateDog(fido);

  // Print the updated results.
  print(await dogs()); // Prints Fido with age 42.

  // Delete Fido from the database.
  await deleteDog(fido.id);

  // Print the list of dogs (empty).
  print(await dogs());
}

class Dog {
  final int id;
  final String name;
  final int age;

  Dog({
    required this.id,
    required this.name,
    required this.age,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}
```


[`delete()`]: {{site.pub-api}}/sqflite_common/latest/sqlite_api/DatabaseExecutor/delete.html
[`insert()`]: {{site.pub-api}}/sqflite_common/latest/sqlite_api/DatabaseExecutor/insert.html
[`sqflite`]: {{site.pub-pkg}}/sqflite
[SQLite Tutorial]: http://www.sqlitetutorial.net/
[official SQLite Datatypes documentation]: https://www.sqlite.org/datatype3.html
[`update()`]: {{site.pub-api}}/sqflite_common/latest/sqlite_api/DatabaseExecutor/update.html
