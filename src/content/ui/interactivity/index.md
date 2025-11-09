---
ia-translate: true
title: Adicionar interatividade ao seu app Flutter
description: Como implementar um stateful widget que responde a toques.
shortTitle: Interatividade
---

{% assign examples = site.repo.this | append: "/tree/" | append: site.branch | append: "/examples" -%}

:::secondary O que você aprenderá
* Como responder a toques.
* Como criar um widget personalizado.
* A diferença entre widgets stateless e stateful.
:::

Como você modifica seu app para que ele reaja à entrada do usuário?
Neste tutorial, você adicionará interatividade a um app que
contém apenas widgets não-interativos.
Especificamente, você modificará um ícone para torná-lo tocável
criando um stateful widget personalizado que gerencia dois
stateless widgets.

O [tutorial de construção de layouts][building layouts tutorial] mostrou como criar
o layout para a seguinte captura de tela.

<DashImage figure img-class="site-mobile-screenshot border" image="ui/layout/lakes.jpg" caption="The layout tutorial app" />

Quando o app é iniciado pela primeira vez, a estrela é vermelha sólida,
indicando que este lago foi previamente favoritado.
O número ao lado da estrela indica que 41
pessoas favoritaram este lago. Após completar este tutorial,
tocar na estrela remove seu status de favoritado,
substituindo a estrela sólida por um contorno e
diminuindo a contagem. Tocar novamente favorita o lago,
desenhando uma estrela sólida e aumentando a contagem.

<DashImage figure image="ui/favorited-not-favorited.png" alt="The custom widget you'll create" img-class="diagram-wrap" />

Para realizar isso, você criará um único widget personalizado
que inclui tanto a estrela quanto a contagem,
que são eles mesmos widgets. Tocar na estrela muda o estado
para ambos os widgets, então o mesmo widget deve gerenciar ambos.

