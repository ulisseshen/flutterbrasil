---
<<<<<<< pt
ia-translate: true
title: Propriedade enabled adicionada e onChanged opcional em DropdownButton
||||||| base_en
title: Added enabled property and made onChanged optional for DropdownButton
=======
title: Added enabled to DropdownButtonFormField and made onChanged optional
>>>>>>> new_en
description: >-
<<<<<<< pt
  DropdownButton e DropdownButtonFormField agora oferecem suporte a uma
  propriedade enabled explícita, e os callbacks onChanged deixam de ser obrigatórios.
||||||| base_en
  DropdownButton and DropdownButtonFormField now support an explicit enabled
  property, and their onChanged callbacks are no longer required.
=======
  DropdownButtonFormField in material_ui now supports an explicit enabled
  parameter, and its onChanged callback is no longer required.
>>>>>>> new_en
---

{% render "docs/breaking-changes.md" %}

<<<<<<< pt
## Resumo {:#summary}

`DropdownButton` e `DropdownButtonFormField` agora incluem
uma propriedade `enabled` para controlar explicitamente o estado de interação,
e o callback `onChanged` não é mais marcado como `required`.

## Contexto {:#background}

Antes, `DropdownButton` e `DropdownButtonFormField` não tinham
um parâmetro `enabled`.
A única forma de desabilitar o dropdown
(deixando-o acinzentado e sem interação) era passar `null` para o
callback `onChanged`, que era `required`.
Isso resultava em código pouco intuitivo ao tentar
habilitar ou desabilitar o botão dinamicamente,
obrigando o desenvolvedor a escrever expressões condicionais no próprio callback,
como `onChanged: condition ? (value) { ... } : null`.

Para melhorar essa API, foi introduzida uma propriedade `enabled` dedicada,
e `onChanged` passou a ser opcional.

A propriedade `enabled` é opcional.
Torná-la obrigatória causaria uma grande quebra de compatibilidade, que
afetaria quase todas as implementações existentes de `DropdownButton` no
ecossistema Flutter.
Por isso, para preservar a compatibilidade, se o argumento `enabled` não for
informado explicitamente, o botão determina o seu estado pela presença de
`onChanged` (ou seja, fica habilitado se `onChanged != null` e desabilitado
se `onChanged == null`).

A quebra de compatibilidade aqui é, em essência, estrutural:
embora o padrão antigo de `onChanged` condicional ainda funcione
graças à lógica de fallback, recomenda-se migrar para a API mais clara,
usando explicitamente a propriedade `enabled`.

## Guia de migração {:#migration-guide}

Se você desabilitava o seu `DropdownButton` passando `null` condicionalmente
para `onChanged`, migre para a nova propriedade `enabled`.
Isso separa de forma limpa o estado do widget (habilitado/desabilitado) do
seu comportamento (o callback).

Para migrar o seu código automaticamente nos casos simples
(como passar `null` de forma estática), execute o seguinte comando:

```console
$ dart fix --apply
```

||||||| base_en
## Summary

`DropdownButton` and `DropdownButtonFormField` now include
an `enabled` property to explicitly manage their interactive state,
and the `onChanged` callback is no longer marked as `required`.

## Background

Previously, `DropdownButton` and `DropdownButtonFormField` didn't
have an `enabled` parameter.
The only way to disable the dropdown
(graying it out and making it non-interactive) was to
pass `null` to the `required` `onChanged` callback.
This led to unintuitive code when trying to
dynamically enable or disable the button,
forcing developers to write conditional expressions for the callback itself,
such as `onChanged: condition ? (value) { ... } : null`.

To improve this API, a dedicated `enabled` property was introduced,
and `onChanged` was made optional.

The `enabled` property is optional.
Making it mandatory introduces a massive breaking change that
breaks nearly every existing `DropdownButton` implementation in
the Flutter ecosystem.
Instead, to preserve backward compatibility,
if the `enabled` argument isn't explicitly provided,
the button determines its state by falling back to whether
`onChanged` is provided (that is, it's enabled if `onChanged != null`,
and disabled if `onChanged == null`).

The minor breaking change here is structural:
while the old conditional `onChanged` pattern technically
still works due to the fallback logic,
developers are encouraged to migrate to the clearer API by
explicitly using the `enabled` property.

## Migration guide

If you previously disabled your `DropdownButton` by
conditionally passing `null` to `onChanged`,
migrate to the new `enabled` property.
This cleanly separates the state of the widget (enabled/disabled) from
its behavior (the callback).

To automatically migrate your code for simple cases
(such as statically passing `null`), run the following command:

```console
$ dart fix --apply
```

=======
## Summary

In `package:material_ui`, `DropdownButtonFormField` now includes
an `enabled` parameter to explicitly manage its interactive state,
and the `onChanged` callback is no longer marked as `required`.
This change is backward compatible, so existing code continues to work.

:::note
The change is only available in `package:material_ui`.
The `DropdownButtonFormField` in `package:flutter/material.dart`
doesn't have an `enabled` parameter, and its `onChanged` is still required.
:::

## Background

Previously, `DropdownButtonFormField` didn't have an `enabled` parameter.
The only way to disable the dropdown
(graying it out and making it non-interactive) was to
pass `null` to the `required` `onChanged` callback.
This led to unintuitive code when trying to
dynamically enable or disable the field,
forcing developers to write conditional expressions for the callback itself,
such as `onChanged: condition ? (value) { ... } : null`.

To improve this API, a dedicated `enabled` parameter was introduced,
and `onChanged` was made optional.

