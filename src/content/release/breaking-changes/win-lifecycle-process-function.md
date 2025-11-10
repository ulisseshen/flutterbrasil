---
title: Introdução do FlutterEngine::ProcessExternalWindowMessage
description: >-
  Janelas externas devem chamar ProcessExternalWindowMessage para
  serem consideradas em eventos de ciclo de vida do aplicativo.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

Quando você adiciona janelas externas ao seu app Flutter,
você precisa incluí-las na lógica de ciclo de vida do app Windows.
Para incluir a janela, sua função `WndProc` deve invocar
`FlutterEngine::ProcessExternalWindowMessage`.

## Quem é afetado

Aplicativos Windows compilados com Flutter 3.13 ou mais recente que
abrem janelas não-Flutter.

## Descrição da mudança

Implementar o ciclo de vida do aplicativo no Windows envolve escutar mensagens
do Window para atualizar o estado do ciclo de vida. Para que janelas não-Flutter
adicionais afetem o estado do ciclo de vida, elas devem encaminhar suas mensagens
de janela para `FlutterEngine::ProcessExternalWindowMessage` a partir de suas
funções `WndProc`. Esta função retorna um `std::optional<LRESULT>`, que é
`std::nullopt` quando a mensagem é recebida, mas não consumida. Quando o
resultado retornado tem um valor, a mensagem foi consumida, e o processamento
adicional em `WndProc` deve cessar.

## Guia de migração

O seguinte exemplo de procedimento `WndProc` invoca
`FlutterEngine::ProcessExternalWindowMessage`:

```cpp
LRESULT Window::Messagehandler(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam) {
    std::optional<LRESULT> result = flutter_controller_->engine()->ProcessExternalWindowMessage(hwnd, msg, wparam, lparam);
    if (result.has_value()) {
        return *result;
    }
    // Original contents of WndProc...
}
```

## Cronograma

Adicionado na versão: 3.14.0-3.0.pre<br>
Na versão estável: 3.16

## Referências

PRs relevantes:

* [Reintroduce Windows lifecycle with guard for posthumous OnWindowStateEvent][Reintroduce Windows lifecycle with guard for posthumous OnWindowStateEvent]

[Reintroduce Windows lifecycle with guard for posthumous OnWindowStateEvent]: {{site.repo.engine}}/pull/44344
