---
title: Adicionado parâmetro BuildContext a TextEditingController.buildTextSpan
description: >
  Um parâmetro BuildContext é adicionado a TextEditingController.buildTextSpan para que
  herdeiros que sobrescrevem buildTextSpan possam acessar widgets herdados.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

Um parâmetro `BuildContext` foi adicionado a `TextEditingController.buildTextSpan`.

Classes que estendem ou implementam `TextEditingController`
e sobrescrevem `buildTextSpan` precisam adicionar o parâmetro `BuildContext`
à assinatura para torná-la uma sobrescrita válida.

Chamadores de `TextEditingController.buildTextSpan`
precisam passar um `BuildContext` para a chamada.

## Context

`TextEditingController.buildTextSpan` é chamado por `EditableText`
em seu controller para criar o `TextSpan` que ele renderiza.
`buildTextSpan` pode ser sobrescrito em classes customizadas que estendem
`TextEditingController`. Isso permite que classes que estendem
`TextEditingController` sobrescrevam `buildTextSpan` para alterar
o estilo de partes do texto, por exemplo, para edição de rich text.

Qualquer estado que é requerido por `buildTextSpan`
(além dos argumentos `TextStyle` e `withComposing`)
precisava ser passado para a classe que estende
`TextEditingController`.

## Description of change

Com o `BuildContext` disponível, usuários podem acessar
`InheritedWidgets` dentro de `buildTextSpan`
para recuperar o estado necessário para estilizar o texto,
ou de outra forma manipular o `TextSpan` criado.

Considere o exemplo onde temos um
`HighlightTextEditingController` que deseja
destacar texto definindo sua cor como `Theme.accentColor`.

Antes desta mudança, a implementação do controller seria assim:

```dart
class HighlightTextEditingController extends TextEditingController {
  HighlightTextEditingController(this.highlightColor);

  final Color highlightColor;

  @override
  TextSpan buildTextSpan({TextStyle? style, required bool withComposing}) {
    return super.buildTextSpan(style: TextStyle(color: highlightColor), withComposing: withComposing);
  }
```

E usuários do controller precisariam passar a cor
ao criar o controller.

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

## Migration guide

### Overriding `TextEditingController.buildTextSpan`

Adicione um parâmetro `required BuildContext context` à
assinatura da sobrescrita de `buildTextSpan`.

Code before migration:

```dart
class MyTextEditingController {
  @override
  TextSpan buildTextSpan({TextStyle? style, required bool withComposing}) {
    /* ... */
  }
}
```

Exemplo de mensagem de erro antes da migração:

```plaintext
'MyTextEditingController.buildTextSpan' ('TextSpan Function({TextStyle? style, required bool withComposing})') isn't a valid override of 'TextEditingController.buildTextSpan' ('TextSpan Function({required BuildContext context, TextStyle? style, required bool withComposing})').
```

Code after migration:

```dart
class MyTextEditingController {
  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    /* ... */
  }
}
```

### Calling `TextEditingController.buildTextSpan`

Passe um parâmetro nomeado 'context' do tipo
`BuildContext` para a chamada.

Code before migration:

```dart
TextEditingController controller = /* ... */;
TextSpan span = controller.buildTextSpan(withComposing: false);
```

Mensagem de erro antes da migração:

```plaintext
The named parameter 'context' is required, but there's no corresponding argument.
Try adding the required argument.
```

Code after migration:

```dart
BuildContext context = /* ... */;
TextEditingController controller = /* ... */;
TextSpan span = controller.buildTextSpan(context: context, withComposing: false);
```

## Timeline

Landed in version: 1.26.0<br>
In stable release: 2.0.0

## References

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
