---
ia-translate: true
title: Migrar para Material 3
description: >-
  Aprenda como migrar a interface de usuário do seu aplicativo Flutter de Material 2 para Material 3.
---

## Sumário

A biblioteca Material foi atualizada para corresponder à especificação do Design Material 3.
As mudanças incluem novos componentes e temas de componentes, visuais de componentes atualizados
e muito mais. Muitas dessas atualizações são contínuas. Você verá a nova versão
de um widget afetado ao recompilar seu aplicativo na versão 3.16 (ou posterior).
Mas algum trabalho manual também é necessário para concluir a migração.

## Guia de migração

Antes da versão 3.16, você podia optar pelas mudanças do Material 3
definindo o sinalizador `useMaterial3` como verdadeiro. A partir da versão
Flutter 3.16 (novembro de 2023), `useMaterial3` é verdadeiro por padrão.

A propósito, você _pode_ reverter para o comportamento do Material 2 em seu
aplicativo definindo `useMaterial3` como `false`. No entanto, esta é apenas uma
solução temporária. O sinalizador `useMaterial3` _e_ a implementação do
Material 2 serão eventualmente removidos como parte da política de depreciação do
Flutter.

### Cores

Os valores padrão para `ThemeData.colorScheme` são atualizados para
corresponder à especificação do Design Material 3.

O construtor `ColorScheme.fromSeed` gera um `ColorScheme`
derivado da `seedColor` fornecida. As cores geradas por este
construtor são projetadas para funcionar bem juntas e atender aos requisitos
de contraste para acessibilidade no sistema Design Material 3.

Ao atualizar para a versão 3.16, sua interface de usuário pode parecer um
pouco estranha sem o `ColorScheme` correto. Para corrigir isso, migre para o
`ColorScheme` gerado a partir do construtor `ColorScheme.fromSeed`.

Código antes da migração:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.light(primary: Colors.blue),
),
```

Código após a migração:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
),
```

Para gerar um esquema de cores dinâmico baseado em conteúdo, use o método
estático `ColorScheme.fromImageProvider`. Para obter um exemplo de geração de
um esquema de cores, confira o exemplo [`ColorScheme` a partir de uma imagem de rede][].

[`ColorScheme` a partir de uma imagem de rede]: {{site.api}}/flutter/material/ColorScheme/fromImageProvider.html

As mudanças no Flutter Material 3 incluem uma nova cor de fundo.
`ColorScheme.surfaceTint` indica um widget elevado.
Alguns widgets usam cores diferentes.

Para retornar a interface do seu aplicativo ao seu comportamento anterior (o que não recomendamos):

* Defina `Colors.grey[50]!` para `ColorScheme.background`
  (quando o tema é `Brightness.light`).
* Defina `Colors.grey[850]!` para `ColorScheme.background`
  (quando o tema é `Brightness.dark`).

Código antes da migração:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
),
```

Código após a migração:

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
Material 3. Alguns widgets podem usar `surfaceTint` e `shadowColor` para indicar
a elevação (por exemplo, `Card` e `ElevatedButton`) e outros podem usar apenas
`surfaceTint` para indicar elevação (como `AppBar`).

Para retornar ao comportamento anterior do widget, defina `Colors.transparent`
para `ColorScheme.surfaceTint` no tema. Para diferenciar a sombra de um widget
do conteúdo (quando ele não tem sombra), defina a cor `ColorScheme.shadow`
para a propriedade `shadowColor` no tema do widget sem uma cor de sombra
padrão.

Código antes da migração:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
),
```

Código após a migração:

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
Anteriormente, quando o sinalizador `useMaterial3` estava definido como falso,
o `ElevatedButton` se estilava com `ColorScheme.primary` para o fundo e
`ColorScheme.onPrimary` para o primeiro plano. Para obter os mesmos visuais,
mude para o novo widget `FilledButton` sem as mudanças de elevação ou sombra
projetada.

Código antes da migração:

```dart
ElevatedButton(
  onPressed: () {},
  child: const Text('Button'),
),
```

Código após a migração:

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

### Tipografia

Os valores padrão para `ThemeData.textTheme` são atualizados para corresponder
aos padrões do Material 3. As mudanças incluem tamanho da fonte, peso da fonte,
espaçamento entre letras e altura da linha atualizados. Para mais detalhes,
confira a documentação [`TextTheme`][].

Como mostrado no exemplo a seguir, antes da versão 3.16, quando um widget `Text`
com uma string longa usando `TextTheme.bodyLarge` em um layout restrito
quebrava o texto em duas linhas. No entanto, a versão 3.16 quebra o texto em três
linhas. Se você precisar obter o comportamento anterior, ajuste o estilo do texto
e, se necessário, o espaçamento entre letras.

Código antes da migração:

```dart
ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: 200),
    child: Text(
      'This is a very long text that should wrap to multiple lines.',
      style: Theme.of(context).textTheme.bodyLarge,
  ),
),
```

Código após a migração:

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

### Componentes

Alguns componentes não puderam ser simplesmente atualizados para corresponder
à especificação do Design Material 3, mas precisaram de uma implementação
totalmente nova. Esses componentes exigem migração manual, pois o SDK do Flutter
não sabe o que, exatamente, você quer.

