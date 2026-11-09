---
title: Método showAutocorrectionPromptRect adicionado ao TextInputClient
description: >
  Um novo método, void showAutocorrectionPromptRect(int start, int end),
  foi adicionado à interface TextInputClient
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Um novo método, `void showAutocorrectionPromptRect(int start, int end)`,
foi adicionado à interface `TextInputClient`.

## Contexto {:#context}

Para exibir o destaque de autocorreção do iOS,
o plugin de entrada de texto do iOS precisava de uma maneira de informar ao
framework Flutter a posição inicial e final do destaque.

## Descrição da mudança {:#description-of-change}

Um novo método, `void showAutocorrectionPromptRect(int start, int end)`,
foi adicionado à interface `TextInputClient`. O iOS chama este método
quando encontra um novo candidato potencial de autocorreção
na entrada atual do usuário, ou quando o intervalo de um candidato
anteriormente destacado muda.

## Guia de migração {:#migration-guide}

Se sua aplicação não implementa ou estende `TextInputClient`,
nenhuma migração é necessária. Se sua aplicação não tem como alvo iOS,
ou a classe que implementa a interface `textInputClient` não
suporta autocorreção, você só precisa adicionar uma implementação vazia
para o novo método:

```dart
class CustomTextInputClient implements TextInputClient {
  void showAutocorrectionPromptRect(int start, int end) {}
}
```

Caso contrário, se seu app tem como alvo iOS e suporta autocorreção no iOS,
recomendamos que você adicione uma implementação sensata de
`void showAutocorrectionPromptRect(int start, int end)`
à sua subclasse de `TextInputClient`.

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

## Cronograma {:#timeline}

Na versão estável: 1.20

## Referências {:#references}

Documentação da API:

* [`TextInputClient`][]

Issue relevante:

* [Issue 12920][]

PR relevante:

* [iOS UITextInput autocorrection prompt][]


[iOS UITextInput autocorrection prompt]: {{site.repo.flutter}}/pull/54119/
[Issue 12920]: {{site.repo.flutter}}/issues/12920
[`TextInputClient`]: {{site.api}}/flutter/services/TextInputClient-class.html
