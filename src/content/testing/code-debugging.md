---
title: Depurar aplicativos Flutter a partir do código
description: >
  Como ativar várias ferramentas de depuração a partir do
  seu código e na linha de comando.
ia-translate: true
---

<?code-excerpt path-base="testing/code_debugging"?>

Este guia descreve quais recursos de depuração você pode ativar em seu código.
Para uma lista completa de ferramentas de depuração e criação de perfil, consulte a
página [Depuração][].

:::note
Se você está procurando uma maneira de usar o GDB para depurar remotamente o
mecanismo Flutter em execução dentro de um processo de aplicativo Android,
confira o [`flutter_gdb`][].
:::

[`flutter_gdb`]: {{site.repo.engine}}/blob/main/sky/tools/flutter_gdb

## Adicionar registro ao seu aplicativo

:::note
Você pode ver os logs na [Visualização de registro][] do DevTools
ou no console do seu sistema. Esta seção
mostra como configurar suas declarações de registro.
:::

Você tem duas opções para registrar seu aplicativo.

1. Imprimir em `stdout` e `stderr` usando declarações `print()`.
2. Importar `dart:io` e invocar métodos em
   `stderr` e `stdout`. Por exemplo:

    <?code-excerpt "lib/main.dart (stderr)"?>
    ```dart
    stderr.writeln('print me');
    ```

Se você gerar muita saída de uma vez, o Android poderá descartar algumas linhas de log.
Para evitar esse resultado,
use [`debugPrint()`][] da biblioteca `foundation` do Flutter.
Este wrapper em torno de `print` limita a saída para evitar que o kernel do Android
descarte a saída.

Você também pode registrar seu aplicativo usando a função `dart:developer` [`log()`][].
Isso permite que você inclua maior granularidade e mais informações
na saída do registro.

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

Você também pode passar dados do aplicativo para a chamada de log.
A convenção para isso é usar o parâmetro nomeado `error:`
na chamada `log()`, codificar em JSON o objeto
que você deseja enviar e passar a string codificada para o
parâmetro de erro.

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

A visualização de logs do DevTool interpreta o parâmetro de erro codificado em JSON
como um objeto de dados.
O DevTool renderiza na visualização de detalhes para essa entrada de log.

## Definir breakpoints

Você pode definir breakpoints no [Debugger][] do DevTools ou
no depurador integrado do seu IDE.

Para definir breakpoints programáticos:

1. Importe o pacote `dart:developer` no arquivo relevante.
2. Insira breakpoints programáticos usando a declaração `debugger()`.
   Esta declaração usa um argumento `when` opcional.
   Este argumento booleano define uma pausa quando a condição dada é resolvida como verdadeira.

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

## Depurar camadas do aplicativo usando flags

Cada camada do framework Flutter fornece uma função para despejar seu
estado atual ou eventos no console usando a propriedade `debugPrint`.

:::note
Todos os exemplos a seguir foram executados como aplicativos nativos macOS em
um MacBook Pro M1. Eles serão diferentes de qualquer despejo que sua
máquina de desenvolvimento imprime.
:::

{% include docs/admonitions/tip-hashCode-tree.md %}

### Imprimir a árvore de widgets

Para despejar o estado da biblioteca Widgets,
chame a função [`debugDumpApp()`][].

1. Abra seu arquivo de origem.
2. Importe `package:flutter/rendering.dart`.
3. Chame a função [`debugDumpApp()`][] de dentro da função `runApp()`.
   Você precisa do seu aplicativo em modo de depuração.
   Você não pode chamar essa função dentro de um método `build()`
   quando o aplicativo está sendo construído.
4. Se você não iniciou seu aplicativo, depure-o usando seu IDE.
5. Se você iniciou seu aplicativo, salve seu arquivo de origem.
   O hot reload renderiza seu aplicativo novamente.

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
a raiz da árvore de widgets. Ele retorna uma árvore "achatada".

O **Exemplo 4** produz a seguinte árvore de widgets. Ele inclui:

* Todos os widgets projetados através de suas várias funções de build.
* Muitos widgets que não aparecem no código fonte do seu aplicativo.
  As funções de build dos widgets do framework os inserem durante o build.

  A árvore a seguir, por exemplo, mostra [`_InkFeatures`][].
  Essa classe implementa parte do widget [`Material`][].
  Ela não aparece em nenhum lugar no código do **Exemplo 4**.

<details>
<summary><strong>Expandir para ver a árvore de widgets para o Exemplo 4</strong></summary>

{% render docs/testing/trees/widget-tree.md -%}

</details>

