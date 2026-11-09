---
ia-translate: true
title: Recursos avançados de UI
description: >-
  Uma introdução suave a recursos avançados de UI:
  layouts adaptativos, slivers, rolagem, navegação.
layout: tutorial
---

Pré-visualize o app Rolodex que você vai construir e configure um projeto baseado em Cupertino com modelos de dados.

<SummaryCard>
title: O que você vai realizar
items:
  - title: Pré-visualizar o app Rolodex que você vai construir
    icon: preview
  - title: Configurar um projeto com widgets Cupertino
    icon: phone_iphone
  - title: Criar modelos de dados para contatos e grupos
    icon: data_object
</SummaryCard>

---

### Introdução {:#introduction}

Nesta terceira parte da série de tutoriais do Flutter,
você usará a biblioteca Cupertino do Flutter para construir um
clone parcial do app Contatos do iOS.

<img src='/assets/images/docs/tutorial/rolodex_complete.png' class="diagram-wrap"
width="320px" alt="Uma captura de tela do app de gerenciamento de contatos Rolodex
concluído, mostrando uma lista de contatos organizados em ordem alfabética.">

Ao final deste tutorial, você terá aprendido como criar
layouts adaptativos, implementar temas abrangentes, construir padrões
de navegação e usar técnicas avançadas de rolagem.

#### O que você vai aprender {:#what-youll-learn}

Este tutorial explora os seguintes tópicos:

* Construir layouts responsivos com `LayoutBuilder`.
* Usar rolagem avançada com slivers e busca.
* Implementar padrões de navegação baseados em stack.
* Criar temas abrangentes com `CupertinoThemeData`.
* Suportar temas claro e escuro.
* Criar uma UI no estilo iOS usando widgets Cupertino.

Este tutorial assume que você concluiu os tutoriais anteriores do Flutter
e está confortável com composição básica de widgets, gerenciamento de estado
e a estrutura de projetos Flutter.


### Crie um novo projeto Flutter {:#create-a-new-flutter-project}

Para construir um app Flutter, você primeiro precisa de um projeto Flutter.
Você pode criar um novo app com a [ferramenta CLI do Flutter][Flutter CLI tool],
que é instalada como parte do SDK do Flutter.

Abra seu terminal preferido e execute
o seguinte comando para criar um novo projeto Flutter:

```console
$ flutter create rolodex --empty
$ cd rolodex
```

Este comando cria um novo projeto Flutter que
usa o template mínimo "empty".

[Flutter CLI tool]: /reference/flutter-cli

### Adicione as dependências Cupertino {:#add-the-cupertino-dependencies}

Este projeto usa o [pacote `cupertino_ui`][`cupertino_ui` package] para widgets Cupertino
e o [pacote `cupertino_icons`][`cupertino_icons` package] para assets de ícones Cupertino.
Adicione ambos os pacotes oficiais do Flutter como dependências
executando o seguinte comando:

```console
$ flutter pub add cupertino_ui cupertino_icons
```

### Configure a estrutura do projeto {:#set-up-the-project-structure}

Primeiro, crie a estrutura básica de diretórios para o seu app.
No diretório `lib` do seu projeto, crie as seguintes pastas:

```console
$ mkdir lib/data lib/screens lib/theme
```

Este comando cria pastas para organizar seu código em seções lógicas:
modelos de dados, widgets de tela e configuração de tema.

### Substitua o código inicial {:#replace-the-starter-code}

Na sua IDE, abra o arquivo `lib/main.dart` e substitua todo o seu
conteúdo pelo seguinte código inicial:

<?code-excerpt "fwe/rolodex/lib/step1_advanced_ui/main_starter.dart"?>
```dart
import 'package:cupertino_ui/cupertino_ui.dart';

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
      home: CupertinoPageScaffold(child: Center(child: Text('Hello Rolodex!'))),
    );
  }
}
```

Diferentemente dos dois tutoriais anteriores,
este app usa `CupertinoApp` em vez de `MaterialApp`.
O design system Cupertino fornece widgets e estilos no estilo iOS,
o que é perfeito para construir apps que parecem nativos em dispositivos Apple.

