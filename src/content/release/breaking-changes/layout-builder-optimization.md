---
ia-translate: true
title: Otimização do LayoutBuilder
description: >
  LayoutBuilder e SliverLayoutBuilder chamam a função builder menos vezes.
---

{% render "docs/breaking-changes.md" %}

## Resumo

Este guia explica como migrar aplicações Flutter após
[a otimização do LayoutBuilder][1].

## Contexto

[LayoutBuilder][2] e [SliverLayoutBuilder][3] chamam
a função [builder][4] mais vezes do que o necessário para
cumprir seu objetivo principal de permitir que os apps adaptem sua
estrutura de widgets às restrições de layout do pai.
Isso levou a aplicações menos eficientes e com mais travamentos
porque widgets são reconstruídos desnecessariamente.

Isso afeta transitivamente [OrientationBuilder][5] também.

Para melhorar o desempenho dos apps,
a [otimização do LayoutBuilder][1] foi feita,
resultando em menos chamadas à função `builder`.

Apps que dependem desta função ser chamada com uma certa frequência podem quebrar.
O app pode exibir alguma combinação dos seguintes sintomas:

* A função `builder` não é chamada quando seria antes da atualização para a
  versão do Flutter que introduziu a otimização.
* A UI de um widget está faltando.
* A UI de um widget não está atualizando.

## Descrição da mudança

Antes da otimização, a função builder passada para `LayoutBuilder` ou
`SliverLayoutBuilder` era chamada quando qualquer uma das seguintes situações acontecia:

1. `LayoutBuilder` é reconstruído devido a uma mudança de configuração do widget
   (isso tipicamente acontece quando o widget que usa `LayoutBuilder` reconstrói
   devido a `setState`, `didUpdateWidget` ou `didChangeDependencies`).
1. `LayoutBuilder` é layoutado e recebe restrições de layout de seu pai
   que são _diferentes_ das restrições recebidas pela última vez.
1. `LayoutBuilder` é layoutado e recebe restrições de layout de seu pai
   que são as _mesmas_ das restrições recebidas da última vez.

Após a otimização, a função builder não é mais chamada neste último
caso. Se as restrições são as mesmas e a configuração do widget não
mudou, a função builder não é chamada.

Seu app pode quebrar se depender do relayout para causar a reconstrução do
`LayoutBuilder` ao invés de uma chamada explícita a `setState`. Isso geralmente
acontece por acidente. Você pretendia adicionar `setState`, mas esqueceu porque o app
continuou funcionando como você queria, e portanto nada o lembrou de adicionar.

## Guia de migração

Procure por usos de `LayoutBuilder` e `SliverLayoutBuilder` e certifique-se de
chamar `setState` sempre que o estado do widget mudar.

**Exemplo**: no exemplo abaixo, o conteúdo da função builder depende
do valor do campo `_counter`. Portanto, sempre que o valor for atualizado,
você deve chamar `setState` para dizer ao framework para reconstruir o widget. Porém,
este exemplo pode ter funcionado anteriormente mesmo sem chamar `setState`, se o
`_ResizingBox` disparar um relayout do `LayoutBuilder`.

Código antes da migração (note o `setState` faltando dentro do callback `onPressed`):

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Counter(),
    );
  }
}

class Counter extends StatefulWidget {
  Counter({Key key}) : super(key: key);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Center(child: Container(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return _ResizingBox(
            TextButton(
                onPressed: () {
                  _counter++;
                },
                child: Text('Increment Counter')),
            Text(_counter.toString()),
          );
        },
      ),
    ));
  }
}

class _ResizingBox extends StatefulWidget {
  _ResizingBox(this.child1, this.child2);

  final Widget child1;
  final Widget child2;

  @override
  State<StatefulWidget> createState() => _ResizingBoxState();
}

class _ResizingBoxState extends State<_ResizingBox>
    with SingleTickerProviderStateMixin {
  Animation animation;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 1),
    )
      ..forward()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 100 + animation.value * 100,
          child: widget.child1,
        ),
        SizedBox(
          width: 100 + animation.value * 100,
          child: widget.child2,
        ),
      ],
    );
  }
}
```

Código após a migração (`setState` adicionado ao `onPressed`):

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Counter(),
    );
  }
}

class Counter extends StatefulWidget {
  Counter({Key key}) : super(key: key);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Center(child: Container(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return _ResizingBox(
            TextButton(
                onPressed: () {
                  setState(() {
                    _counter++;
                  });
                },
                child: Text('Increment Counter')),
            Text(_counter.toString()),
          );
        },
      ),
    ));
  }
}

class _ResizingBox extends StatefulWidget {
  _ResizingBox(this.child1, this.child2);

  final Widget child1;
  final Widget child2;

  @override
  State<StatefulWidget> createState() => _ResizingBoxState();
}

class _ResizingBoxState extends State<_ResizingBox>
    with SingleTickerProviderStateMixin {
  Animation animation;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 1),
    )
      ..forward()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 100 + animation.value * 100,
          child: widget.child1,
        ),
        SizedBox(
          width: 100 + animation.value * 100,
          child: widget.child2,
        ),
      ],
    );
  }
}
```

Fique atento para usos de `Animation` e `LayoutBuilder` no mesmo widget.
Animations têm estado mutável interno que muda a cada frame. Se a
lógica da sua função builder depende do valor da animation, pode
ser necessário um `setState` para atualizar em conjunto com a animation. Para fazer isso, adicione um
[listener de animation][7] que chama `setState`, assim:

```dart
Animation animation = … create animation …;
animation.addListener(() {
  setState(() {
    // Intencionalmente vazio. O estado está dentro do objeto animation.
  });
});
```

## Linha do tempo

Esta mudança foi lançada no Flutter v1.20.0.

## Referências

Documentação da API:

* [`LayoutBuilder`][2]
* [`SliverLayoutBuilder`][3]

Issue relevante:

* [Issue 6469][8]

PR relevante:

* [LayoutBuilder: skip calling builder when constraints are the same][6]

[1]: /go/layout-builder-optimization
[2]: {{site.api}}/flutter/widgets/LayoutBuilder-class.html
[3]: {{site.api}}/flutter/widgets/SliverLayoutBuilder-class.html
[4]: {{site.api}}/flutter/widgets/LayoutBuilder/builder.html
[5]: {{site.api}}/flutter/widgets/OrientationBuilder-class.html
[6]: {{site.repo.flutter}}/pull/55414
[7]: {{site.api}}/flutter/animation/Animation/addListener.html
[8]: {{site.repo.flutter}}/issues/6469
