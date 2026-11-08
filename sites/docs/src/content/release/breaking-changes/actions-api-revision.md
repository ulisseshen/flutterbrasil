---
title: Revisão da API Actions
description: >
  Remove a necessidade de FocusNode em invocações, mapeia tipos Intent para Actions.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

No Flutter, um [`Intent`][] é um objeto que normalmente é vinculado
a uma combinação de teclas do teclado usando o widget [`Shortcuts`][].
Um `Intent` pode ser vinculado a uma [`Action`][],
que pode atualizar o estado do aplicativo ou executar outras operações.
No decorrer do uso desta API, identificamos várias desvantagens
no design, então atualizamos a API Actions para torná-la mais fácil
de usar e entender.

No design anterior da API Actions, as ações eram mapeadas de uma
[`LocalKey`][] para um `ActionFactory` que criava uma nova
`Action` cada vez que o método `invoke` era chamado.
Na API atual, as ações são mapeadas do tipo do `Intent`
para uma instância de `Action` (com um `Map<Type, Action>`),
e não são criadas novamente para cada invocação.

## Contexto {:#context}

O design original da API Actions era orientado para invocar ações a partir de
widgets e fazer com que essas ações agissem no contexto do widget.
As equipes vêm usando ações e encontraram várias limitações nesse
design que precisavam ser abordadas:

1. As ações não podiam ser invocadas de fora da hierarquia de widgets.
   Exemplos disso incluem o processamento de um script de comandos,
   algumas arquiteturas de desfazer e algumas arquiteturas de controlador.

1. O mapeamento da tecla de atalho para `Intent` e depois para
   `Action` nem sempre era claro, já que as estruturas de dados
   mapeavam LogicalKeySet =>Intent e depois
   `LocalKey` => `ActionFactory`. O novo mapeamento ainda é
   `LogicalKeySet` para `Intent`, mas depois mapeia `Type`
   (tipo de `Intent`) para `Action`, o que é mais direto e
   legível, já que o tipo do intent é escrito no mapeamento.

1. Se a vinculação de tecla para uma ação estivesse em outra parte da
   hierarquia de widgets, nem sempre era possível para o `Intent`
   ter acesso ao estado necessário para decidir se o
   intent/ação deveria ser habilitado ou não.

Para resolver esses problemas, fizemos algumas mudanças significativas na API.
O mapeamento de ações foi tornado mais intuitivo,
e a interface habilitada foi movida para a classe `Action`.
Alguns argumentos desnecessários foram removidos do método
`invoke` da `Action` e de seu construtor, e as ações foram autorizadas
a retornar resultados de seu método invoke.
As ações foram transformadas em genéricas, aceitando o tipo de `Intent`
que elas manipulam, e as `LocalKeys` não são mais usadas para identificar
qual ação executar, e o tipo do `Intent` é usado em vez disso.

A maioria dessas mudanças foi feita nos PRs para
[Revise Action API][] e [Make Action.enabled be
isEnabled(Intent intent) instead][], e estão
descritas em detalhes no [documento de
design](/go/actions-and-shortcuts-design-revision).

## Descrição da mudança {:#description-of-change}

Aqui estão as mudanças feitas para resolver os problemas acima:

1. O `Map<LocalKey, ActionFactory>` que era passado para o widget [`Actions`][]
   agora é um `Map<Type, Action<Intent>>` (o tipo é o tipo do Intent a
   ser passado para a Action).
1. O método `isEnabled` foi movido da classe `Intent` para a classe `Action`.
1. O argumento `FocusNode` para os métodos `Action.invoke` e `Actions.invoke` foi removido.
1. Invocar uma ação não cria mais uma nova instância da `Action`.
1. O argumento `LocalKey` para o construtor `Intent` foi removido.
1. O argumento `LocalKey` para `CallbackAction` foi removido.
1. A classe `Action` agora é genérica (`Action<T extends Intent>`) para melhor
   segurança de tipo.
1. O `OnInvokeCallback` usado por `CallbackAction` não aceita mais um argumento `FocusNode`.
1. A assinatura de `ActionDispatcher.invokeAction` mudou para não aceitar um
   `FocusNode` opcional, mas em vez disso aceitar um `BuildContext` opcional.
1. As constantes estáticas `LocalKey` (nomeadas key por convenção) em subclasses de `Action`
   foram removidas.