### Execute seu app {:#run-your-app}

No seu terminal, na raiz do seu app Flutter, execute o seguinte comando:

```console
$ flutter run -d chrome
```

O app é compilado e iniciado em uma nova instância do Chrome.
Ele exibe "Hello Rolodex!" no centro da tela.

### Crie os modelos de dados {:#create-the-data-models}

Antes de construir a UI,
crie as estruturas de dados e os dados de exemplo que o app usará.
Esta seção é explicada brevemente porque não é o foco deste tutorial.

#### Dados de Contact {:#contact-data}

Crie um novo arquivo, `lib/data/contact.dart`, e adicione a classe básica `Contact`:

<?code-excerpt "fwe/rolodex/lib/step1_advanced_ui/data/contact.dart" replace="/\/\/ openFold/[* -/g; /\/\/ closeFold/*]/g;"?>
```dart foldable
class Contact {
  Contact({
    required this.id,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.suffix,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String? middleName;
  final String? suffix;
}

[* -
final johnAppleseed = Contact(id: 0, firstName: 'John', lastName: 'Appleseed');
final kateBell = Contact(id: 1, firstName: 'Kate', lastName: 'Bell');
final annaHaro = Contact(id: 2, firstName: 'Anna', lastName: 'Haro');
final danielHiggins = Contact(
  id: 3,
  firstName: 'Daniel',
  lastName: 'Higgins',
  suffix: 'Jr.',
);
final davidTaylor = Contact(id: 4, firstName: 'David', lastName: 'Taylor');
final hankZakroff = Contact(
  id: 5,
  firstName: 'Hank',
  middleName: 'M.',
  lastName: 'Zakroff',
);

final alexAnderson = Contact(id: 6, firstName: 'Alex', lastName: 'Anderson');
final benBrown = Contact(id: 7, firstName: 'Ben', lastName: 'Brown');
final carolCarter = Contact(id: 8, firstName: 'Carol', lastName: 'Carter');
final dianaDevito = Contact(id: 9, firstName: 'Diana', lastName: 'Devito');
final emilyEvans = Contact(id: 10, firstName: 'Emily', lastName: 'Evans');
final frankFisher = Contact(id: 11, firstName: 'Frank', lastName: 'Fisher');
final graceGreen = Contact(id: 12, firstName: 'Grace', lastName: 'Green');
final henryHall = Contact(id: 13, firstName: 'Henry', lastName: 'Hall');
final isaacIngram = Contact(id: 14, firstName: 'Isaac', lastName: 'Ingram');
final juliaJackson = Contact(id: 15, firstName: 'Julia', lastName: 'Jackson');
final kevinKelly = Contact(id: 16, firstName: 'Kevin', lastName: 'Kelly');
final lindaLewis = Contact(id: 17, firstName: 'Linda', lastName: 'Lewis');
final michaelMiller = Contact(id: 18, firstName: 'Michael', lastName: 'Miller');
final nancyNewman = Contact(id: 19, firstName: 'Nancy', lastName: 'Newman');
final oliverOwens = Contact(id: 20, firstName: 'Oliver', lastName: 'Owens');
final penelopeParker = Contact(
  id: 21,
  firstName: 'Penelope',
  lastName: 'Parker',
);
final quentinQuinn = Contact(id: 22, firstName: 'Quentin', lastName: 'Quinn');
final rachelReed = Contact(id: 23, firstName: 'Rachel', lastName: 'Reed');
final samuelSmith = Contact(id: 24, firstName: 'Samuel', lastName: 'Smith');
final tessaTurner = Contact(id: 25, firstName: 'Tessa', lastName: 'Turner');
final umbertoUpton = Contact(id: 26, firstName: 'Umberto', lastName: 'Upton');
final victoriaVance = Contact(id: 27, firstName: 'Victoria', lastName: 'Vance');
final williamWilson = Contact(id: 28, firstName: 'William', lastName: 'Wilson');
final xavierXu = Contact(id: 29, firstName: 'Xavier', lastName: 'Xu');
final yasmineYoung = Contact(id: 30, firstName: 'Yasmine', lastName: 'Young');
final zacharyZimmerman = Contact(
  id: 31,
  firstName: 'Zachary',
  lastName: 'Zimmerman',
);
final elizabethMJohnson = Contact(
  id: 32,
  firstName: 'Elizabeth',
  middleName: 'M.',
  lastName: 'Johnson',
);
final robertLWilliamsSr = Contact(
  id: 33,
  firstName: 'Robert',
  middleName: 'L.',
  lastName: 'Williams',
  suffix: 'Sr.',
);
final margaretAnneDavis = Contact(
  id: 34,
  firstName: 'Margaret',
  middleName: 'Anne',
  lastName: 'Davis',
);
final williamJamesBrownIII = Contact(
  id: 35,
  firstName: 'William',
  middleName: 'James',
  lastName: 'Brown',
  suffix: 'III',
);
final maryElizabethClark = Contact(
  id: 36,
  firstName: 'Mary',
  middleName: 'Elizabeth',
  lastName: 'Clark',
);
final drSarahWatson = Contact(
  id: 37,
  firstName: 'Dr. Sarah',
  lastName: 'Watson',
);
final jamesRSmithEsq = Contact(
  id: 38,
  firstName: 'James',
  middleName: 'R.',
  lastName: 'Smith',
  suffix: 'Esq.',
);
final mariaCruz = Contact(id: 39, firstName: 'Maria', lastName: 'Cruz');
final pierreMartin = Contact(id: 40, firstName: 'Pierre', lastName: 'Martin');
final yukiTanaka = Contact(id: 41, firstName: 'Yuki', lastName: 'Tanaka');
final hansSchmidt = Contact(id: 42, firstName: 'Hans', lastName: 'Schmidt');
final priyaPatel = Contact(id: 43, firstName: 'Priya', lastName: 'Patel');
final carlosGarcia = Contact(id: 44, firstName: 'Carlos', lastName: 'Garcia');
final ninaVolkova = Contact(id: 45, firstName: 'Nina', lastName: 'Volkova');
final jenniferAdams = Contact(id: 46, firstName: 'Jennifer', lastName: 'Adams');
final michaelBaker = Contact(id: 47, firstName: 'Michael', lastName: 'Baker');
final sarahCooper = Contact(id: 48, firstName: 'Sarah', lastName: 'Cooper');
final christopherDaniel = Contact(
  id: 49,
  firstName: 'Christopher',
  lastName: 'Daniel',
);
final jessicaEdwards = Contact(
  id: 50,
  firstName: 'Jessica',
  lastName: 'Edwards',
);
*]

[* -
final Set<Contact> allContacts = {
  johnAppleseed,
  kateBell,
  annaHaro,
  danielHiggins,
  davidTaylor,
  hankZakroff,
  alexAnderson,
  benBrown,
  carolCarter,
  dianaDevito,
  emilyEvans,
  frankFisher,
  graceGreen,
  henryHall,
  isaacIngram,
  juliaJackson,
  kevinKelly,
  lindaLewis,
  michaelMiller,
  nancyNewman,
  oliverOwens,
  penelopeParker,
  quentinQuinn,
  rachelReed,
  samuelSmith,
  tessaTurner,
  umbertoUpton,
  victoriaVance,
  williamWilson,
  xavierXu,
  yasmineYoung,
  zacharyZimmerman,
  elizabethMJohnson,
  robertLWilliamsSr,
  margaretAnneDavis,
  williamJamesBrownIII,
  maryElizabethClark,
  drSarahWatson,
  jamesRSmithEsq,
  mariaCruz,
  pierreMartin,
  yukiTanaka,
  hansSchmidt,
  priyaPatel,
  carlosGarcia,
  ninaVolkova,
  jenniferAdams,
  michaelBaker,
  sarahCooper,
  christopherDaniel,
  jessicaEdwards,
};
*]
```

