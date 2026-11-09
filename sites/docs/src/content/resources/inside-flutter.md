---
title: Por dentro do Flutter
description: >-
  Saiba como o Flutter funciona por dentro, com um dos engenheiros fundadores.
showBreadcrumbs: false
ia-translate: true
---

Este documento descreve o funcionamento interno do toolkit do Flutter que
torna possível a API do Flutter. Como os widgets do Flutter são construídos
por meio de uma composição agressiva, as interfaces de usuário criadas com
Flutter têm um grande número de widgets. Para dar conta dessa carga de
trabalho, o Flutter usa algoritmos sublineares para o layout e para a
construção de widgets, além de estruturas de dados que tornam eficiente a
manipulação da árvore e que possuem várias otimizações de fator constante.
Com alguns detalhes adicionais, esse design também facilita que os
desenvolvedores criem listas de rolagem infinita usando callbacks que
constroem exatamente os widgets visíveis para o usuário.

## Composabilidade agressiva {:#aggressive-composability}

Um dos aspectos mais distintivos do Flutter é a sua _composabilidade
agressiva_. Os widgets são construídos compondo outros widgets, que, por sua
vez, são construídos a partir de widgets progressivamente mais básicos.
Por exemplo, `Padding` é um widget, e não uma propriedade de outros widgets.
Como resultado, as interfaces de usuário criadas com Flutter são compostas por
muitos, muitos widgets.

A recursão de construção de widgets termina nos `RenderObjectWidgets`,
que são widgets que criam nós na _árvore de render_ subjacente.
A árvore de render é uma estrutura de dados que armazena a geometria da
interface de usuário, a qual é calculada durante o _layout_ e usada durante a
_pintura_ e o _teste de acerto_ (_hit testing_). A maioria dos desenvolvedores
Flutter não cria objetos de render diretamente; em vez disso, manipulam a
árvore de render por meio de widgets.

Para dar suporte à composabilidade agressiva na camada de widgets, o Flutter
usa vários algoritmos eficientes e otimizações tanto na camada de widgets
quanto na de árvore de render, descritos nas subseções a seguir.

### Layout sublinear {:#sublinear-layout}

Com um grande número de widgets e objetos de render, a chave para um bom
desempenho são algoritmos eficientes. Do ponto de vista do desempenho, o
mais importante é o _layout_, que é o algoritmo que determina a geometria
(por exemplo, o tamanho e a posição) dos objetos de render.
Alguns outros toolkits usam algoritmos de layout com complexidade O(N²) ou
pior (por exemplo, iteração de ponto fixo em algum domínio de restrições).
O Flutter busca um desempenho linear para o layout inicial e um _desempenho de
layout sublinear_ no caso comum de atualizar um layout já existente.
Normalmente, o tempo gasto no layout deve crescer mais lentamente do que o
número de objetos de render.

O Flutter executa um layout por quadro, e o algoritmo de layout funciona em
uma única passagem. As _restrições_ são passadas para baixo na árvore pelos
objetos pais, que chamam o método de layout de cada um de seus filhos.
Os filhos executam recursivamente o próprio layout e, então, devolvem a
_geometria_ para cima na árvore, retornando de seu método de layout.
Importante: depois que um objeto de render retorna do seu método de layout,
ele não será visitado novamente[^1] até o layout do próximo quadro.
Essa abordagem combina o que, de outra forma, seriam passagens separadas de
medição e de layout em uma única passagem e, como resultado, cada objeto de
render é visitado _no máximo duas vezes_[^2] durante o layout: uma vez na
descida da árvore e outra na subida.

O Flutter tem várias especializações desse protocolo geral.
A mais comum é o `RenderBox`, que opera em coordenadas cartesianas
bidimensionais. No layout de caixa, as restrições são uma largura mínima e
máxima e uma altura mínima e máxima. Durante o layout, o filho determina sua
geometria escolhendo um tamanho dentro desses limites.
Depois que o filho retorna do layout, o pai decide a posição do filho no
sistema de coordenadas do pai[^3].
Observe que o layout do filho não pode depender da sua posição, pois a posição
só é determinada depois que o filho retorna do layout. Por isso, o pai é livre
para reposicionar o filho sem precisar recalcular o layout dele.

De forma mais geral, durante o layout, a _única_ informação que flui do pai
para o filho são as restrições, e a _única_ informação que flui do filho para
o pai é a geometria. Essas invariantes podem reduzir o trabalho necessário
durante o layout:

* Se o filho não marcou o próprio layout como sujo, ele pode retornar
  imediatamente do layout, interrompendo a travessia, desde que o pai dê ao
  filho as mesmas restrições que ele recebeu durante o layout anterior.

