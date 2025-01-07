---
ia-translate: true
title: Introdução à UI declarativa
short-title: UI declarativa
description: Explica a diferença entre um estilo de programação declarativo e imperativo.
---

<?code-excerpt path-base="get-started/flutter-for/declarative"?>

_Esta introdução descreve a diferença conceitual entre o estilo
declarativo usado pelo Flutter e o estilo imperativo usado por muitas outras
estruturas de UI._

## Por que uma UI declarativa?

Frameworks do Win32 à web, Android e iOS geralmente usam um estilo imperativo
de programação de UI. Este pode ser o estilo com o qual você está mais
familiarizado — onde você constrói manualmente uma entidade de UI totalmente
funcional, como uma `UIView` ou equivalente, e posteriormente a altera usando
métodos e setters quando a UI muda.

Para aliviar o fardo dos desenvolvedores de ter que programar como fazer a
transição entre vários estados de UI, o Flutter, por outro lado, permite que o
desenvolvedor descreva o estado atual da UI e deixe a transição para a estrutura.

Isso, no entanto, requer uma ligeira mudança na forma de pensar sobre como
manipular a UI.

## Como alterar a UI em um framework declarativo

Considere o exemplo simplificado abaixo:

<img src="/assets/images/docs/declarativeUIchanges.png" alt="Visualização B (contida pela visualização A) se transforma de conter duas visualizações, c1 e c2, para conter apenas a visualização c3.">

No estilo imperativo, você normalmente iria ao proprietário de `ViewB` e
recuperaria a instância `b` usando seletores ou com `findViewById` ou similar,
e invocaria mutações nela (e implicitamente a invalidaria). Por exemplo:

```java
// Estilo imperativo
b.setColor(red)
b.clearChildren()
ViewC c3 = new ViewC(...)
b.add(c3)
```

Você também pode precisar replicar essa configuração no construtor de `ViewB`,
já que a fonte da verdade para a UI pode sobreviver à própria instância `b`.

No estilo declarativo, as configurações de visualização (como os Widgets do
Flutter) são imutáveis e são apenas "projetos" leves. Para alterar a UI, um
widget aciona uma reconstrução em si mesmo (mais comumente chamando
`setState()` em `StatefulWidgets` no Flutter) e constrói uma nova subárvore
de Widget.

<?code-excerpt "lib/main.dart (declarative)"?>
```dart
// Estilo declarativo
return ViewB(
  color: red,
  child: const ViewC(),
);
```

Aqui, em vez de alterar uma instância antiga `b` quando a UI muda, o Flutter
constrói novas instâncias de Widget. O framework gerencia muitas das
responsabilidades de um objeto de UI tradicional (como manter o estado do
layout) nos bastidores com RenderObjects. RenderObjects persistem entre
frames e os Widgets leves do Flutter dizem ao framework para alterar os
RenderObjects entre os estados. O framework Flutter cuida do resto.
