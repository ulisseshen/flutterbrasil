---
ia-translate: true
title: Por Dentro do Flutter
description: Aprenda sobre o funcionamento interno do Flutter com um dos engenheiros fundadores.
---

Este documento descreve o funcionamento interno do toolkit Flutter que torna
possível a API do Flutter. Como os widgets Flutter são construídos usando composição
agressiva, interfaces de usuário construídas com Flutter têm um grande número de
widgets. Para suportar essa carga de trabalho, Flutter usa algoritmos sublineares para
layout e construção de widgets, bem como estruturas de dados que tornam a cirurgia de
árvore eficiente e que têm várias otimizações de fator constante.
Com alguns detalhes adicionais, esse design também facilita para os desenvolvedores
criar listas de rolagem infinitas usando callbacks que constroem exatamente aqueles
widgets que estão visíveis para o usuário.

## Composição agressiva

Um dos aspectos mais distintivos do Flutter é sua _composição
agressiva_. Widgets são construídos compondo outros widgets,
que são eles mesmos construídos de widgets progressivamente mais básicos.
Por exemplo, `Padding` é um widget em vez de uma propriedade de outros widgets.
Como resultado, interfaces de usuário construídas com Flutter consistem de muitos,
muitos widgets.

A recursão de construção de widgets termina em `RenderObjectWidgets`,
que são widgets que criam nós na _árvore de renderização_ subjacente.
A render tree é uma estrutura de dados que armazena a geometria da interface do
usuário, que é computada durante o _layout_ e usada durante a _pintura_ e
_hit testing_. A maioria dos desenvolvedores Flutter não cria render objects diretamente
mas, em vez disso, manipula a render tree usando widgets.

Para suportar composição agressiva na camada de widget,
Flutter usa vários algoritmos e otimizações eficientes tanto nas
camadas de widget quanto de render tree, que são descritas nas
subseções a seguir.

### Layout sublinear

Com um grande número de widgets e render objects, a chave para um bom
desempenho são algoritmos eficientes. De importância primordial é o
desempenho do _layout_, que é o algoritmo que determina a
geometria (por exemplo, o tamanho e posição) dos render objects.
Alguns outros toolkits usam algoritmos de layout que são O(N²) ou pior
(por exemplo, iteração de ponto fixo em algum domínio de constraints).
Flutter visa desempenho linear para layout inicial, e _desempenho de layout
sublinear_ no caso comum de atualizar subsequentemente um
layout existente. Tipicamente, a quantidade de tempo gasto em layout deve
escalar mais lentamente do que o número de render objects.

Flutter executa um layout por frame, e o algoritmo de layout funciona
em uma única passagem. _Constraints_ são passadas para baixo na árvore por objetos
pai chamando o método layout em cada um de seus filhos.
Os filhos executam recursivamente seu próprio layout e então retornam
_geometria_ subindo na árvore retornando de seu método layout. Importante,
uma vez que um render object retornou de seu método layout, aquele render
object não será visitado novamente[^1]
até o layout para o próximo frame. Essa abordagem combina o que poderia
ser passes separados de medida e layout em uma única passagem e,
como resultado, cada render object é visitado _no máximo duas vezes_[^2] durante o layout:
uma vez no caminho para baixo na árvore, e uma vez no caminho para cima na árvore.

Flutter tem várias especializações deste protocolo geral.
A especialização mais comum é `RenderBox`, que opera em
coordenadas cartesianas bidimensionais. No box layout, as constraints
são uma largura mínima e máxima e uma altura mínima e máxima. Durante o layout,
o filho determina sua geometria escolhendo um tamanho dentro desses limites.
Depois que o filho retorna do layout, o pai decide a posição do filho
no sistema de coordenadas do pai[^3].
Note que o layout do filho não pode depender de sua posição,
já que a posição não é determinada até depois que o filho
retorna do layout. Como resultado, o pai é livre para reposicionar
o filho sem precisar recomputar seu layout.

De forma mais geral, durante o layout, a _única_ informação que flui do
pai para o filho são as constraints e a _única_ informação que
flui do filho para o pai é a geometria. Essas invariantes podem reduzir
a quantidade de trabalho necessário durante o layout:

* Se o filho não marcou seu próprio layout como sujo, o filho pode
  retornar imediatamente do layout, cortando a caminhada, desde que o
  pai dê ao filho as mesmas constraints que o filho recebeu
  durante o layout anterior.

