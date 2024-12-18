---
ia-translate: true
title: API Deprecadas Removidas Após a v2.5
description: >
  Após atingir o fim de vida útil, as seguintes APIs deprecadas
  foram removidas do Flutter.
---

## Sumário

De acordo com a [Política de Depreciação][Deprecation Policy] do Flutter,
APIs deprecadas que atingiram o fim de vida após o
lançamento da versão estável 2.5 foram removidas.

Todas as APIs afetadas foram compiladas nesta fonte
primária para auxiliar na migração. Uma
[folha de referência rápida][] também está disponível.


[Deprecation Policy]: {{site.repo.flutter}}/blob/master/docs/contributing/Tree-hygiene.md#deprecations
[folha de referência rápida]: /go/deprecations-removed-after-2-5

## Mudanças

Esta seção lista as depreciações por classe afetada.

---

### `autovalidate` de `Form` & classes relacionadas

Suportado pelo Flutter Fix: sim

`autovalidate` foi depreciado na v1.19.

Use `autovalidateMode` em vez disso.
Onde `autovalidate` era true, substitua por `AutovalidateMode.always`.
Onde `autovalidate` era false, substitua por `AutovalidateMode.disabled`.
Essa mudança permite que mais comportamentos sejam especificados além da escolha
binária original, adicionando `AutovalidateMode.onUserInteraction` como uma opção
adicional.

As seguintes classes têm a mesma mudança de API:

- `Form`
- `FormField`
- `DropdownButtonFormField`
- `TextFormField`

**Guia de migração**

[Guia de migração detalhado disponível][]

Código antes da migração:

```dart
const Form form = Form(autovalidate: true);
const Form form = Form(autovalidate: false);
final autoMode = form.autovalidate;

const FormField formField = FormField(autovalidate: true);
const FormField formField = FormField(autovalidate: false);
final autoMode = formField.autovalidate;

const TextFormField textFormField = TextFormField(autovalidate: true);
const TextFormField textFormField = TextFormField(autovalidate: false);

const DropdownButtonFormField dropDownButtonFormField = DropdownButtonFormField(autovalidate: true);
const DropdownButtonFormField dropdownButtonFormField = DropdownButtonFormField(autovalidate: false);
```

Código após a migração:

```dart
const Form form = Form(autovalidateMode: AutovalidateMode.always);
const Form form = Form(autovalidateMode: AutovalidateMode.disabled);
final autoMode = form.autovalidateMode;

const FormField formField = FormField(autovalidateMode: AutovalidateMode.always);
const FormField formField = FormField(autovalidateMode: AutovalidateMode.disabled);
final autoMode = formField.autovalidateMode;

const TextFormField textFormField = TextFormField(autovalidateMode: AutovalidateMode.always);
const TextFormField textFormField = TextFormField(autovalidateMode: AutovalidateMode.disabled);

const DropdownButtonFormField dropDownButtonFormField = DropdownButtonFormField(autovalidateMode: AutovalidateMode.always);
const DropdownButtonFormField dropdownButtonFormField = DropdownButtonFormField(autovalidateMode: AutovalidateMode.disabled);
```

[Guia de migração detalhado disponível]: /release/breaking-changes/form-field-autovalidation-api

**Referências**

Documentação da API:

* [`Form`][]
* [`FormField`][]
* [`TextFormField`][]
* [`DropdownButtonFormField`][]
* [`AutovalidateMode`][]

Issues relevantes:

* [Issue 56363]({{site.repo.flutter}}/issues/56363)
* [Issue 18885]({{site.repo.flutter}}/issues/18885)
* [Issue 15404]({{site.repo.flutter}}/issues/15404)
* [Issue 36154]({{site.repo.flutter}}/issues/36154)
* [Issue 48876]({{site.repo.flutter}}/issues/48876)

PRs relevantes:

