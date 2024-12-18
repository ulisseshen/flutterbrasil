---
ia-translate: true
title: Mudanças de Ruptura e Guias de Migração
short-title: Mudanças de Ruptura
description: Uma lista de guias de migração para mudanças de ruptura no Flutter.
---

Como descrito na [política de mudanças de ruptura][],
ocasionalmente publicamos guias
para migrar código através de uma mudança de ruptura.

Para ser notificado sobre futuras mudanças de ruptura,
junte-se aos grupos [Flutter announce][] e [Dart announce][].

Ao enfrentar erros do Dart após atualizar o Flutter,
considere usar o comando [`dart fix`][]
para migrar seu código automaticamente.
Nem toda mudança de ruptura é suportada dessa forma,
mas muitas são.

Para evitar ser afetado por versões futuras do Flutter,
considere enviar seus testes para nosso [registro de testes].

## Mudanças de ruptura por lançamento

Os seguintes guias estão disponíveis. Eles estão ordenados por
lançamento e listados em ordem alfabética:

[breaking change policy]: /release/compatibility-policy
[Flutter announce]: {{site.groups}}/forum/#!forum/flutter-announce
[Dart announce]: {{site.groups}}/a/dartlang.org/g/announce
[`dart fix`]: /tools/flutter-fix
[test registry]: {{site.github}}/flutter/tests

### Ainda não lançado para o estável

* [`ImageFilter.blur` seleção automática do modo de tile padrão][]
* [Mensagens localizadas são geradas em fonte, não em um pacote sintético][]
* [`.flutter-plugins-dependencies` substitui `.flutter-plugins`][]
* [`Slider` do Material 3 atualizado][]
* [Indicadores de progresso do Material 3 atualizados][]
* [Descontinuar `ThemeData.indicatorColor` em favor de `TabBarThemeData.indicatorColor`][]
* [Descontinuar `ThemeData.dialogBackgroundColor` em favor de `DialogThemeData.backgroundColor`][]

[`ImageFilter.blur` seleção automática do modo de tile padrão]: /release/breaking-changes/image-filter-blur-tilemode
[Mensagens localizadas são geradas em fonte, não em um pacote sintético]: /release/breaking-changes/flutter-generate-i10n-source
[`.flutter-plugins-dependencies` substitui `.flutter-plugins`]: /release/breaking-changes/flutter-plugins-configuration
[`Slider` do Material 3 atualizado]: /release/breaking-changes/updated-material-3-slider
[Indicadores de progresso do Material 3 atualizados]: /release/breaking-changes/updated-material-3-progress-indicators
[Descontinuar `ThemeData.dialogBackgroundColor` em favor de `DialogThemeData.backgroundColor`]: /release/breaking-changes/deprecate-themedata-dialogbackgroundcolor
[Descontinuar `ThemeData.indicatorColor` em favor de `TabBarThemeData.indicatorColor`]: /release/breaking-changes/deprecate-themedata-indicatorcolor

<a id="released-in-flutter-327" aria-hidden="true"></a>
### Lançado no Flutter 3.27

*   Suporte a ampla gama de cores em `Color`][]
*   [Remover parâmetros inválidos para `InputDecoration.collapsed`][]
*   [Parar de gerar `AssetManifest.json`][]
*   [Mudança na flag de deep links][]
*   [Descontinuar `TextField.canRequestFocus`][]
*   [Definir o padrão para SystemUiMode como Edge-to-Edge][]
*   [Atualização dos Tokens do Material 3 no Flutter][]
*   [Normalização do tema do componente][]

