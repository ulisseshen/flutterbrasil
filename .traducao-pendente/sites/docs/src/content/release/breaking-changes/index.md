---
title: Breaking changes and migration guides
shortTitle: Breaking changes
description: >-
   A collection of notices and migration guides for breaking changes in Flutter.
ia-translate: true
---

Conforme descrito na [política de breaking change][breaking change policy],
ocasionalmente publicamos guias
para migrar código através de uma breaking change.

{% render "docs/breaking-changes.md" %}

Para ser notificado sobre futuras breaking changes,
junte-se aos grupos [Flutter announce][] e [Dart announce][].

Ao enfrentar erros do Dart após atualizar o Flutter,
considere usar o comando [`dart fix`][]
para migrar automaticamente seu código.
Nem toda breaking change é suportada desta forma,
mas muitas são.

Para evitar ser quebrado por versões futuras do Flutter,
considere submeter seus testes para o [registro de testes][test registry] do framework.

[breaking change policy]: /release/compatibility-policy
[Flutter announce]: {{site.groups.flutter-announce}}
[Dart announce]: {{site.groups.dart-announce}}
[`dart fix`]: /tools/flutter-fix
[test registry]: https://github.com/flutter/tests

## Breaking changes por versão {:#breaking-changes-by-release}

Os seguintes guias estão disponíveis.
Eles estão organizados por versão e listados em ordem alfabética:

<<<<<<< pt
### Ainda não lançado na stable {:#not-yet-released-to-stable}
||||||| base_en
### Not yet released to stable
=======
<!-- ### Not yet released to stable -->
>>>>>>> new_en

<<<<<<< pt
* [Propriedade enabled adicionada e onChanged opcional em DropdownButton][Added enabled property and made onChanged optional for DropdownButton]
* [Migre para os pacotes independentes material_ui e cupertino_ui][Migrate to standalone `material_ui` and `cupertino_ui` packages]
* [Restringe flags do engine Android em modo release][Restrict Android engine flags in release mode]
* [Hifens suaves são renderizados nas quebras de linha][Soft hyphens render at line breaks]
* [Verificação mais rigorosa de `Intent` do Android para entrypoints de apps][Stricter Android `Intent` verification for app entrypoints]
* [Suporte a SafeArea com viewport-fit=cover na web][Web `viewport-fit=cover` `SafeArea` support]
* [Ordem de WidgetSpan em texto da direita para a esquerda][WidgetSpan order in right-to-left text]
||||||| base_en
* [Added enabled property and made onChanged optional for DropdownButton][]
* [Migrate to standalone `material_ui` and `cupertino_ui` packages][]
* [Restrict Android engine flags in release mode][]
* [Soft hyphens render at line breaks][]
* [Stricter Android `Intent` verification for app entrypoints][]
* [Web `viewport-fit=cover` `SafeArea` support][]
* [WidgetSpan order in right-to-left text][]
=======
<a id="released-in-flutter-350" aria-hidden="true"></a>
### Released in Flutter 3.50

* [Added `enabled` to `DropdownButtonFormField` and made `onChanged` optional][] (`material_ui` 1.8.0)
* [Migrate to standalone `material_ui` and `cupertino_ui` packages][]
* [Restrict Android engine flags in release mode][]
* [Soft hyphens render at line breaks][]
* [Stricter Android `Intent` verification for app entrypoints][]
* [Web `viewport-fit=cover` `SafeArea` support][]
* [WidgetSpan order in right-to-left text][]
>>>>>>> new_en

[Added `enabled` to `DropdownButtonFormField` and made `onChanged` optional]: /release/breaking-changes/dropdownbuttonformfield-enabled-parameter
[Migrate to standalone `material_ui` and `cupertino_ui` packages]: /release/breaking-changes/material-ui-and-cupertino-ui
[Restrict Android engine flags in release mode]: /release/breaking-changes/restrict-android-engine-flags-release-mode
[Soft hyphens render at line breaks]: /release/breaking-changes/soft-hyphen-rendering
[Stricter Android `Intent` verification for app entrypoints]: /release/breaking-changes/stricter-android-entrypoint-intent-verification
[Web `viewport-fit=cover` `SafeArea` support]: /release/breaking-changes/viewport-fit-cover-safe-area
[WidgetSpan order in right-to-left text]: /release/breaking-changes/widgetspan-rtl-bidi-order

<a id="released-in-flutter-347" aria-hidden="true"></a>
### Lançado no Flutter 3.47

* [O conteúdo de render-to-texture do OpenGL ES é armazenado de cima para baixo][OpenGL ES render-to-texture content is stored top-down]
* [Atualização do comportamento de header e headingLevel no iOS e Android][Update semantics header and headingLevel behavior on iOS and Android]
* [Remove describeEnum][Removal of `describeEnum`]

[OpenGL ES render-to-texture content is stored top-down]: /release/breaking-changes/opengles-render-to-texture-top-down
[Update semantics header and headingLevel behavior on iOS and Android]: /release/breaking-changes/semantics-header-heading-level
[Removal of `describeEnum`]: /release/breaking-changes/remove-describeEnum

<a id="released-in-flutter-344" aria-hidden="true"></a>
### Lançado no Flutter 3.44

