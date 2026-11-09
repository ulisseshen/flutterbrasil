---
title: Otimização de rebuilds para OverlayEntries e Routes
description: OverlayEntries são reconstruídos apenas em mudanças explícitas de estado.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Esta otimização melhora o desempenho das transições de rota,
mas pode revelar chamadas de `setState` que estão faltando no seu app.

## Contexto {:#context}

Antes desta mudança, um `OverlayEntry` era reconstruído quando
uma nova entrada opaca era adicionada sobre ele ou removida acima dele.
Essas reconstruções eram desnecessárias, pois não eram causadas
por uma mudança de estado do `OverlayEntry` afetado. Esta
mudança que quebra compatibilidade otimizou como tratamos a adição e a remoção de
`OverlayEntry`s, eliminando reconstruções desnecessárias
para melhorar o desempenho.

Como o `Navigator` coloca internamente cada `Route` em um
`OverlayEntry`, esta mudança também se aplica às transições de `Route`:
se uma `Route` opaca é empilhada sobre outra `Route` ou removida de cima dela,
as `Route`s abaixo da `Route` opaca
não são mais reconstruídas desnecessariamente.

## Descrição da mudança {:#description-of-change}

Na maioria dos casos, esta mudança não exige nenhuma alteração no seu código.
No entanto, se o seu app dependia de forma incorreta das
reconstruções implícitas, você pode ver problemas, que podem ser resolvidos
envolvendo qualquer mudança de estado em uma chamada de `setState`.

Além disso, esta mudança alterou um pouco a forma da
árvore de widgets: antes dela,
os `OverlayEntry`s eram envolvidos por um widget `Stack`.
O `Stack` explícito foi removido da hierarquia de widgets.

## Guia de migração {:#migration-guide}

Se você está vendo problemas após atualizar para uma versão do Flutter
que incluiu esta mudança, audite seu código em busca de chamadas de
`setState` ausentes. No exemplo abaixo, atribuir o valor de retorno de
`Navigator.pushNamed` a `buttonLabel` modifica o estado
implicitamente, e essa atribuição deveria estar envolvida em uma chamada explícita
de `setState`.

Código antes da migração:

```dart
class FooState extends State<Foo> {
  String buttonLabel = 'Click Me';
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Illegal state modification that should be wrapped in setState.
        buttonLabel = await Navigator.pushNamed(context, '/bar');
      },
      child: Text(buttonLabel),
    );
  }
}
```

Código após a migração:

```dart
class FooState extends State<Foo> {
  String buttonLabel = 'Click Me';
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final newLabel = await Navigator.pushNamed(context, '/bar');
        setState(() {
          buttonLabel = newLabel;
        });
      },
      child: Text(buttonLabel),
    );
  }
}
```

## Linha do tempo {:#timeline}

Incluído na versão: 1.16.3<br>
Na versão estável: 1.17

## Referências {:#references}

Documentação da API:

* [`setState`][]
* [`OverlayEntry`][]
* [`Overlay`][]
* [`Navigator`][]
* [`Route`][]
* [`OverlayRoute`][]

Issue relevante:

* [Issue 45797][]

PRs relevantes:

* [Do not rebuild Routes when a new opaque Route is pushed on top][]
* [Reland "Do not rebuild Routes when a new opaque Route is pushed on top"][]


[Do not rebuild Routes when a new opaque Route is pushed on top]: {{site.repo.flutter}}/pull/48900
[Issue 45797]: {{site.repo.flutter}}/issues/45797
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`Overlay`]: {{site.api}}/flutter/widgets/Overlay-class.html
[`OverlayEntry`]: {{site.api}}/flutter/widgets/OverlayEntry-class.html
[`OverlayRoute`]: {{site.api}}/flutter/widgets/OverlayRoute-class.html
[`Route`]: {{site.api}}/flutter/widgets/Route-class.html
[`setState`]: {{site.api}}/flutter/widgets/State/setState.html
[Reland "Do not rebuild Routes when a new opaque Route is pushed on top"]: {{site.repo.flutter}}/pull/49376
