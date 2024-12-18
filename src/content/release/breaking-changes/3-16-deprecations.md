---
ia-translate: true
title: API Deprecadas Removidas Após a v3.16
description: >-
  Após atingir o fim da vida útil, as seguintes APIs
  deprecadas foram removidas do Flutter.
---

## Sumário

Em conformidade com a [Política de Depreciação][] do Flutter,
APIs deprecadas que atingiram o fim da vida útil após o
lançamento estável 3.16 foram removidas.

Todas as APIs afetadas foram compiladas nesta fonte
primária para auxiliar na migração.
Para auxiliar ainda mais na sua migração, confira esta
[folha de referência rápida][].

[Política de Depreciação]: {{site.repo.flutter}}/blob/master/docs/contributing/Tree-hygiene.md#deprecations
[folha de referência rápida]: /go/deprecations-removed-after-3-16

## Mudanças

Esta seção lista as depreciações por pacote e classe afetada.

### Propriedades `styleFrom` de Botões

Pacote: flutter
Suportado pelo Flutter Fix: sim

Os widgets `TextButton`, `ElevatedButton` e `OutlinedButton` possuem um
método estático `styleFrom` para gerar o `ButtonStyle`. As seguintes propriedades
de cor deste método para cada classe foram depreciadas na v3.1:

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

Essas mudanças alinharam melhor a API com as especificações atualizadas do Material
Design. As mudanças também proporcionaram mais clareza em como as cores seriam
aplicadas aos botões, substituindo essas propriedades por `backgroundColor`,
`foregroundColor` e `disabledForegroundColor`.

**Guia de Migração**

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

Pacote: flutter
Suportado pelo Flutter Fix: sim

A propriedade `selectedRowColor` de `ThemeData` foi depreciada na v3.1.

A propriedade não era mais usada pelo framework, pois os widgets que a usavam migraram
para outros temas de componentes ou não precisavam mais dela na especificação
atualizada para o Material Design.

**Guia de Migração**

Código antes da migração:

```dart
ThemeData(
  // ...
  selectedRowColor: Colors.pink, // Não teria efeito.
);
```

Código após a migração:

```dart
ThemeData(
  // ...
  // Remova os usos.
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

Pacote: flutter
Suportado pelo Flutter Fix: sim

A propriedade `focusScopeNode` de `NavigatorState` foi depreciada na v3.1.

Essa mudança foi feita para resolver vários problemas decorrentes do
`FocusScopeNode` introduzido pelo `Navigator`. Em vez disso, o `FocusScope`
foi movido para envolver o `Navigator` mais alto em um `WidgetsApp`.
`NavigatorState` foi alterado para conter seu próprio `FocusNode`, de onde ele
pode se referir ao seu `FocusNode.enclosingScope` para acessar o `FocusScopeNode` correto.

**Guia de Migração**

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

Pacote: flutter
Suportado pelo Flutter Fix: sim

A propriedade `body` de `PlatformMenuBar` foi depreciada na v3.1.

Essa mudança foi feita para alinhar `PlatformMenuBar` com outros widgets no
framework, renomeando-o para `child`.

**Guia de Migração**

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

As depreciações [anunciadas anteriormente][] para `TextTheme`, `WidgetInspectorService`,
e `WidgetInspectorServiceExtensions` não foram removidas durante este ciclo.
A depreciação de `WidgetInspectorService` e `WidgetInspectorServiceExtensions`
em `setPubRootDirectories` foi estendida por mais um ano para permitir que
IDEs e outros clientes migrem.
Espere que as depreciações de `TextTheme` sejam removidas no próximo ciclo, o
que será anunciado novamente quando chegar.

[anunciadas anteriormente]: https://groups.google.com/g/flutter-announce/c/DLnuqZo714o

---

## Linha do Tempo

Na versão estável: 3.19.0

