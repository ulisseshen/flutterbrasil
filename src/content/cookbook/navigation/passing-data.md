---
ia-translate: true
title: Enviar dados para uma nova tela
description: Como passar dados para uma nova rota.
---

<?code-excerpt path-base="cookbook/navigation/passing_data"?>

Frequentemente, você não quer apenas navegar para uma nova tela,
mas também passar dados para a tela.
Por exemplo, você pode querer passar informações sobre
o item que foi tocado.

Lembre-se: Telas são apenas widgets.
Neste exemplo, crie uma lista de todos.
Quando um todo é tocado, navegue para uma nova tela (widget) que
exibe informações sobre o todo.
Esta receita usa os seguintes passos:

  1. Definir uma classe todo.
  2. Exibir uma lista de todos.
  3. Criar uma tela de detalhe que pode exibir informações sobre um todo.
  4. Navegar e passar dados para a tela de detalhe.

## 1. Definir uma classe todo

Primeiro, você precisa de uma maneira simples de representar todos. Para este exemplo,
crie uma classe que contém dois pedaços de dados: o título e descrição.

<?code-excerpt "lib/main.dart (Todo)"?>
```dart
class Todo {
  final String title;
  final String description;

  const Todo(this.title, this.description);
}
```

## 2. Criar uma lista de todos

Segundo, exiba uma lista de todos. Neste exemplo, gere
20 todos e mostre-os usando um ListView.
Para mais informações sobre trabalhar com listas,
veja a receita [Use lists][].

### Gerar a lista de todos

<?code-excerpt "lib/main.dart (Generate)" replace="/^todos:/final todos =/g/^\),$/);/g"?>
```dart
final todos = List.generate(
  20,
  (i) => Todo(
    'Todo $i',
    'A description of what needs to be done for Todo $i',
  ),
);
```

### Exibir a lista de todos usando um ListView

<?code-excerpt "lib/main_todoscreen.dart (ListViewBuilder)" replace="/^body: //g;/^\),$/)/g"?>
```dart
ListView.builder(
  itemCount: todos.length,
  itemBuilder: (context, index) {
    return ListTile(title: Text(todos[index].title));
  },
)
```

Até agora, tudo bem.
Isso gera 20 todos e os exibe em um ListView.

## 3. Criar uma tela Todo para exibir a lista

Para isso, criamos um `StatelessWidget`. Nós o chamamos de `TodosScreen`.
Como o conteúdo desta página não mudará durante o runtime,
teremos que exigir a lista
de todos dentro do escopo deste widget.

Passamos nosso `ListView.builder` como corpo do widget que estamos retornando para `build()`.
Isso renderizará a lista na tela para você começar!

<?code-excerpt "lib/main_todoscreen.dart (TodosScreen)"?>
```dart
class TodosScreen extends StatelessWidget {
  // Requiring the list of todos.
  const TodosScreen({super.key, required this.todos});

  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      //passing in the ListView.builder
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(todos[index].title));
        },
      ),
    );
  }
}
```

Com o estilo padrão do Flutter, você está pronto para começar sem se preocupar sobre
coisas que você gostaria de fazer mais tarde!

## 4. Criar uma tela de detalhe para exibir informações sobre um todo

Agora, crie a segunda tela. O título da tela contém o
título do todo, e o corpo da tela mostra a descrição.

Como a tela de detalhe é um `StatelessWidget` normal,
exija que o usuário insira um `Todo` na UI.
Então, construa a UI usando o todo fornecido.

<?code-excerpt "lib/main.dart (detail)"?>
```dart
class DetailScreen extends StatelessWidget {
  // In the constructor, require a Todo.
  const DetailScreen({super.key, required this.todo});

  // Declare a field that holds the Todo.
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(title: Text(todo.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(todo.description),
      ),
    );
  }
}
```

## 5. Navegar e passar dados para a tela de detalhe

Com um `DetailScreen` em vigor,
você está pronto para realizar a Navegação.
Neste exemplo, navegue para o `DetailScreen` quando um usuário
toca em um todo na lista. Passe o todo para o `DetailScreen`.

