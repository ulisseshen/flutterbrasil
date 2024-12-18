---
ia-translate: true
title: Migrar o sistema RawKeyEvent/RawKeyboard para o sistema KeyEvent/HardwareKeyboard
description: >-
  O subsistema de eventos de tecla raw foi substituído pelo subsistema de eventos
  de tecla, e as APIs que usam RawKeyEvent e RawKeyboard são convertidas para
  KeyEvent e HardwareKeyboard.
---

## Sumário

Há algum tempo (anos), o Flutter possui dois sistemas de eventos de tecla
implementados. O novo sistema atingiu paridade com o antigo sistema de eventos de
tecla raw específico da plataforma, e o sistema raw foi descontinuado.

## Contexto

No subsistema de eventos de tecla original, o tratamento das peculiaridades de
cada plataforma no framework e nos aplicativos cliente causava código
excessivamente complexo, e o antigo sistema não representava corretamente o
estado real dos eventos de tecla no sistema.

A API legada [`RawKeyboard`][] foi descontinuada e será removida no futuro. As
APIs [`HardwareKeyboard`][] e [`KeyEvent`][] substituem essa API legada. Um
exemplo dessa mudança é [`FocusNode.onKeyEvent`][] substituindo `FocusNode.onKey`.

O comportamento de [`RawKeyboard`][] fornecia um modelo de evento menos unificado
e menos regular do que [`HardwareKeyboard`][] fornece. Considere os seguintes
exemplos:

*   Eventos de "tecla pressionada" nem sempre eram correspondidos com um evento
    de "tecla liberada", e vice-versa (o conjunto de teclas pressionadas era
    atualizado silenciosamente).
*   A tecla lógica do evento de "tecla pressionada" nem sempre era a mesma do
    evento de "tecla liberada".
*   Eventos de "tecla pressionada" e eventos de repetição não eram facilmente
    distinguíveis (tinham que ser rastreados manualmente).
*   Os modos de bloqueio (como CapsLock) apenas tinham seu estado "habilitado"
    registrado. Não havia como adquirir seu estado pressionado.

Assim, o novo sistema baseado em [`KeyEvent`][]/[`HardwareKeyboard`][] nasceu
e, para minimizar as mudanças interruptivas, foi implementado em paralelo com o
antigo sistema com a intenção de eventualmente descontinuar o sistema raw. Esse
momento chegou, e os desenvolvedores de aplicativos devem migrar seu código para
evitar mudanças interruptivas que ocorrerão quando as APIs descontinuadas forem
removidas.

## Descrição da mudança

Abaixo estão as APIs que foram descontinuadas.

### APIs descontinuadas que têm um equivalente

*   [`Focus.onKey`][] => [`Focus.onKeyEvent`][]
*   O argumento `onKey` de [`FocusNode.attach`][] => argumento `onKeyEvent`
*   [`FocusNode.onKey`][] => [`FocusNode.onKeyEvent`][]
*   [`FocusOnKeyCallback`][] => [`FocusOnKeyEventCallback`][]
*   [`FocusScope.onKey`][] => [`FocusScope.onKeyEvent`][]
*   [`FocusScopeNode.onKey`][] => [`FocusScopeNode.onKeyEvent`][]
*   [`RawKeyboard`][] => [`HardwareKeyboard`][]
*   [`RawKeyboardListener`][] => [`KeyboardListener`][]
*   [`RawKeyDownEvent`][] => [`KeyDownEvent`][]
*   [`RawKeyEvent`][] => [`KeyEvent`][]
*   [`RawKeyUpEvent`][] => [`KeyUpEvent`][]

### APIs que foram descontinuadas

Essas APIs não são mais necessárias depois que houver apenas um sistema de
eventos de tecla, ou sua funcionalidade não é mais oferecida.

