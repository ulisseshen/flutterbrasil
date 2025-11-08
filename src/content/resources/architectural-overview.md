---
ia-translate: true
title: Visão geral da arquitetura Flutter
description: Uma visão geral de alto nível da arquitetura do Flutter, incluindo os princípios e conceitos centrais que formam seu design.
---

<?code-excerpt path-base="resources/architectural_overview/"?>

Este artigo tem como objetivo fornecer uma visão geral de alto nível da arquitetura do
Flutter, incluindo os princípios e conceitos centrais que formam seu design.

Flutter é um toolkit de UI multiplataforma que foi projetado para permitir reutilização de código
em sistemas operacionais como iOS e Android, enquanto também permite que
aplicações interajam diretamente com os serviços de plataforma subjacentes. O objetivo
é permitir que desenvolvedores entreguem apps de alto desempenho que se sintam naturais em
diferentes plataformas, abraçando diferenças onde elas existem, enquanto compartilham o
máximo possível de código.

Durante o desenvolvimento, apps Flutter rodam em uma VM que oferece hot reload stateful de
mudanças sem precisar de uma recompilação completa. Para release, apps Flutter são compilados
diretamente para código de máquina, seja instruções Intel x64 ou ARM, ou para
JavaScript se o alvo for web. O framework é open source, com uma licença
BSD permissiva, e tem um ecossistema próspero de pacotes de terceiros que
complementam a funcionalidade da biblioteca central.

Esta visão geral está dividida em várias seções:

1. O **modelo de camadas**: As peças das quais Flutter é construído.
1. **Interfaces de usuário reativas**: Um conceito central para o desenvolvimento de interfaces de usuário Flutter.
1. Uma introdução aos **widgets**: Os blocos de construção fundamentais das interfaces de usuário Flutter.
1. O **processo de renderização**: Como Flutter transforma código de UI em pixels.
1. Uma visão geral dos **embedders de plataforma**: O código que permite que sistemas operacionais
   mobile e desktop executem apps Flutter.
1. **Integrando Flutter com outro código**: Informações sobre diferentes técnicas
   disponíveis para apps Flutter.
1. **Suporte para web**: Observações finais sobre as características do
   Flutter em um ambiente de navegador.

## Camadas arquiteturais

Flutter é projetado como um sistema extensível e em camadas. Ele existe como uma série de
bibliotecas independentes que cada uma depende da camada subjacente. Nenhuma camada tem
acesso privilegiado à camada abaixo, e cada parte do nível de framework é
projetada para ser opcional e substituível.

{% comment %}
The PNG diagrams in this document were created using draw.io. The draw.io
metadata is embedded in the PNG file itself, so you can open the PNG directly
from draw.io to edit the individual components.

The following settings were used:

 - Select all (to avoid exporting the canvas itself)
 - Export as PNG, zoom 300% (for a reasonable sized output)
 - Enable _Transparent Background_
 - Enable _Selection Only_, _Crop_
 - Enable _Include a copy of my diagram_

{% endcomment %}

![Architectural
diagram](/assets/images/docs/arch-overview/archdiagram.png){:width="100%"}

