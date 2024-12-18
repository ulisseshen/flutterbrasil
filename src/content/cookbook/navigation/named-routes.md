---
ia-translate: true
title: Navegar com rotas nomeadas
description: Como implementar rotas nomeadas para navegar entre telas.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/navigation/named_routes"?>

:::note
Rotas nomeadas não são mais recomendadas para a maioria das
aplicações. Para mais informações, veja
[Limitações][] na página de [visão geral da navegação][].
:::

[Limitações]: /ui/navigation#limitations
[visão geral da navegação]: /ui/navigation

Na receita [Navegar para uma nova tela e voltar][],
você aprendeu como navegar para uma nova tela criando uma nova rota e
empurrando-a para o [`Navigator`][].

No entanto, se você precisar navegar para a mesma tela em muitas partes
do seu aplicativo, essa abordagem pode resultar em duplicação de código.
A solução é definir uma _rota nomeada_ e usar a rota nomeada para navegação.

Para trabalhar com rotas nomeadas,
use a função [`Navigator.pushNamed()`][].
Este exemplo replica a funcionalidade da receita original,
demonstrando como usar rotas nomeadas seguindo os passos abaixo:

  1. Criar duas telas.
  2. Definir as rotas.
  3. Navegar para a segunda tela usando `Navigator.pushNamed()`.
  4. Retornar para a primeira tela usando `Navigator.pop()`.

## 1. Criar duas telas

Primeiro, crie duas telas para trabalhar. A primeira tela contém um
botão que navega para a segunda tela. A segunda tela contém um
botão que volta para a primeira.

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
            // Navegar para a segunda tela quando tocado.
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
            // Navegar de volta para a primeira tela quando tocado.
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
para o construtor [`MaterialApp`][]: o `initialRoute`
e as `routes` em si.

A propriedade `initialRoute` define com qual rota o aplicativo deve começar.
A propriedade `routes` define as rotas nomeadas disponíveis e os widgets
a serem construídos ao navegar para essas rotas.

{% comment %}
RegEx remove a vírgula final
{% endcomment %}
<?code-excerpt "lib/main.dart (MaterialApp)" replace="/^\),$/)/g"?>
```dart
MaterialApp(
  title: 'Named Routes Demo',
  // Inicia o aplicativo com a rota nomeada "/". Neste caso, o aplicativo inicia
  // no widget FirstScreen.
  initialRoute: '/',
  routes: {
    // Ao navegar para a rota "/", constrói o widget FirstScreen.
    '/': (context) => const FirstScreen(),
    // Ao navegar para a rota "/second", constrói o widget SecondScreen.
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
tabela `routes` e iniciar a tela.

No método `build()` do widget `FirstScreen`, atualize o callback `onPressed()`:

{% comment %}
RegEx remove a vírgula final
{% endcomment %}
<?code-excerpt "lib/main.dart (PushNamed)" replace="/,$//g"?>
```dart
// Dentro do widget `FirstScreen`
onPressed: () {
  // Navega para a segunda tela usando uma rota nomeada.
  Navigator.pushNamed(context, '/second');
}
```

## 4. Retornar para a primeira tela

Para navegar de volta para a primeira tela, use a
função [`Navigator.pop()`][].

{% comment %}
RegEx remove a vírgula final
{% endcomment %}
<?code-excerpt "lib/main.dart (Pop)" replace="/,$//g"?>
```dart
// Dentro do widget SecondScreen
onPressed: () {
  // Navega de volta para a primeira tela removendo a rota atual
  // da pilha.
  Navigator.pop(context);
}
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de rotas nomeadas do Flutter no DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Named Routes Demo',
      // Inicia o aplicativo com a rota nomeada "/". Neste caso, o aplicativo inicia
      // no widget FirstScreen.
      initialRoute: '/',
      routes: {
        // Ao navegar para a rota "/", constrói o widget FirstScreen.
        '/': (context) => const FirstScreen(),
        // Ao navegar para a rota "/second", constrói o widget SecondScreen.
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
          // Dentro do widget `FirstScreen`
          onPressed: () {
            // Navega para a segunda tela usando uma rota nomeada.
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
          // Dentro do widget SecondScreen
          onPressed: () {
            // Navega de volta para a primeira tela removendo a rota atual
            // da pilha.
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
  <img src="/assets/images/docs/cookbook/navigation-basics.gif" alt="Demonstração de Noções Básicas de Navegação" class="site-mobile-screenshot" />
</noscript>


[`MaterialApp`]: {{site.api}}/flutter/material/MaterialApp-class.html
[Navegar para uma nova tela e voltar]: /cookbook/navigation/navigation-basics
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`Navigator.pop()`]: {{site.api}}/flutter/widgets/Navigator/pop.html
[`Navigator.pushNamed()`]: {{site.api}}/flutter/widgets/Navigator/pushNamed.html
