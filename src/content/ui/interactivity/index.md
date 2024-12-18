---
ia-translate: true
title: Adicione interatividade ao seu aplicativo Flutter
description: Como implementar um widget stateful que responde a toques.
short-title: Interatividade
---

{% assign examples = site.repo.this | append: "/tree/" | append: site.branch | append: "/examples" -%}

:::secondary O que você aprenderá
* Como responder a toques.
* Como criar um widget personalizado.
* A diferença entre widgets stateless e stateful.
:::

Como você modifica seu aplicativo para que ele reaja à entrada do usuário?
Neste tutorial, você adicionará interatividade a um aplicativo que
contém apenas widgets não interativos. Especificamente, você
modificará um ícone para torná-lo clicável criando um widget
stateful personalizado que gerencia dois widgets stateless.

O [tutorial de criação de layouts][] mostrou como criar o layout
para a seguinte captura de tela.

{% render docs/app-figure.md, img-class:"site-mobile-screenshot border", image:"ui/layout/lakes.jpg", caption:"O aplicativo do tutorial de layout" %}

Quando o aplicativo é iniciado pela primeira vez, a estrela é vermelha sólida,
indicando que este lago foi favoritado anteriormente. O número ao lado
da estrela indica que 41 pessoas favoritaram este lago. Depois de
concluir este tutorial, tocar na estrela remove seu status de favorito,
substituindo a estrela sólida por um contorno e diminuindo a contagem.
Tocar novamente favorita o lago, desenhando uma estrela sólida e
aumentando a contagem.

<img src='/assets/images/docs/ui/favorited-not-favorited.png' class="mw-100 text-center" alt="O widget personalizado que você criará" width="200px">

Para realizar isso, você criará um único widget personalizado que
inclui tanto a estrela quanto a contagem, que são eles mesmos
widgets. Tocar na estrela muda o estado para ambos os widgets,
então o mesmo widget deve gerenciar ambos.

