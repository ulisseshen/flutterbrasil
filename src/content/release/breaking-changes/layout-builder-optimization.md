---
ia-translate: true
title: Otimização do LayoutBuilder
description: >
  LayoutBuilder e SliverLayoutBuilder chamam a função builder com menos frequência.
---

## Resumo

Este guia explica como migrar aplicativos Flutter após
[a otimização do LayoutBuilder][1].

## Contexto

[LayoutBuilder][2] e [SliverLayoutBuilder][3] chamam
a função [builder][4] mais vezes do que o necessário para
cumprir seu objetivo principal de permitir que os aplicativos adaptem sua
estrutura de widget às restrições de layout pai.
Isso levou a aplicativos menos eficientes e mais instáveis
porque os widgets são reconstruídos desnecessariamente.

Isso afeta transitivamente o [OrientationBuilder][5] também.

Para melhorar o desempenho do aplicativo,
a [otimização do LayoutBuilder][1] foi feita,
o que resulta em chamar a função `builder` com menos frequência.

Aplicativos que dependem dessa função para ser chamada com uma certa frequência
podem quebrar.
O aplicativo pode apresentar alguma combinação dos seguintes sintomas:

* A função `builder` não é chamada quando seria antes da atualização para a
  versão do Flutter que introduziu a otimização.
* A UI de um widget está faltando.
* A UI de um widget não está sendo atualizada.

## Descrição da mudança

Antes da otimização, a função builder passada para `LayoutBuilder` ou
`SliverLayoutBuilder` era chamada quando qualquer um dos seguintes acontecia:

1.  `LayoutBuilder` é reconstruído devido a uma mudança na configuração do widget
    (isso normalmente acontece quando o widget que usa `LayoutBuilder` é reconstruído
    devido a `setState`, `didUpdateWidget` ou `didChangeDependencies`).
2.  `LayoutBuilder` é disposto e recebe restrições de layout de seu pai
    que são _diferentes_ das últimas restrições recebidas.
3.  `LayoutBuilder` é disposto e recebe restrições de layout de seu pai
    que são _iguais_ às restrições recebidas da última vez.

Após a otimização, a função builder não é mais chamada no último caso.
Se as restrições forem as mesmas e a configuração do widget não mudar,
a função builder não é chamada.

Seu aplicativo pode quebrar se ele depender do relayout para causar a
reconstrução do `LayoutBuilder` em vez de uma chamada explícita para `setState`.
Isso geralmente acontece por acidente. Você pretendia adicionar `setState`, mas
esqueceu porque o aplicativo continuou funcionando como você queria e, portanto,
nada o lembrou de adicioná-lo.

## Guia de migração

Procure por usos de `LayoutBuilder` e `SliverLayoutBuilder` e certifique-se de
chamar `setState` sempre que o estado do widget mudar.

**Exemplo**: no exemplo abaixo, o conteúdo da função builder depende
do valor do campo `_counter`. Portanto, sempre que o valor for atualizado,
você deve chamar `setState` para informar ao framework para reconstruir o
widget. No entanto, este exemplo pode ter funcionado anteriormente mesmo sem
chamar `setState`, se o `_ResizingBox` acionar um relayout de `LayoutBuilder`.

Código antes da migração (observe a falta de `setState` dentro do
callback `onPressed`):

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
  Counter({Key? key}) : super(key: key);

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
  Animation? animation;

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
          width: 100 + animation!.value * 100,
          child: widget.child1,
        ),
        SizedBox(
          width: 100 + animation!.value * 100,
          child: widget.child2,
        ),
      ],
    );
  }
}
```

Código após a migração (`setState` adicionado a `onPressed`):

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
  Counter({Key? key}) : super(key: key);

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
  Animation? animation;

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
          width: 100 + animation!.value * 100,
          child: widget.child1,
        ),
        SizedBox(
          width: 100 + animation!.value * 100,
          child: widget.child2,
        ),
      ],
    );
  }
}
```

Observe o uso de `Animation` e `LayoutBuilder` no mesmo widget.
Animações têm um estado mutável interno que muda a cada frame. Se a
lógica da sua função builder depender do valor da animação, pode ser
necessário um `setState` para atualizar em conjunto com a animação. Para
fazer isso, adicione um [listener de animação][7] que chama `setState`, assim:

```dart
Animation animation = … criar animação …;
animation.addListener(() {
  setState(() {
    // Intencionalmente vazio. O estado está dentro do objeto de animação.
  });
});
```

## Cronograma

Essa mudança foi lançada no Flutter v1.20.0.

## Referências

Documentação da API:

* [`LayoutBuilder`][2]
* [`SliverLayoutBuilder`][3]

Problema relevante:

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
