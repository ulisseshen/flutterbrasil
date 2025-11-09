---
ia-translate: true
title: Melhores práticas para design adaptativo
description: >-
  Resumo de algumas das melhores práticas para design adaptativo.
shortTitle: Melhores práticas
---

Melhores práticas recomendadas para design adaptativo incluem:

## Considerações de design

### Divida seus widgets

Ao projetar seu app, tente dividir widgets grandes e
complexos em widgets menores e mais simples.

Refatorar widgets pode reduzir a complexidade de
adotar uma UI adaptativa compartilhando partes centrais do código.
Existem outros benefícios também:

* Do lado da performance, ter muitos widgets `const` pequenos
  melhora os tempos de reconstrução em comparação com widgets grandes
  e complexos.
* Flutter pode reutilizar instâncias de widgets `const`,
  enquanto um widget complexo maior precisa ser configurado
  para cada reconstrução.
* Do ponto de vista da saúde do código, organizar sua UI
  em pedaços menores ajuda a manter a complexidade
  de cada `Widget` baixa. Um `Widget` menos complexo é mais legível,
  mais fácil de refatorar e menos propenso a ter comportamento inesperado.

Para saber mais, confira os 3 passos do
design adaptativo em [General approach][General approach].

[General approach]: /ui/adaptive-responsive/general

### Projete para as forças de cada fator de forma

Além do tamanho da tela, você também deve dedicar tempo
considerando as forças e fraquezas únicas
de diferentes fatores de forma. Nem sempre é ideal
que seu app multiplataforma ofereça funcionalidade
idêntica em todos os lugares. Considere se faz
sentido focar em capacidades específicas,
ou até mesmo remover certos recursos, em algumas categorias de dispositivos.

Por exemplo, dispositivos móveis são portáteis e têm câmeras,
mas não são adequados para trabalho criativo detalhado.
Com isso em mente, você pode focar mais em capturar conteúdo
e marcá-lo com dados de localização para uma UI móvel,
mas focar em organizar ou manipular esse conteúdo
para uma UI de tablet ou desktop.

Outro exemplo é aproveitar a barreira extremamente baixa
da web para compartilhamento. Se você está implantando um app web,
decida quais [deep links][deep links] suportar,
e projete suas rotas de navegação com isso em mente.

A conclusão principal aqui é pensar sobre o que cada
plataforma faz melhor e ver se há capacidades únicas
que você pode aproveitar.

[deep links]: /ui/navigation/deep-linking

### Resolva touch primeiro

Construir uma ótima UI touch pode frequentemente ser mais difícil
do que uma UI desktop tradicional, em parte,
devido à falta de aceleradores de entrada como clique direito,
roda de rolagem ou atalhos de teclado.

Uma maneira de abordar esse desafio é focar inicialmente
em uma ótima UI orientada a touch. Você ainda pode fazer a maior parte
dos seus testes usando o target desktop pela sua velocidade de iteração.
Mas lembre-se de alternar frequentemente para um dispositivo móvel para
verificar se tudo está certo.

Depois que você tiver a interface touch polida, você pode ajustar
a densidade visual para usuários de mouse, e então adicionar todas
as entradas adicionais. Aborde essas outras entradas como
aceleradores—alternativas que tornam uma tarefa mais rápida.
O importante a considerar é o que um usuário espera
ao usar um dispositivo de entrada específico,
e trabalhar para refletir isso em seu app.

## Detalhes de implementação

### Não bloqueie a orientação do seu app.

Um app adaptativo deve ter uma boa aparência em janelas de
diferentes tamanhos e formas. Embora bloquear um app
no modo retrato em telefones possa ajudar a reduzir o escopo
de um produto mínimo viável, isso pode aumentar o
esforço necessário para tornar o app adaptativo no futuro.

Por exemplo, a suposição de que telefones só
renderizarão seu app em modo retrato de tela cheia não
é uma garantia. O suporte a apps em várias janelas está se tornando comum,
e dobráveis têm muitos casos de uso que funcionam melhor com
múltiplos apps rodando lado a lado.

Se você absolutamente precisa bloquear seu app no modo retrato (mas não faça isso),
use a API `Display` em vez de algo como `MediaQuery`
para obter as dimensões físicas da tela.

Para resumir:

  * Telas bloqueadas podem ser [an accessibility issue][an accessibility issue] para alguns usuários
  * Os níveis de formato grande do Android requerem suporte a retrato e paisagem
    no [lowest level][lowest level].
  * Dispositivos Android podem [override a locked screen][override a locked screen]
  * As diretrizes da Apple dizem [aim to support both orientations][aim to support both orientations]

[an accessibility issue]: https://www.w3.org/WAI/WCAG21/Understanding/orientation.html
[aim to support both orientations]: https://www.w3.org/WAI/WCAG21/Understanding/orientation.html
[lowest level]:  {{site.android-dev}}/docs/quality-guidelines/large-screen-app-quality#T3-8
[override a locked screen]: {{site.android-dev}}/guide/topics/large-screens/large-screen-compatibility-mode#per-app_overrides

### Evite layouts baseados em orientação do dispositivo

