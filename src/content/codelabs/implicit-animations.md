---
ia-translate: true
title: "Animações implícitas"
description: >
  Aprenda como usar os widgets de animação implícita do Flutter
  através de exemplos e exercícios interativos.
toc: true
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="animation/implicit"?>

Bem-vindo ao codelab de animações implícitas, onde você aprende como usar widgets
Flutter que facilitam a criação de animações para um conjunto específico de propriedades.

{% include docs/dartpad-troubleshooting.md %}

Para aproveitar ao máximo este codelab, você deve ter conhecimento básico sobre:

- Como [criar um app Flutter][make a Flutter app].
- Como usar [stateful widgets][].

Este codelab aborda o seguinte material:

- Usar `AnimatedOpacity` para criar um efeito de fade-in.
- Usar `AnimatedContainer` para animar transições de tamanho, cor e margem.
- Visão geral de animações implícitas e técnicas para usá-las.

**Tempo estimado para completar este codelab: 15-30 minutos.**

## O que são animações implícitas?

Com a [biblioteca de animação][animation library] do Flutter,
você pode adicionar movimento e criar efeitos visuais
para os widgets na sua UI.
Um conjunto de widgets na biblioteca gerencia animações para você.
Esses widgets são coletivamente chamados de _animações implícitas_,
ou _widgets implicitamente animados_, derivando seu nome da
classe [ImplicitlyAnimatedWidget][] que eles implementam.
Com animações implícitas,
você pode animar uma propriedade de widget definindo um valor alvo;
sempre que esse valor alvo muda,
o widget anima a propriedade do valor antigo para o novo.
Dessa forma, animações implícitas trocam controle por conveniência&mdash;elas
gerenciam efeitos de animação para que você não precise fazer isso.

## Exemplo: Efeito de fade-in de texto {#example-fade-in-text-effect}

O exemplo a seguir mostra como adicionar um efeito de fade-in à UI existente
usando um widget implicitamente animado chamado [AnimatedOpacity][].
**O exemplo começa sem código de animação**&mdash;ele
consiste em uma tela inicial de [Material App][] contendo:

- Uma fotografia de uma coruja.
- Um botão **Show details** que não faz nada quando clicado.
- Texto de descrição da coruja na fotografia.

### Fade-in (código inicial) {#fade-in-starter-code}

Para ver o exemplo, clique em **Run**:

{% render docs/implicit-animations/fade-in-starter-code.md %}

### Animar opacidade com o widget AnimatedOpacity

Esta seção contém uma lista de etapas que você pode usar para adicionar uma
animação implícita ao
[código inicial fade-in][fade-in starter code]. Depois das etapas, você também pode executar o
código [fade-in completo][fade-in complete] com as alterações já feitas.
As etapas descrevem como usar o widget `AnimatedOpacity`
para adicionar o seguinte recurso de animação:

- O texto de descrição da coruja permanece oculto até que o usuário clique
  em **Show details**.
- Quando o usuário clica em **Show details**,
  o texto de descrição da coruja aparece gradualmente (fade in).

#### 1. Escolha uma propriedade de widget para animar

Para criar um efeito de fade-in, você pode animar a
propriedade `opacity` usando o widget `AnimatedOpacity`.
Envolva o widget `Column` em um widget `AnimatedOpacity`:

```dart diff
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      Image.network(owlUrl),
      TextButton(
        child: const Text(
          'Show Details',
          style: TextStyle(color: Colors.blueAccent),
        ),
        onPressed: () => {},
      ),
-     const Column(
-       children: [
-         Text('Type: Owl'),
-         Text('Age: 39'),
-         Text('Employment: None'),
-       ],
-     ),
+     AnimatedOpacity(
+       child: const Column(
+         children: [
+           Text('Type: Owl'),
+           Text('Age: 39'),
+           Text('Employment: None'),
+         ],
+       ),
+     ),
    ]);
  }
```

:::note
Você pode referenciar os números de linha no código de exemplo para ajudar a rastrear onde
fazer essas alterações no [código inicial fade-in][fade-in starter code].
:::

#### 2. Inicialize uma variável de estado para a propriedade animada

Para ocultar o texto antes que o usuário clique em **Show details**, defina
o valor inicial para `opacity` como zero:

```dart diff
  class _FadeInDemoState extends State<FadeInDemo> {
+   double opacity = 0;
+
    @override
    Widget build(BuildContext context) {
      return ListView(children: <Widget>[
        // ...
        AnimatedOpacity(
+         opacity: opacity,
          child: const Column(
```

#### 3. Defina a duração da animação

Além de um parâmetro `opacity`, `AnimatedOpacity` requer uma
[duration][] para usar em sua animação. Para este exemplo,
você pode começar com 2 segundos:

```dart diff
  AnimatedOpacity(
+   duration: const Duration(seconds: 2),
    opacity: opacity,
    child: const Column(
```

#### 4. Configure um gatilho para a animação e escolha um valor final

Configure a animação para disparar quando o usuário clicar em **Show details**.
Para fazer isso, altere o estado `opacity` usando o handler `onPressed()` para
`TextButton`. Para fazer o widget `FadeInDemo` ficar totalmente visível quando
o usuário clicar em **Show details**, use o handler `onPressed()`
para definir `opacity` como 1:

