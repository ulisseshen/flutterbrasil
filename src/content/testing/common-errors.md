---
ia-translate: true
title: Erros comuns do Flutter
description: Como reconhecer e resolver erros comuns do framework Flutter.
---

<?code-excerpt path-base="testing/common_errors"?>

## Introdução

Esta página explica vários erros frequentemente encontrados no
framework Flutter (incluindo erros de layout) e dá sugestões
sobre como resolvê-los.
Este é um documento vivo com mais erros a serem adicionados em
revisões futuras, e suas contribuições são bem-vindas.
Sinta-se à vontade para [abrir um issue][open an issue] ou [enviar um pull request][submit a pull request] para
tornar esta página mais útil para você e a comunidade Flutter.

[open an issue]: {{site.repo.this}}/issues/new/choose
[submit a pull request]: {{site.repo.this}}/pulls

## Uma tela vermelha ou cinza sólida ao executar seu app

Tipicamente chamada de "tela vermelha (ou cinza) da morte",
esta é às vezes como o Flutter permite
que você saiba que há um erro.

A tela vermelha pode aparecer quando o app é executado em
modo debug ou profile. A tela cinza pode aparecer
quando o app é executado em modo release.

Geralmente, esses erros ocorrem quando há uma
exceção não capturada (e você pode precisar de outro
bloco try-catch), ou quando há algum erro de renderização,
como um erro de overflow.

Os artigos a seguir fornecem algumas percepções úteis
sobre como depurar esse tipo de erro:

* [Flutter errors demystified][Flutter errors demystified] por Abishek
* [Understanding and addressing the grey screen in Flutter][Understanding and addressing the grey screen in Flutter] por Christopher Nwosu-Madueke
* [Flutter stuck on white screen][Flutter stuck on white screen] por Kesar Bhimani

[Flutter errors demystified]: {{site.medium}}/@hpatilabhi10/flutter-errors-demystified-red-screen-errors-vs-debug-console-errors-acb3b8ed2625
[Flutter stuck on white screen]: https://www.dhiwise.com/post/flutter-stuck-on-white-screen-understanding-and-fixing
[Understanding and addressing the grey screen in Flutter]: {{site.medium}}/@LordChris/understanding-and-addressing-the-grey-screen-in-flutter-5e72c31f408f

## 'A RenderFlex overflowed…'

O overflow de RenderFlex é um dos erros mais frequentemente
encontrados do framework Flutter,
e você provavelmente já se deparou com ele.

**Como é o erro?**

Quando isso acontece, listras amarelas e pretas aparecem,
indicando a área de overflow na UI do app.
Além disso, uma mensagem de erro é exibida no console de debug:

```plaintext
The following assertion was thrown during layout:
A RenderFlex overflowed by 1146 pixels on the right.

The relevant error-causing widget was

    Row      lib/errors/renderflex_overflow_column.dart:23

The overflowing RenderFlex has an orientation of Axis.horizontal.
The edge of the RenderFlex that is overflowing has been marked in the rendering
with a yellow and black striped pattern. This is usually caused by the contents
being too big for the RenderFlex.
(Additional lines of this message omitted)
```

**Como você pode encontrar este erro?**

O erro frequentemente ocorre quando uma `Column` ou `Row` tem um
widget filho que não está restrito em seu tamanho.
Por exemplo,
o trecho de código abaixo demonstra um cenário comum:

<?code-excerpt "lib/renderflex_overflow.dart (problem)"?>
```dart
Widget build(BuildContext context) {
  return Row(
    children: [
      const Icon(Icons.message),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Title', style: Theme.of(context).textTheme.headlineMedium),
          const Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed '
            'do eiusmod tempor incididunt ut labore et dolore magna '
            'aliqua. Ut enim ad minim veniam, quis nostrud '
            'exercitation ullamco laboris nisi ut aliquip ex ea '
            'commodo consequat.',
          ),
        ],
      ),
    ],
  );
}
```

No exemplo acima,
a `Column` tenta ser mais larga que o espaço que a `Row`
(seu pai) pode alocar para ela, causando um erro de overflow.
Por que a `Column` tenta fazer isso?
Para entender esse comportamento de layout, você precisa saber
como o framework Flutter realiza o layout:

"_Para realizar o layout, o Flutter percorre a árvore de renderização em uma travessia depth-first
e **passa constraints de tamanho** de pai para filho… Os filhos respondem
**passando um tamanho** para seu objeto pai dentro das constraints que o pai
estabeleceu._" – [Visão geral arquitetural do Flutter][Flutter architectural overview]

Neste caso, o widget `Row` não restringe o
tamanho de seus filhos, nem o widget `Column`.
Sem constraints de seu widget pai, o segundo
widget `Text` tenta ser tão largo quanto todos os caracteres
que precisa exibir. A largura autodeterminada do
widget `Text` é então adotada pela `Column`, que
conflita com a quantidade máxima de espaço horizontal que seu pai,
o widget `Row`, pode fornecer.

[Flutter architectural overview]: /resources/architectural-overview#layout-and-rendering

**Como corrigir?**

Bem, você precisa garantir que a `Column` não tente
ser mais larga do que pode ser. Para conseguir isso,
você precisa restringir sua largura. Uma maneira de fazer isso é
envolver a `Column` em um widget `Expanded`:

<?code-excerpt "lib/renderflex_overflow.dart (solution)"?>
```dart
return const Row(
  children: [
    Icon(Icons.message),
    Expanded(
      child: Column(
        // code omitted
      ),
    ),
  ],
);
```

Outra maneira é envolver a `Column` em um widget `Flexible`
e especificar um fator `flex`. Na verdade,
o widget `Expanded` é equivalente ao widget `Flexible`
com um fator `flex` de 1.0, como [seu código-fonte][its source code] mostra.
Para entender melhor como usar o widget `Flex` em layouts Flutter,
confira [este vídeo Widget of the Week de 90 segundos][flexible-video]
sobre o widget `Flexible`.

**Mais informações:**

Os recursos vinculados abaixo fornecem mais informações sobre este erro.

* [Flexible (Flutter Widget of the Week)][flexible-video]
* [How to debug layout issues with the Flutter Inspector][medium-article]
* [Understanding constraints][Understanding constraints]

[its source code]: {{site.repo.flutter}}/blob/c8e42b47f5ea8b5ff7bf2f2b0a2a8e765f1aa51d/packages/flutter/lib/src/widgets/basic.dart#L5166-L5174
[flexible-video]: {{site.yt.watch}}?v=CI7x0mAZiY0
[medium-article]: {{site.flutter-blog}}/how-to-debug-layout-issues-with-the-flutter-inspector-87460a7b9db#738b
[Understanding constraints]: /ui/layout/constraints

## 'RenderBox was not laid out'

Embora este erro seja bastante comum,
muitas vezes é um efeito colateral de um erro primário
que ocorre anteriormente no pipeline de renderização.

**Como é o erro?**

A mensagem mostrada pelo erro se parece com isto:

```plaintext
RenderBox was not laid out:
RenderViewport#5a477 NEEDS-LAYOUT NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
```

**Como você pode encontrar este erro?**

Geralmente, o problema está relacionado à violação de constraints de caixa,
e precisa ser resolvido fornecendo mais informações
ao Flutter sobre como você gostaria de restringir os widgets em questão.
Você pode aprender mais sobre como as constraints funcionam
no Flutter na página [Understanding constraints][Understanding constraints].

O erro `RenderBox was not laid out` é frequentemente
causado por um de dois outros erros:

* 'Vertical viewport was given unbounded height'
* 'An InputDecorator...cannot have an unbounded width'

<a id="unbounded"></a>

## 'Vertical viewport was given unbounded height'

Este é outro erro de layout comum que você pode encontrar
ao criar uma UI no seu app Flutter.

**Como é o erro?**

A mensagem mostrada pelo erro se parece com isto:

```plaintext
The following assertion was thrown during performResize():
Vertical viewport was given unbounded height.

Viewports expand in the scrolling direction to fill their container.
In this case, a vertical viewport was given an unlimited amount of
vertical space in which to expand. This situation typically happens when a
scrollable widget is nested inside another scrollable widget.
(Additional lines of this message omitted)
```

**Como você pode encontrar este erro?**