The `enabled` parameter is optional and
determines the field's interactive state as follows:

* If `enabled` is `true`, the field is interactive,
  even if `onChanged` is `null`.
* If `enabled` is `false`, the field isn't interactive,
  even if `onChanged` is provided.
* If `enabled` isn't provided, the field is interactive only if
  `onChanged` isn't `null`, which preserves backward compatibility.

In all of these cases,
the field isn't interactive if `items` is empty or `null`.

## Migration guide

:::tip
The `enabled` parameter is only available in `package:material_ui`.
If your project still imports `package:flutter/material.dart`,
first [migrate to the standalone packages][].
:::

If you previously disabled your `DropdownButtonFormField` by
conditionally passing `null` to `onChanged`,
you can migrate to the new `enabled` parameter.
This cleanly separates the state of the widget (enabled/disabled) from
its behavior (the callback).

>>>>>>> new_en
:::important
<<<<<<< pt
Observe que o `dart fix` não migra automaticamente os casos em que `onChanged`
é definido com lógica condicional. Nesses casos, você deve atualizar o código manualmente.
||||||| base_en
Note that `dart fix` will not automatically migrate cases where `onChanged`
is set using conditional logic. For those, you must update your code manually.
=======
Unlike `onChanged: null`, `enabled: false` turns off the field's own
`always`, `onUserInteraction`, and `onUserInteractionIfError` autovalidation.
`FormState.validate` and the parent `Form`'s `autovalidateMode`
still validate the field.
If you rely on `AutovalidateMode.always` to show errors on a disabled field,
keep using `onChanged: null` and omit `enabled`.
>>>>>>> new_en
:::

<<<<<<< pt
### Caso 1: dropdown desabilitado estaticamente {: #case-1-statically-disabled }
||||||| base_en
### Case 1: Statically disabled dropdown {: #case-1-statically-disabled }
=======
[migrate to the standalone packages]: /release/breaking-changes/material-ui-and-cupertino-ui

### Case 1: Statically disabled dropdown {: #case-1-statically-disabled }
>>>>>>> new_en

Para casos simples em que o dropdown fica permanentemente desabilitado,
agora você pode simplesmente omitir `onChanged` e usar `enabled: false`.

Código antes da migração:

```dart
final disabledDropdown = DropdownButtonFormField<String>(
  initialValue: 'Option 1',
  items: const [
    DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
  ],
  onChanged: null, // This was the only way to disable it.
);
```

Código após a migração:

```dart diff
  final disabledDropdown = DropdownButtonFormField<String>(
    initialValue: 'Option 1',
    items: const [
      DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
    ],
-   onChanged: null, // This was the only way to disable it.
+   enabled: false,
  );
```

### Caso 2: dropdown desabilitado condicionalmente {: #case-2-conditionally-disabled }

<<<<<<< pt
A prática recomendada é separar o callback do
estado de interação, usando diretamente a propriedade `enabled`.
||||||| base_en
The recommended best practice is to separate the callback from
the interactive state by using the `enabled` property directly.
=======
The recommended best practice is to separate the callback from
the interactive state by using the `enabled` parameter directly.
Remove the condition from `onChanged` when you add `enabled`.
If `enabled` is `true` and `onChanged` is `null`,
users can still change the selection.
The field stores the selected value in its form state and
the parent `Form`'s `onChanged` callback runs,
but the field has no callback of its own to run.
>>>>>>> new_en

Código antes da migração:

```dart
final conditionalDropdown = DropdownButtonFormField<String>(
  initialValue: 'Option 1',
  items: const [
    DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
  ],
  onChanged: condition ? (value) { ... } : null,
);
```

Código após a migração:

```dart diff
  final conditionalDropdown = DropdownButtonFormField<String>(
    initialValue: 'Option 1',
    items: const [
      DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
    ],
-   onChanged: condition ? (value) { ... } : null,
+   onChanged: (value) { ... },
+   enabled: condition,
  );
```

## Linha do tempo {:#timeline}

<<<<<<< pt
Incluído na versão: Ainda não<br>
Na versão estável: Ainda não
||||||| base_en
Landed in version: Not yet<br>
In stable release: Not yet
=======
Landed in `package:material_ui` version: 1.8.0<br>
Minimum supported Flutter version: 3.47
>>>>>>> new_en

## Referências {:#references}

Documentação da API:

<<<<<<< pt
* [`DropdownButton`][`DropdownButton`]
* [`DropdownButtonFormField`][`DropdownButtonFormField`]
||||||| base_en
* [`DropdownButton`][]
* [`DropdownButtonFormField`][]
=======
* [`DropdownButtonFormField`][]
>>>>>>> new_en

Issues relevantes:

* [Por que o onChanged do DropdownButtonFormField é obrigatório?][issue-57953]

PRs relevantes:

<<<<<<< pt
* [Atualiza a lógica da propriedade enabled do DropdownButton][Update DropdownButton enabled property logic]
||||||| base_en
* [Update DropdownButton enabled property logic][]
=======
* [Add enabled parameter to DropdownButtonFormField][]
* [Original SDK proposal][] (closed without merging)
>>>>>>> new_en

[`DropdownButtonFormField`]: {{site.material_ui}}/DropdownButtonFormField-class.html
[issue-57953]: {{site.repo.flutter}}/issues/57953
[Add enabled parameter to DropdownButtonFormField]: {{site.repo.packages}}/pull/12610
[Original SDK proposal]: {{site.repo.flutter}}/pull/182419
