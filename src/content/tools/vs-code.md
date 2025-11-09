---
ia-translate: true
title: Visual Studio Code
shortTitle: VS Code
description: Como desenvolver apps Flutter no Visual Studio Code.
---

<ul class="nav nav-tabs" id="ide-tabs" role="tablist">
  <li class="nav-item">
    <a class="nav-link" href="/tools/android-studio" role="tab" aria-selected="false">Android Studio and IntelliJ</a>
  </li>
  <li class="nav-item">
    <a class="nav-link active" role="tab" aria-selected="true">Visual Studio Code</a>
  </li>
</ul>

<a id="installation-and-setup" aria-hidden="true"></a>

## Instalação e configuração {: #setup}

[VS Code][VS Code] é um editor de código para compilar e depurar apps.
Com a extensão Flutter instalada, você pode compilar, implantar e depurar
apps Flutter.

Para instalar a versão mais recente do VS Code,
siga as instruções da Microsoft para a plataforma relevante:

- [Instalar no macOS][Install on macOS]
- [Instalar no Windows][Install on Windows]
- [Instalar no Linux][Install on Linux]

[VS Code]: https://code.visualstudio.com/
[Install on macOS]: https://code.visualstudio.com/docs/setup/mac
[Install on Windows]: https://code.visualstudio.com/docs/setup/windows
[Install on Linux]: https://code.visualstudio.com/docs/setup/linux

### Instalar a extensão Flutter {: #install-extension}

1. Inicie o **VS Code**.

1. Abra um navegador e vá para a página da [extensão Flutter][Flutter extension]
   no Visual Studio Marketplace.

1. Clique em **Install**.
   Instalar a extensão Flutter também instala a extensão Dart.

[Flutter extension]: https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter

### Validar sua configuração do VS Code {: #validate-setup}

1. Vá para **View** <span aria-label="and then">></span>
   **Command Palette...**.

   Você também pode pressionar <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> +
   <kbd>Shift</kbd> + <kbd>P</kbd>.

1. Digite `doctor`.

1. Selecione **Flutter: Run Flutter Doctor**.

   Uma vez que você seleciona este comando, o VS Code faz o seguinte:

   - Abre o painel **Output**.
   - Exibe **flutter (flutter)** no dropdown no canto superior direito
     deste painel.
   - Exibe a saída do comando `flutter doctor`.

### Atualizando a extensão {:#updating}

Atualizações para as extensões são enviadas regularmente.
Por padrão, o VS Code atualiza automaticamente as extensões quando
atualizações estão disponíveis.

Para instalar atualizações você mesmo:

1. Clique em **Extensions** na Barra Lateral.
1. Se a extensão Flutter tiver uma atualização disponível,
   clique em **Update** e depois em **Reload**.
1. Reinicie o VS Code.

## Criando projetos

Existem algumas maneiras de criar um novo projeto.

### Criando um novo projeto

Para criar um novo projeto Flutter a partir do
template de app inicial do Flutter:

1. Vá para **View** <span aria-label="and then">></span>
   **Command Palette...**.

   Você também pode pressionar <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> +
   <kbd>Shift</kbd> + <kbd>P</kbd>.

1. Digite `flutter`.
1. Selecione o **Flutter: New Project**.
1. Pressione <kbd>Enter</kbd>.
1. Selecione **Application**.
1. Pressione <kbd>Enter</kbd>.
1. Selecione uma **Project location**.
1. Digite o **Project name** desejado.

### Abrindo um projeto a partir de código-fonte existente

Para abrir um projeto Flutter existente:

1. Vá para **File** <span aria-label="and then">></span> **Open**.

   Você também pode pressionar <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> + <kbd>O</kbd>

1. Navegue até o diretório que contém seus
   arquivos de código-fonte Flutter existentes.
1. Clique em **Open**.

## Editando código e visualizando problemas

A extensão Flutter realiza análise de código.
A análise de código pode:

- Destacar sintaxe da linguagem
- Completar código baseado em análise de tipo rica
- Navegar para declarações de tipo

  - Vá para **Go** <span aria-label="and then">></span> **Go to Definition**.
  - Você também pode pressionar <kbd>F12</kbd>.

- Encontrar usos de tipo.

  - Pressione <kbd>Shift</kbd> + <kbd>F12</kbd>.

