---
ia-translate: true
title: Use o Flutter inspector
description: Aprenda a usar o Flutter inspector para explorar a árvore de widgets de um app Flutter.
---

<?code-excerpt path-base="visual_debugging/"?>

:::note
O inspector funciona com todas as aplicações Flutter.
:::

Para informações sobre como localizar as telas do DevTools em diferentes IDEs,
consulte a [visão geral do DevTools][DevTools overview].

[DevTools overview]: /tools/devtools

## O que é?

O Flutter widget inspector é uma ferramenta poderosa para visualizar e
explorar árvores de widgets do Flutter. O framework Flutter usa widgets
como o bloco de construção principal para tudo, desde controles
(como texto, botões e toggles),
até layout (como centralização, padding, linhas e colunas).
O inspector ajuda você a visualizar e explorar árvores de widgets do Flutter,
e pode ser usado para o seguinte:

* entender layouts existentes
* diagnosticar problemas de layout

![Screenshot of the Flutter inspector window](/assets/images/docs/tools/devtools/inspector_screenshot.png){:width="100%"}

## O novo Flutter inspector {:#new}

Como parte do Flutter 3.29, o novo Flutter inspector está ativado por padrão. No entanto, ele pode ser desativado a partir do [diálogo de configurações do inspector][inspector settings dialog].

[inspector settings dialog]: #inspector-settings
[legacy inspector]: /tools/devtools/legacy-inspector
[filing a bug]: https://github.com/flutter/devtools/issues/new

### Depurando problemas de layout visualmente

O seguinte é um guia para os recursos disponíveis na
barra de ferramentas do inspector. Quando o espaço é limitado, o ícone é
usado como a versão visual do rótulo.

