---
title: showAutocorrectionPromptRect method added to TextInputClient 
description: >
  A new method, void showAutocorrectionPromptRect(int start, int end), 
  was added to the TextInputClient interface
ia-translate: true
---

## Resumo

A new method,`void showAutocorrectionPromptRect(int start, int end)`,
was added to the `TextInputClient` interface.

## Contexto

In order to display the iOS autocorrection highlight,
the iOS text input plugin needed a way to inform the
Flutter framework of the highlight's start and end position.

## Descrição da mudança

A new method, `void showAutocorrectionPromptRect(int start, int end)`,
was added to the `TextInputClient` interface. iOS calls this method
when it finds a new potential autocorrect candidate
in the current user input, or when the range of a previously
highlighted candidate changes.

## Guia de migração

If your application doesn't implement or subclass `TextInputClient`,
no migration is needed. If your application doesn't target iOS,
or the class that implemented the `textInputClient` interface doesn't 
support autocorrect, you only need to add an empty implementation
for the new method:

```dart
class CustomTextInputClient implements TextInputClient {
  void showAutocorrectionPromptRect(int start, int end) {}
}
```

Otherwise, if your app targets iOS and supports autocorrect on iOS,
we recommend that you add a sensible implementation of
`void showAutocorrectionPromptRect(int start, int end)` 
to your `TextInputClient` subclass. 

Código após a migração:

```dart
// Assume your `TextInputClient` is a `State` subclass, and it has a variable 
// `_currentPromptRectRange` that controls the autocorrection highlight.
class CustomTextInputClient extends State<...> implements TextInputClient {
  @override
  void updateEditingValue(TextEditingValue value) {
    // When the text changes, the highlight needs to be dismissed.
    if (value.text != _value.text) {
      setState(() {
        _currentPromptRectRange = null;
      });
    }
  }

  void _handleFocusChanged() {
    // When this text input loses focus, the autocorrection highlight needs
    // to be dismissed.
    if (!_hasFocus) {
      setState(() {
        _currentPromptRectRange = null;
      });
    }
  }

  @override
  void showAutocorrectionPromptRect(int start, int end) {
    // Updates the range of the highlight, as iOS requested.
    // This method isn't called when iOS decides to
    // dismiss the highlight.
    setState(() {
      _currentPromptRectRange = TextRange(start: start, end: end);
    });
  }
}
```

## Linha do tempo

Na versão estável: 1.20

## Referências

Documentação da API:

* [`TextInputClient`][]

Issues relevantes:

* [Issue 12920][]

PRs relevantes:

* [iOS UITextInput autocorrection prompt][]


[iOS UITextInput autocorrection prompt]: {{site.repo.flutter}}/pull/54119/
[Issue 12920]: {{site.repo.flutter}}/issues/12920
[`TextInputClient`]: {{site.api}}/flutter/services/TextInputClient-class.html
