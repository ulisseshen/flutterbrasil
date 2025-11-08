---
ia-translate: true
title: JSON e serialização
short-title: JSON
description: Como usar JSON com Flutter.
---

<?code-excerpt path-base="data-and-backend/json/"?>

É difícil pensar em um aplicativo móvel que não precise se comunicar com um
servidor web ou armazenar facilmente dados estruturados em algum momento. Ao fazer
apps conectados à rede, as chances são de que ele precise consumir algum bom e velho
JSON, mais cedo ou mais tarde.

Este guia examina maneiras de usar JSON com Flutter.
Ele aborda qual solução JSON usar em diferentes cenários e por quê.

:::note Terminologia
_Codificação_ (encoding) e _serialização_ (serialization) são a mesma
coisa&mdash;transformar uma estrutura de dados em uma string.
_Decodificação_ (decoding) e _desserialização_ (deserialization) são o
processo oposto&mdash;transformar uma string em uma estrutura de dados.
No entanto, _serialização_ também geralmente se refere ao processo completo de
traduzir estruturas de dados de e para um formato mais facilmente legível.

Para evitar confusão, este documento usa "serialização" ao se referir ao
processo geral, e "codificação" e "decodificação" ao se referir especificamente
a esses processos.
:::

## Qual método de serialização JSON é adequado para mim?

Este artigo aborda duas estratégias gerais para trabalhar com JSON:

* Serialização manual
* Serialização automatizada usando geração de código

Projetos diferentes vêm com complexidades e casos de uso diferentes.
Para projetos menores de prova de conceito ou protótipos rápidos,
usar geradores de código pode ser exagero.
Para apps com vários modelos JSON com mais complexidade,
a codificação manual pode rapidamente se tornar tediosa, repetitiva
e se prestar a muitos pequenos erros.

### Use serialização manual para projetos menores

A decodificação manual de JSON refere-se ao uso do decodificador JSON integrado em
`dart:convert`. Envolve passar a string JSON bruta para a função `jsonDecode()`
e, em seguida, procurar os valores necessários no
`Map<String, dynamic>` resultante.
Não tem dependências externas ou processo de configuração particular,
e é bom para uma prova de conceito rápida.

A decodificação manual não tem um bom desempenho quando seu projeto fica maior.
Escrever lógica de decodificação manualmente pode se tornar difícil de gerenciar e propenso a erros.
Se você tiver um erro de digitação ao acessar um campo JSON
inexistente, seu código lança um erro durante a execução.

Se você não tiver muitos modelos JSON em seu projeto e estiver
procurando testar um conceito rapidamente,
a serialização manual pode ser a maneira como você deseja começar.
Para um exemplo de codificação manual, veja
[Serializando JSON manualmente usando dart:convert][].

