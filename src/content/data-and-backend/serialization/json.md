---
ia-translate: true
title: JSON e serialização
short-title: JSON
description: Como usar JSON com Flutter.
---

<?code-excerpt path-base="data-and-backend/json/"?>

É difícil imaginar um aplicativo móvel que não precise se comunicar com um
servidor web ou armazenar facilmente dados estruturados em algum momento. Ao criar
aplicativos conectados à rede, as chances são de que ele precise consumir um bom e velho
JSON, mais cedo ou mais tarde.

Este guia explora formas de usar JSON com Flutter.
Ele cobre qual solução JSON usar em diferentes cenários e por quê.

:::note Terminology
_Codificação_ e _serialização_ são a mesma
coisa&mdash;transformar uma estrutura de dados em uma string.
_Decodificação_ e _desserialização_ são o
processo oposto&mdash;transformar uma string em uma estrutura de dados.
No entanto, _serialização_ também se refere comumente a todo o processo de
traduzir estruturas de dados de e para um formato mais facilmente legível.

Para evitar confusão, este documento usa "serialização" quando se refere ao
processo geral, e "codificação" e "decodificação" quando se refere
especificamente a esses processos.
:::

## Qual método de serialização JSON é o certo para mim?

Este artigo aborda duas estratégias gerais para trabalhar com JSON:

* Serialização manual
* Serialização automatizada usando geração de código

Diferentes projetos vêm com diferentes complexidades e casos de uso.
Para projetos menores de prova de conceito ou protótipos rápidos,
usar geradores de código pode ser exagero.
Para aplicativos com vários modelos JSON com mais complexidade,
a codificação manual pode rapidamente se tornar tediosa, repetitiva,
e propensa a muitos pequenos erros.

### Use serialização manual para projetos menores

A decodificação manual de JSON refere-se ao uso do decodificador JSON integrado em
`dart:convert`. Envolve passar a string JSON bruta para a função `jsonDecode()`,
e então procurar os valores que você precisa no resultante
`Map<String, dynamic>`.
Ele não possui dependências externas ou processo de configuração específico,
e é bom para uma prova de conceito rápida.

A decodificação manual não funciona bem quando seu projeto se torna maior.
Escrever a lógica de decodificação manualmente pode se tornar difícil de gerenciar e propenso a erros.
Se você tiver um erro de digitação ao acessar um campo JSON inexistente,
seu código lança um erro durante o tempo de execução.

Se você não tiver muitos modelos JSON em seu projeto e estiver
procurando testar um conceito rapidamente,
a serialização manual pode ser a forma como você quer começar.
Para um exemplo de codificação manual, veja
[Serializando JSON manualmente usando dart:convert][].

:::tip
Para prática prática de desserialização JSON e
aproveitando os novos recursos do Dart 3,
confira o codelab [Mergulhe nos padrões e registros do Dart][].
:::

### Use geração de código para projetos de médio a grande porte

Serialização JSON com geração de código significa ter uma biblioteca externa
gerando o boilerplate de codificação para você. Após alguma configuração inicial,
você executa um observador de arquivos que gera o código a partir de suas classes de modelo.
Por exemplo, [`json_serializable`][] e [`built_value`][] são esses
tipos de bibliotecas.

Esta abordagem escala bem para um projeto maior. Nenhum código boilerplate
escrito à mão é necessário, e erros de digitação ao acessar campos JSON são detectados em
tempo de compilação. A desvantagem com a geração de código é que ela requer alguma
configuração inicial. Além disso, os arquivos de origem gerados podem produzir desordem visual
em seu navegador de projeto.

Você pode querer usar código gerado para serialização JSON quando você tiver um
projeto médio ou maior. Para ver um exemplo de codificação JSON baseada em geração de código,
veja [Serializando JSON usando bibliotecas de geração de código][].

## Existe um equivalente GSON/<wbr>Jackson/<wbr>Moshi no Flutter?

A resposta simples é não.

