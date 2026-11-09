---
ia-translate: true
title: Gestos de trackpad podem acionar GestureRecognizer
description: >
  Gestos de trackpad na maioria das plataformas agora enviam sequências `PointerPanZoom` e
  podem acionar callbacks de `GestureRecognizer` de pan, drag e scale.
---

{% render "docs/breaking-changes.md" %}

## Resumo

Gestos de trackpad na maioria das plataformas agora enviam sequências `PointerPanZoom` e
podem acionar callbacks de `GestureRecognizer` de pan, drag e scale.

## Contexto

A rolagem no Flutter Desktop antes da versão 3.3.0 usava mensagens `PointerScrollEvent`
para representar deltas de rolagem discretos. Este sistema funcionava bem para rodas de
rolagem de mouse, mas não era uma boa solução para rolagem de trackpad. A rolagem de
trackpad é esperada para causar momentum, que depende não apenas dos deltas de rolagem,
mas também do momento em que os dedos são liberados do trackpad.
Além disso, o gesto de pinça para zoom do trackpad não podia ser representado.

Três novos `PointerEvent`s foram introduzidos: `PointerPanZoomStartEvent`,
`PointerPanZoomUpdateEvent` e `PointerPanZoomEndEvent`.
`GestureRecognizer`s relevantes foram atualizados para registrar interesse em
sequências de gestos de trackpad, e emitirão callbacks `onDrag`, `onPan` e/ou
`onScale` em resposta a movimentos de dois ou mais dedos no trackpad.

Isso significa que tanto o código projetado apenas para interações de toque pode ser
acionado em interação com trackpad, quanto o código projetado para lidar com toda a
rolagem de desktop pode agora ser acionado apenas na rolagem de mouse, e não na rolagem
de trackpad.

## Descrição da mudança

O Flutter engine foi atualizado em todas as plataformas possíveis para reconhecer
gestos de trackpad e enviá-los para o framework como eventos `PointerPanZoom`
ao invés de eventos `PointerScrollSignal`. Eventos `PointerScrollSignal` ainda
serão usados para representar rolagem em uma roda de mouse.

Dependendo da plataforma e modelo específico de trackpad, o novo sistema pode não
ser usado, se não houver dados suficientes fornecidos ao Flutter engine pelas APIs da
plataforma. Isso inclui no Windows, onde o suporte a gestos de trackpad depende do
driver do trackpad, e na plataforma Web, onde não há dados suficientes fornecidos pelas
APIs do navegador, e a rolagem de trackpad ainda deve usar o sistema antigo
`PointerScrollSignal`.

Desenvolvedores devem estar preparados para receber ambos os tipos de eventos e
garantir que seus apps ou pacotes os tratem da maneira apropriada.

`Listener` agora tem três novos callbacks: `onPointerPanZoomStart`,
`onPointerPanZoomUpdate` e `onPointerPanZoomEnd` que podem
ser usados para observar eventos de rolagem e zoom de trackpad.

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

`PointerPanZoomUpdateEvent` contém um campo `pan` para representar o pan cumulativo
do gesto atual, um campo `panDelta` para representar a diferença no pan desde o
último evento, um evento `scale` para representar o zoom cumulativo do gesto atual,
e um evento `rotation` para representar a rotação cumulativa (em radianos) do gesto
atual.

`GestureRecognizer`s agora têm métodos para todos os eventos de trackpad de um
gesto contínuo de trackpad. Chamar o método `addPointerPanZoom` em um
`GestureRecognizer` com um `PointerPanZoomStartEvent` fará com que o recognizer
registre seu interesse naquela interação de trackpad, e resolva conflitos
entre múltiplos `GestureRecognizer`s que potencialmente poderiam responder ao
gesto.

O exemplo a seguir mostra o uso adequado de `Listener` e `GestureRecognizer`
para responder a interações de trackpad.

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

Ao usar `GestureDetector`, isso é feito automaticamente, então código como o
exemplo a seguir emitirá seus callbacks de atualização de gesto em resposta tanto
a panning de toque quanto de trackpad.

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

Os passos de migração dependem de se você quer que cada interação de gesto em seu
app seja utilizável via trackpad, ou se deve ser restrito apenas a uso de toque
e mouse.

