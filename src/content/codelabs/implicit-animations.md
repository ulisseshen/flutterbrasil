---
ia-translate: true
title: "Animações implícitas"
description: >
  Aprenda como usar os widgets de animação implícita do Flutter
  através de exemplos interativos e exercícios.
toc: true
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="animation/implicit"?>

Bem-vindo ao codelab de animações implícitas, onde você aprenderá como usar
widgets do Flutter que facilitam a criação de animações para um conjunto
específico de propriedades.

{% include docs/dartpad-troubleshooting.md %}

Para obter o máximo deste codelab, você deve ter conhecimento básico sobre:

- Como [criar um aplicativo Flutter][].
- Como usar [widgets stateful][].

Este codelab abrange o seguinte material:

- Usar `AnimatedOpacity` para criar um efeito de fade-in.
- Usar `AnimatedContainer` para animar transições de tamanho, cor e margem.
- Visão geral das animações implícitas e técnicas para usá-las.

**Tempo estimado para concluir este codelab: 15-30 minutos.**

## O que são animações implícitas?

Com a [biblioteca de animação][] do Flutter,
você pode adicionar movimento e criar efeitos visuais
para os widgets na sua UI.
Um conjunto de widgets na biblioteca gerencia animações para você.
Esses widgets são coletivamente referidos como _animações implícitas_,
ou _widgets com animação implícita_, derivando seu nome da
classe [ImplicitlyAnimatedWidget][] que eles implementam.
Com animações implícitas,
você pode animar uma propriedade de um widget definindo um valor alvo;
sempre que esse valor alvo mudar,
o widget anima a propriedade do valor antigo para o novo.
Dessa forma, as animações implícitas trocam o controle pela conveniência — elas
gerenciam os efeitos de animação para que você não precise.

## Exemplo: Efeito de fade-in de texto

O exemplo a seguir mostra como adicionar um efeito de fade-in à UI existente
usando um widget com animação implícita chamado [AnimatedOpacity][].
**O exemplo começa sem nenhum código de animação** — ele
consiste em uma tela inicial [Material App][] contendo:

- Uma fotografia de uma coruja.
- Um botão **Mostrar detalhes** que não faz nada quando clicado.
- Texto de descrição da coruja na fotografia.

### Fade-in (código inicial)

Para visualizar o exemplo, clique em **Executar**:

{% render docs/implicit-animations/fade-in-starter-code.md %}

### Animar opacidade com widget AnimatedOpacity

Esta seção contém uma lista de etapas que você pode usar para adicionar uma
animação implícita ao [código inicial de fade-in][]. Após as etapas, você
também pode executar o código [fade-in completo][] com as alterações já feitas.
As etapas descrevem como usar o widget `AnimatedOpacity`
para adicionar o seguinte recurso de animação:

- O texto de descrição da coruja permanece oculto até que o usuário clique em
  **Mostrar detalhes**.
- Quando o usuário clica em **Mostrar detalhes**,
  o texto de descrição da coruja aparece gradualmente.

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
fazer essas alterações no [código inicial de fade-in][].
:::

#### 2. Inicialize uma variável de estado para a propriedade animada

Para ocultar o texto antes que o usuário clique em **Mostrar detalhes**, defina
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

#### 4. Configure um gatilho para animação e escolha um valor final

Configure a animação para ser acionada quando o usuário clicar em **Mostrar detalhes**.
Para fazer isso, altere o estado `opacity` usando o manipulador `onPressed()` para
`TextButton`. Para fazer com que o widget `FadeInDemo` se torne totalmente visível quando
o usuário clica em **Mostrar detalhes**, use o manipulador `onPressed()`
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
O widget `AnimatedOpacity` gerencia tudo entre eles.
:::

### Fade-in (completo)

Aqui está o exemplo com as alterações concluídas que você fez.
Execute este exemplo e clique em **Mostrar detalhes** para acionar a animação.

{% render docs/implicit-animations/fade-in-complete.md %}

### Juntando tudo

