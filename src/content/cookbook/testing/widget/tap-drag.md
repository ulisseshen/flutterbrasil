---
ia-translate: true
title: Tocar, arrastar e inserir texto
description: Como testar widgets para interação do usuário.
---

<?code-excerpt path-base="cookbook/testing/widget/tap_drag/"?>

{% assign api = site.api | append: '/flutter' -%}

Muitos widgets não apenas exibem informações, mas também respondem
à interação do usuário. Isso inclui botões que podem ser tocados,
e [`TextField`][] para inserir texto.

Para testar essas interações, você precisa de uma maneira de simulá-las
no ambiente de teste. Para esse propósito, use a
biblioteca [`WidgetTester`][].

O `WidgetTester` fornece métodos para inserir texto,
tocar e arrastar.

* [`enterText()`][]
* [`tap()`][]
* [`drag()`][]

Em muitos casos, as interações do usuário atualizam o estado do aplicativo. No ambiente de teste, o Flutter não reconstrói automaticamente os widgets quando o estado muda. Para garantir que a árvore de widgets seja reconstruída após simular uma interação do usuário, chame os métodos [`pump()`][] ou [`pumpAndSettle()`][] fornecidos pelo `WidgetTester`.
Esta receita usa as seguintes etapas:

  1. Crie um widget para testar.
  2. Insira texto no campo de texto.
  3. Garanta que tocar em um botão adicione o todo.
  4. Garanta que o swipe para dispensar remova o todo.

## 1. Crie um widget para testar

Para este exemplo,
crie um aplicativo de todo básico que testa três recursos:

  1. Inserir texto em um `TextField`.
  2. Tocar em um `FloatingActionButton` para adicionar o texto a uma lista de todos.
  3. Arrastar para dispensar para remover o item da lista.

Para manter o foco nos testes,
esta receita não fornecerá um guia detalhado sobre como construir o aplicativo de todo.
Para saber mais sobre como este aplicativo é construído,
veja as receitas relevantes:

* [Criar e estilizar um campo de texto][]
* [Lidar com toques][]
* [Criar uma lista básica][]
* [Implementar o swipe para dispensar][]

<?code-excerpt "test/main_test.dart (TodoList)"?>
```dart
class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  static const _appTitle = 'Lista de Tarefas';
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

## 2. Insira texto no campo de texto

Agora que você tem um aplicativo de todo, comece a escrever o teste.
Comece inserindo texto no `TextField`.

Realize esta tarefa:

  1. Construindo o widget no ambiente de teste.
  2. Usando o método [`enterText()`][]
     do `WidgetTester`.

<?code-excerpt "test/main_steps.dart (TestWidgetStep2)"?>
```dart
testWidgets('Adicionar e remover um todo', (tester) async {
  // Construa o widget
  await tester.pumpWidget(const TodoList());

  // Insira 'oi' no TextField.
  await tester.enterText(find.byType(TextField), 'oi');
});
```

:::note
Esta receita se baseia em receitas de testes de widget anteriores.
Para aprender os conceitos básicos de testes de widget,
veja as seguintes receitas:

* [Introdução ao teste de widget][]
* [Encontrando widgets em um teste de widget][]
:::

## 3. Garanta que tocar em um botão adicione o todo

Depois de inserir texto no `TextField`, certifique-se de que tocar
no `FloatingActionButton` adicione o item à lista.

Isso envolve três etapas:

 1. Toque no botão adicionar usando o método [`tap()`][].
 2. Reconstrua o widget após a mudança de estado usando o
    método [`pump()`][].
 3. Garanta que o item da lista apareça na tela.

<?code-excerpt "test/main_steps.dart (TestWidgetStep3)"?>
```dart
testWidgets('Adicionar e remover um todo', (tester) async {
  // Código para inserir texto...

  // Toque no botão adicionar.
  await tester.tap(find.byType(FloatingActionButton));

  // Reconstrua o widget após a mudança de estado.
  await tester.pump();

  // Espere encontrar o item na tela.
  expect(find.text('oi'), findsOneWidget);
});
```

## 4. Garanta que o swipe para dispensar remova o todo

Finalmente, certifique-se de que realizar uma ação de swipe para dispensar no todo
item remove-o da lista. Isso envolve três etapas:

  1. Use o método [`drag()`][]
     para realizar uma ação de swipe para dispensar.
  2. Use o método [`pumpAndSettle()`][]
     para reconstruir continuamente a árvore de widgets até que a animação de dispensa
     seja concluída.
  3. Garanta que o item não apareça mais na tela.

<?code-excerpt "test/main_steps.dart (TestWidgetStep4)"?>
```dart
testWidgets('Adicionar e remover um todo', (tester) async {
  // Insira o texto e adicione o item...

  // Arraste o item para dispensá-lo.
  await tester.drag(find.byType(Dismissible), const Offset(500, 0));

  // Construa o widget até que a animação de dispensa termine.
  await tester.pumpAndSettle();

  // Garanta que o item não esteja mais na tela.
  expect(find.text('oi'), findsNothing);
});
```

## Exemplo completo

<?code-excerpt "test/main_test.dart"?>
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Adicionar e remover um todo', (tester) async {
    // Construa o widget.
    await tester.pumpWidget(const TodoList());

    // Insira 'oi' no TextField.
    await tester.enterText(find.byType(TextField), 'oi');

    // Toque no botão adicionar.
    await tester.tap(find.byType(FloatingActionButton));

    // Reconstrua o widget com o novo item.
    await tester.pump();

    // Espere encontrar o item na tela.
    expect(find.text('oi'), findsOneWidget);

    // Arraste o item para dispensá-lo.
    await tester.drag(find.byType(Dismissible), const Offset(500, 0));

    // Construa o widget até que a animação de dispensa termine.
    await tester.pumpAndSettle();

    // Garanta que o item não esteja mais na tela.
    expect(find.text('oi'), findsNothing);
  });
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  static const _appTitle = 'Lista de Tarefas';
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

[Criar uma lista básica]: /cookbook/lists/basic-list
[Criar e estilizar um campo de texto]: /cookbook/forms/text-input
[`drag()`]: {{api}}/flutter_test/WidgetController/drag.html
[`enterText()`]: {{api}}/flutter_test/WidgetTester/enterText.html
[Encontrando widgets em um teste de widget]: /cookbook/testing/widget/finders
[Lidar com toques]: /cookbook/gestures/handling-taps
[Implementar o swipe para dispensar]: /cookbook/gestures/dismissible
[Introdução ao teste de widget]: /cookbook/testing/widget/introduction
[`pump()`]: {{api}}/flutter_test/WidgetTester/pump.html
[`pumpAndSettle()`]: {{api}}/flutter_test/WidgetTester/pumpAndSettle.html
[`tap()`]: {{api}}/flutter_test/WidgetController/tap.html
[`TextField`]: {{api}}/material/TextField-class.html
[`WidgetTester`]: {{api}}/flutter_test/WidgetTester-class.html
