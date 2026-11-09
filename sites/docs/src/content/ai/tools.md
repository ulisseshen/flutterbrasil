---
ia-translate: true
title: Como as ferramentas de IA do Flutter funcionam
shortTitle: Como as ferramentas de IA funcionam
description: >-
  Saiba como as agent skills, o servidor MCP do Dart e do Flutter e as
  package skills interagem para auxiliar no seu fluxo de desenvolvimento.
---

O Flutter e o Dart oferecem um conjunto integrado de ferramentas projetadas para ajudar
assistentes de programação com IA a entender sua base de código, seguir as melhores práticas
e executar tarefas de desenvolvimento com precisão.

## Visão geral do ecossistema de ferramentas {:#tooling-ecosystem-overview}

O ecossistema de ferramentas de IA do Flutter é composto por seis componentes complementares:

1. **Agent skills**: blueprints orientados a tarefas que ensinam os assistentes a
   executar fluxos de trabalho específicos (como criar layouts responsivos ou
   escrever testes).
2. **Servidor MCP do Dart e do Flutter**: um servidor Model Context Protocol (MCP)
   que expõe para os assistentes diagnósticos do SDK em tempo real, resolução de símbolos
   e introspecção em tempo de execução.
3. **Servidor MCP da Developer Knowledge**: um servidor de busca na documentação
   hospedado na nuvem, que dá aos assistentes acesso direto à documentação oficial
   do Flutter e do Dart.
4. **Package skills**: skills publicadas diretamente dentro de pacotes de terceiros
   no `pub.dev`, dando aos assistentes conhecimento instantâneo sobre bibliotecas específicas.
5. **Agentes especializados**: personas de agente dedicadas, equipadas com ferramentas
   focadas e instruções de sistema para fluxos de trabalho isolados, como auditoria
   de acessibilidade.
6. **Regras de agente**: regras persistentes adicionadas à janela de contexto toda vez
   que você inicia uma nova sessão com seu assistente (por exemplo, instruir o
   assistente a acionar proativamente o hot reload ao modificar widgets Flutter).

---

## Agent skills