* Sempre que um pai chama o método layout de um filho, o pai indica
  se ele usa as informações de tamanho retornadas do filho. Se,
  como frequentemente acontece, o pai não usa as informações de tamanho,
  então o pai não precisa recomputar seu layout se o filho seleciona
  um novo tamanho porque o pai tem garantia de que o novo tamanho
  estará em conformidade com as constraints existentes.

* _Tight_ constraints são aquelas que podem ser satisfeitas por exatamente uma
  geometria válida. Por exemplo, se as larguras mínima e máxima são iguais
  uma à outra e as alturas mínima e máxima são iguais uma à outra,
  o único tamanho que satisfaz essas constraints é aquele com aquela
  largura e altura. Se o pai fornece tight constraints,
  então o pai não precisa recomputar seu layout sempre que o filho
  recomputa seu layout, mesmo que o pai use o tamanho do filho
  em seu layout, porque o filho não pode mudar de tamanho sem novas
  constraints de seu pai.

* Um render object pode declarar que ele usa as constraints fornecidas
  pelo pai apenas para determinar sua geometria. Tal declaração
  informa o framework que o pai daquele render object não
  precisa recomputar seu layout quando o filho recomputa seu layout
  _mesmo se as constraints não forem tight_ e _mesmo se o layout do pai
  depende do tamanho do filho_, porque o filho não pode mudar
  de tamanho sem novas constraints de seu pai.

Como resultado dessas otimizações, quando a render object tree contém
nós sujos, apenas aqueles nós e uma parte limitada da subárvore ao redor
deles são visitados durante o layout.

### Construção de widget sublinear

Similar ao algoritmo de layout, o algoritmo de construção de widget do Flutter
é sublinear. Depois de serem construídos, os widgets são mantidos pela _árvore
de elementos_, que retém a estrutura lógica da interface do usuário.
A element tree é necessária porque os próprios widgets são
_imutáveis_, o que significa (entre outras coisas), que eles não podem lembrar de seus
relacionamentos pai ou filho com outros widgets. A element tree também
mantém os objetos _state_ associados a stateful widgets.

Em resposta a entrada do usuário (ou outros estímulos), um elemento pode se tornar sujo,
por exemplo, se o desenvolvedor chamar `setState()` no objeto state associado.
O framework mantém uma lista de elementos sujos e pula diretamente
para eles durante a fase de _build_, pulando elementos limpos. Durante
a fase de build, a informação flui _unidirecionalmente_ para baixo na element
tree, o que significa que cada elemento é visitado no máximo uma vez durante a fase de
build. Uma vez limpo, um elemento não pode se tornar sujo novamente porque,
por indução, todos os seus elementos ancestrais também estão limpos[^4].

Como os widgets são _imutáveis_, se um elemento não se marcou como
sujo, o elemento pode retornar imediatamente do build, cortando a caminhada,
se o pai reconstrói o elemento com um widget idêntico. Além disso,
o elemento precisa apenas comparar a identidade de objeto das duas referências de widget
para estabelecer que o novo widget é o mesmo que
o widget antigo. Os desenvolvedores exploram essa otimização para implementar o
padrão de _reprojeção_, no qual um widget inclui um widget filho pré-construído
armazenado como uma variável membro em seu build.

Durante o build, o Flutter também evita caminhar pela cadeia pai usando
`InheritedWidgets`. Se os widgets comumente caminhassem por sua cadeia pai,
por exemplo, para determinar a cor do tema atual, a fase de build
se tornaria O(N²) na profundidade da árvore, que pode ser bastante
grande devido à composição agressiva. Para evitar essas caminhadas de pai,
o framework empurra informações para baixo na element tree mantendo
uma tabela hash de `InheritedWidget`s em cada elemento. Tipicamente, muitos
elementos referenciarão a mesma tabela hash, que muda apenas em
elementos que introduzem um novo `InheritedWidget`.

### Reconciliação linear {#linear-reconciliation}

Ao contrário da crença popular, o Flutter não emprega um algoritmo de tree-diffing.
Em vez disso, o framework decide se reutiliza elementos examinando
a lista de filhos para cada elemento independentemente usando um algoritmo O(N).
O algoritmo de reconciliação de lista de filhos otimiza para os
seguintes casos:

* A lista de filhos antiga está vazia.
* As duas listas são idênticas.
* Há uma inserção ou remoção de um ou mais widgets em exatamente
  um lugar na lista.
* Se cada lista contém um widget com a mesma key[^5],
  os dois widgets são correspondidos.

