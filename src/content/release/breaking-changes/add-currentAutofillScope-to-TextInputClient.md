---
title: Adicionando a propriedade TextInputClient.currentAutofillScope
description: >
  Um novo getter TextInputClient.currentAutofillScope foi
  adicionado à interface TextInputClient para suporte a autofill.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

Um novo getter, `TextInputClient.currentAutofillScope`, foi adicionado à
interface `TextInputClient`; todas as subclasses de `TextInputClient` devem
fornecer uma implementação concreta de `currentAutofillScope`.

Este getter permite que o `TextInputClient` acione um
autofill que envolve múltiplos campos de entrada logicamente conectados.
Por exemplo, um campo "username" pode acionar um
autofill que preenche tanto ele próprio quanto o campo "password"
associado a ele.

## Contexto

Em muitas plataformas, os serviços de autofill são capazes de
preencher automaticamente múltiplos campos de entrada em uma única tentativa de autofill.
Por exemplo, campos de nome de usuário e campos de senha geralmente podem
ser preenchidos automaticamente de uma só vez. Por esse motivo, um campo de entrada
do Flutter que está prestes a acionar o autofill também deve fornecer
à plataforma informações sobre outros campos de entrada preenchíveis automaticamente
logicamente conectados a ele.
`TextInputClient.currentAutofillScope` define o grupo de
campos de entrada que estão logicamente conectados a este `TextInputClient`,
e podem ser preenchidos automaticamente juntos.

## Descrição da alteração

`TextInputClient` agora tem um getter adicional que retorna
o `AutofillScope` ao qual este cliente pertence.
Este getter é usado pelo cliente de entrada para coletar informações
relacionadas ao autofill de outros campos de entrada preenchíveis automaticamente
dentro do mesmo escopo.

```dart
abstract class TextInputClient {
  AutofillScope get currentAutofillScope;
}
```

Se você vir a mensagem de erro "missing concrete implementation of
'getter TextInputClient.currentAutofillScope'" ao compilar
um aplicativo Flutter, siga as etapas de migração listadas abaixo.

## Guia de migração

Se você não está planejando adicionar suporte a autofill
de múltiplos campos à sua subclasse `TextInputClient`,
simplesmente retorne `null` no getter:

```dart
class CustomTextField implements TextInputClient {
  // Not having an AutofillScope does not prevent the input field
  // from being autofilled. However, only this input field is
  // autofilled when autofill is triggered on it.
  AutofillScope get currentAutofillScope => null;
}
```

Se o suporte a autofill de múltiplos campos for desejável, um
`AutofillScope` comum a ser usado é o widget `AutofillGroup`.
Para obter o widget `AutofillGroup` mais próximo do
input de texto, use `AutofillGroup.of(context)`:

```dart
class CustomTextFieldState extends State<CustomTextField> implements TextInputClient {
  AutofillScope get currentAutofillScope => AutofillGroup.of(context);
}
```

Para mais informações, consulte [`AutofillGroup`][].

## Linha do tempo

Disponibilizado na versão: 1.18.0<br>
Na versão estável: 1.20

## Referências

Documentação da API:

* [`AutofillGroup`][]
* [`TextInputClient.currentAutofillScope`][]

Issue relevante:

* [Issue 13015: Autofill support][]

PR relevante:

* [Framework PR that added autofill support][]


[Framework PR that added autofill support]: {{site.repo.flutter}}/pull/52126
[Issue 13015: Autofill support]: {{site.repo.flutter}}/issues/13015

[`AutofillGroup`]: {{site.api}}/flutter/widgets/AutofillGroup-class.html
[`TextInputClient.currentAutofillScope`]: {{site.api}}/flutter/services/TextInputClient/currentAutofillScope.html
