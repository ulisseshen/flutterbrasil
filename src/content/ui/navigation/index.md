---
title: Navegação e roteamento
description: Visão geral dos recursos de navegação e roteamento do Flutter
ia-translate: true
---

O Flutter fornece um sistema completo para navegação entre telas e tratamento
de deep links. Aplicações pequenas sem deep linking complexo podem usar o
[`Navigator`][], enquanto aplicações com requisitos específicos de deep linking
e navegação também devem usar o [`Router`][] para tratar corretamente deep links
no Android e iOS, e para permanecer sincronizado com a barra de endereços quando
o aplicativo está em execução na web.

Para configurar seu aplicativo Android ou iOS para lidar com deep links, consulte
[Deep linking][].

## Usando o Navigator

O widget `Navigator` exibe telas como uma pilha usando as animações de transição
corretas para a plataforma de destino. Para navegar para uma nova tela, acesse o
`Navigator` através do `BuildContext` da rota e chame métodos imperativos como
`push()` ou `pop()`:

<?code-excerpt "ui/navigation/lib/navigator_basic.dart (push-route)"?>
```dart
child: const Text('Open second screen'),
onPressed: () {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context) => const SecondScreen(),
    ),
  );
},
```

Como o `Navigator` mantém uma pilha de objetos `Route` (representando a pilha
de histórico), o método `push()` também recebe um objeto `Route`. O objeto
`MaterialPageRoute` é uma subclasse de `Route` que especifica as animações de
transição para Material Design. Para mais exemplos de como usar o `Navigator`,
siga as [navigation recipes][] do Flutter Cookbook ou visite a
[documentação da API do Navigator][`Navigator`].

## Usando rotas nomeadas

:::note
Não recomendamos o uso de rotas nomeadas para a maioria das aplicações.
Para mais informações, consulte a seção Limitações abaixo.
:::

Aplicações com requisitos simples de navegação e deep linking podem usar o
`Navigator` para navegação e o parâmetro [`MaterialApp.routes`][] para deep
links:

<?code-excerpt "ui/navigation/lib/navigator_named_routes.dart (push-route)"?>
```dart
child: const Text('Open second screen'),
onPressed: () {
  Navigator.pushNamed(context, '/second');
},
```

`/second` representa uma _rota nomeada_ que foi declarada na lista
`MaterialApp.routes`. Para um exemplo completo, siga a receita
[Navigate with named routes][] do Flutter Cookbook.


### Limitações {:#limitations}

Embora as rotas nomeadas possam lidar com deep links, o comportamento é sempre
o mesmo e não pode ser personalizado. Quando um novo deep link é recebido pela
plataforma, o Flutter empurra uma nova `Route` para o Navigator independentemente
de onde o usuário está atualmente.

O Flutter também não suporta o botão de avançar do navegador para aplicações
usando rotas nomeadas. Por essas razões, não recomendamos o uso de rotas nomeadas
na maioria das aplicações.

## Usando o Router

Aplicações Flutter com requisitos avançados de navegação e roteamento (como um
aplicativo web que usa links diretos para cada tela, ou um aplicativo com múltiplos
widgets `Navigator`) devem usar um pacote de roteamento como [go_router][] que pode
analisar o caminho da rota e configurar o `Navigator` sempre que o aplicativo recebe
um novo deep link.

Para usar o Router, mude para o construtor `router` no `MaterialApp` ou
`CupertinoApp` e forneça uma configuração de `Router`. Pacotes de roteamento,
como [go_router][], normalmente fornecem configuração de rota e as rotas
podem ser usadas da seguinte forma:

<?code-excerpt "ui/navigation/lib/navigator_router.dart (push-route)"?>
```dart
child: const Text('Open second screen'),
onPressed: () => context.go('/second'),
```

Como pacotes como go_router são _declarativos_, eles sempre exibirão a(s)
mesma(s) tela(s) quando um deep link for recebido.

