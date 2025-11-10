---
ia-translate: true
title: APIs descontinuadas removidas após v3.16
description: >-
  Após atingir o fim da vida útil, as seguintes APIs descontinuadas
  foram removidas do Flutter.
---

## Resumo

De acordo com a [Política de Descontinuação][Deprecation Policy] do Flutter,
as APIs descontinuadas que atingiram o fim da vida útil após o
lançamento estável 3.16 foram removidas.

Todas as APIs afetadas foram compiladas nesta
fonte principal para auxiliar na migração.
Para auxiliar ainda mais sua migração, confira esta
[folha de referência rápida][quick reference sheet].

[Deprecation Policy]: {{site.repo.flutter}}/blob/main/docs/contributing/Tree-hygiene.md#deprecations
[quick reference sheet]: /go/deprecations-removed-after-3-16

## Mudanças

Esta seção lista as descontinuações por pacote e classe afetada.

### Propriedades `styleFrom` de Button

Package: flutter
Supported by Flutter Fix: yes

Os widgets `TextButton`, `ElevatedButton` e `OutlinedButton` todos têm um
método estático `styleFrom` para gerar o `ButtonStyle`. As seguintes propriedades
de cor deste método para cada classe foram descontinuadas na v3.1:

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

Essas mudanças alinharam melhor a API com as especificações atualizadas do Material Design.
As mudanças também proporcionaram mais clareza sobre como as cores seriam
aplicadas aos botões, substituindo essas propriedades por `backgroundColor`,
`foregroundColor` e `disabledForegroundColor`.

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

* [`TextButton`][`TextButton`]
* [`ElevatedButton`][`ElevatedButton`]
* [`OutlinedButton`][`OutlinedButton`]
* [`ButtonStyle`][`ButtonStyle`]

PRs relevantes:

* Descontinuado em [#105291][#105291]
* Removido em [#139267][#139267]

[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html
[`ElevatedButton`]: {{site.api}}/flutter/material/ElevatedButton-class.html
[`OutlinedButton`]: {{site.api}}/flutter/material/OutlinedButton-class.html
[`ButtonStyle`]: {{site.api}}/flutter/material/ButtonStyle-class.html

[#105291]: {{site.repo.flutter}}/pull/105291
[#139267]: {{site.repo.flutter}}/pull/139267

---

### ThemeData.selectedRowColor

Package: flutter
Supported by Flutter Fix: yes

A propriedade `selectedRowColor` de `ThemeData` foi descontinuada na v3.1.

A propriedade não era mais usada pelo framework, pois os widgets que a utilizavam migraram
para outros temas de componentes ou não a requeriam mais na especificação
atualizada do Material Design.

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

* [`ThemeData`][`ThemeData`]

PRs relevantes:

* Descontinuado em [#109070][#109070]
* Removido em [#139080][#139080]

[`ThemeData`]: {{site.api}}/flutter/material/ThemeData-class.html

[#109070]: {{site.repo.flutter}}/pull/109070
[#139080]: {{site.repo.flutter}}/pull/139080

---

### NavigatorState.focusScopeNode

Package: flutter
Supported by Flutter Fix: yes

A propriedade `focusScopeNode` de `NavigatorState` foi descontinuada na v3.1.

Esta mudança foi feita para resolver vários problemas relacionados ao
`FocusScopeNode` introduzido pelo `Navigator`. Em vez disso, o `FocusScope`
foi movido para envolver o `Navigator` superior em um `WidgetsApp`.
O `NavigatorState` foi alterado para conter seu próprio `FocusNode`, de onde pode
referenciar seu `FocusNode.enclosingScope` para acessar o `FocusScopeNode` correto.

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

* [`Navigator`][`Navigator`]
* [`NavigatorState`][`NavigatorState`]
* [`FocusScope`][`FocusScope`]
* [`FocusScopeNode`][`FocusScopeNode`]
* [`FocusNode`][`FocusNode`]

PRs relevantes:

* Descontinuado em [#109702][#109702]
* Removido em [#139260][#139260]

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
Supported by Flutter Fix: yes

A propriedade `body` de `PlatformMenuBar` foi descontinuada na v3.1.

Esta mudança foi feita para alinhar `PlatformMenuBar` com outros widgets no
framework, renomeando-a para `child`.

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

* [`PlatformMenuBar`][`PlatformMenuBar`]

PRs relevantes:

* Descontinuado em [#104565][#104565]
* Removido em [#138509][#138509]

[`PlatformMenuBar`]: {{site.api}}/flutter/widgets/PlatformMenuBar-class.html

[#104565]: {{site.repo.flutter}}/pull/104565
[#138509]: {{site.repo.flutter}}/pull/138509

---

As descontinuações [anunciadas anteriormente][previously announced] para `TextTheme`, `WidgetInspectorService`
e `WidgetInspectorServiceExtensions` não foram removidas durante este ciclo.
A descontinuação de `WidgetInspectorService` e `WidgetInspectorServiceExtensions`
em `setPubRootDirectories` foi estendida por mais um ano para permitir
que IDEs e outros clientes migrem.
Espera-se que as descontinuações de `TextTheme` sejam removidas no próximo ciclo, o que será
anunciado novamente quando chegar.

[previously announced]: https://groups.google.com/g/flutter-announce/c/DLnuqZo714o

---

## Cronograma

No lançamento estável: 3.19.0
