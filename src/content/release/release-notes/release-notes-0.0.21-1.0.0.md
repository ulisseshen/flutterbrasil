---
ia-translate: true
title: Flutter Changelog 0.0.21 - 1.0.0
short-title: Flutter Changelog até 1.0.0
description: Página wiki de Changelog arquivada, contendo informações de lançamento entre Flutter 0.0.21 e 1.0.0.
---

_Esta página é um despejo da antiga página Changelog da wiki do Flutter até
[notas de lançamento do Flutter](./) serem publicadas em flutter.dev._

## Mudanças até e incluindo 1.0.0

* Skia e engine rolls para resolver o seguinte:
  * [problema de distorção de imagem video_player após a última atualização do flutter 0.11.3](https://github.com/flutter/flutter/issues/24402)
  * [Barra verde e piscando sobre a visualização da câmera](https://github.com/flutter/flutter/issues/24289)
  * [Problemas de renderização de imagem em dispositivos Adreno 3xx após a atualização de 0.9.4 para 0.10.2](https://github.com/flutter/flutter/issues/24517)
* Engine rolls para corrigir
  * [Acrescentar [NSLocale currentLocale] para o primeiro locale no iOS para garantir que countryCode exista. Permitir locales apenas com idioma.](https://github.com/flutter/engine/issues/6995)
  * [Mudanças para desbloquear o roll do Fuchsia](https://github.com/flutter/engine/issues/6949)
* Várias correções nas ferramentas para documentação, documentação e documentação que acompanham os templates.

## Mudanças desde a v0.10.2
* [flutter/engine#6883](https://github.com/flutter/engine/pull/6883) - FlutterViewController não carregará mais a tela inicial do seu aplicativo por padrão. A implementação disso foi movida para um novo método `loadDefaultSplashScreenView`.
* [#23755](https://github.com/flutter/flutter/pull/23755) Removida a dependência direta de flutter_test em `package:test`. O Flutter agora requer a versão 1.5.1 do test e a versão 4.0.0 do mockito.

  ### Mudança Breaking:
  Isso requer a adição de uma dependência explícita ao seu pubspec.yaml:
  ```yaml
  dev_dependencies:
    test: ^1.5.1
  ```
* [#24024](https://github.com/flutter/flutter/pull/24024) e [flutter/engine#6760](https://github.com/flutter/engine/pull/6760) Harfbuzz atualizado para 2.1.0, layout de texto significativamente aprimorado e suporte a zero-width-joiner (zwj) para melhores emojis no iOS.
* [#23417](https://github.com/flutter/flutter/pull/23417) fornecer `null` quando o locale estiver indisponível ou inválido em vez de `_`.
* [#23583](https://github.com/flutter/flutter/pull/23583) Algoritmo de localização aprimorado com scriptCodes e suporte total à lista de locales preferidos, mudanças importantes nos callbacks quando os locales são alterados (passar lista em vez de um único locale).

### v0.11.0
* [#23320](https://github.com/flutter/flutter/pull/23320) Adiciona suporte de volta ao gesto de deslizar para as transições entre páginas das barras de navegação Cupertino.
* [#23320](https://github.com/flutter/flutter/pull/23322) Adiciona suporte para transições Hero através de vários Navigators.

## Mudanças na v0.10.2 (desde a v0.9.4) - beta 10

### v0.10.2
* [#23194](https://github.com/flutter/flutter/pull/23194) Adiciona CupertinoTextField, um campo de entrada de texto com estilo iOS.
* [#23221](https://github.com/flutter/flutter/pull/23221) Adiciona suporte RTL para as transições entre páginas das barras de navegação Cupertino.

### v0.10.1
* [#22977](https://github.com/flutter/flutter/pull/22977) substitui a maior parte de `Null` por `void`. Consulte [o e-mail propondo esta alteração](https://groups.google.com/forum/#!topic/flutter-dev/b7TKGqERNTM).
* [#22985](https://github.com/flutter/flutter/pull/22985) Implementar projeção ortográfica correta
* [#23104](https://github.com/flutter/flutter/pull/23104) Atualizar mensagem de encapsulamento
* [#22924](https://github.com/flutter/flutter/pull/22924) Suporte para desabilitar o cursor e a seleção interativos do TextField
* [#22870](https://github.com/flutter/flutter/pull/22870) Usar nova sintaxe `mixin` para super-mixins
* [#22022](https://github.com/flutter/flutter/pull/22022) permitir a opção de linha de comando "--project-name" em flutter create
* [#23126](https://github.com/flutter/flutter/pull/23126) Despachar um evento Flutter.Navigation cada vez que a navegação ocorre.
* [#23183](https://github.com/flutter/flutter/pull/23183) Corrigir bug onde a regra de construção do gradle seria executada novamente ao alternar de
* [#22394](https://github.com/flutter/flutter/pull/22394) Corrigir simulação de mola fora do intervalo em ClampingScrollSimulation
* [#23174](https://github.com/flutter/flutter/pull/23174) habilitar lint prefer_void_to_null
* [#23184](https://github.com/flutter/flutter/pull/23184) TextTheme.apply() não deve assumir campos TextStyle não nulos
* [#23168](https://github.com/flutter/flutter/pull/23168) Adicionadas traduções para o mongol (mn)
* [#23167](https://github.com/flutter/flutter/pull/23167) Corrigir validação de formfield desabilitada
* [#23015](https://github.com/flutter/flutter/pull/23015) Finalizar a edição ao pressionar a tecla enter em um TextField de linha única
* [#23021](https://github.com/flutter/flutter/pull/23021) Tornar mais fácil usar o CocoaPods para Add2App para iOS
* [#22825](https://github.com/flutter/flutter/pull/22825) corrigir a matemática de Curves.bounceInOut
* [#22977](https://github.com/flutter/flutter/pull/22977) Preferir void a null
* [#22822](https://github.com/flutter/flutter/pull/22822) Adiciona callback para Long Press Up
* [#18770](https://github.com/flutter/flutter/pull/18770) Adicionar `disabledHint` ao DropdownButton
* [#21657](https://github.com/flutter/flutter/pull/21657) Fazer o AndroidView receber fábricas de reconhecimento de gestos.
* [#22449](https://github.com/flutter/flutter/pull/22449) Adicionar suporte para sombras de texto
* [flutter/engine#6644](https://github.com/flutter/engine/pull/6644) Adicionar BoxHeightStyle e BoxWidthStyle como argumentos para Paragraph.getBoxesForRange() para obter vários estilos de caixas delimitadoras.
* Atualização do Skia que altera a implementação de baixo nível de desfoques e anti-aliasing, o que pode quebrar testes golden.

### v0.9.7
* [flutter/engine#6393](https://github.com/flutter/engine/pull/6393) adiciona anotações de nulidade ao Android MethodChannel/MethodCall.

### v0.9.6
* [#21251](https://github.com/flutter/flutter/pull/21251) adiciona CupertinoDatePicker, um controle de seleção de estilo iOS que oferece suporte a um modo de data e um modo de data + hora.

## Mudanças na v0.9.4 (desde a v0.8.2 ) - beta 9

### v0.9.4

* [#21715](https://github.com/flutter/flutter/pull/21715), A transição padrão do MaterialPageRoute agora é definida pelo Theme. Adicionado suporte (opcional) para transições de página no estilo Android P. O suporte do MaterialPageRoute para "hospedar" outra rota para reutilizar seu método buildTransitions() foi removido porque PageTransitionsBuilders, incluindo CupertinoPageTransitionBuilder, são objetos independentes.

### v0.9.3

* [#22108](https://github.com/flutter/flutter/pull/22108) mudou ligeiramente a saída de `flutter doctor`, o que pode afetar scripts automatizados que dependiam da saída exata.

### v0.9.2

* [#21540](https://github.com/flutter/flutter/pull/21540) adicionou um método `transform()` para [`Animatable`](https://api.flutter.dev/flutter/animation/Animatable-class.html). Ele é implementado por `Tween` (a subclasse principal de `Animatable`), mas as classes que subclasseiam `Animatable` diretamente precisarão implementá-lo. Normalmente, o método `evaluate()` existente pode ser alterado para implementar `transform()` em vez disso, usando o valor fornecido pelo argumento para `transform()` em vez do valor atual da animação fornecida para `evaluate()`. `evaluate()` agora tem uma implementação padrão que defere para `transform()`.

## Mudanças na v0.8.2 (desde a v0.7.3) - beta 8

### v0.7.4
* [#20322](https://github.com/flutter/flutter/pull/20322) executa transições de paralaxe entre `CupertinoNavigationBar`s e `CupertinoSliverNavigationBar`s ao navegar entre páginas.

## Mudanças na v0.7.3 (desde a v0.6.0) - beta 7

### v0.7.3
* [#20966](https://github.com/flutter/flutter/pull/20966) adiciona `CupertinoTimerPicker`.

### v0.7.2
* [#20929](https://github.com/flutter/flutter/pull/20929) corrige o bug em que `CupertinoPageScaffold` não estava inserindo seu conteúdo quando o teclado era exibido.

### v0.7.1
* [#19637](https://github.com/flutter/flutter/pull/19637) `CupertinoNavigationBar` e `CupertinoSliverNavigationBar` agora preenchem automaticamente seus rótulos de título e botão voltar com base em seu `CupertinoPageRoute.title`.

## Mudanças na v0.6.0 (desde a v0.5.1) - beta 6

### v0.6.0
* Dart SDK atualizado para um build do Dart 2 (2.1.0-dev.0.0). Autores de pacotes e plugins devem garantir que seus arquivos `pubspec.yaml` incluam uma restrição do Dart SDK com um limite superior de `<3.0.0`. Consulte a postagem [Preparando-se para o Dart 2](https://medium.com/dartlang/getting-ready-for-dart-2-and-making-your-packages-look-great-on-the-pub-site-118464d7f59d) para obter detalhes.
* [#19025](https://github.com/flutter/flutter/pull/19025) renomeou `CupertinoRefreshControl` para `CupertinoSliverRefreshControl` por consistência.
* [#19317](https://github.com/flutter/flutter/pull/19317) Adicionar cursorWidth e cursorRadius ao cursor TextField (Material).
* [#20116](https://github.com/flutter/flutter/pull/20116) reduziu os tamanhos dos binários de lançamento em ~2MB
* [#20267](https://github.com/flutter/flutter/pull/20267) adiciona `CupertinoSegmentedControl'.
* [#19232](https://github.com/flutter/flutter/pull/19232) adiciona `CupertinoActionSheet` para folhas pop-up inferiores no estilo iOS.
* [#20101](https://github.com/flutter/flutter/pull/20101) melhora a fidelidade visual de `CupertinoScrollbar` durante overscrolls.
* [#19789](https://github.com/flutter/flutter/pull/19789) adiciona suporte para rolagem infinita e rolagem em loop para `CupertinoPicker`.
* [#18381](https://github.com/flutter/flutter/pull/18381) melhora a fidelidade visual de `CupertinoAlertDialog`.

### v0.5.8
* [#19284](https://github.com/flutter/flutter/pull/19284) adiciona suporte a `CupertinoPicker` de várias colunas para projeção cilíndrica fora do eixo.

### v0.5.7
* [#18469](https://github.com/flutter/flutter/pull/18469) adicionou um `CupertinoApp` para criar aplicativos com estilo iOS.

### v0.5.6
* [#18614](https://github.com/flutter/flutter/pull/18614) adicionou `isInstanceOf` como uma função exportada do Flutter, porque o package:matcher descontinuou sua implementação de `isInstanceOf`.
* [flutter/engine#5517](https://github.com/flutter/engine/pull/5517) habilitou o sinalizador Dart `--sync-async`.

### v0.5.5

* [#18488](https://github.com/flutter/flutter/pull/18488) tornou o argumento `--debug-port` para `flutter trace` obrigatório, porque o comportamento anterior não era confiável e causava testes instáveis.

### v0.5.2

* [#18096](https://github.com/flutter/flutter/pull/18096) alterou a renderização do contador de caracteres em campos de texto para corresponder mais de perto às especificações de design do Material.

## Mudanças na v0.5.1 (desde a v0.3.2) - beta 5

### v0.5.0

* [#17661](https://github.com/flutter/flutter/pull/17661) alterou o layout e o tamanho de `ListTile` para melhor se adequar às mais recentes especificações de design do Material.

* [#17620](https://github.com/flutter/flutter/pull/17620) reduz ligeiramente as dimensões padrão de `Checkbox`, `Radio` e `Switch` para melhor se adequar às mais recentes especificações de design do Material.

* [#17637](https://github.com/flutter/flutter/pull/17637) atualiza `Checkbox`, `Radio` e `Switch` para usar o `ThemeData` `toggleableActiveColor`. Se você estiver usando um tema claro e não estiver especificando um `accentColor` em seu `ThemeData`, esses controles agora usarão um tom de maior contraste da amostra primária.

* [#17586](https://github.com/flutter/flutter/pull/17586) adicionou uma nova propriedade `background` para `TextStyle`. As subclasses devem garantir que essa propriedade seja tratada em construtores e `copyWith`.

## Mudanças na v0.4.4 (desde a v0.3.2) - beta 4

### v0.4.0
* [#17021](https://github.com/flutter/flutter/pull/17021) adicionou rolagem a11y implícita para iOS. Para isso, os viewports definem uma extensão de cache antes da borda inicial e depois da borda final, e espera-se que os slivers forneçam informações semânticas se caírem na extensão do cache.

  ### Mudança Breaking
  Com essa alteração, os filhos de um viewport que atualmente não estão visíveis no viewport agora são considerados fora do palco. Para encontrá-los em um teste, especifique `skipOffstage: false` no Finder.

### v0.3.6

* [#17094](https://github.com/flutter/flutter/pull/17094) introduziu a capacidade de fazer testes de imagem golden em testes de widget. Dentro de um teste de widget, você agora pode usar o seguinte matcher para garantir que a imagem rasterizada do seu widget corresponda a um arquivo golden (por exemplo, `foo.png`):

  ```dart
  await expectLater(find.byType(MyWidget), matchesGoldenFile('foo.png'));
  ```

  ### Mudança Breaking

  Uma das consequências dessa alteração é que todos os testes executados por meio de `flutter test` agora dependem explicitamente do `package:flutter_test`. Os usuários de `flutter test` precisarão atualizar seu arquivo `pubspec.yaml` para incluir o seguinte, caso ainda não exista:

  ```yaml
  dev_dependencies:
    flutter_test:
      sdk: flutter
  ```

  Se o seu `pubspec.yaml` não contiver a dependência necessária e você executar `flutter test`, você verá erros do seguinte formato:

  ```console
  compiler message: Error: Could not resolve the package 'flutter_test' in 'package:flutter_test/flutter_test.dart'.
  ```

### v0.3.3

* [flutter/engine#5060](https://github.com/flutter/engine/pull/5060) introduziu a capacidade de codificar um `dart:ui Image` em um PNG via `Image.toByteData()`. Os chamadores que desejam obter bytes codificados podem passar o argumento `format`, da seguinte maneira:

  ```dart
  image.toByteData(format: ui.ImageByteFormat.png);
  ```

## Mudanças na v0.3.2 (desde a v0.3.1) - beta 3

## Mudanças na v0.3.1 (desde a v0.2.8) - atualização beta 2

Estamos cientes de um problema potencial com a validação de certificados na implementação do `HttpClient`.
Para acompanhar nossa investigação, veja [Dart issue 32936](https://github.com/dart-lang/sdk/issues/32936).

### v0.3.1

* [flutter/engine#4932](https://github.com/flutter/engine/pull/4932) introduziu uma nova API de incorporação de shell com vários novos recursos. Em particular, um único processo agora pode hospedar vários shells Flutter.

* [flutter/engine#4762](https://github.com/flutter/engine/pull/4762) e [flutter/engine#5008](https://github.com/flutter/engine/pull/5008) introduziram `Image.toByteData()`, que é usada para obter os bytes RGBA brutos de uma instância de `Image` em `dart:ui`.

* [#16721](https://github.com/flutter/flutter/pull/16721) o movimento de rolagem começa no iOS foi ajustado para evitar um salto quando a rolagem começa a se mover pela primeira vez e para espelhar mais de perto o comportamento nativo.

### v0.2.11

* [#16039](https://github.com/flutter/flutter/pull/16039) e [#16447](https://github.com/flutter/flutter/pull/16447) revisaram substancialmente a implementação do `Chip`, adicionaram novos tipos de chip: `InputChip`, `ChoiceChip`, `FilterChip`, `ActionChip` e atualizaram a aparência dos chips.

### v0.2.9

* [#16187](https://github.com/flutter/flutter/pull/16187) atualizou o formato e a elevação do widget `Card`.

### Mudanças no Dart desde o Flutter v0.2.8

* `dart:async`: Removeu o parâmetro `defaultValue` obsoleto em `Stream.firstWhere` e `Stream.lastWhere`.
* `dart:core`: Adicionou o método estático `tryParse` para `int`, `double`, `num`, `BigInt`, `Uri` e `DateTime` e descontinuou o parâmetro `onError` em `int.parse`, `double.parse` e `num.parse`.
* A palavra-chave `new` agora pode ser sempre omitida. A palavra-chave `const` é necessária para criar uma expressão constante, embora dentro da expressão, mais palavras-chave `const` também possam ser omitidas.

## Mudanças na v0.2.8 (desde a v0.2.3) - beta 2

### v0.2.8

* [#16040](https://github.com/flutter/flutter/pull/16040) adiciona uma API para permitir que a aba atual do `CupertinoTabScaffold` seja alterada programaticamente por meio do `currentIndex` do `CupertinoTabBar`.

### v0.2.5

* [#15416](https://github.com/flutter/flutter/pull/15416) removeu o `package:http` do Flutter e substituiu todos os usos pelo `HttpClient` de `dart:io`. Se você usar `package:http`, você deve adicioná-lo como uma dependência em seu `pubspec.yaml` para continuar usando-o.

  `createHttpClient()` também foi removido depois de ser marcado como obsoleto. Para alterar como a estrutura cria clientes http, você pode usar [HttpOverrides](https://api.flutter.dev/flutter/dart-io/HttpOverrides-class.html) de `dart:io` para fornecer seu próprio callback `createHttpClient()` globalmente ou por zona.

  Mais detalhes estão disponíveis [no anúncio](https://groups.google.com/forum/#!topic/flutter-dev/AnqDqgQ6vus).

* [#15871](https://github.com/flutter/flutter/pull/15871) alterou a configuração padrão do `AndroidManifest.xml` criado por `flutter create`. "screenLayout" e "density" agora são incluídos por padrão no atributo configChanges, evitando que os aplicativos flutter reiniciem quando eles mudam.

* [#15324](https://github.com/flutter/flutter/pull/15324) adiciona um novo widget CupertinoRefreshControl estilizado após o padrão pull-to-refresh do iOS. Demonstração disponível na Galeria Flutter.

### v0.2.4

* [#15565](https://github.com/flutter/flutter/pull/15565) ativou o modo Dart 2 por padrão. Para executar no modo Dart 1, você ainda pode usar `--no-preview-dart-2`.

  Mais detalhes estão disponíveis [no anúncio](https://groups.google.com/d/msg/flutter-dev/H8dDhWg_c8I/_Ql78q_6AgAJ).

* [#15537](https://github.com/flutter/flutter/pull/15537) removeu SemanticsSortOrder. De agora em diante, a classificação de travessia é feita apenas entre nós irmãos.

  Mais detalhes disponíveis [no anúncio](https://groups.google.com/forum/#!topic/flutter-dev/iCoLnW31heE).

* [#15484](https://github.com/flutter/flutter/pull/15484) alterou o significado do parâmetro do construtor `initialValue` do `TextFormField`.

  O parâmetro initialValue do TextFormField não inicializa mais incondicionalmente a propriedade text de seu TextEditingController. Se você criar um TextFormField e fornecer um controlador, o initialValue deverá ser nulo, que agora é o padrão. Se você estiver fornecendo um controlador, poderá especificar seu valor de texto inicial com a propriedade text do TextEditingController.

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

* [#15303](https://github.com/flutter/flutter/pull/15303) atualizou a função `showDialog` para receber um builder e descontinuou o parâmetro `widget`.

  > #### Antes
  >     showDialog(context: context, child: new Text('hello'))
  >
  > #### Depois
  >     showDialog(context: context, builder: (BuildContext context) => new Text('hello'))

* [#15265](https://github.com/flutter/flutter/pull/15265) atualizou `ThemeData` para usar a cor primária de um `MaterialColor` em vez de usar incondicionalmente a tonalidade 500 para temas claros. Os valores de cor permanecem inalterados.

  > #### Antes
  >     expect(widget.color, Colors.blue.shade500) // cor primária
  >
  > #### Depois
  >     expect(widget.color, Colors.blue) // cor primária

* [#15548](https://github.com/flutter/flutter/pull/15548) adiciona flags de depuração `debugDisableClipLayers`, `debugDisablePhysicalShapeLayers` e `debugDisableOpacityLayers` para ajudar no diagnóstico de desempenho da velocidade de rasterização.

## Mudanças na v0.2.3 (desde a v0.1.5) - atualização beta 1

### v0.2.0

* [flutter/engine#4742](https://github.com/flutter/engine/pull/4742) atualizou os assets para serem lidos diretamente do APK no Android. Como resultado, barras iniciais não são mais suportadas em caminhos de assets de imagem:

  > #### Antes
  >     new Image.asset('/foo/bar.png')
  >
  > #### Depois:
  >     new Image.asset('foo/bar.png')

### v0.1.9

* [#14901](https://github.com/flutter/flutter/pull/14901) Uma atualização visual do [Slider](https://api.flutter.dev/flutter/material/Slider-class.html) alterou as cores, opacidades e o formato e comportamento do indicador de valor. Ele também removeu o flag "`thumbOpenAtMin`" da classe Slider, que não é mais necessária e pode ser emulada pelo suporte de formato de thumb personalizado.

## Mudanças na v0.1.5 (desde a v0.1.4) - beta 1.1

### v0.1.5

* [#14714](https://github.com/flutter/flutter/pull/14714) corrigiu o script groovy para a Galeria Flutter, corrigindo assim [#14912](https://github.com/flutter/flutter/issues/14912).

## Mudanças na v0.1.4 (desde a v0.0.20) - beta 1

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

  Os construtores padrão foram removidos para evitar a criação de instâncias não inicializadas dessas classes (e, em certos casos, para evitar a extensão dessas classes). Essas classes devem ser instanciadas apenas pelo mecanismo Flutter ou por meio de construtores nomeados (se fornecidos).

### v0.0.24

* [#14410](https://github.com/flutter/flutter/pull/14410) continha uma alteração de API breaking para `ButtonTheme`:

  * Os construtores `ButtonTheme()` e `ButtonTheme.bar()` não são mais construtíveis `const`
  * `ButtonTheme.textTheme` agora é `ButtonTheme.data.textTheme`
  * `ButtonTheme.minWidth` agora é `ButtonTheme.data.minWidth`
  * `ButtonTheme.height` agora é `ButtonTheme.data.height`
  * `ButtonTheme.padding` agora é `ButtonTheme.data.padding`

* [#14410](https://github.com/flutter/flutter/pull/14410) alterou a hierarquia de `FlatButton` e `RaisedButton` - ambos herdam de `RawMaterialButton` agora em vez de `MaterialButton`.

* [#14410](https://github.com/flutter/flutter/pull/14410) alterou `RaisedButton` para não projetar mais uma sombra quando desabilitado.

### v0.0.23

* [#14343](https://github.com/flutter/flutter/pull/14343) revisou como copiar, recortar e colar funciona para EditableText: A classe abstrata TextSelectionControls tem novos métodos canCopy, canCut, etc. para determinar se essas ações estão disponíveis. A interface TextSelectionDelegate agora requer um método adicional bringIntoView(TextPosition position) para rolar um TextPosition para a parte visível de um TextField. Além disso, essa interface não é mais implementada por TextSelectionOverlay. Em seu lugar, EditableTextState deve ser usado, que implementa essa interface. Veja também: [flutter-dev/IHPndyUDy0M](https://groups.google.com/forum/#!topic/flutter-dev/IHPndyUDy0M)

#### APIs Sliver

* [#14449](https://github.com/flutter/flutter/pull/14449) substitui o método `SliverGridLayout.estimateMaxScrollOffset` pelo método `SliverGridLayout.computeMaxScrollOffset`. Este novo método deve relatar um valor preciso, não apenas uma estimativa. Isso foi necessário para corrigir um bug onde um `SliverGrid` finito não conseguia lidar com a rolagem para fora da parte superior da tela (porque não tínhamos como determinar quanto conteúdo ele tinha).

  Por motivos semelhantes, a interface `RenderSliverBoxChildManager` tem um novo getter, `childCount`, que deve retornar um valor não nulo se `createChild` puder retornar nulo. Na prática, é incomum implementar esta interface, portanto, isso não deve ter efeito. É mais comum implementar o equivalente da camada de widgets, `SliverChildDelegate`. Esta interface já tinha um getter `estimatedChildCount`. O getter continua a existir, embora sua semântica tenha sido ajustada um pouco para exigir que o valor retornado seja preciso se o método `build` no delegate retornar nulo.

### v0.0.21

* [#13734](https://github.com/flutter/flutter/pull/13734), [#14055](https://github.com/flutter/flutter/pull/14055) e [#14177](https://github.com/flutter/flutter/pull/14177) revisaram substancialmente os widgets InputDecorator et al. O layout das partes do input decorator mudou um pouco, o que significa que o layout interno dos campos de texto também mudou. Os testes que dependem da geometria interna dos campos de texto precisarão ser atualizados.

  Além disso, `hideDivider: true` deve ser substituído pelo novo `border: InputBorder.none`. Isso faz parte do nosso esforço para facilitar a personalização de como as entradas são renderizadas; agora você também pode fornecer uma subclasse InputBorder personalizada se tiver desejos particularmente inovadores para sua decoração de entrada.

* [#4528](https://github.com/flutter/engine/pull/4528) e [#14011](https://github.com/flutter/flutter/pull/14011) descontinuaram o suporte para inteiros grandes nos codecs padrão de mensagem/método do canal da plataforma, para ser disponibilizado após um período de carência de quatro semanas. Essa alteração é uma consequência da transição para o Dart 2.0, onde o tipo `int` não é mais de tamanho ilimitado.

* [#4487](https://github.com/flutter/engine/pull/4487) substitui todos os usos do conceito de callback `RequestPermissionResult` em `io.flutter.plugin.common.PluginRegistry` por `RequestPermissionsResult`, adicionando um `s` ausente para alinhar com o conceito correspondente do Android SDK.

  A API antiga foi descontinuada e ficará indisponível em uma versão posterior. Haverá um período de carência de pelo menos quatro semanas entre o lançamento que introduz a descontinuação e o lançamento que torna a API antiga indisponível.
