---
ia-translate: true
title: Prompts
description: >
  Aprenda a criar e otimizar prompts de IA generativa no Flutter usando instruções
  de sistema, parâmetros dinâmicos e técnicas de versionamento.
prev:
  title: Melhores práticas de IA no Flutter
  path: /ai/best-practices
next:
  title: Estrutura e saída
  path: /ai/best-practices/structure-output
---


Partindo do pressuposto de que você configurou seu app Flutter com o projeto e a
configuração do Firebase necessários para usar o SDK Firebase AI Logic (sobre o qual você pode
saber mais [no README][crossword-readme]), você está pronto para começar a usar
IA generativa. IA generativa é o ramo do Machine Learning (ML) que usa uma rede neural treinada
em um grande conjunto de linguagem humana para produzir um Large
Language Model (LLM). Atualmente, os melhores modelos (como o Google Gemini) são
treinados com, essencialmente, a internet inteira.

Nessa escala, um modelo treinado com tantos dados criou modelos capazes de
interpretar a linguagem humana e produzir saídas úteis em linguagem humana. Com certeza
você já usou [o app de chat do Gemini][gemini-app] (ou ChatGPT, Claude ou
outros apps de chat), então sabe que, se você conversar com um LLM usando linguagem vaga,
é provável que receba resultados vagos e, muitas vezes, incorretos. Se quiser
bons resultados, precisará usar bons prompts.

### Construção de prompts {:#prompt-construction}

Um prompt é a entrada que você fornece a um LLM para obter a saída desejada. Ele
inclui texto e, opcionalmente, arquivos, como imagens ou PDFs. Se você estiver
implementando um chat no seu app, o usuário digitará os prompts (e
o [Flutter AI Toolkit][ai-toolkit] é útil para criar a UI do chat). Se
você usar um LLM para implementar os recursos do seu app, como analisar uma imagem
para extrair dados de palavras cruzadas, então você mesmo vai criar os prompts.
A forma como você os constrói importa.

Como exemplo, ao criar o Crossword Companion, o prompt original para resolver pistas tinha esta aparência:

```dart
You are a crossword puzzle solver. Your goal is to solve the puzzle by filling in the grid with the correct answers. Given the current state of the crossword grid and a single clue, provide the answer for that clue. The answer should be a single word, returned in a JSON object that matches the following schema: '{"type": "object", "properties": {"answer": {"type": "string"}}}'.

# Puzzle Information
## Grid Layout
The grid is (${grid.width}x${grid.height}):
${_getGridStateAsString(grid)}

## Clue
${clue.number} ${clue.direction == ClueDirection.across ? 'Across' : 'Down'}: ${clue.text}
```

Esse prompt não é de todo ruim: ele tem algumas partes úteis:

- **Persona:** a frase "You are a crossword puzzle solver" direciona o
  foco do modelo  
- **Contexto:** o estado atual do quebra-cabeça  
- **Consulta:** pedido de solução para uma pista  
- **Formato:** a saída em JSON para que o resultado possa ser processado
  programaticamente

No entanto, por causa da natureza bidimensional dos dados, este é um prompt difícil de
resolver para alguns modelos. Os resultados do Gemini 2.5 Flash (o mais
eficiente entre os modelos disponíveis na época) foram inconsistentes. A qualidade dos
resultados do Gemini 2.5 Pro foi excelente, mas eram mais lentos e mais
caros de obter. A depuração revelou que o Pro estava, essencialmente, resolvendo o
quebra-cabeça inteiro a cada chamada, respondendo apenas com a solução de
uma pista.

O necessário era a eficiência do Flash com a qualidade do Pro. Para isso,
foi preciso trabalhar no prompt:

```markdown
Your task is to solve the following crossword clue.

**Clue:** "${clue.text}"

**Constraints:**
- The answer is a **$length-letter** word.
- The current letter pattern is `$pattern`, where `_` represents an unknown letter.

Return your answer and confidence score in the required JSON format.
```

Esse prompt pede para resolver a pista, fornece o contexto importante
e especifica o formato de saída. Em vez de passar o estado inteiro da
grade bidimensional, a entrada foi reduzida ao requisito de tamanho e a um padrão,
como "_ R _ Y". Essas simplificações produzem resultados de alta qualidade
do Flash, que voltam rápido o suficiente para tornar [divertido de
acompanhar][crossword-demo].  
<img
src="/assets/images/docs/ai-best-practices/crossword-companion-interface-showing-a.png"
alt="Interface do Crossword Companion mostrando uma grade parcialmente resolvida e pistas
com respostas geradas por IA e pontuações de confiança">

