---
ia-translate: true
title: AlertDialog Rolar (Não está mais obsoleto)
description: AlertDialog deve rolar automaticamente quando estoura.
---

## Sumário

:::note
`AlertDialog.scrollable` não está mais obsoleto porque não há
uma maneira retrocompatível de tornar o `AlertDialog` rolável por padrão.
Em vez disso, o parâmetro permanecerá e você pode definir `scrollable`
como verdadeiro se quiser um `AlertDialog` rolável.
:::

Um `AlertDialog` agora rola automaticamente quando estoura.

## Contexto

Antes dessa mudança,
quando o conteúdo de um widget `AlertDialog` era muito alto,
a exibição estourava, fazendo com que o conteúdo fosse cortado.
Isso resultou nos seguintes problemas:

* Não havia como visualizar a parte do conteúdo que foi cortada.
* A maioria das caixas de diálogo de alerta tem botões abaixo do conteúdo para solicitar ações dos usuários. Se o conteúdo estourasse, obscurecendo os botões, os usuários poderiam não estar cientes de sua existência.

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
e expondo a barra de botões na parte inferior da caixa de diálogo.

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

Você pode ver os seguintes problemas como resultado desta alteração:

**Testes de semântica podem falhar devido à adição de um `SingleChildScrollView`.**
: Testes manuais dos recursos `Talkback` e `VoiceOver`
  mostram que eles ainda exibem o mesmo comportamento (correto)
  de antes.

**Testes Golden podem falhar.**
: Essa alteração pode ter causado diferenças em testes golden (anteriormente aprovados)
  já que o `SingleChildScrollView` agora aninha os widgets de título e conteúdo.
  Alguns projetos Flutter passaram a criar testes de semântica
  usando goldens de nós semânticos usados na construção de depuração do Flutter.

  <br>Quaisquer atualizações golden semânticas que reflitam a rolagem
  adição de contêiner são esperadas e essas diferenças devem ser seguras para aceitar.

  Exemplo de árvore de semântica resultante:

```plaintext
flutter:        ├─SemanticsNode#30 <-- SingleChildScrollView
flutter:          │ flags: hasImplicitScrolling
flutter:          │ scrollExtentMin: 0.0
flutter:          │ scrollPosition: 0.0
flutter:          │ scrollExtentMax: 0.0
flutter:          │
flutter:          ├─SemanticsNode#31 <-- title
flutter:          │   flags: namesRoute
flutter:          │   label: "Olá"
flutter:          │
flutter:          └─SemanticsNode#32 <-- contents
flutter:              label: "Conteúdo enorme"
```

**Alterações de layout podem resultar por causa da visualização de rolagem.**
: Se a caixa de diálogo já estava estourando,
  esta mudança corrige o problema.
  Essa mudança de layout é esperada.

  <br>Um `SingleChildScrollView` aninhado em `AlertDialog.content`
  deve funcionar corretamente se deixado no código,
  mas deve ser removido se não for intencional, pois
  pode causar confusão.

Código antes da migração:

```dart
AlertDialog(
  title: Text(
    'Título muito, muito grande que também é rolável',
    textScaleFactor: 5,
  ),
  content: SingleChildScrollView( // não será rolável
    child: Text('Conteúdo rolável', textScaleFactor: 5),
  ),
  actions: <Widget>[
    TextButton(child: Text('Botão 1'), onPressed: () {}),
    TextButton(child: Text('Botão 2'), onPressed: () {}),
  ],
)
```

Código após a migração:

```dart
AlertDialog(
  title: Text('Título muito, muito grande', textScaleFactor: 5),
  content: Text('Conteúdo muito, muito grande', textScaleFactor: 5),
  actions: <Widget>[
    TextButton(child: Text('Botão 1'), onPressed: () {}),
    TextButton(child: Text('Botão 2'), onPressed: () {}),
  ],
)
```

## Linha do tempo

Implementado na versão: 1.16.3<br>
Na versão estável: 1.17

## Referências

Documento de design:

* [AlertDialog rolável][]

Documentação da API:

* [`AlertDialog`][]

Problema relevante:

* [Exceções de estouro com tamanho máximo de fonte de acessibilidade][]

PRs relevantes:

* [Atualização para `AlertDialog.scrollable`][]
* [Tentativa original de implementar `AlertDialog` rolável][]
* [Reversão da tentativa original de implementar `AlertDialog` rolável][]

[`AlertDialog`]: {{site.api}}/flutter/material/AlertDialog-class.html
[Tentativa original de implementar `AlertDialog` rolável]: {{site.repo.flutter}}/pull/43226
[Exceções de estouro com tamanho máximo de fonte de acessibilidade]: {{site.repo.flutter}}/issues/42696
[Reversão da tentativa original de implementar `AlertDialog` rolável]: {{site.repo.flutter}}/pull/44003
[AlertDialog rolável]: /go/scrollable-alert-dialog
[Atualização para `AlertDialog.scrollable`]: {{site.repo.flutter}}/pull/45079
