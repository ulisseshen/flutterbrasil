---
ia-translate: true
title: CupertinoTabBar requer um pai Localizations
description: >
  Para fornecer semântica apropriada à localidade, o
  CupertinoTabBar requer um pai Localizations.
---

## Resumo

Instâncias de `CupertinoTabBar` devem ter um pai
`Localizations` para fornecer uma dica de `Semantics`
localizada. Tentar instanciar um `CupertinoTabBar` sem
localizações resulta em uma asserção como a seguinte:

```plaintext
CupertinoTabBar requer um pai Localizations para fornecer uma dica Semantics apropriada
para indexação de abas. Um CupertinoApp fornece o DefaultCupertinoLocalizations, ou você pode
instanciar suas próprias Localizations.
'package:flutter/src/cupertino/bottom_tab_bar.dart':
Falha na asserção: linha 213 pos 7: 'localizations != null'
```

## Contexto

Para suportar informações de semântica localizada, o
`CupertinoTabBar` requer localizações.

Antes dessa alteração, a dica de `Semantics` fornecida
ao `CupertinoTabBar` era uma String codificada,
'tab, $index de $total'. O conteúdo da dica de semântica
também foi atualizado dessa String original para 'Tab $index
de $total' em inglês.

Se o seu `CupertinoTabBar` estiver dentro do escopo
de um `CupertinoApp`, o `DefaultCupertinoLocalizations`
já está instanciado e pode atender às suas
necessidades sem ter que fazer uma alteração no seu código existente.

Se o seu `CupertinoTabBar` não estiver dentro de um `CupertinoApp`,
você pode fornecer as localizações de
sua escolha usando o widget `Localizations`.

## Guia de migração

Se você estiver vendo um erro de asserção `'localizations != null'`,
certifique-se de que as informações de localidade estão sendo
fornecidas para o seu `CupertinoTabBar`.

Código antes da migração:

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

Código após a migração (Fornecendo localizações via o `CupertinoApp`):

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

Código após a migração (Fornecendo localizações usando o widget
`Localizations`):

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

## Linha do tempo

Implementado na versão: 1.18.0-9.0.pre<br>
Na versão estável: 1.20.0

## Referências

Documentação da API:

* [`CupertinoTabBar`][]
* [`Localizations`][]
* [`DefaultCupertinoLocalizations`][]
* [`Semantics`][]
* [`CupertinoApp`][]
* [Internacionalizando Aplicativos Flutter][]

PRs relevantes:

* [PR 55336: Adicionando tabSemanticsLabel ao CupertinoLocalizations][]
* [PR 56582: Atualizar a semântica da Tab no Cupertino para ser a mesma do Material][]

[`CupertinoTabBar`]: {{site.api}}/flutter/cupertino/CupertinoTabBar-class.html
[`Localizations`]: {{site.api}}/flutter/widgets/Localizations-class.html
[`DefaultCupertinoLocalizations`]: {{site.api}}/flutter/cupertino/DefaultCupertinoLocalizations-class.html
[`Semantics`]: {{site.api}}/flutter/widgets/Semantics-class.html
[`CupertinoApp`]: {{site.api}}/flutter/cupertino/CupertinoApp-class.html
[Internacionalizando Aplicativos Flutter]: /ui/accessibility-and-internationalization/internationalization
[PR 55336: Adicionando tabSemanticsLabel ao CupertinoLocalizations]: {{site.repo.flutter}}/pull/55336
[PR 56582: Atualizar a semântica da Tab no Cupertino para ser a mesma do Material]: {{site.repo.flutter}}/pull/56582#issuecomment-625497951
