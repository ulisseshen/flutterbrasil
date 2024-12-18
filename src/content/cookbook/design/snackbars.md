---
ia-translate: true
title: Exibir uma snackbar
description: Como implementar uma snackbar para exibir mensagens.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/design/snackbars/"?>

Pode ser útil informar brevemente seus usuários quando certas ações
ocorrem. Por exemplo, quando um usuário desliza uma mensagem em uma lista,
você pode querer informá-lo de que a mensagem foi excluída.
Você pode até querer dar a ele a opção de desfazer a ação.

Em Material Design, este é o trabalho de uma [`SnackBar`][].
Esta receita implementa uma snackbar usando os seguintes passos:

  1. Crie um `Scaffold`.
  2. Exiba uma `SnackBar`.
  3. Forneça uma ação opcional.

## 1. Crie um `Scaffold`

Ao criar aplicativos que seguem as diretrizes do Material Design,
dê aos seus aplicativos uma estrutura visual consistente.
Neste exemplo, exiba a `SnackBar` na parte inferior da tela,
sem sobrepor outros widgets importantes,
como o `FloatingActionButton`.

O widget [`Scaffold`][], da [biblioteca material][],
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

## 2. Exiba uma `SnackBar`

Com o `Scaffold` no lugar, exiba uma `SnackBar`.
Primeiro, crie uma `SnackBar`, depois exiba-a usando `ScaffoldMessenger`.

<?code-excerpt "lib/partial.dart (DisplaySnackBar)"?>
```dart
const snackBar = SnackBar(
  content: Text('Yay! A SnackBar!'),
);

// Encontre o ScaffoldMessenger na árvore de widgets
// e use-o para mostrar uma SnackBar.
ScaffoldMessenger.of(context).showSnackBar(snackBar);
```

:::note
Para saber mais, assista a este breve vídeo Widget of the Week sobre
o widget `ScaffoldMessenger`:

{% ytEmbed 'lytQi-slT5Y', 'ScaffoldMessenger | Widget da semana do Flutter' %}
:::

## 3. Forneça uma ação opcional

Você pode querer fornecer uma ação para o usuário quando
a SnackBar é exibida.
Por exemplo, se o usuário excluir acidentalmente uma mensagem,
ele pode usar uma ação opcional na SnackBar para recuperar
a mensagem.

Aqui está um exemplo de como fornecer
uma `action` adicional ao widget `SnackBar`:

<?code-excerpt "lib/main.dart (SnackBarAction)"?>
```dart
final snackBar = SnackBar(
  content: const Text('Yay! A SnackBar!'),
  action: SnackBarAction(
    label: 'Desfazer',
    onPressed: () {
      // Algum código para desfazer a mudança.
    },
  ),
);
```

## Exemplo interativo

:::note
Neste exemplo, a SnackBar é exibida quando um usuário toca em um botão.
Para obter mais informações sobre como trabalhar com a entrada do usuário,
consulte a seção [Gestos][] do cookbook.
:::

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de snackbar do Flutter no DartPad" run="true"
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
              label: 'Desfazer',
              onPressed: () {
                // Algum código para desfazer a mudança.
              },
            ),
          );

          // Encontre o ScaffoldMessenger na árvore de widgets
          // e use-o para mostrar uma SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: const Text('Mostrar SnackBar'),
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
