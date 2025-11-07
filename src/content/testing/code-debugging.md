---
ia-translate: true
title: Depurar apps Flutter pelo código
description: >
  Como habilitar várias ferramentas de depuração a partir
  do seu código e na linha de comando.
---

<?code-excerpt path-base="testing/code_debugging"?>

Este guia descreve quais recursos de depuração você pode habilitar no seu código.
Para uma lista completa de ferramentas de depuração e profiling, confira a
página [Debugging][].

:::note
Se você está procurando uma maneira de usar GDB para depurar remotamente o
engine Flutter executando dentro de um processo de app Android,
confira [`flutter_gdb`][].
:::

[`flutter_gdb`]: {{site.repo.flutter}}/blob/main/engine/src/flutter/sky/tools/flutter_gdb

## Adicionar logging à sua aplicação

:::note
Você pode visualizar logs na [Logging view][] do DevTools
ou no console do seu sistema. Esta seção
mostra como configurar suas instruções de logging.
:::

Você tem duas opções para logging na sua aplicação.

1. Imprimir para `stdout` e `stderr` usando instruções `print()`.
1. Importar `dart:io` e invocar métodos em
   `stderr` e `stdout`. Por exemplo:

    <?code-excerpt "lib/main.dart (stderr)"?>
    ```dart
    stderr.writeln('print me');
    ```

Se você gerar muita saída de uma vez, então o Android pode descartar algumas linhas de log.
Para evitar esse resultado,
use [`debugPrint()`][] da biblioteca `foundation` do Flutter.
Este wrapper em torno de `print` limita a saída para evitar que o kernel do Android
descarte a saída.

Você também pode registrar seu app usando a função [`log()`][] do `dart:developer`.
Isso permite que você inclua maior granularidade e mais informações
na saída de logging.

### Exemplo 1 {:.no_toc}

<?code-excerpt "lib/main.dart (log)"?>
```dart
import 'dart:developer' as developer;

void main() {
  developer.log('log me', name: 'my.app.category');

  developer.log('log me 1', name: 'my.other.category');
  developer.log('log me 2', name: 'my.other.category');
}
```

Você também pode passar dados do app para a chamada de log.
A convenção para isso é usar o parâmetro nomeado `error:`
na chamada `log()`, codificar em JSON o objeto
que você deseja enviar, e passar a string codificada para o
parâmetro error.

### Exemplo 2 {:.no_toc}

<?code-excerpt "lib/app_data.dart (pass-data)"?>
```dart
import 'dart:convert';
import 'dart:developer' as developer;

void main() {
  var myCustomObject = MyCustomObject();

  developer.log(
    'log me',
    name: 'my.app.category',
    error: jsonEncode(myCustomObject),
  );
}
```

A view de logging do DevTool interpreta o parâmetro error codificado em JSON
como um objeto de dados.
DevTool renderiza na view de detalhes para essa entrada de log.

## Definir breakpoints

Você pode definir breakpoints no [Debugger][] do DevTools ou
no depurador integrado do seu IDE.

Para definir breakpoints programáticos:

1. Importe o pacote `dart:developer` para o arquivo relevante.
1. Insira breakpoints programáticos usando a instrução `debugger()`.
   Esta instrução recebe um argumento opcional `when`.
   Este argumento booleano define uma quebra quando a condição fornecida é resolvida para true.

   O **Exemplo 3** ilustra isso.

### Exemplo 3 {:.no_toc}

<?code-excerpt "lib/debugger.dart"?>
```dart
import 'dart:developer';

void someFunction(double offset) {
  debugger(when: offset > 30);
  // ...
}
```

## Depurar camadas do app usando flags

Cada camada do framework Flutter fornece uma função para despejar seu
estado atual ou eventos para o console usando a propriedade `debugPrint`.

:::note
Todos os exemplos a seguir foram executados como apps nativos macOS em
um MacBook Pro M1. Eles serão diferentes de qualquer dump que sua
máquina de desenvolvimento imprimir.
:::

{% include docs/admonitions/tip-hashCode-tree.md %}

### Imprimir a árvore de widgets

Para despejar o estado da biblioteca Widgets,
chame a função [`debugDumpApp()`][].

1. Abra seu arquivo fonte.
1. Importe `package:flutter/rendering.dart`.
1. Chame a função [`debugDumpApp()`][] de dentro da função `runApp()`.
   Você precisa que seu app esteja no modo debug.
   Você não pode chamar essa função dentro de um método `build()`
   quando o app está sendo construído.