* [Mudança na ordem de fechamento do RawMenuAnchor][Changing RawMenuAnchor close order]
* [Deprecação do callback onReorder][Deprecate `onReorder` callback]
* [Descontinua `TextInputConnection.setStyle`][Deprecate `TextInputConnection.setStyle`]
* ['`cacheExtent` e `cacheExtentStyle` descontinuados'][Deprecated `cacheExtent` and `cacheExtentStyle`]
* [Classe IconData marcada como final][`IconData` class marked as `final`]
* [Restrições de orientação e redimensionamento em telas grandes ignoradas no Android 17][Large screen orientation and resizability restrictions ignored on Android 17]
* [ListTile reporta um erro em debug quando envolvido por um widget colorido][ListTile reports an error in debug when wrapped in a colored widget]
* [Migração de projetos Android do Flutter para o Kotlin integrado][Migrating Flutter Android projects to built-in Kotlin]
* [Reorganização dos builders de transição de página][Page transition builders reorganization]

[Changing RawMenuAnchor close order]: /release/breaking-changes/raw-menu-anchor-close-order
[Deprecate `onReorder` callback]: /release/breaking-changes/deprecate-onreorder-callback
[Deprecated `cacheExtent` and `cacheExtentStyle`]: /release/breaking-changes/scroll-cache-extent
[Deprecate `TextInputConnection.setStyle`]: /release/breaking-changes/deprecate-text-input-connection-set-style
[`IconData` class marked as `final`]: /release/breaking-changes/icondata-class-marked-final
[Large screen orientation and resizability restrictions ignored on Android 17]: /release/breaking-changes/android-large-screens-restrictions-ignored
[ListTile reports an error in debug when wrapped in a colored widget]: /release/breaking-changes/list-tile-color-warning
[Migrating Flutter Android projects to built-in Kotlin]: /release/breaking-changes/migrate-to-built-in-kotlin
[Page transition builders reorganization]: /release/breaking-changes/decouple-page-transition-builders

<a id="released-in-flutter-341" aria-hidden="true"></a>
### Lançado no Flutter 3.41

* [Threads unificadas no Linux][Merged threads on Linux]
* [FontWeight também controla o atributo weight de fontes variáveis][`FontWeight` also controls the weight attribute of variable fonts]
* [Depreciação de `containsSemantics` em favor de `isSemantics`][Deprecate `containsSemantics` in favor of `isSemantics`]
* [Depreciação de `findChildIndexCallback` em favor de `findItemIndexCallback` nos construtores separated de `ListView` e `SliverList`][Deprecate `findChildIndexCallback` in favor of `findItemIndexCallback` in `ListView` and `SliverList` separated constructors]
* [Atualização do Material Color Utilities no Flutter][Material 3 tokens update]

[Merged threads on Linux]: /release/breaking-changes/linux-merged-threads
[`FontWeight` also controls the weight attribute of variable fonts]: /release/breaking-changes/font-weight-variation
[Deprecate `containsSemantics` in favor of `isSemantics`]: /release/breaking-changes/deprecate-contains-semantics
[Deprecate `findChildIndexCallback` in favor of `findItemIndexCallback` in `ListView` and `SliverList` separated constructors]: /release/breaking-changes/separated-builder-find-child-index-callback
[Material 3 tokens update]: /release/breaking-changes/material-color-utilities

<a id="released-in-flutter-338" aria-hidden="true"></a>
### Lançado no Flutter 3.38

* [Guia de migração para CupertinoDynamicColor de gamut amplo][`CupertinoDynamicColor` wide gamut support]
* [Deprecate `OverlayPortal.targetsRootOverlay` and enforce `LookupBoundary` in `Overlay.of`][Deprecate `OverlayPortal.targetsRootOverlay`]
* [Descontinuação de `SemanticsProperties.focusable` e `SemanticsConfiguration.isFocusable`][Deprecate `SemanticsProperties.focusable` and `SemanticsConfiguration.isFocusable`]
* [SnackBar com action não fecha mais automaticamente][SnackBar with action no longer auto-dismisses]
* [A transição de página padrão no Android agora é PredictiveBackPageTransitionsBuilder][The default page transition on Android is now `PredictiveBackPageTransitionBuilder`]
* [Adoção do UIScene][UISceneDelegate adoption]

[`CupertinoDynamicColor` wide gamut support]: /release/breaking-changes/wide-gamut-cupertino-dynamic-color
[Deprecate `OverlayPortal.targetsRootOverlay`]: /release/breaking-changes/deprecate-overlay-portal-targets-root
[Deprecate `SemanticsProperties.focusable` and `SemanticsConfiguration.isFocusable`]: /release/breaking-changes/deprecate-focusable
[SnackBar with action no longer auto-dismisses]: /release/breaking-changes/snackbar-with-action-behavior-update
[The default page transition on Android is now `PredictiveBackPageTransitionBuilder`]: /release/breaking-changes/default-android-page-transition
[UISceneDelegate adoption]: /release/breaking-changes/uiscenedelegate

<a id="released-in-flutter-335" aria-hidden="true"></a>
### Lançado no Flutter 3.35

* [Atualizações de normalização de temas de componentes][Component theme normalization updates]
* [>-][Deprecate `DropdownButtonFormField` `value` parameter in favor of `initialValue`]
* [Descontinuação do parâmetro color no tema do AppBar][Deprecate app bar color]
* [Widget `Radio` redesenhado][Redesigned the `Radio` widget]
* [Removido elevation e thickness da semântica][Removed semantics elevation and thickness]
* [O widget Form não suporta mais ser um sliver.][The `Form` widget no longer supports being a sliver]
* [Flutter agora define `abiFilters` padrão em builds Android][Flutter now sets default `abiFilters` in Android builds]
* [Threads mescladas no macOS e Windows][Merged threads on macOS and Windows]
* [O widget Visibility não é mais focalizável por padrão quando maintainState está habilitado][The `Visibility` widget is no longer focusable by default when `maintainState` is enabled]
* [$FLUTTER_ROOT/bin/cache/flutter.version.json substitui $FLUTTER_ROOT/version][`$FLUTTER_ROOT/version` replaced by `$FLUTTER_ROOT/bin/cache/flutter.version.json`]

