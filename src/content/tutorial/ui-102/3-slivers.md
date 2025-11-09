---
ia-translate: true
title: Rolagem avançada e slivers
description: Aprenda como implementar rolagem performática com slivers.
permalink: /tutorial/slivers/
sitemap: false
---

Nesta lição, você aprenderá sobre slivers, que são widgets especiais
que podem aproveitar o sistema de rolagem poderoso e compon&#237;vel do Flutter.
Slivers permitem que você crie efeitos de rolagem sofisticados,
incluindo cabeçalhos retráteis, integração de busca e comportamentos
de rolagem personalizados. Ao final desta seção, você entenderá como usar
`CustomScrollView`, criar barras de navegação que retraem, e organizar
conteúdo em seções roláveis.

## Slivers e widgets

Slivers são áreas roláveis que podem ser compostas juntas em um
`CustomScrollView` ou outras views de rolagem. Pense em slivers como
blocos de construção que cada um contribui uma porção do conteúdo
rolável geral.

Enquanto slivers e widgets são ambos conceitos fundamentais do Flutter, eles
servem propósitos diferentes e não são intercambiáveis.

- **Widgets** são blocos de construção de UI gerais que podem ser usados em qualquer lugar
  na sua árvore de widgets.
- **Slivers** são widgets especializados projetados especificamente para
  layouts roláveis e têm algumas restrições:

- Slivers podem **apenas** ser filhos diretos de views de rolagem, como
  `CustomScrollView` e `NestedScrollView`.
- Algumas views de rolagem **apenas** aceitam slivers como filhos. Você não pode
  passar widgets regulares para `CustomScrollView.slivers`.
- Para usar widgets regulares dentro de um contexto sliver, envolva-os em
  `SliverToBoxAdapter` ou `SliverFillRemaining`.

Esta separação arquitetural permite que o Flutter otimize a performance
de rolagem enquanto mantém limites claros entre diferentes
tipos de componentes de UI.

## Adicione uma estrutura básica de sliver aos grupos de contatos

Primeiro, substitua o conteúdo placeholder na sua página de grupos
de contatos. Para evitar duplicar código entre o layout de telefone e a barra lateral
de tablet, você pode criar um widget privado reutilizável.

Atualize `lib/screens/contact_groups.dart` adicionando `_ContactGroupsView` ao final do arquivo.

```dart
// lib/screens/contact_groups.dart

// New imports
import 'package:rolodex/data/contact_group.dart';
import 'package:rolodex/main.dart';

// ... ContactGroupsPage widget ...

// New
class _ContactGroupsView extends StatelessWidget {
  const _ContactGroupsView({
    required this.onListSelected,
    this.selectedListId,
  });

  final int? selectedListId;
  final Function(ContactGroup) onListSelected;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Lists'),
          ),
          SliverFillRemaining(
            child: ValueListenableBuilder<List<ContactGroup>>(
              valueListenable: contactGroupsModel.listsNotifier,
              builder: (context, contactLists, child) {
                return CupertinoListSection.insetGrouped(
                  header: const Text('iPhone'),
                  children: [
                    for (final ContactGroup contactList in contactLists)
                      CupertinoListTile(
                        title: Text(contactList.label),
                        onTap: () => onListSelected(contactList),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

Este widget privado contém a UI compartilhada para exibir a lista de
grupos de contatos. Em telas pequenas, ele será usado como uma página, e em
telas grandes ele será usado para preencher a coluna esquerda.

Este widget introduz vários slivers:
- `CupertinoSliverNavigationBar`: Uma barra de navegação opinada que
  retrai conforme a página rola.
- `SliverList`: Uma lista rolável de itens.
- `SliverFillRemaining`: Um sliver que ocupa o espaço restante na
  área de rolagem, e cujo filho é um widget não-sliver.



Ele recebe uma função callback, `onListSelected`, para lidar com
toques, o que o torna adaptável tanto para navegação quanto para seleção de barra lateral.

Agora, atualize `ContactGroupsPage` para usar este novo widget privado:

```dart
// lib/screens/contact_groups.dart
class ContactGroupsPage extends StatelessWidget {
  const ContactGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ContactGroupsView(
      selectedListId: 0,
      onListSelected: (list) {
        // TODO: Implement navigation lesson.
        debugPrint(list.toString());
      },
    );
  }
}
// ... _ContactGroupsView from above
```

Esta estrutura mantém o `ContactGroupsPage` limpo e focado em sua
responsabilidade primária: navegação, que você aprenderá na
próxima seção deste tutorial.

## Melhore a lista com ícones e elementos visuais

Agora, adicione ícones e contagens de contatos para tornar a lista mais
informativa. Adicione este método auxiliar à sua classe `_ContactGroupsView`:

```dart
// In lib/screens/contact_groups.dart, inside _ContactGroupsView

