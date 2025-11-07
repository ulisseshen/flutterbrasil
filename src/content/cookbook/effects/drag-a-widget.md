---
title: Arrastar um elemento de UI
description: Como implementar um elemento de UI arrastável.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
ia-translate: true
---

<?code-excerpt path-base="cookbook/effects/drag_a_widget"?>

Arrastar e soltar é uma interação comum em aplicativos móveis.
Quando o usuário pressiona longamente (às vezes chamado de _touch & hold_)
em um widget, outro widget aparece abaixo do
dedo do usuário, e o usuário arrasta o widget para um
local final e o libera.
Nesta receita, você vai construir uma interação de arrastar e soltar
onde o usuário pressiona longamente em uma escolha de comida,
e então arrasta essa comida para a foto do cliente que
está pagando por ela.

A seguinte animação mostra o comportamento do aplicativo:

![Pedindo a comida arrastando para a pessoa](/assets/images/docs/cookbook/effects/DragAUIElement.gif){:.site-mobile-screenshot}

Esta receita começa com uma lista pré-construída de itens de menu e
uma linha de clientes.
O primeiro passo é reconhecer uma pressão longa
e exibir uma foto arrastável de um item de menu.

## Pressionar e arrastar

Flutter fornece um widget chamado [`LongPressDraggable`][]
que fornece exatamente o comportamento que você precisa para iniciar
uma interação de arrastar e soltar. Um `LongPressDraggable`
widget reconhece quando uma pressão longa ocorre e então
exibe um novo widget perto do dedo do usuário.
Conforme o usuário arrasta, o widget segue o dedo do usuário.
`LongPressDraggable` dá a você controle total sobre o
widget que o usuário arrasta.

Cada item da lista de menu é exibido com um
widget `MenuListItem` personalizado.

<?code-excerpt "lib/main.dart (MenuListItem)" replace="/^child: //g;/^\),$/)/g"?>
```dart
MenuListItem(
  name: item.name,
  price: item.formattedTotalItemPrice,
  photoProvider: item.imageProvider,
)
```

Envolva o widget `MenuListItem` com um widget `LongPressDraggable`.

<?code-excerpt "lib/main.dart (LongPressDraggable)" replace="/^return //g;/^\),$/)/g"?>
```dart
LongPressDraggable<Item>(
  data: item,
  dragAnchorStrategy: pointerDragAnchorStrategy,
  feedback: DraggingListItem(
    dragKey: _draggableKey,
    photoProvider: item.imageProvider,
  ),
  child: MenuListItem(
    name: item.name,
    price: item.formattedTotalItemPrice,
    photoProvider: item.imageProvider,
  ),
);
```

Neste caso, quando o usuário pressiona longamente no
widget `MenuListItem`, o widget `LongPressDraggable`
exibe um `DraggingListItem`.
Este `DraggingListItem` exibe uma foto do
item de comida selecionado, centralizado abaixo
do dedo do usuário.

A propriedade `dragAnchorStrategy` é definida como
[`pointerDragAnchorStrategy`][].
Este valor de propriedade instrui `LongPressDraggable`
a basear a posição do `DraggableListItem` no
dedo do usuário. Conforme o usuário move o dedo,
o `DraggableListItem` se move com ele.

Arrastar e soltar é de pouca utilidade se nenhuma informação
é transmitida quando o item é solto.
Por esta razão, `LongPressDraggable` recebe um parâmetro `data`.
Neste caso, o tipo de `data` é `Item`,
que contém informações sobre o
item de comida do menu que o usuário pressionou.

O `data` associado a um `LongPressDraggable`
é enviado para um widget especial chamado `DragTarget`,
onde o usuário libera o gesto de arrastar.
Você implementará o comportamento de soltar a seguir.

## Soltar o arrastável

O usuário pode soltar um `LongPressDraggable` onde quiser,
mas soltar o arrastável não tem efeito a menos que seja solto
em cima de um `DragTarget`. Quando o usuário solta um arrastável em
cima de um widget `DragTarget`, o widget `DragTarget`
pode aceitar ou rejeitar os dados do arrastável.

Nesta receita, o usuário deve soltar um item de menu em um
widget `CustomerCart` para adicionar o item de menu ao carrinho do usuário.

<?code-excerpt "lib/main.dart (CustomerCart)" replace="/^return //g;/^\),$/)/g"?>
```dart
CustomerCart(
  hasItems: customer.items.isNotEmpty,
  highlighted: candidateItems.isNotEmpty,
  customer: customer,
);
```

Envolva o widget `CustomerCart` com um widget `DragTarget`.

<?code-excerpt "lib/main.dart (DragTarget)" replace="/^child: //g;/^\),$/)/g"?>
```dart
DragTarget<Item>(
  builder: (context, candidateItems, rejectedItems) {
    return CustomerCart(
      hasItems: customer.items.isNotEmpty,
      highlighted: candidateItems.isNotEmpty,
      customer: customer,
    );
  },
  onAcceptWithDetails: (details) {
    _itemDroppedOnCustomerCart(
      item: details.data,
      customer: customer,
    );
  },
)
```

