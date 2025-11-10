---
title: Migrate to Material 3
description: >-
  Learn how to migrate your Flutter app's UI from Material 2 to Material 3.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

A biblioteca Material foi atualizada para corresponder à especificação de Design Material 3.
As mudanças incluem novos componentes e temas de componentes, visuais de componentes atualizados,
e muito mais. Muitas dessas atualizações são perfeitas. Você verá a nova versão
de um widget afetado ao recompilar seu app contra a versão 3.16 (ou posterior).
Mas algum trabalho manual também é necessário para completar a migração.

## Migration guide

Antes da versão 3.16, você podia optar pelas mudanças do Material 3
definindo a flag `useMaterial3` como true. A partir da versão 3.16 do Flutter
(Novembro 2023), `useMaterial3` é true por padrão.

A propósito, você _pode_ reverter para o comportamento Material 2 no seu app definindo
`useMaterial3` como `false`. No entanto, esta é apenas uma solução temporária. A
flag `useMaterial3` _e_ a implementação Material 2 eventualmente serão
removidas como parte da política de descontinuação do Flutter.

### Colors

Os valores padrão para `ThemeData.colorScheme` são atualizados para corresponder
à especificação de Design Material 3.

O construtor `ColorScheme.fromSeed` gera um `ColorScheme`
derivado da `seedColor` fornecida. As cores geradas por este
construtor são projetadas para funcionar bem juntas e atender aos requisitos de contraste
para acessibilidade no sistema de Design Material 3.

Ao atualizar para a versão 3.16, sua UI pode parecer um pouco estranha
sem o `ColorScheme` correto. Para corrigir isso, migre para o
`ColorScheme` gerado a partir do construtor `ColorScheme.fromSeed`.

Code before migration:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.light(primary: Colors.blue),
),
```

Code after migration:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
),
```

Para gerar um esquema de cores dinâmico baseado em conteúdo, use o
método estático `ColorScheme.fromImageProvider`. Para um exemplo de geração de um
esquema de cores, confira o exemplo [`ColorScheme` from a network image][].

[`ColorScheme` from a network image]: {{site.api}}/flutter/material/ColorScheme/fromImageProvider.html

As mudanças no Flutter Material 3 incluem uma nova cor de fundo.
`ColorScheme.surfaceTint` indica um widget elevado.
Alguns widgets usam cores diferentes.

Para retornar a UI do seu app ao comportamento anterior (o que não recomendamos):

* Defina `Colors.grey[50]!` para `ColorScheme.background`
  (quando o tema for `Brightness.light`).
* Defina  `Colors.grey[850]!` para `ColorScheme.background`
  (quando o tema for `Brightness.dark`).

Code before migration:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
),
```

Code after migration:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
    background: Colors.grey[50]!,
  ),
),
```

```dart
darkTheme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.dark,
  ).copyWith(background: Colors.grey[850]!),
),
```

O valor `ColorScheme.surfaceTint` indica a elevação de um componente no
Material 3. Alguns widgets podem usar tanto `surfaceTint` quanto `shadowColor` para
indicar elevação (por exemplo, `Card` e `ElevatedButton`) e outros podem
usar apenas `surfaceTint` para indicar elevação (como `AppBar`).

Para retornar ao comportamento anterior do widget, defina `Colors.transparent`
para `ColorScheme.surfaceTint` no tema. Para diferenciar a sombra de um widget
do conteúdo (quando não tiver sombra), defina a cor `ColorScheme.shadow` para a
propriedade `shadowColor` no tema do widget sem uma cor de sombra padrão.

Code before migration:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
),
```

Code after migration:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
    surfaceTint: Colors.transparent,
  ),
  appBarTheme: AppBarTheme(
   elevation: 4.0,
   shadowColor: Theme.of(context).colorScheme.shadow,
 ),
),
```

O `ElevatedButton` agora se estiliza com uma nova combinação de cores.
Anteriormente, quando a flag `useMaterial3` estava definida como false, `ElevatedButton`
se estilizava com `ColorScheme.primary` para o fundo e
`ColorScheme.onPrimary` para o foreground. Para alcançar os mesmos visuais, mude
para o novo widget `FilledButton` sem as mudanças de elevação ou sombra.

