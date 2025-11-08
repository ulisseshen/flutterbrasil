---
title: API depreciada removida após v3.16
description: >
  ia-translate: true-
  Após atingir o fim da vida útil, as seguintes APIs depreciadas
  foram removidas do Flutter.
---

## Resumo

De acordo com a [Política de Depreciação][Deprecation Policy] do Flutter,
APIs depreciadas que atingiram o fim da vida útil após a
3.16 versão estável foram removidas.

Todas as APIs afetadas foram compiladas nesta
fonte primária para auxiliar na migração.
To further aid your migration, check out this
[quick reference sheet][].

[Deprecation Policy]: {{site.repo.flutter}}/blob/main/docs/contributing/Tree-hygiene.md#deprecations
[quick reference sheet]: /go/deprecations-removed-after-3-16

## Mudanças

This section lists the deprecations by the package and affected class.

### Button `styleFrom` properties

Package: flutter
Suportado pelo Flutter Fix: sim

The `TextButton`, `ElevatedButton` and `OutlinedButton` widgets all have a
static `styleFrom` method for generating the `ButtonStyle`. The following color
properties of this method for each class foram depreciados na v3.1:

* `TextButton.styleFrom`
  * `primary`
  * `onSurface`
* `ElevatedButton.styleFrom`
  * `primary`
  * `onPrimary`
  * `onSurface`
* `OutlinedButton.styleFrom`
  * `primary`
  * `onSurface`

These changes better aligned the API with updated Material Design
specifications. The changes also provided more clarity in how the colors would
be applied to the buttons, by replacing these properties with `backgroundColor`,
`foregroundColor`, and `disabledForegroundColor`.

**Guia de migração**

Código antes da migração:

```dart
TextButton.styleFrom(
  primary: Colors.red,
  onSurface: Colors.black,
);
ElevatedButton.styleFrom(
  primary: Colors.red,
  onPrimary: Colors.blue,
  onSurface: Colors.black,
);
OutlinedButton.styleFrom(
  primary: Colors.red,
  onSurface: Colors.black,
);
```

Código após a migração:

```dart
TextButton.styleFrom(
  foregroundColor: Colors.red,
  disabledForegroundColor: Colors.black,
);
ElevatedButton.styleFrom(
  backgroundColor: Colors.red,
  foregroundColor: Colors.blue,
  disabledForegroundColor: Colors.black,
);
OutlinedButton.styleFrom(
  foregroundColor: Colors.red,
  disabledForegroundColor: Colors.black,
);
```

**Referências**

Documentação da API:

* [`TextButton`][]
* [`ElevatedButton`][]
* [`OutlinedButton`][]
* [`ButtonStyle`][]

PRs relevantes:

* Depreciado em [#105291][]
* Removido em [#139267][]

[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html
[`ElevatedButton`]: {{site.api}}/flutter/material/ElevatedButton-class.html
[`OutlinedButton`]: {{site.api}}/flutter/material/OutlinedButton-class.html
[`ButtonStyle`]: {{site.api}}/flutter/material/ButtonStyle-class.html

[#105291]: {{site.repo.flutter}}/pull/105291
[#139267]: {{site.repo.flutter}}/pull/139267

---

### ThemeData.selectedRowColor

Package: flutter
Suportado pelo Flutter Fix: sim

The `selectedRowColor` property of `ThemeData` foi depreciado na v3.1.

The property was no longer used by the framework, as widgets using it migrated
to other component themes or no longer required it in the updated specification
for Material Design.

**Guia de migração**

Código antes da migração:

```dart
ThemeData(
  // ...
  selectedRowColor: Colors.pink, // Would have no effect.  
);
```

Código após a migração:

```dart
ThemeData(
  // ...
  // Remove uses.  
);
```

**Referências**

Documentação da API:

* [`ThemeData`][]

PRs relevantes:

* Depreciado em [#109070][]
* Removido em [#139080][]

[`ThemeData`]: {{site.api}}/flutter/material/ThemeData-class.html

[#109070]: {{site.repo.flutter}}/pull/109070
[#139080]: {{site.repo.flutter}}/pull/139080

---

### NavigatorState.focusScopeNode

Package: flutter
Suportado pelo Flutter Fix: sim

The `focusScopeNode` property of `NavigatorState` foi depreciado na v3.1.

This change was made to resolve several issues stemming around the
`FocusScopeNode` introduced by the `Navigator`. Instead, the `FocusScope`
was moved to enclose the topmost `Navigator` in a `WidgetsApp`.
`NavigatorState` was changed to contain its own `FocusNode`, from where it can
refer to its `FocusNode.enclosingScope` to access the correct `FocusScopeNode`.

**Guia de migração**

Código antes da migração:

```dart
Navigator.of(context).focusScopeNode;

```

Código após a migração:

```dart
Navigator.of(context).focusNode.enclosingScope!;
```

**Referências**

Documentação da API:

* [`Navigator`][]
* [`NavigatorState`][]
* [`FocusScope`][]
* [`FocusScopeNode`][]
* [`FocusNode`][]

PRs relevantes:

* Depreciado em [#109702][]
* Removido em [#139260][]

[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`NavigatorState`]: {{site.api}}/flutter/widgets/NavigatorState-class.html
[`FocusScope`]: {{site.api}}/flutter/widgets/FocusScope-class.html
[`FocusScopeNode`]: {{site.api}}/flutter/widgets/FocusScopeNode-class.html
[`FocusNode`]: {{site.api}}/flutter/widgets/FocusNode-class.html

[#109702]: {{site.repo.flutter}}/pull/109702
[#139260]: {{site.repo.flutter}}/pull/139260

---

### PlatformMenuBar.body

Package: flutter
Suportado pelo Flutter Fix: sim

The `body` property of `PlatformMenuBar` foi depreciado na v3.1.

This change was made to align `PlatformMenuBar` with other widgets in the
framework, renaming it to `child`.

**Guia de migração**

Código antes da migração:

```dart
PlatformMenuBar(
  body: myWidget,
);
```

Código após a migração:

```dart
PlatformMenuBar(
  child: myWidget,
);
```

**Referências**

Documentação da API:

* [`PlatformMenuBar`][]

PRs relevantes:

* Depreciado em [#104565][]
* Removido em [#138509][]

[`PlatformMenuBar`]: {{site.api}}/flutter/widgets/PlatformMenuBar-class.html

[#104565]: {{site.repo.flutter}}/pull/104565
[#138509]: {{site.repo.flutter}}/pull/138509

---

The [previously announced][] deprecations for `TextTheme`, `WidgetInspectorService`,
and `WidgetInspectorServiceExtensions` were not removed during this cycle.
The `WidgetInspectorService` and `WidgetInspectorServiceExtensions`
deprecation on `setPubRootDirectories` has been extended another year to allow
IDEs and other customer to migrate.
Expect the `TextTheme` deprecations to be removed in the next cycle, which will
be announced again when it comes.

[previously announced]: https://groups.google.com/g/flutter-announce/c/DLnuqZo714o

---

## Linha do tempo

Na versão estável: 3.19.0