O `DragTarget` exibe seu widget existente e
também coordena com `LongPressDraggable` para reconhecer
quando o usuário arrasta um arrastável em cima do `DragTarget`.
O `DragTarget` também reconhece quando o usuário solta
um arrastável em cima do widget `DragTarget`.

Quando o usuário arrasta um arrastável sobre o widget `DragTarget`,
`candidateItems` contém os itens de dados que o usuário está arrastando.
Isso permite que você altere a aparência do seu widget
quando o usuário está arrastando sobre ele. Neste caso,
o widget `Customer` fica vermelho sempre que quaisquer itens são arrastados sobre o
widget `DragTarget`. A aparência visual vermelha é configurada com a
propriedade `highlighted` dentro do widget `CustomerCart`.

Quando o usuário solta um arrastável no widget `DragTarget`,
o callback `onAcceptWithDetails` é invocado. É quando você
decide se aceita ou não os dados que foram soltos.
Neste caso, o item é sempre aceito e processado.
Você pode escolher inspecionar o item recebido para tomar uma
decisão diferente.

Observe que o tipo de item solto no `DragTarget`
deve corresponder ao tipo de item arrastado do `LongPressDraggable`.
Se os tipos não forem compatíveis, então
o método `onAcceptWithDetails` não é invocado.

Com um widget `DragTarget` configurado para aceitar seus
dados desejados, agora você pode transmitir dados de uma parte
da sua UI para outra arrastando e soltando.

No próximo passo,
você atualiza o carrinho do cliente com o item de menu solto.

## Adicionar um item de menu a um carrinho

Cada cliente é representado por um objeto `Customer`,
que mantém um carrinho de itens e um preço total.

<?code-excerpt "lib/main.dart (CustomerClass)"?>
```dart
class Customer {
  Customer({
    required this.name,
    required this.imageProvider,
    List<Item>? items,
  }) : items = items ?? [];

  final String name;
  final ImageProvider imageProvider;
  final List<Item> items;

  String get formattedTotalItemPrice {
    final totalPriceCents =
        items.fold<int>(0, (prev, item) => prev + item.totalPriceCents);
    return '\$${(totalPriceCents / 100.0).toStringAsFixed(2)}';
  }
}
```

O widget `CustomerCart` exibe a foto do cliente,
nome, total e contagem de itens com base em uma instância `Customer`.

Para atualizar o carrinho de um cliente quando um item de menu é solto,
adicione o item solto ao objeto `Customer` associado.

<?code-excerpt "lib/main.dart (AddCart)"?>
```dart
void _itemDroppedOnCustomerCart({
  required Item item,
  required Customer customer,
}) {
  setState(() {
    customer.items.add(item);
  });
}
```

O método `_itemDroppedOnCustomerCart` é invocado em
`onAcceptWithDetails()` quando o usuário solta um item de menu em um
widget `CustomerCart`. Ao adicionar o item solto ao
objeto `customer`, e invocar `setState()` para causar uma
atualização de layout, a UI se atualiza com o novo total de preço e
contagem de itens do cliente.

Parabéns! Você tem uma interação de arrastar e soltar
que adiciona itens de comida ao carrinho de compras de um cliente.

## Exemplo interativo

Execute o aplicativo:

* Role pelos itens de comida.
* Pressione e segure em um com seu
  dedo ou clique e segure com o
  mouse.
* Enquanto segura, a imagem do item de comida
  aparecerá acima da lista.
* Arraste a imagem e solte-a em uma das
  pessoas na parte inferior da tela.
  O texto abaixo da imagem atualiza para
  refletir a cobrança para essa pessoa.
  Você pode continuar adicionando itens de comida
  e ver as cobranças se acumularem.

