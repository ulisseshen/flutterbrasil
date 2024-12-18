---
ia-translate: true
title: Migrar ShortcutActivator e ShortcutManager para o sistema KeyEvent
description: >
  O subsistema de eventos de tecla raw foi substituído pelo subsistema de
  eventos de tecla, e as APIs que usam RawKeyEvent e RawKeyboard foram
  convertidas para KeyEvent e HardwareKeyboard.
---

## Resumo

Há algum tempo (anos), o Flutter tem dois sistemas de eventos de tecla
implementados. O novo sistema alcançou paridade com o antigo sistema de
eventos de tecla raw específico da plataforma, e o sistema raw será removido.
Para se preparar para isso, as APIs do Flutter que usam o sistema antigo
estão sendo modificadas, e para algumas delas, decidimos fazer mudanças
drásticas na API a fim de preservar a qualidade da API.

## Contexto

No subsistema original de eventos de tecla, o tratamento das peculiaridades
de cada plataforma no framework e nos aplicativos cliente causava um código
excessivamente complexo, e o sistema antigo não representava adequadamente o
estado real dos eventos de tecla no sistema.

Assim, nasceu o novo sistema baseado em [`KeyEvent`][], e para minimizar as
mudanças drásticas, foi implementado em paralelo com o sistema antigo com
a intenção de eventualmente descontinuar o sistema raw. Esse momento está
chegando rapidamente e, para se preparar para ele, fizemos algumas mudanças
drásticas mínimas necessárias para preservar a qualidade da API.

## Descrição da mudança

Resumo das APIs que foram afetadas:

- `ShortcutActivator.accepts` agora recebe um `KeyEvent` e um
  `HardwareKeyboard`.
- `ShortcutActivator.isActivatedBy` agora está obsoleto. Basta chamar
  `accepts` em vez disso.
- `ShortcutActivator.triggers` agora é opcional e retorna nulo se não
  implementado.
- `ShortcutManager.handleKeypress` agora recebe um `KeyEvent`.

A mudança modifica o método `ShortcutActivator.accepts` para receber um
`KeyEvent` e um `HardwareKeyboard` em vez do anterior `RawKeyEvent` e
`RawKeyboard`.

O significado de `ShortcutActivator.accepts` mudou um pouco. Antes da
mudança, presumia-se que `accepts` só era chamado se
`ShortcutActivator.triggers` retornasse nulo ou se o evento de tecla enviado
para `accepts` tivesse uma tecla lógica que estivesse na lista `triggers`.
Agora ele é sempre chamado e pode usar a lista `triggers` como uma melhoria
de desempenho, mas não é necessário. Subclasses do Flutter, como
`SingleActivator` e `CharacterActivator`, já fazem isso.

A mudança também modifica o método `ShortcutManager.handleKeypress` para
receber um `KeyEvent` em vez de `RawKeyEvent`.

## Guia de migração

As APIs fornecidas pelo framework Flutter já estão migradas. A migração
é necessária apenas se você estiver usando qualquer um dos métodos listados
na seção anterior.

### Migrando suas APIs que usam `ShortcutActivator` ou suas subclasses.

Passe um `KeyEvent` em vez de um `RawKeyEvent` para
`ShortcutActivator.accepts`. Isso pode significar mudar de onde você obtém
seus eventos de tecla. Dependendo de onde você os obtém, isso pode
significar mudar para usar `Focus.onKeyEvent` em vez de `Focus.onKey`, ou
uma mudança semelhante se estiver usando `FocusScope`, `FocusNode` ou
`FocusScopeNode`.

Se você estiver usando um `RawKeyboardListener`, mude para usar um
`KeyboardListener`. Se você estiver acessando `RawKeyboard` diretamente,
use `HardwareKeyboard` em vez disso. Você descobrirá que existem equivalentes
não raw para todas as fontes de eventos de tecla.

### Migrando suas APIs que estendem `ShortcutActivator`

O método `ShortcutActivator.accepts` foi modificado para receber um
`KeyEvent` e um `HardwareKeyboard` em vez de um `RawKeyEvent` e
`RawKeyboard`.

Antes:

```dart
class MyActivator extends ShortcutActivator {
  @override
  bool accepts(RawKeyEvent event, RawKeyboard state) {
    // ... (sua implementação aqui)
    returns false;
  }
  // ...
}
```

Depois:

```dart
class MyActivator extends ShortcutActivator {
  @override
  bool accepts(KeyEvent event, HardwareKeyboard state) {
    // ... (sua implementação aqui)
    returns false;
  }
  // ...
}
```

### Migrando suas APIs que estendem `ShortcutManager`

A classe `ShortcutManager` foi modificada para receber `KeyEvent`s em
`handleKeypress` em vez de `RawKeyEvent`s. Uma diferença nas duas APIs é
que as teclas repetidas são determinadas de forma diferente. No caso de
`RawKeyEvent`, o membro `repeat` indicava uma repetição, mas no código
`RawKeyEvent`, o evento é de um tipo diferente (`KeyRepeatEvent`).

Antes:

```dart
class _MyShortcutManager extends ShortcutManager {
  @override
  KeyEventResult handleKeypress(BuildContext context, RawKeyEvent event) {
    if (event is! RawKeyDownEvent) {
      return KeyEventResult.ignored;
    }
    if (event.repeat) {
      // (Faça algo com as teclas repetidas.)
    }
    // ... (sua implementação aqui)
    return KeyEventResult.handled;
  }
}
```

Depois:

```dart
class _MyShortcutManager extends ShortcutManager {
  @override
  KeyEventResult handleKeypress(BuildContext context, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (event is KeyRepeatEvent) {
      // (Faça algo com as teclas repetidas.)
    }
    // ... (sua implementação aqui)
    return KeyEventResult.handled;
  }
}
```

## Linha do tempo

Incluído na versão: 3.17.0-5.0.pre<br>
Na versão estável: 3.19.0

## Referências

Documentação da API:

* [`KeyEvent`][]
* [`HardwareKeyboard`][]
* [`ShortcutActivator`][]
* [`ShortcutManager`][]

Issues relevantes:

* [`RawKeyEvent` e `RawKeyboard`, et al devem ser descontinuados e removidos (Issue 136419)][]

PRs relevantes:

* [Prepare ShortcutActivator and ShortcutManager to migrate to KeyEvent from RawKeyEvent][]

[`KeyEvent`]: {{site.api}}/flutter/services/KeyEvent-class.html
[`HardwareKeyboard`]: {{site.api}}/flutter/services/HardwareKeyboard-class.html
[`ShortcutActivator`]: {{site.api}}/flutter/widgets/ShortcutActivator-class.html
[`ShortcutManager`]: {{site.api}}/flutter/widgets/ShortcutManager-class.html
[`RawKeyEvent` and `RawKeyboard`, et al should be deprecated and removed (Issue 136419)]: {{site.repo.flutter}}/issues/136419
[Prepare ShortcutActivator and ShortcutManager to migrate to KeyEvent from RawKeyEvent]: {{site.repo.flutter}}/pull/136854
