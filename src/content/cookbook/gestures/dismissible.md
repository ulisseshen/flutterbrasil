---
ia-translate: true
title: Implementar o gesto de deslizar para dispensar
description: Como implementar o gesto de deslizar para dispensar ou excluir.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/gestures/dismissible"?>

O padrão "deslizar para dispensar" é comum em muitos aplicativos móveis.
Por exemplo, ao escrever um aplicativo de e-mail,
você pode querer permitir que um usuário deslize mensagens de e-mail
para excluí-las de uma lista.

O Flutter facilita essa tarefa fornecendo o
widget [`Dismissible`][].
Aprenda como implementar o gesto de deslizar para dispensar com as seguintes etapas:

  1. Crie uma lista de itens.
  2. Envolva cada item em um widget `Dismissible`.
  3. Forneça indicadores de "deixar para trás".

## 1. Crie uma lista de itens

Primeiro, crie uma lista de itens. Para obter instruções detalhadas
sobre como criar uma lista,
siga a receita [Trabalhando com listas longas][].

### Crie uma fonte de dados

Neste exemplo,
você precisa de 20 itens de amostra para trabalhar.
Para manter a simplicidade, gere uma lista de strings.

<?code-excerpt "lib/main.dart (Items)"?>
```dart
final items = List<String>.generate(20, (i) => 'Item ${i + 1}');
```

### Converta a fonte de dados em uma lista

Exiba cada item da lista na tela. Os usuários não
poderão dispensar esses itens deslizando por enquanto.

<?code-excerpt "lib/step1.dart (ListView)" replace="/^body: //g;/^\),$/)/g"?>
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(items[index]),
    );
  },
)
```

## 2. Envolva cada item em um widget Dismissible

Nesta etapa,
dê aos usuários a capacidade de deslizar um item da lista usando o
widget [`Dismissible`][].

Depois que o usuário deslizar o item,
remova o item da lista e exiba uma snackbar.
Em um aplicativo real, você pode precisar executar uma lógica mais complexa,
como remover o item de um serviço da Web ou banco de dados.

Atualize a função `itemBuilder()` para retornar um widget `Dismissible`:

<?code-excerpt "lib/step2.dart (Dismissible)"?>
```dart
itemBuilder: (context, index) {
  final item = items[index];
  return Dismissible(
    // Cada Dismissible deve conter uma Key. Keys permitem que o Flutter
    // identifique widgets de forma única.
    key: Key(item),
    // Forneça uma função que diga ao aplicativo
    // o que fazer depois que um item for dispensado por deslize.
    onDismissed: (direction) {
      // Remova o item da fonte de dados.
      setState(() {
        items.removeAt(index);
      });

      // Em seguida, mostre uma snackbar.
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$item dispensado')));
    },
    child: ListTile(
      title: Text(item),
    ),
  );
},
```

## 3. Forneça indicadores de "deixar para trás"

Como está,
o aplicativo permite que os usuários dispensem itens da lista, mas não
dá uma indicação visual do que acontece quando o fazem.
Para fornecer uma dica de que os itens são removidos,
exiba um indicador de "deixar para trás" enquanto eles
deslizam o item para fora da tela. Neste caso,
o indicador é um fundo vermelho.

Para adicionar o indicador,
forneça um parâmetro `background` ao `Dismissible`.


```dart diff
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$item dispensado')));
  },
+ // Mostre um fundo vermelho enquanto o item é dispensado por deslize.
+ background: Container(color: Colors.red),
  child: ListTile(
    title: Text(item),
  ),
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de deslizar para dispensar do Flutter no DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// MyApp é um StatefulWidget. Isso permite atualizar o estado do
// widget quando um item é removido.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final items = List<String>.generate(20, (i) => 'Item ${i + 1}');

  @override
  Widget build(BuildContext context) {
    const title = 'Dispensando Itens';

    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Dismissible(
              // Cada Dismissible deve conter uma Key. Keys permitem que o Flutter
              // identifique widgets de forma única.
              key: Key(item),
              // Forneça uma função que diga ao aplicativo
              // o que fazer depois que um item for dispensado por deslize.
              onDismissed: (direction) {
                // Remova o item da fonte de dados.
                setState(() {
                  items.removeAt(index);
                });

                // Em seguida, mostre uma snackbar.
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('$item dispensado')));
              },
              // Mostre um fundo vermelho enquanto o item é dispensado por deslize.
              background: Container(color: Colors.red),
              child: ListTile(
                title: Text(item),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/dismissible.gif" alt="Demonstração do Dismissible" class="site-mobile-screenshot" />
</noscript>


[`Dismissible`]: {{site.api}}/flutter/widgets/Dismissible-class.html
[Trabalhando com listas longas]: /cookbook/lists/long-lists
