---
ia-translate: true
title: Persistir dados com SQLite
description: Como usar o SQLite para armazenar e recuperar dados.
---

<?code-excerpt path-base="cookbook/persistence/sqlite/"?>

:::note
Este guia utiliza o pacote [sqflite][].
Este pacote oferece suporte apenas a aplicativos que são executados em
macOS, iOS ou Android.
:::

[sqflite package]: {{site.pub-pkg}}/sqflite

Se você está escrevendo um aplicativo que precisa persistir e consultar grandes quantidades de dados no
dispositivo local, considere usar um banco de dados em vez de um arquivo local ou
armazenamento chave-valor. Em geral, os bancos de dados fornecem inserções, atualizações
e consultas mais rápidas em comparação com outras soluções de persistência local.

Os aplicativos Flutter podem usar os bancos de dados SQLite através do
plugin [`sqflite`][] disponível em pub.dev.
Esta receita demonstra o básico de como usar `sqflite`
para inserir, ler, atualizar e remover dados sobre vários Dogs.

Se você é novo no SQLite e nas instruções SQL, revise o
[Tutorial SQLite][] para aprender o básico antes de
concluir esta receita.

Esta receita usa as seguintes etapas:

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
    definir o local para armazenar o banco de dados no disco.

Para adicionar os pacotes como uma dependência,
execute `flutter pub add`:

```console
$ flutter pub add sqflite path
```

Certifique-se de importar os pacotes no arquivo em que você estará trabalhando.

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
que contém três partes de dados:
Um `id` único, o `nome` e a `idade` de cada dog.

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

Antes de ler e gravar dados no banco de dados, abra uma conexão
com o banco de dados. Isso envolve duas etapas:

  1. Defina o caminho para o arquivo do banco de dados usando `getDatabasesPath()` do
  pacote `sqflite`, combinado com a função `join` do pacote `path`.
  2. Abra o banco de dados com a função `openDatabase()` do `sqflite`.

:::note
Para usar a palavra-chave `await`, o código deve ser colocado
dentro de uma função `async`. Você deve colocar todas as funções
de tabela a seguir dentro de `void main() async {}`.
:::

<?code-excerpt "lib/step3.dart (openDatabase)"?>
```dart
// Evite erros causados pela atualização do flutter.
// Importar 'package:flutter/widgets.dart' é obrigatório.
WidgetsFlutterBinding.ensureInitialized();
// Abra o banco de dados e armazene a referência.
final database = openDatabase(
  // Defina o caminho para o banco de dados. Nota: Usar a função `join` do
  // pacote `path` é a melhor prática para garantir que o caminho seja construído
  // corretamente para cada plataforma.
  join(await getDatabasesPath(), 'doggie_database.db'),
);
```

## 4. Criar a tabela `dogs`

Em seguida, crie uma tabela para armazenar informações sobre vários Dogs.
Para este exemplo, crie uma tabela chamada `dogs` que define os dados
que podem ser armazenados. Cada `Dog` contém um `id`, `name` e `age`.
Portanto, eles são representados como três colunas na tabela `dogs`.

  1. O `id` é um `int` Dart e é armazenado como um `INTEGER` SQLite
     Datatype. Também é uma boa prática usar um `id` como a chave primária
     para a tabela para melhorar os tempos de consulta e atualização.
  2. O `name` é uma `String` Dart e é armazenado como um `TEXT` SQLite
     Datatype.
  3. A `age` também é um `int` Dart e é armazenada como um `INTEGER`
     Datatype.

Para obter mais informações sobre os Datatypes disponíveis que podem ser armazenados em um
banco de dados SQLite, consulte a [documentação oficial de Datatypes do SQLite][].

<?code-excerpt "lib/main.dart (openDatabase)"?>
```dart
final database = openDatabase(
  // Defina o caminho para o banco de dados. Nota: Usar a função `join` do
  // pacote `path` é a melhor prática para garantir que o caminho seja construído
  // corretamente para cada plataforma.
  join(await getDatabasesPath(), 'doggie_database.db'),
  // Quando o banco de dados é criado pela primeira vez, crie uma tabela para armazenar dogs.
  onCreate: (db, version) {
    // Execute a instrução CREATE TABLE no banco de dados.
    return db.execute(
      'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
    );
  },
  // Defina a versão. Isso executa a função onCreate e fornece um
  // caminho para realizar upgrades e downgrades do banco de dados.
  version: 1,
);
```

