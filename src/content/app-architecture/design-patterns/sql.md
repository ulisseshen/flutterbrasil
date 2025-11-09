---
ia-translate: true
title: "Arquitetura de armazenamento persistente: SQL"
description: Salve dados complexos de aplicação no dispositivo do usuário com SQL.
contentTags:
  - data
  - SQL
iconPath: /assets/images/docs/app-architecture/design-patterns/sql-icon.svg
order: 2
---

<?code-excerpt path-base="app-architecture/todo_data_service"?>

A maioria das aplicações Flutter,
não importa quão pequenas ou grandes elas sejam,
podem precisar armazenar dados no dispositivo do usuário em algum momento.
Por exemplo, chaves de API,
preferências do usuário ou dados que devem estar disponíveis offline.

Nesta receita,
você aprenderá como integrar armazenamento persistente para dados complexos usando SQL
em uma aplicação Flutter seguindo o padrão de design de arquitetura Flutter.

Para aprender como armazenar dados chave-valor mais simples,
dê uma olhada na receita do Cookbook:
[Persistent storage architecture: Key-value data][Persistent storage architecture: Key-value data].

Para ler esta receita,
você deve estar familiarizado com SQL e SQLite.
Se precisar de ajuda, você pode ler a receita [Persist data with SQLite][Persist data with SQLite]
antes de ler esta.

Este exemplo usa [`sqflite`][`sqflite`] com o plugin [`sqflite_common_ffi`][`sqflite_common_ffi`],
que combinados oferecem suporte para mobile e desktop.
O suporte para web é fornecido no plugin experimental
[`sqflite_common_ffi_web`][`sqflite_common_ffi_web`] mas não está incluído neste exemplo.

## Aplicação de exemplo: Aplicação de lista de tarefas

A aplicação de exemplo consiste em uma única tela com uma barra de aplicativo no topo,
uma lista de itens e um campo de entrada de texto na parte inferior.

<img src='/assets/images/docs/cookbook/architecture/todo_app_light.png'
class="site-mobile-screenshot" alt="ToDo application in light mode" >

O corpo da aplicação contém o `TodoListScreen`.
Esta tela contém um `ListView` de itens `ListTile`,
cada um representando um item de tarefa.
Na parte inferior, um `TextField` permite que os usuários criem novos itens de tarefa
escrevendo a descrição da tarefa e depois tocando no `FilledButton` "Add".

Os usuários podem tocar no `IconButton` de exclusão para excluir o item de tarefa.

A lista de itens de tarefa é armazenada localmente usando um serviço de banco de dados,
e restaurada quando o usuário inicia a aplicação.

:::note
O código-fonte completo e executável para este exemplo está
disponível em [`/examples/app-architecture/todo_data_service/`][`/examples/app-architecture/todo_data_service/`].
:::

## Armazenando dados complexos com SQL

Esta funcionalidade segue o [design de arquitetura Flutter][Flutter Architecture design] recomendado,
contendo uma camada de UI e uma camada de dados.
Além disso, na camada de domínio você encontrará o modelo de dados usado.

- Camada de UI com `TodoListScreen` e `TodoListViewModel`
- Camada de domínio com a classe de dados `Todo`
- Camada de dados com `TodoRepository` e `DatabaseService`

### Camada de apresentação da lista de tarefas

O `TodoListScreen` é um Widget que contém a UI encarregada de exibir
e criar os itens de tarefa.
Ele segue o [padrão MVVM][MVVM pattern]
e é acompanhado pelo `TodoListViewModel`,
que contém a lista de itens de tarefa
e três comandos para carregar, adicionar e excluir itens de tarefa.

Esta tela é dividida em duas partes,
uma contendo a lista de itens de tarefa,
implementada usando um `ListView`,
e a outra é um `TextField`
e um `Button`, usados para criar novos itens de tarefa.

O `ListView` é envolvido por um `ListenableBuilder`,
que escuta mudanças no `TodoListViewModel`,
e mostra um `ListTile` para cada item de tarefa.

