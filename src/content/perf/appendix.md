---
ia-translate: true
title: Mais reflexões sobre performance
description: O que é performance, e por que performance é importante
---

## O que é performance?

Performance é um conjunto de propriedades quantificáveis de um executor.

Neste contexto, performance não é a execução de uma ação em si;
é quão bem algo ou alguém executa. Portanto, usamos o adjetivo
_performant_.

Enquanto a parte _quão bem_ pode, em geral, ser descrita em linguagens naturais,
em nosso escopo limitado, o foco está em algo que seja quantificável como um número
real. Números reais incluem inteiros e binários 0/1 como casos especiais.
Descrições em linguagem natural ainda são muito importantes. Por exemplo, um artigo de notícias
que critica fortemente a performance do Flutter apenas usando palavras
sem nenhum número (um valor quantificável) ainda pode ser significativo, e pode
ter grandes impactos. O escopo limitado é escolhido apenas por causa de nossos
recursos limitados.

A quantidade necessária para descrever performance é frequentemente referida como uma
métrica.

Para navegar por inúmeras questões e métricas de performance, você pode categorizar
com base nos executores.

Por exemplo, a maior parte do conteúdo neste website é sobre a performance de apps
Flutter, onde o executor é um app Flutter. Performance de infra também é
importante para o Flutter, onde os executores são build bots e executores de tarefas CI:
eles afetam fortemente quão rápido o Flutter pode incorporar mudanças de código, para melhorar
a performance do app.

Aqui, o escopo foi intencionalmente ampliado para incluir questões de performance além
de apenas questões de performance de apps porque elas podem compartilhar muitas ferramentas independentemente de
quem sejam os executores. Por exemplo, performance de apps Flutter e performance de infra
podem compartilhar o mesmo dashboard e mecanismos de alerta similares.

Ampliar o escopo também permite que sejam incluídos executores que tradicionalmente
são fáceis de ignorar. Performance de documentação é um exemplo disso. O executor
poderia ser uma documentação de API do SDK, e uma métrica poderia ser: a porcentagem de leitores
que acham a documentação da API útil.

## Por que performance é importante?

Responder esta pergunta não é apenas crucial para validar o trabalho em
performance, mas também para guiar o trabalho de performance de forma a ser mais
útil. A resposta para "por que performance é importante?" frequentemente é também a resposta
para "como performance é útil?"

Falando simplesmente, performance é importante e útil porque, no escopo,
performance deve ter propriedades ou métricas quantificáveis. Isso implica:
1. Um relatório de performance é fácil de consumir.
2. Performance tem pouca ambiguidade.
3. Performance é comparável e conversível.
4. Performance é justa.

Não que questões ou descrições não-performance, ou não-mensuráveis não sejam
importantes. Elas são destinadas a destacar os cenários onde performance pode ser
mais útil.

### 1. Um relatório de performance é fácil de consumir

Métricas de performance são números. Ler um número é muito mais fácil do que ler uma
passagem. Por exemplo, provavelmente leva a um engenheiro 1 segundo para consumir a
classificação de performance como um número de 1 a 5. Provavelmente leva ao mesmo engenheiro
pelo menos 1 minuto para ler o resumo completo de feedback de 500 palavras.

Se há muitos números, é fácil resumir ou visualizá-los para consumo rápido.
Por exemplo, você pode rapidamente consumir milhões de números olhando
para seu histograma, média, quantis, e assim por diante. Se uma métrica tem um
histórico de milhares de pontos de dados, então você pode facilmente plotar uma linha do tempo para
ler sua tendência.

Por outro lado, ter _n_ textos de 500 palavras quase garante um
custo de _n_ vezes para consumir esses textos. Seria uma tarefa assustadora analisar
milhares de descrições históricas, cada uma tendo 500 palavras.

### 2. Performance tem pouca ambiguidade

Outra vantagem de ter performance como um conjunto de números é sua não ambiguidade.
Quando você quer que uma animação tenha uma performance de 20 ms por frame ou
50 fps, há pouco espaço para diferentes interpretações sobre os números. Por
outro lado, para descrever a mesma animação em palavras, alguém pode chamá-la de
boa, enquanto outra pessoa pode reclamar que é ruim. Similarmente, a mesma
palavra ou frase pode ser interpretada diferentemente por pessoas diferentes. Você pode
interpretar uma taxa de quadros OK como sendo 60 fps, enquanto outra pessoa pode interpretar como
30 fps.