- Visualizar todos os problemas atuais de código-fonte.

  - Vá para **View** <span aria-label="and then">></span> **Problems**.
  - Você também pode pressionar <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> +
    <kbd>Shift</kbd> + <kbd>M</kbd>.
  - O painel Problems exibe quaisquer problemas de análise:<br>
    ![Problems pane](/assets/images/docs/tools/vs-code/problems.png)

## Executando e depurando {:#running-and-debugging}

:::note
Você pode depurar seu app de algumas maneiras.

- Usando [DevTools][DevTools], um conjunto de ferramentas de depuração e profiling
  que executam em um navegador.
- Usando recursos de depuração integrados do VS Code,
  como definir breakpoints.

As instruções abaixo descrevem recursos disponíveis no VS Code.
Para informações sobre como iniciar e usar o DevTools, veja
[Running DevTools from VS Code][Running DevTools from VS Code] na documentação do [DevTools][DevTools].
:::

Comece a depurar clicando em **Run > Start Debugging**
na janela principal da IDE, ou pressione <kbd>F5</kbd>.

### Selecionando um dispositivo alvo

Quando um projeto Flutter está aberto no VS Code,
você deve ver um conjunto de entradas específicas do Flutter na barra de status,
incluindo uma versão do Flutter SDK e um
nome de dispositivo (ou a mensagem **No Devices**):<br>
![VS Code status bar][VS Code status bar]

:::note
- Se você não vê um número de versão do Flutter ou informações de dispositivo,
  seu projeto pode não ter sido detectado como um projeto Flutter.
  Certifique-se de que a pasta que contém seu `pubspec.yaml` está
  dentro de um **Workspace Folder** do VS Code.
- Se a barra de status mostra **No Devices**, o Flutter não conseguiu
  descobrir quaisquer dispositivos iOS ou Android conectados ou simuladores.
  Você precisa conectar um dispositivo, ou iniciar um simulador ou emulador,
  para prosseguir.
:::

A extensão Flutter seleciona automaticamente o último dispositivo conectado.
No entanto, se você tiver múltiplos dispositivos/simuladores conectados, clique em
**device** na barra de status para ver uma lista de escolha
no topo da tela. Selecione o dispositivo que você deseja usar para
executar ou depurar.

:::secondary
**Você está desenvolvendo para macOS ou iOS remotamente usando
Visual Studio Code Remote?** Se sim, você pode precisar desbloquear manualmente
o keychain. Para mais informações, veja esta
[pergunta no StackExchange][question on StackExchange].
:::

[question on StackExchange]: https://superuser.com/questions/270095/when-i-ssh-into-os-x-i-dont-have-my-keychain-when-i-use-terminal-i-do/363840#363840

### Executar app sem breakpoints

Vá para **Run** > **Start Without Debugging**.

Você também pode pressionar <kbd>Ctrl</kbd> + <kbd>F5</kbd>.

### Executar app com breakpoints {:#run-app-with-breakpoints}

1. Se desejar, defina breakpoints em seu código-fonte.
1. Clique em **Run** <span aria-label="and then">></span> **Start Debugging**.
   Você também pode pressionar <kbd>F5</kbd>.
   A barra de status fica laranja para mostrar que você está em uma sessão de depuração.<br>
   ![Debug console](/assets/images/docs/tools/vs-code/debug_console.png)

   - A **Debug Sidebar** à esquerda mostra stack frames e variáveis.
   - O painel **Debug Console** inferior mostra saída de log detalhada.
   - A depuração é baseada em uma configuração de lançamento padrão.
     Para personalizar, clique na engrenagem no topo da
     **Debug Sidebar** para criar um arquivo `launch.json`.
     Você pode então modificar os valores.

### Executar app em modo debug, profile ou release

