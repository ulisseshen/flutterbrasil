---
ia-translate: true
title: Navegação baseada em pilha
description: Aprenda como navegar de uma página para outra em um app Flutter.
layout: tutorial
---

Aprenda a navegar entre telas com Navigator.push e a implementar
padrões de navegação adaptativa para diferentes tamanhos de tela.

<SummaryCard>
title: O que você vai realizar
items:
  - title: Navegar entre telas com Navigator.push
    icon: open_in_new
  - title: Usar CupertinoPageRoute para transições no estilo iOS
    icon: swipe_right
  - title: Criar diferentes padrões de navegação para cada tamanho de tela
    icon: devices
</SummaryCard>

---

### Introdução {:#introduction}

Agora que você entende slivers e rolagem,
você pode implementar navegação entre telas.
Nesta lição,
você atualizará a view de tela pequena de modo que quando um grupo de contatos for tocado,
ele navegue para a lista de contatos daquele grupo.

Primeiro, reverta as mudanças no widget de layout adaptativo para que ele
exiba o `ContactGroupsPage` por padrão em telas pequenas.

<?code-excerpt "fwe/rolodex/lib/step4_navigation/screens/adaptive_layout.dart (reverted-state)"?>
```dart
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
  // ···
}
```

### Adicione navegação aos grupos de contatos {:#add-navigation-to-contact-groups}

O `ContactGroupsPage` já usa um `_ContactGroupsView`
e fornece a ele um callback.
Esse callback precisa ser atualizado para navegar quando um grupo é tocado,
em vez de imprimir o grupo no console.

Certifique-se de que o callback `onListSelected` e os imports em
`lib/screens/contact_groups.dart` estão implementados da seguinte forma:

<?code-excerpt "fwe/rolodex/lib/step4_navigation/screens/contact_groups.dart (contact_groups_page)"?>
```dart title="lib/screens/contact_groups.dart"
import 'contacts.dart';

class ContactGroupsPage extends StatelessWidget {
  const ContactGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ContactGroupsView(
      onListSelected: (list) => Navigator.of(context).push(
        CupertinoPageRoute<void>(
          title: list.title,
          builder: (context) => ContactListsPage(listId: list.id),
        ),
      ),
    );
  }
}
```

Este pequeno bloco de código contém a informação nova mais importante desta página.

`Navigator.of(context)` recupera o
widget `Navigator` mais próximo da árvore de widgets.
O método `push` adiciona uma nova rota à pilha do navegador, e
exibe o widget retornado da propriedade `builder`.

Esta é a implementação mais básica de uso de navegação baseada em pilha,
onde novas telas são empilhadas em cima da tela atual.
Para navegar de volta para a tela anterior, você usaria o método `Navigator.pop`.

`CupertinoPageRoute` cria transições de página no estilo iOS com
os seguintes recursos:

- Uma animação de deslizamento da direita.
- Suporte automático de botão de voltar.
- Tratamento adequado de título.
- Suporte a gesto de deslizar-para-voltar.

### Crie o componente de barra lateral para telas grandes {:#create-the-sidebar-component-for-large-screens}

Para telas grandes, você precisa de uma barra lateral que não navegue mas
em vez disso atualize a área de conteúdo principal.
Graças à refatoração na etapa anterior,
criar este componente é mais simples.
Adicione este widget ao final de `lib/screens/contact_groups.dart`:

<?code-excerpt "fwe/rolodex/lib/step4_navigation/screens/contact_groups.dart (contact_groups_sidebar)"?>
```dart
/// A sidebar component for selecting contact groups on large screens.
class ContactGroupsSidebar extends StatelessWidget {
  const ContactGroupsSidebar({
    super.key,
    required this.selectedListId,
    required this.onListSelected,
  });

  final int selectedListId;
  final void Function(int) onListSelected;

  @override
  Widget build(BuildContext context) {
    return _ContactGroupsView(
      selectedListId: selectedListId,
      onListSelected: (list) => onListSelected(list.id),
    );
  }
}
```

Este componente de barra lateral reutiliza o `_ContactGroupsView` e
fornece um callback diferente. Em vez de navegar,
ele chama `onListSelected` com o ID da lista tocada.
Ele também passa o `selectedListId` para `_ContactGroupsView` para que
o item selecionado possa ser destacado.

### Crie a view de detalhe para telas grandes {:#create-the-detail-view-for-large-screens}

Para o layout de tela grande, você precisa de uma view de detalhe que
não mostre controles de navegação. Assim como a barra lateral,
ela pode ser recriada reutilizando o `_ContactListView`.
Adicione este widget ao final do seu arquivo `contacts.dart`:

<?code-excerpt "fwe/rolodex/lib/step4_navigation/screens/contacts.dart (contact_list_detail)"?>
```dart
class ContactListDetail extends StatelessWidget {
  const ContactListDetail({super.key, required this.listId});

  final int listId;

  @override
  Widget build(BuildContext context) {
    return _ContactListView(listId: listId, automaticallyImplyLeading: false);
  }
}
```

A view de detalhe reutiliza `_ContactListView` e define
o parâmetro `automaticallyImplyLeading` como `false` para
esconder o botão de voltar, já que a navegação é tratada pela barra lateral.

### Conecte a barra lateral ao layout adaptativo {:#connect-the-sidebar-to-the-adaptive-layout}