* Depreciado em [#59766]({{site.repo.flutter}}/pull/59766)
* Removido em [#90292]({{site.repo.flutter}}/pull/90292)

[`Form`]: {{site.api}}/flutter/widgets/Form-class.html
[`FormField`]: {{site.api}}/flutter/widgets/FormField-class.html
[`TextFormField`]: {{site.api}}/flutter/material/TextFormField-class.html
[`DropdownButtonFormField`]: {{site.api}}/flutter/material/DropdownButtonFormField-class.html
[`AutovalidateMode`]: {{site.api}}/flutter/widgets/AutovalidateMode-class.html

---

### `FloatingHeaderSnapConfiguration.vsync`

Suportado pelo Flutter Fix: não

A propriedade `TickerProvider` `vsync` de `FloatingHeaderSnapConfiguration` foi
depreciada na v1.19.

O `vsync` para a animação deve ser especificado usando
`SliverPersistentHeaderDelegate.vsync` em vez disso.

**Guia de migração**

Código antes da migração:

```dart
class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  FloatingHeaderSnapConfiguration? get snapConfiguration => FloatingHeaderSnapConfiguration(vsync: myTickerProvider);
}
```

Código após a migração:

```dart
class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  FloatingHeaderSnapConfiguration? get snapConfiguration => FloatingHeaderSnapConfiguration();
  TickerProvider? get vsync => myTickerProvider;
}
```

**Referências**

Documento de design:

* [Control SliverPersistentHeader's showOnScreen Behavior][]

Documentação da API:

* [`FloatingHeaderSnapConfiguration`][]
* [`SliverPersistentHeaderDelegate`][]
* [`TickerProvider`][]

Issues relevantes:

* [Issue 25507]({{site.repo.flutter}}/issues/25507)

PRs relevantes:

* Depreciado em [#56413]({{site.repo.flutter}}/pull/56413)
* Removido em [#90293]({{site.repo.flutter}}/pull/90293)

[Control SliverPersistentHeader's showOnScreen Behavior]: https://docs.google.com/document/d/1BZhxy176uUnqOCnXdnHM1XetS9mw9WIyUAOE-dgVdUM/edit?usp=sharing
[`FloatingHeaderSnapConfiguration`]: {{site.api}}/flutter/rendering/FloatingHeaderSnapConfiguration-class.html
[`SliverPersistentHeaderDelegate`]: {{site.api}}/flutter/widgets/SliverPersistentHeaderDelegate-class.html
[`TickerProvider`]: {{site.api}}/flutter/scheduler/TickerProvider-class.html

---

### `AndroidViewController` & `id` das subclasses

Suportado pelo Flutter Fix: sim

O `id` de `AndroidViewController`, `TextureAndroidViewController` e
`SurfaceAndroidViewController`, foi depreciado na v1.20.

Para todos esses casos de uso, `viewId` deve ser usado em vez disso.

**Guia de migração**

Código antes da migração:

```dart
final SurfaceAndroidViewController surfaceController = SurfaceAndroidViewController(
  viewId: 10,
  viewType: 'FixTester',
  layoutDirection: TextDirection.ltr,
);
int viewId = surfaceController.id;
final SurfaceAndroidViewController surfaceController = SurfaceAndroidViewController(
  error: '',
);
final TextureAndroidViewController textureController = TextureAndroidViewController(
  error: '',
);
final TextureAndroidViewController textureController = TextureAndroidViewController(
  viewId: 10,
  viewType: 'FixTester',
  layoutDirection: TextDirection.ltr,
);
viewId = textureController.id;
```

Código após a migração:

```dart
final SurfaceAndroidViewController surfaceController = SurfaceAndroidViewController(
  viewId: 10,
  viewType: 'FixTester',
  layoutDirection: TextDirection.ltr,
);
int viewId = surfaceController.viewId;
final SurfaceAndroidViewController surfaceController = SurfaceAndroidViewController(
  error: '',
);
final TextureAndroidViewController textureController = TextureAndroidViewController(
  error: '',
);
final TextureAndroidViewController textureController = TextureAndroidViewController(
  viewId: 10,
  viewType: 'FixTester',
  layoutDirection: TextDirection.ltr,
);
viewId = textureController.viewId;
```

**Referências**

Documento de design:

* [Flutter Hybrid Composition][]

Documentação da API:

* [`AndroidViewController`][]
* [`TextureAndroidViewController`][]
* [`SurfaceAndroidViewController`][]

Issues relevantes:

* [Issue 55218]({{site.repo.flutter}}/issues/55218)

PRs relevantes:

* Depreciado em [#60320]({{site.repo.flutter}}/issues/60320)
* Removido em [#90294]({{site.repo.flutter}}/issues/90294)

[Flutter Hybrid Composition]: {{site.repo.flutter}}/blob/master/docs/platforms/Hybrid-Composition.md
[`AndroidViewController`]: {{site.api}}/flutter/services/AndroidViewController-class.html
[`TextureAndroidViewController`]: {{site.api}}/flutter/services/TextureAndroidViewController-class.html
[`SurfaceAndroidViewController`]: {{site.api}}/flutter/services/SurfaceAndroidViewController-class.html

---

### `BlacklistingTextInputFormatter` & `WhitelistingTextInputFormatter`

Suportado pelo Flutter Fix: não

As classes inteiras de `BlacklistingTextInputFormatter` e
`WhitelistingTextInoutFormatter` foram depreciadas na v1.20.

Sua funcionalidade foi reescrita em uma única classe,
`FilteringTextInputFormatter`.

**Guia de migração**

Código antes da migração:

```dart
formatter = BlacklistingTextInputFormatter(pattern, replacementString: 'replacedPattern');
formatter = BlacklistingTextInputFormatter.singleLineFormatter;
pattern = formatter.blacklistedPattern;
formatter = WhitelistingTextInputFormatter(pattern);
formatter = WhitelistingTextInputFormatter.digitsOnly;
pattern = formatter.whitelistedPattern;
```

Código após a migração:

```dart
formatter = FilteringTextInputFormatter.deny(pattern, replacementString: 'replacedPattern');
formatter = FilteringTextInputFormatter.singleLineFormatter;
pattern = formatter.filterPattern;
formatter = FilteringTextInputFormatter.allow(pattern);
formatter = FilteringTextInputFormatter.digitsOnly;
pattern = formatter.filterPattern;
```

**Referências**

Documentação da API:

* [`FilteringTextInputFormatter`][]

PRs relevantes:

* Depreciado em [#59120]({{site.repo.flutter}}/issues/59120)
* Removido em [#90296]({{site.repo.flutter}}/issues/90296)

[`FilteringTextInputFormatter`]: {{site.api}}/flutter/services/FilteringTextInputFormatter-class.html

---

### `BottomNavigationBarItem.title`

Suportado pelo Flutter Fix: sim

O `title` de `BottomNavigationBarItem` foi depreciado na v1.19.
A propriedade `label` deve ser usada em vez disso. Essa migração permite uma
melhor escala de texto e apresenta `Tooltip`s internos para o `BottomNavigationBarItem`
no contexto de um `BottomNavigationBar`.

**Guia de migração**

[Guia de migração detalhado disponível][]

Código antes da migração:

```dart
const BottomNavigationBarItem bottomNavigationBarItem = BottomNavigationBarItem(title: myTitle);
const BottomNavigationBarItem bottomNavigationBarItem = BottomNavigationBarItem();
bottomNavigationBarItem.title;
```

Código após a migração:

```dart
const BottomNavigationBarItem bottomNavigationBarItem = BottomNavigationBarItem(label: myTitle);
const BottomNavigationBarItem bottomNavigationBarItem = BottomNavigationBarItem();
bottomNavigationBarItem.label;
```

**Referências**

Documento de design:
* [BottomNavigationBarItem title][]

Documentação da API:

* [`BottomNavigationBarItem`][]
* [`BottomNavigationBar`][]
* [`Tooltip`][]

PRs relevantes:

* Depreciado em [#59127]({{site.repo.flutter}}/issues/59127)
* Removido em [#90295]({{site.repo.flutter}}/issues/90295)

[Guia de migração detalhado disponível]: /release/breaking-changes/bottom-navigation-title-to-label
[BottomNavigationBarItem title]: /go/bottom-navigation-bar-title-deprecation
[`BottomNavigationBarItem`]: {{site.api}}/flutter/widgets/BottomNavigationBarItem-class.html
[`BottomNavigationBar`]: {{site.api}}/flutter/material/BottomNavigationBar-class.html
[`Tooltip`]: {{site.api}}/flutter/material/Tooltip-class.html

---

### `packageRoot` em `dart:core`, `dart:isolate` e `package:platform`

As seguintes APIs foram removidas:

* [`Platform.packageRoot`][] em `dart:core`
* [`Isolate.packageRoot`][] em `dart:isolate`
* [`Platform.packageRoot`][] em `package:platform`

Essas APIs foram marcadas como deprecadas [no Dart 2.0][dart-deprecated], e não
funcionaram corretamente em nenhuma versão do Dart 2.x.

**Guia de migração**

Essas APIs `packageRoot` foram substituídas por um novo conjunto de APIs
`packageConfig`, para as quais você deve migrar.

* [`Platform.packageConfig`][] em `dart:core`
* [`Isolate.packageConfig`][] em `dart:isolate`
* [`Platform.packageConfig`][] em `package:platform`

Se você estiver usando o pacote `package:platform`, observe que,
independentemente de você estar usando a API `packageRoot` ou não, versões mais
antigas desse pacote não são compatíveis com o Dart 2.16 e posterior, pois
dependem da API `packageRoot` agora removida. Você pode ver um erro como este ao
tentar executar seu aplicativo:

```plaintext
../../.pub-cache/hosted/pub.dartlang.org/platform-3.0.0/
  lib/src/interface/local_platform.dart:46:19:
  Error: Member not found: 'packageRoot'.
      io.Platform.packageRoot; // ignore: deprecated_member_use
                  ^^^^^^^^^^^
```

Para resolver isso, atualize para a versão `3.1.0` ou posterior de
`package:platform` atualizando a restrição em seu arquivo `pubspec.yaml`:

```yaml
dependencies:
  platform: ^3.1.0
```

**Referências**

PRs relevantes:

* Removido das bibliotecas Dart em [#47769][]
* Removido de `package:platform` em [PR #38][]
* Flutter atualizado para usar `package:platform` 3.1.0 em [PR #94603][]

[`Platform.packageRoot`]: {{site.dart.api}}/stable/2.15.1/dart-io/Platform/packageRoot.html
[`Isolate.packageRoot`]: {{site.dart.api}}/stable/2.15.1/dart-isolate/Isolate/packageRoot.html
[`Platform.packageRoot`]: {{site.pub-api}}/platform/3.0.0/platform/Platform/packageRoot.html
[dart-deprecated]: https://dart-review.googlesource.com/c/sdk/+/59100/16/CHANGELOG.md
[`Platform.packageConfig`]: {{site.dart.api}}/stable/2.15.1/dart-io/Platform/packageConfig.html
[`Isolate.packageConfig`]: {{site.dart.api}}/stable/2.15.1/dart-isolate/Isolate/packageConfig.html
[`Platform.packageConfig`]: {{site.pub-api}}/platform/3.0.0/platform/Platform/packageConfig.html
[#47769]: {{site.github}}/dart-lang/sdk/issues/47769
[PR #38]: {{site.github}}/google/platform.dart/pull/38
[PR #94603]: {{site.repo.flutter}}/pull/94603

---

## Cronologia

Na versão estável: 2.10
