---
ia-translate: true
title: Migrar sistema RawKeyEvent/RawKeyboard para sistema KeyEvent/HardwareKeyboard
description: >-
  O subsistema de evento de tecla raw foi substituído pelo subsistema de evento de tecla,
  e APIs que usam RawKeyEvent e RawKeyboard são convertidas para KeyEvent e
  HardwareKeyboard.
---

{% render "docs/breaking-changes.md" %}

## Resumo

Há algum tempo (anos), o Flutter tem dois sistemas de eventos de tecla implementados.
O novo sistema alcançou paridade com o antigo sistema de evento de tecla raw específico da plataforma,
e o sistema raw foi descontinuado.

## Contexto

No subsistema original de evento de tecla, lidar com as peculiaridades de cada plataforma no
framework e em apps clientes causava código excessivamente complexo, e o sistema antigo
não representava adequadamente o verdadeiro estado dos eventos de tecla no sistema.

A API legada [`RawKeyboard`][RawKeyboard] foi descontinuada
e será removida no futuro.
As APIs [`HardwareKeyboard`][HardwareKeyboard] e [`KeyEvent`][KeyEvent] substituem esta API legada.
Um exemplo dessa mudança é [`FocusNode.onKeyEvent`][FocusNode.onKeyEvent]
substituindo `FocusNode.onKey`.

O comportamento de [`RawKeyboard`][RawKeyboard] fornecia um
modelo de eventos menos unificado e menos regular
do que [`HardwareKeyboard`][HardwareKeyboard] fornece.
Considere os seguintes exemplos:

* Eventos de pressionamento nem sempre eram correspondidos com um evento de liberação, e vice-versa (o conjunto
  de teclas pressionadas era atualizado silenciosamente).
* A tecla lógica do evento de pressionamento nem sempre era a mesma do evento de
  liberação.
* Eventos de pressionamento e eventos de repetição não eram facilmente distinguíveis (tinham que ser
  rastreados manualmente).
* Modos de bloqueio (como CapsLock) tinham apenas seu estado "habilitado" registrado. Não
  havia maneira de adquirir seu estado pressionado.

Então, o novo sistema baseado em [`KeyEvent`][KeyEvent]/[`HardwareKeyboard`][HardwareKeyboard] nasceu e, para
minimizar mudanças drásticas, foi implementado em paralelo com o sistema antigo com
a intenção de eventualmente descontinuar o sistema raw. Esse momento chegou,
e desenvolvedores de aplicações devem migrar seu código para evitar mudanças drásticas
que ocorrerão quando as APIs descontinuadas forem removidas.

## Descrição da mudança

Abaixo estão as APIs que foram descontinuadas.

### APIs descontinuadas que têm um equivalente

* [`Focus.onKey`][Focus.onKey] => [`Focus.onKeyEvent`][Focus.onKeyEvent]
* [`FocusNode.attach`][FocusNode.attach]'s `onKey` argument => `onKeyEvent` argument
* [`FocusNode.onKey`][FocusNode.onKey] => [`FocusNode.onKeyEvent`][FocusNode.onKeyEvent]
* [`FocusOnKeyCallback`][FocusOnKeyCallback] => [`FocusOnKeyEventCallback`][FocusOnKeyEventCallback]
* [`FocusScope.onKey`][FocusScope.onKey] => [`FocusScope.onKeyEvent`][FocusScope.onKeyEvent]
* [`FocusScopeNode.onKey`][FocusScopeNode.onKey] => [`FocusScopeNode.onKeyEvent`][FocusScopeNode.onKeyEvent]
* [`RawKeyboard`][RawKeyboard] => [`HardwareKeyboard`][HardwareKeyboard]
* [`RawKeyboardListener`][RawKeyboardListener] => [`KeyboardListener`][KeyboardListener]
* [`RawKeyDownEvent`][RawKeyDownEvent] => [`KeyDownEvent`][KeyDownEvent]
* [`RawKeyEvent`][RawKeyEvent] => [`KeyEvent`][KeyEvent]
* [`RawKeyUpEvent`][RawKeyUpEvent] => [`KeyUpEvent`][KeyUpEvent]

### APIs que foram descontinuadas

Essas APIs não são mais necessárias uma vez que existe apenas um sistema de evento de tecla, ou
sua funcionalidade não é mais oferecida.

