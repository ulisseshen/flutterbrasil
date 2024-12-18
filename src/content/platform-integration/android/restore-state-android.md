---
ia-translate: true
title: "Restaurar estado no Android"
description: "Como restaurar o estado do seu aplicativo Android após ele ser finalizado pelo SO."
---

Quando um usuário executa um aplicativo móvel e, em seguida, seleciona outro
aplicativo para executar, o primeiro aplicativo é movido para segundo plano,
ou _em segundo plano_. O sistema operacional (tanto iOS quanto Android)
pode finalizar o aplicativo em segundo plano para liberar memória e
melhorar o desempenho do aplicativo em primeiro plano.

Quando o usuário seleciona o aplicativo novamente, trazendo-o
de volta para o primeiro plano, o SO o reinicia.
Mas, a menos que você tenha configurado uma forma de salvar o
estado do aplicativo antes de ele ser finalizado,
você perdeu o estado e o aplicativo começa do zero.
O usuário perdeu a continuidade que espera,
o que claramente não é o ideal.
(Imagine preencher um formulário longo e ser interrompido
por uma ligação _antes_ de clicar em **Enviar**.)

Então, como você pode restaurar o estado do aplicativo para que
ele pareça como antes de ser enviado para o
segundo plano?

O Flutter tem uma solução para isso com o
[`RestorationManager`][] (e classes relacionadas)
na biblioteca [services][].
Com o `RestorationManager`, o framework Flutter
fornece os dados de estado para o mecanismo _conforme o estado
muda_, de forma que o aplicativo esteja pronto quando o SO sinaliza
que está prestes a finalizar o aplicativo, dando ao aplicativo apenas
alguns instantes para se preparar.

:::secondary Estado da instância vs estado de longa duração
  Quando você deve usar o `RestorationManager` e
  quando você deve salvar o estado em armazenamento de longo prazo?
  _Estado da instância_
  (também chamado de estado _de curto prazo_ ou _efêmero_),
  inclui valores de campo de formulário não enviados, a aba atualmente
  selecionada e assim por diante. No Android, isso é
  limitado a 1 MB e, se o aplicativo exceder isso,
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
   e manter esse estado em um [`RestorableProperty`][].
   (A API do Flutter fornece várias subclasses para
   diferentes tipos de dados.)
   Defina esses widgets `RestorableProperty`
   em uma classe `State` que usa o [`RestorationMixin`][].
   Registre esses widgets com o mixin em um
   método `restoreState`.

3. Se você usar qualquer API Navigator (como `push`, `pushNamed` e assim por diante)
   migre para a API que tem "restorable" no nome
   (`restorablePush`, `restorablePushNamed` e assim por diante)
   para restaurar a pilha de navegação.

Outras considerações:

* Fornecer um `restorationId` para
  `MaterialApp`, `CupertinoApp` ou `WidgetsApp`
  habilita automaticamente a restauração de estado,
  injetando um `RootRestorationScope`.
  Se você precisar restaurar o estado _acima_ da classe do aplicativo,
  injete um `RootRestorationScope` manualmente.

* **A diferença entre um `restorationId` e
  um `restorationScopeId`:** Widgets que usam um
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

## Restaurando o estado de navegação

Se você deseja que seu aplicativo retorne a uma rota específica
que o usuário estava visualizando mais recentemente
(o carrinho de compras, por exemplo), então você deve implementar
o estado de restauração para a navegação também.

Se você usa a API Navigator diretamente,
migre os métodos padrão para métodos restauráveis
(que têm "restorable" no nome).
Por exemplo, substitua `push` por [`restorablePush`][].

O exemplo VeggieSeasons (listado em "Outros recursos" abaixo)
implementa a navegação com o pacote [`go_router`][].
Definir os valores de `restorationId`
ocorre nas classes `lib/screens`.

## Testando a restauração de estado

Para testar a restauração de estado, configure seu dispositivo móvel para que
ele não salve o estado assim que um aplicativo for colocado em segundo plano.
Para saber como fazer isso tanto para iOS quanto para Android,
confira [Testando a restauração de estado][] na
página do [`RestorationManager`][].

:::warning
Não se esqueça de reativar
o armazenamento de estado no seu dispositivo depois de
terminar de testar!
:::

[Testando a restauração de estado]: {{site.api}}/flutter/services/RestorationManager-class.html#testing-state-restoration
[`RestorationBucket`]: {{site.api}}/flutter/services/RestorationBucket-class.html
[`RestorationManager`]: {{site.api}}/flutter/services/RestorationManager-class.html
[services]: {{site.api}}/flutter/services/services-library.html

## Outros recursos

Para obter mais informações sobre a restauração de estado,
confira os seguintes recursos:

* Para obter um exemplo que implementa a restauração de estado,
  confira [VeggieSeasons][], um aplicativo de amostra escrito
  para iOS que usa widgets Cupertino. Um aplicativo iOS requer
  [um pouco de configuração extra][] no Xcode, mas as classes de restauração
  funcionam da mesma forma no iOS e no Android.<br>
  A lista a seguir vincula as partes relevantes do VeggieSeasons
  exemplo:
    * [Definindo uma `RestorablePropery` como uma propriedade de instância]({{site.repo.samples}}/blob/604c82cd7c9c7807ff6c5ca96fbb01d44a4f2c41/veggieseasons/lib/widgets/trivia.dart#L33-L37)
    * [Registrando as propriedades]({{site.repo.samples}}/blob/604c82cd7c9c7807ff6c5ca96fbb01d44a4f2c41/veggieseasons/lib/widgets/trivia.dart#L49-L54)
    * [Atualizando os valores da propriedade]({{site.repo.samples}}/blob/604c82cd7c9c7807ff6c5ca96fbb01d44a4f2c41/veggieseasons/lib/widgets/trivia.dart#L108-L109)
    * [Usando os valores da propriedade no build]({{site.repo.samples}}/blob/604c82cd7c9c7807ff6c5ca96fbb01d44a4f2c41/veggieseasons/lib/widgets/trivia.dart#L205-L210)<br>

* Para saber mais sobre estado de curto e longo prazo,
  confira [Diferenciar entre estado efêmero
  e estado do aplicativo][state].

* Você pode querer verificar os pacotes no pub.dev que
  realizam a restauração de estado, como o [`statePersistence`][].

* Para obter mais informações sobre navegação e o
  pacote `go_router`, confira [Navegação e roteamento][].

[`RestorableProperty`]: {{site.api}}/flutter/widgets/RestorableProperty-class.html
[`restorablePush`]: {{site.api}}/flutter/widgets/Navigator/restorablePush.html
[`ScrollView`]: {{site.api}}/flutter/widgets/ScrollView/restorationId.html
[`statePersistence`]: {{site.pub-pkg}}/state_persistence
[`TextField`]: {{site.api}}/flutter/material/TextField/restorationId.html
[`restorablePush`]: {{site.api}}/flutter/widgets/Navigator/restorablePush.html
[`go_router`]: {{site.pub}}/packages/go_router
[Navigation and routing]: /ui/navigation

