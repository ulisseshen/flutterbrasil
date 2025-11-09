---
ia-translate: true
title: Visão geral da arquitetura do Flutter
description: >
  Uma visão geral de alto nível da arquitetura do Flutter,
  incluindo os princípios e conceitos fundamentais que formam seu design.
showBreadcrumbs: false
---

<?code-excerpt path-base="resources/architectural_overview/"?>

Este artigo tem como objetivo fornecer uma visão geral de alto nível da arquitetura do
Flutter, incluindo os princípios e conceitos fundamentais que formam seu design.
Se você está interessado em como arquitetar um app Flutter,
confira [Arquitetando apps Flutter][Architecting Flutter apps].

[Architecting Flutter apps]: /app-architecture

O Flutter é um toolkit de UI multiplataforma projetado para permitir a reutilização de código
entre sistemas operacionais como iOS, Android, web e desktop,
ao mesmo tempo que permite
que aplicações interajam diretamente com os serviços da plataforma subjacente.
O objetivo é permitir que os desenvolvedores entreguem apps de alto desempenho
que pareçam naturais em diferentes plataformas,
abraçando as diferenças onde elas existem enquanto compartilham o
máximo de código possível.

Durante o desenvolvimento, os apps Flutter executam em uma VM que oferece
hot reload com estado das mudanças sem a necessidade de uma recompilação completa.
Para release, os apps Flutter são compilados diretamente para código de máquina,
seja instruções Intel x64 ou ARM,
ou para JavaScript se o alvo for a web.
O framework é open source, com uma licença BSD permissiva,
e possui um ecossistema próspero de pacotes de terceiros que
complementam a funcionalidade da biblioteca principal.

Esta visão geral está dividida em várias seções:

1. O **modelo de camadas**: As peças com as quais o Flutter é construído.
1. **Interfaces de usuário reativas**: Um conceito fundamental para o desenvolvimento
   de interfaces de usuário no Flutter.
1. Uma introdução aos **widgets**: Os blocos de construção fundamentais
   das interfaces de usuário do Flutter.
1. O **processo de renderização**: Como o Flutter transforma código de UI em pixels.
1. Uma visão geral dos **embedders de plataforma**: O código que permite que
   sistemas operacionais móveis e desktop executem apps Flutter.
1. **Integrando Flutter com outro código**: Informações sobre
   diferentes técnicas disponíveis para apps Flutter.
1. **Suporte para web**: Observações finais sobre as características do
   Flutter em um ambiente de navegador.

## Camadas arquiteturais

O Flutter é projetado como um sistema extensível e em camadas. Ele existe como uma série de
bibliotecas independentes, cada uma dependendo da camada subjacente. Nenhuma camada tem
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

![Diagrama
arquitetural](/assets/images/docs/arch-overview/archdiagram.png){:width="100%"}

Para o sistema operacional subjacente, as aplicações Flutter são empacotadas da
mesma forma que qualquer outra aplicação nativa. Um embedder específico da plataforma fornece
um ponto de entrada; coordena com o sistema operacional subjacente para acesso a
serviços como superfícies de renderização, acessibilidade e entrada; e gerencia o
loop de eventos de mensagens. O embedder é escrito em uma linguagem apropriada
para a plataforma: atualmente Java e C++ para Android, Swift e
Objective-C/Objective-C++ para iOS e macOS,
e C++ para Windows e Linux. Usando o embedder, o código Flutter
pode ser integrado em uma aplicação existente como um módulo,
ou o código pode ser o conteúdo inteiro da aplicação.
O Flutter inclui vários embedders
para plataformas-alvo comuns, mas outros embedders também
existem.

No núcleo do Flutter está o **Flutter engine**,
que é escrito principalmente em C++ e suporta
os primitivos necessários para suportar todas as aplicações Flutter.
O engine é responsável por rasterizar cenas compostas
sempre que um novo frame precisa ser pintado.
Ele fornece a implementação de baixo nível da API principal do Flutter,
incluindo gráficos (através do [Impeller][]
no iOS, Android e desktop (atrás de uma flag),
e [Skia][] em outras plataformas), layout de texto,
I/O de arquivo e rede, suporte de acessibilidade,
arquitetura de plugin e um runtime Dart
e toolchain de compilação.

:::note
Se você tem uma dúvida sobre quais dispositivos suportam
Impeller, confira [Can I use Impeller?][]
para informações detalhadas.
:::

[Can I use Impeller?]: {{site.main-url}}/go/can-i-use-impeller
[Skia]: https://skia.org
[Impeller]: /perf/impeller

O engine é exposto ao framework Flutter através do
[`dart:ui`]({{site.repo.flutter}}/tree/main/engine/src/flutter/lib/ui),
que envolve o código C++ subjacente em classes Dart. Esta biblioteca
expõe os primitivos de nível mais baixo, como classes para conduzir entrada,
gráficos e subsistemas de renderização de texto.

Normalmente, os desenvolvedores interagem com o Flutter através do **Flutter framework**,
que fornece um framework moderno e reativo escrito na linguagem Dart. Ele
inclui um rico conjunto de bibliotecas de plataforma, layout e fundação, compostas de
uma série de camadas. Trabalhando de baixo para cima, temos:

* Classes **[foundational]({{site.api}}/flutter/foundation/foundation-library.html)**
  básicas e serviços de blocos de construção como
  **[animation]({{site.api}}/flutter/animation/animation-library.html),
  [painting]({{site.api}}/flutter/painting/painting-library.html) e
  [gestures]({{site.api}}/flutter/gestures/gestures-library.html)** que oferecem
  abstrações comumente usadas sobre a fundação subjacente.
* A **[camada de renderização]({{site.api}}/flutter/rendering/rendering-library.html)**
  fornece uma abstração para lidar com layout. Com esta camada, você pode construir uma árvore de
  objetos renderizáveis. Você pode manipular esses objetos dinamicamente, com a
  árvore atualizando automaticamente o layout para refletir suas mudanças.
* A **[camada de widgets]({{site.api}}/flutter/widgets/widgets-library.html)** é
  uma abstração de composição. Cada objeto de renderização na camada de renderização tem uma
  classe correspondente na camada de widgets. Além disso, a camada de widgets
  permite que você defina combinações de classes que você pode reutilizar. Esta é a
  camada na qual o modelo de programação reativa é introduzido.
* As bibliotecas
  **[Material]({{site.api}}/flutter/material/material-library.html)**
  e
  **[Cupertino]({{site.api}}/flutter/cupertino/cupertino-library.html)**
  oferecem conjuntos abrangentes de controles que usam os primitivos de
  composição da camada de widgets para implementar as linguagens de design Material ou iOS.