* Sempre que um pai chama o método de layout de um filho, ele indica se usa
  a informação de tamanho retornada pelo filho. Se, como acontece com frequência,
  o pai não usa a informação de tamanho, ele não precisa recalcular o próprio
  layout caso o filho escolha um novo tamanho, pois o pai tem a garantia de
  que o novo tamanho respeitará as restrições existentes.

* _Restrições justas_ (_tight_) são aquelas que podem ser satisfeitas por
  exatamente uma geometria válida. Por exemplo, se as larguras mínima e máxima
  forem iguais entre si e as alturas mínima e máxima também forem iguais entre
  si, o único tamanho que satisfaz essas restrições é aquele com essa largura e
  essa altura. Se o pai fornece restrições justas, então ele não precisa
  recalcular o próprio layout sempre que o filho recalcular o dele, mesmo que
  o pai use o tamanho do filho no seu layout, pois o filho não pode mudar de
  tamanho sem novas restrições do pai.

* Um objeto de render pode declarar que usa as restrições fornecidas pelo pai
  apenas para determinar a própria geometria. Essa declaração informa ao
  framework que o pai desse objeto de render não precisa recalcular o próprio
  layout quando o filho recalcular o dele, _mesmo que as restrições não sejam
  justas_ e _mesmo que o layout do pai dependa do tamanho do filho_, porque o
  filho não pode mudar de tamanho sem novas restrições do pai.

Como resultado dessas otimizações, quando a árvore de objetos de render contém
nós sujos, apenas esses nós e uma parte limitada da subárvore ao redor deles
são visitados durante o layout.

### Construção sublinear de widgets {:#sublinear-widget-building}

Assim como no algoritmo de layout, o algoritmo de construção de widgets do
Flutter é sublinear. Depois de construídos, os widgets são mantidos pela
_árvore de elementos_, que preserva a estrutura lógica da interface de usuário.
A árvore de elementos é necessária porque os próprios widgets são _imutáveis_,
o que significa (entre outras coisas) que eles não podem lembrar suas relações
de pai ou de filho com outros widgets. A árvore de elementos também mantém os
objetos de _estado_ associados aos widgets com estado.

Em resposta a entradas do usuário (ou outros estímulos), um elemento pode ficar
sujo, por exemplo, se o desenvolvedor chamar `setState()` no objeto de estado
associado. O framework mantém uma lista de elementos sujos e vai diretamente
até eles durante a fase de _build_, pulando os elementos limpos. Durante a fase
de build, a informação flui _unidirecionalmente_ para baixo na árvore de
elementos, o que significa que cada elemento é visitado no máximo uma vez nessa
fase. Uma vez limpo, um elemento não pode ficar sujo novamente porque, por
indução, todos os seus elementos ancestrais também estão limpos[^4].

Como os widgets são _imutáveis_, se um elemento não se marcou como sujo, ele
pode retornar imediatamente do build, interrompendo a travessia, caso o pai
reconstrua o elemento com um widget idêntico. Além disso, o elemento só precisa
comparar a identidade de objeto das duas referências de widget para verificar
que o novo widget é igual ao antigo. Os desenvolvedores exploram essa
otimização para implementar o padrão de _reprojeção_, no qual um widget inclui
um widget filho pré-construído, armazenado como variável membro em seu build.

Durante o build, o Flutter também evita percorrer a cadeia de pais usando
`InheritedWidgets`. Se os widgets percorressem a cadeia de pais com frequência,
por exemplo, para determinar a cor atual do tema, a fase de build teria
complexidade O(N²) em relação à profundidade da árvore, que pode ser bastante
grande por causa da composição agressiva. Para evitar essas travessias para cima,
o framework propaga informações para baixo na árvore de elementos, mantendo uma
tabela hash de `InheritedWidget`s em cada elemento. Normalmente, muitos
elementos referenciam a mesma tabela hash, que muda apenas nos elementos que
introduzem um novo `InheritedWidget`.

### Reconciliação linear {:#linear-reconciliation}

Ao contrário do que muitos acreditam, o Flutter não emprega um algoritmo de
comparação de árvores (_tree-diffing_). Em vez disso, o framework decide se
reutiliza elementos examinando a lista de filhos de cada elemento de forma
independente, usando um algoritmo O(N). O algoritmo de reconciliação da lista
de filhos é otimizado para os seguintes casos:

* A lista antiga de filhos está vazia.
* As duas listas são idênticas.
* Há a inserção ou a remoção de um ou mais widgets em exatamente um lugar da
  lista.
* Se cada lista contém um widget com a mesma chave[^5], os dois widgets são
  pareados.