Para capturar o toque do usuário no `TodosScreen`, escreva um callback [`onTap()`][]
para o widget `ListTile`. Dentro do callback `onTap()`,
use o método [`Navigator.push()`][].

<?code-excerpt "lib/main.dart (builder)"?>
```dart
body: ListView.builder(
  itemCount: todos.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(todos[index].title),
      // When a user taps the ListTile, navigate to the DetailScreen.
      // Notice that you're not only creating a DetailScreen, you're
      // also passing the current todo through to it.
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
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
```dartpad title="Flutter passing data hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

class Todo {
  final String title;
  final String description;

  const Todo(this.title, this.description);
}

void main() {
  runApp(
    MaterialApp(
      title: 'Passing Data',
      home: TodosScreen(
        todos: List.generate(
          20,
          (i) => Todo(
            'Todo $i',
            'A description of what needs to be done for Todo $i',
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
      appBar: AppBar(title: const Text('Todos')),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todos[index].title),
            // When a user taps the ListTile, navigate to the DetailScreen.
            // Notice that you're not only creating a DetailScreen, you're
            // also passing the current todo through to it.
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
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
  // In the constructor, require a Todo.
  const DetailScreen({super.key, required this.todo});

  // Declare a field that holds the Todo.
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(title: Text(todo.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(todo.description),
      ),
    );
  }
}
```

## Alternativamente, passar os argumentos usando RouteSettings

Repita os dois primeiros passos.

### Criar uma tela de detalhe para extrair os argumentos

Em seguida, crie uma tela de detalhe que extrai e exibe o título e descrição do `Todo`. Para acessar o `Todo`, use o método [`ModalRoute.of()`][]. Este método retorna a rota atual com os argumentos.

<?code-excerpt "lib/main_routesettings.dart (DetailScreen)"?>
```dart
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todo = ModalRoute.of(context)!.settings.arguments as Todo;

    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(title: Text(todo.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(todo.description),
      ),
    );
  }
}
```

### Navegar e passar os argumentos para a tela de detalhe

Finalmente, navegue para o `DetailScreen` quando um usuário toca
em um widget `ListTile` usando `Navigator.push()`.
Passe os argumentos como parte do [`RouteSettings`][].
O `DetailScreen` extrai esses argumentos.

<?code-excerpt "lib/main_routesettings.dart (builder)" replace="/^body: //g;/^\),$/)/g"?>
```dart
ListView.builder(
  itemCount: todos.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(todos[index].title),
      // When a user taps the ListTile, navigate to the DetailScreen.
      // Notice that you're not only creating a DetailScreen, you're
      // also passing the current todo through to it.
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const DetailScreen(),
            // Pass the arguments as part of the RouteSettings. The
            // DetailScreen reads the arguments from these settings.
            settings: RouteSettings(arguments: todos[index]),
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
      title: 'Passing Data',
      home: TodosScreen(
        todos: List.generate(
          20,
          (i) => Todo(
            'Todo $i',
            'A description of what needs to be done for Todo $i',
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
      appBar: AppBar(title: const Text('Todos')),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todos[index].title),
            // When a user taps the ListTile, navigate to the DetailScreen.
            // Notice that you're not only creating a DetailScreen, you're
            // also passing the current todo through to it.
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const DetailScreen(),
                  // Pass the arguments as part of the RouteSettings. The
                  // DetailScreen reads the arguments from these settings.
                  settings: RouteSettings(arguments: todos[index]),
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

    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(title: Text(todo.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(todo.description),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/passing-data.webp" alt="Passing Data Demo" class="site-mobile-screenshot" />
</noscript>


[`ModalRoute.of()`]: {{site.api}}/flutter/widgets/ModalRoute/of.html
[`Navigator.push()`]: {{site.api}}/flutter/widgets/Navigator/push.html
[`onTap()`]: {{site.api}}/flutter/material/ListTile/onTap.html
[`RouteSettings`]: {{site.api}}/flutter/widgets/RouteSettings-class.html
[Use lists]: /cookbook/lists/basic-list
