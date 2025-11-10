---
title: Asserções mais rigorosas no Navigator e no escopo do Hero controller
description: >
  Adicionadas asserções adicionais para garantir que
  um escopo de hero controller possa se inscrever em apenas um navigator por vez.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

O framework lança um erro de asserção quando detecta que há
múltiplos navigators registrados com um escopo de hero controller.

## Context

O escopo do hero controller hospeda um hero controller para sua subárvore
de widget. O hero controller pode suportar apenas um navigator por
vez. Anteriormente, não havia asserção para garantir isso.

## Description of change

Se o código começar a lançar erros de asserção após esta mudança,
significa que o código já estava quebrado mesmo antes desta mudança.
Múltiplos navigators podem estar registrados sob o mesmo escopo de
hero controller, e eles não podem acionar animações hero quando
suas rotas mudam. Esta mudança apenas expôs este problema.

## Migration guide

Uma aplicação de exemplo que começa a lançar exceções.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      builder: (BuildContext context, Widget child) {
        // Builds two parallel navigators. This throws
        // error because both of navigators are under the same
        // hero controller scope created by MaterialApp.
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

Você pode corrigir esta aplicação introduzindo seus próprios escopos de hero controller.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      builder: (BuildContext context, Widget child) {
        // Builds two parallel navigators.
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

## Timeline

Landed in version: 1.20.0<br>
In stable release: 1.20

## References

API documentation:

* [`Navigator`][]
* [`HeroController`][]
* [`HeroControllerScope`][]

Relevant issue:

* [Issue 45938][]

Relevant PR:

* [Clean up hero controller scope][]

[Clean up hero controller scope]: {{site.repo.flutter}}/pull/60655
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`HeroController`]: {{site.api}}/flutter/widgets/HeroController-class.html
[`HeroControllerScope`]: {{site.api}}/flutter/widgets/HeroControllerScope-class.html
[Issue 45938]: {{site.repo.flutter}}/issues/45938
