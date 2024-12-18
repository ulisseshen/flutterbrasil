---
ia-translate: true
title: Mudança de Localização do Anexo do TextField FocusNode
description: >
  `EditableText.focusNode` não está mais anexado ao
  `BuildContext` de `EditableTextState`.
---

## Resumo

`EditableText.focusNode` agora está anexado a um widget `Focus`
dedicado abaixo de `EditableText`.

## Contexto

Um widget de campo de entrada de texto (`TextField`, por exemplo)
normalmente possui um `FocusNode`.
Quando esse `FocusNode` é o foco principal do aplicativo,
eventos (como pressionamentos de tecla) são enviados ao `BuildContext`
ao qual o `FocusNode` está anexado.

O `FocusNode` também desempenha um papel no tratamento de atalhos:
O widget `Shortcuts` traduz sequências de teclas em um `Intent`, e
tenta encontrar o primeiro manipulador adequado para aquele `Intent`,
começando do `BuildContext` ao qual o `FocusNode` está anexado, até
a raiz da árvore de widgets. Isso significa que um widget `Actions`
(que fornece manipuladores para diferentes `Intent`s) não poderá
manipular nenhum atalho `Intent`s quando o `BuildContext` que
tem o foco principal está acima dele na árvore.

Anteriormente, para `EditableText`, o `FocusNode` era anexado ao
`BuildContext` de `EditableTextState`.
Quaisquer widgets `Actions` definidos em `EditableTextState` (que serão
inflados abaixo do `BuildContext` do `EditableTextState`) não podiam
manipular atalhos, mesmo quando aquele `EditableText` estava focado,
pelo motivo declarado acima.

## Descrição da mudança

`EditableTextState` agora cria um widget `Focus` dedicado para hospedar
`EditableText.focusNode`.
Isso permite que `EditableTextState`s definam manipuladores para atalho
`Intent`s. Por exemplo, `EditableText` agora tem um manipulador que
lida com o intent "deleteCharacter" quando a tecla <kbd>DEL</kbd> é
pressionada.

Essa alteração não envolve nenhuma alteração na API pública, mas
quebra bases de código que dependem desse detalhe de implementação
específico para dizer se um `FocusNode` está associado a um campo
de entrada de texto.

Essa alteração não quebra nenhuma compilação, mas pode introduzir
problemas de tempo de execução ou fazer com que os testes existentes
falhem.

## Guia de migração

O widget `EditableText` recebe um `FocusNode` como parâmetro, que
anteriormente estava anexado ao `BuildContext` do seu `EditableText`.
Se você está confiando na verificação de tipo em tempo de execução
para descobrir se um `FocusNode` está anexado a um campo de entrada
de texto ou um campo de texto selecionável como:

- `focusNode.context.widget is EditableText`
- `(focusNode.context as StatefulElement).state as EditableTextState`

Então, continue lendo e considere seguir os passos de migração para
evitar quebras.

Se você não tem certeza se uma base de código precisa de migração,
pesquise por `is EditableText`, `as EditableText`, `is EditableTextState` e
`as EditableTextState` e verifique se algum dos resultados da
pesquisa está fazendo uma verificação de tipo ou typecast em um
`FocusNode.context`. Se sim, então a migração é necessária.

Para evitar realizar uma verificação de tipo ou downcasting
o `BuildContext` associado ao `FocusNode` de interesse, e
dependendo das capacidades reais que a base de código está tentando
invocar do dado `FocusNode`, dispare um `Intent` daquele
`BuildContext`. Por exemplo, se você deseja atualizar o texto do
`TextField` atualmente focado para um valor específico, veja o seguinte
exemplo:

Código antes da migração:

```dart
final Widget? focusedWidget = primaryFocus?.context?.widget;
if (focusedWidget is EditableText) {
  widget.controller.text = 'Texto Atualizado';
}
```

Código após a migração:

```dart
final BuildContext? focusedContext = primaryFocus?.context;
if (focusedContext != null) {
  Actions.maybeInvoke(focusedContext, ReplaceTextIntent('TextoAtualizado'));
}
```

Para uma lista abrangente de `Intent`s suportados pelo widget
`EditableText`, consulte a documentação do widget `EditableText`.

## Cronograma

Implementado na versão: 2.6.0-12.0.pre<br>
Na versão estável: 2.10.0

## Referências

Documentação da API:

* [`EditableText`][]

PR relevante:

* [Mover as Actions de edição de texto para EditableTextState][]

[`EditableText`]: {{site.api}}/flutter/widgets/EditableText-class.html
[Mover as Actions de edição de texto para EditableTextState]: {{site.repo.flutter}}/pull/90684