A abordagem geral é parear o início e o fim das duas listas de filhos,
comparando o tipo em tempo de execução e a chave de cada widget, possivelmente
encontrando um intervalo não vazio no meio de cada lista que contém todos os
filhos não pareados. Em seguida, o framework coloca os filhos desse intervalo
na lista antiga em uma tabela hash, indexada por chave. Depois, o framework
percorre o intervalo na nova lista de filhos e consulta a tabela hash pela chave
para encontrar pares. Os filhos não pareados são descartados e reconstruídos do
zero, enquanto os filhos pareados são reconstruídos com seus novos widgets.

### Cirurgia de árvore {:#tree-surgery}

Reutilizar elementos é importante para o desempenho, porque os elementos
possuem dois dados críticos: o estado dos widgets com estado e os objetos de
render subjacentes. Quando o framework consegue reutilizar um elemento, o
estado daquela parte lógica da interface de usuário é preservado, e as
informações de layout calculadas anteriormente podem ser reaproveitadas,
evitando, muitas vezes, a travessia de subárvores inteiras. Na verdade,
reutilizar elementos é tão valioso que o Flutter oferece suporte a mutações
_não locais_ da árvore que preservam o estado e as informações de layout.

O desenvolvedor pode realizar uma mutação não local da árvore associando uma
`GlobalKey` a um de seus widgets. Cada chave global é única em todo o
aplicativo e é registrada em uma tabela hash específica da thread.
Durante a fase de build, o desenvolvedor pode mover um widget com chave global
para uma localização arbitrária na árvore de elementos. Em vez de construir um
elemento novo nessa localização, o framework consulta a tabela hash e
reparenta o elemento existente, movendo-o da localização anterior para a nova,
preservando a subárvore inteira.

Os objetos de render na subárvore reparentada conseguem preservar suas
informações de layout, porque as restrições de layout são a única informação
que flui do pai para o filho na árvore de render. O novo pai é marcado como
sujo para o layout, porque sua lista de filhos mudou, mas, se o novo pai passar
ao filho as mesmas restrições de layout que o filho recebeu do pai antigo, o
filho pode retornar imediatamente do layout, interrompendo a travessia.

As chaves globais e as mutações não locais da árvore são usadas extensivamente
pelos desenvolvedores para obter efeitos como as transições de _hero_ e a
navegação.

### Otimizações de fator constante {:#constant-factor-optimizations}

Além dessas otimizações algorítmicas, alcançar a composabilidade agressiva
também depende de várias otimizações importantes de fator constante. Essas
otimizações são mais importantes nas folhas dos principais algoritmos
discutidos acima.

* **Agnóstica ao modelo de filhos.** Diferentemente da maioria dos toolkits,
  que usam listas de filhos, a árvore de render do Flutter não se compromete
  com um modelo específico de filhos. Por exemplo, a classe `RenderBox` tem um
  método abstrato `visitChildren()`, em vez de uma interface concreta com
  `firstChild` e `nextSibling`. Muitas subclasses suportam apenas um único
  filho, armazenado diretamente como variável membro, em vez de uma lista de
  filhos. Por exemplo, `RenderPadding` suporta apenas um filho e, como
  resultado, tem um método de layout mais simples, que leva menos tempo para
  ser executado.

* **Árvore de render visual, árvore de widgets lógica.** No Flutter, a árvore
  de render opera em um sistema de coordenadas visual e independente de
  dispositivo, o que significa que valores menores na coordenada x estão sempre
  mais à esquerda, mesmo que a direção de leitura atual seja da direita para a
  esquerda. A árvore de widgets normalmente opera em coordenadas lógicas, ou
  seja, com valores de _início_ e _fim_, cuja interpretação visual depende da
  direção de leitura. A transformação de coordenadas lógicas para visuais é
  feita na passagem entre a árvore de widgets e a árvore de render. Essa
  abordagem é mais eficiente, porque os cálculos de layout e de pintura na
  árvore de render acontecem com mais frequência do que a passagem de widgets
  para render, e assim se evitam conversões repetidas de coordenadas.

* **Texto tratado por um objeto de render especializado.** A grande maioria
  dos objetos de render desconhece as complexidades do texto. Em vez disso, o
  texto é tratado por um objeto de render especializado, `RenderParagraph`,
  que é uma folha na árvore de render. Em vez de criar uma subclasse de um
  objeto de render sensível a texto, os desenvolvedores incorporam texto à
  interface de usuário por meio de composição. Esse padrão significa que
  `RenderParagraph` pode evitar recalcular o layout do próprio texto enquanto
  o pai fornecer as mesmas restrições de layout, o que é comum, inclusive
  durante a cirurgia de árvore.