Você pode ir direto para tocar no código na
[Etapa 2: Subclasse StatefulWidget](#step-2).
Se você quiser experimentar diferentes maneiras de gerenciar o estado,
pule para [Gerenciando estado][].

## Widgets stateful e stateless

Um widget é stateful ou stateless. Se um widget pode
mudar&mdash;quando um usuário interage com ele, por exemplo&mdash;ele
é stateful.

Um widget _stateless_ nunca muda.
[`Icon`][], [`IconButton`][] e [`Text`][] são exemplos de widgets
stateless. Widgets stateless são subclasses de [`StatelessWidget`][].

Um widget _stateful_ é dinâmico: por exemplo, ele pode mudar sua
aparência em resposta a eventos acionados por interações do usuário
ou quando recebe dados. [`Checkbox`][], [`Radio`][], [`Slider`][],
[`InkWell`][], [`Form`][] e [`TextField`][] são exemplos de widgets
stateful. Widgets stateful são subclasses de [`StatefulWidget`][].

O estado de um widget é armazenado em um objeto [`State`][],
separando o estado do widget de sua aparência. O estado consiste
em valores que podem mudar, como o valor atual de um slider ou se
um checkbox está marcado. Quando o estado do widget muda, o objeto
de estado chama `setState()`, informando à estrutura para redesenhar
o widget.

## Criando um widget stateful

:::secondary Qual é o objetivo?

* Um widget stateful é implementado por duas classes:
  uma subclasse de `StatefulWidget` e uma subclasse de `State`.
* A classe state contém o estado mutável do widget e o método
  `build()` do widget.
* Quando o estado do widget muda, o objeto state chama `setState()`,
  informando à estrutura para redesenhar o widget.

:::

Nesta seção, você criará um widget stateful personalizado. Você
substituirá dois widgets stateless&mdash;a estrela vermelha sólida
e a contagem numérica ao lado dela&mdash;por um único widget
stateful personalizado que gerencia uma linha com dois widgets
filhos: um `IconButton` e `Text`.

A implementação de um widget stateful personalizado requer a
criação de duas classes:

* Uma subclasse de `StatefulWidget` que define o widget.
* Uma subclasse de `State` que contém o estado para esse widget e
  define o método `build()` do widget.

Esta seção mostra como construir um widget stateful, chamado
`FavoriteWidget`, para o aplicativo de lagos. Depois de configurar,
sua primeira etapa é escolher como o estado é gerenciado para
`FavoriteWidget`.

### Etapa 0: Prepare-se

Se você já construiu o aplicativo no [tutorial de criação de
layouts][], pule para a próxima seção.

 1. Certifique-se de ter [configurado][] seu ambiente.
 1. [Crie um novo aplicativo Flutter][new-flutter-app].
 1. Substitua o arquivo `lib/main.dart` por [`main.dart`][].
 1. Substitua o arquivo `pubspec.yaml` por [`pubspec.yaml`][].
 1. Crie um diretório `images` em seu projeto e adicione
    [`lake.jpg`][].

Depois de ter um dispositivo conectado e habilitado, ou você
iniciou o [simulador iOS][] (parte da instalação do Flutter) ou
o [emulador Android][] (parte da instalação do Android Studio),
você está pronto para começar!

<a id="step-1"></a>

### Etapa 1: Decida qual objeto gerencia o estado do widget

O estado de um widget pode ser gerenciado de várias maneiras, mas
em nosso exemplo, o próprio widget, `FavoriteWidget`, gerenciará
seu próprio estado. Neste exemplo, alternar a estrela é uma
ação isolada que não afeta o widget pai ou o restante da IU,
portanto, o widget pode lidar com seu estado internamente.

Saiba mais sobre a separação de widget e estado e como o estado
pode ser gerenciado em [Gerenciando estado][].

<a id="step-2"></a>

### Etapa 2: Subclasse StatefulWidget

A classe `FavoriteWidget` gerencia seu próprio estado, então ela
substitui `createState()` para criar um objeto `State`. A estrutura
chama `createState()` quando deseja construir o widget. Neste
exemplo, `createState()` retorna uma instância de
`_FavoriteWidgetState`, que você implementará na próxima etapa.

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
Membros ou classes que começam com um sublinhado (`_`) são
privados. Para mais informações, consulte [Bibliotecas e
importações][], uma seção na [documentação da linguagem Dart][].
:::

<a id="step-3"></a>

### Etapa 3: Subclasse State

A classe `_FavoriteWidgetState` armazena os dados mutáveis que
podem mudar ao longo da vida útil do widget. Quando o aplicativo
é iniciado pela primeira vez, a IU exibe uma estrela vermelha
sólida, indicando que o lago tem o status de "favorito", junto
com 41 curtidas. Esses valores são armazenados nos campos
`_isFavorited` e `_favoriteCount`:

<?code-excerpt "lib/main.dart (favorite-state-fields)" replace="/(bool|int) .*/[!$&!]/g"?>
```dart
class _FavoriteWidgetState extends State<FavoriteWidget> {
  [!bool _isFavorited = true;!]
  [!int _favoriteCount = 41;!]
```

A classe também define um método `build()`, que cria uma linha
contendo um `IconButton` vermelho e `Text`. Você usa
[`IconButton`][] (em vez de `Icon`) porque ele tem uma propriedade
`onPressed` que define a função de callback (`_toggleFavorite`)
para lidar com um toque. Você definirá a função de callback em
seguida.

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
        SizedBox(
          width: 18,
          child: SizedBox(
            [!child: Text('$_favoriteCount'),!]
          ),
        ),
      ],
    );
  }
  // ···
}
```

:::tip
Colocar o `Text` em um [`SizedBox`][] e definir sua largura
impede um "salto" perceptível quando o texto muda entre os valores
de 40 e 41 &mdash; um salto ocorreria caso contrário porque esses
valores têm larguras diferentes.
:::

O método `_toggleFavorite()`, que é chamado quando o
`IconButton` é pressionado, chama `setState()`. Chamar
`setState()` é fundamental, porque isso informa à estrutura que
o estado do widget mudou e que o widget deve ser redesenhado. O
argumento da função para `setState()` alterna a IU entre esses
dois estados:

* Um ícone de `star` e o número 41
* Um ícone de `star_border` e o número 40

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

### Etapa 4: Conecte o widget stateful à árvore de widgets

Adicione seu widget stateful personalizado à árvore de widgets no
método `build()` do aplicativo. Primeiro, localize o código que
cria o `Icon` e `Text` e exclua-o. No mesmo local, crie o widget
stateful:

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

É isso! Quando você recarregar o aplicativo, o ícone de estrela
agora deve responder a toques.

### Problemas?

Se você não conseguir executar seu código, procure possíveis
erros em seu IDE. [Depurando aplicativos Flutter][] pode ajudar.
Se você ainda não conseguir encontrar o problema, compare seu
código com o exemplo interativo de lagos no GitHub.

{% comment %}
TODO: substitua os seguintes links por painéis de código com
guias.
{% endcomment -%}

* [`lib/main.dart`]({{site.repo.this}}/tree/{{site.branch}}/examples/layout/lakes/interactive/lib/main.dart)
* [`pubspec.yaml`]({{site.repo.this}}/tree/{{site.branch}}/examples/layout/lakes/interactive/pubspec.yaml)
* [`lakes.jpg`]({{site.repo.this}}/tree/{{site.branch}}/examples/layout/lakes/interactive/images/lake.jpg)

Se você ainda tiver dúvidas, consulte um dos canais da
[comunidade][] de desenvolvedores.

---

O restante desta página aborda várias maneiras pelas quais o estado
de um widget pode ser gerenciado e lista outros widgets interativos
disponíveis.

## Gerenciando estado

:::secondary Qual é o objetivo?
* Existem diferentes abordagens para gerenciar o estado.
* Você, como designer de widgets, escolhe qual abordagem usar.
* Em caso de dúvida, comece gerenciando o estado no widget pai.
:::

Quem gerencia o estado do widget stateful? O próprio widget? O
widget pai? Ambos? Outro objeto? A resposta é... depende. Existem
várias maneiras válidas de tornar seu widget interativo. Você,
como designer de widget, toma a decisão com base em como você
espera que seu widget seja usado. Aqui estão as maneiras mais
comuns de gerenciar o estado:

* [O widget gerencia seu próprio estado](#self-managed)
* [O pai gerencia o estado do widget](#parent-managed)
* [Uma abordagem mista](#mix-and-match)

Como você decide qual abordagem usar? Os princípios a seguir
devem ajudá-lo a decidir:

* Se o estado em questão são dados do usuário, por exemplo, o modo
  marcado ou desmarcado de um checkbox, ou a posição de um slider,
  então o estado é melhor gerenciado pelo widget pai.

* Se o estado em questão é estético, por exemplo, uma animação,
  então o estado é melhor gerenciado pelo próprio widget.

Em caso de dúvida, comece gerenciando o estado no widget pai.

Daremos exemplos das diferentes maneiras de gerenciar o estado
criando três exemplos simples: TapboxA, TapboxB e TapboxC. Os
exemplos funcionam de forma semelhante&mdash;cada um cria um
container que, quando tocado, alterna entre uma caixa verde ou
cinza. O booleano `_active` determina a cor: verde para ativo
ou cinza para inativo.

<div class="row mb-4">
  <div class="col-12 text-center">
    <img src='/assets/images/docs/ui/tapbox-active-state.png' class="border mt-1 mb-1 mw-100" width="150px" alt="Estado ativo">
    <img src='/assets/images/docs/ui/tapbox-inactive-state.png' class="border mt-1 mb-1 mw-100" width="150px" alt="Estado inativo">
  </div>
</div>

Esses exemplos usam [`GestureDetector`][] para capturar a
atividade no `Container`.

<a id="self-managed"></a>

### O widget gerencia seu próprio estado

Às vezes, faz mais sentido para o widget gerenciar seu estado
internamente. Por exemplo, [`ListView`][] rola automaticamente
quando seu conteúdo excede a caixa de renderização. A maioria
dos desenvolvedores que usam `ListView` não deseja gerenciar o
comportamento de rolagem do `ListView`, então o próprio
`ListView` gerencia seu deslocamento de rolagem.

A classe `_TapboxAState`:

* Gerencia o estado para `TapboxA`.
* Define o booleano `_active` que determina a cor atual da caixa.
* Define a função `_handleTap()`, que atualiza `_active` quando
  a caixa é tocada e chama a função `setState()` para atualizar a IU.
* Implementa todo o comportamento interativo para o widget.

<?code-excerpt path-base="ui/interactive/"?>

<?code-excerpt "lib/self_managed.dart"?>
```dart
import 'package:flutter/material.dart';

