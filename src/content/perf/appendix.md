---
ia-translate: true
title: Mais reflexões sobre desempenho
description: O que é desempenho, e por que o desempenho é importante
---

## O que é desempenho?

Desempenho é um conjunto de propriedades quantificáveis de um performer.

Neste contexto, desempenho não é a execução de uma ação em si;
é o quão bem algo ou alguém performa. Portanto, usamos o adjetivo
_performant_.

Enquanto a parte _quão bem_ pode, em geral, ser descrita em linguagens naturais,
em nosso escopo limitado, o foco está em algo que é quantificável como um número
real. Números reais incluem inteiros e binários 0/1 como casos especiais.
Descrições em linguagem natural ainda são muito importantes. Por exemplo, um artigo de notícia
que critica fortemente o desempenho do Flutter apenas usando palavras
sem nenhum número (um valor quantificável) ainda pode ser significativo, e pode
ter grandes impactos. O escopo limitado é escolhido apenas por causa de nossos
recursos limitados.

A quantidade necessária para descrever desempenho é frequentemente referida como uma
métrica.

Para navegar através de inúmeros problemas de desempenho e métricas, você pode categorizar
com base nos performers.

Por exemplo, a maioria do conteúdo neste website é sobre o desempenho de apps Flutter,
onde o performer é um app Flutter. O desempenho de infraestrutura também é
importante para o Flutter, onde os performers são build bots e executores de tarefas de CI:
eles afetam muito a rapidez com que o Flutter pode incorporar mudanças de código, para melhorar
o desempenho do app.

Aqui, o escopo foi intencionalmente ampliado para incluir problemas de desempenho que não
sejam apenas problemas de desempenho de app, porque eles podem compartilhar muitas ferramentas independentemente de
quem sejam os performers. Por exemplo, o desempenho de app Flutter e o desempenho de infraestrutura
podem compartilhar o mesmo dashboard e mecanismos de alerta similares.

Ampliar o escopo também permite incluir performers que tradicionalmente
são fáceis de ignorar. O desempenho de documentação é um exemplo disso. O performer
pode ser uma documentação de API do SDK, e uma métrica pode ser: a porcentagem de leitores
que acham a documentação de API útil.

## Por que o desempenho é importante?

Responder a esta pergunta não é apenas crucial para validar o trabalho em
desempenho, mas também para guiar o trabalho de desempenho de modo a ser mais
útil. A resposta para "por que o desempenho é importante?" frequentemente é também a resposta
para "como o desempenho é útil?"

Simplificando, o desempenho é importante e útil porque, no escopo,
o desempenho deve ter propriedades ou métricas quantificáveis. Isso implica:
1. Um relatório de desempenho é fácil de consumir.
2. O desempenho tem pouca ambiguidade.
3. O desempenho é comparável e conversível.
4. O desempenho é justo.

Não que problemas ou descrições não relacionados a desempenho ou não mensuráveis não
sejam importantes. Eles são destinados a destacar os cenários onde o desempenho pode ser
mais útil.

### 1. Um relatório de desempenho é fácil de consumir

Métricas de desempenho são números. Ler um número é muito mais fácil do que ler uma
passagem. Por exemplo, provavelmente leva 1 segundo para um engenheiro consumir a
classificação de desempenho como um número de 1 a 5. Provavelmente leva para o mesmo engenheiro
pelo menos 1 minuto para ler o resumo completo de feedback de 500 palavras.

Se houver muitos números, é fácil resumi-los ou visualizá-los para rápido
consumo. Por exemplo, você pode rapidamente consumir milhões de números
olhando para seu histograma, média, quantis, e assim por diante. Se uma métrica tem um
histórico de milhares de pontos de dados, então você pode facilmente plotar uma linha do tempo para
ler sua tendência.

Por outro lado, ter _n_ textos de 500 palavras quase garante um
custo de _n_ vezes para consumir esses textos. Seria uma tarefa assustadora analisar
milhares de descrições históricas, cada uma tendo 500 palavras.

### 2. O desempenho tem pouca ambiguidade

