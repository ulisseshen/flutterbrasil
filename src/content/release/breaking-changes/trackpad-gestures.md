---
ia-translate: true
title: Gestos do Trackpad podem Acionar o GestureRecognizer
description: >
  Gestos do trackpad na maioria das plataformas agora enviam sequências `PointerPanZoom` e
  podem acionar callbacks `GestureRecognizer` de pan, arrastar e escalar.
---

## Resumo

Gestos do trackpad na maioria das plataformas agora enviam sequências `PointerPanZoom` e
podem acionar callbacks `GestureRecognizer` de pan, arrastar e escalar.

## Contexto

A rolagem no Flutter Desktop anterior à versão 3.3.0 usava mensagens `PointerScrollEvent`
para representar deltas de rolagem discretos. Este sistema funcionava bem para rodas de
rolagem do mouse, mas não era uma boa opção para rolagem do trackpad. Espera-se que a
rolagem do trackpad cause momentum, que depende não apenas dos deltas de rolagem, mas também
do tempo em que os dedos são liberados do trackpad. Além disso, o movimento de pinça
para zoom do trackpad não podia ser representado.

Três novos `PointerEvent`s foram introduzidos: `PointerPanZoomStartEvent`,
`PointerPanZoomUpdateEvent` e `PointerPanZoomEndEvent`. Os `GestureRecognizer`s
relevantes foram atualizados para registrar o interesse em sequências de gestos do
trackpad e emitirão callbacks `onDrag`, `onPan` e/ou `onScale` em resposta a
movimentos de dois ou mais dedos no trackpad.

Isso significa que tanto o código projetado apenas para interações por toque pode ser
acionado na interação com o trackpad, quanto o código projetado para lidar com toda a rolagem
na área de trabalho pode agora ser acionado apenas na rolagem do mouse, e não na rolagem
do trackpad.

## Descrição da alteração

O motor do Flutter foi atualizado em todas as plataformas possíveis para reconhecer gestos
do trackpad e enviá-los para o framework como eventos `PointerPanZoom`, em vez de como
eventos `PointerScrollSignal`. Os eventos `PointerScrollSignal` ainda serão usados
para representar a rolagem em uma roda de mouse.

Dependendo da plataforma e do modelo específico do trackpad, o novo sistema pode não ser
usado, se não forem fornecidos dados suficientes para o motor do Flutter pelas APIs da
plataforma. Isso inclui no Windows, onde o suporte a gestos do trackpad depende do driver
do trackpad, e na plataforma Web, onde não são fornecidos dados suficientes pelas APIs do
navegador, e a rolagem do trackpad ainda deve usar o antigo sistema `PointerScrollSignal`.

Os desenvolvedores devem estar preparados para receber ambos os tipos de eventos e garantir
que seus aplicativos ou pacotes os tratem da maneira apropriada.

O `Listener` agora tem três novos callbacks: `onPointerPanZoomStart`,
`onPointerPanZoomUpdate` e `onPointerPanZoomEnd` que podem ser usados para
observar eventos de rolagem e zoom do trackpad.

```dart
void main() => runApp(Foo());

class Foo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (PointerSignalEvent event) {
        if (event is PointerScrollEvent) {
          debugPrint('mouse scrolled ${event.scrollDelta}');
        }
      },
      onPointerPanZoomStart: (PointerPanZoomStartEvent event) {
        debugPrint('trackpad scroll started');
      },
      onPointerPanZoomUpdate: (PointerPanZoomUpdateEvent event) {
        debugPrint('trackpad scrolled ${event.panDelta}');
      },
      onPointerPanZoomEnd: (PointerPanZoomEndEvent event) {
        debugPrint('trackpad scroll ended');
      },
      child: Container()
    );
  }
}
```

`PointerPanZoomUpdateEvent` contém um campo `pan` para representar o pan cumulativo do
gesto atual, um campo `panDelta` para representar a diferença no pan desde o último
evento, um evento `scale` para representar o zoom cumulativo do gesto atual e um evento
`rotation` para representar a rotação cumulativa (em radianos) do gesto atual.

`GestureRecognizer`s agora têm métodos para todos os eventos do trackpad de um gesto
contínuo do trackpad. Chamar o método `addPointerPanZoom` em um `GestureRecognizer`
com um `PointerPanZoomStartEvent` fará com que o reconhecedor registre seu interesse
nessa interação com o trackpad e resolva conflitos entre vários `GestureRecognizer`s
que poderiam potencialmente responder ao gesto.

O exemplo a seguir mostra o uso adequado de `Listener` e `GestureRecognizer` para
responder a interações do trackpad.

```dart
void main() => runApp(Foo());

class Foo extends StatefulWidget {
  late final PanGestureRecognizer recognizer;

  @override
  void initState() {
    super.initState();
    recognizer = PanGestureRecognizer()
    ..onStart = _onPanStart
    ..onUpdate = _onPanUpdate
    ..onEnd = _onPanEnd;
  }

  void _onPanStart(DragStartDetails details) {
    debugPrint('onStart');
  }

  void _onPanUpdate(DragUpdateDetails details) {
    debugPrint('onUpdate');
  }

  void _onPanEnd(DragEndDetails details) {
    debugPrint('onEnd');
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: recognizer.addPointer,
      onPointerPanZoomStart: recognizer.addPointerPanZoom,
      child: Container()
    );
  }
}
```

