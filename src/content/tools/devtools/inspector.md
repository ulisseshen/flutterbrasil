---
ia-translate: true
title: Usar o Flutter inspector
description: Aprenda como usar o Flutter inspector para explorar a árvore de widgets de um app Flutter.
---

<?code-excerpt path-base="visual_debugging/"?>

:::note
O inspector funciona com todas as aplicações Flutter.
:::

## O que é?

O Flutter widget inspector é uma ferramenta poderosa para visualizar e
explorar árvores de widgets Flutter. O framework Flutter usa widgets
como bloco de construção central para qualquer coisa, desde controles
(como texto, botões e toggles),
até layout (como centralização, padding, rows e columns).
O inspector ajuda você a visualizar e explorar árvores de
widgets Flutter, e pode ser usado para o seguinte:

* entender layouts existentes
* diagnosticar problemas de layout

![Screenshot of the Flutter inspector window](/assets/images/docs/tools/devtools/inspector_screenshot.png){:width="100%"}

## Começando

Para depurar um problema de layout, execute o app em [modo debug][debug mode] e
abra o inspector clicando na aba **Flutter Inspector**
na barra de ferramentas DevTools.

:::note
Você ainda pode acessar o Flutter inspector diretamente do
Android Studio/IntelliJ, mas você pode preferir a
visualização mais espaçosa ao executá-lo do DevTools
em um navegador.
:::

### Depurando problemas de layout visualmente

A seguir está um guia para os recursos disponíveis na
barra de ferramentas do inspector. Quando o espaço é limitado, o ícone é
usado como a versão visual do rótulo.

