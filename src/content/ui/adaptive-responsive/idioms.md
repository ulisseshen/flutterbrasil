---
ia-translate: true
title: Idiomas de plataforma
description: >-
  Aprenda como criar um app responsivo
  que responde a mudanças no tamanho da tela.
shortTitle: Idiomas
---

<?code-excerpt path-base="ui/adaptive_app_demos"?>

A área final a considerar para apps adaptativos são os padrões de plataforma.
Cada plataforma tem seus próprios idiomas e normas;
esses padrões nominais ou de fato informam as expectativas do usuário
de como uma aplicação deve se comportar. Graças, em parte à web,
os usuários estão acostumados a experiências mais customizadas,
mas refletir esses padrões de plataforma ainda pode fornecer
benefícios significativos:

* **Reduzir a carga cognitiva**
: Ao corresponder ao modelo mental existente do usuário,
  realizar tarefas se torna intuitivo,
  o que requer menos pensamento,
  aumenta a produtividade e reduz frustrações.

* **Construir confiança**
: Os usuários podem ficar cautelosos ou suspeitos
  quando aplicações não aderem às suas expectativas.
  Por outro lado, uma UI que parece familiar pode construir confiança do usuário
  e pode ajudar a melhorar a percepção de qualidade.
  Isso frequentemente tem o benefício adicional de melhores classificações
  na loja de apps—algo que todos podemos apreciar!

## Considere o comportamento esperado em cada plataforma

O primeiro passo é dedicar algum tempo considerando qual é
a aparência, apresentação,
ou comportamento esperado nesta plataforma.
Tente esquecer quaisquer limitações da sua implementação atual,
e apenas visualize a experiência ideal do usuário.
Trabalhe de trás para frente a partir daí.

Outra maneira de pensar sobre isso é perguntar,
"Como um usuário desta plataforma esperaria alcançar este objetivo?"
Então, tente visualizar como isso funcionaria em seu app
sem quaisquer compromissos.

Isso pode ser difícil se você não é um usuário regular da plataforma.
Você pode não estar ciente dos idiomas específicos e pode facilmente perdê-los
completamente. Por exemplo, um usuário de Android de longa data é
provavelmente inconsciente das convenções de plataforma no iOS,
e o mesmo vale para macOS, Linux e Windows.
Essas diferenças podem ser sutis para você,
mas serem dolorosamente óbvias para um usuário experiente.

### Encontre um defensor da plataforma

Se possível, designe alguém como defensor de cada plataforma.
Idealmente, seu defensor usa a plataforma como seu dispositivo principal,
e pode oferecer a perspectiva de um usuário altamente opinativo.
Para reduzir o número de pessoas, combine papéis.
Tenha um defensor para Windows e Android,
um para Linux e web, e um para Mac e iOS.

O objetivo é ter feedback constante e informado para que o app
se sinta ótimo em cada plataforma. Os defensores devem ser encorajados
a serem bastante exigentes, apontando qualquer coisa que sintam que difere de
aplicações típicas em seu dispositivo. Um exemplo simples é como
o botão padrão em um dialog é tipicamente à esquerda no Mac
e Linux, mas está à direita no Windows.
Detalhes como esse são fáceis de perder se você não está usando uma plataforma
regularmente.

:::secondary Importante
Os defensores não precisam ser desenvolvedores ou
mesmo membros de tempo integral da equipe. Eles podem ser designers,
stakeholders, ou testadores externos que recebem
builds regulares.
:::

### Permaneça único

Conformar-se aos comportamentos esperados não significa que seu app
precisa usar componentes ou estilos padrão.
Muitos dos apps multiplataforma mais populares têm UIs muito distintas
e opinativas, incluindo botões customizados, menus de contexto,
e barras de título.

Quanto mais você puder consolidar estilo e comportamento entre plataformas,
mais fácil será o desenvolvimento e teste.
O truque é equilibrar a criação de uma experiência única com uma
identidade forte, enquanto respeita as normas de cada plataforma.

## Idiomas e normas comuns a considerar

Dê uma olhada rápida em algumas normas e idiomas específicos
que você pode querer considerar, e como você poderia abordá-los
no Flutter.

### Aparência e comportamento da scrollbar

Usuários de desktop e mobile esperam scrollbars,
mas esperam que elas se comportem de maneira diferente em diferentes plataformas.
Usuários móveis esperam scrollbars menores que aparecem apenas
enquanto rolam, enquanto usuários de desktop geralmente esperam
scrollbars onipresentes e maiores que podem clicar ou arrastar.

Flutter vem com um widget `Scrollbar` integrado que já
tem suporte para cores e tamanhos adaptativos de acordo com a
plataforma atual. O único ajuste que você pode querer fazer é
alternar `alwaysShown` quando em uma plataforma desktop:

<?code-excerpt "lib/pages/adaptive_grid_page.dart (scrollbar-always-shown)"?>
```dart
return Scrollbar(
  thumbVisibility: DeviceType.isDesktop,
  controller: _scrollController,
  child: GridView.count(
    controller: _scrollController,
    padding: const EdgeInsets.all(Insets.extraLarge),
    childAspectRatio: 1,
    crossAxisCount: colCount,
    children: listChildren,
  ),
);
```