Estes dados de exemplo incluem contatos com e sem nomes do meio e sufixos.
Isso oferece uma variedade de dados para trabalhar enquanto você constrói a UI.

#### Dados de ContactGroup {:#contactgroup-data}

Agora, crie os grupos de contatos que organizam seus contatos em listas.
Crie um novo arquivo `lib/data/contact_group.dart` e
adicione a classe `ContactGroup`:

<?code-excerpt "fwe/rolodex/lib/step1_advanced_ui/data/contact_group.dart (contact_group_class)"?>
```dart
import 'dart:collection';

import 'package:cupertino_ui/cupertino_ui.dart';

import 'contact.dart';

class ContactGroup {
  factory ContactGroup({
    required int id,
    required String label,
    bool permanent = false,
    String? title,
    List<Contact>? contacts,
  }) {
    final contactsCopy = contacts ?? <Contact>[];
    _sortContacts(contactsCopy);
    return ContactGroup._internal(
      id: id,
      label: label,
      permanent: permanent,
      title: title,
      contacts: contactsCopy,
    );
  }

  ContactGroup._internal({
    required this.id,
    required this.label,
    this.permanent = false,
    String? title,
    List<Contact>? contacts,
  }) : title = title ?? label,
       _contacts = contacts ?? const <Contact>[];

  final int id;
  final bool permanent;
  final String label;
  final String title;
  final List<Contact> _contacts;

  List<Contact> get contacts => _contacts;

  AlphabetizedContactMap get alphabetizedContacts {
    final contactsMap = AlphabetizedContactMap();
    for (final contact in _contacts) {
      final lastInitial = contact.lastName[0].toUpperCase();
      if (contactsMap.containsKey(lastInitial)) {
        contactsMap[lastInitial]!.add(contact);
      } else {
        contactsMap[lastInitial] = [contact];
      }
    }
    return contactsMap;
  }
}
```

