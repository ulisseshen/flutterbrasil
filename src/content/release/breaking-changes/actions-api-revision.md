---
ia-translate: true
title: Revisão da API de Actions
description: >
  Remove a necessidade de FocusNode em invocações, mapeia tipos Intent para Actions.
---

## Sumário

No Flutter, um [`Intent`][] é um objeto que é tipicamente vinculado a
uma combinação de teclas do teclado usando o widget [`Shortcuts`][].
Um `Intent` pode ser vinculado a uma [`Action`][], que pode atualizar
o estado do aplicativo ou realizar outras operações. No decorrer do
uso desta API, identificamos várias desvantagens no design, por isso
atualizamos a API de Actions para torná-la mais fácil de usar e entender.

No design anterior da API de Actions, as actions eram mapeadas de uma
[`LocalKey`][] para um `ActionFactory` que criava uma nova `Action`
cada vez que o método `invoke` era chamado. Na API atual, as actions
são mapeadas a partir do tipo do `Intent` para uma instância de `Action`
(com um `Map<Type, Action>`), e elas não são criadas novamente para cada
invocação.

## Contexto

O design original da API de Actions foi orientado para invocar actions
a partir de widgets, e fazer com que essas actions atuem no contexto
do widget. As equipes têm usado actions e encontraram várias limitações
nesse design que precisavam ser abordadas:

1. Actions não podiam ser invocadas de fora da hierarquia de widgets.
   Exemplos disso incluem o processamento de um script de comandos,
   algumas arquiteturas de desfazer e algumas arquiteturas de controlador.

2. O mapeamento da tecla de atalho para `Intent` e depois para `Action`
   nem sempre era claro, já que as estruturas de dados mapeavam
   `LogicalKeySet` => `Intent` e depois `LocalKey` => `ActionFactory`. O
   novo mapeamento ainda é `LogicalKeySet` para `Intent`, mas então
   mapeia `Type` (tipo `Intent`) para `Action`, o que é mais direto e
   legível, já que o tipo do intent é escrito no mapeamento.

3. Se a ligação de tecla para uma action estivesse em outra parte da
   hierarquia de widgets, nem sempre era possível para o `Intent` ter
   acesso ao estado necessário para decidir se o intent/action deveria
   estar habilitado ou não.

Para resolver esses problemas, fizemos algumas mudanças significativas na
API. O mapeamento de actions foi tornado mais intuitivo, e a interface
habilitada foi movida para a classe `Action`. Alguns argumentos
desnecessários foram removidos do método `invoke` da `Action` e de seu
construtor, e as actions foram autorizadas a retornar resultados de seu
método invoke. As actions foram transformadas em genéricas, aceitando o
tipo de `Intent` que elas manipulam, e `LocalKeys` não foram mais usadas
para identificar qual action executar, e o tipo do `Intent` é usado
em vez disso.

A maioria dessas mudanças foi feita nas PRs para
[Revise Action API][] e [Make Action.enabled be
isEnabled(Intent intent) instead][], e são descritas em detalhes
em [o documento de design](/go/actions-and-shortcuts-design-revision).

## Descrição da mudança

Aqui estão as mudanças feitas para resolver os problemas acima:

1. O `Map<LocalKey, ActionFactory>` que foi dado ao widget [`Actions`][]
   agora é um `Map<Type, Action<Intent>>` (o tipo é o tipo do `Intent` a
   ser passado para a Action).
2. O método `isEnabled` foi movido da classe `Intent` para a classe
   `Action`.
3. O argumento `FocusNode` para os métodos `Action.invoke` e
   `Actions.invoke` foi removido.
4. Invocar uma action não cria mais uma nova instância da `Action`.
5. O argumento `LocalKey` para o construtor `Intent` foi removido.
6. O argumento `LocalKey` para `CallbackAction` foi removido.
7. A classe `Action` agora é genérica (`Action<T extends Intent>`) para
   melhor segurança de tipo.
8. O `OnInvokeCallback` usado por `CallbackAction` não recebe mais um
   argumento `FocusNode`.
9. A assinatura `ActionDispatcher.invokeAction` foi alterada para não
   aceitar um `FocusNode` opcional, mas em vez disso receber um
   `BuildContext` opcional.
10. As constantes estáticas `LocalKey` (nomeadas key por convenção) em
    subclasses de `Action` foram removidas.
11. Os métodos `Action.invoke` e `ActionDispatcher.invokeAction` agora
    retornam o resultado da invocação da action como um `Object`.
12. A classe `Action` agora pode ser ouvida para mudanças de estado.
13. O typedef `ActionFactory` foi removido, pois não é mais usado.

## Exemplo de falhas do analisador

Aqui estão alguns exemplos de falhas do analisador que podem ser
encontradas onde um uso desatualizado da API de Actions pode ser a
causa do problema. Os detalhes do erro podem diferir, e pode haver
outras falhas causadas por essas mudanças.

```plaintext
error: MyActionDispatcher.invokeAction' ('bool Function(Action<Intent>, Intent, {FocusNode focusNode})') não é uma substituição válida de 'ActionDispatcher.invokeAction' ('Object Function(Action<Intent>, Intent, [BuildContext])'). (invalid_override em [main] lib/main.dart:74)

error: MyAction.invoke' ('void Function(FocusNode, Intent)') não é uma substituição válida de 'Action.invoke' ('Object Function(Intent)'). (invalid_override em [main] lib/main.dart:231)

error: O método 'isEnabled' não está definido para o tipo 'Intent'. (undefined_method em [main] lib/main.dart:97)

error: O tipo de argumento 'Null Function(FocusNode, Intent)' não pode ser atribuído ao tipo de parâmetro 'Object Function(Intent)'. (argument_type_not_assignable em [main] lib/main.dart:176)

error: O getter 'key' não está definido para o tipo 'NextFocusAction'. (undefined_getter em [main] lib/main.dart:294)

error: O tipo de argumento 'Map<LocalKey, dynamic>' não pode ser atribuído ao tipo de parâmetro 'Map<Type, Action<Intent>>'. (argument_type_not_assignable em [main] lib/main.dart:418)
```