1. Os métodos `Action.invoke` e `ActionDispatcher.invokeAction` agora retornam
   o resultado de invocar a ação como um `Object`.
1. A classe `Action` agora pode ser ouvida para mudanças de estado.
1. O typedef `ActionFactory` foi removido, pois não é mais usado.

## Falhas de exemplo do analyzer {:#example-analyzer-failures}

Aqui estão algumas falhas de exemplo do analyzer que podem ser encontradas onde um
uso desatualizado da API Actions pode ser a causa do problema. Os detalhes específicos
do erro podem diferir, e pode haver outras falhas causadas por essas
mudanças.

```plaintext
error: MyActionDispatcher.invokeAction' ('bool Function(Action<Intent>, Intent, {FocusNode focusNode})') isn't a valid override of 'ActionDispatcher.invokeAction' ('Object Function(Action<Intent>, Intent, [BuildContext])'). (invalid_override at [main] lib/main.dart:74)

error: MyAction.invoke' ('void Function(FocusNode, Intent)') isn't a valid override of 'Action.invoke' ('Object Function(Intent)'). (invalid_override at [main] lib/main.dart:231)

error: The method 'isEnabled' isn't defined for the type 'Intent'. (undefined_method at [main] lib/main.dart:97)

error: The argument type 'Null Function(FocusNode, Intent)' can't be assigned to the parameter type 'Object Function(Intent)'. (argument_type_not_assignable at [main] lib/main.dart:176)

error: The getter 'key' isn't defined for the type 'NextFocusAction'. (undefined_getter at [main] lib/main.dart:294)

error: The argument type 'Map<LocalKey, dynamic>' can't be assigned to the parameter type 'Map<Type, Action<Intent>>'. (argument_type_not_assignable at [main] lib/main.dart:418)
```

## Guia de migração {:#migration-guide}

Mudanças significativas são necessárias para atualizar o código existente
para a nova API.

### Mapeamento de Actions para ações pré-definidas {:#actions-mapping-for-pre-defined-actions}

Para atualizar os mapas de ação no widget `Actions` para
ações pré-definidas no Flutter, como `ActivateAction`
e `SelectAction`, faça o seguinte:

* Atualize o tipo de argumento do argumento `actions`
* Use uma instância de uma classe `Intent` específica no
  mapeamento `Shortcuts`, em vez de uma instância
  `Intent(TheAction.key)`.

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

### Ações personalizadas {:#custom-actions}

Para migrar suas ações personalizadas, elimine as `LocalKeys`
que você definiu e substitua-as por subclasses de `Intent`,
bem como altere o tipo do argumento para o argumento `actions`
do widget `Actions`.

Código antes da migração:

```dart
class MyAction extends Action {
  MyAction() : super(key);

  /// The [LocalKey] that uniquely identifies this action to an [Intent].
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
// Você pode precisar criar novas subclasses de Intent se você usou
// uma LocalKey simples antes.
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

### `Actions` e `Intents` personalizados com argumentos {:#custom-actions-and-intents-with-arguments}

Para atualizar ações que usam argumentos de intent ou mantêm estado,
você precisa modificar os argumentos para o método `invoke`.
No exemplo abaixo, o código mantém o valor do
argumento no intent como parte da instância da ação.
Isso ocorre porque no design antigo há uma nova instância
da ação criada cada vez que ela é executada,
e a ação resultante pode ser mantida pelo
[`ActionDispatcher`][] para registrar o estado.

No exemplo de código pós-migração abaixo,
o novo `MyAction` retorna o estado como resultado
de chamar `invoke`, já que uma nova instância não é criada
para cada invocação. Esse estado é retornado ao chamador de
`Actions.invoke` ou `ActionDispatcher.invokeAction`,
dependendo de como a ação é invocada.

Código antes da migração:

```dart
class MyIntent extends Intent {
  const MyIntent({this.argument});

  final int argument;
}

class MyAction extends Action {
  MyAction() : super(key);

  /// The [LocalKey] that uniquely identifies this action to an [Intent].
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

## Linha do tempo {:#timeline}

Implementado na versão: 1.18<br>
Na versão estável: 1.20

## Referências {:#references}

Documentação da API:

* [`Action`][]
* [`ActionDispatcher`][]
* [`Actions`][]
* [`Intent`][]
* [`Shortcuts`][]

Issue relevante:

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
