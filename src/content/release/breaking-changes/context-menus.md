---
title: Uma nova maneira de personalizar menus de contexto
description: >
  Vários parâmetros codificados para personalizar menus de contexto
  foram substituídos por um builder de widget genérico.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

Menus de contexto, ou barras de ferramentas de seleção de texto, são os menus que aparecem ao pressionar longamente ou clicar com o botão direito no texto no Flutter, e exibem opções como **Cut**, **Copy**, **Paste** e **Select all**. Anteriormente, era possível personalizá-los de forma limitada usando `ToolbarOptions` e `TextSelectionControls`. Agora, eles foram tornados combináveis usando widgets, assim como tudo no Flutter, e os parâmetros de configuração específicos foram descontinuados.

## Context

Anteriormente, era possível desabilitar botões dos menus de contexto usando `TextSelectionControls`, mas qualquer personalização além disso exigia copiar e editar centenas de linhas de classes personalizadas no framework. Agora, tudo isso foi substituído por uma função builder simples, `contextMenuBuilder`, que permite que qualquer widget Flutter seja usado como menu de contexto.

## Description of change

Os menus de contexto agora são construídos a partir do parâmetro `contextMenuBuilder`, que foi adicionado a todos os widgets de edição de texto e seleção de texto. Se um não for fornecido, o Flutter simplesmente define um padrão que constrói o menu de contexto correto para a plataforma específica. Todos esses widgets padrão são expostos aos usuários para reutilização. Personalizar menus de contexto agora consiste em usar `contextMenuBuilder` para retornar qualquer widget que você deseja, possivelmente incluindo a reutilização dos widgets de menu de contexto integrados.

Aqui está um exemplo que mostra como adicionar um botão **Send email** aos menus de contexto padrão sempre que um endereço de e-mail é selecionado. O código completo pode ser encontrado no repositório de exemplos em
[email_button_page.dart]({{site.repo.samples}}/blob/main/context_menus/lib/email_button_page.dart)
no GitHub.

```dart
TextField(
  contextMenuBuilder: (context, editableTextState) {
    final TextEditingValue value = editableTextState.textEditingValue;
    final List<ContextMenuButtonItem> buttonItems =
        editableTextState.contextMenuButtonItems;
    if (isValidEmail(value.selection.textInside(value.text))) {
      buttonItems.insert(
          0,
          ContextMenuButtonItem(
            label: 'Send email',
            onPressed: () {
              ContextMenuController.removeAny();
              Navigator.of(context).push(_showDialog(context));
            },
          ));
    }
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: editableTextState.contextMenuAnchors,
      buttonItems: buttonItems,
    );
  },
)
```

Um grande número de exemplos de diferentes menus de contexto personalizados estão disponíveis
[no repositório de exemplos]({{site.repo.samples}}/tree/main/context_menus)
no GitHub.

Todos os recursos relacionados descontinuados foram marcados com o aviso de descontinuação "Use
`contextMenuBuilder` instead."

## Migration guide

Em geral, quaisquer alterações anteriores nos menus de contexto que foram descontinuadas agora
requerem o uso do parâmetro `contextMenuBuilder` no widget de edição de texto ou seleção de texto relevante (
[em `TextField`]({{site.api}}/flutter/material/TextField/contextMenuBuilder.html),
por exemplo). Retorne um widget de menu de contexto integrado como
[`AdaptiveTextSelectionToolbar`]({{site.api}}/flutter/material/AdaptiveTextSelectionToolbar-class.html)
para usar os menus de contexto integrados do Flutter, ou retorne seu próprio widget para algo
totalmente personalizado.

Para fazer a transição para `contextMenuBuilder`, os seguintes parâmetros e classes foram
descontinuados.

### [`ToolbarOptions`]({{site.api}}/flutter/widgets/ToolbarOptions-class.html)

Esta classe era anteriormente usada para habilitar ou desabilitar explicitamente certos botões
em um menu de contexto. Antes desta alteração, você poderia tê-la passado para `TextField`
ou outros widgets assim:

