---
ia-translate: true
title: Entrada do usuário e acessibilidade
description: >-
  Um app verdadeiramente adaptativo também lida com diferenças
  em como a entrada do usuário funciona e também programas
  para ajudar pessoas com problemas de acessibilidade.
---

<?code-excerpt path-base="ui/adaptive_app_demos"?>

Não é suficiente apenas adaptar como seu app parece,
você também precisa suportar uma variedade de entradas de usuário.
O mouse e o teclado introduzem tipos de entrada além daqueles
encontrados em um dispositivo de toque, como roda de rolagem, clique direito,
interações de hover, travessia por tab e atalhos de teclado.

Alguns desses recursos funcionam por padrão em widgets
Material. Mas, se você criou um widget customizado,
pode precisar implementá-los diretamente.

Alguns recursos que abrangem um app bem projetado
também ajudam usuários que trabalham com tecnologias assistivas.
Por exemplo, além de ser **bom design de app**,
alguns recursos, como travessia por tab e atalhos de teclado,
são _críticos para usuários que trabalham com dispositivos assistivos_.
Além do conselho padrão para
[criar apps acessíveis][creating accessible apps], esta página cobre
informações para criar apps que são tanto
adaptativos _quanto_ acessíveis.

[creating accessible apps]: /ui/accessibility-and-internationalization/accessibility

## Roda de rolagem para widgets customizados

Widgets de rolagem como `ScrollView` ou `ListView`
suportam a roda de rolagem por padrão, e porque
quase todo widget de rolagem customizado é construído
usando um desses, funciona com eles também.

Se você precisa implementar comportamento de rolagem customizado,
você pode usar o widget [`Listener`][], que permite
customizar como sua UI reage à roda de rolagem.

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

## Travessia por tab e interações de foco

Usuários com teclados físicos esperam que possam usar
a tecla tab para navegar rapidamente em uma aplicação,
e usuários com diferenças motoras ou de visão frequentemente dependem
completamente da navegação por teclado.

Existem duas considerações para interações de tab:
como o foco se move de widget para widget, conhecido como travessia,
e o destaque visual mostrado quando um widget está focado.

A maioria dos componentes integrados, como botões e campos de texto,
suportam travessia e destaques por padrão.
Se você tem seu próprio widget que deseja incluir na
travessia, você pode usar o widget [`FocusableActionDetector`][]
para criar seus próprios controles. O [`FocusableActionDetector`][]
é útil para combinar foco, entrada de mouse
e atalhos juntos em um widget. Você pode criar
um detector que define ações e vinculações de teclas,
e fornece callbacks para lidar com destaques de foco e hover.

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
          print('Enter or Space was pressed!');
          return null;
        }),
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const FlutterLogo(size: 100),
          // Position focus in the negative margin for a cool effect
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

### Controlando a ordem de travessia

Para ter mais controle sobre a ordem em que
widgets são focados quando o usuário usa tab,
você pode usar [`FocusTraversalGroup`][] para definir seções
da árvore que devem ser tratadas como um grupo ao usar tab.

Por exemplo, você pode querer percorrer todos os campos em
um formulário antes de usar tab no botão de envio:

<?code-excerpt "lib/pages/focus_examples_page.dart (focus-traversal-group)"?>
```dart
return Column(children: [
  FocusTraversalGroup(
    child: MyFormWithMultipleColumnsAndRows(),
  ),
  SubmitButton(),
]);
```

O Flutter tem várias maneiras integradas de percorrer widgets e grupos,
padrão para a classe `ReadingOrderTraversalPolicy`.
Esta classe geralmente funciona bem, mas é possível modificar isso
usando outra classe `TraversalPolicy` predefinida ou criando
uma política customizada.

[`FocusTraversalGroup`]: {{site.api}}/flutter/widgets/FocusTraversalGroup-class.html

## Aceleradores de teclado

Além da travessia por tab, usuários de desktop e web estão acostumados
a ter vários atalhos de teclado vinculados a ações específicas.
Seja a tecla `Delete` para exclusões rápidas ou
`Control+N` para um novo documento, certifique-se de considerar os diferentes
aceleradores que seus usuários esperam. O teclado é uma ferramenta
de entrada poderosa, então tente extrair o máximo de eficiência dele.
Seus usuários vão agradecer!

Aceleradores de teclado podem ser realizados de algumas maneiras no Flutter,
dependendo de seus objetivos.

Se você tem um único widget como um `TextField` ou um `Button` que
já tem um nó de foco, você pode envolvê-lo em um [`KeyboardListener`][]
ou um widget [`Focus`][] e ouvir eventos de teclado:

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
// Define a class for each type of shortcut action you want
class CreateNewItemIntent extends Intent {
  const CreateNewItemIntent();
}