Code before migration:

```dart
ElevatedButton(
  onPressed: () {},
  child: const Text('Button'),
),
```

Code after migration:

```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
  ),
  onPressed: () {},
  child: const Text('Button'),
),
```

### Typography

Os valores padrão para `ThemeData.textTheme` são atualizados para corresponder aos
padrões Material 3. As mudanças incluem tamanho de fonte atualizado, peso de fonte, espaçamento
de letras e altura de linha. Para mais detalhes, confira a documentação [`TextTheme`][].

Conforme mostrado no exemplo a seguir, antes da versão 3.16, quando um widget `Text`
com uma string longa usando `TextTheme.bodyLarge` em um layout restrito
quebrava o texto em duas linhas. No entanto, a versão 3.16 quebra o texto em
três linhas. Se você deve alcançar o comportamento anterior, ajuste o estilo do texto
e, se necessário, o espaçamento de letras.

Code before migration:

```dart
 ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: 200),
    child: Text(
      'This is a very long text that should wrap to multiple lines.',
      style: Theme.of(context).textTheme.bodyLarge,
  ),
),
```

Code after migration:

```dart
 ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: 200),
    child: Text(
      'This is a very long text that should wrap to multiple lines.',
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        letterSpacing: 0.0,
      ),
  ),
),
```

[`TextTheme`]: {{site.api}}/flutter/material/TextTheme-class.html

### Components

Alguns componentes não puderam meramente ser atualizados para corresponder à especificação de Design Material 3
mas precisaram de uma implementação completamente nova. Tais componentes requerem migração manual
já que o Flutter SDK não sabe exatamente o que você quer.

Substitua o widget [`BottomNavigationBar`][] estilo Material 2 pelo novo
widget [`NavigationBar`][]. É um pouco mais alto, contém
indicadores de navegação em forma de pílula e usa novos mapeamentos de cores.

Code before migration:

```dart
BottomNavigationBar(
  items: const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.business),
      label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.school),
      label: 'School',
    ),
  ],
),
```

Code after migration:

```dart
NavigationBar(
  destinations: const <Widget>[
    NavigationDestination(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.business),
      label: 'Business',
    ),
    NavigationDestination(
      icon: Icon(Icons.school),
      label: 'School',
    ),
  ],
),
```

Confira o exemplo completo sobre
[migrating from `BottomNavigationBar` to `NavigationBar`][].

Substitua o widget [`Drawer`][] por [`NavigationDrawer`][], que fornece
indicadores de navegação em forma de pílula, cantos arredondados e novos mapeamentos de cores.

Code before migration:

```dart
Drawer(
  child: ListView(
    children: <Widget>[
      DrawerHeader(
        child: Text(
          'Drawer Header',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      ListTile(
        leading: const Icon(Icons.message),
        title: const Text('Messages'),
        onTap: () { },
      ),
      ListTile(
        leading: const Icon(Icons.account_circle),
        title: const Text('Profile'),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.settings),
        title: const Text('Settings'),
        onTap: () { },
      ),
    ],
  ),
),
```

Code after migration:

```dart
NavigationDrawer(
  children: <Widget>[
    DrawerHeader(
      child: Text(
        'Drawer Header',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    ),
    const NavigationDrawerDestination(
      icon: Icon(Icons.message),
      label: Text('Messages'),
    ),
    const NavigationDrawerDestination(
      icon: Icon(Icons.account_circle),
      label: Text('Profile'),
    ),
    const NavigationDrawerDestination(
      icon: Icon(Icons.settings),
      label: Text('Settings'),
    ),
  ],
),
```

Confira o exemplo completo sobre
[migrating from `Drawer` to `NavigationDrawer`][].

O Material 3 introduz app bars médios e grandes que exibem um título maior
antes de rolar. Em vez de uma sombra, a cor `ColorScheme.surfaceTint`
é usada para criar uma separação do conteúdo ao rolar.

