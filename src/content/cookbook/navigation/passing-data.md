---
ia-translate: true
title: Enviar dados para uma nova tela
description: Como passar dados para uma nova rota.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/navigation/passing_data"?>

Frequentemente, você não quer apenas navegar para uma nova tela,
mas também passar dados para essa tela.
Por exemplo, você pode querer passar informações sobre
o item que foi tocado.

Lembre-se: telas são apenas widgets.
Neste exemplo, crie uma lista de tarefas (todos).
Quando uma tarefa é tocada, navegue para uma nova tela (widget) que
exibe informações sobre a tarefa.
Esta receita usa os seguintes passos:

  1. Defina uma classe de tarefa.
  2. Exiba uma lista de tarefas.
  3. Crie uma tela de detalhes que pode exibir informações sobre uma tarefa.
  4. Navegue e passe dados para a tela de detalhes.

## 1. Defina uma classe de tarefa

Primeiro, você precisa de uma maneira simples de representar tarefas. Para este exemplo,
crie uma classe que contenha duas partes de dados: o título e a descrição.

<?code-excerpt "lib/main.dart (Todo)"?>
```dart
class Todo {
  final String title;
  final String description;

  const Todo(this.title, this.description);
}
```

## 2. Crie uma lista de tarefas

Segundo, exiba uma lista de tarefas. Neste exemplo, gere
20 tarefas e mostre-as usando um ListView.
Para mais informações sobre como trabalhar com listas,
veja a receita [Usar listas][].

### Gere a lista de tarefas

<?code-excerpt "lib/main.dart (Generate)" replace="/^todos:/final todos =/g/^\),$/);/g"?>
```dart
final todos = List.generate(
  20,
  (i) => Todo(
    'Todo $i',
    'Uma descrição do que precisa ser feito para a Tarefa $i',
  ),
);
```

### Exiba a lista de tarefas usando um ListView

<?code-excerpt "lib/main_todoscreen.dart (ListViewBuilder)" replace="/^body: //g;/^\),$/)/g"?>
```dart
ListView.builder(
  itemCount: todos.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(todos[index].title),
    );
  },
)
```

Até agora, tudo bem.
Isso gera 20 tarefas e as exibe em um ListView.

## 3. Crie uma tela de tarefas para exibir a lista

Para isso, criamos um `StatelessWidget`. Nós o chamamos de `TodosScreen`.
Como o conteúdo desta página não mudará durante o tempo de execução,
teremos que exigir a lista
de tarefas dentro do escopo deste widget.

Passamos nosso `ListView.builder` como corpo do widget que estamos retornando para `build()`.
Isso renderizará a lista na tela para você começar!

<?code-excerpt "lib/main_todoscreen.dart (TodosScreen)"?>
```dart
class TodosScreen extends StatelessWidget {
  // Requerendo a lista de tarefas.
  const TodosScreen({super.key, required this.todos});

  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      //passando o ListView.builder
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todos[index].title),
          );
        },
      ),
    );
  }
}
```

Com o estilo padrão do Flutter, você está pronto para começar sem se preocupar com
coisas que você gostaria de fazer mais tarde!

## 4. Crie uma tela de detalhes para exibir informações sobre uma tarefa

Agora, crie a segunda tela. O título da tela contém o
título da tarefa, e o corpo da tela mostra a descrição.

Como a tela de detalhes é um `StatelessWidget` normal,
exija que o usuário insira um `Todo` na UI.
Em seguida, construa a UI usando a tarefa fornecida.

<?code-excerpt "lib/main.dart (detail)"?>
```dart
class DetailScreen extends StatelessWidget {
  // No construtor, requer um Todo.
  const DetailScreen({super.key, required this.todo});

  // Declara um campo que armazena o Todo.
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    // Use o Todo para criar a UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(todo.description),
      ),
    );
  }
}
```

## 5. Navegue e passe dados para a tela de detalhes

Com uma `DetailScreen` no lugar,
você está pronto para realizar a Navegação.
Neste exemplo, navegue para a `DetailScreen` quando um usuário
tocar em uma tarefa na lista. Passe a tarefa para a `DetailScreen`.

Para capturar o toque do usuário na `TodosScreen`, escreva um callback [`onTap()`][]
para o widget `ListTile`. Dentro do callback `onTap()`,
use o método [`Navigator.push()`][].

<?code-excerpt "lib/main.dart (builder)"?>
```dart
body: ListView.builder(
  itemCount: todos.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(todos[index].title),
      // Quando um usuário toca no ListTile, navegue para a DetailScreen.
      // Observe que você não está apenas criando uma DetailScreen, você está
      // também passando a tarefa atual para ela.
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(todo: todos[index]),
          ),
        );
      },
    );
  },
),
```

### Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de passagem de dados no Flutter com DartPad" run="true"
import 'package:flutter/material.dart';

class Todo {
  final String title;
  final String description;

  const Todo(this.title, this.description);
}

void main() {
  runApp(
    MaterialApp(
      title: 'Passando Dados',
      home: TodosScreen(
        todos: List.generate(
          20,
          (i) => Todo(
            'Tarefa $i',
            'Uma descrição do que precisa ser feito para a Tarefa $i',
          ),
        ),
      ),
    ),
  );
}

class TodosScreen extends StatelessWidget {
  const TodosScreen({super.key, required this.todos});

  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todos[index].title),
            // Quando um usuário toca no ListTile, navegue para a DetailScreen.
            // Observe que você não está apenas criando uma DetailScreen, você está
            // também passando a tarefa atual para ela.
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(todo: todos[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  // No construtor, requer um Todo.
  const DetailScreen({super.key, required this.todo});

  // Declara um campo que armazena o Todo.
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    // Use o Todo para criar a UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(todo.description),
      ),
    );
  }
}
```

## Alternativamente, passe os argumentos usando RouteSettings

Repita os dois primeiros passos.

### Crie uma tela de detalhes para extrair os argumentos

Em seguida, crie uma tela de detalhes que extrai e exibe o título e a descrição do `Todo`. Para acessar o `Todo`, use o método [`ModalRoute.of()`][]. Este método retorna a rota atual com os argumentos.

<?code-excerpt "lib/main_routesettings.dart (DetailScreen)"?>
```dart
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todo = ModalRoute.of(context)!.settings.arguments as Todo;

    // Use o Todo para criar a UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(todo.description),
      ),
    );
  }
}
```

### Navegue e passe os argumentos para a tela de detalhes

Finalmente, navegue até a `DetailScreen` quando um usuário toca
em um widget `ListTile` usando `Navigator.push()`.
Passe os argumentos como parte do [`RouteSettings`][].
A `DetailScreen` extrai esses argumentos.

<?code-excerpt "lib/main_routesettings.dart (builder)" replace="/^body: //g;/^\),$/)/g"?>
```dart
ListView.builder(
  itemCount: todos.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(todos[index].title),
      // Quando um usuário toca no ListTile, navegue para a DetailScreen.
      // Observe que você não está apenas criando uma DetailScreen, você está
      // também passando a tarefa atual para ela.
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DetailScreen(),
            // Passe os argumentos como parte do RouteSettings. A
            // DetailScreen lê os argumentos dessas configurações.
            settings: RouteSettings(
              arguments: todos[index],
            ),
          ),
        );
      },
    );
  },
)
```

### Exemplo completo

<?code-excerpt "lib/main_routesettings.dart"?>
```dart
import 'package:flutter/material.dart';

class Todo {
  final String title;
  final String description;

  const Todo(this.title, this.description);
}

void main() {
  runApp(
    MaterialApp(
      title: 'Passando Dados',
      home: TodosScreen(
        todos: List.generate(
          20,
          (i) => Todo(
            'Tarefa $i',
            'Uma descrição do que precisa ser feito para a Tarefa $i',
          ),
        ),
      ),
    ),
  );
}

class TodosScreen extends StatelessWidget {
  const TodosScreen({super.key, required this.todos});

  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todos[index].title),
            // Quando um usuário toca no ListTile, navegue para a DetailScreen.
            // Observe que você não está apenas criando uma DetailScreen, você está
            // também passando a tarefa atual para ela.
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DetailScreen(),
                  // Passe os argumentos como parte do RouteSettings. A
                  // DetailScreen lê os argumentos dessas configurações.
                  settings: RouteSettings(
                    arguments: todos[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todo = ModalRoute.of(context)!.settings.arguments as Todo;

    // Use o Todo para criar a UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(todo.description),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/passing-data.gif" alt="Demo de Passagem de Dados" class="site-mobile-screenshot" />
</noscript>


[`ModalRoute.of()`]: {{site.api}}/flutter/widgets/ModalRoute/of.html
[`Navigator.push()`]: {{site.api}}/flutter/widgets/Navigator/push.html
[`onTap()`]: {{site.api}}/flutter/material/ListTile/onTap.html
[`RouteSettings`]: {{site.api}}/flutter/widgets/RouteSettings-class.html
[Usar listas]: /cookbook/lists/basic-list