Quando o botão muda de pressionado para liberado,
isso invoca a função `debugDumpApp()`.
Também coincide com o objeto [`TextButton`][] chamando [`setState()`][]
e, portanto, marcando-se como sujo.
Isso explica por que o Flutter marca um objeto específico como "sujo".
Ao revisar a árvore de widgets, procure por uma linha que se pareça com a seguinte:

```plaintext
└TextButton(dirty, dependencies: [MediaQuery, _InheritedTheme, _LocalizationsScope-[GlobalKey#5880d]], state: _ButtonStyleState#ab76e)
```

Se você escrever seus próprios widgets, substitua o
método [`debugFillProperties()`][widget-fill] para adicionar informações.
Adicione objetos [DiagnosticsProperty][] ao argumento do método
e chame o método da superclasse.
O método `toString` usa essa função para preencher a descrição do widget.

### Imprimir a árvore de renderização

Ao depurar um problema de layout, a árvore da camada Widgets pode não ter detalhes.
O próximo nível de depuração pode exigir uma árvore de renderização.
Para despejar a árvore de renderização:

1. Abra seu arquivo de origem.
2. Chame a função [`debugDumpRenderTree()`][].
   Você pode chamar isso a qualquer momento, exceto durante uma fase de layout ou pintura.
   Considere chamá-lo de um [callback de frame][] ou um manipulador de eventos.
3. Se você não iniciou seu aplicativo, depure-o usando seu IDE.
4. Se você iniciou seu aplicativo, salve seu arquivo de origem.
   O hot reload renderiza seu aplicativo novamente.

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
As restrições fluem para baixo da árvore e os tamanhos fluem de volta para cima.

<details>
<summary><strong>Expandir para ver a árvore de renderização para o Exemplo 5</strong></summary>

{% render docs/testing/trees/render-tree.md -%}

</details>

Na árvore de renderização do **Exemplo 5**:

* O `RenderView`, ou tamanho da janela, limita todos os objetos de renderização até e
  incluindo o objeto de renderização [`RenderPositionedBox`][]`#dc1df`
  ao tamanho da tela.
  Este exemplo define o tamanho para `Size(800.0, 600.0)`

* A propriedade `constraints` de cada objeto de renderização limita o tamanho
  de cada filho. Esta propriedade usa o objeto de renderização [`BoxConstraints`][] como um valor.
  Começando com `RenderSemanticsAnnotations#fe6b5`, a restrição é igual a
  `BoxConstraints(w=800.0, h=600.0)`.

* O widget [`Center`][] criou o objeto de renderização `RenderPositionedBox#dc1df`
  sob a subárvore `RenderSemanticsAnnotations#8187b`.

* Cada filho sob este objeto de renderização tem `BoxConstraints` com ambos
  valores mínimos e máximos. Por exemplo, `RenderSemanticsAnnotations#a0a4b`
  usa `BoxConstraints(0.0<=w<=800.0, 0.0<=h<=600.0)`.

* Todos os filhos do objeto de renderização `RenderPhysicalShape#8e171` usam
  `BoxConstraints(BoxConstraints(56.0<=w<=800.0, 28.0<=h<=600.0))`.

* O filho `RenderPadding#8455f` define um valor de `padding` de
  `EdgeInsets(8.0, 0.0, 8.0, 0.0)`.
  Isso define um padding esquerdo e direito de 8 para todos os filhos subsequentes de
  este objeto de renderização.
  Eles agora têm novas restrições:
  `BoxConstraints(40.0<=w<=784.0, 28.0<=h<=600.0)`.

Este objeto, que o campo `creator` nos diz que é
provavelmente parte da definição do [`TextButton`][],
define uma largura mínima de 88 pixels em seu conteúdo e uma
altura específica de 36.0. Esta é a classe `TextButton` implementando
as diretrizes de Material Design sobre dimensões de botão.

O objeto de renderização `RenderPositionedBox#80b8d` afrouxa as restrições novamente
para centralizar o texto dentro do botão.
O objeto de renderização [`RenderParagraph`][]#59bc2 escolhe seu tamanho com base em
seu conteúdo.
Se você seguir os tamanhos de volta na árvore,
você verá como o tamanho do texto influencia a largura de todas as caixas
que formam o botão.
Todos os pais pegam as dimensões de seus filhos para se dimensionarem.

Outra maneira de notar isso é olhando para o `relayoutBoundary`
atributo nas descrições de cada caixa.
Isso informa quantos ancestrais dependem do tamanho deste elemento.