Widget _buildTrailing(List<Contact> contacts, BuildContext context) {
  final TextStyle style = CupertinoTheme.of(
    context,
  ).textTheme.textStyle.copyWith(color: CupertinoColors.systemGrey);

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(contacts.length.toString(), style: style),
      const Icon(
        CupertinoIcons.forward,
        color: CupertinoColors.systemGrey3,
        size: 18,
      ),
    ],
  );
}
```

Este auxiliar cria o conteúdo trailing para cada item da lista. Ele mostra
a contagem de contatos e uma seta para frente.

Agora, atualize o `CupertinoListSection` em `_ContactGroupsView` para usar
ícones e o auxiliar trailing. Atualize o código dentro do
callback `ListenableBuilder.builder` no método `build`.

```dart
import 'package:flutter/cupertino.dart';
import 'package:rolodex/data/contact.dart';
import 'package:rolodex/data/contact_group.dart';
import 'package:rolodex/main.dart';

class ContactGroupsPage extends StatelessWidget {
  const ContactGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ContactGroupsView(
      selectedListId: 0,
      onListSelected: (list) {
        // TODO: Implement navigation lesson.
        debugPrint(list.toString());
      },
    );
  }
}

class _ContactGroupsView extends StatelessWidget {
  const _ContactGroupsView({
    required this.onListSelected,
    this.selectedListId,
  });