Evite usar o campo orientation do `MediaQuery`
ou `OrientationBuilder` perto do topo da sua árvore de widgets
para alternar entre diferentes layouts de app. Isso é
similar à orientação de não verificar tipos de dispositivo
para determinar o tamanho da tela. A orientação do dispositivo também
não necessariamente informa quanto espaço sua
janela de app tem.

Em vez disso, use `sizeOf` do `MediaQuery` ou `LayoutBuilder`,
conforme discutido na página [General approach][General approach].
Então use breakpoints adaptativos como os que o
[Material][Material] recomenda.

[General approach]: /ui/adaptive-responsive/general#
[Material]: https://m3.material.io/foundations/layout/applying-layout/window-size-classes

### Não consuma todo o espaço horizontal

Apps que usam a largura total da janela para
exibir caixas ou campos de texto não funcionam bem
quando esses apps são executados em telas grandes.

Para saber como evitar isso,
confira [Layout with GridView][Layout with GridView].

[Layout with GridView]: /ui/adaptive-responsive/large-screens#layout-with-gridview

### Evite verificar tipos de hardware

Evite escrever código que verifica se o dispositivo em que você está
executando é um "telefone" ou um "tablet", ou qualquer outro tipo
de dispositivo ao tomar decisões de layout.

O espaço que seu app realmente recebe para renderizar
nem sempre está vinculado ao tamanho total da tela do dispositivo.
Flutter pode executar em muitas plataformas diferentes,
e seu app pode estar rodando em uma janela redimensionável no ChromeOS,
lado a lado com outro app em tablets em modo de várias janelas,
ou até mesmo em um picture-in-picture em telefones.
Portanto, tipo de dispositivo e tamanho da janela do app não estão
realmente fortemente conectados.

Em vez disso, use `MediaQuery` para obter o tamanho da janela
em que seu app está atualmente em execução.

Isso não é útil apenas para código de UI.
Para saber como abstrair capacidades de dispositivo
pode ajudar seu código de lógica de negócios,
confira a palestra do Google I/O de 2022,
[Flutter lessons for federated plugin development][Flutter lessons for federated plugin development].

[Flutter lessons for federated plugin development]: {{site.youtube-site}}/watch?v=GAnSNplNpCA

### Suporte uma variedade de dispositivos de entrada

Apps devem suportar mouses básicos, trackpads,
e atalhos de teclado. Os fluxos de usuário mais comuns
devem suportar navegação por teclado
para garantir acessibilidade. Em particular,
seu app deve seguir as melhores práticas acessíveis
para teclados em dispositivos grandes.

A biblioteca Material fornece widgets com
excelente comportamento padrão para interação com touch, mouse,
e teclado.

Para saber como adicionar esse suporte a widgets customizados,
confira [User input & accessibility][User input & accessibility].

[User input & accessibility]: /ui/adaptive-responsive/input

### Restaure o estado da Lista

Para manter a posição de rolagem em uma lista
que não muda seu layout quando a
orientação do dispositivo muda,
use a classe [`PageStorageKey`][`PageStorageKey`].
[`PageStorageKey`][`PageStorageKey`] persiste o
estado do widget em armazenamento após o widget ser
destruído e restaura o estado quando recriado.

Você pode ver um exemplo disso no [Wonderous app][Wonderous app],
onde ele armazena o estado da lista no
widget `SingleChildScrollView`.

Se o widget `List` mudar seu layout
quando a orientação do dispositivo mudar,
você pode ter que fazer um pouco de matemática ([example][example])
para mudar a posição de rolagem na rotação da tela.

[example]: {{site.github}}/gskinnerTeam/flutter-wonderous-app/blob/34e49a08084fbbe69ed67be948ab00ef23819313/lib/ui/screens/collection/widgets/_collection_list.dart#L39
[`PageStorageKey`]: {{site.api}}/flutter/widgets/PageStorageKey-class.html
[Wonderous app]: {{site.github}}/gskinnerTeam/flutter-wonderous-app/blob/8a29d6709668980340b1b59c3d3588f123edd4d8/lib/ui/screens/wonder_events/widgets/_events_list.dart#L64

## Salve o estado do app

Apps devem reter ou restaurar o [app state][app state]
conforme o dispositivo gira, muda o tamanho da janela,
ou dobra e desdobra.
Por padrão, um app deve manter o estado.

Se seu app perder o estado durante a configuração do dispositivo,
verifique se os plugins e extensões nativas
que seu app usa suportam o
tipo de dispositivo, como uma tela grande.
Algumas extensões nativas podem perder o estado quando o
dispositivo muda de posição.

Para mais informações sobre um caso real
onde isso ocorreu, confira
[Problem: Folding/unfolding causes state loss][state-loss]
em [Developing Flutter apps for Large screens][article],
um artigo gratuito no Medium.

[app state]: {{site.android-dev}}/jetpack/compose/state#store-state
[article]: {{site.flutter-blog}}/developing-flutter-apps-for-large-screens-53b7b0e17f10
[state-loss]: {{site.flutter-blog}}/developing-flutter-apps-for-large-screens-53b7b0e17f10#:~:text=Problem%3A%20Folding/Unfolding%20causes%20state%2Dloss
