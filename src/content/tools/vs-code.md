---
ia-translate: true
title: Visual Studio Code
short-title: VS Code
description: Como desenvolver aplicativos Flutter no Visual Studio Code.
---

<ul class="nav nav-tabs" id="ide-tabs" role="tablist">
  <li class="nav-item">
    <a class="nav-link" href="/tools/android-studio" role="tab" aria-selected="false">Android Studio e IntelliJ</a>
  </li>
  <li class="nav-item">
    <a class="nav-link active" role="tab" aria-selected="true">Visual Studio Code</a>
  </li>
</ul>

## Instalação e configuração

Siga as instruções em [Configurar um editor][] para
instalar as extensões (também chamadas de plugins) Dart e Flutter.

### Atualizando a extensão {:#updating}

As atualizações das extensões são enviadas regularmente.
Por padrão, o VS Code atualiza automaticamente as extensões quando
há atualizações disponíveis.

Para instalar as atualizações manualmente:

1. Clique em **Extensões** na Barra Lateral.
1. Se a extensão Flutter tiver uma atualização disponível,
   clique em **Atualizar** e, em seguida, em **Recarregar**.
1. Reinicie o VS Code.

## Criando projetos

Existem algumas maneiras de criar um novo projeto.

### Criando um novo projeto

Para criar um novo projeto Flutter a partir do modelo
de aplicativo inicial do Flutter:

1. Vá para **Exibir** <span aria-label="e então">></span>
   **Paleta de Comandos...**.

   Você também pode pressionar <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> +
   <kbd>Shift</kbd> + <kbd>P</kbd>.

1. Digite `flutter`.
1. Selecione **Flutter: Novo Projeto**.
1. Pressione <kbd>Enter</kbd>.
1. Selecione **Aplicativo**.
1. Pressione <kbd>Enter</kbd>.
1. Selecione um **Local do Projeto**.
1. Insira o **Nome do Projeto** desejado.

### Abrindo um projeto a partir de código-fonte existente

Para abrir um projeto Flutter existente:

1. Vá para **Arquivo** <span aria-label="e então">></span> **Abrir**.

   Você também pode pressionar <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> + <kbd>O</kbd>

1. Navegue até o diretório que contém seus arquivos
   de código-fonte Flutter existentes.
1. Clique em **Abrir**.

## Editando código e visualizando problemas

A extensão Flutter realiza análise de código.
A análise de código pode:

- Destacar a sintaxe da linguagem
- Completar o código com base em análise de tipo rica
- Navegar para declarações de tipo

  - Vá para **Ir** <span aria-label="e então">></span> **Ir para Definição**.
  - Você também pode pressionar <kbd>F12</kbd>.

- Encontrar usos de tipo.

  - Pressione <kbd>Shift</kbd> + <kbd>F12</kbd>.

- Visualizar todos os problemas atuais do código-fonte.

  - Vá para **Exibir** <span aria-label="e então">></span> **Problemas**.
  - Você também pode pressionar <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> +
    <kbd>Shift</kbd> + <kbd>M</kbd>.
  - O painel Problemas exibe quaisquer problemas de análise:<br>
    ![Painel Problemas](/assets/images/docs/tools/vs-code/problems.png){:.mw-100 .pt-1}

## Executando e depurando

:::note
Você pode depurar seu aplicativo de algumas maneiras.

- Usando o [DevTools][], um conjunto de ferramentas de depuração e
  profiling que são executadas em um navegador.
- Usando os recursos de depuração integrados do VS Code,
  como definir breakpoints.

As instruções abaixo descrevem os recursos disponíveis no VS Code.
Para obter informações sobre como iniciar e usar o DevTools, consulte
[Executando o DevTools a partir do VS Code][] na documentação do
[DevTools][].
:::

Comece a depurar clicando em **Executar > Iniciar Depuração**
na janela principal do IDE ou pressione <kbd>F5</kbd>.

### Selecionando um dispositivo de destino

Quando um projeto Flutter está aberto no VS Code,
você deve ver um conjunto de entradas específicas do Flutter na
barra de status, incluindo uma versão do SDK do Flutter e um
nome de dispositivo (ou a mensagem **Nenhum Dispositivo**):<br>
![Barra de status do VS Code][]{:.mw-100 .pt-1}

:::note
- Se você não vir um número de versão do Flutter ou informações do dispositivo,
  seu projeto pode não ter sido detectado como um projeto Flutter.
  Certifique-se de que a pasta que contém seu `pubspec.yaml` esteja
  dentro de uma **Pasta de Workspace** do VS Code.
- Se a barra de status exibir **Nenhum Dispositivo**, o Flutter não conseguiu
  descobrir nenhum dispositivo iOS ou Android conectado ou simuladores.
  Você precisa conectar um dispositivo ou iniciar um simulador ou emulador
  para prosseguir.
:::

