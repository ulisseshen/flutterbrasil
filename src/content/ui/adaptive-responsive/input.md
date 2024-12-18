---
ia-translate: true
title: Entrada do usuário e acessibilidade
description: >-
  Um aplicativo verdadeiramente adaptável também lida com diferenças
  em como a entrada do usuário funciona e também programas
  para ajudar pessoas com problemas de acessibilidade.
---

<?code-excerpt path-base="ui/adaptive_app_demos"?>

Não é suficiente apenas adaptar a aparência do seu aplicativo,
você também precisa oferecer suporte a uma variedade de entradas do usuário.
O mouse e o teclado introduzem tipos de entrada além daqueles
encontrados em um dispositivo touch, como roda de rolagem, clique com o botão direito,
interações de _hover_, navegação por tabulação e atalhos de teclado.

Alguns desses recursos funcionam por padrão em widgets do Material.
Mas, se você criou um widget personalizado,
pode precisar implementá-los diretamente.

Alguns recursos que abrangem um aplicativo bem projetado,
também ajudam os usuários que trabalham com tecnologias assistivas.
Por exemplo, além de ser um **bom design de aplicativo**,
alguns recursos, como navegação por tabulação e atalhos de teclado,
são _críticos para usuários que trabalham com dispositivos assistivos_.
Além do conselho padrão para
[criar aplicativos acessíveis][], esta página aborda
informações para criar aplicativos que sejam adaptáveis
_e_ acessíveis.

[criar aplicativos acessíveis]: /ui/accessibility-and-internationalization/accessibility

## Roda de rolagem para widgets personalizados

Widgets de rolagem como `ScrollView` ou `ListView`
oferecem suporte à roda de rolagem por padrão e, como
quase todos os widgets personalizados roláveis são construídos
usando um desses, ele também funciona com eles.

Se você precisar implementar um comportamento de rolagem personalizado,
você pode usar o widget [`Listener`][], que permite
personalizar como sua interface reage à roda de rolagem.

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (pointer-scroll)"?>
```dart
return Listener(
  onPointerSignal: (event) {
    if (event is PointerScrollEvent) print(event.scrollDelta.dy);
  },
  child: ListView(),
);
```

[`Listener`]: {{site.api}}/flutter/widgets/Listener-class.html

## Navegação por tabulação e interações de foco

Usuários com teclados físicos esperam que possam usar
a tecla Tab para navegar rapidamente em um aplicativo,
e usuários com diferenças motoras ou de visão geralmente dependem
completamente da navegação pelo teclado.

Existem duas considerações para interações de tabulação:
como o foco se move de widget para widget, conhecido como _traversal_,
e o destaque visual exibido quando um widget está focado.

A maioria dos componentes internos, como botões e campos de texto,
oferecem suporte à _traversal_ e destaques por padrão.
Se você tiver seu próprio widget que deseja incluir na
_traversal_, você pode usar o widget [`FocusableActionDetector`][]
para criar seus próprios controles. O widget [`FocusableActionDetector`][]
é útil para combinar foco, entrada de mouse e
atalhos em um widget. Você pode criar
um detector que define ações e associações de teclas,
e fornece retornos de chamada para lidar com o foco e realces de _hover_.

<?code-excerpt "lib/pages/focus_examples_page.dart (focusable-action-detector)"?>
```dart
class _BasicActionDetectorState extends State<BasicActionDetector> {
  bool _hasFocus = false;
  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onFocusChange: (value) => setState(() => _hasFocus = value),
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<Intent>(onInvoke: (intent) {
          print('Enter ou Space foi pressionado!');
          return null;
        }),
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const FlutterLogo(size: 100),
          // Posicione o foco na margem negativa para um efeito legal
          if (_hasFocus)
            Positioned(
              left: -4,
              top: -4,
              bottom: -4,
              right: -4,
              child: _roundedBorder(),
            )
        ],
      ),
    );
  }
}
```

[`Actions`]: {{site.api}}/flutter/widgets/Actions-class.html
[`Focus`]: {{site.api}}/flutter/widgets/Focus-class.html
[`FocusableActionDetector`]: {{site.api}}/flutter/widgets/FocusableActionDetector-class.html
[`MouseRegion`]: {{site.api}}/flutter/widgets/MouseRegion-class.html
[`Shortcuts`]: {{site.api}}/flutter/widgets/Shortcuts-class.html

### Controlando a ordem da _traversal_

Para obter mais controle sobre a ordem em que os
widgets são focados quando o usuário tabula,
você pode usar [`FocusTraversalGroup`][] para definir seções
da árvore que devem ser tratadas como um grupo ao tabular.

Por exemplo, você pode tabular todos os campos em
um formulário antes de tabular para o botão de envio:

<?code-excerpt "lib/pages/focus_examples_page.dart (focus-traversal-group)"?>
```dart
return Column(children: [
  FocusTraversalGroup(
    child: MyFormWithMultipleColumnsAndRows(),
  ),
  SubmitButton(),
]);
```

