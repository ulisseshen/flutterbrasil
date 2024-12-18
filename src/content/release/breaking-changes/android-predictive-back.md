---
ia-translate: true
title: Retorno preditivo do Android
description: >-
  A capacidade de controlar a navegação de retorno no momento em que um gesto
  de retorno é recebido foi substituída por uma API de navegação antecipada
  para oferecer suporte ao recurso de Retorno Preditivo do Android 14.
---

## Resumo

Para oferecer suporte ao recurso de Retorno Preditivo do Android 14, um conjunto
de APIs antecipadas substituiu as APIs de navegação just-in-time, como
`WillPopScope` e `Navigator.willPop`.

:::note
A versão 3.22 do Flutter inclui algumas atualizações para o comportamento de
retorno preditivo. Para mais informações, confira [Issue #132504][].
:::

[Issue #132504]: {{site.github}}/flutter/flutter/issues/132504#issuecomment-2025776552

## Contexto

O Android 14 introduziu o [recurso de Retorno Preditivo]({{site.android-dev}}/guide/navigation/predictive-back-gesture), que permite que o usuário espreite por trás da rota atual durante um gesto de retorno válido e decida se continua para trás ou cancela o gesto. Isso era incompatível com as APIs de navegação do Flutter que permitiam ao desenvolvedor cancelar um gesto de retorno depois de recebido.

Com o retorno preditivo, a animação de retorno começa imediatamente quando o
usuário inicia o gesto e antes que ele seja confirmado. Não há oportunidade para
o aplicativo Flutter decidir se ele pode acontecer naquele momento. Isso deve ser
conhecido antecipadamente.

Por esse motivo, todas as APIs que permitem que um desenvolvedor de aplicativo
Flutter cancele uma navegação de retorno no momento em que um gesto de retorno é
recebido agora estão obsoletas. Elas foram substituídas por APIs equivalentes que
mantêm um estado booleano em todos os momentos que dita se a navegação de retorno
é possível ou não. Quando é, a animação de retorno preditivo acontece
normalmente. Caso contrário, a navegação é interrompida. Em ambos os casos, o
desenvolvedor do aplicativo é informado de que uma tentativa de retorno foi feita
e se ela foi bem-sucedida.

### PopScope

A classe `PopScope` substitui diretamente `WillPopScope` para habilitar o
retorno preditivo. Em vez de decidir se um pop é possível no momento em que
ocorre, isso é definido antecipadamente com o booleano `canPop`. Você ainda pode
ouvir os pops usando `onPopInvoked`.

```dart
PopScope(
  canPop: _myPopDisableEnableLogic(),
  onPopInvoked: (bool didPop) {
    // Lidar com o pop. Se `didPop` for falso, ele foi bloqueado.
  },
)
```

### Form.canPop e Form.onPopInvoked

Esses dois novos parâmetros são baseados em `PopScope` e substituem o parâmetro
obsoleto `Form.onWillPop`. Eles são usados com `PopScope` da mesma forma que
acima.

```dart
Form(
  canPop: _myPopDisableEnableLogic(),
  onPopInvoked: (bool didPop) {
    // Lidar com o pop. Se `didPop` for falso, ele foi bloqueado.
  },
)
```

### Route.popDisposition

Este getter retorna de forma síncrona o `RoutePopDisposition` para a rota, que
descreve como os pops se comportarão.

```dart
if (myRoute.popDisposition == RoutePopDisposition.doNotPop) {
  // Gestos de retorno são desabilitados.
}
```

### ModalRoute.registerPopEntry e ModalRoute.unregisterPopEntry

Use esses métodos para registrar widgets `PopScope`, a serem avaliados quando a
rota decidir se pode fazer pop. Essa funcionalidade pode ser usada ao
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

## Guia de migração

### Migrando de `WillPopScope` para `PopScope`

A substituição direta do widget `WillPopScope` é o widget `PopScope`. Em muitos
casos, a lógica que estava sendo executada no momento do gesto de retorno em
`onWillPop` pode ser feita em tempo de construção e definida como `canPop`.

Código antes da migração:

```dart
WillPopScope(
  onWillPop: () async {
    return _myCondition;
  },
  child: ...
),
```

Código após a migração:

```dart
PopScope(
  canPop: _myCondition,
  child: ...
),
```

Para os casos em que é necessário ser notificado de que um pop foi tentado, o
método `onPopInvoked` pode ser usado de forma semelhante a `onWillPop`. Tenha em
mente que, embora `onWillPop` fosse chamado antes que o pop fosse tratado e
tivesse a capacidade de cancelá-lo, `onPopInvoked` é chamado após o pop terminar
de ser tratado.

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

Código após a migração:

```dart
PopScope(
  canPop: true,
  onPopInvoked: (bool didPop) {
    _myHandleOnPopMethod();
  },
  child: ...
),
```

### Migrando de WillPopScope para NavigatorPopHandler para Navigators aninhados

Um caso de uso muito comum de `WillPopScope` era lidar adequadamente com gestos
de retorno ao usar widgets `Navigator` aninhados. É possível fazer isso usando
`PopScope` também, mas agora existe um widget de wrapper que torna isso ainda
mais fácil: `NavigatorPopHandler`.

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

Código após a migração:

```dart
NavigatorPopHandler(
  onPop: () => _nestedNavigatorKey.currentState!.pop(),
  child: Navigator(
    key: _nestedNavigatorKey,
    …
  ),
)
```

### Migrando de Form.onWillPop para Form.canPop e Form.onPopInvoked

Anteriormente, `Form` usava uma instância `WillPopScope` sob o capô e expunha
seu método `onWillPop`. Isso foi substituído por um `PopScope` que expõe seus
métodos `canPop` e `onPopInvoked`. A migração é idêntica à migração de
`WillPopScope` para `PopScope`, detalhada acima.

### Migrando de Route.willPop para Route.popDisposition

O método `willPop` de `Route` retornava um `Future<RoutePopDisposition>` para
acomodar o fato de que os pops podiam ser cancelados. Agora que isso não é mais
verdade, essa lógica foi simplificada para um getter síncrono.

Código antes da migração:

```dart
if (await myRoute.willPop() == RoutePopDisposition.doNotPop) {
  ...
}
```

Código após a migração:

```dart
if (myRoute.popDisposition == RoutePopDisposition.doNotPop) {
  ...
}
```

### Migrando de ModalRoute.add/removeScopedWillPopCallback para ModalRoute.(un)registerPopEntry

Internamente, `ModalRoute` rastreava a existência de `WillPopScope`s em sua
subárvore de widgets, registrando-os com `addScopedWillPopCallback` e
`removeScopedWillPopCallback`. Como `PopScope` substitui `WillPopScope`, esses
métodos foram substituídos por `registerPopEntry` e `unregisterPopEntry`,
respectivamente.

`PopEntry` é implementado por `PopScope` para expor apenas as informações
mínimas necessárias para `ModalRoute`. Qualquer pessoa que escreva seu próprio
`PopScope` deve implementar `PopEntry` e registrar e cancelar o registro de seu
widget com seu `ModalRoute` envolvente.

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

Código após a migração:

```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  _route?.unregisterPopEntry(this);
  _route = ModalRoute.of(context);
  _route?.registerPopEntry(this);
}
```

### Migrando de ModalRoute.hasScopedWillPopCallback para ModalRoute.popDisposition

Esse método era usado anteriormente para um caso de uso muito semelhante ao
Retorno Preditivo, mas na biblioteca Cupertino, onde certas transições de retorno
permitiam cancelar a navegação. A transição da rota era desabilitada quando havia
mesmo a possibilidade de um widget `WillPopScope` cancelar o pop.

Agora que a API exige que isso seja decidido antecipadamente, isso não precisa
mais ser especulativamente baseado na existência de widgets `PopScope`. A lógica
definitiva de se um `ModalRoute` tem o pop bloqueado por um widget `PopScope` é
incorporada em `ModalRoute.popDisposition`.

Código antes da migração:

```dart
if (_route.hasScopedWillPopCallback) {
  // Desabilite as transições preditivas de rota.
}
```

Código após a migração:

```dart
if (_route.popDisposition == RoutePopDisposition.doNotPop) {
  // Desabilite as transições preditivas de rota.
}
```

### Migrando um diálogo de confirmação de retorno

`WillPopScope` era usado às vezes para mostrar uma caixa de diálogo de
confirmação quando um gesto de retorno era recebido. Isso ainda pode ser feito
com `PopScope` em um padrão semelhante.

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

Código após a migração:

```dart
return PopScope(
  canPop: false,
  onPopInvoked: (bool didPop) async {
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

### Suportando o retorno preditivo

  1. Execute o Android 14 (nível de API 34) ou superior.
  1. Habilite o sinalizador de recurso para retorno preditivo no
     dispositivo em "Opções do desenvolvedor". Isso será desnecessário em
     versões futuras do Android.
  1. Defina `android:enableOnBackInvokedCallback="true"` em
     `android/app/src/main/AndroidManifest.xml`. Se necessário, consulte o
     [guia completo do Android]({{site.android-dev}}/guide/navigation/custom-back/predictive-back-gesture).
     para migrar aplicativos Android para suportar o retorno preditivo.
  1. Certifique-se de que você está usando a versão `3.14.0-7.0.pre`
     do Flutter ou superior.
  1. Certifique-se de que seu aplicativo Flutter não usa o widget
     `WillPopScope`. Usá-lo desabilita o retorno preditivo. Se necessário, use
     `PopScope` em vez disso.
  1. Execute o aplicativo e execute um gesto de retorno (deslize da
     esquerda da tela).

## Cronograma

Implementado na versão: 3.14.0-7.0.pre<br>
Em versão estável: 3.16

## Referências

Documentação da API:

* [`PopScope`][]
* [`NavigatorPopHandler`][]
* [`PopScope`][]
* [`NavigatorPopHandler`][]
* [`PopEntry`][]
* [`Form.canPop`][]
* [`Form.onPopInvoked`][]
* [`Route.popDisposition`][]
* [`ModalRoute.registerPopEntry`][]
* [`ModalRoute.unregisterPopEntry`][]

Issues relevantes:

* [Issue 109513][]

PRs relevantes:

* [Suporte de Retorno Preditivo para rotas raiz][]
* [Canal de plataforma para retorno preditivo][]

[`PopScope`]: {{site.api}}/flutter/widgets/PopScope-class.html
[`NavigatorPopHandler`]: {{site.api}}/flutter/widgets/NavigatorPopHandler-class.html
[`PopEntry`]: {{site.api}}/flutter/widgets/PopEntry-class.html
[`Form.canPop`]: {{site.api}}/flutter/widgets/Form/canPop.html
[`Form.onPopInvoked`]: {{site.api}}/flutter/widgets/Form/onPopInvoked.html
[`Route.popDisposition`]: {{site.api}}/flutter/widgets/Route/popDisposition.html
[`ModalRoute.registerPopEntry`]: {{site.api}}/flutter/widgets/ModalRoute/registerPopEntry.html
[`ModalRoute.unregisterPopEntry`]: {{site.api}}/flutter/widgets/ModalRoute/unregisterPopEntry.html

[Issue 109513]: {{site.repo.flutter}}/issues/109513
[Suporte de Retorno Preditivo para rotas raiz]: {{site.repo.flutter}}/pull/120385
[Canal de plataforma para retorno preditivo]: {{site.repo.engine}}/pull/39208
