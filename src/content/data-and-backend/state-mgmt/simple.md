---
ia-translate: true
title: Gerenciamento de estado de aplicativo simples
description: Uma forma simples de gerenciamento de estado.
prev:
  title: Estado efêmero versus estado do aplicativo
  path: /development/data-and-backend/state-mgmt/ephemeral-vs-app
next:
  title: Lista de abordagens
  path: /development/data-and-backend/state-mgmt/options
---

<?code-excerpt path-base="state_mgmt/simple/"?>

Agora que você sabe sobre [programação de UI declarativa][]
e a diferença entre [estado efêmero e estado do aplicativo][],
você está pronto para aprender sobre gerenciamento de estado de aplicativo simples.

Nesta página, vamos usar o pacote `provider`.
Se você é novo no Flutter e não tem uma razão forte para escolher
outra abordagem (Redux, Rx, hooks, etc.), esta é provavelmente a abordagem
com a qual você deve começar. O pacote `provider` é fácil de entender
e não usa muito código.
Ele também usa conceitos que são aplicáveis em todas as outras abordagens.

Dito isto, se você tem um forte conhecimento em
gerenciamento de estado de outros frameworks reativos,
você pode encontrar pacotes e tutoriais listados na [página de opções][].

## Nosso exemplo

<img src='/assets/images/docs/development/data-and-backend/state-mgmt/model-shopper-screencast.gif' alt='Um gif animado mostrando um aplicativo Flutter em uso. Ele começa com o usuário em uma tela de login. Eles fazem login e são levados para a tela do catálogo, com uma lista de itens. Eles clicam em vários itens e, ao fazer isso, os itens são marcados como "adicionados". O usuário clica em um botão e é levado para a visualização do carrinho. Eles veem os itens lá. Eles voltam para o catálogo e os itens que compraram ainda mostram "adicionado". Fim da animação.' class='site-image-right'>

Para fins de ilustração, considere o seguinte aplicativo simples.

O aplicativo tem duas telas separadas: um catálogo,
e um carrinho (representados pelos widgets `MyCatalog` e
`MyCart`, respectivamente). Poderia ser um aplicativo de compras,
mas você pode imaginar a mesma estrutura em um aplicativo de rede social simples
(substitua catálogo por "mural" e carrinho por "favoritos").

A tela do catálogo inclui uma barra de aplicativo personalizada (`MyAppBar`)
e uma visualização com rolagem de muitos itens de lista (`MyListItems`).

Aqui está o aplicativo visualizado como uma árvore de widgets.

<img src='/assets/images/docs/development/data-and-backend/state-mgmt/simple-widget-tree.png' width="100%" alt="Uma árvore de widgets com MyApp no topo e MyCatalog e MyCart abaixo. A área MyCart é de nós folha, mas MyCatalog tem dois filhos: MyAppBar e uma lista de MyListItems.">

{% comment %}
  Source drawing for the png above: https://docs.google.com/drawings/d/1KXxAl_Ctxc-avhR4uE58BXBM6Tyhy0pQMCsSMFHVL_0/edit?zx=y4m1lzbhsrvx
{% endcomment %}

Então temos pelo menos 5 subclasses de `Widget`. Muitos deles precisam
acessar o estado que "pertence" a outro lugar. Por exemplo, cada
`MyListItem` precisa ser capaz de se adicionar ao carrinho.
Ele também pode querer ver se o item exibido atualmente
já está no carrinho.

Isso nos leva à nossa primeira pergunta: onde devemos colocar o estado atual
do carrinho?

## Elevando o estado

No Flutter,
faz sentido manter o estado acima dos widgets que o usam.

Por quê? Em frameworks declarativos como o Flutter, se você quiser alterar a UI,
você tem que reconstruí-la. Não há maneira fácil de ter
`MyCart.updateWith(somethingNew)`. Em outras palavras, é difícil
alterar imperativamente um widget de fora, chamando um método nele.
E mesmo que você conseguisse fazer isso funcionar, você estaria lutando contra o
framework em vez de deixá-lo ajudá-lo.

```dart
// RUIM: NÃO FAÇA ISSO
void myTapHandler() {
  var cartWidget = somehowGetMyCartWidget();
  cartWidget.updateWith(item);
}
```

Mesmo que você consiga fazer o código acima funcionar,
você teria que lidar
com o seguinte no widget `MyCart`:

```dart
// RUIM: NÃO FAÇA ISSO
Widget build(BuildContext context) {
  return SomeWidget(
    // O estado inicial do carrinho.
  );
}

void updateWith(Item item) {
  // De alguma forma você precisa alterar a UI a partir daqui.
}
```

Você precisaria levar em consideração o estado atual da UI
e aplicar os novos dados a ela. É difícil evitar bugs dessa forma.

