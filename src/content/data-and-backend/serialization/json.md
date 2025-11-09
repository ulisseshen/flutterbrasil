---
ia-translate: true
title: JSON e serialização
shortTitle: JSON
description: Como usar JSON com Flutter.
---

<?code-excerpt path-base="data-and-backend/json/"?>

É difícil pensar em um app mobile que não precise se comunicar com um
servidor web ou armazenar dados estruturados facilmente em algum momento. Ao criar
apps conectados à rede, as chances são de que ele precise consumir algum bom e velho
JSON, mais cedo ou mais tarde.

Este guia analisa maneiras de usar JSON com Flutter.
Ele aborda qual solução JSON usar em diferentes cenários e por quê.

:::note Terminologia
_Encoding_ e _serialization_ são a mesma
coisa&mdash;transformar uma estrutura de dados em uma string.
_Decoding_ e _deserialization_ são o
processo oposto&mdash;transformar uma string em uma estrutura de dados.
No entanto, _serialization_ também comumente se refere a todo o processo de
traduzir estruturas de dados de e para um formato mais facilmente legível.

Para evitar confusão, este documento usa "serialization" ao se referir ao
processo geral, e "encoding" e "decoding" ao se referir especificamente
a esses processos.
:::

<YouTubeEmbed id="ngsxzZt5DoY" title="dart:convert (Technique of the Week)"></YouTubeEmbed>

## Qual método de serialização JSON é adequado para mim?

Este artigo cobre duas estratégias gerais para trabalhar com JSON:

* Serialização manual
* Serialização automatizada usando geração de código

Projetos diferentes vêm com complexidades e casos de uso diferentes.
Para projetos menores de prova de conceito ou protótipos rápidos,
usar geradores de código pode ser exagero.
Para apps com vários modelos JSON com mais complexidade,
codificar manualmente pode rapidamente se tornar tedioso, repetitivo
e propício a muitos pequenos erros.

### Use serialização manual para projetos menores

Decodificação manual de JSON refere-se ao uso do decodificador JSON integrado em
`dart:convert`. Envolve passar a string JSON bruta para a função `jsonDecode()`
e então procurar os valores que você precisa no
`Map<String, dynamic>` resultante.
Não tem dependências externas ou processo de configuração particular,
e é bom para uma prova de conceito rápida.

Decodificação manual não funciona bem quando seu projeto fica maior.
Escrever lógica de decodificação manualmente pode se tornar difícil de gerenciar e propensa a erros.
Se você tiver um erro de digitação ao acessar um campo JSON
inexistente, seu código lança um erro durante o runtime.

Se você não tem muitos modelos JSON em seu projeto e está
procurando testar um conceito rapidamente,
serialização manual pode ser a maneira que você quer começar.
Para um exemplo de encoding manual, veja
[Serializando JSON manualmente usando dart:convert][Serializing JSON manually using dart:convert].

