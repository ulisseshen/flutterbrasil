---
ia-translate: true
title: Melhores práticas de IA no Flutter
shortTitle: Melhores práticas de IA
breadcrumb: Melhores práticas
description: >
  Aprenda as melhores práticas para criar apps Flutter com IA, usando guardrails para verificar e corrigir dados gerados por IA.
next:
  title: Prompts
  path: /ai/best-practices/prompting
---


O Flutter e a IA combinam muito bem em vários níveis. Se você usa IA para
gerar código Flutter, precisa gerar o código de um único app para atingir
várias plataformas. E se você usa o Gemini para implementar funcionalidades no
seu app, o Firebase AI Logic SDK torna isso simples, com uma API fácil de usar
e segura, pois mantém as chaves de API fora do seu código.

Se você é novo no uso de IA em qualquer um desses dois casos, saiba: por melhor
que ela seja (e o Gemini 3 Pro Preview é *muito* bom), a IA ainda comete erros.
Se você usa IA para escrever seu código, pode usar guardrails para mantê-la nos
trilhos, como o analyzer do Flutter, testes unitários e o
[`skills_lint`](/ai/tools#quality-assurance-and-linting) para skills de agentes.

Mas o que fazer quando você usa IA para implementar as funcionalidades do seu
app, sabendo que às vezes ela vai errar? Ou, para citar um amigo meu:

***Lei de Morgan***  
*"Eventualmente, devido à natureza da amostragem de uma distribuição de
probabilidade, [a IA] vai falhar em fazer o que precisa ser feito."*  
*–Brett Morgan, Engenheiro de Relações com Desenvolvedores do Flutter, julho de 2025\.*

A boa notícia é que, assim como você pode usar ferramentas de desenvolvimento
para criar guardrails em volta da IA que escreve seu código, você pode usar o
Flutter para criar guardrails em volta da IA que usa para implementar suas
funcionalidades. O [app Crossword Companion][crossword-app] foi criado para
demonstrar essas técnicas.  
<img
src="/assets/images/docs/ai-best-practices/crossword-companion-app-interface-showin.png"
alt="Crossword Companion app interface showing a 5-step setup process starting
with selecting a crossword image.">  
O objetivo do app Crossword Companion não é ajudar você a trapacear nas
mini palavras cruzadas – embora ele seja muito bom nisso – mas ilustrar como
canalizar o poder da IA usando Flutter. Por exemplo, a primeira coisa que você
faz ao executar o app é enviar a captura de tela de um quebra-cabeça de mini
palavras cruzadas. Quando você pressiona o botão **Next**, a IA usa essa
imagem para inferir o tamanho, o conteúdo e as dicas do quebra-cabeça:  
<img
src="/assets/images/docs/ai-best-practices/crossword-companion-app-showing-a-5x5-gr.png"
alt="Crossword Companion app showing a 5x5 grid with settings incorrectly
displaying 4 rows and 5 columns.">  
Repare que, embora o quebra-cabeça seja uma grade 5x5, a IA diz que é 4x5.
Como sabemos que erros acontecem (aparentemente as IAs também são humanas),
construímos o app para permitir que o usuário verifique e corrija os dados
gerados pela IA. Isso é importante; dados ruins levam a resultados ruins.

Então, este texto não trata do app em detalhes, mas sim das melhores práticas
para usar ao construir seus próprios apps de IA com Flutter. Vamos lá!


[crossword-app]: {{site.repo.demos}}/tree/main/crossword_companion