Agora, conecte a barra lateral ao seu layout adaptativo.
Atualize seu arquivo `adaptive_layout.dart` para importar os arquivos necessários e
atualizar o layout de tela grande:

<?code-excerpt "fwe/rolodex/lib/step4_navigation/screens/adaptive_layout.dart (imports)"?>
```dart
import 'package:cupertino_ui/cupertino_ui.dart';

import 'contact_groups.dart';
import 'contacts.dart';
```

Então atualize o método `_buildLargeScreenLayout`:

<?code-excerpt "fwe/rolodex/lib/step4_navigation/screens/adaptive_layout.dart (build_large_screen)"?>
```dart
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
          Container(width: 1, color: CupertinoColors.separator),
          Expanded(child: ContactListDetail(listId: selectedListId)),
        ],
      ),
    ),
  );
}
```

Este código cria o layout clássico menu-detalhe onde a barra lateral
controla o conteúdo da área de detalhe.

### Teste o comportamento de navegação adaptativa {:#test-the-adaptive-navigation-behavior}

Faça hot reload do seu app e teste a navegação:

**Telas pequenas (largura <600px):**

- Toque nos grupos de contatos para navegar para detalhes de contatos.
- Use o botão de voltar ou um gesto de deslizar para retornar.
- Este é um fluxo clássico de navegação baseada em pilha.

**Telas grandes (largura >600px):**

- Clique nos grupos de contatos na barra lateral para atualizar a view de detalhe.
- Não há pilha de navegação. A seleção atualiza a área de conteúdo.
- Este é um padrão de interface mestre-detalhe.

O app escolhe automaticamente o
padrão de navegação apropriado baseado no tamanho da tela.
Isso fornece uma experiência ideal tanto em telefones quanto em tablets.

:::note
Se você redimensionar o app de uma tela pequena para uma tela grande enquanto estiver
em uma página de detalhes de contato, e então pressionar o botão de voltar,
você pode ver uma exceção de tag `Hero`.
Isso acontece porque o `Navigator` ainda mantém a rota de tela pequena empilhada
enquanto o layout de tela grande renderiza simultaneamente a view de detalhe,
causando widgets duplicados (como a barra de navegação) na árvore de widgets durante a transição.
Este é um caso extremo esperado para esta arquitetura simples e pode ser ignorado
para os propósitos deste caminho de aprendizado.
:::

### Revisão {:#review}


<SummaryCard>
title: O que você realizou
subtitle: Aqui está um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Navegou entre telas com Navigator.push
    icon: open_in_new
    details: >-
      `Navigator.of(context).push` adiciona uma nova rota à pilha de navegação.
      Esta é a base da navegação baseada em pilha, onde as telas são
      empilhadas umas sobre as outras e removidas para voltar.
  - title: Usou CupertinoPageRoute para transições no estilo iOS
    icon: swipe_right
    details: >-
      `CupertinoPageRoute` fornece suporte a recursos nativos de navegação do iOS:
      animações de deslizamento da direita, botões de voltar automáticos,
      tratamento adequado de título e suporte a gesto de deslizar-para-voltar.
  - title: Implementou padrões de navegação adaptativa
    icon: devices
    details: >-
      Você configurou diferentes padrões de navegação para telas pequenas e grandes.
      Telas pequenas usam navegação baseada em pilha, onde
      tocar em um grupo empilha uma nova tela.
      Telas grandes usam um padrão mestre-detalhe, onde selecionar
      um grupo atualiza o painel de detalhes sem navegação.
  - title: Concluiu o app Rolodex
    icon: celebration
    details: >-
      Você construiu um app de contatos completo no estilo iOS com
      layouts adaptativos, rolagem avançada,
      cabeçalhos recolhíveis com busca e navegação responsiva.
      Esses são padrões comuns usados em apps de produção!
</SummaryCard>

### Teste seus conhecimentos {:#test-yourself}

<Quiz title="Quiz de Navegação">
- question: "O que `Navigator.of(context).push` faz?"
  options:
    - text: Substitui a tela atual por uma nova.
      correct: false
      explanation: "Push adiciona à pilha; `pushReplacement` substitui a tela atual."
    - text: Adiciona uma nova rota à pilha de navegação, exibindo-a sobre a tela atual.
      correct: true
      explanation: Push adiciona a nova rota à pilha, permitindo que os usuários voltem para a tela anterior.
    - text: Remove a tela atual da pilha de navegação.
      correct: false
      explanation: "Isso é o que `pop` faz; push adiciona uma nova tela."
    - text: Abre uma caixa de diálogo sobre a tela atual.
      correct: false
      explanation: "Diálogos usam `showDialog`; Navigator.push navega para uma tela inteira."
- question: "O que `Navigator.of(context).pop()` faz?"
  options:
    - text: Fecha o app inteiro.
      correct: false
      explanation: Pop apenas remove a rota atual; ele não fecha o app.
    - text: Remove a rota atual da pilha de navegação, retornando para a tela anterior.
      correct: true
      explanation: Pop remove a rota do topo da pilha, revelando a tela abaixo dela.
    - text: Limpa todas as rotas e mostra a tela inicial.
      correct: false
      explanation: Isso exigiria popUntil ou pushAndRemoveUntil; pop remove apenas a rota do topo.
    - text: Atualiza a tela atual com novos dados.
      correct: false
      explanation: Pop navega para trás; para atualizar, você usaria setState ou outro gerenciamento de estado.
</Quiz>