1. Se você não iniciou seu app, depure-o usando seu IDE.
1. Se você já iniciou seu app, salve seu arquivo fonte.
   Hot reload re-renderiza seu app.

#### Exemplo 4: Chamar `debugDumpApp()`

<?code-excerpt "lib/dump_app.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: AppHome(),
    ),
  );
}

class AppHome extends StatelessWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: TextButton(
          onPressed: () {
            debugDumpApp();
          },
          child: const Text('Dump Widget Tree'),
        ),
      ),
    );
  }
}
```

Esta função chama recursivamente o método `toStringDeep()` começando com
a raiz da árvore de widgets. Ela retorna uma árvore "achatada".

O **Exemplo 4** produz a seguinte árvore de widgets. Ela inclui:

* Todos os widgets projetados através de suas várias funções de build.
* Muitos widgets que não aparecem no código fonte do seu app.
  Os widgets do framework os inserem durante o build.

  A árvore a seguir, por exemplo, mostra [`_InkFeatures`][].
  Essa classe implementa parte do widget [`Material`][].
  Ela não aparece em lugar nenhum no código no **Exemplo 4**.

<details>
<summary><strong>Expandir para ver a árvore de widgets para o Exemplo 4</strong></summary>

{% render docs/testing/trees/widget-tree.md -%}

</details>

Quando o botão muda de pressionado para liberado,
isso invoca a função `debugDumpApp()`.
Também coincide com o objeto [`TextButton`][] chamando [`setState()`][]
e assim marcando-o como dirty.
Isso explica por que Flutter marca um objeto específico como "dirty".
Ao revisar a árvore de widgets, procure uma linha que se assemelhe à seguinte:

```plaintext
└TextButton(dirty, dependencies: [MediaQuery, _InheritedTheme, _LocalizationsScope-[GlobalKey#5880d]], state: _ButtonStyleState#ab76e)
```

Se você escrever seus próprios widgets, sobrescreva o
método [`debugFillProperties()`][widget-fill] para adicionar informações.
Adicione objetos [DiagnosticsProperty][] ao argumento do método
e chame o método da superclasse.
O método `toString` usa essa função para preencher a descrição do widget.

### Imprimir a árvore de renderização

Ao depurar um problema de layout, a árvore da camada Widgets pode carecer de detalhes.
O próximo nível de depuração pode exigir uma árvore de renderização.
Para despejar a árvore de renderização:

1. Abra seu arquivo fonte.
1. Chame a função [`debugDumpRenderTree()`][].
   Você pode chamar isso a qualquer momento, exceto durante uma fase de layout ou pintura.
   Considere chamá-lo de um [frame callback][] ou um manipulador de evento.
1. Se você não iniciou seu app, depure-o usando seu IDE.
1. Se você já iniciou seu app, salve seu arquivo fonte.
   Hot reload re-renderiza seu app.

#### Exemplo 5: Chamar `debugDumpRenderTree()`

<?code-excerpt "lib/dump_render_tree.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: AppHome(),
    ),
  );
}

class AppHome extends StatelessWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: TextButton(
          onPressed: () {
            debugDumpRenderTree();
          },
          child: const Text('Dump Render Tree'),
        ),
      ),
    );
  }
}
```

Ao depurar problemas de layout, observe os campos `size` e `constraints`.
As constraints fluem pela árvore abaixo e os tamanhos fluem de volta para cima.

<details>
<summary><strong>Expandir para ver a árvore de renderização para o Exemplo 5</strong></summary>

{% render docs/testing/trees/render-tree.md -%}

</details>

Na árvore de renderização para o **Exemplo 5**:

* O `RenderView`, ou tamanho da janela, limita todos os objetos de renderização até e
  incluindo o objeto de renderização [`RenderPositionedBox`][]`#dc1df`
  ao tamanho da tela.
  Este exemplo define o tamanho para `Size(800.0, 600.0)`

* A propriedade `constraints` de cada objeto de renderização limita o tamanho
  de cada filho. Esta propriedade recebe o objeto de renderização [`BoxConstraints`][] como valor.
  Começando com `RenderSemanticsAnnotations#fe6b5`, a constraint é igual a
  `BoxConstraints(w=800.0, h=600.0)`.

* O widget [`Center`][] criou o objeto de renderização `RenderPositionedBox#dc1df`
  sob a subárvore `RenderSemanticsAnnotations#8187b`.

* Cada filho sob este objeto de renderização tem `BoxConstraints` com ambos
  valores mínimo e máximo. Por exemplo, `RenderSemanticsAnnotations#a0a4b`
  usa `BoxConstraints(0.0<=w<=800.0, 0.0<=h<=600.0)`.

* Todos os filhos do objeto de renderização `RenderPhysicalShape#8e171` usam
  `BoxConstraints(BoxConstraints(56.0<=w<=800.0, 28.0<=h<=600.0))`.

* O filho `RenderPadding#8455f` define um valor de `padding` de
  `EdgeInsets(8.0, 0.0, 8.0, 0.0)`.
  Isso define um padding esquerdo e direito de 8 para todos os filhos subsequentes deste
  objeto de renderização.
  Eles agora têm novas constraints:
  `BoxConstraints(40.0<=w<=784.0, 28.0<=h<=600.0)`.

Este objeto, que o campo `creator` nos diz que é
provavelmente parte da definição do [`TextButton`][],
define uma largura mínima de 88 pixels em seu conteúdo e uma
altura específica de 36.0. Esta é a classe `TextButton` implementando
as diretrizes do Material Design sobre dimensões de botões.

O objeto de renderização `RenderPositionedBox#80b8d` afrouxa as constraints novamente
para centralizar o texto dentro do botão.
O objeto de renderização [`RenderParagraph`][]#59bc2 escolhe seu tamanho com base em
seu conteúdo.
Se você seguir os tamanhos de volta pela árvore,
verá como o tamanho do texto influencia a largura de todas as caixas
que formam o botão.
Todos os pais assumem as dimensões de seus filhos para se dimensionarem.

Outra maneira de notar isso é observando o atributo `relayoutBoundary`
nas descrições de cada caixa.
Isso informa quantos ancestrais dependem do tamanho deste elemento.

Por exemplo, a linha `RenderPositionedBox` mais interna tem um `relayoutBoundary=up13`.
Isso significa que quando Flutter marca o `RenderConstrainedBox` como dirty,
ele também marca 13 ancestrais da caixa como dirty porque as novas dimensões
podem afetar esses ancestrais.

Para adicionar informações ao dump se você escrever seus próprios objetos de renderização,
sobrescreva [`debugFillProperties()`][render-fill].
Adicione objetos [DiagnosticsProperty][] ao argumento do método
e então chame o método da superclasse.

### Imprimir a árvore de camadas

Para depurar um problema de composição, use [`debugDumpLayerTree()`][].

#### Exemplo 6: Chamar `debugDumpLayerTree()`

<?code-excerpt "lib/dump_layer_tree.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: AppHome(),
    ),
  );
}