Esta atenção sutil aos detalhes pode fazer seu app se sentir mais
confortável em uma determinada plataforma.

### Multi-seleção

Lidar com multi-seleção dentro de uma lista é outra área
com diferenças sutis entre plataformas:

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (multi-select-shift)"?>
```dart
static bool get isSpanSelectModifierDown =>
    isKeyDown({LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.shiftRight});
```

Para realizar uma verificação consciente da plataforma para control ou command,
você pode escrever algo assim:

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (multi-select-modifier-down)"?>
```dart
static bool get isMultiSelectModifierDown {
  bool isDown = false;
  if (Platform.isMacOS) {
    isDown = isKeyDown({
      LogicalKeyboardKey.metaLeft,
      LogicalKeyboardKey.metaRight,
    });
  } else {
    isDown = isKeyDown({
      LogicalKeyboardKey.controlLeft,
      LogicalKeyboardKey.controlRight,
    });
  }
  return isDown;
}
```

Uma consideração final para usuários de teclado é a ação **Select All**.
Se você tem uma grande lista de itens selecionáveis,
muitos dos seus usuários de teclado esperarão que possam usar
`Control+A` para selecionar todos os itens.

#### Dispositivos touch

Em dispositivos touch, a multi-seleção é tipicamente simplificada,
com o comportamento esperado sendo similar a ter o
`isMultiSelectModifier` pressionado no desktop.
Você pode selecionar ou desselecionar itens usando um único toque,
e geralmente terá um botão para **Select All** ou
**Clear** a seleção atual.

Como você lida com multi-seleção em diferentes dispositivos depende
dos seus casos de uso específicos, mas o importante é
certificar-se de que você está oferecendo a cada plataforma o melhor
modelo de interação possível.

### Texto selecionável

Uma expectativa comum na web (e em menor grau no desktop)
é que a maior parte do texto visível pode ser selecionada com o cursor do mouse.
Quando o texto não é selecionável,
usuários na web tendem a ter uma reação adversa.

Felizmente, isso é fácil de suportar com o widget [`SelectableText`][`SelectableText`]:

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (selectable-text)"?>
```dart
return const SelectableText('Select me!');
```

Para suportar rich text, então use `TextSpan`:

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (rich-text-span)"?>
```dart
return const SelectableText.rich(
  TextSpan(
    children: [
      TextSpan(text: 'Hello'),
      TextSpan(
        text: 'Bold',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ],
  ),
);
```

[`SelectableText`]: {{site.api}}/flutter/material/SelectableText-class.html

### Barras de título

Em aplicações desktop modernas, é comum customizar
a barra de título da janela do seu app, adicionando um logo para
branding mais forte ou controles contextuais para ajudar a economizar
espaço vertical em sua UI principal.

![Samples of title bars](/assets/images/docs/ui/adaptive-responsive/titlebar.png){:width="100%"}

Isso não é suportado diretamente no Flutter, mas você pode usar o
pacote [`bits_dojo`][`bits_dojo`] para desabilitar as barras de título nativas,
e substituí-las pelas suas próprias.

Este pacote permite adicionar quaisquer widgets que você queira à
`TitleBar` porque usa widgets Flutter puros por baixo dos panos.
Isso facilita a adaptação da barra de título conforme você navega
para diferentes seções do app.

[`bits_dojo`]: {{site.github}}/bitsdojo/bitsdojo_window

### Menus de contexto e tooltips

No desktop, existem várias interações que
se manifestam como um widget mostrado em uma sobreposição,
mas com diferenças em como são acionadas, descartadas,
e posicionadas:

* **Menu de contexto**
: Tipicamente acionado por um clique direito,
  um menu de contexto é posicionado perto do mouse,
  e é descartado clicando em qualquer lugar,
  selecionando uma opção do menu, ou clicando fora dele.

* **Tooltip**
: Tipicamente acionado ao pairar por
  200-400ms sobre um elemento interativo,
  um tooltip é geralmente ancorado a um widget
  (em oposição à posição do mouse) e é descartado
  quando o cursor do mouse sai desse widget.

* **Painel popup (também conhecido como flyout)**
: Similar a um tooltip,
  um painel popup é geralmente ancorado a um widget.
  A principal diferença é que painéis são mais frequentemente
  mostrados em um evento de toque, e geralmente não se escondem
  quando o cursor sai.
  Em vez disso, painéis são tipicamente descartados clicando
  fora do painel ou pressionando um botão **Close** ou **Submit**.

Para mostrar tooltips básicos no Flutter,
use o widget [`Tooltip`][`Tooltip`] integrado:

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (tooltip)"?>
```dart
return const Tooltip(
  message: 'I am a Tooltip',
  child: Text('Hover over the text to show a tooltip.'),
);
```

Flutter também fornece menus de contexto integrados ao editar
ou selecionar texto.