No Flutter, você constrói um novo widget sempre que seu conteúdo muda.
Em vez de `MyCart.updateWith(somethingNew)` (uma chamada de método)
você usa `MyCart(contents)` (um construtor). Como você só pode
construir novos widgets nos métodos de build de seus pais,
se você quiser alterar `contents`, ele precisa residir no
pai de `MyCart` ou acima.

<?code-excerpt "lib/src/provider.dart (my-tap-handler)"?>
```dart
// BOM
void myTapHandler(BuildContext context) {
  var cartModel = somehowGetMyCartModel(context);
  cartModel.add(item);
}
```

Agora `MyCart` tem apenas um caminho de código para construir qualquer versão da UI.

<?code-excerpt "lib/src/provider.dart (build)"?>
```dart
// BOM
Widget build(BuildContext context) {
  var cartModel = somehowGetMyCartModel(context);
  return SomeWidget(
    // Apenas construa a UI uma vez, usando o estado atual do carrinho.
    // ···
  );
}
```

Em nosso exemplo, `contents` precisa residir em `MyApp`. Sempre que ele muda,
ele reconstrói `MyCart` de cima (mais sobre isso depois). Por causa disso,
`MyCart` não precisa se preocupar com o ciclo de vida&mdash;ele apenas declara
o que mostrar para qualquer `contents` dado. Quando isso muda, o antigo
widget `MyCart` desaparece e é completamente substituído pelo novo.

<img src='/assets/images/docs/development/data-and-backend/state-mgmt/simple-widget-tree-with-cart.png' width="100%" alt="Mesma árvore de widgets acima, mas agora mostramos um pequeno selo 'carrinho' ao lado de MyApp e há duas setas aqui. Uma vem de um dos MyListItems para o 'carrinho', e outra vai do 'carrinho' para o widget MyCart.">

{% comment %}
  Source drawing for the png above: https://docs.google.com/drawings/d/1ErMyaX4fwfbIW9ABuPAlHELLGMsU6cdxPDFz_elsS9k/edit?zx=j42inp8903pt
{% endcomment %}

Isto é o que queremos dizer quando dizemos que os widgets são imutáveis.
Eles não mudam&mdash;eles são substituídos.

Agora que sabemos onde colocar o estado do carrinho, vamos ver como
acessá-lo.

## Acessando o estado

Quando um usuário clica em um dos itens do catálogo,
ele é adicionado ao carrinho. Mas como o carrinho reside acima de `MyListItem`,
como fazemos isso?

Uma opção simples é fornecer um callback que `MyListItem` pode chamar
quando ele é clicado. As funções do Dart são objetos de primeira classe,
então você pode passá-las por aí do jeito que quiser. Então, dentro
de `MyCatalog` você pode definir o seguinte:

<?code-excerpt "lib/src/passing_callbacks.dart (methods)"?>
```dart
@override
Widget build(BuildContext context) {
  return SomeWidget(
    // Constrói o widget, passando uma referência ao método acima.
    MyListItem(myTapCallback),
  );
}

void myTapCallback(Item item) {
  print('usuário clicou em $item');
}
```

Isso funciona bem, mas para um estado de aplicativo que você precisa modificar de
muitos lugares diferentes, você teria que passar muitos
callbacks&mdash;o que fica cansativo muito rapidamente.

Felizmente, o Flutter tem mecanismos para widgets fornecerem dados e
serviços para seus descendentes (em outras palavras, não apenas seus filhos,
mas quaisquer widgets abaixo deles). Como seria de esperar do Flutter,
onde _Tudo é um Widget™_, esses mecanismos são apenas especiais
tipos de widgets&mdash;`InheritedWidget`, `InheritedNotifier`,
`InheritedModel` e muito mais. Não vamos cobrir esses aqui,
porque eles são um pouco de baixo nível para o que estamos tentando fazer.

Em vez disso, vamos usar um pacote que funciona com os
widgets de baixo nível, mas é simples de usar. Ele se chama `provider`.

Antes de trabalhar com `provider`,
não se esqueça de adicionar a dependência a ele no seu `pubspec.yaml`.

Para adicionar o pacote `provider` como uma dependência, execute `flutter pub add`:

```console
$ flutter pub add provider
```

Agora você pode `import 'package:provider/provider.dart';`
e começar a construir.

Com `provider`, você não precisa se preocupar com callbacks ou
`InheritedWidgets`. Mas você precisa entender 3 conceitos:

* ChangeNotifier
* ChangeNotifierProvider
* Consumer

## ChangeNotifier

`ChangeNotifier` é uma classe simples incluída no SDK do Flutter que fornece
notificação de mudança para seus ouvintes. Em outras palavras, se algo é
um `ChangeNotifier`, você pode se inscrever em suas mudanças. (É uma forma de
Observable, para aqueles familiarizados com o termo.)