class AppHome extends StatelessWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: TextButton(
          onPressed: () {
            debugDumpLayerTree();
          },
          child: const Text('Dump Layer Tree'),
        ),
      ),
    );
  }
}
```

<details>
<summary><strong>Expandir para ver a saída da árvore de camadas para o Exemplo 6</strong></summary>

{% render docs/testing/trees/layer-tree.md -%}

</details>

O widget `RepaintBoundary` cria:

1. Um RenderObject `RenderRepaintBoundary` na árvore de renderização
   conforme mostrado nos resultados do **Exemplo 5**.

   ```plaintext
   ╎     └─child: RenderRepaintBoundary#f8f28
   ╎       │ needs compositing
   ╎       │ creator: RepaintBoundary ← _FocusInheritedScope ← Semantics ←
   ╎       │   FocusScope ← PrimaryScrollController ← _ActionsScope ← Actions
   ╎       │   ← Builder ← PageStorage ← Offstage ← _ModalScopeStatus ←
   ╎       │   UnmanagedRestorationScope ← ⋯
   ╎       │ parentData: <none> (can use size)
   ╎       │ constraints: BoxConstraints(w=800.0, h=600.0)
   ╎       │ layer: OffsetLayer#e73b7
   ╎       │ size: Size(800.0, 600.0)
   ╎       │ metrics: 66.7% useful (1 bad vs 2 good)
   ╎       │ diagnosis: insufficient data to draw conclusion (less than five
   ╎       │   repaints)
   ```

1. Uma nova camada na árvore de camadas conforme mostrado nos resultados do **Exemplo 6**.

   ```plaintext
   ├─child 1: OffsetLayer#0f766
   │ │ creator: RepaintBoundary ← _FocusInheritedScope ← Semantics ←
   │ │   FocusScope ← PrimaryScrollController ← _ActionsScope ← Actions
   │ │   ← Builder ← PageStorage ← Offstage ← _ModalScopeStatus ←
   │ │   UnmanagedRestorationScope ← ⋯
   │ │ engine layer: OffsetEngineLayer#1768d
   │ │ handles: 2
   │ │ offset: Offset(0.0, 0.0)
   ```

Isso reduz quanto precisa ser repintado.

### Imprimir a árvore de foco

Para depurar um problema de foco ou atalho, despeje a árvore de foco
usando a função [`debugDumpFocusTree()`][].

O método `debugDumpFocusTree()` retorna a árvore de foco para o app.

A árvore de foco rotula os nós da seguinte maneira:

* O nó focado é rotulado como `PRIMARY FOCUS`.
* Ancestrais dos nós de foco são rotulados como `IN FOCUS PATH`.

Se seu app usa o widget [`Focus`][], use a propriedade [`debugLabel`][]
para simplificar a localização do seu nó de foco na árvore.

Você também pode usar a propriedade booleana [`debugFocusChanges`][] para habilitar
logging extensivo quando o foco muda.

#### Exemplo 7: Chamar `debugDumpFocusTree()`

<?code-excerpt "lib/dump_focus_tree.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: AppHome(),
    ),
  );
}

class AppHome extends StatelessWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: TextButton(
          onPressed: () {
            debugDumpFocusTree();
          },
          child: const Text('Dump Focus Tree'),
        ),
      ),
    );
  }
}
```

