---
ia-translate: true
title: Retornar dados de uma tela
description: Como retornar dados de uma nova tela.
---

<?code-excerpt path-base="cookbook/navigation/returning_data/"?>

Em alguns casos, você pode querer retornar dados de uma nova tela.
Por exemplo, digamos que você abra uma nova tela que apresenta duas opções para um usuário.
Quando o usuário toca em uma opção, você quer informar a primeira tela
da seleção do usuário para que ela possa agir sobre essa informação.

Você pode fazer isso com o método [`Navigator.pop()`][]
usando os seguintes passos:

  1. Definir a tela home
  2. Adicionar um botão que abre a tela de seleção
  3. Mostrar a tela de seleção com dois botões
  4. Quando um botão é tocado, fechar a tela de seleção
  5. Mostrar um snackbar na tela home com a seleção

## 1. Definir a tela home

A tela home exibe um botão. Quando tocado,
ele abre a tela de seleção.

<?code-excerpt "lib/main_step2.dart (HomeScreen)"?>
```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Returning Data Demo')),
      // Create the SelectionButton widget in the next step.
      body: const Center(child: SelectionButton()),
    );
  }
}
```

## 2. Adicionar um botão que abre a tela de seleção

Agora, crie o SelectionButton, que faz o seguinte:

  * Abre a SelectionScreen quando é tocado.
  * Aguarda a SelectionScreen retornar um resultado.

<?code-excerpt "lib/main_step2.dart (SelectionButton)"?>
```dart
class SelectionButton extends StatefulWidget {
  const SelectionButton({super.key});

  @override
  State<SelectionButton> createState() => _SelectionButtonState();
}

class _SelectionButtonState extends State<SelectionButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _navigateAndDisplaySelection(context);
      },
      child: const Text('Pick an option, any option!'),
    );
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute<String>(builder: (context) => const SelectionScreen()),
    );
  }
}
```

## 3. Mostrar a tela de seleção com dois botões

Agora, construa uma tela de seleção que contém dois botões.
Quando um usuário toca em um botão,
o app fecha a tela de seleção e informa à tela home
qual botão foi tocado.

Este passo define a UI.
O próximo passo adiciona código para retornar dados.

<?code-excerpt "lib/main_step2.dart (SelectionScreen)"?>
```dart
class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick an option')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  // Pop here with "Yep"...
                },
                child: const Text('Yep!'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  // Pop here with "Nope"...
                },
                child: const Text('Nope.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 4. Quando um botão é tocado, fechar a tela de seleção

Agora, atualize o callback `onPressed()` para ambos os botões.
Para retornar dados para a primeira tela,
use o método [`Navigator.pop()`][],
que aceita um segundo argumento opcional chamado `result`.
Qualquer resultado é retornado para o `Future` no SelectionButton.

### Botão Yep

<?code-excerpt "lib/main.dart (Yep)" replace="/^child: //g;/^\),$/)/g"?>
```dart
ElevatedButton(
  onPressed: () {
    // Close the screen and return "Yep!" as the result.
    Navigator.pop(context, 'Yep!');
  },
  child: const Text('Yep!'),
)
```

### Botão Nope

<?code-excerpt "lib/main.dart (Nope)" replace="/^child: //g;/^\),$/)/g"?>
```dart
ElevatedButton(
  onPressed: () {
    // Close the screen and return "Nope." as the result.
    Navigator.pop(context, 'Nope.');
  },
  child: const Text('Nope.'),
)
```

## 5. Mostrar um snackbar na tela home com a seleção

Agora que você está abrindo uma tela de seleção e aguardando o resultado,
você vai querer fazer algo com a informação que é retornada.

Neste caso, mostre um snackbar exibindo o resultado usando o
método `_navigateAndDisplaySelection()` em `SelectionButton`:

<?code-excerpt "lib/main.dart (navigateAndDisplay)"?>
```dart
// A method that launches the SelectionScreen and awaits the result from
// Navigator.pop.
Future<void> _navigateAndDisplaySelection(BuildContext context) async {
  // Navigator.push returns a Future that completes after calling
  // Navigator.pop on the Selection Screen.
  final result = await Navigator.push(
    context,
    MaterialPageRoute<String>(builder: (context) => const SelectionScreen()),
  );

  // When a BuildContext is used from a StatefulWidget, the mounted property
  // must be checked after an asynchronous gap.
  if (!context.mounted) return;

  // After the Selection Screen returns a result, hide any previous snackbars
  // and show the new result.
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$result')));
}
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter Return from Data hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(title: 'Returning Data', home: HomeScreen()));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Returning Data Demo')),
      body: const Center(child: SelectionButton()),
    );
  }
}

class SelectionButton extends StatefulWidget {
  const SelectionButton({super.key});

  @override
  State<SelectionButton> createState() => _SelectionButtonState();
}

class _SelectionButtonState extends State<SelectionButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _navigateAndDisplaySelection(context);
      },
      child: const Text('Pick an option, any option!'),
    );
  }

  // A method that launches the SelectionScreen and awaits the result from
  // Navigator.pop.
  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute<String>(builder: (context) => const SelectionScreen()),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!context.mounted) return;

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$result')));
  }

}

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick an option')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  // Close the screen and return "Yep!" as the result.
                  Navigator.pop(context, 'Yep!');
                },
                child: const Text('Yep!'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  // Close the screen and return "Nope." as the result.
                  Navigator.pop(context, 'Nope.');
                },
                child: const Text('Nope.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/returning-data.webp" alt="Returning data demo" class="site-mobile-screenshot" />
</noscript>


[`Navigator.pop()`]: {{site.api}}/flutter/widgets/Navigator/pop.html