```dart
// Deprecated.
TextField(
  toolbarOptions: ToolbarOptions(
    copy: true,
  ),
)
```

Agora, você pode alcançar o mesmo efeito ajustando os `buttonItems` passados para
`AdaptiveTextSelectionToolbar`. Por exemplo, você pode garantir que o botão **Cut**
nunca apareça, mas os outros botões apareçam normalmente:

```dart
TextField(
  contextMenuBuilder: (context, editableTextState) {
    final List<ContextMenuButtonItem> buttonItems =
        editableTextState.contextMenuButtonItems;
    buttonItems.removeWhere((ContextMenuButtonItem buttonItem) {
      return buttonItem.type == ContextMenuButtonType.cut;
    });
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: editableTextState.contextMenuAnchors,
      buttonItems: buttonItems,
    );
  },
)
```

Ou, você pode garantir que o botão **Cut** apareça exclusivamente e sempre:

```dart
TextField(
  contextMenuBuilder: (context, editableTextState) {
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: editableTextState.contextMenuAnchors,
      buttonItems: <ContextMenuButtonItem>[
        ContextMenuButtonItem(
          onPressed: () {
            editableTextState.cutSelection(SelectionChangedCause.toolbar);
          },
          type: ContextMenuButtonType.cut,
        ),
      ],
    );
  },
)
```

### [`TextSelectionControls.canCut`]({{site.api}}/flutter/widgets/TextSelectionControls/canCut.html) e outros booleanos de botão

Estes booleanos tinham anteriormente o mesmo efeito de habilitar e desabilitar certos
botões como `ToolbarOptions.cut`, e assim por diante. Antes desta alteração, você poderia
estar ocultando e exibindo botões sobrescrevendo `TextSelectionControls` e
definindo esses booleanos assim:

```dart
// Deprecated.
class _MyMaterialTextSelectionControls extends MaterialTextSelectionControls {
  @override
  bool canCut() => false,
}
```

Veja a seção anterior sobre `ToolbarOptions` para saber como alcançar um efeito similar
com `contextMenuBuilder`.

### [`TextSelectionControls.handleCut`]({{site.api}}/flutter/widgets/TextSelectionControls/handleCut.html) e outros callbacks de botão

Essas funções permitiam a modificação do callback chamado quando os botões
eram pressionados. Antes desta alteração, você poderia estar modificando callbacks de botões do menu de contexto sobrescrevendo esses métodos handler assim:

```dart
// Deprecated.
class _MyMaterialTextSelectionControls extends MaterialTextSelectionControls {
  @override
  bool handleCut() {
    // My custom cut implementation here.
  },
}
```

Isso ainda é possível usando `contextMenuBuilder`, incluindo chamar
as ações dos botões originais no handler personalizado, usando widgets de barra de ferramentas como `AdaptiveTextSelectionToolbar.buttonItems`.

Este exemplo mostra a modificação do botão **Copy** para exibir um diálogo além de
realizar sua lógica de cópia usual.

```dart
TextField(
  contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
    final List<ContextMenuButtonItem> buttonItems =
        editableTextState.contextMenuButtonItems;
    final int copyButtonIndex = buttonItems.indexWhere(
      (ContextMenuButtonItem buttonItem) {
        return buttonItem.type == ContextMenuButtonType.copy;
      },
    );
    if (copyButtonIndex >= 0) {
      final ContextMenuButtonItem copyButtonItem =
          buttonItems[copyButtonIndex];
      buttonItems[copyButtonIndex] = copyButtonItem.copyWith(
        onPressed: () {
          copyButtonItem.onPressed();
          Navigator.of(context).push(
            DialogRoute<void>(
              context: context,
              builder: (BuildContext context) =>
                const AlertDialog(
                  title: Text('Copied, but also showed this dialog.'),
                ),
            );
          )
        },
      );
    }
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: editableTextState.contextMenuAnchors,
      buttonItems: buttonItems,
    );
  },
)
```