## Guia de migração

Mudanças significativas são necessárias para atualizar o código existente
para a nova API.

### Mapeamento de Actions para actions predefinidas

Para atualizar os mapas de actions no widget `Actions` para actions
predefinidas no Flutter, como `ActivateAction` e `SelectAction`, faça
o seguinte:

* Atualize o tipo de argumento do argumento `actions`
* Use uma instância de uma classe `Intent` específica no mapeamento
  `Shortcuts`, em vez de uma instância `Intent(TheAction.key)`.

Código antes da migração:

```dart
class MyWidget extends StatelessWidget {
  // ...
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent> {
        LogicalKeySet(LogicalKeyboardKey.enter): Intent(ActivateAction.key),
      },
      child: Actions(
        actions: <LocalKey, ActionFactory>{
          Activate.key: () => ActivateAction(),
        },
        child: Container(),
      )
    );
  }
}
```

Código após a migração:

```dart
class MyWidget extends StatelessWidget {
  // ...
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent> {
        LogicalKeySet(LogicalKeyboardKey.enter): ActivateIntent,
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          ActivateIntent: ActivateAction(),
        },
        child: Container(),
      )
    );
  }
}
```

### Actions personalizadas

Para migrar suas actions personalizadas, elimine os `LocalKeys` que você
definiu e substitua-os por subclasses `Intent`, além de alterar o tipo
do argumento para o argumento `actions` do widget `Actions`.

Código antes da migração:

```dart
class MyAction extends Action {
  MyAction() : super(key);

  /// O [LocalKey] que identifica exclusivamente esta action para um [Intent].
  static const LocalKey key = ValueKey<Type>(RequestFocusAction);

  @override
  void invoke(FocusNode node, MyIntent intent) {
    // ...
  }
}

class MyWidget extends StatelessWidget {
  // ...
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent> {
        LogicalKeySet(LogicalKeyboardKey.enter): Intent(MyAction.key),
      },
      child: Actions(
        actions: <LocalKey, ActionFactory>{
          MyAction.key: () => MyAction(),
        },
        child: Container(),
      )
    );
  }
}
```

Código após a migração:

```dart
// Você pode precisar criar novas subclasses Intent se usou
// um LocalKey puro antes.
class MyIntent extends Intent {
  const MyIntent();
}

class MyAction extends Action<MyIntent> {
  @override
  Object invoke(MyIntent intent) {
    // ...
  }
}

class MyWidget extends StatelessWidget {
  // ...
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent> {
        LogicalKeySet(LogicalKeyboardKey.enter): MyIntent,
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          MyIntent: MyAction(),
        },
        child: Container(),
      )
    );
  }
}
```

### `Actions` e `Intents` personalizados com argumentos

Para atualizar actions que usam argumentos de intent ou mantêm estado,
você precisa modificar os argumentos para o método `invoke`. No exemplo
abaixo, o código mantém o valor do argumento no intent como parte da
instância da action. Isso ocorre porque no design antigo existe uma
nova instância da action criada cada vez que ela é executada, e a action
resultante poderia ser mantida pelo [`ActionDispatcher`][] para
registrar o estado.

No exemplo de código pós-migração abaixo, a nova `MyAction` retorna o
estado como o resultado da chamada de `invoke`, já que uma nova
instância não é criada para cada invocação. Este estado é retornado ao
chamador de `Actions.invoke`, ou `ActionDispatcher.invokeAction`,
dependendo de como a action é invocada.

Código antes da migração:

```dart
class MyIntent extends Intent {
  const MyIntent({this.argument});

  final int argument;
}

class MyAction extends Action {
  MyAction() : super(key);

  /// O [LocalKey] que identifica exclusivamente esta action para um [Intent].
  static const LocalKey key = ValueKey<Type>(RequestFocusAction);

  int state;

  @override
  void invoke(FocusNode node, MyIntent intent) {
    // ...
    state = intent.argument;
  }
}
```

Código após a migração:

```dart
class MyIntent extends Intent {
  const MyIntent({this.argument});

  final int argument;
}

class MyAction extends Action<MyIntent> {
  @override
  int invoke(Intent intent) {
    // ...
    return intent.argument;
  }
}
```

## Linha do tempo

Implementado na versão: 1.18<br>
Na versão estável: 1.20

## Referências

Documentação da API:

* [`Action`][]
* [`ActionDispatcher`][]
* [`Actions`][]
* [`Intent`][]
* [`Shortcuts`][]

Problema relevante:

* [Issue 53276][]

PRs relevantes:

* [Revise Action API][]
* [Make Action.enabled be isEnabled(Intent intent) instead][]

[`Action`]: {{site.api}}/flutter/widgets/Action-class.html
[`ActionDispatcher`]: {{site.api}}/flutter/widgets/ActionDispatcher-class.html
[`Actions`]: {{site.api}}/flutter/widgets/Actions-class.html
[`Intent`]: {{site.api}}/flutter/widgets/Intent-class.html
[Issue 53276]: {{site.repo.flutter}}/issues/53276
[`LocalKey`]: {{site.api}}/flutter/foundation/LocalKey-class.html
[Make Action.enabled be isEnabled(Intent intent) instead]: {{site.repo.flutter}}/pull/55230
[Revise Action API]: {{site.repo.flutter}}/pull/42940
[`Shortcuts`]: {{site.api}}/flutter/widgets/Shortcuts-class.html
