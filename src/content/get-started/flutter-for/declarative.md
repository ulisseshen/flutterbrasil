---
ia-translate: true
title: Introdução à UI declarativa
short-title: UI declarativa
description: Explica a diferença entre um estilo de programação declarativo e imperativo.
---

<?code-excerpt path-base="get-started/flutter-for/declarative"?>

_Esta introdução descreve a diferença conceitual entre o
estilo declarativo usado pelo Flutter, e o estilo imperativo usado por
muitos outros frameworks de UI._

## Por que uma UI declarativa?

Frameworks do Win32 à web, ao Android e iOS normalmente usam um estilo
imperativo de programação de UI. Este pode ser o estilo com o qual você está mais familiarizado&mdash;onde você constrói manualmente uma entidade UI totalmente funcional,
como um UIView ou equivalente, e posteriormente a modifica usando métodos e
setters quando a UI muda.

Para aliviar o fardo dos desenvolvedores de ter que programar como fazer a
transição entre vários estados de UI, o Flutter, em contraste,
permite que o desenvolvedor descreva o estado atual da UI e deixa a
transição para o framework.

Isso, no entanto, requer uma pequena mudança no pensamento de como manipular a UI.

## Como mudar a UI em um framework declarativo

Considere um exemplo simplificado abaixo:

<img src="/assets/images/docs/declarativeUIchanges.png" alt="View B (contained by view A) morphs from containing two views, c1 and c2, to containing only view c3.">

No estilo imperativo, você normalmente iria ao proprietário de ViewB
e recuperaria a instância `b` usando seletores ou com `findViewById` ou similar,
e invocaria mutações nela (e implicitamente a invalidaria). Por exemplo:

```java
// Imperative style
b.setColor(red)
b.clearChildren()
ViewC c3 = new ViewC(...)
b.add(c3)
```

Você também pode precisar replicar essa configuração no construtor de
ViewB, já que a fonte de verdade para a UI pode sobreviver à própria instância `b`.

No estilo declarativo, as configurações de view (como os Widgets do Flutter)
são imutáveis e são apenas "blueprints" leves. Para mudar a UI,
um widget dispara uma reconstrução em si mesmo (mais comumente chamando `setState()`
em StatefulWidgets no Flutter) e constrói uma nova subárvore de Widget.

<?code-excerpt "lib/main.dart (declarative)"?>
```dart
// Declarative style
return ViewB(
  color: red,
  child: const ViewC(),
);
```

Aqui, em vez de modificar uma instância antiga `b` quando a UI muda,
o Flutter constrói novas instâncias de Widget. O framework gerencia muitas das
responsabilidades de um objeto UI tradicional (como manter o
estado do layout) nos bastidores com RenderObjects.
RenderObjects persistem entre frames e os Widgets leves do Flutter
dizem ao framework para modificar os RenderObjects entre estados.
O framework Flutter cuida do resto.