[`Color` wide gamut support]: /release/breaking-changes/wide-gamut-framework
[Remover parâmetros inválidos para `InputDecoration.collapsed`]: /release/breaking-changes/input-decoration-collapsed
[Parar de gerar `AssetManifest.json`]: /release/breaking-changes/asset-manifest-dot-json
[Mudança na flag de deep links]: /release/breaking-changes/deep-links-flag-change
[Descontinuar `TextField.canRequestFocus`]: /release/breaking-changes/can-request-focus
[Definir o padrão para SystemUiMode como Edge-to-Edge]: /release/breaking-changes/default-systemuimode-edge-to-edge
[Atualização dos Tokens do Material 3 no Flutter]: /release/breaking-changes/material-design-3-token-update
[Normalização do tema do componente]: /release/breaking-changes/component-theme-normalization
[Descontinuar `ThemeData.dialogBackgroundColor` em favor de `DialogThemeData.backgroundColor`]: /release/breaking-changes/deprecate-themedata-dialogbackgroundcolor
[`Slider` do Material 3 atualizado]: /release/breaking-changes/updated-material-3-slider
[Indicadores de progresso do Material 3 atualizados]: /release/breaking-changes/updated-material-3-progress-indicators
[Descontinuar `ThemeData.indicatorColor` em favor de `TabBarThemeData.indicatorColor`]: /release/breaking-changes/deprecate-themedata-indicatorcolor

<a id="released-in-flutter-324" aria-hidden="true"></a>
### Lançado no Flutter 3.24

* [Mudança de ruptura nas APIs de página do Navigator][]
* [Tipos genéricos em `PopScope`][]
* [Descontinuar `ButtonBar` em favor de `OverflowBar`][]
* [Novas APIs para plugins Android que renderizam para uma `Surface`][]

[Mudança de ruptura nas APIs de página do Navigator]: /release/breaking-changes/navigator-and-page-api
[Tipos genéricos em `PopScope`]: /release/breaking-changes/popscope-with-result
[Descontinuar `ButtonBar` em favor de `OverflowBar`]: /release/breaking-changes/deprecate-buttonbar
[Novas APIs para plugins Android que renderizam para uma `Surface`]: /release/breaking-changes/android-surface-plugins

<a id="released-in-flutter-322" aria-hidden="true"></a>
### Lançado no Flutter 3.22

* [API descontinuada removida após v3.19][]
* [Renomear `MaterialState` para `WidgetState`][]
* [Introduzir novos papéis de `ColorScheme`][]
* [Fim do suporte para Android KitKat][]
* [`PageView.controller` anulável][]
* [Renomear `MemoryAllocations` para `FlutterMemoryAllocations`][]

[API descontinuada removida após v3.19]: /release/breaking-changes/3-19-deprecations
[Renomear `MaterialState` para `WidgetState`]: /release/breaking-changes/material-state
[Introduzir novos papéis de `ColorScheme`]: /release/breaking-changes/new-color-scheme-roles
[Fim do suporte para Android KitKat]: /release/breaking-changes/android-kitkat-deprecation
[`PageView.controller` anulável]: /release/breaking-changes/pageview-controller
[Renomear `MemoryAllocations` para `FlutterMemoryAllocations`]: /release/breaking-changes/flutter-memory-allocations

<a id="released-in-flutter-319" aria-hidden="true"></a>
### Lançado no Flutter 3.19

* [API descontinuada removida após v3.16][]
* [Migrar o sistema RawKeyEvent/RawKeyboard para o sistema KeyEvent/HardwareKeyboard][]
* [Descontinuar a aplicação imperativa dos plugins Gradle do Flutter][]
* [Rolagem multitoque padrão][]
* [Ordem de travessia de acessibilidade da dica de ferramenta alterada][]

[API descontinuada removida após v3.16]: /release/breaking-changes/3-16-deprecations
[Migrar o sistema RawKeyEvent/RawKeyboard para o sistema KeyEvent/HardwareKeyboard]: /release/breaking-changes/key-event-migration
[Descontinuar a aplicação imperativa dos plugins Gradle do Flutter]: /release/breaking-changes/flutter-gradle-plugin-apply
[Rolagem multitoque padrão]: /release/breaking-changes/multi-touch-scrolling
[Ordem de travessia de acessibilidade da dica de ferramenta alterada]: /release/breaking-changes/tooltip-semantics-order

<a id="released-in-flutter-316" aria-hidden="true"></a>
### Lançado no Flutter 3.16

