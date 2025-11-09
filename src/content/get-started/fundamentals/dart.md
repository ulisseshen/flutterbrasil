---
ia-translate: true
title: Introdução ao Dart
description: Aprenda sobre a linguagem de programação Dart
prev:
  title: Fundamentals
  path: /get-started/fundamentals
next:
  title: Widgets
  path: /get-started/fundamentals/widgets
---

Para começar com Flutter,
você precisa ter alguma familiaridade com
a linguagem de programação Dart, na qual as
aplicações Flutter são escritas.
Esta página é uma introdução gentil ao Dart,
e se você se sentir confortável lendo os
exemplos de código, sinta-se livre para pular esta página.
Você não precisa ser um especialista em Dart para
continuar com esta série.

## Dart

Aplicações Flutter são construídas em [Dart][],
uma linguagem que parecerá familiar
para qualquer pessoa que já escreveu Java, Javascript,
ou qualquer outra linguagem similar ao C.

:::note
Instalar Flutter também instala o Dart,
então você não precisa instalar o Dart separadamente.
:::

O exemplo a seguir é um pequeno programa que
busca dados de dart.dev,
decodifica o json retornado,
e imprime no console.
Se você está confiante na sua habilidade de
entender este programa,
sinta-se livre para pular para a próxima página.

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
    print('Failed to retrieve the http package!');
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

Este programa tem duas partes:
a declaração da classe `Package`, e a lógica de negócio,
que está contida na função [`main`][].

A classe `Package` contém muitas das funcionalidades mais comuns
que você usará ao trabalhar com [classes em Dart][classes in Dart].
Esta classe tem três membros,
e define um construtor e um método.

A linguagem Dart é [type safe][]; ela usa
verificação de tipo estática para garantir que
o valor de uma variável sempre corresponda ao
tipo estático da variável.
Ao definir uma classe, anotar os membros com
`String` é obrigatório,
mas geralmente é opcional devido à inferência de tipo.
Na função `main` neste exemplo
há várias linhas que começam com `final variableName =`.
Estas linhas são type safe,
apesar de não terem um tipo explicitamente declarado.

Dart também tem [sound null safety][] integrado.
No exemplo, o membro `description` é
declarado com o tipo `String?`.
O `?` no final de `String?` significa que
esta propriedade pode ser null.
Os outros dois membros não podem ser null,
e o programa não compilará se
você tentar defini-los como `null`.
Você pode ver isso demonstrado no construtor da
classe `Package`. Ele recebe dois argumentos obrigatórios
posicionais e um argumento opcional nomeado.

A seguir no exemplo está a função `main`.
Todos os programas Dart, incluindo apps Flutter,
começam com uma função `main`.
A função demonstra várias funcionalidades básicas da linguagem Dart,
incluindo o uso de bibliotecas, marcação de funções como async,
chamadas de função, uso de controle de fluxo com `if`,
e mais.

:::note Onde vai o código de inicialização?
O ponto de entrada principal em um app
Flutter inicial está em `lib/main.dart`.
O método `main` padrão se parece
com o seguinte:

```dart title="lib/main.dart"
void main() {
  runApp(const MyApp());
}
```

Execute qualquer inicialização _rápida_ (menos de um ou dois frames)
_antes_ de chamar `runApp()`,
embora esteja ciente de que a árvore de widgets ainda não foi criada.
Se você quiser executar uma inicialização que leva tempo,
como carregar dados do disco ou pela rede,
faça isso de uma forma que não bloqueie a thread principal da UI.
Para mais informações, confira [Asynchronous programming][],
a API [`FutureBuilder`][], [Deferred components][],
ou a receita do cookbook [Working with long lists][],
conforme apropriado.

Todo stateful widget tem um método `initState()`
que é chamado quando o widget é
criado e adicionado à árvore de widgets.
Você pode sobrescrever este método e executar
inicialização lá, embora a primeira linha deste
método _deva_ ser `super.initState()`.

Finalmente, fazer hot reload do seu app _não_
chama `initState` ou `main` novamente.
Hot restart chama ambos.
:::

Se estas funcionalidades não são familiares para você,
você pode encontrar recursos para aprender Dart na
página [Bootstrap into Dart][].

## Next: Widgets

Esta página é uma introdução ao Dart,
e ajuda você a se familiarizar com a leitura
de código Flutter e Dart. Está tudo bem se você não
se sentir claro sobre todo o código nesta página,
contanto que você se sinta confortável com a _sintaxe_
da linguagem Dart.
Na próxima seção, você aprenderá sobre o
bloco de construção de apps Flutter: widgets.

[Asynchronous programming]: {{site.dart-site}}/libraries/async/async-await
[Dart]: {{site.dart-site}}
[Deferred components]: /perf/deferred-components
[`main`]: {{site.dart-site}}/language#hello-world
[classes in Dart]: {{site.dart-site}}/language/classes
[`FutureBuilder`]: {{site.api}}/flutter/widgets/FutureBuilder-class.html
[type safe]: {{site.dart-site}}/language/type-system
[sound null safety]: {{site.dart-site}}/null-safety
[Working with long lists]: /cookbook/lists/long-lists
[Bootstrap into Dart]: /resources/bootstrap-into-dart

## Feedback

À medida que esta seção do site está evoluindo,
nós [agradecemos seu feedback][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="dart"