*   [`debugKeyEventSimulatorTransitModeOverride`][]
*   [`GLFWKeyHelper`][]
*   [`GtkKeyHelper`][]
*   [`KeyboardSide`][]
*   [`KeyDataTransitMode`][]
*   [`KeyEventManager`][]
*   [`KeyHelper`][]
*   [`KeyMessage`][]
*   [`KeyMessageHandler`][]
*   [`KeySimulatorTransitModeVariant`][]
*   [`ModifierKey`][]
*   [`RawKeyEventData`][]
*   [`RawKeyEventDataAndroid`][]
*   [`RawKeyEventDataFuchsia`][]
*   [`RawKeyEventDataIos`][]
*   [`RawKeyEventDataLinux`][]
*   [`RawKeyEventDataMacOs`][]
*   [`RawKeyEventDataWeb`][]
*   [`RawKeyEventDataWindows`][]
*   [`RawKeyEventHandler`][]
*   [`ServicesBinding.keyEventManager`][]

## Guia de migração

As bibliotecas do framework Flutter já foram migradas. Se seu código usar alguma
das classes ou métodos listados na seção anterior, migre para essas novas APIs.

### Migrando seu código que usa `RawKeyEvent`

Na maior parte, existem APIs `KeyEvent` equivalentes disponíveis para todas as
APIs `RawKeyEvent`.

Algumas APIs relacionadas a informações específicas da plataforma contidas em
objetos [`RawKeyEventData`][] ou suas subclasses foram removidas e não são mais
suportadas. Uma exceção é que as informações de [`RawKeyEventDataAndroid.eventSource`][]
estão acessíveis agora como [`KeyEvent.deviceType`][] em uma forma mais
independente da plataforma.

#### Migrando `isKeyPressed` e funções relacionadas

Se o código legado usava as APIs [`RawKeyEvent.isKeyPressed`][],
[`RawKeyEvent.isControlPressed`][], [`RawKeyEvent.isShiftPressed`][],
[`RawKeyEvent.isAltPressed`][] ou [`RawKeyEvent.isMetaPressed`][], agora
existem funções equivalentes na instância singleton [`HardwareKeyboard`][],
mas não estão disponíveis em [KeyEvent]. [`RawKeyEvent.isKeyPressed`][] está
disponível como [`HardwareKeyboard.isLogicalKeyPressed`][].

Antes:

```dart
KeyEventResult _handleKeyEvent(RawKeyEvent keyEvent) {
  if (keyEvent.isControlPressed ||
      keyEvent.isShiftPressed ||
      keyEvent.isAltPressed ||
      keyEvent.isMetaPressed) {
    print('Modificador pressionado: $keyEvent');
  }
  if (keyEvent.isKeyPressed(LogicalKeyboardKey.keyA)) {
    print('Tecla A pressionada.');
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
    print('Modificador pressionado: $keyEvent');
  }
  if (HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.keyA)) {
    print('Tecla A pressionada.');
  }
  return KeyEventResult.ignored;
}
```

#### Configurando `onKey` para foco

Se o código legado estava usando os parâmetros [`Focus.onKey`][],
[`FocusScope.onKey`][], [`FocusNode.onKey`][] ou [`FocusScopeNode.onKey`][],
então existe um parâmetro equivalente [`Focus.onKeyEvent`][],
[`FocusScope.onKeyEvent`][], [`FocusNode.onKeyEvent`][] ou
[`FocusScopeNode.onKeyEvent`][] que fornece `KeyEvent`s em vez de `RawKeyEvent`s.

Antes:

```dart
Widget build(BuildContext context) {
  return Focus(
    onKey: (RawKeyEvent keyEvent) {
      print('Evento de tecla: $keyEvent');
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
      print('Evento de tecla: $keyEvent');
      return KeyEventResult.ignored;
    }
    child: child,
  );
}
```

#### Tratamento de eventos de repetição de tecla

Se você estava confiando no atributo [`RawKeyEvent.repeat`][] para determinar se
uma tecla era um evento de tecla repetido, isso agora foi separado em um tipo
[`KeyRepeatEvent`][] separado.

Antes:

```dart
KeyEventResult _handleKeyEvent(RawKeyEvent keyEvent) {
  if (keyEvent is RawKeyDownEvent) {
    print('Tecla pressionada: ${keyEvent.data.logicalKey.keyLabel}(${keyEvent.repeat ? ' (repetida)' : ''})');
  }
  return KeyEventResult.ignored;
}
```