Ao usar `GestureDetector`, isso é feito automaticamente, de modo que um código como o
exemplo a seguir emitirá seus callbacks de atualização de gesto em resposta a movimentos
de toque e pan do trackpad.

```dart
void main() => runApp(Foo());

class Foo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        debugPrint('onStart');
      },
      onPanUpdate: (details) {
        debugPrint('onUpdate');
      },
      onPanEnd: (details) {
        debugPrint('onEnd');
      }
      child: Container()
    );
  }
}
```

## Guia de migração

As etapas de migração dependem se você deseja que cada interação de gesto em seu aplicativo
seja utilizável por meio de um trackpad ou se ela deve ser restrita apenas ao uso de toque
e mouse.

### Para interações de gestos adequadas para uso no trackpad

#### Usando `GestureDetector`

Nenhuma alteração é necessária, `GestureDetector` processa automaticamente eventos de
gesto do trackpad e aciona callbacks se reconhecido.

#### Usando `GestureRecognizer` e `Listener`

Certifique-se de que `onPointerPanZoomStart` seja passado para cada reconhecedor do
`Listener`. O método `addPointerPanZoom` de `GestureRecognizer` deve ser chamado
para que ele mostre interesse e comece a rastrear cada gesto do trackpad.

Código antes da migração:

```dart
void main() => runApp(Foo());

class Foo extends StatefulWidget {
  late final PanGestureRecognizer recognizer;

  @override
  void initState() {
    super.initState();
    recognizer = PanGestureRecognizer()
    ..onStart = _onPanStart
    ..onUpdate = _onPanUpdate
    ..onEnd = _onPanEnd;
  }

  void _onPanStart(DragStartDetails details) {
    debugPrint('onStart');
  }

  void _onPanUpdate(DragUpdateDetails details) {
    debugPrint('onUpdate');
  }

  void _onPanEnd(DragEndDetails details) {
    debugPrint('onEnd');
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: recognizer.addPointer,
      child: Container()
    );
  }
}
```

Código após a migração:

```dart
void main() => runApp(Foo());

class Foo extends StatefulWidget {
  late final PanGestureRecognizer recognizer;

  @override
  void initState() {
    super.initState();
    recognizer = PanGestureRecognizer()
    ..onStart = _onPanStart
    ..onUpdate = _onPanUpdate
    ..onEnd = _onPanEnd;
  }

  void _onPanStart(DragStartDetails details) {
    debugPrint('onStart');
  }

  void _onPanUpdate(DragUpdateDetails details) {
    debugPrint('onUpdate');
  }

  void _onPanEnd(DragEndDetails details) {
    debugPrint('onEnd');
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: recognizer.addPointer,
      onPointerPanZoomStart: recognizer.addPointerPanZoom,
      child: Container()
    );
  }
}
```

#### Usando `Listener` bruto

O código a seguir usando PointerScrollSignal não será mais chamado em toda a rolagem da
área de trabalho. Os eventos `PointerPanZoomUpdate` devem ser capturados para receber
dados de gestos do trackpad.

Código antes da migração:

```dart
void main() => runApp(Foo());

class Foo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (PointerSignalEvent event) {
        if (event is PointerScrollEvent) {
          debugPrint('scroll wheel event');
        }
      }
      child: Container()
    );
  }
}
```

Código após a migração:

```dart
void main() => runApp(Foo());

class Foo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (PointerSignalEvent event) {
        if (event is PointerScrollEvent) {
          debugPrint('scroll wheel event');
        }
      },
      onPointerPanZoomUpdate: (PointerPanZoomUpdateEvent event) {
        debugPrint('trackpad scroll event');
      }
      child: Container()
    );
  }
}
```

Observação: o uso de `Listener` bruto desta forma pode causar conflitos com outras
interações de gestos, pois não participa da arena de desambiguação de gestos.

### Para interações de gestos não adequadas para uso no trackpad

#### Usando `GestureDetector`

Se estiver usando o Flutter 3.3.0, `RawGestureDetector` pode ser usado em vez de
`GestureDetector` para garantir que cada `GestureRecognizer` criado pelo
`GestureDetector` tenha `supportedDevices` definido para excluir
`PointerDeviceKind.trackpad`. A partir da versão 3.4.0, existe um parâmetro
`supportedDevices` diretamente em `GestureDetector`.

Código antes da migração:

```dart
void main() => runApp(Foo());

class Foo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        debugPrint('onStart');
      },
      onPanUpdate: (details) {
        debugPrint('onUpdate');
      },
      onPanEnd: (details) {
        debugPrint('onEnd');
      }
      child: Container()
    );
  }
}
```

Código após a migração (Flutter 3.3.0):