[Component theme normalization updates]: /release/breaking-changes/component-theme-normalization-updates
[Deprecate `DropdownButtonFormField` `value` parameter in favor of `initialValue`]: /release/breaking-changes/deprecate-dropdownbuttonformfield-value
[Deprecate app bar color]: /release/breaking-changes/appbar-theme-color
[Redesigned the `Radio` Widget]: /release/breaking-changes/radio-api-redesign
[Removed semantics elevation and thickness]: /release/breaking-changes/remove-semantics-elevation-and-thickness
[The `Form` widget no longer supports being a sliver]: /release/breaking-changes/form-semantics
[Flutter now sets default `abiFilters` in Android builds]: /release/breaking-changes/default-abi-filters-android
[Merged threads on macOS and Windows]: /release/breaking-changes/macos-windows-merged-threads
[The `Visibility` widget is no longer focusable by default when `maintainState` is enabled]: /release/breaking-changes/visibility-maintainfocusability
[`$FLUTTER_ROOT/version` replaced by `$FLUTTER_ROOT/bin/cache/flutter.version.json`]: /release/breaking-changes/flutter-root-version-file

<a id="released-in-flutter-332" aria-hidden="true"></a>
### Lançado no Flutter 3.32

* [SystemContextMenuController.show descontinuado][Deprecate `SystemContextMenuController.show`]
* [Descontinuação do ExpansionTileController][Deprecate `ExpansionTileController` in favor of `ExpansibleController`]
* [Quando uma rota é removida da pilha, os futuros associados devem ser completados][deprecate-markForRemove]
  em favor de `RouteTransitionRecord.markForComplete`
* [Descontinuar `ThemeData.indicatorColor` em favor de][Deprecate `ThemeData.indicatorColor` in favor of `TabBarThemeData.indicatorColor`]
* [Atualizações do sistema de tema Material][Material Theme System Updates]
* [.flutter-plugins-dependencies substitui .flutter-plugins.][`.flutter-plugins-dependencies` replaces `.flutter-plugins`]
* [Mensagens localizadas são geradas no código fonte, não em um pacote sintético][Localized messages are generated into source, not a synthetic package]
* [Comparadores padrão de golden-file em testes de integração alterados no Android e iOS.][Changing the default `goldenFileComparator` for `integration_test`s]
* [Depreciar `InputDecoration.maintainHintHeight` em favor de][Deprecate `InputDecoration.maintainHintHeight` in favor of `InputDecoration.maintainHintSize`]
* [Fórmula de spring underdamped alterada][Underdamped spring formula changed]

[Deprecate `SystemContextMenuController.show`]: /release/breaking-changes/system_context_menu_controller_show
[Deprecate `ExpansionTileController` in favor of `ExpansibleController`]: /release/breaking-changes/expansion-tile-controller
[deprecate-markForRemove]: /release/breaking-changes/navigator-complete-route
[Deprecate `ThemeData.indicatorColor` in favor of `TabBarThemeData.indicatorColor`]: /release/breaking-changes/deprecate-themedata-indicatorcolor
[Localized messages are generated into source, not a synthetic package]: /release/breaking-changes/flutter-generate-i10n-source
[Material Theme System Updates]: /release/breaking-changes/material-theme-system-updates
[`.flutter-plugins-dependencies` replaces `.flutter-plugins`]: /release/breaking-changes/flutter-plugins-configuration
[Changing the default `goldenFileComparator` for `integration_test`s]: /release/breaking-changes/integration-test-default-golden-comparator
[Deprecate `InputDecoration.maintainHintHeight` in favor of `InputDecoration.maintainHintSize`]: /release/breaking-changes/deprecate-inputdecoration-maintainhintheight
[Underdamped spring formula changed]: /release/breaking-changes/spring-description-underdamped

<a id="released-in-flutter-329" aria-hidden="true"></a>
### Lançado no Flutter 3.29

* [Remoção das APIs Java do Android v1 embedding][Removal of v1 Android embedding Java APIs]
* [Comparações golden específicas da Web não são mais suportadas][Deprecate `WebGoldenComparator`]
* [Descontinuar `ThemeData.dialogBackgroundColor` em favor de][Deprecate `ThemeData.dialogBackgroundColor` in favor of `DialogThemeData.backgroundColor`]
* [ImageFilter.blur default tile mode automatic selection.][`ImageFilter.blur` default tile mode automatic selection]
* ['`Slider` do Material 3 atualizado'][Updated Material 3 `Slider`]
* [Indicadores de progresso Material 3 atualizados][Updated Material 3 progress indicators]

[Removal of v1 Android embedding Java APIs]: /release/breaking-changes/v1-android-embedding
[Deprecate `WebGoldenComparator`]: /release/breaking-changes/web-golden-comparator
[Deprecate `ThemeData.dialogBackgroundColor` in favor of `DialogThemeData.backgroundColor`]: /release/breaking-changes/deprecate-themedata-dialogbackgroundcolor
[`ImageFilter.blur` default tile mode automatic selection]: /release/breaking-changes/image-filter-blur-tilemode
[Updated Material 3 progress indicators]: /release/breaking-changes/updated-material-3-progress-indicators
[Updated Material 3 `Slider`]: /release/breaking-changes/updated-material-3-slider