Tal biblioteca exigiria o uso de [reflexão][] de tempo de execução, que é desabilitada no
Flutter. A reflexão em tempo de execução interfere no [tree shaking][], que o Dart
suporta há bastante tempo. Com o tree shaking, você pode "remover" o código não utilizado
de suas construções de release. Isso otimiza o tamanho do aplicativo significativamente.

Como a reflexão torna todo o código implicitamente usado por padrão, ela dificulta o tree
shaking. As ferramentas não podem saber quais partes não são usadas em tempo de execução, então o
código redundante é difícil de remover. Os tamanhos dos aplicativos não podem ser facilmente otimizados
ao usar reflexão.

Embora você não possa usar reflexão em tempo de execução com Flutter,
algumas bibliotecas oferecem APIs semelhantes e fáceis de usar, mas são
baseadas em geração de código. Essa
abordagem é abordada com mais detalhes na
seção [bibliotecas de geração de código][].

<a id="manual-encoding"></a>
## Serializando JSON manualmente usando dart:convert

A serialização básica de JSON no Flutter é muito simples. O Flutter possui uma
biblioteca `dart:convert` integrada que inclui um codificador e um decodificador JSON diretos.

O seguinte JSON de exemplo implementa um modelo de usuário simples.

<?code-excerpt "lib/manual/main.dart (multiline-json)" skip="1" take="4"?>
```json
{
  "name": "John Smith",
  "email": "john@example.com"
}
```

Com `dart:convert`,
você pode serializar este modelo JSON de duas maneiras.

### Serializando JSON embutido

Ao olhar a documentação do [`dart:convert`][],
você verá que pode decodificar o JSON chamando a
função `jsonDecode()`, com a string JSON como argumento do método.

<?code-excerpt "lib/manual/main.dart (manual)"?>
```dart
final user = jsonDecode(jsonString) as Map<String, dynamic>;

print('Olá, ${user['name']}!');
print('Enviamos o link de verificação para ${user['email']}.');
```

Infelizmente, `jsonDecode()` retorna um `dynamic`, o que significa que
você não sabe os tipos dos valores até o tempo de execução. Com esta abordagem,
você perde a maioria dos recursos da linguagem estaticamente tipada: segurança de tipo,
autocompletar e, o mais importante, exceções em tempo de compilação. Seu código
se tornará instantaneamente mais propenso a erros.

Por exemplo, sempre que você acessa os campos `name` ou `email`, você pode rapidamente
introduzir um erro de digitação. Um erro de digitação que o compilador não conhece, já que o
JSON reside em uma estrutura de mapa.

### Serializando JSON dentro de classes de modelo

Combata os problemas mencionados anteriormente introduzindo um modelo simples
classe, chamada `User` neste exemplo. Dentro da classe `User`, você encontrará:

* Um construtor `User.fromJson()`, para construir uma nova instância de `User` a partir de um
  estrutura de mapa.
* Um método `toJson()`, que converte uma instância de `User` em um mapa.

Com essa abordagem, o _código de chamada_ pode ter segurança de tipo,
autocompletar para os campos `name` e `email` e exceções em tempo de compilação.
Se você cometer erros de digitação ou tratar os campos como `int`s em vez de `String`s,
o aplicativo não será compilado, em vez de travar em tempo de execução.

**user.dart**

<?code-excerpt "lib/manual/user.dart"?>
```dart
class User {
  final String name;
  final String email;

  User(this.name, this.email);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        email = json['email'] as String;

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
      };
}
```

A responsabilidade da lógica de decodificação agora é movida para dentro do modelo
em si. Com esta nova abordagem, você pode decodificar um usuário facilmente.

<?code-excerpt "lib/manual/main.dart (from-json)"?>
```dart
final userMap = jsonDecode(jsonString) as Map<String, dynamic>;
final user = User.fromJson(userMap);

print('Olá, ${user.name}!');
print('Enviamos o link de verificação para ${user.email}.');
```

Para codificar um usuário, passe o objeto `User` para a função `jsonEncode()`.
Você não precisa chamar o método `toJson()`, já que `jsonEncode()`
já faz isso para você.