[Agent skills](https://agentskills.io/) oferecem uma forma padronizada de equipar
assistentes de IA com conhecimento procedural de domínio.

### Divulgação progressiva {:#progressive-disclosure}

As skills usam **divulgação progressiva** para economizar o contexto do modelo:

* **Fase de descoberta**: o assistente lê inicialmente apenas os metadados da skill (nome
  e descrição curta) do diretório `.agents/skills`.
* **Fase de execução**: quando o assistente determina que uma skill é relevante para
  seu prompt, ele carrega as instruções completas (`SKILL.md`) e os scripts
  de referência de apoio.

### Repositórios oficiais de skills {:#official-skills-repositories}

* [**flutter/agent-plugins**](https://github.com/flutter/agent-plugins):
  oferece skills para desenvolvimento Flutter, incluindo construção de widgets, navegação
  declarativa, design responsivo e gerenciamento de estado.
* [**dart-lang/skills**](https://github.com/dart-lang/skills): oferece skills
  para desenvolvimento Dart, incluindo criação de testes unitários, resolução de dependências
  e correção de análise estática.

### Garantia de qualidade e lint {:#quality-assurance-and-linting}

Use o [`package:skills_lint`]({{site.pub-pkg}}/skills_lint) para validar
skills existentes no repositório (como as do diretório `.agents/skills/`)
e as package skills publicadas, de acordo com a
[especificação de Agent Skills][agentskills].
O linter verifica o frontmatter YAML do `SKILL.md`, a estrutura de diretórios,
as convenções de nomenclatura e os caminhos relativos de arquivos, para manter suas definições
de skill válidas e prontas para uso pelos assistentes de IA conforme sua base de código evolui.

Para configurar e executar o linter, consulte [Valide e faça lint de skills](
{{site.dart-site}}/tools/pub/package-skills#validate-and-lint-skills).

[agentskills]: https://agentskills.io/specification

---

## Servidor MCP do Dart e do Flutter {:#dart-and-flutter-mcp-server}

O [servidor MCP do Dart e do Flutter](
https://github.com/dart-lang/ai/tree/main/pkgs/dart_mcp_server)
implementa o Model Context Protocol (MCP) aberto, conectando assistentes de IA
às ferramentas ativas do SDK do Dart e do Flutter por entrada e saída padrão (stdio).

Os principais recursos oferecidos pelo servidor MCP incluem:

* **Análise estática e diagnósticos**: inspecione e corrija erros e
  avisos do analisador em todo o seu projeto.
* **Resolução de símbolos**: resolva símbolos para suas definições, assinaturas e
  documentação.
* **Introspecção em tempo de execução**: consulte o estado de um app Flutter em execução
  durante sessões de depuração ativas.
* **Gerenciamento de pacotes**: pesquise no [pub.dev](https://pub.dev) e gerencie
  dependências no `pubspec.yaml`.
* **Testes e formatação**: execute testes unitários e de widget e formate o código usando
  as regras do `dart format`.

---

## Servidor MCP da Developer Knowledge {:#developer-knowledge-mcp-server}

Enquanto o servidor MCP local do Dart e do Flutter foca na análise da base de código local
e na depuração em tempo de execução, você também pode dar ao seu assistente acesso de busca à
documentação oficial online.

O [servidor MCP da Developer Knowledge](
https://developers.google.com/knowledge/mcp)
conecta assistentes de IA ao corpus de documentação para desenvolvedores do Google, incluindo
[docs.flutter.dev](https://docs.flutter.dev),
[dart.dev](https://dart.dev) e as referências oficiais de API. Isso permite que os
assistentes recuperem guias atualizados, notas de migração e referências de API
diretamente durante a conversa.

---

## Package skills

Além das skills principais do Flutter, autores de bibliotecas podem incluir skills oficiais
diretamente dentro de seus pacotes no [pub.dev](https://pub.dev).

Ao adicionar uma dependência ao seu projeto, você pode descobrir e instalar as
skills dela usando a CLI `skills`:

```bash
dart run skills@ get
```

Para aprender a descobrir e instalar package skills, confira
[Package skills]({{site.dart-site}}/ai/package-skills).
Para incluir skills no seu próprio pacote, confira
[Distribua skills com pacotes]({{site.dart-site}}/tools/pub/package-skills).

---

## Agentes especializados {:#specialized-agents}

**Agentes especializados** (chamados de custom agents em plataformas como
o Antigravity) são assistentes de IA configurados com prompts de sistema dedicados,
conjuntos de ferramentas selecionados e subconjuntos de skills focados.

Enquanto as agent skills orientam assistentes de uso geral durante a programação ativa,
os agentes especializados executam fluxos de trabalho profundos e de propósito único em contextos
isolados, sem sobrecarregar o histórico principal da sua conversa.

### Agente de acessibilidade do Flutter {:#flutter-accessibility-agent}

O **agente de acessibilidade do Flutter (`a11y`)** é um agente especializado oficial
projetado para auditar árvores de widgets Flutter e recomendar melhorias de
acessibilidade. O agente de acessibilidade está disponível atualmente no
[Google Antigravity](https://antigravity.google).

Os principais recursos do agente de acessibilidade incluem:

* **Inspeção de rótulos semânticos**: identifica widgets interativos (como
  `IconButton` ou `InkWell`) que não têm rótulos semânticos descritivos.
* **Validação de áreas de toque**: sinaliza elementos interativos com áreas de teste de
  toque menores que os 48x48 pixels lógicos recomendados.
* **Verificações de contraste e visuais**: destaca possíveis problemas de razão de contraste
  e indicadores de foco ausentes.
* **Correções automáticas de código**: gera correções idiomáticas do Flutter (como
  envolver widgets em `Semantics` ou ajustar os limites de toque) que você pode revisar e
  aceitar.

### Usando o agente de acessibilidade no Antigravity {:#using-the-accessibility-agent-in-antigravity}

Após instalar o [plugin oficial do Dart e do Flutter](
https://antigravity.google/docs/build-with-google/#dart-and-flutter)
no Antigravity, você pode invocar o agente de acessibilidade diretamente ao conversar
com o Antigravity, selecionando o **Flutter Accessibility Agent** no
seletor de agentes, mencionando `@flutter_a11y_agent` ou pedindo ao seu assistente que
revise seu código quanto à acessibilidade:

```text
@flutter_a11y_agent Audit this screen for accessibility issues.
```

---

## Regras de agente {:#agent-rules}

**Regras de agente** são regras persistentes adicionadas à janela de contexto
toda vez que você inicia uma nova sessão com seu assistente.
As regras estabelecem convenções do projeto e restrições comuns
em toda a sua base de código.

Para explorar as regras oficiais do Flutter, visite o
[diretório de regras](https://github.com/flutter/agent-plugins/tree/main/rules)
no repositório flutter/agent-plugins.

---

## Quando usar cada uma {:#when-to-use-what}

Use o modelo mental a seguir para entender como os diferentes mecanismos de IA
interagem:

| Mecanismo | Escopo e comportamento | Ideal para |
| :--- | :--- | :--- |
| **Agent skill** | Sob demanda | Receitas de múltiplos passos, padrões |
| **Dart MCP server** | Ferramentas locais do SDK | Diagnósticos, testes, tempo de execução |
| **Developer Knowledge MCP** | Busca online | Documentação ao vivo, referências de API |
| **Package skill** | Vindo de dependências | APIs de bibliotecas, geração de código |
| **Agente especializado** | Subagente isolado | Auditorias de acessibilidade |
| **Regra de agente** | Contexto persistente | Convenções e restrições do projeto |

{:.table .table-striped}

## Próximos passos {:#next-steps}

* Siga o guia [Comece a usar IA com o Flutter](/ai/get-started) para instalar os
  plugins oficiais no seu editor.
* Aprenda a instalar skills com
  [Package skills]({{site.dart-site}}/ai/package-skills).
* Aprenda a distribuir skills com
  [Distribua skills com pacotes]({{site.dart-site}}/tools/pub/package-skills).