Em `provider`, `ChangeNotifier` é uma forma de encapsular o seu aplicativo
estado. Para aplicativos muito simples, você se vira com um único `ChangeNotifier`.
Em complexos, você terá vários modelos e, portanto, vários
`ChangeNotifiers`. (Você não precisa usar `ChangeNotifier` com `provider`
em tudo, mas é uma classe fácil de trabalhar.)

Em nosso exemplo de aplicativo de compras, queremos gerenciar o estado do carrinho em um
`ChangeNotifier`. Criamos uma nova classe que a estende, como esta:

<?code-excerpt "lib/src/provider.dart (model)" replace="/ChangeNotifier/[!$&!]/g;/notifyListeners/[!$&!]/g"?>
```dart
class CartModel extends [!ChangeNotifier!] {
  /// Estado interno e privado do carrinho.
  final List<Item> _items = [];

  /// Uma visualização não modificável dos itens no carrinho.
  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  /// O preço total atual de todos os itens (assumindo que todos os itens custam $42).
  int get totalPrice => _items.length * 42;

  /// Adiciona [item] ao carrinho. Este e [removeAll] são as únicas maneiras de modificar o
  /// carrinho de fora.
  void add(Item item) {
    _items.add(item);
    // Esta chamada informa os widgets que estão ouvindo este modelo para reconstruir.
    [!notifyListeners!]();
  }

  /// Remove todos os itens do carrinho.
  void removeAll() {
    _items.clear();
    // Esta chamada informa os widgets que estão ouvindo este modelo para reconstruir.
    [!notifyListeners!]();
  }
}
```

O único código que é específico para `ChangeNotifier` é a chamada
para `notifyListeners()`. Chame este método sempre que o modelo mudar de uma forma
que pode mudar a UI do seu aplicativo. Todo o resto em `CartModel` é o
próprio modelo e sua lógica de negócios.

`ChangeNotifier` faz parte de `flutter:foundation` e não depende de
quaisquer classes de nível superior no Flutter. É facilmente testável (você nem precisa
usar [testes de widget][] para ele). Por exemplo,
aqui está um teste unitário simples de `CartModel`:

<?code-excerpt "test/model_test.dart (test)"?>
```dart
test('adicionar item aumenta o custo total', () {
  final cart = CartModel();
  final startingPrice = cart.totalPrice;
  var i = 0;
  cart.addListener(() {
    expect(cart.totalPrice, greaterThan(startingPrice));
    i++;
  });
  cart.add(Item('Dash'));
  expect(i, 1);
});
```

## ChangeNotifierProvider

`ChangeNotifierProvider` é o widget que fornece uma instância de
um `ChangeNotifier` para seus descendentes. Ele vem do pacote `provider`.

Já sabemos onde colocar `ChangeNotifierProvider`: acima dos widgets que
precisam acessá-lo. No caso de `CartModel`, isso significa em algum lugar
acima de `MyCart` e `MyCatalog`.

Você não quer colocar `ChangeNotifierProvider` mais alto do que o necessário
(porque você não quer poluir o escopo). Mas, em nosso caso,
o único widget que está no topo de `MyCart` e `MyCatalog` é `MyApp`.

<?code-excerpt "lib/main.dart (main)" replace="/ChangeNotifierProvider/[!$&!]/g"?>
```dart
void main() {
  runApp(
    [!ChangeNotifierProvider!](
      create: (context) => CartModel(),
      child: const MyApp(),
    ),
  );
}
```

Observe que estamos definindo um construtor que cria uma nova instância
de `CartModel`. `ChangeNotifierProvider` é inteligente o suficiente _para não_ reconstruir
`CartModel` a menos que seja absolutamente necessário. Ele também chama automaticamente
`dispose()` em `CartModel` quando a instância não é mais necessária.

Se você quiser fornecer mais de uma classe, você pode usar `MultiProvider`:

<?code-excerpt "lib/main.dart (multi-provider-main)" replace="/multiProviderMain/main/g;/MultiProvider/[!$&!]/g"?>
```dart
void main() {
  runApp(
    [!MultiProvider!](
      providers: [
        ChangeNotifierProvider(create: (context) => CartModel()),
        Provider(create: (context) => SomeOtherClass()),
      ],
      child: const MyApp(),
    ),
  );
}
```

## Consumer

Agora que `CartModel` é fornecido para widgets em nosso aplicativo através do
declaração `ChangeNotifierProvider` no topo, podemos começar a usá-lo.

Isso é feito através do widget `Consumer`.