* [`debugKeyEventSimulatorTransitModeOverride`][debugKeyEventSimulatorTransitModeOverride]
* [`GLFWKeyHelper`][GLFWKeyHelper]
* [`GtkKeyHelper`][GtkKeyHelper]
* [`KeyboardSide`][KeyboardSide]
* [`KeyDataTransitMode`][KeyDataTransitMode]
* [`KeyEventManager`][KeyEventManager]
* [`KeyHelper`][KeyHelper]
* [`KeyMessage`][KeyMessage]
* [`KeyMessageHandler`][KeyMessageHandler]
* [`KeySimulatorTransitModeVariant`][KeySimulatorTransitModeVariant]
* [`ModifierKey`][ModifierKey]
* [`RawKeyEventData`][RawKeyEventData]
* [`RawKeyEventDataAndroid`][RawKeyEventDataAndroid]
* [`RawKeyEventDataFuchsia`][RawKeyEventDataFuchsia]
* [`RawKeyEventDataIos`][RawKeyEventDataIos]
* [`RawKeyEventDataLinux`][RawKeyEventDataLinux]
* [`RawKeyEventDataMacOs`][RawKeyEventDataMacOs]
* [`RawKeyEventDataWeb`][RawKeyEventDataWeb]
* [`RawKeyEventDataWindows`][RawKeyEventDataWindows]
* [`RawKeyEventHandler`][RawKeyEventHandler]
* [`ServicesBinding.keyEventManager`][ServicesBinding.keyEventManager]

## Guia de migração

As bibliotecas do framework Flutter já foram migradas.
Se seu código usa alguma das classes ou métodos listados na
seção anterior, migre para essas novas APIs.

### Migrando seu código que usa `RawKeyEvent`

Na maior parte, existem APIs `KeyEvent` equivalentes disponíveis para todas as
APIs `RawKeyEvent`.

Algumas APIs relacionadas a informações específicas da plataforma contidas em
objetos [`RawKeyEventData`][RawKeyEventData] ou suas subclasses foram removidas e não são mais
suportadas. Uma exceção é que a informação [`RawKeyEventDataAndroid.eventSource`][RawKeyEventDataAndroid.eventSource]
está acessível agora como [`KeyEvent.deviceType`][KeyEvent.deviceType] de forma
mais independente da plataforma.

#### Migrando `isKeyPressed` e funções relacionadas

Se o código legado usava as APIs [`RawKeyEvent.isKeyPressed`][RawKeyEvent.isKeyPressed],
[`RawKeyEvent.isControlPressed`][RawKeyEvent.isControlPressed], [`RawKeyEvent.isShiftPressed`][RawKeyEvent.isShiftPressed],
[`RawKeyEvent.isAltPressed`][RawKeyEvent.isAltPressed], ou [`RawKeyEvent.isMetaPressed`][RawKeyEvent.isMetaPressed], existem
agora funções equivalentes na instância singleton [`HardwareKeyboard`][HardwareKeyboard],
mas não estão disponíveis em [KeyEvent]. [`RawKeyEvent.isKeyPressed`][RawKeyEvent.isKeyPressed] está disponível
como [`HardwareKeyboard.isLogicalKeyPressed`][HardwareKeyboard.isLogicalKeyPressed].

Antes:

```dart
KeyEventResult _handleKeyEvent(RawKeyEvent keyEvent) {
  if (keyEvent.isControlPressed ||
      keyEvent.isShiftPressed ||
      keyEvent.isAltPressed ||
      keyEvent.isMetaPressed) {
    print('Modifier pressed: $keyEvent');
  }
  if (keyEvent.isKeyPressed(LogicalKeyboardKey.keyA)) {
    print('Key A pressed.');
  }
  return KeyEventResult.ignored;
}
```

Depois:

```dart
KeyEventResult _handleKeyEvent(KeyEvent _) {
  if (HardwareKeyboard.instance.isControlPressed ||
      HardwareKeyboard.instance.isShiftPressed ||
      HardwareKeyboard.instance.isAltPressed ||
      HardwareKeyboard.instance.isMetaPressed) {
    print('Modifier pressed: $keyEvent');
  }
  if (HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.keyA)) {
    print('Key A pressed.');
  }
  return KeyEventResult.ignored;
}
```

#### Definindo `onKey` para focus

Se o código legado estava usando os parâmetros [`Focus.onKey`][Focus.onKey], [`FocusScope.onKey`][FocusScope.onKey],
[`FocusNode.onKey`][FocusNode.onKey], ou [`FocusScopeNode.onKey`][FocusScopeNode.onKey], então existe
um parâmetro equivalente [`Focus.onKeyEvent`][Focus.onKeyEvent], [`FocusScope.onKeyEvent`][FocusScope.onKeyEvent],
[`FocusNode.onKeyEvent`][FocusNode.onKeyEvent], ou [`FocusScopeNode.onKeyEvent`][FocusScopeNode.onKeyEvent] que
fornece `KeyEvent`s ao invés de `RawKeyEvent`s.

