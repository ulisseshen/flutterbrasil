---
ia-translate: true
title: Comece a desenvolver com IA
shortTitle: Comece aqui
description: >-
  Aprenda a configurar e usar plugins de agentes de IA para Flutter e Dart
  com o assistente de código de sua preferência.
---

Assistentes de código com IA podem acelerar seu fluxo de desenvolvimento Flutter
escrevendo código, corrigindo erros e construindo funcionalidades completas.

Por padrão, assistentes de IA de propósito geral podem não ter o contexto mais
recente sobre padrões do Flutter, diagnósticos de projeto ou pacotes de terceiros.
Instalar o plugin oficial de agente do Flutter equipa seu assistente com
ferramentas e receitas dedicadas, feitas sob medida para o desenvolvimento
em Flutter e Dart.

## Como os plugins de IA do Flutter funcionam {:#how-flutter-ai-plugins-work}

Um **plugin de agente** reúne as ferramentas e o conhecimento de que um assistente
de IA precisa para entender e modificar sua base de código Flutter.

Quando você instala um plugin oficial de agente do Flutter, ele conecta seu
assistente a quatro capacidades principais:

* **[Skills de agente](/ai/tools#agent-skills)**: guias procedimentais sob demanda
  dos repositórios oficiais do Flutter e do Dart que ensinam o assistente a
  executar tarefas específicas, como criar layouts responsivos, gerenciar estado
  ou escrever testes de widget.
* **[Regras de agente](/ai/tools#agent-rules)**: instruções persistentes que guiam
  as respostas de um assistente, como acionar proativamente o hot reload com
  estado ao editar widgets Flutter.
* **[Servidor MCP do Dart e Flutter](/ai/tools#dart-and-flutter-mcp-server)**:
  um servidor Model Context Protocol (MCP) que conecta o assistente ao SDK do Dart,
  dando a ele acesso em tempo real a diagnósticos do analyzer, resolução de símbolos,
  executores de testes e inspeção de runtime.
* **[Agentes especializados](/ai/tools#specialized-agents)**: personas de assistente
  focadas, feitas sob medida para fluxos de trabalho dedicados, como o agente de
  acessibilidade do Flutter (`a11y`), que faz auditorias automatizadas de
  acessibilidade e correções de código.

Essas ferramentas funcionam em conjunto automaticamente: o assistente usa as
ferramentas MCP para consultar o estado ao vivo do projeto e a análise estática,
enquanto usa as skills de agente para orientar suas estratégias de codificação e
boas práticas.

Além dos plugins principais do Flutter, você também pode equipar seu assistente com
skills distribuídas diretamente por pacotes de terceiros no `pub.dev`, usando
[skills de pacotes](https://dart.dev/ai/package-skills).

Para saber mais sobre a arquitetura subjacente e as capacidades de cada ferramenta,
confira [Como as ferramentas de IA do Flutter funcionam](/ai/tools).

## Escolha seu agente de codificação com IA {:#choose-your-ai-coding-agent}

Selecione seu agente abaixo para ver instruções sobre como instalar os plugins
oficiais e configurar as ferramentas para o desenvolvimento Flutter.

<Tabs key="ai-agent-tabs" wrapped="true">

<Tab name="Antigravity">

O [Antigravity](
https://antigravity.google/docs/build-with-google/#dart-and-flutter)
é uma plataforma de desenvolvimento agêntico do Google que inclui o Antigravity
IDE, extensões de IDE (para VS Code e outros editores) e o Antigravity CLI.

**Antigravity IDE e extensões**

Equipe o Antigravity IDE ou a extensão do Antigravity (como no VS Code)
com as ferramentas oficiais do Dart e do Flutter:

1. Abra **Settings** no Antigravity clicando no ícone de engrenagem ou pressionando
   <kbd class="special-key">Cmd/Ctrl</kbd> + <kbd>,</kbd>.
1. Clique na aba **Customizations**.
1. Na seção **Build with Google Plugins**, clique em **Customize**.
1. Clique em **Download** ao lado da integração **Dart and Flutter**.

Para verificar a instalação, abra o painel **Agent**
(<kbd class="special-key">Cmd/Ctrl</kbd> + <kbd>L</kbd>) e pergunte ao agente:

```text
Summarize the Dart and Flutter tools and skills available in this project.
```

**Antigravity CLI**

O Antigravity CLI é executado com o comando `agy` no seu terminal.

1. Configure o servidor MCP do Dart e Flutter no arquivo `.agents/mcp_config.json`
   do seu projeto (ou globalmente em
   `~/.gemini/config/mcp_config.json`):

   ```json
   {
     "mcpServers": {
       "dart": {
         "command": "dart",
         "args": ["mcp-server"]
       }
     }
   }
   ```

1. Instale as skills oficiais de Flutter e Dart no seu workspace:

   ```bash
   # Install Flutter skills
   npx skills add flutter/agent-plugins --skill '*' --agent universal --yes

   # Install Dart skills
   npx skills add dart-lang/skills --skill '*' --agent universal --yes
   ```

1. Inicie uma sessão interativa na raiz do seu projeto:

   ```bash
   agy
   ```

</Tab>

<Tab name="Claude Code">

O [Claude Code](https://code.claude.com/) é um assistente de codificação agêntico
da Anthropic que roda no seu terminal.

**Instale o plugin oficial**

Equipe o Claude Code com as skills oficiais de Flutter e Dart e a configuração MCP:

1. Adicione o marketplace de plugins do Claude Code:

   ```bash
   claude plugin marketplace add flutter/agent-plugins
   ```

1. Instale o plugin de Flutter e Dart:

   ```bash
   claude plugin install dart-flutter@dart-flutter
   ```

**Configure as regras do agente**

Os plugins do Claude Code descobrem skills e servidores MCP,
mas não carregam automaticamente as regras dos plugins.
Para equipar o Claude Code com as regras oficiais do Flutter,
adicione as regras que você quiser do
[repositório oficial de regras](https://github.com/flutter/agent-plugins/tree/main/rules)
ao arquivo `CLAUDE.md` do seu projeto.

**Verifique a instalação**

Verifique se o plugin está ativo no Claude Code:

```bash
claude plugin marketplace list
```

</Tab>

<Tab name="Cursor">

O [Cursor](https://cursor.com/) é um editor de código com IA construído sobre o VS Code.

**Instale o plugin oficial**

Equipe o Cursor com as skills oficiais de Flutter e Dart e a configuração MCP
usando qualquer um dos seguintes métodos:

* Acesse o [plugin Dart and Flutter](https://cursor.com/marketplace/flutter)
  no Cursor Marketplace e selecione **Add to Cursor**.
* No Cursor, abra **Customize**, depois pesquise e adicione **Dart and Flutter**.
* Em uma sessão de chat do Cursor, execute `/add-plugin dart-flutter`.

O Cursor descobre automaticamente as skills incluídas e configura
o servidor MCP do Dart e Flutter.

**Configure as regras do agente**

O Cursor oferece suporte a regras com escopo por arquivo no diretório `.cursor/rules/`,
usando arquivos `.mdc`.
Para equipar o Cursor com as regras oficiais do Flutter,
baixe os arquivos `.mdc` do
[repositório oficial de regras](https://github.com/flutter/agent-plugins/tree/main/rules)
para o diretório `.cursor/rules/` do seu projeto.

</Tab>

<Tab name="Codex">

O [Codex](https://chatgpt.com/codex) é um assistente de codificação agêntico
projetado para fluxos de trabalho no terminal e na IDE.

**Instale o plugin oficial**

Equipe o Codex com as skills oficiais de Flutter e Dart e a configuração MCP:

1. Adicione o marketplace de plugins do Dart e Flutter para o Codex:

   ```bash
   codex plugin marketplace add flutter/agent-plugins
   ```

1. Instale o plugin do Dart e Flutter:

   ```bash
   codex plugin add dart-flutter@dart-flutter
   ```

**Configure as regras do agente**

Os plugins do Codex instalam skills e servidores MCP,
mas não incluem regras automaticamente.
Para equipar o Codex com as regras oficiais do Flutter,
baixe os arquivos de regra `.md` do
[repositório oficial de regras](https://github.com/flutter/agent-plugins/tree/main/rules)
para o diretório `.agent/rules/` do seu projeto,
ou acrescente as instruções das regras ao `CODEX.md`.

**Verifique a instalação**

Verifique se o plugin está ativo no Codex:

```bash
codex plugin list
```

</Tab>

<Tab name="GitHub Copilot">

O [GitHub Copilot](https://github.com/features/copilot) no VS Code oferece suporte
a codificação agêntica, chamada de ferramentas via MCP e instruções personalizadas
para o workspace.

**Configure o servidor MCP**

1. Verifique se a extensão **Model Context Protocol (MCP)** está habilitada no VS Code.
1. Crie ou abra `.vscode/mcp.json` no seu workspace e adicione o servidor MCP
   do Dart:

   ```json
   {
     "servers": {
       "dart": {
         "command": "dart",
         "args": ["mcp-server"]
       }
     }
   }
   ```

**Instale as skills de agente**

Na raiz do seu projeto Flutter, instale as skills oficiais usando a flag universal:

```bash
# Install Flutter skills
npx skills add flutter/agent-plugins --skill '*' --agent universal --yes

# Install Dart skills
npx skills add dart-lang/skills --skill '*' --agent universal --yes
```

**Configure as regras do agente**

O GitHub Copilot oferece suporte a instruções personalizadas do workspace em
`.github/copilot-instructions.md`.
Para equipar o Copilot com as regras oficiais do Flutter,
adicione as regras que você quiser do
[repositório oficial de regras](https://github.com/flutter/agent-plugins/tree/main/rules)
ao arquivo `.github/copilot-instructions.md` do seu projeto.

</Tab>

<Tab name="Other">

Se você usa outro assistente de codificação (como Windsurf, Zed ou Cline)
que oferece suporte ao Model Context Protocol (MCP) ou à especificação de Agent Skills,
configure as ferramentas manualmente.

**Configure o servidor MCP**

A maioria dos clientes compatíveis com MCP usa um formato de configuração JSON padrão.
Adicione a seguinte entrada ao arquivo de configuração MCP do seu cliente:

```json
{
  "mcpServers": {
    "dart": {
      "command": "dart",
      "args": ["mcp-server"]
    }
  }
}
```

Para guias de configuração específicos de cada cliente, argumentos de linha de comando
e solução de problemas, consulte o
[repositório do servidor MCP do Dart e Flutter](
https://github.com/dart-lang/ai/tree/main/pkgs/dart_mcp_server).

**Instale as skills de agente**

Use a CLI `skills` para baixar as skills para o diretório padrão
`.agents/skills` do seu workspace:

```bash
# Install Flutter skills
npx skills add flutter/agent-plugins --skill '*' --agent universal --yes

# Install Dart skills
npx skills add dart-lang/skills --skill '*' --agent universal --yes
```

**Configure as regras do agente**

Se o seu assistente de código oferece suporte a instruções ou regras de projeto
(como `.windsurfrules` do Windsurf ou `.clinerules` do Cline),
copie ou baixe as regras do
[repositório oficial de regras](https://github.com/flutter/agent-plugins/tree/main/rules)
para o arquivo de configuração do seu assistente.

</Tab>

</Tabs>

## Próximos passos {:#next-steps}

* Para saber mais sobre como skills e ferramentas interagem, confira
  [Como as ferramentas de IA do Flutter funcionam](/ai/tools).
* Para descobrir e instalar skills de dependências, consulte
  [Skills de pacotes](https://dart.dev/ai/package-skills).
* Para publicar skills com seus próprios pacotes, consulte
  [Distribua skills com pacotes](https://dart.dev/tools/pub/package-skills).
* Para dar ao seu assistente acesso de busca à documentação oficial de Flutter e Dart,
  conecte-se ao [servidor MCP Developer Knowledge](
  https://developers.google.com/knowledge/mcp).
* Para explorar os plugins oficiais, confira o repositório
  [flutter/agent-plugins](https://github.com/flutter/agent-plugins).