A abordagem geral é corresponder o início e o fim de ambas as listas
de filhos comparando o tipo de runtime e key de cada widget,
potencialmente encontrando um intervalo não vazio no meio de cada lista
que contém todos os filhos não correspondidos. O framework então coloca
os filhos no intervalo na lista de filhos antiga em uma tabela hash
baseada em suas keys. Em seguida, o framework caminha pelo intervalo na nova
lista de filhos e consulta a tabela hash por key para correspondências. Filhos não correspondidos
são descartados e reconstruídos do zero, enquanto filhos correspondidos
são reconstruídos com seus novos widgets.

### Cirurgia de árvore

Reutilizar elementos é importante para o desempenho porque elementos possuem
duas partes críticas de dados: o state para stateful widgets e os
render objects subjacentes. Quando o framework é capaz de reutilizar um elemento,
o state para aquela parte lógica da interface do usuário é preservado
e as informações de layout computadas anteriormente podem ser reutilizadas,
frequentemente evitando caminhadas de subárvore inteiras. De fato, reutilizar elementos é
tão valioso que o Flutter suporta mutações de árvore _não-locais_ que
preservam state e informações de layout.

Desenvolvedores podem executar uma mutação de árvore não-local associando uma `GlobalKey`
com um de seus widgets. Cada global key é única em toda a
aplicação inteira e é registrada com uma tabela hash específica da thread.
Durante a fase de build, o desenvolvedor pode mover um widget com uma global
key para uma localização arbitrária na element tree. Em vez de construir
um elemento fresco naquela localização, o framework verificará a tabela
hash e reparentará o elemento existente de sua localização anterior para
sua nova localização, preservando a subárvore inteira.

Os render objects na subárvore reparentada são capazes de preservar
suas informações de layout porque as constraints de layout são a única
informação que flui de pai para filho na render tree.
O novo pai é marcado como sujo para layout porque sua lista de filhos
mudou, mas se o novo pai passa ao filho as mesmas constraints de layout
que o filho recebeu de seu pai antigo, o filho pode
retornar imediatamente do layout, cortando a caminhada.

Global keys e mutações de árvore não-locais são usadas extensivamente por
desenvolvedores para alcançar efeitos como hero transitions e navegação.

### Otimizações de fator constante

Além dessas otimizações algorítmicas, alcançar composição agressiva
também depende de várias otimizações importantes de fator
constante. Essas otimizações são mais importantes nas folhas dos
principais algoritmos discutidos acima.

* **Agnóstico ao modelo de filhos.** Ao contrário da maioria dos toolkits, que usam listas de filhos,
  a render tree do Flutter não se compromete com um modelo de filhos específico.
  Por exemplo, a classe `RenderBox` tem um método `visitChildren()` abstrato
  em vez de uma interface concreta `firstChild` e `nextSibling`.
  Muitas subclasses suportam apenas um único filho, mantido diretamente como uma variável
  membro, em vez de uma lista de filhos. Por exemplo, `RenderPadding`
  suporta apenas um único filho e, como resultado, tem um método layout mais simples
  que leva menos tempo para executar.

* **Visual render tree, logical widget tree.** No Flutter, a render
  tree opera em um sistema de coordenadas visual independente de dispositivo,
  o que significa que valores menores na coordenada x estão sempre à
  esquerda, mesmo se a direção de leitura atual for da direita para a esquerda.
  A widget tree tipicamente opera em coordenadas lógicas, significando
  com valores _start_ e _end_ cuja interpretação visual depende
  da direção de leitura. A transformação de coordenadas lógicas para visuais
  é feita na passagem entre a widget tree e a
  render tree. Essa abordagem é mais eficiente porque cálculos de layout e
  pintura na render tree acontecem com mais frequência do que a
  passagem widget-to-render tree e podem evitar conversões de coordenadas repetidas.

* **Texto tratado por um render object especializado.** A grande maioria
  dos render objects são ignorantes das complexidades do texto. Em vez disso,
  o texto é tratado por um render object especializado, `RenderParagraph`,
  que é uma folha na render tree. Em vez de fazer subclasse de um
  render object consciente de texto, desenvolvedores incorporam texto em sua
  interface de usuário usando composição. Esse padrão significa que `RenderParagraph`
  pode evitar recomputar seu layout de texto desde que seu pai forneça
  as mesmas constraints de layout, o que é comum, mesmo durante a cirurgia de árvore.

* **Objetos observáveis.** Flutter usa tanto o paradigma de observação de modelo quanto
  o paradigma reativo. Obviamente, o paradigma reativo é dominante,
  mas Flutter usa objetos de modelo observáveis para algumas estruturas de dados folha.
  Por exemplo, `Animation`s notificam uma lista de observadores quando seu valor muda.
  Flutter passa esses objetos observáveis da widget tree para a
  render tree, que os observa diretamente e invalida apenas o
  estágio apropriado do pipeline quando eles mudam. Por exemplo,
  uma mudança em uma `Animation<Color>` pode disparar apenas a fase de paint
  em vez de ambas as fases build e paint.

