---
title: CupertinoTabBar requer parent Localizations
description: >
  Para fornecer semântica apropriada ao locale, o
  CupertinoTabBar requer um parent Localizations.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

Instâncias de `CupertinoTabBar` devem ter um
parent `Localizations` para fornecer uma dica de
`Semantics` localizada. Tentar instanciar um
`CupertinoTabBar` sem localizações
resulta em uma asserção como a seguinte:

```plaintext
CupertinoTabBar requires a Localizations parent in order to provide an appropriate Semantics hint
for tab indexing. A CupertinoApp provides the DefaultCupertinoLocalizations, or you can
instantiate your own Localizations.
'package:flutter/src/cupertino/bottom_tab_bar.dart':
Failed assertion: line 213 pos 7: 'localizations != null'
```

## Context

Para suportar informações de semântica localizadas,
o `CupertinoTabBar` requer localizações.

Antes desta mudança, a dica `Semantics` fornecida
ao `CupertinoTabBar` era uma String codificada,
'tab, $index of $total'. O conteúdo da dica de semântica
também foi atualizado desta String original
para 'Tab $index of $total' em inglês.

Se seu `CupertinoTabBar` está dentro do escopo
de um `CupertinoApp`, o `DefaultCupertinoLocalizations`
já está instanciado e pode atender suas
necessidades sem ter que fazer uma mudança no seu código existente.

Se seu `CupertinoTabBar` não está dentro de um `CupertinoApp`,
você pode fornecer as localizações de
sua escolha usando o widget `Localizations`.

## Migration guide

Se você está vendo um erro de asserção `'localizations != null'`,
certifique-se de que informações de locale estão sendo
fornecidas ao seu `CupertinoTabBar`.

Code before migration:

```dart
import 'package:flutter/cupertino.dart';

void main() => runApp(Foo());

class Foo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(),
      child: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add_circled),
            label: 'Tab 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add_circled_solid),
            label: 'Tab 2',
          ),
        ],
        currentIndex: 1,
      ),
    );
  }
}
```

Code after migration (Providing localizations via the `CupertinoApp`):

```dart
import 'package:flutter/cupertino.dart';

void main() => runApp(Foo());

class Foo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add_circled),
            label: 'Tab 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add_circled_solid),
            label: 'Tab 2',
          ),
        ],
        currentIndex: 1,
      ),
    );
  }
}
```

Code after migration (Providing localizations by using
the `Localizations` widget):

```dart
import 'package:flutter/cupertino.dart';

void main() => runApp(Foo());

class Foo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Localizations(
      locale: const Locale('en', 'US'),
      delegates: <LocalizationsDelegate<dynamic>>[
        DefaultWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      child: MediaQuery(
        data: const MediaQueryData(),
        child: CupertinoTabBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.add_circled),
              label: 'Tab 1',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.add_circled_solid),
              label: 'Tab 2',
            ),
          ],
          currentIndex: 1,
        ),
      ),
    );
  }
}
```

## Timeline

Landed in version: 1.18.0-9.0.pre<br>
In stable release: 1.20.0

## References

API documentation:

* [`CupertinoTabBar`][]
* [`Localizations`][]
* [`DefaultCupertinoLocalizations`][]
* [`Semantics`][]
* [`CupertinoApp`][]
* [Internationalizing Flutter Apps][]


Relevant PR:

* [PR 55336: Adding tabSemanticsLabel to CupertinoLocalizations][]
* [PR 56582: Update Tab semantics in Cupertino to be the same as Material][]

[`CupertinoTabBar`]: {{site.api}}/flutter/cupertino/CupertinoTabBar-class.html
[`Localizations`]: {{site.api}}/flutter/widgets/Localizations-class.html
[`DefaultCupertinoLocalizations`]: {{site.api}}/flutter/cupertino/DefaultCupertinoLocalizations-class.html
[`Semantics`]: {{site.api}}/flutter/widgets/Semantics-class.html
[`CupertinoApp`]: {{site.api}}/flutter/cupertino/CupertinoApp-class.html
[Internationalizing Flutter Apps]: /ui/internationalization
[PR 55336: Adding tabSemanticsLabel to CupertinoLocalizations]: {{site.repo.flutter}}/pull/55336
[PR 56582: Update Tab semantics in Cupertino to be the same as Material]: {{site.repo.flutter}}/pull/56582#issuecomment-625497951