:::tip
Para prática hands-on desserializando JSON e
aproveitando os novos recursos do Dart 3,
confira o codelab [Dive into Dart's patterns and records][].
:::

### Use geração de código para projetos médios a grandes

Serialização JSON com geração de código significa ter uma biblioteca externa
gerar o boilerplate de encoding para você. Após alguma configuração inicial,
você executa um file watcher que gera o código a partir de suas classes modelo.
Por exemplo, [`json_serializable`][] e [`built_value`][] são esses
tipos de bibliotecas.

Esta abordagem escala bem para um projeto maior. Nenhum
boilerplate escrito manualmente é necessário, e erros de digitação ao acessar campos JSON são capturados em
tempo de compilação. A desvantagem com geração de código é que requer alguma
configuração inicial. Além disso, os arquivos de código gerado podem produzir desordem visual
no navegador do seu projeto.

Você pode querer usar código gerado para serialização JSON quando tiver um
projeto médio ou maior. Para ver um exemplo de encoding JSON baseado em geração de código,
veja [Serializando JSON usando bibliotecas de geração de código][Serializing JSON using code generation libraries].

## Existe um equivalente GSON/<wbr>Jackson/<wbr>Moshi no Flutter?

A resposta simples é não.

Tal biblioteca exigiria usar [reflection][] em runtime, que está desabilitado no
Flutter. Reflection em runtime interfere com [tree shaking][], que Dart tem
suportado por bastante tempo. Com tree shaking, você pode "sacudir" código não usado
de seus builds de release. Isso otimiza o tamanho do app significativamente.

Como reflection torna todo código implicitamente usado por padrão, torna tree
shaking difícil. As ferramentas não podem saber quais partes não são usadas em runtime, então
o código redundante é difícil de remover. Tamanhos de apps não podem ser facilmente otimizados
ao usar reflection.

Embora você não possa usar reflection em runtime com Flutter,
algumas bibliotecas oferecem APIs igualmente fáceis de usar, mas são
baseadas em geração de código. Esta
abordagem é coberta em mais detalhes na
seção [bibliotecas de geração de código][code generation libraries].

<a id="manual-encoding"></a>
## Serializando JSON manualmente usando dart:convert

Serialização JSON básica no Flutter é muito simples. Flutter tem uma
biblioteca `dart:convert` integrada que inclui um encoder e
decoder JSON direto.

O exemplo de JSON a seguir implementa um modelo de usuário simples.

<?code-excerpt "lib/manual/main.dart (multiline-json)" skip="1" take="4"?>
```json
{
  "name": "John Smith",
  "email": "john@example.com"
}
```

Com `dart:convert`,
você pode serializar este modelo JSON de duas maneiras.

### Serializando JSON inline

Ao olhar a documentação [`dart:convert`][],
você verá que pode decodificar o JSON chamando a
função `jsonDecode()`, com a string JSON como argumento do método.

<?code-excerpt "lib/manual/main.dart (manual)"?>
```dart
final user = jsonDecode(jsonString) as Map<String, dynamic>;

print('Howdy, ${user['name']}!');
print('We sent the verification link to ${user['email']}.');
```

Infelizmente, `jsonDecode()` retorna um `dynamic`, significando
que você não sabe os tipos dos valores até o runtime. Com esta abordagem,
você perde a maioria dos recursos de linguagem estaticamente tipada: type safety,
autocompletion e mais importante, exceções em tempo de compilação. Seu código se
tornará instantaneamente mais propenso a erros.

Por exemplo, sempre que você acessar os campos `name` ou `email`, você poderia rapidamente
introduzir um erro de digitação. Um erro de digitação que o compilador não sabe, já que o
JSON vive em uma estrutura de map.

### Serializando JSON dentro de classes modelo

Combata os problemas mencionados anteriormente introduzindo uma classe modelo
simples, chamada `User` neste exemplo. Dentro da classe `User`, você encontrará:

* Um construtor `User.fromJson()`, para construir uma nova instância `User` de uma
  estrutura de map.
* Um método `toJson()`, que converte uma instância `User` em um map.

Com esta abordagem, o _código chamador_ pode ter type safety,
autocompletion para os campos `name` e `email`, e exceções em tempo de compilação.
Se você cometer erros de digitação ou tratar os campos como `int`s em vez de `String`s,
o app não compilará, em vez de quebrar em runtime.

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

  Map<String, dynamic> toJson() => {'name': name, 'email': email};
}
```

A responsabilidade da lógica de decodificação agora está movida para dentro do modelo
em si. Com esta nova abordagem, você pode decodificar um usuário facilmente.

<?code-excerpt "lib/manual/main.dart (from-json)"?>
```dart
final userMap = jsonDecode(jsonString) as Map<String, dynamic>;
final user = User.fromJson(userMap);

