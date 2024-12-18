---
ia-translate: true
title: SnackBars gerenciados pelo ScaffoldMessenger
description: >
  SnackBars agora são gerenciados pelo ScaffoldMessenger e persistem entre rotas.
---

## Resumo

A API `SnackBar` dentro do `Scaffold` agora é tratada pelo `ScaffoldMessenger`,
um dos quais está disponível por padrão dentro do contexto de um `MaterialApp`.

## Contexto

Antes desta mudança, os `SnackBar`s eram exibidos chamando o `Scaffold` dentro do
`BuildContext` atual. Ao chamar `Scaffold.of(context).showSnackBar`, o
`Scaffold` atual animava um `SnackBar` na view. Isso se aplicaria apenas ao
`Scaffold` atual e não persistiria entre rotas se elas fossem alteradas no
curso da apresentação do `SnackBar`. Isso também levaria a erros se
`showSnackBar` fosse chamado durante a execução de um evento assíncrono e o
`BuildContext` fosse invalidado pela mudança de rota e o `Scaffold` fosse
descartado.

O `ScaffoldMessenger` agora gerencia os `SnackBar`s para persistir entre rotas e
sempre ser exibido no `Scaffold` atual. Por padrão, um `ScaffoldMessenger` raiz
está incluído no `MaterialApp`, mas você pode criar seu próprio escopo
controlado para o `ScaffoldMessenger` para controlar ainda mais _quais_
`Scaffold`s recebem seus `SnackBar`s.

## Descrição da mudança

A abordagem anterior chamava o `Scaffold` para mostrar um `SnackBar`.

```dart
Scaffold(
  key: scaffoldKey,
  body: Builder(
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: const Text('snack'),
            duration: const Duration(seconds: 1),
            action: SnackBarAction(
              label: 'ACTION',
              onPressed: () { },
            ),
          ));
        },
        child: const Text('SHOW SNACK'),
      );
    },
  )
);
```

A nova abordagem chama o `ScaffoldMessenger` para mostrar o `SnackBar`. Neste
caso, o `Builder` não é mais necessário para fornecer um novo escopo com um
`BuildContext` que esteja "sob" o `Scaffold`.

```dart
Scaffold(
  key: scaffoldKey,
  body: GestureDetector(
    onTap: () {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('snack'),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'ACTION',
          onPressed: () { },
        ),
      ));
    },
    child: const Text('SHOW SNACK'),
  ),
);
```

Ao apresentar um `SnackBar` durante uma transição, o `SnackBar` conclui uma
animação `Hero`, movendo-se suavemente para a próxima página.

O `ScaffoldMessenger` cria um escopo no qual todos os `Scaffold`s descendentes se
registram para receber `SnackBar`s, que é como eles persistem nessas transições.
Ao usar o `ScaffoldMessenger` raiz fornecido pelo `MaterialApp`, todos os
`Scaffold`s descendentes recebem `SnackBar`s, a menos que um novo escopo
`ScaffoldMessenger` seja criado mais abaixo na árvore. Ao instanciar seu
próprio `ScaffoldMessenger`, você pode controlar quais `Scaffold`s recebem
`SnackBar`s e quais não, com base no contexto do seu aplicativo.

O método `debugCheckHasScaffoldMessenger` está disponível para afirmar que um
dado contexto tem um ancestral `ScaffoldMessenger`. Tentar apresentar um
`SnackBar` sem um ancestral `ScaffoldMessenger` presente resulta em uma
asserção como a seguinte:

```plaintext
No ScaffoldMessenger widget found.
Scaffold widgets require a ScaffoldMessenger widget ancestor.
Typically, the ScaffoldMessenger widget is introduced by the MaterialApp
at the top of your application widget tree.
```

## Guia de migração

Código antes da migração:

```dart
// O ScaffoldState do contexto atual era usado para gerenciar SnackBars.
Scaffold.of(context).showSnackBar(mySnackBar);
Scaffold.of(context).hideCurrentSnackBar(mySnackBar);
Scaffold.of(context).removeCurrentSnackBar(mySnackBar);

// Se uma Scaffold.key for especificada, o ScaffoldState pode ser acessado
// diretamente sem primeiro obtê-lo de um BuildContext via
// Scaffold.of. Da chave, use o getter GlobalKey.currentState.
// Isso era usado anteriormente para gerenciar SnackBars.
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
Scaffold(
  key: scaffoldKey,
  body: ...,
);

scaffoldKey.currentState.showSnackBar(mySnackBar);
scaffoldKey.currentState.hideCurrentSnackBar(mySnackBar);
scaffoldKey.currentState.removeCurrentSnackBar(mySnackBar);
```

Código após a migração:

```dart
// O ScaffoldMessengerState do contexto atual é usado para gerenciar SnackBars.
ScaffoldMessenger.of(context).showSnackBar(mySnackBar);
ScaffoldMessenger.of(context).hideCurrentSnackBar(mySnackBar);
ScaffoldMessenger.of(context).removeCurrentSnackBar(mySnackBar);

// Se uma ScaffoldMessenger.key for especificada, o ScaffoldMessengerState pode
// ser acessado diretamente sem primeiro obtê-lo de um BuildContext via
// ScaffoldMessenger.of. Da chave, use o getter GlobalKey.currentState.
// Isso é usado para gerenciar SnackBars.
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
ScaffoldMessenger(
  key: scaffoldMessengerKey,
  child: ...
)

scaffoldMessengerKey.currentState.showSnackBar(mySnackBar);
scaffoldMessengerKey.currentState.hideCurrentSnackBar(mySnackBar);
scaffoldMessengerKey.currentState.removeCurrentSnackBar(mySnackBar);

// O ScaffoldMessenger raiz também pode ser acessado fornecendo uma chave para
// MaterialApp.scaffoldMessengerKey. Desta forma, o ScaffoldMessengerState pode ser
// acessado diretamente sem primeiro obtê-lo de um BuildContext via
// ScaffoldMessenger.of. Da chave, use o getter GlobalKey.currentState.
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
MaterialApp(
  scaffoldMessengerKey: rootScaffoldMessengerKey,
  home: ...
)

rootScaffoldMessengerKey.currentState.showSnackBar(mySnackBar);
rootScaffoldMessengerKey.currentState.hideCurrentSnackBar(mySnackBar);
rootScaffoldMessengerKey.currentState.removeCurrentSnackBar(mySnackBar);
```

## Linha do tempo

Implementado na versão: 1.23.0-13.0.pre<br>
Na versão estável: 2.0.0

## Referências

Documentação da API:

* [`Scaffold`][]
* [`ScaffoldMessenger`][]
* [`SnackBar`][]
* [`MaterialApp`][]

Problemas relevantes:

* [Issue #57218][]
* [Issue #62921][]

PRs relevantes:

* [ScaffoldMessenger][]
* [Migração do ScaffoldMessenger][]

[`Scaffold`]: {{site.api}}/flutter/material/Scaffold-class.html
[`ScaffoldMessenger`]: {{site.api}}/flutter/material/ScaffoldMessenger-class.html
[`SnackBar`]: {{site.api}}/flutter/material/SnackBar-class.html
[`MaterialApp`]: {{site.api}}/flutter/material/MaterialApp-class.html
[Issue #57218]: {{site.repo.flutter}}/issues/57218
[Issue #62921]: {{site.repo.flutter}}/issues/62921
[ScaffoldMessenger]: {{site.repo.flutter}}/pull/64101
[Migração do ScaffoldMessenger]: {{site.repo.flutter}}/pull/64170
