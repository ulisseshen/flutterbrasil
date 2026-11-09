---
ia-translate: true
title: Exibir uma Cupertino sheet
description: >-
  Como implementar uma Cupertino sheet para exibir mensagens e conteúdo.
---

<?code-excerpt path-base="cookbook/design/cupertino_sheets/"?>

Uma Cupertino sheet é um modal no estilo iOS,
usado para apresentar conteúdo ou opções.
Ela surge deslizando de baixo para cima na tela
e pode ser arrastada para baixo para ser fechada.

No Flutter, essa tarefa é feita por [`showCupertinoSheet`][].
Esta receita implementa uma Cupertino sheet seguindo estes passos:

  1. Criar um `CupertinoApp` ou `MaterialApp`.
  2. Exibir o conteúdo da sheet.

## 1. Criar um `CupertinoApp` {:#1-create-a-cupertinoapp}

Ao criar apps que seguem as diretrizes de design do iOS,
você pode usar `CupertinoApp`.
O exemplo a seguir exibe um botão no centro da tela
que abre o modal.

<?code-excerpt "lib/main.dart (CupertinoSheetDemo)"?>
```dart
class CupertinoSheetDemo extends StatelessWidget {
  const CupertinoSheetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'CupertinoSheet Demo',
      home: CupertinoSheetPage(),
    );
  }
}
```

## 2. Exibir o conteúdo da sheet {:#2-display-the-sheet-content}

Com a estrutura básica do app pronta, exiba a sheet.
Para mostrá-la, chame `showCupertinoSheet` e forneça um `scrollableBuilder`
que retorne o conteúdo da sheet, como um `SingleChildScrollView`.

<?code-excerpt "lib/main.dart (ShowCupertinoSheet)"?>
```dart
showCupertinoSheet<void>(
  context: context,
  scrollableBuilder: (context, scrollController) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 100),
            const Text('This is a Cupertino sheet'),
            const SizedBox(height: 20),
            CupertinoButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  },
);
```

## Exemplo interativo {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter CupertinoSheet hands-on example in DartPad" run="true"
import 'package:flutter/cupertino.dart';

void main() => runApp(const CupertinoSheetDemo());

class CupertinoSheetDemo extends StatelessWidget {
  const CupertinoSheetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'CupertinoSheet Demo',
      home: CupertinoSheetPage(),
    );
  }
}

class CupertinoSheetPage extends StatelessWidget {
  const CupertinoSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('CupertinoSheet Demo'),
      ),
      child: Center(
        child: CupertinoButton.filled(
          onPressed: () {
            showCupertinoSheet<void>(
              context: context,
              scrollableBuilder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 100),
                        const Text('This is a Cupertino sheet'),
                        const SizedBox(height: 20),
                        CupertinoButton(
                          child: const Text('Close'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: const Text('Show Sheet'),
        ),
      ),
    );
  }
}
```

[`showCupertinoSheet`]: {{site.cupertino_ui}}/showCupertinoSheet.html
