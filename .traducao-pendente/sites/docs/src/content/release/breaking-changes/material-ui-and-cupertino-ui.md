---
ia-translate: true
title: Migre para os pacotes independentes material_ui e cupertino_ui
description: >-
  As bibliotecas de design Material e Cupertino agora estão disponíveis como
  pacotes independentes, desacoplando os sistemas de design do SDK do Flutter.
---

{% render "docs/breaking-changes.md" %}

<<<<<<< pt
## Resumo {:#summary}

As bibliotecas de design Material e Cupertino agora estão disponíveis como
pacotes independentes: [`package:material_ui`][`package:material_ui`] e [`package:cupertino_ui`][`package:cupertino_ui`].
No Flutter 3.47, os desenvolvedores podem optar por esses pacotes antes da
depreciação formal das bibliotecas de design incluídas no framework.

## Contexto {:#background}

Historicamente, as bibliotecas de widgets Material (`package:flutter/material.dart`)
e Cupertino (`package:flutter/cupertino.dart`) do Flutter eram incluídas
diretamente no SDK principal do Flutter.
Embora isso facilitasse o início com widgets com precisão de pixel,
incluir os sistemas de design no framework principal trazia vários desafios:

* Atualizações de widgets, correções de bugs e novos componentes estavam
  presos aos lançamentos trimestrais do SDK do Flutter.
* As contribuições e iterações nas bibliotecas de design avançavam mais devagar
  do que em pacotes Dart independentes.
* As aplicações não podiam atualizar as bibliotecas de design
  independentemente do engine e do framework.

Para resolver esses desafios, os sistemas de design agora estão desacoplados
do framework principal.
A partir do Flutter 3.47, a versão 1.0 dos pacotes independentes
`material_ui` e `cupertino_ui` é publicada no `pub.dev`.

Desacoplar os sistemas de design traz vários benefícios:

* **Ciclos de lançamento independentes**:
  os pacotes podem lançar correções de bugs, melhorias e novos componentes
  em seus próprios cronogramas (com lançamentos semanais previstos),
  sem exigir uma atualização completa do SDK do Flutter.
* **Contribuições mais rápidas**:
  membros da comunidade podem contribuir diretamente com as bibliotecas no
  repositório [`flutter/packages`][`flutter/packages`].
* **Núcleo neutro em estilo**:
  o desacoplamento prepara o terreno para um catálogo de widgets principais
  do Flutter neutro em estilo, facilitando a criação e a manutenção de
  sistemas de design customizados.

As contribuições para os pacotes Material e Cupertino dentro do SDK principal
foram congeladas a partir do Flutter 3.44.
As versões iniciais 1.0.0 de `package:material_ui` e `package:cupertino_ui`
correspondem ao código do framework congelado, para garantir uma transição sem interrupções.
As próximas versões dos pacotes usarão versionamento semântico para atualizações
de versão principal, secundária e de correção.
As bibliotecas de design do framework estão programadas para depreciação formal
em uma próxima versão estável.

## Guia de migração {:#migration-guide}

Para migrar o seu projeto das bibliotecas de design do framework para os
pacotes independentes, você pode usar a ferramenta automatizada `dart fix`
ou fazer a migração manualmente.

### Migração automatizada com dart fix {:#automated-migration-with-dart-fix}

A forma mais rápida de migrar é usar a regra de correção `migrate_design_widgets`
com o `dart fix`:
||||||| base_en
## Summary

The Material and Cupertino design libraries are now available as
standalone packages: [`package:material_ui`][] and [`package:cupertino_ui`][].
In Flutter 3.47, developers can opt in to these packages ahead of
the formal deprecation of the in-framework design libraries.

## Background

Historically, Flutter's Material (`package:flutter/material.dart`)
and Cupertino (`package:flutter/cupertino.dart`) widget libraries
were bundled directly inside the core Flutter SDK.
While this made it easy to get started with pixel-perfect widgets,
bundling design systems inside the core framework presented several challenges:

* Widget updates, bug fixes, and new components were tied to
  quarterly Flutter SDK releases.
* Contributions and iteration on design libraries moved slower
  than standalone Dart packages.
* Applications couldn't update design libraries independently of
  the engine and framework.

To resolve these challenges, the design systems are now decoupled
from the core framework.
Starting in Flutter 3.47, version 1.0 of the standalone
`material_ui` and `cupertino_ui` packages is published on `pub.dev`.

Decoupling the design systems provides several benefits:

* **Independent release cycles**:
  The packages can ship bug fixes, improvements, and new components
  on their own release schedules (planned for weekly releases),
  without requiring a full Flutter SDK upgrade.
* **Faster contributions**:
  Community members can contribute directly to the libraries in the
  [`flutter/packages`][] repository.