Antes:

```dart
Widget build(BuildContext context) {
  return Focus(
    onKey: (RawKeyEvent keyEvent) {
      print('Key event: $keyEvent');
      return KeyEventResult.ignored;
    }
    child: child,
  );
}
```

Depois:

```dart
Widget build(BuildContext context) {
  return Focus(
    onKeyEvent: (KeyEvent keyEvent) {
      print('Key event: $keyEvent');
      return KeyEventResult.ignored;
    }
    child: child,
  );
}
```

#### Tratamento de evento de tecla de repetição

Se você estava confiando no atributo [`RawKeyEvent.repeat`][RawKeyEvent.repeat] para determinar se uma
tecla era um evento de tecla repetido, isso agora foi separado em um
tipo [`KeyRepeatEvent`][KeyRepeatEvent] separado.

Antes:

```dart
KeyEventResult _handleKeyEvent(RawKeyEvent keyEvent) {
  if (keyEvent is RawKeyDownEvent) {
    print('Key down: ${keyEvent.data.logicalKey.keyLabel}(${keyEvent.repeat ? ' (repeated)' : ''})');
  }
  return KeyEventResult.ignored;
}
```

Depois:

```dart
KeyEventResult _handleKeyEvent(KeyEvent _) {
  if (keyEvent is KeyDownEvent || keyEvent is KeyRepeatEvent) {
    print('Key down: ${keyEvent.logicalKey.keyLabel}(${keyEvent is KeyRepeatEvent ? ' (repeated)' : ''})');
  }
  return KeyEventResult.ignored;
}
```

Embora não seja uma subclasse de [`KeyDownEvent`][KeyDownEvent],
um [`KeyRepeatEvent`][KeyRepeatEvent] também é um evento de tecla pressionada.
Não assuma que `keyEvent is! KeyDownEvent` permite apenas eventos de tecla liberada.
Verifique tanto `KeyDownEvent` quanto `KeyRepeatEvent`.

## Cronograma

Disponibilizado na versão: 3.18.0-7.0.pre<br>
Na versão estável: 3.19.0

## Referências

Documentação da API de substituição:

* [`Focus.onKeyEvent`][Focus.onKeyEvent]
* [`FocusNode.onKeyEvent`][FocusNode.onKeyEvent]
* [`FocusOnKeyEventCallback`][FocusOnKeyEventCallback]
* [`FocusScope.onKeyEvent`][FocusScope.onKeyEvent]
* [`FocusScopeNode.onKeyEvent`][FocusScopeNode.onKeyEvent]
* [`HardwareKeyboard`][HardwareKeyboard]
* [`KeyboardListener`][KeyboardListener]
* [`KeyDownEvent`][KeyDownEvent]
* [`KeyRepeatEvent`][KeyRepeatEvent]
* [`KeyEvent`][KeyEvent]
* [`KeyEventHandler`][KeyEventHandler]
* [`KeyUpEvent`][KeyUpEvent]

Issues relevantes:

* [`RawKeyEvent` and `RawKeyboard`, et al should be deprecated and removed (Issue 136419)][RawKeyEvent and RawKeyboard issue]

PRs relevantes:

* [Deprecate RawKeyEvent, et al. and exempt uses in the framework.][Deprecate RawKeyEvent PR]