Números ainda podem ser ruidosos. Por exemplo, o tempo medido por frame pode
ser um tempo de computação real deste frame, mais uma quantidade aleatória de tempo (ruído)
que a CPU/GPU gasta em algum trabalho não relacionado. Portanto, a métrica flutua.
No entanto, não há ambiguidade sobre o que o número significa. E, também há
teoria rigorosa e ferramentas de teste para lidar com tal ruído. Por exemplo, você
pode fazer múltiplas medições para estimar a distribuição de uma variável
aleatória, ou você pode tirar a média de muitas medições para eliminar o
ruído pela [lei dos grandes números][1].

### 3. Performance é comparável e conversível

Números de performance não apenas têm significados não ambíguos, mas também têm
comparações não ambíguas. Por exemplo, não há dúvida de que 5 é maior que 4.
Por outro lado, pode ser subjetivo descobrir se excelente é
melhor ou pior que soberbo. Similarmente, você poderia descobrir se épico é
melhor que lendário? Na verdade, a frase _fortemente excede expectativas_
pode ser melhor que _soberbo_ na interpretação de alguém. Só se torna
não ambíguo e comparável após uma definição que mapeia fortemente excede
expectativas para 4 e soberbo para 5.

Números também são facilmente conversíveis usando fórmulas e funções. Por exemplo,
60 fps pode ser convertido para 16.67 ms por frame. O tempo de renderização de um frame
_x_ (ms) pode ser convertido para um indicador binário
`isSmooth = [x <= 16] = (x <= 16 ? 1 :0)`. Tal conversão pode ser composta ou
encadeada, então você pode obter uma grande variedade de quantidades usando uma única
medição sem nenhum ruído ou ambiguidade adicionados. A quantidade convertida pode
então ser usada para comparações e consumo adicionais. Tais conversões são
quase impossíveis se você está lidando com linguagens naturais.

### 4. Performance é justa

Se questões dependem de palavras verbosas para serem descobertas, então uma vantagem injusta é
dada a pessoas que são mais verbosas (mais dispostas a conversar ou escrever) ou aquelas
que estão mais próximas da equipe de desenvolvimento, que têm uma largura de banda maior e menor
custo para conversar ou reuniões presenciais.

Ao ter as mesmas métricas para detectar problemas não importa quão longe ou quão
silenciosos os usuários estão, podemos tratar todas as questões de forma justa. Isso, por sua vez,
nos permite focar nas questões certas que têm maior impacto.

### Como tornar performance útil

O seguinte resume os 4 pontos discutidos aqui, de uma perspectiva ligeiramente diferente:
1. Torne métricas de performance fáceis de consumir. Não sobrecarregue os leitores com
   muitos números (ou palavras). Se há muitos números, então tente resumi-los
   em um conjunto menor de números (por exemplo, resumir muitos números em
   um único número médio). Apenas notifique leitores quando os números mudam
   significativamente (por exemplo, alertas automáticos sobre picos ou regressões).

2. Torne métricas de performance tão não ambíguas quanto possível. Defina a unidade que o
   número está usando. Descreva precisamente como o número é medido. Torne o
   número facilmente reproduzível. Quando há muito ruído, tente mostrar a distribuição
   completa, ou elimine o ruído o máximo possível agregando muitas
   medições ruidosas.

3. Torne fácil comparar performance. Por exemplo, forneça uma linha do tempo para
   comparar a versão atual com a versão antiga. Forneça maneiras e ferramentas para
   converter uma métrica em outra. Por exemplo, se pudermos converter tanto aumento de memória
   quanto quedas de fps no número de usuários perdidos ou receita perdida em
   dólares, então podemos compará-los e fazer um trade-off informado.

4. Torne métricas de performance monitorem uma população que seja tão ampla quanto possível,
   para que ninguém seja deixado para trás.

[1]: https://en.wikipedia.org/wiki/Law_of_large_numbers
