---
title: SystemContextMenuController.show descontinuado
description: >-
  O método `show` de `SystemContextMenuController` está descontinuado e substituído por
  seu método `showWithItems`.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

`SystemContextMenuController.show` está descontinuado. A mesma funcionalidade pode ser
alcançada passando o resultado de chamar `SystemContextMenu.getDefaultItems` para
`SystemContextMenuController.showWithItems`.

## Background

O recurso `SystemContextMenu` desenhado pelo iOS foi originalmente adicionado sem a
capacidade de controlar quais itens são mostrados no menu. A plataforma decidia
quais itens mostrar baseado na `TextInputConnection` ativa.

O problema com esta abordagem é que um botão "Autofill" é frequentemente mostrado, mas
Flutter não tem a capacidade de responder a este botão. Então em muitos casos,
usuários veem um botão "Autofill" que não faz nada quando tocado, e desenvolvedores de aplicações
Flutter não têm como esconder o botão.

Este problema é resolvido introduzindo um novo método,
`SystemContextMenuController.showWithItems`, que requer uma lista de `items` para
ser passada.

Desenvolvedores que não têm preferência sobre quais itens são mostrados podem chamar o novo método
`SystemContextMenu.getDefaultItems` para obter os itens padrão baseados no
`EditableTextState` fornecido. Por exemplo, se o `EditableTextState` indica que
não há nada selecionado, então o botão **Copy** não será incluído, já que ele
requer uma seleção para copiar.

## Migration guide

A maioria dos usuários usa o menu de contexto do sistema através do widget `SystemContextMenu`,
e neste caso não haverá mudança necessária. O widget `SystemContextMenu`
obtém automaticamente os itens padrão internamente.

Nenhuma migração é necessária:

```dart
class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    TextField(
      contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
        return SystemContextMenu.editableText(
          editableTextState: editableTextState,
        );
      }
    );
  }
}
```

Para usuários avançados que trabalham diretamente com `SystemContextMenuController`,
migre para o novo método `SystemContextMenuController.showWithItems`. O
padrão pode ser obtido de `SystemContextMenu.getDefaultItems` como uma lista de
`IOSSystemContextMenuItem`s, que podem ser convertidos para o formato requerido por
`showWithItems` através de `IOSSystemContextMenuItem.getData`.

Code before migration:

```dart
_controller.show(selectionRect);
```

Code after migration:

```dart
final List<IOSSystemContextMenuItem> defaultItems =
    SystemContextMenu.getDefaultItems(editableTextState);
final WidgetsLocalizations localizations =
    WidgetsLocalizations.of(context);
final List<IOSSystemContextMenuItemData> defaultItemDatas =
    defaultItems
        .map((IOSSystemContextMenuItem item) =>
            item.getData(localizations))
        .toList();
_controller.showWithItems(selectionRect, defaultItemDatas);
```

## Timeline

Landed in version: 3.29.0-0.3.pre<br>
In stable release: 3.32

## References

API documentation:

* [`TextInputConnection`][]
* [`SystemContextMenuController.show`][]
* [`SystemContextMenuController.showWithItems`][]
* [`SystemContextMenu`][]

Relevant issues:

* [Flutter should support iOS 15's Secure Paste feature][]

Relevant PRs:

* [Secure paste milestone 2][]
* [ios secure_paste show menu item based on info sent from framework][]
* [Native ios context menu][]
* [ios_edit_menu add native edit menu][]

[`TextInputConnection`]: {{site.api}}/flutter/services/TextInputConnection-class.html
[`SystemContextMenuController.show`]: {{site.api}}/flutter/services/SystemContextMenuController/show.html
[`SystemContextMenuController.showWithItems`]: {{site.api}}/flutter/services/SystemContextMenuController/showWithItems.html
[`SystemContextMenu`]: {{site.api}}/flutter/services/SystemContextMenu.html

[Secure paste milestone 2]: {{site.repo.flutter}}/pull/159013
[ios secure_paste show menu item based on info sent from framework]: {{site.repo.engine}}/pull/161103
[Native ios context menu]: {{site.repo.flutter}}/pull/143002
[ios_edit_menu add native edit menu]: {{site.repo.flutter}}/pull/50095
[Flutter should support iOS 15's Secure Paste feature]: {{site.repo.flutter}}/issues/103163
