---
ia-translate: true
title: Navegar para uma nova tela e voltar
description: Como navegar entre rotas.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/navigation/navigation_basics"?>

A maioria dos aplicativos contém diversas telas para exibir diferentes tipos de
informação.
Por exemplo, um aplicativo pode ter uma tela que exibe produtos.
Quando o usuário toca na imagem de um produto, uma nova tela exibe
detalhes sobre o produto.

:::note Terminologia
Em Flutter, _telas_ e _páginas_ são chamadas de _rotas_.
O restante desta receita se refere a rotas.
:::

No Android, uma rota é equivalente a uma Activity.
No iOS, uma rota é equivalente a um ViewController.
No Flutter, uma rota é apenas um widget.

Esta receita usa o [`Navigator`][] para navegar para uma nova rota.

As próximas seções mostram como navegar entre duas rotas,
usando estas etapas:

  1. Criar duas rotas.
  2. Navegar para a segunda rota usando Navigator.push().
  3. Retornar para a primeira rota usando Navigator.pop().

## 1. Criar duas rotas

Primeiro, crie duas rotas para trabalhar. Como este é um exemplo básico,
cada rota contém apenas um único botão. Tocar no botão na
primeira rota navega para a segunda rota. Tocar no botão na
segunda rota retorna para a primeira rota.

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
            // Navegar para a segunda rota quando tocado.
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
            // Navegar de volta para a primeira rota quando tocado.
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
```

## 2. Navegar para a segunda rota usando Navigator.push()

Para mudar para uma nova rota, use o método [`Navigator.push()`][].
O método `push()` adiciona uma `Route` à pilha de rotas gerenciadas pelo
`Navigator`. De onde vem a `Route`?
Você pode criar a sua própria, ou usar uma [`MaterialPageRoute`][],
que é útil porque faz a transição para a
nova rota usando uma animação específica da plataforma.

No método `build()` do widget `FirstRoute`,
atualize o callback `onPressed()`:

<?code-excerpt "lib/main_step2.dart (first-route-on-pressed)" replace="/^\},$/}/g"?>
```dart
// Dentro do widget `FirstRoute`:
onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SecondRoute()),
  );
}
```

## 3. Retornar para a primeira rota usando Navigator.pop()

Como você fecha a segunda rota e retorna para a primeira?
Usando o método [`Navigator.pop()`][].
O método `pop()` remove a `Route` atual da pilha de
rotas gerenciadas pelo `Navigator`.

Para implementar um retorno à rota original, atualize o callback `onPressed()`
no widget `SecondRoute`:

<?code-excerpt "lib/main_step2.dart (second-route-on-pressed)" replace="/^\},$/}/g"?>
```dart
// Dentro do widget SecondRoute
onPressed: () {
  Navigator.pop(context);
}
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de navegação Flutter no DartPad" run="true"
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
  <img src="/assets/images/docs/cookbook/navigation-basics.gif" alt="Demonstração de conceitos básicos de navegação" class="site-mobile-screenshot" />
</noscript>

## Navegação com CupertinoPageRoute

No exemplo anterior você aprendeu como navegar entre telas
usando a [`MaterialPageRoute`][] do [Material Components][].
No entanto, no Flutter você não está limitado à linguagem de design Material,
em vez disso, você também tem acesso aos widgets [Cupertino][] (estilo iOS).

Implementar a navegação com widgets Cupertino segue as mesmas etapas
de quando usar [`MaterialPageRoute`][],
mas em vez disso você usa [`CupertinoPageRoute`][]
que fornece uma animação de transição estilo iOS.

No exemplo a seguir, esses widgets foram substituídos:

- [`MaterialApp`][] substituído por [`CupertinoApp`].
- [`Scaffold`][] substituído por [`CupertinoPageScaffold`][].
- [`ElevatedButton`][] substituído por [`CupertinoButton`][].

Dessa forma, o exemplo segue a atual linguagem de design do iOS.

:::secondary
Você não precisa substituir todos os widgets Material por versões Cupertino
para usar [`CupertinoPageRoute`][]
já que o Flutter permite que você misture e combine widgets Material e Cupertino
dependendo das suas necessidades.
:::

<?code-excerpt "lib/main_cupertino.dart"?>
```dartpad title="Exemplo prático do tema Cupertino do Flutter no DartPad" run="true"
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
  <img src="/assets/images/docs/cookbook/navigation-basics-cupertino.gif" alt="Demonstração de conceitos básicos de navegação no Cupertino" class="site-mobile-screenshot" />
</noscript>

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
[`Scaffold`]: {{site.api}}/flutter/material/Scaffold-class.html
