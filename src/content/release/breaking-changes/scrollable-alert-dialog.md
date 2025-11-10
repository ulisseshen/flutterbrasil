---
title: AlertDialog rolável (Não mais obsoleto)
description: AlertDialog deve rolar automaticamente quando transborda.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

:::note
`AlertDialog.scrollable` não está mais obsoleto porque não há
maneira retrocompatível de tornar `AlertDialog` rolável por padrão.
Em vez disso, o parâmetro permanecerá e você pode definir `scrollable`
como true se quiser um `AlertDialog` rolável.
:::

Um `AlertDialog` agora rola automaticamente quando transborda.

## Contexto

Antes desta mudança,
quando o conteúdo de um widget `AlertDialog` era muito alto,
a exibição transbordava, causando o corte do conteúdo.
Isso resultou nos seguintes problemas:

* Não havia como visualizar a parte do conteúdo que foi cortada.
* A maioria dos diálogos de alerta tem botões abaixo do conteúdo para solicitar aos usuários
  ações. Se o conteúdo transbordasse, obscurecendo os botões,
  os usuários poderiam não estar cientes de sua existência.

## Descrição da mudança

A abordagem anterior listava os widgets de título e conteúdo
consecutivamente em um widget `Column`.

```dart
Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: <Widget>[
    if (title != null)
      Padding(
        padding: titlePadding ?? EdgeInsets.fromLTRB(24, 24, 24, content == null ? 20 : 0),
        child: DefaultTextStyle(
          style: titleTextStyle ?? dialogTheme.titleTextStyle ?? theme.textTheme.title,
          child: Semantics(
          child: title,
          namesRoute: true,
          container: true,
          ),
        ),
      ),
    if (content != null)
      Flexible(
        child: Padding(
        padding: contentPadding,
        child: DefaultTextStyle(
          style: contentTextStyle ?? dialogTheme.contentTextStyle ?? theme.textTheme.subhead,
          child: content,
        ),
      ),
    ),
    // ...
  ],
);
```

A nova abordagem envolve ambos os widgets em um
`SingleChildScrollView` acima da barra de botões,
tornando ambos os widgets parte do mesmo rolável
e expondo a barra de botões na parte inferior do diálogo.

```dart
Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: <Widget>[
    if (title != null || content != null)
      SingleChildScrollView(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
         children: <Widget>[
           if (title != null)
             titleWidget,
             if (content != null)
             contentWidget,
         ],
       ),
     ),
   // ...
  ],
),
```

## Guia de migração

Você pode ver os seguintes problemas como resultado desta mudança:

**Testes de semântica podem falhar devido à adição de um `SingleChildScrollView`.**
: Testes manuais dos recursos `Talkback` e `VoiceOver`
  mostram que eles ainda exibem o mesmo comportamento (correto)
  de antes.

**Testes golden podem falhar.**
: Esta mudança pode ter causado diferenças em testes golden
  (anteriormente passando) já que o `SingleChildScrollView` agora aninha ambos os
  widgets de título e conteúdo.
  Alguns projetos Flutter adotaram a criação de testes de semântica
  tirando goldens de nós de semântica usados no build de debug do Flutter.

  <br>Quaisquer atualizações de golden de semântica que refletem a adição do
  contêiner rolável são esperadas e essas diferenças devem ser seguras para aceitar.

  Exemplo de árvore de Semântica resultante:

```plaintext
flutter:        ├─SemanticsNode#30 <-- SingleChildScrollView
flutter:          │ flags: hasImplicitScrolling
flutter:          │ scrollExtentMin: 0.0
flutter:          │ scrollPosition: 0.0
flutter:          │ scrollExtentMax: 0.0
flutter:          │
flutter:          ├─SemanticsNode#31 <-- title
flutter:          │   flags: namesRoute
flutter:          │   label: "Hello"
flutter:          │
flutter:          └─SemanticsNode#32 <-- contents
flutter:              label: "Huge content"
```

**Mudanças de layout podem resultar devido à visualização de rolagem.**
: Se o diálogo já estava transbordando,
  esta mudança corrige o problema.
  Esta mudança de layout é esperada.

  <br>Um `SingleChildScrollView` aninhado em `AlertDialog.content`
  deve funcionar corretamente se deixado no código,
  mas deve ser removido se não intencional, já que
  pode causar confusão.

Código antes da migração:

```dart
AlertDialog(
  title: Text(
    'Very, very large title that is also scrollable',
    textScaleFactor: 5,
  ),
  content: SingleChildScrollView( // won't be scrollable
    child: Text('Scrollable content', textScaleFactor: 5),
  ),
  actions: <Widget>[
    TextButton(child: Text('Button 1'), onPressed: () {}),
    TextButton(child: Text('Button 2'), onPressed: () {}),
  ],
)
```

Código após a migração:

```dart
AlertDialog(
  title: Text('Very, very large title', textScaleFactor: 5),
  content: Text('Very, very large content', textScaleFactor: 5),
  actions: <Widget>[
    TextButton(child: Text('Button 1'), onPressed: () {}),
    TextButton(child: Text('Button 2'), onPressed: () {}),
  ],
)
```

## Linha do tempo

Lançado na versão: 1.16.3<br>
Na versão estável: 1.17

## Referências

Documento de design:

* [`AlertDialog` rolável][]

Documentação da API:

* [`AlertDialog`][]

Issue relevante:

* [Exceções de overflow com tamanho máximo de fonte de acessibilidade][]

PRs relevantes:

* [Atualização para `AlertDialog.scrollable`][]
* [Tentativa original de implementar `AlertDialog` rolável][]
* [Reversão da tentativa original de implementar `AlertDialog` rolável][]


[`AlertDialog`]: {{site.api}}/flutter/material/AlertDialog-class.html
[Tentativa original de implementar `AlertDialog` rolável]: {{site.repo.flutter}}/pull/43226
[Exceções de overflow com tamanho máximo de fonte de acessibilidade]: {{site.repo.flutter}}/issues/42696
[Reversão da tentativa original de implementar `AlertDialog` rolável]: {{site.repo.flutter}}/pull/44003
[`AlertDialog` rolável]: /go/scrollable-alert-dialog
[Atualização para `AlertDialog.scrollable`]: {{site.repo.flutter}}/pull/45079