print('Howdy, ${user.name}!');
print('We sent the verification link to ${user.email}.');
```

Para codificar um usuário, passe o objeto `User` para a função `jsonEncode()`.
Você não precisa chamar o método `toJson()`, já que `jsonEncode()`
já faz isso para você.

<?code-excerpt "lib/manual/main.dart (json-encode)" skip="1"?>
```dart
String json = jsonEncode(user);
```

Com esta abordagem, o código chamador não precisa se preocupar com
serialização JSON. No entanto, a classe modelo ainda definitivamente precisa.
Em um app de produção, você iria querer garantir que a serialização
funciona corretamente. Na prática, os métodos `User.fromJson()` e `User.toJson()`
ambos precisam ter testes unitários em vigor para verificar comportamento correto.

:::note
O cookbook contém [um exemplo mais abrangente de uso de
classes modelo JSON][json background parsing], usando um isolate para analisar
o arquivo JSON em uma thread em segundo plano. Esta abordagem é ideal se você
precisa que seu app permaneça responsivo enquanto o arquivo JSON está sendo
decodificado.
:::

No entanto, cenários do mundo real nem sempre são tão simples.
Às vezes, respostas de API JSON são mais complexas, por exemplo, já que
contêm objetos JSON aninhados que devem ser analisados através de sua própria classe
modelo.

Seria bom se houvesse algo que lidasse com encoding
e decoding JSON para você. Felizmente, existe!

<a id="code-generation"></a>
## Serializando JSON usando bibliotecas de geração de código

Embora existam outras bibliotecas disponíveis, este guia usa
[`json_serializable`][], um gerador de código-fonte automatizado que
gera o boilerplate de serialização JSON para você.

:::note Escolhendo uma biblioteca
Você pode ter notado dois pacotes [Flutter Favorite][]
no pub.dev que geram código de serialização JSON,
[`json_serializable`][] e [`built_value`][].
Como você escolhe entre esses pacotes?
O pacote `json_serializable` permite que você torne classes regulares
serializáveis usando annotations,
enquanto o pacote `built_value` fornece uma maneira de nível mais alto
de definir classes de valor imutáveis que também podem ser
serializadas para JSON.
:::

Como o código de serialização não é escrito manualmente ou mantido manualmente
mais, você minimiza o risco de ter exceções de serialização JSON em
runtime.

### Configurando json_serializable em um projeto

Para incluir `json_serializable` em seu projeto, você precisa de uma dependência regular
e duas _dev dependencies_. Em resumo, _dev dependencies_
são dependências que não são incluídas no código-fonte do nosso app&mdash;elas
são usadas apenas no ambiente de desenvolvimento.

Para adicionar as dependências, execute `flutter pub add`:

```console
$ flutter pub add json_annotation dev:build_runner dev:json_serializable
```

Execute `flutter pub get` dentro da pasta raiz do seu projeto
(ou clique em **Packages get** no seu editor)
para tornar essas novas dependências disponíveis em seu projeto.

### Criando classes modelo da maneira json_serializable

O seguinte mostra como converter a classe `User` para uma
classe `json_serializable`. Para simplificar,
este código usa o modelo JSON simplificado
dos exemplos anteriores.

**user.dart**

<?code-excerpt "lib/serializable/user.dart"?>
```dart
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'user.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class User {
  User(this.name, this.email);

  String name;
  String email;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

Com esta configuração, o gerador de código-fonte gera código para encoding
e decoding dos campos `name` e `email` de JSON.

Se necessário, também é fácil personalizar a estratégia de nomenclatura.
Por exemplo, se a API retorna objetos com _snake\_case_,
e você quer usar _lowerCamelCase_ em seus modelos,
você pode usar a annotation `@JsonKey` com um parâmetro name:

```dart
/// Tell json_serializable that "registration_date_millis" should be
/// mapped to this property.
@JsonKey(name: 'registration_date_millis')
final int registrationDateMillis;
```

É melhor se tanto servidor quanto cliente seguem a mesma estratégia de nomenclatura.
`@JsonSerializable()` fornece enum `fieldRename` para converter totalmente campos dart
em chaves JSON.

Modificar `@JsonSerializable(fieldRename: FieldRename.snake)` é equivalente a
adicionar `@JsonKey(name: '<snake_case>')` a cada campo.

Às vezes, dados do servidor são incertos, então é necessário verificar e proteger dados
no cliente.
Outras annotations `@JsonKey` comumente usadas incluem:

```dart
/// Tell json_serializable to use "defaultValue" if the JSON doesn't
/// contain this key or if the value is `null`.
@JsonKey(defaultValue: false)
final bool isAdult;

/// When `true` tell json_serializable that JSON must contain the key,
/// If the key doesn't exist, an exception is thrown.
@JsonKey(required: true)
final String id;

/// When `true` tell json_serializable that generated code should
/// ignore this field completely.
@JsonKey(ignore: true)
final String verificationCode;
```

### Executando o utilitário de geração de código

Ao criar classes `json_serializable` pela primeira vez,
você receberá erros semelhantes ao seguinte:

```plaintext
Target of URI hasn't been generated: 'user.g.dart'.
```

Esses erros são totalmente normais e são simplesmente porque o código gerado para
a classe modelo ainda não existe. Para resolver isso, execute o gerador de código
que gera o boilerplate de serialização.

Existem duas maneiras de executar o gerador de código.