Para o sistema operacional subjacente, aplicações Flutter são empacotadas da mesma
forma que qualquer outra aplicação nativa. Um embedder específico de plataforma fornece
um ponto de entrada; coordena com o sistema operacional subjacente para acesso a
serviços como superfícies de renderização, acessibilidade e entrada; e gerencia o
loop de eventos de mensagem. O embedder é escrito em uma linguagem que é apropriada
para a plataforma: atualmente Java e C++ para Android, Objective-C/Objective-C++
para iOS e macOS, e C++ para Windows e Linux. Usando o embedder, código Flutter
pode ser integrado em uma aplicação existente como um módulo, ou o código pode
ser todo o conteúdo da aplicação. Flutter inclui vários embedders
para plataformas alvo comuns, mas [outros embedders também
existem](https://hover.build/blog/one-year-in/).

No núcleo do Flutter está o **Flutter engine**,
que é principalmente escrito em C++ e suporta
os primitivos necessários para suportar todas as aplicações Flutter.
A engine é responsável por rasterizar cenas compostas
sempre que um novo frame precisa ser pintado.
Ela fornece a implementação de baixo nível da API central do Flutter,
incluindo gráficos (através de [Impeller][] no iOS e chegando ao Android e macOS,
e [Skia][] em outras plataformas) layout de texto,
I/O de arquivo e rede, suporte de acessibilidade,
arquitetura de plugin, e um runtime Dart
e toolchain de compilação.

[Skia]: https://skia.org
[Impeller]: /perf/impeller

A engine é exposta ao framework Flutter através de
[`dart:ui`]({{site.repo.flutter}}/tree/main/engine/src/flutter/lib/ui),
que envolve o código C++ subjacente em classes Dart. Esta biblioteca
expõe os primitivos de mais baixo nível, como classes para dirigir entrada,
gráficos e subsistemas de renderização de texto.

Tipicamente, desenvolvedores interagem com Flutter através do **Flutter framework**,
que fornece um framework moderno e reativo escrito na linguagem Dart. Ele
inclui um rico conjunto de bibliotecas de plataforma, layout e fundamentais, composto de
uma série de camadas. Trabalhando de baixo para cima, temos:

- Classes **[fundamentais]({{site.api}}/flutter/foundation/foundation-library.html)**
  básicas, e serviços de blocos de construção como
  **[animation]({{site.api}}/flutter/animation/animation-library.html),
  [painting]({{site.api}}/flutter/painting/painting-library.html), e
  [gestures]({{site.api}}/flutter/gestures/gestures-library.html)** que oferecem
  abstrações comumente usadas sobre a fundação subjacente.
- A **[camada de renderização]({{site.api}}/flutter/rendering/rendering-library.html)** fornece uma
  abstração para lidar com layout. Com esta camada, você pode construir uma árvore de
  objetos renderizáveis. Você pode manipular esses objetos dinamicamente, com a
  árvore automaticamente atualizando o layout para refletir suas mudanças.
- A **[camada de widgets]({{site.api}}/flutter/widgets/widgets-library.html)** é
  uma abstração de composição. Cada render object na camada de renderização tem uma
  classe correspondente na camada de widgets. Além disso, a camada de widgets
  permite que você defina combinações de classes que você pode reutilizar. Esta é a
  camada em que o modelo de programação reativa é introduzido.
- As bibliotecas
  **[Material]({{site.api}}/flutter/material/material-library.html)**
  e
  **[Cupertino]({{site.api}}/flutter/cupertino/cupertino-library.html)**
  oferecem conjuntos abrangentes de controles que usam os primitivos de
  composição da camada de widgets para implementar as linguagens de design Material ou iOS.

O framework Flutter é relativamente pequeno; muitos recursos de alto nível que
desenvolvedores podem usar são implementados como pacotes, incluindo plugins de plataforma
como [camera]({{site.pub}}/packages/camera) e
[webview]({{site.pub}}/packages/webview_flutter), bem como recursos agnósticos de plataforma
como [characters]({{site.pub}}/packages/characters),
[http]({{site.pub}}/packages/http), e
[animations]({{site.pub}}/packages/animations) que se baseiam nas bibliotecas centrais Dart e
Flutter. Alguns desses pacotes vêm do ecossistema mais amplo,
cobrindo serviços como [pagamentos in-app]({{site.pub}}/packages/square_in_app_payments), [autenticação
Apple]({{site.pub}}/packages/sign_in_with_apple), e
[animações]({{site.pub}}/packages/lottie).

O resto desta visão geral navega amplamente pelas camadas, começando com o
paradigma reativo de desenvolvimento de UI. Então, descrevemos como widgets são compostos
juntos e convertidos em objetos que podem ser renderizados como parte de uma
aplicação. Descrevemos como Flutter interopera com outro código em um nível de
plataforma, antes de dar um breve resumo de como o suporte web do Flutter difere de
outros alvos.

## Anatomia de um app {:#anatomy-of-an-app}

O diagrama a seguir dá uma visão geral das peças
que compõem um app Flutter regular gerado por `flutter create`.
Ele mostra onde o Flutter Engine fica nesta stack,
destaca limites de API, e identifica os repositórios
onde as peças individuais vivem. A legenda abaixo esclarece
alguma da terminologia comumente usada para descrever as
peças de um app Flutter.

<img src='/assets/images/docs/app-anatomy.svg' alt='As camadas de um app Flutter criado por "flutter create": Dart app, framework, engine, embedder, runner'>

**Dart App**
* Compõe widgets na UI desejada.
* Implementa lógica de negócio.
* Propriedade do desenvolvedor do app.

**Framework** ([código fonte]({{site.repo.flutter}}/tree/main/packages/flutter/lib))
* Fornece API de alto nível para construir apps de alta qualidade
  (por exemplo, widgets, hit-testing, detecção de gestos,
  acessibilidade, entrada de texto).
* Compõe a árvore de widgets do app em uma cena.

**Engine** ([código fonte]({{site.repo.flutter}}/tree/main/engine/src/flutter/shell/common))
* Responsável por rasterizar cenas compostas.
* Fornece implementação de baixo nível das APIs centrais do Flutter
  (por exemplo, gráficos, layout de texto, runtime Dart).
* Expõe sua funcionalidade ao framework usando a **dart:ui API**.
* Integra com uma plataforma específica usando a **Embedder API** da Engine.

**Embedder** ([código fonte]({{site.repo.flutter}}/tree/main/engine/src/flutter/shell/platform))
* Coordena com o sistema operacional subjacente
  para acesso a serviços como superfícies de renderização,
  acessibilidade e entrada.
* Gerencia o loop de eventos.
* Expõe **API específica de plataforma** para integrar o Embedder em apps.

**Runner**
* Compõe as peças expostas pela
  API específica de plataforma do Embedder em um pacote de app executável na plataforma alvo.
* Parte do template de app gerado por `flutter create`,
  propriedade do desenvolvedor do app.

## Interfaces de usuário reativas

Na superfície, Flutter é [um framework de UI reativo e declarativo][faq],
no qual o desenvolvedor fornece um mapeamento do estado da aplicação para o estado da interface,
e o framework assume a tarefa de atualizar a interface em runtime
quando o estado da aplicação muda. Este modelo é inspirado por
[trabalho que veio do Facebook para seu próprio framework React][fb],
que inclui um repensar de muitos princípios de design tradicionais.

[faq]: /resources/faq#what-programming-paradigm-does-flutters-framework-use
[fb]: {{site.yt.watch}}?time_continue=2&v=x7cQ3mrcKaY&feature=emb_logo

Na maioria dos frameworks de UI tradicionais, o estado inicial da interface do usuário é
descrito uma vez e então atualizado separadamente pelo código do usuário em runtime, em resposta
a eventos. Um desafio desta abordagem é que, conforme a aplicação cresce em
complexidade, o desenvolvedor precisa estar ciente de como mudanças de estado cascateiam
por toda a UI. Por exemplo, considere a seguinte UI:

![Color picker dialog](/assets/images/docs/arch-overview/color-picker.png){:width="66%"}

Há muitos lugares onde o estado pode ser mudado: a caixa de cor, o
slider de matiz, os botões de rádio. Conforme o usuário interage com a UI, mudanças devem ser
refletidas em todos os outros lugares. Pior, a menos que haja cuidado,
uma mudança menor em uma parte da interface do usuário pode causar efeitos cascata em peças aparentemente não relacionadas
do código.

Uma solução para isso é uma abordagem como MVC, onde você empurra mudanças de dados para o
modelo através do controlador, e então o modelo empurra o novo estado para a view
através do controlador. No entanto, isso também é problemático, já que criar e
atualizar elementos de UI são dois passos separados que podem facilmente sair de sincronia.

Flutter, junto com outros frameworks reativos, adota uma abordagem alternativa para
este problema, desacoplando explicitamente a interface do usuário de seu
estado subjacente. Com APIs estilo React, você apenas cria a descrição da UI, e o
framework cuida de usar aquela configuração para criar e/ou
atualizar a interface do usuário conforme apropriado.

No Flutter, widgets (semelhantes a componentes no React) são representados por classes imutáveis
que são usadas para configurar uma árvore de objetos. Esses widgets são usados para
gerenciar uma árvore separada de objetos para layout, que é então usada para gerenciar uma
árvore separada de objetos para composição. Flutter é, em seu núcleo, uma série de
mecanismos para caminhar eficientemente pelas partes modificadas das árvores, convertendo árvores
de objetos em árvores de objetos de nível mais baixo, e propagando mudanças através
dessas árvores.

Um widget declara sua interface de usuário sobrescrevendo o método `build()`, que
é uma função que converte estado em UI:

```plaintext
UI = f(state)
```

O método `build()` é por design rápido para executar e deve ser livre de efeitos
colaterais, permitindo que seja chamado pelo framework sempre que necessário (potencialmente
tão frequentemente quanto uma vez por frame renderizado).

Esta abordagem depende de certas características de um runtime de linguagem (em
particular, instanciação e exclusão rápida de objetos). Felizmente, [Dart é
particularmente bem adequado para esta
tarefa]({{site.flutter-medium}}/flutter-dont-fear-the-garbage-collector-d69b3ff1ca30).

## Widgets

Como mencionado, Flutter enfatiza widgets como uma unidade de composição. Widgets são os
blocos de construção da interface de usuário de um app Flutter, e cada widget é uma
declaração imutável de parte da interface de usuário.

Widgets formam uma hierarquia baseada em composição. Cada widget aninha dentro de seu
pai e pode receber contexto do pai. Essa estrutura continua todo o
caminho até o widget raiz (o contêiner que hospeda o app Flutter, tipicamente
`MaterialApp` ou `CupertinoApp`), como este exemplo trivial mostra:

<?code-excerpt "lib/main.dart (main)"?>
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Home Page'),
        ),
        body: Center(
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  const Text('Hello World'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      print('Click!');
                    },
                    child: const Text('A button'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
```

No código anterior, todas as classes instanciadas são widgets.

Apps atualizam sua interface de usuário em resposta a eventos (como uma interação do
usuário) dizendo ao framework para substituir um widget na hierarquia por
outro widget. O framework então compara os novos e antigos widgets, e
eficientemente atualiza a interface do usuário.

Flutter tem suas próprias implementações de cada controle de UI, em vez de delegar para
aqueles fornecidos pelo sistema: por exemplo, há uma pura [implementação
Dart]({{site.api}}/flutter/cupertino/CupertinoSwitch-class.html) de ambos o
[controle Toggle do
iOS]({{site.apple-dev}}/design/human-interface-guidelines/toggles)
e [um para]({{site.api}}/flutter/material/Switch-class.html) o
[equivalente Android]({{site.material}}/components/switch).

Esta abordagem fornece vários benefícios:

- Fornece extensibilidade ilimitada. Um desenvolvedor que quer uma variante do
  controle Switch pode criar uma de qualquer maneira arbitrária, e não está limitado aos
  pontos de extensão fornecidos pelo SO.
- Evita um gargalo de desempenho significativo ao permitir que Flutter componha
  a cena inteira de uma vez, sem fazer transições de volta e adiante entre código Flutter
  e código de plataforma.
- Desacopla o comportamento da aplicação de quaisquer dependências do sistema operacional. A
  aplicação parece e se sente a mesma em todas as versões do SO, mesmo se o SO
  mudou as implementações de seus controles.

### Composição {:#composition}

Widgets são tipicamente compostos de muitos outros widgets pequenos e de propósito único que
se combinam para produzir efeitos poderosos.

Onde possível, o número de conceitos de design é mantido em um mínimo enquanto
permite que o vocabulário total seja grande. Por exemplo, na camada de widgets,
Flutter usa o mesmo conceito central (um `Widget`) para representar desenhar na
tela, layout (posicionamento e dimensionamento), interatividade do usuário, gerenciamento de estado,
tema, animações e navegação. Na camada de animação, um par de conceitos,
`Animation`s e `Tween`s, cobrem a maior parte do espaço de design. Na camada de renderização,
`RenderObject`s são usados para descrever layout, pintura, hit testing e
acessibilidade. Em cada um desses casos, o vocabulário correspondente acaba
sendo grande: há centenas de widgets e render objects, e dezenas de
tipos de animation e tween.

A hierarquia de classes é deliberadamente rasa e ampla para maximizar o número possível
de combinações, focando em widgets pequenos e combináveis que cada um faz uma
coisa bem. Recursos centrais são abstratos, com até recursos básicos como padding
e alinhamento sendo implementados como componentes separados em vez de serem construídos
no núcleo. (Isso também contrasta com APIs mais tradicionais onde recursos
como padding são construídos no núcleo comum de cada componente de layout.) Então, por
exemplo, para centralizar um widget, em vez de ajustar uma propriedade notional `Align`,
você o envolve em um widget [`Center`]({{site.api}}/flutter/widgets/Center-class.html).

Há widgets para padding, alinhamento, linhas, colunas e grids. Esses widgets de layout
não têm uma representação visual própria. Em vez disso, seu único
propósito é controlar algum aspecto do layout de outro widget. Flutter também
inclui widgets utilitários que aproveitam essa abordagem composicional.

Por exemplo, [`Container`]({{site.api}}/flutter/widgets/Container-class.html), um
widget comumente usado, é composto de vários widgets responsáveis por layout,
pintura, posicionamento e dimensionamento. Especificamente, Container é composto dos widgets
[`LimitedBox`]({{site.api}}/flutter/widgets/LimitedBox-class.html),
[`ConstrainedBox`]({{site.api}}/flutter/widgets/ConstrainedBox-class.html),
[`Align`]({{site.api}}/flutter/widgets/Align-class.html),
[`Padding`]({{site.api}}/flutter/widgets/Padding-class.html),
[`DecoratedBox`]({{site.api}}/flutter/widgets/DecoratedBox-class.html), e
[`Transform`]({{site.api}}/flutter/widgets/Transform-class.html), como você
pode ver lendo seu código fonte. Uma característica definidora do Flutter é que
você pode explorar o código fonte de qualquer widget e examiná-lo. Então, em vez
de fazer subclasse de `Container` para produzir um efeito customizado, você pode compô-lo
e outros widgets de formas novas, ou apenas criar um novo widget usando
`Container` como inspiração.

### Construindo widgets

Como mencionado anteriormente, você determina a representação visual de um widget
sobrescrevendo a função
[`build()`]({{site.api}}/flutter/widgets/StatelessWidget/build.html) para
retornar uma nova árvore de elementos. Esta árvore representa a parte do widget da interface do
usuário em termos mais concretos. Por exemplo, um widget de toolbar pode ter uma
função build que retorna um [layout
horizontal]({{site.api}}/flutter/widgets/Row-class.html) de algum
[texto]({{site.api}}/flutter/widgets/Text-class.html) e
[vários]({{site.api}}/flutter/material/IconButton-class.html)
[botões]({{site.api}}/flutter/material/PopupMenuButton-class.html). Conforme necessário,
o framework recursivamente pede a cada widget para construir até que a árvore seja inteiramente
descrita por [objetos renderizáveis
concretos]({{site.api}}/flutter/widgets/RenderObjectWidget-class.html). O
framework então une os objetos renderizáveis em uma árvore de objetos renderizáveis.

A função build de um widget deve ser livre de efeitos colaterais. Sempre que a função
é solicitada a construir, o widget deve retornar uma nova árvore de widgets[^1],
independentemente do que o widget retornou anteriormente. O
framework faz o trabalho pesado para determinar quais métodos build precisam ser
chamados com base na árvore de render object (descrito em mais detalhes posteriormente). Mais
informações sobre este processo podem ser encontradas no tópico [Inside Flutter
](/resources/inside-flutter#linear-reconciliation).

Em cada frame renderizado, Flutter pode recriar apenas as partes da UI onde o
estado mudou chamando o método `build()` daquele widget. Portanto é
importante que métodos build retornem rapidamente, e trabalho computacional pesado
deve ser feito de forma assíncrona e então armazenado como parte do estado
a ser usado por um método build.

Embora relativamente ingênua na abordagem, esta comparação automatizada é bastante
eficaz, habilitando apps interativos de alto desempenho. E, o design da
função build simplifica seu código ao focar em declarar do que um widget é
feito, em vez das complexidades de atualizar a interface do usuário de um
estado para outro.

### Estado de widget

O framework introduz duas classes principais de widget: widgets _stateful_ e _stateless_.

Muitos widgets não têm estado mutável: eles não têm quaisquer propriedades que mudam
ao longo do tempo (por exemplo, um ícone ou um rótulo). Esses widgets fazem subclasse de
[`StatelessWidget`]({{site.api}}/flutter/widgets/StatelessWidget-class.html).

No entanto, se as características únicas de um widget precisam mudar com base na interação do
usuário ou outros fatores, aquele widget é _stateful_. Por exemplo, se um
widget tem um contador que incrementa sempre que o usuário toca um botão, então o
valor do contador é o estado para aquele widget. Quando aquele valor muda, o
widget precisa ser reconstruído para atualizar sua parte da UI. Esses widgets fazem subclasse de
[`StatefulWidget`]({{site.api}}/flutter/widgets/StatefulWidget-class.html), e
(porque o widget em si é imutável) eles armazenam estado mutável em uma
classe separada que faz subclasse de [`State`]({{site.api}}/flutter/widgets/State-class.html).
`StatefulWidget`s não têm um método build; em vez disso, sua interface de usuário é
construída através de seu objeto `State`.

Sempre que você muta um objeto `State` (por exemplo, incrementando o contador),
você deve chamar [`setState()`]({{site.api}}/flutter/widgets/State/setState.html)
para sinalizar ao framework para atualizar a interface do usuário chamando o método `build` do `State`
novamente.

Ter objetos de state e widget separados permite que outros widgets tratem widgets stateless
e stateful exatamente da mesma forma, sem se preocupar em
perder estado. Em vez de precisar segurar um filho para preservar seu estado,
o pai pode criar uma nova instância do filho a qualquer momento sem perder o
estado persistente do filho. O framework faz todo o trabalho de encontrar e reutilizar
objetos de state existentes quando apropriado.

### Gerenciamento de estado {:#state-management}

Então, se muitos widgets podem conter estado, como o estado é gerenciado e passado pelo
sistema?

Como com qualquer outra classe,
você pode usar um construtor em um widget para inicializar seus dados,
então um método `build()` pode garantir que qualquer widget filho
seja instanciado com os dados que ele precisa:

```dart
@override
Widget build(BuildContext context) {
   return ContentWidget([!importantState!]);
}
```

Onde `importantState` é um placeholder para a classe
que contém o estado importante para o `Widget`.

Conforme árvores de widgets ficam mais profundas, no entanto,
passar informações de estado para cima e para baixo na
hierarquia de árvore se torna complicado.
Então, um terceiro tipo de widget, [`InheritedWidget`][],
fornece uma maneira fácil de pegar dados de um ancestral compartilhado.
Você pode usar `InheritedWidget` para criar um widget de estado
que envolve um ancestral comum na
árvore de widgets, como mostrado neste exemplo:

![Inherited widgets](/assets/images/docs/arch-overview/inherited-widget.png){:width="50%"}

[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html

Sempre que um dos objetos `ExamWidget` ou `GradeWidget` precisa de dados do
`StudentState`, ele agora pode acessá-lo com um comando como:

```dart
final studentState = StudentState.of(context);
```

A chamada `of(context)` pega o build context
(um handle para a localização atual do widget),
e retorna [o ancestral mais próximo na árvore][]
que corresponde ao tipo `StudentState`.
`InheritedWidget`s também oferecem um método `updateShouldNotify()`,
que Flutter chama para determinar se uma mudança de estado
deve disparar uma reconstrução de widgets filhos que o usam.

[o ancestral mais próximo na árvore]: {{site.api}}/flutter/widgets/BuildContext/dependOnInheritedWidgetOfExactType.html

O próprio Flutter usa `InheritedWidget` extensivamente como parte
do framework para estado compartilhado,
como o _tema visual_ da aplicação, que inclui
[propriedades como cor e estilos de tipo][] que são
pervasivas em toda uma aplicação.
O método `build()` de `MaterialApp` insere um tema
na árvore quando ela constrói, e então mais profundo na hierarquia um widget
pode usar o método `.of()` para buscar os dados relevantes do tema.

Por exemplo:

<?code-excerpt "lib/main.dart (container)"?>
```dart
Container(
  color: Theme.of(context).secondaryHeaderColor,
  child: Text(
    'Text with a background color',
    style: Theme.of(context).textTheme.titleLarge,
  ),
);
```

[propriedades como cor e estilos de tipo]: {{site.api}}/flutter/material/ThemeData-class.html

Conforme aplicações crescem, abordagens de gerenciamento de estado mais avançadas que reduzem a
cerimônia de criar e usar widgets stateful se tornam mais atraentes. Muitos
apps Flutter usam pacotes utilitários como
[provider]({{site.pub}}/packages/provider), que fornece um wrapper em torno de
`InheritedWidget`. A arquitetura em camadas do Flutter também habilita abordagens alternativas
para implementar a transformação de estado em UI, como o
pacote [flutter_hooks]({{site.pub}}/packages/flutter_hooks).

## Renderização e layout

Esta seção descreve o pipeline de renderização, que é a série de passos que
Flutter segue para converter uma hierarquia de widgets nos pixels reais pintados
em uma tela.

### Modelo de renderização do Flutter

Você pode estar se perguntando: se Flutter é um framework multiplataforma,
então como ele pode oferecer desempenho comparável a
frameworks de plataforma única?

É útil começar pensando sobre como apps
Android tradicionais funcionam. Ao desenhar,
você primeiro chama o código Java do framework Android.
As bibliotecas do sistema Android fornecem os componentes
responsáveis por desenhar a si mesmos em um objeto `Canvas`,
que Android pode então renderizar com [Skia][],
uma engine gráfica escrita em C/C++ que chama a
CPU ou GPU para completar o desenho no dispositivo.

Frameworks multiplataforma _tipicamente_ funcionam criando
uma camada de abstração sobre as bibliotecas de UI
Android e iOS nativas subjacentes, tentando suavizar as
inconsistências de cada representação de plataforma.
Código de app é frequentemente escrito em uma linguagem interpretada como JavaScript,
que deve por sua vez interagir com as bibliotecas de sistema
baseadas em Java do Android ou baseadas em Objective-C do iOS para exibir UI.
Tudo isso adiciona overhead que pode ser significativo,
particularmente onde há muita
interação entre a UI e a lógica do app.

Em contraste, Flutter minimiza essas abstrações,
pulando as bibliotecas de widget de UI do sistema em favor
de seu próprio conjunto de widgets. O código Dart que pinta
os visuais do Flutter é compilado para código nativo,
que usa Skia (ou, no futuro, Impeller) para renderização.
Flutter também incorpora sua própria cópia do Skia como parte da engine,
permitindo que o desenvolvedor atualize seu app para ficar
atualizado com as últimas melhorias de desempenho
mesmo se o telefone não foi atualizado com uma nova versão do Android.
O mesmo é verdade para Flutter em outras plataformas nativas,
como Windows ou macOS.

:::note
Flutter 3.10 definiu Impeller como a
engine de renderização padrão no iOS. Você pode visualizar
Impeller no Android atrás da flag `enable-impeller`.
Para mais informações, confira [Engine de renderização Impeller][Impeller].
:::

### Da entrada do usuário para a GPU

O princípio predominante que Flutter aplica ao seu
pipeline de renderização é que **simples é rápido**.
Flutter tem um pipeline direto para como dados fluem para
o sistema, como mostrado no seguinte diagrama de sequenciamento:

![Render pipeline sequencing
diagram](/assets/images/docs/arch-overview/render-pipeline.png){:width="100%"}

Vamos dar uma olhada em algumas dessas fases em maior detalhe.

### Build: de Widget para Element

Considere este fragmento de código que demonstra uma hierarquia de widgets:

<?code-excerpt "lib/main.dart (widget-hierarchy)"?>
```dart
Container(
  color: Colors.blue,
  child: Row(
    children: [
      Image.network('https://www.example.com/1.png'),
      const Text('A'),
    ],
  ),
);
```

Quando Flutter precisa renderizar este fragmento,
ele chama o método `build()`, que
retorna uma subárvore de widgets que renderiza
UI baseada no estado atual do app.
Durante este processo,
o método `build()` pode introduzir novos widgets,
conforme necessário, com base em seu estado.
Como exemplo, no fragmento de código anterior,
`Container` tem propriedades `color` e `child`.
Olhando o [código
fonte]({{site.repo.flutter}}/blob/02efffc134ab4ce4ff50a9ddd86c832efdb80462/packages/flutter/lib/src/widgets/container.dart#L401)
de `Container`, você pode ver que se a color não for null,
ele insere um `ColoredBox` representando a cor:

```dart
if (color != null)
  current = ColoredBox(color: color!, child: current);
```

Correspondentemente, os widgets `Image` e `Text` podem inserir widgets filhos como
`RawImage` e `RichText` durante o processo de build. A hierarquia eventual de widgets pode,
portanto, ser mais profunda do que o código representa,
como neste caso[^2]:

![Render pipeline sequencing
diagram](/assets/images/docs/arch-overview/widgets.png){:width="35%"}

Isso explica por que, quando você examina a árvore através de
uma ferramenta de debug como o
[Flutter inspector](/tools/devtools/inspector),
parte do Flutter/Dart DevTools,
você pode ver uma estrutura que é consideravelmente mais profunda do que o que
está em seu código original.

Durante a fase de build, Flutter traduz os widgets expressos em código em uma
**árvore de elementos** correspondente, com um elemento para cada widget. Cada elemento
representa uma instância específica de um widget em uma dada localização da hierarquia de
árvore. Há dois tipos básicos de elementos:

- `ComponentElement`, um host para outros elementos.
- `RenderObjectElement`, um elemento que participa nas fases de layout ou paint.

![Render pipeline sequencing
diagram](/assets/images/docs/arch-overview/widget-element.png){:width="85%"}

`RenderObjectElement`s são um intermediário entre seu análogo de widget e o
`RenderObject` subjacente, ao qual chegaremos mais tarde.

O elemento para qualquer widget pode ser referenciado através de seu `BuildContext`, que
é um handle para a localização de um widget na árvore. Este é o `context` em uma
chamada de função como `Theme.of(context)`, e é fornecido ao método `build()`
como um parâmetro.

Como widgets são imutáveis, incluindo o relacionamento pai/filho entre
nós, qualquer mudança na árvore de widgets (como mudar `Text('A')` para
`Text('B')` no exemplo anterior) causa um novo conjunto de objetos widget a serem
retornados. Mas isso não significa que a representação subjacente deve ser reconstruída.
A árvore de elementos é persistente de frame para frame, e portanto desempenha um
papel crítico de desempenho, permitindo que Flutter aja como se a hierarquia de widgets fosse
totalmente descartável enquanto cacheia sua representação subjacente. Ao caminhar apenas
pelos widgets que mudaram, Flutter pode reconstruir apenas as partes da
árvore de elementos que requerem reconfiguração.

### Layout e renderização {:#layout-and-rendering}

Seria uma aplicação rara que desenhasse apenas um único widget. Uma parte importante
de qualquer framework de UI é, portanto, a habilidade de fazer layout eficientemente de uma hierarquia
de widgets, determinando o tamanho e posição de cada elemento antes que sejam
renderizados na tela.

A classe base para cada nó na render tree é
[`RenderObject`]({{site.api}}/flutter/rendering/RenderObject-class.html), que
define um modelo abstrato para layout e pintura. Isso é extremamente geral: ele
não se compromete com um número fixo de dimensões ou mesmo um sistema de coordenadas
Cartesiano (demonstrado por [este exemplo de um sistema de coordenadas
polar]({{site.dartpad}}/?id=596b1d6331e3b9d7b00420085fab3e27)). Cada
`RenderObject` conhece seu pai, mas sabe pouco sobre seus filhos além de
como _visitá-los_ e suas constraints. Isso fornece ao `RenderObject`
abstração suficiente para ser capaz de lidar com uma variedade de casos de uso.

Durante a fase de build, Flutter cria ou atualiza um objeto que herda de
`RenderObject` para cada `RenderObjectElement` na árvore de elementos.
`RenderObject`s são primitivos:
[`RenderParagraph`]({{site.api}}/flutter/rendering/RenderParagraph-class.html)
renderiza texto,
[`RenderImage`]({{site.api}}/flutter/rendering/RenderImage-class.html) renderiza
uma imagem, e
[`RenderTransform`]({{site.api}}/flutter/rendering/RenderTransform-class.html)
aplica uma transformação antes de pintar seu filho.

![Diferenças entre a hierarquia de widgets e as árvores de element e render
](/assets/images/docs/arch-overview/trees.png){:width="100%"}

A maioria dos widgets Flutter são renderizados por um objeto que herda da
subclasse `RenderBox`, que representa um `RenderObject` de tamanho fixo em um espaço
Cartesiano 2D. `RenderBox` fornece a base de um _modelo de constraint de box_,
estabelecendo uma largura e altura mínima e máxima para cada widget a ser
renderizado.

Para executar o layout, Flutter caminha pela render tree em uma travessia depth-first e
**passa constraints de tamanho para baixo** de pai para filho. Ao determinar seu tamanho,
o filho _deve_ respeitar as constraints dadas a ele por seu pai. Filhos
respondem **passando um tamanho para cima** para seu objeto pai dentro das constraints
que o pai estabeleceu.

![Constraints vão para baixo, tamanhos vão para
cima](/assets/images/docs/arch-overview/constraints-sizes.png){:width="80%"}

No final desta única caminhada pela árvore, todo objeto tem um tamanho definido
dentro das constraints de seu pai e está pronto para ser pintado chamando o método
[`paint()`]({{site.api}}/flutter/rendering/RenderObject/paint.html).

O modelo de constraint de box é muito poderoso como uma forma de fazer layout de objetos em tempo _O(n)_:

- Pais podem ditar o tamanho de um objeto filho ao definir constraints máximas e mínimas
  para o mesmo valor. Por exemplo, o render object mais ao topo em um
  app de telefone restringe seu filho a ser do tamanho da tela. (Filhos podem
  escolher como usar aquele espaço. Por exemplo, eles podem apenas centralizar o que querem
  renderizar dentro das constraints ditadas.)
- Um pai pode ditar a largura do filho mas dar ao filho flexibilidade sobre
  altura (ou ditar altura mas oferecer flexibilidade sobre largura). Um exemplo do mundo real
  é texto fluido, que pode ter que caber em uma constraint horizontal mas variar
  verticalmente dependendo da quantidade de texto.

Este modelo funciona mesmo quando um objeto filho precisa saber quanto espaço ele tem
disponível para decidir como ele vai renderizar seu conteúdo. Ao usar um widget
[`LayoutBuilder`]({{site.api}}/flutter/widgets/LayoutBuilder-class.html),
o objeto filho pode examinar as constraints passadas e usá-las para
determinar como ele vai usá-las, por exemplo:

<?code-excerpt "lib/main.dart (layout-builder)"?>
```dart
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return const OneColumnLayout();
      } else {
        return const TwoColumnLayout();
      }
    },
  );
}
```

Mais informações sobre o sistema de constraint e layout,
junto com exemplos funcionais, podem ser encontradas no tópico
[Entendendo constraints](/ui/layout/constraints).

A raiz de todos os `RenderObject`s é o `RenderView`, que representa a saída total
da render tree. Quando a plataforma demanda que um novo frame seja renderizado
(por exemplo, por causa de um
[vsync](https://source.android.com/devices/graphics/implement-vsync) ou porque
uma descompressão/upload de textura está completa), uma chamada é feita ao método
`compositeFrame()`, que é parte do objeto `RenderView` na raiz
da render tree. Isso cria um `SceneBuilder` para disparar uma atualização da
cena. Quando a cena está completa, o objeto `RenderView` passa a cena composta
para o método `Window.render()` em `dart:ui`, que passa controle para a
GPU para renderizá-la.

Detalhes adicionais dos estágios de composição e rasterização do pipeline estão
além do escopo deste artigo de alto nível, mas mais informações podem ser encontradas
[nesta palestra sobre o pipeline de renderização Flutter]({{site.yt.watch}}?v=UUfXWzp0-DU).

## Platform embedding

Como vimos, em vez de serem traduzidas para os widgets equivalentes do SO,
interfaces de usuário Flutter são construídas, laid out, compostas e pintadas pelo próprio Flutter.
O mecanismo para obter a textura e participar do
ciclo de vida do app do sistema operacional subjacente inevitavelmente varia dependendo das
preocupações únicas daquela plataforma. A engine é agnóstica de plataforma, apresentando uma
[ABI estável (Application Binary
Interface)]({{site.repo.flutter}}/blob/main/engine/src/flutter/shell/platform/embedder/embedder.h)
que fornece a um _platform embedder_ uma forma de configurar e usar Flutter.

O platform embedder é a aplicação de SO nativa que hospeda todo o conteúdo Flutter,
e age como a cola entre o sistema operacional host e Flutter.
Quando você inicia um app Flutter, o embedder fornece o ponto de entrada, inicializa
a Flutter engine, obtém threads para UI e rastering, e cria uma textura
na qual Flutter pode escrever. O embedder também é responsável pelo
ciclo de vida do app, incluindo gestos de entrada (como mouse, teclado, toque), dimensionamento de janela,
gerenciamento de thread e mensagens de plataforma. Flutter inclui platform
embedders para Android, iOS, Windows, macOS e Linux; você também pode criar um
platform embedder customizado, como [neste exemplo
funcionando]({{site.github}}/chinmaygarde/fluttercast) que suporta remoting
de sessões Flutter através de um framebuffer estilo VNC ou [neste exemplo funcionando para
Raspberry Pi]({{site.github}}/ardera/flutter-pi).

Cada plataforma tem seu próprio conjunto de APIs e constraints. Algumas notas breves
específicas de plataforma:

- No iOS e macOS, Flutter é carregado no embedder como um `UIViewController`
  ou `NSViewController`, respectivamente. O platform embedder cria uma
  `FlutterEngine`, que serve como um host para a Dart VM e seu
  runtime Flutter, e um `FlutterViewController`, que se anexa à `FlutterEngine`
  para passar eventos de entrada UIKit ou Cocoa para Flutter e exibir frames
  renderizados pela `FlutterEngine` usando Metal ou OpenGL.
- No Android, Flutter é, por padrão, carregado no embedder como uma `Activity`.
  A view é controlada por uma
  [`FlutterView`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html),
  que renderiza conteúdo Flutter como uma view ou uma textura, dependendo da
  composição e requisitos de z-ordering do conteúdo Flutter.
- No Windows, Flutter é hospedado em um app Win32 tradicional, e conteúdo é
  renderizado usando
  [ANGLE](https://chromium.googlesource.com/angle/angle/+/master/README.md), uma
  biblioteca que traduz chamadas de API OpenGL para equivalentes DirectX 11.

## Integrando com outro código

Flutter fornece uma variedade de mecanismos de interoperabilidade, seja você acessando código ou APIs escritas em uma linguagem como Kotlin ou Swift, chamando uma
API nativa baseada em C, incorporando controles nativos em um app Flutter, ou incorporando
Flutter em uma aplicação existente.

### Platform channels

Para apps mobile e desktop, Flutter permite que você chame código customizado através de
um _platform channel_, que é um mecanismo para comunicação entre seu
código Dart e o código específico de plataforma do seu app host. Ao criar um
channel comum (encapsulando um nome e um codec), você pode enviar e receber mensagens
entre Dart e um componente de plataforma escrito em uma linguagem como Kotlin ou
Swift. Dados são serializados de um tipo Dart como `Map` para um formato padrão,
e então desserializados em uma representação equivalente em Kotlin (como
`HashMap`) ou Swift (como `Dictionary`).

![Como platform channels permitem que Flutter se comunique com código
host](/assets/images/docs/arch-overview/platform-channels.png){:width="70%"}

O seguinte é um exemplo curto de platform channel de uma chamada Dart para um handler de
evento receptor em Kotlin (Android) ou Swift (iOS):

<?code-excerpt "lib/main.dart (method-channel)"?>
```dart
// Dart side
const channel = MethodChannel('foo');
final greeting = await channel.invokeMethod('bar', 'world') as String;
print(greeting);
```

```kotlin
// Android (Kotlin)
val channel = MethodChannel(flutterView, "foo")
channel.setMethodCallHandler { call, result ->
  when (call.method) {
    "bar" -> result.success("Hello, ${call.arguments}")
    else -> result.notImplemented()
  }
}
```

```swift
// iOS (Swift)
let channel = FlutterMethodChannel(name: "foo", binaryMessenger: flutterView)
channel.setMethodCallHandler {
  (call: FlutterMethodCall, result: FlutterResult) -> Void in
  switch (call.method) {
    case "bar": result("Hello, \(call.arguments as! String)")
    default: result(FlutterMethodNotImplemented)
  }
}
```

Exemplos adicionais de uso de platform channels, incluindo exemplos para plataformas desktop,
podem ser encontrados no repositório [flutter/packages]({{site.repo.packages}}).
Também há [milhares de plugins
já disponíveis]({{site.pub}}/flutter) para Flutter que cobrem muitos
cenários comuns, variando de Firebase a ads a hardware de dispositivo como camera e
Bluetooth.

### Foreign Function Interface

Para APIs baseadas em C, incluindo aquelas que podem ser geradas para código escrito em
linguagens modernas como Rust ou Go, Dart fornece um mecanismo direto para binding
a código nativo usando a biblioteca `dart:ffi`. A foreign function interface
(FFI) pode ser consideravelmente mais rápida que platform channels, porque nenhuma
serialização é necessária para passar dados. Em vez disso, o runtime Dart fornece a
habilidade de alocar memória no heap que é apoiada por um objeto Dart e fazer
chamadas para bibliotecas linkadas estaticamente ou dinamicamente. FFI está disponível para todas as
plataformas exceto web, onde as [bibliotecas de interop JS][] e
[`package:web`][] servem um propósito similar.

Para usar FFI, você cria um `typedef` para cada uma das assinaturas de método
Dart e não gerenciadas, e instrui a Dart VM a mapear entre elas. Como exemplo,
aqui está um fragmento de código para chamar a API tradicional Win32 `MessageBox()`:

<?code-excerpt "lib/ffi.dart" remove="ignore:"?>
```dart
import 'dart:ffi';
import 'package:ffi/ffi.dart'; // contains .toNativeUtf16() extension method

