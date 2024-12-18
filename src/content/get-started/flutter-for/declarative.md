---
title: Introdução à UI Declarativa
short-title: UI Declarativa
description: Explica a diferença entre um estilo de programação declarativo e imperativo.
ia-translate: true
---

<?code-excerpt path-base="get-started/flutter-for/declarative"?>

_Esta introdução descreve a diferença conceitual entre o estilo
declarativo usado pelo Flutter e o estilo imperativo usado por muitas
outras frameworks de UI._

## Por que uma UI declarativa?

Frameworks de Win32 até web, Android e iOS, tipicamente usam um estilo
imperativo de programação de UI. Este pode ser o estilo com o qual você
está mais familiarizado — onde você constrói manualmente uma entidade de UI
totalmente funcional, como um `UIView` ou equivalente, e posteriormente a
modifica usando métodos e setters quando a UI muda.

Para aliviar o fardo dos desenvolvedores de ter que programar como fazer a
transição entre vários estados da UI, o Flutter, por outro lado, permite
que o desenvolvedor descreva o estado atual da UI e deixa a transição para
o framework.

Isso, no entanto, requer uma pequena mudança na maneira de pensar sobre como manipular a UI.

## Como alterar a UI em uma framework declarativa

Considere o exemplo simplificado abaixo:

<img src="/assets/images/docs/declarativeUIchanges.png" alt="View B (contida pela view A) se transforma de conter duas views, c1 e c2, para conter apenas a view c3.">

No estilo imperativo, você normalmente iria ao proprietário da `ViewB` e
recuperaria a instância `b` usando seletores ou com `findViewById` ou similar,
e invocaria modificações nela (e a invalidaria implicitamente). Por exemplo:

```java
// Estilo imperativo
b.setColor(red)
b.clearChildren()
ViewC c3 = new ViewC(...)
b.add(c3)
```

Você também pode precisar replicar essa configuração no construtor de
`ViewB`, já que a fonte da verdade para a UI pode sobreviver à própria instância `b`.

No estilo declarativo, as configurações de view (como os Widgets do
Flutter) são imutáveis e são apenas "projetos" leves. Para alterar a UI, um
widget aciona uma reconstrução em si mesmo (mais comumente chamando
`setState()` em `StatefulWidgets` no Flutter) e constrói uma nova subárvore
de `Widget`.

<?code-excerpt "lib/main.dart (declarative)"?>
```dart
// Estilo declarativo
return ViewB(
  color: red,
  child: const ViewC(),
);
```

Aqui, em vez de modificar uma instância antiga `b` quando a UI muda, o
Flutter constrói novas instâncias de `Widget`. O framework gerencia muitas
das responsabilidades de um objeto de UI tradicional (como manter o estado
do layout) nos bastidores com RenderObjects. RenderObjects persistem entre
frames e os Widgets leves do Flutter dizem ao framework para modificar os
RenderObjects entre os estados. O framework Flutter cuida do resto.
