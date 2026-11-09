---
ia-translate: true
title: Semântica de botão do Material Chip
description: Chips Material interativos agora são semanticamente marcados como botões.
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

O Flutter agora aplica o rótulo semântico de `button` para
todos os [Material Chips][Material Chips] interativos para fins de acessibilidade.

## Contexto {:#context}

Chips Material interativos (especificamente [`ActionChip`][],
[`ChoiceChip`][], [`FilterChip`][], e [`InputChip`][])
agora são semanticamente marcados como sendo botões.
No entanto, o [`Chip`][] de informação não interativo não é.

Marcar Chips como botões ajuda ferramentas de acessibilidade,
mecanismos de busca e outros softwares de análise semântica
a entender o significado de um app. Por exemplo, permite
que leitores de tela (como TalkBack no Android
e VoiceOver no iOS) anunciem um Chip tocável
como um "button", o que pode auxiliar usuários na navegação
do seu app. Antes desta mudança, usuários de ferramentas de acessibilidade
podem ter tido uma experiência inferior,
a menos que você implementasse uma solução alternativa adicionando manualmente as
semânticas faltantes aos widgets Chip em seu app.

## Descrição da mudança {:#description-of-change}

O widget [`Semantics`][] mais externo que envolve todas as
classes Chip para descrever suas propriedades semânticas
é modificado.

As seguintes mudanças se aplicam a
[`ActionChip`][], [`ChoiceChip`][], [`FilterChip`][],
e [`InputChip`][]:

* A propriedade [`button`][`SemanticsProperties.button`]
  é definida como `true`.
* A propriedade [`enabled`][`SemanticsProperties.enabled`]
  reflete se o Chip está _atualmente_ tocável
  (tendo um callback definido).

Essas mudanças de propriedade alinham o comportamento semântico dos Chips interativos
com o de outros [Material Buttons][Material Buttons].

Para o [`Chip`][] de informação não interativo:

* A propriedade [`button`][`SemanticsProperties.button`]
  é definida como `false`.
* A propriedade [`enabled`][`SemanticsProperties.enabled`]
  é definida como `null`.

## Guia de migração {:#migration-guide}

**Você pode não precisar realizar nenhuma migração.**
Esta mudança só afeta você se você contornou
o problema de Material Chips faltando semânticas de `button` ao
envolver o widget fornecido ao campo `label` de um
`Chip` com um widget `Semantics` marcado como
`button: true`. **Neste caso, as semânticas internas e externas de `button`
entram em conflito, resultando na área tocável
do botão encolhendo para o tamanho do label
após esta mudança ser introduzida.** Corrija este problema
deletando esse widget `Semantics` e substituindo-o
por seu filho, ou removendo a propriedade `button: true`
se outras propriedades semânticas ainda
precisarem ser aplicadas ao widget `label` do Chip.

Os seguintes trechos usam [`InputChip`][] como exemplo,
mas o mesmo processo se aplica a [`ActionChip`][],
[`ChoiceChip`][], e [`FilterChip`][] também.

**Caso 1: Remova o widget `Semantics`.**

Código antes da migração:

```dart
Widget myInputChip = InputChip(
  onPressed: () {},
  label: Semantics(
    button: true,
    child: Text('My Input Chip'),
  ),
);
```

Código após a migração:

```dart
Widget myInputChip = InputChip(
  onPressed: () {},
  label: Text('My Input Chip'),
);
```

**Caso 2: Remova `button:true` do widget `Semantics`.**

Código antes da migração:

```dart
Widget myInputChip = InputChip(
  onPressed: () {},
  label: Semantics(
    button: true,
    hint: 'Example Hint',
    child: Text('My Input Chip'),
  ),
);
```

Código após a migração:

```dart
Widget myInputChip = InputChip(
  onPressed: () {},
  label: Semantics(
    hint: 'Example Hint',
    child: Text('My Input Chip'),
  ),
);
```

## Cronograma {:#timeline}

Disponibilizado na versão: 1.23.0-7.0.pre<br>
Na versão estável: 2.0.0

## Referências {:#references}

Documentação da API:

* [`ActionChip`][]
* [`Chip`][]
* [`ChoiceChip`][]
* [`FilterChip`][]
* [`InputChip`][]
* [Material Buttons][Material Buttons]
* [Material Chips][Material Chips]
* [`Semantics`][]
* [`SemanticsProperties.button`][]
* [`SemanticsProperties.enabled`][]

Issue relevante:

* [Issue 58010][Issue 58010]: InputChip doesn't announce any
  action for a11y on iOS

PRs relevantes:

* [PR 60141][PR 60141]: Tweaking Material Chip a11y semantics
  to match buttons
* [PR 60645][]: Revert "Tweaking Material Chip a11y
  semantics to match buttons" (#60141)
* [PR 61048][]: Re-land "Tweaking Material Chip a11y
  semantics to match buttons" (#60141)

[`ActionChip`]: {{site.material_ui}}/ActionChip-class.html
[`Chip`]: {{site.material_ui}}/Chip-class.html
[`ChoiceChip`]: {{site.material_ui}}/ChoiceChip-class.html
[`FilterChip`]: {{site.material_ui}}/FilterChip-class.html
[`InputChip`]: {{site.material_ui}}/InputChip-class.html
[Material Buttons]: {{site.material}}/components/all-buttons
[Material Chips]: {{site.material}}/components/chips
[`Semantics`]: {{site.api}}/flutter/widgets/Semantics-class.html
[`SemanticsProperties.button`]: {{site.api}}/flutter/semantics/SemanticsProperties/button.html
[`SemanticsProperties.enabled`]: {{site.api}}/flutter/semantics/SemanticsProperties/enabled.html

[Issue 58010]: {{site.repo.flutter}}/issues/58010

[PR 60141]: {{site.repo.flutter}}/pull/60141
[PR 60645]: {{site.repo.flutter}}/pull/60645
[PR 61048]: {{site.repo.flutter}}/pull/61048