O framework Flutter é relativamente pequeno; muitos recursos de nível superior que
os desenvolvedores podem usar são implementados como pacotes, incluindo plugins de plataforma
como [camera]({{site.pub}}/packages/camera) e
[webview]({{site.pub}}/packages/webview_flutter), bem como recursos agnósticos de plataforma
como [characters]({{site.pub}}/packages/characters),
[http]({{site.pub}}/packages/http) e
[animations]({{site.pub}}/packages/animations) que constroem sobre as bibliotecas principais do Dart e
Flutter. Alguns desses pacotes vêm do ecossistema mais amplo,
cobrindo serviços como [pagamentos
in-app]({{site.pub}}/packages/square_in_app_payments), [autenticação
Apple]({{site.pub}}/packages/sign_in_with_apple) e
[animações]({{site.pub}}/packages/lottie).

O restante desta visão geral navega amplamente pelas camadas, começando com o
paradigma reativo de desenvolvimento de UI. Em seguida, descrevemos como os widgets são compostos
juntos e convertidos em objetos que podem ser renderizados como parte de uma
aplicação. Descrevemos como o Flutter interopera com outro código em um nível de
plataforma, antes de dar um breve resumo de como o suporte web do Flutter difere de
outros alvos.

## Anatomia de um app {:#anatomy-of-an-app}

O diagrama a seguir dá uma visão geral das peças
que compõem um app Flutter regular gerado por `flutter create`.
Ele mostra onde o Flutter Engine se encaixa nesta pilha,
destaca limites de API e identifica os repositórios
onde as peças individuais estão. A legenda abaixo esclarece
parte da terminologia comumente usada para descrever as
peças de um app Flutter.

<img src='/assets/images/docs/app-anatomy.svg' alt='As camadas de um app Flutter criado por "flutter create": Dart app, framework, engine, embedder, runner'>

**Dart App**
* Compõe widgets na UI desejada.
* Implementa lógica de negócios.
* De propriedade do desenvolvedor do app.

**Framework** ([código-fonte]({{site.repo.flutter}}/tree/main/packages/flutter/lib))
* Fornece API de nível superior para construir apps de alta qualidade
  (por exemplo, widgets, hit-testing, detecção de gestos,
  acessibilidade, entrada de texto).
* Compõe a árvore de widgets do app em uma cena.

**Engine** ([código-fonte]({{site.repo.flutter}}/tree/main/engine/src/flutter/shell/common))
* Responsável por rasterizar cenas compostas.
* Fornece implementação de baixo nível das APIs principais do Flutter
  (por exemplo, gráficos, layout de texto, runtime Dart).
* Expõe sua funcionalidade ao framework usando a **API dart:ui**.
* Integra-se com uma plataforma específica usando a **API Embedder** do Engine.

**Embedder** ([código-fonte]({{site.repo.flutter}}/tree/main/engine/src/flutter/shell/platform))
* Coordena com o sistema operacional subjacente
  para acesso a serviços como superfícies de renderização,
  acessibilidade e entrada.
* Gerencia o loop de eventos.
* Expõe **API específica da plataforma** para integrar o Embedder em apps.

**Runner**
* Compõe as peças expostas pela
  API específica da plataforma do Embedder em um pacote de app executável na plataforma-alvo.
* Parte do template de app gerado por `flutter create`,
  de propriedade do desenvolvedor do app.

## Interfaces de usuário reativas

Na superfície, o Flutter é [um framework de UI reativo e declarativo][faq],
no qual o desenvolvedor fornece um mapeamento do estado da aplicação para o estado da interface,
e o framework assume a tarefa de atualizar a interface em tempo de execução
quando o estado da aplicação muda. Este modelo é inspirado por
[trabalho que veio do Facebook para seu próprio framework React][fb],
que inclui uma reformulação de muitos princípios de design tradicionais.

[faq]: /resources/faq#what-programming-paradigm-does-flutters-framework-use
[fb]: {{site.yt.watch}}?time_continue=2&v=x7cQ3mrcKaY&feature=emb_logo

Na maioria dos frameworks de UI tradicionais, o estado inicial da interface do usuário é
descrito uma vez e então atualizado separadamente pelo código do usuário em tempo de execução, em resposta
a eventos. Um desafio dessa abordagem é que, conforme a aplicação cresce em
complexidade, o desenvolvedor precisa estar ciente de como as mudanças de estado se espalham
por toda a UI. Por exemplo, considere a seguinte UI:

![Diálogo de seleção de cores](/assets/images/docs/arch-overview/color-picker.png){:width="66%"}

Há muitos lugares onde o estado pode ser alterado: a caixa de cores, o controle
deslizante de matiz, os botões de rádio. Conforme o usuário interage com a UI, as mudanças devem ser
refletidas em todos os outros lugares. Pior ainda, a menos que se tome cuidado, uma pequena mudança em
uma parte da interface do usuário pode causar efeitos cascata em partes aparentemente não relacionadas
do código.

Uma solução para isso é uma abordagem como MVC, onde você envia mudanças de dados para o
modelo através do controlador, e então o modelo envia o novo estado para a visualização
através do controlador. No entanto, isso também é problemático, pois criar e
atualizar elementos de UI são duas etapas separadas que podem facilmente ficar fora de sincronia.

O Flutter, juntamente com outros frameworks reativos, adota uma abordagem alternativa para
este problema, desacoplando explicitamente a interface do usuário de seu estado
subjacente. Com APIs no estilo React, você apenas cria a descrição da UI, e o
framework cuida de usar essa configuração para criar e/ou
atualizar a interface do usuário conforme apropriado.

No Flutter, widgets (semelhantes a componentes no React) são representados por classes imutáveis
que são usadas para configurar uma árvore de objetos. Esses widgets são usados para
gerenciar uma árvore separada de objetos para layout, que é então usada para gerenciar uma
árvore separada de objetos para composição. O Flutter é, em seu núcleo, uma série de
mecanismos para percorrer eficientemente as partes modificadas das árvores, convertendo árvores
de objetos em árvores de objetos de nível inferior e propagando mudanças através
dessas árvores.

Um widget declara sua interface de usuário substituindo o método `build()`, que
é uma função que converte estado em UI:

```plaintext
UI = f(state)
```

O método `build()` é por design rápido de executar e deve estar livre de efeitos
colaterais, permitindo que seja chamado pelo framework sempre que necessário (potencialmente
tão frequentemente quanto uma vez por frame renderizado).

