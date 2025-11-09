---
ia-translate: true
title: Tocar, arrastar e inserir texto
description: Como testar widgets para interação do usuário.
---

<?code-excerpt path-base="cookbook/testing/widget/tap_drag/"?>

Muitos widgets não apenas exibem informações, mas também respondem
à interação do usuário. Isso inclui botões que podem ser tocados,
e [`TextField`][`TextField`] para inserir texto.

Para testar essas interações, você precisa de uma maneira de simulá-las
no ambiente de teste. Para este propósito, use a
biblioteca [`WidgetTester`][`WidgetTester`].

O `WidgetTester` fornece métodos para inserir texto,
tocar e arrastar.

* [`enterText()`][`enterText()`]
* [`tap()`][`tap()`]
* [`drag()`][`drag()`]

Em muitos casos, interações do usuário atualizam o estado do app. No ambiente de teste,
o Flutter não reconstrói automaticamente os widgets quando o estado
muda. Para garantir que a árvore de widgets seja reconstruída após simular uma interação
do usuário, chame os métodos [`pump()`][`pump()`] ou [`pumpAndSettle()`][`pumpAndSettle()`]
fornecidos pelo `WidgetTester`.
Esta receita usa os seguintes passos:

  1. Crie um widget para testar.
  2. Insira texto no campo de texto.
  3. Garanta que tocar em um botão adiciona o todo.
  4. Garanta que deslizar para dispensar remove o todo.

## 1. Crie um widget para testar

Para este exemplo,
crie um app básico de todos que testa três recursos:

  1. Inserir texto em um `TextField`.
  2. Tocar em um `FloatingActionButton` para adicionar o texto a uma lista de todos.
  3. Deslizar para dispensar para remover o item da lista.

Para manter o foco em testes,
esta receita não fornecerá um guia detalhado sobre como construir o app de todos.
Para aprender mais sobre como este app é construído,
consulte as receitas relevantes:

* [Criar e estilizar um campo de texto][Create and style a text field]
* [Lidar com toques][Handle taps]
* [Criar uma lista básica][Create a basic list]
* [Implementar deslizar para dispensar][Implement swipe to dismiss]

<?code-excerpt "test/main_test.dart (TodoList)"?>
```dart
class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  static const _appTitle = 'Todo List';
  final todos = <String>[];
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appTitle,
      home: Scaffold(
        appBar: AppBar(title: const Text(_appTitle)),
        body: Column(
          children: [
            TextField(controller: controller),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];

                  return Dismissible(
                    key: Key('$todo$index'),
                    onDismissed: (direction) => todos.removeAt(index),
                    background: Container(color: Colors.red),
                    child: ListTile(title: Text(todo)),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              todos.add(controller.text);
              controller.clear();
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
```

## 2. Insira texto no campo de texto

Agora que você tem um app de todos, comece escrevendo o teste.
Comece inserindo texto no `TextField`.

Realize esta tarefa:

  1. Construindo o widget no ambiente de teste.
  2. Usando o método [`enterText()`][`enterText()`]
     do `WidgetTester`.

<?code-excerpt "test/main_steps.dart (TestWidgetStep2)"?>
```dart
testWidgets('Add and remove a todo', (tester) async {
  // Build the widget
  await tester.pumpWidget(const TodoList());

  // Enter 'hi' into the TextField.
  await tester.enterText(find.byType(TextField), 'hi');
});
```

:::note
Esta receita se baseia em receitas anteriores de testes de widget.
Para aprender os conceitos principais de testes de widget,
consulte as seguintes receitas:

* [Introdução a testes de widget][Introduction to widget testing]
* [Encontrando widgets em um teste de widget][Finding widgets in a widget test]
:::

## 3. Garanta que tocar em um botão adiciona o todo

Após inserir texto no `TextField`, garanta que tocar
no `FloatingActionButton` adiciona o item à lista.

