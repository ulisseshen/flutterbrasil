---
title: Adaptações automáticas de plataforma
description: Saiba mais sobre a adaptabilidade de plataforma do Flutter.
ia-translate: true
---

## Filosofia de adaptação

Em geral, existem dois casos de adaptabilidade de plataforma:

1. Coisas que são comportamentos do ambiente do SO
   (como edição de texto e rolagem) e que
   estariam 'erradas' se um comportamento diferente ocorresse.
2. Coisas que são convencionalmente implementadas em aplicativos usando
   os SDKs do OEM (como usar abas paralelas no iOS ou
   mostrar um [`android.app.AlertDialog`][] no Android).

Este artigo cobre principalmente as adaptações automáticas
fornecidas pelo Flutter no caso 1 no Android e iOS.

Para o caso 2, o Flutter agrupa os meios para produzir os
efeitos apropriados das convenções da plataforma, mas não
se adapta automaticamente quando escolhas de design de aplicativo são necessárias.
Para uma discussão, veja [issue #8410][] e a
[definição do problema de widget adaptativo Material/Cupertino][Material/Cupertino adaptive widget problem definition].

Para um exemplo de um aplicativo usando diferentes estruturas de
arquitetura de informação no Android e iOS, mas compartilhando
o mesmo código de conteúdo, veja os [exemplos de código platform_design][platform_design code samples].

:::secondary
Guias preliminares abordando o caso 2
estão sendo adicionados à seção de componentes de UI.
Você pode solicitar guias adicionais comentando na [issue #8427][8427].
:::

[`android.app.AlertDialog`]: {{site.android-dev}}/reference/android/app/AlertDialog.html
[issue #8410]: {{site.repo.flutter}}/issues/8410#issuecomment-468034023
[Material/Cupertino adaptive widget problem definition]: https://bit.ly/flutter-adaptive-widget-problem
[platform_design code samples]: {{site.repo.samples}}/tree/main/platform_design

## Navegação de página

O Flutter fornece os padrões de navegação vistos no Android
e iOS e também adapta automaticamente a animação de navegação
para a plataforma atual.

### Transições de navegação

No **Android**, a transição padrão do [`Navigator.push()`][]
é modelada após [`startActivity()`][],
que geralmente tem uma variante de animação de baixo para cima.

No **iOS**:

* A API padrão [`Navigator.push()`][] produz uma
  transição de estilo Show/Push do iOS que anima do
  final para o início dependendo da configuração RTL da localidade.
  A página atrás da nova rota também desliza em paralaxe
  na mesma direção como no iOS.
* Um estilo de transição separado de baixo para cima existe ao
  empurrar uma rota de página onde [`PageRoute.fullscreenDialog`][]
  é true. Isso representa a transição de estilo Present/Modal do iOS
  e é normalmente usado em páginas modais em tela cheia.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img style="border-radius: 12px;" src="/assets/images/docs/platform-adaptations/navigation-android.gif" class="figure-img img-fluid" alt="An animation of the bottom-up page transition on Android" />
        <figcaption class="figure-caption">
          Transição de página no Android
        </figcaption>
      </figure>
    </div>
    <div class="col-sm text-center">
      <figure class="figure">
        <img style="border-radius: 22px;" src="/assets/images/docs/platform-adaptations/navigation-ios.gif" class="figure-img img-fluid" alt="An animation of the end-start style push page transition on iOS" />
        <figcaption class="figure-caption">
          Transição push no iOS
        </figcaption>
      </figure>
    </div>
    <div class="col-sm text-center">
      <figure class="figure">
        <img style="border-radius: 22px;" src="/assets/images/docs/platform-adaptations/navigation-ios-modal.gif" class="figure-img img-fluid" alt="An animation of the bottom-up style present page transition on iOS" />
        <figcaption class="figure-caption">
          Transição present no iOS
        </figcaption>
      </figure>
    </div>
  </div>
</div>

[`Navigator.push()`]: {{site.api}}/flutter/widgets/Navigator/push.html
[`startActivity()`]: {{site.android-dev}}/reference/kotlin/android/app/Activity#startactivity
[`PageRoute.fullscreenDialog`]: {{site.api}}/flutter/widgets/PageRoute-class.html

### Detalhes de transição específicos da plataforma

No **Android**, o Flutter usa a animação [`ZoomPageTransitionsBuilder`][].
Quando o usuário toca em um item, a UI amplia para uma tela que apresenta esse item.
Quando o usuário toca para voltar, a UI reduz para a tela anterior.

No **iOS**, quando a transição de estilo push é usada,
as barras de navegação [`CupertinoNavigationBar`][]
e [`CupertinoSliverNavigationBar`][] empacotadas do Flutter
animam automaticamente cada subcomponente para seu subcomponente correspondente
na `CupertinoNavigationBar` ou `CupertinoSliverNavigationBar`
da próxima ou anterior página.

<div class="container">
  <div class="row">
    <div class="col-sm">
      <figure class="figure text-center">
      <img style="border-radius: 12px; height: 400px;" class="figure-img img-fluid" height="400" width="185" alt="An animation of the page transition on Android" src="/assets/images/docs/platform-adaptations/android-zoom-animation.png" />
        <figcaption class="figure-caption">
          Android
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img style="border-radius: 22px;" src="/assets/images/docs/platform-adaptations/navigation-ios-nav-bar.gif" class="figure-img img-fluid" alt="An animation of the nav bar transitions during a page transition on iOS" />
        <figcaption class="figure-caption">
          Nav Bar do iOS
        </figcaption>
      </figure>
    </div>
  </div>
</div>

[`ZoomPageTransitionsBuilder`]: {{site.api}}/flutter/material/ZoomPageTransitionsBuilder-class.html
[`CupertinoNavigationBar`]: {{site.api}}/flutter/cupertino/CupertinoNavigationBar-class.html
[`CupertinoSliverNavigationBar`]: {{site.api}}/flutter/cupertino/CupertinoSliverNavigationBar-class.html

### Navegação de retorno

No **Android**,
o botão Voltar do SO, por padrão, é enviado para o Flutter
e retira a rota superior do Navigator do [`WidgetsApp`][].

No **iOS**,
um gesto de deslizar na borda pode ser usado para retirar a rota superior.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img style="border-radius: 12px;" src="/assets/images/docs/platform-adaptations/navigation-android-back.gif" class="figure-img img-fluid" alt="A page transition triggered by the Android back button" />
        <figcaption class="figure-caption">
          Botão Voltar do Android
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img style="border-radius: 22px;" src="/assets/images/docs/platform-adaptations/navigation-ios-back.gif" class="figure-img img-fluid" alt="A page transition triggered by an iOS back swipe gesture" />
        <figcaption class="figure-caption">
          Gesto de deslizar para voltar do iOS
        </figcaption>
      </figure>
    </div>
  </div>
</div>

[`WidgetsApp`]: {{site.api}}/flutter/widgets/WidgetsApp-class.html

## Rolagem

A rolagem é uma parte importante da aparência e sensação
da plataforma, e o Flutter ajusta automaticamente
o comportamento de rolagem para corresponder à plataforma atual.

### Simulação de física

Android e iOS têm simulações de física de rolagem
complexas que são difíceis de descrever verbalmente.
Geralmente, o rolável do iOS tem mais peso e
atrito dinâmico, mas o Android tem mais atrito estático.
Portanto, o iOS ganha alta velocidade mais gradualmente, mas para
menos abruptamente e é mais escorregadio em velocidades baixas.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/scroll-soft.gif" class="figure-img img-fluid rounded" alt="A soft fling where the iOS scrollable slid longer at lower speed than Android" />
        <figcaption class="figure-caption">
          Comparação de rolagem suave
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/scroll-medium.gif" class="figure-img img-fluid rounded" alt="A medium force fling where the Android scrollable reached speed faster and stopped more abruptly after reaching a longer distance" />
        <figcaption class="figure-caption">
          Comparação de rolagem média
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/scroll-strong.gif" class="figure-img img-fluid rounded" alt="A strong fling where the Android scrollable reach speed faster and reached significantly more distance" />
        <figcaption class="figure-caption">
          Comparação de rolagem forte
        </figcaption>
      </figure>
    </div>
  </div>
</div>

### Comportamento de overscroll

No **Android**,
rolar além da borda de um rolável mostra um
[indicador de brilho de overscroll][overscroll glow indicator] (baseado na cor
do tema Material atual).

No **iOS**, rolar além da borda de um rolável
[faz overscroll][overscrolls] com resistência crescente e volta.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/scroll-overscroll.gif" class="figure-img img-fluid rounded" alt="Android and iOS scrollables being flung past their edge and exhibiting platform specific overscroll behavior" />
        <figcaption class="figure-caption">
          Comparação de overscroll dinâmico
        </figcaption>
      </figure>
    </div>
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/scroll-static-overscroll.gif" class="figure-img img-fluid rounded" alt="Android and iOS scrollables being overscrolled from a resting position and exhibiting platform specific overscroll behavior" />
        <figcaption class="figure-caption">
          Comparação de overscroll estático
        </figcaption>
      </figure>
    </div>
  </div>
</div>

[overscroll glow indicator]: {{site.api}}/flutter/widgets/GlowingOverscrollIndicator-class.html
[overscrolls]: {{site.api}}/flutter/widgets/BouncingScrollPhysics-class.html

### Momento

No **iOS**,
rolagens repetidas na mesma direção acumulam momento
e constroem mais velocidade a cada rolagem sucessiva.
Não há comportamento equivalente no Android.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/scroll-momentum-ios.gif" class="figure-img img-fluid rounded" alt="Repeated scroll flings building momentum on iOS" />
        <figcaption class="figure-caption">
          Momento de rolagem no iOS
        </figcaption>
      </figure>
    </div>
  </div>
</div>

### Retornar ao topo

No **iOS**,
tocar na barra de status do SO rola o controlador
de rolagem primário para a posição superior.
Não há comportamento equivalente no Android.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img style="border-radius: 22px;" src="/assets/images/docs/platform-adaptations/scroll-tap-to-top-ios.gif" class="figure-img img-fluid" alt="Tapping the status bar scrolls the primary scrollable back to the top" />
        <figcaption class="figure-caption">
          Toque na barra de status para ir ao topo no iOS
        </figcaption>
      </figure>
    </div>
  </div>
</div>

## Tipografia

Ao usar o pacote Material,
a tipografia automaticamente padrão para a
família de fontes apropriada para a plataforma.
O Android usa a fonte Roboto.
O iOS usa a fonte San Francisco.

Ao usar o pacote Cupertino, o [tema padrão][default theme]
usa a fonte San Francisco.

A licença da fonte San Francisco limita seu uso a
software executado apenas no iOS, macOS ou tvOS.
Portanto, uma fonte substituta é usada ao executar no Android
se a plataforma for sobrescrita em debug para iOS ou o
tema Cupertino padrão for usado.

Você pode optar por adaptar o estilo de texto dos widgets Material
para corresponder ao estilo de texto padrão no iOS.
Você pode ver exemplos específicos de widgets na
[seção de Componentes de UI](#ui-components).

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/typography-android.png" class="figure-img img-fluid rounded" alt="Roboto font on Android" />
        <figcaption class="figure-caption">
          Roboto no Android
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/typography-ios.png" class="figure-img img-fluid rounded" alt="San Francisco font on iOS" />
        <figcaption class="figure-caption">
          San Francisco no iOS
        </figcaption>
      </figure>
    </div>
  </div>
</div>

[default theme]: {{site.repo.flutter}}/blob/main/packages/flutter/lib/src/cupertino/text_theme.dart

## Iconografia

Ao usar o pacote Material,
certos ícones mostram automaticamente gráficos diferentes
dependendo da plataforma.
Por exemplo, os três pontos do botão de overflow
são horizontais no iOS e verticais no Android.
O botão Voltar é um chevron simples no iOS e
tem uma haste no Android.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/iconography-android.png" class="figure-img img-fluid rounded" alt="Android appropriate icons" />
        <figcaption class="figure-caption">
          Ícones no Android
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/iconography-ios.png" class="figure-img img-fluid rounded" alt="iOS appropriate icons" />
        <figcaption class="figure-caption">
          Ícones no iOS
        </figcaption>
      </figure>
    </div>
  </div>
</div>

A biblioteca material também fornece um conjunto de
ícones adaptativos de plataforma através de [`Icons.adaptive`][].

[`Icons.adaptive`]: {{site.api}}/flutter/material/PlatformAdaptiveIcons-class.html

## Feedback háptico

Os pacotes Material e Cupertino automaticamente
acionam o feedback háptico apropriado da plataforma em
certos cenários.

Por exemplo,
uma seleção de palavra via pressão longa no campo de texto aciona uma vibração 'buzz'
no Android e não no iOS.

Rolar pelos itens do picker no iOS aciona um
impacto 'leve' e nenhum feedback no Android.

## Edição de texto

Os campos de entrada de texto Material e Cupertino
suportam verificação ortográfica e se adaptam para usar a
configuração de verificação ortográfica adequada para a plataforma,
e o menu e cores de destaque de verificação ortográfica apropriados.

O Flutter também faz as adaptações abaixo ao editar
o conteúdo dos campos de texto para corresponder à plataforma atual.

### Navegação por gesto no teclado

No **Android**,
deslizes horizontais podem ser feitos na tecla de <kbd>espaço</kbd> do teclado virtual
para mover o cursor nos campos de texto Material e Cupertino.

Em dispositivos **iOS** com capacidades 3D Touch,
um gesto de pressão forçada e arrasto pode ser feito no teclado
virtual para mover o cursor em 2D através de um cursor flutuante.
Isso funciona em campos de texto Material e Cupertino.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/text-keyboard-move-android.gif" class="figure-img img-fluid rounded" alt="Moving the cursor via the space key on Android" />
        <figcaption class="figure-caption">
          Movimento do cursor pela tecla de espaço no Android
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/text-keyboard-move-ios.gif" class="figure-img img-fluid rounded" alt="Moving the cursor via 3D Touch drag on the keyboard on iOS" />
        <figcaption class="figure-caption">
          Movimento do cursor via arrasto 3D Touch no teclado no iOS
        </figcaption>
      </figure>
    </div>
  </div>
</div>

### Barra de ferramentas de seleção de texto

Com **Material no Android**,
a barra de ferramentas de seleção no estilo Android é mostrada quando
uma seleção de texto é feita em um campo de texto.

Com **Material no iOS** ou ao usar **Cupertino**,
a barra de ferramentas de seleção no estilo iOS é mostrada quando uma
seleção de texto é feita em um campo de texto.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/text-toolbar-android.png" class="figure-img img-fluid rounded" alt="Android appropriate text toolbar" />
        <figcaption class="figure-caption">
          Barra de ferramentas de seleção de texto do Android
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/text-toolbar-ios.png" class="figure-img img-fluid rounded" alt="iOS appropriate text toolbar" />
        <figcaption class="figure-caption">
          Barra de ferramentas de seleção de texto do iOS
        </figcaption>
      </figure>
    </div>
  </div>
</div>

### Gesto de toque único

Com **Material no Android**,
um único toque em um campo de texto coloca o cursor no
local do toque.

Uma seleção de texto recolhida também mostra uma
alça arrastável para posteriormente mover o cursor.

Com **Material no iOS** ou ao usar **Cupertino**,
um único toque em um campo de texto coloca o cursor na
borda mais próxima da palavra tocada.

Seleções de texto recolhidas não têm alças arrastáveis no iOS.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/text-single-tap-android.gif" class="figure-img img-fluid rounded" alt="Moving the cursor to the tapped position on Android" />
        <figcaption class="figure-caption">
          Toque no Android
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/text-single-tap-ios.gif" class="figure-img img-fluid rounded" alt="Moving the cursor to the nearest edge of the tapped word on iOS" />
        <figcaption class="figure-caption">
          Toque no iOS
        </figcaption>
      </figure>
    </div>
  </div>
</div>

### Gesto de pressão longa

Com **Material no Android**,
uma pressão longa seleciona a palavra sob a pressão longa.
A barra de ferramentas de seleção é mostrada após soltar.

Com **Material no iOS** ou ao usar **Cupertino**,
uma pressão longa coloca o cursor no local da
pressão longa. A barra de ferramentas de seleção é mostrada após soltar.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/text-long-press-android.gif" class="figure-img img-fluid rounded" alt="Selecting a word via long press on Android" />
        <figcaption class="figure-caption">
          Pressão longa no Android
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/text-long-press-ios.gif" class="figure-img img-fluid rounded" alt="Selecting a position via long press on iOS" />
        <figcaption class="figure-caption">
          Pressão longa no iOS
        </figcaption>
      </figure>
    </div>
  </div>
</div>

### Gesto de arrasto com pressão longa

Com **Material no Android**,
arrastar enquanto mantém a pressão longa expande as palavras selecionadas.

Com **Material no iOS** ou ao usar **Cupertino**,
arrastar enquanto mantém a pressão longa move o cursor.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/text-long-press-drag-android.gif" class="figure-img img-fluid rounded" alt="Expanding word selection via long press drag on Android" />
        <figcaption class="figure-caption">
          Arrasto com pressão longa no Android
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/text-long-press-drag-ios.gif" class="figure-img img-fluid rounded" alt="Moving the cursor via long press drag on iOS" />
        <figcaption class="figure-caption">
          Arrasto com pressão longa no iOS
        </figcaption>
      </figure>
    </div>
  </div>
</div>

### Gesto de toque duplo

Tanto no Android quanto no iOS,
um toque duplo seleciona a palavra que recebe o
toque duplo e mostra a barra de ferramentas de seleção.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/text-double-tap-android.gif" class="figure-img img-fluid rounded" alt="Selecting a word via double tap on Android" />
        <figcaption class="figure-caption">
          Toque duplo no Android
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/text-double-tap-ios.gif" class="figure-img img-fluid rounded" alt="Selecting a word via double tap on iOS" />
        <figcaption class="figure-caption">
          Toque duplo no iOS
        </figcaption>
      </figure>
    </div>
  </div>
</div>

## Componentes de UI

Esta seção inclui recomendações preliminares sobre como adaptar
widgets Material para entregar uma experiência natural e atraente no iOS.
Seu feedback é bem-vindo na [issue #8427][8427].

[8427]: {{site.repo.this}}/issues/8427

### Widgets com construtores .adaptive()

Vários widgets suportam construtores `.adaptive()`.
A tabela a seguir lista esses widgets.
Construtores adaptativos substituem os componentes Cupertino correspondentes
quando o aplicativo é executado em um dispositivo iOS.

Os widgets na tabela a seguir são usados principalmente para entrada,
seleção e para exibir informações do sistema.
Como esses controles são fortemente integrados ao sistema operacional,
os usuários foram treinados para reconhecê-los e responder a eles.
Portanto, recomendamos que você siga as convenções da plataforma.


| Widget Material | Widget Cupertino | Construtor adaptativo |
|---|---|---|
|<img width=160 src="/assets/images/docs/platform-adaptations/m3-switch.png" class="figure-img img-fluid rounded" alt="Switch in Material 3" /><br/>`Switch`|<img src="/assets/images/docs/platform-adaptations/hig-switch.png" class="figure-img img-fluid rounded" alt="Switch in HIG" /><br/>`CupertinoSwitch`|[`Switch.adaptive()`][]|
|<img src="/assets/images/docs/platform-adaptations/m3-slider.png" width =160 class="figure-img img-fluid rounded" alt="Slider in Material 3" /><br/>`Slider`|<img src="/assets/images/docs/platform-adaptations/hig-slider.png"  width =160  class="figure-img img-fluid rounded" alt="Slider in HIG" /><br/>`CupertinoSlider`|[`Slider.adaptive()`][]|
|<img src="/assets/images/docs/platform-adaptations/m3-progress.png" width = 100 class="figure-img img-fluid rounded" alt="Circular progress indicator in Material 3" /><br/>`CircularProgressIndicator`|<img src="/assets/images/docs/platform-adaptations/hig-progress.png" class="figure-img img-fluid rounded" alt="Activity indicator in HIG" /><br/>`CupertinoActivityIndicator`|[`CircularProgressIndicator.adaptive()`][]|
| <img src="/assets/images/docs/platform-adaptations/m3-checkbox.png" class="figure-img img-fluid rounded" alt=" Checkbox in Material 3" /> <br/>`Checkbox`| <img src="/assets/images/docs/platform-adaptations/hig-checkbox.png" class="figure-img img-fluid rounded" alt="Checkbox in HIG" /> <br/> `CupertinoCheckbox`|[`Checkbox.adaptive()`][]|
|<img src="/assets/images/docs/platform-adaptations/m3-radio.png" class="figure-img img-fluid rounded" alt="Radio in Material 3" /> <br/>`Radio`|<img src="/assets/images/docs/platform-adaptations/hig-radio.png" class="figure-img img-fluid rounded" alt="Radio in HIG" /><br/>`CupertinoRadio`|[`Radio.adaptive()`][]|
|<img src="/assets/images/docs/platform-adaptations/m3-alert.png" class="figure-img img-fluid rounded" alt="AlertDialog in Material 3" /> <br/>`AlertDialog`|<img src="/assets/images/docs/platform-adaptations/cupertino-alert.png" class="figure-img img-fluid rounded" alt="AlertDialog in HIG" /><br/>`CupertinoAlertDialog`|[`AlertDialog.adaptive()`][]|

[`AlertDialog.adaptive()`]: {{site.api}}/flutter/material/AlertDialog/AlertDialog.adaptive.html
[`Checkbox.adaptive()`]: {{site.api}}/flutter/material/Checkbox/Checkbox.adaptive.html
[`Radio.adaptive()`]: {{site.api}}/flutter/material/Radio/Radio.adaptive.html
[`Switch.adaptive()`]: {{site.api}}/flutter/material/Switch/Switch.adaptive.html
[`Slider.adaptive()`]: {{site.api}}/flutter/material/Slider/Slider.adaptive.html
[`CircularProgressIndicator.adaptive()`]: {{site.api}}/flutter/material/CircularProgressIndicator/CircularProgressIndicator.adaptive.html

### Barra de aplicativo superior e barra de navegação

Desde o Android 12, a UI padrão para barras de aplicativo
superiores segue as diretrizes de design definidas no [Material 3][mat-appbar].
No iOS, um componente equivalente chamado "Navigation Bars"
é definido nas [Diretrizes de Interface Humana da Apple][hig-appbar] (HIG).

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/mat-appbar.png"
        class="figure-img img-fluid rounded" alt=" Top App Bar in Material 3 " />
        <figcaption class="figure-caption">
          Top App Bar no Material 3
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/hig-appbar.png"
        class="figure-img img-fluid rounded" alt="Navigation Bar in Human Interface Guidelines" />
        <figcaption class="figure-caption">
          Navigation Bar nas Diretrizes de Interface Humana
        </figcaption>
      </figure>
    </div>
  </div>
</div>

Certas propriedades das barras de aplicativo em aplicativos Flutter devem ser adaptadas,
como ícones do sistema e transições de página.
Estas já são adaptadas automaticamente ao usar
os widgets Material `AppBar` e `SliverAppBar`.
Você também pode personalizar ainda mais as propriedades desses widgets para melhor
corresponder aos estilos da plataforma iOS, conforme mostrado abaixo.

```dart
// Map the text theme to iOS styles
TextTheme cupertinoTextTheme = TextTheme(
    headlineMedium: CupertinoThemeData()
        .textTheme
        .navLargeTitleTextStyle
         // fixes a small bug with spacing
        .copyWith(letterSpacing: -1.5),
    titleLarge: CupertinoThemeData().textTheme.navTitleTextStyle)
...

// Use iOS text theme on iOS devices
ThemeData(
      textTheme: Platform.isIOS ? cupertinoTextTheme : null,
      ...
)
...

// Modify AppBar properties
AppBar(
        surfaceTintColor: Platform.isIOS ? Colors.transparent : null,
        shadowColor: Platform.isIOS ? CupertinoColors.darkBackgroundGray : null,
        scrolledUnderElevation: Platform.isIOS ? .1 : null,
        toolbarHeight: Platform.isIOS ? 44 : null,
        ...
      ),
```

Mas, como as barras de aplicativo são exibidas junto com
outro conteúdo em sua página, é recomendado adaptar o estilo
apenas se for coeso com o resto do seu aplicativo. Você pode ver
amostras de código adicionais e uma explicação mais detalhada na
[discussão do GitHub sobre adaptações de barra de aplicativo][appbar-post].

[mat-appbar]: {{site.material}}/components/top-app-bar/overview
[hig-appbar]: {{site.apple-dev}}/design/human-interface-guidelines/components/navigation-and-search/navigation-bars/
[appbar-post]: {{site.repo.uxr}}/discussions/93

### Barras de navegação inferior

Desde o Android 12, a UI padrão para barras de navegação
inferior seguem as diretrizes de design definidas no [Material 3][mat-navbar].
No iOS, um componente equivalente chamado "Tab Bars"
é definido nas [Diretrizes de Interface Humana da Apple][hig-tabbar] (HIG).

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/mat-navbar.png"
        class="figure-img img-fluid rounded" alt="Bottom Navigation Bar in Material 3 " />
        <figcaption class="figure-caption">
          Bottom Navigation Bar no Material 3
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/hig-tabbar.png"
        class="figure-img img-fluid rounded" alt="Tab Bar in Human Interface Guidelines" />
        <figcaption class="figure-caption">
         Tab Bar nas Diretrizes de Interface Humana
        </figcaption>
      </figure>
    </div>
  </div>
</div>

Como as barras de abas são persistentes em todo o seu aplicativo, elas devem corresponder à
sua própria marca. No entanto, se você optar por usar o estilo padrão do Material
no Android, você pode considerar adaptar para as barras de abas padrão do iOS.

Para implementar barras de navegação inferior específicas da plataforma,
você pode usar o widget `NavigationBar` do Flutter no Android
e o widget `CupertinoTabBar` no iOS.
Abaixo está um trecho de código que você pode
adaptar para mostrar barras de navegação específicas da plataforma.

```dart
final Map<String, Icon> _navigationItems = {
    'Menu': Platform.isIOS ? Icon(CupertinoIcons.house_fill) : Icon(Icons.home),
    'Order': Icon(Icons.adaptive.share),
  };

...

Scaffold(
  body: _currentWidget,
  bottomNavigationBar: Platform.isIOS
          ? CupertinoTabBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() => _currentIndex = index);
                _loadScreen();
              },
              items: _navigationItems.entries
                  .map<BottomNavigationBarItem>(
                      (entry) => BottomNavigationBarItem(
                            icon: entry.value,
                            label: entry.key,
                          ))
                  .toList(),
            )
          : NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() => _currentIndex = index);
                _loadScreen();
              },
              destinations: _navigationItems.entries
                  .map<Widget>((entry) => NavigationDestination(
                        icon: entry.value,
                        label: entry.key,
                      ))
                  .toList(),
            ));
```

[mat-navbar]: {{site.material}}/components/navigation-bar/overview
[hig-tabbar]: {{site.apple-dev}}/design/human-interface-guidelines/components/navigation-and-search/tab-bars/

### Campos de texto

Desde o Android 12, os campos de texto seguem as
diretrizes de design do [Material 3][m3-text-field] (M3).
No iOS, as [Diretrizes de Interface Humana][hig-text-field] (HIG) da Apple definem
um componente equivalente.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/m3-text-field.png"
        class="figure-img img-fluid rounded" alt="Text Field in Material 3" />
        <figcaption class="figure-caption">
          Text Field no Material 3
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/hig-text-field.png"
        class="figure-img img-fluid rounded" alt="Text Field in Human Interface Guidelines" />
        <figcaption class="figure-caption">
          Text Field no HIG
        </figcaption>
      </figure>
    </div>
  </div>
</div>

Como os campos de texto exigem entrada do usuário,
seu design deve seguir as convenções da plataforma.

Para implementar um `TextField` específico da plataforma
no Flutter, você pode adaptar o estilo do
`TextField` Material.

```dart
Widget _createAdaptiveTextField() {
  final _border = OutlineInputBorder(
    borderSide: BorderSide(color: CupertinoColors.lightBackgroundGray),
  );

  final iOSDecoration = InputDecoration(
    border: _border,
    enabledBorder: _border,
    focusedBorder: _border,
    filled: true,
    fillColor: CupertinoColors.white,
    hoverColor: CupertinoColors.white,
    contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
  );

  return Platform.isIOS
      ? SizedBox(
          height: 36.0,
          child: TextField(
            decoration: iOSDecoration,
          ),
        )
      : TextField();
}
```

Para saber mais sobre como adaptar campos de texto, confira
[a discussão do GitHub sobre campos de texto][text-field-post].
Você pode deixar feedback ou fazer perguntas na discussão.

[text-field-post]: {{site.repo.uxr}}/discussions/95
[m3-text-field]: {{site.material}}/components/text-fields/overview
[hig-text-field]: {{site.apple-dev}}/design/human-interface-guidelines/text-fields
