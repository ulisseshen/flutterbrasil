---
ia-translate: true
title: O `PrimaryScrollController` padrão no Desktop
description: >
  O `PrimaryScrollController` não se conectará mais a `ScrollView`s
  verticais automaticamente no Desktop.
---

## Resumo

A API `PrimaryScrollController` foi atualizada para não se conectar mais
automaticamente a `ScrollView`s verticais em plataformas desktop.

## Contexto

Antes desta mudança, `ScrollView.primary` teria como padrão `true` se uma
`ScrollView` tivesse uma direção de rolagem `Axis.vertical` e um
`ScrollController` já não tivesse sido fornecido. Isso permitia que padrões
de UI comuns, como a função de rolar para o topo no iOS, funcionassem
prontamente para aplicativos Flutter. No desktop, no entanto, esse padrão
geralmente causava o seguinte erro de asserção:

```plaintext
ScrollController attached to multiple ScrollViews.
```

Embora seja comum que um aplicativo móvel exiba um `ScrollView` por vez, os
padrões de UI de desktop são mais propensos a exibir vários `ScrollView`s
lado a lado. A implementação anterior do `PrimaryScrollController` entrava
em conflito com esse padrão, resultando em uma mensagem de erro muitas
vezes inútil. Para remediar isso, o `PrimaryScrollController` foi atualizado
com parâmetros adicionais, bem como melhores mensagens de erro em vários
widgets que dependem dele.

## Descrição da mudança

A implementação anterior de `ScrollView` resultava em `primary` sendo
`true` por padrão para todos os `ScrollView`s verticais que ainda não
tinham um `ScrollController`, em todas as plataformas. Esse comportamento
padrão nem sempre era claro, principalmente porque é separado do próprio
`PrimaryScrollController`.

```dart
// Anteriormente, esta ListView sempre resultaria em primary sendo true,
// e anexada ao PrimaryScrollController em todas as plataformas.
Scaffold(
  body: ListView.builder(
    itemBuilder: (BuildContext context, int index) {
      return Text('Item $index');
    }
  ),
);
```

A implementação muda `ScrollView.primary` para ser anulável, com a tomada
de decisão de fallback sendo realocada para o `PrimaryScrollController`.
Quando `primary` é nulo e nenhum `ScrollController` foi fornecido, o
`ScrollView` procurará o `PrimaryScrollController` e, em vez disso,
chamará `shouldInherit` para determinar se o determinado `ScrollView` deve
usar o `PrimaryScrollController`.

Os novos membros da classe `PrimaryScrollController`,
`automaticallyInheritForPlatforms` e `scrollDirection`, são avaliados em
`shouldInherit`, permitindo aos usuários clareza e controle sobre o
comportamento do `PrimaryScrollController`.

Por padrão, a compatibilidade com versões anteriores é mantida para
plataformas móveis. `PrimaryScrollController.shouldInherit` retorna `true`
para `ScrollView`s verticais. No desktop, isso retorna `false` por padrão.

```dart
// Somente em plataformas móveis isso se conectará ao PrimaryScrollController
// por padrão.
Scaffold(
  body: ListView.builder(
    itemBuilder: (BuildContext context, int index) {
      return Text('Item $index');
    }
  ),
);
```

Para alterar o padrão, os usuários podem definir `ScrollView.primary` como
`true` ou `false` para gerenciar explicitamente o
`PrimaryScrollController` para um `ScrollView` individual. Para
comportamento em vários `ScrollView`s, o `PrimaryScrollController` agora é
configurável definindo a plataforma específica, bem como a direção de
rolagem que é preferida para herança.

Widgets que usam o `PrimaryScrollController`, como `NestedScrollView`,
`Scrollbar` e `DropdownMenuButton`, não terão nenhuma mudança na
funcionalidade existente. Recursos como a rolagem para o topo do iOS também
continuarão a funcionar como esperado, sem qualquer migração.

`ScrollAction`s e `ScrollIntent`s no desktop são as únicas classes afetadas
por esta mudança, exigindo migração. Por padrão, o
`PrimaryScrollController` é usado para executar `Shortcuts` de rolagem de
teclado de fallback se o `Focus` atual estiver contido em um `Scrollable`.
Como exibir mais de um `ScrollView` lado a lado é comum em plataformas
desktop, não é possível para o Flutter decidir "Qual `ScrollView` deve ser
primário nesta visualização e receber a ação de rolagem do teclado?"

Se mais de um `ScrollView` estivesse presente antes desta mudança, a
mesma asserção (`ScrollController attached to multiple ScrollViews.`) seria
lançada. Agora, em plataformas desktop, os usuários precisam especificar
`primary: true` para designar qual `ScrollView` é o fallback para receber
`Shortcuts` de teclado não tratados.

## Guia de migração

Código antes da migração:

```dart
// Estes ListViews lado a lado lançariam erros de Scrollbars e
// ScrollActions anteriormente devido ao PrimaryScrollController.
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

Código após a migração:

```dart
// Estas ListViews lado a lado não lançarão mais erros, mas para
// ScrollActions padrão, um precisará ser designado como primário.
Scaffold(
  body: LayoutBuilder(
    builder: (context, constraints) {
      return Row(
        children: [
          SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth / 2,
            child: ListView.builder(
              // Este ScrollView usará o PrimaryScrollController
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

## Linha do tempo

Implementado na versão: 3.3.0-0.0.pre<br>
Na versão estável: 3.3

## Referências

Documentação da API:

* [`PrimaryScrollController`][]
* [`ScrollView`][]
* [`ScrollAction`][]
* [`ScrollIntent`][]
* [`Scrollbar`][]

Documento de design:

* [Updating PrimaryScrollController][]

Problemas relevantes:

* [Issue #100264][]

PRs relevantes:

* [Updating PrimaryScrollController for Desktop][]

[`PrimaryScrollController`]: {{site.api}}/flutter/widgets/PrimaryScrollController-class.html
[`ScrollView`]: {{site.api}}/flutter/widgets/ScrollView-class.html
[`ScrollAction`]: {{site.api}}/flutter/widgets/ScrollAction-class.html
[`ScrollIntent`]: {{site.api}}/flutter/widgets/ScrollIntent-class.html
[`Scrollbar`]: {{site.api}}/flutter/material/Scrollbar-class.html
[Updating PrimaryScrollController]: https://docs.google.com/document/d/12OQx7h8UQzzAi0Kxh-saDC2dg7h2fghCCzwJ0ysPmZE/edit?usp=sharing&resourcekey=0-ATO-1Er3HO2HITm59I0IdA
[Issue #100264]: {{site.repo.flutter}}/issues/100264
[Updating PrimaryScrollController for Desktop]: {{site.repo.flutter}}/pull/102099