Esta abordagem depende de certas características de um runtime de linguagem (em
particular, instanciação e exclusão rápidas de objetos). Felizmente, [Dart é
particularmente adequado para esta
tarefa]({{site.flutter-blog}}/flutter-dont-fear-the-garbage-collector-d69b3ff1ca30).

## Widgets

Como mencionado, o Flutter enfatiza widgets como uma unidade de composição. Widgets são
os blocos de construção da interface de usuário de um app Flutter, e cada widget é uma
declaração imutável de parte da interface de usuário.

Os widgets formam uma hierarquia baseada em composição. Cada widget se aninha dentro de seu
pai e pode receber contexto do pai. Esta estrutura se estende até
o widget raiz (o contêiner que hospeda o app Flutter, tipicamente
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
        appBar: AppBar(title: const Text('My Home Page')),
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

Os apps atualizam sua interface de usuário em resposta a eventos (como uma interação
do usuário) dizendo ao framework para substituir um widget na hierarquia por
outro widget. O framework então compara os widgets novos e antigos, e
atualiza eficientemente a interface do usuário.

O Flutter tem suas próprias implementações de cada controle de UI, em vez de delegar para
aqueles fornecidos pelo sistema: por exemplo, há uma [implementação pura em
Dart]({{site.api}}/flutter/cupertino/CupertinoSwitch-class.html)
tanto do [controle Toggle do
iOS]({{site.apple-dev}}/design/human-interface-guidelines/toggles)
quanto do [equivalente para]({{site.api}}/flutter/material/Switch-class.html) o
[Android]({{site.material}}/components/switch).

Esta abordagem oferece vários benefícios:

* Fornece extensibilidade ilimitada. Um desenvolvedor que deseja uma variante do
  controle Switch pode criar uma de qualquer maneira arbitrária, e não está limitado aos
  pontos de extensão fornecidos pelo SO.
* Evita um gargalo de desempenho significativo ao permitir que o Flutter componha
  a cena inteira de uma vez, sem fazer transições de ida e volta entre o código Flutter
  e o código da plataforma.
* Desacopla o comportamento da aplicação de quaisquer dependências do sistema operacional. A
  aplicação tem a mesma aparência e sensação em todas as versões do SO, mesmo se o SO
  mudou as implementações de seus controles.

### Composição {:#composition}

Os widgets são tipicamente compostos de muitos outros widgets pequenos e de propósito único que
se combinam para produzir efeitos poderosos.

Quando possível, o número de conceitos de design é mantido ao mínimo enquanto
permite que o vocabulário total seja grande. Por exemplo, na camada de widgets,
o Flutter usa o mesmo conceito central (um `Widget`) para representar desenho na
tela, layout (posicionamento e dimensionamento), interatividade do usuário, gerenciamento de estado,
temas, animações e navegação. Na camada de animação, um par de conceitos,
`Animation`s e `Tween`s, cobrem a maior parte do espaço de design. Na camada de renderização,
`RenderObject`s são usados para descrever layout, pintura, teste de hit e
acessibilidade. Em cada um desses casos, o vocabulário correspondente acaba
sendo grande: há centenas de widgets e objetos de renderização, e dezenas de
tipos de animação e tween.

A hierarquia de classes é deliberadamente rasa e ampla para maximizar o número possível
de combinações, concentrando-se em widgets pequenos e compostos que cada um faz uma
coisa bem. Os recursos principais são abstratos, com até mesmo recursos básicos como padding
e alinhamento sendo implementados como componentes separados em vez de serem integrados
ao núcleo. (Isso também contrasta com APIs mais tradicionais onde recursos
como padding são integrados ao núcleo comum de cada componente de layout.) Então, por
exemplo, para centralizar um widget, em vez de ajustar uma propriedade nocional `Align`,
você o envolve em um widget [`Center`]({{site.api}}/flutter/widgets/Center-class.html).

Existem widgets para padding, alinhamento, linhas, colunas e grades. Esses widgets de layout
não têm uma representação visual própria. Em vez disso, seu único
propósito é controlar algum aspecto do layout de outro widget. O Flutter também
inclui widgets utilitários que aproveitam essa abordagem de composição.

Por exemplo, [`Container`]({{site.api}}/flutter/widgets/Container-class.html), um
widget comumente usado, é composto de vários widgets responsáveis por layout,
pintura, posicionamento e dimensionamento. Especificamente, `Container` é composto de
[`LimitedBox`]({{site.api}}/flutter/widgets/LimitedBox-class.html),
[`ConstrainedBox`]({{site.api}}/flutter/widgets/ConstrainedBox-class.html),
[`Align`]({{site.api}}/flutter/widgets/Align-class.html),
[`Padding`]({{site.api}}/flutter/widgets/Padding-class.html),
[`DecoratedBox`]({{site.api}}/flutter/widgets/DecoratedBox-class.html) e
[`Transform`]({{site.api}}/flutter/widgets/Transform-class.html), como você
pode ver lendo seu código-fonte. Uma característica definitiva do Flutter é que
você pode mergulhar no código-fonte de qualquer widget e examiná-lo. Então, em vez
de fazer subclasse de `Container` para produzir um efeito customizado, você pode compô-lo
e outros widgets de maneiras novas, ou apenas criar um novo widget usando
`Container` como inspiração.

### Construindo widgets

Como mencionado anteriormente, você determina a representação visual de um widget
substituindo a função
[`build()`]({{site.api}}/flutter/widgets/StatelessWidget/build.html) para
retornar uma nova árvore de elementos. Esta árvore representa a parte do widget da interface
do usuário em termos mais concretos. Por exemplo, um widget de barra de ferramentas pode ter uma
função build que retorna um [layout
horizontal]({{site.api}}/flutter/widgets/Row-class.html) de algum
[texto]({{site.api}}/flutter/widgets/Text-class.html) e
[vários]({{site.api}}/flutter/material/IconButton-class.html)
[botões]({{site.api}}/flutter/material/PopupMenuButton-class.html). Conforme necessário,
o framework pede recursivamente a cada widget para construir até que a árvore seja inteiramente
descrita por [objetos renderizáveis
concretos]({{site.api}}/flutter/widgets/RenderObjectWidget-class.html). O
framework então une os objetos renderizáveis em uma árvore de objetos renderizáveis.

A função build de um widget deve estar livre de efeitos colaterais. Sempre que a função
é solicitada a construir, o widget deve retornar uma nova árvore de widgets[^1],
independentemente do que o widget retornou anteriormente. O
framework faz o trabalho pesado para determinar quais métodos build precisam ser
chamados com base na árvore de objetos de renderização (descrita em mais detalhes posteriormente). Mais
informações sobre este processo podem ser encontradas no tópico [Inside Flutter
](/resources/inside-flutter#linear-reconciliation).

Em cada frame renderizado, o Flutter pode recriar apenas as partes da UI onde o
estado mudou chamando o método `build()` daquele widget. Portanto, é
importante que os métodos build retornem rapidamente, e o trabalho computacional pesado
deve ser feito de maneira assíncrona e então armazenado como parte do estado
para ser usado por um método build.

Embora relativamente ingênua na abordagem, essa comparação automatizada é bastante
eficaz, permitindo apps interativos de alto desempenho. E o design da
função build simplifica seu código concentrando-se em declarar do que um widget é
feito, em vez das complexidades de atualizar a interface do usuário de um
estado para outro.

### Estado do widget

O framework introduz duas classes principais de widget: widgets _stateful_ e _stateless_.

Muitos widgets não têm estado mutável: eles não têm propriedades que mudam
ao longo do tempo (por exemplo, um ícone ou um rótulo). Esses widgets fazem subclasse de
[`StatelessWidget`]({{site.api}}/flutter/widgets/StatelessWidget-class.html).

No entanto, se as características únicas de um widget precisam mudar com base na interação
do usuário ou outros fatores, esse widget é _stateful_. Por exemplo, se um
widget tem um contador que incrementa sempre que o usuário toca em um botão, então o
valor do contador é o estado para aquele widget. Quando esse valor muda, o
widget precisa ser reconstruído para atualizar sua parte da UI. Esses widgets fazem subclasse de
[`StatefulWidget`]({{site.api}}/flutter/widgets/StatefulWidget-class.html), e
(porque o widget em si é imutável) eles armazenam estado mutável em uma
classe separada que faz subclasse de [`State`]({{site.api}}/flutter/widgets/State-class.html).
`StatefulWidget`s não têm um método build; em vez disso, sua interface de usuário é
construída através de seu objeto `State`.

Sempre que você muta um objeto `State` (por exemplo, incrementando o contador),
você deve chamar [`setState()`]({{site.api}}/flutter/widgets/State/setState.html)
para sinalizar ao framework para atualizar a interface do usuário chamando o método
build do `State` novamente.

Ter objetos de estado e widget separados permite que outros widgets tratem widgets stateless
e stateful exatamente da mesma maneira, sem se preocupar em perder o estado. Em vez de precisar se agarrar a um filho para preservar seu estado,
o pai pode criar uma nova instância do filho a qualquer momento sem perder o
estado persistente do filho. O framework faz todo o trabalho de encontrar e reutilizar
objetos de estado existentes quando apropriado.

### Gerenciamento de estado {:#state-management}

Então, se muitos widgets podem conter estado, como o estado é gerenciado e passado pelo
sistema?

Como com qualquer outra classe,
você pode usar um construtor em um widget para inicializar seus dados,
então um método `build()` pode garantir que qualquer widget filho
seja instanciado com os dados de que precisa:

```dart
@override
Widget build(BuildContext context) {
   return ContentWidget([!importantState!]);
}
```

Onde `importantState` é um placeholder para a classe
que contém o estado importante para o `Widget`.

Conforme as árvores de widgets ficam mais profundas, no entanto,
passar informações de estado para cima e para baixo na
hierarquia de árvores se torna complicado.
Então, um terceiro tipo de widget, [`InheritedWidget`][],
fornece uma maneira fácil de obter dados de um ancestral compartilhado.
Você pode usar `InheritedWidget` para criar um widget de estado
que envolve um ancestral comum na
árvore de widgets, como mostrado neste exemplo:

![Widgets herdados](/assets/images/docs/arch-overview/inherited-widget.png){:width="50%" .diagram-wrap}

[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html

Sempre que um dos objetos `ExamWidget` ou `GradeWidget` precisa de dados de
`StudentState`, ele agora pode acessá-los com um comando como:

```dart
final studentState = StudentState.of(context);
```

A chamada `of(context)` pega o contexto de build
(um identificador para a localização atual do widget),
e retorna [o ancestral mais próximo na árvore][the nearest ancestor in the tree]
que corresponde ao tipo `StudentState`.
`InheritedWidget`s também oferecem um método `updateShouldNotify()`,
que o Flutter chama para determinar se uma mudança de estado
deve acionar uma reconstrução de widgets filhos que o usam.

[the nearest ancestor in the tree]: {{site.api}}/flutter/widgets/BuildContext/dependOnInheritedWidgetOfExactType.html

O próprio Flutter usa `InheritedWidget` extensivamente como parte
do framework para estado compartilhado,
como o _tema visual_ da aplicação, que inclui
[propriedades como cor e estilos de tipo][properties like color and type styles] que são
pervasivos em toda a aplicação.
O método `build()` do `MaterialApp` insere um tema
na árvore quando ele constrói, e então mais profundamente na hierarquia um widget
pode usar o método `.of()` para procurar os dados de tema relevantes.

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

[properties like color and type styles]: {{site.api}}/flutter/material/ThemeData-class.html

À medida que as aplicações crescem, abordagens mais avançadas de gerenciamento de estado que reduzem a
cerimônia de criar e usar widgets stateful se tornam mais atraentes. Muitos
apps Flutter usam pacotes utilitários como
[provider]({{site.pub}}/packages/provider), que fornece um wrapper em torno de
`InheritedWidget`. A arquitetura em camadas do Flutter também permite abordagens alternativas
para implementar a transformação de estado em UI, como o pacote
[flutter_hooks]({{site.pub}}/packages/flutter_hooks).

## Renderização e layout

Esta seção descreve o pipeline de renderização, que é a série de etapas que
o Flutter executa para converter uma hierarquia de widgets nos pixels reais pintados
em uma tela.

### Modelo de renderização do Flutter

Você pode estar se perguntando: se o Flutter é um framework multiplataforma,
então como ele pode oferecer desempenho comparável a
frameworks de plataforma única?

É útil começar pensando em como os apps Android tradicionais
funcionam. Ao desenhar,
você primeiro chama o código Java do framework Android.
As bibliotecas do sistema Android fornecem os componentes
responsáveis por se desenhar em um objeto `Canvas`,
que o Android pode então renderizar com [Skia][],
um motor gráfico escrito em C/C++ que chama a
CPU ou GPU para completar o desenho no dispositivo.

Frameworks multiplataforma _normalmente_ funcionam criando
uma camada de abstração sobre as bibliotecas de UI nativas
subjacentes do Android e iOS, tentando suavizar as
inconsistências de cada representação de plataforma.
O código do app é frequentemente escrito em uma linguagem interpretada como JavaScript,
que deve por sua vez interagir com as bibliotecas de sistema
baseadas em Java do Android ou Objective-C do iOS para exibir UI.
Tudo isso adiciona overhead que pode ser significativo,
particularmente onde há muita
interação entre a UI e a lógica do app.

Em contraste, o Flutter minimiza essas abstrações,
ignorando as bibliotecas de widget de UI do sistema em favor
de seu próprio conjunto de widgets. O código Dart que pinta
os visuais do Flutter é compilado em código nativo,
que usa Impeller para renderização.
O Impeller é enviado junto com a aplicação,
permitindo que o desenvolvedor atualize seu app para se manter
atualizado com as últimas melhorias de desempenho
mesmo que o telefone não tenha sido atualizado com uma nova versão do Android.
O mesmo é verdade para o Flutter em outras plataformas nativas,
como Windows ou macOS.

:::note
Se você quer saber quais dispositivos o Impeller suporta,
confira [Can I use Impeller?][].
Para mais informações,
visite [Motor de renderização Impeller][Impeller rendering engine]
:::

[Impeller rendering engine]: /perf/impeller

### Da entrada do usuário à GPU

O princípio primordial que o Flutter aplica ao seu
pipeline de renderização é que **simples é rápido**.
O Flutter tem um pipeline direto para como os dados fluem para
o sistema, como mostrado no seguinte diagrama de sequência:

![Diagrama de sequência do pipeline de renderização](/assets/images/docs/arch-overview/render-pipeline.png){:width="100%" .diagram-wrap}

Vamos dar uma olhada em algumas dessas fases com mais detalhes.

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

Quando o Flutter precisa renderizar este fragmento,
ele chama o método `build()`, que
retorna uma subárvore de widgets que renderiza
UI baseada no estado atual do app.
Durante este processo,
o método `build()` pode introduzir novos widgets,
conforme necessário, com base em seu estado.
Como exemplo, no fragmento de código anterior,
`Container` tem propriedades `color` e `child`.
Ao olhar o [código-fonte]({{site.repo.flutter}}/blob/02efffc134ab4ce4ff50a9ddd86c832efdb80462/packages/flutter/lib/src/widgets/container.dart#L401)
de `Container`, você pode ver que se a cor não for nula,
ele insere um `ColoredBox` representando a cor:

```dart
if (color != null)
  current = ColoredBox(color: color!, child: current);
```

Correspondentemente, os widgets `Image` e `Text` podem inserir widgets filhos como
`RawImage` e `RichText` durante o processo de build. A hierarquia de widgets
eventual pode, portanto, ser mais profunda do que o código representa,
como neste caso[^2]:

![Diagrama de sequência do pipeline de renderização](/assets/images/docs/arch-overview/widgets.png){:width="40%" .diagram-wrap}

Isso explica por que, quando você examina a árvore através
de uma ferramenta de depuração como o
[Flutter inspector](/tools/devtools/inspector),
parte do Flutter/Dart DevTools,
você pode ver uma estrutura que é consideravelmente mais profunda do que o
que está em seu código original.

Durante a fase de build, o Flutter traduz os widgets expressos em código em uma
**árvore de elementos** correspondente, com um elemento para cada widget. Cada elemento
representa uma instância específica de um widget em um determinado local da hierarquia
da árvore. Existem dois tipos básicos de elementos:

- `ComponentElement`, um hospedeiro para outros elementos.
- `RenderObjectElement`, um elemento que participa das fases de layout ou pintura.

![Diagrama de sequência do pipeline de renderização](/assets/images/docs/arch-overview/widget-element.png){:width="85%" .diagram-wrap}

`RenderObjectElement`s são um intermediário entre seu análogo de widget e o
`RenderObject` subjacente, ao qual chegaremos mais tarde.

O elemento de qualquer widget pode ser referenciado através de seu `BuildContext`, que
é um identificador para a localização de um widget na árvore. Este é o `context` em uma
chamada de função como `Theme.of(context)`, e é fornecido ao método `build()`
como um parâmetro.

Como os widgets são imutáveis, incluindo a relação pai/filho entre
nós, qualquer mudança na árvore de widgets (como mudar `Text('A')` para
`Text('B')` no exemplo anterior) faz com que um novo conjunto de objetos de widget seja
retornado. Mas isso não significa que a representação subjacente deve ser reconstruída.
A árvore de elementos é persistente de frame para frame, e portanto desempenha um
papel crítico de desempenho, permitindo que o Flutter aja como se a hierarquia de widgets fosse
totalmente descartável enquanto armazena em cache sua representação subjacente. Ao percorrer apenas
os widgets que mudaram, o Flutter pode reconstruir apenas as partes da
árvore de elementos que requerem reconfiguração.

### Layout e renderização {:#layout-and-rendering}

Seria uma aplicação rara que desenhasse apenas um único widget. Uma parte importante
de qualquer framework de UI é, portanto, a capacidade de dispor eficientemente uma hierarquia
de widgets, determinando o tamanho e a posição de cada elemento antes de serem
renderizados na tela.

A classe base para cada nó na árvore de renderização é
[`RenderObject`]({{site.api}}/flutter/rendering/RenderObject-class.html), que
define um modelo abstrato para layout e pintura. Isso é extremamente geral: não
se compromete com um número fixo de dimensões ou mesmo um sistema de coordenadas
cartesianas (demonstrado por [este exemplo de um sistema de coordenadas
polares]({{site.dartpad}}/?id=596b1d6331e3b9d7b00420085fab3e27)). Cada
`RenderObject` conhece seu pai, mas sabe pouco sobre seus filhos além de
como _visitá-los_ e suas restrições. Isso fornece a `RenderObject` abstração
suficiente para ser capaz de lidar com uma variedade de casos de uso.

Durante a fase de build, o Flutter cria ou atualiza um objeto que herda de
`RenderObject` para cada `RenderObjectElement` na árvore de elementos.
`RenderObject`s são primitivos:
[`RenderParagraph`]({{site.api}}/flutter/rendering/RenderParagraph-class.html)
renderiza texto,
[`RenderImage`]({{site.api}}/flutter/rendering/RenderImage-class.html) renderiza
uma imagem, e
[`RenderTransform`]({{site.api}}/flutter/rendering/RenderTransform-class.html)
aplica uma transformação antes de pintar seu filho.

![Diferenças entre a hierarquia de widgets e as árvores de elementos e renderização](/assets/images/docs/arch-overview/trees.png){:width="100%" .diagram-wrap}

A maioria dos widgets Flutter é renderizada por um objeto que herda da
subclasse `RenderBox`, que representa um `RenderObject` de tamanho fixo em um espaço
cartesiano 2D. `RenderBox` fornece a base de um _modelo de restrição de caixa_,
estabelecendo uma largura e altura mínima e máxima para cada widget a ser
renderizado.

Para realizar o layout, o Flutter percorre a árvore de renderização em uma travessia em profundidade e
**passa restrições de tamanho** do pai para o filho. Ao determinar seu tamanho,
o filho _deve_ respeitar as restrições dadas a ele por seu pai. Os filhos
respondem **passando um tamanho** para seu objeto pai dentro das restrições
que o pai estabeleceu.

![Restrições descem, tamanhos sobem](/assets/images/docs/arch-overview/constraints-sizes.png){:width="70%" .diagram-wrap}

No final desta única caminhada pela árvore, cada objeto tem um tamanho definido
dentro das restrições de seu pai e está pronto para ser pintado chamando o método
[`paint()`]({{site.api}}/flutter/rendering/RenderObject/paint.html).

O modelo de restrição de caixa é muito poderoso como uma maneira de fazer layout de objetos em tempo _O(n)_:

- Os pais podem ditar o tamanho de um objeto filho definindo restrições máximas e mínimas
  para o mesmo valor. Por exemplo, o objeto de renderização mais alto em um
  app de telefone restringe seu filho a ser do tamanho da tela. (Os filhos podem
  escolher como usar esse espaço. Por exemplo, eles podem apenas centralizar o que querem
  renderizar dentro das restrições ditadas.)
- Um pai pode ditar a largura do filho, mas dar ao filho flexibilidade sobre
  a altura (ou ditar a altura, mas oferecer flexibilidade sobre a largura). Um exemplo do mundo real
  é o texto fluido, que pode ter que se ajustar a uma restrição horizontal, mas variar
  verticalmente dependendo da quantidade de texto.

Este modelo funciona mesmo quando um objeto filho precisa saber quanto espaço ele tem
disponível para decidir como renderizar seu conteúdo. Ao usar um widget
[`LayoutBuilder`]({{site.api}}/flutter/widgets/LayoutBuilder-class.html),
o objeto filho pode examinar as restrições passadas e usá-las para
determinar como ele as usará, por exemplo:

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

Mais informações sobre o sistema de restrição e layout,
juntamente com exemplos práticos, podem ser encontradas no tópico
[Entendendo restrições][Understanding constraints].

[Understanding constraints]: /ui/layout/constraints

A raiz de todos os `RenderObject`s é o `RenderView`, que representa a saída total
da árvore de renderização. Quando a plataforma exige que um novo frame seja renderizado
(por exemplo, por causa de um
[vsync](https://source.android.com/devices/graphics/implement-vsync) ou porque
uma descompressão/upload de textura está completo), uma chamada é feita ao método
`compositeFrame()`, que faz parte do objeto `RenderView` na raiz
da árvore de renderização. Isso cria um `SceneBuilder` para acionar uma atualização da
cena. Quando a cena está completa, o objeto `RenderView` passa a cena composta
para o método `Window.render()` em `dart:ui`, que passa o controle para a
GPU para renderizá-la.

Mais detalhes sobre os estágios de composição e rasterização do pipeline estão
além do escopo deste artigo de alto nível, mas mais informações podem ser encontradas
[nesta palestra sobre o pipeline de renderização do
Flutter]({{site.yt.watch}}?v=UUfXWzp0-DU).

## Embedding de plataforma

Como vimos, em vez de serem traduzidas para os widgets equivalentes do SO,
as interfaces de usuário do Flutter são construídas, dispostas, compostas e pintadas pelo próprio
Flutter. O mecanismo para obter a textura e participar do
ciclo de vida do app do sistema operacional subjacente inevitavelmente varia dependendo das
preocupações únicas dessa plataforma. O engine é agnóstico de plataforma,
apresentando uma [ABI (Application Binary Interface) estável][ABI]
que fornece a um _platform embedder_ uma maneira de configurar e usar o Flutter.

[ABI]: {{site.repo.flutter}}/blob/main/engine/src/flutter/shell/platform/embedder/embedder.h

O platform embedder é a aplicação nativa do SO que hospeda todo o conteúdo do Flutter,
e age como a cola entre o sistema operacional hospedeiro e o Flutter.
Quando você inicia um app Flutter, o embedder fornece o ponto de entrada,
inicializa o Flutter engine, obtém threads para UI e rasterização,
e cria uma textura na qual o Flutter pode escrever.
O embedder também é responsável pelo ciclo de vida do app,
incluindo gestos de entrada (como mouse, teclado, toque), dimensionamento de janela,
gerenciamento de threads e mensagens de plataforma.
O Flutter inclui platform embedders para Android, iOS, Windows,
macOS e Linux; você também pode criar um
platform embedder personalizado, como [neste exemplo
trabalhado]({{site.github}}/chinmaygarde/fluttercast) que suporta remoting de
sessões Flutter através de um framebuffer estilo VNC ou [neste exemplo trabalhado para
Raspberry Pi]({{site.github}}/ardera/flutter-pi).

Cada plataforma tem seu próprio conjunto de APIs e restrições. Algumas notas breves
específicas da plataforma:

- A partir do Flutter 3.29, as threads de UI e plataforma são mescladas no
  iOS e Android. Especificamente, a thread de UI
  é removida e o código Dart é executado na thread nativa da plataforma.
  Para mais informações, veja o vídeo [The great thread merge][].
- No iOS e macOS, o Flutter é carregado no embedder como um `UIViewController`
  ou `NSViewController`, respectivamente. O platform embedder cria um
  `FlutterEngine`, que serve como um host para a VM Dart e seu
  runtime Flutter, e um `FlutterViewController`, que se anexa ao `FlutterEngine`
  para passar eventos de entrada UIKit ou Cocoa para o Flutter e exibir frames
  renderizados pelo `FlutterEngine` usando Metal ou OpenGL.
- No Android, o Flutter é, por padrão, carregado no embedder como uma `Activity`.
  A visualização é controlada por um
  [`FlutterView`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html),
  que renderiza conteúdo Flutter como uma visualização ou uma textura, dependendo da
  composição e requisitos de z-ordering do conteúdo Flutter.
- No Windows, o Flutter é hospedado em um app Win32 tradicional, e o conteúdo é
  renderizado usando
  [ANGLE](https://chromium.googlesource.com/angle/angle/+/master/README.md), uma
  biblioteca que traduz chamadas de API OpenGL para os equivalentes DirectX 11.

[The great thread merge]: https://youtu.be/miW7vCmQwnw?si=9EYvRDxtkpkPrcSO

## Integrando com outro código

O Flutter fornece uma variedade de mecanismos de interoperabilidade, seja você
acessando código ou APIs escritas em uma linguagem como Kotlin ou Swift, chamando uma
API nativa baseada em C, incorporando controles nativos em um app Flutter, ou incorporando
Flutter em uma aplicação existente.

### Canais de plataforma

Para apps móveis e desktop, o Flutter permite que você chame código personalizado através
de um _canal de plataforma_, que é um mecanismo para comunicação entre seu
código Dart e o código específico da plataforma do seu app hospedeiro. Ao criar um canal comum
(encapsulando um nome e um codec), você pode enviar e receber mensagens
entre Dart e um componente de plataforma escrito em uma linguagem como Kotlin ou
Swift. Os dados são serializados de um tipo Dart como `Map` para um formato padrão,
e então desserializados em uma representação equivalente em Kotlin (como
`HashMap`) ou Swift (como `Dictionary`).

![Como os canais de plataforma permitem que o Flutter se comunique com o código hospedeiro](/assets/images/docs/arch-overview/platform-channels.png){:width="65%" .diagram-wrap}

O seguinte é um exemplo curto de canal de plataforma de uma chamada Dart para um manipulador de
eventos receptor em Kotlin (Android) ou Swift (iOS):

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

Mais exemplos de uso de canais de plataforma, incluindo exemplos para plataformas
desktop, podem ser encontrados no repositório [flutter/packages]({{site.repo.packages}}).
Também há [milhares de plugins
já disponíveis]({{site.pub}}/flutter) para Flutter que cobrem muitos
cenários comuns, desde Firebase até anúncios até hardware de dispositivos como câmera e
Bluetooth.

### Foreign Function Interface (FFI)

Para APIs baseadas em C, incluindo aquelas que podem ser geradas para código escrito em
linguagens modernas como Rust ou Go, o Dart fornece um mecanismo direto para vincular
a código nativo usando a biblioteca `dart:ffi`. A foreign function interface
(FFI) pode ser consideravelmente mais rápida do que canais de plataforma, porque nenhuma
serialização é necessária para passar dados. Em vez disso, o runtime Dart fornece a
capacidade de alocar memória no heap que é apoiada por um objeto Dart e fazer
chamadas para bibliotecas vinculadas estaticamente ou dinamicamente. FFI está disponível para todas as
plataformas além da web, onde as [bibliotecas de interoperabilidade JS][JS interop libraries] e
[`package:web`][] servem a um propósito similar.

Para usar FFI, você cria um `typedef` para cada uma das assinaturas de método Dart e não gerenciado,
e instrui a VM Dart a mapear entre elas. Como exemplo,
aqui está um fragmento de código para chamar a API tradicional Win32 `MessageBox()`:

<?code-excerpt "lib/ffi.dart" remove="ignore:"?>
```dart
import 'dart:ffi';
import 'package:ffi/ffi.dart'; // contains .toNativeUtf16() extension method

typedef MessageBoxNative =
    Int32 Function(
      IntPtr hWnd,
      Pointer<Utf16> lpText,
      Pointer<Utf16> lpCaption,
      Int32 uType,
    );

typedef MessageBoxDart =
    int Function(
      int hWnd,
      Pointer<Utf16> lpText,
      Pointer<Utf16> lpCaption,
      int uType,
    );

void exampleFfi() {
  final user32 = DynamicLibrary.open('user32.dll');
  final messageBox = user32.lookupFunction<MessageBoxNative, MessageBoxDart>(
    'MessageBoxW',
  );

  final result = messageBox(
    0, // No owner window
    'Test message'.toNativeUtf16(), // Message
    'Window caption'.toNativeUtf16(), // Window title
    0, // OK button only
  );
}
```

[JS interop libraries]: {{site.dart-site}}/interop/js-interop
[`package:web`]: {{site.pub-pkg}}/web

### Renderizando controles nativos em um app Flutter

Como o conteúdo do Flutter é desenhado em uma textura e sua árvore de widgets é inteiramente
interna, não há lugar para algo como uma visualização Android existir dentro do
modelo interno do Flutter ou renderizar intercalado com widgets Flutter. Isso é um
problema para desenvolvedores que gostariam de incluir componentes de plataforma existentes
em seus apps Flutter, como um controle de navegador.

O Flutter resolve isso introduzindo widgets de visualização de plataforma
([`AndroidView`]({{site.api}}/flutter/widgets/AndroidView-class.html)
e [`UiKitView`]({{site.api}}/flutter/widgets/UiKitView-class.html))
que permitem incorporar esse tipo de conteúdo em cada plataforma. As visualizações de plataforma podem ser
integradas com outro conteúdo Flutter[^3]. Cada um
desses widgets age como um intermediário para o sistema operacional subjacente. Por
exemplo, no Android, `AndroidView` serve três funções principais:

- Fazer uma cópia da textura gráfica renderizada pela visualização nativa e
  apresentá-la ao Flutter para composição como parte de uma superfície renderizada pelo Flutter
  cada vez que o frame é pintado.
- Responder a teste de hit e gestos de entrada, e traduzi-los para a
  entrada nativa equivalente.
- Criar um análogo da árvore de acessibilidade e passar comandos e
  respostas entre as camadas nativa e Flutter.

Inevitavelmente, há uma certa quantidade de overhead associado a esta
sincronização. Em geral, portanto, essa abordagem é mais adequada para
controles complexos como Google Maps onde reimplementar no Flutter não é prático.

Normalmente, um app Flutter instancia esses widgets em um método `build()` baseado
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
  '$defaultTargetPlatform is not yet supported by the maps plugin',
);
```

Comunicar-se com o código nativo subjacente ao `AndroidView` ou `UiKitView`
normalmente ocorre usando o mecanismo de canais de plataforma, conforme descrito anteriormente.

No momento, as visualizações de plataforma não estão disponíveis para plataformas desktop, mas isso não é
uma limitação arquitetural; o suporte pode ser adicionado no futuro.

### Hospedando conteúdo Flutter em um app pai

O inverso do cenário anterior é incorporar um widget Flutter em uma
aplicação Android ou iOS existente. Como descrito em uma seção anterior, um
app Flutter recém-criado em execução em um dispositivo móvel é hospedado em uma activity do Android ou
`UIViewController` do iOS. O conteúdo Flutter pode ser incorporado em uma aplicação Android ou
iOS existente usando a mesma API de embedding.

O template de módulo Flutter é projetado para fácil embedding; você pode
incorporá-lo como uma dependência de origem em uma definição de build Gradle ou Xcode existente, ou
você pode compilá-lo em um Android Archive ou iOS Framework binário para uso
sem exigir que cada desenvolvedor tenha o Flutter instalado.

O Flutter engine leva um curto tempo para inicializar, porque ele precisa carregar
bibliotecas compartilhadas do Flutter, inicializar o runtime Dart, criar e executar um
isolate Dart, e anexar uma superfície de renderização à UI. Para minimizar quaisquer atrasos de UI
ao apresentar conteúdo Flutter, é melhor inicializar o Flutter engine
durante a sequência de inicialização geral do app, ou pelo menos antes da primeira
tela Flutter, para que os usuários não experimentem uma pausa repentina enquanto o primeiro
código Flutter é carregado. Além disso, separar o Flutter engine permite que ele seja
reutilizado em várias telas Flutter e compartilhe o overhead de memória envolvido
no carregamento das bibliotecas necessárias.

Mais informações sobre como o Flutter é carregado em uma aplicação Android ou iOS existente
podem ser encontradas no tópico [Sequência de carregamento, desempenho e memória][Load sequence, performance and memory
topic].

[Load sequence, performance and memory
topic]: /add-to-app/performance

## Suporte web do Flutter

Embora os conceitos arquiteturais gerais se apliquem a todas as plataformas que o Flutter
suporta, há algumas características únicas do suporte web do Flutter que
merecem comentário.

O Dart tem compilado para JavaScript desde que a linguagem existe,
com uma toolchain otimizada tanto para fins de desenvolvimento quanto de produção.
Muitos apps importantes compilam de Dart para JavaScript e executam em produção hoje,
incluindo as [ferramentas de anunciante para Google Ads](https://ads.google.com/home/).
Como o framework Flutter é escrito em Dart, compilá-lo para JavaScript
foi relativamente simples.

No entanto, o Flutter engine, escrito em C++,
é projetado para interagir com o
sistema operacional subjacente em vez de um navegador web.
Uma abordagem diferente é, portanto, necessária.

Na web, o Flutter oferece dois renderizadores:

<table class="table table-striped">
<tr>
<th>Renderizador</th>
<th>Alvo de compilação</th>
</tr>

<tr>
<td>CanvasKit
</td>
<td>JavaScript
</td>
</tr>

<tr>
<td>Skwasm
</td>
<td>WebAssembly
</td>
</tr>
</table>

_Modos de build_ são opções de linha de comando que ditam
quais renderizadores estão disponíveis quando você executa o app.

O Flutter oferece dois _modos_ de build:

<table class="table table-striped">
<tr>
<th>Modo de build</th>
<th>Renderizador(es) disponível(is)</th>
</tr>

<tr>
<td>padrão</td>
<td>CanvasKit</td>
</tr>

<tr>
<td>`--wasm`</td>
<td>Skwasm (preferido), CanvasKit (fallback)</td>
</tr>
</table>


O modo padrão torna apenas o renderizador CanvasKit disponível.
A opção `--wasm` torna ambos os renderizadores disponíveis,
e escolhe o engine com base nas capacidades do navegador:
preferindo Skwasm se o navegador for capaz de executá-lo,
e volta para CanvasKit caso contrário.

{% comment %}
The draw.io source for the following image is in /diagrams/resources
{% endcomment %}

![Arquitetura web do Flutter](/assets/images/docs/arch-overview/web-framework-diagram.png){:width="80%" .diagram-wrap}

Talvez a diferença mais notável em comparação com outras
plataformas nas quais o Flutter executa é que não há necessidade
do Flutter fornecer um runtime Dart.
Em vez disso, o framework Flutter (junto com qualquer código que você escreve)
é compilado para JavaScript.
Também é digno de nota que o Dart tem muito poucas diferenças
semânticas de linguagem em todos os seus modos
(JIT versus AOT, compilação nativa versus web),
e a maioria dos desenvolvedores nunca escreverá uma linha de código que
encontre tal diferença.

Durante o tempo de desenvolvimento, o Flutter web usa
[`dartdevc`]({{site.dart-site}}/tools/dartdevc),
um compilador que suporta compilação incremental
e, portanto, permite hot restart e
[hot reload atrás de uma flag][hot reload behind a flag].
Por outro lado, quando você está pronto para criar um app de produção
para a web, [`dart2js`]({{site.dart-site}}/tools/dart2js),
o compilador JavaScript de produção altamente otimizado do Dart é usado,
empacotando o núcleo e framework Flutter junto com sua
aplicação em um arquivo fonte minificado que
pode ser implantado em qualquer servidor web.
O código pode ser oferecido em um único arquivo ou dividido
em vários arquivos através de [importações diferidas][deferred imports].

Para mais informações sobre o Flutter web, confira
[Suporte web para Flutter][Web support for Flutter] e [Renderizadores web][Web renderers].

[deferred imports]: {{site.dart-site}}/language/libraries#lazily-loading-a-library
[Web renderers]: /platform-integration/web/renderers
[Web support for Flutter]: /platform-integration/web
[hot reload behind a flag]: /platform-integration/web/faq#hot-reload

## Mais informações

Para aqueles interessados em mais informações sobre os internos do Flutter,
o whitepaper [Inside Flutter][/resources/inside-flutter]
fornece um guia útil para a filosofia de design do framework.

[/resources/inside-flutter]: /resources/inside-flutter

[^1]: Embora a função `build` retorne uma nova árvore,
  você só precisa retornar algo _diferente_ se
  houver alguma nova configuração para incorporar.
  Se a configuração for de fato a mesma,
  você pode apenas retornar o mesmo widget.
[^2]: Esta é uma simplificação leve para facilitar a leitura.
  Na prática, a árvore pode ser mais complexa.
[^3]: Existem algumas limitações com essa abordagem, por exemplo,
  a transparência não compõe da mesma maneira para uma visualização de plataforma como
  faria para outros widgets Flutter.
