---
ia-translate: true
title: Navegação e roteamento
description: Visão geral dos recursos de navegação e roteamento do Flutter
---

O Flutter oferece um sistema completo para navegar entre telas e lidar com
deep links. Aplicações pequenas sem deep linking complexo podem usar o
[`Navigator`][], enquanto aplicativos com requisitos específicos de deep linking e
navegação também devem usar o [`Router`][] para lidar corretamente com deep links
no Android e iOS, e para manter a sincronia com a barra de endereço quando o
aplicativo estiver sendo executado na web.

Para configurar seu aplicativo Android ou iOS para lidar com deep links, consulte
[Deep linking][].

## Usando o Navigator

O widget `Navigator` exibe telas como uma pilha usando as animações de
transição corretas para a plataforma de destino. Para navegar para uma nova
tela, acesse o `Navigator` através do `BuildContext` da rota e chame métodos
imperativos como `push()` ou `pop()`:

<?code-excerpt "ui/navigation/lib/navigator_basic.dart (push-route)"?>
```dart
child: const Text('Abrir segunda tela'),
onPressed: () {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => const SecondScreen()),
  );
},
```

Como o `Navigator` mantém uma pilha de objetos `Route` (representando o
histórico), o método `push()` também recebe um objeto `Route`. O objeto
`MaterialPageRoute` é uma subclasse de `Route` que especifica as animações de
transição para o Material Design. Para mais exemplos de como usar o `Navigator`,
siga as [receitas de navegação][] do Flutter Cookbook ou visite a [documentação
da API Navigator][`Navigator`].

## Usando rotas nomeadas

:::note
Não recomendamos o uso de rotas nomeadas para a maioria dos aplicativos.
Para obter mais informações, consulte a seção Limitações abaixo.
:::

Aplicativos com navegação simples e requisitos de deep linking podem usar o
`Navigator` para navegação e o parâmetro [`MaterialApp.routes`][] para deep
links:

<?code-excerpt "ui/navigation/lib/navigator_named_routes.dart (push-route)"?>
```dart
child: const Text('Abrir segunda tela'),
onPressed: () {
  Navigator.pushNamed(context, '/second');
},
```

`/second` representa uma _rota nomeada_ que foi declarada na lista
`MaterialApp.routes`. Para um exemplo completo, siga a receita [Navegar com rotas
nomeadas][] do Flutter Cookbook.

### Limitações

Embora as rotas nomeadas possam lidar com deep links, o comportamento é sempre o
mesmo e não pode ser personalizado. Quando um novo deep link é recebido pela
plataforma, o Flutter envia um novo `Route` para o Navigator,
independentemente de onde o usuário esteja atualmente.

O Flutter também não oferece suporte ao botão avançar do navegador para
aplicativos que usam rotas nomeadas. Por esses motivos, não recomendamos o uso de
rotas nomeadas na maioria dos aplicativos.

## Usando o Router

Aplicativos Flutter com requisitos avançados de navegação e roteamento (como um
aplicativo da web que usa links diretos para cada tela ou um aplicativo com
vários widgets `Navigator`) devem usar um pacote de roteamento como o
[go_router][] que pode analisar o caminho da rota e configurar o `Navigator`
sempre que o aplicativo recebe um novo deep link.

Para usar o Router, mude para o construtor `router` em `MaterialApp` ou
`CupertinoApp` e forneça a ele uma configuração `Router`. Pacotes de roteamento,
como [go_router][], geralmente fornecem configuração de rota e rotas que
podem ser usadas da seguinte forma:

<?code-excerpt "ui/navigation/lib/navigator_router.dart (push-route)"?>
```dart
child: const Text('Abrir segunda tela'),
onPressed: () => context.go('/second'),
```

Como pacotes como o go_router são _declarativos_, eles sempre exibirão a(s)
mesma(s) tela(s) quando um deep link for recebido.