Outra vantagem de ter desempenho como um conjunto de números é sua não ambiguidade.
Quando você quer que uma animação tenha um desempenho de 20 ms por frame ou
50 fps, há pouco espaço para interpretações diferentes sobre os números. Por
outro lado, para descrever a mesma animação em palavras, alguém pode chamá-la de
boa, enquanto outra pessoa pode reclamar que é ruim. Da mesma forma, a mesma
palavra ou frase pode ser interpretada de forma diferente por pessoas diferentes. Você pode
interpretar uma taxa de frames OK como sendo 60 fps, enquanto outra pessoa pode interpretar como
sendo 30 fps.

Os números ainda podem ser ruidosos. Por exemplo, o tempo medido por frame pode
ser um tempo de computação verdadeiro deste frame, mais uma quantidade aleatória de tempo (ruído)
que CPU/GPU gasta em algum trabalho não relacionado. Portanto, a métrica flutua.
No entanto, não há ambiguidade sobre o que o número significa. E, também há
teoria rigorosa e ferramentas de teste para lidar com esse ruído. Por exemplo, você
pode fazer múltiplas medições para estimar a distribuição de uma variável
aleatória, ou você pode tirar a média de muitas medições para eliminar o
ruído pela [lei dos grandes números][1].

### 3. O desempenho é comparável e conversível

Os números de desempenho não apenas têm significados não ambíguos, mas também têm
comparações não ambíguas. Por exemplo, não há dúvida de que 5 é maior que 4.
Por outro lado, pode ser subjetivo descobrir se excelente é
melhor ou pior que soberbo. Da mesma forma, você pode descobrir se épico é
melhor que lendário? Na verdade, a frase _excede fortemente as expectativas_
pode ser melhor que _soberbo_ na interpretação de alguém. Só se torna
não ambíguo e comparável após uma definição que mapeia excede fortemente as
expectativas para 4 e soberbo para 5.

Os números também são facilmente conversíveis usando fórmulas e funções. Por exemplo,
60 fps pode ser convertido para 16.67 ms por frame. O tempo de renderização de um frame
_x_ (ms) pode ser convertido para um indicador binário
`isSmooth = [x <= 16] = (x <= 16 ? 1 :0)`. Essa conversão pode ser composta ou
encadeada, então você pode obter uma grande variedade de quantidades usando uma única
medição sem nenhum ruído ou ambiguidade adicionados. A quantidade convertida pode
então ser usada para comparações e consumo adicionais. Tais conversões são
quase impossíveis se você está lidando com linguagens naturais.

### 4. O desempenho é justo

Se problemas dependem de palavras verbosas para serem descobertos, então uma vantagem injusta é
dada a pessoas que são mais verbosas (mais dispostas a conversar ou escrever) ou aquelas
que estão mais próximas da equipe de desenvolvimento, que têm uma maior largura de banda e menor
custo para conversas ou reuniões presenciais.

Ao ter as mesmas métricas para detectar problemas, não importa quão longe ou quão
silenciosos os usuários estejam, podemos tratar todos os problemas de forma justa. Isso, por sua vez,
nos permite focar nos problemas certos que têm maior impacto.

### Como tornar o desempenho útil

O seguinte resume os 4 pontos discutidos aqui, de uma perspectiva ligeiramente diferente:
1. Torne as métricas de desempenho fáceis de consumir. Não sobrecarregue os leitores com
   muitos números (ou palavras). Se houver muitos números, tente resumi-los
   em um conjunto menor de números (por exemplo, resumir muitos números em
   um único número médio). Apenas notifique os leitores quando os números mudarem
   significativamente (por exemplo, alertas automáticos sobre picos ou regressões).

2. Torne as métricas de desempenho o mais não ambíguas possível. Defina a unidade que o
   número está usando. Descreva precisamente como o número é medido. Torne o
   número facilmente reproduzível. Quando houver muito ruído, tente mostrar a distribuição
   completa, ou elimine o ruído o máximo possível agregando muitas
   medições ruidosas.

3. Facilite a comparação de desempenho. Por exemplo, forneça uma linha do tempo para
   comparar a versão atual com a versão antiga. Forneça formas e ferramentas para
   converter uma métrica em outra. Por exemplo, se pudermos converter tanto aumento de memória
   quanto quedas de fps no número de usuários perdidos ou receita perdida em
   dólares, então podemos compará-los e fazer uma compensação informada.

4. Faça as métricas de desempenho monitorarem uma população que seja o mais ampla possível,
   para que ninguém seja deixado para trás.

[1]: https://en.wikipedia.org/wiki/Law_of_large_numbers