Você pode ir direto para tocar no código em
[Step 2: Subclass StatefulWidget](#step-2).
Se você quiser experimentar diferentes formas de gerenciar estado,
pule para [Gerenciando estado][Managing state].

## Widgets stateful e stateless

Um widget é ou stateful ou stateless. Se um widget pode
mudar&mdash;quando um usuário interage com ele,
por exemplo&mdash;ele é stateful.

Um widget _stateless_ nunca muda.
[`Icon`][`Icon`], [`IconButton`][`IconButton`], e [`Text`][`Text`] são
exemplos de widgets stateless. Widgets stateless
são subclasses de [`StatelessWidget`][`StatelessWidget`].

Um widget _stateful_ é dinâmico: por exemplo,
ele pode mudar sua aparência em resposta a eventos
disparados por interações do usuário ou quando recebe dados.
[`Checkbox`][`Checkbox`], [`Radio`][`Radio`], [`Slider`][`Slider`],
[`InkWell`][`InkWell`], [`Form`][`Form`], e [`TextField`][`TextField`]
são exemplos de widgets stateful. Widgets stateful
são subclasses de [`StatefulWidget`][`StatefulWidget`].

O estado de um widget é armazenado em um objeto [`State`][`State`],
separando o estado do widget de sua aparência.
O estado consiste de valores que podem mudar, como o
valor atual de um slider ou se um checkbox está marcado.
Quando o estado do widget muda,
o objeto state chama `setState()`,
dizendo ao framework para redesenhar o widget.

## Criando um stateful widget

:::secondary Qual é a questão?

* Um stateful widget é implementado por duas classes:
  uma subclasse de `StatefulWidget` e uma subclasse de `State`.
* A classe state contém o estado mutável do widget e
  o método `build()` do widget.
* Quando o estado do widget muda, o objeto state chama
  `setState()`, dizendo ao framework para redesenhar o widget.

:::

Nesta seção, você criará um stateful widget personalizado.
Você substituirá dois widgets stateless&mdash;a estrela vermelha
sólida e a contagem numérica ao lado dela&mdash;com um único
stateful widget personalizado que gerencia uma linha com dois
widgets filhos: um `IconButton` e `Text`.

Implementar um stateful widget personalizado requer criar duas classes:

* Uma subclasse de `StatefulWidget` que define o widget.
* Uma subclasse de `State` que contém o estado para aquele
  widget e define o método `build()` do widget.

Esta seção mostra como construir um stateful widget,
chamado `FavoriteWidget`, para o app lakes.
Após a configuração, seu primeiro passo é escolher como o estado é
gerenciado para `FavoriteWidget`.

### Step 0: Prepare-se

Se você já construiu o app no
[tutorial de construção de layouts][building layouts tutorial],
pule para a próxima seção.

 1. Certifique-se de ter [configurado][set up] seu ambiente.
 1. [Crie um novo app Flutter][new-flutter-app].
 1. Substitua o arquivo `lib/main.dart` por [`main.dart`][`main.dart`].
 1. Substitua o arquivo `pubspec.yaml` por [`pubspec.yaml`][`pubspec.yaml`].
 1. Crie um diretório `images` no seu projeto, e adicione
    [`lake.jpg`][`lake.jpg`].

Uma vez que você tenha um dispositivo conectado e habilitado,
ou tenha iniciado o [simulador iOS][iOS simulator]
(parte da instalação do Flutter) ou o
[emulador Android][Android emulator] (parte da instalação do Android Studio),
você está pronto para começar!

<a id="step-1"></a>

### Step 1: Decida qual objeto gerencia o estado do widget

O estado de um widget pode ser gerenciado de várias formas,
mas em nosso exemplo o próprio widget,
`FavoriteWidget`, gerenciará seu próprio estado.
Neste exemplo, alternar a estrela é uma ação isolada
que não afeta o widget pai ou o resto da
UI, então o widget pode lidar com seu estado internamente.

Aprenda mais sobre a separação de widget e estado,
e como o estado pode ser gerenciado, em [Gerenciando estado][Managing state].

<a id="step-2"></a>

### Step 2: Crie uma subclasse de StatefulWidget

A classe `FavoriteWidget` gerencia seu próprio estado,
então ela sobrescreve `createState()` para criar um objeto `State`.
O framework chama `createState()`
quando quer construir o widget.
Neste exemplo, `createState()` retorna uma
instância de `_FavoriteWidgetState`,
que você implementará no próximo passo.

<?code-excerpt path-base="layout/lakes/interactive"?>

<?code-excerpt "lib/main.dart (favorite-widget)"?>
```dart
class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget({super.key});

  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}
```

:::note
Membros ou classes que começam com um underscore
(`_`) são privados. Para mais informações,
veja [Libraries and imports][Libraries and imports], uma seção na
[documentação da linguagem Dart][Dart language documentation].
:::

<a id="step-3"></a>

### Step 3: Crie uma subclasse de State

A classe `_FavoriteWidgetState` armazena os dados mutáveis
que podem mudar durante o tempo de vida do widget.
Quando o app é iniciado pela primeira vez, a UI exibe uma
estrela vermelha sólida, indicando que o lago tem status "favorite",
junto com 41 likes. Esses valores são armazenados nos
campos `_isFavorited` e `_favoriteCount`:

<?code-excerpt "lib/main.dart (favorite-state-fields)" replace="/(bool|int) .*/[!$&!]/g"?>
```dart
class _FavoriteWidgetState extends State<FavoriteWidget> {
  [!bool _isFavorited = true;!]
  [!int _favoriteCount = 41;!]
```

A classe também define um método `build()`,
que cria uma linha contendo um `IconButton` vermelho,
e `Text`. Você usa [`IconButton`][`IconButton`] (em vez de `Icon`)
porque ele tem uma propriedade `onPressed` que define
a função callback (`_toggleFavorite`) para lidar com um toque.
Você definirá a função callback a seguir.

<?code-excerpt "lib/main.dart (favorite-state-build)" replace="/build|icon.*|onPressed.*|child: Text.*/[!$&!]/g"?>
```dart
class _FavoriteWidgetState extends State<FavoriteWidget> {
  // ···
  @override
  Widget [!build!](BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(0),
          child: IconButton(
            padding: const EdgeInsets.all(0),
            alignment: Alignment.center,
            [!icon: (_isFavorited!]
                ? const Icon(Icons.star)
                : const Icon(Icons.star_border)),
            color: Colors.red[500],
            [!onPressed: _toggleFavorite,!]
          ),
        ),
        SizedBox(width: 18, child: SizedBox([!child: Text('$_favoriteCount'))),!]
      ],
    );
  }

  // ···
}
```

:::tip
Colocar o `Text` em um [`SizedBox`][`SizedBox`] e definir sua
largura previne um "salto" perceptível quando o texto muda
entre os valores de 40 e 41 &mdash; um salto
ocorreria de outra forma porque esses valores têm larguras diferentes.
:::

O método `_toggleFavorite()`, que é chamado quando o
`IconButton` é pressionado, chama `setState()`.
Chamar `setState()` é crítico, porque isso
diz ao framework que o estado do widget
mudou e que o widget deve ser redesenhado.
O argumento de função para `setState()` alterna a
UI entre esses dois estados:

* Um ícone `star` e o número 41
* Um ícone `star_border` e o número 40

<?code-excerpt "lib/main.dart (toggle-favorite)"?>
```dart
void _toggleFavorite() {
  setState(() {
    if (_isFavorited) {
      _favoriteCount -= 1;
      _isFavorited = false;
    } else {
      _favoriteCount += 1;
      _isFavorited = true;
    }
  });
}
```

<a id="step-4"></a>

### Step 4: Conecte o stateful widget na árvore de widgets

Adicione seu stateful widget personalizado à árvore de widgets no
método `build()` do app. Primeiro, localize o código que
cria o `Icon` e `Text`, e delete-o.
No mesmo local, crie o stateful widget:

<?code-excerpt path-base=""?>

```dart diff
  child: Row(
    children: [
      // ...
-     Icon(
-       Icons.star,
-       color: Colors.red[500],
-     ),
-     const Text('41'),
+     const FavoriteWidget(),
    ],
  ),
```

É isso! Quando você fizer hot reload do app,
o ícone de estrela agora deve responder a toques.

### Problemas?

Se você não conseguir fazer seu código rodar, procure no seu
IDE por possíveis erros. [Depurando apps Flutter][Debugging Flutter apps] pode ajudar.
Se você ainda não conseguir encontrar o problema,
verifique seu código contra o exemplo interativo lakes no GitHub.

{% comment %}
TODO: replace the following links with tabbed code panes.
{% endcomment -%}

* [`lib/main.dart`]({{site.repo.this}}/tree/{{site.branch}}/examples/layout/lakes/interactive/lib/main.dart)
* [`pubspec.yaml`]({{site.repo.this}}/tree/{{site.branch}}/examples/layout/lakes/interactive/pubspec.yaml)
* [`lakes.jpg`]({{site.repo.this}}/tree/{{site.branch}}/examples/layout/lakes/interactive/images/lake.jpg)

Se você ainda tiver dúvidas, consulte qualquer um dos canais da
[comunidade][community] de desenvolvedores.

---

O restante desta página cobre várias formas de gerenciar o estado de um widget,
e lista outros widgets interativos disponíveis.

## Gerenciando estado

:::secondary Qual é a questão?
* Existem diferentes abordagens para gerenciar estado.
* Você, como designer do widget, escolhe qual abordagem usar.
* Em caso de dúvida, comece gerenciando o estado no widget pai.
:::

Quem gerencia o estado do stateful widget? O próprio widget?
O widget pai? Ambos? Outro objeto?
A resposta é... depende. Existem várias formas válidas
de tornar seu widget interativo. Você, como designer do widget,
toma a decisão baseado em como você espera que seu widget seja usado.
Aqui estão as formas mais comuns de gerenciar estado:

* [O widget gerencia seu próprio estado](#self-managed)
* [O pai gerencia o estado do widget](#parent-managed)
* [Uma abordagem mista](#mix-and-match)

Como você decide qual abordagem usar?
Os seguintes princípios devem ajudá-lo a decidir:

* Se o estado em questão são dados do usuário,
  por exemplo o modo marcado ou desmarcado
  de um checkbox, ou a posição de um slider,
  então o estado é melhor gerenciado pelo widget pai.

* Se o estado em questão é estético,
  por exemplo uma animação, então o
  estado é melhor gerenciado pelo próprio widget.

Em caso de dúvida, comece gerenciando o estado no widget pai.

Daremos exemplos das diferentes formas de gerenciar estado
criando três exemplos simples: TapboxA, TapboxB,
e TapboxC. Os exemplos funcionam de forma similar&mdash;cada
um cria um container que, quando tocado, alterna entre uma
caixa verde ou cinza. O booleano `_active` determina a
cor: verde para ativo ou cinza para inativo.

<div class="side-by-side text-center">
  <div class="text-center">
    <img src='/assets/images/docs/ui/tapbox-active-state.png' class="simple-border" width="150px" alt="Active state">
    <img src='/assets/images/docs/ui/tapbox-inactive-state.png' class="simple-border" width="150px" alt="Inactive state">
  </div>
</div>

Esses exemplos usam [`GestureDetector`][`GestureDetector`] para capturar atividade
no `Container`.

<a id="self-managed" aria-hidden="true"></a>

### O widget gerencia seu próprio estado

Às vezes faz mais sentido para o widget
gerenciar seu estado internamente. Por exemplo,
[`ListView`][`ListView`] automaticamente rola quando seu
conteúdo excede a render box. A maioria dos desenvolvedores
usando `ListView` não quer gerenciar o comportamento de rolagem do `ListView`,
então `ListView` ele mesmo gerencia seu scroll offset.

A classe `_TapboxAState`:

* Gerencia o estado para `TapboxA`.
* Define o booleano `_active` que determina a
  cor atual da caixa.
* Define a função `_handleTap()`, que atualiza
  `_active` quando a caixa é tocada e chama a
  função `setState()` para atualizar a UI.
* Implementa todo o comportamento interativo para o widget.

<?code-excerpt path-base="ui/interactive/"?>

<?code-excerpt "lib/self_managed.dart"?>
```dart
import 'package:flutter/material.dart';

// TapboxA manages its own state.

//------------------------- TapboxA ----------------------------------

class TapboxA extends StatefulWidget {
  const TapboxA({super.key});

  @override
  State<TapboxA> createState() => _TapboxAState();
}

class _TapboxAState extends State<TapboxA> {
  bool _active = false;

  void _handleTap() {
    setState(() {
      _active = !_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: _active ? Colors.lightGreen[700] : Colors.grey[600],
        ),
        child: Center(
          child: Text(
            _active ? 'Active' : 'Inactive',
            style: const TextStyle(fontSize: 32, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

//------------------------- MyApp ----------------------------------

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter Demo')),
        body: const Center(child: TapboxA()),
      ),
    );
  }
}
```

<hr>

<a id="parent-managed"></a>

### O widget pai gerencia o estado do widget

Frequentemente faz mais sentido para o widget pai
gerenciar o estado e dizer ao seu widget filho quando atualizar.
Por exemplo, [`IconButton`][`IconButton`] permite que você trate
um ícone como um botão tocável. `IconButton` é um
widget stateless porque decidimos que o widget pai
precisa saber se o botão foi tocado,
para que possa tomar a ação apropriada.

No exemplo a seguir, TapboxB exporta seu estado
para seu pai através de um callback. Como TapboxB
não gerencia nenhum estado, ele é subclasse de StatelessWidget.

A classe ParentWidgetState:

* Gerencia o estado `_active` para TapboxB.
* Implementa `_handleTapboxChanged()`,
  o método chamado quando a caixa é tocada.
* Quando o estado muda, chama `setState()`
  para atualizar a UI.

A classe TapboxB:

* Estende StatelessWidget porque todo o estado é manipulado por seu pai.
* Quando um toque é detectado, ele notifica o pai.

<?code-excerpt "lib/parent_managed.dart"?>
```dart
import 'package:flutter/material.dart';

// ParentWidget manages the state for TapboxB.

//------------------------ ParentWidget --------------------------------

class ParentWidget extends StatefulWidget {
  const ParentWidget({super.key});

  @override
  State<ParentWidget> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  bool _active = false;

  void _handleTapboxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TapboxB(active: _active, onChanged: _handleTapboxChanged),
    );
  }
}

//------------------------- TapboxB ----------------------------------

class TapboxB extends StatelessWidget {
  const TapboxB({super.key, this.active = false, required this.onChanged});

  final bool active;
  final ValueChanged<bool> onChanged;

  void _handleTap() {
    onChanged(!active);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: active ? Colors.lightGreen[700] : Colors.grey[600],
        ),
        child: Center(
          child: Text(
            active ? 'Active' : 'Inactive',
            style: const TextStyle(fontSize: 32, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
```

<hr>

<a id="mix-and-match"></a>

### Uma abordagem mista

Para alguns widgets, uma abordagem mista faz
mais sentido. Neste cenário, o stateful widget
gerencia parte do estado, e o widget pai
gerencia outros aspectos do estado.

No exemplo `TapboxC`, no tap down,
uma borda verde escura aparece em torno da caixa. No tap up,
a borda desaparece e a cor da caixa muda. `TapboxC`
exporta seu estado `_active` para seu pai mas gerencia seu
estado `_highlight` internamente. Este exemplo tem dois objetos `State`,
`_ParentWidgetState` e `_TapboxCState`.

O objeto `_ParentWidgetState`:

* Gerencia o estado `_active`.
* Implementa `_handleTapboxChanged()`,
  o método chamado quando a caixa é tocada.
* Chama `setState()` para atualizar a UI quando um toque
  ocorre e o estado `_active` muda.

O objeto `_TapboxCState`:

* Gerencia o estado `_highlight`.
* O `GestureDetector` ouve todos os eventos de toque.
  Quando o usuário toca para baixo, ele adiciona o destaque
  (implementado como uma borda verde escura). Quando o usuário libera o
  toque, ele remove o destaque.
* Chama `setState()` para atualizar a UI no tap down,
  tap up, ou tap cancel, e o estado `_highlight` muda.
* Em um evento de toque, passa essa mudança de estado para o widget pai para tomar
  a ação apropriada usando a propriedade [`widget`][`widget`].

<?code-excerpt "lib/mixed.dart"?>
```dart
import 'package:flutter/material.dart';

//---------------------------- ParentWidget ----------------------------

class ParentWidget extends StatefulWidget {
  const ParentWidget({super.key});

  @override
  State<ParentWidget> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  bool _active = false;

  void _handleTapboxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TapboxC(active: _active, onChanged: _handleTapboxChanged),
    );
  }
}

//----------------------------- TapboxC ------------------------------

class TapboxC extends StatefulWidget {
  const TapboxC({super.key, this.active = false, required this.onChanged});

  final bool active;
  final ValueChanged<bool> onChanged;

  @override
  State<TapboxC> createState() => _TapboxCState();
}

class _TapboxCState extends State<TapboxC> {
  bool _highlight = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _highlight = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTap() {
    widget.onChanged(!widget.active);
  }

  @override
  Widget build(BuildContext context) {
    // This example adds a green border on tap down.
    // On tap up, the square changes to the opposite state.
    return GestureDetector(
      onTapDown: _handleTapDown, // Handle the tap events in the order that
      onTapUp: _handleTapUp, // they occur: down, up, tap, cancel
      onTap: _handleTap,
      onTapCancel: _handleTapCancel,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: widget.active ? Colors.lightGreen[700] : Colors.grey[600],
          border: _highlight
              ? Border.all(color: Colors.teal[700]!, width: 10)
              : null,
        ),
        child: Center(
          child: Text(
            widget.active ? 'Active' : 'Inactive',
            style: const TextStyle(fontSize: 32, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
```

Uma implementação alternativa poderia ter exportado o estado de destaque
para o pai enquanto mantém o estado ativo interno,
mas se você pedisse a alguém para usar aquela tap box,
eles provavelmente reclamariam que não faz muito sentido.
O desenvolvedor se importa se a caixa está ativa.
O desenvolvedor provavelmente não se importa com como o destaque
é gerenciado, e prefere que a tap box lide com esses
detalhes.

<hr>

## Outros widgets interativos

Flutter oferece uma variedade de botões e widgets interativos similares.
A maioria desses widgets implementa as [diretrizes Material Design][Material Design guidelines],
que definem um conjunto de componentes com uma UI opinativa.

Se você preferir, pode usar [`GestureDetector`][`GestureDetector`] para construir
interatividade em qualquer widget personalizado.
Você pode encontrar exemplos de `GestureDetector` em
[Gerenciando estado][Managing state]. Aprenda mais sobre o `GestureDetector`
em [Manipular toques][Handle taps], uma receita no cookbook do Flutter.

:::tip
Flutter também fornece um conjunto de widgets no estilo iOS chamados
[`Cupertino`][`Cupertino`].
:::

Quando você precisa de interatividade, é mais fácil usar um dos
widgets pré-fabricados. Aqui está uma lista parcial:

### Widgets padrão

* [`Form`][`Form`]
* [`FormField`][`FormField`]

### Material Components

* [`Checkbox`][`Checkbox`]
* [`DropdownButton`][`DropdownButton`]
* [`TextButton`][`TextButton`]
* [`FloatingActionButton`][`FloatingActionButton`]
* [`IconButton`][`IconButton`]
* [`Radio`][`Radio`]
* [`ElevatedButton`][`ElevatedButton`]
* [`Slider`][`Slider`]
* [`Switch`][`Switch`]
* [`TextField`][`TextField`]

## Recursos

Os seguintes recursos podem ajudar ao adicionar interatividade
ao seu app.

[Gestos][Gestures], uma seção no cookbook do Flutter.

[Manipulando gestos][Handling gestures]
: Como criar um botão e fazê-lo responder à entrada.

[Gestos no Flutter][Gestures in Flutter]
: Uma descrição do mecanismo de gestos do Flutter.

[Documentação da API Flutter][Flutter API documentation]
: Documentação de referência para todas as bibliotecas Flutter.

App Wonderous [app em execução][wonderous-app], [repo][wonderous-repo]
: App de showcase do Flutter com um design personalizado e interações envolventes.

[Design em Camadas do Flutter][Flutter's Layered Design] (vídeo)
: Este vídeo inclui informações sobre state e
  stateless widgets. Apresentado pelo engenheiro do Google, Ian Hickson.

[Android emulator]: /platform-integration/android/setup#set-up-devices
[`Checkbox`]: {{site.api}}/flutter/material/Checkbox-class.html
[`Cupertino`]: {{site.api}}/flutter/cupertino/cupertino-library.html
[Dart language documentation]: {{site.dart-site}}/language
[Debugging Flutter apps]: /testing/debugging
[`DropdownButton`]: {{site.api}}/flutter/material/DropdownButton-class.html
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html
[`FloatingActionButton`]: {{site.api}}/flutter/material/FloatingActionButton-class.html
[Flutter API documentation]: {{site.api}}
[Flutter's Layered Design]: {{site.yt.watch}}?v=dkyY9WCGMi0
[`FormField`]: {{site.api}}/flutter/widgets/FormField-class.html
[`Form`]: {{site.api}}/flutter/widgets/Form-class.html
[`GestureDetector`]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[Gestures]: /cookbook/gestures
[Gestures in Flutter]: /ui/interactivity/gestures
[Handling gestures]: /ui#handling-gestures
[new-flutter-app]: /reference/create-new-app
[`IconButton`]: {{site.api}}/flutter/material/IconButton-class.html
[`Icon`]: {{site.api}}/flutter/widgets/Icon-class.html
[`InkWell`]: {{site.api}}/flutter/material/InkWell-class.html
[iOS simulator]: /platform-integration/ios/setup#set-up-devices
[building layouts tutorial]: /ui/layout/tutorial
[community]: {{site.main-url}}/community
[Handle taps]: /cookbook/gestures/handling-taps
[`lake.jpg`]: {{examples}}/layout/lakes/step6/images/lake.jpg
[Libraries and imports]: {{site.dart-site}}/language/libraries
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[`main.dart`]: {{examples}}/layout/lakes/step6/lib/main.dart
[Managing state]: #managing-state
[Material Design guidelines]: {{site.material}}/styles
[`pubspec.yaml`]: {{examples}}/layout/lakes/step6/pubspec.yaml
[`Radio`]: {{site.api}}/flutter/material/Radio-class.html
[`ElevatedButton`]: {{site.api}}/flutter/material/ElevatedButton-class.html
[wonderous-app]: {{site.wonderous}}/web
[wonderous-repo]: {{site.repo.wonderous}}
[set up]: /get-started
[`SizedBox`]: {{site.api}}/flutter/widgets/SizedBox-class.html
[`Slider`]: {{site.api}}/flutter/material/Slider-class.html
[`State`]: {{site.api}}/flutter/widgets/State-class.html
[`StatefulWidget`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html
[`StatelessWidget`]: {{site.api}}/flutter/widgets/StatelessWidget-class.html
[`Switch`]: {{site.api}}/flutter/material/Switch-class.html
[`TextField`]: {{site.api}}/flutter/material/TextField-class.html
[`Text`]: {{site.api}}/flutter/widgets/Text-class.html
[`widget`]: {{site.api}}/flutter/widgets/State/widget.html