![Select widget mode icon](/assets/images/docs/tools/devtools/select-widget-mode-icon.png){:width="20px"} **Select widget mode**
: Habilite este botão para selecionar
  um widget no dispositivo para inspecioná-lo. Para saber mais,
  confira [Inspecionando um widget](#inspecting-a-widget).

![Refresh tree icon](/assets/images/docs/tools/devtools/refresh-tree-icon.png){:width="20px"} **Refresh tree**
: Recarregar as informações atuais do widget.

![Slow animations icon](/assets/images/docs/tools/devtools/slow-animations-icon.png){:width="20px"} **[Slow animations][]**
: Executar animações 5 vezes mais lentas para ajudar a ajustá-las.

![Show guidelines mode icon](/assets/images/docs/tools/devtools/debug-paint-mode-icon.png){:width="20px"} **[Show guidelines][]**
: Sobrepor diretrizes para auxiliar na correção de problemas de layout.

![Show baselines icon](/assets/images/docs/tools/devtools/paint-baselines-icon.png){:width="20px"} **[Show baselines][]**
: Mostrar baselines, que são usadas para alinhar texto.
  Pode ser útil para verificar se o texto está alinhado.

![Highlight repaints icon](/assets/images/docs/tools/devtools/repaint-rainbow-icon.png){:width="20px"} **[Highlight repaints][]**
: Mostrar bordas que mudam de cor quando elementos repintam.
  Útil para encontrar repinturas desnecessárias.

![Highlight oversized images icon](/assets/images/docs/tools/devtools/invert_oversized_images_icon.png){:width="20px"} **[Highlight oversized images][]**
: Destaca imagens que estão usando muita memória
  invertendo cores e invertendo-as.

[Slow animations]: #slow-animations
[Show guidelines]: #show-guidelines
[Show baselines]: #show-baselines
[Highlight repaints]: #highlight-repaints
[Highlight oversized images]: #highlight-oversized-images

## Inspecionando um widget

Você pode navegar pela árvore interativa de widgets para visualizar widgets próximos
e ver seus valores de campos.

Para localizar elementos individuais de UI na árvore de widgets,
clique no botão **Select Widget Mode** na barra de ferramentas.
Isso coloca o app no dispositivo em um "modo de seleção de widget".
Clique em qualquer widget na UI do app; isso seleciona o widget na
tela do app e rola a árvore de widgets até o nó correspondente.
Alterne o botão **Select Widget Mode** novamente para sair
do modo de seleção de widget.

Ao depurar problemas de layout, os campos-chave a serem observados são os
campos `size` e `constraints`. As constraints fluem para baixo na árvore,
e os tamanhos fluem de volta para cima. Para mais informações sobre como isso funciona,
veja [Entendendo constraints][Understanding constraints].

## Flutter Layout Explorer

O Flutter Layout Explorer ajuda você a entender melhor
layouts Flutter.

Para uma visão geral do que você pode fazer com esta ferramenta, veja
o vídeo Flutter Explorer:

{% ytEmbed 'Jakrc3Tn_y4', 'DevTools Layout Explorer' %}

Você também pode achar útil o seguinte artigo passo a passo:

* [Como depurar problemas de layout com o Flutter Inspector][debug-article]

[debug-article]: {{site.flutter-medium}}/how-to-debug-layout-issues-with-the-flutter-inspector-87460a7b9db

### Usar o Layout Explorer

Do Flutter Inspector, selecione um widget. O Layout Explorer
suporta tanto [layouts flex][flex layouts] quanto layouts de tamanho fixo, e tem
ferramentas específicas para ambos os tipos.

#### Layouts Flex

Quando você seleciona um widget flex (por exemplo, [`Row`][], [`Column`][], [`Flex`][])
ou um filho direto de um widget flex, a ferramenta de layout flex
aparecerá no Layout Explorer.

O Layout Explorer visualiza como widgets [`Flex`][] e seus
filhos são organizados. O explorer identifica o eixo principal
e o eixo transversal, bem como o alinhamento atual para cada
(por exemplo, start, end e spaceBetween).
Ele também mostra detalhes como fator flex, flex fit e
constraints de layout.

Além disso, o explorer mostra violações de constraints de layout
e erros de overflow de renderização. Constraints de layout violadas
são coloridas de vermelho, e erros de overflow são apresentados no
padrão "fita amarela" padrão, como você pode ver em um dispositivo
em execução. Essas visualizações visam melhorar a compreensão de
por que erros de overflow ocorrem e como corrigi-los.

![The Layout Explorer showing errors and device inspector](/assets/images/docs/tools/devtools/layout_explorer_errors_and_device.gif){:width="100%"}

Clicar em um widget no layout explorer espelha
a seleção no inspector no dispositivo. **Select Widget Mode**
precisa estar habilitado para isso. Para habilitá-lo,
clique no botão **Select Widget Mode** no inspector.

![The Select Widget Mode button in the inspector](/assets/images/docs/tools/devtools/select_widget_mode_button.png)

Para algumas propriedades, como fator flex, flex fit e alinhamento,
você pode modificar o valor através de listas suspensas no explorer.
Ao modificar uma propriedade de widget, você vê o novo valor refletido
não apenas no Layout Explorer, mas também no
dispositivo executando seu app Flutter. O explorer anima
nas mudanças de propriedade para que o efeito da mudança seja claro.
Mudanças de propriedade de widget feitas do layout explorer não
modificam seu código-fonte e são revertidas no hot reload.

##### Propriedades Interativas

Layout Explorer suporta modificar [`mainAxisAlignment`][],
[`crossAxisAlignment`][] e [`FlexParentData.flex`][].
No futuro, podemos adicionar suporte para propriedades adicionais
como [`mainAxisSize`][], [`textDirection`][] e
[`FlexParentData.fit`][].

###### mainAxisAlignment

![The Layout Explorer changing main axis alignment](/assets/images/docs/tools/devtools/layout_explorer_main_axis_alignment.gif){:width="100%"}

Valores suportados:

* `MainAxisAlignment.start`
* `MainAxisAlignment.end`
* `MainAxisAlignment.center`
* `MainAxisAlignment.spaceBetween`
* `MainAxisAlignment.spaceAround`
* `MainAxisAlignment.spaceEvenly`

###### crossAxisAlignment

![The Layout Explorer changing cross axis alignment](/assets/images/docs/tools/devtools/layout_explorer_cross_axis_alignment.gif){:width="100%"}

Valores suportados:

* `CrossAxisAlignment.start`
* `CrossAxisAlignment.center`
* `CrossAxisAlignment.end`
* `CrossAxisAlignment.stretch`

###### FlexParentData.flex

![The Layout Explorer changing flex factor](/assets/images/docs/tools/devtools/layout_explorer_flex.gif){:width="100%"}

Layout Explorer suporta 7 opções flex na UI
(null, 0, 1, 2, 3, 4, 5), mas tecnicamente o fator
flex de um filho de widget flex pode ser qualquer int.

###### Flexible.fit

![The Layout Explorer changing fit](/assets/images/docs/tools/devtools/layout_explorer_fit.gif){:width="100%"}

Layout Explorer suporta os dois tipos diferentes de
[`FlexFit`][]: `loose` e `tight`.

#### Layouts de tamanho fixo

Quando você seleciona um widget de tamanho fixo que não é filho
de um widget flex, informações de layout de tamanho fixo aparecerão
no Layout Explorer. Você pode ver informações de tamanho, constraint e padding
tanto para o widget selecionado quanto para seu RenderObject
upstream mais próximo.

![The Layout Explorer fixed size tool](/assets/images/docs/tools/devtools/layout_explorer_fixed_layout.png){:width="100%"}

## Depuração visual

O Flutter Inspector fornece várias opções para depurar visualmente seu app.

![Inspector visual debugging options](/assets/images/docs/tools/devtools/visual_debugging_options.png){:width="100%"}

### Slow animations

Quando habilitada, esta opção executa animações 5 vezes mais lentas para inspeção visual
mais fácil.
Isso pode ser útil se você quiser observar cuidadosamente e ajustar uma animação que
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

* [Documentação Flutter: propriedade timeDilation]({{site.api}}/flutter/scheduler/timeDilation.html)

As seguintes gravações de tela mostram antes e depois de desacelerar uma animação.

![Screen recording showing normal animation speed](/assets/images/docs/tools/devtools/debug-toggle-slow-animations-disabled.gif)
![Screen recording showing slowed animation speed](/assets/images/docs/tools/devtools/debug-toggle-slow-animations-enabled.gif)

### Show guidelines

Este recurso desenha diretrizes sobre seu app que exibem render boxes, alinhamentos,
paddings, scroll views, clippings e spacers.

Esta ferramenta pode ser usada para entender melhor seu layout. Por exemplo,
encontrando padding indesejado ou entendendo o alinhamento de widgets.

Você também pode habilitar isso no código:

<?code-excerpt "lib/layout_guidelines.dart"?>
```dart
import 'package:flutter/rendering.dart';

void showLayoutGuidelines() {
  debugPaintSizeEnabled = true;
}
```

#### Render boxes

Widgets que desenham na tela criam um [render box][], os
blocos de construção de layouts Flutter. Eles são mostrados com uma borda azul brilhante:

![Screenshot of render box guidelines](/assets/images/docs/tools/devtools/debug-toggle-guideline-render-box.png)

#### Alinhamentos

Alinhamentos são mostrados com setas amarelas. Essas setas mostram os deslocamentos
vertical e horizontal de um widget em relação ao seu pai.
Por exemplo, o ícone deste botão é mostrado como centralizado pelas quatro setas:

![Screenshot of alignment guidelines](/assets/images/docs/tools/devtools/debug-toggle-guidelines-alignment.png)

#### Padding

Padding é mostrado com um fundo azul semi-transparente:

![Screenshot of padding guidelines](/assets/images/docs/tools/devtools/debug-toggle-guidelines-padding.png)

#### Scroll views

Widgets com conteúdo de rolagem (como list views) são mostrados com setas verdes:

![Screenshot of scroll view guidelines](/assets/images/docs/tools/devtools/debug-toggle-guidelines-scroll.png)

#### Clipping

Clipping, por exemplo ao usar o [widget ClipRect][ClipRect widget], são mostrados
com uma linha rosa tracejada com um ícone de tesoura:

[ClipRect widget]: {{site.api}}/flutter/widgets/ClipRect-class.html

![Screenshot of clip guidelines](/assets/images/docs/tools/devtools/debug-toggle-guidelines-clip.png)

#### Spacers

Widgets Spacer são mostrados com um fundo cinza,
como este `SizedBox` sem filho:

![Screenshot of spacer guidelines](/assets/images/docs/tools/devtools/debug-toggle-guidelines-spacer.png)

### Show baselines

Esta opção torna todas as baselines visíveis.
Baselines são linhas horizontais usadas para posicionar texto.

Isso pode ser útil para verificar se o texto está precisamente alinhado verticalmente.
Por exemplo, as baselines de texto na seguinte captura de tela estão ligeiramente desalinhadas:

![Screenshot with show baselines enabled](/assets/images/docs/tools/devtools/debug-toggle-guidelines-baseline.png)

O widget [Baseline][] pode ser usado para ajustar baselines.

[Baseline]: {{site.api}}/flutter/widgets/Baseline-class.html

Uma linha é desenhada em qualquer [render box][] que tenha uma baseline definida;
baselines alfabéticas são mostradas em verde e ideográficas em amarelo.

Você também pode habilitar isso no código:

<?code-excerpt "lib/show_baselines.dart"?>
```dart
import 'package:flutter/rendering.dart';

void showBaselines() {
  debugPaintBaselinesEnabled = true;
}
```

### Highlight repaints

Esta opção desenha uma borda ao redor de todos os [render boxes][]
que muda de cor cada vez que aquela box é repintada.

[render boxes]: {{site.api}}/flutter/rendering/RenderBox-class.html

Este arco-íris rotativo de cores é útil para encontrar partes do seu app
que estão repintando com muita frequência e potencialmente prejudicando a performance.

Por exemplo, uma pequena animação pode estar fazendo com que uma página inteira
repinte em cada frame.
Envolver a animação em um [widget RepaintBoundary][RepaintBoundary widget] limita
a repintura apenas à animação.

[RepaintBoundary widget]: {{site.api}}/flutter/widgets/RepaintBoundary-class.html

Aqui o indicador de progresso faz com que seu container repinte:

<?code-excerpt "lib/highlight_repaints.dart (everything-repaints)"?>
```dart
class EverythingRepaintsPage extends StatelessWidget {
  const EverythingRepaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Repaint Example')),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
```

![Screen recording of a whole screen repainting](/assets/images/docs/tools/devtools/debug-toggle-guidelines-repaint-1.gif)

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
        child: RepaintBoundary(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
```

![Screen recording of a just a progress indicator repainting](/assets/images/docs/tools/devtools/debug-toggle-guidelines-repaint-2.gif)

Widgets `RepaintBoundary` têm trade-offs. Eles podem ajudar com performance,
mas também têm o overhead de criar um novo canvas,
que usa memória adicional.

Você também pode habilitar esta opção no código:

<?code-excerpt "lib/highlight_repaints.dart (toggle)"?>
```dart
import 'package:flutter/rendering.dart';

void highlightRepaints() {
  debugRepaintRainbowEnabled = true;
}
```

### Highlight oversized images

Esta opção destaca imagens que são muito grandes tanto invertendo suas cores
quanto virando-as verticalmente:

![A highlighted oversized image](/assets/images/docs/tools/devtools/debug-toggle-guidelines-oversized.png)

As imagens destacadas usam mais memória do que o necessário;
por exemplo, uma imagem grande de 5MB exibida em 100 por 100 pixels.

Tais imagens podem causar performance ruim, especialmente em dispositivos de baixo desempenho
e quando você tem muitas imagens, como em uma list view,
este impacto de performance pode se acumular.
Informações sobre cada imagem são impressas no console de debug:

```console
dash.png has a display size of 213×392 but a decode size of 2130×392, which uses an additional 2542KB.
```

Imagens são consideradas muito grandes se usarem pelo menos 128KB a mais do que o necessário.

#### Corrigindo imagens

Sempre que possível, a melhor maneira de corrigir este problema é redimensionar
o arquivo de asset de imagem para que seja menor.

Se isso não for possível, você pode usar os parâmetros `cacheHeight` e `cacheWidth`
no construtor `Image`:

<?code-excerpt "lib/oversized_images.dart (resized-image)"?>
```dart
class ResizedImage extends StatelessWidget {
  const ResizedImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'dash.png',
      cacheHeight: 213,
      cacheWidth: 392,
    );
  }
}
```

Isso faz com que a engine decodifique esta imagem no tamanho especificado,
e reduz o uso de memória (decodificação e armazenamento ainda são mais caros
do que se o asset de imagem em si fosse reduzido).
A imagem é renderizada nas constraints do layout ou largura e altura
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

* [Documentação Flutter: debugInvertOversizedImages]({{site.api}}/flutter/painting/debugInvertOversizedImages.html)

[render box]: {{site.api}}/flutter/rendering/RenderBox-class.html

## Details Tree

Selecione a aba **Widget Details Tree** para exibir a árvore de detalhes para o
widget selecionado. Daqui, você pode coletar informações úteis sobre as
propriedades, render object e filhos de um widget.

![The Details Tree view](/assets/images/docs/tools/devtools/inspector_details_tree.png){:width="100%"}

## Track widget creation

Parte da funcionalidade do Flutter inspector é baseada em
instrumentar o código da aplicação para entender melhor
as localizações de origem onde widgets são criados. A
instrumentação de origem permite que o Flutter inspector apresente a
árvore de widgets de maneira semelhante a como a UI foi definida
no seu código-fonte. Sem ela, a árvore de nós na
árvore de widgets é muito mais profunda, e pode ser mais difícil
entender como a hierarquia de widgets em tempo de execução corresponde
à UI da sua aplicação.

Você pode desabilitar este recurso passando `--no-track-widget-creation` para
o comando `flutter run`.

Aqui estão exemplos de como sua árvore de widgets pode parecer
com e sem track widget creation habilitado.

Track widget creation habilitado (padrão):

![The widget tree with track widget creation enabled](/assets/images/docs/tools/devtools/track_widget_creation_enabled.png){:width="100%"}

Track widget creation desabilitado (não recomendado):

![The widget tree with track widget creation disabled](/assets/images/docs/tools/devtools/track_widget_creation_disabled.png){:width="100%"}

Este recurso impede que widgets `const` idênticos sejam
considerados iguais em compilações de debug. Para mais detalhes, veja
a discussão sobre [problemas comuns ao depurar][common problems when debugging].

## Configurações do Inspector

![The Flutter Inspector Settings dialog](/assets/images/docs/tools/devtools/flutter_inspector_settings.png){:width="100%"}

### Enable hover inspection

Passar o mouse sobre qualquer widget exibe suas propriedades e valores.

Alternar este valor habilita ou desabilita a funcionalidade de inspeção por hover.

### Package directories

Por padrão, DevTools limita os widgets exibidos na árvore de widgets
àqueles do diretório raiz do projeto e aqueles do Flutter. Esta
filtragem se aplica apenas aos widgets na Inspector Widget Tree (lado esquerdo
do Inspector)—não na Widget Details Tree (lado direito do Inspector
na mesma visualização de aba que o Layout Explorer).
Na Widget Details Tree,
você pode ver todos os widgets na árvore de todos os pacotes.

Para mostrar outros widgets,
um diretório pai deles deve
ser adicionado aos Package Directories.

Por exemplo, considere a seguinte estrutura de diretórios:

```plaintext
project_foo
  pkgs
    project_foo_app
    widgets_A
    widgets_B
```

Executar seu app de `project_foo_app` exibe apenas widgets de
`project_foo/pkgs/project_foo_app` na árvore do widget inspector.

Para mostrar widgets de `widgets_A` na árvore de widgets,
adicione `project_foo/pkgs/widgets_A` aos package directories.

Para exibir _todos_ os widgets da raiz do seu projeto na árvore de widgets,
adicione `project_foo` aos package directories.

Mudanças nos seus package directories persistem na próxima vez que o
widget inspector for aberto para o app.

## Outros recursos

Para uma demonstração do que geralmente é possível com o inspector,
veja a [palestra DartConf 2018][DartConf 2018 talk] demonstrando a versão IntelliJ
do Flutter inspector.

Para aprender como depurar visualmente problemas de layout
usando DevTools, confira um
[tutorial guiado do Flutter Inspector][inspector-tutorial].

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
