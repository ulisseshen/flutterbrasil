---
ia-translate: true
title: Regras de IA para Flutter e Dart
description: >
  Aprenda como adicionar regras de IA a ferramentas que aceleram seu
  fluxo de trabalho de desenvolvimento.
---

Este guia aborda como você pode aproveitar regras de IA para
otimizar seu desenvolvimento Flutter e Dart.

## Visão geral

Editores alimentados por IA usam arquivos de regras para fornecer contexto e
instruções a um LLM subjacente. Esses arquivos ajudam você a:

*   Personalizar o comportamento da IA para as necessidades da sua equipe.
*   Impor melhores práticas do projeto para estilo de código e
    design.
*   Fornecer contexto crítico do projeto à IA.

<a class="filled-button" style="margin-bottom: 0.5rem;" href="https://raw.githubusercontent.com/flutter/flutter/refs/heads/master/docs/rules/rules.md" download>
  <span aria-hidden="true" class="material-symbols" translate="no">download</span>
  <span>Baixar o template de regras Flutter e Dart</span>
</a>

## Ambientes que suportam regras

Muitos ambientes de IA suportam arquivos de regras para guiar
o comportamento do LLM. Aqui estão alguns exemplos comuns e seus
nomes de arquivo de regras correspondentes:

| Ambiente | Arquivo de Regras | Instruções de Instalação                     |
| :--- | :--- |:----------------------------------------------|
| IDEs com Copilot | `copilot-instructions.md` | [Configure .github/copilot-instructions.md][] |
| Cursor | `cursor.md` | [Configure cursorrules.md][]                  |
| Firebase Studio | `airules.md` | [Configure airules.md][]                      |
| Gemini CLI | `GEMINI.md` | [Configure GEMINI.md][]                       |
| IDEs JetBrains | `guidelines.md` | [Configure guidelines.md][]                   |
| VS Code | `.instructions.md` | [Configure .instructions.md][]                |
| Windsurf | `guidelines.md` | [Configure guidelines.md][]                   |

[Configure airules.md]: https://firebase.google.com/docs/studio/set-up-gemini#custom-instructions
[Configure .github/copilot-instructions.md]: https://code.visualstudio.com/docs/copilot/copilot-customization#_custom-instructions
[Configure cursorrules.md]: https://docs.cursor.com/en/context/rules
[Configure guidelines.md]: https://www.jetbrains.com/help/junie/customize-guidelines.html
[Configure .instructions.md]: https://code.visualstudio.com/docs/copilot/copilot-customization#_custom-instructions
[Configure guidelines.md]: https://docs.windsurf.com/windsurf/cascade/memories#rules
[Configure GEMINI.md]: https://codelabs.developers.google.com/gemini-cli-hands-on

## Criar regras para seu editor

Você pode adaptar nosso template de regras Flutter e Dart para seu
ambiente específico. Para fazer isso, siga estes passos:

1.  Baixe o template de regras Flutter e Dart:
    <a href="https://raw.githubusercontent.com/flutter/flutter/refs/heads/master/docs/rules/rules.md" download>rules.md</a>

1.  Em um LLM como [Gemini][], anexe o
    arquivo `rules.md` que você baixou no
    último passo.

1.  Forneça um prompt para reformatar o arquivo para seu editor
    desejado.

    Exemplo de prompt:

    ```text
    Convert the attached rules.md file
    into a guidelines.md file for Gemini CLI. Make sure
    to use the styles required for a guidelines.md file.
    ```

1.  Revise a saída do LLM e faça quaisquer ajustes
    necessários.

1.  Siga as instruções do seu ambiente para adicionar o novo
    arquivo de regras. Isso pode envolver adicionar a um arquivo existente
    ou criar um novo.

1.  Verifique se seu assistente de IA está usando as novas regras para
    guiar suas respostas.

[Gemini]: https://gemini.google.com/