// TapboxA gerencia seu próprio estado.

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
        appBar: AppBar(
          title: const Text('Flutter Demo'),
        ),
        body: const Center(
          child: TapboxA(),
        ),
      ),
    );
  }
}
```

<hr>

<a id="parent-managed"></a>

### O widget pai gerencia o estado do widget

Freqüentemente, faz mais sentido para o widget pai gerenciar o estado
e dizer a seu widget filho quando atualizar. Por exemplo,
[`IconButton`][] permite que você trate um ícone como um botão
clicável. `IconButton` é um widget stateless porque decidimos
que o widget pai precisa saber se o botão foi tocado, para que
possa tomar as medidas apropriadas.

No exemplo a seguir, TapboxB exporta seu estado para seu pai por
meio de um callback. Como TapboxB não gerencia nenhum estado, ele
é uma subclasse de StatelessWidget.

A classe ParentWidgetState:

* Gerencia o estado `_active` para TapboxB.
* Implementa `_handleTapboxChanged()`, o método chamado quando a
  caixa é tocada.
* Quando o estado muda, chama `setState()` para atualizar a IU.

A classe TapboxB:

* Estende StatelessWidget porque todo o estado é tratado por seu pai.
* Quando um toque é detectado, ele notifica o pai.

<?code-excerpt "lib/parent_managed.dart"?>
```dart
import 'package:flutter/material.dart';

