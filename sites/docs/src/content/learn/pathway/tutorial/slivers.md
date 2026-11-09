---
ia-translate: true
title: Rolagem avançada e slivers
description: Aprenda como implementar rolagem performática com slivers.
layout: tutorial
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g;"?>

Nesta lição, você aprenderá sobre slivers,
que são widgets especiais que podem aproveitar o
sistema de rolagem poderoso e componível do Flutter.
Slivers permitem que você crie efeitos de rolagem sofisticados,
incluindo cabeçalhos retráteis, integração de busca e comportamentos de rolagem personalizados.
Ao final desta seção, você entenderá como
usar `CustomScrollView`, criar barras de navegação que retraem,
e organizar conteúdo em seções roláveis.

<SummaryCard>
title: O que você vai realizar
items:
  - title: Entender slivers e como eles diferem dos widgets
    icon: view_day
  - title: Construir layouts roláveis com CustomScrollView
    icon: unfold_more
  - title: Criar barras de navegação retráteis com busca
    icon: search
  - title: Organizar contatos em seções alfabetizadas
    icon: sort_by_alpha
</SummaryCard>

---

### Slivers e widgets

Slivers são áreas roláveis que podem ser compostas juntas em um
`CustomScrollView` ou outras views de rolagem.
Pense em slivers como blocos de construção que cada um
contribui com uma porção do conteúdo rolável geral.

Enquanto slivers e widgets são ambos conceitos fundamentais do Flutter,
eles servem propósitos diferentes e não são intercambiáveis.

- **Widgets** são blocos de construção de UI gerais que
  podem ser usados em qualquer lugar na sua árvore de widgets.
- **Slivers** são widgets especializados projetados especificamente para
  layouts roláveis e têm algumas restrições:

- Slivers podem **apenas** ser filhos diretos de views de rolagem, como
  `CustomScrollView` e `NestedScrollView`.
- Algumas views de rolagem **apenas** aceitam slivers como filhos.
  Você não pode passar widgets regulares para `CustomScrollView.slivers`.
- Para usar widgets regulares dentro de um contexto sliver,
  envolva-os em `SliverToBoxAdapter` ou `SliverFillRemaining`.

Esta separação arquitetural permite que o Flutter
otimize a performance de rolagem enquanto mantém limites claros entre
diferentes tipos de componentes de UI.

### Adicione uma estrutura básica de sliver aos grupos de contatos

Primeiro, substitua o conteúdo placeholder na sua página de grupos de contatos.
Para evitar duplicar código entre o layout de telefone e a barra lateral de tablet,
você pode criar um widget privado reutilizável.

Atualize `lib/screens/contact_groups.dart`
adicionando `_ContactGroupsView` ao final do arquivo.