Depois:

```dart
KeyEventResult _handleKeyEvent(KeyEvent _) {
  if (keyEvent is KeyDownEvent || keyEvent is KeyRepeatEvent) {
    print('Tecla pressionada: ${keyEvent.logicalKey.keyLabel}(${keyEvent is KeyRepeatEvent ? ' (repetida)' : ''})');
  }
  return KeyEventResult.ignored;
}
```

Embora não seja uma subclasse de [`KeyDownEvent`][], um [`KeyRepeatEvent`][]
também é um evento de "tecla pressionada". Não suponha que `keyEvent is!
KeyDownEvent` só permite eventos de "tecla liberada". Verifique ambos
`KeyDownEvent` e `KeyRepeatEvent`.

## Cronograma

Implementado na versão: 3.18.0-7.0.pre<br>
Na versão estável: 3.19.0

## Referências

Documentação da API de substituição:

*   [`Focus.onKeyEvent`][]
*   [`FocusNode.onKeyEvent`][]
*   [`FocusOnKeyEventCallback`][]
*   [`FocusScope.onKeyEvent`][]
*   [`FocusScopeNode.onKeyEvent`][]
*   [`HardwareKeyboard`][]
*   [`KeyboardListener`][]
*   [`KeyDownEvent`][]
*   [`KeyRepeatEvent`][]
*   [`KeyEvent`][]
*   [`KeyEventHandler`][]
*   [`KeyUpEvent`][]

Problemas relevantes:

*   [`RawKeyEvent` e `RawKeyboard`, et al devem ser descontinuados e removidos (Issue 136419)][]

PRs relevantes:

*   [Descontinuar RawKeyEvent, et al. e isentar usos no framework.][]