![Select widget mode button](/assets/images/docs/tools/devtools/select-widget-mode-button.png)
**Select widget mode**
: Ative este botão para selecionar
  um widget no dispositivo para inspecioná-lo. Para saber mais,
  confira [Inspecionando um widget](#inspecting-a-widget).

![Show implementation widgets button](/assets/images/docs/tools/devtools/show-implementation-widgets-button.png)
**Show implementation widgets**
: Ative este botão para mostrar widgets de implementação na árvore de widgets. Para saber mais,
  confira [Use a Árvore de Widgets](#use-the-widget-tree).

![Refresh tree icon](/assets/images/docs/tools/devtools/refresh-tree-icon.png){:.theme-icon width="20px"} **Refresh tree**
: Recarregue as informações atuais do widget.

![Slow animations icon](/assets/images/docs/tools/devtools/slow-animations-icon.png){:.theme-icon width="20px"} **[Slow animations][Slow animations]**
: Execute animações 5 vezes mais devagar para ajudar a ajustá-las.

![Show guidelines mode icon](/assets/images/docs/tools/devtools/debug-paint-mode-icon.png){:.theme-icon width="20px"} **[Show guidelines][Show guidelines]**
: Sobreponha diretrizes para auxiliar na correção de problemas de layout.

![Show baselines icon](/assets/images/docs/tools/devtools/paint-baselines-icon.png){:.theme-icon width="20px"} **[Show baselines][Show baselines]**
: Mostre baselines, que são usadas para alinhar texto.
  Pode ser útil para verificar se o texto está alinhado.

![Highlight repaints icon](/assets/images/docs/tools/devtools/repaint-rainbow-icon.png){:.theme-icon width="20px"} **[Highlight repaints][Highlight repaints]**
: Mostre bordas que mudam de cor quando elementos repintam.
  Útil para encontrar repinturas desnecessárias.

![Highlight oversized images icon](/assets/images/docs/tools/devtools/invert_oversized_images_icon.png){:.theme-icon width="20px"} **[Highlight oversized images][Highlight oversized images]**
: Destaque imagens que estão usando muita memória
  invertendo cores e virando-as.

[Slow animations]: #slow-animations
[Show guidelines]: #show-guidelines
[Show baselines]: #show-baselines
[Highlight repaints]: #highlight-repaints
[Highlight oversized images]: #highlight-oversized-images

## Inspecionando um widget

Você pode navegar pela árvore de widgets interativa para visualizar widgets
próximos e ver seus valores de campos.

Para localizar elementos de UI individuais na árvore de widgets,
clique no botão **Select Widget Mode** na barra de ferramentas.
Isso coloca o app no dispositivo em um modo "seleção de widget".
Clique em qualquer widget na UI do app; isso seleciona o widget na
tela do app, e rola a árvore de widgets até o nó correspondente.
Alterne o botão **Select Widget Mode** novamente para sair do
modo de seleção de widget.

Ao depurar problemas de layout, os campos principais a observar são os
campos `size` e `constraints`. As constraints fluem para baixo na árvore,
e os tamanhos fluem de volta para cima. Para mais informações sobre como isso funciona,
veja [Understanding constraints].

## Árvore de Widgets do Flutter

A Árvore de Widgets do Flutter permite que você visualize, entenda e navegue pela árvore de Widgets do seu app.

![Image of Flutter inspector with Widget Tree highlighted](/assets/images/docs/tools/devtools/inspector-widget-tree.png){:width="100%"}

### Use a Árvore de Widgets

#### Visualizando widgets criados em seu projeto

Por padrão, a Árvore de Widgets do Flutter inclui todos os widgets criados no
diretório raiz do seu projeto.

As relações pai-filhos dos widgets são representadas por uma única linha vertical (se o widget pai tiver apenas um único filho) ou através
de indentação (se o widget pai tiver múltiplos filhos.)

Por exemplo, para a seguinte seção de uma árvore de widgets:

![Image of widget tree section](/assets/images/docs/tools/devtools/widget-tree.png){:width="100%"}

* `Padding` tem um único filho `Row`
* `Row` tem três filhos: `Icon`, `SizedBox` e `Flexible`
* `Flexible` tem um único filho `Column`
* `Column` tem quatro filhos: `Text`, `Text`, `SizedBox` e `Divider`

#### Visualizando todos os widgets

Para visualizar todos os widgets na sua árvore de widgets, incluindo
aqueles que foram criados fora do seu projeto, ative "Show implementation widgets".

Os widgets de implementação são mostrados em uma fonte mais clara que os widgets criados em seu projeto,
distinguindo-os visualmente. Eles também estão ocultos atrás de grupos recolhíveis
que podem ser expandidos através dos botões de expansão inline.

Por exemplo, aqui está a mesma seção de uma árvore de widgets como acima com widgets de implementação mostrados:

![Image of widget tree section showing implementation widgets](/assets/images/docs/tools/devtools/widget-tree-with-implementation-widgets.png){:width="100%"}

* `Icon` tem cinco widgets de implementação recolhidos abaixo dele
* Ambos os widgets `Text` têm widgets de implementação `RichText` como filhos
* `Divider` tem nove widgets de implementação recolhidos abaixo dele

## Flutter Widget Explorer

O Flutter Widget Explorer ajuda você a entender melhor
o widget inspecionado.

![Image of Flutter inspector with Widget Explorer highlighted](/assets/images/docs/tools/devtools/inspector-widget-explorer.png){:width="100%"}

### Use o Widget Explorer

Do Flutter inspector, selecione um widget. O Widget Explorer será mostrado no lado direito da janela.

Dependendo do widget selecionado, o Widget Explorer incluirá um ou mais dos seguintes:

* Aba de propriedades do widget
* Aba do flex explorer
* Aba do render object

#### Aba de propriedades do widget

![Image of widget properties tab](/assets/images/docs/tools/devtools/widget-properties-tab.png){:width="100%"}

A aba de propriedades mostra uma mini-visualização do layout do seu widget, incluindo
largura, altura e padding, junto com uma lista de propriedades desse widget.

Essas propriedades incluem se o valor corresponde ou não ao valor padrão
para o argumento da propriedade.

#### Aba de render object

![Image of render object tab](/assets/images/docs/tools/devtools/render-object-tab.png){:width="100%"}

A aba de render object exibe todas as propriedades definidas no render object do
widget Flutter selecionado.

#### Aba do flex explorer

![Image of flex explorer tab](/assets/images/docs/tools/devtools/flex-explorer-tab.png){:width="100%"}

Quando você seleciona um widget flex (por exemplo, [`Row`], [`Column`], [`Flex`])
ou um filho direto de um widget flex, a ferramenta flex explorer aparecerá
no Widget Explorer.

A ferramenta flex explorer visualiza como widgets [`Flex`] e seus
filhos são dispostos. O explorador identifica o eixo principal
e o eixo transversal, assim como o alinhamento atual para cada
(por exemplo, start, end e spaceBetween).
Ele também mostra detalhes como fator flex, flex fit e
constraints de layout.

Além disso, o explorador mostra violações de constraints de layout
e erros de overflow de renderização. Constraints de layout violadas
são coloridas de vermelho, e erros de overflow são apresentados no
padrão "fita amarela" padrão, como você pode ver em um dispositivo
em execução. Essas visualizações visam melhorar a compreensão de
por que erros de overflow ocorrem, bem como como corrigi-los.

![The flex explorer showing errors and device inspector](/assets/images/docs/tools/devtools/layout_explorer_errors_and_device.webp){:width="100%"}

Clicar em um widget no flex explorer espelha
a seleção no inspector do dispositivo. **Select Widget Mode**
precisa estar ativado para isso. Para ativá-lo,
clique no botão **Select Widget Mode** no inspector.

![The Select Widget Mode button in the inspector](/assets/images/docs/tools/devtools/select-widget-mode-button.png)

Para algumas propriedades, como fator flex, flex fit e alinhamento,
você pode modificar o valor através de listas suspensas no explorador.
Ao modificar uma propriedade de widget, você vê o novo valor refletido
não apenas no flex explorer, mas também no
dispositivo executando seu app Flutter. O explorador anima
em mudanças de propriedade para que o efeito da mudança seja claro.
Mudanças de propriedade de widget feitas do layout explorer não
modificam seu código-fonte e são revertidas em hot reload.

##### Propriedades Interativas

O flex explorer suporta modificar [`mainAxisAlignment`],
[`crossAxisAlignment`] e [`FlexParentData.flex`].
No futuro, podemos adicionar suporte para propriedades adicionais
como [`mainAxisSize`], [`textDirection`] e
[`FlexParentData.fit`].

###### mainAxisAlignment

![The flex explorer changing main axis alignment](/assets/images/docs/tools/devtools/layout_explorer_main_axis_alignment.webp){:width="100%"}

Valores suportados:

- `MainAxisAlignment.start`
- `MainAxisAlignment.end`
- `MainAxisAlignment.center`
- `MainAxisAlignment.spaceBetween`
- `MainAxisAlignment.spaceAround`
- `MainAxisAlignment.spaceEvenly`

###### crossAxisAlignment

![The flex explorer changing cross axis alignment](/assets/images/docs/tools/devtools/layout_explorer_cross_axis_alignment.webp){:width="100%"}

Valores suportados:

- `CrossAxisAlignment.start`
- `CrossAxisAlignment.center`
- `CrossAxisAlignment.end`
- `CrossAxisAlignment.stretch`

###### FlexParentData.flex

![The flex explorer changing flex factor](/assets/images/docs/tools/devtools/layout_explorer_flex.webp){:width="100%"}

O flex explorer suporta 7 opções flex na UI
(null, 0, 1, 2, 3, 4, 5), mas tecnicamente o fator
flex do filho de um widget flex pode ser qualquer int.

###### Flexible.fit

![The flex explorer changing fit](/assets/images/docs/tools/devtools/layout_explorer_fit.webp){:width="100%"}

O flex explorer suporta os dois tipos diferentes de
[`FlexFit`]: `loose` e `tight`.

## Depuração visual

O Flutter Inspector fornece várias opções para depurar visualmente seu app.

![Inspector visual debugging options](/assets/images/docs/tools/devtools/visual_debugging_options.png){:width="100%"}

### Slow animations

Quando ativada, esta opção executa animações 5 vezes mais devagar para inspeção visual
mais fácil.
Isso pode ser útil se você quiser observar e ajustar cuidadosamente uma animação que
não parece totalmente correta.

Isso também pode ser definido no código:

<?code-excerpt "lib/slow_animations.dart"?>
```dart
import 'package:flutter/scheduler.dart';

void setSlowAnimations() {
  timeDilation = 5.0;
}
```

Isso desacelera as animações em 5x.

#### Veja também

Os seguintes links fornecem mais informações.

* [Flutter documentation: timeDilation property]({{site.api}}/flutter/scheduler/timeDilation.html)

As seguintes gravações de tela mostram antes e depois de desacelerar uma animação.

![Screen recording showing normal animation speed](/assets/images/docs/tools/devtools/debug-toggle-slow-animations-disabled.webp)
![Screen recording showing slowed animation speed](/assets/images/docs/tools/devtools/debug-toggle-slow-animations-enabled.webp)

### Show guidelines

Este recurso desenha diretrizes sobre seu app que exibem render boxes, alinhamentos,
paddings, scroll views, clippings e spacers.

Esta ferramenta pode ser usada para entender melhor seu layout. Por exemplo,
encontrando padding indesejado ou entendendo o alinhamento de widgets.

Você também pode ativar isso no código:

<?code-excerpt "lib/layout_guidelines.dart"?>
```dart
import 'package:flutter/rendering.dart';

void showLayoutGuidelines() {
  debugPaintSizeEnabled = true;
}
```

#### Render boxes

Widgets que desenham na tela criam uma [render box][render box], os
blocos de construção dos layouts do Flutter. Eles são mostrados com uma borda azul brilhante:

![Screenshot of render box guidelines](/assets/images/docs/tools/devtools/debug-toggle-guideline-render-box.png)

#### Alinhamentos

Alinhamentos são mostrados com setas amarelas. Essas setas mostram os offsets verticais
e horizontais de um widget em relação ao seu pai.
Por exemplo, o ícone deste botão é mostrado como estando centralizado pelas quatro setas:

![Screenshot of alignment guidelines](/assets/images/docs/tools/devtools/debug-toggle-guidelines-alignment.png)

#### Padding

Padding é mostrado com um fundo azul semi-transparente:

![Screenshot of padding guidelines](/assets/images/docs/tools/devtools/debug-toggle-guidelines-padding.png)

#### Scroll views

Widgets com conteúdo rolável (como list views) são mostrados com setas verdes:

![Screenshot of scroll view guidelines](/assets/images/docs/tools/devtools/debug-toggle-guidelines-scroll.png)

#### Clipping

Clipping, por exemplo ao usar o [widget ClipRect][ClipRect widget], é mostrado
com uma linha rosa tracejada com um ícone de tesoura:

[ClipRect widget]: {{site.api}}/flutter/widgets/ClipRect-class.html

![Screenshot of clip guidelines](/assets/images/docs/tools/devtools/debug-toggle-guidelines-clip.png)

#### Spacers

Widgets spacer são mostrados com um fundo cinza,
como este `SizedBox` sem um filho:

![Screenshot of spacer guidelines](/assets/images/docs/tools/devtools/debug-toggle-guidelines-spacer.png)

### Show baselines

Esta opção torna todas as baselines visíveis.
Baselines são linhas horizontais usadas para posicionar texto.

Isso pode ser útil para verificar se o texto está precisamente alinhado verticalmente.
Por exemplo, as baselines de texto na seguinte captura de tela estão ligeiramente desalinhadas:

![Screenshot with show baselines enabled](/assets/images/docs/tools/devtools/debug-toggle-guidelines-baseline.png)

O widget [Baseline] pode ser usado para ajustar baselines.

[Baseline]: {{site.api}}/flutter/widgets/Baseline-class.html

Uma linha é desenhada em qualquer [render box] que tenha uma baseline definida;
baselines alfabéticas são mostradas como verde e ideográficas como amarelo.

Você também pode ativar isso no código:

<?code-excerpt "lib/show_baselines.dart"?>
```dart
import 'package:flutter/rendering.dart';

void showBaselines() {
  debugPaintBaselinesEnabled = true;
}
```

### Highlight repaints

Esta opção desenha uma borda ao redor de todas as [render boxes][render boxes]
que muda de cor toda vez que aquela box repinta.

[render boxes]: {{site.api}}/flutter/rendering/RenderBox-class.html

Este arco-íris rotativo de cores é útil para encontrar partes do seu app
que estão repintando com muita frequência e potencialmente prejudicando o desempenho.

Por exemplo, uma pequena animação pode estar fazendo com que uma página inteira
repinte em cada frame.
Envolver a animação em um [widget RepaintBoundary][RepaintBoundary widget] limita
a repintura apenas à animação.

[RepaintBoundary widget]: {{site.api}}/flutter/widgets/RepaintBoundary-class.html

Aqui o indicador de progresso faz com que seu contêiner repinte:

<?code-excerpt "lib/highlight_repaints.dart (everything-repaints)"?>
```dart
class EverythingRepaintsPage extends StatelessWidget {
  const EverythingRepaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Repaint Example')),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
```

![Screen recording of a whole screen repainting](/assets/images/docs/tools/devtools/debug-toggle-guidelines-repaint-1.webp)

Envolver o indicador de progresso em um `RepaintBoundary` faz com que
apenas aquela seção da tela repinte:

<?code-excerpt "lib/highlight_repaints.dart (area-repaints)"?>
```dart
class AreaRepaintsPage extends StatelessWidget {
  const AreaRepaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Repaint Example')),
      body: const Center(
        child: RepaintBoundary(child: CircularProgressIndicator()),
      ),
    );
  }
}
```

![Screen recording of a just a progress indicator repainting](/assets/images/docs/tools/devtools/debug-toggle-guidelines-repaint-2.webp)

Widgets `RepaintBoundary` têm compensações. Eles podem ajudar com o desempenho,
mas também têm uma sobrecarga de criar um novo canvas,
que usa memória adicional.

Você também pode ativar esta opção no código:

<?code-excerpt "lib/highlight_repaints.dart (toggle)"?>
```dart
import 'package:flutter/rendering.dart';

void highlightRepaints() {
  debugRepaintRainbowEnabled = true;
}
```

### Highlight oversized images

Esta opção destaca imagens que são muito grandes invertendo suas cores
e virando-as verticalmente:

![A highlighted oversized image](/assets/images/docs/tools/devtools/debug-toggle-guidelines-oversized.png)

As imagens destacadas usam mais memória do que o necessário;
por exemplo, uma grande imagem de 5MB exibida em 100 por 100 pixels.

Tais imagens podem causar baixo desempenho, especialmente em dispositivos de baixo custo
e quando você tem muitas imagens, como em uma list view,
esse impacto no desempenho pode se acumular.
Informações sobre cada imagem são impressas no console de depuração:

```console
dash.png has a display size of 213×392 but a decode size of 2130×392, which uses an additional 2542KB.
```

Imagens são consideradas muito grandes se usarem pelo menos 128KB a mais do que o necessário.

#### Corrigindo imagens

Sempre que possível, a melhor maneira de corrigir este problema é redimensionar
o arquivo de asset da imagem para que seja menor.

Se isso não for possível, você pode usar os parâmetros `cacheHeight` e `cacheWidth`
no construtor `Image`:

<?code-excerpt "lib/oversized_images.dart (resized-image)"?>
```dart
class ResizedImage extends StatelessWidget {
  const ResizedImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset('dash.png', cacheHeight: 213, cacheWidth: 392);
  }
}
```

Isso faz com que o motor decodifique esta imagem no tamanho especificado,
e reduz o uso de memória (decodificação e armazenamento ainda são mais caros
do que se o próprio asset da imagem fosse encolhido).
A imagem é renderizada para as constraints do layout ou largura e altura
independentemente desses parâmetros.

Esta propriedade também pode ser definida no código:

<?code-excerpt "lib/oversized_images.dart (toggle)"?>
```dart
void showOversizedImages() {
  debugInvertOversizedImages = true;
}
```

#### Mais informações

Você pode aprender mais no seguinte link:

- [Flutter documentation: debugInvertOversizedImages]({{site.api}}/flutter/rendering/debugInvertOversizedImages.html)

[render box]: {{site.api}}/flutter/rendering/RenderBox-class.html

## Rastreamento de criação de widgets

Parte da funcionalidade do Flutter inspector é baseada em
instrumentar o código da aplicação para entender melhor
os locais de origem onde os widgets são criados. A instrumentação
de origem permite que o Flutter inspector apresente a
árvore de widgets de uma maneira similar a como a UI foi definida
no seu código-fonte. Sem ela, a árvore de nós na
árvore de widgets é muito mais profunda, e pode ser mais difícil
entender como a hierarquia de widgets em runtime corresponde
à UI da sua aplicação.

Você pode desativar este recurso passando `--no-track-widget-creation` para
o comando `flutter run`.

Aqui estão exemplos de como sua árvore de widgets pode parecer
com e sem o rastreamento de criação de widgets ativado.

Rastreamento de criação de widgets ativado (padrão):

![The widget tree with track widget creation enabled](/assets/images/docs/tools/devtools/track_widget_creation_enabled.png){:width="100%"}

Rastreamento de criação de widgets desativado (não recomendado):

![The widget tree with track widget creation disabled](/assets/images/docs/tools/devtools/track_widget_creation_disabled.png){:width="100%"}

Este recurso impede que Widgets `const` idênticos sejam
considerados iguais em builds de debug. Para mais detalhes, veja
a discussão sobre [problemas comuns ao depurar][common problems when debugging].

## Configurações do Inspector

![The Flutter Inspector Settings dialog](/assets/images/docs/tools/devtools/flutter-inspector-settings.png){:width="100%"}

### Ativar inspeção ao passar o mouse

Passar o mouse sobre qualquer widget exibe suas propriedades e valores.

Alternar este valor ativa ou desativa a funcionalidade de inspeção ao passar o mouse.

### Ativar atualização automática da árvore de widgets

Quando ativado, a árvore de widgets é atualizada automaticamente após
um hot-reload ou um evento de navegação.

### Usar inspector legado

Quando ativado, use o [inspector legado][legacy inspector] em vez do novo inspector.

:::note
O [inspector legado][legacy inspector] será removido em uma versão futura.
Avise-nos se houver problemas que o impedem de usar o novo inspector através de [registrar um bug][filing a bug].
:::

[legacy inspector]: /tools/devtools/legacy-inspector

### Diretórios de pacotes

Por padrão, o DevTools limita os widgets exibidos na árvore de widgets àqueles criados
no diretório raiz do projeto. Para ver todos os widgets, incluindo aqueles criados fora
do diretório raiz do projeto, ative [Show implementation widgets][Show implementation widgets]

Para incluir outros widgets na árvore de widgets padrão, um diretório pai deles deve
ser adicionado aos Diretórios de Pacotes.

Por exemplo, considere a seguinte estrutura de diretórios:

```plaintext
project_foo
  pkgs
    project_foo_app
    widgets_A
    widgets_B
```

Executar seu app a partir de `project_foo_app` exibe apenas widgets de
`project_foo/pkgs/project_foo_app` na árvore do widget inspector.

Para mostrar widgets de `widgets_A` na árvore de widgets,
adicione `project_foo/pkgs/widgets_A` aos diretórios de pacotes.

Para exibir _todos_ os widgets da raiz do seu projeto na árvore de widgets,
adicione `project_foo` aos diretórios de pacotes.

Mudanças em seus diretórios de pacotes persistem na próxima vez que o
widget inspector for aberto para o app.

[Show implementation widgets]: #debugging-layout-issues-visually

## Outros recursos

Para uma demonstração do que é geralmente possível com o inspector,
veja a [palestra DartConf 2018][DartConf 2018 talk] demonstrando a versão IntelliJ
do Flutter inspector.

Para aprender como depurar visualmente problemas de layout
usando DevTools, confira um tutorial guiado
do [Flutter Inspector][inspector-tutorial].

[`Column`]: {{site.api}}/flutter/widgets/Column-class.html
[common problems when debugging]: /testing/debugging
[`crossAxisAlignment`]: {{site.api}}/flutter/widgets/Flex/crossAxisAlignment.html
[DartConf 2018 talk]: {{site.yt.watch}}?v=JIcmJNT9DNI
[debug mode]: /testing/build-modes#debug
[`Flex`]: {{site.api}}/flutter/widgets/Flex-class.html
[flex layouts]: {{site.api}}/flutter/widgets/Flex-class.html
[`FlexFit`]: {{site.api}}/flutter/rendering/FlexFit.html
[`FlexParentData.fit`]: {{site.api}}/flutter/rendering/FlexParentData/fit.html
[`FlexParentData.flex`]: {{site.api}}/flutter/rendering/FlexParentData/flex.html
[`mainAxisAlignment`]: {{site.api}}/flutter/widgets/Flex/mainAxisAlignment.html
[`mainAxisSize`]: {{site.api}}/flutter/widgets/Flex/mainAxisSize.html
[`Row`]: {{site.api}}/flutter/widgets/Row-class.html
[`textDirection`]: {{site.api}}/flutter/widgets/Flex/textDirection.html
[Understanding constraints]: /ui/layout/constraints
[inspector-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-flutter-inspector-part-2-of-8-bbff40692fc7