* **Objetos observáveis.** O Flutter usa tanto o paradigma de observação de
  modelos quanto o paradigma reativo. Obviamente, o paradigma reativo é o
  dominante, mas o Flutter usa objetos de modelo observáveis em algumas
  estruturas de dados folha. Por exemplo, as `Animation`s notificam uma lista
  de observadores quando seu valor muda. O Flutter repassa esses objetos
  observáveis da árvore de widgets para a árvore de render, que os observa
  diretamente e invalida apenas a etapa apropriada do pipeline quando eles
  mudam. Por exemplo, uma mudança em um `Animation<Color>` pode disparar apenas
  a fase de pintura, em vez de tanto a fase de build quanto a de pintura.

Somadas e aplicadas às grandes árvores criadas pela composição agressiva,
essas otimizações têm um efeito substancial no desempenho.

### Separação das árvores Element e RenderObject {:#separation-of-the-element-and-renderobject-trees}

As árvores `RenderObject` e `Element` (Widget) do Flutter são isomorfas
(estritamente falando, a árvore `RenderObject` é um subconjunto da árvore
`Element`). Uma simplificação óbvia seria combinar essas árvores em uma só.
No entanto, na prática, há várias vantagens em mantê-las separadas:

* **Desempenho.** Quando o layout muda, apenas as partes relevantes da árvore
  de layout precisam ser percorridas. Por causa da composição, a árvore de
  elementos frequentemente tem muitos nós adicionais que teriam de ser
  ignorados.

* **Clareza.** A separação mais clara de responsabilidades permite que o
  protocolo de widgets e o protocolo de objetos de render sejam cada um
  especializado para as suas necessidades específicas, simplificando a
  superfície da API e, assim, reduzindo o risco de bugs e a carga de testes.

* **Segurança de tipos.** A árvore de objetos de render pode ser mais segura em
  relação aos tipos, pois pode garantir em tempo de execução que os filhos serão
  do tipo apropriado (cada sistema de coordenadas, por exemplo, tem seu próprio
  tipo de objeto de render). Widgets de composição podem ser agnósticos quanto
  ao sistema de coordenadas usado durante o layout (por exemplo, o mesmo widget
  que expõe uma parte do modelo do app poderia ser usado tanto em um layout de
  caixa quanto em um layout de sliver). Assim, na árvore de elementos, verificar
  o tipo dos objetos de render exigiria percorrer a árvore.

## Rolagem infinita {:#infinite-scrolling}

Listas de rolagem infinita são notoriamente difíceis para os toolkits.
O Flutter oferece suporte a listas de rolagem infinita com uma interface simples
baseada no padrão _builder_, no qual um `ListView` usa um callback para construir
widgets sob demanda, à medida que eles se tornam visíveis para o usuário durante
a rolagem. Oferecer esse recurso exige _layout ciente do viewport_ e a
_construção de widgets sob demanda_.

### Layout ciente do viewport {:#viewport-aware-layout}

Como quase tudo no Flutter, os widgets roláveis são construídos por composição.
O exterior de um widget rolável é um `Viewport`, que é uma caixa que é "maior por
dentro", ou seja, seus filhos podem se estender além dos limites do viewport e
ser rolados para dentro da visualização. No entanto, em vez de ter filhos
`RenderBox`, um viewport tem filhos `RenderSliver`, conhecidos como _slivers_,
que têm um protocolo de layout ciente do viewport.

O protocolo de layout de sliver corresponde à estrutura do protocolo de layout
de caixa, pois os pais passam restrições para os filhos e recebem geometria em
troca. Porém, os dados de restrição e de geometria diferem entre os dois
protocolos. No protocolo de sliver, os filhos recebem informações sobre o
viewport, incluindo o espaço visível restante. Os dados de geometria que eles
devolvem possibilitam uma variedade de efeitos vinculados à rolagem, incluindo
cabeçalhos recolhíveis e parallax.

Diferentes slivers preenchem o espaço disponível no viewport de maneiras
diferentes. Por exemplo, um sliver que produz uma lista linear de filhos
organiza cada filho em ordem até que o sliver fique sem filhos ou sem espaço.
Da mesma forma, um sliver que produz uma grade bidimensional de filhos preenche
apenas a porção visível da grade. Como conhecem o espaço visível, os slivers
podem produzir um número finito de filhos, mesmo que tenham potencial para
produzir um número ilimitado deles.

Os slivers podem ser compostos para criar layouts roláveis e efeitos sob medida.
Por exemplo, um único viewport pode ter um cabeçalho recolhível, seguido de uma
lista linear e, então, de uma grade. Os três slivers vão cooperar pelo protocolo
de layout de sliver para produzir apenas os filhos que de fato são visíveis
através do viewport, independentemente de esses filhos pertencerem ao cabeçalho,
à lista ou à grade[^6].

### Construindo widgets sob demanda {:#building-widgets-on-demand}