Tomadas em conjunto e somadas sobre as grandes árvores criadas por composição
agressiva, essas otimizações têm um efeito substancial no desempenho.

### Separação das árvores Element e RenderObject

As árvores `RenderObject` e `Element` (Widget) no Flutter são isomórficas
(estritamente falando, a árvore `RenderObject` é um subconjunto da árvore
`Element`). Uma simplificação óbvia seria combinar essas árvores em
uma árvore. No entanto, na prática há vários benefícios em ter
essas árvores separadas:

* **Desempenho.** Quando o layout muda, apenas as partes relevantes da
  layout tree precisam ser percorridas. Devido à composição, a element
  tree frequentemente tem muitos nós adicionais que teriam que ser pulados.

* **Clareza.** A separação mais clara de preocupações permite que o protocolo de widget
  e o protocolo de render object sejam especializados para
  suas necessidades específicas, simplificando a superfície da API e assim reduzindo
  o risco de bugs e o fardo de testes.

* **Segurança de tipo.** A render object tree pode ser mais type safe já que ela
  pode garantir em runtime que os filhos serão do tipo apropriado
  (cada sistema de coordenadas, por exemplo, tem seu próprio tipo de render object).
  Widgets de composição podem ser agnósticos sobre o sistema de coordenadas usado
  durante o layout (por exemplo, o mesmo widget expondo uma parte do modelo do app
  poderia ser usado tanto em um box layout quanto em um sliver layout), e assim
  na element tree, verificar o tipo dos render objects exigiria
  uma caminhada de árvore.

## Rolagem infinita

Listas de rolagem infinita são notoriamente difíceis para toolkits.
Flutter suporta listas de rolagem infinita com uma interface simples
baseada no padrão _builder_, no qual uma `ListView` usa um callback
para construir widgets sob demanda conforme eles se tornam visíveis ao usuário durante
a rolagem. Suportar esse recurso requer _layout ciente de viewport_
e _construção de widgets sob demanda_.

### Layout ciente de viewport

Como a maioria das coisas no Flutter, widgets roláveis são construídos usando
composição. A parte externa de um widget rolável é um `Viewport`,
que é uma caixa que é "maior por dentro", significando que seus filhos
podem se estender além dos limites do viewport e podem ser rolados para
visualização. No entanto, em vez de ter filhos `RenderBox`, um viewport tem
filhos `RenderSliver`, conhecidos como _slivers_, que têm um
protocolo de layout ciente de viewport.

O protocolo de layout sliver corresponde à estrutura do protocolo de layout
box no sentido de que pais passam constraints para seus filhos e
recebem geometria em retorno. No entanto, os dados de constraint e geometria
diferem entre os dois protocolos. No protocolo sliver, filhos
recebem informações sobre o viewport, incluindo a quantidade de
espaço visível restante. Os dados de geometria que eles retornam habilitam uma
variedade de efeitos ligados à rolagem, incluindo cabeçalhos recolhíveis e
parallax.

Slivers diferentes preenchem o espaço disponível no viewport de formas diferentes.
Por exemplo, um sliver que produz uma lista linear de filhos coloca
cada filho em ordem até que o sliver fique sem filhos ou
fique sem espaço. Similarmente, um sliver que produz uma grid bidimensional
de filhos preenche apenas a porção de sua grid que está visível.
Como eles são cientes de quanto espaço está visível, slivers podem produzir
um número finito de filhos mesmo que tenham o potencial de produzir
um número ilimitado de filhos.

Slivers podem ser compostos para criar layouts roláveis personalizados e efeitos.
Por exemplo, um único viewport pode ter um cabeçalho recolhível seguido
por uma lista linear e então uma grid. Todos os três slivers cooperarão através
do protocolo de layout sliver para produzir apenas aqueles filhos que estão realmente
visíveis através do viewport, independentemente de se aqueles filhos pertencem
ao cabeçalho, à lista ou à grid[^6].

### Construindo widgets sob demanda {#building-widgets-on-demand}

Se o Flutter tivesse um pipeline estrito _build-then-layout-then-paint_,
o acima seria insuficiente para implementar uma lista de rolagem
infinita porque as informações sobre quanto espaço está visível através
do viewport estão disponíveis apenas durante a fase de layout. Sem
maquinário adicional, a fase de layout é tarde demais para construir os
widgets necessários para preencher o espaço. Flutter resolve esse problema
intercalando as fases build e layout do pipeline. Em qualquer
ponto na fase de layout, o framework pode começar a construir novos
widgets sob demanda _desde que aqueles widgets sejam descendentes do
render object atualmente executando layout_.

