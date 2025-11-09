---
ia-translate: true
title: Navegação baseada em pilha
description: Aprenda como navegar de uma página para outra em um app Flutter
permalink: /tutorial/stack-based-navigation/
sitemap: false
---

Agora que você entende slivers e rolagem, você pode implementar
navegação entre telas. Nesta lição, você atualizará a
view de tela pequena de modo que quando um grupo de contatos for tocado, ele
navegue para a lista de contatos daquele grupo.

Primeiro, reverta as mudanças no widget de layout adaptativo para que ele
exiba o ContactGroupsPage por padrão em telas pequenas.

```dart
// lib/screens/adaptive_layout.dart

class _AdaptiveLayoutState extends State<AdaptiveLayout> {
  int selectedListId = 0;

  void _onContactListSelected(int listId) {
    setState(() {
      selectedListId = listId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > largeScreenMinWidth;

        if (isLargeScreen) {
          return _buildLargeScreenLayout();
        } else {
          return const ContactGroupsPage(); // Reverted
        }
      },
    );
  }
}
```

## Adicione navegação aos grupos de contatos

O `ContactGroupsPage` já usa um `_ContactGroupsView`
e fornece a ele um callback. Esse callback precisa ser atualizado para
navegar quando um grupo é tocado, em vez de imprimir o grupo no
console.

Certifique-se de que o callback `onListSelected` em
`lib/screens/contact_groups.dart` está implementado da seguinte forma:

```dart
// lib/screens/contact_groups.dart

class ContactGroupsPage extends StatelessWidget {
  const ContactGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ContactGroupsView(
      onListSelected: (list) => Navigator.of(context).push(
        CupertinoPageRoute(
          title: list.title,
          builder: (context) => ContactListsPage(listId: list.id),
        ),
      ),
    );
  }
}
```

Este pequeno bloco de código contém a informação nova mais importante desta página.

`Navigator.of(context)` recupera o widget `Navigator` mais próximo da
árvore de widgets. O método `push` adiciona uma nova rota à
pilha do navegador, e exibe o widget retornado da propriedade `builder`.

Esta é a implementação mais básica de uso de navegação baseada em pilha,
onde novas telas são empilhadas em cima da tela atual. Para navegar
de volta para a tela anterior, você usaria o método `Navigator.pop`.

`CupertinoPageRoute` cria transições de página no estilo iOS com os seguintes recursos:
- Uma animação de deslizamento da direita.
- Suporte automático de botão de voltar.
- Tratamento adequado de título.
- Suporte a gesto de deslizar-para-voltar.

## Crie o componente de barra lateral para telas grandes

Para telas grandes, você precisa de uma barra lateral que não navegue mas
em vez disso atualize a área de conteúdo principal. Graças à refatoração na
etapa anterior, criar este componente é simples. Adicione este widget
ao final de `lib/screens/contact_groups.dart`:

```dart
// lib/screens/contact_groups.dart

// ...

/// A sidebar component for selecting contact groups, designed for large screens.
class ContactGroupsSidebar extends StatelessWidget {
  const ContactGroupsSidebar({
    super.key,
    required this.selectedListId,
    required this.onListSelected,
  });

  final int selectedListId;
  final Function(int) onListSelected;

  @override
  Widget build(BuildContext context) {
    return _ContactGroupsView(
      selectedListId: selectedListId,
      onListSelected: (list) => onListSelected(list.id),
    );
  }
}
```

Este componente de barra lateral reutiliza o `_ContactGroupsView` e fornece um
callback diferente. Em vez de navegar, ele chama `onListSelected`
com o ID da lista tocada. Ele também passa o `selectedListId` para
`_ContactGroupsView` para que o item selecionado possa ser destacado.

## Crie a view de detalhe para telas grandes

Para o layout de tela grande, você precisa de uma view de detalhe que não mostre
controles de navegação. Assim como a barra lateral, isto é fácil de criar
reutilizando o `_ContactListView`. Adicione este widget ao final do seu
arquivo `contacts.dart`:

```dart
// lib/screens/contacts.dart

// ...

/// A detail view component for showing contacts in a specific list.
class ContactListDetail extends StatelessWidget {
  const ContactListDetail({super.key, required this.listId});

  final int listId;

  @override
  Widget build(BuildContext context) {
    return _ContactListView(
      listId: listId,
      automaticallyImplyLeading: false,
    );
  }
}
```

A view de detalhe reutiliza `_ContactListView` e define
`automaticallyImplyLeading: false` para esconder o botão de voltar, já que
a navegação é tratada pela barra lateral.

## Conecte a barra lateral ao layout adaptativo

Agora, conecte a barra lateral ao seu layout adaptativo. Atualize seu
`adaptive_layout.dart` para importar os arquivos necessários e atualizar o
layout de tela grande:

```dart
// lib/screens/adaptive_layout.dart
import 'package:flutter/cupertino.dart';
import 'package:rolodex/screens/contact_groups.dart';
import 'package:rolodex/screens/contacts.dart';
```

Então atualize o método `_buildLargeScreenLayout`:

```dart
// lib/screens/adaptive_layout.dart

Widget _buildLargeScreenLayout() {
  return CupertinoPageScaffold(
    backgroundColor: CupertinoColors.extraLightBackgroundGray,
    child: SafeArea(
      child: Row(
        children: [
          SizedBox(
            width: 320,
            child: ContactGroupsSidebar(
              selectedListId: selectedListId,
              onListSelected: _onContactListSelected,
            ),
          ),
          Container(
            width: 1,
            color: CupertinoColors.separator,
          ),
          Expanded(
            child: ContactListDetail(listId: selectedListId),
          ),
        ],
      ),
    ),
  );
}
```

Este código cria o layout clássico menu-detalhe onde a barra lateral
controla o conteúdo da área de detalhe.

## Teste o comportamento de navegação adaptativa

Faça hot reload do seu app e teste a navegação:

**Telas pequenas (largura < 600px):**
- Toque nos grupos de contatos para navegar para detalhes de contatos.
- Use o botão de voltar ou gesto de deslizar para retornar.
- Este é um fluxo clássico de navegação baseada em pilha.

**Telas grandes (largura > 600px):**
- Clique nos grupos de contatos na barra lateral para atualizar a view de detalhe.
- Não há pilha de navegação. A seleção atualiza a área de conteúdo.
- Este é um padrão de interface mestre-detalhe.

O app escolhe automaticamente o padrão de navegação apropriado baseado
no tamanho da tela. Isso fornece uma experiência ideal tanto em telefones quanto em
tablets.
