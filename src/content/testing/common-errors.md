---
title: Erros Comuns do Flutter
description: Como reconhecer e resolver erros comuns do framework Flutter.
ia-translate: true
---

<?code-excerpt path-base="testing/common_errors"?>

## Introdução

Esta página explica vários erros do framework Flutter que são encontrados com frequência
(incluindo erros de layout) e oferece sugestões
de como resolvê-los.
Este é um documento dinâmico com mais erros a serem adicionados em
revisões futuras, e suas contribuições são bem-vindas.
Sinta-se à vontade para [abrir uma issue][] ou [enviar um pull request][] para
tornar esta página mais útil para você e a comunidade Flutter.

[abrir uma issue]: {{site.repo.this}}/issues/new/choose
[enviar um pull request]: {{site.repo.this}}/pulls

## Uma tela vermelha ou cinza sólida ao executar seu aplicativo

Geralmente chamada de "tela vermelha (ou cinza) da morte",
às vezes, é assim que o Flutter informa
que há um erro.

A tela vermelha pode aparecer quando o aplicativo é executado em
modo de debug ou profile. A tela cinza pode aparecer
quando o aplicativo é executado em modo release.

Geralmente, esses erros ocorrem quando há uma
exceção não capturada (e você pode precisar de outro
bloco try-catch), ou quando há algum erro de renderização,
como um erro de overflow.

Os seguintes artigos fornecem algumas informações úteis
sobre a depuração desse tipo de erro:

* [Flutter errors demystified][] por Abishek
* [Understanding and addressing the grey screen in Flutter][] por Christopher Nwosu-Madueke
* [Flutter stuck on white screen][] por Kesar Bhimani

[Flutter errors demystified]: {{site.medium}}/@hpatilabhi10/flutter-errors-demystified-red-screen-errors-vs-debug-console-errors-acb3b8ed2625
[Flutter stuck on white screen]: https://www.dhiwise.com/post/flutter-stuck-on-white-screen-understanding-and-fixing
[Understanding and addressing the grey screen in Flutter]: {{site.medium}}/@LordChris/understanding-and-addressing-the-grey-screen-in-flutter-5e72c31f408f

## 'A RenderFlex overflowed…'

O overflow do RenderFlex é um dos erros do framework Flutter mais frequentemente
encontrados, e você provavelmente já se deparou com ele.

**Como o erro se parece?**

Quando acontece, listras amarelas e pretas aparecem,
indicando a área de overflow na interface do usuário do aplicativo.
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
(Linhas adicionais desta mensagem omitidas)
```

**Como você pode se deparar com esse erro?**

O erro geralmente ocorre quando um `Column` ou `Row` tem um
widget filho que não tem seu tamanho restringido.
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
          Text('Título', style: Theme.of(context).textTheme.headlineMedium),
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
o `Column` tenta ser mais largo do que o espaço que o `Row`
(seu pai) pode alocar para ele, causando um erro de overflow.
Por que o `Column` tenta fazer isso?
Para entender esse comportamento do layout, você precisa saber
como o framework Flutter executa o layout:

"_Para executar o layout, o Flutter percorre a árvore de renderização em uma travessia de profundidade
e **passa restrições de tamanho** de pai para filho… Os filhos respondem
**passando um tamanho** para seu objeto pai dentro das restrições que o pai
estabeleceu._" – [Visão geral da arquitetura do Flutter][]

Nesse caso, o widget `Row` não restringe o
tamanho de seus filhos, nem o widget `Column`.
Sem restrições de seu widget pai, o segundo
widget `Text` tenta ser tão largo quanto todos os caracteres
que ele precisa exibir. A largura autodeterminada do
widget `Text` é então adotada pelo `Column`, que
entra em conflito com a quantidade máxima de espaço horizontal que seu pai,
o widget `Row`, pode fornecer.

[Visão geral da arquitetura do Flutter]: /resources/architectural-overview#layout-and-rendering

**Como corrigir isso?**

Bem, você precisa garantir que o `Column` não tente
ser mais largo do que pode ser. Para conseguir isso,
você precisa restringir sua largura. Uma maneira de fazer isso é
envolver o `Column` em um widget `Expanded`:

<?code-excerpt "lib/renderflex_overflow.dart (solution)"?>
```dart
return const Row(
  children: [
    Icon(Icons.message),
    Expanded(
      child: Column(
          // código omitido
          ),
    ),
  ],
);
```

Outra maneira é envolver o `Column` em um widget `Flexible`
e especificar um fator `flex`. Na verdade,
o widget `Expanded` é equivalente ao widget `Flexible`
com um fator `flex` de 1,0, como [seu código-fonte][] mostra.
Para entender melhor como usar o widget `Flex` em layouts do Flutter,
confira [este vídeo de 90 segundos Widget of the Week][flexible-video]
sobre o widget `Flexible`.

**Informações adicionais:**

Os recursos vinculados abaixo fornecem mais informações sobre esse erro.

* [Flexible (Widget da Semana do Flutter)][flexible-video]
* [Como depurar problemas de layout com o Inspetor do Flutter][medium-article]
* [Entendendo restrições][]

[seu código-fonte]: {{site.repo.flutter}}/blob/c8e42b47f5ea8b5ff7bf2f2b0a2a8e765f1aa51d/packages/flutter/lib/src/widgets/basic.dart#L5166-L5174
[flexible-video]: {{site.yt.watch}}?v=CI7x0mAZiY0
[medium-article]: {{site.flutter-medium}}/how-to-debug-layout-issues-with-the-flutter-inspector-87460a7b9db#738b
[Entendendo restrições]: /ui/layout/constraints

## 'RenderBox was not laid out'

Embora esse erro seja bastante comum,
geralmente é um efeito colateral de um erro primário
que ocorre antes no pipeline de renderização.

**Como o erro se parece?**

A mensagem mostrada pelo erro é semelhante a esta:

```plaintext
RenderBox was not laid out: 
RenderViewport#5a477 NEEDS-LAYOUT NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
```

**Como você pode se deparar com esse erro?**

Normalmente, o problema está relacionado à violação das restrições de caixa,
e precisa ser resolvido fornecendo mais informações
ao Flutter sobre como você gostaria de restringir os widgets em questão.
Você pode aprender mais sobre como as restrições funcionam
no Flutter na página [Entendendo restrições][].

O erro `RenderBox was not laid out` é frequentemente
causado por um dos dois outros erros:

* 'Vertical viewport was given unbounded height'
* 'An InputDecorator...cannot have an unbounded width'

<a id="unbounded"></a>

## 'Vertical viewport was given unbounded height'

Este é outro erro de layout comum que você pode encontrar
ao criar uma interface do usuário em seu aplicativo Flutter.

**Como o erro se parece?**

A mensagem mostrada pelo erro é semelhante a esta:

```plaintext
The following assertion was thrown during performResize():
Vertical viewport was given unbounded height.

