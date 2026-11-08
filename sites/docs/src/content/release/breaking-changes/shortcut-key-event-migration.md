---
ia-translate: true
title: Migrar ShortcutActivator e ShortcutManager para o sistema KeyEvent
description: >
  O subsistema de eventos de tecla raw foi substituído pelo subsistema de eventos de tecla,
  e APIs que usam RawKeyEvent e RawKeyboard foram convertidas para KeyEvent e
  HardwareKeyboard.
---

{% render "docs/breaking-changes.md" %}

## Resumo

Por algum tempo (anos), o Flutter teve dois sistemas de eventos de tecla implementados.
O novo sistema alcançou paridade com o antigo sistema de eventos de tecla raw específico de plataforma,
e o sistema raw será removido. Para preparar para isso, as APIs do Flutter
que usam o sistema antigo estão sendo modificadas, e para algumas delas decidimos
fazer mudanças incompatíveis na API para preservar a
qualidade da API.

## Contexto

No subsistema de eventos de tecla original, lidar com as peculiaridades de cada plataforma no
framework e nos apps cliente causava código excessivamente complexo, e o sistema antigo
não representava adequadamente o estado verdadeiro dos eventos de tecla no sistema.

Então, o novo sistema baseado em [`KeyEvent`][`KeyEvent`] nasceu, e para minimizar mudanças incompatíveis,
foi implementado em paralelo com o sistema antigo com a intenção de
eventualmente depreciar o sistema raw. Esse momento está chegando rapidamente, e para
nos preparar para isso, fizemos algumas mudanças incompatíveis mínimas necessárias para preservar
a qualidade da API.

## Descrição da mudança

Resumo das APIs que foram afetadas:

- `ShortcutActivator.accepts` agora recebe um `KeyEvent` e `HardwareKeyboard`.
- `ShortcutActivator.isActivatedBy` agora está deprecado. Apenas chame `accepts` ao invés disso.
- `ShortcutActivator.triggers` agora é opcional, e retorna null se não implementado.
- `ShortcutManager.handleKeypress` agora recebe um `KeyEvent`.

A mudança modifica o método `ShortcutActivator.accepts` para receber um `KeyEvent`
e `HardwareKeyboard` ao invés dos anteriores `RawKeyEvent` e `RawKeyboard`.

O significado de `ShortcutActivator.accepts` mudou ligeiramente. Antes da
mudança, assumia-se que `accepts` era chamado apenas se
`ShortcutActivator.triggers` retornasse null, ou se o evento de tecla enviado para `accepts`
tivesse uma tecla lógica que estivesse na lista `triggers`. Agora ele é sempre chamado, e
pode usar a lista `triggers` como uma melhoria de desempenho, mas não é obrigado
a fazê-lo. Subclasses do Flutter como `SingleActivator` e `CharacterActivator`
já fazem isso.

A mudança também modifica o método `ShortcutManager.handleKeypress` para receber um
`KeyEvent` ao invés de `RawKeyEvent`.

## Guia de migração

As APIs fornecidas pelo framework Flutter já foram migradas. A migração é
necessária apenas se você estiver usando algum dos métodos listados na seção anterior.

### Migrando suas APIs que usam `ShortcutActivator` ou suas subclasses.

Passe um `KeyEvent` ao invés de um `RawKeyEvent` para `ShortcutActivator.accepts`.
Isso pode significar mudar de onde você obtém seus eventos de tecla. Dependendo de onde
você os obtém, isso pode significar mudar para usar `Focus.onKeyEvent` ao invés
de `Focus.onKey`, ou uma mudança similar se estiver usando `FocusScope`, `FocusNode` ou
`FocusScopeNode`.

Se você estiver usando um `RawKeyboardListener`, mude para usar um
`KeyboardListener` ao invés. Se você estiver acessando `RawKeyboard` diretamente, use
`HardwareKeyboard` ao invés. Você descobrirá que existem equivalentes não-raw para
todas as fontes de eventos de tecla.

### Migrando suas APIs que estendem `ShortcutActivator`

O método `ShortcutActivator.accepts` foi modificado para receber um `KeyEvent` e um
`HardwareKeyboard` ao invés de um `RawKeyEvent` e `RawKeyboard`.

Antes:

```dart
class MyActivator extends ShortcutActivator {
  @override
  bool accepts(RawKeyEvent event, RawKeyboard state) {
    // ... (your implementation here)
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
    // ... (your implementation here)
    returns false;
  }
  // ...
}
```

### Migrando suas APIs que estendem `ShortcutManager`

A classe `ShortcutManager` foi modificada para receber `KeyEvent`s em `handleKeypress`
ao invés de `RawKeyEvent`s. Uma diferença nas duas APIs é que teclas repetidas
são determinadas de forma diferente. No caso do `RawKeyEvent`, o membro `repeat`
indicava uma repetição, mas no código `RawKeyEvent`, o evento é de um tipo diferente
(`KeyRepeatEvent`).

Antes:

```dart
class _MyShortcutManager extends ShortcutManager {
  @override
  KeyEventResult handleKeypress(BuildContext context, RawKeyEvent event) {
    if (event is! RawKeyDownEvent) {
      return KeyEventResult.ignored;
    }
    if (event.repeat) {
      // (Do something with repeated keys.)
    }
    // ... (your implementation here)
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
      // (Do something with repeated keys.)
    }
    // ... (your implementation here)
    return KeyEventResult.handled;
  }
}
```

## Linha do tempo

Implementado na versão: 3.17.0-5.0.pre<br>
Na versão estável: 3.19.0

## Referências

Documentação da API:

* [`KeyEvent`][`KeyEvent`]
* [`HardwareKeyboard`][`HardwareKeyboard`]
* [`ShortcutActivator`][`ShortcutActivator`]
* [`ShortcutManager`][`ShortcutManager`]

Issues relevantes:

* [`RawKeyEvent` and `RawKeyboard`, et al should be deprecated and removed (Issue 136419)][`RawKeyEvent` and `RawKeyboard`, et al should be deprecated and removed (Issue 136419)]

PRs relevantes:

* [Prepare ShortcutActivator and ShortcutManager to migrate to KeyEvent from RawKeyEvent][Prepare ShortcutActivator and ShortcutManager to migrate to KeyEvent from RawKeyEvent]

[`KeyEvent`]: {{site.api}}/flutter/services/KeyEvent-class.html
[`HardwareKeyboard`]: {{site.api}}/flutter/services/HardwareKeyboard-class.html
[`ShortcutActivator`]: {{site.api}}/flutter/widgets/ShortcutActivator-class.html
[`ShortcutManager`]: {{site.api}}/flutter/widgets/ShortcutManager-class.html
[`RawKeyEvent` and `RawKeyboard`, et al should be deprecated and removed (Issue 136419)]: {{site.repo.flutter}}/issues/136419
[Prepare ShortcutActivator and ShortcutManager to migrate to KeyEvent from RawKeyEvent]: {{site.repo.flutter}}/pull/136854