Por exemplo, a linha `RenderPositionedBox` mais interna tem um `relayoutBoundary=up13`.
Isso significa que quando o Flutter marca o `RenderConstrainedBox` como sujo,
ele também marca os 13 ancestrais da caixa como sujos porque as novas dimensões
podem afetar esses ancestrais.

Para adicionar informações ao despejo se você escrever seus próprios objetos de renderização,
substitua [`debugFillProperties()`][render-fill].
Adicione objetos [DiagnosticsProperty][] ao argumento do método
e, em seguida, chame o método da superclasse.

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

1. Um `RenderRepaintBoundary` RenderObject na árvore de renderização
   como mostrado nos resultados do **Exemplo 5**.

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

2. Uma nova camada na árvore de camadas, conforme mostrado no **Exemplo 6**
   resultados.

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

Isso reduz o quanto precisa ser repintado.

### Imprimir a árvore de foco

Para depurar um problema de foco ou atalho, despeje a árvore de foco
usando a função [`debugDumpFocusTree()`][].

O método `debugDumpFocusTree()` retorna a árvore de foco para o aplicativo.

A árvore de foco rotula os nós da seguinte maneira:

* O nó com foco é rotulado como `PRIMARY FOCUS`.
* Os ancestrais dos nós de foco são rotulados como `IN FOCUS PATH`.

Se o seu aplicativo usa o widget [`Focus`][], use a propriedade [`debugLabel`][]
para simplificar a localização de seu nó de foco na árvore.

Você também pode usar a propriedade booleana [`debugFocusChanges`][] para ativar
o registro extenso quando o foco mudar.

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

A função `debugDumpSemanticsTree()` imprime a árvore semântica para o aplicativo.

A árvore semântica é apresentada às APIs de acessibilidade do sistema.
Para obter um despejo da árvore semântica:

1. Ative a acessibilidade usando uma ferramenta de acessibilidade do sistema
   ou o `SemanticsDebugger`
2. Use a função [`debugDumpSemanticsTree()`][].

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

### Imprimir tempos de eventos

Se você quiser descobrir onde seus eventos acontecem em relação ao início e fim do frame,
você pode definir impressões para registrar esses eventos.
Para imprimir o início e o fim dos frames no console,
alterne o [`debugPrintBeginFrameBanner`][]
e o [`debugPrintEndFrameBanner`][].

**O log do banner de frame de impressão para o Exemplo 1**

```plaintext
I/flutter : ▄▄▄▄▄▄▄▄ Frame 12         30s 437.086ms ▄▄▄▄▄▄▄▄
I/flutter : Debug print: Am I performing this work more than once per frame?
I/flutter : Debug print: Am I performing this work more than once per frame?
I/flutter : ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
```

Para imprimir a pilha de chamadas que faz com que o frame atual seja agendado,
use a flag [`debugPrintScheduleFrameStacks`][].

## Depurar problemas de layout

Para depurar um problema de layout usando uma GUI, defina
[`debugPaintSizeEnabled`][] como `true`.
Esta flag pode ser encontrada na biblioteca `rendering`.
Você pode ativá-la a qualquer momento e afeta toda a pintura enquanto estiver `true`.
Considere adicioná-la ao topo do seu ponto de entrada `void main()`.

#### Exemplo 9

Veja um exemplo no código a seguir:

<?code-excerpt "lib/debug_flags.dart (debug-paint-size-enabled)"?>
```dart
// Adicione a importação à biblioteca de renderização do Flutter.
import 'package:flutter/rendering.dart';

void main() {
  debugPaintSizeEnabled = true;
  runApp(const MyApp());
}
```

Quando ativado, o Flutter exibe as seguintes alterações no seu aplicativo:

* Exibe todas as caixas em uma borda teal brilhante.
* Exibe todo o padding como uma caixa com preenchimento azul desbotado e borda azul
  em torno do widget filho.
* Exibe todo o posicionamento de alinhamento com setas amarelas.
* Exibe todos os espaçadores em cinza, quando não têm filhos.

A flag [`debugPaintBaselinesEnabled`][]
faz algo semelhante, mas para objetos com linhas de base.
O aplicativo exibe a linha de base para caracteres alfabéticos em verde brilhante
e a linha de base para caracteres ideográficos em laranja.
Caracteres alfabéticos "sentam-se" na linha de base alfabética,
mas essa linha de base "corta" a parte inferior dos [caracteres CJK][cjk].
O Flutter posiciona a linha de base ideográfica na parte inferior da linha de texto.

