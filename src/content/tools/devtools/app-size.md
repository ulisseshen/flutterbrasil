---
ia-translate: true
title: Usar a ferramenta de tamanho de app
description: Aprenda como usar a ferramenta de tamanho de app do DevTools.
---

## O que é isso?

A ferramenta de tamanho de app permite que você analise o tamanho total do seu app. Você pode visualizar um único snapshot de "informações de tamanho" usando a aba [Analysis][], ou comparar dois snapshots diferentes de "informações de tamanho" usando a aba [Diff][].

### O que são "informações de tamanho"?

"Informações de tamanho" contêm dados de tamanho para código Dart, código nativo e elementos não codificados do seu app, como o pacote do aplicativo, assets e fontes. Um arquivo de "informações de tamanho" contém dados para o panorama geral do tamanho do seu aplicativo.

### Informações de tamanho do Dart

O compilador AOT do Dart realiza tree-shaking no seu código ao compilar seu aplicativo (somente nos modos profile ou release — o compilador AOT não é usado para builds de debug, que são compilados com JIT). Isso significa que o compilador tenta otimizar o tamanho do seu app removendo partes de código que não são usadas ou que são inacessíveis.

Após o compilador otimizar seu código o máximo possível, o resultado final pode ser resumido como a coleção de packages, libraries, classes e functions que existem na saída binária, juntamente com seu tamanho em bytes. Essa é a parte Dart das "informações de tamanho" que podemos analisar na ferramenta de tamanho de app para otimizar ainda mais o código Dart e rastrear problemas de tamanho.

## Como usar

Se o DevTools já estiver conectado a um aplicativo em execução, navegue até a aba "App Size".

![Captura de tela da aba tamanho do app](/assets/images/docs/tools/devtools/app_size_tab.png)

Se o DevTools não estiver conectado a um aplicativo em execução, você pode acessar a ferramenta na página inicial que aparece depois que você inicia o DevTools (veja as [instruções de inicialização][]).

![Captura de tela do acesso ao tamanho do app na página inicial](/assets/images/docs/tools/devtools/app_size_access_landing_page.png){:width="100%"}

## Aba Analysis

A aba Analysis permite que você inspecione um único snapshot de informações de tamanho. Você pode visualizar a estrutura hierárquica dos dados de tamanho usando o treemap e a tabela, e pode visualizar os dados de atribuição de código (por exemplo, por que uma parte do código está incluída no seu aplicativo compilado) usando a árvore de dominador e o gráfico de chamadas.

![Captura de tela da análise do tamanho do app](/assets/images/docs/tools/devtools/app_size_analysis.png){:width="100%"}

### Carregando um arquivo de tamanho

Quando você abre a aba Analysis, você verá instruções para carregar um arquivo de tamanho de app. Arraste e solte um arquivo de tamanho de app na caixa de diálogo e clique em "Analyze Size".

![Captura de tela da tela de carregamento da análise do tamanho do app](/assets/images/docs/tools/devtools/app_size_load_analysis.png){:width="100%"}

Veja [Gerando arquivos de tamanho][] abaixo para obter informações sobre como gerar arquivos de tamanho.

### Treemap e tabela

O treemap e a tabela mostram os dados hierárquicos para o tamanho do seu app.

#### Usar o treemap

Um treemap é uma visualização para dados hierárquicos. O espaço é dividido em retângulos, onde cada retângulo é dimensionado e ordenado por alguma variável quantitativa (neste caso, o tamanho em bytes). A área de cada retângulo é proporcional ao tamanho que o nó ocupa no aplicativo compilado. Dentro de cada retângulo (chame um de A), existem retângulos adicionais que existem um nível mais profundo na hierarquia de dados (filhos de A).

Para detalhar uma célula no treemap, selecione a célula. Isso redefine a árvore para que a célula selecionada se torne a raiz visual do treemap.

Para navegar de volta ou subir um nível, use o navegador breadcrumb na parte superior do treemap.

![Captura de tela do navegador breadcrumb do treemap](/assets/images/docs/tools/devtools/treemap_breadcrumbs.png){:width="100%"}

### Árvore de dominador e gráfico de chamadas

Esta seção da página mostra dados de atribuição de tamanho de código (por exemplo, por que uma parte do código está incluída no seu aplicativo compilado). Esses dados são visíveis na forma de uma árvore de dominador, bem como um gráfico de chamadas.

#### Usar a árvore de dominador

Uma [árvore de dominador][] é uma árvore onde os filhos de cada nó são aqueles nós que ele domina imediatamente. Diz-se que um nó `a` "domina" um nó `b` se todo caminho para `b` deve passar por `a`.

[árvore de dominador]: https://en.wikipedia.org/wiki/Dominator_(graph_theory)

Para colocar isso no contexto da análise de tamanho do app, imagine que `package:a` importa `package:b` e `package:c`, e ambos `package:b` e `package:c` importam `package:d`.

```plaintext
package:a
|__ package:b
|   |__ package:d
|__ package:c
    |__ package:d
```

Neste exemplo, `package:a` domina `package:d`, então a árvore de dominador para esses dados seria assim:

```plaintext
package:a
|__ package:b
|__ package:c
|__ package:d
```

Essas informações são úteis para entender por que certas partes do código estão presentes no seu aplicativo compilado. Por exemplo, se você estiver analisando o tamanho do seu app e encontrar um package inesperado incluído no seu app compilado, você pode usar a árvore de dominador para rastrear o package até sua fonte raiz.