* [Migrando para o Material 3][]
* [Migrar ShortcutActivator e ShortcutManager para o sistema KeyEvent][]
* [A propriedade `ThemeData.useMaterial3` agora está definida como true por padrão][]
* [API descontinuada removida após v3.13][]
* [Personalizar o alinhamento das abas usando a nova propriedade `TabBar.tabAlignment`][]
* [Descontinuar `textScaleFactor` em favor de `TextScaler`][]
* [Escala de fonte não linear do Android 14 habilitada][]
* [Descontinuar `describeEnum` e atualizar `EnumProperty` para ser estritamente tipado][]
* [APIs de pop de navegação just-in-time descontinuadas para Android Predictive Back][]
* [`Paint.enableDithering` descontinuado][]
* [Estilos de texto padrão atualizados para menus][]
* [Windows: Janelas externas devem notificar o mecanismo do Flutter sobre as mudanças no ciclo de vida][]
* [Caminho de build do Windows alterado para adicionar a arquitetura de destino][]

[Migrando para o Material 3]: /release/breaking-changes/material-3-migration
[Migrar ShortcutActivator e ShortcutManager para o sistema KeyEvent]: /release/breaking-changes/shortcut-key-event-migration
[A propriedade `ThemeData.useMaterial3` agora está definida como true por padrão]: /release/breaking-changes/material-3-default
[API descontinuada removida após v3.13]: /release/breaking-changes/3-13-deprecations
[Personalizar o alinhamento das abas usando a nova propriedade `TabBar.tabAlignment`]: /release/breaking-changes/tab-alignment
[Descontinuar `textScaleFactor` em favor de `TextScaler`]: /release/breaking-changes/deprecate-textscalefactor
[Escala de fonte não linear do Android 14 habilitada]: /release/breaking-changes/android-14-nonlinear-text-scaling-migration
[Descontinuar `describeEnum` e atualizar `EnumProperty` para ser estritamente tipado]: /release/breaking-changes/describe-enum
[APIs de pop de navegação just-in-time descontinuadas para Android Predictive Back]: /release/breaking-changes/android-predictive-back
[`Paint.enableDithering` descontinuado]: /release/breaking-changes/paint-enableDithering
[Estilos de texto padrão atualizados para menus]: /release/breaking-changes/menus-text-style
[Windows: Janelas externas devem notificar o mecanismo do Flutter sobre as mudanças no ciclo de vida]: /release/breaking-changes/win-lifecycle-process-function
[Caminho de build do Windows alterado para adicionar a arquitetura de destino]: /release/breaking-changes/windows-build-architecture

<a id="released-in-flutter-313" aria-hidden="true"></a>
### Lançado no Flutter 3.13

* [Adicionado `dispose()` ausente para alguns objetos descartáveis no Flutter][]
* [API descontinuada removida após v3.10][]
* [Adicionado o valor de enum `AppLifecycleState.hidden`][]
* [Strings localizadas de `ReorderableListView` movidas][] das localizações de material para widgets
* [Removido propriedades `ignoringSemantics`][]
* [Descontinuado `RouteInformation.location`][] e suas APIs relacionadas
* [Comportamento de rolagem para visualização de `EditableText` atualizado][]
* [Migrar um projeto Windows para garantir que a janela seja mostrada][]
* [Comportamento de `Checkbox.fillColor` atualizado][]

[Adicionado `dispose()` ausente para alguns objetos descartáveis no Flutter]: /release/breaking-changes/dispose
[API descontinuada removida após v3.10]: /release/breaking-changes/3-10-deprecations
[Adicionado o valor de enum `AppLifecycleState.hidden`]: /release/breaking-changes/add-applifecyclestate-hidden
[Strings localizadas de `ReorderableListView` movidas]: /release/breaking-changes/material-localized-strings
[Removido propriedades `ignoringSemantics`]: /release/breaking-changes/ignoringsemantics-migration
[Descontinuado `RouteInformation.location`]: /release/breaking-changes/route-information-uri
[Comportamento de rolagem para visualização de `EditableText` atualizado]: /release/breaking-changes/editable-text-scroll-into-view
[Migrar um projeto Windows para garantir que a janela seja mostrada]: /release/breaking-changes/windows-show-window-migration
[Comportamento de `Checkbox.fillColor` atualizado]: /release/breaking-changes/checkbox-fillColor