### Camadas de prompts {:#layering-your-prompts}

O prompt usado para resolver as pistas não é o único que o modelo vê. Ele
também recebe a instrução de sistema (também conhecida como mensagem de sistema ou prompt de sistema),
definida na criação da instância do modelo. Pense na instrução de sistema como "isto é o que você faz", enquanto
os prompts individuais são "agora faça isto".

Aqui está a instrução de sistema parcial do modelo que resolve pistas (você verá o
restante mais adiante):

```dart
final clueSolverSystemInstruction =
'''
You are an expert crossword puzzle solver.

**Follow these rules at all times:**
1.  **Prefer Common Words:** Prioritize common English words and proper nouns. Avoid obscure, archaic, or highly technical terms unless the clue strongly implies them.
2.  **Match the Clue:** Ensure your answer strictly matches the clue's tense, plurality (singular vs. plural), and part of speech.
3.  **Verify Grammatically:** If a clue implies a specific part of speech (e.g., it's a verb, adverb, or plural), it's a good idea to use the `getWordMetadata` tool to verify your candidate answer matches. However, avoid using it for every clue.
4.  **Be Confident:** Provide a confidence score from 0.0 to 1.0 indicating your certainty.
5.  **Trust the Clue Over the Pattern:** The provided letter pattern is only a suggestion based on other potentially incorrect answers. Your primary goal is to find the best word that fits the **clue text**. If you are confident in an answer that contradicts the provided pattern, you should use that answer.
6.  **Format Correctly:** You must return your answer in the specified JSON format.
...
''';

```

Com o modelo que queremos usar e a instrução de sistema, agora temos
tudo o que precisamos para criar uma instância:

```dart
// The model for solving clues.
_clueSolverModel = FirebaseAI.googleAI().generativeModel(
  model: 'gemini-2.5-flash',
  systemInstruction: Content.text(clueSolverSystemInstruction),
  ...
);
```

Enquanto a instrução de sistema costuma ser estática, os prompts individuais geralmente são
criados dinamicamente com base nos dados.

### Parametrizando seus prompts {:#parameterizing-your-prompts}

Cada prompt do resolvedor de pistas é criado com o texto da pista, o tamanho alvo
da resposta e o padrão até o momento, com base nas pistas já resolvidas anteriormente, como
"_R_Y":

```dart
String getSolverPrompt(Clue clue, int length, String pattern) =>
'''
Your task is to solve the following crossword clue.

**Clue:** "${clue.text}"

**Constraints:**
- The answer is a **$length-letter** word.
- The current letter pattern is `$pattern`, where `_` represents an unknown letter.

Return your answer and confidence score in the required JSON format.
''';
```

Com o prompt em mãos, podemos enviá-lo ao modelo para obter a resposta da pista:

```dart
final result = await _clueSolverModel.generateContent(
  prompt: getSolverPrompt(clue, length, pattern),
);
```

### Versionamento de prompts {:#prompt-versioning}

Este app básico mantém as strings de prompt no código.
Isso dificulta encontrá-las e atualizá-las.
Em apps de produção, é melhor manter os prompts separados do código,
talvez empacotados como assets do Flutter.
Uma forma de organizar os arquivos de prompt é
usar [o formato dotprompt do Google][dotprompt],
que permite escrever arquivos `.prompt` como este:

```markdown
---
model: googleai/gemini-2.5-flash
input:
  schema:
    text: string
output:
  format: json
  schema:
    title?: string, the title of the article if it has one
    summary: string, a 3-sentence summary of the text
    tags?(array, a list of string tag category for the text): string
---

Extract the requested information from the given text. If a piece of information is not present, omit that field from the output.

Text: {{text}}
```

Para expandir um arquivo `.prompt` para uso em seus projetos Dart e Flutter, você pode
usar [o pacote dotprompt_dart][dotprompt-dart].



[crossword-readme]: {{site.repo.demos}}/tree/main/crossword_companion
[gemini-app]: https://gemini.google.com/app
[ai-toolkit]: /ai-toolkit
[crossword-demo]: {{site.repo.demos}}/raw/refs/heads/main/crossword_companion/readme/screen-recording.mov
[dotprompt]: https://google.github.io/dotprompt/getting-started/
[dotprompt-dart]: {{site.pub-pkg}}/dotprompt_dart
