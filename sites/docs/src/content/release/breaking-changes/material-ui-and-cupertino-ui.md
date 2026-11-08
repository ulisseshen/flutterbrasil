---
ia-translate: true
title: Migre para os pacotes independentes material_ui e cupertino_ui
description: >-
  As bibliotecas de design Material e Cupertino agora estão disponíveis como
  pacotes independentes, desacoplando os sistemas de design do SDK do Flutter.
---

{% render "docs/breaking-changes.md" %}

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

## Referências {:#references}

Documentação do pacote:

* [`package:material_ui`][`package:material_ui`]
* [`package:cupertino_ui`][`package:cupertino_ui`]

Issues relevantes:

* [Issue 191448][Issue 191448]

Posts do blog e anúncios relevantes:

* [O que há de novo no Flutter 3.47][What's new in Flutter 3.47]
* [O congelamento de código do Material e do Cupertino no Flutter][Flutter's Material and Cupertino code freeze]

[`flutter/packages`]: {{site.repo.packages}}
[Issue 191448]: {{site.repo.flutter}}/issues/191448
[`package:cupertino_ui`]: {{site.pub-pkg}}/cupertino_ui
[`package:material_ui`]: {{site.pub-pkg}}/material_ui
[Flutter's Material and Cupertino code freeze]: {{site.main-url}}/blog/flutters-material-and-cupertino-code-freeze
[What's new in Flutter 3.47]: {{site.main-url}}/blog/whats-new-in-flutter-3-47
