---
ia-translate: true
title: Gerenciamento de estado simples de app
description: Uma forma simples de gerenciamento de estado.
prev:
  title: Ephemeral versus app state
  path: /data-and-backend/state-mgmt/ephemeral-vs-app
next:
  title: List of approaches
  path: /data-and-backend/state-mgmt/options
---

<?code-excerpt path-base="state_mgmt/simple/"?>

Agora que você sabe sobre [programação de UI declarativa][declarative UI programming]
e a diferença entre [estado efêmero e estado do app][ephemeral and app state],
você está pronto para aprender sobre gerenciamento de estado simples de app.

Nesta página, vamos usar o pacote `provider`.
Se você é novo no Flutter e não tem uma razão forte para escolher
outra abordagem (Redux, Rx, hooks, etc.), esta é provavelmente a abordagem
com a qual você deve começar. O pacote `provider` é fácil de entender
e não usa muito código.
Ele também usa conceitos que são aplicáveis em todas as outras abordagens.

Dito isso, se você tem uma sólida experiência em
gerenciamento de estado de outros frameworks reativos,
você pode encontrar pacotes e tutoriais listados na [página de opções][options page].

## Nosso exemplo

<img src='/assets/images/docs/development/data-and-backend/state-mgmt/model-shopper-screencast.webp' alt='An animated gif showing a Flutter app in use. It starts with the user on a login screen. They log in and are taken to the catalog screen, with a list of items. The click on several items, and as they do so, the items are marked as "added". The user clicks on a button and gets taken to the cart view. They see the items there. They go back to the catalog, and the items they bought still show "added". End of animation.' class='site-image-right' style="max-height: 24rem;">

Para ilustração, considere o seguinte app simples.

O app tem duas telas separadas: um catálogo,
e um carrinho (representados pelos widgets `MyCatalog`
e `MyCart`, respectivamente). Poderia ser um app de compras,
mas você pode imaginar a mesma estrutura em um app simples de rede social
(substitua catálogo por "mural" e carrinho por "favoritos").

A tela de catálogo inclui uma app bar customizada (`MyAppBar`)
e uma visualização de rolagem de muitos itens de lista (`MyListItems`).

Aqui está o app visualizado como uma árvore de widgets.

<img src='/assets/images/docs/development/data-and-backend/state-mgmt/simple-widget-tree.png' width="100%" class="diagram-wrap" alt="A widget tree with MyApp at the top, and  MyCatalog and MyCart below it. MyCart area leaf nodes, but MyCatalog have two children: MyAppBar and a list of MyListItems.">

{% comment %}
  Source drawing for the png above: https://docs.google.com/drawings/d/1KXxAl_Ctxc-avhR4uE58BXBM6Tyhy0pQMCsSMFHVL_0/edit?zx=y4m1lzbhsrvx
{% endcomment %}

Então temos pelo menos 5 subclasses de `Widget`. Muitos deles precisam
de acesso ao estado que "pertence" a outro lugar. Por exemplo, cada
`MyListItem` precisa ser capaz de se adicionar ao carrinho.
Ele também pode querer ver se o item exibido atualmente
já está no carrinho.

Isso nos leva à nossa primeira pergunta: onde devemos colocar o estado
atual do carrinho?


## Elevando o estado

No Flutter,
faz sentido manter o estado acima dos widgets que o usam.

Por quê? Em frameworks declarativos como o Flutter, se você quiser mudar a UI,
você tem que reconstruí-la. Não há uma forma fácil de ter
`MyCart.updateWith(somethingNew)`. Em outras palavras, é difícil
mudar imperativamente um widget de fora, chamando um método nele.
E mesmo se você pudesse fazer isso funcionar, você estaria lutando contra o
framework ao invés de deixá-lo ajudá-lo.

```dart
// BAD: DO NOT DO THIS
void myTapHandler() {
  var cartWidget = somehowGetMyCartWidget();
  cartWidget.updateWith(item);
}
```

Mesmo se você conseguisse fazer o código acima funcionar,
você teria que lidar
com o seguinte no widget `MyCart`:

```dart
// BAD: DO NOT DO THIS
Widget build(BuildContext context) {
  return SomeWidget(
    // The initial state of the cart.
  );
}

void updateWith(Item item) {
  // Somehow you need to change the UI from here.
}
```

Você precisaria levar em consideração o estado atual da UI
e aplicar os novos dados a ela. É difícil evitar bugs desta forma.

No Flutter, você constrói um novo widget toda vez que seu conteúdo muda.
Ao invés de `MyCart.updateWith(somethingNew)` (uma chamada de método)
você usa `MyCart(contents)` (um construtor). Como você só pode
construir novos widgets nos métodos build de seus pais,
se você quiser mudar `contents`, ele precisa viver no pai de `MyCart`
ou acima.

<?code-excerpt "lib/src/provider.dart (my-tap-handler)"?>
```dart
// GOOD
void myTapHandler(BuildContext context) {
  var cartModel = somehowGetMyCartModel(context);
  cartModel.add(item);
}
```

Agora `MyCart` tem apenas um caminho de código para construir qualquer versão da UI.

<?code-excerpt "lib/src/provider.dart (build)"?>
```dart
// GOOD
Widget build(BuildContext context) {
  var cartModel = somehowGetMyCartModel(context);
  return SomeWidget(
    // Just construct the UI once, using the current state of the cart.
    // ···
  );
}
```

No nosso exemplo, `contents` precisa viver em `MyApp`. Sempre que ele muda,
ele reconstrói `MyCart` de cima (mais sobre isso depois). Por causa disso,
`MyCart` não precisa se preocupar com ciclo de vida&mdash;ele apenas declara
o que mostrar para qualquer `contents` dado. Quando isso muda, o antigo
widget `MyCart` desaparece e é completamente substituído pelo novo.

<img src='/assets/images/docs/development/data-and-backend/state-mgmt/simple-widget-tree-with-cart.png' width="100%" class="diagram-wrap" alt="Same widget tree as above, but now we show a small 'cart' badge next to MyApp, and there are two arrows here. One comes from one of the MyListItems to the 'cart', and another one goes from the 'cart' to the MyCart widget.">

{% comment %}
  Source drawing for the png above: https://docs.google.com/drawings/d/1ErMyaX4fwfbIW9ABuPAlHELLGMsU6cdxPDFz_elsS9k/edit?zx=j42inp8903pt
{% endcomment %}

Isso é o que queremos dizer quando dizemos que widgets são imutáveis.
Eles não mudam&mdash;eles são substituídos.

Agora que sabemos onde colocar o estado do carrinho, vamos ver como
acessá-lo.

## Acessando o estado

Quando um usuário clica em um dos itens no catálogo,
ele é adicionado ao carrinho. Mas como o carrinho vive acima de `MyListItem`,
como fazemos isso?

Uma opção simples é fornecer um callback que `MyListItem` pode chamar
quando é clicado. As funções do Dart são objetos de primeira classe,
então você pode passá-las da forma que quiser. Então, dentro de
`MyCatalog` você pode definir o seguinte:

<?code-excerpt "lib/src/passing_callbacks.dart (methods)"?>
```dart
@override
Widget build(BuildContext context) {
  return SomeWidget(
    // Construct the widget, passing it a reference to the method above.
    MyListItem(myTapCallback),
  );
}

void myTapCallback(Item item) {
  print('user tapped on $item');
}
```

Isso funciona bem, mas para um estado de app que você precisa modificar de
muitos lugares diferentes, você teria que passar muitos
callbacks&mdash;o que fica cansativo bem rápido.

Felizmente, o Flutter tem mecanismos para widgets fornecerem dados e
serviços aos seus descendentes (em outras palavras, não apenas seus filhos,
mas quaisquer widgets abaixo deles). Como você esperaria do Flutter,
onde _Tudo é um Widget™_, esses mecanismos são apenas tipos especiais
de widgets&mdash;`InheritedWidget`, `InheritedNotifier`,
`InheritedModel`, e mais. Não vamos cobrir esses aqui,
porque eles são um pouco de baixo nível para o que estamos tentando fazer.