O Flutter oferece muitos modos de compilação diferentes para executar seu app.
Você pode ler mais sobre eles em [modos de compilação do Flutter][Flutter's build modes].

1. Abra o arquivo `launch.json` no VS Code.

   Se você não tiver um arquivo `launch.json`:

   {: type="a"}
   1. Vá para **View** <span aria-label="and then">></span> **Run**.

      Você também pode pressionar <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> +
      <kbd>Shift</kbd> + <kbd>D</kbd>

      O painel **Run and Debug** é exibido.

   1. Clique em **create a launch.json file**.

1. Na seção `configurations`,
   altere a propriedade `flutterMode` para
   o modo de compilação que você deseja atingir.

   Por exemplo, se você quiser executar em modo debug,
   seu `launch.json` pode parecer com isto:

    ```json
    "configurations": [
      {
        "name": "Flutter",
        "request": "launch",
        "type": "dart",
        "flutterMode": "debug"
      }
    ]
    ```

1. Execute o app através do painel **Run**.

## Ciclo de desenvolvimento de edição e atualização rápida

Flutter oferece um ciclo de desenvolvedor de primeira classe que permite
ver o efeito de suas mudanças quase instantaneamente com o
recurso _Stateful Hot Reload_.
Para aprender mais, confira [Hot reload][Hot reload].

## Depuração avançada

Você pode achar as seguintes dicas de depuração avançada úteis:

### Depurando problemas de layout visual

Durante uma sessão de depuração,
vários comandos de depuração adicionais são adicionados à
[Command Palette][Command Palette] e ao [Flutter inspector][Flutter inspector].
Quando o espaço é limitado, o ícone é usado como a versão visual
do rótulo.

**Toggle Baseline Painting** ![Baseline painting icon](/assets/images/docs/tools/devtools/paint-baselines-icon.png){:.theme-icon width="20px"}
: Faz com que cada RenderBox pinte uma linha em cada uma de suas baselines.

**Toggle Repaint Rainbow** ![Repaint rainbow icon](/assets/images/docs/tools/devtools/repaint-rainbow-icon.png){:.theme-icon width="20px"}
: Mostra cores rotativas em camadas ao repintar.

**Toggle Slow Animations** ![Slow animations icon](/assets/images/docs/tools/devtools/slow-animations-icon.png){:.theme-icon width="20px"}
: Diminui a velocidade das animações para permitir inspeção visual.

**Toggle Debug Mode Banner** ![Debug mode banner icon](/assets/images/docs/tools/devtools/debug-mode-banner-icon.png){:width="20px"}
: Oculta o banner de modo debug mesmo ao executar uma compilação de debug.

### Depurando bibliotecas externas

Por padrão, a depuração de uma biblioteca externa está desabilitada
na extensão Flutter. Para habilitar:

1. Selecione **Settings > Extensions > Dart Configuration**.
2. Marque a opção `Debug External Libraries`.

## Dicas de edição para código Flutter

Se você tiver dicas adicionais que devemos compartilhar, [nos avise][let us know]!

### Assists & quick fixes

Assists são mudanças de código relacionadas a um certo identificador de código.
Vários destes estão disponíveis quando o cursor é colocado em um
identificador de widget Flutter, conforme indicado pelo ícone de lâmpada amarela.
Para invocar o assist, clique na lâmpada conforme mostrado na seguinte captura de tela:

![Code assists](/assets/images/docs/tools/vs-code/assists.png){:width="467px"}

Você também pode pressionar <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> + <kbd>.</kbd>

Quick fixes são similares,
apenas eles são mostrados com um pedaço de código que tem um erro e podem
auxiliar na correção.

**Wrap with new widget assist**
: Isso pode ser usado quando você tem um widget que deseja envolver
  em um widget envolvente, por exemplo se você quiser envolver um
  widget em um `Row` ou `Column`.

**Wrap widget list with new widget assist**
: Similar ao assist acima, mas para envolver uma
  lista de widgets existente ao invés de um widget individual.

**Convert child to children assist**
: Altera um argumento child para um argumento children,
  e envolve o valor do argumento em uma lista.

**Convert StatelessWidget to StatefulWidget assist**
: Altera a implementação de um `StatelessWidget` para a de
  um `StatefulWidget`, criando a classe `State` e movendo
  o código para lá.

### Snippets

Snippets podem ser usados para acelerar a digitação de estruturas de código típicas.
Eles são invocados digitando seu prefixo,
e então selecionando na janela de completar código:
![Snippets](/assets/images/docs/tools/vs-code/snippets.png){:width="100%"}

A extensão Flutter inclui os seguintes snippets:

- Prefixo `stless`: Crie uma nova subclasse de `StatelessWidget`.
- Prefixo `stful`: Crie uma nova subclasse de `StatefulWidget`
  e sua subclasse State associada.
- Prefixo `stanim`: Crie uma nova subclasse de `StatefulWidget`,
  e sua subclasse State associada incluindo um campo inicializado
  com um `AnimationController`.

A extensão Dart inclui os seguintes snippets:

| Prefixo | Descrição | Exemplo de Código |
|---|---|---|
| `main` | Insere uma função main, usada como ponto de entrada. | `void main(List<String> args) {  }` |
| `try` | Insere um bloco try/catch. | `try {  } catch (e) {  }` |
| `if` | Insere uma declaração if. | `if (condition) {  }` |
| `ife` | Insere uma declaração if com um bloco else. | `if (condition) {  } else {  }` |
| `switch` | Insere uma declaração switch. | `switch (variable) { case value1:  break; case value2:  break; default:  }` |
| `for` | Insere um loop for. | `for (var i = 0; i < 10; i++) {  }` |
| `fori` | Insere um loop for-in. | `for (var item in list) {  }` |
| `while` | Insere um loop while. | `while (condition) {  }` |
| `do` | Insere um loop do-while. | `do {  } while (condition);` |
| `fun` | Insere uma definição de função. | `void myFunction(String name) {  }` |
| `class` | Insere uma definição de classe. | `class MyClass {  }` |
| `typedef` | Insere um typedef. | `typedef MyFunction = void Function(String);` |
| `test` | Insere um bloco de teste. | `test('My test description', () {  });` |
| `group` | Insere um bloco de grupo de teste. | `group('My test group', () {  });` |

Você também pode definir snippets customizados executando
**Configure User Snippets** a partir da [Command Palette][Command Palette].

### Atalhos de teclado

**Hot reload**
: Para executar um hot reload durante uma sessão de depuração,
  clique em **Hot Reload** na **Debug Toolbar**.

  Você também pode pressionar <kbd>Ctrl</kbd> + <kbd>F5</kbd>
  (<kbd>Cmd</kbd> + <kbd>F5</kbd>  no macOS).

  Mapeamentos de teclado podem ser alterados executando o
  comando **Open Keyboard Shortcuts** a partir da [Command Palette][Command Palette].

### Hot reload vs. hot restart

Hot reload funciona injetando arquivos de código-fonte atualizados no
Dart VM (Virtual Machine) em execução. Isso inclui não apenas
adicionar novas classes, mas também adicionar métodos e campos a
classes existentes, e alterar funções existentes.
Alguns tipos de mudanças de código não podem ter hot reload, no entanto:

- Inicializadores de variáveis globais
- Inicializadores de campos estáticos
- O método `main()` do app

Para essas mudanças, reinicie seu app sem
encerrar sua sessão de depuração. Para executar um hot restart,
execute o comando **Flutter: Hot Restart** a partir da [Command Palette][Command Palette].

Você também pode pressionar
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>F5</kbd>
ou <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>F5</kbd> no macOS.

## Flutter Property Editor {: #property-editor}

O Flutter Property Editor é uma ferramenta poderosa fornecida pela [extensão
Flutter][Flutter extension] que permite visualizar e modificar propriedades de widget diretamente de sua
interface visual.

### Como abrir o Flutter Property Editor no VS Code

1. Clique no **ícone** do Flutter Property Editor ![Flutter Property Editor VS Code icon](/assets/images/docs/tools/devtools/property-editor-icon-vscode.png){:width="20px"} na barra lateral do VS Code.
2. O Flutter Property Editor será carregado no painel lateral.
3. Por favor, consulte a [documentação][documentation] do Flutter Property Editor para um guia de uso detalhado.

![Flutter Property Editor side panel in VS Code](/assets/images/docs/tools/devtools/property-editor-vscode.png){:width="600px"}

[Flutter extension]: https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter
[documentation]: /tools/property-editor

## Solução de problemas

### Problemas conhecidos e feedback

Todos os bugs conhecidos são rastreados no issue tracker:
[issue tracker de extensões Dart e Flutter no GitHub][issue tracker].
Aceitamos feedback,
tanto sobre bugs/problemas quanto solicitações de recursos.

Antes de registrar novos problemas:

- Faça uma busca rápida nos issue trackers para ver se o
  problema já está sendo rastreado.
- Certifique-se de estar [atualizado][updating] com a versão mais recente
  do plugin.

Ao registrar novos problemas, inclua a saída do [flutter doctor][flutter doctor].

[Command Palette]: https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette
[DevTools]: /tools/devtools
[flutter doctor]: /resources/bug-reports/#provide-some-flutter-diagnostics
[Flutter inspector]: /tools/devtools/inspector
[Flutter's build modes]: /testing/build-modes
[Hot reload]: /tools/hot-reload
[let us know]: {{site.repo.this}}/issues/new
[issue tracker]: {{site.github}}/Dart-Code/Dart-Code/issues
[Running DevTools from VS Code]: /tools/devtools/vscode
[VS Code status bar]: /assets/images/docs/tools/vs-code/device_status_bar.png
[updating]: #updating
