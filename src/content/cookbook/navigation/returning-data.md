---
ia-translate: true
title: Retornar dados de uma tela
description: Como retornar dados de uma nova tela.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/navigation/returning_data/"?>

Em alguns casos, você pode querer retornar dados de uma nova tela.
Por exemplo, digamos que você empurre uma nova tela que apresenta duas opções para um usuário.
Quando o usuário toca em uma opção, você quer informar a primeira tela
da seleção do usuário para que ela possa agir sobre essa informação.

Você pode fazer isso com o método [`Navigator.pop()`][]
seguindo os seguintes passos:

  1. Defina a tela inicial
  2. Adicione um botão que inicia a tela de seleção
  3. Mostre a tela de seleção com dois botões
  4. Quando um botão é tocado, feche a tela de seleção
  5. Mostre uma snackbar na tela inicial com a seleção

## 1. Defina a tela inicial

A tela inicial exibe um botão. Quando tocado,
ele inicia a tela de seleção.

<?code-excerpt "lib/main_step2.dart (HomeScreen)"?>
```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demonstração de Retorno de Dados'),
      ),
      // Crie o widget SelectionButton no próximo passo.
      body: const Center(
        child: SelectionButton(),
      ),
    );
  }
}
```

## 2. Adicione um botão que inicia a tela de seleção

Agora, crie o SelectionButton, que faz o seguinte:

  * Inicia a SelectionScreen quando é tocado.
  * Espera que a SelectionScreen retorne um resultado.

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
      child: const Text('Escolha uma opção, qualquer opção!'),
    );
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push retorna um Future que é completado após chamar
    // Navigator.pop na Selection Screen.
    final result = await Navigator.push(
      context,
      // Crie a SelectionScreen no próximo passo.
      MaterialPageRoute(builder: (context) => const SelectionScreen()),
    );
  }
}
```

## 3. Mostre a tela de seleção com dois botões

Agora, construa uma tela de seleção que contenha dois botões.
Quando um usuário toca em um botão,
o aplicativo fecha a tela de seleção e informa à tela inicial
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
      appBar: AppBar(
        title: const Text('Escolha uma opção'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  // Pop aqui com "Sim"...
                },
                child: const Text('Sim!'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  // Pop aqui com "Não"...
                },
                child: const Text('Não.'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
```

## 4. Quando um botão é tocado, feche a tela de seleção

Agora, atualize o callback `onPressed()` para ambos os botões.
Para retornar dados para a primeira tela,
use o método [`Navigator.pop()`][],
que aceita um segundo argumento opcional chamado `result`.
Qualquer resultado é retornado para o `Future` no SelectionButton.

### Botão Sim

<?code-excerpt "lib/main.dart (Yep)" replace="/^child: //g;/^\),$/)/g"?>
```dart
ElevatedButton(
  onPressed: () {
    // Fecha a tela e retorna "Sim!" como resultado.
    Navigator.pop(context, 'Sim!');
  },
  child: const Text('Sim!'),
)
```

### Botão Não

<?code-excerpt "lib/main.dart (Nope)" replace="/^child: //g;/^\),$/)/g"?>
```dart
ElevatedButton(
  onPressed: () {
    // Fecha a tela e retorna "Não." como resultado.
    Navigator.pop(context, 'Não.');
  },
  child: const Text('Não.'),
)
```

## 5. Mostre uma snackbar na tela inicial com a seleção

Agora que você está iniciando uma tela de seleção e aguardando o resultado,
você vai querer fazer algo com a informação que foi retornada.

Neste caso, mostre uma snackbar exibindo o resultado usando o
método `_navigateAndDisplaySelection()` em `SelectionButton`:

<?code-excerpt "lib/main.dart (navigateAndDisplay)"?>
```dart
// Um método que inicia a SelectionScreen e aguarda o resultado de
// Navigator.pop.
Future<void> _navigateAndDisplaySelection(BuildContext context) async {
  // Navigator.push retorna um Future que é completado após chamar
  // Navigator.pop na Selection Screen.
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SelectionScreen()),
  );

  // Quando um BuildContext é usado de um StatefulWidget, a propriedade mounted
  // deve ser verificada após um intervalo assíncrono.
  if (!context.mounted) return;

  // Após a Selection Screen retornar um resultado, oculte qualquer snackbar
  // anterior e mostre o novo resultado.
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$result')));
}
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de retorno de dados do Flutter no DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      title: 'Retornando Dados',
      home: HomeScreen(),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demonstração de Retorno de Dados'),
      ),
      body: const Center(
        child: SelectionButton(),
      ),
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
      child: const Text('Escolha uma opção, qualquer opção!'),
    );
  }

  // Um método que inicia a SelectionScreen e aguarda o resultado de
  // Navigator.pop.
  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push retorna um Future que é completado após chamar
    // Navigator.pop na Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectionScreen()),
    );

    // Quando um BuildContext é usado de um StatefulWidget, a propriedade mounted
    // deve ser verificada após um intervalo assíncrono.
    if (!context.mounted) return;

    // Após a Selection Screen retornar um resultado, oculte qualquer snackbar
    // anterior e mostre o novo resultado.
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
      appBar: AppBar(
        title: const Text('Escolha uma opção'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  // Fecha a tela e retorna "Sim!" como resultado.
                  Navigator.pop(context, 'Sim!');
                },
                child: const Text('Sim!'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  // Fecha a tela e retorna "Não." como resultado.
                  Navigator.pop(context, 'Não.');
                },
                child: const Text('Não.'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/returning-data.gif" alt="Demonstração de retorno de dados" class="site-mobile-screenshot" />
</noscript>


[`Navigator.pop()`]: {{site.api}}/flutter/widgets/Navigator/pop.html
