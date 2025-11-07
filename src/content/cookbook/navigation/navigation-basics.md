---
title: Navegar para uma nova tela e voltar
description: Como navegar entre rotas.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
ia-translate: true
---

<?code-excerpt path-base="cookbook/navigation/navigation_basics"?>

A maioria dos apps contém várias telas para exibir diferentes tipos de
informação.
Por exemplo, um app pode ter uma tela que exibe produtos.
Quando o usuário toca na imagem de um produto, uma nova tela exibe
detalhes sobre o produto.

:::note Terminologia
No Flutter, _screens_ e _pages_ são chamadas de _routes_.
O restante desta receita se refere a routes.
:::

No Android, uma route é equivalente a uma `Activity`.
No iOS, uma route é equivalente a um `ViewController`.
No Flutter, uma route é apenas um widget.

Esta receita usa o [`Navigator`][] para navegar para uma nova route.

As próximas seções mostram como navegar entre duas routes,
usando os seguintes passos:

  1. Criar duas routes.
  2. Navegar para a segunda route usando Navigator.push().
  3. Retornar à primeira route usando Navigator.pop().

## 1. Criar duas routes

Primeiro, crie duas routes para trabalhar. Como este é um exemplo básico,
cada route contém apenas um único botão. Tocar no botão da
primeira route navega para a segunda route. Tocar no botão da
segunda route retorna à primeira route.

Primeiro, configure a estrutura visual:

<?code-excerpt "lib/main_step1.dart (first-second-routes)"?>
```dart
class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open route'),
          onPressed: () {
            // Navigate to second route when tapped.
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
```

## 2. Navegar para a segunda route usando Navigator.push()

Para mudar para uma nova route, use o método [`Navigator.push()`][].
O método `push()` adiciona uma `Route` à pilha de routes gerenciada pelo
`Navigator`. De onde vem a `Route`?
Você pode criar sua própria, ou usar um [`MaterialPageRoute`][],
que é útil porque faz a transição para a
nova route usando uma animação específica da plataforma.

No método `build()` do widget `FirstRoute`,
atualize o callback `onPressed()`:

<?code-excerpt "lib/main_step2.dart (first-route-on-pressed)" replace="/^\},$/}/g"?>
```dart
// Within the `FirstRoute` widget:
onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SecondRoute()),
  );
}
```

## 3. Retornar à primeira route usando Navigator.pop()

Como você fecha a segunda route e retorna à primeira?
Usando o método [`Navigator.pop()`][].
O método `pop()` remove a `Route` atual da pilha de
routes gerenciada pelo `Navigator`.

Para implementar um retorno à route original, atualize o callback `onPressed()`
no widget `SecondRoute`:

<?code-excerpt "lib/main_step2.dart (second-route-on-pressed)" replace="/^\},$/}/g"?>
```dart
// Within the SecondRoute widget
onPressed: () {
  Navigator.pop(context);
}
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter navigation hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open route'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SecondRoute()),
            );
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/navigation-basics.gif" alt="Navigation Basics Demo" class="site-mobile-screenshot" />
</noscript>

## Navegação com CupertinoPageRoute

No exemplo anterior você aprendeu como navegar entre telas
usando o [`MaterialPageRoute`][] de [Material Components][].
No entanto, no Flutter você não está limitado à linguagem de design Material,
ao invés disso, você também tem acesso a widgets [Cupertino][] (estilo iOS).

Implementar navegação com widgets Cupertino segue os mesmos passos
que ao usar [`MaterialPageRoute`][],
mas ao invés disso você usa [`CupertinoPageRoute`][]
que fornece uma animação de transição no estilo iOS.

No exemplo a seguir, esses widgets foram substituídos:

- [`MaterialApp`][] substituído por [`CupertinoApp`].
- [`Scaffold`][] substituído por [`CupertinoPageScaffold`][].
- [`ElevatedButton`][] substituído por [`CupertinoButton`][].

Desta forma, o exemplo segue a linguagem de design atual do iOS.

:::secondary
Você não precisa substituir todos os widgets Material por versões Cupertino
para usar [`CupertinoPageRoute`][]
já que o Flutter permite que você misture widgets Material e Cupertino
dependendo das suas necessidades.
:::

<?code-excerpt "lib/main_cupertino.dart"?>
```dartpad title="Flutter Cupertino theme hands-on example in DartPad" run="true"
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const CupertinoApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('First Route'),
      ),
      child: Center(
        child: CupertinoButton(
          child: const Text('Open route'),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => const SecondRoute()),
            );
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Second Route'),
      ),
      child: Center(
        child: CupertinoButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/navigation-basics-cupertino.gif" alt="Navigation Basics Cupertino Demo" class="site-mobile-screenshot" />
</noscript>

## Métodos adicionais de navegação

A receita neste tópico mostra uma maneira de navegar para uma nova tela e
voltar para a cena anterior, usando os métodos [`push`] e [`pop`] na
classe [`Navigator`], mas existem vários outros métodos estáticos do `Navigator` que
você pode usar. Aqui estão alguns deles:

*   [`pushAndRemoveUntil`]: Adiciona uma rota de navegação à pilha e então remove
    as rotas mais recentes da pilha até que uma condição seja atendida.
*   [`pushReplacement`]: Substitui a rota atual no topo da
    pilha por uma nova.
*   [`replace`]: Substitui uma rota na pilha por outra rota.
*   [`replaceRouteBelow`]: Substitui a rota abaixo de uma rota específica na pilha.
*   [`popUntil`]: Remove as rotas mais recentes que foram adicionadas à pilha de
    rotas de navegação até que uma condição seja atendida.
*   [`removeRoute`]: Remove uma rota específica da pilha.
*   [`removeRouteBelow`]: Remove a rota abaixo de uma rota específica da
    pilha.
*   [`restorablePush`]: Restaura uma rota que foi removida da pilha.

[Cupertino]: {{site.docs}}/ui/widgets/cupertino
[Material Components]: {{site.docs}}/ui/widgets/material
[`CupertinoApp`]: {{site.api}}/flutter/cupertino/CupertinoApp-class.html
[`CupertinoButton`]: {{site.api}}/flutter/cupertino/CupertinoButton-class.html
[`CupertinoPageRoute`]: {{site.api}}/flutter/cupertino/CupertinoPageRoute-class.html
[`CupertinoPageScaffold`]: {{site.api}}/flutter/cupertino/CupertinoPageScaffold-class.html
[`ElevatedButton`]: {{site.api}}/flutter/material/ElevatedButton-class.html
[`MaterialApp`]: {{site.api}}/flutter/material/MaterialApp-class.html
[`MaterialPageRoute`]: {{site.api}}/flutter/material/MaterialPageRoute-class.html
[`Navigator.pop()`]: {{site.api}}/flutter/widgets/Navigator/pop.html
[`Navigator.push()`]: {{site.api}}/flutter/widgets/Navigator/push.html
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`pop`]: {{site.api}}/flutter/widgets/Navigator/pop.html
[`popUntil`]: {{site.api}}/flutter/widgets/Navigator/popUntil.html
[`push`]: {{site.api}}/flutter/widgets/Navigator/push.html
[`pushAndRemoveUntil`]: {{site.api}}/flutter/widgets/Navigator/pushAndRemoveUntil.html
[`pushReplacement`]: {{site.api}}/flutter/widgets/Navigator/pushReplacement.html
[`removeRoute`]: {{site.api}}/flutter/widgets/Navigator/removeRoute.html
[`removeRouteBelow`]: {{site.api}}/flutter/widgets/Navigator/removeRouteBelow.html
[`replace`]: {{site.api}}/flutter/widgets/Navigator/replace.html
[`replaceRouteBelow`]: {{site.api}}/flutter/widgets/Navigator/replaceRouteBelow.html
[`restorablePush`]: {{site.api}}/flutter/widgets/Navigator/restorablePush.html
[`Scaffold`]: {{site.api}}/flutter/material/Scaffold-class.html
