---
title: '`PrimaryScrollController` padrão no Desktop'
description: >
  O `PrimaryScrollController` não será mais anexado automaticamente a
  `ScrollView`s verticais no Desktop.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

A API `PrimaryScrollController` foi atualizada para não se anexar mais
automaticamente a `ScrollView`s verticais em plataformas desktop.

## Contexto {:#background}

Antes desta mudança, `ScrollView.primary` era true por padrão se uma
`ScrollView` tivesse uma direção de rolagem `Axis.vertical` e um
`ScrollController` não tivesse sido fornecido. Isso permitia padrões comuns de
UI, como a função de rolar para o topo no iOS, funcionarem sem configuração
nos apps Flutter. No desktop, porém, esse padrão frequentemente causava o
seguinte erro de asserção:

```plaintext
ScrollController attached to multiple ScrollViews.
```

Embora seja comum um app mobile exibir uma `ScrollView` por vez, os padrões de
UI no desktop costumam exibir várias `ScrollView`s lado a lado. A implementação
anterior do `PrimaryScrollController` conflitava com esse padrão, resultando em
uma mensagem de erro muitas vezes pouco útil. Para resolver isso, o
`PrimaryScrollController` recebeu parâmetros adicionais, além de mensagens de
erro melhores em vários widgets que dependem dele.

## Descrição da mudança {:#change-description}

A implementação anterior de `ScrollView` fazia com que `primary` fosse true por
padrão em todas as `ScrollView`s verticais que não tinham um
`ScrollController`, em todas as plataformas. Esse comportamento padrão nem
sempre era claro, principalmente porque era separado do próprio
`PrimaryScrollController`.

```dart
// Previously, this ListView would always result in primary being true,
// and attached to the PrimaryScrollController on all platforms.
Scaffold(
  body: ListView.builder(
    itemBuilder: (BuildContext context, int index) {
      return Text('Item $index');
    }
  ),
);
```

A implementação altera `ScrollView.primary` para ser anulável, e a decisão do
valor padrão passa a ser feita pelo `PrimaryScrollController`. Quando `primary`
é nulo e nenhum `ScrollController` foi fornecido, a `ScrollView` consulta o
`PrimaryScrollController` e chama `shouldInherit` para determinar se ela deve
usar o `PrimaryScrollController`.

Os novos membros da classe `PrimaryScrollController`,
`automaticallyInheritForPlatforms` e `scrollDirection`, são avaliados em
`shouldInherit`, o que dá aos usuários clareza e controle sobre o
comportamento do `PrimaryScrollController`.

Por padrão, a compatibilidade com versões anteriores é mantida para plataformas
mobile. `PrimaryScrollController.shouldInherit` retorna true para
`ScrollView`s verticais. No desktop, isso retorna false por padrão.

```dart
// Only on mobile platforms will this attach to the PrimaryScrollController by
// default.
Scaffold(
  body: ListView.builder(
    itemBuilder: (BuildContext context, int index) {
      return Text('Item $index');
    }
  ),
);
```

Para alterar o padrão, os usuários podem definir `ScrollView.primary` como true
ou false para gerenciar explicitamente o `PrimaryScrollController` de uma
`ScrollView` específica. Para o comportamento entre várias `ScrollView`s, o
`PrimaryScrollController` agora é configurável definindo a plataforma específica,
bem como a direção de rolagem preferida para herança.

Widgets que usam o `PrimaryScrollController`, como `NestedScrollView`,
`Scrollbar` e `DropdownMenuButton`, não sofrem nenhuma alteração na
funcionalidade existente. Recursos como o rolar para o topo no iOS também
continuam funcionando como esperado, sem nenhuma migração.

`ScrollAction`s e `ScrollIntent`s no desktop são as únicas classes afetadas
por esta mudança, e exigem migração. Por padrão, o `PrimaryScrollController` é
usado para executar `Shortcuts` de rolagem pelo teclado como fallback, se o
`Focus` atual estiver contido em um `Scrollable`. Como exibir mais de uma
`ScrollView` lado a lado é comum em plataformas desktop, não é possível para o
Flutter decidir "Qual `ScrollView` deve ser a primária nesta view e receber a
ação de rolagem do teclado?"

Se mais de uma `ScrollView` estivesse presente antes desta mudança, a mesma
asserção (`ScrollController attached to multiple ScrollViews.`) seria lançada.
Agora, nas plataformas desktop, os usuários precisam especificar
`primary: true` para designar qual `ScrollView` é o fallback que vai receber
os `Shortcuts` de teclado não tratados.

## Guia de migração {:#migration-guide}

Código antes da migração:

```dart
// These side-by-side ListViews would throw errors from Scrollbars and
// ScrollActions previously due to the PrimaryScrollController.
Scaffold(
  body: LayoutBuilder(
    builder: (context, constraints) {
      return Row(
        children: [
          SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth / 2,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Text('List 1 - Item $index');
              }
            ),
          ),
          SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth / 2,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Text('List 2 - Item $index');
              }
            ),
          ),
        ]
      );
    },
  ),
);
```

Código depois da migração:

```dart
// These side-by-side ListViews will no longer throw errors, but for
// default ScrollActions, one will need to be designated as primary.
Scaffold(
  body: LayoutBuilder(
    builder: (context, constraints) {
      return Row(
        children: [
          SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth / 2,
            child: ListView.builder(
              // This ScrollView will use the PrimaryScrollController
              primary: true,
              itemBuilder: (BuildContext context, int index) {
                return Text('List 1 - Item $index');
              }
            ),
          ),
          SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth / 2,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Text('List 2 - Item $index');
              }
            ),
          ),
        ]
      );
    },
  ),
);
```

## Linha do tempo {:#timeline}

Incluído na versão: 3.3.0-0.0.pre<br>
Na versão estável: 3.3

## Referências {:#references}

Documentação da API:

* [`PrimaryScrollController`][]
* [`ScrollView`][]
* [`ScrollAction`][]
* [`ScrollIntent`][]
* [`Scrollbar`][]

Documento de design:

* [Updating PrimaryScrollController][]

Issues relevantes:

* [Issue #100264][]

PRs relevantes:

* [Updating PrimaryScrollController for Desktop][]

[`PrimaryScrollController`]: {{site.api}}/flutter/widgets/PrimaryScrollController-class.html
[`ScrollView`]: {{site.api}}/flutter/widgets/ScrollView-class.html
[`ScrollAction`]: {{site.api}}/flutter/widgets/ScrollAction-class.html
[`ScrollIntent`]: {{site.api}}/flutter/widgets/ScrollIntent-class.html
[`Scrollbar`]: {{site.material_ui}}/Scrollbar-class.html
[Updating PrimaryScrollController]: https://docs.google.com/document/d/12OQx7h8UQzzAi0Kxh-saDC2dg7h2fghCCzwJ0ysPmZE/edit?usp=sharing&resourcekey=0-ATO-1Er3HO2HITm59I0IdA
[Issue #100264]: {{site.repo.flutter}}/issues/100264
[Updating PrimaryScrollController for Desktop]: {{site.repo.flutter}}/pull/102099
