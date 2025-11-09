---
ia-translate: true
title: Android Studio e IntelliJ
description: >-
  Aprenda como desenvolver apps Flutter no
  Android Studio e outros produtos IntelliJ.
---

<ul class="nav nav-tabs" id="ide" role="tablist">
  <li class="nav-item">
    <a class="nav-link active" role="tab" aria-selected="true">Android Studio and IntelliJ</a>
  </li>
  <li class="nav-item">
    <a class="nav-link" href="/tools/vs-code" role="tab" aria-selected="false">Visual Studio Code</a>
  </li>
</ul>

<a id="installation-and-setup" aria-hidden="true"></a>

## Instalação e configuração {: #setup}

Android Studio e IntelliJ IDEA oferecem uma experiência de
IDE completa após a instalação do plugin Flutter.

Para instalar a versão mais recente das seguintes IDEs, siga as instruções:

- [Android Studio][Android Studio]
- [IntelliJ IDEA Community][IntelliJ IDEA Community]
- [IntelliJ IDEA Ultimate][IntelliJ IDEA Ultimate]

[Android Studio]: {{site.android-dev}}/studio/install
[IntelliJ IDEA Community]: https://www.jetbrains.com/idea/download/
[IntelliJ IDEA Ultimate]: https://www.jetbrains.com/idea/download/

### Instale o plugin Flutter {: #install-plugin}

<Tabs key="dev-os">

<Tab name="Windows">

1. Vá para **File** <span aria-label="and then">></span>
   **Settings**.

   Você também pode pressionar <kbd>Ctrl</kbd> + <kbd>Alt</kbd> +
   <kbd>S</kbd>.

   A caixa de diálogo **Preferences** abre.

1. Na lista à esquerda, selecione **Plugins**.

1. No topo deste painel, selecione **Marketplace**.

1. Digite `flutter` no campo de busca de plugins.

1. Selecione o plugin **Flutter**.

1. Clique em **Install**.

1. Clique em **Yes** quando solicitado para instalar o plugin.

1. Clique em **Restart** quando solicitado.

</Tab>
<Tab name="macOS">

1. Inicie o Android Studio ou IntelliJ.

1. Na barra de menu do macOS, vá para **Android Studio** (ou **IntelliJ**)
   <span aria-label="and then">></span> **Settings...**.

   Você também pode pressionar <kbd>Cmd</kbd> + <kbd>,</kbd>.

   A caixa de diálogo **Preferences** abre.

1. Na lista à esquerda, selecione **Plugins**.

1. No topo deste painel, selecione **Marketplace**.

1. Digite `flutter` no campo de busca de plugins.

1. Selecione o plugin **Flutter**.

1. Clique em **Install**.

1. Clique em **Yes** quando solicitado para instalar o plugin.

1. Clique em **Restart** quando solicitado.

</Tab>
<Tab name="Linux">

1. Vá para **File** <span aria-label="and then">></span>
   **Settings**.

   Você também pode pressionar <kbd>Ctrl</kbd> + <kbd>Alt</kbd> +
   <kbd>S</kbd>.

   A caixa de diálogo **Preferences** abre.

1. Na lista à esquerda, selecione **Plugins**.

1. No topo deste painel, selecione **Marketplace**.

1. Digite `flutter` no campo de busca de plugins.

1. Selecione o plugin **Flutter**.

1. Clique em **Install**.

1. Clique em **Yes** quando solicitado para instalar o plugin.

1. Clique em **Restart** quando solicitado.

</Tab>

</Tabs>

### Atualizando os plugins {:#updating}

Atualizações dos plugins são disponibilizadas regularmente.
Você deve ser notificado na IDE quando uma atualização estiver disponível.

Para verificar atualizações manualmente:

 1. Abra as preferências (**Android Studio > Check for Updates** no macOS,
    **Help > Check for Updates** no Linux).
 1. Se `dart` ou `flutter` estiverem listados, atualize-os.

## Criando projetos

Você pode criar um novo projeto de várias maneiras.

### Criando um novo projeto

Criar um novo projeto Flutter a partir do template do app inicial Flutter
difere entre Android Studio e IntelliJ.

