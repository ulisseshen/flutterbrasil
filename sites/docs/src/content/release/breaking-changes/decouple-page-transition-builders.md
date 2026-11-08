---
ia-translate: true
title: Reorganização dos builders de transição de página
description: >-
  CupertinoPageTransitionsBuilder foi movido da
  biblioteca Material para a biblioteca Cupertino, onde pertence.
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

`CupertinoPageTransitionsBuilder` foi realocado de
`package:material_ui/material_ui.dart` para o pacote Cupertino,
que agora está em `package:cupertino_ui/cupertino_ui.dart`.

## Contexto {:#background}

O Flutter oferece vários builders de transição de página que
controlam como as rotas são animadas ao navegar entre páginas.
Esses builders são usados com `PageTransitionsTheme` para
personalizar as transições por plataforma.

Os builders de transição de página disponíveis são:

| Builder | Biblioteca | Descrição |
|---------|---------|-------------|
| `FadeUpwardsPageTransitionsBuilder` | Material | Transição padrão antes do Material 3 |
| `OpenUpwardsPageTransitionsBuilder` | Material | Transição de deslize vertical |
| `ZoomPageTransitionsBuilder` | Material | Transição de zoom (padrão do Material 3) |
| `PredictiveBackPageTransitionsBuilder` | Material | Suporte ao gesto de voltar preditivo do Android |
| `CupertinoPageTransitionsBuilder` | **Cupertino** | Transição de deslize horizontal estilo iOS |

{:.table}

Anteriormente, `CupertinoPageTransitionsBuilder` era definido na
biblioteca Material, junto com os outros builders.
Essa classe é semanticamente um componente Cupertino porque
sua implementação usa mixins de transição Cupertino e
oferece animações de navegação no estilo iOS.

Essa mudança melhora a organização do código e permite que apps Cupertino usem
esse builder sem depender da biblioteca Material.

## Guia de migração {:#migration-guide}

Se você usa `CupertinoPageTransitionsBuilder` e
importa apenas `package:material_ui/material_ui.dart`,
adicione um import para `package:cupertino_ui/cupertino_ui.dart`.

Código antes da migração:

```dart
import 'package:material_ui/material_ui.dart';

final pageTransitionsTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  },
);
```

Código após a migração:

```dart
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

final pageTransitionsTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  },
);
```

Se o seu app já importa os dois pacotes, nenhuma alteração é necessária.

## Linha do tempo {:#timeline}

Incluído na versão: 3.43.0-0.1.pre<br>
Na versão estável: 3.44

## Referências {:#references}

PRs relevantes:

* [Decouple CupertinoPageTransitionsBuilder from Material][pr-179776]

[pr-179776]: {{site.repo.flutter}}/pull/179776
