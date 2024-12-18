---
ia-translate: true
title: Adicionando a propriedade TextInputClient.currentAutofillScope
description: >
  Um novo getter TextInputClient.currentAutofillScope foi
  adicionado à interface TextInputClient para suporte a preenchimento automático.
---

## Sumário

Um novo getter, `TextInputClient.currentAutofillScope`, foi adicionado à
interface `TextInputClient`; todas as subclasses de `TextInputClient` devem
fornecer uma implementação concreta de `currentAutofillScope`.

Este getter permite que o `TextInputClient` acione um preenchimento
automático que envolva vários campos de entrada logicamente conectados.
Por exemplo, um campo "nome de usuário" pode acionar um preenchimento
automático que preenche tanto ele quanto o campo "senha" associado a ele.

## Contexto

Em muitas plataformas, os serviços de preenchimento automático são capazes de
preencher automaticamente vários campos de entrada em uma única tentativa.
Por exemplo, campos de nome de usuário e campos de senha geralmente podem
ser preenchidos automaticamente de uma vez. Por esta razão, um campo de
entrada do Flutter que está prestes a acionar o preenchimento automático
também deve fornecer à plataforma informações sobre outros campos de
entrada que podem ser preenchidos automaticamente e que estão logicamente
conectados a ele. `TextInputClient.currentAutofillScope` define o grupo de
campos de entrada que estão logicamente conectados a este `TextInputClient` e
que podem ser preenchidos automaticamente em conjunto.

## Descrição da mudança

`TextInputClient` agora tem um getter adicional que retorna o `AutofillScope`
ao qual este cliente pertence. Este getter é usado pelo cliente de entrada
para coletar informações relacionadas ao preenchimento automático de outros
campos de entrada que podem ser preenchidos automaticamente dentro do mesmo
escopo.

```dart
abstract class TextInputClient {
  AutofillScope get currentAutofillScope;
}
```

Se você vir a mensagem de erro "missing concrete implementation of
'getter TextInputClient.currentAutofillScope'" ao compilar um aplicativo
Flutter, siga os passos de migração listados abaixo.

## Guia de migração

Se você não está planejando adicionar suporte a preenchimento automático de
múltiplos campos para sua subclasse `TextInputClient`, simplesmente retorne
`null` no getter:

```dart
class CustomTextField implements TextInputClient {
  // Não ter um AutofillScope não impede que o campo de entrada
  // seja preenchido automaticamente. No entanto, apenas este campo
  // de entrada é preenchido automaticamente quando o preenchimento
  // automático é acionado nele.
  AutofillScope get currentAutofillScope => null;
}
```

Se o suporte a preenchimento automático de múltiplos campos for desejável, um
`AutofillScope` comum a ser usado é o widget `AutofillGroup`. Para obter o
widget `AutofillGroup` mais próximo da entrada de texto, use
`AutofillGroup.of(context)`:

```dart
class CustomTextFieldState extends State<CustomTextField> implements TextInputClient {
  AutofillScope get currentAutofillScope => AutofillGroup.of(context);
}
```

Para mais informações, consulte [`AutofillGroup`][].

## Linha do tempo

Incluído na versão: 1.18.0<br>
Na versão estável: 1.20

## Referências

Documentação da API:

* [`AutofillGroup`][]
* [`TextInputClient.currentAutofillScope`][]

Issue relevante:

* [Issue 13015: Autofill support][]

PR relevante:

* [PR do Framework que adicionou suporte a preenchimento automático][]

[PR do Framework que adicionou suporte a preenchimento automático]: {{site.repo.flutter}}/pull/52126
[Issue 13015: Autofill support]: {{site.repo.flutter}}/issues/13015

[`AutofillGroup`]: {{site.api}}/flutter/widgets/AutofillGroup-class.html
[`TextInputClient.currentAutofillScope`]: {{site.api}}/flutter/services/TextInputClient/currentAutofillScope.html