<details>
<summary><strong>Expandir para ver a árvore de foco para o Exemplo 7</strong></summary>

{% render docs/testing/trees/focus-tree.md -%}

</details>

### Imprimir a árvore semântica

A função `debugDumpSemanticsTree()` imprime a árvore semântica para o app.

A árvore de Semantics é apresentada às APIs de acessibilidade do sistema.
Para obter um dump da árvore de Semantics:

1. Habilite a acessibilidade usando uma ferramenta de acessibilidade do sistema
   ou o `SemanticsDebugger`
1. Use a função [`debugDumpSemanticsTree()`][].

#### Exemplo 8: Chamar `debugDumpSemanticsTree()`

<?code-excerpt "lib/dump_semantic_tree.dart"?>
```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(
    const MaterialApp(
      home: AppHome(),
    ),
  );
}

class AppHome extends StatelessWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Semantics(
          button: true,
          enabled: true,
          label: 'Clickable text here!',
          child: GestureDetector(
              onTap: () {
                debugDumpSemanticsTree();
                if (kDebugMode) {
                  print('Clicked!');
                }
              },
              child: const Text('Click Me!', style: TextStyle(fontSize: 56))),
        ),
      ),
    );
  }
}
```

<details>
<summary><strong>Expandir para ver a árvore semântica para o Exemplo 8</strong></summary>

{% render docs/testing/trees/semantic-tree.md -%}

</details>

### Imprimir timings de eventos

Se você quiser descobrir onde seus eventos acontecem em relação ao
início e fim do frame, você pode configurar prints para registrar esses eventos.
Para imprimir o início e fim dos frames no console,
alterne [`debugPrintBeginFrameBanner`][]
e [`debugPrintEndFrameBanner`][].

**O log de banner de frame de impressão para o Exemplo 1**

```plaintext
I/flutter : ▄▄▄▄▄▄▄▄ Frame 12         30s 437.086ms ▄▄▄▄▄▄▄▄
I/flutter : Debug print: Am I performing this work more than once per frame?
I/flutter : Debug print: Am I performing this work more than once per frame?
I/flutter : ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
```

Para imprimir a pilha de chamadas causando o agendamento do frame atual,
use a flag [`debugPrintScheduleFrameStacks`][].

## Depurar problemas de layout

Para depurar um problema de layout usando uma GUI, defina
[`debugPaintSizeEnabled`][] para `true`.
Esta flag pode ser encontrada na biblioteca `rendering`.
Você pode habilitá-la a qualquer momento e afeta toda a pintura enquanto `true`.
Considere adicioná-la ao topo do seu ponto de entrada `void main()`.

#### Exemplo 9

Veja um exemplo no seguinte código:

<?code-excerpt "lib/debug_flags.dart (debug-paint-size-enabled)"?>
```dart
// Add import to the Flutter rendering library.
import 'package:flutter/rendering.dart';

void main() {
  debugPaintSizeEnabled = true;
  runApp(const MyApp());
}
```