<a id="released-in-flutter-310" aria-hidden="true"></a>
### Lançado no Flutter 3.10

* [Mudanças do Dart 3 no Flutter v3.10 e posterior][]
* [API descontinuada removida após v3.7][]
* [Inserir cliente de entrada de texto de conteúdo][]
* [Descontinuado o singleton window][]
* [Resolver o erro Android Java Gradle][]
* [Requerer uma variante de dados para o construtor `ClipboardData`][]
* [Mensagem "Zone mismatch"][]

[Mudanças do Dart 3 no Flutter v3.10 e posterior]: {{site.dart-site}}/resources/dart-3-migration
[API descontinuada removida após v3.7]: /release/breaking-changes/3-7-deprecations
[Inserir cliente de entrada de texto de conteúdo]: /release/breaking-changes/insert-content-text-input-client
[Descontinuado o singleton window]: /release/breaking-changes/window-singleton
[Resolver o erro Android Java Gradle]: /release/breaking-changes/android-java-gradle-migration-guide
[Requerer uma variante de dados para o construtor `ClipboardData`]: /release/breaking-changes/clipboard-data-required
[Mensagem "Zone mismatch"]: /release/breaking-changes/zone-errors

<a id="released-in-flutter-37" aria-hidden="true"></a>
### Lançado no Flutter 3.7

* [API descontinuada removida após v3.3][]
* [Parâmetros substituídos para personalizar os menus de contexto com um construtor de widget genérico][]
* [`splashScreenView` de iOS `FlutterViewController` tornado anulável][]
* [Migrar `of` para valores de retorno não anuláveis e adicionar `maybeOf`][]
* [Removido `RouteSettings.copyWith`][]
* [A propriedade `toggleableActiveColor` de `ThemeData` foi descontinuada][]
* [Migrar um projeto Windows para oferecer suporte a barras de título escuras][]

[Parâmetros substituídos para personalizar os menus de contexto com um construtor de widget genérico]: /release/breaking-changes/context-menus
[API descontinuada removida após v3.3]: /release/breaking-changes/3-3-deprecations
[`splashScreenView` de iOS `FlutterViewController` tornado anulável]: /release/breaking-changes/ios-flutterviewcontroller-splashscreenview-nullable
[Migrar `of` para valores de retorno não anuláveis e adicionar `maybeOf`]: /release/breaking-changes/supplemental-maybeOf-migration
[Removido `RouteSettings.copyWith`]: /release/breaking-changes/routesettings-copywith-migration
[A propriedade `toggleableActiveColor` de `ThemeData` foi descontinuada]: /release/breaking-changes/toggleable-active-color
[Migrar um projeto Windows para oferecer suporte a barras de título escuras]: /release/breaking-changes/windows-dark-mode

<a id="released-in-flutter-33" aria-hidden="true"></a>
### Lançado no Flutter 3.3

* [Adicionando `ImageProvider.loadBuffer`][]
* [`PrimaryScrollController` padrão na área de trabalho][]
* [Gestos de trackpad podem acionar `GestureRecognizer`][]
* [Migrar um projeto Windows para definir informações de versão][]

[Adicionando `ImageProvider.loadBuffer`]: /release/breaking-changes/image-provider-load-buffer
[`PrimaryScrollController` padrão na área de trabalho]: /release/breaking-changes/primary-scroll-controller-desktop
[Gestos de trackpad podem acionar `GestureRecognizer`]: /release/breaking-changes/trackpad-gestures
[Migrar um projeto Windows para definir informações de versão]: /release/breaking-changes/windows-version-information

### Lançado no Flutter 3

* [API descontinuada removida após v2.10][]
* [Migrar `useDeleteButtonTooltip` para `deleteButtonTooltipMessage` de Chips][]
* [Transições de página substituídas por `ZoomPageTransitionsBuilder`][]

