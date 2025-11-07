---
title: Navegar com rotas nomeadas
description: Como implementar rotas nomeadas para navegar entre telas.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
ia-translate: true
---

<?code-excerpt path-base="cookbook/navigation/named_routes"?>

:::note
Rotas nomeadas não são mais recomendadas para a maioria
das aplicações. Para mais informações, veja
[Limitações][] na página [visão geral de navegação][].
:::

[Limitações]: /ui/navigation#limitations
[visão geral de navegação]: /ui/navigation

Na receita [Navegar para uma nova tela e voltar][],
você aprendeu como navegar para uma nova tela criando uma nova rota e
enviando-a para o [`Navigator`][].

No entanto, se você precisa navegar para a mesma tela em muitas partes
do seu app, essa abordagem pode resultar em duplicação de código.
A solução é definir uma _rota nomeada_,
e usar a rota nomeada para navegação.

Para trabalhar com rotas nomeadas,
use a função [`Navigator.pushNamed()`][].
Este exemplo replica a funcionalidade da receita original,
demonstrando como usar rotas nomeadas usando os seguintes passos:

  1. Criar duas telas.
  2. Definir as rotas.
  3. Navegar para a segunda tela usando `Navigator.pushNamed()`.
  4. Retornar à primeira tela usando `Navigator.pop()`.

## 1. Criar duas telas

Primeiro, crie duas telas para trabalhar. A primeira tela contém um
botão que navega para a segunda tela. A segunda tela contém um
botão que navega de volta para a primeira.

<?code-excerpt "lib/main_original.dart"?>
```dart
import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the second screen when tapped.
          },
          child: const Text('Launch screen'),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first screen when tapped.
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
```

## 2. Definir as rotas

Em seguida, defina as rotas fornecendo propriedades adicionais
ao construtor [`MaterialApp`][]: a `initialRoute`
e as próprias `routes`.

A propriedade `initialRoute` define com qual rota o app deve começar.
A propriedade `routes` define as rotas nomeadas disponíveis e os widgets
a serem construídos ao navegar para essas rotas.

{% comment %}
RegEx removes the trailing comma
{% endcomment %}
<?code-excerpt "lib/main.dart (MaterialApp)" replace="/^\),$/)/g"?>
```dart
MaterialApp(
  title: 'Named Routes Demo',
  // Start the app with the "/" named route. In this case, the app starts
  // on the FirstScreen widget.
  initialRoute: '/',
  routes: {
    // When navigating to the "/" route, build the FirstScreen widget.
    '/': (context) => const FirstScreen(),
    // When navigating to the "/second" route, build the SecondScreen widget.
    '/second': (context) => const SecondScreen(),
  },
)
```

:::warning
Ao usar `initialRoute`, **não** defina uma propriedade `home`.
:::

## 3. Navegar para a segunda tela

Com os widgets e rotas no lugar, acione a navegação usando o
método [`Navigator.pushNamed()`][].
Isso diz ao Flutter para construir o widget definido na
tabela `routes` e lançar a tela.

No método `build()` do widget `FirstScreen`, atualize o callback `onPressed()`:

{% comment %}
RegEx removes the trailing comma
{% endcomment %}
<?code-excerpt "lib/main.dart (PushNamed)" replace="/,$//g"?>
```dart
// Within the `FirstScreen` widget
onPressed: () {
  // Navigate to the second screen using a named route.
  Navigator.pushNamed(context, '/second');
}
```

## 4. Retornar à primeira tela

Para navegar de volta à primeira tela, use a
função [`Navigator.pop()`][].

{% comment %}
RegEx removes the trailing comma
{% endcomment %}
<?code-excerpt "lib/main.dart (Pop)" replace="/,$//g"?>
```dart
// Within the SecondScreen widget
onPressed: () {
  // Navigate back to the first screen by popping the current route
  // off the stack.
  Navigator.pop(context);
}
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter Named Routes hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Named Routes Demo',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const FirstScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/second': (context) => const SecondScreen(),
      },
    ),
  );
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          // Within the `FirstScreen` widget
          onPressed: () {
            // Navigate to the second screen using a named route.
            Navigator.pushNamed(context, '/second');
          },
          child: const Text('Launch screen'),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          // Within the SecondScreen widget
          onPressed: () {
            // Navigate back to the first screen by popping the current route
            // off the stack.
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


[`MaterialApp`]: {{site.api}}/flutter/material/MaterialApp-class.html
[Navegar para uma nova tela e voltar]: /cookbook/navigation/navigation-basics
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`Navigator.pop()`]: {{site.api}}/flutter/widgets/Navigator/pop.html
[`Navigator.pushNamed()`]: {{site.api}}/flutter/widgets/Navigator/pushNamed.html