Quando habilitado, o Flutter exibe as seguintes mudanças no seu app:

* Exibe todas as caixas em uma borda teal brilhante.
* Exibe todo o padding como uma caixa com preenchimento azul desbotado e borda azul
  ao redor do widget filho.
* Exibe todo o posicionamento de alinhamento com setas amarelas.
* Exibe todos os espaçadores em cinza, quando não têm filho.

A flag [`debugPaintBaselinesEnabled`][]
faz algo similar mas para objetos com baselines.
O app exibe a baseline para caracteres alfabéticos em verde brilhante
e a baseline para caracteres ideográficos em laranja.
Caracteres alfabéticos "sentam" na baseline alfabética,
mas essa baseline "corta" através da parte inferior de [caracteres CJK][cjk].
O Flutter posiciona a baseline ideográfica na parte mais inferior da linha de texto.

A flag [`debugPaintPointersEnabled`][] ativa um modo especial que
destaca quaisquer objetos que você toca em teal.
Isso pode ajudá-lo a determinar se um objeto falha no teste de hit.
Isso pode acontecer se o objeto cair fora dos limites de seu pai
e assim não ser considerado para teste de hit em primeiro lugar.

Se você está tentando depurar camadas de compositor, considere usar as seguintes flags.

* Use a flag [`debugPaintLayerBordersEnabled`][] para encontrar os limites
  de cada camada. Esta flag resulta em delinear os limites de cada camada em laranja.

* Use a flag [`debugRepaintRainbowEnabled`][] para exibir uma camada repintada.
  Sempre que uma camada repinta, ela sobrepõe com um conjunto rotativo de cores.

Qualquer função ou método no framework Flutter que comece com
`debug...` funciona apenas no [modo debug][].

[cjk]: https://en.wikipedia.org/wiki/CJK_characters

## Depurar problemas de animação

:::note
Para depurar animações com o mínimo de esforço, desacelere-as.
Para desacelerar a animação,
clique em **Slow Animations** na [Inspector view][] do DevTools.
Isso reduz a animação para 20% da velocidade.
Se você quiser mais controle sobre a quantidade de lentidão,
use as instruções a seguir.
:::

Defina a variável [`timeDilation`][] (da biblioteca `scheduler`)
para um número maior que 1.0, por exemplo, 50.0.
É melhor definir isso apenas uma vez na inicialização do app. Se você
mudar isso em tempo real, especialmente se você reduzi-lo enquanto
animações estão sendo executadas, é possível que o framework
observe o tempo indo para trás, o que provavelmente
resultará em asserções e geralmente interferirá com seus esforços.

## Depurar problemas de desempenho

:::note
Você pode obter resultados semelhantes a algumas dessas flags de debug
usando [DevTools][]. Algumas das flags de debug fornecem pouco benefício.
Se você encontrar uma flag com funcionalidade que gostaria de adicionar ao [DevTools][],
[registre um problema][file an issue].
:::

O Flutter fornece uma ampla variedade de propriedades e funções de nível superior
para ajudá-lo a depurar seu app em vários pontos ao longo do
ciclo de desenvolvimento.
Para usar esses recursos, compile seu app no modo debug.

A lista a seguir destaca algumas flags e uma função da
[biblioteca rendering][] para depurar problemas de desempenho.

[`debugDumpRenderTree()`][]
: Para despejar a árvore de renderização para o console,
  chame esta função quando não estiver em uma fase de layout ou repintura.

  {% comment %}
    Feature is not yet added to DevTools:
    Rather than using this flag to dump the render tree
    to a file, view the render tree in the Flutter inspector.
    To do so, bring up the Flutter inspector and select the
    **Render Tree** tab.
  {% endcomment %}

  Para definir essas flags:

* edite o código do framework
* importe o módulo, defina o valor na sua função `main()`,
  então faça hot restart.

[`debugPaintLayerBordersEnabled`][]
: Para exibir os limites de cada camada, defina esta propriedade para `true`.
  Quando definida, cada camada pinta uma caixa ao redor de seu limite.

[`debugRepaintRainbowEnabled`][]
: Para exibir uma borda colorida ao redor de cada widget, defina esta propriedade para `true`.
  Essas bordas mudam de cor conforme o usuário do app rola no app.
  Para definir esta flag, adicione `debugRepaintRainbowEnabled = true;` como uma propriedade
  de nível superior no seu app.
  Se quaisquer widgets estáticos rotacionarem através de cores após definir esta flag,
  considere adicionar limites de repintura a essas áreas.

