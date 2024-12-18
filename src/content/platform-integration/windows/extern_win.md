---
ia-translate: true
title: Janelas externas em aplicativos Flutter para Windows
description: Considerações especiais para adicionar janelas externas a aplicativos Flutter
---

# Ciclo de vida do Windows

## Quem é afetado

Aplicativos Windows construídos com versões do Flutter posteriores a 3.13 que abrem janelas não-Flutter.

## Visão geral

Ao adicionar uma janela não-Flutter a um aplicativo Flutter para Windows, ela não fará parte da lógica para atualizações de estado do ciclo de vida do aplicativo por padrão. Por exemplo, isso significa que quando a janela externa é mostrada ou oculta, o estado do ciclo de vida do aplicativo não será atualizado adequadamente para inativo ou oculto. Como resultado, o aplicativo pode receber mudanças de estado de ciclo de vida incorretas por meio de [WidgetsBindingObserver.didChangeAppLifecycle][].

# O que preciso fazer?

Para adicionar a janela externa a esta lógica do aplicativo, o procedimento `WndProc` da janela deve invocar `FlutterEngine::ProcessExternalWindowMessage`.

Para conseguir isso, adicione o seguinte código a uma função de manipulador de mensagens de janela:

```cpp diff
  LRESULT Window::Messagehandler(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam) {
+     std::optional<LRESULT> result = flutter_controller_->engine()->ProcessExternalWindowMessage(hwnd, msg, wparam, lparam);
+     if (result.has_value()) {
+         return *result;
+     }
      // Conteúdo original do WndProc...
  }
```

[documentação dessa mudança de quebra.]: /release/breaking-changes/win_lifecycle_process_function
[WidgetsBindingObserver.didChangeAppLifecycle]: {{site.api}}/flutter/widgets/WidgetsBindingObserver/didChangeAppLifecycleState.html
