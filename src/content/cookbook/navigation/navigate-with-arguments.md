---
ia-translate: true
title: Passar argumentos para uma rota nomeada
description: Como passar argumentos para uma rota nomeada.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/navigation/navigate_with_arguments"?>

O [`Navigator`][] oferece a capacidade de navegar
para uma rota nomeada de qualquer parte de um aplicativo usando
um identificador comum.
Em alguns casos, você também pode precisar passar argumentos para uma
rota nomeada. Por exemplo, você pode querer navegar para a rota `/user` e
passar informações sobre o usuário para essa rota.

:::note
Rotas nomeadas não são mais recomendadas para a maioria
dos aplicativos. Para obter mais informações, consulte
[Limitações][] na página de [visão geral da navegação][].
:::

[Limitações]: /ui/navigation#limitations
[visão geral da navegação]: /ui/navigation

Você pode realizar essa tarefa usando o parâmetro `arguments` do
método [`Navigator.pushNamed()`][]. Extraia os argumentos usando o
método [`ModalRoute.of()`][] ou dentro de uma função [`onGenerateRoute()`][]
fornecida para o construtor [`MaterialApp`][] ou [`CupertinoApp`][].

Esta receita demonstra como passar argumentos para uma rota nomeada
e ler os argumentos usando `ModalRoute.of()`
e `onGenerateRoute()` usando as seguintes etapas:

  1. Defina os argumentos que você precisa passar.
  2. Crie um widget que extraia os argumentos.
  3. Registre o widget na tabela `routes`.
  4. Navegue até o widget.

## 1. Defina os argumentos que você precisa passar

Primeiro, defina os argumentos que você precisa passar para a nova rota.
Neste exemplo, passe duas informações:
O `title` da tela e uma `message`.

Para passar ambas as informações, crie uma classe que armazene essas informações.

<?code-excerpt "lib/main.dart (ScreenArguments)"?>
```dart
// Você pode passar qualquer objeto para o parâmetro arguments.
// Neste exemplo, crie uma classe que contenha ambos
// um título e uma mensagem personalizáveis.
class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}
```

## 2. Crie um widget que extraia os argumentos

Em seguida, crie um widget que extraia e exiba o
`title` e a `message` de `ScreenArguments`.
Para acessar o `ScreenArguments`,
use o método [`ModalRoute.of()`][].
Este método retorna a rota atual com os argumentos.

<?code-excerpt "lib/main.dart (ExtractArgumentsScreen)"?>
```dart
// Um Widget que extrai os argumentos necessários de
// o ModalRoute.
class ExtractArgumentsScreen extends StatelessWidget {
  const ExtractArgumentsScreen({super.key});

  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    // Extraia os argumentos das configurações do ModalRoute atual
    // e converta-os como ScreenArguments.
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: Center(
        child: Text(args.message),
      ),
    );
  }
}
```

## 3. Registre o widget na tabela `routes`

Em seguida, adicione uma entrada às `routes` fornecidas ao widget `MaterialApp`. As
`routes` definem qual widget deve ser criado com base no nome da rota.

{% comment %}
RegEx remove a declaração de retorno e adiciona o parêntese de fechamento no final
{% endcomment %}
<?code-excerpt "lib/main.dart (routes)" plaster="none" replace="/return //g;/^\);$/)/g"?>
```dart
MaterialApp(
  routes: {
    ExtractArgumentsScreen.routeName: (context) =>
        const ExtractArgumentsScreen(),
  },
)
```

## 4. Navegue até o widget

Finalmente, navegue até `ExtractArgumentsScreen`
quando um usuário tocar em um botão usando [`Navigator.pushNamed()`][].
Forneça os argumentos para a rota através da propriedade `arguments`. O
`ExtractArgumentsScreen` extrai o `title` e a `message` desses
argumentos.

<?code-excerpt "lib/main.dart (PushNamed)"?>
```dart
// Um botão que navega para uma rota nomeada.
// A rota nomeada extrai os argumentos
// por si só.
ElevatedButton(
  onPressed: () {
    // Quando o usuário toca no botão,
    // navegue para uma rota nomeada e
    // forneça os argumentos como um parâmetro
    // opcional.
    Navigator.pushNamed(
      context,
      ExtractArgumentsScreen.routeName,
      arguments: ScreenArguments(
        'Extract Arguments Screen',
        'Esta mensagem é extraída no método build.',
      ),
    );
  },
  child: const Text('Navegar para a tela que extrai argumentos'),
),
```

## Alternativamente, extraia os argumentos usando `onGenerateRoute`

Em vez de extrair os argumentos diretamente dentro do widget, você também pode
extrair os argumentos dentro de uma função [`onGenerateRoute()`][]
e passá-los para um widget.

A função `onGenerateRoute()` cria a rota correta com base no dado
[`RouteSettings`][].

{% comment %}
RegEx remove a declaração de retorno, removeu a propriedade "routes" e adiciona o parêntese de fechamento no final
{% endcomment %}