Se o Flutter tivesse um pipeline estrito de _construir-depois-layout-depois-pintar_,
o que foi descrito acima não bastaria para implementar uma lista de rolagem
infinita, porque a informação sobre quanto espaço está visível através do
viewport só fica disponível durante a fase de layout. Sem um mecanismo adicional,
a fase de layout chega tarde demais para construir os widgets necessários para
preencher o espaço. O Flutter resolve esse problema intercalando as fases de
build e de layout do pipeline. Em qualquer ponto da fase de layout, o framework
pode começar a construir novos widgets sob demanda, _desde que esses widgets
sejam descendentes do objeto de render que está executando o layout no momento_.

A intercalação entre build e layout só é possível por causa dos controles rígidos
sobre a propagação de informações nos algoritmos de build e de layout.
Especificamente, durante a fase de build, a informação só pode se propagar para
baixo na árvore. Quando um objeto de render está executando o layout, a travessia
de layout ainda não visitou a subárvore abaixo desse objeto de render, o que
significa que as escritas geradas pela construção naquela subárvore não podem
invalidar nenhuma informação que já entrou no cálculo de layout até aquele
momento. Da mesma forma, depois que o layout retorna de um objeto de render,
esse objeto de render nunca mais será visitado durante esse layout, o que
significa que quaisquer escritas geradas pelos cálculos de layout posteriores
não podem invalidar a informação usada para construir a subárvore do objeto de
render.

Além disso, a reconciliação linear e a cirurgia de árvore são essenciais para
atualizar os elementos de forma eficiente durante a rolagem e para modificar a
árvore de render quando os elementos entram e saem da visualização na borda do
viewport.

## Ergonomia da API {:#api-ergonomics}

Ser rápido só importa se o framework puder ser usado de forma eficaz.
Para orientar o design da API do Flutter em direção a uma maior usabilidade, o
Flutter tem sido repetidamente testado em extensos estudos de UX com
desenvolvedores. Esses estudos às vezes confirmaram decisões de design já
existentes, às vezes ajudaram a orientar a priorização de funcionalidades e às
vezes mudaram a direção do design da API. Por exemplo, as APIs do Flutter são
fortemente documentadas; os estudos de UX confirmaram o valor dessa
documentação, mas também destacaram a necessidade específica de código de
exemplo e de diagramas ilustrativos.

Esta seção discute algumas das decisões tomadas no design da API do Flutter
para favorecer a usabilidade.

### Especializando APIs para se alinhar à mentalidade do desenvolvedor {:#specializing-apis-to-match-the-developers-mindset}

A classe base para os nós das árvores `Widget`, `Element` e `RenderObject` do
Flutter não define um modelo de filhos. Isso permite que cada nó seja
especializado para o modelo de filhos aplicável a ele.

A maioria dos objetos `Widget` tem um único widget filho e, portanto, expõe
apenas um parâmetro `child`. Alguns widgets suportam um número arbitrário de
filhos e expõem um parâmetro `children` que recebe uma lista.
Alguns widgets não têm filho algum, não reservam memória para eles e não têm
parâmetros para isso. Da mesma forma, os `RenderObjects` expõem APIs específicas
ao seu modelo de filhos. `RenderImage` é um nó folha e não tem o conceito de
filhos. `RenderPadding` recebe um único filho, então tem espaço para um único
ponteiro para um único filho. `RenderFlex` recebe um número arbitrário de filhos
e os gerencia como uma lista encadeada.

Em alguns casos raros, são usados modelos de filhos mais complicados. O
construtor do objeto de render `RenderTable` recebe um array de arrays de filhos,
a classe expõe getters e setters que controlam o número de linhas e de colunas, e
há métodos específicos para substituir filhos individuais pela coordenada x,y,
para adicionar uma linha, para fornecer um novo array de arrays de filhos e para
substituir a lista inteira de filhos por um único array e uma contagem de colunas.
Na implementação, o objeto não usa uma lista encadeada, como a maioria dos objetos
de render, mas sim um array indexável.

Os widgets `Chip` e os objetos `InputDecoration` têm campos que correspondem aos
slots existentes nos controles relevantes. Quando um modelo de filhos único para
todos os casos forçaria a semântica a ser montada sobre uma lista de filhos, por
exemplo, definindo que o primeiro filho é o valor de prefixo e o segundo é o de
sufixo, o modelo de filhos dedicado permite usar propriedades nomeadas específicas.

Essa flexibilidade permite que cada nó dessas árvores seja manipulado da forma
mais idiomática para o seu papel. É raro querer inserir uma célula em uma tabela,
fazendo com que todas as outras células se reorganizem; da mesma forma, é raro
querer remover um filho de uma linha flexível pelo índice em vez de pela
referência.

O objeto `RenderParagraph` é o caso mais extremo: ele tem um filho de um tipo
completamente diferente, `TextSpan`. Na fronteira do `RenderParagraph`, a árvore
`RenderObject` se transforma em uma árvore de `TextSpan`.

