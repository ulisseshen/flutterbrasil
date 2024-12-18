---
ia-translate: true
title: Atualizar a UI com base na orientação
description: Responda a uma mudança na orientação da tela.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/design/orientation"?>

Em algumas situações, você quer atualizar a exibição de um aplicativo quando o usuário gira a tela do modo retrato para o modo paisagem. Por exemplo, o aplicativo pode mostrar um item após o outro no modo retrato, mas colocar esses mesmos itens lado a lado no modo paisagem.

No Flutter, você pode construir layouts diferentes dependendo de uma dada [`Orientation`][]. Neste exemplo, construa uma lista que exiba duas colunas no modo retrato e três colunas no modo paisagem usando os seguintes passos:

  1. Construa um `GridView` com duas colunas.
  2. Use um `OrientationBuilder` para mudar o número de colunas.

## 1. Construa um `GridView` com duas colunas

Primeiro, crie uma lista de itens para trabalhar. Em vez de usar uma lista normal, crie uma lista que exiba itens em uma grade. Por enquanto, crie uma grade com duas colunas.

<?code-excerpt "lib/partials.dart (GridViewCount)"?>
```dart
return GridView.count(
  // Uma lista com 2 colunas
  crossAxisCount: 2,
  // ...
);
```

Para saber mais sobre como trabalhar com `GridViews`, veja a receita [Criando uma lista em grade][].

## 2. Use um `OrientationBuilder` para mudar o número de colunas

Para determinar a `Orientation` atual do aplicativo, use o widget [`OrientationBuilder`][]. O `OrientationBuilder` calcula a `Orientation` atual comparando a largura e a altura disponíveis para o widget pai e reconstrói quando o tamanho do pai muda.

Usando a `Orientation`, construa uma lista que exiba duas colunas no modo retrato ou três colunas no modo paisagem.

<?code-excerpt "lib/partials.dart (OrientationBuilder)"?>
```dart
body: OrientationBuilder(
  builder: (context, orientation) {
    return GridView.count(
      // Cria uma grade com 2 colunas no modo retrato,
      // ou 3 colunas no modo paisagem.
      crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
    );
  },
),
```

:::note
Se você estiver interessado na orientação da tela, em vez da quantidade de espaço disponível para o pai, use `MediaQuery.of(context).orientation` em vez de um widget `OrientationBuilder`.
:::

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de orientação de aplicativo Flutter no DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Demo de Orientação';

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
            // Cria uma grade com 2 colunas no modo retrato, ou 3 colunas no
            // modo paisagem.
            crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
            // Gera 100 widgets que exibem seu índice na Lista.
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
  <img src="/assets/images/docs/cookbook/orientation.gif" alt="Demo de Orientação" class="site-mobile-screenshot" />
</noscript>

## Bloqueando a orientação do dispositivo

Na seção anterior, você aprendeu como adaptar a UI do aplicativo a mudanças de orientação do dispositivo.

O Flutter também permite que você especifique as orientações que seu aplicativo suporta usando os valores de [`DeviceOrientation`]. Você pode:

- Bloquear o aplicativo em uma única orientação, como apenas a posição `portraitUp`, ou...
- Permitir múltiplas orientações, como `portraitUp` e `portraitDown`, mas não paisagem.

No método `main()` do aplicativo, chame [`SystemChrome.setPreferredOrientations()`] com a lista de orientações preferidas que seu aplicativo suporta.

Para bloquear o dispositivo em uma única orientação, você pode passar uma lista com um único item.

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

[Criando uma lista em grade]: /cookbook/lists/grid-lists
[`DeviceOrientation`]: {{site.api}}/flutter/services/DeviceOrientation.html
[`OrientationBuilder`]: {{site.api}}/flutter/widgets/OrientationBuilder-class.html
[`Orientation`]: {{site.api}}/flutter/widgets/Orientation.html
[`SystemChrome.setPreferredOrientations()`]: {{site.api}}/flutter/services/SystemChrome/setPreferredOrientations.html