```dart diff
  TextButton(
    child: const Text(
      'Show Details',
      style: TextStyle(color: Colors.blueAccent),
    ),
-   onPressed: () => {},
+   onPressed: () => setState(() {
+     opacity = 1;
+   }),
  ),
```

:::note
Você só precisa definir os valores inicial e final de `opacity`.
O widget `AnimatedOpacity` gerencia tudo no meio.
:::

### Fade-in (completo) {#fade-in-complete}

Aqui está o exemplo com as alterações completas que você fez.
Execute este exemplo e clique em **Show details** para disparar a animação.

{% render docs/implicit-animations/fade-in-complete.md %}

### Juntando tudo

O exemplo [Efeito de fade-in de texto][Fade-in text effect] demonstra os seguintes recursos
do widget `AnimatedOpacity`.

- Ele escuta mudanças de estado em sua propriedade `opacity`.
- Quando a propriedade `opacity` muda,
  ele anima a transição para o novo valor de `opacity`.
- Ele requer um parâmetro `duration` para definir quanto tempo
  a transição entre os valores deve levar.

:::note
- Animações implícitas só podem animar as
  propriedades de um widget stateful pai.
  O exemplo anterior habilita isso com o
  widget `FadeInDemo` que estende `StatefulWidget`.

- O widget `AnimatedOpacity` anima apenas a propriedade `opacity`.
  Alguns widgets implicitamente animados podem animar muitas propriedades
  ao mesmo tempo. O exemplo a seguir demonstra isso.
:::

## Exemplo: Efeito de mudança de forma

O exemplo a seguir mostra como usar o widget [`AnimatedContainer`][] para
animar múltiplas propriedades (`margin`, `borderRadius` e `color`) com
diferentes tipos (`double` e `Color`).
**O exemplo começa sem código de animação**.
Ele começa com uma tela inicial de [Material App][] que contém:

- Um widget `Container` configurado com
 `borderRadius`, `margin` e `color`.
  Essas propriedades são configuradas para serem regeneradas
  cada vez que você executar o exemplo.
- Um botão **Change** que não faz nada quando clicado.

### Mudança de forma (código inicial) {#shape-shifting-starter-code}

Para iniciar o exemplo, clique em **Run**.

{% render docs/implicit-animations/shape-shifting-starter-code.md %}

### Animar color, borderRadius e margin com AnimatedContainer

Esta seção contém uma lista de etapas que você pode usar para adicionar uma
animação implícita ao [código inicial de mudança de forma][shape-shifting starter code].
Depois de completar cada etapa, você também pode executar o
[exemplo completo de mudança de forma][complete shape-shifting example] com as alterações já feitas.

O [código inicial de mudança de forma][shape-shifting starter code] atribui
a cada propriedade no widget `Container` um valor aleatório.
Funções associadas geram os valores relevantes:

- A função `randomColor()` gera uma
  `Color` para a propriedade `color`
- A função `randomBorderRadius()` gera um
  `double` para a propriedade `borderRadius`.
- A função `randomMargin()` gera um
  `double` para a propriedade `margin`.

As etapas a seguir usam o widget `AnimatedContainer` para:

- Fazer a transição para novos valores de `color`, `borderRadius`,
  e `margin` sempre que o usuário clicar em **Change**.
- Animar a transição para os novos valores de `color`,
  `borderRadius` e `margin` sempre que eles forem definidos.

#### 1. Adicione uma animação implícita

Mude o widget `Container` para um widget `AnimatedContainer`:

```dart diff
  SizedBox(
    width: 128,
    height: 128,
-   child: Container(
+   child: AnimatedContainer(
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  ),
```

:::note
Você pode referenciar os números de linha no código de exemplo para ajudar a rastrear onde
fazer essas alterações no [código inicial de mudança de forma][shape-shifting starter code].
:::

#### 2. Defina valores iniciais para propriedades animadas

O widget `AnimatedContainer` faz a transição entre
valores antigos e novos de suas propriedades quando eles mudam.
Para conter o comportamento disparado quando o usuário clica em **Change**,
crie um método `change()`.
O método `change()` pode usar o método `setState()` para definir novos valores
para as variáveis de estado `color`, `borderRadius` e `margin`:

```dart diff
+ void change() {
+   setState(() {
+     color = randomColor();
+     borderRadius = randomBorderRadius();
+     margin = randomMargin();
+   });
+ }
+
  @override
  Widget build(BuildContext context) {
    // ...
```

#### 3. Configure um gatilho para a animação

Para definir a animação para disparar sempre que o usuário pressionar **Change**,
invoque o método `change()` no handler `onPressed()`:

```dart diff
  ElevatedButton(
    child: const Text('Change'),
-   onPressed: () => {},
+   onPressed: () => change(),
  ),
```

#### 4. Defina a duração

Defina a `duration` da animação que alimenta a transição
entre os valores antigos e novos:

```dart diff
  SizedBox(
    width: 128,
    height: 128,
    child: AnimatedContainer(
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
+     duration: const Duration(milliseconds: 400),
    ),
  ),
```