Um exemplo completo de modificação de uma ação de menu de contexto integrado pode ser encontrado no repositório de exemplos em
[modified_action_page.dart]({{site.repo.samples}}/blob/main/context_menus/lib/modified_action_page.dart)
no GitHub.

### [`buildToolbar`]({{site.api}}/flutter/widgets/TextSelectionControls/buildToolbar.html)

Esta função gerava o widget de menu de contexto de forma similar ao
`contextMenuBuilder`, mas exigia mais configuração para usar. Antes desta alteração, você
poderia estar sobrescrevendo `buildToolbar` como parte de `TextSelectionControls`,
assim:

```dart
// Deprecated.
class _MyMaterialTextSelectionControls extends MaterialTextSelectionControls {
  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset selectionMidpoint,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ClipboardStatusNotifier clipboardStatus,
    Offset lastSecondaryTapDownPosition,
  ) {
    return _MyCustomToolbar();
  },
}
```

Agora você pode simplesmente usar `contextMenuBuilder` diretamente como parâmetro para
`TextField` (e outros). As informações fornecidas nos parâmetros para
`buildToolbar` podem ser obtidas do `EditableTextState` que é passado para
`contextMenuBuilder`.

O exemplo a seguir mostra como construir uma barra de ferramentas totalmente personalizada do zero
enquanto ainda usa os botões padrão.

```dart
class _MyContextMenu extends StatelessWidget {
  const _MyContextMenu({
    required this.anchor,
    required this.children,
  });

  final Offset anchor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: anchor.dy,
          left: anchor.dx,
          child: Container(
            width: 200,
            height: 200,
            color: Colors.amberAccent,
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}

class _MyTextField extends StatelessWidget {
  const _MyTextField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      maxLines: 4,
      minLines: 2,
      contextMenuBuilder: (context, editableTextState) {
        return _MyContextMenu(
          anchor: editableTextState.contextMenuAnchors.primaryAnchor,
          children: AdaptiveTextSelectionToolbar.getAdaptiveButtons(
            context,
            editableTextState.contextMenuButtonItems,
          ).toList(),
        );
      },
    );
  }
}
```

Um exemplo completo de construção de um menu de contexto personalizado pode ser encontrado no repositório de exemplos em
[`custom_menu_page.dart`]({{site.repo.samples}}/blob/main/context_menus/lib/custom_menu_page.dart)
no GitHub.

## Timeline

Landed in version: 3.6.0-0.0.pre<br>
In stable release: 3.7.0

## References

API documentation:

* [`TextField.contextMenuBuilder`]({{site.api}}/flutter/material/TextField/contextMenuBuilder.html)
* [`AdaptiveTextSelectionToolbar`]({{site.api}}/flutter/material/AdaptiveTextSelectionToolbar-class.html)

Relevant issues:

* [Simple custom text selection toolbars]({{site.repo.flutter}}/issues/73574)
* [Right click menu outside of text fields]({{site.repo.flutter}}/issues/98272)
* [Text editing for desktop - stable]({{site.repo.flutter}}/issues/90563)
* [Ability to disable context menu on TextFields]({{site.repo.flutter}}/issues/79796)
* [Missing APIs for text selection toolbar styling]({{site.repo.flutter}}/issues/22210)
* [Enable copy toolbar in all widgets]({{site.repo.flutter}}/issues/49996)
* [Disable context menu from browser]({{site.repo.flutter}}/issues/78671)
* [Custom context menus don't show up for Flutter web]({{site.repo.flutter}}/issues/84219)

Relevant PRs:

* [ContextMenus]({{site.repo.flutter}}/pull/107193)
* [Ability to disable the browser's context menu on web]({{site.repo.flutter}}/pull/118194)
* [Ability to disable the browser's context menu on web (engine)]({{site.repo.engine}}/pull/38682)
* [Custom context menus in SelectableRegion on web]({{site.repo.flutter}}/pull/121653)