O código a seguir demonstra como implementar a app bar média:

```dart
CustomScrollView(
  slivers: <Widget>[
    const SliverAppBar.medium(
      title: Text('Title'),
    ),
    SliverToBoxAdapter(
      child: Card(
        child: SizedBox(
          height: 1200,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 100, 8, 100),
            child: Text(
              'Here be scrolling content...',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
      ),
    ),
  ],
),
```

Agora existem dois tipos de widgets [`TabBar`][]: primário e secundário.
Abas secundárias são usadas dentro de uma área de conteúdo para separar ainda mais
conteúdo relacionado e estabelecer hierarquia. Confira o exemplo [`TabBar.secondary`][].

A nova propriedade [`TabBar.tabAlignment`][] especifica o alinhamento horizontal
das abas.

O exemplo a seguir mostra como modificar o alinhamento de aba em um `TabBar` rolável:

```dart
AppBar(
  title: const Text('Title'),
  bottom: const TabBar(
    tabAlignment: TabAlignment.start,
    isScrollable: true,
    tabs: <Widget>[
      Tab(
        icon: Icon(Icons.cloud_outlined),
      ),
      Tab(
        icon: Icon(Icons.beach_access_sharp),
      ),
      Tab(
        icon: Icon(Icons.brightness_5_sharp),
      ),
    ],
  ),
),
```

[`SegmentedButton`][], uma versão atualizada de [`ToggleButtons`][],
usa cantos totalmente arredondados, difere em altura e
tamanho de layout, e usa um `Set` Dart para determinar itens selecionados.

Code before migration:

```dart
enum Weather { cloudy, rainy, sunny }

ToggleButtons(
  isSelected: const [false, true, false],
  onPressed: (int newSelection) { },
  children: const <Widget>[
    Icon(Icons.cloud_outlined),
    Icon(Icons.beach_access_sharp),
    Icon(Icons.brightness_5_sharp),
  ],
),
```

Code after migration:

```dart
enum Weather { cloudy, rainy, sunny }

SegmentedButton<Weather>(
  selected: const <Weather>{Weather.rainy},
  onSelectionChanged: (Set<Weather> newSelection) { },
  segments: const <ButtonSegment<Weather>>[
    ButtonSegment(
      icon: Icon(Icons.cloud_outlined),
      value: Weather.cloudy,
    ),
    ButtonSegment(
      icon: Icon(Icons.beach_access_sharp),
      value: Weather.rainy,
    ),
    ButtonSegment(
      icon: Icon(Icons.brightness_5_sharp),
      value: Weather.sunny,
    ),
  ],
),
```

Confira o exemplo completo sobre
[migrating from `ToggleButtons` to `SegmentedButton`][].

[migrating from `BottomNavigationBar` to `NavigationBar`]: {{site.api}}/flutter/material/BottomNavigationBar-class.html#material.BottomNavigationBar.2
[migrating from `Drawer` to `NavigationDrawer`]: {{site.api}}/flutter/material/Drawer-class.html#material.Drawer.2
[migrating from `ToggleButtons` to `SegmentedButton`]: {{site.api}}/flutter/material/ToggleButtons-class.html#material.ToggleButtons.1

