---
ia-translate: true
title: Otimização de Reconstrução para OverlayEntries e Rotas
description: OverlayEntries só são reconstruídos em mudanças de estado explícitas.
---

## Resumo

Esta otimização melhora o desempenho para transições de rota,
mas pode revelar chamadas faltantes para `setState` em seu app.

## Contexto

Antes desta mudança, um `OverlayEntry` era reconstruído quando
uma nova entrada opaca era adicionada em cima dele ou removida acima dele.
Essas reconstruções eram desnecessárias porque não eram acionadas
por uma mudança no estado do `OverlayEntry` afetado. Esta
mudança quebra a compatibilidade otimizou como lidamos com a adição e remoção de
`OverlayEntry`s, e remove reconstruções desnecessárias
para melhorar o desempenho.

Como o `Navigator` internamente coloca cada `Route` em um
`OverlayEntry`, essa mudança também se aplica às transições de `Route`:
Se uma `Route` opaca é empurrada em cima ou removida de cima de outra
`Route`, as `Route`s abaixo da `Route` opaca
não são mais reconstruídas desnecessariamente.

## Descrição da mudança

Na maioria dos casos, esta mudança não requer nenhuma alteração no seu código.
No entanto, se seu aplicativo estava erroneamente contando com as
reconstruções implícitas, você pode ver problemas, que podem ser resolvidos envolvendo
qualquer mudança de estado em uma chamada `setState`.

Além disso, essa mudança modificou ligeiramente a forma da
árvore de widgets: Antes dessa mudança,
os `OverlayEntry`s eram envolvidos em um widget `Stack`.
O widget `Stack` explícito foi removido da hierarquia de widgets.

## Guia de migração

Se você estiver vendo problemas após atualizar para uma versão do Flutter
que incluiu essa mudança, revise seu código em busca de chamadas faltantes para
`setState`. No exemplo abaixo, atribuir o valor de retorno de
`Navigator.pushNamed` a `buttonLabel` é
modificar implicitamente o estado e deve ser envolvido em uma
chamada `setState` explícita.

Código antes da migração:

```dart
class FooState extends State<Foo> {
  String buttonLabel = 'Click Me';
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Modificação de estado ilegal que deve ser envolvida em setState.
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

## Linha do tempo

Implementado na versão: 1.16.3<br>
Em lançamento estável: 1.17

## Referências

Documentação da API:

* [`setState`][]
* [`OverlayEntry`][]
* [`Overlay`][]
* [`Navigator`][]
* [`Route`][]
* [`OverlayRoute`][]

Issues relevantes:

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
