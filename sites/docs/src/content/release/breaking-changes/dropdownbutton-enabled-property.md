---
ia-translate: true
title: Propriedade enabled adicionada e onChanged opcional em DropdownButton
description: >-
  DropdownButton e DropdownButtonFormField agora oferecem suporte a uma
  propriedade enabled explícita, e os callbacks onChanged deixam de ser obrigatórios.
---

{% render "docs/breaking-changes.md" %}

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

:::important
Observe que o `dart fix` não migra automaticamente os casos em que `onChanged`
é definido com lógica condicional. Nesses casos, você deve atualizar o código manualmente.
:::

### Caso 1: dropdown desabilitado estaticamente {: #case-1-statically-disabled }

Para casos simples em que o dropdown fica permanentemente desabilitado,
agora você pode simplesmente omitir `onChanged` e usar `enabled: false`.

Código antes da migração:

```dart
final disabledDropdown = DropdownButton<String>(
  value: 'Option 1',
  items: const [
    DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
  ],
  onChanged: null, // This was the only way to disable it.
);
```

Código após a migração:

```dart diff
  final disabledDropdown = DropdownButton<String>(
    value: 'Option 1',
    items: const [
      DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
    ],
-   onChanged: null, // This was the only way to disable it.
+   enabled: false,
  );
```

### Caso 2: dropdown desabilitado condicionalmente {: #case-2-conditionally-disabled }

A prática recomendada é separar o callback do
estado de interação, usando diretamente a propriedade `enabled`.

Código antes da migração:

```dart
final conditionalDropdown = DropdownButton<String>(
  value: 'Option 1',
  items: const [
    DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
  ],
  onChanged: condition ? (value) { ... } : null,
);
```

Código após a migração:

```dart diff
  final conditionalDropdown = DropdownButton<String>(
    value: 'Option 1',
    items: const [
      DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
    ],
-   onChanged: condition ? (value) { ... } : null,
+   onChanged: (value) { ... },
+   enabled: condition,
  );
```

## Linha do tempo {:#timeline}

Incluído na versão: Ainda não<br>
Na versão estável: Ainda não

## Referências {:#references}

Documentação da API:

* [`DropdownButton`][`DropdownButton`]
* [`DropdownButtonFormField`][`DropdownButtonFormField`]

Issues relevantes:

* [Por que o onChanged do DropdownButtonFormField é obrigatório?][issue-57953]

PRs relevantes:

* [Atualiza a lógica da propriedade enabled do DropdownButton][Update DropdownButton enabled property logic]

[`DropdownButton`]: {{site.material_ui}}/DropdownButton-class.html
[`DropdownButtonFormField`]: {{site.material_ui}}/DropdownButtonFormField-class.html
[issue-57953]: {{site.repo.flutter}}/issues/57953
[Update DropdownButton enabled property logic]: {{site.repo.flutter}}/pull/182419