<?code-excerpt "lib/manual/main.dart (json-encode)" skip="1"?>
```dart
String json = jsonEncode(user);
```

Com essa abordagem, o código de chamada não precisa se preocupar com JSON
serialização em absoluto. No entanto, a classe de modelo ainda precisa.
Em um aplicativo de produção, você gostaria de garantir que a serialização
funcione corretamente. Na prática, os métodos `User.fromJson()` e `User.toJson()`
ambos precisam ter testes unitários para verificar o comportamento correto.

:::note
O cookbook contém [um exemplo prático mais abrangente de uso
classes de modelo JSON][json background parsing], usando um isolate para analisar
o arquivo JSON em um thread em background. Essa abordagem é ideal se você
precisa que seu aplicativo permaneça responsivo enquanto o arquivo JSON está sendo
decodificado.
:::

No entanto, os cenários do mundo real nem sempre são tão simples.
Às vezes, as respostas da API JSON são mais complexas, por exemplo, porque contêm objetos
JSON aninhados que devem ser analisados ​​por meio de sua própria classe de modelo.

Seria bom se houvesse algo que lidasse com a codificação
e decodificação JSON para você. Felizmente, existe!

<a id="code-generation"></a>
## Serializando JSON usando bibliotecas de geração de código

Embora existam outras bibliotecas disponíveis, este guia usa
[`json_serializable`][], um gerador de código-fonte automatizado que
gera o boilerplate de serialização JSON para você.

:::note Escolhendo uma biblioteca
Você pode ter notado dois pacotes [Flutter Favorite][]
em pub.dev que geram código de serialização JSON,
[`json_serializable`][] e [`built_value`][].
Como você escolhe entre esses pacotes?
O pacote `json_serializable` permite que você torne as
classes regulares serializáveis usando anotações,
enquanto o pacote `built_value` fornece uma maneira de nível superior
de definir classes de valor imutáveis ​​que também podem ser
serializadas para JSON.
:::

Como o código de serialização não é mais escrito ou mantido manualmente,
você minimiza o risco de ter exceções de serialização JSON em
tempo de execução.

### Configurando json_serializable em um projeto

Para incluir `json_serializable` em seu projeto, você precisa de uma
dependência regular e duas _dev dependências_. Em resumo, _dev dependências_
são dependências que não são incluídas em nosso código-fonte do aplicativo&mdash;elas
são usadas apenas no ambiente de desenvolvimento.

Para adicionar as dependências, execute `flutter pub add`:

```console
$ flutter pub add json_annotation dev:build_runner dev:json_serializable
```

Execute `flutter pub get` dentro da pasta raiz do seu projeto
(ou clique em **Packages get** no seu editor)
para disponibilizar essas novas dependências em seu projeto.

### Criando classes de modelo da forma json_serializable

O seguinte mostra como converter a classe `User` em uma
classe `json_serializable`. Para simplificar,
este código usa o modelo JSON simplificado
dos exemplos anteriores.

**user.dart**

<?code-excerpt "lib/serializable/user.dart"?>
```dart
import 'package:json_annotation/json_annotation.dart';

/// Isso permite que a classe `User` acesse membros privados no
/// arquivo gerado. O valor para isso é *.g.dart, onde
/// o asterisco denota o nome do arquivo de origem.
part 'user.g.dart';

/// Uma anotação para o gerador de código saber que esta classe precisa do
/// lógica de serialização JSON a ser gerada.
@JsonSerializable()
class User {
  User(this.name, this.email);

  String name;
  String email;

  /// Um construtor de fábrica necessário para criar uma nova instância de User
  /// de um mapa. Passe o mapa para o construtor gerado `_$UserFromJson()`.
  /// O construtor tem o nome da classe de origem, neste caso, User.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// `toJson` é a convenção para uma classe declarar suporte para serialização
  /// para JSON. A implementação simplesmente chama o privado, gerado
  /// método auxiliar `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

Com essa configuração, o gerador de código-fonte gera código para codificar
e decodificando os campos `name` e `email` do JSON.

