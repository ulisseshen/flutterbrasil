---
title: Descontinuação do ExpansionTileController
description: >
  `ExpansionTileController` foi descontinuado e substituído por
  `ExpansibleController`.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

`ExpansionTileController` foi descontinuado. A mesma funcionalidade pode ser
alcançada usando `ExpansibleController` em seu lugar.

## Contexto {:#background}

`ExpansionTileController` expande e colapsa programaticamente um `ExpansionTile`. Um novo widget `Expansible` foi adicionado à biblioteca de widgets, que contém a lógica para o comportamento de expandir e colapsar sem estar vinculado à biblioteca Material. `ExpansibleController` complementa `Expansible` e tem a mesma funcionalidade que `ExpansionTileController`. Além disso, `ExpansibleController` também suporta adicionar e notificar ouvintes quando seu estado de expansão muda.

Apps que usam `ExpansionTileController` exibem o seguinte erro quando executados
no modo debug: "Use `ExpansibleController` instead.". Especificamente, isso significa que os usuários devem substituir o uso de `ExpansionTileController` por `ExpansibleController`.

## Guia de migração {:#migration-guide}

Para migrar, substitua o parâmetro `controller` de um `ExpansionTile` de um `ExpansionTileController` para um `ExpansibleController`. Diferentemente de `ExpansionTileController`, `ExpansibleController` é um `ChangeNotifier`, então lembre-se de descartar o novo `ExpansibleController`.

Código antes da migração:

```dart
class _MyWidgetState extends State<MyWidget> {
  final ExpansionTileController controller = ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      controller: controller,
    );
  }
}
```

Código após a migração:

```dart
class _MyWidgetState extends State<MyWidget> {
  final ExpansibleController controller = ExpansibleController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      controller: controller,
    );
  }
}
```

## Cronograma {:#timeline}

Implementado na versão: 3.31.0-0.1.pre<br>
Na versão estável: 3.32

## Referências {:#references}

Documentação da API:

* [`ExpansionTileController`][]
* [`ExpansibleController`][]
* [`ExpansionTile.controller`][]
* [`Expansible.controller`][]

Issues relevantes:

* [Codeshare between ExpansionTile and its Cupertino variant][]
* [Deprecate ExpansionTileController in favor of ExpansibleController][]

PRs relevantes:

* [Introduce Expansible, a base widget for ExpansionTile][]
* [Deprecate ExpansionTileController][]

[`ExpansionTileController`]: {{site.api}}/flutter/material/ExpansionTileController-class.html
[`ExpansibleController`]: {{site.api}}/flutter/widgets/ExpansibleController-class.html
[`ExpansionTile.controller`]: {{site.api}}/flutter/material/ExpansionTile/controller.html
[`Expansible.controller`]: {{site.api}}/flutter/widgets/Expansible/controller.html

[Codeshare between ExpansionTile and its Cupertino variant]: {{site.repo.flutter}}/issues/163552
[Deprecate ExpansionTileController in favor of ExpansibleController]: {{site.repo.flutter}}/issues/165511
[Introduce Expansible, a base widget for ExpansionTile]: {{site.repo.flutter}}/pull/164049
[Deprecate ExpansionTileController]: {{site.repo.flutter}}/pull/166368