A abordagem geral de especializar as APIs para atender às expectativas do
desenvolvedor é aplicada a mais do que apenas modelos de filhos.

Alguns widgets bastante triviais existem especificamente para que os
desenvolvedores os encontrem quando procuram uma solução para um problema.
Adicionar um espaço a uma linha ou coluna é fácil depois que se sabe como, usando
o widget `Expanded` e um filho `SizedBox` de tamanho zero. Mas descobrir esse
padrão não é necessário, porque pesquisar por `space` revela o widget `Spacer`,
que usa `Expanded` e `SizedBox` diretamente para obter o efeito.

Da mesma forma, ocultar uma subárvore de widgets é fácil: basta não incluí-la no
build. No entanto, os desenvolvedores normalmente esperam que exista um widget
para fazer isso, por isso o widget `Visibility` existe para encapsular esse padrão
em um widget reutilizável e trivial.

### Argumentos explícitos {:#explicit-arguments}

Frameworks de UI tendem a ter muitas propriedades, de modo que um desenvolvedor
raramente consegue lembrar o significado semântico de cada argumento de
construtor de cada classe. Como o Flutter usa o paradigma reativo, é comum que os
métodos de build no Flutter tenham muitas chamadas a construtores. Ao aproveitar
o suporte do Dart a argumentos nomeados, a API do Flutter consegue manter esses
métodos de build claros e compreensíveis.

Esse padrão se estende a qualquer método com múltiplos argumentos e, em particular,
a qualquer argumento booleano, de modo que valores isolados `true` ou `false` em
chamadas de métodos sejam sempre autoexplicativos. Além disso, para evitar a
confusão comumente causada por dupla negação em APIs, os argumentos e as
propriedades booleanas são sempre nomeados na forma positiva (por exemplo,
`enabled: true` em vez de `disabled: false`).

### Eliminando armadilhas {:#paving-over-pitfalls}

Uma técnica usada em vários pontos do framework Flutter é definir a API de forma
que as condições de erro não existam. Isso remove classes inteiras de erros da
equação.

Por exemplo, as funções de interpolação permitem que uma ou ambas as extremidades
da interpolação sejam `null`, em vez de definir isso como um caso de erro:
interpolar entre dois valores nulos sempre resulta em `null`, e interpolar a
partir de um valor nulo ou até um valor nulo equivale a interpolar até o análogo
zero do tipo dado. Isso significa que desenvolvedores que passem `null`
acidentalmente para uma função de interpolação não vão encontrar um caso de erro,
mas sim um resultado razoável.

Um exemplo mais sutil está no algoritmo de layout `Flex`. A ideia desse layout é
que o espaço dado ao objeto de render flexível seja dividido entre seus filhos,
então o tamanho do flex deve ser a totalidade do espaço disponível. No design
original, fornecer espaço infinito falharia: isso implicaria que o flex deveria
ter tamanho infinito, uma configuração de layout inútil. Em vez disso, a API foi
ajustada para que, quando espaço infinito é alocado ao objeto de render flexível,
ele se dimensione para caber no tamanho desejado dos filhos, reduzindo o número
possível de casos de erro.

A abordagem também é usada para evitar construtores que permitam criar dados
inconsistentes. Por exemplo, o construtor de `PointerDownEvent` não permite que a
propriedade `down` de `PointerEvent` seja definida como `false` (uma situação que
seria autocontraditória); em vez disso, o construtor não tem parâmetro para o
campo `down` e sempre o define como `true`.

Em geral, a abordagem consiste em definir interpretações válidas para todos os
valores do domínio de entrada. O exemplo mais simples é o construtor de `Color`.
Em vez de receber quatro inteiros, um para vermelho, um para verde, um para azul
e um para alfa, cada um dos quais poderia estar fora do intervalo, o construtor
padrão recebe um único valor inteiro e define o significado de cada bit (por
exemplo, os oito bits inferiores definem o componente vermelho), de modo que
qualquer valor de entrada seja um valor de cor válido.

Um exemplo mais elaborado é a função `paintImage()`. Essa função recebe onze
argumentos, alguns com domínios de entrada bastante amplos, mas eles foram
cuidadosamente projetados para serem, em sua maioria, ortogonais entre si, de
modo que existam pouquíssimas combinações inválidas.

### Reportando casos de erro de forma agressiva {:#reporting-error-cases-aggressively}

Nem todas as condições de erro podem ser eliminadas pelo design. Para as que
restam, em builds de depuração, o Flutter geralmente tenta capturar os erros
muito cedo e os reporta imediatamente. Asserts são amplamente usados.
Os argumentos dos construtores são verificados em detalhes. Os ciclos de vida são
monitorados e, quando inconsistências são detectadas, elas imediatamente causam
o lançamento de uma exceção.