Viewports expand in the scrolling direction to fill their container. 
In this case, a vertical viewport was given an unlimited amount of 
vertical space in which to expand. This situation typically happens when a 
scrollable widget is nested inside another scrollable widget.
(Linhas adicionais desta mensagem omitidas)
```

**Como você pode se deparar com esse erro?**

O erro é frequentemente causado quando um `ListView`
(ou outros tipos de widgets roláveis, como `GridView`)
é colocado dentro de um `Column`. Um `ListView` ocupa todo
o espaço vertical disponível para ele,
a menos que seja restringido por seu widget pai.
No entanto, um `Column` não impõe nenhuma restrição
na altura de seus filhos por padrão.
A combinação dos dois comportamentos leva à falha de
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
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Map'),
            ),
            ListTile(
              leading: Icon(Icons.subway),
              title: Text('Subway'),
            ),
          ],
        ),
      ],
    ),
  );
}
```

**Como corrigir isso?**

Para corrigir esse erro, especifique a altura que o `ListView` deve ter.
Para torná-lo tão alto quanto o espaço restante no `Column`,
envolva-o usando um widget `Expanded` (conforme mostrado no exemplo a seguir).
Caso contrário, especifique uma altura absoluta usando um `SizedBox`
widget ou uma altura relativa usando um widget `Flexible`.

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
              ListTile(
                leading: Icon(Icons.map),
                title: Text('Map'),
              ),
              ListTile(
                leading: Icon(Icons.subway),
                title: Text('Subway'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
```

**Informações adicionais:**

Os recursos vinculados abaixo fornecem
mais informações sobre esse erro.

* [Como depurar problemas de layout com o Inspetor do Flutter][medium-article]
* [Entendendo restrições][]

## 'An InputDecorator...cannot have an unbounded width'

A mensagem de erro sugere que também está relacionado
a restrições de caixa, que são importantes para entender
para evitar muitos dos erros mais comuns do framework Flutter.

**Como o erro se parece?**

A mensagem mostrada pelo erro é semelhante a esta:

```plaintext
The following assertion was thrown during performLayout():
An InputDecorator, which is typically created by a TextField, cannot have an 
unbounded width.
This happens when the parent widget does not provide a finite width constraint. 
For example, if the InputDecorator is contained by a `Row`, then its width must 
be constrained. An `Expanded` widget or a SizedBox can be used to constrain the 
width of the InputDecorator or the TextField that contains it.
(Linhas adicionais desta mensagem omitidas)
```

**Como você pode se deparar com o erro?**

Este erro ocorre, por exemplo, quando um `Row` contém um
`TextFormField` ou um `TextField`, mas o último não tem
nenhuma restrição de largura.

<?code-excerpt "lib/unbounded_width.dart (problem)"?>
```dart
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Largura Ilimitada do TextField'),
      ),
      body: const Row(
        children: [
          TextField(),
        ],
      ),
    ),
  );
}
```

**Como corrigir isso?**

Como sugerido pela mensagem de erro,
corrija esse erro restringindo o campo de texto
usando um widget `Expanded` ou `SizedBox`.
O exemplo a seguir demonstra o uso de um widget `Expanded`:

<?code-excerpt "lib/unbounded_width.dart (solution)"?>
```dart
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Largura Ilimitada do TextField'),
      ),
      body: Row(
        children: [
          Expanded(child: TextFormField()),
        ],
      ),
    ),
  );
}
```

## 'Incorrect use of ParentData widget'

Este erro é sobre a falta de um widget pai esperado.

**Como o erro se parece?**

A mensagem mostrada pelo erro é semelhante a esta:

```plaintext
The following assertion was thrown while looking for parent data:
Incorrect use of ParentDataWidget.
(Algumas linhas desta mensagem omitidas)
Usually, this indicates that at least one of the offending ParentDataWidgets 
listed above is not placed directly inside a compatible ancestor widget.
```

**Como você pode se deparar com o erro?**

Embora os widgets do Flutter sejam geralmente flexíveis
em como eles podem ser compostos juntos em uma interface do usuário,
um pequeno subconjunto desses widgets espera widgets pai específicos.
Quando essa expectativa não pode ser satisfeita em sua árvore de widgets,
é provável que você encontre este erro.

Aqui está uma lista _incompleta_ de widgets que esperam
widgets pai específicos dentro do framework Flutter.
Sinta-se à vontade para enviar um PR (usando o ícone do documento em
o canto superior direito da página) para expandir esta lista.

| Widget                                |  Widget(s) pai esperado(s) |
|:--------------------------------------|---------------------------:|
| `Flexible`                            | `Row`, `Column` ou `Flex` |
| `Expanded` (um `Flexible` especializado) | `Row`, `Column` ou `Flex` |
| `Positioned`                          |                    `Stack` |
| `TableCell`                           |                    `Table` |

**Como corrigir isso?**

A correção deve ser óbvia quando você souber
qual widget pai está faltando.

## 'setState called during build'

O método `build` em seu código Flutter não é
um bom lugar para chamar `setState`,
direta ou indiretamente.

**Como o erro se parece?**

Quando o erro ocorre,
a seguinte mensagem é exibida no console:

```plaintext
The following assertion was thrown building DialogPage(dirty, dependencies: 
[_InheritedTheme, _LocalizationsScope-[GlobalKey#59a8e]], 
state: _DialogPageState#f121e):
setState() or markNeedsBuild() called during build.

This Overlay widget cannot be marked as needing to build because the framework 
is already in the process of building widgets.
(Linhas adicionais desta mensagem omitidas)
```

**Como você pode se deparar com o erro?**

Em geral, esse erro ocorre quando o método `setState`
é chamado dentro do método `build`.

Um cenário comum em que esse erro ocorre é quando
tenta acionar um `Dialog` de dentro do
método `build`. Isso é frequentemente motivado pela necessidade de
mostrar imediatamente informações ao usuário,
mas `setState` nunca deve ser chamado de um método `build`.

O trecho a seguir parece ser um culpado comum desse erro:

<?code-excerpt "lib/set_state_build.dart (problem)"?>
```dart
Widget build(BuildContext context) {
  // Não faça isso.
  showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Alert Dialog'),
        );
      });

  return const Center(
    child: Column(
      children: <Widget>[
        Text('Mostrar Diálogo Material'),
      ],
    ),
  );
}
```

Este código não faz uma chamada explícita para `setState`,
mas é chamado por `showDialog`.
O método `build` não é o lugar certo para chamar
`showDialog` porque `build` pode ser chamado pelo
framework para cada frame, por exemplo, durante uma animação.

**Como corrigir isso?**

Uma maneira de evitar esse erro é usar a API `Navigator`
para acionar o diálogo como uma rota. No exemplo a seguir,
existem duas páginas. A segunda página tem um
diálogo a ser exibido ao entrar.
Quando o usuário solicita a segunda página por
clicando em um botão na primeira página,
o `Navigator` envia duas rotas – uma
para a segunda página e outra para o diálogo.

<?code-excerpt "lib/set_state_build.dart (solution)"?>
```dart
class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Primeira Tela'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Abrir tela'),
          onPressed: () {
            // Navegue para a segunda tela usando uma rota nomeada.
            Navigator.pushNamed(context, '/second');
            // Mostre imediatamente um diálogo ao carregar a segunda tela.
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

Este erro pode ocorrer quando vários widgets de rolagem
(como `ListView`) aparecem no
tela ao mesmo tempo. É mais provável que
este erro ocorra em um aplicativo web ou desktop,
do que em um aplicativo móvel, pois é raro encontrar
este cenário no celular.

Para obter mais informações e aprender como corrigir,
confira o seguinte vídeo sobre
[`PrimaryScrollController`][controller-video]:

{% ytEmbed '33_0ABjFJUU', 'PrimaryScrollController | Decodificando Flutter', true %}

[controller-video]: {{site.api}}/flutter/widgets/PrimaryScrollController-class.html

## Referências

Para aprender mais sobre como depurar erros,
especialmente erros de layout no Flutter,
confira os seguintes recursos:

* [Como depurar problemas de layout com o Inspetor do Flutter][medium-article]
* [Entendendo restrições][]
* [Visão geral da arquitetura do Flutter][]

[Visão geral da arquitetura do Flutter]: /resources/architectural-overview#layout-and-rendering