O Flutter tem várias maneiras internas de percorrer widgets e grupos,
o padrão é a classe `ReadingOrderTraversalPolicy`.
Essa classe geralmente funciona bem, mas é possível modificá-la
usando outra classe `TraversalPolicy` predefinida ou criando
uma política personalizada.

[`FocusTraversalGroup`]: {{site.api}}/flutter/widgets/FocusTraversalGroup-class.html

## Aceleradores de teclado

Além da _traversal_ por tabulação, usuários de desktop e web estão acostumados
a ter vários atalhos de teclado vinculados a ações específicas.
Seja a tecla `Delete` para exclusões rápidas ou
`Control+N` para um novo documento, certifique-se de considerar os diferentes
aceleradores que seus usuários esperam. O teclado é uma ferramenta
de entrada poderosa, então tente extrair o máximo de eficiência que puder.
Seus usuários vão apreciar!

Aceleradores de teclado podem ser feitos de algumas maneiras no Flutter,
dependendo de seus objetivos.

Se você tiver um único widget como um `TextField` ou um `Button` que
já tem um nó de foco, você pode envolvê-lo em um [`KeyboardListener`][]
ou um widget [`Focus`][] e ouvir os eventos do teclado:

<?code-excerpt "lib/pages/focus_examples_page.dart (focus-keyboard-listener)"?>
```dart
  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          print(event.logicalKey);
        }
        return KeyEventResult.ignored;
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: const TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
```

Para aplicar um conjunto de atalhos de teclado a uma grande seção
da árvore, use o widget [`Shortcuts`][]:

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (shortcuts)"?>
```dart
// Defina uma classe para cada tipo de ação de atalho que você deseja
class CreateNewItemIntent extends Intent {
  const CreateNewItemIntent();
}

Widget build(BuildContext context) {
  return Shortcuts(
    // Vincule intents a combinações de teclas
    shortcuts: const <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.keyN, control: true):
          CreateNewItemIntent(),
    },
    child: Actions(
      // Vincule intents a um método real em seu código
      actions: <Type, Action<Intent>>{
        CreateNewItemIntent: CallbackAction<CreateNewItemIntent>(
          onInvoke: (intent) => _createNewItem(),
        ),
      },
      // Sua subárvore deve ser envolvida em um focusNode, para que possa receber o foco.
      child: Focus(
        autofocus: true,
        child: Container(),
      ),
    ),
  );
}
```

O widget [`Shortcuts`][] é útil porque ele apenas
permite que atalhos sejam disparados quando esta árvore de widget
ou um de seus filhos tem foco e está visível.

A última opção é um ouvinte global. Este ouvinte
pode ser usado para atalhos sempre ativos em todo o aplicativo ou para
painéis que podem aceitar atalhos sempre que estiverem visíveis
(independentemente de seu estado de foco). Adicionar ouvintes globais
é fácil com [`HardwareKeyboard`][]:

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (hardware-keyboard)"?>
```dart
@override
void initState() {
  super.initState();
  HardwareKeyboard.instance.addHandler(_handleKey);
}

@override
void dispose() {
  HardwareKeyboard.instance.removeHandler(_handleKey);
  super.dispose();
}
```

Para verificar combinações de teclas com o ouvinte global,
você pode usar o conjunto `HardwareKeyboard.instance.logicalKeysPressed`.
Por exemplo, um método como o seguinte pode verificar se alguma
das teclas fornecidas está sendo mantida pressionada:

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (keys-pressed)"?>
```dart
static bool isKeyDown(Set<LogicalKeyboardKey> keys) {
  return keys
      .intersection(HardwareKeyboard.instance.logicalKeysPressed)
      .isNotEmpty;
}
```

Juntando essas duas coisas,
você pode disparar uma ação quando `Shift+N` for pressionado:

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (handle-key)"?>
```dart
bool _handleKey(KeyEvent event) {
  bool isShiftDown = isKeyDown({
    LogicalKeyboardKey.shiftLeft,
    LogicalKeyboardKey.shiftRight,
  });

  if (isShiftDown && event.logicalKey == LogicalKeyboardKey.keyN) {
    _createNewItem();
    return true;
  }

  return false;
}
```

Uma observação de cautela ao usar o ouvinte estático,
é que você geralmente precisa desabilitá-lo quando o usuário
está digitando em um campo ou quando o widget ao qual ele está
associado está oculto da tela.
Ao contrário de `Shortcuts` ou `KeyboardListener`,
é sua responsabilidade gerenciar isso. Isso pode ser especialmente
importante quando você está vinculando um acelerador Delete/Backspace para
`Delete`, mas então tem `TextFields` filhos em que o usuário
pode estar digitando.

[`HardwareKeyboard`]: {{site.api}}/flutter/services/HardwareKeyboard-class.html
[`KeyboardListener`]: {{site.api}}/flutter/widgets/KeyboardListener-class.html

## Mouse _enter_, _exit_ e _hover_ para widgets personalizados {:#custom-widgets}

No desktop, é comum mudar o cursor do mouse
para indicar a funcionalidade sobre o conteúdo que o
mouse está pairando. Por exemplo, você normalmente vê
um cursor de mão quando você paira sobre um botão,
ou um cursor `I` quando você paira sobre o texto.