Em vez disso, vamos usar um pacote que trabalha com os widgets de baixo nível
mas é simples de usar. Ele se chama `provider`.

Antes de trabalhar com `provider`,
não se esqueça de adicionar a dependência dele ao seu `pubspec.yaml`.

Para adicionar o pacote `provider` como uma dependência, execute `flutter pub add`:

```console
$ flutter pub add provider
```

Agora você pode fazer `import 'package:provider/provider.dart';`
e começar a construir.

Com `provider`, você não precisa se preocupar com callbacks ou
`InheritedWidgets`. Mas você precisa entender 3 conceitos:

* ChangeNotifier
* ChangeNotifierProvider
* Consumer


## ChangeNotifier

`ChangeNotifier` é uma classe simples incluída no Flutter SDK que fornece
notificação de mudança para seus ouvintes. Em outras palavras, se algo é
um `ChangeNotifier`, você pode se inscrever em suas mudanças. (É uma forma de
Observable, para aqueles familiarizados com o termo.)

No `provider`, `ChangeNotifier` é uma forma de encapsular o estado da sua aplicação.
Para apps muito simples, você se vira com um único `ChangeNotifier`.
Em apps complexos, você terá vários modelos, e portanto vários
`ChangeNotifiers`. (Você não precisa usar `ChangeNotifier` com `provider`
de forma alguma, mas é uma classe fácil de trabalhar.)

No nosso exemplo de app de compras, queremos gerenciar o estado do carrinho em um
`ChangeNotifier`. Criamos uma nova classe que o estende, assim:

<?code-excerpt "lib/src/provider.dart (model)" replace="/ChangeNotifier/[!$&!]/g;/notifyListeners/[!$&!]/g"?>
```dart
class CartModel extends [!ChangeNotifier!] {
  /// Internal, private state of the cart.
  final List<Item> _items = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  /// The current total price of all items (assuming all items cost $42).
  int get totalPrice => _items.length * 42;

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(Item item) {
    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    [!notifyListeners!]();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    [!notifyListeners!]();
  }
}
```

O único código que é específico do `ChangeNotifier` é a chamada
para `notifyListeners()`. Chame esse método sempre que o modelo mudar de uma forma
que possa mudar a UI do seu app. Todo o resto em `CartModel` é o
próprio modelo e sua lógica de negócios.

`ChangeNotifier` faz parte de `flutter:foundation` e não depende de
nenhuma classe de nível superior no Flutter. É facilmente testável (você nem precisa
usar [testes de widget][widget testing] para isso). Por exemplo,
aqui está um teste unitário simples de `CartModel`:

<?code-excerpt "test/model_test.dart (test)"?>
```dart
test('adding item increases total cost', () {
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
um `ChangeNotifier` aos seus descendentes. Ele vem do pacote `provider`.

Já sabemos onde colocar `ChangeNotifierProvider`: acima dos widgets que
precisam acessá-lo. No caso de `CartModel`, isso significa em algum lugar
acima de `MyCart` e `MyCatalog`.

Você não quer colocar `ChangeNotifierProvider` mais alto do que o necessário
(porque você não quer poluir o escopo). Mas no nosso caso,
o único widget que está acima de `MyCart` e `MyCatalog` é `MyApp`.

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

Note que estamos definindo um builder que cria uma nova instância
de `CartModel`. `ChangeNotifierProvider` é inteligente o suficiente para _não_ reconstruir
`CartModel` a menos que seja absolutamente necessário. Ele também chama automaticamente
`dispose()` em `CartModel` quando a instância não é mais necessária.

Se você quiser fornecer mais de uma classe, pode usar `MultiProvider`:

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

Agora que `CartModel` é fornecido aos widgets no nosso app através da
declaração `ChangeNotifierProvider` no topo, podemos começar a usá-lo.

Isso é feito através do widget `Consumer`.

<?code-excerpt "lib/src/provider.dart (descendant)" replace="/Consumer/[!$&!]/g"?>
```dart
return [!Consumer!]<CartModel>(
  builder: (context, cart, child) {
    return Text('Total price: ${cart.totalPrice}');
  },
);
```

Devemos especificar o tipo do modelo que queremos acessar.
Neste caso, queremos `CartModel`, então escrevemos
`Consumer<CartModel>`. Se você não especificar o genérico (`<CartModel>`),
o pacote `provider` não será capaz de ajudá-lo. `provider` é baseado em tipos,
e sem o tipo, ele não sabe o que você quer.

O único argumento obrigatório do widget `Consumer`
é o builder. Builder é uma função que é chamada sempre que o
`ChangeNotifier` muda. (Em outras palavras, quando você chama `notifyListeners()`
no seu modelo, todos os métodos builder de todos os widgets
`Consumer` correspondentes são chamados.)

O builder é chamado com três argumentos. O primeiro é `context`,
que você também obtém em todo método build.

O segundo argumento da função builder é a instância do
`ChangeNotifier`. É o que estávamos pedindo em primeiro lugar.
Você pode usar os dados no modelo para definir como a UI deve parecer
em qualquer ponto dado.

O terceiro argumento é `child`, que está lá para otimização.
Se você tiver uma grande subárvore de widgets sob seu `Consumer`
que _não_ muda quando o modelo muda, você pode construí-la
uma vez e obtê-la através do builder.

<?code-excerpt "lib/src/performance.dart (child)" replace="/\bchild\b/[!$&!]/g"?>
```dart
return Consumer<CartModel>(
  builder: (context, cart, [!child!]) => Stack(
    children: [
      // Use SomeExpensiveWidget here, without rebuilding every time.
      ?[!child!],
      Text('Total price: ${cart.totalPrice}'),
    ],
  ),
  // Build the expensive widget here.
  [!child!]: const SomeExpensiveWidget(),
);
```

É uma boa prática colocar seus widgets `Consumer` o mais profundo possível na árvore.
Você não quer reconstruir grandes porções da UI
apenas porque algum detalhe em algum lugar mudou.

<?code-excerpt "lib/src/performance.dart (non-leaf-descendant)"?>
```dart
// DON'T DO THIS
return Consumer<CartModel>(
  builder: (context, cart, child) {
    return HumongousWidget(
      // ...
      child: AnotherMonstrousWidget(
        // ...
        child: Text('Total price: ${cart.totalPrice}'),
      ),
    );
  },
);
```

Em vez disso:

<?code-excerpt "lib/src/performance.dart (leaf-descendant)"?>
```dart
// DO THIS
return HumongousWidget(
  // ...
  child: AnotherMonstrousWidget(
    // ...
    child: Consumer<CartModel>(
      builder: (context, cart, child) {
        return Text('Total price: ${cart.totalPrice}');
      },
    ),
  ),
);
```

### Provider.of

Às vezes, você não precisa realmente dos _dados_ no modelo para mudar a
UI mas ainda precisa acessá-lo. Por exemplo, um botão `ClearCart`
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

Usar a linha acima em um método build não fará este widget
reconstruir quando `notifyListeners` for chamado.


## Juntando tudo

Você pode [conferir o exemplo][check out the example] abordado neste artigo.
Se você quiser algo mais simples,
veja como o app Counter simples fica quando
[construído com `provider`][built with `provider`].

Ao acompanhar esses artigos, você melhorou muito
sua capacidade de criar aplicações baseadas em estado.
Tente construir uma aplicação com `provider` você mesmo para
dominar essas habilidades.

[built with `provider`]: {{site.repo.samples}}/tree/main/provider_counter
[check out the example]: {{site.repo.samples}}/tree/main/provider_shopper
[declarative UI programming]: /data-and-backend/state-mgmt/declarative
[ephemeral and app state]: /data-and-backend/state-mgmt/ephemeral-vs-app
[options page]: /data-and-backend/state-mgmt/options
[widget testing]: /testing/overview#widget-tests
