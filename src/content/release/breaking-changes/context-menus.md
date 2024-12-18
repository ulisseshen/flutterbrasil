---
ia-translate: true
title: Uma nova forma de personalizar menus de contexto
description: >
  Vários parâmetros hard-coded para personalizar menus de contexto foram agora
  substituídos por um construtor de widget genérico.
---

## Resumo

Menus de contexto, ou barras de ferramentas de seleção de texto, são os menus que
aparecem quando se pressiona longamente ou clica com o botão direito do mouse em
um texto no Flutter, e exibem opções como **Recortar**, **Copiar**, **Colar** e
**Selecionar tudo**. Anteriormente, era possível personalizá-los de forma
restrita usando `ToolbarOptions` e `TextSelectionControls`. Agora, eles foram
tornados componíveis usando widgets, assim como tudo mais no Flutter, e os
parâmetros de configuração específicos foram descontinuados.

## Contexto

Anteriormente, era possível desabilitar botões dos menus de contexto usando
`TextSelectionControls`, mas qualquer personalização além disso exigia a cópia e
edição de centenas de linhas de classes personalizadas no framework. Agora, tudo
isso foi substituído por uma função de construtor simples, `contextMenuBuilder`,
que permite que qualquer widget Flutter seja usado como um menu de contexto.

## Descrição da mudança

Os menus de contexto agora são construídos a partir do parâmetro `contextMenuBuilder`, que foi adicionado a todos os widgets de edição e seleção de texto. Se um não for fornecido, o Flutter simplesmente o define para um padrão que constrói o menu de contexto correto para a plataforma fornecida. Todos esses widgets padrão são expostos aos usuários para reutilização. Personalizar menus de contexto agora consiste em usar `contextMenuBuilder` para retornar qualquer widget que você queira, possivelmente incluindo a reutilização dos widgets de menu de contexto integrados.

Aqui está um exemplo que mostra como adicionar um botão **Enviar email** aos
menus de contexto padrão sempre que um endereço de email é selecionado. O código
completo pode ser encontrado no repositório de exemplos em
[email_button_page.dart]({{site.repo.samples}}/blob/main/experimental/context_menus/lib/email_button_page.dart)
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
            label: 'Enviar email',
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

Um grande número de exemplos de diferentes menus de contexto personalizados está
disponível [no repositório de exemplos]({{site.repo.samples}}/tree/main/experimental/context_menus)
no GitHub.

Todos os recursos descontinuados relacionados foram sinalizados com o aviso de
descontinuação "Use `contextMenuBuilder` em vez disso."

## Guia de migração

Em geral, quaisquer mudanças anteriores nos menus de contexto que foram
descontinuadas agora exigem o uso do parâmetro `contextMenuBuilder` no widget de
edição de texto ou seleção de texto relevante (
[em `TextField`]({{site.api}}/flutter/material/TextField/contextMenuBuilder.html),
por exemplo). Retorne um widget de menu de contexto integrado como
[`AdaptiveTextSelectionToolbar`]({{site.api}}/flutter/material/AdaptiveTextSelectionToolbar-class.html)
para usar os menus de contexto integrados do Flutter, ou retorne seu próprio
widget para algo totalmente personalizado.

Para fazer a transição para `contextMenuBuilder`, os seguintes parâmetros e
classes foram descontinuados.

### [`ToolbarOptions`]({{site.api}}/flutter/widgets/ToolbarOptions-class.html)

Essa classe era usada anteriormente para habilitar ou desabilitar explicitamente
certos botões em um menu de contexto. Antes dessa mudança, você poderia tê-la
passado para `TextField` ou outros widgets assim:

```dart
// Descontinuado.
TextField(
  toolbarOptions: ToolbarOptions(
    copy: true,
  ),
)
```

Agora, você pode obter o mesmo efeito ajustando os `buttonItems` passados para
`AdaptiveTextSelectionToolbar`. Por exemplo, você pode garantir que o botão
**Recortar** nunca apareça, mas os outros botões apareçam como de costume:

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

Ou, você pode garantir que o botão **Recortar** apareça exclusivamente e sempre:

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

### [`TextSelectionControls.canCut`]({{site.api}}/flutter/widgets/TextSelectionControls/canCut.html) e outros booleanos de botões

Esses booleanos anteriormente tinham o mesmo efeito de habilitar e desabilitar
certos botões como `ToolbarOptions.cut` e assim por diante. Antes dessa
mudança, você poderia estar ocultando e mostrando botões substituindo
`TextSelectionControls` e definindo esses booleanos assim:

```dart
// Descontinuado.
class _MyMaterialTextSelectionControls extends MaterialTextSelectionControls {
  @override
  bool canCut() => false,
}
```

Consulte a seção anterior sobre `ToolbarOptions` para saber como obter um efeito
semelhante com `contextMenuBuilder`.

### [`TextSelectionControls.handleCut`]({{site.api}}/flutter/widgets/TextSelectionControls/handleCut.html) e outros callbacks de botões

Essas funções permitiam a modificação do callback chamado quando os botões eram
pressionados. Antes dessa mudança, você poderia estar modificando os callbacks
dos botões do menu de contexto substituindo esses métodos de manipulador assim:

```dart
// Descontinuado.
class _MyMaterialTextSelectionControls extends MaterialTextSelectionControls {
  @override
  bool handleCut() {
    // Minha implementação de recortar personalizada aqui.
  },
}
```

Isso ainda é possível usando `contextMenuBuilder`, incluindo o envio para as
ações dos botões originais no manipulador personalizado, usando widgets de barra
de ferramentas como `AdaptiveTextSelectionToolbar.buttonItems`.

Este exemplo mostra a modificação do botão **Copiar** para exibir um diálogo
além de fazer sua lógica de cópia usual.

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
                  title: Text('Copiado, mas também mostrou este diálogo.'),
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

Um exemplo completo de modificação de uma ação de menu de contexto integrada pode
ser encontrado no repositório de exemplos em
[modified_action_page.dart]({{site.repo.samples}}/blob/main/experimental/context_menus/lib/modified_action_page.dart)
no GitHub.

### [`buildToolbar`]({{site.api}}/flutter/widgets/TextSelectionControls/buildToolbar.html)

Essa função gerava o widget de menu de contexto de forma semelhante a
`contextMenuBuilder`, mas exigia mais configuração para ser usada. Antes dessa
mudança, você poderia estar substituindo `buildToolbar` como parte de
`TextSelectionControls`, assim:

```dart
// Descontinuado.
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

Agora você pode simplesmente usar `contextMenuBuilder` diretamente como um
parâmetro para `TextField` (e outros). As informações fornecidas nos parâmetros
para `buildToolbar` podem ser obtidas do `EditableTextState` que é passado para
`contextMenuBuilder`.

O exemplo a seguir mostra como construir uma barra de ferramentas totalmente
personalizada do zero, ainda usando os botões padrão.

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

Um exemplo completo de construção de um menu de contexto personalizado pode ser
encontrado no repositório de exemplos em
[`custom_menu_page.dart`]({{site.repo.samples}}/blob/main/experimental/context_menus/lib/custom_menu_page.dart)
no GitHub.

## Cronograma

Implementado na versão: 3.6.0-0.0.pre<br>
Na versão estável: 3.7.0

## Referências

Documentação da API:

*   [`TextField.contextMenuBuilder`]({{site.api}}/flutter/material/TextField/contextMenuBuilder.html)
*   [`AdaptiveTextSelectionToolbar`]({{site.api}}/flutter/material/AdaptiveTextSelectionToolbar-class.html)

Issues relevantes:

*   [Barras de ferramentas de seleção de texto personalizadas simples]({{site.repo.flutter}}/issues/73574)
*   [Menu do clique direito fora dos campos de texto]({{site.repo.flutter}}/issues/98272)
*   [Edição de texto para desktop - estável]({{site.repo.flutter}}/issues/90563)
*   [Capacidade de desabilitar o menu de contexto em TextFields]({{site.repo.flutter}}/issues/79796)
*   [APIs ausentes para o estilo da barra de ferramentas de seleção de texto]({{site.repo.flutter}}/issues/22210)
*   [Habilitar a barra de ferramentas de cópia em todos os widgets]({{site.repo.flutter}}/issues/49996)
*   [Desabilitar o menu de contexto do navegador]({{site.repo.flutter}}/issues/78671)
*   [Menus de contexto personalizados não aparecem para o Flutter web]({{site.repo.flutter}}/issues/84219)

PRs relevantes:

*   [ContextMenus]({{site.repo.flutter}}/pull/107193)
*   [Capacidade de desabilitar o menu de contexto do navegador na web]({{site.repo.flutter}}/pull/118194)
*   [Capacidade de desabilitar o menu de contexto do navegador na web (engine)]({{site.repo.engine}}/pull/38682)
*   [Menus de contexto personalizados em SelectableRegion na web]({{site.repo.flutter}}/pull/121653)