#### New components

 * "Menu bars and cascading menus" fornecem um sistema de menu estilo desktop que é
    totalmente navegável com o mouse ou teclado. Os menus são ancorados por
    um [`MenuBar`][] ou um [`MenuAnchor`][]. O novo sistema de menu não é
    algo que aplicações existentes devam migrar, no entanto
    aplicações que são implantadas na web ou em plataformas desktop
    devem considerar usá-lo em vez das classes `PopupMenuButton` (e relacionadas).
 * [`DropdownMenu`][] combina um campo de texto e um menu para
    produzir o que às vezes é chamado de _combo box_. Os usuários podem selecionar
    um item de menu de uma lista potencialmente grande inserindo uma
    string correspondente ou interagindo com o menu com toque, mouse,
    ou teclado. Isso pode ser um bom substituto para o widget `DropdownButton`,
    embora não seja necessário.
 * [`SearchBar`][] e [`SearchAnchor`][] são para interações onde o
    usuário insere uma consulta de pesquisa, o app calcula uma lista de
    respostas correspondentes e então o usuário seleciona uma ou ajusta a
    consulta.
 * [`Badge`][] decora seu filho com um pequeno rótulo de apenas alguns
    caracteres. Como '+1'. Badges são tipicamente usados para decorar o ícone
    dentro de um `NavigationDestination`, um `NavigationRailDestination`,
    um `NavigationDrawerDestination`, ou o ícone de um botão, como em
    `TextButton.icon`.
 * [`FilledButton`] e [`FilledButton.tonal`][] são muito similares a um
    `ElevatedButton` sem as mudanças de elevação e sombra.
 * [`FilterChip.elevated`][], [`ChoiceChip.elevated`][], e
    [`ActionChip.elevated`] são variantes elevadas dos mesmos chips
    com uma sombra e uma cor de preenchimento.
 * [`Dialog.fullscreen`][]  preenche a tela inteira e
    tipicamente contém um título, um botão de ação e um botão de fechar
    no topo.

[`BottomNavigationBar`]: {{site.api}}/flutter/material/BottomNavigationBar-class.html
[`NavigationBar`]: {{site.api}}/flutter/material/NavigationBar-class.html
[`Drawer`]: {{site.api}}/flutter/material/Drawer-class.html
[`NavigationDrawer`]: {{site.api}}/flutter/material/NavigationDrawer-class.html
[`TabBar`]: {{site.api}}/flutter/material/TabBar-class.html
[`TabBar.secondary`]: {{site.api}}/flutter/material/TabBar/TabBar.secondary.html
[`TabBar.tabAlignment`]: {{site.api}}/flutter/material/TabBar/tabAlignment.html
[`SegmentedButton`]: {{site.api}}/flutter/material/SegmentedButton-class.html
[`ToggleButtons`]: {{site.api}}/flutter/material/ToggleButtons-class.html
[`MenuBar`]: {{site.api}}/flutter/material/MenuBar-class.html
[`MenuAnchor`]: {{site.api}}/flutter/material/MenuAnchor-class.html
[`DropdownMenu`]: {{site.api}}/flutter/material/DropdownMenu-class.html
[`SearchBar`]: {{site.api}}/flutter/material/SearchBar-class.html
[`SearchAnchor`]: {{site.api}}/flutter/material/SearchAnchor-class.html
[`Badge`]: {{site.api}}/flutter/material/Badge-class.html
[`FilledButton`]: {{site.api}}/flutter/material/FilledButton-class.html
[`FilledButton.tonal`]: {{site.api}}/flutter/material/FilledButton/FilledButton.tonal.html
[`FilterChip.elevated`]: {{site.api}}/flutter/material/FilterChip/FilterChip.elevated.html
[`ChoiceChip.elevated`]: {{site.api}}/flutter/material/ChoiceChip/ChoiceChip.elevated.html
[`ActionChip.elevated`]: {{site.api}}/flutter/material/ActionChip/ActionChip.elevated.html
[`Dialog.fullscreen`]: {{site.api}}/flutter/material/Dialog/Dialog.fullscreen.html

## Timeline

In stable release: 3.16

## References

Documentation:

* [Material Design for Flutter][]

API documentation:

* [`ThemeData.useMaterial3`][]

Relevant issues:

* [Material 3 umbrella issue][]

Relevant PRs:

* [Change the default for `ThemeData.useMaterial3` to true][]
* [Updated `ThemeData.useMaterial3` API doc, default is true][]


[Material 3 umbrella issue]: {{site.repo.flutter}}/issues/91605
[Material Design for Flutter]: /ui/design/material
[`ThemeData.useMaterial3`]: {{site.api}}/flutter/material/ThemeData/useMaterial3.html
[Change the default for `ThemeData.useMaterial3` to true]: {{site.repo.flutter}}/pull/129724
[Updated `ThemeData.useMaterial3` API doc, default is true]: {{site.repo.flutter}}/pull/130764