### Mudança de forma (completo) {#shape-shifting-complete}

Aqui está o exemplo com as alterações completas que você fez.
Execute o código e clique em **Change** para disparar a animação.
Cada vez que você clicar em **Change**, a forma anima para seus novos valores
de `margin`, `borderRadius` e `color`.

{% render docs/implicit-animations/shape-shifting-complete.md %}

### Usando curvas de animação

Os exemplos anteriores mostram como:

- Animações implícitas permitem que você anime a transição entre
  valores para propriedades específicas de widget.
- O parâmetro `duration` permite que você defina quanto tempo a animação
  leva para completar.

Animações implícitas também permitem que você controle mudanças na **taxa**
de uma animação que ocorre durante a `duration` definida.
Para definir essa mudança na taxa,
defina o valor do parâmetro `curve` para uma
[`Curve`][], como uma declarada na classe [`Curves`][].

Os exemplos anteriores não especificaram um valor para o parâmetro `curve`.
Sem um valor de curva especificado,
as animações implícitas aplicam uma [curva de animação linear][linear animation curve].

Especifique um valor para o parâmetro `curve` no
[exemplo completo de mudança de forma][complete shape-shifting example].
A animação muda quando você passa a
constante [`easeInOutBack`][] para `curve`,

```dart diff
  SizedBox(
    width: 128,
    height: 128,
    child: AnimatedContainer(
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      duration: _duration,
+     curve: Curves.easeInOutBack,
    ),
  ),
```

Quando você passa a constante `Curves.easeInOutBack` para a propriedade `curve`
do widget `AnimatedContainer`, observe como
as taxas de mudança para `margin`, `borderRadius` e `color`
seguem a curva que essa constante definiu.

<video style="width:464px; height:192px;" loop="" autoplay disablepictureinpicture playsinline controls controlslist="nodownload noremoteplayback">
  <source src="{{site.flutter-assets}}/animation/curve_ease_in_out_back.mp4" type="video/mp4">
</video>

### Juntando tudo

O [exemplo completo de mudança de forma][complete shape-shifting example] anima transições entre
valores para as propriedades `margin`, `borderRadius` e `color`.
O widget `AnimatedContainer` anima mudanças em qualquer uma de suas propriedades.
Isso inclui aquelas que você não usou, como `padding`, `transform`,
e até `child` e `alignment`!
Ao mostrar recursos adicionais de animações implícitas,
o [exemplo completo de mudança de forma][complete shape-shifting example] se baseia no
exemplo [fade-in completo][fade-in complete].

Para resumir animações implícitas:

- Algumas animações implícitas, como o widget `AnimatedOpacity`,
  animam apenas uma propriedade.
  Outras, como o widget `AnimatedContainer`, podem animar muitas propriedades.
- Animações implícitas animam a transição entre o
  valor antigo e novo de uma propriedade quando ela
  muda usando a `curve` e `duration` fornecidas.
- Se você não especificar uma `curve`,
  animações implícitas usam como padrão uma [curva linear][linear curve].

## O que vem a seguir?

Parabéns, você terminou o codelab!
Para aprender mais, confira estas sugestões:

- Experimente o [tutorial de animações][animations tutorial].
- Aprenda sobre [animações hero][hero animations] e [animações escalonadas][staggered animations].
- Confira a [biblioteca de animação][animation library].
- Experimente outro [codelab][].

[`AnimatedContainer`]: {{site.api}}/flutter/widgets/AnimatedContainer-class.html
[AnimatedOpacity]: {{site.api}}/flutter/widgets/AnimatedOpacity-class.html
[animation library]: {{site.api}}/flutter/animation/animation-library.html
[animations tutorial]: /ui/animations/tutorial
[codelab]: /codelabs
[`Curve`]: {{site.api}}/flutter/animation/Curve-class.html
[`Curves`]: {{site.api}}/flutter/animation/Curves-class.html
[duration]: {{site.api}}/flutter/widgets/ImplicitlyAnimatedWidget/duration.html
[`easeInOutBack`]: {{site.api}}/flutter/animation/Curves/easeInOutBack-constant.html
[fade-in complete]: #fade-in-complete
[fade-in starter code]: #fade-in-starter-code
[Fade-in text effect]: #example-fade-in-text-effect
[hero animations]: /ui/animations/hero-animations
[ImplicitlyAnimatedWidget]: {{site.api}}/flutter/widgets/ImplicitlyAnimatedWidget-class.html
[linear animation curve]: {{site.api}}/flutter/animation/Curves/linear-constant.html
[linear curve]: {{site.api}}/flutter/animation/Curves/linear-constant.html
[make a Flutter app]: {{site.codelabs}}/codelabs/flutter-codelab-first
[Material App]: {{site.api}}/flutter/material/MaterialApp-class.html
[complete shape-shifting example]: #shape-shifting-complete
[shape-shifting starter code]: #shape-shifting-starter-code
[staggered animations]: /ui/animations/staggered-animations
[stateful widgets]: /ui/interactivity#stateful-and-stateless-widgets
