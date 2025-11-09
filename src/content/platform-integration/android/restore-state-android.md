---
ia-translate: true
title: "Restaurar estado no Android"
description: "Como restaurar o estado do seu app Android depois que ele for morto pelo SO."
---

Quando um usuário executa um app mobile e então seleciona outro
app para executar, o primeiro app é movido para segundo plano,
ou _backgrounded_. O sistema operacional (tanto iOS quanto Android)
pode matar o app em segundo plano para liberar memória e
melhorar a performance para o app rodando em primeiro plano.

Quando o usuário seleciona o app novamente, trazendo-o
de volta para primeiro plano, o SO o relança.
Mas, a menos que você tenha configurado uma forma de salvar o
estado do app antes que ele fosse morto,
você perdeu o estado e o app começa do zero.
O usuário perdeu a continuidade que espera,
o que claramente não é ideal.
(Imagine preencher um formulário longo e ser interrompido
por uma ligação telefônica _antes_ de clicar em **Submit**.)

Então, como você pode restaurar o estado do app para que
ele pareça como estava antes de ser enviado para
segundo plano?

O Flutter tem uma solução para isso com o
[`RestorationManager`][RestorationManager] (e classes relacionadas)
na biblioteca [services][services].
Com o `RestorationManager`, o framework Flutter
fornece os dados de estado para o engine _conforme o estado
muda_, para que o app esteja pronto quando o SO sinalizar
que está prestes a matar o app, dando ao app apenas
momentos para se preparar.

:::secondary Estado de instância vs estado de longa duração
  Quando você deve usar o `RestorationManager` e
  quando deve salvar estado em armazenamento de longo prazo?
  _Estado de instância_
  (também chamado de estado _de curto prazo_ ou _efêmero_),
  inclui valores de campos de formulário não enviados, a aba atualmente
  selecionada, e assim por diante. No Android, isso é
  limitado a 1 MB e, se o app exceder isso,
  ele trava com um erro `TransactionTooLargeException`
  no código nativo.
:::

[state]: /data-and-backend/state-mgmt/ephemeral-vs-app

## Visão geral

Você pode habilitar a restauração de estado com apenas algumas tarefas:

1. Defina um `restorationScopeId` para classes como
   `CupertinoApp`, `MaterialApp`, ou `WidgetsApp`.

2. Defina um `restorationId` para widgets que o suportam,
   como [`TextField`][TextField] e [`ScrollView`][ScrollView].
   Isso habilita automaticamente a restauração de estado
   integrada para esses widgets.

3. Para widgets personalizados,
   você deve decidir qual estado deseja restaurar
   e manter esse estado em uma [`RestorableProperty`][RestorableProperty].
   (A API Flutter fornece várias subclasses para
   diferentes tipos de dados.)
   Defina esses widgets `RestorableProperty`
   em uma classe `State` que usa o [`RestorationMixin`][RestorationMixin].
   Registre esses widgets com o mixin em um
   método `restoreState`.

4. Se você usa qualquer API Navigator (como `push`, `pushNamed`, e assim por diante)
   migre para a API que tem "restorable" no nome
   (`restorablePush`, `restorablePushNamed`, e assim por diante)
   para restaurar a pilha de navegação.

Outras considerações:

* Fornecer um `restorationScopeId` para
  `MaterialApp`, `CupertinoApp`, ou `WidgetsApp`
  habilita automaticamente a restauração de estado ao
  injetar um `RootRestorationScope`.
  Se você precisa restaurar estado _acima_ da classe app,
  injete um `RootRestorationScope` manualmente.

* **A diferença entre um `restorationId` e
  um `restorationScopeId`:** Widgets que recebem um
  `restorationScopeId` criam um novo `restorationScope`
  (um novo `RestorationBucket`) no qual todos os filhos
  armazenam seu estado. Um `restorationId` significa que o widget
  (e seus filhos) armazena os dados no bucket circundante.

[a bit of extra setup]: {{site.api}}/flutter/services/RestorationManager-class.html#state-restoration-on-ios
[restorationId]: {{site.api}}/flutter/widgets/RestorationScope/restorationId.html
[restorationScopeId]: {{site.api}}/flutter/widgets/RestorationScope/restorationScopeId.html
[RestorationMixin]: {{site.api}}/flutter/widgets/RestorationMixin-mixin.html
[RestorationScope]: {{site.api}}/flutter/widgets/RestorationScope-class.html
[restoreState]: {{site.api}}/flutter/widgets/RestorationMixin/restoreState.html
[VeggieSeasons]: https://github.com/flutter/demos/tree/main/veggieseasons

## Restaurando estado de navegação

Se você quer que seu app retorne para uma rota particular
que o usuário estava visualizando mais recentemente
(o carrinho de compras, por exemplo), então você deve implementar
estado de restauração para navegação, também.

Se você usa a API Navigator diretamente,
migre os métodos padrão para métodos restauráveis
(que têm "restorable" no nome).
Por exemplo, substitua `push` por [`restorablePush`][restorablePush].

## Testando restauração de estado

Para testar a restauração de estado, configure seu dispositivo móvel para que
ele não salve estado uma vez que um app seja colocado em segundo plano.
Para aprender como fazer isso tanto para iOS quanto Android,
confira [Testing state restoration][Testing state restoration] na
página [`RestorationManager`][RestorationManager].

:::warning
Não esqueça de reabilitar
o armazenamento de estado em seu dispositivo uma vez que tenha
terminado o teste!
:::

[Testing state restoration]: {{site.api}}/flutter/services/RestorationManager-class.html#testing-state-restoration
[RestorationBucket]: {{site.api}}/flutter/services/RestorationBucket-class.html
[RestorationManager]: {{site.api}}/flutter/services/RestorationManager-class.html
[services]: {{site.api}}/flutter/services/services-library.html

## Outros recursos

Para mais informações sobre restauração de estado,
confira os seguintes recursos.

* Para aprender mais sobre estado de curto prazo e longo prazo,
  confira [Diferencie entre estado efêmero
  e estado de app][state].

* Você pode querer conferir pacotes no pub.dev que
  realizam restauração de estado, como [`statePersistence`][statePersistence].

* Para mais informações sobre navegação e o
  pacote [`go_router`][go_router], confira [Navegação e roteamento][Navigation and routing]
  e o tópico [State restoration][State restoration] no pub.dev.

[go_router]: {{site.pub}}/packages/go_router
[State restoration]: {{site.pub-api}}/go_router/latest/topics/State%20restoration-topic.html
[Navigation and routing]: /ui/navigation
[RestorableProperty]: {{site.api}}/flutter/widgets/RestorableProperty-class.html
[restorablePush]: {{site.api}}/flutter/widgets/Navigator/restorablePush.html
[ScrollView]: {{site.api}}/flutter/widgets/ScrollView/restorationId.html
[statePersistence]: {{site.pub-pkg}}/state_persistence
[TextField]: {{site.api}}/flutter/material/TextField/restorationId.html