Se necessário, também é fácil personalizar a estratégia de nomenclatura.
Por exemplo, se a API retornar objetos com _snake\_case_,
e você quiser usar _lowerCamelCase_ em seus modelos,
você pode usar a anotação `@JsonKey` com um parâmetro name:

```dart
/// Diga ao json_serializable que "registration_date_millis" deve ser
/// mapeado para esta propriedade.
@JsonKey(name: 'registration_date_millis')
final int registrationDateMillis;
```

É melhor se o servidor e o cliente seguirem a mesma estratégia de nomenclatura.
`@JsonSerializable()` fornece um enum `fieldRename` para converter totalmente os campos
dart em chaves JSON.

Modificar `@JsonSerializable(fieldRename: FieldRename.snake)` é equivalente a
adicionar `@JsonKey(name: '<snake_case>')` a cada campo.

Às vezes, os dados do servidor são incertos, portanto, é necessário verificar e proteger os dados
no cliente.
Outras anotações `@JsonKey` comumente usadas incluem:

```dart
/// Diga ao json_serializable para usar "defaultValue" se o JSON não
/// contiver esta chave ou se o valor for `null`.
@JsonKey(defaultValue: false)
final bool isAdult;

/// Quando `true` diga ao json_serializable que o JSON deve conter a chave,
/// Se a chave não existir, uma exceção é lançada.
@JsonKey(required: true)
final String id;

/// Quando `true` diga ao json_serializable que o código gerado deve
/// ignore este campo completamente.
@JsonKey(ignore: true)
final String verificationCode;
```

### Executando o utilitário de geração de código

Ao criar classes `json_serializable` pela primeira vez,
você receberá erros semelhantes aos mostrados na imagem abaixo.

![Aviso de IDE quando o código gerado para uma classe de modelo ainda não existe.](/assets/images/docs/json/ide_warning.png){:.mw-100}

Esses erros são totalmente normais e simplesmente porque o código gerado para
a classe de modelo ainda não existe. Para resolver isso, execute o código
gerador que gera o boilerplate de serialização.

Existem duas maneiras de executar o gerador de código.

#### Geração de código única

Ao executar `dart run build_runner build --delete-conflicting-outputs` na raiz do projeto,
você gera código de serialização JSON para seus modelos sempre que eles são necessários.
Isso aciona uma construção única que percorre os arquivos de origem, escolhe os
relevantes e gera o código de serialização necessário para eles.

Embora isso seja conveniente, seria bom se você não tivesse que executar a
construção manualmente cada vez que você faz alterações em suas classes de modelo.

#### Gerando código continuamente

Um _watcher_ torna nosso processo de geração de código-fonte mais conveniente. Ele
observa as mudanças em nossos arquivos de projeto e constrói automaticamente os
arquivos necessários quando necessário. Inicie o observador executando
`dart run build_runner watch --delete-conflicting-outputs` na raiz do projeto.

É seguro iniciar o observador uma vez e deixá-lo funcionando em background.

### Consumindo modelos json_serializable

Para decodificar uma string JSON da maneira `json_serializable`,
você não precisa realmente fazer nenhuma alteração em nosso código anterior.

<?code-excerpt "lib/serializable/main.dart (from-json)"?>
```dart
final userMap = jsonDecode(jsonString) as Map<String, dynamic>;
final user = User.fromJson(userMap);
```
O mesmo vale para codificação. A API de chamada é a mesma de antes.

<?code-excerpt "lib/serializable/main.dart (json-encode)" skip="1"?>
```dart
String json = jsonEncode(user);
```

Com `json_serializable`,
você pode esquecer qualquer serialização JSON manual na classe `User`.
O gerador de código-fonte cria um arquivo chamado `user.g.dart`,
que tem toda a lógica de serialização necessária.
Você não precisa mais escrever testes automatizados para garantir
que a serialização funcione&mdash;agora é _responsabilidade da biblioteca_ garantir que a
serialização funcione adequadamente.

## Gerando código para classes aninhadas

