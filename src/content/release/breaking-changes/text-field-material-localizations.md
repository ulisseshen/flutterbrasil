---
title: TextField requer um widget MaterialLocalizations
description: >
  TextField agora lança um erro de assert se não houver
  um widget MaterialLocalizations na árvore de widgets.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

Instâncias de `TextField` devem ter um
`MaterialLocalizations` presente na árvore de widgets.
Tentar instanciar um `TextField` sem as localizações adequadas
resulta em uma assertion como a seguinte:

```plaintext
No MaterialLocalizations found.
TextField widgets require MaterialLocalizations to be provided by a Localizations widget ancestor.
The material library uses Localizations to generate messages, labels, and abbreviations.
To introduce a MaterialLocalizations, either use a MaterialApp at the root of your application to
include them automatically, or add a Localization widget with a MaterialLocalizations delegate.
The specific widget that could not find a MaterialLocalizations ancestor was:
  TextField
```

## Context

Se o `TextField` descende de um `MaterialApp`, o
`DefaultMaterialLocalizations` já está instanciado
e não exigirá alterações no seu código existente.

Se o `TextField` não descende de `MaterialApp`,
você pode usar um widget `Localizations` para
fornecer suas próprias localizações.

## Migration guide

Se você encontrar um erro de assertion, certifique-se de que
as informações de localização estejam disponíveis para o `TextField`,
seja através de um ancestral `MaterialApp`
(que fornece automaticamente `Localizations`), ou
criando seu próprio widget `Localizations`.

Código antes da migração:

```dart
import 'package:flutter/material.dart';

void main() => runApp(Foo());

class Foo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Material(
          child: TextField(),
        ),
      ),
    );
  }
}
```

Código após a migração (Fornecendo localizações usando o `MaterialApp`):

```dart
import 'package:flutter/material.dart';

void main() => runApp(Foo());

class Foo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: TextField(),
      ),
    );
  }
}
```

Código após a migração (Fornecendo localizações via widget `Localizations`):

```dart
import 'package:flutter/material.dart';

void main() => runApp(Foo());

class Foo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Localizations(
      locale: const Locale('en', 'US'),
      delegates: const <LocalizationsDelegate<dynamic>>[
        DefaultWidgetsLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
      ],
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Material(
            child: TextField(),
          ),
        ),
      ),
    );
  }
}
```

## Timeline

Adicionado na versão: 1.20.0-1.0.pre<br>
Na versão estável: 1.20

## References

Documentação da API:

* [`TextField`][]
* [`Localizations`][]
* [`MaterialLocalizations`][]
* [`DefaultMaterialLocalizations`][]
* [`MaterialApp`][]
* [Internationalizing Flutter apps][]

PR relevante:

* [PR 58831: Assert debugCheckHasMaterialLocalizations on TextField][]

[`TextField`]: {{site.api}}/flutter/material/TextField-class.html
[`Localizations`]: {{site.api}}/flutter/widgets/Localizations-class.html
[`MaterialLocalizations`]: {{site.api}}/flutter/material/MaterialLocalizations-class.html
[`DefaultMaterialLocalizations`]: {{site.api}}/flutter/material/DefaultMaterialLocalizations-class.html
[`MaterialApp`]: {{site.api}}/flutter/material/MaterialApp-class.html
[Internationalizing Flutter apps]: /ui/internationalization
[PR 58831: Assert debugCheckHasMaterialLocalizations on TextField]: {{site.repo.flutter}}/pull/58831
