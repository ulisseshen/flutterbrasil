---
ia-translate: true
title: A nova API de auto-validação de Form e FormField
description: Dá mais controle em como auto validar um Form e um FormField.
---

## Resumo

A API de auto-validação anterior para os widgets `Form` e
`FormField` não controlava quando a auto-validação
deveria ocorrer. Então a auto-validação para esses widgets
sempre acontecia na primeira construção quando o widget era
visível ao usuário pela primeira vez, e você não era capaz
de controlar quando a auto-validação deveria acontecer.

## Contexto

Devido à API original não permitir que os desenvolvedores
mudassem o comportamento de auto-validação para validar
somente quando o usuário interage com o campo do formulário,
nós adicionamos uma nova API que permite aos desenvolvedores
configurar como eles querem que a auto-validação se
comporte para os widgets `Form` e `FormField`.

## Descrição da mudança

As seguintes mudanças foram feitas:

* O parâmetro `autovalidate` está obsoleto.
* Um novo parâmetro chamado `autovalidateMode`,
  um Enum que aceita valores da classe Enum `AutovalidateMode`,
  foi adicionado.

## Guia de migração

Para migrar para a nova API de auto-validação você precisa
substituir o uso do parâmetro obsoleto `autovalidate`
pelo novo parâmetro `autovalidateMode`.
Se você quer o mesmo comportamento de antes, você pode usar:
`autovalidateMode = AutovalidateMode.always`.
Isso faz com que seus widgets `Form` e `FormField` se auto
validem na primeira construção e toda vez que mudam.

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

## Linha do tempo

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