:::tip
Para prática prática de desserialização de JSON e
aproveitando os novos recursos do Dart 3,
confira o codelab [Mergulhe nos patterns e records do Dart][Dive into Dart's patterns and records].
:::

### Use geração de código para projetos médios a grandes

Serialização JSON com geração de código significa ter uma biblioteca externa
gerar o boilerplate de codificação para você. Após alguma configuração inicial,
você executa um file watcher que gera o código a partir de suas classes de modelo.
Por exemplo, [`json_serializable`][] e [`built_value`][] são esses
tipos de bibliotecas.

Essa abordagem escala bem para um projeto maior. Nenhum
boilerplate escrito à mão é necessário, e erros de digitação ao acessar campos JSON são capturados em
tempo de compilação. A desvantagem da geração de código é que ela requer alguma
configuração inicial. Além disso, os arquivos de origem gerados podem produzir confusão visual
no navegador de projetos.

Você pode querer usar código gerado para serialização JSON quando tiver um
projeto médio ou maior. Para ver um exemplo de codificação JSON baseada em geração de código,
veja [Serializando JSON usando bibliotecas de geração de código][].

## Existe um equivalente GSON/<wbr>Jackson/<wbr>Moshi no Flutter?

A resposta simples é não.

Tal biblioteca exigiria o uso de [reflection][] em tempo de execução, que está desabilitado no
Flutter. A reflection em tempo de execução interfere com [tree shaking][], que o Dart
suporta há bastante tempo. Com tree shaking, você pode "sacudir" código não utilizado
de suas builds de release. Isso otimiza o tamanho do app significativamente.

Como a reflection torna todo o código implicitamente usado por padrão, torna o tree
shaking difícil. As ferramentas não podem saber quais partes não são usadas em tempo de execução, então
o código redundante é difícil de remover. Os tamanhos dos apps não podem ser facilmente otimizados
ao usar reflection.

Embora você não possa usar reflection em tempo de execução com Flutter,
algumas bibliotecas fornecem APIs igualmente fáceis de usar, mas são
baseadas em geração de código. Essa
abordagem é abordada com mais detalhes na
seção [bibliotecas de geração de código][code generation libraries].

<a id="manual-encoding"></a>
## Serializando JSON manualmente usando dart:convert

A serialização JSON básica no Flutter é muito simples. O Flutter tem uma
biblioteca `dart:convert` integrada que inclui um codificador e
decodificador JSON diretos.

O seguinte exemplo JSON implementa um modelo de usuário simples.

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

Ao olhar para a documentação do [`dart:convert`][],
você verá que pode decodificar o JSON chamando a
função `jsonDecode()`, com a string JSON como argumento do método.

<?code-excerpt "lib/manual/main.dart (manual)"?>
```dart
final user = jsonDecode(jsonString) as Map<String, dynamic>;

print('Howdy, ${user['name']}!');
print('We sent the verification link to ${user['email']}.');
```

Infelizmente, `jsonDecode()` retorna um `dynamic`, significando
que você não conhece os tipos dos valores até a execução. Com essa abordagem,
você perde a maioria dos recursos de linguagem estaticamente tipada: segurança de tipo,
autocompletar e, o mais importante, exceções em tempo de compilação. Seu código se
tornará instantaneamente mais propenso a erros.

Por exemplo, sempre que você acessar os campos `name` ou `email`, você poderia rapidamente
introduzir um erro de digitação. Um erro de digitação que o compilador não sabe porque o
JSON vive em uma estrutura de map.

### Serializando JSON dentro de classes de modelo

Combata os problemas mencionados anteriormente introduzindo uma classe de modelo simples,
chamada `User` neste exemplo. Dentro da classe `User`, você encontrará:

* Um construtor `User.fromJson()`, para construir uma nova instância `User` a partir de uma
  estrutura map.
* Um método `toJson()`, que converte uma instância `User` em um map.

Com essa abordagem, o _código de chamada_ pode ter segurança de tipo,
autocompletar para os campos `name` e `email`, e exceções em tempo de compilação.
Se você cometer erros de digitação ou tratar os campos como `int`s em vez de `String`s,
o app não compilará, em vez de travar em tempo de execução.

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

A responsabilidade da lógica de decodificação agora é movida para dentro do próprio
modelo. Com essa nova abordagem, você pode decodificar um usuário facilmente.

<?code-excerpt "lib/manual/main.dart (from-json)"?>
```dart
final userMap = jsonDecode(jsonString) as Map<String, dynamic>;
final user = User.fromJson(userMap);

print('Howdy, ${user.name}!');
print('We sent the verification link to ${user.email}.');
```

Para codificar um usuário, passe o objeto `User` para a função `jsonEncode()`.
Você não precisa chamar o método `toJson()`, pois `jsonEncode()`
já faz isso para você.

<?code-excerpt "lib/manual/main.dart (json-encode)" skip="1"?>
```dart
String json = jsonEncode(user);
```

Com essa abordagem, o código de chamada não precisa se preocupar com a
serialização JSON. No entanto, a classe de modelo ainda definitivamente precisa.
Em um app de produção, você gostaria de garantir que a serialização
funcione corretamente. Na prática, os métodos `User.fromJson()` e `User.toJson()`
precisam ter testes unitários para verificar o comportamento correto.

:::note
O cookbook contém [um exemplo prático mais abrangente de uso de
classes de modelo JSON][json background parsing], usando um isolate para analisar
o arquivo JSON em uma thread em background. Essa abordagem é ideal se você
precisa que seu app permaneça responsivo enquanto o arquivo JSON está sendo
decodificado.
:::

No entanto, cenários do mundo real nem sempre são tão simples.
Às vezes, as respostas da API JSON são mais complexas, por exemplo, porque
contêm objetos JSON aninhados que devem ser analisados através de sua própria classe
de modelo.

Seria bom se houvesse algo que lidasse com a codificação
e decodificação JSON para você. Felizmente, existe!

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
serializáveis usando anotações,
enquanto o pacote `built_value` fornece uma maneira de nível superior
de definir classes de valor imutáveis que também podem ser
serializadas para JSON.
:::

Como o código de serialização não é mais escrito à mão ou mantido manualmente,
você minimiza o risco de ter exceções de serialização JSON em
tempo de execução.

### Configurando json_serializable em um projeto

Para incluir `json_serializable` em seu projeto, você precisa de uma dependência regular
e duas _dependências dev_. Resumindo, _dependências dev_
são dependências que não são incluídas no código-fonte do nosso app&mdash;elas
são usadas apenas no ambiente de desenvolvimento.

Para adicionar as dependências, execute `flutter pub add`:

```console
$ flutter pub add json_annotation dev:build_runner dev:json_serializable
```

Execute `flutter pub get` dentro da pasta raiz do seu projeto
(ou clique em **Packages get** no seu editor)
para tornar essas novas dependências disponíveis em seu projeto.

### Criando classes de modelo da maneira json_serializable

O seguinte mostra como converter a classe `User` para uma
classe `json_serializable`. Para fins de simplicidade,
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

Com essa configuração, o gerador de código-fonte gera código para codificar
e decodificar os campos `name` e `email` de JSON.

Se necessário, também é fácil personalizar a estratégia de nomenclatura.
Por exemplo, se a API retornar objetos com _snake\_case_,
e você quiser usar _lowerCamelCase_ em seus modelos,
você pode usar a anotação `@JsonKey` com um parâmetro name:

```dart
/// Tell json_serializable that "registration_date_millis" should be
/// mapped to this property.
@JsonKey(name: 'registration_date_millis')
final int registrationDateMillis;
```

É melhor se tanto o servidor quanto o cliente seguirem a mesma estratégia de nomenclatura.
`@JsonSerializable()` fornece enum `fieldRename` para converter totalmente campos
dart em chaves JSON.

Modificar `@JsonSerializable(fieldRename: FieldRename.snake)` é equivalente a
adicionar `@JsonKey(name: '<snake_case>')` a cada campo.

Às vezes, os dados do servidor são incertos, por isso é necessário verificar e proteger dados
no cliente.
Outras anotações `@JsonKey` comumente usadas incluem:

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
você obterá erros semelhantes aos mostrados na imagem abaixo.

![IDE warning when the generated code for a model class does not exist
yet.](/assets/images/docs/json/ide_warning.png){:.mw-100}

Esses erros são totalmente normais e são simplesmente porque o código gerado para
a classe de modelo ainda não existe. Para resolver isso, execute o gerador
de código que gera o boilerplate de serialização.

Existem duas maneiras de executar o gerador de código.

#### Geração de código única

Ao executar `dart run build_runner build --delete-conflicting-outputs` na raiz do projeto,
você gera código de serialização JSON para seus modelos sempre que necessário.
Isso aciona uma compilação única que percorre os arquivos de origem, escolhe os
relevantes e gera o código de serialização necessário para eles.

Embora isso seja conveniente, seria bom se você não tivesse que executar a
compilação manualmente toda vez que fizer alterações em suas classes de modelo.

#### Gerando código continuamente

Um _watcher_ torna nosso processo de geração de código-fonte mais conveniente. Ele
observa mudanças em nossos arquivos de projeto e constrói automaticamente os
arquivos necessários quando necessário. Inicie o watcher executando
`dart run build_runner watch --delete-conflicting-outputs` na raiz do projeto.

É seguro iniciar o watcher uma vez e deixá-lo em execução em background.

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
que a serialização funcione&mdash;agora é
_responsabilidade da biblioteca_ garantir que a serialização funcione
adequadamente.

## Gerando código para classes aninhadas

Você pode ter código que tem classes aninhadas dentro de uma classe.
Se for esse o caso, e você tentou passar a classe em formato JSON
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

Executar
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

Para fazer isso funcionar, passe `explicitToJson: true` na anotação `@JsonSerializable()`
acima da declaração da classe. A classe `User` agora se parece com o seguinte:

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
classe [`JsonSerializable`][] do pacote [`json_annotation`][].

## Referências adicionais

Para mais informações, veja os seguintes recursos:

* A documentação do [`dart:convert`][] e [`JsonCodec`][]
* O pacote [`json_serializable`][] no pub.dev
* Os [exemplos de `json_serializable`][`json_serializable` examples] no GitHub
* O codelab [Mergulhe nos patterns e records do Dart][Dive into Dart's patterns and records]
* Este guia definitivo sobre [como analisar JSON em Dart/Flutter][how to parse JSON in Dart/Flutter]

[`built_value`]: {{site.pub}}/packages/built_value
[code generation libraries]: #code-generation
[`dart:convert`]: {{site.dart.api}}/{{site.dart.sdk.channel}}/dart-convert
[`explicitToJson`]: {{site.pub}}/documentation/json_annotation/latest/json_annotation/JsonSerializable/explicitToJson.html
[Flutter Favorite]: /packages-and-plugins/favorites
[json background parsing]: /cookbook/networking/background-parsing
[`JsonCodec`]: {{site.dart.api}}/{{site.dart.sdk.channel}}/dart-convert/JsonCodec-class.html
[`JsonSerializable`]: {{site.pub}}/documentation/json_annotation/latest/json_annotation/JsonSerializable-class.html
[`json_annotation`]: {{site.pub}}/packages/json_annotation
[`json_serializable`]: {{site.pub}}/packages/json_serializable
[`json_serializable` examples]: {{site.github}}/google/json_serializable.dart/blob/master/example/lib/example.dart
[pubspec file]: https://raw.githubusercontent.com/google/json_serializable.dart/master/example/pubspec.yaml
[reflection]: https://en.wikipedia.org/wiki/Reflection_(computer_programming)
[Serializing JSON manually using dart:convert]: #manual-encoding
[Serializando JSON manualmente usando dart:convert]: #manual-encoding
[Serializing JSON using code generation libraries]: #code-generation
[Serializando JSON usando bibliotecas de geração de código]: #code-generation
[tree shaking]: https://en.wikipedia.org/wiki/Tree_shaking
[Dive into Dart's patterns and records]: {{site.codelabs}}/codelabs/dart-patterns-records
[how to parse JSON in Dart/Flutter]: https://codewithandrea.com/articles/parse-json-dart/