```dart
// Exemplo de código após a alteração.
void main() => runApp(Foo());

class Foo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        PanGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
          () => PanGestureRecognizer(
            supportedDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.stylus,
              PointerDeviceKind.invertedStylus,
              // Não inclua PointerDeviceKind.trackpad
            }
          ),
          (recognizer) {
            recognizer
              ..onStart = (details) {
                debugPrint('onStart');
              }
              ..onUpdate = (details) {
                debugPrint('onUpdate');
              }
              ..onEnd = (details) {
                debugPrint('onEnd');
              };
          },
        ),
      },
      child: Container()
    );
  }
}
```

Código após a migração (Flutter 3.4.0):

```dart
void main() => runApp(Foo());

class Foo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      supportedDevices: {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
        // Não inclua PointerDeviceKind.trackpad
      },
      onPanStart: (details) {
        debugPrint('onStart');
      },
      onPanUpdate: (details) {
        debugPrint('onUpdate');
      },
      onPanEnd: (details) {
        debugPrint('onEnd');
      }
      child: Container()
    );
  }
}
```

#### Usando `RawGestureRecognizer`

Certifique-se explicitamente de que `supportedDevices` não inclua
`PointerDeviceKind.trackpad`.

Código antes da migração:

```dart
void main() => runApp(Foo());

class Foo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        PanGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
          () => PanGestureRecognizer(),
          (recognizer) {
            recognizer
              ..onStart = (details) {
                debugPrint('onStart');
              }
              ..onUpdate = (details) {
                debugPrint('onUpdate');
              }
              ..onEnd = (details) {
                debugPrint('onEnd');
              };
          },
        ),
      },
      child: Container()
    );
  }
}
```

Código após a migração:

```dart
// Exemplo de código após a alteração.
void main() => runApp(Foo());

class Foo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        PanGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
          () => PanGestureRecognizer(
            supportedDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.stylus,
              PointerDeviceKind.invertedStylus,
              // Não inclua PointerDeviceKind.trackpad
            }
          ),
          (recognizer) {
            recognizer
              ..onStart = (details) {
                debugPrint('onStart');
              }
              ..onUpdate = (details) {
                debugPrint('onUpdate');
              }
              ..onEnd = (details) {
                debugPrint('onEnd');
              };
          },
        ),
      },
      child: Container()
    );
  }
}
```

#### Usando `GestureRecognizer` e `Listener`

Após a atualização para o Flutter 3.3.0, não haverá alteração no comportamento, pois
`addPointerPanZoom` deve ser chamado em cada `GestureRecognizer` para permitir que ele
rastreie os gestos. O código a seguir não receberá callbacks de gestos de pan quando o
trackpad for rolado:

```dart
void main() => runApp(Foo());

class Foo extends StatefulWidget {
  late final PanGestureRecognizer recognizer;

  @override
  void initState() {
    super.initState();
    recognizer = PanGestureRecognizer()
    ..onStart = _onPanStart
    ..onUpdate = _onPanUpdate
    ..onEnd = _onPanEnd;
  }

  void _onPanStart(DragStartDetails details) {
    debugPrint('onStart');
  }

  void _onPanUpdate(DragUpdateDetails details) {
    debugPrint('onUpdate');
  }

  void _onPanEnd(DragEndDetails details) {
    debugPrint('onEnd');
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: recognizer.addPointer,
      // recognizer.addPointerPanZoom não é chamado
      child: Container()
    );
  }
}
```

## Linha do tempo

Implementado na versão: 3.3.0-0.0.pre<br>
Em lançamento estável: 3.3.0

## Referências

Documentação da API:

* [`GestureDetector`][]
* [`RawGestureDetector`][]
* [`GestureRecognizer`][]

Documento de design:

* [Gestos do Trackpad Flutter][]

Problemas relevantes:

* [Issue 23604][]

PRs relevantes:

* [Suporte a gestos de trackpad no framework][]
* [Gestos de trackpad do iPad][]
* [Gestos de trackpad do Linux][]
* [Gestos de trackpad do Mac][]
* [Gestos de trackpad Win32][]
* [Gestos de trackpad ChromeOS/Android][]

[`GestureDetector`]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[`GestureRecognizer`]: {{site.api}}/flutter/gestures/GestureRecognizer-class.html
[`RawGestureDetector`]: {{site.api}}/flutter/widgets/RawGestureDetector-class.html
[Gestos do Trackpad Flutter]: https://docs.google.com/document/d/1oRvebwjpsC3KlxN1gOYnEdxtNpQDYpPtUFAkmTUe-K8
[Issue 23604]: {{site.repo.flutter}}/issues/23604
[Suporte a gestos de trackpad no framework]: {{site.repo.flutter}}/pull/89944
[Gestos de trackpad do iPad]: {{site.repo.engine}}/pull/31591
[Gestos de trackpad do Linux]: {{site.repo.engine}}/pull/31592
[Gestos de trackpad do Mac]: {{site.repo.engine}}/pull/31593
[Gestos de trackpad Win32]: {{site.repo.engine}}/pull/31594
[Gestos de trackpad ChromeOS/Android]: {{site.repo.engine}}/pull/34060