Intercalar build e layout é possível apenas devido aos controles estritos
na propagação de informações nos algoritmos de build e layout.
Especificamente, durante a fase de build, a informação pode propagar apenas
para baixo na árvore. Quando um render object está executando layout, a caminhada de layout
não visitou a subárvore abaixo daquele render object, o que significa
que escritas geradas ao construir naquela subárvore não podem invalidar nenhuma
informação que entrou no cálculo de layout até agora. Similarmente,
uma vez que o layout retornou de um render object, aquele render object
nunca será visitado novamente durante este layout, o que significa que quaisquer escritas
geradas por cálculos de layout subsequentes não podem invalidar as
informações usadas para construir a subárvore do render object.

Adicionalmente, reconciliação linear e cirurgia de árvore são essenciais
para atualizar eficientemente elementos durante a rolagem e para modificar
a render tree quando elementos são rolados para dentro e para fora da visualização na
borda do viewport.

## Ergonomia de API

Ser rápido só importa se o framework pode realmente ser usado efetivamente.
Para guiar o design da API do Flutter em direção a maior usabilidade, o Flutter foi
repetidamente testado em estudos extensivos de UX com desenvolvedores. Esses estudos
às vezes confirmaram decisões de design pré-existentes, às vezes ajudaram a guiar
a priorização de recursos, e às vezes mudaram a direção do
design da API. Por exemplo, as APIs do Flutter são fortemente documentadas; estudos de UX
confirmaram o valor de tal documentação, mas também destacaram
a necessidade especificamente de código de exemplo e diagramas ilustrativos.

Esta seção discute algumas das decisões tomadas no design da API do Flutter
em prol da usabilidade.

### Especializando APIs para corresponder à mentalidade do desenvolvedor

A classe base para nós nas árvores `Widget`, `Element` e `RenderObject`
do Flutter não define um modelo de filhos. Isso permite que cada nó seja
especializado para o modelo de filhos que é aplicável àquele nó.

A maioria dos objetos `Widget` tem um único filho `Widget`, e portanto expõe apenas
um único parâmetro `child`. Alguns widgets suportam um número arbitrário de
filhos, e expõem um parâmetro `children` que recebe uma lista.
Alguns widgets não têm filhos e não reservam memória,
e não têm parâmetros para eles. Similarmente, `RenderObjects` expõem APIs
específicas ao seu modelo de filhos. `RenderImage` é um nó folha, e não tem
conceito de filhos. `RenderPadding` recebe um único filho, então tem armazenamento
para um único ponteiro para um único filho. `RenderFlex` recebe um número arbitrário
de filhos e os gerencia como uma lista encadeada.

Em alguns casos raros, modelos de filhos mais complicados são usados. O
construtor do render object `RenderTable` recebe uma matriz de matrizes de
filhos, a classe expõe getters e setters que controlam o número
de linhas e colunas, e há métodos específicos para substituir
filhos individuais por coordenada x,y, para adicionar uma linha, para fornecer uma
nova matriz de matrizes de filhos, e para substituir a lista inteira de filhos
com uma única matriz e uma contagem de colunas. Na implementação,
o objeto não usa uma lista encadeada como a maioria dos render objects mas
em vez disso usa uma matriz indexável.

Os widgets `Chip` e objetos `InputDecoration` têm campos que correspondem
aos slots que existem nos controles relevantes. Onde um modelo de filhos único-para-todos
forçaria semânticas a serem camadas em cima de uma lista de
filhos, por exemplo, definindo o primeiro filho como o valor de prefixo
e o segundo como o sufixo, o modelo de filhos dedicado permite
propriedades nomeadas dedicadas serem usadas em vez disso.

Essa flexibilidade permite que cada nó nessas árvores seja manipulado da
maneira mais idiomática para seu papel. É raro querer inserir uma célula
em uma tabela, fazendo todas as outras células envolverem; similarmente,
é raro querer remover um filho de uma flex row por índice em vez
de por referência.

O objeto `RenderParagraph` é o caso mais extremo: ele tem um filho de
um tipo inteiramente diferente, `TextSpan`. No limite do `RenderParagraph`,
a árvore `RenderObject` transiciona para ser uma árvore `TextSpan`.

A abordagem geral de especializar APIs para atender às
expectativas do desenvolvedor é aplicada a mais do que apenas modelos de filhos.