Você pode ter um código que tenha classes aninhadas dentro de uma classe.
Se esse for o caso, e você tentou passar a classe no formato JSON
como argumento para um serviço (como o Firebase, por exemplo),
você pode ter experimentado um erro `Invalid argument`.

Considere a seguinte classe `Address`:

<?code-excerpt "lib/nested/address.dart"?>
```dart
import 'package:json_annotation/json_annotation.dart';
part 'address.g.dart';

@JsonSerializable()
class Address {
  String street;
  String city;

  Address(this.street, this.city);

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
```

A classe `Address` está aninhada dentro da classe `User`:

<?code-excerpt "lib/nested/user.dart" replace="/explicitToJson: true//g"?>
```dart
import 'package:json_annotation/json_annotation.dart';

import 'address.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User(this.name, this.address);

  String name;
  Address address;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

Executando
`dart run build_runner build --delete-conflicting-outputs`
no terminal cria
o arquivo `*.g.dart`, mas a função privada `_$UserToJson()`
parece algo como o seguinte:

```dart
Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'name': instance.name,
  'address': instance.address,
};
```

Tudo parece bem agora, mas se você fizer um print() no objeto user:

<?code-excerpt "lib/nested/main.dart (print)"?>
```dart
Address address = Address('My st.', 'New York');
User user = User('John', address);
print(user.toJson());
```

O resultado é:

```json
{name: John, address: Instance of 'address'}
```

Quando o que você provavelmente deseja é uma saída como a seguinte:

```json
{name: John, address: {street: My st., city: New York}}
```

Para fazer isso funcionar, passe `explicitToJson: true` na anotação `@JsonSerializable()`
sobre a declaração de classe. A classe `User` agora se parece com o seguinte:

<?code-excerpt "lib/nested/user.dart"?>
```dart
import 'package:json_annotation/json_annotation.dart';

import 'address.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  User(this.name, this.address);

  String name;
  Address address;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

Para mais informações, veja [`explicitToJson`][] na
classe [`JsonSerializable`][] para o pacote [`json_annotation`][].

## Referências adicionais

Para mais informações, consulte os seguintes recursos:

* A documentação [`dart:convert`][] e [`JsonCodec`][]
* O pacote [`json_serializable`][] no pub.dev
* Os [`json_serializable` exemplos][] no GitHub
* O codelab [Mergulhe nos padrões e registros do Dart][]
* Este guia definitivo sobre [como analisar JSON em Dart/Flutter][]

[`built_value`]: {{site.pub}}/packages/built_value
[bibliotecas de geração de código]: #code-generation
[`dart:convert`]: {{site.dart.api}}/{{site.dart.sdk.channel}}/dart-convert
[`explicitToJson`]: {{site.pub}}/documentation/json_annotation/latest/json_annotation/JsonSerializable/explicitToJson.html
[Flutter Favorite]: /packages-and-plugins/favorites
[json background parsing]: /cookbook/networking/background-parsing
[`JsonCodec`]: {{site.dart.api}}/{{site.dart.sdk.channel}}/dart-convert/JsonCodec-class.html
[`JsonSerializable`]: {{site.pub}}/documentation/json_annotation/latest/json_annotation/JsonSerializable-class.html
[`json_annotation`]: {{site.pub}}/packages/json_annotation
[`json_serializable`]: {{site.pub}}/packages/json_serializable
[`json_serializable` exemplos]: {{site.github}}/google/json_serializable.dart/blob/master/example/lib/example.dart
[arquivo pubspec]: https://raw.githubusercontent.com/google/json_serializable.dart/master/example/pubspec.yaml
[reflexão]: https://en.wikipedia.org/wiki/Reflection_(computer_programming)
[Serializando JSON manualmente usando dart:convert]: #manual-encoding
[Serializando JSON usando bibliotecas de geração de código]: #code-generation
[tree shaking]: https://en.wikipedia.org/wiki/Tree_shaking
[Mergulhe nos padrões e registros do Dart]: {{site.codelabs}}/codelabs/dart-patterns-records
[como analisar JSON em Dart/Flutter]: https://codewithandrea.com/articles/parse-json-dart/
