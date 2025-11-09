---
ia-translate: true
title: Adaptações automáticas de plataforma
description: Saiba mais sobre a adaptabilidade de plataforma do Flutter.
---

## Filosofia de adaptação

Em geral, existem dois casos de adaptabilidade de plataforma:

1. Coisas que são comportamentos do ambiente do SO
   (como edição de texto e rolagem) e que
   estariam 'erradas' se um comportamento diferente ocorresse.
2. Coisas que são convencionalmente implementadas em apps usando
   os SDKs do OEM (como usar tabs paralelos no iOS ou
   mostrar um [`android.app.AlertDialog`][`android.app.AlertDialog`] no Android).

Este artigo cobre principalmente as adaptações automáticas
fornecidas pelo Flutter no caso 1 no Android e iOS.

Para o caso 2, Flutter agrupa os meios para produzir os
efeitos apropriados das convenções de plataforma, mas não
adapta automaticamente quando escolhas de design de app são necessárias.
Para uma discussão, consulte [issue #8410][issue #8410] e a
[definição do problema de widget adaptativo Material/Cupertino][Material/Cupertino adaptive widget problem definition].

Para um exemplo de um app usando diferentes estruturas
de arquitetura de informação no Android e iOS mas compartilhando
o mesmo código de conteúdo, consulte os [exemplos de código platform_design][platform_design code samples].

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

Flutter fornece os padrões de navegação vistos no Android
e iOS e também adapta automaticamente a animação de navegação
à plataforma atual.

### Transições de navegação

No **Android**, a transição padrão do [`Navigator.push()`][`Navigator.push()`]
é modelada após [`startActivity()`][`startActivity()`],
que geralmente tem uma variante de animação de baixo para cima.

No **iOS**:

* A API padrão [`Navigator.push()`][`Navigator.push()`] produz uma
  transição no estilo Show/Push do iOS que anima de
  fim para início dependendo da configuração RTL da localidade.
  A página atrás da nova rota também desliza em paralaxe
  na mesma direção como no iOS.
* Um estilo de transição de baixo para cima separado existe ao
  empurrar uma rota de página onde [`PageRoute.fullscreenDialog`][`PageRoute.fullscreenDialog`]
  é true. Isso representa o estilo de transição Present/Modal do iOS
  e é tipicamente usado em páginas modais de tela cheia.

<div class="wrapping-row">
  <DashImage figure image="platform-adaptations/navigation-android.webp" img-style="border-radius: 12px;" caption="Android page transition" alt="An animation of the bottom-up page transition on Android" />
  <DashImage figure image="platform-adaptations/navigation-ios.webp" img-style="border-radius: 22px;" caption="iOS push transition" alt="An animation of the end-start style push page transition on iOS" />
  <DashImage figure image="platform-adaptations/navigation-ios-modal.webp" img-style="border-radius: 22px;" caption="iOS present transition" alt="An animation of the bottom-up style present page transition on iOS" />
</div>

[`Navigator.push()`]: {{site.api}}/flutter/widgets/Navigator/push.html
[`startActivity()`]: {{site.android-dev}}/reference/kotlin/android/app/Activity#startactivity
[`PageRoute.fullscreenDialog`]: {{site.api}}/flutter/widgets/PageRoute-class.html

### Detalhes de transição específicos da plataforma

No **Android**, Flutter usa a animação [`ZoomPageTransitionsBuilder`][`ZoomPageTransitionsBuilder`].
Quando o usuário toca em um item, a UI amplia para uma tela que apresenta esse item.
Quando o usuário toca para voltar, a UI reduz para a tela anterior.

No **iOS** quando a transição no estilo push é usada,
as barras de navegação [`CupertinoNavigationBar`][`CupertinoNavigationBar`] e [`CupertinoSliverNavigationBar`][`CupertinoSliverNavigationBar`]
incluídas no Flutter animam automaticamente cada subcomponente para seu subcomponente
correspondente na próxima página ou página anterior
`CupertinoNavigationBar` ou `CupertinoSliverNavigationBar`.

<div class="wrapping-row">
  <DashImage figure image="platform-adaptations/android-zoom-animation.png" img-style="border-radius: 12px;" caption="Android" alt="An animation of the page transition on Android" />
  <DashImage figure image="platform-adaptations/navigation-ios-nav-bar.webp" img-style="border-radius: 22px;" caption="iOS Nav Bar" alt="An animation of the nav bar transitions during a page transition on iOS" />
</div>

[`ZoomPageTransitionsBuilder`]: {{site.api}}/flutter/material/ZoomPageTransitionsBuilder-class.html
[`CupertinoNavigationBar`]: {{site.api}}/flutter/cupertino/CupertinoNavigationBar-class.html
[`CupertinoSliverNavigationBar`]: {{site.api}}/flutter/cupertino/CupertinoSliverNavigationBar-class.html

### Navegação de volta

No **Android**,
o botão de voltar do SO, por padrão, é enviado ao Flutter
e remove a rota superior do Navigator do [`WidgetsApp`][`WidgetsApp`].

No **iOS**,
um gesto de deslizar da borda pode ser usado para remover a rota superior.

<div class="wrapping-row">
  <DashImage figure image="platform-adaptations/navigation-android-back.webp" img-style="border-radius: 12px;" caption="Android back button" alt="A page transition triggered by the Android back button" />
  <DashImage figure image="platform-adaptations/navigation-ios-back.webp" img-style="border-radius: 22px;" caption="iOS back swipe gesture" alt="A page transition triggered by an iOS back swipe gesture" />
</div>

[`WidgetsApp`]: {{site.api}}/flutter/widgets/WidgetsApp-class.html

## Rolagem

A rolagem é uma parte importante da aparência e sensação da
plataforma, e o Flutter ajusta automaticamente
o comportamento de rolagem para corresponder à plataforma atual.

### Simulação de física

Android e iOS ambos têm simulações de física de rolagem
complexas que são difíceis de descrever verbalmente.
Geralmente, o rolável do iOS tem mais peso e
fricção dinâmica, mas o Android tem mais fricção estática.
Portanto, o iOS ganha alta velocidade mais gradualmente, mas para
menos abruptamente e é mais escorregadio em velocidades baixas.

<div class="wrapping-row">
  <DashImage figure image="platform-adaptations/scroll-soft.webp" caption="Soft fling comparison" alt="A soft fling where the iOS scrollable slid longer at lower speed than Android" />
  <DashImage figure image="platform-adaptations/scroll-medium.webp" caption="Medium fling comparison" alt="A medium force fling where the Android scrollable reaches speed faster and stopped more abruptly after reaching a longer distance" />
  <DashImage figure image="platform-adaptations/scroll-strong.webp" caption="Strong fling comparison" alt="A strong fling where the Android scrollable reaches speed faster and covered significantly more distance" />
</div>

### Comportamento de overscroll

No **Android**,
rolar além da borda de um rolável mostra um
[indicador de brilho de overscroll][overscroll glow indicator] (baseado na cor
do tema Material atual).

No **iOS**, rolar além da borda de um rolável
[faz overscroll][overscrolls] com resistência crescente e volta ao normal.

<div class="wrapping-row">
  <DashImage figure image="platform-adaptations/scroll-overscroll.webp" caption="Dynamic overscroll comparison" alt="Android and iOS scrollables being flung past their edge and exhibiting platform specific overscroll behavior" />
  <DashImage figure image="platform-adaptations/scroll-static-overscroll.webp" caption="Static overscroll comparison" alt="Android and iOS scrollables being overscrolled from a resting position and exhibiting platform specific overscroll behavior" />
</div>

[overscroll glow indicator]: {{site.api}}/flutter/widgets/GlowingOverscrollIndicator-class.html
[overscrolls]: {{site.api}}/flutter/widgets/BouncingScrollPhysics-class.html

### Momentum

No **iOS**,
deslizamentos repetidos na mesma direção acumulam momentum
e constroem mais velocidade com cada deslizamento sucessivo.
Não há comportamento equivalente no Android.

<div class="wrapping-row">
  <DashImage figure image="platform-adaptations/scroll-momentum-ios.webp" caption="iOS scroll momentum" alt="Repeated scroll flings building momentum on iOS" />
</div>

### Retornar ao topo

No **iOS**,
tocar na barra de status do SO rola o controlador
de rolagem primário para a posição superior.
Não há comportamento equivalente no Android.

<div class="wrapping-row">
  <DashImage figure image="platform-adaptations/scroll-tap-to-top-ios.webp" img-style="border-radius: 22px;" caption="iOS status bar tap to top" alt="Tapping the status bar scrolls the primary scrollable back to the top" />
</div>

## Tipografia

Ao usar o pacote Material,
a tipografia automaticamente assume como padrão a
família de fontes apropriada para a plataforma.
Android usa a fonte Roboto.
iOS usa a fonte San Francisco.

Ao usar o pacote Cupertino, o [tema padrão][default theme]
usa a fonte San Francisco.

A licença da fonte San Francisco limita seu uso a
software rodando apenas no iOS, macOS ou tvOS.
Portanto, uma fonte de fallback é usada ao rodar no Android
se a plataforma é sobrescrita para iOS em modo debug ou o
tema Cupertino padrão é usado.

Você pode optar por adaptar o estilo de texto de widgets Material
para corresponder ao estilo de texto padrão no iOS.
Você pode ver exemplos específicos de widget na
[seção de componentes de UI](#ui-components).

<div class="wrapping-row">
  <DashImage figure image="platform-adaptations/typography-android.png" img-style="border-radius: 12px;" caption="Roboto on Android" alt="Roboto font typography scale on Android" />
  <DashImage figure image="platform-adaptations/typography-ios.png" img-style="border-radius: 22px;" caption="San Francisco on iOS" alt="San Francisco typography scale on iOS" />
</div>

[default theme]: {{site.repo.flutter}}/blob/main/packages/flutter/lib/src/cupertino/text_theme.dart

## Iconografia

Ao usar o pacote Material,
certos ícones mostram automaticamente diferentes
gráficos dependendo da plataforma.
Por exemplo, os três pontos do botão de overflow
são horizontais no iOS e verticais no Android.
O botão de voltar é uma seta simples no iOS e
tem uma haste/cabo no Android.

<div class="wrapping-row">
  <DashImage figure image="platform-adaptations/iconography-android.png" caption="Icons on Android" alt="Android appropriate icons" />
  <DashImage figure image="platform-adaptations/iconography-ios.png" caption="Icons on iOS" alt="iOS appropriate icons" />
</div>

A biblioteca material também fornece um conjunto de
ícones adaptativos de plataforma através de [`Icons.adaptive`][`Icons.adaptive`].

[`Icons.adaptive`]: {{site.api}}/flutter/material/PlatformAdaptiveIcons-class.html

## Feedback háptico

Os pacotes Material e Cupertino automaticamente
acionam o feedback háptico apropriado da plataforma em
certos cenários.

Por exemplo,
uma seleção de palavra via long-press em campo de texto aciona uma vibração de 'buzz'
no Android e não no iOS.

Rolar através de itens de picker no iOS aciona um
batida de 'impacto leve' e sem feedback no Android.

## Edição de texto

Ambos os campos de entrada de texto Material e Cupertino
suportam verificação ortográfica e se adaptam para usar a
configuração de verificação ortográfica adequada para a plataforma,
e o menu e cores de destaque de verificação ortográfica apropriados.

Flutter também faz as adaptações abaixo ao editar
o conteúdo de campos de texto para corresponder à plataforma atual.

### Navegação por gestos de teclado

No **Android**,
deslizamentos horizontais podem ser feitos na tecla <kbd>espaço</kbd> do teclado virtual
para mover o cursor em campos de texto Material e Cupertino.

Em dispositivos **iOS** com capacidades 3D Touch,
um gesto de força-pressione-arraste pode ser feito no teclado
virtual para mover o cursor em 2D via um cursor flutuante.
Isso funciona tanto em campos de texto Material quanto Cupertino.

<div class="wrapping-row">
  <DashImage figure image="platform-adaptations/text-keyboard-move-android.webp" caption="Android space key cursor move" alt="Moving the cursor via the space key on Android" />
  <DashImage figure image="platform-adaptations/text-keyboard-move-ios.webp" caption="iOS 3D Touch drag cursor move" alt="Moving the cursor via 3D Touch drag on the keyboard on iOS" />
</div>

### Barra de ferramentas de seleção de texto

Com **Material no Android**,
a barra de ferramentas de seleção no estilo Android é mostrada quando
uma seleção de texto é feita em um campo de texto.

Com **Material no iOS** ou ao usar **Cupertino**,
a barra de ferramentas de seleção no estilo iOS é mostrada quando uma
seleção de texto é feita em um campo de texto.

<div class="wrapping-row">
  <DashImage figure image="platform-adaptations/text-toolbar-android.png" caption="Android text selection toolbar" alt="Android appropriate text toolbar" />
  <DashImage figure image="platform-adaptations/text-toolbar-ios.png" caption="iOS text selection toolbar" alt="iOS appropriate text toolbar" />
</div>

### Gesto de toque único

Com **Material no Android**,
um único toque em um campo de texto coloca o cursor no
local do toque.

Uma seleção de texto colapsada também mostra uma alça
arrastável para posteriormente mover o cursor.

Com **Material no iOS** ou ao usar **Cupertino**,
um único toque em um campo de texto coloca o cursor na
borda mais próxima da palavra tocada.

Seleções de texto colapsadas não têm alças arrastáveis no iOS.

<div class="wrapping-row">
  <DashImage figure image="platform-adaptations/text-single-tap-android.webp" caption="Android tap" alt="Moving the cursor to the tapped position on Android" />
  <DashImage figure image="platform-adaptations/text-single-tap-ios.webp" caption="iOS tap" alt="Moving the cursor to the nearest edge of the tapped word on iOS" />
</div>

### Gesto de long-press

Com **Material no Android**,
um long press seleciona a palavra sob o long press.
A barra de ferramentas de seleção é mostrada ao soltar.

Com **Material no iOS** ou ao usar **Cupertino**,
um long press coloca o cursor no local do
long press. A barra de ferramentas de seleção é mostrada ao soltar.

<div class="wrapping-row">
  <DashImage figure image="platform-adaptations/text-long-press-android.webp" caption="Android long press" alt="Selecting a word with long press on Android" />
  <DashImage figure image="platform-adaptations/text-long-press-ios.webp" caption="iOS long press" alt="Selecting a position with long press on iOS" />
</div>

### Gesto de arrastar long-press

Com **Material no Android**,
arrastar enquanto segura o long press expande as palavras selecionadas.

Com **Material no iOS** ou ao usar **Cupertino**,
arrastar enquanto segura o long press move o cursor.

<div class="wrapping-row">
  <DashImage figure image="platform-adaptations/text-long-press-drag-android.webp" caption="Android long-press drag" alt="Expanding word selection with a long-press drag on Android" />
  <DashImage figure image="platform-adaptations/text-long-press-drag-ios.webp" caption="iOS long-press drag" alt="Moving the cursor with a long-press drag on iOS" />
</div>

### Gesto de toque duplo

Tanto no Android quanto no iOS,
um toque duplo seleciona a palavra que recebe o
toque duplo e mostra a barra de ferramentas de seleção.

<div class="wrapping-row">
  <DashImage figure image="platform-adaptations/text-double-tap-android.webp" caption="Android double tap" alt="Selecting a word via double tap on Android" />
  <DashImage figure image="platform-adaptations/text-double-tap-ios.webp" caption="iOS double tap" alt="Selecting a word via double tap on iOS" />
</div>

## Componentes de UI

Esta seção inclui recomendações preliminares sobre como adaptar
widgets Material para entregar uma experiência natural e convincente no iOS.
Seu feedback é bem-vindo na [issue #8427][8427].

[8427]: {{site.repo.this}}/issues/8427

### Widgets com construtores .adaptive()

Vários widgets suportam construtores `.adaptive()`.
A tabela a seguir lista esses widgets.
Construtores adaptativos substituem os componentes Cupertino correspondentes
quando o app é executado em um dispositivo iOS.

Widgets na tabela a seguir são usados principalmente para entrada,
seleção e para exibir informações do sistema.
Como esses controles são fortemente integrados ao sistema operacional,
os usuários foram treinados para reconhecê-los e responder a eles.
Portanto, recomendamos que você siga as convenções de plataforma.


| Material widget | Cupertino widget | Adaptive constructor |
|---|---|---|
|<img width=160 src="/assets/images/docs/platform-adaptations/m3-switch.png" alt="Switch in Material 3" /><br/>`Switch`|<img src="/assets/images/docs/platform-adaptations/hig-switch.png" alt="Switch in HIG" /><br/>`CupertinoSwitch`|[`Switch.adaptive()`][`Switch.adaptive()`]|
|<img src="/assets/images/docs/platform-adaptations/m3-slider.png" width =160 alt="Slider in Material 3" /><br/>`Slider`|<img src="/assets/images/docs/platform-adaptations/hig-slider.png"  width =160  alt="Slider in HIG" /><br/>`CupertinoSlider`|[`Slider.adaptive()`][`Slider.adaptive()`]|
|<img src="/assets/images/docs/platform-adaptations/m3-progress.png" width = 100 alt="Circular progress indicator in Material 3" /><br/>`CircularProgressIndicator`|<img src="/assets/images/docs/platform-adaptations/hig-progress.png" alt="Activity indicator in HIG" /><br/>`CupertinoActivityIndicator`|[`CircularProgressIndicator.adaptive()`][`CircularProgressIndicator.adaptive()`]|
|<img src="/assets/images/docs/platform-adaptations/m3-refresh.png" width = 100 alt="Refresh indicator in Material 3" /><br/>`RefreshProgressIndicator`|<img src="/assets/images/docs/platform-adaptations/hig-refresh.png" alt="Refresh indicator in HIG" /><br/>`CupertinoActivityIndicator`|[`RefreshIndicator.adaptive()`][`RefreshIndicator.adaptive()`]|
|<img src="/assets/images/docs/platform-adaptations/m3-checkbox.png" alt=" Checkbox in Material 3" /> <br/>`Checkbox`| <img src="/assets/images/docs/platform-adaptations/hig-checkbox.png" alt="Checkbox in HIG" /> <br/> `CupertinoCheckbox`|[`Checkbox.adaptive()`][`Checkbox.adaptive()`]|
|<img src="/assets/images/docs/platform-adaptations/m3-radio.png" alt="Radio in Material 3" /> <br/>`Radio`|<img src="/assets/images/docs/platform-adaptations/hig-radio.png" alt="Radio in HIG" /><br/>`CupertinoRadio`|[`Radio.adaptive()`][`Radio.adaptive()`]|
|<img src="/assets/images/docs/platform-adaptations/m3-alert.png" alt="AlertDialog in Material 3" /> <br/>`AlertDialog`|<img src="/assets/images/docs/platform-adaptations/cupertino-alert.png" alt="AlertDialog in HIG" /><br/>`CupertinoAlertDialog`|[`AlertDialog.adaptive()`][`AlertDialog.adaptive()`]|

[`AlertDialog.adaptive()`]: {{site.api}}/flutter/material/AlertDialog/AlertDialog.adaptive.html
[`Checkbox.adaptive()`]: {{site.api}}/flutter/material/Checkbox/Checkbox.adaptive.html
[`Radio.adaptive()`]: {{site.api}}/flutter/material/Radio/Radio.adaptive.html
[`Switch.adaptive()`]: {{site.api}}/flutter/material/Switch/Switch.adaptive.html
[`Slider.adaptive()`]: {{site.api}}/flutter/material/Slider/Slider.adaptive.html
[`CircularProgressIndicator.adaptive()`]: {{site.api}}/flutter/material/CircularProgressIndicator/CircularProgressIndicator.adaptive.html
[`RefreshIndicator.adaptive()`]: {{site.api}}/flutter/material/RefreshIndicator/RefreshIndicator.adaptive.html

### Top app bar e navigation bar

Desde o Android 12, a UI padrão para top app
bars segue as diretrizes de design definidas no [Material 3][mat-appbar].
No iOS, um componente equivalente chamado "Navigation Bars"
é definido nas [Diretrizes de Interface Humana da Apple][hig-appbar] (HIG).

<div class="wrapping-row">
  <DashImage figure image="platform-adaptations/mat-appbar.png" caption="Top App Bar in Material 3" alt="Top App Bar in Material 3" height="240px" />
  <DashImage figure image="platform-adaptations/hig-appbar.png" caption="Navigation Bar in Human Interface Guidelines" alt="Navigation Bar in Human Interface Guidelines" height="240px" />
</div>

Certas propriedades de app bars em apps Flutter devem ser adaptadas,
como ícones do sistema e transições de página.
Estas já são automaticamente adaptadas ao usar
os widgets Material `AppBar` e `SliverAppBar`.
Você também pode personalizar ainda mais as propriedades desses widgets para melhor
corresponder aos estilos de plataforma iOS, conforme mostrado abaixo.

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

Mas, como app bars são exibidas ao lado de
outro conteúdo em sua página, é recomendado apenas adaptar o estilo
desde que seja coeso com o resto de sua aplicação. Você pode ver
exemplos de código adicionais e uma explicação mais detalhada na
[discussão do GitHub sobre adaptações de app bar][appbar-post].

[mat-appbar]: {{site.material}}/components/top-app-bar/overview
[hig-appbar]: {{site.apple-dev}}/design/human-interface-guidelines/components/navigation-and-search/navigation-bars/
[appbar-post]: {{site.repo.uxr}}/discussions/93

### Bottom navigation bars

Desde o Android 12, a UI padrão para bottom navigation
bars segue as diretrizes de design definidas no [Material 3][mat-navbar].
No iOS, um componente equivalente chamado "Tab Bars"
é definido nas [Diretrizes de Interface Humana da Apple][hig-tabbar] (HIG).

<div class="wrapping-row">
  <DashImage figure image="platform-adaptations/mat-navbar.png" caption="Bottom Navigation Bar in Material 3" alt="Bottom Navigation Bar in Material 3" height="160px" />
  <DashImage figure image="platform-adaptations/hig-tabbar.png" caption="Tab Bar in Human Interface Guidelines" alt="Tab Bar in Human Interface Guidelines" height="160px" />
</div>

Como tab bars são persistentes em seu app, devem corresponder à sua
própria marca. No entanto, se você optar por usar o estilo padrão
do Material no Android, pode considerar adaptar às tab bars
iOS padrão.

Para implementar bottom navigation bars específicas da plataforma,
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

### Text fields

Desde o Android 12, text fields seguem as
diretrizes de design do [Material 3][m3-text-field] (M3).
No iOS, as [Diretrizes de Interface Humana][hig-text-field] da Apple (HIG) definem
um componente equivalente.

<div class="wrapping-row">
  <DashImage figure image="platform-adaptations/m3-text-field.png" caption="Text Field in Material 3" alt="Text Field in Material 3" width="320px" height="100px" />
  <DashImage figure image="platform-adaptations/hig-text-field.png" caption="Text Field in HIG" alt="Text Field in Human Interface Guidelines" width="320px" height="100px" />
</div>

Como text fields requerem entrada do usuário,
seu design deve seguir as convenções de plataforma.

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

Para saber mais sobre adaptar text fields, confira
[a discussão do GitHub sobre text fields][text-field-post].
Você pode deixar feedback ou fazer perguntas na discussão.

[text-field-post]: {{site.repo.uxr}}/discussions/95
[m3-text-field]: {{site.material}}/components/text-fields/overview
[hig-text-field]: {{site.apple-dev}}/design/human-interface-guidelines/text-fields