O erro é frequentemente causado quando um `ListView`
(ou outros tipos de widgets roláveis como `GridView`)
é colocado dentro de uma `Column`. Um `ListView` pega todo
o espaço vertical disponível para ele,
a menos que seja restringido por seu widget pai.
No entanto, uma `Column` não impõe nenhuma constraint
na altura de seus filhos por padrão.
A combinação dos dois comportamentos leva à falha em
determinar o tamanho do `ListView`.

<?code-excerpt "lib/unbounded_height.dart (problem)"?>
```dart
Widget build(BuildContext context) {
  return Center(
    child: Column(
      children: <Widget>[
        const Text('Header'),
        ListView(
          children: const <Widget>[
            ListTile(leading: Icon(Icons.map), title: Text('Map')),
            ListTile(leading: Icon(Icons.subway), title: Text('Subway')),
          ],
        ),
      ],
    ),
  );
}
```

**Como corrigir?**

Para corrigir este erro, especifique quão alto o `ListView` deve ser.
Para torná-lo tão alto quanto o espaço restante na `Column`,
envolva-o usando um widget `Expanded` (como mostrado no exemplo a seguir).
Caso contrário, especifique uma altura absoluta usando um widget `SizedBox`
ou uma altura relativa usando um widget `Flexible`.

<?code-excerpt "lib/unbounded_height.dart (solution)"?>
```dart
Widget build(BuildContext context) {
  return Center(
    child: Column(
      children: <Widget>[
        const Text('Header'),
        Expanded(
          child: ListView(
            children: const <Widget>[
              ListTile(leading: Icon(Icons.map), title: Text('Map')),
              ListTile(leading: Icon(Icons.subway), title: Text('Subway')),
            ],
          ),
        ),
      ],
    ),
  );
}
```

**Mais informações:**

Os recursos vinculados abaixo fornecem
mais informações sobre este erro.

* [How to debug layout issues with the Flutter Inspector][medium-article]
* [Understanding constraints][Understanding constraints]

## 'An InputDecorator...cannot have an unbounded width'

A mensagem de erro sugere que também está relacionada
a constraints de caixa, que são importantes para entender
para evitar muitos dos erros mais comuns do framework Flutter.

**Como é o erro?**

A mensagem mostrada pelo erro se parece com isto:

```plaintext
The following assertion was thrown during performLayout():
An InputDecorator, which is typically created by a TextField, cannot have an
unbounded width.
This happens when the parent widget does not provide a finite width constraint.
For example, if the InputDecorator is contained by a `Row`, then its width must
be constrained. An `Expanded` widget or a SizedBox can be used to constrain the
width of the InputDecorator or the TextField that contains it.
(Additional lines of this message omitted)
```

**Como você pode encontrar este erro?**

Este erro ocorre, por exemplo, quando uma `Row` contém um
`TextFormField` ou um `TextField` mas este último não tem
constraint de largura.

<?code-excerpt "lib/unbounded_width.dart (problem)"?>
```dart
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Unbounded Width of the TextField')),
      body: const Row(children: [TextField()]),
    ),
  );
}
```

**Como corrigir?**

Como sugerido pela mensagem de erro,
corrija este erro restringindo o campo de texto
usando um widget `Expanded` ou `SizedBox`.
O exemplo a seguir demonstra o uso de um widget `Expanded`:

<?code-excerpt "lib/unbounded_width.dart (solution)"?>
```dart
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Unbounded Width of the TextField')),
      body: Row(children: [Expanded(child: TextFormField())]),
    ),
  );
}
```

## 'Incorrect use of ParentData widget'

Este erro é sobre a falta de um widget pai esperado.

**Como é o erro?**

A mensagem mostrada pelo erro se parece com isto:

```plaintext
The following assertion was thrown while looking for parent data:
Incorrect use of ParentDataWidget.
(Some lines of this message omitted)
Usually, this indicates that at least one of the offending ParentDataWidgets
listed above is not placed directly inside a compatible ancestor widget.
```

**Como você pode encontrar este erro?**

Embora os widgets do Flutter geralmente sejam flexíveis
em como podem ser compostos juntos em uma UI,
um pequeno subconjunto desses widgets espera widgets pais específicos.
Quando essa expectativa não pode ser satisfeita na sua árvore de widgets,
você provavelmente encontrará este erro.