// ParentWidget gerencia o estado para TapboxB.

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
      child: TapboxB(
        active: _active,
        onChanged: _handleTapboxChanged,
      ),
    );
  }
}

//------------------------- TapboxB ----------------------------------

class TapboxB extends StatelessWidget {
  const TapboxB({
    super.key,
    this.active = false,
    required this.onChanged,
  });

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

Para alguns widgets, uma abordagem mista faz mais sentido. Neste
cenário, o widget stateful gerencia parte do estado e o widget
pai gerencia outros aspectos do estado.

No exemplo `TapboxC`, ao tocar para baixo, uma borda verde-escura
aparece ao redor da caixa. Ao tocar para cima, a borda desaparece
e a cor da caixa muda. `TapboxC` exporta seu estado `_active` para
seu pai, mas gerencia seu estado `_highlight` internamente. Este
exemplo tem dois objetos `State`, `_ParentWidgetState` e
`_TapboxCState`.

O objeto `_ParentWidgetState`:

* Gerencia o estado `_active`.
* Implementa `_handleTapboxChanged()`, o método chamado quando a
  caixa é tocada.
* Chama `setState()` para atualizar a IU quando um toque ocorre
  e o estado `_active` muda.

O objeto `_TapboxCState`:

* Gerencia o estado `_highlight`.
* O `GestureDetector` ouve todos os eventos de toque. Conforme o
  usuário toca para baixo, ele adiciona o destaque (implementado
  como uma borda verde-escura). Conforme o usuário libera o toque,
  ele remove o destaque.
* Chama `setState()` para atualizar a IU ao tocar para baixo,
  tocar para cima ou cancelar o toque, e o estado `_highlight` muda.
* Em um evento de toque, passa essa mudança de estado para o widget
  pai para tomar as medidas apropriadas usando a propriedade
  [`widget`][].

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
      child: TapboxC(
        active: _active,
        onChanged: _handleTapboxChanged,
      ),
    );
  }
}

//----------------------------- TapboxC ------------------------------

