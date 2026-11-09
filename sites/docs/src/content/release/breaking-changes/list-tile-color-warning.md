---
ia-translate: true
title: ListTile reporta um erro em debug quando envolvido por um widget colorido
description: >-
  ListTile agora reporta um erro em modo debug quando é envolvido por
  um widget intermediário com uma cor de fundo não transparente.
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Quando um widget com cor de fundo não transparente,
como um `Container` ou `ColoredBox` que define `color`,
fica entre um `ListTile` e o seu ancestral `Material` mais próximo,
o framework agora reporta um erro.

## Contexto {:#background}

O `ListTile` pinta a sua cor de fundo e os efeitos de respingo (ink splash)
no ancestral `Material` mais próximo.
Quando um widget com cor de fundo opaca é
colocado entre o `ListTile` e o seu ancestral `Material`,
ele oculta esses efeitos visuais,
tornando-os invisíveis para o usuário.

Para evitar que você introduza esse bug sem querer e fique se perguntando por que
o fundo ou os efeitos de respingo do `ListTile` não aparecem,
o framework agora reporta um erro de asserção durante o desenvolvimento.

Se o seu código tem um widget colorido intermediário
entre um `ListTile` e um widget `Material`,
você verá agora um erro parecido com este:

```text
ListTile background color or ink splashes may be invisible.
The ListTile is wrapped in a Container that has a background color.
Because ListTile paints its background and ink splashes on
the nearest Material ancestor, this Container will hide those effects.
To fix this, wrap the ListTile in its own Material widget, or
remove the background color from the intermediate Container.
```

## Guia de migração {:#migration-guide}

Para corrigir o erro,
remova a cor de fundo do widget intermediário ou
envolva o `ListTile` em seu próprio widget `Material`.

Código antes da migração:

```dart
// The colored Container hides the ink splashes from the ListTile.
Material(
  child: Container(
    color: Colors.pink,
    child: ListTile(
      title: const Text('Title'),
      onTap: () {},
    ),
  ),
)
```

Código após a migração:

```dart
// Use a Material widget directly for the background color.
Material(
  color: Colors.pink,
  child: Container(
    child: ListTile(
      title: const Text('Title'),
      onTap: () {},
    ),
  ),
)
```

Alternativamente,
envolva o `ListTile` em seu próprio widget `Material`:

```dart
Container(
  color: Colors.blue,
  child: Material(
    type: MaterialType.transparency,
    child: ListTile(
      title: const Text('Title'),
      onTap: () {},
    ),
  ),
)
```

## Linha do tempo {:#timeline}

Incluído na versão: 3.43.0-0.1.pre<br>
Na versão estável: 3.44

## Referências {:#references}

Documentação da API:

* [`ListTile`][]
* [`Material`][]

Issues relevantes:

* [`ListTile.selectedTileColor` not visible when parent `Container` has explicit background color][issue-174366]

PRs relevantes:

* [Add warning when there is a widget with color between `Material` and `ListTile`][pr-181402]

[`ListTile`]: {{site.material_ui}}/ListTile-class.html
[`Material`]: {{site.material_ui}}/Material-class.html
[issue-174366]: {{site.repo.flutter}}/issues/174366
[pr-181402]: {{site.repo.flutter}}/pull/181402
