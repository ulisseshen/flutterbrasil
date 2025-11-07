---
ia-translate: true
title: Melhores práticas para design adaptativo
description: >-
  Resumo de algumas das melhores práticas para design adaptativo.
short-title: Melhores práticas
---

As melhores práticas recomendadas para design adaptativo incluem:

## Considerações de design

### Divida seus widgets

Ao projetar seu app, tente dividir widgets grandes e
complexos em widgets menores e mais simples.

Refatorar widgets pode reduzir a complexidade de
adotar uma UI adaptativa ao compartilhar partes centrais do código.
Existem outros benefícios também:

* Do lado do desempenho, ter muitos widgets `const` pequenos
  melhora os tempos de reconstrução em comparação com ter widgets grandes e
  complexos.
* O Flutter pode reutilizar instâncias de widgets `const`,
  enquanto um widget complexo maior precisa ser configurado
  para cada reconstrução.
* Do ponto de vista da saúde do código, organizar sua UI
  em pedaços menores ajuda a manter a complexidade
  de cada `Widget` baixa. Um `Widget` menos complexo é mais legível,
  mais fácil de refatorar e menos propenso a ter comportamento surpreendente.

Para saber mais, confira os 3 passos de
design adaptativo em [Abordagem geral][General approach].

[General approach]: /ui/adaptive-responsive/general

### Projete para os pontos fortes de cada fator de forma

Além do tamanho da tela, você também deve dedicar tempo
considerando os pontos fortes e fracos únicos
de diferentes fatores de forma. Nem sempre é ideal
que seu app multiplataforma ofereça funcionalidade idêntica
em todos os lugares. Considere se faz
sentido focar em capacidades específicas,
ou até mesmo remover certos recursos, em algumas categorias de dispositivos.

Por exemplo, dispositivos móveis são portáteis e têm câmeras,
mas não são bem adequados para trabalho criativo detalhado.
Com isso em mente, você pode focar mais em capturar conteúdo
e marcá-lo com dados de localização para uma UI móvel,
mas focar em organizar ou manipular esse conteúdo
para uma UI de tablet ou desktop.

Outro exemplo é aproveitar a barreira extremamente baixa
da web para compartilhamento. Se você está implantando um app web,
decida quais [deep links][] suportar,
e projete suas rotas de navegação com isso em mente.

A principal conclusão aqui é pensar sobre o que cada
plataforma faz de melhor e ver se há capacidades únicas
que você pode aproveitar.

[deep links]: /ui/navigation/deep-linking

### Resolva o toque primeiro

Construir uma ótima UI de toque pode ser mais difícil
do que uma UI de desktop tradicional devido, em parte,
à falta de aceleradores de entrada como clique direito,
roda de rolagem ou atalhos de teclado.

Uma maneira de abordar esse desafio é focar inicialmente
em uma ótima UI orientada ao toque. Você ainda pode fazer a maior parte de
seus testes usando o destino desktop pela velocidade de iteração.
Mas lembre-se de alternar frequentemente para um dispositivo móvel para
verificar se tudo está correto.

Depois de ter a interface de toque polida, você pode ajustar
a densidade visual para usuários de mouse e, em seguida, adicionar todas
as entradas adicionais. Aborde essas outras entradas como
aceleradoras—alternativas que tornam uma tarefa mais rápida.
O importante a considerar é o que um usuário espera
ao usar um dispositivo de entrada específico,
e trabalhe para refletir isso em seu app.

## Detalhes de implementação

### Não bloqueie a orientação do seu app.

Um app adaptativo deve ter boa aparência em janelas de
diferentes tamanhos e formatos. Embora bloquear um app
no modo retrato em telefones possa ajudar a reduzir o escopo
de um produto mínimo viável, pode aumentar o
esforço necessário para tornar o app adaptativo no futuro.

Por exemplo, a suposição de que telefones renderizarão
seu app apenas em modo retrato em tela cheia não é
uma garantia. O suporte a apps com múltiplas janelas está se tornando comum,
e dobráveis têm muitos casos de uso que funcionam melhor com
vários apps rodando lado a lado.

Se você absolutamente precisa bloquear seu app no modo retrato (mas não faça isso),
use a API `Display` em vez de algo como `MediaQuery`
para obter as dimensões físicas da tela.

Para resumir:

  * Telas bloqueadas podem ser [um problema de acessibilidade][] para alguns usuários
  * Os níveis de formato grande do Android exigem suporte a retrato e paisagem
    no [nível mais baixo][lowest level].
  * Dispositivos Android podem [sobrescrever uma tela bloqueada][override a locked screen]
  * As diretrizes da Apple dizem [tente suportar ambas as orientações][aim to support both orientations]

[an accessibility issue]: https://www.w3.org/WAI/WCAG21/Understanding/orientation.html
[aim to support both orientations]: https://www.w3.org/WAI/WCAG21/Understanding/orientation.html
[lowest level]:  {{site.android-dev}}/docs/quality-guidelines/large-screen-app-quality#T3-8
[override a locked screen]: {{site.android-dev}}/guide/topics/large-screens/large-screen-compatibility-mode#per-app_overrides

### Evite layouts baseados em orientação