[API descontinuada removida após v2.10]: /release/breaking-changes/2-10-deprecations
[Transições de página substituídas por `ZoomPageTransitionsBuilder`]: /release/breaking-changes/page-transition-replaced-by-ZoomPageTransitionBuilder
[Migrar `useDeleteButtonTooltip` para `deleteButtonTooltipMessage` de Chips]: /release/breaking-changes/chip-usedeletebuttontooltip-migration

<a id="released-in-flutter-210" aria-hidden="true"></a>
### Lançado no Flutter 2.10

* [API descontinuada removida após v2.5][]
* [Imagens brutas na Web usam a origem e as cores corretas][]
* [Versão Kotlin necessária][]
* [Cliente de entrada de texto Scribble][]

[API descontinuada removida após v2.5]: /release/breaking-changes/2-5-deprecations
[Imagens brutas na Web usam a origem e as cores corretas]: /release/breaking-changes/raw-images-on-web-uses-correct-origin-and-colors
[Versão Kotlin necessária]: /release/breaking-changes/kotlin-version
[Cliente de entrada de texto Scribble]: /release/breaking-changes/scribble-text-input-client

<a id="released-in-flutter-25" aria-hidden="true"></a>
### Lançado no Flutter 2.5

* [Dispositivos de rolagem de arrastar padrão][]
* [API descontinuada removida após v2.2][]
* [Alterar o método `enterText` para mover o cursor para o final do texto de entrada][]
* [Limpeza do `GestureRecognizer`][]
* [Apresentando o pacote `package:flutter_lints`][]
* [Substituir `AnimationSheetBuilder.display` por `collate`][]
* [As propriedades de acento do `ThemeData` foram descontinuadas][]
* [Transição das interfaces de teste do canal da plataforma para o pacote `flutter_test`][]
* [Usando slots HTML para renderizar visualizações de plataforma na web][]
* [Migrar um projeto Windows para o loop de execução idiomático][]

[Alterar o método `enterText` para mover o cursor para o final do texto de entrada]: /release/breaking-changes/enterText-trailing-caret
[Dispositivos de rolagem de arrastar padrão]: /release/breaking-changes/default-scroll-behavior-drag
[API descontinuada removida após v2.2]: /release/breaking-changes/2-2-deprecations
[Limpeza do `GestureRecognizer`]: /release/breaking-changes/gesture-recognizer-add-allowed-pointer
[Apresentando o pacote `package:flutter_lints`]: /release/breaking-changes/flutter-lints-package
[Substituir `AnimationSheetBuilder.display` por `collate`]: /release/breaking-changes/animation-sheet-builder-display
[As propriedades de acento do `ThemeData` foram descontinuadas]: /release/breaking-changes/theme-data-accent-properties
[Transição das interfaces de teste do canal da plataforma para o pacote `flutter_test`]: /release/breaking-changes/mock-platform-channels
[Usando slots HTML para renderizar visualizações de plataforma na web]: /release/breaking-changes/platform-views-using-html-slots-web
[Migrar um projeto Windows para o loop de execução idiomático]: /release/breaking-changes/windows-run-loop

### Mudança revertida em 2.2

A seguinte mudança de ruptura foi revertida na versão 2.2:

**[Política de rede no iOS e Android][]**<br>
: Introduzida na versão: 2.0.0<br>
   Revertida na versão: 2.2.0

[Política de rede no iOS e Android]: /release/breaking-changes/network-policy-ios-android

<a id="released-in-flutter-22" aria-hidden="true"></a>
### Lançado no Flutter 2.2

* [Barras de rolagem padrão na área de trabalho][]

[Barras de rolagem padrão na área de trabalho]: /release/breaking-changes/default-desktop-scrollbars

### Lançado no Flutter 2