## 5. Inserir um Dog no banco de dados

Agora que você tem um banco de dados com uma tabela adequada para armazenar informações
sobre vários dogs, é hora de ler e gravar dados.

Primeiro, insira um `Dog` na tabela `dogs`. Isso envolve duas etapas:

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

  // Converta um Dog em um Map. As chaves devem corresponder aos nomes do
  // colunas no banco de dados.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Implemente toString para facilitar a visualização de informações sobre
  // cada dog ao usar a instrução print.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}
```

<?code-excerpt "lib/main.dart (insertDog)"?>
```dart
// Defina uma função que insere dogs no banco de dados
Future<void> insertDog(Dog dog) async {
  // Obtenha uma referência para o banco de dados.
  final db = await database;

  // Insira o Dog na tabela correta. Você também pode especificar o
  // `conflictAlgorithm` para usar caso o mesmo dog seja inserido duas vezes.
  //
  // Nesse caso, substitua todos os dados anteriores.
  await db.insert(
    'dogs',
    dog.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
```

<?code-excerpt "lib/main.dart (fido)"?>
```dart
// Crie um Dog e adicione-o à tabela dogs
var fido = Dog(
  id: 0,
  name: 'Fido',
  age: 35,
);

await insertDog(fido);
```

## 6. Recuperar a lista de Dogs

Agora que um `Dog` está armazenado no banco de dados, consulte o banco de dados
para um dog específico ou uma lista de todos os dogs. Isso envolve duas etapas:

  1. Execute uma `query` na tabela `dogs`. Isso retorna um `List<Map>`.
  2. Converter o `List<Map>` em um `List<Dog>`.

<?code-excerpt "lib/main.dart (dogs)"?>
```dart
// Um método que recupera todos os dogs da tabela dogs.
Future<List<Dog>> dogs() async {
  // Obtenha uma referência para o banco de dados.
  final db = await database;

  // Consulte a tabela para todos os dogs.
  final List<Map<String, Object?>> dogMaps = await db.query('dogs');

  // Converta a lista de campos de cada dog em uma lista de objetos `Dog`.
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
// Agora, use o método acima para recuperar todos os dogs.
print(await dogs()); // Imprime uma lista que inclui Fido.
```

## 7. Atualizar um `Dog` no banco de dados

Depois de inserir informações no banco de dados,
você pode querer atualizar essas informações posteriormente.
Você pode fazer isso usando o método [`update()`][]
da biblioteca `sqflite`.

Isso envolve duas etapas:

  1. Converter o Dog em um Map.
  2. Use uma cláusula `where` para garantir que você atualize o Dog correto.

<?code-excerpt "lib/main.dart (update)"?>
```dart
Future<void> updateDog(Dog dog) async {
  // Obtenha uma referência para o banco de dados.
  final db = await database;

  // Atualize o Dog fornecido.
  await db.update(
    'dogs',
    dog.toMap(),
    // Certifique-se de que o Dog tenha um id correspondente.
    where: 'id = ?',
    // Passe o id do Dog como um whereArg para evitar injeção de SQL.
    whereArgs: [dog.id],
  );
}
```

<?code-excerpt "lib/main.dart (update2)"?>
```dart
// Atualize a idade do Fido e salve-a no banco de dados.
fido = Dog(
  id: fido.id,
  name: fido.name,
  age: fido.age + 7,
);
await updateDog(fido);

// Imprima os resultados atualizados.
print(await dogs()); // Imprime Fido com idade 42.
```

:::warning
Sempre use `whereArgs` para passar argumentos para uma instrução `where`.
Isso ajuda a proteger contra ataques de injeção de SQL.

Não use interpolação de string, como `where: "id = ${dog.id}"`!
:::

## 8. Deletar um `Dog` do banco de dados

Além de inserir e atualizar informações sobre Dogs,
você também pode remover dogs do banco de dados. Para excluir dados,
use o método [`delete()`][] da biblioteca `sqflite`.

Nesta seção, crie uma função que recebe um id e exclui o dog com
um id correspondente do banco de dados. Para que isso funcione, você deve fornecer uma cláusula `where`
para limitar os registros que estão sendo excluídos.

<?code-excerpt "lib/main.dart (deleteDog)"?>
```dart
Future<void> deleteDog(int id) async {
  // Obtenha uma referência para o banco de dados.
  final db = await database;

  // Remova o Dog do banco de dados.
  await db.delete(
    'dogs',
    // Use uma cláusula `where` para excluir um dog específico.
    where: 'id = ?',
    // Passe o id do Dog como um whereArg para evitar injeção de SQL.
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
  // Evite erros causados pela atualização do flutter.
  // Importar 'package:flutter/widgets.dart' é obrigatório.
  WidgetsFlutterBinding.ensureInitialized();
  // Abra o banco de dados e armazene a referência.
  final database = openDatabase(
    // Defina o caminho para o banco de dados. Nota: Usar a função `join` do
    // pacote `path` é a melhor prática para garantir que o caminho seja construído
    // corretamente para cada plataforma.
    join(await getDatabasesPath(), 'doggie_database.db'),
    // Quando o banco de dados é criado pela primeira vez, crie uma tabela para armazenar dogs.
    onCreate: (db, version) {
      // Execute a instrução CREATE TABLE no banco de dados.
      return db.execute(
        'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
      );
    },
    // Defina a versão. Isso executa a função onCreate e fornece um
    // caminho para realizar upgrades e downgrades do banco de dados.
    version: 1,
  );

  // Defina uma função que insere dogs no banco de dados
  Future<void> insertDog(Dog dog) async {
    // Obtenha uma referência para o banco de dados.
    final db = await database;

    // Insira o Dog na tabela correta. Você também pode especificar o
    // `conflictAlgorithm` para usar caso o mesmo dog seja inserido duas vezes.
    //
    // Nesse caso, substitua todos os dados anteriores.
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Um método que recupera todos os dogs da tabela dogs.
  Future<List<Dog>> dogs() async {
    // Obtenha uma referência para o banco de dados.
    final db = await database;

    // Consulte a tabela para todos os dogs.
    final List<Map<String, Object?>> dogMaps = await db.query('dogs');

    // Converta a lista de campos de cada dog em uma lista de objetos `Dog`.
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
    // Obtenha uma referência para o banco de dados.
    final db = await database;

    // Atualize o Dog fornecido.
    await db.update(
      'dogs',
      dog.toMap(),
      // Certifique-se de que o Dog tenha um id correspondente.
      where: 'id = ?',
      // Passe o id do Dog como um whereArg para evitar injeção de SQL.
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(int id) async {
    // Obtenha uma referência para o banco de dados.
    final db = await database;

    // Remova o Dog do banco de dados.
    await db.delete(
      'dogs',
      // Use uma cláusula `where` para excluir um dog específico.
      where: 'id = ?',
      // Passe o id do Dog como um whereArg para evitar injeção de SQL.
      whereArgs: [id],
    );
  }

  // Crie um Dog e adicione-o à tabela dogs
  var fido = Dog(
    id: 0,
    name: 'Fido',
    age: 35,
  );

  await insertDog(fido);

  // Agora, use o método acima para recuperar todos os dogs.
  print(await dogs()); // Imprime uma lista que inclui Fido.

  // Atualize a idade do Fido e salve-a no banco de dados.
  fido = Dog(
    id: fido.id,
    name: fido.name,
    age: fido.age + 7,
  );
  await updateDog(fido);

  // Imprima os resultados atualizados.
  print(await dogs()); // Imprime Fido com idade 42.

  // Delete Fido do banco de dados.
  await deleteDog(fido.id);

  // Imprima a lista de dogs (vazia).
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

  // Converta um Dog em um Map. As chaves devem corresponder aos nomes do
  // colunas no banco de dados.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Implemente toString para facilitar a visualização de informações sobre
  // cada dog ao usar a instrução print.
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