<a id="released-in-flutter-327" aria-hidden="true"></a>
### Lançado no Flutter 3.27

* [Guia de migração para Color de gama ampla][`Color` wide gamut support]
* [Normalização de component theme][Component theme normalization]
* [Mudança na flag de deep links][Deep links flag change]
* [Atualização de tokens Material 3 no Flutter][Material 3 Tokens Update in Flutter]
* [Remover parâmetros inválidos para `InputDecoration.collapsed`][Remove invalid parameters for `InputDecoration.collapsed`]
* [Definir padrão de `SystemUiMode` para edge-to-edge][Set default for SystemUiMode to Edge-to-Edge]

[`Color` wide gamut support]: /release/breaking-changes/wide-gamut-framework
[Component theme normalization]: /release/breaking-changes/component-theme-normalization
[Deep links flag change]: /release/breaking-changes/deep-links-flag-change
[Material 3 Tokens Update in Flutter]: /release/breaking-changes/material-design-3-token-update
[Remove invalid parameters for `InputDecoration.collapsed`]: /release/breaking-changes/input-decoration-collapsed
[Set default for SystemUiMode to Edge-to-Edge]: /release/breaking-changes/default-systemuimode-edge-to-edge

<a id="released-in-flutter-324" aria-hidden="true"></a>
### Lançado no Flutter 3.24