Em alguns casos, isso é levado ao extremo: por exemplo, ao executar testes
unitários, independentemente do que mais o teste esteja fazendo, toda subclasse
de `RenderBox` que passa por layout inspeciona agressivamente se seus métodos de
dimensionamento intrínseco cumprem o contrato de dimensionamento intrínseco. Isso
ajuda a detectar erros em APIs que, de outra forma, poderiam não ser exercitadas.

Quando exceções são lançadas, elas incluem o máximo de informação disponível.
Algumas mensagens de erro do Flutter examinam proativamente a stack trace
associada para determinar a localização mais provável do bug real. Outras
percorrem as árvores relevantes para determinar a origem de dados inválidos. Os
erros mais comuns incluem instruções detalhadas, em alguns casos com código de
exemplo para evitar o erro, ou links para mais documentação.

### Paradigma reativo {:#reactive-paradigm}

As APIs mutáveis baseadas em árvore sofrem de um padrão de acesso dicotômico:
criar o estado original da árvore normalmente usa um conjunto de operações muito
diferente das atualizações subsequentes. A camada de renderização do Flutter usa
esse paradigma, pois é uma forma eficaz de manter uma árvore persistente, o que é
essencial para o layout e a pintura eficientes. No entanto, isso significa que a
interação direta com a camada de renderização é, na melhor das hipóteses,
desajeitada e, na pior, propensa a bugs.

A camada de widgets do Flutter introduz um mecanismo de composição usando o
paradigma reativo[^7] para manipular a árvore de renderização subjacente.
Essa API abstrai a manipulação da árvore combinando as etapas de criação e de
mutação da árvore em uma única descrição da árvore (build), na qual, após cada
mudança no estado do sistema, o desenvolvedor descreve a nova configuração da
interface de usuário e o framework calcula a série de mutações da árvore
necessária para refletir essa nova configuração.

### Interpolação {:#interpolation}

Como o framework do Flutter incentiva os desenvolvedores a descrever a configuração
da interface que corresponde ao estado atual do aplicativo, existe um mecanismo
para animar implicitamente a transição entre essas configurações.

Por exemplo, suponha que, no estado S<sub>1</sub>, a interface consista em um
círculo, mas, no estado S<sub>2</sub>, ela consista em um quadrado. Sem um mecanismo
de animação, a mudança de estado causaria uma mudança brusca na interface. Uma
animação implícita permite que o círculo se transforme suavemente em quadrado ao
longo de vários quadros.

Cada recurso que pode ser animado implicitamente tem um widget com estado que
mantém um registro do valor atual da entrada e inicia uma sequência de animação
sempre que o valor de entrada muda, fazendo a transição do valor atual para o
novo valor ao longo de uma duração especificada.

Isso é implementado usando funções `lerp` (interpolação linear) com objetos
imutáveis. Cada estado (círculo e quadrado, neste caso) é representado por um
objeto imutável configurado com as configurações apropriadas (cor, espessura do
traço etc.) e que sabe como se pintar. Quando chega a hora de desenhar os passos
intermediários da animação, os valores inicial e final são passados para a função
`lerp` apropriada, junto com um valor _t_ que representa o ponto na animação,
onde 0.0 representa o `start` e 1.0 representa o `end`[^8], e a função retorna um
terceiro objeto imutável que representa a etapa intermediária.

Para a transição de círculo para quadrado, a função `lerp` retornaria um objeto
representando um "quadrado arredondado", com um raio descrito como uma fração
derivada do valor _t_, uma cor interpolada usando a função `lerp` para cores e uma
espessura de traço interpolada usando a função `lerp` para doubles. Esse objeto,
que implementa a mesma interface de círculos e quadrados, então seria capaz de se
pintar quando solicitado.

Essa técnica permite que a máquina de estados, o mapeamento de estados para
configurações, a máquina de animação, a máquina de interpolação e a lógica
específica de como pintar cada quadro sejam totalmente separados uns dos outros.

Essa abordagem é amplamente aplicável. No Flutter, tipos básicos como `Color` e
`Shape` podem ser interpolados, mas também tipos muito mais elaborados, como
`Decoration`, `TextStyle` ou `Theme`. Eles normalmente são construídos a partir de
componentes que também podem ser interpolados, e interpolar objetos mais
complicados costuma ser tão simples quanto interpolar recursivamente todos os
valores que descrevem esses objetos.

