---
title: Mais reflexôes sobre desempenho
description: O que é desempenho e por que o desempenho é importante
ia-translate: true
---
## O que é performance?

Performance é um conjunto de propriedades quantificáveis de um executor.

Neste contexto, performance não é a execução de uma ação em si; é o quão bem algo
ou alguém desempenha. Portanto, usamos o adjetivo _performático_.

Embora a parte do _quão bem_ possa, em geral, ser descrita em linguagens naturais,
em nosso escopo limitado, o foco é em algo que é quantificável como um número real.
Números reais incluem inteiros e binários 0/1 como casos especiais. Descrições em
linguagem natural ainda são muito importantes. Por exemplo, um artigo de notícias
que critica fortemente a performance do Flutter usando apenas palavras sem nenhum
número (um valor quantificável) ainda pode ser significativo, e pode ter grandes
impactos. O escopo limitado é escolhido apenas por causa de nossos recursos
limitados.

A quantidade necessária para descrever a performance é frequentemente referida como
uma métrica.

Para navegar por inúmeras questões e métricas de performance, você pode categorizar
com base nos executores.

Por exemplo, a maior parte do conteúdo neste site é sobre a performance de
aplicativos Flutter, onde o executor é um aplicativo Flutter. A performance da
infraestrutura também é importante para o Flutter, onde os executores são bots de
construção e executores de tarefas de CI: eles afetam muito a rapidez com que o
Flutter pode incorporar mudanças de código, para melhorar a performance do
aplicativo.

Aqui, o escopo foi intencionalmente ampliado para incluir questões de performance
além de apenas questões de performance de aplicativos, porque elas podem compartilhar
muitas ferramentas, independentemente de quem sejam os executores. Por exemplo, a
performance de aplicativos Flutter e a performance de infraestrutura podem
compartilhar o mesmo painel e mecanismos de alerta semelhantes.

Ampliar o escopo também permite que executores sejam incluídos que tradicionalmente
são fáceis de ignorar. A performance de documentos é um exemplo. O executor pode
ser um documento de API do SDK, e uma métrica pode ser: a porcentagem de leitores
que acham o documento de API útil.

## Por que a performance é importante?

Responder a essa pergunta não é apenas crucial para validar o trabalho em
performance, mas também para guiar o trabalho de performance para que seja mais
útil. A resposta para "por que a performance é importante?" muitas vezes também é a
resposta para "como a performance é útil?"

Simplificando, a performance é importante e útil porque, dentro do escopo, a
performance deve ter propriedades ou métricas quantificáveis. Isso implica:
1. Um relatório de performance é fácil de consumir.
2. A performance tem pouca ambiguidade.
3. A performance é comparável e conversível.
4. A performance é justa.

Não que questões ou descrições não relacionadas à performance ou não mensuráveis
não sejam importantes. Elas servem para destacar os cenários em que a performance
pode ser mais útil.

### 1. Um relatório de performance é fácil de consumir

Métricas de performance são números. Ler um número é muito mais fácil do que ler
uma passagem. Por exemplo, provavelmente leva 1 segundo para um engenheiro consumir
a avaliação de performance como um número de 1 a 5. Provavelmente leva o mesmo
engenheiro pelo menos 1 minuto para ler o resumo completo de feedback de 500
palavras.

Se houver muitos números, é fácil resumi-los ou visualizá-los para um consumo
rápido. Por exemplo, você pode consumir rapidamente milhões de números olhando para
seu histograma, média, quantis e assim por diante. Se uma métrica tiver um
histórico de milhares de pontos de dados, então você pode facilmente plotar uma
linha do tempo para ler sua tendência.

Por outro lado, ter _n_ número de textos de 500 palavras quase garante um custo _n_
vezes maior para consumir esses textos. Seria uma tarefa assustadora analisar
milhares de descrições históricas, cada uma com 500 palavras.

### 2. A performance tem pouca ambiguidade

Outra vantagem de ter a performance como um conjunto de números é sua não
ambiguidade. Quando você quer que uma animação tenha uma performance de 20 ms por
quadro ou 50 fps, há pouco espaço para diferentes interpretações sobre os números.
Por outro lado, para descrever a mesma animação em palavras, alguém pode chamá-la de
boa, enquanto outra pessoa pode reclamar que é ruim. Da mesma forma, a mesma palavra
ou frase pode ser interpretada de forma diferente por pessoas diferentes. Você pode
interpretar uma taxa de quadros OK como 60 fps, enquanto outra pessoa pode
interpretá-la como 30 fps.