Alguns widgets bastante triviais existem especificamente para que desenvolvedores
os encontrem ao procurar uma solução para um problema. Adicionar um
espaço a uma row ou column é facilmente feito uma vez que se sabe como, usando
o widget `Expanded` e um filho `SizedBox` de tamanho zero, mas descobrir
esse padrão é desnecessário porque procurar por `space`
descobre o widget `Spacer`, que usa `Expanded` e `SizedBox` diretamente
para alcançar o efeito.

Similarmente, ocultar uma subárvore de widget é facilmente feito não incluindo a
subárvore de widget no build. No entanto, desenvolvedores tipicamente esperam
que haja um widget para fazer isso, e então o widget `Visibility` existe
para envolver esse padrão em um widget reutilizável trivial.

### Argumentos explícitos

Frameworks de UI tendem a ter muitas propriedades, de modo que um desenvolvedor raramente
é capaz de lembrar o significado semântico de cada argumento de construtor
de cada classe. Como Flutter usa o paradigma reativo,
é comum que métodos build no Flutter tenham muitas chamadas a
construtores. Ao aproveitar o suporte do Dart para argumentos nomeados,
a API do Flutter é capaz de manter tais métodos build claros e compreensíveis.

Esse padrão é estendido a qualquer método com múltiplos argumentos,
e em particular é estendido a qualquer argumento booleano, de modo que
literais isolados `true` ou `false` em chamadas de método são sempre autodocumentados.
Além disso, para evitar confusão comumente causada por duplas negativas
em APIs, argumentos e propriedades booleanas são sempre nomeados na
forma positiva (por exemplo, `enabled: true` em vez de `disabled: false`).

### Pavimentando armadilhas

Uma técnica usada em vários lugares no framework Flutter é
definir a API de tal forma que condições de erro não existem. Isso remove
classes inteiras de erros da consideração.

Por exemplo, funções de interpolação permitem que uma ou ambas as extremidades da
interpolação sejam null, em vez de definir isso como um caso de erro:
interpolar entre dois valores null é sempre null, e interpolar
de um valor null ou para um valor null é o equivalente a interpolar
para o análogo zero para o tipo dado. Isso significa que desenvolvedores
que acidentalmente passam null para uma função de interpolação não atingirão
um caso de erro, mas em vez disso obterão um resultado razoável.

Um exemplo mais sutil está no algoritmo de layout `Flex`. O conceito deste
layout é que o espaço dado ao render object flex é
dividido entre seus filhos, então o tamanho do flex deve ser o
todo do espaço disponível. No design original, fornecer
espaço infinito falharia: isso implicaria que o flex deveria ser
infinitamente grande, uma configuração de layout inútil. Em vez disso, a API
foi ajustada para que quando espaço infinito for alocado ao flex
render object, o render object se dimensione para caber no tamanho desejado
dos filhos, reduzindo o número possível de casos de erro.

A abordagem também é usada para evitar ter construtores que permitem
dados inconsistentes serem criados. Por exemplo, o construtor `PointerDownEvent`
não permite que a propriedade `down` de `PointerEvent` seja
definida como `false` (uma situação que seria autocontraditória);
em vez disso, o construtor não tem um parâmetro para o campo `down`
e sempre o define como `true`.

Em geral, a abordagem é definir interpretações válidas para todos
os valores no domínio de entrada. O exemplo mais simples é o construtor `Color`.
Em vez de receber quatro inteiros, um para red, um para green,
um para blue e um para alpha, cada um dos quais poderia estar fora do intervalo,
o construtor padrão recebe um único valor inteiro, e define
o significado de cada bit (por exemplo, os oito bits inferiores definem o
componente red), de modo que qualquer valor de entrada é um valor de cor válido.

Um exemplo mais elaborado é a função `paintImage()`. Esta função
recebe onze argumentos, alguns com domínios de entrada bastante amplos, mas eles
foram cuidadosamente projetados para serem principalmente ortogonais uns aos outros,
de modo que há muito poucas combinações inválidas.

### Reportando casos de erro agressivamente

Nem todas as condições de erro podem ser projetadas para fora. Para aquelas que permanecem,
em builds de debug, o Flutter geralmente tenta capturar os erros muito
cedo e reportá-los imediatamente. Asserts são amplamente usados.
Argumentos de construtor são verificados em detalhes quanto à sanidade. Ciclos de vida são
monitorados e quando inconsistências são detectadas elas imediatamente
causam o lançamento de uma exceção.