* [Adicionado parâmetro `BuildContext` para `TextEditingController.buildTextSpan`][]
* [Mudança na assinatura de `ActivityControlSurface.attachToActivity` do Android][]
* [API de teste `Android FlutterMain.setIsRunningInRobolectricTest` removida][]
* [Comportamento de `Clip`][]
* [API descontinuada removida após v1.22][]
* [Suporte a layout seco para `RenderBox`][]
* [Eliminando parâmetros `nullOk`][]
* [Semântica do botão `Material Chip`][]
* [`SnackBars` gerenciados pelo `ScaffoldMessenger`][]
* [Migração `TextSelectionTheme`][]
* [Transição de interfaces de teste de canal de plataforma para pacote `flutter_test`][]
* [Usar `maxLengthEnforcement` em vez de `maxLengthEnforced`][]

[Adicionado parâmetro `BuildContext` para `TextEditingController.buildTextSpan`]: /release/breaking-changes/buildtextspan-buildcontext
[Mudança na assinatura de `ActivityControlSurface.attachToActivity` do Android]: /release/breaking-changes/android-activity-control-surface-attach
[API de teste `Android FlutterMain.setIsRunningInRobolectricTest` removida]: /release/breaking-changes/android-setIsRunningInRobolectricTest-removed
[Comportamento de `Clip`]: /release/breaking-changes/clip-behavior
[API descontinuada removida após v1.22]: /release/breaking-changes/1-22-deprecations
[Suporte a layout seco para `RenderBox`]: /release/breaking-changes/renderbox-dry-layout
[Eliminando parâmetros `nullOk`]: /release/breaking-changes/eliminating-nullok-parameters
[Semântica do botão `Material Chip`]: /release/breaking-changes/material-chip-button-semantics
[`SnackBars` gerenciados pelo `ScaffoldMessenger`]: /release/breaking-changes/scaffold-messenger
[Migração `TextSelectionTheme`]: /release/breaking-changes/text-selection-theme
[Usar `maxLengthEnforcement` em vez de `maxLengthEnforced`]: /release/breaking-changes/use-maxLengthEnforcement-instead-of-maxLengthEnforced
[Transição de interfaces de teste de canal de plataforma para pacote `flutter_test`]: /release/breaking-changes/mock-platform-channels

<a id="released-in-flutter-122" aria-hidden="true"></a>
### Lançado no Flutter 1.22

* [Descontinuação da criação de aplicativo e plugin Android v1 embedding][]
* [`Cupertino icons` 1.0.0][]
* [Nova API de validação automática de `Form`, `FormField`][]

[Descontinuação da criação de aplicativo e plugin Android v1 embedding]: /release/breaking-changes/android-v1-embedding-create-deprecation
[`Cupertino icons` 1.0.0]: /release/breaking-changes/cupertino-icons-1.0.0
[Nova API de validação automática de `Form`, `FormField`]: /release/breaking-changes/form-field-autovalidation-api

<a id="released-in-flutter-120" aria-hidden="true"></a>
### Lançado no Flutter 1.20

* [Revisão da API Actions][]
* [Adicionando a propriedade `TextInputClient.currentAutofillScope`][]
* [Novos botões e temas de botões][]
* [`BorderRadius` padrão dos diálogos][]
* [Asserções mais estritas no Navigator e no escopo do Controlador Hero][]
* [O registro de transição de rota e atualizações do delegado de transição][]
* [`RenderEditable` precisa ser disposta antes do teste de hit][]
* [Invertendo a dependência entre o agendador e a camada de serviços][]
* [Ordem semântica das entradas de sobreposição em rotas modais][]
* [Método `showAutocorrectionPromptRect` adicionado a `TextInputClient`][]
* [`TestWidgetsFlutterBinding.clock`][]
* [`TextField` requer `MaterialLocalizations`][]