![Captura de tela da árvore de dominador de tamanho de código](/assets/images/docs/tools/devtools/app_size_dominator_tree.png){:width="100%"}

#### Usar o gráfico de chamadas

Um gráfico de chamadas fornece informações semelhantes à árvore de dominador com relação a ajudar você a entender por que o código existe em um aplicativo compilado. No entanto, em vez de mostrar as relações dominantes de um-para-muitos entre os nós de dados de tamanho de código, como a árvore de dominador, o gráfico de chamadas mostra as relações de muitos-para-muitos que existem entre os nós de dados de tamanho de código.

Novamente, usando o seguinte exemplo:

```plaintext
package:a
|__ package:b
|   |__ package:d
|__ package:c
    |__ package:d
```

O gráfico de chamadas para esses dados vincularia `package:d` aos seus chamadores diretos, `package:b` e `package:c`, em vez de seu "dominador", `package:a`.

```plaintext
package:a --> package:b -->
                              package:d
package:a --> package:c -->
```

Essas informações são úteis para entender as dependências detalhadas entre as partes do seu código (packages, libraries, classes, functions).

![Captura de tela do gráfico de chamadas de tamanho de código](/assets/images/docs/tools/devtools/app_size_call_graph.png){:width="100%"}

#### Devo usar a árvore de dominador ou o gráfico de chamadas?

Use a árvore de dominador se você quiser entender a causa *raiz* de por que uma parte do código está incluída no seu aplicativo. Use o gráfico de chamadas se você quiser entender todos os caminhos de chamada de e para uma parte do código.

Uma árvore de dominador é uma análise ou slice de dados do gráfico de chamadas, onde os nós são conectados por "dominância" em vez de hierarquia pai-filho. No caso em que um nó pai domina um filho, a relação no gráfico de chamadas e na árvore de dominador seria idêntica, mas nem sempre é o caso.

No cenário em que o gráfico de chamadas está completo (existe uma borda entre cada par de nós), a árvore de dominador mostraria que `root` é o dominador para cada nó no gráfico. Este é um exemplo em que o gráfico de chamadas daria a você uma melhor compreensão sobre por que uma parte do código está incluída no seu aplicativo.

## Aba Diff

A aba Diff permite que você compare dois snapshots de informações de tamanho. Os dois arquivos de informações de tamanho que você está comparando devem ser gerados a partir de duas versões diferentes do mesmo app; por exemplo, o arquivo de tamanho gerado antes e depois das alterações no seu código. Você pode visualizar a diferença entre os dois conjuntos de dados usando o treemap e a tabela.

![Captura de tela da diferença de tamanho do app](/assets/images/docs/tools/devtools/app_size_diff.png){:width="100%"}

### Carregando arquivos de tamanho

Quando você abre a aba **Diff**, você verá instruções para carregar arquivos de tamanho "antigos" e "novos". Novamente, esses arquivos precisam ser gerados a partir do mesmo aplicativo. Arraste e solte esses arquivos em suas respectivas caixas de diálogo e clique em **Analyze Diff**.

![Captura de tela da tela de carregamento da diferença de tamanho do app](/assets/images/docs/tools/devtools/app_size_load_diff.png){:width="100%"}

Veja [Gerando arquivos de tamanho][] abaixo para obter informações sobre como gerar esses arquivos.

### Treemap e tabela

Na visualização de diff, o treemap e a tabela de árvore mostram apenas os dados que diferem entre os dois arquivos de tamanho importados.

Para perguntas sobre como usar o treemap, veja [Usar o treemap][] acima.

## Gerando arquivos de tamanho

Para usar a ferramenta de tamanho de app, você precisará gerar um arquivo de análise de tamanho do Flutter. Este arquivo contém informações de tamanho para todo o seu aplicativo (código nativo, código Dart, assets, fontes, etc.), e você pode gerá-lo usando a flag `--analyze-size`:

```console
flutter build <sua plataforma alvo> --analyze-size
```

Isso constrói seu aplicativo, imprime um resumo do tamanho na linha de comando e imprime uma linha informando onde encontrar o arquivo de análise de tamanho.

```console
flutter build apk --analyze-size --target-platform=android-arm64
...
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
app-release.apk (total comprimido)                               6 MB
...
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
Um resumo da análise do seu APK pode ser encontrado em: build/apk-code-size-analysis_01.json
```

Neste exemplo, importe o arquivo `build/apk-code-size-analysis_01.json` para a ferramenta de tamanho do app para analisar mais detalhadamente. Para obter mais informações, veja [Documentação de Tamanho de App][].

## Outros recursos

Para aprender como realizar uma análise de tamanho passo a passo do Wonderous App usando o DevTools, confira o [tutorial da ferramenta de tamanho de app][app-size-tutorial]. Várias estratégias para reduzir o tamanho de um app também são discutidas.

[Usar o treemap]: #use-the-treemap
[Gerando arquivos de tamanho]: #generating-size-files
[Analysis]: #analysis-tab
[Diff]: #diff-tab
[instruções de inicialização]: /tools/devtools#start
[Documentação de Tamanho de App]: /perf/app-size#breaking-down-the-size
[app-size-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-app-size-tool-part-3-of-8-9be6e9ec42a2