Em alguns casos, isso é levado a extremos: por exemplo, ao executar
testes unitários, independentemente do que mais o teste esteja fazendo, cada subclasse `RenderBox`
que é laid out inspeciona agressivamente se seus métodos de dimensionamento intrínseco
cumprem o contrato de dimensionamento intrínseco. Isso ajuda a capturar
erros em APIs que de outra forma poderiam não ser exercitadas.

Quando exceções são lançadas, elas incluem o máximo de informações
disponíveis. Algumas mensagens de erro do Flutter investigam proativamente o
stack trace associado para determinar a localização mais provável do
bug real. Outros caminham pelas árvores relevantes para determinar a fonte
de dados ruins. Os erros mais comuns incluem instruções detalhadas
incluindo em alguns casos código de exemplo para evitar o erro, ou links
para documentação adicional.

### Paradigma reativo

APIs de árvore mutável baseada sofrem de um padrão de acesso dicotômico:
criar o estado original da árvore tipicamente usa um conjunto muito diferente
de operações do que atualizações subsequentes. A camada de renderização do Flutter
usa esse paradigma, pois é uma maneira eficaz de manter uma árvore persistente,
que é chave para layout e pintura eficientes. No entanto, isso significa
que interação direta com a camada de renderização é desajeitada na melhor das hipóteses
e propensa a bugs na pior.

A camada de widget do Flutter introduz um mecanismo de composição usando o
paradigma reativo[^7] para manipular a render tree subjacente.
Essa API abstrai a manipulação de árvore combinando os passos de criação de árvore
e mutação de árvore em um único passo de descrição de árvore (build),
onde, após cada mudança no estado do sistema, a nova configuração
da interface do usuário é descrita pelo desenvolvedor e o framework
computa a série de mutações de árvore necessárias para refletir essa nova
configuração.

### Interpolação

Como o framework do Flutter encoraja desenvolvedores a descrever a configuração da interface
correspondente ao estado atual da aplicação, um mecanismo existe
para animar implicitamente entre essas configurações.

Por exemplo, suponha que no estado S<sub>1</sub> a interface consiste
de um círculo, mas no estado S<sub>2</sub> ela consiste de um quadrado.
Sem um mecanismo de animação, a mudança de estado teria uma
mudança de interface brusca. Uma animação implícita permite que o círculo seja suavemente
transformado em quadrado ao longo de vários frames.

Cada recurso que pode ser implicitamente animado tem um widget stateful que
mantém um registro do valor atual da entrada, e inicia uma sequência de animação
sempre que o valor de entrada muda, fazendo a transição do valor atual
para o novo valor ao longo de uma duração especificada.

Isso é implementado usando funções `lerp` (interpolação linear) usando
objetos imutáveis. Cada estado (círculo e quadrado, neste caso)
é representado como um objeto imutável que é configurado com
configurações apropriadas (cor, largura de traço, etc) e sabe como pintar
a si mesmo. Quando é hora de desenhar os passos intermediários durante a animação,
os valores inicial e final são passados para a função `lerp` apropriada
junto com um valor _t_ representando o ponto ao longo da animação,
onde 0.0 representa o `start` e 1.0 representa o `end`[^8],
e a função retorna um terceiro objeto imutável representando o
estágio intermediário.

Para a transição círculo-para-quadrado, a função `lerp` retornaria
um objeto representando um "quadrado arredondado" com um raio descrito como
uma fração derivada do valor _t_, uma cor interpolada usando a
função `lerp` para cores, e uma largura de traço interpolada usando a
função `lerp` para doubles. Aquele objeto, que implementa a
mesma interface que círculos e quadrados, então seria capaz de pintar
a si mesmo quando solicitado.

Essa técnica permite que a maquinaria de estado, o mapeamento de estados para
configurações, a maquinaria de animação, a maquinaria de interpolação,
e a lógica específica relacionada a como pintar cada frame sejam
inteiramente separados uns dos outros.

Essa abordagem é amplamente aplicável. No Flutter, tipos básicos como
`Color` e `Shape` podem ser interpolados, mas também tipos muito mais elaborados
como `Decoration`, `TextStyle`, ou `Theme`. Esses são
tipicamente construídos de componentes que podem eles mesmos ser interpolados,
e interpolar os objetos mais complicados é frequentemente tão simples quanto
recursivamente interpolar todos os valores que descrevem os
objetos complicados.