<?code-excerpt "lib/ui/todo_list/widgets/todo_list_screen.dart (ListenableBuilder)" replace="/child: //g;/^\),$/)/g"?>
```dart
ListenableBuilder(
  listenable: widget.viewModel,
  builder: (context, child) {
    return ListView.builder(
      itemCount: widget.viewModel.todos.length,
      itemBuilder: (context, index) {
        final todo = widget.viewModel.todos[index];
        return ListTile(
          title: Text(todo.task),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => widget.viewModel.delete.execute(todo.id),
          ),
        );
      },
    );
  },
)
```

A lista de itens de tarefa é definida no `TodoListViewModel`,
e carregada pelo comando `load`.
Este método chama o `TodoRepository` e busca a lista de itens de tarefa.

<?code-excerpt "lib/ui/todo_list/viewmodel/todo_list_viewmodel.dart (TodoListViewModel)"?>
```dart
List<Todo> _todos = [];

List<Todo> get todos => _todos;

Future<Result<void>> _load() async {
  try {
    final result = await _todoRepository.fetchTodos();
    switch (result) {
      case Ok<List<Todo>>():
        _todos = result.value;
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  } on Exception catch (e) {
    return Result.error(e);
  } finally {
    notifyListeners();
  }
}
```

Pressionar o `FilledButton`,
executa o comando `add`
e passa o valor do controlador de texto.

<?code-excerpt "lib/ui/todo_list/widgets/todo_list_screen.dart (FilledButton)" replace="/^\),$/)/g"?>
```dart
FilledButton.icon(
  onPressed: () =>
      widget.viewModel.add.execute(_controller.text),
  label: const Text('Add'),
  icon: const Icon(Icons.add),
)
```

O comando `add` então chama o método `TodoRepository.createTodo()`
com o texto de descrição da tarefa e cria um novo item de tarefa.

O método `createTodo()` retorna a tarefa recém-criada,
que é então adicionada à lista `_todo` no view model.

Itens de tarefa contêm um identificador único gerado pelo banco de dados.
É por isso que o view model não cria o item de tarefa,
mas sim o `TodoRepository` o faz.

<?code-excerpt "lib/ui/todo_list/viewmodel/todo_list_viewmodel.dart (Add)"?>
```dart
Future<Result<void>> _add(String task) async {
  try {
    final result = await _todoRepository.createTodo(task);
    switch (result) {
      case Ok<Todo>():
        _todos.add(result.value);
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  } on Exception catch (e) {
    return Result.error(e);
  } finally {
    notifyListeners();
  }
}
```

Finalmente, o `TodoListScreen` também escuta o resultado no comando `add`.
Quando a ação é concluída, o `TextEditingController` é limpo.

<?code-excerpt "lib/ui/todo_list/widgets/todo_list_screen.dart (Add)"?>
```dart
void _onAdd() {
  // Clear the text field when the add command completes.
  if (widget.viewModel.add.completed) {
    widget.viewModel.add.clearResult();
    _controller.clear();
  }
}
```

Quando um usuário toca no `IconButton` no `ListTile`, o comando delete é executado.

<?code-excerpt "lib/ui/todo_list/widgets/todo_list_screen.dart (Delete)" replace="/trailing: //g;/^\),$/)/g"?>
```dart
IconButton(
  icon: const Icon(Icons.delete),
  onPressed: () => widget.viewModel.delete.execute(todo.id),
)
```

Então, o view model chama o método `TodoRepository.deleteTodo()`,
passando o identificador único do item de tarefa.
Um resultado correto remove o item de tarefa do view
model *e* da tela.

<?code-excerpt "lib/ui/todo_list/viewmodel/todo_list_viewmodel.dart (Delete)"?>
```dart
Future<Result<void>> _delete(int id) async {
  try {
    final result = await _todoRepository.deleteTodo(id);
    switch (result) {
      case Ok<void>():
        _todos.removeWhere((todo) => todo.id == id);
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  } on Exception catch (e) {
    return Result.error(e);
  } finally {
    notifyListeners();
  }
}
```

### Camada de domínio da lista de tarefas