:::note Nota para desenvolvedores avançados
Se você preferir não usar um pacote de roteamento
e quiser controle total sobre navegação e roteamento em seu aplicativo, sobrescreva
`RouteInformationParser` e `RouterDelegate`. Quando o estado em seu aplicativo
muda, você pode controlar precisamente a pilha de telas fornecendo uma lista de
objetos `Page` usando o parâmetro `Navigator.pages`. Para mais detalhes, consulte
a documentação da API do `Router`.
:::

## Usando Router e Navigator juntos

O `Router` e o `Navigator` são projetados para trabalhar juntos. Você pode navegar
usando a API do `Router` através de um pacote de roteamento declarativo, como
`go_router`, ou chamando métodos imperativos como `push()` e `pop()` no
`Navigator`.

Quando você navega usando o `Router` ou um pacote de roteamento declarativo, cada
rota no Navigator é _page-backed_, significando que foi criada a partir de uma
[`Page`][] usando o argumento [`pages`][] no construtor do `Navigator`.
Por outro lado, qualquer `Route` criada chamando `Navigator.push` ou `showDialog`
adicionará uma rota _pageless_ ao Navigator. Se você está usando um pacote de
roteamento, rotas que são _page-backed_ são sempre deep-linkable, enquanto rotas
_pageless_ não são.

Quando uma `Route` _page-backed_ é removida do `Navigator`, todas as rotas
_pageless_ após ela também são removidas. Por exemplo, se um deep link navega
removendo uma rota _page-backed_ do Navigator, todas as rotas _pageless_ depois
(até a próxima rota _page-backed_) também são removidas.

:::note
Você não pode prevenir navegação de telas page-backed usando `WillPopScope`.
Em vez disso, você deve consultar a documentação da API do seu pacote de roteamento.
:::

## Suporte para web

Aplicações usando a classe `Router` se integram com a History API do navegador para
fornecer uma experiência consistente ao usar os botões de voltar e avançar do
navegador. Sempre que você navega usando o `Router`, uma entrada na History API é
adicionada à pilha de histórico do navegador. Pressionar o botão **voltar** usa
_[navegação cronológica reversa][reverse chronological navigation]_, significando
que o usuário é levado ao local visitado anteriormente que foi mostrado usando o
`Router`. Isso significa que se o usuário remove uma página do `Navigator` e então
pressiona o botão **voltar** do navegador, a página anterior é empurrada de volta
para a pilha.

## Mais informações

Para mais informações sobre navegação e roteamento, confira os seguintes
recursos:

* O Flutter cookbook inclui múltiplas [navigation recipes][] que mostram como
  usar o `Navigator`.
* A documentação da API do [`Navigator`][] e [`Router`][] contém detalhes sobre
  como configurar navegação declarativa sem um pacote de roteamento.
* [Understanding navigation][], uma página da documentação do Material Design,
  descreve conceitos para projetar a navegação em seu aplicativo, incluindo
  explicações para navegação para frente, para cima e cronológica.
* [Learning Flutter's new navigation and routing system][], um artigo no
  Medium, descreve como usar o widget `Router` diretamente, sem
  um pacote de roteamento.
* O [Router design document][] contém a motivação e o design da
  API do `Router`.

[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`Router`]: {{site.api}}/flutter/widgets/Router-class.html
[Deep linking]: /ui/navigation/deep-linking
[navigation recipes]: /cookbook/navigation
[`MaterialApp.routes`]: {{site.api}}/flutter/material/MaterialApp/routes.html
[Navigate with named routes]: /cookbook/navigation/named-routes
[go_router]: {{site.pub}}/packages/go_router
[`Page`]: {{site.api}}/flutter/widgets/Page-class.html
[`pages`]: {{site.api}}/flutter/widgets/Navigator/pages.html
[reverse chronological navigation]: https://material.io/design/navigation/understanding-navigation.html#reverse-navigation
[Understanding navigation]: https://material.io/design/navigation/understanding-navigation.html
[Learning Flutter's new navigation and routing system]: {{site.medium}}/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade
[Router design document]: {{site.main-url}}/go/navigator-with-router
