---
ia-translate: true
title: Plataforma idioms
description: >-
  Aprenda como criar um aplicativo responsivo
  que responde a mudanças no tamanho da tela.
short-title: Idiomas
---

<?code-excerpt path-base="ui/adaptive_app_demos"?>

{% comment %}
<b>PENDENTE: Deixe esta página de fora por enquanto... Na V2, eu gostaria de incluí-la. Mariam sugeriu dividi-la por plataforma e eu gostei dessa ideia</b>
{% endcomment %}

A área final a ser considerada para aplicativos adaptáveis são os padrões da plataforma.
Cada plataforma tem seus próprios "idiomas" e normas;
estes padrões nominais ou de facto informam as expectativas do usuário
de como um aplicativo deve se comportar. Graças, em parte, à web,
os usuários estão acostumados a experiências mais personalizadas,
mas refletir esses padrões de plataforma ainda pode fornecer
benefícios significativos:

*   **Reduzir a carga cognitiva**
    : Ao corresponder ao modelo mental existente do usuário,
      a realização de tarefas torna-se intuitiva,
      o que exige menos reflexão,
      aumenta a produtividade e reduz frustrações.

*   **Construir confiança**
    : Os usuários podem se tornar cautelosos ou desconfiados
      quando os aplicativos não aderem às suas expectativas.
      Por outro lado, uma interface de usuário que parece familiar pode construir confiança do usuário
      e pode ajudar a melhorar a percepção de qualidade.
      Isso muitas vezes tem o benefício adicional de melhores avaliações na loja de aplicativos
      — algo que todos nós podemos apreciar!

## Considere o comportamento esperado em cada plataforma

O primeiro passo é dedicar algum tempo a considerar qual
a aparência, apresentação ou comportamento esperado
nesta plataforma.
Tente esquecer quaisquer limitações da sua implementação atual,
e apenas visualize a experiência ideal do usuário.
Trabalhe de trás para frente a partir daí.

Outra forma de pensar sobre isso é perguntar:
"Como um usuário desta plataforma esperaria atingir este objetivo?"
Então, tente imaginar como isso funcionaria no seu aplicativo
sem quaisquer compromissos.

Isso pode ser difícil se você não for um usuário regular da plataforma.
Você pode não estar ciente dos "idiomas" específicos e pode facilmente perdê-los
completamente. Por exemplo, um usuário do Android por toda a vida
provavelmente não está ciente das convenções da plataforma no iOS,
e o mesmo vale para macOS, Linux e Windows.
Essas diferenças podem ser sutis para você,
mas serem dolorosamente óbvias para um usuário experiente.

### Encontre um defensor da plataforma

Se possível, designe alguém como defensor de cada plataforma.
Idealmente, seu defensor usa a plataforma como seu dispositivo principal,
e pode oferecer a perspectiva de um usuário altamente opinativo.
Para reduzir o número de pessoas, combine funções.
Tenha um defensor para Windows e Android,
um para Linux e a web, e um para Mac e iOS.

O objetivo é ter feedback constante e informado para que o aplicativo
se sinta ótimo em cada plataforma. Os defensores devem ser encorajados
a serem bem exigentes, apontando qualquer coisa que sintam que difere de
aplicativos típicos em seu dispositivo. Um exemplo simples é como
o botão padrão em uma caixa de diálogo geralmente fica à esquerda no Mac
e Linux, mas está à direita no Windows.
Detalhes como esse são fáceis de perder se você não estiver usando uma plataforma
regularmente.

:::secondary Important
Os defensores não precisam ser desenvolvedores ou
mesmo membros da equipe em tempo integral. Eles podem ser designers,
partes interessadas ou testadores externos que recebem
builds regularmente.
:::

### Seja único

Conformar-se com os comportamentos esperados não significa que seu aplicativo
precisa usar componentes ou estilos padrão.
Muitos dos aplicativos multiplataforma mais populares têm UIs muito distintas
e opinativas, incluindo botões personalizados, menus de contexto
e barras de título.

Quanto mais você consolidar o estilo e o comportamento em todas as plataformas,
mais fácil será o desenvolvimento e os testes.
O truque é equilibrar a criação de uma experiência única com uma
identidade forte, respeitando as normas de cada plataforma.

## "Idiomas" e normas comuns a serem considerados

Dê uma olhada rápida em algumas normas e "idiomas" específicos
que você pode querer considerar e como você poderia abordá-los
no Flutter.

### Aparência e comportamento da barra de rolagem

Os usuários de desktop e mobile esperam barras de rolagem,
mas esperam que elas se comportem de forma diferente em diferentes plataformas.
Usuários de mobile esperam barras de rolagem menores que só aparecem
durante a rolagem, enquanto usuários de desktop geralmente esperam
barras de rolagem maiores e onipresentes que podem clicar ou arrastar.

O Flutter vem com um widget `Scrollbar` integrado que já
tem suporte para cores e tamanhos adaptáveis de acordo com a
plataforma atual. O único ajuste que você pode querer fazer é
alternar `alwaysShown` quando estiver em uma plataforma de desktop:

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

