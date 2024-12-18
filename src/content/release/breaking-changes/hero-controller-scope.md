---
ia-translate: true
title: Asserções Mais Estritas no Navigator e no Escopo do Hero Controller
description: >
  Adicionadas asserções adicionais para garantir que
  um escopo de hero controller possa se inscrever em apenas um navegador por vez.
---

## Sumário

O framework lança um erro de asserção quando detecta que há
múltiplos navigators registrados em um escopo de hero controller.

## Contexto

O escopo do hero controller hospeda um hero controller para sua
subárvore de widgets. O hero controller pode suportar apenas um
navigator por vez. Anteriormente, não havia nenhuma asserção para
garantir isso.

## Descrição da mudança

Se o código começar a lançar erros de asserção após esta mudança,
significa que o código já estava quebrado mesmo antes desta
mudança. Múltiplos navigators podem ser registrados sob o mesmo
escopo de hero controller, e eles não podem acionar animações hero
quando suas rotas mudam. Esta mudança apenas revelou este problema.

## Guia de migração

Um exemplo de aplicação que começa a lançar exceções.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      builder: (BuildContext context, Widget child) {
        // Constrói dois navigators paralelos. Isso lança
        // erro porque ambos os navigators estão sob o mesmo
        // escopo de hero controller criado pelo MaterialApp.
        return Stack(
          children: <Widget>[
            Navigator(
              onGenerateRoute: (RouteSettings settings) {
                return MaterialPageRoute<void>(
                  settings: settings,
                  builder: (BuildContext context) {
                    return const Text('first Navigator');
                  }
                );
              },
            ),
            Navigator(
              onGenerateRoute: (RouteSettings settings) {
                return MaterialPageRoute<void>(
                  settings: settings,
                  builder: (BuildContext context) {
                    return const Text('Second Navigator');
                  }
                );
              },
            ),
          ],
        );
      }
    )
  );
}
```

Você pode corrigir esta aplicação introduzindo seus próprios
escopos de hero controller.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      builder: (BuildContext context, Widget child) {
        // Constrói dois navigators paralelos.
        return Stack(
          children: <Widget>[
            HeroControllerScope(
              controller: MaterialApp.createMaterialHeroController(),
              child: Navigator(
                onGenerateRoute: (RouteSettings settings) {
                  return MaterialPageRoute<void>(
                    settings: settings,
                    builder: (BuildContext context) {
                      return const Text('first Navigator');
                    }
                  );
                },
              ),
            ),
            HeroControllerScope(
              controller: MaterialApp.createMaterialHeroController(),
              child: Navigator(
                onGenerateRoute: (RouteSettings settings) {
                  return MaterialPageRoute<void>(
                    settings: settings,
                    builder: (BuildContext context) {
                      return const Text('second Navigator');
                    }
                  );
                },
              ),
            ),
          ],
        );
      }
    )
  );
}
```

## Linha do tempo

Incluído na versão: 1.20.0<br>
Na versão estável: 1.20

## Referências

Documentação da API:

* [`Navigator`][]
* [`HeroController`][]
* [`HeroControllerScope`][]

Issue relevante:

* [Issue 45938][]

PR relevante:

* [Clean up hero controller scope][]

[Clean up hero controller scope]: {{site.repo.flutter}}/pull/60655
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`HeroController`]: {{site.api}}/flutter/widgets/HeroController-class.html
[`HeroControllerScope`]: {{site.api}}/flutter/widgets/HeroControllerScope-class.html
[Issue 45938]: {{site.repo.flutter}}/issues/45938