* **Style-neutral core**:
  Decoupling lays the groundwork for a style-neutral Flutter core widget
  catalog, making it easier to build and maintain custom design systems.

Contributions to Material and Cupertino packages inside the core SDK
were frozen starting in Flutter 3.44.
The initial 1.0.0 versions of `package:material_ui` and `package:cupertino_ui`
match the frozen framework code to provide a seamless transition.
Future releases of the packages will use semantic versioning for major, minor,
and patch updates.
The in-framework design libraries are scheduled for formal deprecation
in an upcoming stable release.

## Migration guide

To migrate your project from the in-framework design libraries to the
standalone packages, you can use the automated `dart fix` tool
or perform the migration manually.

### Automated migration with dart fix

The quickest way to migrate is using the `migrate_design_widgets` fix rule
with `dart fix`:
=======
## Summary

The Material and Cupertino design libraries are now available as
standalone packages: [`package:material_ui`][] and [`package:cupertino_ui`][].
Starting in Flutter 3.47, developers could opt in to these packages ahead of
the formal deprecation of the in-framework design libraries in Flutter 3.50.

## Background

Historically, Flutter's Material (`package:flutter/material.dart`)
and Cupertino (`package:flutter/cupertino.dart`) widget libraries
were bundled directly inside the core Flutter SDK.
While this made it easy to get started with pixel-perfect widgets,
bundling design systems inside the core framework presented several challenges:

* Widget updates, bug fixes, and new components were tied to
  quarterly Flutter SDK releases.
* Contributions and iteration on design libraries moved slower
  than standalone Dart packages.
* Applications couldn't update design libraries independently of
  the engine and framework.

To resolve these challenges, the design systems are now decoupled
from the core framework.
Starting in Flutter 3.47, version 1.0 of the standalone
`material_ui` and `cupertino_ui` packages is published on `pub.dev`.

Decoupling the design systems provides several benefits:

* **Independent release cycles**:
  The packages can ship bug fixes, improvements, and new components
  on their own release schedules (planned for weekly releases),
  without requiring a full Flutter SDK upgrade.
* **Faster contributions**:
  Community members can contribute directly to the libraries in the
  [`flutter/packages`][] repository.
* **Style-neutral core**:
  Decoupling lays the groundwork for a style-neutral Flutter core widget
  catalog, making it easier to build and maintain custom design systems.

Contributions to Material and Cupertino packages inside the core SDK
were frozen starting in Flutter 3.44.
The initial 1.0.0 versions of `package:material_ui` and `package:cupertino_ui`
match the frozen framework code to provide a seamless transition.
Future releases of the packages will use semantic versioning for major, minor,
and patch updates.
The in-framework design libraries are formally deprecated in Flutter 3.50.

## Migration guide

To migrate your project from the in-framework design libraries to the
standalone packages, you can use the automated `dart fix` tool
or perform the migration manually.

### Automated migration with dart fix

The quickest way to migrate is using the `migrate_design_widgets` fix rule
with `dart fix`:
>>>>>>> new_en

```console
$ dart fix --apply --code=migrate_design_widgets
```

Esse comando atualiza automaticamente os seus imports de
`package:flutter/material.dart` e `package:flutter/cupertino.dart`
para os imports dos pacotes independentes correspondentes.

:::note
Se o `dart fix` não adicionar automaticamente os novos pacotes às
dependências do seu `pubspec.yaml`, adicione-os manualmente executando
`flutter pub add material_ui` ou `flutter pub add cupertino_ui`, conforme necessário.
:::

Execute o `dart fix` mais uma vez para garantir que todas as outras migrações
automatizadas sejam aplicadas e que os avisos do linter, como a ordenação
dos imports, sejam resolvidos.

### Migração manual {:#manual-migration}

Para migrar manualmente, siga estes passos:

1.  Adicione os pacotes independentes às dependências do seu `pubspec.yaml`:

    ```console
    $ flutter pub add material_ui
    $ flutter pub add cupertino_ui
    ```

1.  Atualize os imports nos seus arquivos Dart para referenciar os novos pacotes.

    Código antes da migração:

    ```dart
    import 'package:flutter/cupertino.dart';
    import 'package:flutter/material.dart';
    ```

    Código após a migração:

    ```dart
    import 'package:cupertino_ui/cupertino_ui.dart';
    import 'package:material_ui/material_ui.dart';
    ```

### Ponte de compatibilidade {:#compatibility-bridge}

Durante a transição do ecossistema, o seu app pode depender de pacotes de terceiros
que ainda importam as bibliotecas legadas do framework
(`package:flutter/material.dart` ou `package:flutter/cupertino.dart`).

