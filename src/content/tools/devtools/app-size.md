---
ia-translate: true
title: Use a ferramenta de tamanho de app
description: Aprenda como usar a ferramenta de tamanho de app do DevTools.
---

## O que é isso?

A ferramenta de tamanho de app permite analisar o tamanho total do seu app.
Você pode visualizar um único snapshot de "informações de tamanho"
usando a [aba Analysis][Analysis tab], ou comparar dois
snapshots diferentes de "informações de tamanho" usando a [aba Diff][Diff tab].

### O que são "informações de tamanho"?

"Informações de tamanho" contêm dados de tamanho para código Dart,
código nativo e elementos não codificados do seu app,
como o pacote de aplicação, assets e fontes. Um arquivo de "informações
de tamanho" contém dados para o panorama completo
do tamanho da sua aplicação.

### Informações de tamanho Dart

O compilador Dart AOT realiza tree-shaking no seu código
ao compilar sua aplicação (apenas nos modos profile ou release
&mdash;o compilador AOT não é usado para builds de debug,
que são compilados JIT). Isso significa que o compilador
tenta otimizar o tamanho do seu app removendo
partes de código que não são usadas ou estão inacessíveis.

Após o compilador otimizar seu código tanto quanto possível,
o resultado final pode ser resumido como a coleção de packages,
bibliotecas, classes e funções que existem na saída binária,
juntamente com seus tamanhos em bytes. Esta é a porção Dart das
"informações de tamanho" que podemos analisar na ferramenta de tamanho de app para otimizar
ainda mais o código Dart e rastrear problemas de tamanho.

## Como usar

Se DevTools já estiver conectado a uma aplicação em execução,
navegue até a aba "App Size".

![Screenshot of app size tab](/assets/images/docs/tools/devtools/app_size_tab.png)

Se DevTools não estiver conectado a uma aplicação em execução,
você pode acessar a ferramenta da página inicial
que aparece assim que você tenha iniciado
DevTools (veja [instruções de inicialização][launch instructions]).

![Screenshot of app size access on landing page](/assets/images/docs/tools/devtools/app_size_access_landing_page.png){:width="100%"}

## Aba Analysis

A aba Analysis permite inspecionar um único snapshot
de informações de tamanho. Você pode visualizar a estrutura hierárquica
dos dados de tamanho usando o treemap e a tabela,
e você pode visualizar dados de atribuição de código
(por exemplo, por que um pedaço de código está incluído em sua aplicação
compilada) usando a árvore dominadora e o grafo de chamadas.

![Screenshot of app size analysis](/assets/images/docs/tools/devtools/app_size_analysis.png){:width="100%"}

### Carregando um arquivo de tamanho

Quando você abre a aba Analysis, verá instruções
para carregar um arquivo de tamanho de app. Arraste e solte um arquivo de tamanho
de app no diálogo e clique em "Analyze Size".

![Screenshot of app size analysis loading screen](/assets/images/docs/tools/devtools/app_size_load_analysis.png){:width="100%"}

Veja [Gerando arquivos de tamanho][Generating size files] abaixo para informações sobre
como gerar arquivos de tamanho.

### Treemap e tabela

O treemap e a tabela mostram os dados hierárquicos para o tamanho do seu app.

#### Use o treemap

Um treemap é uma visualização para dados hierárquicos.
O espaço é dividido em retângulos,
onde cada retângulo é dimensionado e ordenado por alguma variável
quantitativa (neste caso, tamanho em bytes).
A área de cada retângulo é proporcional ao tamanho
que o nó ocupa na aplicação compilada. Dentro
de cada retângulo (chame um de A), existem retângulos
adicionais que existem um nível mais profundo na hierarquia
de dados (filhos de A).

Para detalhar uma célula no treemap, selecione a célula.
Isso reenraíza a árvore de modo que a célula selecionada se torna
a raiz visual do treemap.

Para navegar de volta, ou subir um nível, use o
navegador de breadcrumb no topo do treemap.

![Screenshot of treemap breadcrumb navigator](/assets/images/docs/tools/devtools/treemap_breadcrumbs.png){:width="100%"}

### Árvore dominadora e grafo de chamadas

Esta seção da página mostra dados de atribuição de tamanho de código
(por exemplo, por que um pedaço de código está incluído em sua
aplicação compilada). Esses dados são visíveis
na forma de uma árvore dominadora, bem como um grafo de chamadas.

#### Use a árvore dominadora

Uma [árvore dominadora][dominator tree] é uma árvore onde os
filhos de cada nó são aqueles nós que ele domina imediatamente.
Diz-se que um nó `a` "domina" um nó `b` se
todo caminho para `b` deve passar por `a`.

[dominator tree]: https://en.wikipedia.org/wiki/Dominator_(graph_theory)

Para colocar em contexto da análise de tamanho de app,
imagine que `package:a` importa tanto `package:b` quanto `package:c`,
e tanto `package:b` quanto `package:c` importam `package:d`.

```plaintext
package:a
|__ package:b
|   |__ package:d
|__ package:c
    |__ package:d
```

Neste exemplo, `package:a` domina `package:d`,
então a árvore dominadora para esses dados ficaria assim:

```plaintext
package:a
|__ package:b
|__ package:c
|__ package:d
```