Evite usar o campo de orientação do `MediaQuery`
ou `OrientationBuilder` para alternar entre
diferentes layouts de app. Isso é semelhante à
orientação de não verificar tipos de dispositivo para determinar
o tamanho da tela. A orientação do dispositivo também não
necessariamente informa quanto espaço a janela do seu app tem.

Em vez disso, use o `sizeOf` do `MediaQuery` ou `LayoutBuilder`,
como discutido na página [Abordagem geral][General approach].
Em seguida, use pontos de interrupção adaptativos como os que
o [Material][] recomenda.

[General approach]: /ui/adaptive-responsive/general#
[Material]: https://m3.material.io/foundations/layout/applying-layout/window-size-classes

### Não consuma todo o espaço horizontal

Apps que usam a largura total da janela para
exibir caixas ou campos de texto não funcionam bem
quando esses apps são executados em telas grandes.

Para saber como evitar isso,
confira [Layout com GridView][Layout with GridView].

[Layout with GridView]: /ui/adaptive-responsive/large-screens#layout-with-gridview

### Evite verificar tipos de hardware

Evite escrever código que verifica se o dispositivo em que você está
executando é um "telefone" ou um "tablet", ou qualquer outro tipo
de dispositivo ao tomar decisões de layout.

O espaço que seu app realmente recebe para renderizar
nem sempre está vinculado ao tamanho total da tela do dispositivo.
O Flutter pode ser executado em muitas plataformas diferentes,
e seu app pode estar rodando em uma janela redimensionável no ChromeOS,
lado a lado com outro app em tablets em um modo de múltiplas janelas,
ou até mesmo em picture-in-picture em telefones.
Portanto, tipo de dispositivo e tamanho da janela do app não estão
realmente fortemente conectados.

Em vez disso, use `MediaQuery` para obter o tamanho da janela
em que seu app está sendo executado atualmente.

Isso não é útil apenas para código de UI.
Para saber como abstrair
capacidades de dispositivos pode ajudar seu código de lógica de negócios,
confira a palestra do Google I/O 2022,
[Flutter lessons for federated plugin development][].

[Flutter lessons for federated plugin development]: {{site.youtube-site}}/watch?v=GAnSNplNpCA

### Suporte uma variedade de dispositivos de entrada

Apps devem suportar mouses básicos, trackpads
e atalhos de teclado. Os fluxos de usuário mais comuns
devem suportar navegação por teclado
para garantir acessibilidade. Em particular,
seu app deve seguir as melhores práticas acessíveis
para teclados em dispositivos grandes.

A biblioteca Material fornece widgets com
excelente comportamento padrão para interação de toque, mouse
e teclado.

Para saber como adicionar esse suporte a widgets customizados,
confira [Entrada do usuário e acessibilidade][User input & accessibility].

[User input & accessibility]: /ui/adaptive-responsive/input

### Restaure o estado da List

{% comment %}
<b>PENDING: Reid, I think you suggested renaming/removing this item? I can't, for the life of me, find that comment in the PR</b>
{% endcomment %}

Para manter a posição de rolagem em uma lista
que não muda seu layout quando a
orientação do dispositivo muda,
use a classe [`PageStorageKey`][]. A
[`PageStorageKey`][] persiste o
estado do widget no armazenamento após o widget ser
destruído e restaura o estado quando recriado.

Você pode ver um exemplo disso no [app Wonderous][Wonderous app],
onde ele armazena o estado da lista no
widget `SingleChildScrollView`.

Se o widget `List` mudar seu layout
quando a orientação do dispositivo mudar,
você pode ter que fazer um pouco de matemática ([exemplo][example])
para mudar a posição de rolagem na rotação da tela.

[example]: {{site.github}}/gskinnerTeam/flutter-wonderous-app/blob/34e49a08084fbbe69ed67be948ab00ef23819313/lib/ui/screens/collection/widgets/_collection_list.dart#L39
[`PageStorageKey`]: {{site.api}}/flutter/widgets/PageStorageKey-class.html
[Wonderous app]: {{site.github}}/gskinnerTeam/flutter-wonderous-app/blob/8a29d6709668980340b1b59c3d3588f123edd4d8/lib/ui/screens/wonder_events/widgets/_events_list.dart#L64

## Salve o estado do app

Apps devem reter ou restaurar o [estado do app][app state]
conforme o dispositivo gira, muda o tamanho da janela,
ou dobra e desdobra.
Por padrão, um app deve manter o estado.

Se seu app perder estado durante a configuração do dispositivo,
verifique se os plugins e extensões nativas
que seu app usa suportam o
tipo de dispositivo, como uma tela grande.
Algumas extensões nativas podem perder estado quando o
dispositivo muda de posição.

Para mais informações sobre um caso real
em que isso ocorreu, confira
[Problema: Dobrar/desdobrar causa perda de estado][state-loss]
em [Desenvolvendo apps Flutter para telas grandes][article],
um artigo gratuito no Medium.

[app state]: {{site.android-dev}}/jetpack/compose/state#store-state
[article]: {{site.flutter-medium}}/developing-flutter-apps-for-large-screens-53b7b0e17f10
[state-loss]: {{site.flutter-medium}}/developing-flutter-apps-for-large-screens-53b7b0e17f10#:~:text=Problem%3A%20Folding/Unfolding%20causes%20state%2Dloss
