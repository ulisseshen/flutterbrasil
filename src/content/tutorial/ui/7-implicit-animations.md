---
ia-translate: true
title: Animações simples
description: Aprenda a maneira mais simples de implementar animações no Flutter.
permalink: /tutorial/animations/
sitemap: false
---

Flutter fornece um rico conjunto de APIs de animação, e a maneira mais simples de
começar a usá-las é com **animações implícitas**. "Animações
implícitas" refere-se a um grupo de widgets que automaticamente animam
mudanças em suas propriedades sem que você precise gerenciar nenhum
comportamento.

Nesta lição, você aprenderá sobre um dos widgets de animação implícita mais comuns e
versáteis: [`AnimatedContainer`][]. Com
apenas duas linhas adicionais de código, a cor de fundo de cada `Tile`
anima para uma nova cor em cerca de meio segundo.

## Converta `Container` para `AnimatedContainer`

Atualmente, o método `Tile.build` retorna um `Container` para exibir
uma letra. Quando o `hitType` muda, como de `HitType.none`
para `HitType.hit`, a cor de fundo do tile muda
instantaneamente (de branco para verde, neste exemplo).

Aqui está o código atual do widget `Tile` para referência:

```dart
class Tile extends StatelessWidget {
  const Tile(required this.letter, required hitType, {super.key});

  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: switch (type) {
          HitType.hit => Colors.green,
          HitType.partial => Colors.yellow,
          HitType.miss => Colors.grey,
          _ => Colors.white,
        },
      ),
      child: Center(
        child: Text(
          letter.char.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
```

Para fazer a mudança de cor animar suavemente, substitua o widget `Container`
por um `AnimatedContainer`.

Um `AnimatedContainer` é como um `Container`, mas automaticamente
anima mudanças em suas propriedades ao longo de uma `duration` especificada. Quando
propriedades como `color`, `height`, `width`, `decoration` ou
`alignment` mudam, `AnimatedContainer` interpola entre os valores antigos
e novos, criando uma transição suave.

Modifique seu widget `Tile` da seguinte forma:

```dart
class Tile extends StatelessWidget {
  const Tile(required this.letter, required hitType, {super.key});

  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: switch (hitType) {
          HitType.hit => Colors.green,
          HitType.partial => Colors.yellow,
          HitType.miss => Colors.grey,
          _ => Colors.white,
        },
      ),
      child: Center(
        child: Text(
          letter.char.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
```

**`duration`** é uma propriedade obrigatória que especifica quanto tempo a
animação deve levar. Neste exemplo, `Duration(milliseconds: 500)`
significa que a transição de cor levará meio segundo. Você também pode
especificar segundos, minutos e muitas outras unidades de tempo.

Agora, quando o `hitType` muda e o widget `Tile` reconstrói
(porque `setState` foi chamado em `GamePage`), a cor do tile
animará suavemente de sua cor antiga para a nova ao longo da
duração especificada.

## Ajuste a curva

Você pode adicionar um pouco de customização a uma animação implícita passando
uma [`Curve`][]. Diferentes curvas mudarão a velocidade da animação
em diferentes pontos ao longo da animação.

{%- comment %} TODO(ewindmill) diagram {%- endcomment %}

Para mudar a `Curve` desta animação, atualize o código para o seguinte:

```dart
class Tile extends StatelessWidget {
  const Tile(required this.letter, required hitType, {super.key});

  final String letter;
  final HitType hitType;


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
	    curve: Curves.decelerate, // NEW
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: switch (hitType) {
          LetterType.hit => Colors.green,
          LetterType.partial => Colors.yellow,
          LetterType.miss => Colors.grey,
          _ => Colors.white,
        },
      ),
      child: Center(
        child: Text(
          letter.char.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
```

Existem muitas curvas diferentes definidas pelo Flutter SDK, então sinta-se
livre para experimentá-las passando diferentes tipos para a
propriedade `AnimatedContainer.curve`.

Animações implícitas como `AnimatedContainer` são poderosas porque você
apenas diz ao widget qual deve ser o novo estado, e ele lida com o
"como" da animação. Para animações complexas e customizadas, você pode escrever
seus próprios widgets animados. Se você está curioso, leia o
[tutorial de animações][animations tutorial].

[`AnimatedContainer`]: {{site.api}}/flutter/widgets/AnimatedContainer-class.html
[`Curve`]: {{site.curve}}/flutter/animation/Curves-class.html
[animations tutorial]: /ui/animations/tutorial.
