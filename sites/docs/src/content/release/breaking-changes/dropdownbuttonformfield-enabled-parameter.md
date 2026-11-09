---
ia-translate: true
title: Adicionado enabled ao DropdownButtonFormField e onChanged tornado opcional
description: >-
  DropdownButtonFormField em material_ui agora oferece suporte a um parâmetro
  enabled explícito, e o seu callback onChanged deixa de ser obrigatório.
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Em `package:material_ui`, `DropdownButtonFormField` agora inclui
um parâmetro `enabled` para controlar explicitamente o estado de interação,
e o callback `onChanged` não é mais marcado como `required`.
Essa mudança é retrocompatível, então o código existente continua funcionando.

:::note
A mudança está disponível apenas em `package:material_ui`.
O `DropdownButtonFormField` de `package:flutter/material.dart`
não tem um parâmetro `enabled`, e o seu `onChanged` continua sendo obrigatório.
:::

## Contexto {:#background}

Antes, `DropdownButtonFormField` não tinha um parâmetro `enabled`.
A única forma de desabilitar o dropdown
(deixando-o acinzentado e sem interação) era passar `null` para o
callback `onChanged`, que era `required`.
Isso resultava em código pouco intuitivo ao tentar
habilitar ou desabilitar o campo dinamicamente,
obrigando o desenvolvedor a escrever expressões condicionais no próprio callback,
como `onChanged: condition ? (value) { ... } : null`.

Para melhorar essa API, foi introduzido um parâmetro `enabled` dedicado,
e `onChanged` passou a ser opcional.

O parâmetro `enabled` é opcional e
determina o estado de interação do campo da seguinte forma:

* Se `enabled` for `true`, o campo é interativo,
  mesmo que `onChanged` seja `null`.
* Se `enabled` for `false`, o campo não é interativo,
  mesmo que `onChanged` seja informado.
* Se `enabled` não for informado, o campo é interativo somente se
  `onChanged` não for `null`, o que preserva a compatibilidade.

Em todos esses casos,
o campo não é interativo se `items` estiver vazio ou for `null`.

## Guia de migração {:#migration-guide}

:::tip
O parâmetro `enabled` está disponível apenas em `package:material_ui`.
Se o seu projeto ainda importa `package:flutter/material.dart`,
primeiro [migre para os packages independentes][migrate to the standalone packages].
:::

Se você desabilitava o seu `DropdownButtonFormField` passando `null`
condicionalmente para `onChanged`,
pode migrar para o novo parâmetro `enabled`.
Isso separa de forma limpa o estado do widget (habilitado/desabilitado) do
seu comportamento (o callback).

:::important
Ao contrário de `onChanged: null`, `enabled: false` desativa a autovalidação
própria do campo nos modos `always`, `onUserInteraction` e
`onUserInteractionIfError`.
`FormState.validate` e o `autovalidateMode` do `Form` pai
ainda validam o campo.
Se você depende de `AutovalidateMode.always` para exibir erros em um campo
desabilitado, continue usando `onChanged: null` e omita `enabled`.
:::

[migrate to the standalone packages]: /release/breaking-changes/material-ui-and-cupertino-ui

### Caso 1: dropdown desabilitado estaticamente {: #case-1-statically-disabled }

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

A prática recomendada é separar o callback do
estado de interação, usando diretamente o parâmetro `enabled`.
Remova a condição de `onChanged` ao adicionar `enabled`.
Se `enabled` for `true` e `onChanged` for `null`,
os usuários ainda podem alterar a seleção.
O campo armazena o valor selecionado no seu estado de formulário e
o callback `onChanged` do `Form` pai é executado,
mas o campo não tem um callback próprio para executar.

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

Incluído na versão de `package:material_ui`: 1.8.0<br>
Versão mínima do Flutter com suporte: 3.47

## Referências {:#references}

Documentação da API:

* [`DropdownButtonFormField`][]

Issues relevantes:

* [Por que o onChanged do DropdownButtonFormField é obrigatório?][issue-57953]

PRs relevantes:

* [Adiciona o parâmetro enabled ao DropdownButtonFormField][Add enabled parameter to DropdownButtonFormField]
* [Proposta original para o SDK][Original SDK proposal] (fechada sem merge)

[`DropdownButtonFormField`]: {{site.material_ui}}/DropdownButtonFormField-class.html
[issue-57953]: {{site.repo.flutter}}/issues/57953
[Add enabled parameter to DropdownButtonFormField]: {{site.repo.packages}}/pull/12610
[Original SDK proposal]: {{site.repo.flutter}}/pull/182419
