---
ia-translate: true
title: Exibir uma snackbar
description: Como implementar uma snackbar para exibir mensagens.
---

<?code-excerpt path-base="cookbook/design/snackbars/"?>

Pode ser útil informar brevemente seus usuários quando certas ações
ocorrem. Por exemplo, quando um usuário desliza uma mensagem em uma lista,
você pode querer informá-lo que a mensagem foi deletada.
Você pode até querer dar a eles uma opção de desfazer a ação.

No Material Design, este é o trabalho de uma [`SnackBar`][].
Esta receita implementa uma snackbar usando os seguintes passos:

  1. Criar um `Scaffold`.
  2. Exibir uma `SnackBar`.
  3. Fornecer uma ação opcional.

## 1. Criar um `Scaffold`

Ao criar apps que seguem as diretrizes do Material Design,
dê aos seus apps uma estrutura visual consistente.
Neste exemplo, exiba a `SnackBar` na parte inferior da tela,
sem sobrepor outros widgets importantes,
como o `FloatingActionButton`.

O widget [`Scaffold`][], da [biblioteca material][material library],
cria esta estrutura visual e garante que widgets importantes
não se sobreponham.

<?code-excerpt "lib/partial.dart (Scaffold)"?>
```dart
return MaterialApp(
  title: 'SnackBar Demo',
  home: Scaffold(
    appBar: AppBar(title: const Text('SnackBar Demo')),
    body: const SnackBarPage(),
  ),
);
```

## 2. Exibir uma `SnackBar`

Com o `Scaffold` no lugar, exiba uma `SnackBar`.
Primeiro, crie uma `SnackBar`, depois a exiba usando `ScaffoldMessenger`.

<?code-excerpt "lib/partial.dart (DisplaySnackBar)"?>
```dart
const snackBar = SnackBar(content: Text('Yay! A SnackBar!'));

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
ScaffoldMessenger.of(context).showSnackBar(snackBar);
```

:::note
Para saber mais, assista este pequeno vídeo Widget of the Week sobre
o widget `ScaffoldMessenger`:

<YouTubeEmbed id="lytQi-slT5Y" title="ScaffoldMessenger | Flutter widget of the week"></YouTubeEmbed>
:::

## 3. Fornecer uma ação opcional

Você pode querer fornecer uma ação ao usuário quando
a SnackBar é exibida.
Por exemplo, se o usuário acidentalmente deletar uma mensagem,
ele pode usar uma ação opcional na SnackBar para recuperar
a mensagem.

Aqui está um exemplo de fornecer
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
Neste exemplo, a SnackBar é exibida quando um usuário toca em um botão.
Para mais informações sobre trabalhar com entrada do usuário,
veja a seção [Gestures][] do cookbook.
:::

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de snackbar Flutter no DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const SnackBarDemo());

class SnackBarDemo extends StatelessWidget {
  const SnackBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnackBar Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('SnackBar Demo')),
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
  <img src="/assets/images/docs/cookbook/snackbar.webp" alt="SnackBar Demo" class="site-mobile-screenshot" />
</noscript>

[Gestures]: /cookbook/gestures
[`Scaffold`]: {{site.api}}/flutter/material/Scaffold-class.html
[`SnackBar`]: {{site.api}}/flutter/material/SnackBar-class.html
[material library]: {{site.api}}/flutter/material/material-library.html