Alguns objetos interpoláveis são definidos por hierarquias de classes. Por exemplo,
formas são representadas pela interface `ShapeBorder`, e existe uma
variedade de formas, incluindo `BeveledRectangleBorder`, `BoxBorder`,
`CircleBorder`, `RoundedRectangleBorder` e `StadiumBorder`. Uma única
função `lerp` não pode antecipar todos os tipos possíveis,
e portanto a interface define métodos `lerpFrom` e `lerpTo`,
para os quais o método estático `lerp` delega. Quando instruído a interpolar de
uma forma A para uma forma B, primeiro B é perguntado se pode `lerpFrom` A, então,
se não pode, A é perguntado se pode `lerpTo` B. (Se nenhum for
possível, então a função retorna A de valores de `t` menores que 0.5,
e retorna B caso contrário.)

Isso permite que a hierarquia de classes seja arbitrariamente estendida, com adições posteriores
sendo capazes de interpolar entre valores previamente conhecidos
e eles mesmos.

Em alguns casos, a interpolação em si não pode ser descrita por nenhuma das
classes disponíveis, e uma classe privada é definida para descrever o
estágio intermediário. Esse é o caso, por exemplo, ao interpolar
entre um `CircleBorder` e um `RoundedRectangleBorder`.

Esse mecanismo tem mais uma vantagem adicional: ele pode lidar com interpolação
de estágios intermediários para novos valores. Por exemplo, no meio de uma
transição círculo-para-quadrado, a forma poderia ser mudada mais uma vez,
fazendo a animação precisar interpolar para um triângulo. Desde que
a classe triângulo possa `lerpFrom` a classe quadrado-arredondado intermediária,
a transição pode ser executada perfeitamente.

## Conclusão

O slogan do Flutter, "tudo é um widget," gira em torno de construir
interfaces de usuário compondo widgets que são, por sua vez, compostos de
widgets progressivamente mais básicos. O resultado desta composição
agressiva é um grande número de widgets que requerem
algoritmos e estruturas de dados cuidadosamente projetados para processar eficientemente.
Com algum design adicional, essas estruturas de dados também facilitam
para desenvolvedores criar listas de rolagem infinitas que constroem
widgets sob demanda quando eles se tornam visíveis.

---
**Notas de rodapé:**

[^1]: Para layout, pelo menos. Ele pode ser revisitado
  para pintura, para construir a árvore de acessibilidade se necessário,
  e para hit testing se necessário.

[^2]: A realidade, é claro, é um pouco mais
  complicada. Alguns layouts envolvem dimensões intrínsecas ou medições de baseline,
  que envolvem uma caminhada adicional da subárvore relevante
  (cache agressivo é usado para mitigar o potencial de desempenho quadrático
  no pior caso). Esses casos, no entanto, são surpreendentemente
  raros. Em particular, dimensões intrínsecas não são necessárias para o
  caso comum de shrink-wrapping.

[^3]: Tecnicamente, a posição do filho não é
  parte de sua geometria RenderBox e portanto não precisa realmente ser
  calculada durante o layout. Muitos render objects posicionam implicitamente
  seu único filho em 0,0 relativo à sua própria origem, o que
  não requer computação ou armazenamento. Alguns render objects
  evitam computar a posição de seus filhos até o último
  momento possível (por exemplo, durante a fase de paint), para evitar
  a computação inteiramente se eles não forem subsequentemente pintados.

[^4]: Existe uma exceção a esta regra.
  Como discutido na seção [Construindo widgets sob demanda](#building-widgets-on-demand),
  alguns widgets podem ser reconstruídos como resultado de uma mudança nas
  constraints de layout. Se um widget se marcou como sujo por razões não relacionadas no
  mesmo frame em que ele também é afetado por uma mudança nas constraints de layout,
  ele será atualizado duas vezes. Esse build redundante é limitado ao
  próprio widget e não impacta seus descendentes.

[^5]: Uma key é um objeto opaco opcionalmente
  associado a um widget cujo operador de igualdade é usado para influenciar
  o algoritmo de reconciliação.

[^6]: Para acessibilidade, e para dar às aplicações
  alguns milissegundos extras entre quando um widget é construído e quando ele
  aparece na tela, o viewport cria (mas não pinta)
  widgets para algumas centenas de pixels antes e depois dos widgets visíveis.

[^7]: Essa abordagem foi primeiro popularizada pela
  biblioteca React do Facebook.

[^8]: Na prática, o valor _t_ é permitido
  estender além do intervalo 0.0-1.0, e o faz para algumas curvas. Por
  exemplo, as curvas "elastic" ultrapassam brevemente para representar
  um efeito de rebote. A lógica de interpolação tipicamente pode extrapolar
  além do início ou fim conforme apropriado. Para alguns tipos, por exemplo,
  ao interpolar cores, o valor _t_ é efetivamente restringido ao
  intervalo 0.0-1.0.
