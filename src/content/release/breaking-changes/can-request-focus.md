---
title: TextField.canRequestFocus descontinuado
description: >-
  O parâmetro canRequestFocus de TextField está descontinuado e substituído pelo
  parâmetro canRequestFocus de seu FocusNode.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

`TextField.canRequestFocus` está descontinuado.
A mesma funcionalidade pode ser alcançada definindo o
parâmetro `canRequestFocus` do `FocusNode` do `TextField`.

## Background

`TextField.canRequestFocus` foi adicionado para suportar `DropdownMenu`, que
tem um `TextField` que às vezes não é interativo. No entanto, a mesma
funcionalidade pode ser alcançada definindo o parâmetro `canRequestFocus` de um
`FocusNode` do `TextField`. `DropdownMenu` foi migrado para esta abordagem,
e outros casos de uso devem seguir o mesmo padrão.

Apps que usam `TextField.canRequestFocus` exibem o seguinte erro quando executados
em modo debug: "Use `focusNode` instead.". Especificamente, isso significa que os usuários
devem passar um `FocusNode` para `TextField.focusNode` com o
parâmetro `FocusNode.canRequestFocus` definido.

## Migration guide

Para migrar, remova o parâmetro `TextField.canRequestFocus`. Crie um
`FocusNode` com o parâmetro `FocusNode.canRequestFocus` definido para o valor
desejado, e passe-o para `TextField.focusNode`.

Código antes da migração:

```dart
class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      canRequestFocus: false,
    );
  }
}
```

Código após a migração:

```dart
class _MyWidgetState extends State<MyWidget> {
  final FocusNode _focusNode = FocusNode(canRequestFocus: false);

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
    );
  }
}
```

## Timeline

Adicionado na versão: Revertido, aguardando relançamento<br>
Na versão estável: Ainda não

## References

Documentação da API:

* [`DropdownMenu`][]
* [`FocusNode.canRequestFocus`][]
* [`TextField.canRequestFocus`][]
* [`TextField.focusNode`][]

Issues relevantes:

* [Broken selection on TextField if canRequestFocus: false][]
* [DropdownMenu Disable text input][]

PRs relevantes:

* [Add requestFocusOnTap to DropdownMenu][]
* [Replace TextField.canRequestFocus with TextField.focusNode.canRequestFocus][]

[`DropdownMenu`]: {{site.api}}/flutter/material/DropdownMenu-class.html
[`FocusNode.canRequestFocus`]: {{site.api}}/flutter/widgets/FocusNode/canRequestFocus.html
[`TextField.canRequestFocus`]: {{site.api}}/flutter/material/TextField/canRequestFocus.html
[`TextField.focusNode`]: {{site.api}}/flutter/material/TextField/focusNode.html

[Broken selection on TextField if canRequestFocus: false]: {{site.repo.flutter}}/issues/130011
[DropdownMenu Disable text input]: {{site.repo.flutter}}/issues/116587
[Replace TextField.canRequestFocus with TextField.focusNode.canRequestFocus]: {{site.repo.flutter}}/pull/130164
[Add requestFocusOnTap to DropdownMenu]: {{site.repo.flutter}}/pull/117504
