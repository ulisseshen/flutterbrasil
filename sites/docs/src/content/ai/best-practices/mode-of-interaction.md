---
ia-translate: true
title: Modo de interação
description: >
  Aprenda a equilibrar as capacidades de LLMs com código tradicional e a
  implementar barreiras de proteção (guardrails) para gerenciar o comportamento
  não determinístico da IA.
prev:
  title: Chamadas de ferramentas (também conhecidas como chamadas de função)
  path: /ai/best-practices/tool-calls
next:
  title: Experiência do desenvolvedor
  path: /ai/best-practices/developer-experience
---


É um erro pensar em uma requisição a um LLM da mesma forma que uma chamada de
função. Dado o mesmo conjunto de entradas na mesma ordem, uma função se comporta
de forma previsível. Podemos escrever testes, injetar falhas e tornar uma função
robusta para uma grande variedade de entradas.

Um LLM não é assim. Uma forma melhor de pensar é imaginar que o LLM é um
usuário e tratar os dados que recebemos dele como tais. Assim como um usuário, um
LLM é não determinístico, frequentemente errado (parcial ou totalmente) e, às
vezes, simplesmente aleatório.
Para proteger nossos apps nessas condições, precisamos construir as mesmas
barreiras de proteção em torno da entrada do LLM que construímos em torno da
entrada do usuário.

Se conseguirmos fazer isso com sucesso, poderemos trazer habilidades
extraordinárias para os apps, na forma de resolução de problemas e criatividade
que podem rivalizar com as de um ser humano.

### Separação de responsabilidades {:#separation-of-concerns}

LLMs são bons em algumas coisas e ruins em outras; o segredo é trazê-los para
seus apps pelo que fazem de bom, mitigando o que fazem de ruim. Como exemplo,
vamos considerar a lista de tarefas do Crossword Companion:

<img
src="/assets/images/docs/ai-best-practices/crossword-task-list-showing-solved-clues.png"
alt="Lista de tarefas do Crossword Companion mostrando pistas resolvidas em verde
com porcentagens de confiança, e pistas não resolvidas em vermelho">

A lista de tarefas é o conjunto de pistas que precisam ser resolvidas. O objetivo
é usar as cores e as soluções na lista de tarefas para mostrar o progresso durante
o processo de resolução. A implementação inicial deu ao modelo uma ferramenta para
gerenciar a lista de tarefas, pedindo que ele fornecesse atualizações de progresso
conforme avançava. O Flash não conseguiu resolver o quebra-cabeça dessa forma, mas
o Pro conseguiu. Infelizmente, ele resolveu em grandes blocos, lembrando-se de
atualizar a lista de tarefas apenas uma ou duas vezes, com um grande atraso entre
elas. Nenhuma quantidade de prompts conseguiu convencê-lo a atualizar as tarefas
conforme avançava. Você verá o mesmo comportamento com agentes de IA modernos que
gerenciam suas próprias listas de tarefas; é simplesmente onde estamos na evolução
dos LLMs no momento.

Então, como obtemos atualizações consistentes e determinísticas da lista de
tarefas? Tire o gerenciamento de tarefas das mãos do LLM e trate-o no código.

Para generalizar, antes de aplicar uma solução de LLM a um problema que você
enfrenta, pergunte a si mesmo se um LLM é a melhor ferramenta para o trabalho.
A resolução de problemas e a criatividade semelhantes às humanas valem a troca
pela imprevisibilidade?

A resposta a essa pergunta vem com experimentação. Aqui estão alguns exemplos
do app de exemplo:

| Tarefa                                            | Adequação para LLM                                           | Adequação para código                                                             |
| ------------------------------------------------- | ------------------------------------------------------------ | --------------------------------------------------------------------------------- |
| **Analisar a grade para tamanho, conteúdo e pistas** | Excelente para um LLM, usando visão e compreensão de linguagem | Difícil escrever o código para isso                                              |
| **Validar o conteúdo da grade**                   | Possível fazer com outro LLM verificando o trabalho          | Mais fácil para um humano dar uma olhada e ajustar                                |
| **Gerenciar a lista de tarefas**                  | Um LLM dificilmente fará isso de forma consistente           | Fácil escrever o código para percorrer uma lista de tarefas, atualizando-a conforme avança |
| **Resolver cada pista**                           | Excelente para um LLM, usando compreensão e geração de linguagem | Difícil, dado que pistas do mundo real dependem de trocadilhos, nomes e gírias |
| **Resolver conflitos**                            | Um LLM é inconsistente nesse tipo de iteração                | Fácil para um humano dar uma olhada e ajustar                                     |

É uma questão de julgamento, com certeza, mas se você consegue razoavelmente
escrever o código para fazer isso, seus resultados serão previsíveis. Porém, se
escrever o código fosse excessivamente difícil, considere um LLM, sabendo que
você precisará construir as barreiras de proteção como fizemos no exemplo.

### Modos ask e agent {:#ask-vs-agent}

Há mais do que um eixo a considerar além de código versus LLM. Os modelos operam
em aproximadamente dois modos: "ask" e "agent".

Um LLM está no modo "ask" quando o acionamos sem dar a ele ferramentas para
provocar mudanças no mundo, por exemplo, sem ferramenta alguma ou apenas com
ferramentas para consultar dados. Tanto o modelo que interpreta a grade de palavras
cruzadas quanto os modelos de resolução de pistas rodam no modo ask, usando
ferramentas apenas para dados adicionais.

Por outro lado, quando damos a um LLM um conjunto de ferramentas que lhe permitem
operar em nosso nome no mundo, como ler e escrever arquivos, executar comandos
bash, carregar páginas web, chamar APIs web e assim por diante, esse LLM está no
modo "agent".

### Barreiras de proteção (guardrails) {:#guardrails}

A diferença entre os modos ask e agent não está no modelo que você escolhe nem nos
prompts que você fornece, mas nas ferramentas que você disponibiliza. A combinação
das ferramentas com o loop agêntico descrito na seção de chamadas de ferramentas
permite que um LLM chame quantas dessas ferramentas quiser, quantas vezes decidir.
Dar esse poder a ele coloca sobre você a responsabilidade de tratá-lo como
imprevisível, mais como uma pessoa do que como um programa.

Você faz isso da mesma forma que valida a entrada do usuário: construindo um
conjunto de testes para ver como seu app funciona diante das respostas do LLM.
Dê a LLMs reais uma grande variedade de prompts e simule as ferramentas para avaliar
como o LLM as está usando. Assim como a sua primeira experiência de teste com
usuários, seus primeiros resultados de teste com LLMs podem surpreendê-lo. Use
esses dados para construir as barreiras de proteção de que você precisa para
tornar seu app mais robusto.

No exemplo, não precisamos nos proteger contra danos, mas precisamos nos proteger
contra resultados imperfeitos. Foram os testes extensivos com dados do mundo real
que levaram à implementação de proteções com humano no loop contra tentativas de
resolver um quebra-cabeça inválido ou soluções conflitantes. Dessa forma, Flutter
e Firebase AI Logic formam a combinação perfeita para aproveitar o poder de um LLM
e trazer capacidades únicas para seus apps.