* [Alteração incompatível nas APIs de página do Navigator][Navigator's page APIs breaking change]
* [Tipos genéricos no PopScope][Generic types in `PopScope`]
* [Descontinuar `ButtonBar` em favor de `OverflowBar`][Deprecate `ButtonBar` in favor of `OverflowBar`]
* [Novas APIs para plugins Android que renderizam em uma Surface][New APIs for Android plugins that render to a `Surface`]

[Navigator's page APIs breaking change]: /release/breaking-changes/navigator-and-page-api
[Generic types in `PopScope`]: /release/breaking-changes/popscope-with-result
[Deprecate `ButtonBar` in favor of `OverflowBar`]: /release/breaking-changes/deprecate-buttonbar
[New APIs for Android plugins that render to a `Surface`]: /release/breaking-changes/android-surface-plugins

<a id="released-in-flutter-322" aria-hidden="true"></a>
### Lançado no Flutter 3.22

* [Deprecated API removed after v3.19][Deprecated API removed after v3.19]
* [Renomear MaterialState para WidgetState][Rename `MaterialState` to `WidgetState`]
* [Introduce new ColorScheme roles for Material 3][Introduce new `ColorScheme` roles]
* [Descontinuando suporte para Android KitKat][Dropping support for Android KitKat]
* [Tornar PageView.controller anulável][Nullable `PageView.controller`]
* [Descontinuar MemoryAllocations em favor de FlutterMemoryAllocations][Rename `MemoryAllocations` to `FlutterMemoryAllocations`]

[Deprecated API removed after v3.19]: /release/breaking-changes/3-19-deprecations
[Rename `MaterialState` to `WidgetState`]: /release/breaking-changes/material-state
[Introduce new `ColorScheme` roles]: /release/breaking-changes/new-color-scheme-roles
[Dropping support for Android KitKat]: /release/breaking-changes/android-kitkat-deprecation
[Nullable `PageView.controller`]: /release/breaking-changes/pageview-controller
[Rename `MemoryAllocations` to `FlutterMemoryAllocations`]: /release/breaking-changes/flutter-memory-allocations

<a id="released-in-flutter-319" aria-hidden="true"></a>

### Lançado no Flutter 3.19

* [APIs descontinuadas removidas após v3.16][Deprecated API removed after v3.16]
* [Migrar sistema RawKeyEvent/RawKeyboard para sistema KeyEvent/HardwareKeyboard][Migrate RawKeyEvent/RawKeyboard system to KeyEvent/HardwareKeyboard system]
* [Aplicação imperativa descontinuada dos plugins Gradle do Flutter][Deprecate imperative apply of Flutter's Gradle plugins]
* [Scrolling multitouch padrão][Default multitouch scrolling]
* [Ordem de travessia de acessibilidade do tooltip alterada][Accessibility traversal order of tooltip changed]
* [Remoção do AssetManifest.json][Stop generating `AssetManifest.json`]

[Deprecated API removed after v3.16]: /release/breaking-changes/3-16-deprecations
[Migrate RawKeyEvent/RawKeyboard system to KeyEvent/HardwareKeyboard system]: /release/breaking-changes/key-event-migration
[Deprecate imperative apply of Flutter's Gradle plugins]: /release/breaking-changes/flutter-gradle-plugin-apply
[Default multitouch scrolling]: /release/breaking-changes/multi-touch-scrolling
[Accessibility traversal order of tooltip changed]: /release/breaking-changes/tooltip-semantics-order
[Stop generating `AssetManifest.json`]: /release/breaking-changes/asset-manifest-dot-json

<a id="released-in-flutter-316" aria-hidden="true"></a>
### Lançado no Flutter 3.16

* [Migrate to Material 3][Migrating to Material 3]
* [Migrar ShortcutActivator e ShortcutManager para o sistema KeyEvent][Migrate ShortcutActivator and ShortcutManager to KeyEvent system]
* [O flag ThemeData.useMaterial3 é true por padrão][The `ThemeData.useMaterial3` property is now set to true by default]
* [API descontinuada removida após v3.13][Deprecated API removed after v3.13]
* [Customizando alinhamento de tabs usando a nova propriedade TabBar.tabAlignment][Customize tabs alignment using the new `TabBar.tabAlignment` property]
* [Descontinuação de textScaleFactor em favor de TextScaler][Deprecate `textScaleFactor` in favor of `TextScaler`]
* [Escalonamento de fonte não linear do Android 14 habilitado][Android 14 nonlinear font scaling enabled]
* [Guia de migração para describeEnum e EnumProperty][Deprecate `describeEnum` and update `EnumProperty` to be type strict]
* [Retorno preditivo do Android][Deprecated just-in-time navigation pop APIs for Android Predictive Back]
* [Paint.enableDithering is now true by default.][Deprecated `Paint.enableDithering`]
* [Estilos de texto padrão atualizados para menus][Updated default text styles for menus]
* [Introdução do FlutterEngine::ProcessExternalWindowMessage][Windows: External windows should notify Flutter engine of lifecycle changes]
* [Caminho de build do Windows alterado para adicionar a arquitetura de destino][Windows build path changed to add the target architecture]

[Migrating to Material 3]: /release/breaking-changes/material-3-migration
[Migrate ShortcutActivator and ShortcutManager to KeyEvent system]: /release/breaking-changes/shortcut-key-event-migration
[The `ThemeData.useMaterial3` property is now set to true by default]: /release/breaking-changes/material-3-default
[Deprecated API removed after v3.13]: /release/breaking-changes/3-13-deprecations
[Customize tabs alignment using the new `TabBar.tabAlignment` property]: /release/breaking-changes/tab-alignment
[Deprecate `textScaleFactor` in favor of `TextScaler`]: /release/breaking-changes/deprecate-textscalefactor
[Android 14 nonlinear font scaling enabled]: /release/breaking-changes/android-14-nonlinear-text-scaling-migration
[Deprecate `describeEnum` and update `EnumProperty` to be type strict]: /release/breaking-changes/describe-enum
[Deprecated just-in-time navigation pop APIs for Android Predictive Back]: /release/breaking-changes/android-predictive-back
[Deprecated `Paint.enableDithering`]: /release/breaking-changes/paint-enableDithering
[Updated default text styles for menus]: /release/breaking-changes/menus-text-style
[Windows: External windows should notify Flutter engine of lifecycle changes]: /release/breaking-changes/win-lifecycle-process-function
[Windows build path changed to add the target architecture]: /release/breaking-changes/windows-build-architecture

<a id="released-in-flutter-313" aria-hidden="true"></a>
### Lançado no Flutter 3.13

* [Adicionado `dispose()` ausente para alguns objetos descartáveis no Flutter][Added missing `dispose()` for some disposable objects in Flutter]
* [API descontinuada removida após v3.10][Deprecated API removed after v3.10]
* [Guia de migração para adicionar AppLifecycleState.hidden][Added AppLifecycleState.hidden] enum value
* [Guia de migração para strings localizadas do Material][Moved ReorderableListView's localized strings] from material to widgets localizations
* [Guia de migração para ignoringSemantics em IgnorePointer e classes relacionadas][Removed `ignoringSemantics`] properties
* [Guia de migração para `RouteInformation.location`][Deprecated `RouteInformation.location`] and its related APIs
* [Comportamento atualizado de scroll into view do EditableText][Updated EditableText scroll into view behavior]
* [Migrar um projeto Windows para garantir que a janela seja exibida][Migrate a Windows project to ensure the window is shown]
* [Comportamento atualizado do `Checkbox.fillColor`][Updated `Checkbox.fillColor` behavior]

[Added missing `dispose()` for some disposable objects in Flutter]: /release/breaking-changes/dispose
[Deprecated API removed after v3.10]: /release/breaking-changes/3-10-deprecations
[Added AppLifecycleState.hidden]: /release/breaking-changes/add-applifecyclestate-hidden
[Moved ReorderableListView's localized strings]: /release/breaking-changes/material-localized-strings
[Removed `ignoringSemantics`]: /release/breaking-changes/ignoringsemantics-migration
[Deprecated `RouteInformation.location`]: /release/breaking-changes/route-information-uri
[Updated EditableText scroll into view behavior]: /release/breaking-changes/editable-text-scroll-into-view
[Migrate a Windows project to ensure the window is shown]: /release/breaking-changes/windows-show-window-migration
[Updated `Checkbox.fillColor` behavior]: /release/breaking-changes/checkbox-fillColor

<a id="released-in-flutter-310" aria-hidden="true"></a>
### Lançado no Flutter 3.10

* [Mudanças do Dart 3 no Flutter v3.10 e posteriores][Dart 3 changes in Flutter v3.10 and later]
* [API descontinuada removida após v3.7][Deprecated API removed after v3.7]
* [Cliente de entrada de texto com inserção de conteúdo][Insert content text input client]
* [The window singleton is deprecated][Deprecated the window singleton]
* [Guia de migração Android Java Gradle][Resolve the Android Java Gradle error]
* [Pelo menos uma variante de dados da área de transferência deve ser fornecida][Require one data variant for `ClipboardData` constructor]
* ["Mensagem \"Zone mismatch\""]["Zone mismatch" message]

[Dart 3 changes in Flutter v3.10 and later]: {{site.dart-site}}/resources/dart-3-migration
[Deprecated API removed after v3.7]: /release/breaking-changes/3-7-deprecations
[Insert Content Text Input Client]: /release/breaking-changes/insert-content-text-input-client
[Deprecated the window singleton]: /release/breaking-changes/window-singleton
[Resolve the Android Java Gradle error]: /release/breaking-changes/android-java-gradle-migration-guide
[Require one data variant for `ClipboardData` constructor]: /release/breaking-changes/clipboard-data-required
["Zone mismatch" message]: /release/breaking-changes/zone-errors

<a id="released-in-flutter-37" aria-hidden="true"></a>
### Lançado no Flutter 3.7

* [API descontinuada removida após v3.3][Deprecated API removed after v3.3]
* [Uma nova maneira de personalizar menus de contexto][Replaced parameters for customizing context menus with a generic widget builder]
* [iOS FlutterViewController splashScreenView tornado anulável][iOS FlutterViewController splashScreenView made nullable]
* [Migre `of` para valores de retorno não-nulos e adicione `maybeOf`][Migrate `of` to non-nullable return values, and add `maybeOf`]
* [Guia de migração para RouteSettings copyWith][Removed RouteSettings.copyWith]
* [A propriedade toggleableActiveColor do ThemeData foi descontinuada][ThemeData's toggleableActiveColor property has been deprecated]
* [Migrar um projeto Windows para suportar barras de título escuras][Migrate a Windows project to support dark title bars]

[Replaced parameters for customizing context menus with a generic widget builder]: /release/breaking-changes/context-menus
[Deprecated API removed after v3.3]: /release/breaking-changes/3-3-deprecations
[iOS FlutterViewController splashScreenView made nullable]: /release/breaking-changes/ios-flutterviewcontroller-splashscreenview-nullable
[Migrate `of` to non-nullable return values, and add `maybeOf`]: /release/breaking-changes/supplemental-maybeOf-migration
[Removed RouteSettings.copyWith]: /release/breaking-changes/routesettings-copywith-migration
[ThemeData's toggleableActiveColor property has been deprecated]: /release/breaking-changes/toggleable-active-color
[Migrate a Windows project to support dark title bars]: /release/breaking-changes/windows-dark-mode

<a id="released-in-flutter-33" aria-hidden="true"></a>
### Lançado no Flutter 3.3

* [Adicionando ImageProvider.loadBuffer][Adding ImageProvider.loadBuffer]
* [Default `PrimaryScrollController` on Desktop][Default PrimaryScrollController on Desktop]
* [Gestos de trackpad podem acionar GestureRecognizer][Trackpad gestures can trigger GestureRecognizer]
* [Migrar um projeto Windows para definir informações de versão][Migrate a Windows project to set version information]

[Adding ImageProvider.loadBuffer]: /release/breaking-changes/image-provider-load-buffer
[Default PrimaryScrollController on Desktop]: /release/breaking-changes/primary-scroll-controller-desktop
[Trackpad gestures can trigger GestureRecognizer]: /release/breaking-changes/trackpad-gestures
[Migrate a Windows project to set version information]: /release/breaking-changes/windows-version-information

### Lançado no Flutter 3

* [API obsoleta removida após v2.10][Deprecated API removed after v2.10]
* [Migrar useDeleteButtonTooltip para deleteButtonTooltipMessage dos Chips][Migrate useDeleteButtonTooltip to deleteButtonTooltipMessage of Chips]
* [Transições de página substituídas por ZoomPageTransitionsBuilder][Page transitions replaced by ZoomPageTransitionsBuilder]

[Deprecated API removed after v2.10]: /release/breaking-changes/2-10-deprecations
[Page transitions replaced by ZoomPageTransitionsBuilder]: /release/breaking-changes/page-transition-replaced-by-ZoomPageTransitionBuilder
[Migrate useDeleteButtonTooltip to deleteButtonTooltipMessage of Chips]: /release/breaking-changes/chip-usedeletebuttontooltip-migration

<a id="released-in-flutter-210" aria-hidden="true"></a>
### Lançado no Flutter 2.10

* [APIs descontinuadas removidas após v2.5][Deprecated API removed after v2.5]
* [Imagens raw na Web usam origem e cores corretas][Raw images on Web uses correct origin and colors]
* [Versão obrigatória do Kotlin][Required Kotlin version]
* [Scribble Text Input Client][Scribble Text Input Client]

[Deprecated API removed after v2.5]: /release/breaking-changes/2-5-deprecations
[Raw images on Web uses correct origin and colors]: /release/breaking-changes/raw-images-on-web-uses-correct-origin-and-colors
[Required Kotlin version]: /release/breaking-changes/kotlin-version
[Scribble Text Input Client]: /release/breaking-changes/scribble-text-input-client

<a id="released-in-flutter-25" aria-hidden="true"></a>
### Lançado no Flutter 2.5

* [Dispositivos de arrasto de rolagem padrão][Default drag scrolling devices]
* [API descontinuada removida após v2.2][Deprecated API removed after v2.2]
* [Alterar o método enterText para mover o cursor para o final do texto de entrada][Change the enterText method to move the caret to the end of the input text]
* [Limpeza do GestureRecognizer][GestureRecognizer cleanup]
* [Apresentando package:flutter_lints][Introducing package:flutter_lints]
* [Substituir AnimationSheetBuilder.display por collate][Replace AnimationSheetBuilder.display with collate]
* [As propriedades accent do ThemeData foram descontinuadas][ThemeData's accent properties have been deprecated]
* [Transição de interfaces de teste de canal de plataforma para o pacote flutter_test][Transition of platform channel test interfaces to flutter_test package]
* [Usando slots HTML para renderizar platform views na web][Using HTML slots to render platform views in the web]
* [Migrar um projeto Windows para o run loop idiomático][Migrate a Windows project to the idiomatic run loop]

[Change the enterText method to move the caret to the end of the input text]: /release/breaking-changes/enterText-trailing-caret
[Default drag scrolling devices]: /release/breaking-changes/default-scroll-behavior-drag
[Deprecated API removed after v2.2]: /release/breaking-changes/2-2-deprecations
[GestureRecognizer cleanup]: /release/breaking-changes/gesture-recognizer-add-allowed-pointer
[Introducing package:flutter_lints]: /release/breaking-changes/flutter-lints-package
[Replace AnimationSheetBuilder.display with collate]: /release/breaking-changes/animation-sheet-builder-display
[ThemeData's accent properties have been deprecated]: /release/breaking-changes/theme-data-accent-properties
[Transition of platform channel test interfaces to flutter_test package]: /release/breaking-changes/mock-platform-channels
[Using HTML slots to render platform views in the web]: /release/breaking-changes/platform-views-using-html-slots-web
[Migrate a Windows project to the idiomatic run loop]: /release/breaking-changes/windows-run-loop

### Mudança revertida na 2.2 {:#reverted-change-in-2-2}

A seguinte breaking change foi revertida na versão 2.2:

**[Política de rede no iOS e Android][Network Policy on iOS and Android]**<br>
:  Introduzida na versão: 2.0.0<br>
   Revertida na versão: 2.2.0

[Network Policy on iOS and Android]: /release/breaking-changes/network-policy-ios-android

<a id="released-in-flutter-22" aria-hidden="true"></a>
### Lançado no Flutter 2.2

* [Scrollbars padrão no Desktop][Default Scrollbars on Desktop]

[Default Scrollbars on Desktop]: /release/breaking-changes/default-desktop-scrollbars

### Lançado no Flutter 2

* [Adicionado parâmetro BuildContext a TextEditingController.buildTextSpan][Added BuildContext parameter to TextEditingController.buildTextSpan]
* [Mudança na assinatura do attachToActivity do ActivityControlSurface do Android][Android ActivityControlSurface attachToActivity signature change]
* [FlutterMain.setIsRunningInRobolectricTest no Android removido][Android FlutterMain.setIsRunningInRobolectricTest testing API removed]
* [Comportamento de Clip][Clip behavior]
* [API obsoleta removida após v1.22][Deprecated API removed after v1.22]
* [Suporte a dry layout para RenderBox][Dry layout support for RenderBox]
* [Eliminating nullOk Parameters][Eliminating nullOk Parameters]
* [Semântica de botão do Material Chip][Material Chip button semantics]
* [SnackBars gerenciados pelo ScaffoldMessenger][SnackBars managed by the ScaffoldMessenger]
* [Migração de TextSelectionTheme][TextSelectionTheme migration]
* [Transição de interfaces de teste de canal de plataforma para o pacote flutter_test][Transition of platform channel test interfaces to flutter_test package]
* [Use maxLengthEnforcement em vez de maxLengthEnforced][Use maxLengthEnforcement instead of maxLengthEnforced]

[Added BuildContext parameter to TextEditingController.buildTextSpan]: /release/breaking-changes/buildtextspan-buildcontext
[Android ActivityControlSurface attachToActivity signature change]: /release/breaking-changes/android-activity-control-surface-attach
[Android FlutterMain.setIsRunningInRobolectricTest testing API removed]: /release/breaking-changes/android-setIsRunningInRobolectricTest-removed
[Clip behavior]: /release/breaking-changes/clip-behavior
[Deprecated API removed after v1.22]: /release/breaking-changes/1-22-deprecations
[Dry layout support for RenderBox]: /release/breaking-changes/renderbox-dry-layout
[Eliminating nullOk Parameters]: /release/breaking-changes/eliminating-nullok-parameters
[Material Chip button semantics]: /release/breaking-changes/material-chip-button-semantics
[SnackBars managed by the ScaffoldMessenger]: /release/breaking-changes/scaffold-messenger
[TextSelectionTheme migration]: /release/breaking-changes/text-selection-theme
[Use maxLengthEnforcement instead of maxLengthEnforced]: /release/breaking-changes/use-maxLengthEnforcement-instead-of-maxLengthEnforced
[Transition of platform channel test interfaces to flutter_test package]: /release/breaking-changes/mock-platform-channels

<a id="released-in-flutter-122" aria-hidden="true"></a>
### Lançado no Flutter 1.22

* [Descontinuação da criação de apps e plugins com Android v1 embedding][Android v1 embedding app and plugin creation deprecation]
* [Novo CupertinoIcons tem alterações nos glifos de ícones][Cupertino icons 1.0.0]
* [A nova API de auto-validação de Form e FormField][The new Form, FormField auto-validation API]


[Android v1 embedding app and plugin creation deprecation]: /release/breaking-changes/android-v1-embedding-create-deprecation
[Cupertino icons 1.0.0]: /release/breaking-changes/cupertino-icons-1.0.0
[The new Form, FormField auto-validation API]: /release/breaking-changes/form-field-autovalidation-api

<a id="released-in-flutter-120" aria-hidden="true"></a>
### Lançado no Flutter 1.20

* [Revisão da API Actions][Actions API revision]
* [Adicionando a propriedade TextInputClient.currentAutofillScope][Adding TextInputClient.currentAutofillScope property]
* [Novos Botões e temas de Botões][New Buttons and Button Themes]
* [BorderRadius padrão de Dialogs][Dialogs' Default BorderRadius]
* [Asserções mais rigorosas no Navigator e no escopo do Hero controller][More Strict Assertions in the Navigator and the Hero Controller Scope]
* [Atualizações de registro de transição de rota e delegado de transição][The Route Transition record and Transition delegate updates]
* [O RenderEditable precisa ser diagramado antes do hit testing][The RenderEditable needs to be laid out before hit testing]
* [Inversão da dependência entre as camadas scheduler e services][Reversing the dependency between the scheduler and services layer]
* [Ordem de Semantics das Overlay Entries em Modal Routes][Semantics Order of the Overlay Entries in Modal Routes]
* [Método showAutocorrectionPromptRect adicionado ao TextInputClient][showAutocorrectionPromptRect method added to TextInputClient]
* [Mudança em TestWidgetsFlutterBinding.clock][TestWidgetsFlutterBinding.clock]
* [TextField requer um widget MaterialLocalizations][TextField requires MaterialLocalizations]

[Actions API revision]: /release/breaking-changes/actions-api-revision
[Adding TextInputClient.currentAutofillScope property]: /release/breaking-changes/add-currentAutofillScope-to-TextInputClient
[New Buttons and Button Themes]: /release/breaking-changes/buttons
[Dialogs' Default BorderRadius]: /release/breaking-changes/dialog-border-radius
[More Strict Assertions in the Navigator and the Hero Controller Scope]: /release/breaking-changes/hero-controller-scope
[Reversing the dependency between the scheduler and services layer]: /release/breaking-changes/services-scheduler-dependency-reversed
[The RenderEditable needs to be laid out before hit testing]: /release/breaking-changes/rendereditable-layout-before-hit-test
[Semantics Order of the Overlay Entries in Modal Routes]: /release/breaking-changes/modal-router-semantics-order
[showAutocorrectionPromptRect method added to TextInputClient]: /release/breaking-changes/add-showAutocorrectionPromptRect
[TestWidgetsFlutterBinding.clock]: /release/breaking-changes/test-widgets-flutter-binding-clock
[TextField requires MaterialLocalizations]: /release/breaking-changes/text-field-material-localizations
[The Route Transition record and Transition delegate updates]: /release/breaking-changes/route-transition-record-and-transition-delegate

<a id="released-in-flutter-117" aria-hidden="true"></a>
### Lançado no Flutter 1.17

* [Adicionando 'linux' e 'windows' ao enum TargetPlatform][Adding 'linux' and 'windows' to TargetPlatform enum]
* [AnnotatedRegionLayers retornam posição local relativa à região de clipping][Annotations return local position relative to object]
* [Otimização de Container com color][Container color optimization]
* [CupertinoTabBar requer parent Localizations][CupertinoTabBar requires Localizations parent]
* [O tipo genérico de ParentDataWidget mudou para ParentData][Generic type of ParentDataWidget changed to ParentData]
* [ImageCache and ImageProvider changes][ImageCache and ImageProvider changes]
* [Imagens grandes no ImageCache][ImageCache large images]
* [MouseTracker movido para rendering][MouseTracker moved to rendering]
* [MouseTracker não anexa mais annotations][MouseTracker no longer attaches annotations]
* [CupertinoThemeData.brightness anulável][Nullable CupertinoTheme.brightness]
* [Otimização de rebuilds para OverlayEntries e Routes][Rebuild optimization for OverlayEntries and Routes]
* [AlertDialog rolável (Não mais obsoleto)][Scrollable AlertDialog]
* [Estado de TestTextInput redefinido][TestTextInput state reset]
* [TextInputClient currentTextEditingValue][TextInputClient currentTextEditingValue]
* [O método forgetChild() deve chamar super][The forgetChild() method must call super]
* [Refatoração de Route e Navigator][The Route and Navigator refactoring]
* [FloatingActionButton e as propriedades de accent do ThemeData][FloatingActionButton and ThemeData's accent properties]

[Adding 'linux' and 'windows' to TargetPlatform enum]: /release/breaking-changes/target-platform-linux-windows
[Annotations return local position relative to object]: /release/breaking-changes/annotations-return-local-position-relative-to-object
[Container color optimization]: /release/breaking-changes/container-color
[CupertinoTabBar requires Localizations parent]: /release/breaking-changes/cupertino-tab-bar-localizations
[Generic type of ParentDataWidget changed to ParentData]: /release/breaking-changes/parent-data-widget-generic-type
[ImageCache and ImageProvider changes]: /release/breaking-changes/image-cache-and-provider
[ImageCache large images]: /release/breaking-changes/imagecache-large-images
[MouseTracker moved to rendering]: /release/breaking-changes/mouse-tracker-moved-to-rendering
[MouseTracker no longer attaches annotations]: /release/breaking-changes/mouse-tracker-no-longer-attaches-annotations
[Nullable CupertinoTheme.brightness]: /release/breaking-changes/nullable-cupertinothemedata-brightness
[Rebuild optimization for OverlayEntries and Routes]: /release/breaking-changes/overlay-entry-rebuilds
[Scrollable AlertDialog]: /release/breaking-changes/scrollable-alert-dialog
[TestTextInput state reset]: /release/breaking-changes/test-text-input
[TextInputClient currentTextEditingValue]: /release/breaking-changes/text-input-client-current-value
[The forgetChild() method must call super]: /release/breaking-changes/forgetchild-call-super
[The Route and Navigator refactoring]: /release/breaking-changes/route-navigator-refactoring
[FloatingActionButton and ThemeData's accent properties]: /release/breaking-changes/fab-theme-data-accent-properties