Esta informação é útil para entender por que certas
partes de código estão presentes em sua aplicação compilada.
Por exemplo, se você estiver analisando o tamanho do seu app e encontrar
um package inesperado incluído no seu app compilado, você pode
usar a árvore dominadora para rastrear o package até sua fonte raiz.

![Screenshot of code size dominator tree](/assets/images/docs/tools/devtools/app_size_dominator_tree.png){:width="100%"}

#### Use o grafo de chamadas

Um grafo de chamadas fornece informações similares à árvore
dominadora no que diz respeito a ajudá-lo a entender por que o código existe
em uma aplicação compilada. No entanto, em vez de mostrar
as relações dominantes de um-para-muitos entre nós de dados
de tamanho de código como a árvore dominadora, o grafo de chamadas mostra as
relações muitos-para-muitos que existem entre nós de dados de tamanho de código.

Novamente, usando o seguinte exemplo:

```plaintext
package:a
|__ package:b
|   |__ package:d
|__ package:c
    |__ package:d
```

O grafo de chamadas para esses dados vincularia `package:d`
aos seus chamadores diretos, `package:b` e `package:c`,
em vez de seu "dominador", `package:a`.

```plaintext
package:a --> package:b -->
                              package:d
package:a --> package:c -->
```

Esta informação é útil para entender as
dependências refinadas entre partes do seu código
(packages, bibliotecas, classes, funções).

![Screenshot of code size call graph](/assets/images/docs/tools/devtools/app_size_call_graph.png){:width="100%"}

#### Devo usar a árvore dominadora ou o grafo de chamadas?

Use a árvore dominadora se você quiser entender a
causa *raiz* de por que um pedaço de código está incluído em sua
aplicação. Use o grafo de chamadas se você quiser entender
todos os caminhos de chamada para e de um pedaço de código.

Uma árvore dominadora é uma análise ou fatia de dados de grafo de chamadas,
onde os nós são conectados por "dominância" em vez de
hierarquia pai-filho. No caso onde um nó pai
domina um filho, a relação no grafo de chamadas e na
árvore dominadora seria idêntica, mas isso nem sempre é o caso.

No cenário onde o grafo de chamadas está completo
(existe uma aresta entre cada par de nós),
a árvore dominadora mostraria que `root` é o
dominador de cada nó no grafo.
Este é um exemplo onde o grafo de chamadas daria
a você uma melhor compreensão sobre por que um pedaço de código está
incluído em sua aplicação.

## Aba Diff

A aba Diff permite comparar dois snapshots de
informações de tamanho. Os dois arquivos de informações de tamanho
que você está comparando devem ser gerados de duas
versões diferentes do mesmo app; por exemplo,
o arquivo de tamanho gerado antes e depois
de mudanças no seu código. Você pode visualizar a
diferença entre os dois conjuntos de dados
usando o treemap e a tabela.

![Screenshot of app size diff](/assets/images/docs/tools/devtools/app_size_diff.png){:width="100%"}

### Carregando arquivos de tamanho

Quando você abre a aba **Diff**,
verá instruções para carregar arquivos de tamanho "old" e "new".
Novamente, esses arquivos precisam ser gerados da
mesma aplicação. Arraste e solte esses arquivos em
seus respectivos diálogos e clique em **Analyze Diff**.

![Screenshot of app size diff loading screen](/assets/images/docs/tools/devtools/app_size_load_diff.png){:width="100%"}

Veja [Gerando arquivos de tamanho][Generating size files] abaixo para informações
sobre como gerar esses arquivos.

### Treemap e tabela

Na view de diff, o treemap e a tabela de árvore mostram
apenas os dados que diferem entre os dois arquivos de tamanho importados.

Para perguntas sobre o uso do treemap, veja [Use o treemap][Use the treemap] acima.

## Gerando arquivos de tamanho

Para usar a ferramenta de tamanho de app, você precisará gerar um
arquivo de análise de tamanho do Flutter. Este arquivo contém informações de tamanho
para toda a sua aplicação (código nativo,
código Dart, assets, fontes, etc.), e você pode gerá-lo usando a
flag `--analyze-size`:

```console
flutter build <your target platform> --analyze-size
```

Isso compila sua aplicação, imprime um resumo de tamanho
na linha de comando e imprime uma linha
informando onde encontrar o arquivo de análise de tamanho.

```console
flutter build apk --analyze-size --target-platform=android-arm64
...
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
app-release.apk (total compressed)                               6 MB
...
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
A summary of your APK analysis can be found at: build/apk-code-size-analysis_01.json
```

Neste exemplo, importe o arquivo `build/apk-code-size-analysis_01.json`
na ferramenta de tamanho de app para analisar mais a fundo.
Para mais informações, veja [Documentação de Tamanho de App][App Size Documentation].

## Outros recursos

Para aprender como realizar uma análise de tamanho passo a passo do
Wonderous App usando DevTools, confira o
[tutorial da Ferramenta de Tamanho de App][app-size-tutorial]. Várias estratégias
para reduzir o tamanho de um app também são discutidas.

[Use the treemap]: #use-the-treemap
[Generating size files]: #generating-size-files
[Analysis tab]: #analysis-tab
[Diff tab]: #diff-tab
[launch instructions]: /tools/devtools#start
[App Size Documentation]: /perf/app-size#breaking-down-the-size
[app-size-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-app-size-tool-part-3-of-8-9be6e9ec42a2
