---
title: Exiba um snackbar
description: Como implementar um snackbar para exibir mensagens.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
ia-translate: true
---

<?code-excerpt path-base="cookbook/design/snackbars/"?>

Pode ser útil informar brevemente seus usuários quando certas ações
ocorrem. Por exemplo, quando um usuário desliza uma mensagem para fora de uma lista,
você pode querer informá-lo que a mensagem foi excluída.
Você pode até querer dar a eles uma opção de desfazer a ação.

No Material Design, este é o trabalho de um [`SnackBar`][].
Esta receita implementa um snackbar usando os seguintes passos:

  1. Criar um `Scaffold`.
  2. Exibir um `SnackBar`.
  3. Fornecer uma ação opcional.

## 1. Criar um `Scaffold`

Ao criar aplicativos que seguem as diretrizes do Material Design,
dê aos seus aplicativos uma estrutura visual consistente.
Neste exemplo, exiba o `SnackBar` na parte inferior da tela,
sem sobrepor outros widgets importantes,
como o `FloatingActionButton`.

O widget [`Scaffold`][], da [biblioteca material][material library],
cria essa estrutura visual e garante que widgets importantes
não se sobreponham.

<?code-excerpt "lib/partial.dart (Scaffold)"?>
```dart
return MaterialApp(
  title: 'SnackBar Demo',
  home: Scaffold(
    appBar: AppBar(
      title: const Text('SnackBar Demo'),
    ),
    body: const SnackBarPage(),
  ),
);
```

## 2. Exibir um `SnackBar`

Com o `Scaffold` no lugar, exiba um `SnackBar`.
Primeiro, crie um `SnackBar`, depois exiba-o usando `ScaffoldMessenger`.

<?code-excerpt "lib/partial.dart (DisplaySnackBar)"?>
```dart
const snackBar = SnackBar(
  content: Text('Yay! A SnackBar!'),
);

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
ScaffoldMessenger.of(context).showSnackBar(snackBar);
```

:::note
Para saber mais, assista a este breve vídeo Widget of the Week sobre
o widget `ScaffoldMessenger`:

{% ytEmbed 'lytQi-slT5Y', 'ScaffoldMessenger | Flutter widget of the week' %}
:::

## 3. Fornecer uma ação opcional

Você pode querer fornecer uma ação ao usuário quando
o SnackBar é exibido.
Por exemplo, se o usuário exclui acidentalmente uma mensagem,
ele pode usar uma ação opcional no SnackBar para recuperar
a mensagem.

Aqui está um exemplo de como fornecer
uma `action` adicional ao widget `SnackBar`:

<?code-excerpt "lib/main.dart (SnackBarAction)"?>
```dart
final snackBar = SnackBar(
  content: const Text('Yay! A SnackBar!'),
  action: SnackBarAction(
    label: 'Undo',
    onPressed: () {
      // Some code to undo the change.
    },
  ),
);
```

## Exemplo interativo

:::note
Neste exemplo, o SnackBar é exibido quando um usuário toca em um botão.
Para mais informações sobre trabalhar com entrada do usuário,
consulte a seção [Gestos][Gestures] do cookbook.
:::

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter snackbar hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const SnackBarDemo());

class SnackBarDemo extends StatelessWidget {
  const SnackBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnackBar Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SnackBar Demo'),
        ),
        body: const SnackBarPage(),
      ),
    );
  }
}

class SnackBarPage extends StatelessWidget {
  const SnackBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          final snackBar = SnackBar(
            content: const Text('Yay! A SnackBar!'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: const Text('Show SnackBar'),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/snackbar.gif" alt="SnackBar Demo" class="site-mobile-screenshot" />
</noscript>

[Gestures]: /cookbook#gestures
[`Scaffold`]: {{site.api}}/flutter/material/Scaffold-class.html
[`SnackBar`]: {{site.api}}/flutter/material/SnackBar-class.html
[material library]: {{site.api}}/flutter/material/material-library.html
