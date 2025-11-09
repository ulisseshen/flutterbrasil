---
ia-translate: true
title: LayoutBuilder e layouts adaptativos
description: Aprenda como usar o widget LayoutBuilder
permalink: /tutorial/adaptive-layouts/
sitemap: false
---

Apps modernos precisam funcionar bem em telas de todos os tamanhos. Nesta página,
você aprenderá como criar layouts que se adaptam a diferentes larguras
de tela. Este app mostra uma barra lateral em telas grandes e uma
UI baseada em navegação em telas pequenas. Especificamente, este app lida com
dois tamanhos de tela:

* **Telas grandes (tablets, desktop)**: Mostra grupos de contatos e
  detalhes de contatos lado a lado.
* **Telas pequenas (telefones)**: Usa navegação para alternar entre grupos
  de contatos e detalhes.

## Crie a página de grupos de contatos

Primeiro, crie a estrutura básica do widget `ContactGroupsPage`
para sua tela de grupos de contatos. Crie
`lib/screens/contact_groups.dart` e adicione a seguinte estrutura
básica:

```dart
import 'package:flutter/cupertino.dart';

class ContactGroupsPage extends StatelessWidget {
  const ContactGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      child: Center(
        child: Text('Contact Groups will go here'),
      ),
    );
  }
}
```

## Crie a página de contatos

Similarmente, crie `lib/screens/contacts.dart` para eventualmente exibir
contatos individuais:

```dart
import 'package:flutter/cupertino.dart';

class ContactListsPage extends StatelessWidget {
  const ContactListsPage({super.key, required this.listId});

  final int listId;

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      child: Center(
        child: Text('Lists of contacts will go here'),
      ),
    );
  }
}
```

Os widgets `ContaactsListPage` e `ContactGroupsPage` são
páginas placeholder que são necessárias para implementar o widget de layout adaptativo,
o que você fará a seguir.

## Construa a base do layout adaptativo

Crie `lib/screens/adaptive_layout.dart`
e comece com a seguinte estrutura básica:

```dart
import 'package:flutter/cupertino.dart';

import 'contract_groups.dart';

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

Em seguida, adicione a lógica de detecção de tamanho de tela:

```dart
import 'package:flutter/cupertino.dart';
import 'contact_groups.dart';

// New
const largeScreenMinWidth = 600;

class AdaptiveLayout extends StatefulWidget {
  const AdaptiveLayout({super.key});

  @override
  State<AdaptiveLayout> createState() => _AdaptiveLayoutState();
}

class _AdaptiveLayoutState extends State<AdaptiveLayout> {
  @override
  Widget build(BuildContext context) {
    // Replace from here
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

O widget `LayoutBuilder` fornece informações sobre as
restrições de tamanho do pai. No callback `builder`, você recebe um
objeto `BoxConstraints` que informa a largura e altura
máximas disponíveis.

Ao verificar se `constraints.maxWidth > largeScreenMinWidth`, você pode
decidir qual layout mostrar. O limite de 600 pixels é um
breakpoint comum que separa telas de tamanho de telefone de telas
de tamanho de tablet.

## Atualize o app principal

Atualize `main.dart` para usar o layout adaptativo, para que você possa ver
suas mudanças.

```dart
import 'package:flutter/cupertino.dart';
import 'package:rolodex/data/contact_group.dart';
import 'package:rolodex/screens/adaptive_layout.dart';

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
      home: AdaptiveLayout(), // New
    );
  }
}
```

Se você está executando no Chrome, você pode redimensionar a janela do navegador para ver
as mudanças de layout.

## Adicione funcionalidade de seleção de lista

O layout de tela grande precisa rastrear qual grupo de contatos está
selecionado. Atualize o objeto de estado com o seguinte código:

```dart
import 'package:flutter/cupertino.dart';

import 'contract_groups.dart';

const largeScreenMinWidth = 600;

class AdaptiveLayout extends StatefulWidget {
  const AdaptiveLayout({super.key});

  @override
  State<AdaptiveLayout> createState() => _AdaptiveLayoutState();
}


class _AdaptiveLayoutState extends State<AdaptiveLayout> {
  // New
  int selectedListId = 0;

  // New
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
e `_onContactListSelected` atualiza esse valor quando o
usuário faz uma seleção.

## Construa o layout de tela grande

Agora, implemente o layout lado a lado para telas grandes. Primeiro,
substitua o texto temporário por um widget que contém o layout
adequado.

```dart
import 'package:flutter/cupertino.dart';

import 'contract_groups.dart';

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
          return _buildLargeScreenLayout(); // New
        } else {
          // For small screens, use the original, navigation-style approach
          return const ContactGroupsPage();
        }
      },
    );
  }

  // New
  Widget _buildLargeScreenLayout() {
    return const CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      child: SafeArea(
        child: Row(
          children: [
            // Contact groups list
            Text('Sidebar'),
            // List detail view
            Text('Details'),
          ],
        ),
      ),
    );
  }
}

```

O layout de tela grande usa um `Row` para colocar a barra lateral e os detalhes
lado a lado. `SafeArea` garante que o conteúdo não sobreponha
elementos da UI do sistema como a barra de status.

Agora, defina os tamanhos dos dois painéis e adicione um divisor visual:

```dart
Widget _buildLargeScreenLayout() {
  return CupertinoPageScaffold(
    backgroundColor: CupertinoColors.extraLightBackgroundGray,
    child: SafeArea(
      child: Row(
        children: [
          // Contact groups list
          SizedBox(
            width: 320,
            child: Text('Sidebar placeholder'), // Temporary
          ),
          // Divider
          Container(
            width: 1,
            color: CupertinoColors.separator,
          ),
          // List detail view
          Expanded(
            child: Text('Details placeholder'), // Temporary
          ),
        ],
      ),
    ),
  );
}
```

Este layout cria o seguinte:
* Uma barra lateral de largura fixa (320 pixels) para grupos de contatos.
* Um divisor de 1 pixel entre os painéis.
* Um painel de detalhes que usa um widget `Expanded` para ocupar o espaço
  restante.

## Teste o layout adaptativo

Faça hot reload do seu app e teste o comportamento responsivo. Se você está
executando no Chrome, você pode redimensionar a janela do navegador para ver a mudança
de layout:

* **Janela larga (> 600px)**: Mostra texto placeholder para a barra lateral
  e detalhes lado a lado.
* **Janela estreita (< 600px)**: Mostra apenas a página de grupos de contatos.

Tanto a barra lateral quanto a área de conteúdo principal mostram texto placeholder por enquanto.

Na próxima lição, você implementará slivers para preencher o
conteúdo da lista de contatos.