### Para interações de gesto adequadas para uso de trackpad

#### Usando `GestureDetector`

Nenhuma mudança é necessária, `GestureDetector` automaticamente processa eventos
de gesto de trackpad e aciona callbacks se reconhecidos.

#### Usando `GestureRecognizer` e `Listener`

Certifique-se de que `onPointerPanZoomStart` seja passado para
cada recognizer do `Listener`.
O método `addPointerPanZoom` de `GestureRecognizer` deve ser chamado
para que ele mostre interesse e comece a rastrear cada gesto de trackpad.

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

#### Usando `Listener` puro

O código a seguir usando PointerScrollSignal não será mais chamado em toda
rolagem de desktop. Eventos `PointerPanZoomUpdate` devem ser capturados para receber
dados de gesto de trackpad.

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

Observe: O uso de `Listener` puro dessa forma pode
causar conflitos com outras interações de gesto, pois não
participa da arena de desambiguação de gestos.

### Para interações de gesto não adequadas para uso de trackpad

#### Usando `GestureDetector`

Se estiver usando Flutter 3.3.0, `RawGestureDetector` pode ser usado
ao invés de `GestureDetector` para garantir que cada `GestureRecognizer` criado
pelo `GestureDetector` tenha `supportedDevices` configurado para
excluir `PointerDeviceKind.trackpad`.
A partir da versão 3.4.0, há um parâmetro `supportedDevices`
diretamente no `GestureDetector`.

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
// Example of code after the change.
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
              // Do not include PointerDeviceKind.trackpad
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

Código após a migração: (Flutter 3.4.0):

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
        // Do not include PointerDeviceKind.trackpad
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

Certifique-se explicitamente de que `supportedDevices`
não inclui `PointerDeviceKind.trackpad`.

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
// Example of code after the change.
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
              // Do not include PointerDeviceKind.trackpad
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

Após atualizar para o Flutter 3.3.0, não haverá mudança no comportamento, pois
`addPointerPanZoom` deve ser chamado em cada `GestureRecognizer` para permitir
que ele rastreie gestos. O código a seguir não receberá callbacks de gesto pan
quando o trackpad for rolado:

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
      // recognizer.addPointerPanZoom is not called
      child: Container()
    );
  }
}
```

## Cronograma

Lançado na versão: 3.3.0-0.0.pre<br>
No lançamento estável: 3.3.0

## Referências

Documentação da API:

* [`GestureDetector`][`GestureDetector`]
* [`RawGestureDetector`][`RawGestureDetector`]
* [`GestureRecognizer`][`GestureRecognizer`]

Documento de design:

* [Flutter Trackpad Gestures][Flutter Trackpad Gestures]

Issues relevantes:

* [Issue 23604][Issue 23604]

PRs relevantes:

* [Support trackpad gestures in framework][Support trackpad gestures in framework]
* [iPad trackpad gestures][iPad trackpad gestures]
* [Linux trackpad gestures][Linux trackpad gestures]
* [Mac trackpad gestures][Mac trackpad gestures]
* [Win32 trackpad gestures][Win32 trackpad gestures]
* [ChromeOS/Android trackpad gestures][ChromeOS/Android trackpad gestures]

[`GestureDetector`]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[`GestureRecognizer`]: {{site.api}}/flutter/gestures/GestureRecognizer-class.html
[`RawGestureDetector`]: {{site.api}}/flutter/widgets/RawGestureDetector-class.html
[Flutter Trackpad Gestures]: https://docs.google.com/document/d/1oRvebwjpsC3KlxN1gOYnEdxtNpQDYpPtUFAkmTUe-K8
[Issue 23604]: {{site.repo.flutter}}/issues/23604
[Support trackpad gestures in framework]: {{site.repo.flutter}}/pull/89944
[iPad trackpad gestures]: {{site.repo.engine}}/pull/31591
[Linux trackpad gestures]: {{site.repo.engine}}/pull/31592
[Mac trackpad gestures]: {{site.repo.engine}}/pull/31593
[Win32 trackpad gestures]: {{site.repo.engine}}/pull/31594
[ChromeOS/Android trackpad gestures]: {{site.repo.engine}}/pull/34060