A extensão Flutter seleciona automaticamente o último dispositivo conectado.
No entanto, se você tiver vários dispositivos/simuladores conectados, clique
em **dispositivo** na barra de status para ver uma lista de seleção
na parte superior da tela. Selecione o dispositivo que você deseja usar para
executar ou depurar.

:::secondary
**Você está desenvolvendo para macOS ou iOS remotamente usando
Visual Studio Code Remote?** Se sim, pode ser necessário
desbloquear manualmente o chaveiro. Para mais informações, consulte esta
[pergunta no StackExchange][].
:::

[question on StackExchange]: https://superuser.com/questions/270095/when-i-ssh-into-os-x-i-dont-have-my-keychain-when-i-use-terminal-i-do/363840#363840

### Executar aplicativo sem breakpoints

Vá para **Executar** > **Iniciar sem Depuração**.

Você também pode pressionar <kbd>Ctrl</kbd> + <kbd>F5</kbd>.

### Executar aplicativo com breakpoints

1. Se desejar, defina breakpoints em seu código-fonte.
1. Clique em **Executar** <span aria-label="e então">></span> **Iniciar Depuração**.
   Você também pode pressionar <kbd>F5</kbd>.
   A barra de status fica laranja para mostrar que você está em uma sessão de depuração.<br>
   ![Console de depuração](/assets/images/docs/tools/vs-code/debug_console.png){:.mw-100 .pt-1}

   - A **Barra Lateral de Depuração** à esquerda mostra os frames da pilha e as variáveis.
   - O painel inferior **Console de Depuração** mostra a saída de log detalhada.
   - A depuração é baseada em uma configuração de inicialização padrão.
     Para personalizar, clique na engrenagem na parte superior da
     **Barra Lateral de Depuração** para criar um arquivo `launch.json`.
     Em seguida, você pode modificar os valores.

### Executar aplicativo em modo debug, profile ou release

O Flutter oferece vários modos de build diferentes para executar seu aplicativo.
Você pode ler mais sobre eles em [Modos de build do Flutter][].

1. Abra o arquivo `launch.json` no VS Code.

   Se você não tiver um arquivo `launch.json`:

   {: type="a"}
   1. Vá para **Exibir** <span aria-label="e então">></span> **Executar**.

      Você também pode pressionar <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> +
      <kbd>Shift</kbd> + <kbd>D</kbd>

      O painel **Executar e Depurar** é exibido.

   1. Clique em **criar um arquivo launch.json**.

1. Na seção `configurations`,
   altere a propriedade `flutterMode` para o
   modo de build que você deseja usar.

   Por exemplo, se você quiser executar no modo debug,
   seu `launch.json` pode ser semelhante a este:

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

1. Execute o aplicativo através do painel **Executar**.

## Ciclo de desenvolvimento de edição rápida e atualização

O Flutter oferece um ciclo de desenvolvedor de primeira classe, permitindo que você
veja o efeito de suas alterações quase instantaneamente com o
recurso _Stateful Hot Reload_.
Para saber mais, consulte [Hot reload][].

## Depuração avançada

Você pode achar as seguintes dicas de depuração avançada úteis:

### Depurando problemas de layout visual

Durante uma sessão de depuração,
vários comandos de depuração adicionais são adicionados à
[Paleta de Comandos][] e ao [Inspetor Flutter][].
Quando o espaço é limitado, o ícone é usado como a versão visual
do rótulo.

**Alternar Pintura de Linha de Base** ![Ícone de pintura de linha de base](/assets/images/docs/tools/devtools/paint-baselines-icon.png){:width="20px"}
: Faz com que cada RenderBox pinte uma linha em cada uma de suas linhas de base.

**Alternar Arco-Íris de Repintura** ![Ícone de arco-íris de repintura](/assets/images/docs/tools/devtools/repaint-rainbow-icon.png){:width="20px"}
: Mostra cores rotativas nas camadas ao repintar.

**Alternar Animações Lentas** ![Ícone de animações lentas](/assets/images/docs/tools/devtools/slow-animations-icon.png){:width="20px"}
: Diminui a velocidade das animações para permitir a inspeção visual.

**Alternar Banner do Modo de Depuração** ![Ícone de banner do modo de depuração](/assets/images/docs/tools/devtools/debug-mode-banner-icon.png){:width="20px"}
: Oculta o banner do modo de depuração mesmo ao executar um build de depuração.

### Depurando bibliotecas externas

Por padrão, a depuração de uma biblioteca externa está desabilitada
na extensão Flutter. Para habilitar:

1. Selecione **Configurações > Extensões > Configuração do Dart**.
2. Marque a opção `Debug External Libraries`.

## Dicas de edição para código Flutter

Se você tiver dicas adicionais que devemos compartilhar, [nos avise][]!

### Assistências e correções rápidas

