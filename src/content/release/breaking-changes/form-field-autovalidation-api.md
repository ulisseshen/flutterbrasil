---
ia-translate: true
title: A nova API de auto-validação de Form e FormField
description: Fornece mais controle sobre como validar automaticamente um Form e um FormField.
---

{% render "docs/breaking-changes.md" %}

## Resumo

A API de validação automática anterior para os widgets `Form` e
`FormField` não controlava quando a validação automática
deveria ocorrer. Portanto, a validação automática para esses widgets
sempre acontecia na primeira construção quando o widget ficava
visível para o usuário pela primeira vez, e você não conseguia controlar
quando a validação automática deveria acontecer.

## Contexto

Devido à API original não permitir que desenvolvedores alterassem
o comportamento da validação automática para validar apenas quando
o usuário interage com o campo de formulário, adicionamos uma nova API
que permite aos desenvolvedores configurar como eles querem que a
validação automática se comporte para os widgets `Form` e `FormField`.

## Descrição da mudança

As seguintes alterações foram feitas:

* O parâmetro `autovalidate` está obsoleto.
* Um novo parâmetro chamado `autovalidateMode`,
  um Enum que aceita valores da classe Enum `AutovalidateMode`,
  foi adicionado.

## Guia de migração

Para migrar para a nova API de validação automática, você precisa
substituir o uso do parâmetro obsoleto `autovalidate` pelo novo
parâmetro `autovalidateMode`. Se você quiser o mesmo comportamento
de antes, pode usar: `autovalidateMode = AutovalidateMode.always`.
Isso faz com que seus widgets `Form` e `FormField` validem
automaticamente na primeira construção e sempre que houver mudanças.

Código antes da migração:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FormField(
      autovalidate: true,
      builder: (FormFieldState state) {
        return Container();
      },
    );
  }
}
```

Código após a migração:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FormField(
      autovalidateMode: AutovalidateMode.always,
      builder: (FormFieldState state) {
        return Container();
      },
    );
  }
}
```

## Cronograma

Implementado na versão: 1.21.0-5.0.pre<br>
Na versão estável: 1.22

## Referências

Documentação da API:

* [`AutovalidateMode`]({{site.api}}/flutter/widgets/AutovalidateMode.html)

Issues relevantes:

* [Issue 56363]({{site.repo.flutter}}/issues/56363)
* [Issue 18885]({{site.repo.flutter}}/issues/18885)
* [Issue 15404]({{site.repo.flutter}}/issues/15404)
* [Issue 36154]({{site.repo.flutter}}/issues/36154)
* [Issue 48876]({{site.repo.flutter}}/issues/48876)

PRs relevantes:

* [PR 56365: FormField should autovalidate only if its
  content was changed]({{site.github}}/flutter/pull/56365)
* [PR 59766: FormField should autovalidate only if its
  content was changed
  (fixed)]({{site.repo.flutter}}/pull/59766)