Widget build(BuildContext context) {
  return Shortcuts(
    // Bind intents to key combinations
    shortcuts: const <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.keyN, control: true):
          CreateNewItemIntent(),
    },
    child: Actions(
      // Bind intents to an actual method in your code
      actions: <Type, Action<Intent>>{
        CreateNewItemIntent: CallbackAction<CreateNewItemIntent>(
          onInvoke: (intent) => _createNewItem(),
        ),
      },
      // Your sub-tree must be wrapped in a focusNode, so it can take focus.
      child: Focus(
        autofocus: true,
        child: Container(),
      ),
    ),
  );
}
```

O widget [`Shortcuts`][] é útil porque só
permite que atalhos sejam disparados quando esta árvore de widgets
ou um de seus filhos tem foco e está visível.

A opção final é um listener global. Este listener
pode ser usado para atalhos sempre ativos, em todo o app ou para
painéis que podem aceitar atalhos sempre que estiverem visíveis
(independentemente de seu estado de foco). Adicionar listeners globais
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

Para verificar combinações de teclas com o listener global,
você pode usar o conjunto `HardwareKeyboard.instance.logicalKeysPressed`.
Por exemplo, um método como o seguinte pode verificar se alguma
das teclas fornecidas está sendo pressionada:

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (keys-pressed)"?>
```dart
static bool isKeyDown(Set<LogicalKeyboardKey> keys) {
  return keys
      .intersection(HardwareKeyboard.instance.logicalKeysPressed)
      .isNotEmpty;
}
```

Juntando essas duas coisas,
você pode disparar uma ação quando `Shift+N` é pressionado:

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

Uma nota de cautela ao usar o listener estático,
é que você frequentemente precisa desabilitá-lo quando o usuário
está digitando em um campo ou quando o widget associado
está oculto da visualização.
Ao contrário de `Shortcuts` ou `KeyboardListener`,
isso é sua responsabilidade gerenciar. Isso pode ser especialmente
importante quando você está vinculando um acelerador Delete/Backspace para
`Delete`, mas então tem `TextFields` filhos nos quais o usuário
pode estar digitando.

[`HardwareKeyboard`]: {{site.api}}/flutter/services/HardwareKeyboard-class.html
[`KeyboardListener`]: {{site.api}}/flutter/widgets/KeyboardListener-class.html

## Mouse enter, exit e hover para widgets customizados {#custom-widgets}

No desktop, é comum mudar o cursor do mouse
para indicar a funcionalidade sobre o conteúdo sobre o qual
o mouse está pairando. Por exemplo, você normalmente vê
um cursor de mão quando paira sobre um botão,
ou um cursor `I` quando paira sobre texto.

Os botões Material do Flutter lidam com estados de foco básicos
para cursores de botão e texto padrão.
(Uma exceção notável é se você mudar o estilo padrão
dos botões Material para definir o `overlayColor` como transparente.)

Implemente um estado de foco para quaisquer botões customizados ou
detectores de gestos em seu app.
Se você mudar os estilos padrão dos botões Material,
teste para estados de foco de teclado e
implemente o seu próprio, se necessário.

Para mudar o cursor de dentro de seus widgets customizados,
use [`MouseRegion`][]:

<?code-excerpt "lib/pages/focus_examples_page.dart (mouse-region)"?>
```dart
// Show hand cursor
return MouseRegion(
  cursor: SystemMouseCursors.click,
  // Request focus when clicked
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
efeitos de rollover e hover customizados:

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
confira o [código do botão para o app Wonderous][button code for the Wonderous app].
O app modifica a propriedade [`FocusNode.hasFocus`][]
para verificar se o botão tem foco
e, se sim, adiciona um contorno.

[button code for the Wonderous app]: {{site.github}}/gskinnerTeam/flutter-wonderous-app/blob/8a29d6709668980340b1b59c3d3588f123edd4d8/lib/ui/common/controls/buttons.dart#L143
[`FocusNode.hasFocus`]: {{site.api}}/flutter/widgets/FocusNode/hasFocus.html

## Densidade visual

Você pode considerar aumentar a "área de toque"
de um widget para acomodar uma tela sensível ao toque, por exemplo.

Diferentes dispositivos de entrada oferecem vários níveis de precisão,
o que requer áreas de toque de tamanhos diferentes.
A classe `VisualDensity` do Flutter facilita ajustar a
densidade de suas visualizações em toda a aplicação,
por exemplo, tornando um botão maior
(e, portanto, mais fácil de tocar) em um dispositivo de toque.

Quando você muda a `VisualDensity` para
seu `MaterialApp`, `MaterialComponents`
que o suportam animam suas densidades para corresponder.
Por padrão, ambas as densidades horizontal e vertical
são definidas como 0.0, mas você pode definir as densidades para qualquer
valor negativo ou positivo que quiser.
Ao alternar entre diferentes
densidades, você pode ajustar facilmente sua UI.

![Adaptive scaffold](/assets/images/docs/ui/adaptive-responsive/adaptive_scaffold.gif){:width="100%"}

Para definir uma densidade visual customizada,
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
você pode consultá-la:

<?code-excerpt "lib/pages/adaptive_reflow_page.dart (visual-density-own-view)"?>
```dart
VisualDensity density = Theme.of(context).visualDensity;
```

Não apenas o container reage automaticamente a mudanças
na densidade, ele também anima quando muda.
Isso une seus componentes customizados,
junto com os componentes integrados,
para um efeito de transição suave em todo o app.

Como mostrado, `VisualDensity` é sem unidade,
então pode significar coisas diferentes para diferentes visualizações.
No exemplo a seguir, 1 unidade de densidade equivale a 6 pixels,
mas isso é totalmente você quem decide.
O fato de ser sem unidade torna bastante versátil,
e deve funcionar na maioria dos contextos.

Vale notar que o Material geralmente
usa um valor de cerca de 4 pixels lógicos para cada
unidade de densidade visual. Para mais informações sobre os
componentes suportados, consulte a API [`VisualDensity`][].
Para mais informações sobre princípios de densidade em geral,
consulte o [guia Material Design][Material Design guide].

[Material Design guide]: {{site.material2}}/design/layout/applying-density.html#usage
[`VisualDensity`]: {{site.api}}/flutter/material/VisualDensity-class.html