**No Android Studio:**

 1. Na IDE, clique em **New Flutter Project** na janela **Welcome** ou
    **File > New > New Flutter Project** na janela principal da IDE.
 1. Especifique o **Flutter SDK path** e clique em **Next**.
 1. Digite o **Project name**, **Description** e **Project location** desejados.
 1. Se você pretende publicar este app,
    [defina o domínio da empresa](#set-the-company-domain).
 1. Clique em **Finish**.

**No IntelliJ:**

 1. Na IDE, clique em **New Project** na janela **Welcome** ou
    **File > New > Project** na janela principal da IDE.
 1. Selecione **Flutter** na lista **Generators** no painel esquerdo
 1. Especifique o **Flutter SDK path** e clique em **Next**.
 1. Digite o **Project name**, **Description** e **Project location** desejados.
 1. Se você pretende publicar este app,
    [defina o domínio da empresa](#set-the-company-domain).
 1. Clique em **Finish**.

#### Defina o domínio da empresa {:#set-the-company-domain}

Ao criar um novo app, alguns plugins Flutter para IDE solicitam um
nome de organização em ordem de domínio reverso,
algo como `com.example`. Junto com o nome do app,
isso é usado como o nome do pacote para Android, e o Bundle ID para iOS
quando o app for lançado. Se você acha que pode lançar este app algum dia,
é melhor especificar isso agora. Eles não podem ser alterados após o app
ser lançado. O nome da sua organização deve ser único.

### Abrindo um projeto a partir de código-fonte existente

Para abrir um projeto Flutter existente:

 1. Na IDE, clique em **Open** na janela **Welcome**, ou
    **File > Open** na janela principal da IDE.
 1. Navegue até o diretório que contém os
    arquivos de código-fonte Flutter existentes.
 1. Clique em **Open**.

    :::important
    *Não* use a opção **New > Project from existing sources**
    para projetos Flutter.
    :::


## Editando código e visualizando problemas

O plugin Flutter realiza análise de código que habilita o seguinte:

* Destacamento de sintaxe.
* Completações de código baseadas em análise de tipos avançada.
* Navegação para declarações de tipo (**Navigate > Declaration**),
  e localização de usos de tipo (**Edit > Find > Find Usages**).
* Visualização de todos os problemas atuais do código-fonte
  (**View > Tool Windows > Dart Analysis**).
  Quaisquer problemas de análise são mostrados no painel Dart Analysis:<br>
  ![Dart Analysis pane](/assets/images/docs/tools/android-studio/dart-analysis.png){:width="90%"}

## Executando e depurando {:#running-and-debugging}

:::note
Você pode depurar seu app de algumas maneiras.

* Usando [DevTools][DevTools], um conjunto de ferramentas de depuração e profiling
  que executam em um navegador
  _e incluem o Flutter inspector_.
* Usando recursos de depuração integrados do Android Studio (ou IntelliJ),
  como a capacidade de definir breakpoints.
* Usando o Flutter inspector, disponível diretamente no
  Android Studio e IntelliJ.

As instruções abaixo descrevem recursos disponíveis no Android
Studio e IntelliJ. Para informações sobre como iniciar o DevTools,
consulte [Running DevTools from Android Studio][Running DevTools from Android Studio] na
documentação do [DevTools][DevTools].
:::

Execução e depuração são controladas a partir da barra de ferramentas principal:

![Main IntelliJ toolbar](/assets/images/docs/tools/android-studio/main-toolbar.png){:width="90%"}

### Selecionando um alvo

Quando um projeto Flutter está aberto na IDE, você deve ver um conjunto de
botões específicos do Flutter no lado direito da barra de ferramentas.

:::note
Se os botões Run e Debug estiverem desabilitados e nenhum alvo estiver listado,
o Flutter não conseguiu descobrir nenhum dispositivo ou simulador iOS ou
Android conectado.
Você precisa conectar um dispositivo ou iniciar um simulador para prosseguir.
:::

 1. Localize o botão drop-down **Flutter Target Selector**.
    Isso mostra uma lista de alvos disponíveis.
 2. Selecione o alvo no qual você deseja que seu app seja iniciado.
    Quando você conecta dispositivos ou inicia simuladores,
    entradas adicionais aparecem.

### Execute o app sem breakpoints

 1. Clique no **ícone Play** na barra de ferramentas, ou invoque **Run > Run**.
    O painel **Run** na parte inferior mostra a saída de logs.

### Execute o app com breakpoints {:#run-app-with-breakpoints}

 1. Se desejar, defina breakpoints em seu código-fonte.
 1. Clique no **ícone Debug** na barra de ferramentas, ou invoque **Run > Debug**.
    * O painel **Debugger** na parte inferior mostra Stack Frames e Variables.
    * O painel **Console** na parte inferior mostra a saída detalhada de logs.
    * A depuração é baseada em uma configuração de lançamento padrão.
      Para personalizar isso, clique no botão drop-down à direita
      do seletor de dispositivo e selecione **Edit configuration**.

## Ciclo de desenvolvimento de edição e atualização rápida

Flutter oferece um ciclo de desenvolvimento de primeira classe que permite ver o efeito
de suas alterações quase instantaneamente com o recurso _Stateful Hot Reload_.
Para saber mais, consulte [Hot reload][Hot reload].

### Mostrar dados de performance {:#show-performance-data}

:::note
Para examinar problemas de performance no Flutter, consulte a
[Timeline view][Timeline view].
:::

Para visualizar os dados de performance, incluindo as informações de
reconstrução de widgets, inicie o app no modo **Debug** e, em seguida, abra
a janela de ferramenta Performance usando
**View > Tool Windows > Flutter Performance**.

![Flutter performance window](/assets/images/docs/tools/android-studio/widget-rebuild-info.png){:width="90%"}

Para ver as estatísticas sobre quais widgets estão sendo reconstruídos e com que frequência,
clique em **Show widget rebuild information** no painel **Performance**.
A contagem exata das reconstruções para este frame é exibida na segunda
coluna da direita para a esquerda. Para um alto número de reconstruções, um círculo
amarelo giratório é exibido. A coluna mais à direita mostra quantas vezes um
widget foi reconstruído desde a entrada na tela atual.
Para widgets que não são reconstruídos, um círculo cinza sólido é exibido.
Caso contrário, um círculo cinza giratório é exibido.

:::secondary
O app mostrado nesta captura de tela foi projetado para entregar
desempenho ruim, e o profiler de reconstrução fornece uma pista
sobre o que está acontecendo no frame que pode causar
desempenho ruim. O profiler de reconstrução de widgets não é uma ferramenta
de diagnóstico, por si só, sobre desempenho ruim.
:::

O propósito deste recurso é torná-lo ciente quando widgets estão
sendo reconstruídos&mdash;você pode não perceber que isso está acontecendo apenas
olhando o código. Se widgets estão sendo reconstruídos quando você não esperava,
provavelmente é um sinal de que você deve refatorar seu código dividindo
métodos build grandes em vários widgets.

Esta ferramenta pode ajudá-lo a depurar pelo menos quatro problemas comuns de performance:

1. A tela inteira (ou grandes partes dela) é construída por um único
   StatefulWidget, causando construção desnecessária de UI. Divida a
   UI em widgets menores com funções `build()` menores.

1. Widgets fora da tela estão sendo reconstruídos. Isso pode acontecer, por exemplo,
   quando um ListView está aninhado em uma Column alta que se estende para fora da tela.
   Ou quando o RepaintBoundary não está definido para uma lista que se estende
   para fora da tela, fazendo com que toda a lista seja redesenhada.

1. A função `build()` de um AnimatedBuilder desenha uma subárvore que
   não precisa ser animada, causando reconstruções desnecessárias de
   objetos estáticos.

1. Um widget Opacity está colocado desnecessariamente alto na árvore de widgets.
   Ou, uma animação Opacity é criada manipulando diretamente a
   propriedade opacity do widget Opacity, fazendo com que o widget em si
   e sua subárvore sejam reconstruídos.

Você pode clicar em uma linha na tabela para navegar até a linha
no código-fonte onde o widget é criado. Conforme o código executa,
os ícones giratórios também são exibidos no painel de código para ajudá-lo a
visualizar quais reconstruções estão acontecendo.

Note que numerosas reconstruções não necessariamente indicam um problema.
Tipicamente você deve se preocupar apenas com reconstruções excessivas se você já
executou o app no modo profile e verificou que a performance
não é o que você deseja.

E lembre-se, _as informações de reconstrução de widgets estão disponíveis apenas em
uma build de debug_. Teste a performance do app em um dispositivo real em uma build
de profile, mas depure problemas de performance em uma build de debug.

## Dicas de edição para código Flutter

Se você tiver dicas adicionais que devemos compartilhar, [nos avise][let us know]!

### Assists & quick fixes

Assists são alterações de código relacionadas a um determinado identificador de código.
Vários deles estão disponíveis quando o cursor é colocado em um
identificador de widget Flutter, conforme indicado pelo ícone de lâmpada amarela.
O assist pode ser invocado clicando na lâmpada, ou usando o
atalho de teclado (`Alt`+`Enter` no Linux e Windows,
`Option`+`Return` no macOS), conforme ilustrado aqui:

![IntelliJ editing assists](/assets/images/docs/tools/android-studio/assists.webp){:width="100%"}

Quick Fixes são similares, apenas são mostrados quando um trecho de código tem um erro
e podem auxiliar na correção. Eles são indicados com uma lâmpada vermelha.

#### Wrap with new widget assist

Isso pode ser usado quando você tem um widget que deseja envolver em um widget
circundante, por exemplo, se você deseja envolver um widget em um `Row` ou `Column`.

#### Wrap widget list with new widget assist

Similar ao assist acima, mas para envolver uma lista existente de
widgets em vez de um widget individual.

#### Convert child to children assist

Transforma um argumento child em um argumento children,
e envolve o valor do argumento em uma lista.

### Live templates

Live templates podem ser usados para acelerar a digitação de estruturas de código típicas.
Eles são invocados digitando seu prefixo e, em seguida, selecionando-o na janela de
completação de código:

![IntelliJ live templates](/assets/images/docs/tools/android-studio/templates.webp){:width="100%"}

O plugin Flutter inclui os seguintes templates:

* Prefixo `stless`: Cria uma nova subclasse de `StatelessWidget`.
* Prefixo `stful`: Cria uma nova subclasse de `StatefulWidget` e
  sua subclasse State associada.
* Prefixo `stanim`: Cria uma nova subclasse de `StatefulWidget` e sua
  subclasse State associada, incluindo um campo inicializado com um
  `AnimationController`.

Você também pode definir templates personalizados em **Settings > Editor > Live Templates**.

### Atalhos de teclado

**Hot reload**

No Linux (keymap _Default for XWin_) e Windows os atalhos de teclado
são `Control`+`Alt`+`;` e `Control`+`Backslash`.

No macOS (keymap _Mac OS X 10.5+ copy_) os atalhos de teclado são
`Command`+`Option` e `Command`+`Backslash`.

Mapeamentos de teclado podem ser alterados nas Preferences/Settings da IDE: Selecione
*Keymap*, depois digite _flutter_ na caixa de pesquisa no canto superior direito.
Clique com o botão direito na associação que você deseja alterar e _Add Keyboard Shortcut_.

![IntelliJ settings keymap](/assets/images/docs/tools/android-studio/keymap-settings-flutter-plugin.png){:width="100%"}

### Hot reload vs. hot restart

Hot reload funciona injetando arquivos de código-fonte atualizados na
Dart VM (Virtual Machine) em execução. Isso inclui não apenas adicionar novas classes,
mas também adicionar métodos e campos a classes existentes,
e alterar funções existentes.
Alguns tipos de alterações de código não podem ser hot reloaded, no entanto:

* Inicializadores de variáveis globais
* Inicializadores de campos estáticos
* O método `main()` do app

Para essas alterações você pode reiniciar completamente seu aplicativo,
sem ter que encerrar sua sessão de depuração. Para realizar um hot restart,
não clique no botão Stop, simplesmente clique novamente no botão Run (se em uma sessão
de execução) ou botão Debug (se em uma sessão de depuração), ou shift-clique no botão 'hot
reload'.

## Editando código Android no Android Studio com suporte completo de IDE {:#android-ide}

Abrir o diretório raiz de um projeto Flutter não expõe todos os arquivos Android
para a IDE. Apps Flutter contêm um subdiretório chamado `android`. Se você
abrir este subdiretório como seu próprio projeto separado no Android Studio, a IDE
será capaz de suportar totalmente a edição e refatoração de todos os arquivos Android (como
scripts Gradle).

Se você já tem o projeto inteiro aberto como um app Flutter no Android
Studio, existem duas maneiras equivalentes de abrir os arquivos Android por conta própria
para edição na IDE. Antes de tentar isso, certifique-se de estar na versão mais recente
do Android Studio e dos plugins Flutter.

* Na ["project view"]["project view"], você deve ver um subdiretório imediatamente sob
  a raiz do seu app flutter chamado `android`. Clique com o botão direito nele,
  depois selecione **Flutter > Open Android module in Android Studio**.
* OU, você pode abrir qualquer um dos arquivos no subdiretório `android` para
  edição. Você deve então ver um banner "Flutter commands" no topo do
  editor com um link rotulado **Open for Editing in Android Studio**.
  Clique nesse link.

Para ambas as opções, o Android Studio oferece a opção de usar janelas separadas ou
substituir a janela existente pelo novo projeto ao abrir um segundo
projeto. Qualquer opção está correta.

Se você ainda não tem o projeto Flutter aberto no Android studio,
você pode abrir os arquivos Android como seu próprio projeto desde o início:

1. Clique em **Open an existing Android Studio Project** na tela
   de boas-vindas, ou **File > Open** se o Android Studio já estiver aberto.
2. Abra o subdiretório `android` imediatamente sob a raiz do app flutter.
   Por exemplo, se o projeto se chama `flutter_app`,
   abra `flutter_app/android`.

Se você ainda não executou seu app Flutter, você pode ver o Android Studio reportar um
erro de build ao abrir o projeto `android`. Execute `flutter pub get` no
diretório raiz do app e reconstrua o projeto selecionando **Build > Make**
para corrigir isso.

## Editando código Android no IntelliJ IDEA {:#edit-android-code}

Para habilitar a edição de código Android no IntelliJ IDEA, você precisa configurar a
localização do Android SDK:

 1. Em **Preferences > Plugins**, habilite **Android Support** se você
    ainda não o fez.
 1. Clique com o botão direito na pasta **android** na visualização Project e selecione **Open
    Module Settings**.
 1. Na aba **Sources**, localize o campo **Language level** e
    selecione o nível 8 ou posterior.
 1. Na aba **Dependencies**, localize o campo **Module SDK**
    e selecione um Android SDK. Se nenhum SDK estiver listado, clique em **New**
    e especifique a localização do Android SDK.
    Certifique-se de selecionar um Android SDK correspondente ao usado pelo
    Flutter (conforme reportado por `flutter doctor`).
 1. Clique em **OK**.

## Flutter Property Editor {: #property-editor}

O Flutter Property Editor é uma ferramenta poderosa fornecida pelo [Flutter
plugin][] que permite visualizar e modificar propriedades de widgets diretamente de sua
interface visual.

### Como abrir o Flutter Property Editor no Android Studio e IntelliJ

1. Clique no **ícone** do Flutter Property Editor ![Flutter Property Editor Android Studio/IntelliJ icon](/assets/images/docs/tools/devtools/property-editor-icon-android-studio.png){:width="20px"} na barra lateral do Android Studio ou IntelliJ.
2. O Flutter Property Editor será carregado no painel lateral.
3. Por favor, consulte a [documentação][documentation] do Flutter Property Editor para um guia de uso detalhado.

![Flutter Property Editor side panel in Android Studio/IntelliJ](/assets/images/docs/tools/devtools/property-editor-android-studio.png){:width="600px"}

[Flutter plugin]: https://plugins.jetbrains.com/plugin/9212-flutter
[documentation]: /tools/property-editor

## Solução de problemas

### Problemas conhecidos e feedback

Problemas conhecidos importantes que podem impactar sua experiência estão documentados
no arquivo [Flutter plugin README][Flutter plugin README].

Todos os bugs conhecidos são rastreados nos issue trackers:

* Plugin Flutter: [GitHub issue tracker][GitHub issue tracker]
* Plugin Dart: [JetBrains YouTrack][JetBrains YouTrack]

Valorizamos feedback, tanto sobre bugs/problemas quanto sobre solicitações de recursos.
Antes de registrar novos problemas:

* Faça uma busca rápida nos issue trackers para ver se o problema já está
  rastreado.
* Certifique-se de ter [atualizado](#updating) para a versão mais recente do
  plugin.

Ao registrar novos problemas, inclua a saída de [`flutter doctor`][`flutter doctor`].

[DevTools]: /tools/devtools
[GitHub issue tracker]: {{site.repo.flutter}}-intellij/issues
[JetBrains YouTrack]: https://youtrack.jetbrains.com/issues?q=%23dart%20%23Unresolved
[`flutter doctor`]: /resources/bug-reports#provide-some-flutter-diagnostics
[Debugging Flutter apps]: /testing/debugging
[Flutter plugin README]: {{site.repo.flutter}}-intellij/blob/master/README.md
["project view"]: {{site.android-dev}}/studio/projects/#ProjectView
[let us know]: {{site.repo.this}}/issues/new
[Running DevTools from Android Studio]: /tools/devtools/android-studio
[Hot reload]: /tools/hot-reload
[Timeline view]: /tools/devtools/performance