[`debugPrintMarkNeedsLayoutStacks`][]
: Para determinar se seu app cria mais layouts do que o esperado,
  defina esta propriedade para `true`.
  Este problema de layout pode acontecer na timeline, em um perfil,
  ou de uma instrução `print` dentro de um método de layout.
  Quando definida, o framework gera stack traces para o console
  para explicar por que seu app marca cada objeto de renderização para ser disposto.

[`debugPrintMarkNeedsPaintStacks`][]
: Para determinar se seu app pinta mais layouts do que o esperado,
  defina esta propriedade para `true`.

Você também pode gerar stack traces sob demanda.
Para imprimir seus próprios stack traces, adicione a função `debugPrintStack()`
ao seu app.

### Rastrear desempenho do código Dart

:::note
Você pode usar a [aba Timeline events][] do DevTools para realizar traces.
Você também pode importar e exportar arquivos de trace para a view Timeline,
mas apenas arquivos gerados pelo DevTools.
:::

Para realizar traces de desempenho personalizados e
medir o tempo de wall ou CPU de segmentos arbitrários de código Dart
como o Android faz com [systrace][],
use utilitários [Timeline][] do `dart:developer`.

1. Abra seu código fonte.
1. Envolva o código que você quer medir em métodos `Timeline`.

    <?code-excerpt "lib/perf_trace.dart"?>
    ```dart
    import 'dart:developer';
    
    void main() {
      Timeline.startSync('interesting function');
      // iWonderHowLongThisTakes();
      Timeline.finishSync();
    }
    ```

1. Enquanto conectado ao seu app, abra a [aba Timeline events][] do DevTools.
1. Selecione a opção de gravação **Dart** nas **Performance settings**.
1. Execute a função que você quer medir.

Para garantir que as características de desempenho em tempo de execução correspondam proximamente às
do seu produto final, execute seu app no [modo profile][].

### Adicionar sobreposição de desempenho

:::note
Você pode alternar a exibição da sobreposição de desempenho no
seu app usando o botão **Performance Overlay** no
[Flutter inspector][]. Se você preferir fazer isso no código,
use as instruções a seguir.
:::

Para habilitar o widget `PerformanceOverlay` no seu código,
defina a propriedade `showPerformanceOverlay` para `true` no
construtor [`MaterialApp`][], [`CupertinoApp`][], ou [`WidgetsApp`][]:

#### Exemplo 10

<?code-excerpt "lib/performance_overlay.dart (show-overlay)"?>
```dart
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: true,
      title: 'My Awesome App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'My Awesome App'),
    );
  }
}
```

(Se você não está usando `MaterialApp`, `CupertinoApp`,
ou `WidgetsApp`, você pode obter o mesmo efeito envolvendo sua
aplicação em uma stack e colocando um widget em sua stack que foi
criado chamando [`PerformanceOverlay.allEnabled()`][].)

Para aprender como interpretar os gráficos na sobreposição,
confira [The performance overlay][] em
[Profiling Flutter performance][].

## Adicionar grade de alinhamento de widgets

Para adicionar uma sobreposição a uma [grade baseline do Material Design][] no seu app para
ajudar a verificar alinhamentos, adicione o argumento `debugShowMaterialGrid` no
[construtor `MaterialApp`][`MaterialApp` constructor].

Para adicionar uma sobreposição a aplicações não-Material, adicione um widget [`GridPaper`][].