Aqui está uma lista _incompleta_ de widgets que esperam
widgets pais específicos dentro do framework Flutter.
Sinta-se à vontade para enviar um PR (usando o ícone de documento no
canto superior direito da página) para expandir esta lista.

| Widget                                | Widgets pais esperados        |
|:--------------------------------------|------------------------------:|
| `Flexible`                            | `Row`, `Column` ou `Flex`     |
| `Expanded` (um `Flexible` especializado) | `Row`, `Column` ou `Flex` |
| `Positioned`                          |                      `Stack`  |
| `TableCell`                           |                      `Table`  |

**Como corrigir?**

A correção deve ser óbvia uma vez que você saiba
qual widget pai está faltando.

## 'setState called during build'

O método `build` no seu código Flutter não é
um bom lugar para chamar `setState`,
direta ou indiretamente.

**Como é o erro?**

Quando o erro ocorre,
a seguinte mensagem é exibida no console:

```plaintext
The following assertion was thrown building DialogPage(dirty, dependencies:
[_InheritedTheme, _LocalizationsScope-[GlobalKey#59a8e]],
state: _DialogPageState#f121e):
setState() or markNeedsBuild() called during build.

This Overlay widget cannot be marked as needing to build because the framework
is already in the process of building widgets.
(Additional lines of this message omitted)
```

**Como você pode encontrar este erro?**

Em geral, este erro ocorre quando o método `setState`
é chamado dentro do método `build`.

Um cenário comum onde este erro ocorre é quando
se tenta acionar um `Dialog` de dentro do
método `build`. Isso é frequentemente motivado pela necessidade de
mostrar informações imediatamente ao usuário,
mas `setState` nunca deve ser chamado de um método `build`.

O trecho a seguir parece ser um culpado comum deste erro:

<?code-excerpt "lib/set_state_build.dart (problem)"?>
```dart
Widget build(BuildContext context) {
  // Don't do this.
  showDialog(
    context: context,
    builder: (context) {
      return const AlertDialog(title: Text('Alert Dialog'));
    },
  );

  return const Center(
    child: Column(children: <Widget>[Text('Show Material Dialog')]),
  );
}
```

Este código não faz uma chamada explícita a `setState`,
mas é chamado por `showDialog`.
O método `build` não é o lugar certo para chamar
`showDialog` porque `build` pode ser chamado pelo
framework para cada frame, por exemplo, durante uma animação.

**Como corrigir?**

Uma maneira de evitar este erro é usar a API `Navigator`
para acionar o dialog como uma rota. No exemplo a seguir,
há duas páginas. A segunda página tem um
dialog a ser exibido na entrada.
Quando o usuário solicita a segunda página
clicando em um botão na primeira página,
o `Navigator` empurra duas rotas–uma
para a segunda página e outra para o dialog.

<?code-excerpt "lib/set_state_build.dart (solution)"?>
```dart
class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First Screen')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Launch screen'),
          onPressed: () {
            // Navigate to the second screen using a named route.
            Navigator.pushNamed(context, '/second');
            // Immediately show a dialog upon loading the second screen.
            Navigator.push(
              context,
              PageRouteBuilder(
                barrierDismissible: true,
                opaque: false,
                pageBuilder: (_, anim1, anim2) => const MyDialog(),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

## `The ScrollController is attached to multiple scroll views`

Este erro pode ocorrer quando múltiplos widgets
de rolagem (como `ListView`) aparecem na
tela ao mesmo tempo. É mais provável que
este erro ocorra em um app web ou desktop,
do que em um app mobile, já que é raro encontrar
este cenário em mobile.

Para mais informações e aprender como corrigir,
confira o vídeo a seguir sobre
[`PrimaryScrollController`][controller-video]:

<YouTubeEmbed id="33_0ABjFJUU" title="PrimaryScrollController | Decoding Flutter"></YouTubeEmbed>

[controller-video]: {{site.api}}/flutter/widgets/PrimaryScrollController-class.html

## Referências

Para aprender mais sobre como depurar erros,
especialmente erros de layout no Flutter,
confira os seguintes recursos:

* [How to debug layout issues with the Flutter Inspector][medium-article]
* [Understanding constraints][Understanding constraints]
* [Visão geral arquitetural do Flutter][Flutter architectural overview]

[Flutter architectural overview]: /resources/architectural-overview#layout-and-rendering
