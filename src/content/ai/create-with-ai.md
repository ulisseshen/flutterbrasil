---
ia-translate: true
title: Criar com IA
description: >
  Aprenda como usar IA para construir apps Flutter, desde SDKs poderosos que integram
  recursos de IA diretamente em seu app até ferramentas que aceleram seu fluxo de
  trabalho de desenvolvimento.
---

Este guia aborda como você pode aproveitar ferramentas de IA para construir recursos alimentados por IA para
seus apps Flutter e otimizar seu desenvolvimento Flutter e Dart.

## Visão geral

IA pode ser usada para construir apps alimentados por IA com Flutter e para acelerar
seu fluxo de trabalho de desenvolvimento. Você pode integrar recursos alimentados por IA como compreensão de
linguagem natural e geração de conteúdo diretamente em seu app Flutter
usando SDKs poderosos, como o Firebase SDK for Generative AI. Você também pode usar
ferramentas de IA, como Gemini Code Assist e Gemini CLI, para ajudar com geração
e estruturação de código. Essas ferramentas são alimentadas pelo Dart e Flutter MCP
Server, que fornece à IA um contexto rico sobre sua base de código. A
Extension para Gemini CLI do Flutter facilita o aproveitamento de regras oficiais, do servidor MCP,
e comandos personalizados para construir seu app. Além disso, arquivos de regras ajudam a
ajustar o comportamento da IA e impor melhores práticas específicas do projeto.

## Construir experiências alimentadas por IA com Flutter

Usar IA em seu app Flutter desbloqueia novas experiências de usuário que permitem que seu app
suporte compreensão de linguagem natural e geração de conteúdo.

Para começar a construir experiências alimentadas por IA no Flutter, confira estes
recursos:

* [Firebase AI Logic][] - O SDK oficial do Firebase para usar recursos de IA generativa
  diretamente no Flutter. Compatível com a Gemini Developer API ou
  Vertex AI. Para começar, confira a
  [documentação oficial][firebase-ai-logic-docs].
* [Flutter AI Toolkit][] - Um app de exemplo com widgets pré-construídos para ajudá-lo a construir
  recursos alimentados por IA no Flutter

[Firebase AI Logic]: {{site.firebase}}/docs/ai-logic
[firebase-ai-logic-docs]: {{site.firebase}}/docs/ai-logic/get-started
[Flutter AI Toolkit]: {{site.url}}/ai-toolkit

## Ferramentas de desenvolvimento de IA

IA não é apenas um recurso em seu app, mas também pode ser um assistente poderoso em
seu fluxo de trabalho de desenvolvimento.  Ferramentas como [Gemini Code
Assist](#gemini-code-assist), [Gemini CLI](#gemini-cli), [Claude Code][],
[Cursor][], e [Windsurf][] podem ajudá-lo a escrever código mais rápido, entender conceitos
complexos e reduzir código repetitivo.

[Claude Code]: https://www.claude.com/product/claude-code
[Cursor]: https://cursor.com/
[Windsurf]: https://windsurf.com/

### Gemini Code Assist

[Gemini Code Assist][] é um colaborador alimentado por IA disponível no Visual Studio
Code e IDEs JetBrains (incluindo Android Studio).  Ele tem uma compreensão profunda
da base de código do seu projeto e pode ajudá-lo com:

* **Conclusão e geração de código**: Ele sugere e gera blocos inteiros de
  código baseado no contexto do que você está escrevendo.
* **Chat no editor**: Você pode fazer perguntas sobre seu código, conceitos do Flutter,
  ou melhores práticas diretamente dentro de sua IDE.
* **Depuração e explicação**: Se você encontrar um erro, pode pedir ao Gemini
  Code Assist para explicá-lo e sugerir uma correção, e
  [Dart and Flutter MCP Server][dart-mcp-flutter-docs]

[Gemini Code Assist]: https://codeassist.google/

### Gemini CLI

O [Gemini CLI][] é uma ferramenta de fluxo de trabalho de IA de linha de comando. Ele permite que você interaja
com modelos Gemini para uma variedade de tarefas sem sair de seu ambiente de
desenvolvimento. Você pode usá-lo para:

* Estruturar rapidamente um novo widget Flutter, função Dart ou um app completo.
* Usar ferramentas de servidor MCP, como o servidor MCP Dart e Flutter
* Automatizar tarefas como fazer commit e push de mudanças para um repositório Git

Para começar, visite o site [Gemini CLI][], ou experimente este
[codelab do Gemini CLI][].

[Gemini CLI]: https://geminicli.com/
[Gemini CLI codelab]: https://codelabs.developers.google.com/gemini-cli-hands-on

## Extension para Gemini CLI do Flutter

A [Extension para Gemini CLI do Flutter][flutter-extension] combina o [Dart and
Flutter MCP Server][dart-mcp-dart-docs] com regras e comandos. Ela usa o
conjunto padrão de [AI rules for Flutter and Dart][], adiciona comandos como
`/create-app` e `/modify` para fazer mudanças estruturadas em seu app, e
configura automaticamente o [Dart and Flutter MCP Server][dart-mcp-dart-docs].

Você pode instalá-la executando o seguinte comando:

```bash
gemini extensions install https://github.com/gemini-cli-extensions/flutter
```

Para saber mais, consulte o [post do blog][flutter-extension-blog] ou
o [README][flutter-extension].

[flutter-extension]: {{site.github}}/gemini-cli-extensions/flutter
[flutter-extension-blog]: https://blog.flutter.dev/meet-the-flutter-extension-for-gemini-cli-f8be3643eaad

## Dart and Flutter MCP Server

Para fornecer assistência durante o desenvolvimento Flutter, ferramentas de IA
precisam se comunicar com as ferramentas de desenvolvedor do Dart e Flutter.
O Dart and Flutter MCP Server facilita essa comunicação.
A especificação MCP (model context protocol) define como
ferramentas de desenvolvimento podem compartilhar o contexto do código de um usuário com um modelo de IA,
o que permite que a IA entenda melhor e interaja com o código.

O servidor MCP Dart e Flutter fornece uma lista crescente de ferramentas para analisar
e corrigir erros, hot reload, obter o widget selecionado e mais.
Isso preenche a lacuna entre a compreensão de linguagem natural da IA,
e o conjunto de ferramentas de desenvolvedor do Dart e Flutter.

Para começar, confira a documentação oficial para o
[servidor MCP Dart e Flutter][dart-mcp-dart-docs]
em dart.dev e o [repositório MCP Dart e Flutter][dart-mcp-github].

[dart-mcp-dart-docs]: {{site.dart-site}}/tools/mcp-server
[dart-mcp-github]: {{site.github}}/dart-lang/ai/tree/main/pkgs/dart_mcp_server
[dart-mcp-flutter-docs]: #dart-and-flutter-mcp-server

## Regras para Flutter e Dart

Você pode usar um arquivo de regras com editores alimentados por IA para fornecer
contexto e instruções a um LLM subjacente. Para começar,
consulte o guia [AI rules for Flutter and Dart][].

[AI rules for Flutter and Dart]: /ai/ai-rules
