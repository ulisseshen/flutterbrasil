---
ia-translate: true
title: Usar o inspetor do Flutter
description: Aprenda a usar o inspetor do Flutter para explorar a árvore de widgets de um app Flutter.
---

<?code-excerpt path-base="visual_debugging/"?>

:::note
O inspetor funciona com todos os aplicativos Flutter.
:::

## O que é?

O inspetor de widgets do Flutter é uma ferramenta poderosa para visualizar e
explorar árvores de widgets do Flutter. O framework Flutter usa widgets
como blocos de construção essenciais para tudo, desde controles
(como texto, botões e toggles),
até layouts (como centralização, preenchimento, linhas e colunas).
O inspetor ajuda você a visualizar e explorar a árvore de widgets do Flutter,
e pode ser usado para o seguinte:

* entender layouts existentes
* diagnosticar problemas de layout

![Captura de tela da janela do inspetor do Flutter](/assets/images/docs/tools/devtools/inspector_screenshot.png){:width="100%"}

## Começar

Para depurar um problema de layout, execute o aplicativo em [modo de depuração][] e
abra o inspetor clicando na aba **Flutter Inspector** na barra de ferramentas do DevTools.

:::note
Você ainda pode acessar o inspetor do Flutter diretamente do
Android Studio/IntelliJ, mas talvez prefira a visualização
mais espaçosa ao executá-lo a partir do DevTools
em um navegador.
:::

### Depurando problemas de layout visualmente

O seguinte é um guia para os recursos disponíveis na
barra de ferramentas do inspetor. Quando o espaço é limitado, o ícone é
usado como a versão visual do rótulo.