As assistências são alterações de código relacionadas a um determinado identificador de código.
Várias dessas assistências estão disponíveis quando o cursor é colocado em um
identificador de widget Flutter, conforme indicado pelo ícone de lâmpada amarela.
Para invocar a assistência, clique na lâmpada conforme mostrado na captura de tela a seguir:

![Assistências de código](/assets/images/docs/tools/vs-code/assists.png){:width="467px"}

Você também pode pressionar <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> + <kbd>.</kbd>

As correções rápidas são semelhantes,
apenas são mostradas quando um pedaço de código tem um erro e elas
podem ajudar a corrigi-lo.

**Assistência Envolver com Novo Widget**
: Isso pode ser usado quando você tem um widget que deseja envolver
  em um widget circundante, por exemplo, se você quiser envolver um
  widget em uma `Row` ou `Column`.

**Assistência Envolver Lista de Widgets com Novo Widget**
: Semelhante à assistência acima, mas para envolver uma lista
  existente de widgets em vez de um widget individual.

**Assistência Converter filho em filhos**
: Altera um argumento filho para um argumento filhos e
  envolve o valor do argumento em uma lista.

**Assistência Converter StatelessWidget em StatefulWidget**
: Altera a implementação de um `StatelessWidget` para a de um
  `StatefulWidget`, criando a classe `State` e movendo o
  código para lá.

### Snippets

Snippets podem ser usados para acelerar a entrada de estruturas de código típicas.
Eles são invocados digitando seu prefixo e,
em seguida, selecionando na janela de conclusão de código:
![Snippets](/assets/images/docs/tools/vs-code/snippets.png){:width="100%"}

A extensão Flutter inclui os seguintes snippets:

- Prefixo `stless`: Crie uma nova subclasse de -StatelessWidget`.
- Prefixo `stful`: Crie uma nova subclasse de `StatefulWidget`
  e sua subclasse State associada.
- Prefixo `stanim`: Crie uma nova subclasse de `StatefulWidget`,
  e sua subclasse State associada, incluindo um campo inicializado
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
| `test` | Insere um bloco de teste. | `test('Minha descrição de teste', () {  });` |
| `group` | Insere um bloco de grupo de teste. | `group('Meu grupo de teste', () {  });` |

Você também pode definir snippets personalizados executando
**Configurar Snippets de Usuário** na [Paleta de Comandos][].

### Atalhos de teclado

**Hot reload**
: Para executar um hot reload durante uma sessão de depuração,
  clique em **Hot Reload** na **Barra de Ferramentas de Depuração**.

  Você também pode pressionar <kbd>Ctrl</kbd> + <kbd>F5</kbd>
  (<kbd>Cmd</kbd> + <kbd>F5</kbd> no macOS).

  Os mapeamentos de teclado podem ser alterados executando o
  comando **Abrir Atalhos de Teclado** na [Paleta de Comandos][].

### Hot reload vs. hot restart

O hot reload funciona injetando arquivos de código-fonte atualizados na
VM (Máquina Virtual) Dart em execução. Isso inclui não apenas
adicionar novas classes, mas também adicionar métodos e campos a
classes existentes e alterar funções existentes.
Alguns tipos de alterações de código não podem ser hot reloaded:

- Inicializadores de variáveis globais
- Inicializadores de campos estáticos
- O método `main()` do aplicativo

Para essas alterações, reinicie seu aplicativo sem
encerrar sua sessão de depuração. Para executar um hot restart,
execute o comando **Flutter: Hot Restart** na [Paleta de Comandos][].

Você também pode pressionar
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>F5</kbd>
ou <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>F5</kbd> no macOS.

## Solução de problemas

### Problemas conhecidos e feedback

Todos os bugs conhecidos são rastreados no rastreador de problemas:
[Rastreador de problemas do GitHub das extensões Dart e Flutter][issue tracker].
Agradecemos o feedback,
tanto sobre bugs/problemas quanto sobre solicitações de recursos.

Antes de enviar novos problemas:

- Faça uma pesquisa rápida nos rastreadores de problemas para ver se o
  problema já está sendo rastreado.
- Certifique-se de que você está [atualizado](#updating) com a versão mais recente
  do plugin.

Ao enviar novos problemas, inclua a saída do [flutter doctor][].

[Command Palette]: https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette
[DevTools]: /tools/devtools
[flutter doctor]: /resources/bug-reports/#provide-some-flutter-diagnostics
[Flutter inspector]: /tools/devtools/inspector
[Modos de build do Flutter]: /testing/build-modes
[Hot reload]: /tools/hot-reload
[nos avise]: {{site.repo.this}}/issues/new
[issue tracker]: {{site.github}}/Dart-Code/Dart-Code/issues
[Executando o DevTools a partir do VS Code]: /tools/devtools/vscode
[Configurar um editor]: /get-started/editor?tab=vscode
[Barra de status do VS Code]: /assets/images/docs/tools/vs-code/device_status_bar.png