A camada de domínio desta aplicação de exemplo contém
o modelo de dados do item `Todo`.

Os itens são representados por uma classe de dados imutável.
Neste caso, a aplicação usa o pacote `freezed` para gerar o código.

A classe tem duas propriedades, um ID representado por um `int`,
e uma descrição de tarefa, representada por uma `String`.

<?code-excerpt "lib/business/model/todo.dart (Todo)"?>
```dart
@freezed
abstract class Todo with _$Todo {
  const factory Todo({
    /// The unique identifier of the Todo item.
    required int id,

    /// The task description of the Todo item.
    required String task,
  }) = _Todo;
}
```

### Camada de dados da lista de tarefas

A camada de dados desta funcionalidade é composta por duas classes,
o `TodoRepository` e o `DatabaseService`.

O `TodoRepository` atua como a fonte da verdade para todos os itens de tarefa.
View models devem usar este repositório para acessar a lista de tarefas,
e ele não deve expor nenhum detalhe de implementação sobre como eles são armazenados.

Internamente, o `TodoRepository` usa o `DatabaseService`,
que implementa o acesso ao banco de dados SQL usando o pacote `sqflite`.
Você pode implementar o mesmo `DatabaseService` usando outros pacotes de armazenamento
como `sqlite3`, `drift` ou até soluções de armazenamento em nuvem como `firebase_database`.

O `TodoRepository` verifica se o banco de dados está aberto
antes de cada solicitação e o abre se necessário.

Ele implementa os métodos `fetchTodos()`, `createTodo()` e `deleteTodo()`.

<?code-excerpt "lib/data/repositories/todo_repository.dart (TodoRepository)"?>
```dart
class TodoRepository {
  TodoRepository({required DatabaseService database}) : _database = database;

  final DatabaseService _database;

  Future<Result<List<Todo>>> fetchTodos() async {
    if (!_database.isOpen()) {
      await _database.open();
    }
    return _database.getAll();
  }

  Future<Result<Todo>> createTodo(String task) async {
    if (!_database.isOpen()) {
      await _database.open();
    }
    return _database.insert(task);
  }

  Future<Result<void>> deleteTodo(int id) async {
    if (!_database.isOpen()) {
      await _database.open();
    }
    return _database.delete(id);
  }
}
```

O `DatabaseService` implementa o acesso ao banco de dados SQLite
usando o pacote `sqflite`.

É uma boa ideia definir os nomes de tabela e coluna como constantes
para evitar erros de digitação ao escrever código SQL.

<?code-excerpt "lib/data/services/database_service.dart (Table)"?>
```dart
static const String _todoTableName = 'todo';
static const String _idColumnName = '_id';
static const String _taskColumnName = 'task';
```

O método `open()` abre o banco de dados existente,
ou cria um novo se ele não existir.

<?code-excerpt "lib/data/services/database_service.dart (Open)"?>
```dart
Future<void> open() async {
  _database = await databaseFactory.openDatabase(
    join(await databaseFactory.getDatabasesPath(), 'app_database.db'),
    options: OpenDatabaseOptions(
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_todoTableName($_idColumnName INTEGER PRIMARY KEY AUTOINCREMENT, $_taskColumnName TEXT)',
        );
      },
      version: 1,
    ),
  );
}
```

Note que a coluna `id` é definida como `primary key` e `autoincrement`;
isso significa que cada item recém-inserido
recebe um novo valor para a coluna `id`.

O método `insert()` cria um novo item de tarefa no banco de dados,
e retorna uma instância Todo recém-criada.
O `id` é gerado como mencionado anteriormente.

<?code-excerpt "lib/data/services/database_service.dart (Insert)"?>
```dart
Future<Result<Todo>> insert(String task) async {
  try {
    final id = await _database!.insert(_todoTableName, {
      _taskColumnName: task,
    });
    return Result.ok(Todo(id: id, task: task));
  } on Exception catch (e) {
    return Result.error(e);
  }
}
```

