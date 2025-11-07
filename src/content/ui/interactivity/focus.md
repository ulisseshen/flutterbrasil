---
title: Compreendendo o sistema de foco de teclado do Flutter
description: Como usar o sistema de foco no seu app Flutter.
ia-translate: true
---

Este artigo explica como controlar para onde a entrada do teclado é direcionada. Se você
está implementando uma aplicação que usa um teclado físico, como a maioria das
aplicações de desktop e web, esta página é para você. Se seu app não será usado
com um teclado físico, você pode pular isto.

## Visão geral

O Flutter vem com um sistema de foco que direciona a entrada do teclado para uma
parte particular de uma aplicação. Para fazer isso, os usuários "focam" a entrada
nessa parte da aplicação tocando ou clicando no elemento de UI desejado.
Uma vez que isso acontece, o texto digitado com o teclado flui para essa parte da
aplicação até que o foco se mova para outra parte da aplicação. O foco também pode
ser movido pressionando um atalho de teclado específico, que é tipicamente
vinculado a <kbd>Tab</kbd>, então às vezes é chamado de "travessia por tab".

Esta página explora as APIs usadas para realizar essas operações em uma aplicação
Flutter, e como o sistema de foco funciona. Notamos que há alguma
confusão entre desenvolvedores sobre como definir e usar objetos [`FocusNode`][].
Se isso descreve sua experiência, pule para as [melhores práticas para
criar objetos `FocusNode`](#best-practices-for-creating-focusnode-objects).

### Casos de uso de foco

Alguns exemplos de situações em que você pode precisar saber como usar o sistema
de foco:

* [Receber/manipular eventos de tecla](#key-events)
* [Implementar um componente personalizado que precisa ser focável](#focus-widget)
* [Receber notificações quando o foco muda](#change-notifications)
* [Mudar ou definir a "ordem de tabulação" da travessia de foco em uma aplicação](#focustraversalpolicy)
* [Definir grupos de controles que devem ser atravessados juntos](#focustraversalgroup-widget)
* [Impedir que alguns controles em uma aplicação sejam focáveis](#controlling-what-gets-focus)

## Glossário

Abaixo estão termos, como o Flutter os usa, para elementos do sistema de foco. As
várias classes que implementam alguns desses conceitos são introduzidas abaixo.

* **Árvore de foco** - Uma árvore de nós de foco que tipicamente espelha esparsamente a
  árvore de widgets, representando todos os widgets que podem receber foco.
* **Nó de foco** - Um único nó em uma árvore de foco. Este nó pode receber o
  foco, e é dito que "tem foco" quando faz parte da cadeia de foco. Ele
  participa no tratamento de eventos de tecla apenas quando tem foco.
* **Foco primário** - O nó de foco mais distante da raiz da árvore de foco
  que tem foco. Este é o nó de foco onde os eventos de tecla começam a propagar para
  o nó de foco primário e seus ancestrais.
* **Cadeia de foco** - Uma lista ordenada de nós de foco que começa no nó de foco
  primário e segue os ramos da árvore de foco até a raiz da
  árvore de foco.
* **Escopo de foco** - Um nó de foco especial cujo trabalho é conter um grupo de
  outros nós de foco, e permitir que apenas esses nós recebam foco. Ele contém
  informações sobre quais nós foram previamente focados em sua subárvore.
* **Travessia de foco** - O processo de mover de um nó focável para
  outro em uma ordem previsível. Isso é tipicamente visto em aplicações quando
  o usuário pressiona <kbd>Tab</kbd> para mover para o próximo controle ou
  campo focável.

## FocusNode e FocusScopeNode

Os objetos `FocusNode` e [`FocusScopeNode`][] implementam a
mecânica do sistema de foco. Eles são objetos de longa duração (mais longos que widgets,
semelhantes a objetos de renderização) que mantêm o estado e atributos de foco para que
sejam persistentes entre construções da árvore de widgets. Juntos, eles formam
a estrutura de dados da árvore de foco.

Eles foram originalmente destinados a serem objetos voltados para desenvolvedores usados para controlar
alguns aspectos do sistema de foco, mas ao longo do tempo evoluíram para implementar principalmente
detalhes do sistema de foco. Para evitar quebrar aplicações existentes, eles ainda contêm interfaces públicas para seus atributos. Mas, em
geral, a coisa para a qual eles são mais úteis é atuar como um identificador relativamente
opaco, passado a um widget descendente para chamar `requestFocus()`
em um widget ancestral, que solicita que um widget descendente obtenha foco.
Configuração dos outros atributos é melhor gerenciada por um widget [`Focus`][] ou
[`FocusScope`][], a menos que você não esteja usando-os, ou esteja implementando sua própria
versão deles.

### Melhores práticas para criar objetos FocusNode

Alguns prós e contras sobre usar esses objetos incluem:

* Não aloque um novo `FocusNode` para cada build. Isso pode causar
  vazamentos de memória, e ocasionalmente causa uma perda de foco quando o widget
  reconstrói enquanto o nó tem foco.
* Crie objetos `FocusNode` e `FocusScopeNode` em um widget stateful.
  `FocusNode` e `FocusScopeNode` precisam ser descartados quando você terminou
  de usá-los, então eles devem ser criados apenas dentro do objeto de estado de um widget stateful,
  onde você pode sobrescrever `dispose` para descartá-los.
* Não use o mesmo `FocusNode` para múltiplos widgets. Se você fizer isso, os
  widgets lutarão pelo gerenciamento dos atributos do nó, e você
  provavelmente não obterá o que espera.
* Defina o `debugLabel` de um widget de nó de foco para ajudar no diagnóstico
  de problemas de foco.
* Não defina o callback `onKeyEvent` em um `FocusNode` ou `FocusScopeNode` se
  eles estiverem sendo gerenciados por um widget `Focus` ou `FocusScope`.
  Se você quiser um handler `onKeyEvent`, então adicione um novo widget `Focus`
  ao redor da subárvore de widgets que você gostaria de escutar, e
  defina o atributo `onKeyEvent` do widget para seu handler.
  Defina `canRequestFocus: false` no widget se
  você também não quiser que ele possa receber foco primário.
  Isso é porque o atributo `onKeyEvent` no widget `Focus` pode ser
  definido para algo diferente em uma build subsequente, e se isso acontecer,
  ele sobrescreve o handler `onKeyEvent` que você definiu no nó.
* Chame `requestFocus()` em um nó para solicitar que ele receba o
  foco primário, especialmente de um ancestral que passou um nó que possui para
  um descendente onde você quer focar.
* Use `focusNode.requestFocus()`. Não é necessário chamar
  `FocusScope.of(context).requestFocus(focusNode)`. O
  método `focusNode.requestFocus()` é equivalente e mais performático.

### Desfocar (Unfocusing)

Existe uma API para dizer a um nó para "desistir do foco", chamada
`FocusNode.unfocus()`. Embora ela remova o foco do nó, é importante
perceber que realmente não existe tal coisa como "desfocar" todos os nós. Se um
nó é desfocado, então ele deve passar o foco para outro lugar, já que há
_sempre_ um foco primário. O nó que recebe o foco quando um nó chama
`unfocus()` é ou o `FocusScopeNode` mais próximo, ou um nó previamente focado
nesse escopo, dependendo do argumento `disposition` dado a `unfocus()`.
Se você quiser mais controle sobre para onde o foco vai quando você o remove de
um nó, foque explicitamente outro nó em vez de chamar `unfocus()`, ou use o
mecanismo de travessia de foco para encontrar outro nó com os métodos `focusInDirection`,
`nextFocus`, ou `previousFocus` em `FocusNode`.

Ao chamar `unfocus()`, o argumento `disposition` permite dois modos para
desfocar: [`UnfocusDisposition.scope`][] e
`UnfocusDisposition.previouslyFocusedChild`. O padrão é `scope`, que dá
o foco ao escopo pai de foco mais próximo. Isso significa que se o foco é
posteriormente movido para o próximo nó com `FocusNode.nextFocus`, ele começa com o
item focável "primeiro" no escopo.

A disposição `previouslyFocusedChild` procurará no escopo para encontrar o
filho previamente focado e solicitará foco nele. Se não houver filho
previamente focado, é equivalente a `scope`.

:::secondary Cuidado
Se não houver outro escopo, então o foco se move para o nó de escopo raiz do
sistema de foco, `FocusManager.rootScope`. Isso geralmente não é desejável, já que
o escopo raiz não tem um `context` para o framework determinar qual
nó deve ser focado em seguida. Se você descobrir que sua aplicação perde de repente
a capacidade de navegar usando travessia de foco, isso é provavelmente o que aconteceu.
Para corrigir isso, adicione um `FocusScope` como ancestral do nó de foco que
está solicitando o unfocus. O `WidgetsApp` (do qual `MaterialApp` e
`CupertinoApp` são derivados) tem seu próprio `FocusScope`, então isso não deve ser um
problema se você estiver usando esses.
:::

## Widget Focus

O widget `Focus` possui e gerencia um nó de foco, e é o cavalo de batalha do
sistema de foco. Ele gerencia o anexo e desanexo do nó de foco que possui
da árvore de foco, gerencia os atributos e callbacks do nó de foco, e
tem funções estáticas para habilitar a descoberta de nós de foco anexados à árvore de
widgets.

Em sua forma mais simples, envolver o widget `Focus` em torno de uma subárvore de widgets permite
que essa subárvore de widgets obtenha foco como parte do processo de travessia de foco, ou
sempre que `requestFocus` é chamado no `FocusNode` passado a ele. Quando combinado
com um detector de gestos que chama `requestFocus`, pode receber foco quando
tocado ou clicado.

Você pode passar um objeto `FocusNode` ao widget `Focus` para gerenciar, mas se você
não fizer isso, ele cria o seu próprio. A principal razão para criar seu próprio
`FocusNode` é ser capaz de chamar `requestFocus()`
no nó para controlar o foco de um widget pai. A maioria das outras
funcionalidades de um `FocusNode` é melhor acessada mudando os atributos do
próprio widget `Focus`.

O widget `Focus` é usado na maioria dos próprios controles do Flutter para implementar sua
funcionalidade de foco.

Aqui está um exemplo mostrando como usar o widget `Focus` para fazer um controle
personalizado focável. Ele cria um container com texto que reage ao receber o
foco.

<?code-excerpt "ui/focus/lib/custom_control_example.dart"?>
```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String _title = 'Focus Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[MyCustomWidget(), MyCustomWidget()],
        ),
      ),
    );
  }
}

class MyCustomWidget extends StatefulWidget {
  const MyCustomWidget({super.key});

  @override
  State<MyCustomWidget> createState() => _MyCustomWidgetState();
}

class _MyCustomWidgetState extends State<MyCustomWidget> {
  Color _color = Colors.white;
  String _label = 'Unfocused';

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) {
        setState(() {
          _color = focused ? Colors.black26 : Colors.white;
          _label = focused ? 'Focused' : 'Unfocused';
        });
      },
      child: Center(
        child: Container(
          width: 300,
          height: 50,
          alignment: Alignment.center,
          color: _color,
          child: Text(_label),
        ),
      ),
    );
  }
}
```

### Eventos de tecla

Se você deseja escutar eventos de tecla em uma subárvore,
defina o atributo `onKeyEvent` do widget `Focus` para
ser um handler que apenas escuta a tecla, ou
manipula a tecla e para sua propagação para outros widgets.

Eventos de tecla começam no nó de foco com foco primário.
Se esse nó não retornar `KeyEventResult.handled` de
seu handler `onKeyEvent`, então seu nó de foco pai recebe o evento.
Se o pai não o manipular, ele vai para seu pai,
e assim por diante, até atingir a raiz da árvore de foco.
Se o evento atinge a raiz da árvore de foco sem ser manipulado, então
ele é retornado à plataforma para dar ao
próximo controle nativo na aplicação
(caso a UI do Flutter seja parte de uma UI de aplicação nativa maior).
Eventos que são manipulados não são propagados para outros widgets do Flutter,
e também não são propagados para widgets nativos.

Aqui está um exemplo de um widget `Focus` que absorve cada tecla que
sua subárvore não manipula, sem ser capaz de ser o foco primário:

<?code-excerpt "ui/focus/lib/samples.dart (absorb-keys)"?>
```dart
@override
Widget build(BuildContext context) {
  return Focus(
    onKeyEvent: (node, event) => KeyEventResult.handled,
    canRequestFocus: false,
    child: child,
  );
}
```

Eventos de tecla de foco são processados antes dos eventos de entrada de texto, então manipular um evento de tecla
quando o widget de foco envolve um campo de texto impede que essa tecla seja
digitada no campo de texto.

Aqui está um exemplo de um widget que não permitirá que a letra "a" seja digitada no
campo de texto:

<?code-excerpt "ui/focus/lib/samples.dart (no-letter-a)"?>
```dart
@override
Widget build(BuildContext context) {
  return Focus(
    onKeyEvent: (node, event) {
      return (event.logicalKey == LogicalKeyboardKey.keyA)
          ? KeyEventResult.handled
          : KeyEventResult.ignored;
    },
    child: const TextField(),
  );
}
```

Se a intenção for validação de entrada, a funcionalidade deste exemplo provavelmente
seria melhor implementada usando um `TextInputFormatter`, mas a técnica ainda pode
ser útil: o widget `Shortcuts` usa este método para manipular atalhos antes
que se tornem entrada de texto, por exemplo.

### Controlando o que obtém foco

Um dos principais aspectos do foco é controlar o que pode receber foco e como.
Os atributos `canRequestFocus`, `skipTraversal,` e `descendantsAreFocusable`
controlam como este nó e seus descendentes participam do processo de foco.

Se o atributo `skipTraversal` for true, então este nó de foco não participa
na travessia de foco. Ele ainda é focável se `requestFocus` for chamado em seu
nó de foco, mas é ignorado de outra forma quando o sistema de travessia de foco está procurando
pela próxima coisa para focar.

O atributo `canRequestFocus`, sem surpresa, controla se ou não o
nó de foco que este widget `Focus` gerencia pode ser usado para solicitar foco. Se
este atributo for false, então chamar `requestFocus` no nó não tem efeito.
Ele também implica que este nó é pulado para travessia de foco, já que não pode
solicitar foco.

O atributo `descendantsAreFocusable` controla se os descendentes deste
nó podem receber foco, mas ainda permite que este nó receba foco. Este
atributo pode ser usado para desligar a focabilidade para uma subárvore inteira de widgets.
É assim que o widget `ExcludeFocus` funciona: é apenas um widget `Focus` com
este atributo definido.

### Autofocus

Definir o atributo `autofocus` de um widget `Focus` diz ao widget para
solicitar o foco na primeira vez que o escopo de foco ao qual pertence é focado. Se
mais de um widget tiver `autofocus` definido, então é arbitrário qual
recebe o foco, então tente definir apenas em um widget por escopo de foco.

O atributo `autofocus` só tem efeito se ainda não houver foco no
escopo ao qual o nó pertence.

Definir o atributo `autofocus` em dois nós que pertencem a diferentes escopos de foco
é bem definido: cada um se torna o widget focado quando seu
escopo correspondente é focado.

### Notificações de mudança

O callback `Focus.onFocusChanged` pode ser usado para obter notificações de que o
estado de foco para um nó específico mudou. Ele notifica se o nó é adicionado
ou removido da cadeia de foco, o que significa que recebe notificações mesmo se
não for o foco primário. Se você só quer saber se recebeu o
foco primário, verifique se `hasPrimaryFocus` é true no nó de foco.

### Obtendo o FocusNode

Às vezes, é útil obter o nó de foco de um widget `Focus` para
interrogar seus atributos.

Para acessar o nó de foco de um ancestral do widget `Focus`, crie e passe
um `FocusNode` como o atributo `focusNode` do widget `Focus`. Como ele precisa
ser descartado, o nó de foco que você passa precisa ser de propriedade de um widget
stateful, então não crie um cada vez que for construído.

Se você precisa acessar o nó de foco de um descendente de um widget `Focus`,
você pode chamar `Focus.of(context)` para obter o nó de foco do widget `Focus`
mais próximo ao contexto dado. Se você precisa obter o `FocusNode` de um widget `Focus`
dentro da mesma função build, use um [`Builder`][] para garantir que você tenha
o contexto correto. Isso é mostrado no exemplo a seguir:

<?code-excerpt "ui/focus/lib/samples.dart (builder)"?>
```dart
@override
Widget build(BuildContext context) {
  return Focus(
    child: Builder(
      builder: (context) {
        final bool hasPrimary = Focus.of(context).hasPrimaryFocus;
        print('Building with primary focus: $hasPrimary');
        return const SizedBox(width: 100, height: 100);
      },
    ),
  );
}
```

### Temporização

Um dos detalhes do sistema de foco é que quando o foco é solicitado, ele só
tem efeito após a fase de build atual ser concluída. Isso significa que mudanças de foco
são sempre atrasadas em um frame, porque mudar o foco pode
causar partes arbitrárias da árvore de widgets serem reconstruídas, incluindo ancestrais do
widget atualmente solicitando foco. Como descendentes não podem sujar seus
ancestrais, isso tem que acontecer entre frames, para que quaisquer mudanças necessárias possam
acontecer no próximo frame.

## Widget FocusScope

O widget `FocusScope` é uma versão especial do widget `Focus` que gerencia
um `FocusScopeNode` em vez de um `FocusNode`. O `FocusScopeNode` é um
nó especial na árvore de foco que serve como um mecanismo de agrupamento para os nós de foco
em uma subárvore. A travessia de foco permanece dentro de um escopo de foco a menos que um nó fora
do escopo seja explicitamente focado.

O escopo de foco também mantém o controle do foco atual e histórico dos nós
focados dentro de sua subárvore. Dessa forma, se um nó libera o foco ou é removido
quando tinha foco, o foco pode ser retornado ao nó que tinha foco
anteriormente.

Escopos de foco também servem como um lugar para retornar o foco se nenhum dos descendentes
tiver foco. Isso permite que o código de travessia de foco tenha um contexto inicial para
encontrar o próximo (ou primeiro) controle focável para mover.

Se você focar um nó de escopo de foco, ele primeiro tenta focar o nó atual, ou mais
recentemente focado em sua subárvore, ou o nó em sua subárvore que solicitou
autofocus (se houver). Se não houver tal nó, ele recebe o foco.

## Widget FocusableActionDetector

O [`FocusableActionDetector`][] é um widget que combina a funcionalidade de
[`Actions`][], [`Shortcuts`][], [`MouseRegion`][] e um widget `Focus` para criar
um detector que define ações e vinculações de teclas, e fornece callbacks para
manipular destaques de foco e hover. É o que os controles do Flutter usam para
implementar todos esses aspectos dos controles. É apenas implementado usando os
widgets constituintes, então se você não precisa de toda a sua funcionalidade, você pode
usar apenas os que você precisa, mas é uma maneira conveniente de construir esses comportamentos em
seus controles personalizados.

:::note
Para saber mais, assista este curto vídeo Widget da Semana sobre
o widget `FocusableActionDetector`:

{% ytEmbed 'R84AGg0lKs8', 'FocusableActionDetector - Flutter widget of the week' %}
:::

## Controlando a travessia de foco

Uma vez que uma aplicação tem a capacidade de focar, a próxima coisa que muitos apps querem
fazer é permitir que o usuário controle o foco usando o teclado ou outro dispositivo de entrada.
O exemplo mais comum disso é a "travessia por tab" onde o usuário
pressiona <kbd>Tab</kbd> para ir para o controle "próximo". Controlar o que "próximo"
significa é o assunto desta seção. Esse tipo de travessia é fornecido pelo
Flutter por padrão.

Em um layout de grade simples, é bastante fácil decidir qual controle é o próximo. Se
você não está no final da linha, então é o da direita (ou esquerda para
locales da direita para a esquerda). Se você está no final de uma linha, é o primeiro controle
na próxima linha. Infelizmente, aplicações raramente são dispostas em grades, então
mais orientação é frequentemente necessária.

O algoritmo padrão no Flutter ([`ReadingOrderTraversalPolicy`][]) para travessia de foco
é bastante bom: Ele dá a resposta certa para a maioria das aplicações.
No entanto, sempre há casos patológicos, ou casos onde o contexto ou
design requer uma ordem diferente daquela que o algoritmo de ordenação padrão
chega. Para esses casos, existem outros mecanismos para alcançar a
ordem desejada.

### Widget FocusTraversalGroup

O widget [`FocusTraversalGroup`][] deve ser colocado na árvore ao redor de subárvores de widgets
que devem ser totalmente atravessadas antes de passar para outro widget ou
grupo de widgets. Apenas agrupar widgets em grupos relacionados é frequentemente suficiente para
resolver muitos problemas de ordenação de travessia por tab. Se não, o grupo também pode ser
dado uma [`FocusTraversalPolicy`][] para determinar a ordenação dentro do grupo.

A [`ReadingOrderTraversalPolicy`][] padrão geralmente é suficiente, mas em
casos onde mais controle sobre a ordenação é necessário, uma
[`OrderedTraversalPolicy`][] pode ser usada. O argumento `order` do
widget [`FocusTraversalOrder`][] envolvido em torno dos componentes focáveis
determina a ordem. A ordem pode ser qualquer subclasse de [`FocusOrder`][], mas
[`NumericFocusOrder`][] e [`LexicalFocusOrder`][] são fornecidos.

Se nenhuma das políticas de travessia de foco fornecidas for suficiente para sua
aplicação, você também poderia escrever sua própria política e usá-la para determinar qualquer
ordenação personalizada que você quiser.

Aqui está um exemplo de como usar o widget `FocusTraversalOrder` para atravessar uma
linha de botões na ordem DOIS, UM, TRÊS usando `NumericFocusOrder`.

<?code-excerpt "ui/focus/lib/samples.dart (ordered-button-row)"?>
```dart
class OrderedButtonRow extends StatelessWidget {
  const OrderedButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Row(
        children: <Widget>[
          const Spacer(),
          FocusTraversalOrder(
            order: const NumericFocusOrder(2),
            child: TextButton(
              child: const Text('ONE'),
              onPressed: () {},
            ),
          ),
          const Spacer(),
          FocusTraversalOrder(
            order: const NumericFocusOrder(1),
            child: TextButton(
              child: const Text('TWO'),
              onPressed: () {},
            ),
          ),
          const Spacer(),
          FocusTraversalOrder(
            order: const NumericFocusOrder(3),
            child: TextButton(
              child: const Text('THREE'),
              onPressed: () {},
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
```

### FocusTraversalPolicy

A `FocusTraversalPolicy` é o objeto que determina qual widget é o próximo,
dada uma solicitação e o nó de foco atual. As solicitações (funções membro) são
coisas como `findFirstFocus`, `findLastFocus`, `next`, `previous` e
`inDirection`.

`FocusTraversalPolicy` é a classe base abstrata para políticas concretas, como
`ReadingOrderTraversalPolicy`, `OrderedTraversalPolicy` e as
classes [`DirectionalFocusTraversalPolicyMixin`][].

Para usar uma `FocusTraversalPolicy`, você a dá a um
`FocusTraversalGroup`, que determina a subárvore de widgets na qual a política
será efetiva. As funções membro da classe raramente são chamadas diretamente:
elas são destinadas a serem usadas pelo sistema de foco.

## O gerenciador de foco

O [`FocusManager`][] mantém o foco primário atual para o sistema. Ele
só tem alguns pedaços de API que são úteis para usuários do sistema de foco. Um
é a propriedade `FocusManager.instance.primaryFocus`, que contém o
nó de foco atualmente focado e também é acessível do campo global
`primaryFocus`.

Outras propriedades úteis são `FocusManager.instance.highlightMode` e
`FocusManager.instance.highlightStrategy`. Essas são usadas por widgets que precisam
alternar entre um modo "toque" e um modo "tradicional" (mouse e teclado)
para seus destaques de foco. Quando um usuário está usando toque para navegar, o destaque de
foco geralmente é oculto, e quando eles mudam para um mouse ou teclado, o
destaque de foco precisa ser mostrado novamente para que saibam o que está focado. A
`hightlightStrategy` diz ao gerenciador de foco como interpretar mudanças no
modo de uso do dispositivo: pode tanto alternar automaticamente entre os dois
baseado nos eventos de entrada mais recentes, ou pode ser travado nos modos toque ou
tradicional. Os widgets fornecidos no Flutter já sabem como usar esta
informação, então você só precisa dela se estiver escrevendo seus próprios controles do
zero. Você pode usar o callback `addHighlightModeListener` para escutar mudanças
no modo de destaque.

[`Actions`]: {{site.api}}/flutter/widgets/Actions-class.html
[`Builder`]: {{site.api}}/flutter/widgets/Builder-class.html
[`DirectionalFocusTraversalPolicyMixin`]: {{site.api}}/flutter/widgets/DirectionalFocusTraversalPolicyMixin-mixin.html
[`Focus`]: {{site.api}}/flutter/widgets/Focus-class.html
[`FocusableActionDetector`]: {{site.api}}/flutter/widgets/FocusableActionDetector-class.html
[`FocusManager`]: {{site.api}}/flutter/widgets/FocusManager-class.html
[`FocusNode`]: {{site.api}}/flutter/widgets/FocusNode-class.html
[`FocusOrder`]: {{site.api}}/flutter/widgets/FocusOrder-class.html
[`FocusScope`]: {{site.api}}/flutter/widgets/FocusScope-class.html
[`FocusScopeNode`]: {{site.api}}/flutter/widgets/FocusScopeNode-class.html
[`FocusTraversalGroup`]: {{site.api}}/flutter/widgets/FocusTraversalGroup-class.html
[`FocusTraversalOrder`]: {{site.api}}/flutter/widgets/FocusTraversalOrder-class.html
[`FocusTraversalPolicy`]: {{site.api}}/flutter/widgets/FocusTraversalPolicy-class.html
[`LexicalFocusOrder`]: {{site.api}}/flutter/widgets/LexicalFocusOrder-class.html
[`MouseRegion`]: {{site.api}}/flutter/widgets/MouseRegion-class.html
[`NumericFocusOrder`]: {{site.api}}/flutter/widgets/NumericFocusOrder-class.html
[`OrderedTraversalPolicy`]: {{site.api}}/flutter/widgets/OrderedTraversalPolicy-class.html
[`ReadingOrderTraversalPolicy`]: {{site.api}}/flutter/widgets/ReadingOrderTraversalPolicy-class.html
[`Shortcuts`]: {{site.api}}/flutter/widgets/Shortcuts-class.html
[`UnfocusDisposition.scope`]: {{site.api}}/flutter/widgets/UnfocusDisposition.html
