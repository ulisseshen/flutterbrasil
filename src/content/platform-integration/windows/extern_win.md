---
ia-translate: true
title: Janelas externas em apps Flutter Windows
description: Considerações especiais para adicionar janelas externas a apps Flutter
---

# Ciclo de vida do Windows

## Quem é afetado

Aplicações Windows construídas com versões do Flutter após 3.13 que abrem janelas não-Flutter.


## Visão geral

Ao adicionar uma janela não-Flutter a um app Flutter Windows, ela não fará parte
da lógica para atualizações de estado do ciclo de vida da aplicação por padrão. Por exemplo,
isso significa que quando a janela externa é mostrada ou oculta, o estado do ciclo de vida do app
não será atualizado apropriadamente para inativo ou oculto. Como resultado, o app
pode receber mudanças de estado do ciclo de vida incorretas através de
[WidgetsBindingObserver.didChangeAppLifecycle][].

# O que eu preciso fazer?

Para adicionar a janela externa a essa lógica da aplicação,
o procedimento `WndProc` da janela
deve invocar `FlutterEngine::ProcessExternalWindowMessage`.

Para conseguir isso, adicione o seguinte código a uma função manipuladora de mensagens de janela:

```cpp diff
  LRESULT Window::Messagehandler(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam) {
+     std::optional<LRESULT> result = flutter_controller_->engine()->ProcessExternalWindowMessage(hwnd, msg, wparam, lparam);
+     if (result.has_value()) {
+         return *result;
+     }
      // Original contents of WndProc...
  }
```

[documentation of this breaking change.]: /release/breaking-changes/win_lifecycle_process_function
[WidgetsBindingObserver.didChangeAppLifecycle]: {{site.api}}/flutter/widgets/WidgetsBindingObserver/didChangeAppLifecycleState.html