  final int? selectedListId;
  final Function(ContactGroup) onListSelected;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Lists'),
          ),
          SliverFillRemaining(
            child: ValueListenableBuilder<List<ContactGroup>>(
              valueListenable: contactGroupsModel.listsNotifier,
              builder: (context, contactLists, child) {

                // New from here
                const groupIcon = Icon(
                  CupertinoIcons.group,
                  weight: 900,
                  size: 32,
                );

                const pairIcon = Icon(
                  CupertinoIcons.person_2,
                  weight: 900,
                  size: 24,
                );

                return CupertinoListSection.insetGrouped(
                  header: const Text('iPhone'),
                  children: [
                    for (final ContactGroup contactList in contactLists)
                      CupertinoListTile(
                        leading: contactList.id == 0 ? groupIcon : pairIcon,
                        title: Text(contactList.label),
                        trailing: _buildTrailing(contactList.contacts, context),
                        onTap: () => onListSelected(contactList),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrailing(List<Contact> contacts, BuildContext context) {
    //...
  }

}
```

O código atualizado agora mostra ícones que diferenciam entre o grupo principal
"All iPhone" e grupos criados pelo usuário, junto com contagens de contatos
e indicadores de navegação.

## Crie rolagem avançada para contatos

Agora, trabalhe na página de contatos. Assim como antes, você criará uma
view privada reutilizável para evitar duplicação de código.

Na próxima lição, você implementará navegação para telas pequenas. Para
ver seu progresso na página de lista de contatos enquanto isso, atualize
`AdaptiveLayout` para exibir a página de lista de contatos.


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
          return const ContactsListPage(listId: 0); // New, temporary
        }
      },
    );
  }
}
```


Atualize `lib/screens/contacts.dart` adicionando `_ContactListView` ao
final do arquivo:

```dart
// lib/screens/contacts.dart
class _ContactListView extends StatelessWidget {
  const _ContactListView({
    required this.listId,
    this.automaticallyImplyLeading = true,
  });

  final int listId;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: ValueListenableBuilder<List<ContactGroup>>(
        valueListenable: contactGroupsModel.listsNotifier,
        builder: (context, contactGroups, child) {
          final ContactGroup contactList =
              contactGroupsModel.findContactList(listId);

          return CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Text(contactList.title),
                automaticallyImplyLeading: automaticallyImplyLeading,
              ),
              SliverFillRemaining(
                child: Center(
                  child: Text(
                      '${contactList.contacts.length} contacts in ${contactList.label}'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

Agora, atualize `ContactListsPage` para usar esta view:

```dart
// lib/screens/contacts.dart
import 'package:flutter/cupertino.dart';
import 'package:rolodex/data/contact_group.dart';
import 'package:rolodex/main.dart';

class ContactListsPage extends StatelessWidget {
  const ContactListsPage({super.key, required this.listId});

  final int listId;

  @override
  Widget build(BuildContext context) {
    return _ContactListView(listId: listId);
  }
}

// ... _ContactListView from above.
```

Esta implementação básica demonstra como usar slivers com dados
dinâmicos em um componente reutilizável.

## Adicione integração de busca com slivers

O construtor `CupertinoSliverNavigationBar.search` fornece
funcionalidade de busca integrada. Conforme você rola para baixo, o campo de busca
transita suavemente para a barra de navegação retraída.

Agora, melhore a página de contatos com UI de funcionalidade
de busca integrada. Atualize o `CustomScrollView` em `_ContactListView`:

```dart
class _ContactListView extends StatelessWidget {
  const _ContactListView({
    required this.listId,
  });

  final int listId;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: ValueListenableBuilder<List<ContactGroup>>(
        valueListenable: contactGroupsModel.listsNotifier,
        builder: (context, contactGroups, child) {
          final ContactGroup contactList = contactGroupsModel.findContactList(
            listId,
          );

          return CustomScrollView(
            slivers: [
              // New
              CupertinoSliverNavigationBar.search(
                largeTitle: Text(contactList.title),
                searchField: const CupertinoSearchTextField(
                  suffixIcon: Icon(CupertinoIcons.mic_fill),
                  suffixMode: OverlayVisibilityMode.always,
                ),
              ),
              SliverFillRemaining(
                child: Center(
                  child: Text(
                    '${contactList.contacts.length} contacts in ${contactList.label}',
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

```

O construtor `CupertinoSliverNavigationBar.search` fornece
funcionalidade de busca integrada. Conforme você rola para baixo, o campo de busca
transita suavemente para a barra de navegação retraída.

## Crie seções de contatos alfabetizadas

Apps de contatos do mundo real organizam contatos alfabeticamente. Para fazer isso,
crie seções para cada letra. Adicione o seguinte widget ao
final do seu arquivo `contacts.dart`. Este widget não contém
slivers.

```dart
// lib/screens/contacts.dart

// ...

class ContactListSection extends StatelessWidget {
  const ContactListSection({
    super.key,
    required this.lastInitial,
    required this.contacts,
  });

  final String lastInitial;
  final List<Contact> contacts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Text(
              lastInitial,
              style: const TextStyle(
                color: CupertinoColors.systemGrey,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          CupertinoListSection(
            backgroundColor: CupertinoColors.systemBackground,
            dividerMargin: 0,
            additionalDividerMargin: 0,
            topMargin: 4,
            children: [
              for (final Contact contact in contacts)
                CupertinoListTile(
                  padding: EdgeInsets.all(0),
                  title: Text('${contact.firstName} ${contact.lastName}'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
```

Este widget cria as seções alfabetizadas familiares que você vê no app Contacts
do iOS.

## Use `SliverList` para as seções alfabetizadas

Agora, substitua o conteúdo placeholder em `_ContactListView` pelas
seções alfabetizadas:

```dart
// In lib/screens/contacts.dart, inside _ContactListView's builder

final AlphabetizedContactMap contacts = contactList.alphabetizedContacts;

return CustomScrollView(
  slivers: [
    CupertinoSliverNavigationBar.search(
      largeTitle: Text(contactList.title),
      automaticallyImplyLeading: automaticallyImplyLeading,
      searchField: const CupertinoSearchTextField(
        suffixIcon: Icon(CupertinoIcons.mic_fill),
        suffixMode: OverlayVisibilityMode.always,
      ),
    ),
    SliverList.list(
      children: [
        const SizedBox(height: 20),
        ...contacts.keys.map(
          (String initial) => ContactListSection(
            lastInitial: initial,
            contacts: contacts[initial]!,
          ),
        ),
      ],
    ),
  ],
);
```

`SliverList.list` permite que você forneça uma lista de widgets que se tornam
parte do conteúdo rolável. Esta é a maneira mais simples de adicionar uma lista
de widgets normais a uma área sliver rolável.

Na próxima lição, você aprenderá sobre navegação baseada em pilha e
atualizará a UI em telas pequenas para navegar entre a view de lista de contatos
e a view de contatos.
