---
ia-translate: true
title: "Restaurar estado no Android"
description: "Como restaurar o estado do seu app Android depois de ele ser encerrado pelo SO."
---

Quando um usuário executa um app mobile e então seleciona outro
app para executar, o primeiro app é movido para segundo plano,
ou _colocado em background_. O sistema operacional (tanto iOS quanto Android)
pode encerrar o app em background para liberar memória e
melhorar o desempenho do app em execução em primeiro plano.

Quando o usuário seleciona o app novamente, trazendo-o
de volta ao primeiro plano, o SO o reinicia.
Mas, a menos que você tenha configurado uma maneira de salvar o
estado do app antes de ele ser encerrado,
você perdeu o estado e o app inicia do zero.
O usuário perdeu a continuidade que espera,
o que claramente não é ideal.
(Imagine preencher um formulário longo e ser interrompido
por uma chamada telefônica _antes_ de clicar em **Submit**.)

Então, como você pode restaurar o estado do app para que
pareça como estava antes de ser enviado para segundo
plano?

O Flutter tem uma solução para isso com o
[`RestorationManager`][] (e classes relacionadas)
na biblioteca [services][].
Com o `RestorationManager`, o framework Flutter
fornece os dados de estado ao engine _conforme o estado
muda_, para que o app esteja pronto quando o SO sinalizar
que está prestes a encerrar o app, dando ao app apenas
momentos para se preparar.

:::secondary Estado de instância vs estado de longa duração
  Quando você deve usar o `RestorationManager` e
  quando deve salvar o estado em armazenamento de longo prazo?
  _Estado de instância_
  (também chamado de estado _de curto prazo_ ou _efêmero_),
  inclui valores de campos de formulário não enviados, a aba
  atualmente selecionada, e assim por diante. No Android, isso é
  limitado a 1 MB e, se o app exceder isso,
  ele trava com um erro `TransactionTooLargeException`
  no código nativo.
:::

[state]: /data-and-backend/state-mgmt/ephemeral-vs-app

## Visão geral

Você pode habilitar a restauração de estado com apenas algumas tarefas:

1. Defina um `restorationId` ou um `restorationScopeId`
   para todos os widgets que o suportam,
   como [`TextField`][] e [`ScrollView`][].
   Isso habilita automaticamente a restauração de estado integrada
   para esses widgets.

2. Para widgets personalizados,
   você deve decidir qual estado deseja restaurar
   e manter esse estado em uma [`RestorableProperty`][].
   (A API do Flutter fornece várias subclasses para
   diferentes tipos de dados.)
   Defina esses widgets `RestorableProperty`
   em uma classe `State` que usa o [`RestorationMixin`][].
   Registre esses widgets com o mixin em um
   método `restoreState`.

3. Se você usar qualquer API do Navigator (como `push`, `pushNamed`, e assim por diante)
   migre para a API que tem "restorable" no nome
   (`restorablePush`, `restorablePushNamed`, e assim por diante)
   para restaurar a pilha de navegação.

Outras considerações:

* Fornecer um `restorationId` para
  `MaterialApp`, `CupertinoApp`, ou `WidgetsApp`
  habilita automaticamente a restauração de estado ao
  injetar um `RootRestorationScope`.
  Se você precisar restaurar o estado _acima_ da classe app,
  injete um `RootRestorationScope` manualmente.

* **A diferença entre um `restorationId` e
  um `restorationScopeId`:** Widgets que aceitam um
  `restorationScopeID` criam um novo `restorationScope`
  (um novo `RestorationBucket`) no qual todos os filhos
  armazenam seu estado. Um `restorationId` significa que o widget
  (e seus filhos) armazenam os dados no bucket circundante.

[a bit of extra setup]: {{site.api}}/flutter/services/RestorationManager-class.html#state-restoration-on-ios
[`restorationId`]: {{site.api}}/flutter/widgets/RestorationScope/restorationId.html
[`restorationScopeId`]: {{site.api}}/flutter/widgets/RestorationScope/restorationScopeId.html
[`RestorationMixin`]: {{site.api}}/flutter/widgets/RestorationMixin-mixin.html
[`RestorationScope`]: {{site.api}}/flutter/widgets/RestorationScope-class.html
[`restoreState`]: {{site.api}}/flutter/widgets/RestorationMixin/restoreState.html
[VeggieSeasons]: {{site.repo.samples}}/tree/main/veggieseasons