[Debugger]: /tools/devtools/debugger
[Debugging]: /testing/debugging
[DevTools]: /tools/devtools
[DiagnosticsProperty]: {{site.api}}/flutter/foundation/DiagnosticsProperty-class.html
[Flutter inspector]: /tools/devtools/inspector
[Inspector view]: /tools/devtools/inspector
[Logging view]: /tools/devtools/logging
[grade baseline do Material Design]: {{site.material}}/foundations/layout/understanding-layout/spacing
[Profiling Flutter performance]: /perf/ui-performance
[The performance overlay]: /perf/ui-performance#the-performance-overlay
[Timeline events tab]: /tools/devtools/performance#timeline-events-tab
[aba Timeline events]: /tools/devtools/performance#timeline-events-tab
[Timeline]: {{site.dart.api}}/dart-developer/Timeline-class.html
[`Center`]: {{site.api}}/flutter/widgets/Center-class.html
[`CupertinoApp`]: {{site.api}}/flutter/cupertino/CupertinoApp-class.html
[`Focus`]: {{site.api}}/flutter/widgets/Focus-class.html
[`GridPaper`]: {{site.api}}/flutter/widgets/GridPaper-class.html
[`MaterialApp` constructor]: {{site.api}}/flutter/material/MaterialApp/MaterialApp.html
[`MaterialApp`]: {{site.api}}/flutter/material/MaterialApp/MaterialApp.html
[`Material`]: {{site.api}}/flutter/material/Material-class.html
[`PerformanceOverlay.allEnabled()`]: {{site.api}}/flutter/widgets/PerformanceOverlay/PerformanceOverlay.allEnabled.html
[`RenderParagraph`]: {{site.api}}/flutter/rendering/RenderParagraph-class.html
[`RenderPositionedBox`]: {{site.api}}/flutter/rendering/RenderPositionedBox-class.html
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html
[`WidgetsApp`]: {{site.api}}/flutter/widgets/WidgetsApp-class.html
[`_InkFeatures`]: {{site.api}}/flutter/material/InkFeature-class.html
[`debugDumpApp()`]: {{site.api}}/flutter/widgets/debugDumpApp.html
[`debugDumpFocusTree()`]: {{site.api}}/flutter/widgets/debugDumpFocusTree.html
[`debugDumpLayerTree()`]: {{site.api}}/flutter/rendering/debugDumpLayerTree.html
[`debugDumpRenderTree()`]: {{site.api}}/flutter/rendering/debugDumpRenderTree.html
[`debugDumpSemanticsTree()`]: {{site.api}}/flutter/rendering/debugDumpSemanticsTree.html
[`debugFocusChanges`]: {{site.api}}/flutter/widgets/debugFocusChanges.html
[`debugLabel`]: {{site.api}}/flutter/widgets/Focus/debugLabel.html
[`debugPaintBaselinesEnabled`]: {{site.api}}/flutter/rendering/debugPaintBaselinesEnabled.html
[`debugPaintLayerBordersEnabled`]: {{site.api}}/flutter/rendering/debugPaintLayerBordersEnabled.html
[`debugPaintPointersEnabled`]: {{site.api}}/flutter/rendering/debugPaintPointersEnabled.html
[`debugPaintSizeEnabled`]: {{site.api}}/flutter/rendering/debugPaintSizeEnabled.html
[`debugPrint()`]: {{site.api}}/flutter/foundation/debugPrint.html
[`debugPrintBeginFrameBanner`]: {{site.api}}/flutter/scheduler/debugPrintBeginFrameBanner.html
[`debugPrintEndFrameBanner`]: {{site.api}}/flutter/scheduler/debugPrintEndFrameBanner.html
[`debugPrintMarkNeedsLayoutStacks`]: {{site.api}}/flutter/rendering/debugPrintMarkNeedsLayoutStacks.html
[`debugPrintMarkNeedsPaintStacks`]: {{site.api}}/flutter/rendering/debugPrintMarkNeedsPaintStacks.html
[`debugPrintScheduleFrameStacks`]: {{site.api}}/flutter/scheduler/debugPrintScheduleFrameStacks.html
[`debugRepaintRainbowEnabled`]: {{site.api}}/flutter/rendering/debugRepaintRainbowEnabled.html
[`log()`]: {{site.api}}/flutter/dart-developer/log.html
[`setState()`]: {{site.api}}/flutter/widgets/State/setState.html
[`timeDilation`]: {{site.api}}/flutter/scheduler/timeDilation.html
[modo debug]: /testing/build-modes#debug
[file an issue]: {{site.github}}/flutter/devtools/issues
[frame callback]: {{site.api}}/flutter/scheduler/SchedulerBinding/addPersistentFrameCallback.html
[modo profile]: /testing/build-modes#profile
[render-fill]: {{site.api}}/flutter/rendering/Layer/debugFillProperties.html
[biblioteca rendering]: {{site.api}}/flutter/rendering/rendering-library.html
[systrace]: {{site.android-dev}}/studio/profile/systrace
[widget-fill]: {{site.api}}/flutter/widgets/Widget/debugFillProperties.html
[`BoxConstraints`]: {{site.api}}/flutter/rendering/BoxConstraints-class.html