A flag [`debugPaintPointersEnabled`][] ativa um modo especial que
destaca todos os objetos que você toca em teal.
Isso pode ajudar você a determinar se um objeto não consegue acertar o teste.
Isso pode acontecer se o objeto estiver fora dos limites de seu pai
e, portanto, não for considerado para o teste de acerto em primeiro lugar.

Se você estiver tentando depurar camadas de compositor, considere usar as seguintes flags.

* Use a flag [`debugPaintLayerBordersEnabled`][] para encontrar os limites
  de cada camada. Esta flag resulta em delinear os limites de cada camada em laranja.

* Use a flag [`debugRepaintRainbowEnabled`][] para exibir uma camada repintada.
  Sempre que uma camada repinta, ela sobrepõe com um conjunto rotativo de cores.

Qualquer função ou método no framework Flutter que começa com
`debug...` só funciona em [modo de depuração][].

[cjk]: https://en.wikipedia.org/wiki/CJK_characters

## Depurar problemas de animação

:::note
Para depurar animações com o mínimo esforço, desacelere-as.
Para desacelerar a animação,
clique em **Animações Lentas** na [Visualização do inspetor][] do DevTools.
Isso reduz a animação para 20% da velocidade.
Se você quiser mais controle sobre a quantidade de lentidão,
use as seguintes instruções.
:::

Defina a variável [`timeDilation`][] (da biblioteca `scheduler`)
para um número maior que 1.0, por exemplo, 50.0.
É melhor definir isso apenas uma vez na inicialização do aplicativo. Se você
alterá-lo em tempo real, especialmente se você reduzi-lo enquanto
as animações estão em execução, é possível que o framework
observe o tempo voltando para trás, o que provavelmente
resultará em asserts e geralmente interferirá em seus esforços.

## Depurar problemas de desempenho

:::note
Você pode obter resultados semelhantes a algumas dessas flags de depuração
usando o [DevTools][]. Algumas das flags de depuração fornecem pouco benefício.
Se você encontrar uma flag com funcionalidade que gostaria de adicionar ao [DevTools][],
[abra um issue][].
:::

O Flutter fornece uma ampla variedade de propriedades e funções de nível superior
para ajudar você a depurar seu aplicativo em vários pontos ao longo do
ciclo de desenvolvimento.
Para usar esses recursos, compile seu aplicativo no modo de depuração.

A lista a seguir destaca algumas flags e uma função da
[biblioteca de renderização][] para depurar problemas de desempenho.

[`debugDumpRenderTree()`][]
: Para despejar a árvore de renderização no console,
  chame esta função quando não estiver em uma fase de layout ou repintura.

  {% comment %}
    O recurso ainda não foi adicionado ao DevTools:
    Em vez de usar esta flag para despejar a árvore de renderização
    em um arquivo, visualize a árvore de renderização no inspetor do Flutter.
    Para fazer isso, abra o inspetor do Flutter e selecione a
    aba **Árvore de Renderização**.
  {% endcomment %}

  Para definir essas flags:

* edite o código do framework
* importe o módulo, defina o valor em sua função `main()`,
  e então faça hot restart.

[`debugPaintLayerBordersEnabled`][]
: Para exibir os limites de cada camada, defina esta propriedade como `true`.
  Quando definido, cada camada pinta uma caixa ao redor de seu limite.

[`debugRepaintRainbowEnabled`][]
: Para exibir uma borda colorida ao redor de cada widget, defina esta propriedade como `true`.
  Essas bordas mudam de cor à medida que o usuário do aplicativo rola no aplicativo.
  Para definir esta flag, adicione `debugRepaintRainbowEnabled = true;` como uma
  propriedade de nível superior em seu aplicativo.
  Se algum widget estático girar através de cores após definir esta flag,
  considere adicionar limites de repintura a essas áreas.

[`debugPrintMarkNeedsLayoutStacks`][]
: Para determinar se seu aplicativo cria mais layouts do que o esperado,
  defina esta propriedade como `true`.
  Esse problema de layout pode acontecer na linha do tempo, em um perfil,
  ou a partir de uma declaração `print` dentro de um método de layout.
  Quando definido, o framework produz rastreamentos de pilha no console
  para explicar por que seu aplicativo marca cada objeto de renderização para ser disposto.

[`debugPrintMarkNeedsPaintStacks`][]
: Para determinar se seu aplicativo pinta mais layouts do que o esperado,
  defina esta propriedade como `true`.

Você também pode gerar rastreamentos de pilha sob demanda.
Para imprimir seus próprios rastreamentos de pilha, adicione a função
`debugPrintStack()` ao seu aplicativo.

### Rastrear o desempenho do código Dart