<?code-excerpt "lib/src/provider.dart (descendant)" replace="/Consumer/[!$&!]/g"?>
```dart
return [!Consumer!]<CartModel>(
  builder: (context, cart, child) {
    return Text('Preço total: ${cart.totalPrice}');
  },
);
```

Devemos especificar o tipo do modelo que queremos acessar.
Neste caso, queremos `CartModel`, então escrevemos
`Consumer<CartModel>`. Se você não especificar o genérico (`<CartModel>`),
o pacote `provider` não poderá ajudá-lo. `provider` é baseado em tipos,
e sem o tipo, ele não sabe o que você quer.

O único argumento necessário do widget `Consumer`
é o builder. Builder é uma função que é chamada sempre que o
`ChangeNotifier` muda. (Em outras palavras, quando você chama `notifyListeners()`
em seu modelo, todos os métodos builder de todos os correspondentes
widgets `Consumer` são chamados.)

O builder é chamado com três argumentos. O primeiro é `context`,
que você também obtém em todos os métodos de build.

O segundo argumento da função builder é a instância de
o `ChangeNotifier`. É o que estávamos pedindo em primeiro lugar.
Você pode usar os dados no modelo para definir como a UI deve ser
em qualquer ponto dado.

O terceiro argumento é `child`, que está lá para otimização.
Se você tem uma grande subárvore de widgets abaixo do seu `Consumer`
que _não_ muda quando o modelo muda, você pode construí-la
uma vez e obtê-la através do builder.

<?code-excerpt "lib/src/performance.dart (child)" replace="/\bchild\b/[!$&!]/g"?>
```dart
return Consumer<CartModel>(
  builder: (context, cart, [!child!]) => Stack(
    children: [
      // Use SomeExpensiveWidget aqui, sem reconstruir toda vez.
      if ([!child!] != null) [!child!],
      Text('Preço total: ${cart.totalPrice}'),
    ],
  ),
  // Construa o widget caro aqui.
  [!child!]: const SomeExpensiveWidget(),
);
```

É uma boa prática colocar seus widgets `Consumer` o mais profundo possível na árvore.
Você não quer reconstruir grandes partes da UI
só porque algum detalhe em algum lugar mudou.

<?code-excerpt "lib/src/performance.dart (non-leaf-descendant)"?>
```dart
// NÃO FAÇA ISSO
return Consumer<CartModel>(
  builder: (context, cart, child) {
    return HumongousWidget(
      // ...
      child: AnotherMonstrousWidget(
        // ...
        child: Text('Preço total: ${cart.totalPrice}'),
      ),
    );
  },
);
```

Em vez disso:

<?code-excerpt "lib/src/performance.dart (leaf-descendant)"?>
```dart
// FAÇA ISSO
return HumongousWidget(
  // ...
  child: AnotherMonstrousWidget(
    // ...
    child: Consumer<CartModel>(
      builder: (context, cart, child) {
        return Text('Preço total: ${cart.totalPrice}');
      },
    ),
  ),
);
```

### Provider.of

Às vezes, você realmente não precisa que os _dados_ no modelo mudem o
UI, mas você ainda precisa acessá-lo. Por exemplo, um botão `ClearCart`
quer permitir que o usuário remova tudo do carrinho.
Ele não precisa exibir o conteúdo do carrinho,
ele só precisa chamar o método `clear()`.

Poderíamos usar `Consumer<CartModel>` para isso,
mas isso seria um desperdício. Estaríamos pedindo ao framework para
reconstruir um widget que não precisa ser reconstruído.

Para este caso de uso, podemos usar `Provider.of`,
com o parâmetro `listen` definido como `false`.

<?code-excerpt "lib/src/performance.dart (non-rebuilding)" replace="/listen: false/[!$&!]/g"?>
```dart
Provider.of<CartModel>(context, [!listen: false!]).removeAll();
```

Usar a linha acima em um método de build não fará com que este widget seja
reconstruído quando `notifyListeners` for chamado.

## Juntando tudo

Você pode [verificar o exemplo][] abordado neste artigo.
Se você quiser algo mais simples,
veja como o aplicativo simples Counter fica quando
[construído com `provider`][].

Ao acompanhar esses artigos, você melhorou muito
sua capacidade de criar aplicativos baseados em estado.
Tente construir um aplicativo com `provider` você mesmo para
dominar essas habilidades.

[construído com `provider`]: {{site.repo.samples}}/tree/main/provider_counter
[verificar o exemplo]: {{site.repo.samples}}/tree/main/provider_shopper
[programação de UI declarativa]: /data-and-backend/state-mgmt/declarative
[estado efêmero e estado do aplicativo]: /data-and-backend/state-mgmt/ephemeral-vs-app
[página de opções]: /data-and-backend/state-mgmt/options
[testes de widget]: /testing/overview#widget-tests
