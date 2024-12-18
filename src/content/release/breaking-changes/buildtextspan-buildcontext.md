---
ia-translate: true
title: Adicionado parâmetro BuildContext a TextEditingController.buildTextSpan
description: >
  Um parâmetro BuildContext é adicionado a TextEditingController.buildTextSpan
  para que herdeiros que substituem buildTextSpan possam acessar widgets herdados.
---

## Resumo

Um parâmetro `BuildContext` foi adicionado a `TextEditingController.buildTextSpan`.

Classes que estendem ou implementam `TextEditingController`
e substituem `buildTextSpan` precisam adicionar o parâmetro
`BuildContext` à assinatura para torná-la uma substituição válida.

Os chamadores de `TextEditingController.buildTextSpan`
precisam passar um `BuildContext` para a chamada.

## Contexto

`TextEditingController.buildTextSpan` é chamado por `EditableText`
em seu controlador para criar o `TextSpan` que ele renderiza.
`buildTextSpan` pode ser substituído em classes personalizadas que estendem
`TextEditingController`. Isso permite que classes que estendem
`TextEditingController` substituam `buildTextSpan` para alterar
o estilo de partes do texto, por exemplo, para edição de rich text.

Qualquer estado que seja exigido por `buildTextSpan`
(além dos argumentos `TextStyle` e `withComposing`)
precisava ser passado para a classe que estende
`TextEditingController`.

## Descrição da mudança

Com o `BuildContext` disponível, os usuários podem acessar
`InheritedWidgets` dentro de `buildTextSpan`
para recuperar o estado necessário para estilizar o texto,
ou manipular de outra forma o `TextSpan` criado.

Considere o exemplo em que temos um
`HighlightTextEditingController` que deseja
destacar o texto definindo sua cor para `Theme.accentColor`.

Antes desta alteração, a implementação do controlador seria assim:

```dart
class HighlightTextEditingController extends TextEditingController {
  HighlightTextEditingController(this.highlightColor);

  final Color highlightColor;

  @override
  TextSpan buildTextSpan({TextStyle? style, required bool withComposing}) {
    return super.buildTextSpan(style: TextStyle(color: highlightColor), withComposing: withComposing);
  }
```

E os usuários do controlador precisariam passar a cor
ao criar o controlador.

Com o parâmetro `BuildContext` disponível,
o `HighlightTextEditingController` pode acessar diretamente
`Theme.accentColor` usando `Theme.of(BuildContext)`:

```dart
class HighlightTextEditingController extends TextEditingController {
  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    final Color color = Theme.of(context).accentColor;
    return super.buildTextSpan(context: context, style: TextStyle(color: color), withComposing: withComposing);
  }
}
```

## Guia de migração

### Substituindo `TextEditingController.buildTextSpan`

Adicione um parâmetro `required BuildContext context` à
assinatura da substituição de `buildTextSpan`.

Código antes da migração:

```dart
class MyTextEditingController {
  @override
  TextSpan buildTextSpan({TextStyle? style, required bool withComposing}) {
    /* ... */
  }
}
```

Mensagem de erro de exemplo antes da migração:

```plaintext
'MyTextEditingController.buildTextSpan' ('TextSpan Function({TextStyle? style, required bool withComposing})') não é uma substituição válida de 'TextEditingController.buildTextSpan' ('TextSpan Function({required BuildContext context, TextStyle? style, required bool withComposing})').
```

Código após a migração:

```dart
class MyTextEditingController {
  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    /* ... */
  }
}
```

### Chamando `TextEditingController.buildTextSpan`

Passe um parâmetro nomeado 'context' do tipo
`BuildContext` para a chamada.

Código antes da migração:

```dart
TextEditingController controller = /* ... */;
TextSpan span = controller.buildTextSpan(withComposing: false);
```

Mensagem de erro antes da migração:

```plaintext
O parâmetro nomeado 'context' é obrigatório, mas não há argumento correspondente.
Tente adicionar o argumento necessário.
```

Código após a migração:

```dart
BuildContext context = /* ... */;
TextEditingController controller = /* ... */;
TextSpan span = controller.buildTextSpan(context: context, withComposing: false);
```

## Linha do tempo

Implementado na versão: 1.26.0<br>
Na versão estável: 2.0.0

## Referências

Documentação da API:

* [`TextEditingController.buildTextSpan`][]

Issues relevantes:

* [Issue #72343][]

PRs relevantes:

* [Reland "Add BuildContext parameter to TextEditingController.buildTextSpan" #73510][]
* [Revert "Add BuildContext parameter to TextEditingController.buildTextSpan" #73503][]
* [Add BuildContext parameter to TextEditingController.buildTextSpan #72344][]

[Add BuildContext parameter to TextEditingController.buildTextSpan #72344]: {{site.repo.flutter}}/pull/72344
[Issue #72343]: {{site.repo.flutter}}/issues/72343
[Reland "Add BuildContext parameter to TextEditingController.buildTextSpan" #73510]: {{site.repo.flutter}}/pull/73510
[Revert "Add BuildContext parameter to TextEditingController.buildTextSpan" #73503]: {{site.repo.flutter}}/pull/73503
[`TextEditingController.buildTextSpan`]: {{site.api}}/flutter/widgets/TextEditingController/buildTextSpan.html