Alguns objetos interpoláveis são definidos por hierarquias de classes. Por exemplo,
formas são representadas pela interface `ShapeBorder`, e existe uma variedade de
formas, incluindo `BeveledRectangleBorder`, `BoxBorder`, `CircleBorder`,
`RoundedRectangleBorder` e `StadiumBorder`. Uma única função `lerp` não consegue
prever todos os tipos possíveis, por isso a interface define os métodos `lerpFrom`
e `lerpTo`, para os quais o método estático `lerp` delega. Ao interpolar de uma
forma A para uma forma B, primeiro pergunta-se a B se ela consegue fazer `lerpFrom`
de A; se não conseguir, pergunta-se a A se ela consegue fazer `lerpTo` de B. (Se
nenhuma das duas for possível, a função retorna A para valores de `t` menores que
0.5, e B caso contrário.)

Isso permite que a hierarquia de classes seja estendida de forma arbitrária, com
adições posteriores podendo interpolar entre valores já conhecidos e elas mesmas.

Em alguns casos, a própria interpolação não pode ser descrita por nenhuma das
classes disponíveis, e uma classe privada é definida para descrever a etapa
intermediária. É o que acontece, por exemplo, ao interpolar entre um
`CircleBorder` e um `RoundedRectangleBorder`.

Esse mecanismo tem mais uma vantagem: ele consegue lidar com a interpolação a
partir de etapas intermediárias para novos valores. Por exemplo, na metade de uma
transição de círculo para quadrado, a forma pode ser alterada mais uma vez,
fazendo com que a animação precise interpolar para um triângulo. Desde que a
classe do triângulo consiga fazer `lerpFrom` da classe intermediária de quadrado
arredondado, a transição pode ser realizada sem emendas.

## Conclusão {:#conclusion}

O lema do Flutter, "tudo é um widget", gira em torno de construir interfaces de
usuário compondo widgets que, por sua vez, são compostos de widgets
progressivamente mais básicos. O resultado dessa composição agressiva é um grande
número de widgets que exigem algoritmos e estruturas de dados cuidadosamente
projetados para serem processados de forma eficiente. Com um design adicional,
essas estruturas de dados também facilitam que os desenvolvedores criem listas de
rolagem infinita que constroem widgets sob demanda, quando se tornam visíveis.

---
**Notas de rodapé:**

[^1]: Pelo menos para o layout. Pode ser revisitado
  para a pintura, para construir a árvore de acessibilidade, se necessário,
  e para o teste de acerto, se necessário.

[^2]: A realidade, claro, é um pouco
  mais complicada. Alguns layouts envolvem dimensões intrínsecas ou medições de
  linha de base, o que exige uma travessia adicional da subárvore relevante
  (usa-se cache agressivo para mitigar o potencial de desempenho quadrático no
  pior caso). Esses casos, porém, são surpreendentemente raros. Em particular,
  dimensões intrínsecas não são necessárias para o caso comum de
  dimensionamento pelo conteúdo (_shrink-wrapping_).

[^3]: Tecnicamente, a posição do filho não faz
  parte da geometria do seu RenderBox e, por isso, não precisa ser realmente
  calculada durante o layout. Muitos objetos de render posicionam implicitamente
  o único filho em 0,0 em relação à própria origem, o que não exige nenhum cálculo
  ou armazenamento. Alguns objetos de render evitam calcular a posição dos filhos
  até o último momento possível (por exemplo, durante a fase de pintura), para
  evitar o cálculo por completo caso não sejam pintados depois.

[^4]: Existe uma exceção a essa regra.
  Como discutido na seção [Construindo widgets sob demanda](#building-widgets-on-demand),
  alguns widgets podem ser reconstruídos como resultado de uma mudança nas
  restrições de layout. Se um widget se marcou como sujo por motivos não
  relacionados no mesmo quadro em que também é afetado por uma mudança nas
  restrições de layout, ele será atualizado duas vezes. Essa reconstrução
  redundante se limita ao próprio widget e não afeta seus descendentes.

[^5]: Uma chave é um objeto opaco, opcionalmente
  associado a um widget, cujo operador de igualdade é usado para influenciar o
  algoritmo de reconciliação.

[^6]: Por acessibilidade, e para dar aos aplicativos
  alguns milissegundos extras entre o momento em que um widget é construído e o
  momento em que ele aparece na tela, o viewport cria (mas não pinta)
  widgets para algumas centenas de pixels antes e depois dos widgets visíveis.

[^7]: Essa abordagem foi popularizada pela
  primeira vez pela biblioteca React, do Facebook.

[^8]: Na prática, o valor _t_ pode
  extrapolar o intervalo de 0.0 a 1.0, e isso acontece em algumas curvas. Por
  exemplo, as curvas "elásticas" ultrapassam o alvo brevemente para representar
  um efeito de quique. A lógica de interpolação normalmente consegue extrapolar
  para além do início ou do fim, conforme apropriado. Para alguns tipos, por
  exemplo, ao interpolar cores, o valor _t_ é efetivamente limitado ao intervalo
  de 0.0 a 1.0.
