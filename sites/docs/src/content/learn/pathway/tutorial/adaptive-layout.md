---
ia-translate: true
title: LayoutBuilder e layouts adaptativos
description: Aprenda como usar o widget LayoutBuilder.
layout: tutorial
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g;"?>

Aprenda como criar layouts que se adaptam a diferentes larguras de tela.

<SummaryCard>
title: O que você vai realizar
items:
  - title: Criar layouts responsivos com LayoutBuilder
    icon: fit_screen
  - title: Detectar o tamanho da tela para escolher diferentes layouts
    icon: devices
  - title: Construir um layout com barra lateral e detalhes para telas grandes
    icon: view_sidebar
</SummaryCard>

---

### Introdução {:#introduction}

Apps modernos precisam funcionar bem em telas de todos os tamanhos.
Nesta página, você aprenderá como criar layouts que
se adaptam a diferentes larguras de tela.
Este app mostra uma barra lateral em telas grandes e
uma UI baseada em navegação em telas pequenas.
Especificamente, este app lida com dois tamanhos de tela:

- **Telas grandes (tablets, desktop)**:
  Mostra grupos de contatos e detalhes de contatos lado a lado.
- **Telas pequenas (telefones)**:
  Usa navegação para alternar entre grupos de contatos e detalhes.

### Crie a página de grupos de contatos {:#create-the-contact-groups-page}

Primeiro, crie a estrutura básica do widget `ContactGroupsPage`
para sua tela de grupos de contatos.
Crie `lib/screens/contact_groups.dart` e adicione
a seguinte estrutura básica:

<?code-excerpt "fwe/rolodex/lib/step2_adaptive_layout/screens/contact_groups.dart"?>
```dart
import 'package:cupertino_ui/cupertino_ui.dart';

class ContactGroupsPage extends StatelessWidget {
  const ContactGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      child: Center(child: Text('Contact Groups will go here')),
    );
  }
}
```

### Crie a página de contatos {:#create-the-contacts-page}

Similarmente, crie `lib/screens/contacts.dart` para eventualmente
exibir contatos individuais:

<?code-excerpt "fwe/rolodex/lib/step2_adaptive_layout/screens/contacts.dart"?>
```dart
import 'package:cupertino_ui/cupertino_ui.dart';

class ContactListsPage extends StatelessWidget {
  const ContactListsPage({super.key, required this.listId});

  final int listId;

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      child: Center(child: Text('Lists of contacts will go here')),
    );
  }
}
```

Os widgets `ContactListsPage` e `ContactGroupsPage` são
páginas placeholder que são necessárias para implementar o widget de layout adaptativo,
o que você fará a seguir.

### Construa a base do layout adaptativo {:#build-the-adaptive-layout-foundation}

Crie `lib/screens/adaptive_layout.dart`
e comece com a seguinte estrutura básica:

<?code-excerpt "fwe/rolodex/lib/step2_adaptive_layout/screens/adaptive_layout_v1.dart"?>
```dart
import 'package:cupertino_ui/cupertino_ui.dart';

import 'contact_groups.dart';

class AdaptiveLayout extends StatefulWidget {
  const AdaptiveLayout({super.key});

  @override
  State<AdaptiveLayout> createState() => _AdaptiveLayoutState();
}

class _AdaptiveLayoutState extends State<AdaptiveLayout> {
  @override
  Widget build(BuildContext context) {
    return const ContactGroupsPage(); // Temporary placeholder
  }
}
```

Este é um `StatefulWidget` porque o layout adaptativo eventualmente
gerencia qual grupo de contatos está atualmente selecionado.

Em seguida, adicione a lógica de detecção de tamanho de tela em `lib/screens/adaptive_layout.dart`:

<?code-excerpt "fwe/rolodex/lib/step2_adaptive_layout/screens/adaptive_layout_v2.dart"?>
```dart
import 'package:cupertino_ui/cupertino_ui.dart';

import 'contact_groups.dart';

const largeScreenMinWidth = 600;

class AdaptiveLayout extends StatefulWidget {
  const AdaptiveLayout({super.key});

  @override
  State<AdaptiveLayout> createState() => _AdaptiveLayoutState();
}

class _AdaptiveLayoutState extends State<AdaptiveLayout> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > largeScreenMinWidth;

        if (isLargeScreen) {
          return const Text('Large screen layout'); // Temporary
        } else {
          return const ContactGroupsPage();
        }
      },
    );
  }
}
```

O widget `LayoutBuilder` fornece informações sobre
as restrições de tamanho do pai.
No callback `builder`, você recebe um objeto `BoxConstraints` que
informa a largura e altura máximas disponíveis.

Ao verificar se `constraints.maxWidth > largeScreenMinWidth`,
você pode decidir qual layout mostrar.
O limite de 600 pixels é um breakpoint comum que
separa telas de tamanho de telefone de telas de tamanho de tablet.

### Atualize o app principal {:#update-the-main-app}

Atualize `main.dart` para usar o layout adaptativo,
para que você possa ver suas mudanças:

<?code-excerpt "fwe/rolodex/lib/step2_adaptive_layout/main.dart"?>
```dart
import 'package:cupertino_ui/cupertino_ui.dart';

import 'data/contact_group.dart';
import 'screens/adaptive_layout.dart';

final contactGroupsModel = ContactGroupsModel();

void main() {
  runApp(const RolodexApp());
}

class RolodexApp extends StatelessWidget {
  const RolodexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Rolodex',
      theme: CupertinoThemeData(
        barBackgroundColor: CupertinoDynamicColor.withBrightness(
          color: Color(0xFFF9F9F9),
          darkColor: Color(0xFF1D1D1D),
        ),
      ),
      home: AdaptiveLayout(),
    );
  }
}
```