Um `ContactGroup` representa uma coleção de contatos,
como "All Contacts" ou "Favorites".

Adicione o seguinte código auxiliar e dados de exemplo a `lib/data/contact_group.dart`:

<?code-excerpt "fwe/rolodex/lib/step1_advanced_ui/data/contact_group.dart (helper_code)"?>
```dart
typedef AlphabetizedContactMap = SplayTreeMap<String, List<Contact>>;

/// Sorts a list of [contacts] alphabetically by
/// last name, then first name, then middle name.
/// If names are identical, sorts by contact ID to ensure consistent ordering.
void _sortContacts(List<Contact> contacts) {
  contacts.sort((a, b) {
    final checkLastName = a.lastName.compareTo(b.lastName);
    if (checkLastName != 0) {
      return checkLastName;
    }
    final checkFirstName = a.firstName.compareTo(b.firstName);
    if (checkFirstName != 0) {
      return checkFirstName;
    }
    if (a.middleName != null && b.middleName != null) {
      final checkMiddleName = a.middleName!.compareTo(b.middleName!);
      if (checkMiddleName != 0) {
        return checkMiddleName;
      }
    } else if (a.middleName != null || b.middleName != null) {
      return a.middleName != null ? 1 : -1;
    }

    // If both contacts have the exact same name, order by first created.
    return a.id.compareTo(b.id);
  });
}

final allPhone = ContactGroup(
  id: 0,
  permanent: true,
  label: 'All iPhone',
  title: 'iPhone',
  contacts: allContacts.toList(),
);

final friends = ContactGroup(
  id: 1,
  label: 'Friends',
  contacts: [allContacts.elementAt(3)],
);

final work = ContactGroup(id: 2, label: 'Work');

List<ContactGroup> generateSeedData() {
  return [allPhone, friends, work];
}
```

Este código cria três grupos de exemplo e uma função para
gerar os dados iniciais do app.

Por fim, adicione uma classe que gerencia mudanças de estado a `lib/data/contact_group.dart`:

<?code-excerpt "fwe/rolodex/lib/step1_advanced_ui/data/contact_group.dart (model_class)"?>
```dart
class ContactGroupsModel {
  ContactGroupsModel() : _listsNotifier = ValueNotifier(generateSeedData());

  final ValueNotifier<List<ContactGroup>> _listsNotifier;

  ValueNotifier<List<ContactGroup>> get listsNotifier => _listsNotifier;

  List<ContactGroup> get lists => _listsNotifier.value;

  ContactGroup findContactList(int id) {
    return lists[id];
  }

  void dispose() {
    _listsNotifier.dispose();
  }
}
```

