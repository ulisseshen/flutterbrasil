---
ia-translate: true
title: Flutter Changelog 0.0.21 - 1.0.0
shortTitle: Flutter Changelog até 1.0.0
description: Página arquivada do Changelog da wiki, contendo informações de release entre Flutter 0.0.21 e 1.0.0.
skipTemplateRendering: true
---

_Esta página é um dump da antiga página de Changelog da wiki do Flutter até que
as [notas de release do Flutter](./) foram publicadas em flutter.dev._

## Mudanças até e incluindo 1.0.0

* Atualizações do Skia e engine para corrigir o seguinte:
  * [Problema de distorção de imagem do video_player após a última atualização do flutter 0.11.3](https://github.com/flutter/flutter/issues/24402)
  * [Barra verde piscando sobre o preview da câmera](https://github.com/flutter/flutter/issues/24289)
  * [Problemas de renderização de imagem em dispositivos Adreno 3xx após atualização de 0.9.4 para 0.10.2](https://github.com/flutter/flutter/issues/24517)
* Atualizações do engine para corrigir
  * [Prepend [NSLocale currentLocale] para o primeiro locale no iOS para garantir que countryCode existe. Permitir locales somente de idioma.](https://github.com/flutter/engine/issues/6995)
  * [Mudanças para desbloquear o roll do Fuchsia](https://github.com/flutter/engine/issues/6949)
* Várias correções nas ferramentas para documentação, documentação e documentação que acompanha os templates.

## Mudanças desde v0.10.2
* [flutter/engine#6883](https://github.com/flutter/engine/pull/6883) - FlutterViewController não carregará mais a splash screen do seu app por padrão. A implementação disso foi movida para um novo método `loadDefaultSplashScreenView`.
* [#23755](https://github.com/flutter/flutter/pull/23755) Removida dependência direta de flutter_test em `package:test`. Flutter agora requer test versão 1.5.1 e mockito versão 4.0.0.

  ### Breaking change:
  Isso requer adicionar uma dependência explícita ao seu pubspec.yaml:
  ```yaml
  dev_dependencies:
    test: ^1.5.1
  ```
* [#24024](https://github.com/flutter/flutter/pull/24024) e [flutter/engine#6760](https://github.com/flutter/engine/pull/6760) Atualizado harfbuzz para 2.1.0, melhorias significativas no layout de texto e suporte a zero-width-joiner (zwj) para melhores emojis no iOS.
* [#23417](https://github.com/flutter/flutter/pull/23417) fornece `null` quando o locale está indisponível ou inválido ao invés de `_`.
* [#23583](https://github.com/flutter/flutter/pull/23583) Melhorado algoritmo de localização com scriptCodes e suporte completo à lista de locales preferidos, breaking changes nos callbacks quando locales são alterados (passa lista ao invés de locale único).

### v0.11.0
* [#23320](https://github.com/flutter/flutter/pull/23320) Adiciona suporte a gestos de deslizar para trás nas transições entre páginas das barras de navegação Cupertino.
* [#23320](https://github.com/flutter/flutter/pull/23322) Adiciona suporte para transições Hero através de múltiplos Navigators.

## Mudanças em v0.10.2 (desde v0.9.4) - beta 10

### v0.10.2
* [#23194](https://github.com/flutter/flutter/pull/23194) Adiciona CupertinoTextField, um campo de entrada de texto estilizado para iOS.
* [#23221](https://github.com/flutter/flutter/pull/23221) Adiciona suporte RTL para transições entre páginas das barras de navegação Cupertino.

### v0.10.1
* [#22977](https://github.com/flutter/flutter/pull/22977) substitui a maioria de `Null` por `void`. Veja [o email propondo esta mudança](https://groups.google.com/forum/#!topic/flutter-dev/b7TKGqERNTM).
* [#22985](https://github.com/flutter/flutter/pull/22985) Implementa projeção ortográfica correta
* [#23104](https://github.com/flutter/flutter/pull/23104) Atualiza mensagem de wrapping
* [#22924](https://github.com/flutter/flutter/pull/22924) Suporte para desabilitar caret e seleção interativa do TextField
* [#22870](https://github.com/flutter/flutter/pull/22870) Usa nova sintaxe `mixin` para super-mixins
* [#22022](https://github.com/flutter/flutter/pull/22022) permite opção de linha de comando "--project-name" em flutter create
* [#23126](https://github.com/flutter/flutter/pull/23126) Despacha um evento Flutter.Navigation cada vez que ocorre navegação.
* [#23183](https://github.com/flutter/flutter/pull/23183) Corrige bug onde a regra de build do gradle reexecutava ao trocar de
* [#22394](https://github.com/flutter/flutter/pull/22394) Corrige simulação de mola fora do intervalo em ClampingScrollSimulation
* [#23174](https://github.com/flutter/flutter/pull/23174) habilita lint prefer_void_to_null
* [#23184](https://github.com/flutter/flutter/pull/23184) TextTheme.apply() não deve assumir campos TextStyle não nulos
* [#23168](https://github.com/flutter/flutter/pull/23168) Adicionadas traduções em Mongol (mn)
* [#23167](https://github.com/flutter/flutter/pull/23167) Corrige validação de formfield desabilitado
* [#23015](https://github.com/flutter/flutter/pull/23015) Finaliza edição ao pressionar a tecla enter em um TextField de linha única
* [#23021](https://github.com/flutter/flutter/pull/23021) Facilita o uso de CocoaPods para Add2App no iOS
* [#22825](https://github.com/flutter/flutter/pull/22825) corrige matemática de Curves.bounceInOut
* [#22977](https://github.com/flutter/flutter/pull/22977) Prefere void a null
* [#22822](https://github.com/flutter/flutter/pull/22822) Adiciona callback para Long Press Up
* [#18770](https://github.com/flutter/flutter/pull/18770) Adiciona `disabledHint` ao DropdownButton
* [#21657](https://github.com/flutter/flutter/pull/21657) Faz AndroidView aceitar factories de gesture recognizer.
* [#22449](https://github.com/flutter/flutter/pull/22449) Adiciona suporte para sombras de texto
* [flutter/engine#6644](https://github.com/flutter/engine/pull/6644) Adiciona BoxHeightStyle e BoxWidthStyle como argumentos para Paragraph.getBoxesForRange() para obter vários estilos de caixas envolventes.
* Atualização do Skia que muda a implementação de baixo nível de blurs e anti aliasing, o que pode quebrar golden tests.

### v0.9.7
* [flutter/engine#6393](https://github.com/flutter/engine/pull/6393) adiciona anotações de nullability ao Android MethodChannel/MethodCall.

### v0.9.6
* [#21251](https://github.com/flutter/flutter/pull/21251) adiciona CupertinoDatePicker, um controle picker estilo iOS que suporta modo de data e modo de data + hora.

## Mudanças em v0.9.4 (desde v0.8.2) - beta 9

### v0.9.4

* [#21715](https://github.com/flutter/flutter/pull/21715), A transição padrão do MaterialPageRoute agora é definida pelo Theme. Adicionado suporte (opcional) para transições de página estilo Android P. O suporte do MaterialPageRoute para "hospedar" outra rota para reutilizar seu método buildTransitions() foi removido porque PageTransitionsBuilders, incluindo CupertinoPageTransitionBuilder, são objetos independentes.

### v0.9.3

* [#22108](https://github.com/flutter/flutter/pull/22108) alterou ligeiramente a saída de `flutter doctor`, o que pode afetar scripts automatizados que dependiam da saída exata.

### v0.9.2

* [#21540](https://github.com/flutter/flutter/pull/21540) adicionou um método `transform()` ao [`Animatable`](https://api.flutter.dev/flutter/animation/Animatable-class.html). Ele é implementado por `Tween` (a principal subclasse de `Animatable`), mas classes que fazem subclasse de `Animatable` diretamente precisarão implementá-lo. Tipicamente o método `evaluate()` existente pode ser alterado para implementar `transform()` ao invés, usando o valor dado pelo argumento para `transform()` ao invés do valor atual da animação fornecido para `evaluate()`. `evaluate()` agora tem uma implementação padrão que delega para `transform()`.

## Mudanças em v0.8.2 (desde v0.7.3) - beta 8

### v0.7.4
* [#20322](https://github.com/flutter/flutter/pull/20322) executa transições parallax entre `CupertinoNavigationBar`s e `CupertinoSliverNavigationBar`s ao navegar entre páginas.

## Mudanças em v0.7.3 (desde v0.6.0) - beta 7

### v0.7.3
* [#20966](https://github.com/flutter/flutter/pull/20966) adiciona `CupertinoTimerPicker`.

### v0.7.2
* [#20929](https://github.com/flutter/flutter/pull/20929) corrige bug onde `CupertinoPageScaffold` não estava ajustando seu conteúdo quando o teclado é exibido.

### v0.7.1
* [#19637](https://github.com/flutter/flutter/pull/19637) `CupertinoNavigationBar` e `CupertinoSliverNavigationBar` agora preenchem automaticamente seu título e labels do botão voltar baseado em seu `CupertinoPageRoute.title`.

## Mudanças em v0.6.0 (desde v0.5.1) - beta 6

### v0.6.0
* Dart SDK atualizado para uma build Dart 2 (2.1.0-dev.0.0). Autores de packages e plugins devem garantir que seus arquivos `pubspec.yaml` incluam uma restrição de Dart SDK com limite superior de `<3.0.0`. Veja o [post Getting ready for Dart 2](https://blog.dart.dev/getting-ready-for-dart-2-and-making-your-packages-look-great-on-the-pub-site-118464d7f59d) para detalhes.
* [#19025](https://github.com/flutter/flutter/pull/19025) renomeou `CupertinoRefreshControl` para `CupertinoSliverRefreshControl` para consistência.
* [#19317](https://github.com/flutter/flutter/pull/19317) Adiciona cursorWidth e cursorRadius ao cursor do TextField (Material).
* [#20116](https://github.com/flutter/flutter/pull/20116) reduziu tamanhos de binários de release em ~2MB
* [#20267](https://github.com/flutter/flutter/pull/20267) adiciona `CupertinoSegmentedControl'.
* [#19232](https://github.com/flutter/flutter/pull/19232) adiciona `CupertinoActionSheet` para sheets pop-up inferiores estilo iOS.
* [#20101](https://github.com/flutter/flutter/pull/20101) melhora a fidelidade visual do `CupertinoScrollbar` durante overscrolls.
* [#19789](https://github.com/flutter/flutter/pull/19789) adiciona suporte para scrolling infinito e scrolling em loop para `CupertinoPicker`.
* [#18381](https://github.com/flutter/flutter/pull/18381) melhora a fidelidade visual do `CupertinoAlertDialog`.

### v0.5.8
* [#19284](https://github.com/flutter/flutter/pull/19284) adiciona suporte de `CupertinoPicker` multi-coluna para projeção cilíndrica fora do eixo.

### v0.5.7
* [#18469](https://github.com/flutter/flutter/pull/18469) adicionou um `CupertinoApp` para criar apps estilizados para iOS.

### v0.5.6
* [#18614](https://github.com/flutter/flutter/pull/18614) adicionou `isInstanceOf` como uma função exportada do Flutter, porque package:matcher deprecou sua implementação de `isInstanceOf`.
* [flutter/engine#5517](https://github.com/flutter/engine/pull/5517) habilitou a flag Dart `--sync-async`.

### v0.5.5

* [#18488](https://github.com/flutter/flutter/pull/18488) tornou o argumento `--debug-port` para `flutter trace` obrigatório, porque o comportamento anterior era não confiável e causava testes instáveis.

### v0.5.2

* [#18096](https://github.com/flutter/flutter/pull/18096) alterou a renderização do contador de caracteres em campos de texto para corresponder mais de perto às especificações de Material design.

## Mudanças em v0.5.1 (desde v0.3.2) - beta 5

### v0.5.0

* [#17661](https://github.com/flutter/flutter/pull/17661) alterou o layout e tamanho do `ListTile` para melhor conformidade com as especificações mais recentes de Material design.

* [#17620](https://github.com/flutter/flutter/pull/17620) reduz ligeiramente as dimensões padrão de `Checkbox`, `Radio` e `Switch` para melhor conformidade com as especificações mais recentes de Material design.

* [#17637](https://github.com/flutter/flutter/pull/17637) atualiza `Checkbox`, `Radio` e `Switch` para usar o `toggleableActiveColor` do `ThemeData`. Se você está usando um tema claro e não está especificando um `accentColor` em seu `ThemeData`, esses controles agora usarão um tom de maior contraste da paleta primária.

* [#17586](https://github.com/flutter/flutter/pull/17586) adicionou uma nova propriedade `background` ao `TextStyle`. Subclasses devem garantir que esta propriedade seja tratada em construtores e `copyWith`.

## Mudanças em v0.4.4 (desde v0.3.2) - beta 4

### v0.4.0
* [#17021](https://github.com/flutter/flutter/pull/17021) adicionou scrolling a11y implícito para iOS. Para isso, viewports definem uma extensão de cache antes da borda inicial assim como após a borda final e slivers devem fornecer informações de semântica se eles caem na extensão do cache.

  ### Breaking change
  Com esta mudança, filhos de um viewport que atualmente não estão visíveis no viewport agora são considerados off-stage. Para encontrá-los em um teste, especifique `skipOffstage: false` no Finder.

### v0.3.6

* [#17094](https://github.com/flutter/flutter/pull/17094) introduziu a habilidade de fazer testes de golden image em widget tests. Dentro de um widget test, você agora pode usar o seguinte matcher para garantir que a imagem rasterizada do seu widget corresponda a um arquivo golden (ex: `foo.png`):

  ```dart
  await expectLater(find.byType(MyWidget), matchesGoldenFile('foo.png'));
  ```

  ### Breaking change

  Uma das consequências desta mudança é que todos os testes executados através de `flutter test` agora dependem explicitamente de `package:flutter_test`. Usuários de `flutter test` precisarão atualizar seu arquivo `pubspec.yaml` para incluir o seguinte se ele ainda não existir:

  ```yaml
  dev_dependencies:
    flutter_test:
      sdk: flutter
  ```

  Se seu `pubspec.yaml` não contém a dependência requisitada, e você executar `flutter test`, você verá erros da seguinte forma:

  ```console
  compiler message: Error: Could not resolve the package 'flutter_test' in 'package:flutter_test/flutter_test.dart'.
  ```

### v0.3.3

* [flutter/engine#5060](https://github.com/flutter/engine/pull/5060) introduziu a habilidade de codificar um `dart:ui Image` em PNG via `Image.toByteData()`. Chamadores que desejam obter bytes codificados podem passar o argumento `format`, assim:

  ```dart
  image.toByteData(format: ui.ImageByteFormat.png);
  ```

## Mudanças em v0.3.2 (desde v0.3.1) - beta 3

## Mudanças em v0.3.1 (desde v0.2.8) - beta 2 update

Estamos cientes de um problema potencial com validação de certificado na implementação de `HttpClient`.
Para acompanhar nossa investigação, veja [Dart issue 32936](https://github.com/dart-lang/sdk/issues/32936).

### v0.3.1

* [flutter/engine#4932](https://github.com/flutter/engine/pull/4932) introduziu uma nova API de embedding do shell com numerosas novas funcionalidades. Em particular, um único processo agora pode hospedar múltiplos shells do Flutter.

* [flutter/engine#4762](https://github.com/flutter/engine/pull/4762) e [flutter/engine#5008](https://github.com/flutter/engine/pull/5008) introduziram `Image.toByteData()`, que é usado para obter os bytes RGBA brutos de uma instância `Image` em `dart:ui`.

* [#16721](https://github.com/flutter/flutter/pull/16721) o início do movimento de scroll no iOS foi ajustado para evitar um salto quando o scroll começa a se mover e para espelhar mais de perto o comportamento nativo.

### v0.2.11

* [#16039](https://github.com/flutter/flutter/pull/16039) e [#16447](https://github.com/flutter/flutter/pull/16447) revisaram substancialmente a implementação de `Chip`, adicionaram novos tipos de chip: `InputChip`, `ChoiceChip`, `FilterChip`, `ActionChip`, e atualizaram a aparência dos chips.

### v0.2.9

* [#16187](https://github.com/flutter/flutter/pull/16187) atualizou o shape e elevation do widget `Card`.

### Mudanças no Dart desde Flutter v0.2.8

* `dart:async`: Removido o parâmetro deprecado `defaultValue` em `Stream.firstWhere` e `Stream.lastWhere`.
* `dart:core`: Adicionado método estático `tryParse` a `int`, `double`, `num`, `BigInt`, `Uri` e `DateTime`, e deprecado o parâmetro `onError` em `int.parse`, `double.parse` e `num.parse`.
* A palavra-chave `new` agora pode sempre ser omitida. A palavra-chave `const` é necessária para criar uma expressão constante, embora dentro da expressão, outras palavras-chave `const` também possam ser omitidas.

## Mudanças em v0.2.8 (desde v0.2.3) - beta 2

### v0.2.8

* [#16040](https://github.com/flutter/flutter/pull/16040) adiciona uma API para permitir que a tab atual do `CupertinoTabScaffold` seja alterada programaticamente via o `currentIndex` de seu `CupertinoTabBar`.

### v0.2.5

* [#15416](https://github.com/flutter/flutter/pull/15416) removeu `package:http` do Flutter e substituiu todos os usos pelo `HttpClient` de `dart:io`. Se você usa `package:http` você deve adicioná-lo como uma dependência em seu `pubspec.yaml` para continuar usando.

  `createHttpClient()` também foi removido após ser marcado como deprecado. Para alterar como o framework cria clientes http, você pode usar [HttpOverrides](https://api.flutter.dev/flutter/dart-io/HttpOverrides-class.html) de `dart:io` para fornecer seu próprio callback `createHttpClient()` globalmente ou por zona.

  Mais detalhes estão disponíveis [no anúncio](https://groups.google.com/forum/#!topic/flutter-dev/AnqDqgQ6vus).

* [#15871](https://github.com/flutter/flutter/pull/15871) alterou a configuração padrão do `AndroidManifest.xml` criado por `flutter create`. "screenLayout" e "density" agora estão incluídos por padrão no atributo configChanges, prevenindo que apps Flutter reiniciem quando estes mudam.

* [#15324](https://github.com/flutter/flutter/pull/15324) adiciona um novo widget CupertinoRefreshControl estilizado após o padrão de pull-to-refresh do iOS. Demo disponível no Flutter Gallery.

### v0.2.4

* [#15565](https://github.com/flutter/flutter/pull/15565) ativou o modo Dart 2 por padrão. Para executar em modo Dart 1, você ainda pode usar `--no-preview-dart-2`.

  Mais detalhes estão disponíveis [no anúncio](https://groups.google.com/d/msg/flutter-dev/H8dDhWg_c8I/_Ql78q_6AgAJ).

* [#15537](https://github.com/flutter/flutter/pull/15537) removeu SemanticsSortOrder. De agora em diante a ordenação de travessia é feita apenas entre nós irmãos.

  Mais detalhes disponíveis [no anúncio](https://groups.google.com/forum/#!topic/flutter-dev/iCoLnW31heE).

* [#15484](https://github.com/flutter/flutter/pull/15484) alterou o significado do parâmetro de construtor `initialValue` de `TextFormField`.

  O parâmetro initialValue de TextFormField não mais inicializa incondicionalmente a propriedade text de seu TextEditingController. Se você criar um TextFormField e fornecer um controller, o initialValue deve ser null, que agora é o padrão. Se você está fornecendo um controller você pode especificar seu valor de texto inicial com a propriedade text do TextEditingController.

  > #### Antes
  >     new TextFormField(
  >       initialValue: 'Hello World',
  >       controller: _myTextEditingController,
  >     );
  >
  > #### Depois
  >     new TextFormField(
  >       controller: _myTextEditingController ..text = 'Hello World',
  >     )
  >     // Ou mais tipicamente:
  >     _myTextEditingController = new TextEditingController(
  >       text: 'Hello World',
  >     );
  >     new TextFormField(
  >       controller: _myTextEditingController,
  >     );

* [#15303](https://github.com/flutter/flutter/pull/15303) atualizou a função `showDialog` para receber um builder e deprecou o parâmetro `widget`.

  > #### Antes
  >     showDialog(context: context, child: new Text('hello'))
  >
  > #### Depois
  >     showDialog(context: context, builder: (BuildContext context) => new Text('hello'))

* [#15265](https://github.com/flutter/flutter/pull/15265) atualizou `ThemeData` para usar a cor primária de um `MaterialColor` ao invés de usar incondicionalmente o tom 500 para temas claros. Os valores de cor permanecem inalterados.

  > #### Antes
  >     expect(widget.color, Colors.blue.shade500) // primary color
  >
  > #### Depois
  >     expect(widget.color, Colors.blue) // primary color

* [#15548](https://github.com/flutter/flutter/pull/15548) adiciona flags de debug `debugDisableClipLayers`, `debugDisablePhysicalShapeLayers` e `debugDisableOpacityLayers` para ajudar com diagnóstico de performance da velocidade de rasterização.

## Mudanças em v0.2.3 (desde v0.1.5) - beta 1 update

### v0.2.0

* [flutter/engine#4742](https://github.com/flutter/engine/pull/4742) atualizou assets para serem lidos diretamente do APK no Android. Como resultado, barras iniciais não são mais suportadas em caminhos de asset de imagem:

  > #### Antes
  >     new Image.asset('/foo/bar.png')
  >
  > #### Depois:
  >     new Image.asset('foo/bar.png')

### v0.1.9

* [#14901](https://github.com/flutter/flutter/pull/14901) Uma atualização visual do [Slider](https://api.flutter.dev/flutter/material/Slider-class.html) alterou as cores, opacidades e o shape e comportamento do indicador de valor. Também removeu a flag "`thumbOpenAtMin`" da classe Slider, que não é mais necessária, e pode ser emulada pelo suporte a shape customizado de thumb.

## Mudanças em v0.1.5 (desde v0.1.4) - beta 1.1

### v0.1.5

* [#14714](https://github.com/flutter/flutter/pull/14714) corrigiu o script groovy para o Flutter Gallery, assim corrigindo [#14912](https://github.com/flutter/flutter/issues/14912).

## Mudanças em v0.1.4 (desde v0.0.20) - beta 1

### v0.1.3

* [#14702](https://github.com/flutter/flutter/pull/14702) removeu o getter `engineDartVersion` da classe `Version` da ferramenta flutter.

### v0.1.1

* [flutter/engine#4607](https://github.com/flutter/engine/pull/4607) e [#14601](https://github.com/flutter/flutter/pull/14601) removeram construtores padrão das seguintes classes `dart:ui`:

  * `Codec`
  * `FrameInfo`
  * `Gradient`
  * `Image`
  * `Paragraph`
  * `Picture`
  * `Scene`
  * `SemanticsUpdate`
  * `Shader`

  Os construtores padrão foram removidos para prevenir a criação de instâncias não inicializadas dessas classes (e em certos casos para prevenir a extensão dessas classes). Essas classes devem ser instanciadas apenas pelo engine Flutter ou através de construtores nomeados (se fornecidos).

### v0.0.24

* [#14410](https://github.com/flutter/flutter/pull/14410) continha uma mudança de API breaking para `ButtonTheme`:

  * Os construtores `ButtonTheme()` e `ButtonTheme.bar()` não são mais construtíveis com `const`
  * `ButtonTheme.textTheme` agora é `ButtonTheme.data.textTheme`
  * `ButtonTheme.minWidth` agora é `ButtonTheme.data.minWidth`
  * `ButtonTheme.height` agora é `ButtonTheme.data.height`
  * `ButtonTheme.padding` agora é `ButtonTheme.data.padding`

* [#14410](https://github.com/flutter/flutter/pull/14410) alterou a hierarquia de `FlatButton` e `RaisedButton` - ambos agora herdam de `RawMaterialButton` ao invés de `MaterialButton`.

* [#14410](https://github.com/flutter/flutter/pull/14410) alterou `RaisedButton` para não mais projetar uma sombra quando desabilitado.

### v0.0.23

* [#14343](https://github.com/flutter/flutter/pull/14343) revisou como copiar, recortar e colar funciona para EditableText: A classe abstrata TextSelectionControls tem novos métodos canCopy, canCut, etc. para determinar se essas ações estão disponíveis. A interface TextSelectionDelegate agora requer um método adicional bringIntoView(TextPosition position) para rolar uma TextPosition para a parte visível de um TextField. Além disso, essa interface não é mais implementada por TextSelectionOverlay. Em seu lugar, EditableTextState deve ser usado, que implementa essa interface. Veja também: [flutter-dev/IHPndyUDy0M](https://groups.google.com/forum/#!topic/flutter-dev/IHPndyUDy0M)

#### APIs Sliver

* [#14449](https://github.com/flutter/flutter/pull/14449) substitui o método `SliverGridLayout.estimateMaxScrollOffset` pelo método `SliverGridLayout.computeMaxScrollOffset`. Este novo método deve reportar um valor preciso, não apenas uma estimativa. Isso foi necessário para corrigir um bug onde um `SliverGrid` finito não podia lidar com ser rolado para fora do topo da tela (porque não tínhamos como determinar quanto conteúdo ele tinha).

  Por razões similares, a interface `RenderSliverBoxChildManager` tem um novo getter, `childCount`, que deve retornar um valor não nulo se `createChild` pode retornar null. Na prática, é incomum implementar esta interface, então isto não deve ter efeito. É mais comum implementar o equivalente da camada de widgets, `SliverChildDelegate`. Esta interface já tinha um getter `estimatedChildCount`. O getter continua a existir, embora sua semântica tenha sido ajustada um pouco para requerer que o valor retornado seja preciso se o método `build` no delegate alguma vez retornar null.

### v0.0.21

* [#13734](https://github.com/flutter/flutter/pull/13734), [#14055](https://github.com/flutter/flutter/pull/14055) e [#14177](https://github.com/flutter/flutter/pull/14177) revisaram substancialmente os widgets InputDecorator et al. O layout das partes do input decorator mudou um pouco, o que significa que o layout interno dos campos de texto também mudou. Testes que dependem da geometria interna dos campos de texto precisarão ser atualizados.

  Além disso, `hideDivider: true` deve ser substituído pelo novo `border: InputBorder.none`. Isto faz parte de nosso esforço para facilitar a customização de como inputs são renderizados; você agora também pode fornecer uma subclasse customizada de InputBorder se você tem desejos particularmente novos para sua decoração de input.

* [#4528](https://github.com/flutter/engine/pull/4528) e [#14011](https://github.com/flutter/flutter/pull/14011) deprecaram o suporte para big integers nos codecs de mensagem/método de canal de plataforma padrão, para serem tornados indisponíveis após um período de graça de quatro semanas. Esta mudança é uma consequência da transição para Dart
2.0 onde o tipo `int` não é mais de tamanho ilimitado.

* [#4487](https://github.com/flutter/engine/pull/4487) substitui todos os usos do conceito de callback `RequestPermissionResult` em `io.flutter.plugin.common.PluginRegistry` com `RequestPermissionsResult`, adicionando um `s` faltante para alinhar com o conceito correspondente do Android SDK.

  A API antiga foi deprecada e será tornada indisponível em uma release posterior. Haverá um período de graça de pelo menos quatro semanas entre a release que introduz a depreciação e a release que torna a API antiga indisponível.