Para mostrar tooltips mais avançados, painéis popup,
ou criar menus de contexto customizados,
você usa um dos pacotes disponíveis,
ou constrói você mesmo usando um `Stack` ou `Overlay`.

Alguns pacotes disponíveis incluem:

* [`context_menus`][`context_menus`]
* [`anchored_popups`][`anchored_popups`]
* [`flutter_portal`][`flutter_portal`]
* [`super_tooltip`][`super_tooltip`]
* [`custom_pop_up_menu`][`custom_pop_up_menu`]

Embora esses controles possam ser valiosos para usuários touch como aceleradores,
eles são essenciais para usuários de mouse. Esses usuários esperam
clicar com o botão direito nas coisas, editar conteúdo no local,
e pairar para mais informações. Não atender a essas expectativas
pode levar a usuários desapontados, ou pelo menos,
uma sensação de que algo não está certo.

[`anchored_popups`]: {{site.pub}}/packages/anchored_popups
[`context_menus`]: {{site.pub}}/packages/context_menus
[`custom_pop_up_menu`]: {{site.pub}}/packages/custom_pop_up_menu
[`flutter_portal`]: {{site.pub}}/packages/flutter_portal
[`super_tooltip`]: {{site.pub}}/packages/super_tooltip
[`Tooltip`]: {{site.api}}/flutter/material/Tooltip-class.html

### Ordem horizontal de botões

No Windows, ao apresentar uma linha de botões,
o botão de confirmação é colocado no início da
linha (lado esquerdo). Em todas as outras plataformas,
é o oposto. O botão de confirmação é
colocado no final da linha (lado direito).

Isso pode ser facilmente tratado no Flutter usando a
propriedade `TextDirection` no `Row`:

<?code-excerpt "lib/widgets/ok_cancel_dialog.dart (row-text-direction)"?>
```dart
TextDirection btnDirection = DeviceType.isWindows
    ? TextDirection.rtl
    : TextDirection.ltr;
return Row(
  children: [
    const Spacer(),
    Row(
      textDirection: btnDirection,
      children: [
        DialogButton(
          label: 'Cancel',
          onPressed: () => Navigator.pop(context, false),
        ),
        DialogButton(
          label: 'Ok',
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    ),
  ],
);
```

![Sample of embedded image](/assets/images/docs/ui/adaptive-responsive/embed_image1.png){:width="75%"}

![Sample of embedded image](/assets/images/docs/ui/adaptive-responsive/embed_image2.png){:width="90%"}

### Barra de menu

Outro padrão comum em apps desktop é a barra de menu.
No Windows e Linux, este menu vive como parte da barra de título Chrome,
enquanto no macOS, está localizado ao longo do topo da tela principal.

Atualmente, você pode especificar entradas de barra de menu customizadas usando
um plugin protótipo, mas espera-se que esta funcionalidade será
eventualmente integrada ao SDK principal.

Vale mencionar que no Windows e Linux,
você não pode combinar uma barra de título customizada com uma barra de menu.
Quando você cria uma barra de título customizada,
você está substituindo completamente a nativa,
o que significa que você também perde a barra de menu nativa integrada.

Se você precisa tanto de uma barra de título customizada quanto de uma barra de menu,
você pode conseguir isso implementando-a no Flutter,
similar a um menu de contexto customizado.

### Arrastar e soltar

Uma das interações centrais para entradas baseadas em touch e
ponteiro é arrastar e soltar. Embora esta
interação seja esperada para ambos os tipos de entrada,
existem diferenças importantes a considerar quando
se trata de listas roláveis de itens arrastáveis.

Geralmente falando, usuários touch esperam ver alças de arrasto
para diferenciar áreas arrastáveis de áreas roláveis,
ou alternativamente, iniciar um arrasto usando um
gesto de pressão longa. Isso ocorre porque rolar e arrastar
estão ambos compartilhando um único dedo para entrada.

Usuários de mouse têm mais opções de entrada. Eles podem usar uma roda
ou barra de rolagem para rolar, o que geralmente elimina a necessidade
de alças de arrasto dedicadas. Se você olhar para o Finder do macOS
ou Windows Explorer, verá que eles funcionam
desta forma: você apenas seleciona um item e começa a arrastar.

No Flutter, você pode implementar arrastar e soltar de muitas maneiras.
Discutir implementações específicas está fora
do escopo deste artigo, mas algumas opções de alto nível
incluem o seguinte:

* Use as APIs [`Draggable`][`Draggable`] e [`DragTarget`][`DragTarget`]
  diretamente para uma aparência e sensação customizadas.

* Conecte-se aos eventos de gesto `onPan`,
  e mova um objeto você mesmo dentro de um `Stack` pai.

* Use um dos [pacotes de lista pré-fabricados][pre-made list packages] em pub.dev.

[`Draggable`]: {{site.api}}/flutter/widgets/Draggable-class.html
[`DragTarget`]: {{site.api}}/flutter/widgets/DragTarget-class.html
[pre-made list packages]: {{site.pub}}/packages?q=reorderable+list
