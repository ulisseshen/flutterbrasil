---
ia-translate: true
title: Semântica do botão Material Chip
description: Material Chips interativos agora são marcados semanticamente como botões.
---

## Resumo

O Flutter agora aplica o rótulo semântico de `button` a
todos os [Material Chips][] interativos para fins de
acessibilidade.

## Contexto

Material Chips interativos (a saber, [`ActionChip`][],
[`ChoiceChip`][], [`FilterChip`][] e [`InputChip`][])
agora são marcados semanticamente como botões.
No entanto, o [`Chip`][] de informação não interativo não é.

Marcar Chips como botões ajuda ferramentas de acessibilidade,
mecanismos de busca e outros softwares de análise semântica a
entender o significado de um aplicativo. Por exemplo, isso
permite que leitores de tela (como o TalkBack no Android
e o VoiceOver no iOS) anunciem um Chip clicável
como um "botão", o que pode auxiliar os usuários na navegação
em seu aplicativo. Antes dessa mudança, usuários de
ferramentas de acessibilidade podem ter tido uma experiência
abaixo do ideal, a menos que você implementasse uma solução
alternativa adicionando manualmente a semântica ausente
aos widgets Chip em seu aplicativo.

## Descrição da mudança

O widget [`Semantics`][] mais externo que envolve todas as
classes Chip para descrever suas propriedades semânticas
foi modificado.

As seguintes mudanças se aplicam a
[`ActionChip`][], [`ChoiceChip`][], [`FilterChip`][] e
[`InputChip`][]:

* A propriedade [`button`][`SemanticsProperties.button`]
  é definida como `true`.
* A propriedade [`enabled`][`SemanticsProperties.enabled`]
  reflete se o Chip é _atualmente_ clicável
  (por ter um callback definido).

Essas mudanças de propriedade alinham o comportamento
semântico de Chips interativos com o de outros
[Material Buttons][].

Para o [`Chip`][] de informação não interativo:

* A propriedade [`button`][`SemanticsProperties.button`]
  é definida como `false`.
* A propriedade [`enabled`][`SemanticsProperties.enabled`]
  é definida como `null`.

## Guia de migração

**Você pode não precisar realizar nenhuma migração.**
Essa mudança afeta você apenas se você contornou
o problema de Material Chips faltando a semântica de `button`
envolvendo o widget fornecido ao campo `label` de um
`Chip` com um widget `Semantics` marcado como
`button: true`. **Nesse caso, a semântica `button` interna
e externa entram em conflito, resultando na área clicável
do botão diminuindo para o tamanho do rótulo
após essa mudança ser introduzida.** Corrija esse problema
excluindo esse widget `Semantics` e substituindo-o
por seu filho, ou removendo a propriedade `button: true`
se outras propriedades semânticas ainda
precisarem ser aplicadas ao widget `label` do Chip.

Os seguintes trechos usam [`InputChip`][] como um exemplo,
mas o mesmo processo se aplica a [`ActionChip`][],
[`ChoiceChip`][] e [`FilterChip`][] também.

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

## Linha do tempo

Implementado na versão: 1.23.0-7.0.pre<br>
Na versão estável: 2.0.0

## Referências

Documentação da API:

* [`ActionChip`][]
* [`Chip`][]
* [`ChoiceChip`][]
* [`FilterChip`][]
* [`InputChip`][]
* [Material Buttons][]
* [Material Chips][]
* [`Semantics`][]
* [`SemanticsProperties.button`][]
* [`SemanticsProperties.enabled`][]

Issue relevante:

* [Issue 58010][]: InputChip não anuncia nenhuma
  ação para a11y no iOS

PRs relevantes:

* [PR 60141][]: Ajustando a semântica a11y do Material Chip
  para corresponder a botões
* [PR 60645][]: Reverter "Ajustando a semântica a11y do
  Material Chip para corresponder a botões (#60141)
* [PR 61048][]: Re-implementar "Ajustando a semântica
  a11y do Material Chip para corresponder a botões
  (#60141)

[`ActionChip`]: {{site.api}}/flutter/material/ActionChip-class.html
[`Chip`]: {{site.api}}/flutter/material/Chip-class.html
[`ChoiceChip`]: {{site.api}}/flutter/material/ChoiceChip-class.html
[`FilterChip`]: {{site.api}}/flutter/material/FilterChip-class.html
[`InputChip`]: {{site.api}}/flutter/material/InputChip-class.html
[Material Buttons]: {{site.material}}/components/all-buttons
[Material Chips]: {{site.material}}/components/chips
[`Semantics`]: {{site.api}}/flutter/widgets/Semantics-class.html
[`SemanticsProperties.button`]: {{site.api}}/flutter/semantics/SemanticsProperties/button.html
[`SemanticsProperties.enabled`]: {{site.api}}/flutter/semantics/SemanticsProperties/enabled.html

[Issue 58010]: {{site.repo.flutter}}/issues/58010

[PR 60141]: {{site.repo.flutter}}/pull/60141
[PR 60645]: {{site.repo.flutter}}/pull/60645
[PR 61048]: {{site.repo.flutter}}/pull/61048