```dart
MaterialApp(
  // Forneça uma função para lidar com rotas nomeadas.
  // Use esta função para identificar o nomeado
  // rota sendo empurrada e crie a correta
  // Tela.
  onGenerateRoute: (settings) {
    // Se você empurrar a rota PassArguments
    if (settings.name == PassArgumentsScreen.routeName) {
      // Converta os argumentos para o correto
      // tipo: ScreenArguments.
      final args = settings.arguments as ScreenArguments;

      // Em seguida, extraia os dados necessários de
      // os argumentos e passe os dados para o
      // tela correta.
      return MaterialPageRoute(
        builder: (context) {
          return PassArgumentsScreen(
            title: args.title,
            message: args.message,
          );
        },
      );
    }
    // O código só suporta
    // PassArgumentsScreen.routeName agora.
    // Outros valores precisam ser implementados se nós
    // adicioná-los. A asserção aqui ajudará a lembrar
    // nós disso mais acima na pilha de chamadas, já que
    // essa asserção de outra forma dispararia em algum lugar
    // na estrutura.
    assert(false, 'Precisa implementar ${settings.name}');
    return null;
  },
)
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático completo de navegação Flutter no DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        ExtractArgumentsScreen.routeName: (context) =>
            const ExtractArgumentsScreen(),
      },
      // Forneça uma função para lidar com rotas nomeadas.
      // Use esta função para identificar o nomeado
      // rota sendo empurrada e crie a correta
      // Tela.
      onGenerateRoute: (settings) {
        // Se você empurrar a rota PassArguments
        if (settings.name == PassArgumentsScreen.routeName) {
          // Converta os argumentos para o correto
          // tipo: ScreenArguments.
          final args = settings.arguments as ScreenArguments;

          // Em seguida, extraia os dados necessários de
          // os argumentos e passe os dados para o
          // tela correta.
          return MaterialPageRoute(
            builder: (context) {
              return PassArgumentsScreen(
                title: args.title,
                message: args.message,
              );
            },
          );
        }
        // O código só suporta
        // PassArgumentsScreen.routeName agora.
        // Outros valores precisam ser implementados se nós
        // adicioná-los. A asserção aqui ajudará a lembrar
        // nós disso mais acima na pilha de chamadas, já que
        // essa asserção de outra forma dispararia em algum lugar
        // na estrutura.
        assert(false, 'Precisa implementar ${settings.name}');
        return null;
      },
      title: 'Navegação com Argumentos',
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Inicial'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Um botão que navega para uma rota nomeada.
            // A rota nomeada extrai os argumentos
            // por si só.
            ElevatedButton(
              onPressed: () {
                // Quando o usuário toca no botão,
                // navegue para uma rota nomeada e
                // forneça os argumentos como um parâmetro
                // opcional.
                Navigator.pushNamed(
                  context,
                  ExtractArgumentsScreen.routeName,
                  arguments: ScreenArguments(
                    'Tela de Extração de Argumentos',
                    'Esta mensagem é extraída no método build.',
                  ),
                );
              },
              child: const Text('Navegar para a tela que extrai argumentos'),
            ),
            // Um botão que navega para uma rota nomeada.
            // Para esta rota, extraia os argumentos em
            // a função onGenerateRoute e passe-os
            // para a tela.
            ElevatedButton(
              onPressed: () {
                // Quando o usuário toca no botão, navegue
                // para uma rota nomeada e forneça os argumentos
                // como um parâmetro opcional.
                Navigator.pushNamed(
                  context,
                  PassArgumentsScreen.routeName,
                  arguments: ScreenArguments(
                    'Tela de Aceitação de Argumentos',
                    'Esta mensagem é extraída na função onGenerateRoute.',
                  ),
                );
              },
              child: const Text('Navegar para uma nomeada que aceita argumentos'),
            ),
          ],
        ),
      ),
    );
  }
}

// Um Widget que extrai os argumentos necessários de
// o ModalRoute.
class ExtractArgumentsScreen extends StatelessWidget {
  const ExtractArgumentsScreen({super.key});

  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    // Extraia os argumentos das configurações do ModalRoute atual
    // e converta-os como ScreenArguments.
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: Center(
        child: Text(args.message),
      ),
    );
  }
}

// Um Widget que aceita os argumentos necessários através do
// construtor.
class PassArgumentsScreen extends StatelessWidget {
  static const routeName = '/passArguments';

  final String title;
  final String message;

  // Este Widget aceita os argumentos como construtor
  // parâmetros. Ele não extrai os argumentos de
  // o ModalRoute.
  //
  // Os argumentos são extraídos pelo onGenerateRoute
  // função fornecida ao widget MaterialApp.
  const PassArgumentsScreen({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(message),
      ),
    );
  }
}

// Você pode passar qualquer objeto para o parâmetro arguments.
// Neste exemplo, crie uma classe que contenha ambos
// um título e uma mensagem personalizáveis.
class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/navigate-with-arguments.gif" alt="Demonstra a navegação para diferentes rotas com argumentos" class="site-mobile-screenshot" />
</noscript>

[`CupertinoApp`]: {{site.api}}/flutter/cupertino/CupertinoApp-class.html
[`MaterialApp`]: {{site.api}}/flutter/material/MaterialApp-class.html
[`ModalRoute.of()`]: {{site.api}}/flutter/widgets/ModalRoute/of.html
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`Navigator.pushNamed()`]: {{site.api}}/flutter/widgets/Navigator/pushNamed.html
[`onGenerateRoute()`]: {{site.api}}/flutter/widgets/WidgetsApp/onGenerateRoute.html
[`RouteSettings`]: {{site.api}}/flutter/widgets/RouteSettings-class.html