:::note
Você pode usar a aba [Eventos da linha do tempo][] do DevTools para realizar rastreamentos.
Você também pode importar e exportar arquivos de rastreamento para a visualização da linha do tempo,
mas apenas arquivos gerados pelo DevTools.
:::

Para realizar rastreamentos de desempenho personalizados e
medir o tempo de parede ou CPU de segmentos arbitrários de código Dart
como o Android faz com o [systrace][],
use as utilidades [Timeline][] de `dart:developer`.

1. Abra seu código-fonte.
2. Envolva o código que você deseja medir em métodos `Timeline`.

    <?code-excerpt "lib/perf_trace.dart"?>
    ```dart
    import 'dart:developer';
    
    void main() {
      Timeline.startSync('interesting function');
      // iWonderHowLongThisTakes();
      Timeline.finishSync();
    }
    ```

3. Enquanto estiver conectado ao seu aplicativo, abra a aba [Eventos da linha do tempo][] do DevTools.
4. Selecione a opção de gravação **Dart** nas **Configurações de desempenho**.
5. Execute a função que você deseja medir.

Para garantir que as características de desempenho do runtime correspondam de perto às
do seu produto final, execute seu aplicativo no [modo profile][].

### Adicionar sobreposição de desempenho

:::note
Você pode alternar a exibição da sobreposição de desempenho no
seu aplicativo usando o botão **Sobreposição de Desempenho** no
[inspetor do Flutter][]. Se você preferir fazer isso no código,
use as seguintes instruções.
:::

Para ativar o widget `PerformanceOverlay` no seu código,
defina a propriedade `showPerformanceOverlay` como `true` no
construtor [`MaterialApp`][], [`CupertinoApp`][] ou [`WidgetsApp`][]:

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

(Se você não estiver usando `MaterialApp`, `CupertinoApp`
ou `WidgetsApp`, você pode obter o mesmo efeito envolvendo seu
aplicativo em uma pilha e colocando um widget em sua pilha que foi
criado chamando [`PerformanceOverlay.allEnabled()`][].)

Para aprender como interpretar os gráficos na sobreposição,
confira [A sobreposição de desempenho][] em
[Criando perfil de desempenho do Flutter][].

## Adicionar grade de alinhamento de widget

Para adicionar uma sobreposição a uma [grade de linha de base do Material Design][] em seu aplicativo para
ajudar a verificar os alinhamentos, adicione o argumento `debugShowMaterialGrid` no
[`Construtor MaterialApp`][].

Para adicionar uma sobreposição a aplicativos não Material, adicione um widget [`GridPaper`][].

[Depurador]: /tools/devtools/debugger
[Depuração]: /testing/debugging
[DevTools]: /tools/devtools
[Propriedade de Diagnóstico]: {{site.api}}/flutter/foundation/DiagnosticsProperty-class.html
[Inspetor do Flutter]: /tools/devtools/inspector
[Visualização do Inspetor]: /tools/devtools/inspector
[Visualização de Registro]: /tools/devtools/logging
[Grade de linha de base do Material Design]: {{site.material}}/foundations/layout/understanding-layout/spacing
[Criando perfil de desempenho do Flutter]: /perf/ui-performance
[A sobreposição de desempenho]: /perf/ui-performance#the-performance-overlay
[Eventos da linha do tempo]: /tools/devtools/performance#timeline-events-tab
[Linha do tempo]: {{site.dart.api}}/dart-developer/Timeline-class.html
[`Center`]: {{site.api}}/flutter/widgets/Center-class.html
[`CupertinoApp`]: {{site.api}}/flutter/cupertino/CupertinoApp-class.html
[`Focus`]: {{site.api}}/flutter/widgets/Focus-class.html
[`GridPaper`]: {{site.api}}/flutter/widgets/GridPaper-class.html
[`Construtor MaterialApp`]: {{site.api}}/flutter/material/MaterialApp/MaterialApp.html
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
[modo de depuração]: /testing/build-modes#debug
[abra um issue]: {{site.github}}/flutter/devtools/issues
[callback de frame]: {{site.api}}/flutter/scheduler/SchedulerBinding/addPersistentFrameCallback.html
[modo profile]: /testing/build-modes#profile
[render-fill]: {{site.api}}/flutter/rendering/Layer/debugFillProperties.html
[biblioteca de renderização]: {{site.api}}/flutter/rendering/rendering-library.html
[systrace]: {{site.android-dev}}/studio/profile/systrace
[widget-fill]: {{site.api}}/flutter/widgets/Widget/debugFillProperties.html
[`BoxConstraints`]: {{site.api}}/flutter/rendering/BoxConstraints-class.html