Se você está executando no Chrome, você pode redimensionar a janela do navegador para
ver as mudanças de layout.

### Adicione funcionalidade de seleção de lista {:#add-list-selection-functionality}

O layout de tela grande precisa rastrear qual grupo de contatos está selecionado.
Atualize o objeto de estado em `lib/screens/adaptive_layout.dart` com o seguinte código:

<?code-excerpt "fwe/rolodex/lib/step2_adaptive_layout/screens/adaptive_layout_v3.dart"?>
```dart

import 'package:cupertino_ui/cupertino_ui.dart';

import 'contact_groups.dart';

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
          return const Text('Large screen layout');
        } else {
          return const ContactGroupsPage();
        }
      },
    );
  }
}
```

A variável `selectedListId` rastreia o grupo de contatos atualmente selecionado,
e `_onContactListSelected` atualiza esse valor quando o usuário faz uma escolha.

### Construa o layout de tela grande {:#build-the-large-screen-layout}

Agora, implemente o layout lado a lado para telas grandes em `lib/screens/adaptive_layout.dart`.
Primeiro, substitua o texto temporário por um widget que
contém o layout adequado.

<?code-excerpt "fwe/rolodex/lib/step2_adaptive_layout/screens/adaptive_layout_v4.dart"?>
```dart

import 'package:cupertino_ui/cupertino_ui.dart';

import 'contact_groups.dart';

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
          // For small screens, use the original, navigation-style approach.
          return const ContactGroupsPage();
        }
      },
    );
  }

  Widget _buildLargeScreenLayout() {
    return const CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      child: SafeArea(child: Row(children: [Text('Sidebar'), Text('Details')])),
    );
  }
}
```

O layout de tela grande usa um `Row` para
colocar a barra lateral e os detalhes lado a lado.
`SafeArea` garante que o conteúdo não sobreponha
elementos da UI do sistema como a barra de status.

Agora, defina os tamanhos dos dois painéis e
adicione um divisor visual em `lib/screens/adaptive_layout.dart`:

<?code-excerpt "fwe/rolodex/lib/step2_adaptive_layout/screens/adaptive_layout.dart (panel-and-divider)"?>
```dart
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
```

Este layout cria o seguinte:

- Uma barra lateral de largura fixa (320 pixels) para grupos de contatos.
- Um divisor de 1 pixel entre os painéis.
- Um painel de detalhes que usa um widget `Expanded` para ocupar o espaço restante.

### Teste o layout adaptativo {:#test-the-adaptive-layout}

Faça hot reload do seu app e teste o comportamento responsivo.
Se você está executando no Chrome, você pode redimensionar a janela do navegador para
ver a mudança de layout:

- **Janela larga (> 600px)**:
  Mostra texto placeholder para a barra lateral e detalhes lado a lado.
- **Janela estreita (< 600px)**:
  Mostra apenas a página de grupos de contatos.

Tanto a barra lateral quanto a área de conteúdo principal mostram texto placeholder por enquanto.

Na próxima lição, você implementará slivers para preencher
o conteúdo da lista de contatos.

### Revisão {:#review}

<SummaryCard>
title: O que você realizou
subtitle: Aqui está um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Criou layouts responsivos com LayoutBuilder
    icon: fit_screen
    details: >-
      `LayoutBuilder` fornece as restrições de tamanho do pai em
      seu callback builder. Ao verificar `constraints.maxWidth`,
      você pode decidir qual layout mostrar com base no espaço disponível.
  - title: Detectou o tamanho da tela para escolher diferentes layouts
    icon: devices
    details: >-
      Você usou um breakpoint de 600 pixels para
      distinguir telas de tamanho de telefone de telas de tamanho de tablet.
      Esse limite comum ajuda seu app a adaptar sua UI para
      fornecer a melhor experiência em cada dispositivo.
  - title: Construiu um layout com barra lateral e detalhes para telas grandes
    icon: view_sidebar
    details: >-
      Em telas grandes, você exibiu uma barra lateral de largura fixa e
      um painel de detalhes `Expanded` lado a lado usando um `Row`.
      Esse padrão clássico maximiza o aproveitamento da tela em tablets e desktops.
</SummaryCard>

### Teste seus conhecimentos {:#test-yourself}

<Quiz title="Quiz de Layout Adaptativo">
- question: Que informação o LayoutBuilder fornece ao seu callback builder?
  options:
    - text: O sistema operacional do dispositivo e a orientação da tela.
      correct: false
      explanation: LayoutBuilder fornece restrições de tamanho, não informações de SO ou orientação.
    - text: As restrições de tamanho do pai, incluindo largura e altura máximas.
      correct: true
      explanation: O builder do LayoutBuilder recebe BoxConstraints que informam o espaço disponível a partir do pai.
    - text: As cores e a tipografia do tema atual.
      correct: false
      explanation: Os dados de tema vêm de Theme.of(context), não do LayoutBuilder.
    - text: O número de widgets filhos na árvore.
      correct: false
      explanation: LayoutBuilder fornece restrições de layout, não informações da árvore de widgets.
- question: Em um layout de tela grande, qual widget pode ser usado para colocar uma barra lateral e um painel de detalhes lado a lado?
  options:
    - text: Column
      correct: false
      explanation: Column organiza widgets verticalmente, não lado a lado.
    - text: Row
      correct: true
      explanation: Row organiza seus filhos horizontalmente, tornando-o ideal para colocar uma barra lateral e um painel de detalhes lado a lado.
    - text: Stack
      correct: false
      explanation: Stack sobrepõe widgets uns sobre os outros, não lado a lado.
    - text: ListView
      correct: false
      explanation: ListView é para listas roláveis, não para layout lado a lado.
</Quiz>
