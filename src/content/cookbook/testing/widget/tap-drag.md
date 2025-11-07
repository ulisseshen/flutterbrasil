---
title: Tocar, arrastar e inserir texto
description: Como testar widgets para interação do usuário.
ia-translate: true
---

<?code-excerpt path-base="cookbook/testing/widget/tap_drag/"?>

{% assign api = site.api | append: '/flutter' -%}

Muitos widgets não apenas exibem informações, mas também respondem
à interação do usuário. Isso inclui botões que podem ser tocados,
e [`TextField`][] para inserir texto.

Para testar essas interações, você precisa de uma maneira de simulá-las
no ambiente de teste. Para este propósito, use a
biblioteca [`WidgetTester`][].

O `WidgetTester` fornece métodos para inserir texto,
tocar e arrastar.

* [`enterText()`][]
* [`tap()`][]
* [`drag()`][]

Em muitos casos, interações do usuário atualizam o estado do aplicativo. No ambiente
de teste, o Flutter não reconstrói widgets automaticamente quando o estado
muda. Para garantir que a árvore de widgets seja reconstruída após simular uma
interação do usuário, chame os métodos [`pump()`][] ou [`pumpAndSettle()`][]
fornecidos pelo `WidgetTester`.
Esta receita usa as seguintes etapas:

  1. Criar um widget para testar.
  2. Inserir texto no campo de texto.
  3. Garantir que tocar em um botão adiciona o todo.
  4. Garantir que deslizar para descartar remove o todo.

## 1. Criar um widget para testar

Para este exemplo,
crie um aplicativo básico de todo que testa três recursos:

  1. Inserir texto em um `TextField`.
  2. Tocar em um `FloatingActionButton` para adicionar o texto a uma lista de todos.
  3. Deslizar para descartar para remover o item da lista.

Para manter o foco em testes,
esta receita não fornecerá um guia detalhado sobre como construir o aplicativo de todo.
Para aprender mais sobre como este aplicativo é construído,
consulte as receitas relevantes:

* [Create and style a text field][]
* [Handle taps][]
* [Create a basic list][]
* [Implement swipe to dismiss][]

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
        appBar: AppBar(
          title: const Text(_appTitle),
        ),
        body: Column(
          children: [
            TextField(
              controller: controller,
            ),
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

## 2. Inserir texto no campo de texto

Agora que você tem um aplicativo de todo, comece escrevendo o teste.
Comece inserindo texto no `TextField`.

Realize esta tarefa:

  1. Construindo o widget no ambiente de teste.
  2. Usando o método [`enterText()`][]
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

* [Introduction to widget testing][]
* [Finding widgets in a widget test][]
:::

## 3. Garantir que tocar em um botão adiciona o todo

Após inserir texto no `TextField`, garanta que tocar
no `FloatingActionButton` adiciona o item à lista.

Isso envolve três etapas:

 1. Tocar no botão adicionar usando o método [`tap()`][].
 2. Reconstruir o widget após o estado ter mudado usando o
    método [`pump()`][].
 3. Garantir que o item da lista apareça na tela.

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

## 4. Garantir que deslizar para descartar remove o todo

Finalmente, garanta que realizar uma ação de deslizar para descartar no item todo
o remove da lista. Isso envolve três etapas:

  1. Usar o método [`drag()`][]
     para realizar uma ação de deslizar para descartar.
  2. Usar o método [`pumpAndSettle()`][]
     para reconstruir continuamente a árvore de widgets até que a animação
     de descarte esteja completa.
  3. Garantir que o item não apareça mais na tela.

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
        appBar: AppBar(
          title: const Text(_appTitle),
        ),
        body: Column(
          children: [
            TextField(
              controller: controller,
            ),
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
[`drag()`]: {{api}}/flutter_test/WidgetController/drag.html
[`enterText()`]: {{api}}/flutter_test/WidgetTester/enterText.html
[Finding widgets in a widget test]: /cookbook/testing/widget/finders
[Handle taps]: /cookbook/gestures/handling-taps
[Implement swipe to dismiss]: /cookbook/gestures/dismissible
[Introduction to widget testing]: /cookbook/testing/widget/introduction
[`pump()`]: {{api}}/flutter_test/WidgetTester/pump.html
[`pumpAndSettle()`]: {{api}}/flutter_test/WidgetTester/pumpAndSettle.html
[`tap()`]: {{api}}/flutter_test/WidgetController/tap.html
[`TextField`]: {{api}}/material/TextField-class.html
[`WidgetTester`]: {{api}}/flutter_test/WidgetTester-class.html
