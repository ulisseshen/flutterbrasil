---
ia-translate: true
title: Mudança no local de anexação do FocusNode do TextField
description: >
  EditableText.focusNode não está mais anexado ao
  BuildContext do EditableTextState.
---

{% render "docs/breaking-changes.md" %}

## Resumo

`EditableText.focusNode` agora está anexado a
um widget `Focus` dedicado abaixo de `EditableText`.

## Contexto

Um widget de campo de entrada de texto (`TextField`, por exemplo)
tipicamente possui um `FocusNode`.
Quando esse `FocusNode` é o foco primário do app,
eventos (como pressionamentos de tecla) são enviados ao `BuildContext`
ao qual o `FocusNode` está anexado.

O `FocusNode` também desempenha um papel no tratamento de atalhos:
O widget `Shortcuts` traduz sequências de teclas em um `Intent`, e
tenta encontrar o primeiro handler adequado para esse `Intent` começando do
`BuildContext` ao qual o `FocusNode` está anexado, até
a raiz da árvore de widgets. Isso significa que um widget `Actions` (que fornece
handlers para diferentes `Intent`s) não será capaz de
lidar com quaisquer `Intent`s de atalho quando o `BuildContext` que
tem o foco primário está acima dele na árvore.

Anteriormente para `EditableText`, o `FocusNode` era anexado ao
`BuildContext` do `EditableTextState`.
Quaisquer widgets `Actions` definidos em `EditableTextState` (que serão inflados
abaixo do `BuildContext` do `EditableTextState`) não podiam lidar com
atalhos mesmo quando esse `EditableText` estava focado, pela
razão mencionada acima.

## Descrição da mudança

`EditableTextState` agora cria um widget `Focus` dedicado para
hospedar `EditableText.focusNode`.
Isso permite que `EditableTextState`s definam handlers para `Intent`s de atalho.
Por exemplo, `EditableText` agora tem um handler que
lida com o intent "deleteCharacter"
quando a tecla <kbd>DEL</kbd> é pressionada.

Esta mudança não envolve quaisquer mudanças na API pública mas
quebra codebases que dependem desse detalhe de implementação específico para
verificar se um `FocusNode` está associado a um campo de entrada de texto.

Esta mudança não quebra nenhuma build mas pode introduzir problemas em tempo de execução, ou
fazer com que testes existentes falhem.

## Guia de migração

O widget `EditableText` recebe um `FocusNode` como parâmetro, que era
anteriormente anexado ao `BuildContext` do seu `EditableText`. Se você está confiando
em verificação de tipo em tempo de execução para descobrir se um `FocusNode` está anexado a um campo de entrada
de texto ou um campo de texto selecionável como:

- `focusNode.context.widget is EditableText`
- `(focusNode.context as StatefulElement).state as EditableTextState`

Então por favor leia e considere seguir os passos de migração para evitar quebras.

Se você não tem certeza se um codebase precisa de migração,
procure por `is EditableText`, `as EditableText`, `is EditableTextState`, e
`as EditableTextState` e verifique se algum dos resultados de busca está fazendo
uma verificação de tipo ou typecast em um `FocusNode.context`.
Se sim, então migração é necessária.

Para evitar realizar uma verificação de tipo, ou fazer downcast
do `BuildContext` associado ao `FocusNode` de interesse, e
dependendo das capacidades reais que o codebase está tentando
invocar do `FocusNode` dado, dispare um `Intent` desse `BuildContext`.
Por exemplo, se você deseja atualizar o texto do `TextField` atualmente focado
para um valor específico, veja o seguinte exemplo:

Código antes da migração:

```dart
final Widget? focusedWidget = primaryFocus?.context?.widget;
if (focusedWidget is EditableText) {
  widget.controller.text = 'Updated Text';
}
```

Código após a migração:

```dart
final BuildContext? focusedContext = primaryFocus?.context;
if (focusedContext != null) {
  Actions.maybeInvoke(focusedContext, ReplaceTextIntent('UpdatedText'));
}
```

Para uma lista abrangente de `Intent`s suportados pelo widget `EditableText`,
consulte a documentação do widget `EditableText`.

## Cronograma

Landed in version: 2.6.0-12.0.pre<br>
In stable release: 2.10.0

## Referências

Documentação da API:

* [`EditableText`][]

PR relevante:

* [Move text editing Actions to EditableTextState][]

[`EditableText`]: {{site.api}}/flutter/widgets/EditableText-class.html
[Move text editing Actions to EditableTextState]: {{site.repo.flutter}}/pull/90684
