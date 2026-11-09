---
title: Retorno preditivo do Android
description: >-
  A capacidade de controlar a navegação de retorno no momento em que um gesto de retorno é
  recebido foi substituída por uma API de navegação antecipada (ahead-of-time) para
  oferecer suporte ao recurso Predictive Back do Android 14.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Para oferecer suporte ao recurso Predictive Back do Android 14,
um conjunto de APIs antecipadas (ahead-of-time) substituiu APIs de navegação
just-in-time, como `WillPopScope` e `Navigator.willPop`.

:::note
A versão 3.22 do Flutter inclui algumas atualizações
no comportamento de predictive back. Para mais informações, consulte a
[Issue #132504][].
:::

[Issue #132504]: {{site.repo.flutter}}/issues/132504#issuecomment-2025776552

## Contexto {:#background}

O Android 14 introduziu o
[recurso Predictive Back]({{site.android-dev}}/guide/navigation/predictive-back-gesture),
que permite ao usuário espiar a rota atual durante um gesto de retorno válido e
decidir se continua voltando ou se cancela o gesto. Isso era
incompatível com as APIs de navegação do Flutter, que permitem ao desenvolvedor
cancelar um gesto de retorno depois que ele é recebido.

Com o predictive back, a animação de retorno começa assim que o
usuário inicia o gesto e antes de ele ser confirmado. Não há
oportunidade para o app Flutter decidir se ela pode acontecer naquele
momento. Isso precisa ser conhecido antecipadamente.

Por esse motivo, todas as APIs que permitem ao desenvolvedor de um app Flutter
cancelar uma navegação de retorno no momento em que um gesto de retorno é
recebido agora estão descontinuadas. Elas foram substituídas por APIs
equivalentes que mantêm, o tempo todo, um estado booleano que determina se a
navegação de retorno é possível. Quando é, a animação de predictive back
acontece normalmente. Caso contrário, a navegação é interrompida. Em ambos os
casos, o desenvolvedor do app é informado de que um retorno foi tentado e de
se ele teve sucesso.

### PopScope

A classe `PopScope` substitui diretamente `WillPopScope` para habilitar o
predictive back. Em vez de decidir se um pop é possível no momento em que ele
ocorre, isso é definido antecipadamente com o booleano `canPop`. Você ainda
pode escutar os pops usando `onPopInvokedWithResult`.

```dart
PopScope(
  canPop: _myPopDisableEnableLogic(),
  onPopInvokedWithResult: (bool didPop, Object? result) {
    // Handle the pop. If `didPop` is false, it was blocked.
  },
)
```

### Form.canPop and Form.onPopInvokedWithResult

Estes dois novos parâmetros são baseados em `PopScope` e substituem o
parâmetro descontinuado `Form.onWillPop`. Eles são usados com `PopScope` da
mesma forma que acima.

```dart
Form(
  canPop: _myPopDisableEnableLogic(),
  onPopInvokedWithResult: (bool didPop, Object? result) {
    // Handle the pop. If `didPop` is false, it was blocked.
  },
)
```

### Route.popDisposition

Este getter retorna de forma síncrona o `RoutePopDisposition` da rota, que
descreve como os pops vão se comportar.

```dart
if (myRoute.popDisposition == RoutePopDisposition.doNotPop) {
  // Back gestures are disabled.
}
```

### ModalRoute.registerPopEntry and ModalRoute.unregisterPopEntry

Use estes métodos para registrar widgets `PopScope`, que serão avaliados quando
a rota decidir se pode fazer pop. Essa funcionalidade pode ser usada ao
implementar um widget `PopScope` personalizado.

```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  final ModalRoute<dynamic>? nextRoute = ModalRoute.of(context);
  if (nextRoute != _route) {
    _route?.unregisterPopEntry(this);
    _route = nextRoute;
    _route?.registerPopEntry(this);
  }
}
```

## Guia de migração {:#migration-guide}

### Migrando de `WillPopScope` para `PopScope` {:#migrating-from-willpopscope-to-popscope}

O substituto direto do widget `WillPopScope` é o widget `PopScope`.
Em muitos casos, a lógica executada no momento do gesto de retorno em
`onWillPop` pode ser feita em tempo de build e definida em `canPop`.

Código antes da migração:

```dart
WillPopScope(
  onWillPop: () async {
    return _myCondition;
  },
  child: ...
),
```

Código depois da migração:

```dart
PopScope(
  canPop: _myCondition,
  child: ...
),
```

Nos casos em que é necessário ser notificado de que um pop foi tentado, o
método `onPopInvokedWithResult` pode ser usado de forma semelhante a
`onWillPop`. Tenha em mente que, enquanto `onWillPop` era chamado antes de o
pop ser tratado e tinha a capacidade de cancelá-lo, `onPopInvokedWithResult`
é chamado depois que o pop termina de ser tratado.

Código antes da migração:

```dart
WillPopScope(
  onWillPop: () async {
    _myHandleOnPopMethod();
    return true;
  },
  child: ...
),
```

Código depois da migração:

```dart
PopScope(
  canPop: true,
  onPopInvokedWithResult: (bool didPop, Object? result) {
    _myHandleOnPopMethod();
  },
  child: ...
),
```

### Migrando de WillPopScope para NavigatorPopHandler em Navigators aninhados {:#migrating-from-willpopscope-to-navigatorpophandler-for-nested-navigators}

Um caso de uso muito comum de `WillPopScope` era tratar corretamente os gestos
de retorno ao usar widgets `Navigator` aninhados. Também é possível fazer isso
com `PopScope`, mas agora existe um widget wrapper que torna isso ainda mais
simples: `NavigatorPopHandler`.

Código antes da migração:

```dart
WillPopScope(
  onWillPop: () async => !(await _nestedNavigatorKey.currentState!.maybePop()),
  child: Navigator(
    key: _nestedNavigatorKey,
    …
  ),
)
```

Código depois da migração:

```dart
NavigatorPopHandler(
  onPop: () => _nestedNavigatorKey.currentState!.pop(),
  child: Navigator(
    key: _nestedNavigatorKey,
    …
  ),
)
```

### Migrando de Form.onWillPop para Form.canPop e Form.onPopInvokedWithResult {:#migrating-from-form-onwillpop-to-form-canpop-and-form-onpopinvokedwithresult}

Anteriormente, `Form` usava uma instância de `WillPopScope` por baixo dos
panos e expunha seu método `onWillPop`. Isso foi substituído por um
`PopScope` que expõe seus métodos `canPop` e `onPopInvokedWithResult`.
A migração é idêntica à migração de `WillPopScope` para `PopScope`,
detalhada acima.

### Migrando de Route.willPop para Route.popDisposition {:#migrating-from-route-willpop-to-route-popdisposition}

O método `willPop` de `Route` retornava um `Future<RoutePopDisposition>` para
acomodar o fato de que os pops podiam ser cancelados. Como isso não é mais
verdade, essa lógica foi simplificada para um getter síncrono.

Código antes da migração:

```dart
if (await myRoute.willPop() == RoutePopDisposition.doNotPop) {
  ...
}
```

Código depois da migração:

```dart
if (myRoute.popDisposition == RoutePopDisposition.doNotPop) {
  ...
}
```

### Migrando de ModalRoute.add/removeScopedWillPopCallback para ModalRoute.(un)registerPopEntry {:#migrating-from-modalroute-add-removescopedwillpopcallback-to-modalroute-un-registerpopentry}

Internamente, `ModalRoute` mantinha o controle da existência de
`WillPopScope`s na sua subárvore de widgets, registrando-os com
`addScopedWillPopCallback` e `removeScopedWillPopCallback`. Como `PopScope`
substitui `WillPopScope`, esses métodos foram substituídos por
`registerPopEntry` e `unregisterPopEntry`, respectivamente.

`PopEntry` é implementada por `PopScope` para expor apenas a informação mínima
necessária para `ModalRoute`. Quem escrever o próprio `PopScope` deve
implementar `PopEntry` e registrar e desregistrar seu widget no `ModalRoute`
que o envolve.

Código antes da migração:

```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  if (widget.onWillPop != null) {
    _route?.removeScopedWillPopCallback(widget.onWillPop!);
  }
  _route = ModalRoute.of(context);
  if (widget.onWillPop != null) {
    _route?.addScopedWillPopCallback(widget.onWillPop!);
  }
}
```

Código depois da migração:

```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  _route?.unregisterPopEntry(this);
  _route = ModalRoute.of(context);
  _route?.registerPopEntry(this);
}
```

### Migrando de ModalRoute.hasScopedWillPopCallback para ModalRoute.popDisposition {:#migrating-from-modalroute-hasscopedwillpopcallback-to-modalroute-popdisposition}

Este método era usado anteriormente em um caso de uso muito semelhante ao
Predictive Back, mas na biblioteca Cupertino, onde determinadas transições de
retorno permitiam cancelar a navegação. A transição de rota era desabilitada
quando havia até mesmo a possibilidade de um widget `WillPopScope` cancelar o
pop.

Agora que a API exige que isso seja decidido antecipadamente, não é mais
preciso fazer essa verificação de forma especulativa com base na existência de
widgets `PopScope`. A lógica definitiva de saber se um `ModalRoute` está com o
pop bloqueado por um widget `PopScope` está embutida em
`ModalRoute.popDisposition`.

Código antes da migração:

```dart
if (_route.hasScopedWillPopCallback) {
  // Disable predictive route transitions.
}
```

Código depois da migração:

```dart
if (_route.popDisposition == RoutePopDisposition.doNotPop) {
  // Disable predictive route transitions.
}
```

### Migrando um diálogo de confirmação de retorno {:#migrating-a-back-confirmation-dialog}

`WillPopScope` às vezes era usado para exibir um diálogo de confirmação quando
um gesto de retorno era recebido. Isso ainda pode ser feito com `PopScope`,
usando um padrão semelhante.

Código antes da migração:

```dart
WillPopScope(
  onWillPop: () async {
    final bool? shouldPop = await _showBackDialog();
    return shouldPop ?? false;
  },
  child: child,
)
```

Código depois da migração:

```dart
return PopScope(
  canPop: false,
  onPopInvokedWithResult: (bool didPop, Object? result) async {
    if (didPop) {
      return;
    }
    final NavigatorState navigator = Navigator.of(context);
    final bool? shouldPop = await _showBackDialog();
    if (shouldPop ?? false) {
      navigator.pop();
    }
  },
  child: child,
)
```

### Dando suporte ao predictive back {:#supporting-predictive-back}

Para instruções completas de configuração, diretrizes sobre as animações do
gesto predictive back e a configuração do manifesto Android, consulte como
[adicionar o gesto predictive-back](/platform-integration/android/predictive-back).

## Linha do tempo {:#timeline}

Incluído na versão: 3.14.0-7.0.pre<br>
Na versão estável: 3.16

## Referências {:#references}

Documentação da API:

* [`PopScope`][]
* [`NavigatorPopHandler`][]
* [`PopEntry`][]
* [`Form.canPop`][]
* [`Form.onPopInvokedWithResult`][]
* [`Route.popDisposition`][]
* [`ModalRoute.registerPopEntry`][]
* [`ModalRoute.unregisterPopEntry`][]

Issues relevantes:

* [Issue 109513][]

PRs relevantes:

* [Predictive Back support for root routes][]
* [Platform channel for predictive back][]

[`PopScope`]: {{site.api}}/flutter/widgets/PopScope-class.html
[`NavigatorPopHandler`]: {{site.api}}/flutter/widgets/NavigatorPopHandler-class.html
[`PopEntry`]: {{site.api}}/flutter/widgets/PopEntry-class.html
[`Form.canPop`]: {{site.api}}/flutter/widgets/Form/canPop.html
[`Form.onPopInvokedWithResult`]: {{site.api}}/flutter/widgets/Form/onPopInvokedWithResult.html
[`Route.popDisposition`]: {{site.api}}/flutter/widgets/Route/popDisposition.html
[`ModalRoute.registerPopEntry`]: {{site.api}}/flutter/widgets/ModalRoute/registerPopEntry.html
[`ModalRoute.unregisterPopEntry`]: {{site.api}}/flutter/widgets/ModalRoute/unregisterPopEntry.html

[Issue 109513]: {{site.repo.flutter}}/issues/109513
[Predictive back support for root routes]: {{site.repo.flutter}}/pull/120385
[Platform channel for predictive back]: {{site.repo.engine}}/pull/39208
