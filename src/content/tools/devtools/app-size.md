---
ia-translate: true
title: Usar a ferramenta de tamanho de app
description: Aprenda como usar a ferramenta de tamanho de app do DevTools.
---

## O que é?

A ferramenta de tamanho de app permite que você analise o tamanho total do seu app.
Você pode visualizar um único snapshot de "informações de tamanho"
usando a [aba Analysis][Analysis tab], ou comparar dois snapshots
diferentes de "informações de tamanho" usando a [aba Diff][Diff tab].

### O que são "informações de tamanho"?

"Informações de tamanho" contêm dados de tamanho para código Dart,
código nativo e elementos não-código do seu app,
como o pacote de aplicação, assets e fontes. Um arquivo de "informações
de tamanho" contém dados para o panorama total
do tamanho da sua aplicação.

### Informações de tamanho Dart

O compilador Dart AOT realiza tree-shaking no seu código
ao compilar sua aplicação (apenas modo profile ou release
&mdash;o compilador AOT não é usado para compilações debug,
que são compiladas JIT). Isso significa que o compilador
tenta otimizar o tamanho do seu app removendo
pedaços de código que não são usados ou são inalcançáveis.

Depois que o compilador otimiza seu código o máximo que pode,
o resultado final pode ser resumido como a coleção de pacotes,
bibliotecas, classes e funções que existem na saída binária,
junto com seu tamanho em bytes. Esta é a porção Dart das
"informações de tamanho" que podemos analisar na ferramenta de tamanho de app para
otimizar ainda mais o código Dart e rastrear problemas de tamanho.

## Como usar

Se DevTools já está conectado a uma aplicação em execução,
navegue para a aba "App Size".

![Screenshot of app size tab](/assets/images/docs/tools/devtools/app_size_tab.png)

Se DevTools não está conectado a uma aplicação em execução,
você pode acessar a ferramenta da página de destino
que aparece depois que você iniciou
DevTools (veja [instruções de inicialização][launch instructions]).

![Screenshot of app size access on landing page](/assets/images/docs/tools/devtools/app_size_access_landing_page.png){:width="100%"}

## Aba Analysis

A aba analysis permite que você inspecione um único snapshot
de informações de tamanho. Você pode visualizar a estrutura hierárquica
dos dados de tamanho usando o treemap e tabela,
e você pode visualizar dados de atribuição de código
(por exemplo, por que um pedaço de código está incluído na sua
aplicação compilada) usando a árvore de dominadores e gráfico de chamada.

![Screenshot of app size analysis](/assets/images/docs/tools/devtools/app_size_analysis.png){:width="100%"}

### Carregando um arquivo de tamanho

Quando você abre a aba Analysis, você verá instruções
para carregar um arquivo de tamanho de app. Arraste e solte um arquivo de tamanho
de app no diálogo e clique em "Analyze Size".

![Screenshot of app size analysis loading screen](/assets/images/docs/tools/devtools/app_size_load_analysis.png){:width="100%"}

Veja [Gerando arquivos de tamanho][Generating size files] abaixo para informações sobre
gerar arquivos de tamanho.

### Treemap e tabela

O treemap e a tabela mostram os dados hierárquicos para o tamanho do seu app.

#### Usar o treemap

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
Isso re-enraíza a árvore de modo que a célula selecionada torna-se
a raiz visual do treemap.

Para navegar de volta, ou subir um nível, use o
navegador breadcrumb no topo do treemap.

![Screenshot of treemap breadcrumb navigator](/assets/images/docs/tools/devtools/treemap_breadcrumbs.png){:width="100%"}

### Árvore de dominadores e gráfico de chamada

Esta seção da página mostra dados de atribuição de tamanho de código
(por exemplo, por que um pedaço de código está incluído na sua
aplicação compilada). Esses dados são visíveis
na forma de uma árvore de dominadores, bem como um gráfico de chamada.

#### Usar a árvore de dominadores

Uma [árvore de dominadores][dominator tree] é uma árvore onde os
filhos de cada nó são aqueles nós que ele domina imediatamente.
Um nó `a` "domina" um nó `b` se
todo caminho para `b` deve passar por `a`.

[dominator tree]: https://en.wikipedia.org/wiki/Dominator_(graph_theory)

Para colocar em contexto de análise de tamanho de app,
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
então a árvore de dominadores para esses dados seria:

```plaintext
package:a
|__ package:b
|__ package:c
|__ package:d
```

Esta informação é útil para entender por que certos
pedaços de código estão presentes na sua aplicação compilada.
Por exemplo, se você está analisando o tamanho do seu app e encontra
um pacote inesperado incluído no seu app compilado, você pode
usar a árvore de dominadores para rastrear o pacote até sua fonte raiz.

![Screenshot of code size dominator tree](/assets/images/docs/tools/devtools/app_size_dominator_tree.png){:width="100%"}