Substitua o widget `BottomNavigationBar` estilo Material 2 pelo novo widget
[`NavigationBar`][]. Ele é um pouco mais alto, contém indicadores de navegação
em forma de pílula e usa novos mapeamentos de cores.

Código antes da migração:

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

Código após a migração:

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
[como migrar de `BottomNavigationBar` para `NavigationBar`][].

Substitua o widget [`Drawer`][] por [`NavigationDrawer`][], que fornece
indicadores de navegação em forma de pílula, cantos arredondados e novos
mapeamentos de cores.

Código antes da migração:

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

Código após a migração:

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
[como migrar de `Drawer` para `NavigationDrawer`][].

O Material 3 introduz barras de aplicativos médias e grandes que exibem um
título maior antes de rolar. Em vez de uma sombra projetada, a cor
`ColorScheme.surfaceTint` é usada para criar uma separação do conteúdo ao rolar.

O código a seguir demonstra como implementar a barra de aplicativos média:

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

Agora, existem dois tipos de widgets [`TabBar`][]: primário e secundário.
As guias secundárias são usadas em uma área de conteúdo para separar ainda
mais o conteúdo relacionado e estabelecer hierarquia. Confira o exemplo
[`TabBar.secondary`][].

A nova propriedade [`TabBar.tabAlignment`][] especifica o alinhamento
horizontal das guias.

O exemplo a seguir mostra como modificar o alinhamento da guia em um `TabBar`
rolável:

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
usa cantos totalmente arredondados, difere em altura e tamanho do layout e
usa um `Set` Dart para determinar os itens selecionados.

Código antes da migração:

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

Código após a migração:

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
[como migrar de `ToggleButtons` para `SegmentedButton`][].

[como migrar de `BottomNavigationBar` para `NavigationBar`]: {{site.api}}/flutter/material/BottomNavigationBar-class.html#material.BottomNavigationBar.2
[como migrar de `Drawer` para `NavigationDrawer`]: {{site.api}}/flutter/material/Drawer-class.html#material.Drawer.2
[como migrar de `ToggleButtons` para `SegmentedButton`]: {{site.api}}/flutter/material/ToggleButtons-class.html#material.ToggleButtons.1

#### Novos componentes

 * "Barras de menu e menus em cascata" fornecem um sistema de menus estilo
   desktop que é totalmente percorrível com o mouse ou teclado. Os menus
   são ancorados por um [`MenuBar`][] ou um [`MenuAnchor`][]. O novo
   sistema de menus não é algo para o qual os aplicativos existentes devem
   migrar, no entanto, aplicativos que são implantados na web ou em
   plataformas desktop devem considerar usá-lo em vez das classes
   `PopupMenuButton` (e relacionadas).
 * [`DropdownMenu`][] combina um campo de texto e um menu para produzir o
   que às vezes é chamado de _caixa de combinação_. Os usuários podem
   selecionar um item de menu de uma lista potencialmente grande inserindo
   uma string correspondente ou interagindo com o menu com toque, mouse ou
   teclado. Esta pode ser uma boa substituição para o widget
   `DropdownButton`, embora não seja necessário.
 * [`SearchBar`][] e [`SearchAnchor`][] são para interações onde o usuário
   insere uma consulta de pesquisa, o aplicativo calcula uma lista de
   respostas correspondentes e, em seguida, o usuário seleciona uma ou
   ajusta a consulta.
 * [`Badge`][] decora seu filho com um pequeno rótulo de apenas alguns
   caracteres. Como '+1'. Os badges são normalmente usados para decorar o
   ícone dentro de um `NavigationDestination`, um `NavigationRailDestination`,
   um `NavigationDrawerDestination` ou o ícone de um botão, como em
   `TextButton.icon`.
 * [`FilledButton`] e [`FilledButton.tonal`][] são muito semelhantes a um
   `ElevatedButton` sem as mudanças de elevação e sombra projetada.
 * [`FilterChip.elevated`][], [`ChoiceChip.elevated`][] e
   [`ActionChip.elevated`] são variantes elevadas dos mesmos chips com
   uma sombra projetada e uma cor de preenchimento.
 * [`Dialog.fullscreen`][] preenche toda a tela e normalmente contém um
   título, um botão de ação e um botão de fechar na parte superior.

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

## Linha do tempo

Na versão estável: 3.16

## Referências

Documentação:

* [Material Design para Flutter][]

Documentação da API:

* [`ThemeData.useMaterial3`][]

Problemas relevantes:

* [Problema guarda-chuva do Material 3][]

PRs relevantes:

* [Alterar o padrão para `ThemeData.useMaterial3` para verdadeiro][]
* [Documento da API `ThemeData.useMaterial3` atualizado, o padrão é verdadeiro][]


[Problema guarda-chuva do Material 3]: {{site.repo.flutter}}/issues/91605
[Material Design para Flutter]: /ui/design/material
[`ThemeData.useMaterial3`]: {{site.api}}/flutter/material/ThemeData/useMaterial3.html
[Alterar o padrão para `ThemeData.useMaterial3` para verdadeiro]: {{site.repo.flutter}}/pull/129724
[Documento da API `ThemeData.useMaterial3` atualizado, o padrão é verdadeiro]: {{site.repo.flutter}}/pull/130764