[`debugKeyEventSimulatorTransitModeOverride`]: {{site.api}}/flutter/services/debugKeyEventSimulatorTransitModeOverride-class.html
[`Focus.onKey`]: {{site.api}}/flutter/services/Focus/onKey.html
[`FocusNode.attach`]: {{site.api}}/flutter/services/FocusNode/attach.html
[`FocusNode.onKey`]: {{site.api}}/flutter/services/FocusNode/onKey.html
[`FocusOnKeyCallback`]: {{site.api}}/flutter/services/FocusOnKeyCallback-class.html
[`FocusScope.onKey`]: {{site.api}}/flutter/services/FocusScope/onKey.html
[`FocusScopeNode.onKey`]: {{site.api}}/flutter/services/FocusScopeNode/onKey.html
[`GLFWKeyHelper`]: {{site.api}}/flutter/services/GLFWKeyHelper-class.html
[`GtkKeyHelper`]: {{site.api}}/flutter/services/GtkKeyHelper-class.html
[`KeyboardSide`]: {{site.api}}/flutter/services/KeyboardSide-class.html
[`KeyDataTransitMode`]: {{site.api}}/flutter/services/KeyDataTransitMode-class.html
[`KeyEventManager`]: {{site.api}}/flutter/services/KeyEventManager-class.html
[`KeyHelper`]: {{site.api}}/flutter/services/KeyHelper-class.html
[`KeyMessage`]: {{site.api}}/flutter/services/KeyMessage-class.html
[`KeyMessageHandler`]: {{site.api}}/flutter/services/KeyMessageHandler-class.html
[`KeySimulatorTransitModeVariant`]: {{site.api}}/flutter/services/KeySimulatorTransitModeVariant-class.html
[`ModifierKey`]: {{site.api}}/flutter/services/ModifierKey-class.html
[`RawKeyboard`]: {{site.api}}/flutter/services/RawKeyboard-class.html
[`RawKeyboardListener`]: {{site.api}}/flutter/services/RawKeyboardListener-class.html
[`RawKeyDownEvent`]: {{site.api}}/flutter/services/RawKeyDownEvent-class.html
[`RawKeyEvent`]: {{site.api}}/flutter/services/RawKeyEvent-class.html
[`RawKeyEventData`]: {{site.api}}/flutter/services/RawKeyEventData-class.html
[`RawKeyEventDataAndroid`]: {{site.api}}/flutter/services/RawKeyEventDataAndroid-class.html
[`RawKeyEventDataFuchsia`]: {{site.api}}/flutter/services/RawKeyEventDataFuchsia-class.html
[`RawKeyEventDataIos`]: {{site.api}}/flutter/services/RawKeyEventDataIos-class.html
[`RawKeyEventDataLinux`]: {{site.api}}/flutter/services/RawKeyEventDataLinux-class.html
[`RawKeyEventDataMacOs`]: {{site.api}}/flutter/services/RawKeyEventDataMacOs-class.html
[`RawKeyEventDataWeb`]: {{site.api}}/flutter/services/RawKeyEventDataWeb-class.html
[`RawKeyEventDataWindows`]: {{site.api}}/flutter/services/RawKeyEventDataWindows-class.html
[`RawKeyEventHandler`]: {{site.api}}/flutter/services/RawKeyEventHandler-class.html
[`RawKeyUpEvent`]: {{site.api}}/flutter/services/RawKeyUpEvent-class.html
[`ServicesBinding.keyEventManager`]: {{site.api}}/flutter/services/ServicesBinding/keyEventManager.html
[`Focus.onKeyEvent`]: {{site.api}}/flutter/services/Focus/onKeyEvent.html
[`FocusNode.onKeyEvent`]: {{site.api}}/flutter/services/FocusNode/onKeyEvent.html
[`FocusOnKeyEventCallback`]: {{site.api}}/flutter/services/FocusOnKeyEventCallback-class.html
[`FocusScope.onKeyEvent`]: {{site.api}}/flutter/services/FocusScope/onKeyEvent.html
[`FocusScopeNode.onKeyEvent`]: {{site.api}}/flutter/services/FocusScopeNode/onKeyEvent.html
[`HardwareKeyboard`]: {{site.api}}/flutter/services/HardwareKeyboard-class.html
[`HardwareKeyboard.isLogicalKeyPressed`]: {{site.api}}/flutter/services/HardwareKeyboard/isLogicalKeyPressed.html
[`KeyboardListener`]: {{site.api}}/flutter/services/KeyboardListener-class.html
[`KeyDownEvent`]: {{site.api}}/flutter/services/KeyDownEvent-class.html
[`KeyRepeatEvent`]: {{site.api}}/flutter/services/KeyRepeatEvent-class.html
[`KeyEvent`]: {{site.api}}/flutter/services/KeyEvent-class.html
[`KeyEventHandler`]: {{site.api}}/flutter/services/KeyEventHandler-class.html
[`KeyUpEvent`]: {{site.api}}/flutter/services/KeyUpEvent-class.html
[`RawKeyEvent.isKeyPressed`]: {{site.api}}/flutter/services/RawKeyEvent/isKeyPressed.html
[`RawKeyEvent.isControlPressed`]: {{site.api}}/flutter/services/RawKeyEvent/isControlPressed.html
[`RawKeyEvent.isShiftPressed`]: {{site.api}}/flutter/services/RawKeyEvent/isShiftPressed.html
[`RawKeyEvent.isAltPressed`]: {{site.api}}/flutter/services/RawKeyEvent/isAltPressed.html
[`RawKeyEvent.isMetaPressed`]: {{site.api}}/flutter/services/RawKeyEvent/isMetaPressed.html
[`RawKeyEvent.repeat`]: {{site.api}}/flutter/services/RawKeyEvent/repeat.html
[`RawKeyEventDataAndroid.eventSource`]: {{site.api}}/flutter/services/RawKeyEventDataAndroid/eventSource.html
[`KeyEvent.deviceType`]: {{site.api}}/flutter/services/KeyEvent/deviceType.html
[`RawKeyEvent` and `RawKeyboard`, et al should be deprecated and removed (Issue 136419)]: {{site.repo.flutter}}/issues/136419
[Descontinuar RawKeyEvent, et al. e isentar usos no framework.]: {{site.repo.flutter}}/pull/136677