Para que o seu app migre imediatamente para os pacotes independentes, sem esperar
que todas as dependências sejam atualizadas, `material_ui` e `cupertino_ui`
oferecem utilitários de ponte de compatibilidade.
Envolva o seu app usando `MaterialUiCompatibilityBridge` dentro de
`MaterialApp.builder`:

```dart
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
        ),
      ),
      builder: (BuildContext context, Widget? child) {
        return MaterialUiCompatibilityBridge(child: child!);
      },
      home: const HomeScreen(),
    );
  }
}
```

#### Recursos e limitações da ponte {:#bridge-capabilities-and-limitations}

`MaterialUiCompatibilityBridge` injeta dados de tema e de localização
para baixo na árvore de widgets.
Isso permite que widgets filhos não migrados e dependências que leem o estado
de design a partir do contexto
(como `Theme.of(context)` ou `MaterialLocalizations.of(context)`)
continuem funcionando corretamente.

No entanto, a ponte de compatibilidade não consegue resolver incompatibilidades de tipos
quando uma dependência expõe, aceita ou retorna tipos do SDK do framework
em suas assinaturas públicas de API (por exemplo, ao passar um
`FloatingActionButtonLocation`, `ColorScheme` ou `TextTheme` como parâmetro
ou valor de retorno de callback).
Como o Dart impõe tipagem estática entre imports de pacotes distintos,
valores de `package:flutter/material.dart` não podem ser atribuídos a parâmetros
que esperam tipos de `package:material_ui`.
Dependências com acoplamento na assinatura da API devem ser migradas para o
pacote independente antes que o seu app possa passar tipos modernos para elas.

### Localizações desacopladas {:#decoupled-localizations}

Como parte dessa transição, o `flutter_localizations` deixou de ser incluído
para os componentes de design.
Os delegates de localização e as strings traduzidas para os widgets Material e Cupertino
agora ficam diretamente em `package:material_ui` e `package:cupertino_ui`.

Código antes da migração:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// ...
MaterialApp(
  localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
    GlobalCupertinoLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  // ...
);
```

Código após a migração:

```dart
import 'package:material_ui/material_ui.dart';

// ...
MaterialApp(
  localizationsDelegates: GlobalMaterialLocalizations.delegates,
  // ...
);
```

Definir `localizationsDelegates` como `GlobalMaterialLocalizations.delegates`
inclui automaticamente também os delegates de Cupertino e de Widgets,
simplificando a configuração de localização.

### Orientações para autores de pacotes {:#guidance-for-package-authors}

Se você mantém um pacote de código aberto ou um plugin no ecossistema Flutter,
migrar para `package:material_ui` ou `package:cupertino_ui` introduz
uma quebra de compatibilidade para os consumidores que não atualizaram suas dependências.
Embora os símbolos e os nomes das classes permaneçam os mesmos,
eles passam a ser referenciados a partir de uma biblioteca totalmente nova.
Trate essa migração como um incremento de versão principal do seu pacote.

<<<<<<< pt
## Referências {:#references}
||||||| base_en
## References
=======
## Timeline

Landed in version: 3.49.0-1.0.pre-295<br>
In stable release: 3.50

## References
>>>>>>> new_en

Documentação do pacote:

* [`package:material_ui`][`package:material_ui`]
* [`package:cupertino_ui`][`package:cupertino_ui`]

Issues relevantes:

* [Issue 191448][Issue 191448]

<<<<<<< pt
Posts do blog e anúncios relevantes:
||||||| base_en
Relevant blog posts and announcements:
=======
Relevant PRs:

* [PR 192957][]

Relevant blog posts and announcements:
>>>>>>> new_en

* [O que há de novo no Flutter 3.47][What's new in Flutter 3.47]
* [O congelamento de código do Material e do Cupertino no Flutter][Flutter's Material and Cupertino code freeze]

Related changes in `package:material_ui`:

* [Added enabled to DropdownButtonFormField and made onChanged optional][]

[Added enabled to DropdownButtonFormField and made onChanged optional]: /release/breaking-changes/dropdownbuttonformfield-enabled-parameter
[`flutter/packages`]: {{site.repo.packages}}
[Issue 191448]: {{site.repo.flutter}}/issues/191448
[PR 192957]: {{site.repo.flutter}}/pull/192957
[`package:cupertino_ui`]: {{site.pub-pkg}}/cupertino_ui
[`package:material_ui`]: {{site.pub-pkg}}/material_ui
[Flutter's Material and Cupertino code freeze]: {{site.main-url}}/blog/flutters-material-and-cupertino-code-freeze
[What's new in Flutter 3.47]: {{site.main-url}}/blog/whats-new-in-flutter-3-47