Isso envolve três passos:

 1. Toque no botão adicionar usando o método [`tap()`][`tap()`].
 2. Reconstrua o widget após o estado ter mudado usando o
    método [`pump()`][`pump()`].
 3. Garanta que o item da lista aparece na tela.

<?code-excerpt "test/main_steps.dart (TestWidgetStep3)"?>
```dart
testWidgets('Add and remove a todo', (tester) async {
  // Enter text code...

  // Tap the add button.
  await tester.tap(find.byType(FloatingActionButton));

  // Rebuild the widget after the state has changed.
  await tester.pump();

  // Expect to find the item on screen.
  expect(find.text('hi'), findsOneWidget);
});
```

## 4. Garanta que deslizar para dispensar remove o todo

Finalmente, garanta que executar uma ação de deslizar para dispensar no item
todo o remove da lista. Isso envolve três passos:

  1. Use o método [`drag()`][`drag()`]
     para executar uma ação de deslizar para dispensar.
  2. Use o método [`pumpAndSettle()`][`pumpAndSettle()`]
     para reconstruir continuamente a árvore de widgets até que a animação
     de dispensar seja concluída.
  3. Garanta que o item não aparece mais na tela.

<?code-excerpt "test/main_steps.dart (TestWidgetStep4)"?>
```dart
testWidgets('Add and remove a todo', (tester) async {
  // Enter text and add the item...

  // Swipe the item to dismiss it.
  await tester.drag(find.byType(Dismissible), const Offset(500, 0));

  // Build the widget until the dismiss animation ends.
  await tester.pumpAndSettle();

  // Ensure that the item is no longer on screen.
  expect(find.text('hi'), findsNothing);
});
```

## Exemplo completo

<?code-excerpt "test/main_test.dart"?>
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Add and remove a todo', (tester) async {
    // Build the widget.
    await tester.pumpWidget(const TodoList());

    // Enter 'hi' into the TextField.
    await tester.enterText(find.byType(TextField), 'hi');

    // Tap the add button.
    await tester.tap(find.byType(FloatingActionButton));

    // Rebuild the widget with the new item.
    await tester.pump();

    // Expect to find the item on screen.
    expect(find.text('hi'), findsOneWidget);

    // Swipe the item to dismiss it.
    await tester.drag(find.byType(Dismissible), const Offset(500, 0));

    // Build the widget until the dismiss animation ends.
    await tester.pumpAndSettle();

    // Ensure that the item is no longer on screen.
    expect(find.text('hi'), findsNothing);
  });
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  static const _appTitle = 'Todo List';
  final todos = <String>[];
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appTitle,
      home: Scaffold(
        appBar: AppBar(title: const Text(_appTitle)),
        body: Column(
          children: [
            TextField(controller: controller),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];

                  return Dismissible(
                    key: Key('$todo$index'),
                    onDismissed: (direction) => todos.removeAt(index),
                    background: Container(color: Colors.red),
                    child: ListTile(title: Text(todo)),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              todos.add(controller.text);
              controller.clear();
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
```

[Create a basic list]: /cookbook/lists/basic-list
[Create and style a text field]: /cookbook/forms/text-input
[`drag()`]: {{site.api}}/flutter/flutter_test/WidgetController/drag.html
[`enterText()`]: {{site.api}}/flutter/flutter_test/WidgetTester/enterText.html
[Finding widgets in a widget test]: /cookbook/testing/widget/finders
[Handle taps]: /cookbook/gestures/handling-taps
[Implement swipe to dismiss]: /cookbook/gestures/dismissible
[Introduction to widget testing]: /cookbook/testing/widget/introduction
[`pump()`]: {{site.api}}/flutter/flutter_test/WidgetTester/pump.html
[`pumpAndSettle()`]: {{site.api}}/flutter/flutter_test/WidgetTester/pumpAndSettle.html
[`tap()`]: {{site.api}}/flutter/flutter_test/WidgetController/tap.html
[`TextField`]: {{site.api}}/flutter/material/TextField-class.html
[`WidgetTester`]: {{site.api}}/flutter/flutter_test/WidgetTester-class.html
