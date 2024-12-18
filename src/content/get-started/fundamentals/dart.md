---
ia-translate: true
title: Introdução ao Dart
description: Aprenda sobre a linguagem de programação Dart
prev:
  title: Fundamentos
  path: /get-started/fundamentals
next:
  title: Widgets
  path: /get-started/fundamentals/widgets
---

Para começar com Flutter, você precisa ter alguma familiaridade com a linguagem de programação Dart, na qual os aplicativos Flutter são escritos. Esta página é uma introdução suave ao Dart e, se você se sentir à vontade para ler os exemplos de código, sinta-se à vontade para pular esta página. Você não precisa ser um especialista em Dart para continuar com esta série.

## Dart

Aplicativos Flutter são construídos em [Dart][], uma linguagem que parecerá familiar para qualquer pessoa que já escreveu Java, Javascript ou qualquer outra linguagem semelhante a C.

:::note
Instalar o Flutter também instala o Dart, então você não precisa instalar o Dart separadamente.
:::

O exemplo a seguir é um pequeno programa que busca dados de dart.dev, decodifica o json retornado e o imprime no console. Se você está confiante em sua capacidade de entender este programa, sinta-se à vontade para pular para a próxima página.

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class Package {
  final String name;
  final String latestVersion; 
  final String? description;

  Package(this.name, this.latestVersion, {this.description});

  @override
  String toString() {
    return 'Package{name: $name, latestVersion: $latestVersion, description: $description}';
  }
}

void main() async {
  final httpPackageUrl = Uri.https('dart.dev', '/f/packages/http.json');
  final httpPackageResponse = await http.get(httpPackageUrl);
  if (httpPackageResponse.statusCode != 200) {
    print('Falha ao recuperar o pacote http!');
    return;
  }
  final json = jsonDecode(httpPackageResponse.body);
  final package = Package(
    json['name'],
    json['latestVersion'],
    description: json['description'],
  );
  print(package);
}
```

Este programa tem duas partes: a declaração da classe `Package` e a lógica de negócios, que está contida na função [`main`][].

A classe `Package` contém muitos dos recursos mais comuns que você usará ao trabalhar com [classes em Dart][]. Esta classe tem três membros e define um construtor e um método.

A linguagem Dart é [type safe][]; ela usa verificação de tipo estática para garantir que o valor de uma variável sempre corresponda ao tipo estático da variável. Ao definir uma classe, anotar os membros com `String` é obrigatório, mas muitas vezes é opcional devido à inferência de tipo. Na função `main` neste exemplo, há muitas linhas que começam com `final variableName =`. Essas linhas são type safe, apesar de não terem um tipo explicitamente definido.

Dart também possui [sound null safety][] integrado. No exemplo, o membro `description` é declarado com o tipo `String?`. O `?` no final de `String?` significa que esta propriedade pode ser nula. Os outros dois membros não podem ser nulos e o programa não será compilado se você tentar defini-los como `null`. Você pode ver isso demonstrado no construtor da classe `Package`. Ele recebe dois argumentos posicionais obrigatórios e um argumento nomeado opcional.

Em seguida, no exemplo, está a função `main`. Todos os programas Dart, incluindo aplicativos Flutter, começam com uma função `main`. A função mostra vários recursos básicos da linguagem Dart, incluindo o uso de bibliotecas, a marcação de funções como async, a realização de chamadas de função, o uso de controle de fluxo de instruções `if` e muito mais.

:::note Onde o código de inicialização vai?
O ponto de entrada principal em um aplicativo Flutter inicial é em `lib/main.dart`. O método `main` padrão se parece com o seguinte:

```dart title="lib/main.dart"
void main() {
  runApp(const MyApp());
}       
```

Execute qualquer inicialização _rápida_ (menos de um ou dois frames) _antes_ de chamar `runApp()`, embora esteja ciente de que a árvore de widgets ainda não foi criada. Se você deseja realizar uma inicialização que leva um tempo, como carregar dados do disco ou pela rede, faça-o de uma maneira que não bloqueie a thread da interface do usuário principal. Para obter mais informações, consulte [Programação assíncrona][], a API [`FutureBuilder`][], [Componentes adiados][] ou a receita do livro de receitas [Trabalhando com listas longas][], conforme apropriado.

Todo widget stateful tem um método `initState()` que é chamado quando o widget é criado e adicionado à árvore de widgets. Você pode substituir este método e realizar a inicialização lá, embora a primeira linha deste método _deva_ ser `super.initState()`.

Finalmente, o hot reloading do seu aplicativo _não_ chama `initState` ou `main` novamente. O hot restart chama ambos.
:::

Se esses recursos não são familiares para você, você pode encontrar recursos para aprender Dart na página [Bootstrap into Dart][].

## Próximo: Widgets

Esta página é uma introdução ao Dart e ajuda você a se familiarizar com a leitura de código Flutter e Dart. Não tem problema se você não se sentir claro sobre todo o código nesta página, contanto que se sinta confortável com a _sintaxe_ da linguagem Dart. Na próxima seção, você aprenderá sobre os blocos de construção de aplicativos Flutter: widgets.

[Programação assíncrona]: {{site.dart-site}}/libraries/async/async-await
[Dart]: {{site.dart-site}}
[Componentes adiados]: /perf/deferred-components
[`main`]: {{site.dart-site}}/language#hello-world
[classes em Dart]: {{site.dart-site}}/language/classes
[`FutureBuilder`]: {{site.api}}/flutter/widgets/FutureBuilder-class
[type safe]: {{site.dart-site}}/language/type-system
[sound null safety]: {{site.dart-site}}/null-safety
[Trabalhando com listas longas]: /cookbook/lists/long-lists
[Bootstrap into Dart]: /resources/bootstrap-into-dart

## Feedback

Como esta seção do site está evoluindo, nós [agradecemos seu feedback][]!

[agradecemos seu feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="dart"