[Revisão da API Actions]: /release/breaking-changes/actions-api-revision
[Adicionando a propriedade `TextInputClient.currentAutofillScope`]: /release/breaking-changes/add-currentAutofillScope-to-TextInputClient
[Novos botões e temas de botões]: /release/breaking-changes/buttons
[`BorderRadius` padrão dos diálogos]: /release/breaking-changes/dialog-border-radius
[Asserções mais estritas no Navigator e no escopo do Controlador Hero]: /release/breaking-changes/hero-controller-scope
[Invertendo a dependência entre o agendador e a camada de serviços]: /release/breaking-changes/services-scheduler-dependency-reversed
[`RenderEditable` precisa ser disposta antes do teste de hit]: /release/breaking-changes/rendereditable-layout-before-hit-test
[Ordem semântica das entradas de sobreposição em rotas modais]: /release/breaking-changes/modal-router-semantics-order
[Método `showAutocorrectionPromptRect` adicionado a `TextInputClient`]: /release/breaking-changes/add-showAutocorrectionPromptRect
[`TestWidgetsFlutterBinding.clock`]: /release/breaking-changes/test-widgets-flutter-binding-clock
[`TextField` requer `MaterialLocalizations`]: /release/breaking-changes/text-field-material-localizations
[O registro de transição de rota e atualizações do delegado de transição]: /release/breaking-changes/route-transition-record-and-transition-delegate

<a id="released-in-flutter-117" aria-hidden="true"></a>
### Lançado no Flutter 1.17

* [Adicionando 'linux' e 'windows' ao enum `TargetPlatform`][]
* [Anotações retornam a posição local relativa ao objeto][]
* [Otimização da cor do container][]
* [`CupertinoTabBar` requer pai `Localizations`][]
* [Tipo genérico de `ParentDataWidget` alterado para `ParentData`][]
* [Mudanças em `ImageCache` e `ImageProvider`][]
* [`ImageCache` imagens grandes][]
* [`MouseTracker` movido para a renderização][]
* [`MouseTracker` não anexa mais anotações][]
* [`CupertinoTheme.brightness` anulável][]
* [Otimização de reconstrução para `OverlayEntries` e `Routes`][]
* [`AlertDialog` rolável][]
* [Redefinição do estado `TestTextInput`][]
* [`TextInputClient` `currentTextEditingValue`][]
* [O método `forgetChild()` deve chamar super][]
* [A refatoração de `Route` e `Navigator`][]
* [`FloatingActionButton` e propriedades de acento de `ThemeData`][]

[Adicionando 'linux' e 'windows' ao enum `TargetPlatform`]: /release/breaking-changes/target-platform-linux-windows
[Anotações retornam a posição local relativa ao objeto]: /release/breaking-changes/annotations-return-local-position-relative-to-object
[Otimização da cor do container]: /release/breaking-changes/container-color
[`CupertinoTabBar` requer pai `Localizations`]: /release/breaking-changes/cupertino-tab-bar-localizations
[Tipo genérico de `ParentDataWidget` alterado para `ParentData`]: /release/breaking-changes/parent-data-widget-generic-type
[Mudanças em `ImageCache` e `ImageProvider`]: /release/breaking-changes/image-cache-and-provider
[`ImageCache` imagens grandes]: /release/breaking-changes/imagecache-large-images
[`MouseTracker` movido para a renderização]: /release/breaking-changes/mouse-tracker-moved-to-rendering
[`MouseTracker` não anexa mais anotações]: /release/breaking-changes/mouse-tracker-no-longer-attaches-annotations
[`CupertinoTheme.brightness` anulável]: /release/breaking-changes/nullable-cupertinothemedata-brightness
[Otimização de reconstrução para `OverlayEntries` e `Routes`]: /release/breaking-changes/overlay-entry-rebuilds
[Substituir `AnimationSheetBuilder.display` por `collate`]: /release/breaking-changes/animation-sheet-builder-display
[`AlertDialog` rolável]: /release/breaking-changes/scrollable-alert-dialog
[Redefinição do estado `TestTextInput`]: /release/breaking-changes/test-text-input
[`TextInputClient` `currentTextEditingValue`]: /release/breaking-changes/text-input-client-current-value
[O método `forgetChild()` deve chamar super]: /release/breaking-changes/forgetchild-call-super
[A refatoração de `Route` e `Navigator`]: /release/breaking-changes/route-navigator-refactoring
[`FloatingActionButton` e propriedades de acento de `ThemeData`]: /release/breaking-changes/fab-theme-data-accent-properties
