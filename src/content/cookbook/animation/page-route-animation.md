---
ia-translate: true
title: Animar uma transição de rota de página
description: Como animar a transição de uma página para outra.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/animation/page_route_animation/"?>

Uma linguagem de design, como o Material, define comportamentos padrão ao
transicionar entre rotas (ou telas). Às vezes, no entanto, uma transição
personalizada entre telas pode tornar um aplicativo mais exclusivo. Para ajudar,
[`PageRouteBuilder`][] fornece um objeto [`Animation`].
Esta `Animation` pode ser usada com objetos [`Tween`][] e
[`Curve`][] para personalizar a animação de transição.
Esta receita mostra como transicionar entre
rotas animando a nova rota para dentro da visualização a partir
da parte inferior da tela.

Para criar uma transição de rota de página personalizada, esta receita usa as seguintes etapas:

1. Configurar um PageRouteBuilder
2. Criar um `Tween`
3. Adicionar um `AnimatedWidget`
4. Usar um `CurveTween`
5. Combinar os dois `Tween`s

## 1. Configurar um PageRouteBuilder

Para começar, use um [`PageRouteBuilder`][] para criar um [`Route`][].
`PageRouteBuilder` tem dois callbacks, um para construir o conteúdo da rota
(`pageBuilder`), e outro para construir a transição da rota (`transitionsBuilder`).

:::note
O parâmetro `child` em transitionsBuilder é o widget retornado de
pageBuilder. A função `pageBuilder` só é chamada na primeira vez que a
rota é construída. O framework pode evitar trabalho extra porque `child` permanece o
mesmo durante toda a transição.
:::

O exemplo a seguir cria duas rotas: uma rota inicial com um botão "Go!", e
uma segunda rota intitulada "Page 2".

<?code-excerpt "lib/starter.dart (Starter)"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Page1(),
    ),
  );
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(_createRoute());
          },
          child: const Text('Go!'),
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Page2(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Page 2'),
      ),
    );
  }
}
```

## 2. Criar um Tween

Para fazer a nova página animar de baixo para cima, ela deve animar de
`Offset(0,1)` para `Offset(0, 0)` (geralmente definido usando o construtor `Offset.zero`).
Neste caso, o Offset é um vetor 2D para o
widget ['FractionalTranslation'] [].
Definir o argumento `dy` para 1 representa uma tradução vertical de uma
altura total da página.

O callback `transitionsBuilder` tem um parâmetro `animation`. É um
`Animation<double>` que produz valores entre 0 e 1. Converta o
`Animation<double>` em um `Animation<Offset>` usando um Tween:

<?code-excerpt "lib/starter.dart (step1)"?>
```dart
transitionsBuilder: (context, animation, secondaryAnimation, child) {
  const begin = Offset(0.0, 1.0);
  const end = Offset.zero;
  final tween = Tween(begin: begin, end: end);
  final offsetAnimation = animation.drive(tween);
  return child;
},
```

## 3. Usar um AnimatedWidget

Flutter tem um conjunto de widgets que estendem [`AnimatedWidget`][]
que se reconstróem quando o valor da animação muda. Por exemplo,
SlideTransition usa um `Animation<Offset>` e traduz seu filho (usando um
widget FractionalTranslation) sempre que o valor da animação muda.

AnimatedWidget Retorna um [`SlideTransition`][]
com a `Animation<Offset>` e o widget filho:

<?code-excerpt "lib/starter.dart (step2)"?>
```dart
transitionsBuilder: (context, animation, secondaryAnimation, child) {
  const begin = Offset(0.0, 1.0);
  const end = Offset.zero;
  final tween = Tween(begin: begin, end: end);
  final offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
},
```

## 4. Usar um CurveTween

O Flutter fornece uma seleção de curvas de easing que
ajustam a taxa da animação ao longo do tempo.
A classe [`Curves`][]
fornece um conjunto predefinido de curvas comumente usadas.
Por exemplo, `Curves.easeOut`
faz com que a animação comece rapidamente e termine lentamente.

Para usar uma Curve, crie um novo [`CurveTween`][]
e passe uma Curve para ele:

<?code-excerpt "lib/starter.dart (step3)"?>
```dart
var curve = Curves.ease;
var curveTween = CurveTween(curve: curve);
```

Este novo Tween ainda produz valores de 0 a 1. Na próxima etapa, ele será
combinado com o `Tween<Offset>` da etapa 2.

## 5. Combinar os dois Tweens

Para combinar os tweens,
use [`chain()`][]:

<?code-excerpt "lib/main.dart (Tween)"?>
```dart
const begin = Offset(0.0, 1.0);
const end = Offset.zero;
const curve = Curves.ease;

var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
```

Em seguida, use este tween passando-o para `animation.drive()`. Isso cria um novo
`Animation<Offset>` que pode ser dado ao widget `SlideTransition`:

<?code-excerpt "lib/main.dart (SlideTransition)"?>
```dart
return SlideTransition(
  position: animation.drive(tween),
  child: child,
);
```

Este novo Tween (ou Animatable) produz valores `Offset` avaliando primeiro o
`CurveTween`, depois avaliando o `Tween<Offset>.` Quando a animação é executada, os
valores são calculados nesta ordem:

1. A animação (fornecida ao callback transitionsBuilder) produz valores
   de 0 a 1.
2. O CurveTween mapeia esses valores para novos valores entre 0 e 1 com base em sua
   curve.
3. O `Tween<Offset>` mapeia os valores `double` para valores `Offset`.

Outra maneira de criar uma `Animation<Offset>` com uma curva de easing é usar uma
`CurvedAnimation`:

<?code-excerpt "lib/starter.dart (step4)" replace="/^\},$/}/g"?>
```dart
transitionsBuilder: (context, animation, secondaryAnimation, child) {
  const begin = Offset(0.0, 1.0);
  const end = Offset.zero;
  const curve = Curves.ease;

  final tween = Tween(begin: begin, end: end);
  final curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: curve,
  );

  return SlideTransition(
    position: tween.animate(curvedAnimation),
    child: child,
  );
}
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de roteamento de página Flutter no DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Page1(),
    ),
  );
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(_createRoute());
          },
          child: const Text('Go!'),
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Page2(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Page 2'),
      ),
    );
  }
}
```
<noscript>
  <img src="/assets/images/docs/cookbook/page-route-animation.gif" alt="Demonstração mostrando uma transição de rota de página personalizada animando de baixo para cima na tela" class="site-mobile-screenshot" />
</noscript>


[`AnimatedWidget`]: {{site.api}}/flutter/widgets/AnimatedWidget-class.html
[`Animation`]: {{site.api}}/flutter/animation/Animation-class.html
[`chain()`]: {{site.api}}/flutter/animation/Animatable/chain.html
[`Curve`]: {{site.api}}/flutter/animation/Curve-class.html
[`Curves`]: {{site.api}}/flutter/animation/Curves-class.html
[`CurveTween`]: {{site.api}}/flutter/animation/CurveTween-class.html
['FractionalTranslation']: {{site.api}}/flutter/widgets/FractionalTranslation-class.html
[`PageRouteBuilder`]: {{site.api}}/flutter/widgets/PageRouteBuilder-class.html
[`Route`]: {{site.api}}/flutter/widgets/Route-class.html
[`SlideTransition`]: {{site.api}}/flutter/widgets/SlideTransition-class.html
[`Tween`]: {{site.api}}/flutter/animation/Tween-class.html