[debugKeyEventSimulatorTransitModeOverride]: {{site.api}}/flutter/services/debugKeyEventSimulatorTransitModeOverride-class.html
[Focus.onKey]: {{site.api}}/flutter/services/Focus/onKey.html
[FocusNode.attach]: {{site.api}}/flutter/services/FocusNode/attach.html
[FocusNode.onKey]: {{site.api}}/flutter/services/FocusNode/onKey.html
[FocusOnKeyCallback]: {{site.api}}/flutter/services/FocusOnKeyCallback-class.html
[FocusScope.onKey]: {{site.api}}/flutter/services/FocusScope/onKey.html
[FocusScopeNode.onKey]: {{site.api}}/flutter/services/FocusScopeNode/onKey.html
[GLFWKeyHelper]: {{site.api}}/flutter/services/GLFWKeyHelper-class.html
[GtkKeyHelper]: {{site.api}}/flutter/services/GtkKeyHelper-class.html
[KeyboardSide]: {{site.api}}/flutter/services/KeyboardSide-class.html
[KeyDataTransitMode]: {{site.api}}/flutter/services/KeyDataTransitMode-class.html
[KeyEventManager]: {{site.api}}/flutter/services/KeyEventManager-class.html
[KeyHelper]: {{site.api}}/flutter/services/KeyHelper-class.html
[KeyMessage]: {{site.api}}/flutter/services/KeyMessage-class.html
[KeyMessageHandler]: {{site.api}}/flutter/services/KeyMessageHandler-class.html
[KeySimulatorTransitModeVariant]: {{site.api}}/flutter/services/KeySimulatorTransitModeVariant-class.html
[ModifierKey]: {{site.api}}/flutter/services/ModifierKey-class.html
[RawKeyboard]: {{site.api}}/flutter/services/RawKeyboard-class.html
[RawKeyboardListener]: {{site.api}}/flutter/services/RawKeyboardListener-class.html
[RawKeyDownEvent]: {{site.api}}/flutter/services/RawKeyDownEvent-class.html
[RawKeyEvent]: {{site.api}}/flutter/services/RawKeyEvent-class.html
[RawKeyEventData]: {{site.api}}/flutter/services/RawKeyEventData-class.html
[RawKeyEventDataAndroid]: {{site.api}}/flutter/services/RawKeyEventDataAndroid-class.html
[RawKeyEventDataFuchsia]: {{site.api}}/flutter/services/RawKeyEventDataFuchsia-class.html
[RawKeyEventDataIos]: {{site.api}}/flutter/services/RawKeyEventDataIos-class.html
[RawKeyEventDataLinux]: {{site.api}}/flutter/services/RawKeyEventDataLinux-class.html
[RawKeyEventDataMacOs]: {{site.api}}/flutter/services/RawKeyEventDataMacOs-class.html
[RawKeyEventDataWeb]: {{site.api}}/flutter/services/RawKeyEventDataWeb-class.html
[RawKeyEventDataWindows]: {{site.api}}/flutter/services/RawKeyEventDataWindows-class.html
[RawKeyEventHandler]: {{site.api}}/flutter/services/RawKeyEventHandler-class.html
[RawKeyUpEvent]: {{site.api}}/flutter/services/RawKeyUpEvent-class.html
[ServicesBinding.keyEventManager]: {{site.api}}/flutter/services/ServicesBinding/keyEventManager.html
[Focus.onKeyEvent]: {{site.api}}/flutter/services/Focus/onKeyEvent.html
[FocusNode.onKeyEvent]: {{site.api}}/flutter/services/FocusNode/onKeyEvent.html
[FocusOnKeyEventCallback]: {{site.api}}/flutter/services/FocusOnKeyEventCallback-class.html
[FocusScope.onKeyEvent]: {{site.api}}/flutter/services/FocusScope/onKeyEvent.html
[FocusScopeNode.onKeyEvent]: {{site.api}}/flutter/services/FocusScopeNode/onKeyEvent.html
[HardwareKeyboard]: {{site.api}}/flutter/services/HardwareKeyboard-class.html
[HardwareKeyboard.isLogicalKeyPressed]: {{site.api}}/flutter/services/HardwareKeyboard/isLogicalKeyPressed.html
[KeyboardListener]: {{site.api}}/flutter/services/KeyboardListener-class.html
[KeyDownEvent]: {{site.api}}/flutter/services/KeyDownEvent-class.html
[KeyRepeatEvent]: {{site.api}}/flutter/services/KeyRepeatEvent-class.html
[KeyEvent]: {{site.api}}/flutter/services/KeyEvent-class.html
[KeyEventHandler]: {{site.api}}/flutter/services/KeyEventHandler-class.html
[KeyUpEvent]: {{site.api}}/flutter/services/KeyUpEvent-class.html
[RawKeyEvent.isKeyPressed]: {{site.api}}/flutter/services/RawKeyEvent/isKeyPressed.html
[RawKeyEvent.isControlPressed]: {{site.api}}/flutter/services/RawKeyEvent/isControlPressed.html
[RawKeyEvent.isShiftPressed]: {{site.api}}/flutter/services/RawKeyEvent/isShiftPressed.html
[RawKeyEvent.isAltPressed]: {{site.api}}/flutter/services/RawKeyEvent/isAltPressed.html
[RawKeyEvent.isMetaPressed]: {{site.api}}/flutter/services/RawKeyEvent/isMetaPressed.html
[RawKeyEvent.repeat]: {{site.api}}/flutter/services/RawKeyEvent/repeat.html
[RawKeyEventDataAndroid.eventSource]: {{site.api}}/flutter/services/RawKeyEventDataAndroid/eventSource.html
[KeyEvent.deviceType]: {{site.api}}/flutter/services/KeyEvent/deviceType.html
[RawKeyEvent and RawKeyboard issue]: {{site.repo.flutter}}/issues/136419
[Deprecate RawKeyEvent PR]: {{site.repo.flutter}}/pull/136677