Essa sutil atenção aos detalhes pode fazer com que seu aplicativo se sinta mais
confortável em uma determinada plataforma.

### Seleção múltipla

Lidar com a seleção múltipla dentro de uma lista é outra área
com diferenças sutis entre as plataformas:

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (multi-select-shift)"?>
```dart
static bool get isSpanSelectModifierDown =>
    isKeyDown({LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.shiftRight});
```

Para executar uma verificação compatível com a plataforma para control ou command,
você pode escrever algo como isto:

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (multi-select-modifier-down)"?>
```dart
static bool get isMultiSelectModifierDown {
  bool isDown = false;
  if (Platform.isMacOS) {
    isDown = isKeyDown(
      {LogicalKeyboardKey.metaLeft, LogicalKeyboardKey.metaRight},
    );
  } else {
    isDown = isKeyDown(
      {LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.controlRight},
    );
  }
  return isDown;
}
```

Uma consideração final para usuários de teclado é a ação **Selecionar tudo**.
Se você tem uma grande lista de itens selecionáveis,
muitos de seus usuários de teclado esperarão que possam usar
`Control+A` para selecionar todos os itens.

#### Dispositivos touch

Em dispositivos touch, a seleção múltipla é normalmente simplificada,
com o comportamento esperado sendo semelhante a ter o
`isMultiSelectModifier` pressionado no desktop.
Você pode selecionar ou desmarcar itens usando um único toque,
e geralmente terá um botão para **Selecionar tudo** ou
**Limpar** a seleção atual.

Como você lida com a seleção múltipla em diferentes dispositivos depende
dos seus casos de uso específicos, mas o importante é
certificar-se de que está oferecendo a cada plataforma o melhor
modelo de interação possível.

### Texto selecionável

Uma expectativa comum na web (e, em menor medida, no desktop)
é que a maior parte do texto visível possa ser selecionada com o cursor do mouse.
Quando o texto não é selecionável,
os usuários na web tendem a ter uma reação adversa.

Felizmente, isso é fácil de suportar com o widget [`SelectableText`][]:

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (selectable-text)"?>
```dart
return const SelectableText('Selecione-me!');
```

Para oferecer suporte a rich text, use `TextSpan`:

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (rich-text-span)"?>
```dart
return const SelectableText.rich(
  TextSpan(
    children: [
      TextSpan(text: 'Olá'),
      TextSpan(text: 'Negrito', style: TextStyle(fontWeight: FontWeight.bold)),
    ],
  ),
);
```

[`SelectableText`]: {{site.api}}/flutter/material/SelectableText-class.html

### Barras de título

Em aplicações de desktop modernas, é comum personalizar
a barra de título da janela do seu aplicativo, adicionando um logotipo para
um branding mais forte ou controles contextuais para ajudar a economizar
espaço vertical na sua interface principal.

![Exemplos de barras de título](/assets/images/docs/ui/adaptive-responsive/titlebar.png){:width="100%"}

Isso não é suportado diretamente no Flutter, mas você pode usar o
pacote [`bits_dojo`][] para desabilitar as barras de título nativas,
e substituí-las pelas suas próprias.

Este pacote permite que você adicione os widgets que quiser à
`TitleBar` porque ele usa widgets Flutter puros por baixo dos panos.
Isso facilita a adaptação da barra de título conforme você navega
para diferentes seções do aplicativo.

[`bits_dojo`]: {{site.github}}/bitsdojo/bitsdojo_window

### Menus de contexto e tooltips

No desktop, existem várias interações que
se manifestam como um widget mostrado em uma sobreposição,
mas com diferenças em como são acionados, dispensados
e posicionados:

*   **Menu de contexto**
    : Normalmente acionado por um clique com o botão direito,
      um menu de contexto é posicionado próximo ao mouse,
      e é dispensado clicando em qualquer lugar,
      selecionando uma opção no menu ou clicando fora dele.

*   **Tooltip**
    : Normalmente acionado por passar o mouse por
      200-400ms sobre um elemento interativo,
      um tooltip é geralmente ancorado a um widget
      (ao contrário da posição do mouse) e é dispensado
      quando o cursor do mouse sai desse widget.

*   **Painel pop-up (também conhecido como flyout)**
    : Semelhante a um tooltip,
      um painel pop-up geralmente é ancorado a um widget.
      A principal diferença é que os painéis são frequentemente
      mostrados em um evento de toque e, geralmente, não se ocultam
      quando o cursor sai.
      Em vez disso, os painéis são normalmente dispensados clicando
      fora do painel ou pressionando um botão **Fechar** ou **Enviar**.

Para mostrar tooltips básicos no Flutter,
use o widget [`Tooltip`][] integrado:

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (tooltip)"?>
```dart
return const Tooltip(
  message: 'Eu sou um Tooltip',
  child: Text('Passe o mouse sobre o texto para exibir um tooltip.'),
);
```