<!-- Start DartPad -->

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter drag a widget hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: ExampleDragAndDrop(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

const List<Item> _items = [
  Item(
    name: 'Spinach Pizza',
    totalPriceCents: 1299,
    uid: '1',
    imageProvider: NetworkImage('https://docs.flutter.dev'
        '/cookbook/img-files/effects/split-check/Food1.jpg'),
  ),
  Item(
    name: 'Veggie Delight',
    totalPriceCents: 799,
    uid: '2',
    imageProvider: NetworkImage('https://docs.flutter.dev'
        '/cookbook/img-files/effects/split-check/Food2.jpg'),
  ),
  Item(
    name: 'Chicken Parmesan',
    totalPriceCents: 1499,
    uid: '3',
    imageProvider: NetworkImage('https://docs.flutter.dev'
        '/cookbook/img-files/effects/split-check/Food3.jpg'),
  ),
];

@immutable
class ExampleDragAndDrop extends StatefulWidget {
  const ExampleDragAndDrop({super.key});

  @override
  State<ExampleDragAndDrop> createState() => _ExampleDragAndDropState();
}

class _ExampleDragAndDropState extends State<ExampleDragAndDrop>
    with TickerProviderStateMixin {
  final List<Customer> _people = [
    Customer(
      name: 'Makayla',
      imageProvider: const NetworkImage('https://docs.flutter.dev'
          '/cookbook/img-files/effects/split-check/Avatar1.jpg'),
    ),
    Customer(
      name: 'Nathan',
      imageProvider: const NetworkImage('https://docs.flutter.dev'
          '/cookbook/img-files/effects/split-check/Avatar2.jpg'),
    ),
    Customer(
      name: 'Emilio',
      imageProvider: const NetworkImage('https://docs.flutter.dev'
          '/cookbook/img-files/effects/split-check/Avatar3.jpg'),
    ),
  ];

  final GlobalKey _draggableKey = GlobalKey();

  void _itemDroppedOnCustomerCart({
    required Item item,
    required Customer customer,
  }) {
    setState(() {
      customer.items.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: _buildAppBar(),
      body: _buildContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: Color(0xFFF64209)),
      title: Text(
        'Order Food',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 36,
              color: const Color(0xFFF64209),
              fontWeight: FontWeight.bold,
            ),
      ),
      backgroundColor: const Color(0xFFF7F7F7),
      elevation: 0,
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _buildMenuList(),
              ),
              _buildPeopleRow(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 12,
        );
      },
      itemBuilder: (context, index) {
        final item = _items[index];
        return _buildMenuItem(
          item: item,
        );
      },
    );
  }

  Widget _buildMenuItem({
    required Item item,
  }) {
    return LongPressDraggable<Item>(
      data: item,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: DraggingListItem(
        dragKey: _draggableKey,
        photoProvider: item.imageProvider,
      ),
      child: MenuListItem(
        name: item.name,
        price: item.formattedTotalItemPrice,
        photoProvider: item.imageProvider,
      ),
    );
  }

  Widget _buildPeopleRow() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 20,
      ),
      child: Row(
        children: _people.map(_buildPersonWithDropZone).toList(),
      ),
    );
  }

  Widget _buildPersonWithDropZone(Customer customer) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
        ),
        child: DragTarget<Item>(
          builder: (context, candidateItems, rejectedItems) {
            return CustomerCart(
              hasItems: customer.items.isNotEmpty,
              highlighted: candidateItems.isNotEmpty,
              customer: customer,
            );
          },
          onAcceptWithDetails: (details) {
            _itemDroppedOnCustomerCart(
              item: details.data,
              customer: customer,
            );
          },
        ),
      ),
    );
  }
}

class CustomerCart extends StatelessWidget {
  const CustomerCart({
    super.key,
    required this.customer,
    this.highlighted = false,
    this.hasItems = false,
  });

  final Customer customer;
  final bool highlighted;
  final bool hasItems;

  @override
  Widget build(BuildContext context) {
    final textColor = highlighted ? Colors.white : Colors.black;

    return Transform.scale(
      scale: highlighted ? 1.075 : 1.0,
      child: Material(
        elevation: highlighted ? 8 : 4,
        borderRadius: BorderRadius.circular(22),
        color: highlighted ? const Color(0xFFF64209) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: SizedBox(
                  width: 46,
                  height: 46,
                  child: Image(
                    image: customer.imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                customer.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: textColor,
                      fontWeight:
                          hasItems ? FontWeight.normal : FontWeight.bold,
                    ),
              ),
              Visibility(
                visible: hasItems,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      customer.formattedTotalItemPrice,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${customer.items.length} item${customer.items.length != 1 ? 's' : ''}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: textColor,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MenuListItem extends StatelessWidget {
  const MenuListItem({
    super.key,
    this.name = '',
    this.price = '',
    required this.photoProvider,
    this.isDepressed = false,
  });

  final String name;
  final String price;
  final ImageProvider photoProvider;
  final bool isDepressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 120,
                height: 120,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    height: isDepressed ? 115 : 120,
                    width: isDepressed ? 115 : 120,
                    child: Image(
                      image: photoProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    price,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DraggingListItem extends StatelessWidget {
  const DraggingListItem({
    super.key,
    required this.dragKey,
    required this.photoProvider,
  });

  final GlobalKey dragKey;
  final ImageProvider photoProvider;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: const Offset(-0.5, -0.5),
      child: ClipRRect(
        key: dragKey,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 150,
          width: 150,
          child: Opacity(
            opacity: 0.85,
            child: Image(
              image: photoProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class Item {
  const Item({
    required this.totalPriceCents,
    required this.name,
    required this.uid,
    required this.imageProvider,
  });
  final int totalPriceCents;
  final String name;
  final String uid;
  final ImageProvider imageProvider;
  String get formattedTotalItemPrice =>
      '\$${(totalPriceCents / 100.0).toStringAsFixed(2)}';
}

class Customer {
  Customer({
    required this.name,
    required this.imageProvider,
    List<Item>? items,
  }) : items = items ?? [];

  final String name;
  final ImageProvider imageProvider;
  final List<Item> items;

  String get formattedTotalItemPrice {
    final totalPriceCents =
        items.fold<int>(0, (prev, item) => prev + item.totalPriceCents);
    return '\$${(totalPriceCents / 100.0).toStringAsFixed(2)}';
  }
}
```

[`pointerDragAnchorStrategy`]: {{site.api}}/flutter/widgets/pointerDragAnchorStrategy.html
[`LongPressDraggable`]: {{site.api}}/flutter/widgets/LongPressDraggable-class.html