:::note Observação para desenvolvedores avançados
Se você preferir não usar um pacote de roteamento e quiser controle total sobre a
navegação e o roteamento em seu aplicativo, substitua `RouteInformationParser` e
`RouterDelegate`. Quando o estado em seu aplicativo mudar, você pode controlar
precisamente a pilha de telas fornecendo uma lista de objetos `Page` usando o
parâmetro `Navigator.pages`. Para mais detalhes, veja a documentação da API
`Router`.
:::

## Usando Router e Navigator juntos

O `Router` e o `Navigator` são projetados para funcionar juntos. Você pode
navegar usando a API `Router` por meio de um pacote de roteamento declarativo,
como o `go_router`, ou chamando métodos imperativos como `push()` e `pop()` no
`Navigator`.

Quando você navega usando o `Router` ou um pacote de roteamento declarativo,
cada rota no Navigator é _page-backed_, o que significa que foi criada a partir
de uma [`Page`][] usando o argumento [`pages`][] no construtor do `Navigator`.
Por outro lado, qualquer `Route` criada chamando `Navigator.push` ou
`showDialog` adicionará uma rota _pageless_ ao Navigator. Se você estiver
usando um pacote de roteamento, as Rotas que são _page-backed_ são sempre
deep-linkable, enquanto as rotas _pageless_ não são.

Quando uma `Route` _page-backed_ é removida do `Navigator`, todas as rotas
_pageless_ depois dela também são removidas. Por exemplo, se um deep link
navegar removendo uma rota _page-backed_ do Navigator, todas as rotas _pageless_
depois (até a próxima rota _page-backed_) também serão removidas.

:::note
Você não pode impedir a navegação de telas _page-backed_ usando `WillPopScope`.
Em vez disso, você deve consultar a documentação da API do seu pacote de
roteamento.
:::

## Suporte à Web

Aplicativos que usam a classe `Router` se integram com a History API do
navegador para fornecer uma experiência consistente ao usar os botões voltar e
avançar do navegador. Sempre que você navega usando o `Router`, uma entrada da
History API é adicionada à pilha de histórico do navegador. Ao pressionar o
botão **voltar**, usa _[navegação cronológica inversa][]_, o que significa que o
usuário é levado para o local visitado anteriormente que foi exibido usando o
`Router`. Isso significa que, se o usuário remover uma página do `Navigator` e
pressionar o botão **voltar** do navegador, a página anterior é enviada de volta
à pilha.

## Mais informações

Para obter mais informações sobre navegação e roteamento, consulte os
seguintes recursos:

* O Flutter cookbook inclui várias [receitas de navegação][] que mostram como
  usar o `Navigator`.
* A documentação da API [`Navigator`][] e [`Router`][] contém detalhes sobre
  como configurar a navegação declarativa sem um pacote de roteamento.
* [Entendendo a navegação][], uma página da documentação do Material Design,
  descreve os conceitos para projetar a navegação em seu aplicativo, incluindo
  explicações para navegação para frente, para cima e cronológica.
* [Aprendendo o novo sistema de navegação e roteamento do Flutter][], um artigo
  no Medium, descreve como usar o widget `Router` diretamente, sem um pacote
  de roteamento.
* O [documento de design do Router][] contém a motivação e o design da API
  `Router`.

[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`Router`]: {{site.api}}/flutter/widgets/Router-class.html
[Deep linking]: /ui/navigation/deep-linking
[receitas de navegação]: /cookbook#navigation
[`MaterialApp.routes`]: {{site.api}}/flutter/material/MaterialApp/routes.html
[Navegar com rotas nomeadas]: /cookbook/navigation/named-routes
[go_router]: {{site.pub}}/packages/go_router
[`Page`]: {{site.api}}/flutter/widgets/Page-class.html
[`pages`]: {{site.api}}/flutter/widgets/Navigator/pages.html
[navegação cronológica inversa]: https://material.io/design/navigation/understanding-navigation.html#reverse-navigation
[Entendendo a navegação]: https://material.io/design/navigation/understanding-navigation.html
[Aprendendo o novo sistema de navegação e roteamento do Flutter]: {{site.medium}}/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade
[documento de design do Router]: {{site.main-url}}/go/navigator-with-router