#### Usar o gráfico de chamada

Um gráfico de chamada fornece informações semelhantes à árvore
de dominadores em relação a ajudá-lo a entender por que o código existe
em uma aplicação compilada. No entanto, em vez de mostrar
as relações dominantes de um-para-muitos entre nós de dados
de tamanho de código como a árvore de dominadores, o gráfico de chamada mostra as
relações muitos-para-muitos que existem entre nós de dados de tamanho de código.

Novamente, usando o seguinte exemplo:

```plaintext
package:a
|__ package:b
|   |__ package:d
|__ package:c
    |__ package:d
```

O gráfico de chamada para esses dados vincularia `package:d`
aos seus chamadores diretos, `package:b` e `package:c`,
em vez de seu "dominador", `package:a`.

```plaintext
package:a --> package:b -->
                              package:d
package:a --> package:c -->
```

Esta informação é útil para entender as
dependências de granularidade fina entre pedaços do seu código
(pacotes, bibliotecas, classes, funções).

![Screenshot of code size call graph](/assets/images/docs/tools/devtools/app_size_call_graph.png){:width="100%"}

#### Devo usar a árvore de dominadores ou o gráfico de chamada?

Use a árvore de dominadores se você quiser entender a
causa *raiz* de por que um pedaço de código está incluído em sua
aplicação. Use o gráfico de chamada se você quiser entender
todos os caminhos de chamada de e para um pedaço de código.

Uma árvore de dominadores é uma análise ou fatia de dados de gráfico de chamada,
onde nós são conectados por "dominância" em vez de
hierarquia pai-filho. No caso onde um nó pai
domina um filho, a relação no gráfico de chamada e na
árvore de dominadores seria idêntica, mas isso nem sempre é o caso.

No cenário onde o gráfico de chamada está completo
(existe uma aresta entre cada par de nós),
a árvore de dominadores mostraria que `root` é o
dominador para cada nó no gráfico.
Este é um exemplo onde o gráfico de chamada lhe daria
um melhor entendimento sobre por que um pedaço de código está
incluído na sua aplicação.

## Aba Diff

A aba diff permite que você compare dois snapshots de
informações de tamanho. Os dois arquivos de informações de tamanho
que você está comparando devem ser gerados de duas versões
diferentes do mesmo app; por exemplo,
o arquivo de tamanho gerado antes e depois
de mudanças no seu código. Você pode visualizar a
diferença entre os dois conjuntos de dados
usando o treemap e tabela.

![Screenshot of app size diff](/assets/images/docs/tools/devtools/app_size_diff.png){:width="100%"}

### Carregando arquivos de tamanho

Quando você abre a aba **Diff**,
você verá instruções para carregar arquivos de tamanho "antigo" e "novo".
Novamente, esses arquivos precisam ser gerados a partir do
mesmo aplicativo. Arraste e solte esses arquivos em
seus respectivos diálogos e clique em **Analyze Diff**.

![Screenshot of app size diff loading screen](/assets/images/docs/tools/devtools/app_size_load_diff.png){:width="100%"}

Veja [Gerando arquivos de tamanho][Generating size files] abaixo para informações
sobre gerar esses arquivos.

### Treemap e tabela

Na visualização diff, o treemap e a tabela de árvore mostram
apenas dados que diferem entre os dois arquivos de tamanho importados.

Para perguntas sobre usar o treemap, veja [Usar o treemap][Use the treemap] acima.

## Gerando arquivos de tamanho

Para usar a ferramenta de tamanho de app, você precisará gerar um
arquivo de análise de tamanho Flutter. Este arquivo contém informações de tamanho
para toda a sua aplicação (código nativo,
código Dart, assets, fontes, etc.), e você pode gerá-lo usando a
flag `--analyze-size`:

```console
flutter build <your target platform> --analyze-size
```

Isso compila sua aplicação, imprime um resumo de tamanho
na linha de comando e imprime uma linha
dizendo onde encontrar o arquivo de análise de tamanho.

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
na ferramenta de tamanho de app para analisar mais.
Para mais informações, veja [Documentação de tamanho de App][App Size Documentation].

## Outros recursos

Para aprender como realizar uma análise de tamanho passo a passo do
App Wonderous usando DevTools, confira o
[tutorial da ferramenta de tamanho de App][app-size-tutorial]. Várias estratégias
para reduzir o tamanho de um app também são discutidas.

[Use the treemap]: #use-the-treemap
[Generating size files]: #generating-size-files
[Analysis tab]: #analysis-tab
[Diff tab]: #diff-tab
[launch instructions]: /tools/devtools#start
[App Size Documentation]: /perf/app-size#breaking-down-the-size
[app-size-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-app-size-tool-part-3-of-8-9be6e9ec42a2