O exemplo [Efeito de fade-in de texto][] demonstra os seguintes recursos
do widget `AnimatedOpacity`.

- Ele escuta as alterações de estado em sua propriedade `opacity`.
- Quando a propriedade `opacity` muda,
  ele anima a transição para o novo valor de `opacity`.
- Ele requer um parâmetro `duration` para definir quanto tempo
  deve levar a transição entre os valores.

:::note
- Animações implícitas só podem animar as
  propriedades de um widget stateful pai.
  O exemplo anterior habilita isso com o
  widget `FadeInDemo` que estende `StatefulWidget`.

- O widget `AnimatedOpacity` só anima a propriedade `opacity`.
  Alguns widgets com animação implícita podem animar várias propriedades
  ao mesmo tempo. O exemplo a seguir mostra isso.
:::

## Exemplo: Efeito de mudança de forma

O exemplo a seguir mostra como usar o widget [`AnimatedContainer`][] para
animar várias propriedades (`margin`, `borderRadius` e `color`) com
diferentes tipos (`double` e `Color`).
**O exemplo começa sem nenhum código de animação**.
Ele começa com uma tela inicial [Material App][] que contém:

- Um widget `Container` configurado com um
  `borderRadius`, `margin` e `color`.
  Essas propriedades são configuradas para serem regeneradas
  cada vez que você executa o exemplo.
- Um botão **Alterar** que não faz nada quando clicado.

### Mudança de forma (código inicial)

Para iniciar o exemplo, clique em **Executar**.

{% render docs/implicit-animations/shape-shifting-starter-code.md %}

### Animar cor, borderRadius e margem com AnimatedContainer

Esta seção contém uma lista de etapas que você pode usar para adicionar uma
animação implícita ao [código inicial de mudança de forma][].
Depois de concluir cada etapa, você também pode executar o
[exemplo completo de mudança de forma][] com as alterações já feitas.

O [código inicial de mudança de forma][] atribui
a cada propriedade no widget `Container` um valor aleatório.
Funções associadas geram os valores relevantes:

- A função `randomColor()` gera um
  `Color` para a propriedade `color`
- A função `randomBorderRadius()` gera um
  `double` para a propriedade `borderRadius`.
- A função `randomMargin()` gera um
  `double` para a propriedade `margin`.

As etapas a seguir usam o widget `AnimatedContainer` para:

- Fazer a transição para novos valores para `color`, `borderRadius`,
  e `margin` sempre que o usuário clicar em **Alterar**.
- Animar a transição para os novos valores para `color`,
  `borderRadius` e `margin` sempre que eles forem definidos.

#### 1. Adicione uma animação implícita

Altere o widget `Container` para um widget `AnimatedContainer`:

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
fazer essas alterações no [código inicial de mudança de forma][].
:::

#### 2. Defina os valores iniciais para as propriedades animadas

O widget `AnimatedContainer` faz a transição entre
valores antigos e novos de suas propriedades quando eles mudam.
Para conter o comportamento acionado quando o usuário clica em **Alterar**,
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

Para definir a animação para ser acionada sempre que o usuário pressionar **Alterar**,
invoque o método `change()` no manipulador `onPressed()`:

```dart diff
  ElevatedButton(
    child: const Text('Change'),
-   onPressed: () => {},
+   onPressed: () => change(),
  ),
```

#### 4. Definir duração

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

### Mudança de forma (completo)

Aqui está o exemplo com as alterações concluídas que você fez.
Execute o código e clique em **Alterar** para acionar a animação.
Cada vez que você clica em **Alterar**, a forma é animada para seus novos valores
para `margin`, `borderRadius` e `color`.

{% render docs/implicit-animations/shape-shifting-complete.md %}

### Usando curvas de animação

Os exemplos anteriores mostram como:

- Animações implícitas permitem que você anime a transição entre
  valores para propriedades de widget específicas.
- O parâmetro `duration` permite que você defina quanto tempo a animação
  leva para ser concluída.