![Ícone do modo de seleção de widget](/assets/images/docs/tools/devtools/select-widget-mode-icon.png){:width="20px"} **Modo de seleção de widget**
: Habilite este botão para selecionar
  um widget no dispositivo para inspecioná-lo. Para saber mais,
  confira [Inspecionando um widget](#inspecionando-um-widget).

![Ícone de atualização da árvore](/assets/images/docs/tools/devtools/refresh-tree-icon.png){:width="20px"} **Atualizar árvore**
: Recarrega as informações do widget atual.

![Ícone de animações lentas](/assets/images/docs/tools/devtools/slow-animations-icon.png){:width="20px"} **[Animações lentas][]**
: Executa animações 5 vezes mais lentas para ajudar a ajustá-las.

![Ícone de modo de exibição de guias](/assets/images/docs/tools/devtools/debug-paint-mode-icon.png){:width="20px"} **[Exibir guias][]**
: Sobrepõe guias para auxiliar na correção de problemas de layout.

![Ícone de exibição de linhas de base](/assets/images/docs/tools/devtools/paint-baselines-icon.png){:width="20px"} **[Exibir linhas de base][]**
: Exibe linhas de base, que são usadas para alinhar texto.
  Pode ser útil para verificar se o texto está alinhado.

![Ícone de realce de repinturas](/assets/images/docs/tools/devtools/repaint-rainbow-icon.png){:width="20px"} **[Realçar repinturas][]**
: Exibe bordas que mudam de cor quando os elementos são repintados.
  Útil para encontrar repinturas desnecessárias.

![Ícone de realce de imagens superdimensionadas](/assets/images/docs/tools/devtools/invert_oversized_images_icon.png){:width="20px"} **[Realçar imagens superdimensionadas][]**
: Realça imagens que estão usando muita memória
  invertendo as cores e espelhando-as.

[Animações lentas]: #animações-lentas
[Exibir guias]: #exibir-guias
[Exibir linhas de base]: #exibir-linhas-de-base
[Realçar repinturas]: #realçar-repinturas
[Realçar imagens superdimensionadas]: #realçar-imagens-superdimensionadas

## Inspecionando um widget

Você pode navegar pela árvore de widgets interativa para visualizar widgets
próximos e ver seus valores de campo.

Para localizar elementos de UI individuais na árvore de widgets,
clique no botão **Modo de Seleção de Widget** na barra de ferramentas.
Isso coloca o aplicativo no dispositivo em um modo de "seleção de widget".
Clique em qualquer widget na UI do aplicativo; isso seleciona o widget na
tela do aplicativo e rola a árvore de widgets para o nó correspondente.
Alterne o botão **Modo de Seleção de Widget** novamente para sair
do modo de seleção de widget.

Ao depurar problemas de layout, os principais campos a serem observados são os
campos `tamanho` e `restrições`. As restrições fluem pela árvore,
e os tamanhos fluem de volta para cima. Para mais informações sobre como isso funciona,
consulte [Entendendo restrições][].

## Explorador de Layout do Flutter

O Explorador de Layout do Flutter ajuda você a entender melhor
os layouts do Flutter.

Para uma visão geral do que você pode fazer com essa ferramenta, veja
o vídeo do Explorador do Flutter:

{% ytEmbed 'Jakrc3Tn_y4', 'DevTools Layout Explorer' %}

Você também pode achar o seguinte artigo passo a passo útil:

* [Como depurar problemas de layout com o Inspetor do Flutter][debug-article]

[debug-article]: {{site.flutter-medium}}/how-to-debug-layout-issues-with-the-flutter-inspector-87460a7b9db

### Usar o Explorador de Layout

A partir do Inspetor do Flutter, selecione um widget. O Explorador de Layout
suporta layouts [flex][] e layouts de tamanho fixo, e possui
ferramentas específicas para ambos os tipos.

#### Layouts flex

Quando você seleciona um widget flex (por exemplo, [`Row`][], [`Column`][], [`Flex`][])
ou um filho direto de um widget flex, a ferramenta de layout flex aparecerá
no Explorador de Layout.

O Explorador de Layout visualiza como os widgets [`Flex`][] e seus
filhos são dispostos. O explorador identifica o eixo principal
e o eixo cruzado, bem como o alinhamento atual para cada um
(por exemplo, início, fim e spaceBetween).
Ele também mostra detalhes como fator flex, ajuste flex e restrições
de layout.

Além disso, o explorador mostra violações de restrições de layout
e erros de estouro de renderização. Restrições de layout violadas
são coloridas em vermelho, e erros de estouro são apresentados no
padrão "fita amarela" padrão, como você pode ver em um dispositivo em execução.
Essas visualizações visam melhorar a compreensão de
por que ocorrem erros de estouro, bem como como corrigi-los.

![O Explorador de Layout mostrando erros e o inspetor do dispositivo](/assets/images/docs/tools/devtools/layout_explorer_errors_and_device.gif){:width="100%"}

Clicar em um widget no explorador de layout espelha
a seleção no inspetor no dispositivo. O **Modo de Seleção de Widget**
precisa estar habilitado para isso. Para habilitá-lo,
clique no botão **Modo de Seleção de Widget** no inspetor.

![O botão Modo de Seleção de Widget no inspetor](/assets/images/docs/tools/devtools/select_widget_mode_button.png)

Para algumas propriedades, como fator flex, ajuste flex e alinhamento,
você pode modificar o valor por meio de listas suspensas no explorador.
Ao modificar uma propriedade de widget, você verá o novo valor refletido
não apenas no Explorador de Layout, mas também no
dispositivo executando seu aplicativo Flutter. O explorador anima
as alterações de propriedade para que o efeito da alteração seja claro.
Alterações de propriedades de widget feitas a partir do explorador de layout
não modificam seu código-fonte e são revertidas na recarga dinâmica.

##### Propriedades Interativas

O Explorador de Layout suporta a modificação de [`mainAxisAlignment`][],
[`crossAxisAlignment`][] e [`FlexParentData.flex`][].
No futuro, podemos adicionar suporte para propriedades adicionais
como [`mainAxisSize`][], [`textDirection`][] e
[`FlexParentData.fit`][].

###### mainAxisAlignment

![O Explorador de Layout alterando o alinhamento do eixo principal](/assets/images/docs/tools/devtools/layout_explorer_main_axis_alignment.gif){:width="100%"}

Valores suportados:

* `MainAxisAlignment.start`
* `MainAxisAlignment.end`
* `MainAxisAlignment.center`
* `MainAxisAlignment.spaceBetween`
* `MainAxisAlignment.spaceAround`
* `MainAxisAlignment.spaceEvenly`

###### crossAxisAlignment

![O Explorador de Layout alterando o alinhamento do eixo cruzado](/assets/images/docs/tools/devtools/layout_explorer_cross_axis_alignment.gif){:width="100%"}

Valores suportados:

* `CrossAxisAlignment.start`
* `CrossAxisAlignment.center`
* `CrossAxisAlignment.end`
* `CrossAxisAlignment.stretch`

###### FlexParentData.flex

![O Explorador de Layout alterando o fator flex](/assets/images/docs/tools/devtools/layout_explorer_flex.gif){:width="100%"}

O Explorador de Layout suporta 7 opções flex na interface do usuário
(null, 0, 1, 2, 3, 4, 5), mas tecnicamente o flex
fator do filho de um widget flex pode ser qualquer int.

###### Flexible.fit

![O Explorador de Layout alterando o ajuste](/assets/images/docs/tools/devtools/layout_explorer_fit.gif){:width="100%"}

O Explorador de Layout suporta os dois tipos diferentes de
[`FlexFit`][]: `loose` e `tight`.

#### Layouts de tamanho fixo

Quando você seleciona um widget de tamanho fixo que não é filho
de um widget flex, informações de layout de tamanho fixo aparecerão
no Explorador de Layout. Você pode ver informações de tamanho, restrição e preenchimento
tanto para o widget selecionado quanto para o RenderObject upstream mais próximo.

![A ferramenta de tamanho fixo do Explorador de Layout](/assets/images/docs/tools/devtools/layout_explorer_fixed_layout.png){:width="100%"}

## Depuração visual

O Inspetor do Flutter fornece várias opções para depurar visualmente seu aplicativo.

![Opções de depuração visual do inspetor](/assets/images/docs/tools/devtools/visual_debugging_options.png){:width="100%"}

### Animações lentas

Quando habilitada, essa opção executa animações 5 vezes mais lentas para facilitar a
inspeção visual.
Isso pode ser útil se você quiser observar cuidadosamente e ajustar uma animação que
não parece muito certa.

Isso também pode ser definido no código:

<?code-excerpt "lib/slow_animations.dart"?>
```dart
import 'package:flutter/scheduler.dart';

void setSlowAnimations() {
  timeDilation = 5.0;
}
```

Isso diminui as animações em 5x.

#### Veja também

Os links a seguir fornecem mais informações.

* [Documentação do Flutter: propriedade timeDilation]({{site.api}}/flutter/scheduler/timeDilation.html)

As gravações de tela a seguir mostram antes e depois de desacelerar uma animação.

![Gravação de tela mostrando a velocidade normal da animação](/assets/images/docs/tools/devtools/debug-toggle-slow-animations-disabled.gif)
![Gravação de tela mostrando a velocidade da animação diminuída](/assets/images/docs/tools/devtools/debug-toggle-slow-animations-enabled.gif)

### Exibir guias

Esse recurso desenha guias sobre seu aplicativo que exibem caixas de renderização,
alinhamentos, preenchimentos, visualizações de rolagem, recortes e espaçadores.

Essa ferramenta pode ser usada para entender melhor seu layout. Por exemplo,
encontrando preenchimento indesejado ou entendendo o alinhamento do widget.

Você também pode habilitar isso no código:

<?code-excerpt "lib/layout_guidelines.dart"?>
```dart
import 'package:flutter/rendering.dart';

void showLayoutGuidelines() {
  debugPaintSizeEnabled = true;
}
```

#### Caixas de renderização

Widgets que desenham na tela criam uma [caixa de renderização][], os
blocos de construção dos layouts do Flutter. Eles são mostrados com uma borda azul brilhante:

![Captura de tela das diretrizes da caixa de renderização](/assets/images/docs/tools/devtools/debug-toggle-guideline-render-box.png)

#### Alinhamentos

Os alinhamentos são mostrados com setas amarelas. Essas setas mostram os
deslocamentos vertical e horizontal de um widget em relação ao seu pai.
Por exemplo, o ícone deste botão é mostrado como sendo centralizado pelas quatro setas:

![Captura de tela das diretrizes de alinhamento](/assets/images/docs/tools/devtools/debug-toggle-guidelines-alignment.png)

#### Preenchimento

O preenchimento é mostrado com um fundo azul semitransparente:

![Captura de tela das diretrizes de preenchimento](/assets/images/docs/tools/devtools/debug-toggle-guidelines-padding.png)

#### Visualizações de rolagem

Widgets com conteúdo de rolagem (como visualizações de lista) são mostrados com setas verdes:

![Captura de tela das diretrizes de visualização de rolagem](/assets/images/docs/tools/devtools/debug-toggle-guidelines-scroll.png)

#### Recorte

O recorte, por exemplo, ao usar o [widget ClipRect][], é mostrado
com uma linha rosa tracejada com um ícone de tesoura:

[widget ClipRect]: {{site.api}}/flutter/widgets/ClipRect-class.html

![Captura de tela das diretrizes de recorte](/assets/images/docs/tools/devtools/debug-toggle-guidelines-clip.png)

#### Espaçadores

Widgets espaçadores são mostrados com um fundo cinza,
como este `SizedBox` sem um filho:

![Captura de tela das diretrizes de espaçador](/assets/images/docs/tools/devtools/debug-toggle-guidelines-spacer.png)

### Exibir linhas de base

Esta opção torna todas as linhas de base visíveis.
Linhas de base são linhas horizontais usadas para posicionar texto.

Isso pode ser útil para verificar se o texto está alinhado verticalmente com precisão.
Por exemplo, as linhas de base de texto na captura de tela a seguir estão ligeiramente desalinhadas:

![Captura de tela com exibir linhas de base habilitado](/assets/images/docs/tools/devtools/debug-toggle-guidelines-baseline.png)

O widget [Baseline][] pode ser usado para ajustar as linhas de base.

[Baseline]: {{site.api}}/flutter/widgets/Baseline-class.html

Uma linha é desenhada em qualquer [caixa de renderização][] que tenha uma linha de base definida;
linhas de base alfabéticas são mostradas em verde e ideográficas em amarelo.

Você também pode habilitar isso no código:

<?code-excerpt "lib/show_baselines.dart"?>
```dart
import 'package:flutter/rendering.dart';

void showBaselines() {
  debugPaintBaselinesEnabled = true;
}
```

### Realçar repinturas

Essa opção desenha uma borda ao redor de todas as [caixas de renderização][]
que muda de cor toda vez que essa caixa é repintada.

[caixas de renderização]: {{site.api}}/flutter/rendering/RenderBox-class.html

Esse arco-íris rotativo de cores é útil para encontrar partes do seu aplicativo
que estão sendo repintadas com muita frequência e, potencialmente, prejudicando o desempenho.

Por exemplo, uma pequena animação pode estar fazendo com que uma página inteira
seja repintada em cada quadro.
Envolver a animação em um [widget RepaintBoundary][] limita
a repintura apenas à animação.

[widget RepaintBoundary]: {{site.api}}/flutter/widgets/RepaintBoundary-class.html

Aqui, o indicador de progresso faz com que seu contêiner seja repintado:

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

![Gravação de tela de uma tela inteira sendo repintada](/assets/images/docs/tools/devtools/debug-toggle-guidelines-repaint-1.gif)

Envolver o indicador de progresso em um `RepaintBoundary` faz com que
apenas essa seção da tela seja repintada:

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

![Gravação de tela de apenas um indicador de progresso sendo repintado](/assets/images/docs/tools/devtools/debug-toggle-guidelines-repaint-2.gif)

Os widgets `RepaintBoundary` têm compensações. Eles podem ajudar no desempenho,
mas também têm uma sobrecarga de criação de um novo canvas,
que usa memória adicional.

Você também pode habilitar essa opção no código:

<?code-excerpt "lib/highlight_repaints.dart (toggle)"?>
```dart
import 'package:flutter/rendering.dart';

void highlightRepaints() {
  debugRepaintRainbowEnabled = true;
}
```

### Realçar imagens superdimensionadas

Essa opção realça imagens que são muito grandes invertendo suas cores
e espelhando-as verticalmente:

![Uma imagem superdimensionada realçada](/assets/images/docs/tools/devtools/debug-toggle-guidelines-oversized.png)

As imagens realçadas usam mais memória do que o necessário;
por exemplo, uma imagem grande de 5 MB exibida em 100 por 100 pixels.

Tais imagens podem causar baixo desempenho, especialmente em dispositivos
de baixo custo, e quando você tem muitas imagens, como em uma visualização
de lista, esse impacto no desempenho pode aumentar.
Informações sobre cada imagem são impressas no console de depuração:

```console
dash.png tem um tamanho de exibição de 213×392, mas um tamanho de decodificação de 2130×392, o que usa 2542KB adicionais.
```

Imagens são consideradas muito grandes se usarem pelo menos 128 KB a mais do que o necessário.

#### Corrigindo imagens

Sempre que possível, a melhor maneira de corrigir esse problema é redimensionar
o arquivo de ativos de imagem para que seja menor.

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

Isso faz com que o mecanismo decodifique essa imagem no tamanho especificado
e reduz o uso de memória (a decodificação e o armazenamento ainda são mais caros
do que se o ativo de imagem em si fosse reduzido).
A imagem é renderizada para as restrições do layout ou largura e altura,
independentemente desses parâmetros.

Essa propriedade também pode ser definida no código:

<?code-excerpt "lib/oversized_images.dart (toggle)"?>
```dart
void showOversizedImages() {
  debugInvertOversizedImages = true;
}
```

#### Mais informações

Você pode saber mais no link a seguir:

* [Documentação do Flutter: debugInvertOversizedImages]({{site.api}}/flutter/painting/debugInvertOversizedImages.html)

[caixa de renderização]: {{site.api}}/flutter/rendering/RenderBox-class.html

## Árvore de detalhes

Selecione a aba **Árvore de Detalhes do Widget** para exibir a árvore de detalhes
para o widget selecionado. A partir daqui, você pode coletar informações úteis
sobre as propriedades, o objeto de renderização e os filhos de um widget.

![A visualização da Árvore de Detalhes](/assets/images/docs/tools/devtools/inspector_details_tree.png){:width="100%"}

## Rastrear a criação de widget

Parte da funcionalidade do Inspetor do Flutter é baseada na
instrumentação do código do aplicativo, a fim de entender melhor
os locais de origem onde os widgets são criados. A instrumentação
de origem permite que o inspetor do Flutter apresente a
árvore de widgets de maneira semelhante a como a UI foi definida
em seu código-fonte. Sem ela, a árvore de nós na árvore de widgets
é muito mais profunda, e pode ser mais difícil de
entender como a hierarquia de widgets de tempo de execução corresponde
à UI do seu aplicativo.

Você pode desabilitar este recurso passando `--no-track-widget-creation`
para o comando `flutter run`.

Aqui estão exemplos de como sua árvore de widgets pode ser
com e sem o rastreamento de criação de widget habilitado.

Rastreamento de criação de widget habilitado (padrão):

![A árvore de widgets com o rastreamento de criação de widget habilitado](/assets/images/docs/tools/devtools/track_widget_creation_enabled.png){:width="100%"}

Rastreamento de criação de widget desabilitado (não recomendado):

![A árvore de widgets com o rastreamento de criação de widget desabilitado](/assets/images/docs/tools/devtools/track_widget_creation_disabled.png){:width="100%"}

Este recurso impede que widgets `const` que, de outra forma,
seriam idênticos, sejam considerados iguais em builds de depuração.
Para mais detalhes, veja a discussão sobre
[problemas comuns ao depurar][].

## Configurações do inspetor

![A caixa de diálogo Configurações do Inspetor do Flutter](/assets/images/docs/tools/devtools/flutter_inspector_settings.png){:width="100%"}

### Habilitar inspeção ao passar o mouse

Passar o mouse sobre qualquer widget exibe suas propriedades e valores.

Alternar esse valor habilita ou desabilita a funcionalidade de inspeção
ao passar o mouse.

### Diretórios de pacote

Por padrão, o DevTools limita os widgets exibidos na árvore de widgets
àqueles do diretório raiz do projeto e àqueles do Flutter. Este
filtragem se aplica apenas aos widgets na Árvore de Widgets do Inspetor
(lado esquerdo do Inspetor) – não na Árvore de Detalhes do Widget (lado
direito do Inspetor na mesma visualização de aba que o Explorador de Layout).
Na Árvore de Detalhes do Widget, você pode ver todos os widgets
na árvore de todos os pacotes.

Para mostrar outros widgets,
um diretório pai deles deve ser adicionado aos Diretórios de Pacote.

Por exemplo, considere a seguinte estrutura de diretório:

```plaintext
project_foo
  pkgs
    project_foo_app
    widgets_A
    widgets_B
```

Executar seu aplicativo de `project_foo_app` exibe apenas widgets de
`project_foo/pkgs/project_foo_app` na árvore do inspetor de widgets.

Para mostrar widgets de `widgets_A` na árvore de widgets, adicione
`project_foo/pkgs/widgets_A` aos diretórios de pacote.

Para exibir _todos_ os widgets da raiz do seu projeto na árvore de widgets,
adicione `project_foo` aos diretórios de pacote.

Alterações nos diretórios de pacote são mantidas na próxima vez que
o inspetor de widgets for aberto para o aplicativo.

## Outros recursos

Para uma demonstração do que geralmente é possível com o inspetor,
veja a [palestra do DartConf 2018][] demonstrando a versão do IntelliJ
do inspetor do Flutter.

Para aprender como depurar visualmente problemas de layout
usando o DevTools, confira um
[tutorial guiado do Inspetor do Flutter][inspector-tutorial].

[`Column`]: {{site.api}}/flutter/widgets/Column-class.html
[problemas comuns ao depurar]: /testing/debugging
[`crossAxisAlignment`]: {{site.api}}/flutter/widgets/Flex/crossAxisAlignment.html
[palestra do DartConf 2018]: {{site.yt.watch}}?v=JIcmJNT9DNI
[modo de depuração]: /testing/build-modes#debug
[`Flex`]: {{site.api}}/flutter/widgets/Flex-class.html
[layouts flex]: {{site.api}}/flutter/widgets/Flex-class.html
[`FlexFit`]: {{site.api}}/flutter/rendering/FlexFit.html
[`FlexParentData.fit`]: {{site.api}}/flutter/rendering/FlexParentData/fit.html
[`FlexParentData.flex`]: {{site.api}}/flutter/rendering/FlexParentData/flex.html
[`mainAxisAlignment`]: {{site.api}}/flutter/widgets/Flex/mainAxisAlignment.html
[`mainAxisSize`]: {{site.api}}/flutter/widgets/Flex/mainAxisSize.html
[`Row`]: {{site.api}}/flutter/widgets/Row-class.html
[`textDirection`]: {{site.api}}/flutter/widgets/Flex/textDirection.html
[Entendendo restrições]: /ui/layout/constraints
[inspector-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-flutter-inspector-part-2-of-8-bbff40692fc7
