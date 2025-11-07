---
title: Atualize a UI com base na orientação
description: Responda a uma mudança na orientação da tela.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
ia-translate: true
---

<?code-excerpt path-base="cookbook/design/orientation"?>

Em algumas situações,
você quer atualizar a exibição de um aplicativo quando o usuário
gira a tela do modo retrato para o modo paisagem. Por exemplo,
o aplicativo pode mostrar um item após o outro no modo retrato,
mas colocar esses mesmos itens lado a lado no modo paisagem.

No Flutter, você pode construir diferentes layouts dependendo
de uma determinada [`Orientation`][].
Neste exemplo, construa uma lista que exibe duas colunas no
modo retrato e três colunas no modo paisagem usando as
seguintes etapas:

  1. Construir um `GridView` com duas colunas.
  2. Usar um `OrientationBuilder` para alterar o número de colunas.

## 1. Construir um `GridView` com duas colunas

Primeiro, crie uma lista de itens para trabalhar.
Em vez de usar uma lista normal,
crie uma lista que exibe itens em uma grade.
Por enquanto, crie uma grade com duas colunas.

<?code-excerpt "lib/partials.dart (GridViewCount)"?>
```dart
return GridView.count(
  // A list with 2 columns
  crossAxisCount: 2,
  // ...
);
```

Para saber mais sobre trabalhar com `GridViews`,
consulte a receita [Criando uma lista de grade][Creating a grid list].

## 2. Usar um `OrientationBuilder` para alterar o número de colunas

Para determinar a `Orientation` atual do aplicativo, use o
widget [`OrientationBuilder`][].
O `OrientationBuilder` calcula a `Orientation` atual comparando
a largura e altura disponíveis para o widget pai,
e reconstrói quando o tamanho do pai muda.

Usando a `Orientation`, construa uma lista que exibe duas colunas no modo retrato
ou três colunas no modo paisagem.

<?code-excerpt "lib/partials.dart (OrientationBuilder)"?>
```dart
body: OrientationBuilder(
  builder: (context, orientation) {
    return GridView.count(
      // Create a grid with 2 columns in portrait mode,
      // or 3 columns in landscape mode.
      crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
    );
  },
),
```

:::note
Se você estiver interessado na orientação da tela,
em vez da quantidade de espaço disponível para o pai,
use `MediaQuery.of(context).orientation` em vez de um
widget `OrientationBuilder`.
:::

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter app orientation hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Orientation Demo';

    return const MaterialApp(
      title: appTitle,
      home: OrientationList(
        title: appTitle,
      ),
    );
  }
}

class OrientationList extends StatelessWidget {
  final String title;

  const OrientationList({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return GridView.count(
            // Create a grid with 2 columns in portrait mode, or 3 columns in
            // landscape mode.
            crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
            // Generate 100 widgets that display their index in the List.
            children: List.generate(100, (index) {
              return Center(
                child: Text(
                  'Item $index',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/orientation.gif" alt="Orientation Demo" class="site-mobile-screenshot" />
</noscript>

## Bloqueando a orientação do dispositivo

Na seção anterior, você aprendeu
como adaptar a UI do aplicativo às mudanças de orientação do dispositivo.

O Flutter também permite que você especifique as orientações que seu aplicativo suporta
usando os valores de [`DeviceOrientation`]. Você pode:

- Bloquear o aplicativo para uma única orientação, como apenas a posição `portraitUp`, ou...
- Permitir múltiplas orientações, como ambas `portraitUp` e `portraitDown`, mas não paisagem.

No método `main()` do aplicativo,
chame [`SystemChrome.setPreferredOrientations()`]
com a lista de orientações preferidas que seu aplicativo suporta.

Para bloquear o dispositivo em uma única orientação,
você pode passar uma lista com um único item.

Para uma lista de todos os valores possíveis, confira [`DeviceOrientation`].

<?code-excerpt "lib/orientation.dart (PreferredOrientations)"?>
```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}
```


[Creating a grid list]: /cookbook/lists/grid-lists
[`DeviceOrientation`]: {{site.api}}/flutter/services/DeviceOrientation.html
[`OrientationBuilder`]: {{site.api}}/flutter/widgets/OrientationBuilder-class.html
[`Orientation`]: {{site.api}}/flutter/widgets/Orientation.html
[`SystemChrome.setPreferredOrientations()`]: {{site.api}}/flutter/services/SystemChrome/setPreferredOrientations.html