Todas as operações do `DatabaseService` usam a classe `Result` para retornar um valor,
conforme recomendado pelas [recomendações de arquitetura Flutter][Flutter architecture recommendations].
Isso facilita o tratamento de erros em etapas posteriores no código da aplicação.

O método `getAll()` realiza uma consulta ao banco de dados,
obtendo todos os valores nas colunas `id` e `task`.
Para cada entrada, ele cria uma instância da classe `Todo`.

<?code-excerpt "lib/data/services/database_service.dart (GetAll)"?>
```dart
Future<Result<List<Todo>>> getAll() async {
  try {
    final entries = await _database!.query(
      _todoTableName,
      columns: [_idColumnName, _taskColumnName],
    );
    final list = entries
        .map(
          (element) => Todo(
            id: element[_idColumnName] as int,
            task: element[_taskColumnName] as String,
          ),
        )
        .toList();
    return Result.ok(list);
  } on Exception catch (e) {
    return Result.error(e);
  }
}
```

O método `delete()` realiza uma operação de exclusão no banco de dados
baseada no `id` do item de tarefa.

Neste caso, se nenhum item foi excluído, um erro é retornado,
indicando que algo deu errado.

<?code-excerpt "lib/data/services/database_service.dart (Delete)"?>
```dart
Future<Result<void>> delete(int id) async {
  try {
    final rowsDeleted = await _database!.delete(
      _todoTableName,
      where: '$_idColumnName = ?',
      whereArgs: [id],
    );
    if (rowsDeleted == 0) {
      return Result.error(Exception('No todo found with id $id'));
    }
    return Result.ok(null);
  } on Exception catch (e) {
    return Result.error(e);
  }
}
```

:::note
Em alguns casos, você pode querer fechar o banco de dados quando terminar de usá-lo.
Por exemplo, quando o usuário sair da tela,
ou após um certo tempo ter passado.

Isso depende da implementação do banco de dados
assim como dos requisitos da sua aplicação.
É recomendado que você verifique com os autores do pacote de banco de dados
para recomendações.
:::

## Juntando tudo

No método `main()` da sua aplicação,
primeiro inicialize o `DatabaseService`,
que requer código de inicialização diferente em diferentes plataformas.
Então, passe o `DatabaseService` recém-criado para o `TodoRepository`
que por sua vez é passado para o `MainApp` como uma dependência de argumento do construtor.

<?code-excerpt "lib/main.dart (MainTodo)"?>
```dart
void main() {
  late DatabaseService databaseService;
  if (kIsWeb) {
    throw UnsupportedError('Platform not supported');
  } else if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    // Initialize FFI SQLite
    sqfliteFfiInit();
    databaseService = DatabaseService(databaseFactory: databaseFactoryFfi);
  } else {
    // Use default native SQLite
    databaseService = DatabaseService(databaseFactory: databaseFactory);
  }

  runApp(
    MainApp(
      // ···
      todoRepository: TodoRepository(database: databaseService),
    ),
  );
}
```

Então, quando o `TodoListScreen` é criado,
também crie o `TodoListViewModel`
e passe o `TodoRepository` para ele como dependência.

<?code-excerpt "lib/main.dart (TodoListScreen)" replace="/body: //g;/^\),$/)/g"?>
```dart
TodoListScreen(
  viewModel: TodoListViewModel(todoRepository: widget.todoRepository),
)
```

[Flutter Architecture design]:/app-architecture
[Flutter architecture recommendations]:/app-architecture
[MVVM pattern]:/get-started/fundamentals/state-management#using-mvvm-for-your-applications-architecture
[Persist data with SQLite]:/cookbook/persistence/sqlite
[Persistent storage architecture: Key-value data]:/app-architecture/design-patterns/key-value-data
[`/examples/app-architecture/todo_data_service/`]: {{site.repo.this}}/tree/main/examples/app-architecture/todo_data_service/
[`sqflite_common_ffi_web`]:{{site.pub}}/packages/sqflite_common_ffi_web
[`sqflite_common_ffi`]:{{site.pub}}/packages/sqflite_common_ffi
[`sqflite`]:{{site.pub}}/packages/sqflite