typedef MessageBoxNative = Int32 Function(
  IntPtr hWnd,
  Pointer<Utf16> lpText,
  Pointer<Utf16> lpCaption,
  Int32 uType,
);

typedef MessageBoxDart = int Function(
  int hWnd,
  Pointer<Utf16> lpText,
  Pointer<Utf16> lpCaption,
  int uType,
);

void exampleFfi() {
  final user32 = DynamicLibrary.open('user32.dll');
  final messageBox =
      user32.lookupFunction<MessageBoxNative, MessageBoxDart>('MessageBoxW');

  final result = messageBox(
    0, // No owner window
    'Test message'.toNativeUtf16(), // Message
    'Window caption'.toNativeUtf16(), // Window title
    0, // OK button only
  );
}
```

[bibliotecas de interop JS]: {{site.dart-site}}/interop/js-interop
[`package:web`]: {{site.pub-pkg}}/web

### Renderizando controles nativos em um app Flutter

Como conteúdo Flutter é desenhado em uma textura e sua árvore de widgets é inteiramente
interna, não há lugar para algo como uma view Android existir dentro do
modelo interno do Flutter ou renderizar intercalado dentro de widgets Flutter. Isso é um
problema para desenvolvedores que gostariam de incluir componentes de plataforma existentes
em seus apps Flutter, como um controle de navegador.

Flutter resolve isso introduzindo widgets de platform view
([`AndroidView`]({{site.api}}/flutter/widgets/AndroidView-class.html)
e [`UiKitView`]({{site.api}}/flutter/widgets/UiKitView-class.html))
que permitem incorporar este tipo de conteúdo em cada plataforma. Platform views podem ser
integradas com outro conteúdo Flutter[^3]. Cada um
desses widgets age como um intermediário para o sistema operacional subjacente. Por
exemplo, no Android, `AndroidView` serve três funções primárias:

- Fazer uma cópia da textura gráfica renderizada pela view nativa e
  apresentá-la ao Flutter para composição como parte de uma superfície renderizada pelo Flutter
  cada vez que o frame é pintado.
- Responder a hit testing e gestos de entrada, e traduzir aqueles na
  entrada nativa equivalente.
- Criar um análogo da árvore de acessibilidade, e passar comandos e
  respostas entre as camadas nativa e Flutter.

Inevitavelmente, há uma certa quantidade de overhead associado a esta
sincronização. Em geral, portanto, esta abordagem é mais adequada para
controles complexos como Google Maps onde reimplementar em Flutter não é prático.

Tipicamente, um app Flutter instancia esses widgets em um método `build()` baseado
em um teste de plataforma. Como exemplo, do plugin
[google_maps_flutter]({{site.pub}}/packages/google_maps_flutter):

```dart
if (defaultTargetPlatform == TargetPlatform.android) {
  return AndroidView(
    viewType: 'plugins.flutter.io/google_maps',
    onPlatformViewCreated: onPlatformViewCreated,
    gestureRecognizers: gestureRecognizers,
    creationParams: creationParams,
    creationParamsCodec: const StandardMessageCodec(),
  );
} else if (defaultTargetPlatform == TargetPlatform.iOS) {
  return UiKitView(
    viewType: 'plugins.flutter.io/google_maps',
    onPlatformViewCreated: onPlatformViewCreated,
    gestureRecognizers: gestureRecognizers,
    creationParams: creationParams,
    creationParamsCodec: const StandardMessageCodec(),
  );
}
return Text(
    '$defaultTargetPlatform is not yet supported by the maps plugin');
