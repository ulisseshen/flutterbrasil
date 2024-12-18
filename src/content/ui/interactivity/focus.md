---
ia-translate: true
title: Entendendo o sistema de foco de teclado do Flutter
description: Como usar o sistema de foco em seu aplicativo Flutter.
---

Este artigo explica como controlar para onde a entrada do teclado é direcionada.
Se você estiver implementando um aplicativo que usa um teclado físico, como a
maioria dos aplicativos para desktop e web, esta página é para você. Se seu
aplicativo não for usado com um teclado físico, você pode pular esta parte.

## Visão geral

O Flutter vem com um sistema de foco que direciona a entrada do teclado para
uma parte específica de um aplicativo. Para fazer isso, os usuários "focam" a
entrada nessa parte de um aplicativo tocando ou clicando no elemento de UI
desejado. Assim que isso acontece, o texto inserido com o teclado flui para
essa parte do aplicativo até que o foco se mova para outra parte do aplicativo.
O foco também pode ser movido pressionando um atalho de teclado específico,
que normalmente é vinculado a <kbd>Tab</kbd>, por isso às vezes é chamado de
"percurso por tabulação".

Esta página explora as APIs usadas para executar essas operações em um
aplicativo Flutter e como o sistema de foco funciona. Notamos que existe alguma
confusão entre os desenvolvedores sobre como definir e usar objetos
[`FocusNode`][]. Se isso descreve sua experiência, avance para as [melhores
práticas para criar objetos `FocusNode`](#best-practices-for-creating-focusnode-objects).

### Casos de uso do foco

Alguns exemplos de situações em que você pode precisar saber como usar o sistema
de foco:

- [Recebimento/tratamento de eventos de teclado](#key-events)
- [Implementação de um componente personalizado que precisa ser focalizável](#focus-widget)
- [Recebimento de notificações quando o foco muda](#change-notifications)
- [Alteração ou definição da "ordem de tabulação" do percurso de foco em um
  aplicativo](#focustraversalpolicy)
- [Definição de grupos de controles que devem ser percorridos juntos](#focustraversalgroup-widget)
- [Prevenção de que alguns controles em um aplicativo sejam focalizáveis](#controlling-what-gets-focus)

## Glossário

A seguir, estão os termos, conforme o Flutter os usa, para elementos do sistema
de foco. As várias classes que implementam alguns desses conceitos são
apresentadas abaixo.

-   **Árvore de foco** - Uma árvore de nós de foco que normalmente espelha
    esparsamente a árvore de widgets, representando todos os widgets que podem
    receber foco.
-   **Nó de foco** - Um único nó em uma árvore de foco. Este nó pode receber o
    foco e diz-se que "tem foco" quando faz parte da cadeia de foco. Ele
    participa do tratamento de eventos de teclado somente quando tem foco.
-   **Foco primário** - O nó de foco mais distante da raiz da árvore de foco que
    tem foco. Este é o nó de foco onde os eventos de teclado começam a se
    propagar para o nó de foco primário e seus ancestrais.
-   **Cadeia de foco** - Uma lista ordenada de nós de foco que começa no nó de
    foco primário e segue os ramos da árvore de foco até a raiz da árvore de
    foco.
-   **Escopo de foco** - Um nó de foco especial cujo trabalho é conter um grupo
    de outros nós de foco e permitir que apenas esses nós recebam foco. Ele
    contém informações sobre quais nós foram previamente focados em sua
    subárvore.
-   **Percurso de foco** - O processo de mover de um nó focalizável para outro
    em uma ordem previsível. Isso é normalmente visto em aplicativos quando o
    usuário pressiona <kbd>Tab</kbd> para passar para o próximo controle ou
    campo focalizável.

## FocusNode e FocusScopeNode

Os objetos `FocusNode` e [`FocusScopeNode`][] implementam a mecânica do
sistema de foco. São objetos de longa duração (mais longos do que os widgets,
semelhantes aos objetos de renderização) que mantêm o estado e os atributos do
foco para que sejam persistentes entre as construções da árvore de widgets.
Juntos, eles formam a estrutura de dados da árvore de foco.

Eles foram originalmente concebidos para serem objetos voltados para o
desenvolvedor, usados para controlar alguns aspectos do sistema de foco, mas com
o tempo eles evoluíram para implementar principalmente detalhes do sistema de
foco. Para evitar quebrar os aplicativos existentes, eles ainda contêm
interfaces públicas para seus atributos. Mas, em geral, a coisa para a qual
eles são mais úteis é para atuar como um manipulador relativamente opaco,
passado para um widget descendente para chamar `requestFocus()` em um widget
ancestral, que solicita que um widget descendente obtenha foco. A configuração
dos outros atributos é melhor gerenciada por um widget [`Focus`][] ou
[`FocusScope`][], a menos que você não os esteja usando ou esteja implementando
sua própria versão deles.

### Melhores práticas para criar objetos FocusNode

Alguns o que fazer e o que não fazer em torno do uso desses objetos incluem:

-   Não aloque um novo `FocusNode` para cada construção. Isso pode causar
    vazamentos de memória e, ocasionalmente, causa perda de foco quando o widget
    é reconstruído enquanto o nó tem foco.
-   Crie objetos `FocusNode` e `FocusScopeNode` em um widget com estado.
    `FocusNode` e `FocusScopeNode` precisam ser descartados quando você terminar
    de usá-los, portanto, eles só devem ser criados dentro do objeto de estado
    de um widget com estado, onde você pode substituir `dispose` para
    descartá-los.
-   Não use o mesmo `FocusNode` para vários widgets. Se você fizer isso, os
    widgets lutarão para gerenciar os atributos do nó e você provavelmente não
    obterá o que espera.
-   Defina o `debugLabel` de um widget de nó de foco para ajudar a diagnosticar
    problemas de foco.
-   Não defina o retorno de chamada `onKeyEvent` em um `FocusNode` ou
    `FocusScopeNode` se eles estiverem sendo gerenciados por um widget `Focus`
    ou `FocusScope`. Se você quiser um manipulador `onKeyEvent`, adicione um
    novo widget `Focus` ao redor da subárvore de widgets que você gostaria de
    ouvir e defina o atributo `onKeyEvent` do widget para seu manipulador.
    Defina `canRequestFocus: false` no widget se você também não quiser que ele
    seja capaz de assumir o foco primário. Isso ocorre porque o atributo
    `onKeyEvent` no widget `Focus` pode ser definido para outra coisa em uma
    construção subsequente e, se isso acontecer, ele substituirá o manipulador
    `onKeyEvent` que você definiu no nó.
-   Chame `requestFocus()` em um nó para solicitar que ele receba o foco
    primário, especialmente de um ancestral que passou um nó que ele possui para
    um descendente onde você deseja focar.
-   Use `focusNode.requestFocus()`. Não é necessário chamar
    `FocusScope.of(context).requestFocus(focusNode)`. O método
    `focusNode.requestFocus()` é equivalente e tem melhor desempenho.

### Retirar o foco

Existe uma API para dizer a um nó para "desistir do foco", chamada
`FocusNode.unfocus()`. Embora ele remova o foco do nó, é importante perceber
que realmente não existe algo como "retirar o foco" de todos os nós. Se um nó
estiver sem foco, ele deve passar o foco para outro lugar, pois existe
_sempre_ um foco primário. O nó que recebe o foco quando um nó chama
`unfocus()` é o `FocusScopeNode` mais próximo ou um nó previamente focado
nesse escopo, dependendo do argumento `disposition` fornecido para
`unfocus()`. Se você quiser mais controle sobre para onde o foco vai quando o
remove de um nó, foque explicitamente em outro nó em vez de chamar `unfocus()`,
ou use o mecanismo de percurso de foco para encontrar outro nó com os métodos
`focusInDirection`, `nextFocus` ou `previousFocus` em `FocusNode`.

Ao chamar `unfocus()`, o argumento `disposition` permite dois modos para
retirar o foco: [`UnfocusDisposition.scope`][] e
`UnfocusDisposition.previouslyFocusedChild`. O padrão é `scope`, que dá o foco
para o escopo de foco pai mais próximo. Isso significa que, se o foco for
movido posteriormente para o próximo nó com `FocusNode.nextFocus`, ele começa
com o "primeiro" item focalizável no escopo.

A disposição `previouslyFocusedChild` pesquisará o escopo para encontrar o
filho previamente focado e solicitará o foco nele. Se não houver um filho
previamente focado, é equivalente a `scope`.

:::secondary Cuidado
Se não houver outro escopo, o foco passa para o nó de escopo raiz do sistema
de foco, `FocusManager.rootScope`. Isso geralmente não é desejável, pois o
escopo raiz não tem um `context` para a estrutura determinar qual nó deve ser
focado em seguida. Se você descobrir que seu aplicativo de repente perde a
capacidade de navegar usando o percurso de foco, é provável que seja isso que
aconteceu. Para corrigir isso, adicione um `FocusScope` como um ancestral ao
nó de foco que está solicitando a remoção do foco. O `WidgetsApp` (do qual
`MaterialApp` e `CupertinoApp` são derivados) tem seu próprio `FocusScope`,
portanto, isso não deve ser um problema se você estiver usando esses.
:::

## Widget de foco

O widget `Focus` possui e gerencia um nó de foco e é o carro-chefe do sistema de
foco. Ele gerencia a anexação e desanexação do nó de foco que ele possui da
árvore de foco, gerencia os atributos e retornos de chamada do nó de foco e tem
funções estáticas para permitir a descoberta de nós de foco anexados à árvore de
widgets.

Em sua forma mais simples, envolver o widget `Focus` em torno de uma subárvore
de widgets permite que essa subárvore de widgets obtenha foco como parte do
processo de percurso de foco ou sempre que `requestFocus` for chamado no
`FocusNode` passado para ele. Quando combinado com um detector de gestos que
chama `requestFocus`, ele pode receber foco quando tocado ou clicado.

Você pode passar um objeto `FocusNode` para o widget `Focus` para gerenciar,
mas se não o fizer, ele cria o seu próprio. O principal motivo para criar seu
próprio `FocusNode` é poder chamar `requestFocus()` no nó para controlar o foco
de um widget pai. A maioria das outras funcionalidades de um `FocusNode` é
melhor acessada alterando os atributos do próprio widget `Focus`.

O widget `Focus` é usado na maioria dos próprios controles do Flutter para
implementar sua funcionalidade de foco.

Aqui está um exemplo mostrando como usar o widget `Focus` para tornar um
controle personalizado focalizável. Ele cria um contêiner com texto que reage ao
receber o foco.

<?code-excerpt "ui/advanced/focus/lib/custom_control_example.dart"?>
```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String _title = 'Exemplo de foco';

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
  String _label = 'Sem foco';

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) {
        setState(() {
          _color = focused ? Colors.black26 : Colors.white;
          _label = focused ? 'Com foco' : 'Sem foco';
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

### Eventos de teclado

Se você deseja ouvir eventos de teclado em uma subárvore, defina o atributo
`onKeyEvent` do widget `Focus` para ser um manipulador que apenas escuta a
tecla ou manipula a tecla e interrompe sua propagação para outros widgets.

Os eventos de teclado começam no nó de foco com foco primário. Se esse nó não
retornar `KeyEventResult.handled` de seu manipulador `onKeyEvent`, então seu nó
de foco pai recebe o evento. Se o pai não o manipular, ele passa para seu pai e
assim por diante, até atingir a raiz da árvore de foco. Se o evento atingir a
raiz da árvore de foco sem ser manipulado, ele é retornado à plataforma para dar
ao próximo controle nativo no aplicativo (caso a interface do usuário do Flutter
faça parte de uma interface de usuário nativa maior do aplicativo). Os eventos
que são manipulados não são propagados para outros widgets Flutter e também não
são propagados para widgets nativos.

Aqui está um exemplo de um widget `Focus` que absorve todas as teclas que sua
subárvore não manipula, sem poder ser o foco primário:

<?code-excerpt "ui/advanced/focus/lib/samples.dart (absorb-keys)"?>
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

Os eventos de tecla de foco são processados antes dos eventos de entrada de
texto, portanto, manipular um evento de tecla quando o widget de foco envolve
um campo de texto impede que essa tecla seja inserida no campo de texto.

Aqui está um exemplo de um widget que não permitirá que a letra "a" seja
digitada no campo de texto:

<?code-excerpt "ui/advanced/focus/lib/samples.dart (no-letter-a)"?>
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

Se a intenção for a validação da entrada, a funcionalidade deste exemplo
provavelmente seria melhor implementada usando um `TextInputFormatter`, mas a
técnica ainda pode ser útil: o widget `Shortcuts` usa este método para
manipular atalhos antes que eles se tornem entrada de texto, por exemplo.

### Controlando o que recebe o foco

Um dos principais aspectos do foco é controlar o que pode receber o foco e como.
Os atributos `canRequestFocus`, `skipTraversal` e
`descendantsAreFocusable` controlam como este nó e seus descendentes
participam do processo de foco.

Se o atributo `skipTraversal` for verdadeiro, este nó de foco não participa do
percurso de foco. Ele ainda é focalizável se `requestFocus` for chamado em seu
nó de foco, mas caso contrário é ignorado quando o sistema de percurso de foco
está procurando a próxima coisa para focar.

O atributo `canRequestFocus`, sem surpresa, controla se o nó de foco que este
widget `Focus` gerencia pode ser usado para solicitar o foco. Se esse atributo
for falso, chamar `requestFocus` no nó não terá efeito. Também implica que
este nó é ignorado para o percurso de foco, pois não pode solicitar o foco.

O atributo `descendantsAreFocusable` controla se os descendentes deste nó podem
receber foco, mas ainda permite que este nó receba foco. Este atributo pode ser
usado para desativar a focalização para toda uma subárvore de widgets. É assim
que o widget `ExcludeFocus` funciona: é apenas um widget `Focus` com este
atributo definido.

### Foco automático

Definir o atributo `autofocus` de um widget `Focus` diz ao widget para
solicitar o foco na primeira vez que o escopo de foco ao qual ele pertence é
focado. Se mais de um widget tiver `autofocus` definido, é arbitrário qual
deles recebe o foco, portanto, tente defini-lo em apenas um widget por escopo de
foco.

O atributo `autofocus` só entra em vigor se já não houver um foco no escopo ao
qual o nó pertence.

Definir o atributo `autofocus` em dois nós que pertencem a escopos de foco
diferentes está bem definido: cada um se torna o widget focado quando seus
respectivos escopos são focados.

### Notificações de alteração

O retorno de chamada `Focus.onFocusChanged` pode ser usado para obter
notificações de que o estado de foco para um nó específico mudou. Ele notifica
se o nó é adicionado ou removido da cadeia de foco, o que significa que ele
recebe notificações mesmo que não seja o foco primário. Se você quiser saber
apenas se recebeu o foco primário, verifique se `hasPrimaryFocus` é verdadeiro
no nó de foco.

### Obtendo o FocusNode

Às vezes, é útil obter o nó de foco de um widget `Focus` para consultar seus
atributos.

Para acessar o nó de foco de um ancestral do widget `Focus`, crie e passe um
`FocusNode` como o atributo `focusNode` do widget `Focus`. Como ele precisa ser
descartado, o nó de foco que você passa precisa ser propriedade de um widget com
estado, portanto, não crie um cada vez que ele é construído.

Se você precisar de acesso ao nó de foco do descendente de um widget `Focus`,
você pode chamar `Focus.of(context)` para obter o nó de foco do `Focus` mais
próximo ao contexto fornecido. Se você precisar obter o `FocusNode` de um widget
`Focus` dentro da mesma função de construção, use um [`Builder`][] para
garantir que você tenha o contexto correto. Isso é mostrado no exemplo a
seguir:

<?code-excerpt "ui/advanced/focus/lib/samples.dart (builder)"?>
```dart
@override
Widget build(BuildContext context) {
  return Focus(
    child: Builder(
      builder: (context) {
        final bool hasPrimary = Focus.of(context).hasPrimaryFocus;
        print('Construindo com foco primário: $hasPrimary');
        return const SizedBox(width: 100, height: 100);
      },
    ),
  );
}
```

### Temporização

Um dos detalhes do sistema de foco é que, quando o foco é solicitado, ele só
entra em vigor após a conclusão da fase de construção atual. Isso significa que
as mudanças de foco são sempre atrasadas em um quadro, porque mudar o foco pode
fazer com que partes arbitrárias da árvore de widgets sejam reconstruídas,
incluindo os ancestrais do widget que está solicitando o foco. Como os
descendentes não podem sujar seus ancestrais, isso precisa acontecer entre os
quadros, para que quaisquer alterações necessárias possam acontecer no próximo
quadro.

## Widget FocusScope

O widget `FocusScope` é uma versão especial do widget `Focus` que gerencia um
`FocusScopeNode` em vez de um `FocusNode`. O `FocusScopeNode` é um nó especial
na árvore de foco que serve como um mecanismo de agrupamento para os nós de
foco em uma subárvore. O percurso de foco permanece dentro de um escopo de foco,
a menos que um nó fora do escopo seja explicitamente focado.

O escopo de foco também mantém o controle do foco atual e do histórico dos nós
focados dentro de sua subárvore. Dessa forma, se um nó liberar o foco ou for
removido quando tinha o foco, o foco pode ser retornado ao nó que tinha o foco
anteriormente.

Os escopos de foco também servem como um lugar para retornar o foco se nenhum
dos descendentes tiver foco. Isso permite que o código de percurso de foco
tenha um contexto inicial para encontrar o próximo (ou primeiro) controle
focalizável para passar.

Se você focar um nó de escopo de foco, ele primeiro tenta focar o nó atual ou
mais recentemente focado em sua subárvore, ou o nó em sua subárvore que
solicitou o foco automático (se houver). Se não houver esse nó, ele recebe o
próprio foco.

## Widget FocusableActionDetector

O [`FocusableActionDetector`][] é um widget que combina a funcionalidade de
[`Actions`][], [`Shortcuts`][], [`MouseRegion`][] e um widget `Focus` para
criar um detector que define ações e ligações de teclas e fornece retornos de
chamada para manipular os destaques de foco e passagem do mouse. É o que os
controles do Flutter usam para implementar todos esses aspectos dos controles.
Ele é apenas implementado usando os widgets constituintes, portanto, se você
não precisar de toda a sua funcionalidade, você pode apenas usar aqueles que
precisa, mas é uma maneira conveniente de construir esses comportamentos em seus
controles personalizados.

:::note
Para saber mais, assista a este curto vídeo Widget da Semana sobre o widget
`FocusableActionDetector`:

{% ytEmbed 'R84AGg0lKs8', 'FocusableActionDetector - Widget da semana do Flutter' %}
:::

## Controlando o percurso de foco

Depois que um aplicativo tem a capacidade de focar, a próxima coisa que muitos
aplicativos desejam fazer é permitir que o usuário controle o foco usando o
teclado ou outro dispositivo de entrada. O exemplo mais comum disso é o "percurso
de tabulação", onde o usuário pressiona <kbd>Tab</kbd> para ir para o "próximo"
controle. Controlar o que "próximo" significa é o assunto desta seção. Esse
tipo de percurso é fornecido pelo Flutter por padrão.

Em um layout de grade simples, é bastante fácil decidir qual controle é o
próximo. Se você não estiver no final da linha, então é aquele à direita (ou à
esquerda para locais da direita para a esquerda). Se você estiver no final de
uma linha, é o primeiro controle da próxima linha. Infelizmente, os aplicativos
raramente são dispostos em grades, portanto, mais orientação é frequentemente
necessária.

O algoritmo padrão no Flutter ([`ReadingOrderTraversalPolicy`][]) para o
percurso de foco é muito bom: ele dá a resposta certa para a maioria dos
aplicativos. No entanto, existem sempre casos patológicos ou casos em que o
contexto ou o design exigem uma ordem diferente daquela que o algoritmo de
ordenação padrão chega. Para esses casos, existem outros mecanismos para
atingir a ordem desejada.

### Widget FocusTraversalGroup

O widget [`FocusTraversalGroup`][] deve ser colocado na árvore em torno de
subárvores de widgets que devem ser totalmente percorridas antes de passar para
outro widget ou grupo de widgets. Apenas agrupar widgets em grupos
relacionados costuma ser suficiente para resolver muitos problemas de ordenação
de percurso de tabulação. Caso contrário, o grupo também pode receber uma
[`FocusTraversalPolicy`][] para determinar a ordem dentro do grupo.

A [`ReadingOrderTraversalPolicy`][] padrão geralmente é suficiente, mas nos
casos em que é necessário mais controle sobre a ordenação, uma
[`OrderedTraversalPolicy`][] pode ser usada. O argumento `order` do widget
[`FocusTraversalOrder`][] envolvido nos componentes focalizáveis determina a
ordem. A ordem pode ser qualquer subclasse de [`FocusOrder`][], mas
[`NumericFocusOrder`][] e [`LexicalFocusOrder`][] são fornecidas.

Se nenhuma das políticas de percurso de foco fornecidas for suficiente para seu
aplicativo, você também pode escrever sua própria política e usá-la para
determinar qualquer ordenação personalizada que desejar.

Aqui está um exemplo de como usar o widget `FocusTraversalOrder` para percorrer
uma linha de botões na ordem DOIS, UM, TRÊS usando `NumericFocusOrder`.

<?code-excerpt "ui/advanced/focus/lib/samples.dart (ordered-button-row)"?>
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
              child: const Text('UM'),
              onPressed: () {},
            ),
          ),
          const Spacer(),
          FocusTraversalOrder(
            order: const NumericFocusOrder(1),
            child: TextButton(
              child: const Text('DOIS'),
              onPressed: () {},
            ),
          ),
          const Spacer(),
          FocusTraversalOrder(
            order: const NumericFocusOrder(3),
            child: TextButton(
              child: const Text('TRÊS'),
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

A `FocusTraversalPolicy` é o objeto que determina qual widget é o próximo, dada
uma solicitação e o nó de foco atual. As solicitações (funções membro) são
coisas como `findFirstFocus`, `findLastFocus`, `next`, `previous` e
`inDirection`.

`FocusTraversalPolicy` é a classe base abstrata para políticas concretas, como
`ReadingOrderTraversalPolicy`, `OrderedTraversalPolicy` e as classes
[`DirectionalFocusTraversalPolicyMixin`][].

Para usar um `FocusTraversalPolicy`, você fornece um para um
`FocusTraversalGroup`, que determina a subárvore de widgets em que a política
será eficaz. As funções membro da classe raramente são chamadas diretamente:
elas devem ser usadas pelo sistema de foco.

## O gerenciador de foco

O [`FocusManager`][] mantém o foco primário atual para o sistema. Ele tem
apenas algumas partes da API que são úteis para os usuários do sistema de
foco. Uma é a propriedade `FocusManager.instance.primaryFocus`, que contém o nó
de foco atualmente focado e também é acessível do campo global `primaryFocus`.

Outras propriedades úteis são `FocusManager.instance.highlightMode` e
`FocusManager.instance.highlightStrategy`. Eles são usados por widgets que
precisam alternar entre um modo "touch" e um modo "tradicional" (mouse e
teclado) para seus destaques de foco. Quando um usuário está usando o toque
para navegar, o destaque do foco geralmente fica oculto e, quando ele alterna
para um mouse ou teclado, o destaque do foco precisa ser mostrado novamente
para que ele saiba o que está focado. A `hightlightStrategy` informa ao
gerenciador de foco como interpretar as mudanças no modo de uso do dispositivo:
ele pode alternar automaticamente entre os dois com base nos eventos de entrada
mais recentes ou pode ser bloqueado nos modos touch ou tradicional. Os widgets
fornecidos no Flutter já sabem como usar essas informações, então você só
precisa delas se estiver escrevendo seus próprios controles do zero. Você pode
usar o retorno de chamada `addHighlightModeListener` para ouvir as mudanças no
modo de destaque.

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