Animações implícitas também permitem que você controle as mudanças na **taxa**
de uma animação que ocorre durante a `duration` definida.
Para definir essa mudança na taxa,
defina o valor do parâmetro `curve` para
uma [`Curve`][], como uma declarada na classe [`Curves`][].

Os exemplos anteriores não especificaram um valor para o parâmetro `curve`.
Sem um valor de curva especificado,
as animações implícitas aplicam uma [curva de animação linear][].

Especifique um valor para o parâmetro `curve` no
[exemplo completo de mudança de forma][].
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
do widget `AnimatedContainer`, veja como
as taxas de mudança para `margin`, `borderRadius` e `color`
seguem a curva que a constante definiu.

<video style="width:464px; height:192px;" loop="" autoplay disablepictureinpicture playsinline controls controlslist="nodownload noremoteplayback">
  <source src="{{site.flutter-assets}}/animation/curve_ease_in_out_back.mp4" type="video/mp4">
</video>

### Juntando tudo

O [exemplo completo de mudança de forma][] anima as transições entre
valores para as propriedades `margin`, `borderRadius` e `color`.
O widget `AnimatedContainer` anima mudanças em qualquer uma de suas propriedades.
Isso inclui aquelas que você não usou, como `padding`, `transform`,
e até mesmo `child` e `alignment`!
Ao mostrar capacidades adicionais de animações implícitas,
o [exemplo completo de mudança de forma][] se baseia no
[fade-in completo][].

Para resumir as animações implícitas:

- Algumas animações implícitas, como o widget `AnimatedOpacity`,
  animam apenas uma propriedade.
  Outras, como o widget `AnimatedContainer`, podem animar várias propriedades.
- Animações implícitas animam a transição entre o
  valor antigo e novo de uma propriedade quando ela
  muda usando a `curve` e `duration` fornecidas.
- Se você não especificar uma `curve`,
  as animações implícitas usam por padrão uma [curva linear][].

## Qual é o próximo passo?

Parabéns, você concluiu o codelab!
Para aprender mais, confira estas sugestões:

- Experimente o [tutorial de animações][].
- Aprenda sobre [animações hero][] e [animações escalonadas][].
- Confira a [biblioteca de animação][].
- Experimente outro [codelab][].

[`AnimatedContainer`]: {{site.api}}/flutter/widgets/AnimatedContainer-class.html
[AnimatedOpacity]: {{site.api}}/flutter/widgets/AnimatedOpacity-class.html
[biblioteca de animação]: {{site.api}}/flutter/animation/animation-library.html
[tutorial de animações]: /ui/animations/tutorial
[codelab]: /codelabs
[`Curve`]: {{site.api}}/flutter/animation/Curve-class.html
[`Curves`]: {{site.api}}/flutter/animation/Curves-class.html
[duration]: {{site.api}}/flutter/widgets/ImplicitlyAnimatedWidget/duration.html
[`easeInOutBack`]: {{site.api}}/flutter/animation/Curves/easeInOutBack-constant.html
[fade-in completo]: #fade-in-complete
[código inicial de fade-in]: #fade-in-starter-code
[efeito de fade-in de texto]: #example-fade-in-text-effect
[animações hero]: /ui/animations/hero-animations
[ImplicitlyAnimatedWidget]: {{site.api}}/flutter/widgets/ImplicitlyAnimatedWidget-class.html
[curva de animação linear]: {{site.api}}/flutter/animation/Curves/linear-constant.html
[curva linear]: {{site.api}}/flutter/animation/Curves/linear-constant.html
[criar um aplicativo Flutter]: {{site.codelabs}}/codelabs/flutter-codelab-first
[Material App]: {{site.api}}/flutter/material/MaterialApp-class.html
[exemplo completo de mudança de forma]: #shape-shifting-complete
[código inicial de mudança de forma]: #shape-shifting-starter-code
[animações escalonadas]: /ui/animations/staggered-animations
[widgets stateful]: /ui/interactivity#stateful-and-stateless-widgets