## Restaurando estado de navegação

Se você quiser que seu app retorne a uma rota específica
que o usuário estava visualizando mais recentemente
(o carrinho de compras, por exemplo), então você deve implementar
estado de restauração para navegação também.

Se você usar a API do Navigator diretamente,
migre os métodos padrão para métodos restauráveis
(que têm "restorable" no nome).
Por exemplo, substitua `push` por [`restorablePush`][].

O exemplo VeggieSeasons (listado em "Outros recursos" abaixo)
implementa navegação com o pacote [`go_router`][].
A definição dos valores de `restorationId`
ocorre nas classes `lib/screens`.

## Testando restauração de estado

Para testar a restauração de estado, configure seu dispositivo móvel para que
ele não salve o estado assim que um app seja colocado em background.
Para aprender como fazer isso tanto para iOS quanto para Android,
confira [Testing state restoration][] na
página [`RestorationManager`][].

:::warning
Não se esqueça de reabilitar
o armazenamento de estado no seu dispositivo assim que você
terminar de testar!
:::

[Testing state restoration]: {{site.api}}/flutter/services/RestorationManager-class.html#testing-state-restoration
[`RestorationBucket`]: {{site.api}}/flutter/services/RestorationBucket-class.html
[`RestorationManager`]: {{site.api}}/flutter/services/RestorationManager-class.html
[services]: {{site.api}}/flutter/services/services-library.html

## Outros recursos

Para mais informações sobre restauração de estado,
confira os seguintes recursos:

* Para um exemplo que implementa restauração de estado,
  confira [VeggieSeasons][], um app de exemplo escrito
  para iOS que usa widgets Cupertino. Um app iOS requer
  [a bit of extra setup][] no Xcode, mas as classes de restauração
  funcionam da mesma forma no iOS e no Android.<br>
  A lista a seguir vincula partes relevantes do exemplo
  VeggieSeasons:
    * [Defining a `RestorablePropery` as an instance property]({{site.repo.samples}}/blob/604c82cd7c9c7807ff6c5ca96fbb01d44a4f2c41/veggieseasons/lib/widgets/trivia.dart#L33-L37)
    * [Registering the properties]({{site.repo.samples}}/blob/604c82cd7c9c7807ff6c5ca96fbb01d44a4f2c41/veggieseasons/lib/widgets/trivia.dart#L49-L54)
    * [Updating the property values]({{site.repo.samples}}/blob/604c82cd7c9c7807ff6c5ca96fbb01d44a4f2c41/veggieseasons/lib/widgets/trivia.dart#L108-L109)
    * [Using property values in build]({{site.repo.samples}}/blob/604c82cd7c9c7807ff6c5ca96fbb01d44a4f2c41/veggieseasons/lib/widgets/trivia.dart#L205-L210)<br>

* Para aprender mais sobre estado de curto prazo e longo prazo,
  confira [Differentiate between ephemeral state
  and app state][state].

* Você pode querer conferir pacotes no pub.dev que
  realizam restauração de estado, como [`statePersistence`][].

* Para mais informações sobre navegação e o
  pacote `go_router`, confira [Navigation and routing][].

[`RestorableProperty`]: {{site.api}}/flutter/widgets/RestorableProperty-class.html
[`restorablePush`]: {{site.api}}/flutter/widgets/Navigator/restorablePush.html
[`ScrollView`]: {{site.api}}/flutter/widgets/ScrollView/restorationId.html
[`statePersistence`]: {{site.pub-pkg}}/state_persistence
[`TextField`]: {{site.api}}/flutter/material/TextField/restorationId.html
[`restorablePush`]: {{site.api}}/flutter/widgets/Navigator/restorablePush.html
[`go_router`]: {{site.pub}}/packages/go_router
[Navigation and routing]: /ui/navigation
