---
title: Servidor MCP do Dart e Flutter
description: >
  Aprenda sobre a ferramenta de servidor MCP do Dart e Flutter que
  expõe ferramentas do Dart e Flutter para clientes e agentes
  de assistente de IA compatíveis.
ia-translate: true
---

Este guia discute o servidor MCP do Dart e Flutter.

:::note experimental
O servidor MCP do Dart e Flutter é experimental e provavelmente evoluirá rapidamente.
As instruções a seguir requerem Dart 3.9 ou posterior.
:::

## Visão geral

O [Dart and Flutter MCP server][]
expõe ações de ferramentas de desenvolvimento do Dart e Flutter para
clientes de assistente de IA compatíveis. MCP (model context protocol)
é um protocolo que permite a comunicação entre ferramentas de desenvolvimento
e assistentes de IA, permitindo que os assistentes entendam o
contexto do código e realizem ações em nome do desenvolvedor.

O servidor MCP do Dart e Flutter pode funcionar com qualquer cliente MCP que
suporte entrada/saída padrão (stdio) como meio de transporte.
Para acessar todos os recursos do servidor MCP do Dart e Flutter,
um cliente MCP deve suportar [Tools][] e [Resources][].
Para a melhor experiência de desenvolvimento com o servidor MCP do Dart e Flutter,
um cliente MCP também deve suportar [Roots][].

Se você estiver usando um cliente que afirma que
suporta roots mas não os define de fato,
passe `--force-roots-fallback` para habilitar ferramentas para gerenciar os roots.

O servidor MCP do Dart e Flutter fornece uma lista crescente de ferramentas que
concedem aos assistentes de IA insights profundos sobre seu projeto.
Aqui está uma visão geral de algumas coisas que ele pode fazer:

*  Analisar e corrigir erros no código do seu projeto.
*  Resolver símbolos para elementos para garantir sua existência e
   buscar informações de documentação e assinatura para eles.
*  Inspecionar e interagir com sua aplicação em execução.
*  Pesquisar no [site pub.dev]({{site.pub}}) pelo melhor pacote para um caso de uso.
*  Gerenciar dependências de pacotes no seu arquivo `pubspec.yaml`.
*  Executar testes e analisar os resultados.
*  Formatar código com o mesmo formatador e configuração do
   [`dart format`][] e do servidor de análise do Dart.

[Tools]: https://modelcontextprotocol.io/docs/concepts/tools
[Resources]: https://modelcontextprotocol.io/docs/concepts/resources
[Roots]: https://modelcontextprotocol.io/docs/concepts/roots
[Dart and Flutter MCP server]: https://github.com/dart-lang/ai/tree/main/pkgs/dart_mcp_server
[`dart format`]: {{site.dart-site}}/tools/dart-format

## Configure seu cliente MCP

Execute o servidor com o comando `dart mcp-server`,
que deve ser configurado no seu cliente preferido.

Esta seção fornece instruções para configurar o
servidor MCP do Dart e Flutter com ferramentas populares como Firebase Studio,
Gemini CLI, Gemini Code Assist, Cursor e GitHub Copilot.

### Gemini CLI

Para configurar o [Gemini CLI][] para usar o servidor MCP do Dart e Flutter,
adicione uma entrada Dart à seção `mcpServers` da configuração do Gemini.

-  Para habilitar o servidor para todos os projetos no seu dispositivo,
   edite o arquivo `~/.gemini/settings.json` no seu diretório home.
-  Para habilitar o servidor para um projeto específico,
   edite o arquivo `.gemini/settings.json` no diretório raiz do projeto.

```json title=".gemini/settings.json"
{
  "mcpServers": {
    "dart": {
      "command": "dart",
      "args": [
        "mcp-server"
      ]
    }
  }
}
```

Para mais informações, consulte a documentação oficial do Gemini CLI
para [configuração de servidores MCP][setting up MCP servers].

[Gemini CLI]: https://geminicli.com/docs/
[setting up MCP servers]: https://geminicli.com/docs/tools/mcp-server/#how-to-set-up-your-mcp-server

### Firebase Studio

Se você deseja usar o servidor MCP do Dart e Flutter no [Firebase Studio][],
um ambiente de desenvolvimento agentic baseado em nuvem que ajuda
você a construir e lançar aplicativos de IA full-stack com qualidade de produção,
siga estas etapas:

1.  No seu projeto de aplicativo do Firebase Studio, crie um
    arquivo `.idx/mcp.json` no seu projeto se ele
    ainda não existir e adicione a seguinte
    configuração do servidor MCP do Dart e Flutter ao arquivo:

    ```json title=".idx/mcp.json"
    {
      "mcpServers": {
        "dart": {
          "command": "dart",
          "args": [
            "mcp-server"
          ]
        }
      }
    }
    ```

1.  Certifique-se de que seu ambiente está executando Dart SDK 3.9/Flutter 3.35 ou posterior.
1.  Reconstrua seu workspace para concluir a configuração.
    *   Abra a Command Palette (**Shift+Ctrl+P**).
    *   Digite **Firebase Studio: Rebuild Environment**.

Para mais informações sobre configuração de servidor MCP no
Firebase Studio, consulte [Personalize seu workspace do Firebase Studio][Customize your Firebase Studio workspace].

[Firebase Studio]: https://firebase.studio/
[Customize your Firebase Studio workspace]: https://firebase.google.com/docs/studio/customize-workspace

### Gemini Code Assist no VS Code

O [modo Agent][Agent mode] do [Gemini Code Assist][] integra o
Gemini CLI para fornecer um agente de IA poderoso diretamente na sua IDE.
Se você ainda não configurou o Gemini Code Assist ou seu modo agent,
siga suas [instruções de Antes de começar][gca-setup] para começar.

Para configurar o Gemini Code Assist para usar o servidor MCP do Dart e Flutter,
siga as instruções para [configurar o Gemini CLI][configure the Gemini CLI].

Você pode verificar se o servidor MCP foi configurado
corretamente digitando `/mcp` na janela de chat no modo Agent.

Para mais informações, consulte a documentação oficial do Gemini Code Assist
para [uso do modo agent][using agent mode].

[gca-setup]: https://developers.google.com/gemini-code-assist/docs/use-agentic-chat-pair-programmer#before-you-begin
[Gemini Code Assist]: https://codeassist.google/
[Agent mode]: https://developers.google.com/gemini-code-assist/docs/use-agentic-chat-pair-programmer
[configure the Gemini CLI]: #gemini-cli
[using agent mode]: https://developers.google.com/gemini-code-assist/docs/use-agentic-chat-pair-programmer#before-you-begin

### GitHub Copilot no VS Code

:::note
O suporte para o servidor MCP do Dart e Flutter no VS Code requer
v3.116 ou posterior da [extensão Dart Code][Dart Code extension].
:::

Por padrão, a extensão Dart usa a
[API MCP do VS Code][VS Code MCP API] para registrar o servidor MCP do Dart e Flutter, bem como
uma ferramenta para fornecer o URI para o Dart Tooling Daemon ativo.

Habilite ou desabilite explicitamente o servidor MCP do Dart e Flutter
configurando a configuração `dart.mcpServer` nas suas configurações do VS Code.

Para alterar isso globalmente, atualize suas configurações de usuário:

1.  No VS Code, clique em **View > Command Palette** e então
    pesquise por **Preferences: Open User Settings (JSON)**.

1.  Adicione a seguinte configuração:

    ```json
    "dart.mcpServer": true
    ```

Se você quiser que essa configuração se aplique apenas a um workspace específico,
adicione a entrada às suas configurações de workspace:

1.  No VS Code, clique em **View > Command Palette** e então
    pesquise por **Preferences: Open Workspace Settings (JSON)**.

1.  Adicione a seguinte configuração:

    ```json
    "dart.mcpServer": true
    ```

Para mais informações, consulte a documentação oficial do VS Code
para [habilitar suporte MCP][enabling MCP support].

[Dart Code extension]: https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code
[VS Code MCP API]: https://code.visualstudio.com/api/extension-guides/mcp
[enabling MCP support]: https://code.visualstudio.com/docs/copilot/chat/mcp-servers#_enable-mcp-support-in-vs-code

### Cursor

A maneira mais fácil de configurar o servidor MCP do Dart e Flutter com o
Cursor é clicando no botão **Add to Cursor**:

[![Add to Cursor](https://cursor.com/deeplink/mcp-install-dark.svg)](cursor://anysphere.cursor-deeplink/mcp/install?name=dart&config=eyJjb21tYW5kIjoiZGFydCBtY3Atc2VydmVyIn0%3D){:.light-mode-visible}
[![Add to Cursor](https://cursor.com/deeplink/mcp-install-light.svg)](cursor://anysphere.cursor-deeplink/mcp/install?name=dart&config=eyJjb21tYW5kIjoiZGFydCBtY3Atc2VydmVyIn0%3D){:.dark-mode-visible}

Alternativamente, você pode configurar o servidor manualmente:

1.  Vá para **Cursor > Settings > Cursor Settings > Tools & Integrations**.
1.  Clique em **Add Custom MCP** ou **New MCP Server**
    dependendo se você já tem outros servidores MCP configurados.
1.  Edite o arquivo `.cursor/mcp.json` no seu projeto local
    (a configuração se aplicará apenas a este projeto) ou
    edite o arquivo global `~/.cursor/mcp.json` no seu diretório home
    (a configuração se aplicará a todos os projetos) para
    configurar o servidor MCP do Dart e Flutter:

    ```json title=".cursor/mcp.json"
    {
      "mcpServers": {
        "dart": {
          "command": "dart",
          "args": [
            "mcp-server"
          ]
        }
      }
    }
    ```

Para mais informações, consulte a documentação oficial do Cursor
para [instalação de servidores MCP][installing MCP servers].

[installing MCP servers]: https://docs.cursor.com/context/model-context-protocol#installing-mcp-servers

## Use seu cliente MCP

Uma vez que você tenha configurado o servidor MCP do Dart e Flutter com um cliente,
o servidor MCP do Dart e Flutter permite que o cliente não apenas raciocine
sobre o contexto do seu projeto, mas também tome ações com ferramentas.

O [Large Language Model (LLM)][LLM] decide quais ferramentas usar e quando,
então você pode se concentrar em descrever seu objetivo em linguagem natural.
Vamos ver isso em ação com alguns exemplos usando
o modo Agent do GitHub Copilot no VS Code.

[LLM]: https://developers.google.com/machine-learning/resources/intro-llms

### Corrigir um erro de layout em tempo de execução em um aplicativo Flutter

Todos nós já passamos por isso: você constrói uma UI bonita, executa o aplicativo,
e é recebido pelas infames listras amarelas e pretas de
um erro de overflow do RenderFlex.
Em vez de depurar manualmente a árvore de widgets, agora você pode
pedir ajuda ao seu assistente de IA com um prompt semelhante ao seguinte:

> Verifique e corrija problemas de análise estática e em tempo de execução.
> Verifique e corrija quaisquer problemas de layout.

Nos bastidores, o agente de IA usa as ferramentas do servidor MCP do Dart e Flutter para:

*  Ver o erro: Ele usa uma ferramenta para obter os erros atuais em tempo de execução
   da aplicação em execução.
*  Inspecionar a UI: Ele acessa a árvore de widgets do Flutter para entender
   o layout que está causando o overflow.
*  Aplicar uma correção: Armado com esse contexto, ele aplica uma correção e
   verifica mais uma vez se há erros restantes.

Você pode então manter ou desfazer as alterações de código.

### Adicionar nova funcionalidade com pesquisa de pacotes

Imagine que você precisa adicionar um gráfico ao seu aplicativo.
Qual pacote você deve usar? Como adicioná-lo e escrever o boilerplate?
O servidor MCP do Dart e Flutter pode agilizar todo esse processo com
um prompt semelhante ao seguinte:

> Encontre um pacote adequado para adicionar um gráfico de linha que
> mapeia o número de pressionamentos de botão ao longo do tempo.

O agente de IA agora age como um verdadeiro assistente:

*  Encontrar a ferramenta certa: Ele usa a ferramenta `pub_dev_search` para
   encontrar bibliotecas de gráficos populares e bem avaliadas.
*  Gerenciar dependências: Depois que você confirma sua escolha,
   como [`package:fl_chart`][],
   ele usa uma ferramenta para adicionar o pacote como uma dependência.
*  Gerar o código: Ele gera o novo código do widget,
   completo com boilerplate para um gráfico de linha que ele coloca na UI.
   Ele até mesmo autocorrige erros de sintaxe introduzidos durante o processo.
   Você pode personalizar ainda mais a partir daí.

O que costumava ser um processo de várias etapas de pesquisa,
leitura de documentação, edição do `pubspec.yaml` e
escrita do código apropriado no seu aplicativo,
agora é uma única solicitação.

[`package:fl_chart`]: {{site.pub-pkg}}/fl_chart