class TapboxC extends StatefulWidget {
  const TapboxC({
    super.key,
    this.active = false,
    required this.onChanged,
  });

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
    // Este exemplo adiciona uma borda verde ao tocar para baixo.
    // Ao tocar para cima, o quadrado muda para o estado oposto.
    return GestureDetector(
      onTapDown: _handleTapDown, // Manipule os eventos de toque na ordem em que
      onTapUp: _handleTapUp, // eles ocorrem: down, up, tap, cancel
      onTap: _handleTap,
      onTapCancel: _handleTapCancel,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: widget.active ? Colors.lightGreen[700] : Colors.grey[600],
          border: _highlight
              ? Border.all(
                  color: Colors.teal[700]!,
                  width: 10,
                )
              : null,
        ),
        child: Center(
          child: Text(widget.active ? 'Active' : 'Inactive',
              style: const TextStyle(fontSize: 32, color: Colors.white)),
        ),
      ),
    );
  }
}
```

Uma implementação alternativa poderia ter exportado o estado de
destaque para o pai, mantendo o estado ativo interno, mas se você
pedisse para alguém usar aquela caixa de toque, eles provavelmente
reclamariam que não faz muito sentido. O desenvolvedor se importa
se a caixa está ativa. O desenvolvedor provavelmente não se importa
com a forma como o destaque é gerenciado e prefere que a caixa de
toque lide com esses detalhes.

<hr>

## Outros widgets interativos

O Flutter oferece uma variedade de botões e widgets interativos
semelhantes. A maioria desses widgets implementa as
[diretrizes de design Material][], que definem um conjunto de
componentes com uma IU opinativa.

Se você preferir, pode usar [`GestureDetector`][] para criar
interatividade em qualquer widget personalizado. Você pode
encontrar exemplos de `GestureDetector` em [Gerenciando
estado][]. Saiba mais sobre o `GestureDetector` em
[Manipular toques][], uma receita no [cookbook Flutter][].

:::tip
O Flutter também fornece um conjunto de widgets no estilo iOS
chamados [`Cupertino`][].
:::

Quando você precisa de interatividade, é mais fácil usar um dos
widgets pré-fabricados. Aqui está uma lista parcial:

### Widgets padrão

* [`Form`][]
* [`FormField`][]

### Componentes Material

* [`Checkbox`][]
* [`DropdownButton`][]
* [`TextButton`][]
* [`FloatingActionButton`][]
* [`IconButton`][]
* [`Radio`][]
* [`ElevatedButton`][]
* [`Slider`][]
* [`Switch`][]
* [`TextField`][]

## Recursos

Os recursos a seguir podem ajudar ao adicionar interatividade ao
seu aplicativo.

[Gestos][], uma seção no [cookbook Flutter][].

[Manipulando gestos][]
: Como criar um botão e fazê-lo responder à entrada.

[Gestos no Flutter][]
: Uma descrição do mecanismo de gestos do Flutter.

[Documentação da API do Flutter][]
: Documentação de referência para todas as bibliotecas do Flutter.

Aplicativo Wonderous [executando aplicativo][wonderous-app],
[repositório][wonderous-repo]
: Aplicativo de demonstração do Flutter com design personalizado
e interações envolventes.

[Design em camadas do Flutter][] (vídeo)
: Este vídeo inclui informações sobre o estado e widgets
stateless. Apresentado pelo engenheiro do Google, Ian Hickson.

[emulador Android]: /get-started/install/windows/mobile?tab=virtual#configure-your-target-android-device  
[`Checkbox`]: {{site.api}}/flutter/material/Checkbox-class.html  
[`Cupertino`]: {{site.api}}/flutter/cupertino/cupertino-library.html  
[documentação da linguagem Dart]: {{site.dart-site}}/language  
[Depurando aplicativos Flutter]: /testing/debugging  
[`DropdownButton`]: {{site.api}}/flutter/material/DropdownButton-class.html  
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html  
[`FloatingActionButton`]: {{site.api}}/flutter/material/FloatingActionButton-class.html  
[Documentação da API do Flutter]: {{site.api}}  
[cookbook Flutter]: /cookbook  
[Design em camadas do Flutter]: {{site.yt.watch}}?v=dkyY9WCGMi0  
[`FormField`]: {{site.api}}/flutter/widgets/FormField-class.html  
[`Form`]: {{site.api}}/flutter/widgets/Form-class.html  
[`GestureDetector`]: {{site.api}}/flutter/widgets/GestureDetector-class.html  
[Gestos]: /cookbook/gestures  
[Gestos no Flutter]: /ui/interactivity/gestures  
[Manipulando gestos]: /ui#manipulando-gestos  
[novo aplicativo Flutter]: /get-started/test-drive  
[`IconButton`]: {{site.api}}/flutter/material/IconButton-class.html  
[`Icon`]: {{site.api}}/flutter/widgets/Icon-class.html  
[`InkWell`]: {{site.api}}/flutter/material/InkWell-class.html  
[simulador iOS]: /get-started/install/macos/mobile-ios#configure-your-target-ios-device  
[tutorial de criação de layouts]: /ui/layout/tutorial  
[comunidade]: {{site.main-url}}/community  
[Manipular toques]: /cookbook/gestures/handling-taps  
[`lake.jpg`]: {{examples}}/layout/lakes/step6/images/lake.jpg  
[Bibliotecas e importações]: {{site.dart-site}}/language/libraries  
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html  
[`main.dart`]: {{examples}}/layout/lakes/step6/lib/main.dart  
[Gerenciando estado]: #gerenciando-estado
[diretrizes de design Material]: {{site.material}}/styles  
[`pubspec.yaml`]: {{examples}}/layout/lakes/step6/pubspec.yaml  
[`Radio`]: {{site.api}}/flutter/material/Radio-class.html  
[`ElevatedButton`]: {{site.api}}/flutter/material/ElevatedButton-class.html  
[aplicativo Wonderous]: {{site.wonderous}}/web  
[repositório Wonderous]: {{site.repo.wonderous}}  
[configurado]: /get-started/install  
[`SizedBox`]: {{site.api}}/flutter/widgets/SizedBox-class.html  
[`Slider`]: {{site.api}}/flutter/material/Slider-class.html  
[`State`]: {{site.api}}/flutter/widgets/State-class.html  
[`StatefulWidget`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html  
[`StatelessWidget`]: {{site.api}}/flutter/widgets/StatelessWidget-class.html  
[`Switch`]: {{site.api}}/flutter/material/Switch-class.html  
[`TextField`]: {{site.api}}/flutter/material/TextField-class.html  
[`Text`]: {{site.api}}/flutter/widgets/Text-class.html  
[`widget`]: {{site.api}}/flutter/widgets/State/widget.html  