O Flutter também oferece menus de contexto integrados ao editar
ou selecionar texto.

Para mostrar tooltips mais avançados, painéis pop-up
ou criar menus de contexto personalizados,
você usa um dos pacotes disponíveis
ou constrói você mesmo usando um `Stack` ou `Overlay`.

Alguns pacotes disponíveis incluem:

*   [`context_menus`][]
*   [`anchored_popups`][]
*   [`flutter_portal`][]
*   [`super_tooltip`][]
*   [`custom_pop_up_menu`][]

Embora esses controles possam ser valiosos para usuários touch como aceleradores,
eles são essenciais para usuários de mouse. Esses usuários esperam
clicar com o botão direito nas coisas, editar o conteúdo no local
e passar o mouse para obter mais informações. Não atender a essas expectativas
pode levar a usuários decepcionados ou, pelo menos,
à sensação de que algo não está totalmente certo.

[`anchored_popups`]: {{site.pub}}/packages/anchored_popups
[`context_menus`]: {{site.pub}}/packages/context_menus
[`custom_pop_up_menu`]: {{site.pub}}/packages/custom_pop_up_menu
[`flutter_portal`]: {{site.pub}}/packages/flutter_portal
[`super_tooltip`]: {{site.pub}}/packages/super_tooltip
[`Tooltip`]: {{site.api}}/flutter/material/Tooltip-class.html

### Ordem horizontal dos botões

No Windows, ao apresentar uma linha de botões,
o botão de confirmação é colocado no início da
linha (lado esquerdo). Em todas as outras plataformas,
é o oposto. O botão de confirmação é
colocado no final da linha (lado direito).

Isso pode ser facilmente tratado no Flutter usando a
propriedade `TextDirection` em `Row`:

<?code-excerpt "lib/widgets/ok_cancel_dialog.dart (row-text-direction)"?>
```dart
TextDirection btnDirection =
    DeviceType.isWindows ? TextDirection.rtl : TextDirection.ltr;
return Row(
  children: [
    const Spacer(),
    Row(
      textDirection: btnDirection,
      children: [
        DialogButton(
          label: 'Cancelar',
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

![Exemplo de imagem incorporada](/assets/images/docs/ui/adaptive-responsive/embed_image1.png){:width="75%"}

![Exemplo de imagem incorporada](/assets/images/docs/ui/adaptive-responsive/embed_image2.png){:width="90%"}

### Barra de menu

Outro padrão comum em aplicativos desktop é a barra de menu.
No Windows e Linux, este menu faz parte da barra de título do Chrome,
enquanto no macOS, ele está localizado na parte superior da tela principal.

Atualmente, você pode especificar entradas personalizadas da barra de menu usando
um plugin protótipo, mas espera-se que essa funcionalidade seja
eventualmente integrada ao SDK principal.

Vale a pena mencionar que no Windows e Linux,
você não pode combinar uma barra de título personalizada com uma barra de menu.
Quando você cria uma barra de título personalizada,
você está substituindo a nativa completamente,
o que significa que você também perde a barra de menu nativa integrada.

Se você precisar de uma barra de título personalizada e uma barra de menu,
você pode conseguir isso implementando no Flutter,
semelhante a um menu de contexto personalizado.

### Arrastar e soltar

Uma das interações principais para entradas baseadas em toque e
baseadas em ponteiro é arrastar e soltar. Embora esta
interação seja esperada para ambos os tipos de entrada,
existem diferenças importantes a considerar quando
se trata de rolar listas de itens arrastáveis.

De modo geral, os usuários de toque esperam ver alças de arrastar
para diferenciar áreas arrastáveis de áreas roláveis,
ou, alternativamente, para iniciar um arrastar usando um longo
gesto de pressionar. Isso ocorre porque a rolagem e o arrastar
estão compartilhando um único dedo para a entrada.

Usuários de mouse têm mais opções de entrada. Eles podem usar uma roda
ou barra de rolagem para rolar, o que geralmente elimina a necessidade
de alças de arrastar dedicadas. Se você olhar o macOS
Finder ou Windows Explorer, verá que eles funcionam
dessa forma: você apenas seleciona um item e começa a arrastar.

No Flutter, você pode implementar arrastar e soltar de várias maneiras.
Discutir implementações específicas está fora
do escopo deste artigo, mas algumas opções de alto nível
incluem o seguinte:

*   Use as APIs [`Draggable`][] e [`DragTarget`][]
    diretamente para uma aparência personalizada.

*   Conecte-se a eventos de gesto `onPan`,
    e mova um objeto você mesmo dentro de um `Stack` pai.

*   Use um dos [pacotes de listas pré-fabricados][] no pub.dev.

[`Draggable`]: {{site.api}}/flutter/widgets/Draggable-class.html
[`DragTarget`]: {{site.api}}/flutter/widgets/DragTarget-class.html
[pre-made list packages]: {{site.pub}}/packages?q=reorderable+list