Os números ainda podem ser ruidosos. Por exemplo, o tempo medido por quadro pode ser
um tempo de computação verdadeiro deste quadro, mais uma quantidade aleatória de tempo
(ruído) que a CPU/GPU gasta em algum trabalho não relacionado. Portanto, a métrica
flutua. No entanto, não há ambiguidade sobre o que o número significa. E, também
existem teorias e ferramentas de teste rigorosas para lidar com esse ruído. Por
exemplo, você pode fazer várias medições para estimar a distribuição de uma
variável aleatória, ou você pode obter a média de muitas medições para eliminar o
ruído pela [lei dos grandes números][1].

### 3. A performance é comparável e conversível

Números de performance não apenas têm significados não ambíguos, mas também têm
comparações não ambíguas. Por exemplo, não há dúvida de que 5 é maior que 4. Por
outro lado, pode ser subjetivo descobrir se excelente é melhor ou pior do que
ótimo. Da mesma forma, você poderia descobrir se épico é melhor do que
lendário? Na verdade, a frase _supera fortemente as expectativas_ poderia ser melhor
do que _excelente_ na interpretação de alguém. Só se torna não ambíguo e comparável
após uma definição que mapeia supera fortemente as expectativas para 4 e excelente
para 5.

Números também são facilmente conversíveis usando fórmulas e funções. Por exemplo,
60 fps podem ser convertidos em 16,67 ms por quadro. O tempo de renderização de um
quadro _x_ (ms) pode ser convertido para um indicador binário `isSmooth = [x <= 16] =
(x <= 16 ? 1 :0)`. Tal conversão pode ser composta ou encadeada, então você pode
obter uma grande variedade de quantidades usando uma única medição sem nenhum ruído
ou ambiguidade adicionada. A quantidade convertida pode então ser usada para
comparações e consumo adicionais. Tais conversões são quase impossíveis se você
estiver lidando com linguagens naturais.

### 4. A performance é justa

Se as questões dependem de palavras verbosas para serem descobertas, então uma
vantagem injusta é dada às pessoas que são mais verbosas (mais dispostas a conversar
ou escrever) ou àquelas que estão mais próximas da equipe de desenvolvimento, que
têm uma largura de banda maior e menor custo para conversas ou reuniões presenciais.

Ao ter as mesmas métricas para detectar problemas, não importa o quão longe ou quão
silenciosos os usuários estejam, podemos tratar todas as questões de forma justa.
Isso, por sua vez, nos permite focar nas questões certas que têm maior impacto.

### Como tornar a performance útil

O seguinte resume os 4 pontos discutidos aqui, de uma perspectiva ligeiramente
diferente:
1. Torne as métricas de performance fáceis de consumir. Não sobrecarregue os
   leitores com muitos números (ou palavras). Se houver muitos números, então
   tente resumi-los em um conjunto menor de números (por exemplo, resuma muitos
   números em um único número médio). Notifique os leitores apenas quando os
   números mudarem significativamente (por exemplo, alertas automáticos em picos
   ou regressões).

2. Torne as métricas de performance o mais não ambíguas possível. Defina a unidade
   que o número está usando. Descreva precisamente como o número é medido. Torne o
   número facilmente reproduzível. Quando houver muito ruído, tente mostrar a
   distribuição completa ou eliminar o ruído o máximo possível, agregando muitas
   medições ruidosas.

3. Facilite a comparação de performance. Por exemplo, forneça uma linha do tempo
   para comparar a versão atual com a versão antiga. Forneça maneiras e ferramentas
   para converter uma métrica em outra. Por exemplo, se pudermos converter tanto o
   aumento de memória quanto as quedas de fps no número de usuários perdidos ou
   receita perdida em dólares, então podemos compará-los e fazer uma troca
   informada.

4. Faça com que as métricas de performance monitorem uma população o mais ampla
   possível, para que ninguém seja deixado para trás.

[1]: https://en.wikipedia.org/wiki/Law_of_large_numbers