#### Geração de código única

Executando `dart run build_runner build --delete-conflicting-outputs` na raiz do projeto,
você gera código de serialização JSON para seus modelos sempre que necessário.
Isso aciona um build único que percorre os arquivos de código-fonte, escolhe os
relevantes e gera o código de serialização necessário para eles.

Embora isso seja conveniente, seria bom se você não tivesse que executar o
build manualmente toda vez que fizer alterações em suas classes modelo.

#### Gerando código continuamente

Um _watcher_ torna nosso processo de geração de código-fonte mais conveniente. Ele
observa alterações em nossos arquivos de projeto e automaticamente constrói os arquivos necessários
quando necessário. Inicie o watcher executando
`dart run build_runner watch --delete-conflicting-outputs` na raiz do projeto.

É seguro iniciar o watcher uma vez e deixá-lo rodando em segundo plano.

### Consumindo modelos json_serializable

Para decodificar uma string JSON da maneira `json_serializable`,
você na verdade não precisa fazer nenhuma alteração em nosso código anterior.

<?code-excerpt "lib/serializable/main.dart (from-json)"?>
```dart
final userMap = jsonDecode(jsonString) as Map<String, dynamic>;
final user = User.fromJson(userMap);
```
O mesmo vale para encoding. A API chamadora é a mesma de antes.

<?code-excerpt "lib/serializable/main.dart (json-encode)" skip="1"?>
```dart
String json = jsonEncode(user);
```

Com `json_serializable`,
você pode esquecer qualquer serialização JSON manual na classe `User`.
O gerador de código-fonte cria um arquivo chamado `user.g.dart`,
que tem toda a lógica de serialização necessária.
Você não precisa mais escrever testes automatizados para garantir
que a serialização funciona&mdash;agora é
_responsabilidade da biblioteca_ garantir que a serialização funcione
apropriadamente.

## Gerando código para classes aninhadas

Você pode ter código que tem classes aninhadas dentro de uma classe.
Se esse for o caso, e você tentou passar a classe em formato JSON
como argumento para um serviço (como Firebase, por exemplo),
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
se parece com o seguinte:

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

Quando o que você provavelmente quer é uma saída como a seguinte:

```json
{name: John, address: {street: My st., city: New York}}
```

Para fazer isso funcionar, passe `explicitToJson: true` na annotation `@JsonSerializable()`
sobre a declaração da classe. A classe `User` agora se parece com o seguinte:

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

Para mais informações, veja os seguintes recursos:

* A documentação [`dart:convert`][] e [`JsonCodec`][]
* O pacote [`json_serializable`][] no pub.dev
* Os [exemplos do `json_serializable`][`json_serializable` examples] no GitHub
* O codelab [Dive into Dart's patterns and records][]
* Este guia definitivo sobre [how to parse JSON in Dart/Flutter][]

[`built_value`]: {{site.pub}}/packages/built_value
[code generation libraries]: #code-generation
[`dart:convert`]: {{site.dart.api}}/dart-convert
[`explicitToJson`]: {{site.pub}}/documentation/json_annotation/latest/json_annotation/JsonSerializable/explicitToJson.html
[Flutter Favorite]: /packages-and-plugins/favorites
[json background parsing]: /cookbook/networking/background-parsing
[`JsonCodec`]: {{site.dart.api}}/dart-convert/JsonCodec-class.html
[`JsonSerializable`]: {{site.pub}}/documentation/json_annotation/latest/json_annotation/JsonSerializable-class.html
[`json_annotation`]: {{site.pub}}/packages/json_annotation
[`json_serializable`]: {{site.pub}}/packages/json_serializable
[`json_serializable` examples]: {{site.github}}/google/json_serializable.dart/blob/master/example/lib/example.dart
[pubspec file]: https://raw.githubusercontent.com/google/json_serializable.dart/master/example/pubspec.yaml
[reflection]: https://en.wikipedia.org/wiki/Reflection_(computer_programming)
[Serializing JSON manually using dart:convert]: #manual-encoding
[Serializing JSON using code generation libraries]: #code-generation
[tree shaking]: https://en.wikipedia.org/wiki/Tree_shaking
[Dive into Dart's patterns and records]: {{site.codelabs}}/codelabs/dart-patterns-records
[how to parse JSON in Dart/Flutter]: https://codewithandrea.com/articles/parse-json-dart/