Botões do Material do Flutter lidam com estados de foco básicos
para botões padrão e cursores de texto.
(Uma exceção notável é se você alterar o estilo padrão
dos botões do Material para definir `overlayColor` como transparente.)

Implemente um estado de foco para quaisquer botões personalizados ou
detectores de gestos em seu aplicativo.
Se você alterar os estilos de botão do Material padrão,
teste os estados de foco do teclado e
implemente os seus próprios, se necessário.

Para alterar o cursor de dentro de seus widgets personalizados,
use [`MouseRegion`][]:

<?code-excerpt "lib/pages/focus_examples_page.dart (mouse-region)"?>
```dart
// Mostre o cursor de mão
return MouseRegion(
  cursor: SystemMouseCursors.click,
  // Solicite o foco quando clicado
  child: GestureDetector(
    onTap: () {
      Focus.of(context).requestFocus();
      _submit();
    },
    child: Logo(showBorder: hasFocus),
  ),
);
```

`MouseRegion` também é útil para criar
efeitos personalizados de _rollover_ e _hover_:

<?code-excerpt "lib/pages/focus_examples_page.dart (mouse-over)"?>
```dart
return MouseRegion(
  onEnter: (_) => setState(() => _isMouseOver = true),
  onExit: (_) => setState(() => _isMouseOver = false),
  onHover: (e) => print(e.localPosition),
  child: Container(
    height: 500,
    color: _isMouseOver ? Colors.blue : Colors.black,
  ),
);
```

Para um exemplo que muda o estilo do botão
para delinear o botão quando ele tem foco,
confira o [código do botão para o aplicativo Wonderous][].
O aplicativo modifica a propriedade [`FocusNode.hasFocus`][]
para verificar se o botão tem foco
e, em caso afirmativo, adiciona um contorno.

[código do botão para o aplicativo Wonderous]: {{site.github}}/gskinnerTeam/flutter-wonderous-app/blob/8a29d6709668980340b1b59c3d3588f123edd4d8/lib/ui/common/controls/buttons.dart#L143
[`FocusNode.hasFocus`]: {{site.api}}/flutter/widgets/FocusNode/hasFocus.html

## Densidade visual

Você pode considerar aumentar a "área de toque"
de um widget para acomodar uma tela sensível ao toque, por exemplo.

Diferentes dispositivos de entrada oferecem vários níveis de precisão,
o que exige áreas de toque de tamanhos diferentes.
A classe `VisualDensity` do Flutter facilita o ajuste da
densidade de suas visualizações em todo o aplicativo,
por exemplo, tornando um botão maior
(e, portanto, mais fácil de tocar) em um dispositivo touch.

Quando você altera o `VisualDensity` para
o seu `MaterialApp`, `MaterialComponents`
que o suportam, animam suas densidades para corresponder.
Por padrão, as densidades horizontal e vertical
são definidas como 0,0, mas você pode definir as densidades para qualquer
valor negativo ou positivo que desejar.
Alternando entre diferentes
densidades, você pode ajustar facilmente sua interface.

![_Scaffold_ adaptável](/assets/images/docs/ui/adaptive-responsive/adaptive_scaffold.gif){:width="100%"}

Para definir uma densidade visual personalizada,
injete a densidade no tema do seu `MaterialApp`:

<?code-excerpt "lib/main.dart (visual-density)"?>
```dart
double densityAmt = touchMode ? 0.0 : -1.0;
VisualDensity density =
    VisualDensity(horizontal: densityAmt, vertical: densityAmt);
return MaterialApp(
  theme: ThemeData(visualDensity: density),
  home: MainAppScaffold(),
  debugShowCheckedModeBanner: false,
);
```

Para usar `VisualDensity` dentro de suas próprias visualizações,
você pode procurá-lo:

<?code-excerpt "lib/pages/adaptive_reflow_page.dart (visual-density-own-view)"?>
```dart
VisualDensity density = Theme.of(context).visualDensity;
```

Não apenas o contêiner reage automaticamente às mudanças
na densidade, ele também anima quando muda.
Isso une seus componentes personalizados,
junto com os componentes internos,
para um efeito de transição suave em todo o aplicativo.

Como mostrado, `VisualDensity` não tem unidade,
então pode significar coisas diferentes para visualizações diferentes.
No exemplo a seguir, 1 unidade de densidade equivale a 6 pixels,
mas isso depende totalmente de você decidir.
O fato de não ter unidade o torna bastante versátil,
e deve funcionar na maioria dos contextos.

Vale a pena notar que o Material geralmente
usa um valor de cerca de 4 pixels lógicos para cada
unidade de densidade visual. Para mais informações sobre o
componentes suportados, consulte a API [`VisualDensity`][].
Para mais informações sobre princípios de densidade em geral,
veja o [guia Material Design][].

[guia Material Design]: {{site.material2}}/design/layout/applying-density.html#usage
[`VisualDensity`]: {{site.api}}/flutter/material/VisualDensity-class.html
