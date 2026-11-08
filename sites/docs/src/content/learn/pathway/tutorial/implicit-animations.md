---
ia-translate: true
title: Animações simples
description: Aprenda a maneira mais simples de implementar animações no Flutter.
layout: tutorial
---

Flutter fornece um rico conjunto de APIs de animação, e a maneira mais simples de
começar a usá-las é com **animações implícitas**.
"Animações implícitas" refere-se a um grupo de widgets que
automaticamente animam mudanças em suas propriedades sem que você
precise gerenciar nenhum comportamento intermediário.

<SummaryCard>
title: O que você vai realizar
items:
  - title: Descobrir animações implícitas no Flutter
    icon: auto_awesome
  - title: Animar mudanças de propriedades com AnimatedContainer
    icon: animation
  - title: Personalizar o tempo com duration e curves
    icon: timeline
</SummaryCard>

Nesta lição, você aprenderá sobre um dos widgets de animação implícita mais comuns e
versáteis: [`AnimatedContainer`][].
Com apenas duas linhas adicionais de código, a cor de fundo de cada `Tile`
anima para uma nova cor em cerca de meio segundo.

[`AnimatedContainer`]: {{site.api}}/flutter/widgets/AnimatedContainer-class.html

---

### Converta `Container` para `AnimatedContainer` {:#convert-container-to-animatedcontainer}

Atualmente, o método `Tile.build` retorna um `Container` para exibir uma letra.
Quando o `hitType` muda, como de `HitType.none` para `HitType.hit`,
a cor de fundo do tile muda instantaneamente.
Por exemplo, de branco para verde no caso de `HitType.none` para `HitType.hit`.

Para referência, aqui está a implementação atual do widget `Tile`:

```dart
class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});

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
          letter.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
```

Para fazer a mudança de cor animar suavemente,
substitua o widget `Container` por um `AnimatedContainer`.

Um `AnimatedContainer` é como um `Container`, mas
automaticamente anima mudanças em suas propriedades ao longo de uma `duration` especificada.
Quando propriedades como
`color`, `height`, `width`, `decoration` ou `alignment` mudam,
`AnimatedContainer` interpola entre os valores antigos e novos,
criando uma transição suave.

Modifique seu widget `Tile` da seguinte forma:

```dart
class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});

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
          letter.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
```

**`duration`** é uma propriedade obrigatória que
especifica quanto tempo a animação deve levar.
Neste exemplo, passar `Duration(milliseconds: 500)` significa
que a transição de cor levará meio segundo.
Você também pode especificar segundos, minutos e muitas outras unidades de tempo.

Agora, quando o `hitType` muda e o widget `Tile` reconstrói
(porque `setState` foi chamado em `GamePage`),
a cor do tile anima suavemente de sua cor antiga para
a nova ao longo da duração especificada.

### Ajuste a curva da animação {:#adjust-the-animation-curve}

Para adicionar um pouco de customização a uma animação implícita,
você pode passar uma [`Curve`][] diferente.
Diferentes curvas mudam a velocidade da animação
em diferentes pontos ao longo da animação.

Por exemplo, a curva padrão para animações no Flutter é `Curves.linear`. Este gif mostra como a curva de animação se comporta:

<img src="/assets/images/docs/tutorial/linear_curve.gif" width="320px"
alt="Um gif que mostra uma curva linear.">

Compare isso com `Curve.bounceIn`, outra curva comum:

<img src="/assets/images/docs/tutorial/bounce_in_curve.gif" width="320px"
alt="Um gif que mostra uma curva bounce-in">



Para mudar a `Curve` desta animação, atualize o código para o seguinte:

```dart
class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});

  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.bounceIn, // NEW
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
          letter.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
```

Existem muitas curvas diferentes fornecidas pelo Flutter SDK, então
sinta-se livre para experimentá-las passando diferentes tipos para o parâmetro `curve`.

Animações implícitas como `AnimatedContainer` são poderosas porque
você apenas diz ao widget qual deve ser o novo estado, e
ele lida com o "como" da animação.

Para animações complexas e customizadas, você pode escrever seus próprios widgets animados.
Se você está curioso, experimente no [tutorial de animações][animations tutorial].

[`Curve`]: {{site.api}}/flutter/animation/Curves-class.html
[animations tutorial]: /ui/animations/tutorial

### Revisão {:#review}

<SummaryCard>
title: O que você realizou
subtitle: Aqui está um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Descobriu animações implícitas
    icon: auto_awesome
    details: >-
      Animações implícitas são widgets que animam automaticamente
      mudanças em suas propriedades.
      Você especifica o novo estado, e o widget cuida
      da animação para você sem exigir gerenciamento manual de animação.
  - title: Animou os tiles com AnimatedContainer
    icon: animation
    details: >-
      Ao substituir `Container` por `AnimatedContainer` e adicionar uma `duration`,
      seus tiles agora fazem uma transição suave entre cores.
      Com apenas duas linhas de código, você adicionou um acabamento profissional ao seu app!
  - title: Personalizou o tempo com duration e curves
    icon: timeline
    details: >-
      A propriedade `duration` controla quanto tempo a animação leva,
      enquanto `curve` muda a sensação da animação.
      Você experimentou `Curves.decelerate`, mas também pode tentar outros valores
      como `Curves.easeIn`, `Curves.bounceOut` ou `Curves.elasticIn`.
  - title: Concluiu o jogo Birdle
    icon: celebration
    details: >-
      Você construiu um jogo completo no estilo Wordle com widgets personalizados,
      layouts dinâmicos, entrada do usuário, gerenciamento de estado e animações suaves.
      Agora você tem as habilidades fundamentais para construir seus próprios apps Flutter!
</SummaryCard>

### Teste seus conhecimentos {:#test-yourself}

<Quiz title="Quiz de Animações Implícitas">
- question: Qual widget você pode usar para animar automaticamente mudanças em propriedades como cor, tamanho e decoração?
  options:
    - text: Container
      correct: false
      explanation: Container não anima; mudanças de propriedades acontecem instantaneamente.
    - text: AnimatedContainer
      correct: true
      explanation: AnimatedContainer anima automaticamente mudanças em suas propriedades ao longo da duração especificada.
    - text: AnimationController
      correct: false
      explanation: AnimationController é para animações explícitas; AnimatedContainer é mais simples para animações básicas.
    - text: TransitionContainer
      correct: false
      explanation: Não existe um widget TransitionContainer; use AnimatedContainer para animações implícitas.
- question: "O que a propriedade `duration` controla em um AnimatedContainer?"
  options:
    - text: Quanto tempo o widget permanece na tela antes de desaparecer.
      correct: false
      explanation: Duration controla o tempo da animação, não a visibilidade do widget.
    - text: Quanto tempo a animação leva para fazer a transição do valor antigo para o novo valor.
      correct: true
      explanation: A duration especifica o tempo durante o qual a mudança de propriedade é animada.
    - text: O atraso antes de a animação começar.
      correct: false
      explanation: Duration se refere à duração da animação; atrasos exigem configuração separada.
    - text: Quantas vezes a animação se repete.
      correct: false
      explanation: Animações implícitas executam uma vez por mudança de estado; repetição exige animation controllers explícitos.
</Quiz>
