---
ia-translate: true
title: Método showAutocorrectionPromptRect adicionado a TextInputClient
description: >
  Um novo método, void showAutocorrectionPromptRect(int start, int end), 
  foi adicionado à interface TextInputClient
---

## Sumário

Um novo método, `void showAutocorrectionPromptRect(int start, int end)`,
foi adicionado à interface `TextInputClient`.

## Contexto

Para exibir o destaque de autocorreção do iOS, o plugin de entrada de texto do iOS precisava de uma maneira de informar o framework Flutter sobre a posição inicial e final do destaque.

## Descrição da alteração

Um novo método, `void showAutocorrectionPromptRect(int start, int end)`,
foi adicionado à interface `TextInputClient`. O iOS chama esse método quando encontra um novo candidato potencial de autocorreção na entrada do usuário atual, ou quando o intervalo de um candidato previamente destacado é alterado.

## Guia de migração

Se o seu aplicativo não implementa ou cria subclasses de `TextInputClient`, nenhuma migração é necessária. Se o seu aplicativo não tem como alvo o iOS, ou a classe que implementou a interface `textInputClient` não oferece suporte à autocorreção, você só precisa adicionar uma implementação vazia para o novo método:

```dart
class CustomTextInputClient implements TextInputClient {
  void showAutocorrectionPromptRect(int start, int end) {}
}
```

Caso contrário, se seu aplicativo tiver como alvo o iOS e oferecer suporte à autocorreção no iOS, recomendamos que você adicione uma implementação sensata de `void showAutocorrectionPromptRect(int start, int end)` à sua subclasse `TextInputClient`.

Código após a migração:

```dart
// Suponha que seu `TextInputClient` seja uma subclasse `State`, e tenha uma variável
// `_currentPromptRectRange` que controla o destaque de autocorreção.
class CustomTextInputClient extends State<...> implements TextInputClient {
  @override
  void updateEditingValue(TextEditingValue value) {
    // Quando o texto muda, o destaque precisa ser descartado.
    if (value.text != _value.text) {
      setState(() {
        _currentPromptRectRange = null;
      });
    }
  }

  void _handleFocusChanged() {
    // Quando esta entrada de texto perde o foco, o destaque de autocorreção precisa
    // ser descartado.
    if (!_hasFocus) {
      setState(() {
        _currentPromptRectRange = null;
      });
    }
  }

  @override
  void showAutocorrectionPromptRect(int start, int end) {
    // Atualiza o intervalo do destaque, conforme solicitado pelo iOS.
    // Este método não é chamado quando o iOS decide
    // descartar o destaque.
    setState(() {
      _currentPromptRectRange = TextRange(start: start, end: end);
    });
  }
}
```

## Cronograma

Na versão estável: 1.20

## Referências

Documentação da API:

* [`TextInputClient`][]

Issue relevante:

* [Issue 12920][]

PR relevante:

* [Prompt de autocorreção do iOS UITextInput][]

[iOS UITextInput autocorrection prompt]: {{site.repo.flutter}}/pull/54119/
[Issue 12920]: {{site.repo.flutter}}/issues/12920
[`TextInputClient`]: {{site.api}}/flutter/services/TextInputClient-class.html