Se você não está familiarizado com `ValueNotifier`,
você deve concluir o [tutorial anterior sobre estado][previous tutorial covering state] antes de continuar,
que aborda gerenciamento de estado.

[previous tutorial covering state]: /learn/pathway/tutorial/set-up-state-project

### Conecte os dados ao seu app {:#connect-the-data-to-your-app}

Atualize seu `main.dart` para incluir o estado global e
importar o novo arquivo de dados:

<?code-excerpt "fwe/rolodex/lib/step1_advanced_ui/main.dart"?>
```dart
import 'package:cupertino_ui/cupertino_ui.dart';

import 'data/contact_group.dart';

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
      home: CupertinoPageScaffold(child: Center(child: Text('Hello Rolodex!'))),
    );
  }
}
```

Com todo o código acessório fora do caminho, na próxima lição,
você começará a construir o app de verdade.

[`cupertino_ui` package]: {{site.pub-pkg}}/cupertino_ui
[`cupertino_icons` package]: {{site.pub-pkg}}/cupertino_icons

### Revisão {:#review}

<SummaryCard>
title: O que você realizou
subtitle: Aqui está um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Pré-visualizou o app Rolodex
    icon: preview
    details: >-
      Você está começando uma nova seção do tutorial focada em recursos avançados de UI.
      Para fazer seu app parecer refinado e nativo em qualquer dispositivo,
      você aprenderá layouts adaptativos, slivers, navegação e temas.
  - title: Configurou um projeto com widgets Cupertino
    icon: phone_iphone
    details: >-
      Diferentemente das lições anteriores,
      este app usa `CupertinoApp` em vez de `MaterialApp`.
      O design system Cupertino fornece widgets no estilo iOS que
      parecem nativos em dispositivos Apple.
  - title: Criou modelos de dados para contatos e grupos
    icon: data_object
    details: >-
      Você criou as classes `Contact` e `ContactGroup` com dados de exemplo,
      além de um `ContactGroupsModel` para gerenciamento de estado.
      Essa base sustenta a UI que você construirá nas próximas lições.
</SummaryCard>

### Teste seus conhecimentos {:#test-yourself}

<Quiz title="Quiz de configuração de UI avançada">
- question: Qual é a principal diferença entre CupertinoApp e MaterialApp?
  options:
    - text: CupertinoApp só funciona em dispositivos iOS.
      correct: false
      explanation: CupertinoApp pode ser executado em qualquer plataforma; ele apenas fornece widgets no estilo iOS.
    - text: CupertinoApp fornece widgets e estilos no estilo iOS, enquanto MaterialApp fornece widgets do Material Design.
      correct: true
      explanation: CupertinoApp usa widgets do design system Cupertino que correspondem à aparência do iOS.
    - text: CupertinoApp é mais leve e tem melhor desempenho.
      correct: false
      explanation: Ambos têm desempenho semelhante; eles diferem no estilo visual, não na velocidade.
    - text: MaterialApp requer mais configuração para ser configurado.
      correct: false
      explanation: Ambos têm requisitos de configuração semelhantes; eles apenas usam design systems diferentes.
- question: Qual é o propósito de um ValueNotifier no gerenciamento de estado?
  options:
    - text: Validar valores de entrada do usuário.
      correct: false
      explanation: ValueNotifier armazena e notifica sobre mudanças de valor, não faz validação.
    - text: Armazenar um único valor e notificar os listeners quando esse valor muda.
      correct: true
      explanation: ValueNotifier é um ChangeNotifier simples que encapsula um único valor e notifica os listeners quando ele muda.
    - text: Converter valores entre diferentes tipos de dados.
      correct: false
      explanation: Conversão de tipos não é o propósito do ValueNotifier.
    - text: Armazenar valores permanentemente no armazenamento local.
      correct: false
      explanation: ValueNotifier mantém valores em memória; persistência requer implementação separada.
</Quiz>