<?code-excerpt "fwe/rolodex/lib/step3_slivers/screens/contact_groups_v1.dart (contact_groups_view)"?>
```dart
import 'package:cupertino_ui/cupertino_ui.dart';

import '../data/contact_group.dart';
import '../main.dart';

class ContactGroupsPage extends StatelessWidget {
  const ContactGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ContactGroupsView(
      selectedListId: 0,
      onListSelected: (list) {
        debugPrint(list.toString());
      },
    );
  }
}

// ···
class _ContactGroupsView extends StatelessWidget {
  const _ContactGroupsView({required this.onListSelected, this.selectedListId});

  final int? selectedListId;
  final void Function(ContactGroup) onListSelected;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(largeTitle: Text('Lists')),
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

Este widget privado contém a UI compartilhada para
exibir a lista de grupos de contatos.
Em telas pequenas, ele será usado como uma página, e em
telas grandes ele será usado para preencher a coluna esquerda.

Este widget introduz vários slivers:

- `CupertinoSliverNavigationBar`:
  Uma barra de navegação opinada que retrai conforme a página rola.
- `SliverList`:
  Uma lista rolável de itens.
- `SliverFillRemaining`:
  Um sliver que ocupa o espaço restante na
  área de rolagem, e cujo filho é um widget não-sliver.

Ele aceita uma função callback, `onListSelected`, para lidar com toques,
o que o torna adaptável tanto para navegação quanto para seleção de barra lateral.

Agora, atualize `ContactGroupsPage` em `lib/screens/contact_groups.dart` para usar seu novo widget `_ContactGroupsView`:

<?code-excerpt "fwe/rolodex/lib/step3_slivers/screens/contact_groups_v1.dart (contact_groups_page)"?>
```dart
class ContactGroupsPage extends StatelessWidget {
  const ContactGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ContactGroupsView(
      selectedListId: 0,
      onListSelected: (list) {
        debugPrint(list.toString());
      },
    );
  }
}
```

Esta estrutura mantém o `ContactGroupsPage` limpo e
focado em sua responsabilidade primária: navegação,
que você aprenderá na próxima seção deste tutorial.

### Melhore a lista com ícones e elementos visuais

Agora, adicione ícones e contagens de contatos para tornar a lista mais informativa.
Adicione este método auxiliar `_buildTrailing` à sua
classe `_ContactGroupsView` em `lib/screens/contact_groups.dart`:

<?code-excerpt "fwe/rolodex/lib/step3_slivers/screens/contact_groups.dart (build_trailing)"?>
```dart
Widget _buildTrailing(List<Contact> contacts, BuildContext context) {
  final TextStyle style = CupertinoTheme.of(context).textTheme.textStyle
      .copyWith(color: CupertinoColors.systemGrey);

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

Este auxiliar cria o conteúdo trailing para cada item da lista.
Ele mostra a contagem de contatos e uma seta para frente.

Agora, atualize o `CupertinoListSection` em `_ContactGroupsView` para
usar ícones e o auxiliar trailing. Atualize o código dentro do
callback `ValueListenableBuilder.builder` no método `build`:

<?code-excerpt "fwe/rolodex/lib/step3_slivers/screens/contact_groups.dart (cupertino_list_section)"?>
```dart
child: ValueListenableBuilder<List<ContactGroup>>(
  valueListenable: contactGroupsModel.listsNotifier,
  builder: (context, contactLists, child) {
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
```

O código atualizado agora mostra ícones que diferenciam entre o
grupo principal "All iPhone" e grupos criados pelo usuário, junto com
contagens de contatos e indicadores de navegação.

### Crie rolagem avançada para contatos

Em seguida, você implementará a página de lista de contatos.

Na próxima lição, você implementará navegação para telas pequenas.
Para ver seu progresso na página de lista de contatos enquanto isso, primeiro
atualize `lib/screens/adaptive_layout.dart` para exibir a página de lista de contatos:

<?code-excerpt "fwe/rolodex/lib/step3_slivers/screens/adaptive_layout.dart"?>
```dart

import 'package:cupertino_ui/cupertino_ui.dart';

import 'contacts.dart';

const largeScreenMinWidth = 600;

class AdaptiveLayout extends StatefulWidget {
  const AdaptiveLayout({super.key});

  @override
  State<AdaptiveLayout> createState() => _AdaptiveLayoutState();
}

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
          return const ContactListsPage(listId: 0); // New, temporary
        }
      },
    );
  }

  Widget _buildLargeScreenLayout() {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      child: SafeArea(
        child: Row(
          children: [
            const SizedBox(width: 320, child: Text('Sidebar placeholder')),
            Container(width: 1, color: CupertinoColors.separator),
            const Expanded(child: Text('Details placeholder')),
          ],
        ),
      ),
    );
  }
}
```

Atualize `lib/screens/contacts.dart` adicionando `_ContactListView` ao
final do arquivo:

<?code-excerpt "fwe/rolodex/lib/step3_slivers/screens/contacts_v1.dart (contact_list_view)"?>
```dart
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
          final contactList = contactGroupsModel.findContactList(listId);

          return CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Text(contactList.title),
                automaticallyImplyLeading: automaticallyImplyLeading,
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

Agora, atualize `ContactListsPage` para usar esta view:

<?code-excerpt "fwe/rolodex/lib/step3_slivers/screens/contacts_v1.dart (contact_lists_page)"?>
```dart
class ContactListsPage extends StatelessWidget {
  const ContactListsPage({super.key, required this.listId});

  final int listId;

  @override
  Widget build(BuildContext context) {
    return _ContactListView(listId: listId);
  }
}
```

Esta implementação básica demonstra como usar slivers com dados
dinâmicos em um componente reutilizável.

### Adicione integração de busca com slivers

Agora, melhore a página de contatos com UI de funcionalidade de busca integrada.
Atualize o `CustomScrollView` em `_ContactListView` para usar o
construtor `CupertinoSliverNavigationBar.search` em vez do
construtor padrão `CupertinoSliverNavigationBar`:

<?code-excerpt "fwe/rolodex/lib/step3_slivers/screens/contacts_v2.dart (search)"?>
```dart
class _ContactListView extends StatelessWidget {
  // ···
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: ValueListenableBuilder<List<ContactGroup>>(
        valueListenable: contactGroupsModel.listsNotifier,
        builder: (context, contactGroups, child) {
          final contactList = contactGroupsModel.findContactList(listId);

          return CustomScrollView(
            slivers: [
              // Now using a search bar:
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
funcionalidade de busca integrada. Conforme você rola para baixo,
o campo de busca transita suavemente para a barra de navegação retraída.

### Crie seções de contatos alfabetizadas

Apps de contatos do mundo real organizam contatos alfabeticamente.
Para fazer isso, crie seções para cada letra.
Adicione o seguinte widget ao final do seu arquivo `contacts.dart`.
Este widget não contém slivers.

<?code-excerpt "fwe/rolodex/lib/step3_slivers/screens/contacts.dart (contact_list_section)"?>
```dart
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
                  padding: const EdgeInsets.all(0),
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

Este widget cria as seções alfabetizadas familiares que
você vê no app Contacts do iOS.

### Use `SliverList` para as seções alfabetizadas

Agora, substitua o conteúdo placeholder em `_ContactListView` pelas
seções alfabetizadas:

<?code-excerpt "fwe/rolodex/lib/step3_slivers/screens/contacts.dart (alphabetized)"?>
```dart
class _ContactListView extends StatelessWidget {
  // ···
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: ValueListenableBuilder<List<ContactGroup>>(
        valueListenable: contactGroupsModel.listsNotifier,
        builder: (context, contactGroups, child) {
          final contactList = contactGroupsModel.findContactList(listId);

          final contacts = contactList.alphabetizedContacts;

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
                    (initial) => ContactListSection(
                      lastInitial: initial,
                      contacts: contacts[initial]!,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
```

`SliverList.list` permite que você forneça uma lista de widgets que
se tornam parte do conteúdo rolável. Esta é a maneira mais simples de
adicionar uma lista de widgets normais a uma área sliver rolável.

Na próxima lição, você aprenderá sobre navegação baseada em pilha e
atualizará a UI em telas pequenas para navegar entre
a view de lista de contatos e a view de contatos.

### Revisão

<SummaryCard>
title: O que você realizou
subtitle: Aqui está um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Entendeu slivers e como eles diferem dos widgets
    icon: view_day
    details: >-
      Slivers são widgets especializados para layouts roláveis.
      Eles só podem ser filhos diretos de views de rolagem como `CustomScrollView`.
      Em `CustomScrollView` e outros contextos sliver, widgets regulares precisam ser
      envolvidos em `SliverToBoxAdapter` ou `SliverFillRemaining`.
  - title: Construiu layouts roláveis com CustomScrollView
    icon: unfold_more
    details: >-
      `CustomScrollView` permite compor vários slivers juntos.
      Você usou `CupertinoSliverNavigationBar`, `SliverFillRemaining`
      e `SliverList` para criar interfaces roláveis sofisticadas.
  - title: Criou barras de navegação retráteis com busca
    icon: search
    details: >-
      Você usou o construtor `CupertinoSliverNavigationBar.search` para
      criar uma barra de navegação retrátil com funcionalidade de busca integrada.
  - title: Organizou contatos em seções alfabetizadas
    icon: sort_by_alpha
    details: >-
      Você criou widgets `ContactListSection` agrupados pela inicial do sobrenome,
      e depois usou `SliverList.list` para adicioná-los à área rolável.
      Isso reproduz a experiência familiar do app Contacts do iOS.
</SummaryCard>

### Teste seus conhecimentos

<Quiz title="Quiz sobre Slivers">
- question: Qual é a principal diferença entre slivers e widgets regulares?
  options:
    - text: Slivers são renderizados mais rápido que widgets regulares.
      correct: false
      explanation: Ambos são otimizados; a diferença está no propósito e no contexto.
    - text: Slivers são widgets especializados projetados para layouts roláveis e só podem ser filhos diretos de views de rolagem.
      correct: true
      explanation: Slivers funcionam dentro de views de rolagem como CustomScrollView; widgets regulares podem ser usados em qualquer lugar.
    - text: Slivers podem ter um número ilimitado de filhos.
      correct: false
      explanation: Alguns slivers como SliverList podem ter muitos filhos, mas não é isso que os distingue.
    - text: Slivers lidam automaticamente com gestos do usuário.
      correct: false
      explanation: O tratamento de gestos é separado; slivers tratam da composição de layouts roláveis.
- question: Como você usa um widget regular dentro da lista de slivers de um CustomScrollView?
  options:
    - text: Basta adicioná-lo diretamente; CustomScrollView aceita qualquer widget.
      correct: false
      explanation: CustomScrollView só aceita slivers; widgets regulares precisam ser envolvidos.
    - text: Envolva-o em um SliverToBoxAdapter ou SliverFillRemaining.
      correct: true
      explanation: Esses adaptadores convertem widgets regulares em slivers para que possam ser usados em contextos sliver.
    - text: "Converta o widget em um sliver chamando `.toSliver()` nele."
      correct: false
      explanation: "Não existe um método `.toSliver()`; você usa widgets adaptadores como SliverToBoxAdapter."
    - text: "Passe-o para a propriedade `child` em vez de `slivers`."
      correct: false
      explanation: CustomScrollView usa a propriedade slivers; não há uma propriedade child para esse propósito.
</Quiz>