```

Comunicação com o código nativo subjacente ao `AndroidView` ou `UiKitView`
tipicamente ocorre usando o mecanismo de platform channels, como descrito anteriormente.

No momento, platform views não estão disponíveis para plataformas desktop, mas isso não é
uma limitação arquitetural; suporte pode ser adicionado no futuro.

### Hospedando conteúdo Flutter em um app pai

O converso do cenário anterior é incorporar um widget Flutter em uma
aplicação Android ou iOS existente. Como descrito em uma seção anterior, um app Flutter recém-criado
rodando em um dispositivo mobile é hospedado em uma activity Android ou
`UIViewController` do iOS. Conteúdo Flutter pode ser incorporado em uma aplicação Android ou
iOS existente usando a mesma API de embedding.

O template de módulo Flutter é projetado para fácil embedding; você pode
incorporá-lo como uma dependência de código fonte em uma definição de build Gradle ou Xcode existente, ou
você pode compilá-lo em um Android Archive ou iOS Framework binário para uso
sem exigir que cada desenvolvedor tenha Flutter instalado.

A Flutter engine leva um curto período para inicializar, porque ela precisa carregar
bibliotecas compartilhadas do Flutter, inicializar o runtime Dart, criar e executar um
isolate Dart, e anexar uma superfície de renderização à UI. Para minimizar quaisquer atrasos de UI
ao apresentar conteúdo Flutter, é melhor inicializar a Flutter engine
durante a sequência geral de inicialização do app, ou pelo menos antes da primeira
tela Flutter, para que os usuários não experimentem uma pausa súbita enquanto o primeiro
código Flutter é carregado. Além disso, separar a Flutter engine permite que ela
seja reutilizada em múltiplas telas Flutter e compartilhe o overhead de memória envolvido
com o carregamento das bibliotecas necessárias.

Mais informações sobre como Flutter é carregado em um app Android ou iOS existente
podem ser encontradas no tópico [Load sequence, performance and memory
](/add-to-app/performance).

## Suporte para web Flutter

Enquanto os conceitos arquiteturais gerais se aplicam a todas as plataformas que Flutter
suporta, há algumas características únicas do suporte web do Flutter que
são dignas de comentário.

Dart tem compilado para JavaScript pelo tempo que a linguagem existe,
com uma toolchain otimizada para propósitos de desenvolvimento e produção. Muitos
apps importantes compilam de Dart para JavaScript e rodam em produção hoje,
incluindo a [ferramenta de anunciante para Google Ads](https://ads.google.com/home/).
Como o framework Flutter é escrito em Dart, compilá-lo para JavaScript foi
relativamente direto.

No entanto, a Flutter engine, escrita em C++,
é projetada para interagir com o
sistema operacional subjacente em vez de um navegador web.
Uma abordagem diferente é, portanto, necessária.
Na web, Flutter fornece uma reimplementação da
engine em cima de APIs padrão de navegador.
Atualmente temos duas opções para
renderizar conteúdo Flutter na web: HTML e WebGL.
No modo HTML, Flutter usa HTML, CSS, Canvas e SVG.
Para renderizar para WebGL, Flutter usa uma versão do Skia
compilada para WebAssembly chamada
[CanvasKit](https://skia.org/docs/user/modules/canvaskit/).
Enquanto o modo HTML oferece as melhores características de tamanho de código,
`CanvasKit` fornece o caminho mais rápido para a
stack gráfica do navegador,
e oferece fidelidade gráfica um pouco maior com os
alvos mobile nativos[^4].

A versão web do diagrama de camada arquitetural é a seguinte:

![Flutter web
architecture](/assets/images/docs/arch-overview/web-arch.png){:width="100%"}

Talvez a diferença mais notável comparada a outras plataformas nas quais Flutter
roda é que não há necessidade de Flutter fornecer um runtime Dart. Em vez disso,
o framework Flutter (junto com qualquer código que você escrever) é compilado para JavaScript.
Também é digno de nota que Dart tem muito poucas diferenças semânticas de linguagem
em todos os seus modos (JIT versus AOT, compilação nativa versus web), e a maioria dos
desenvolvedores nunca escreverá uma linha de código que encontre tal diferença.

Durante o tempo de desenvolvimento, Flutter web usa
[`dartdevc`]({{site.dart-site}}/tools/dartdevc), um compilador que suporta
compilação incremental e portanto permite hot restart (embora atualmente não
hot reload) para apps. Por outro lado, quando você está pronto para criar um app de produção
para web, [`dart2js`]({{site.dart-site}}/tools/dart2js), o compilador
JavaScript altamente otimizado de produção do Dart é usado, empacotando o núcleo Flutter
e framework junto com sua aplicação em um arquivo fonte minificado que
pode ser implantado em qualquer servidor web. Código pode ser oferecido em um único arquivo ou dividido
em múltiplos arquivos através de [deferred imports][].

[deferred imports]: {{site.dart-site}}/language/libraries#lazily-loading-a-library

## Informações adicionais

Para aqueles interessados em mais informações sobre os internos do Flutter, o
whitepaper [Inside Flutter](/resources/inside-flutter)
fornece um guia útil para a filosofia de design do framework.

[^1]: Enquanto o método `build` retorna uma árvore nova,
  você só precisa retornar algo _diferente_ se
  há alguma nova configuração para incorporar.
  Se a configuração é de fato a mesma,
  você pode apenas retornar o mesmo widget.
[^2]: Esta é uma simplificação leve para facilitar a leitura.
  Na prática, a árvore pode ser mais complexa.
[^3]: Há algumas limitações com esta abordagem, por exemplo,
  transparência não compõe da mesma forma para uma platform view como
  faria para outros widgets Flutter.
[^4]: Um exemplo são sombras, que têm que ser aproximadas com
  primitivos equivalentes de DOM ao custo de alguma fidelidade.
