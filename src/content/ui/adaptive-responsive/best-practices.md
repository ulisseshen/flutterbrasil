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

Ao projetar seu aplicativo, tente dividir widgets grandes e
complexos em widgets menores e mais simples.

Refatorar widgets pode reduzir a complexidade de
adotar uma UI adaptativa, compartilhando partes essenciais do código.
Existem outros benefícios também:

*   Do ponto de vista do desempenho, ter muitos widgets `const` pequenos
    melhora os tempos de reconstrução em comparação com widgets grandes
    e complexos.
*   O Flutter pode reutilizar instâncias de widgets `const`,
    enquanto um widget complexo maior precisa ser configurado
    a cada reconstrução.
*   Do ponto de vista da integridade do código, organizar sua UI
    em pedaços menores ajuda a manter a complexidade de cada `Widget`
    baixa. Um `Widget` menos complexo é mais legível,
    mais fácil de refatorar e menos propenso a ter comportamento
    surpreendente.

Para saber mais, confira as 3 etapas de
design adaptativo em [Abordagem geral][].

[Abordagem geral]: /ui/adaptive-responsive/general

### Projete com base nos pontos fortes de cada tipo de dispositivo

Além do tamanho da tela, você também deve dedicar tempo
a considerar os pontos fortes e fracos exclusivos
de diferentes tipos de dispositivos. Nem sempre é ideal
que seu aplicativo multiplataforma ofereça funcionalidades
idênticas em todos os lugares. Considere se faz sentido
concentrar-se em recursos específicos,
ou até mesmo remover certos recursos, em algumas categorias de dispositivos.

Por exemplo, dispositivos móveis são portáteis e têm câmeras,
mas não são adequados para trabalhos criativos detalhados.
Com isso em mente, você pode se concentrar mais na captura de conteúdo
e marcá-lo com dados de localização para uma UI móvel,
mas se concentrar em organizar ou manipular esse conteúdo
para uma UI de tablet ou desktop.

Outro exemplo é aproveitar a barreira extremamente baixa da web
para compartilhamento. Se você estiver implantando um aplicativo web,
decida quais [links diretos][] suportar,
e projete suas rotas de navegação tendo isso em mente.

O principal ponto aqui é pensar no que cada plataforma
faz de melhor e ver se há recursos exclusivos que
você pode aproveitar.

[links diretos]: /ui/navigation/deep-linking

### Resolva o toque primeiro

Construir uma ótima interface de toque pode ser mais difícil
do que uma interface de desktop tradicional, em parte,
devido à falta de aceleradores de entrada como clique com o botão direito,
roda de rolagem ou atalhos de teclado.

Uma forma de abordar esse desafio é focar inicialmente
em uma ótima UI orientada ao toque. Você ainda pode fazer a maior parte
dos seus testes usando o alvo de desktop por sua velocidade de iteração.
Mas, lembre-se de alternar frequentemente para um dispositivo móvel para
verificar se tudo parece certo.

Depois de ter a interface de toque refinada, você pode ajustar
a densidade visual para usuários de mouse e, em seguida, adicionar
todas as entradas adicionais. Aborde essas outras entradas como
aceleradores—alternativas que tornam uma tarefa mais rápida.
O importante a considerar é o que um usuário espera
ao usar um dispositivo de entrada específico,
e trabalhar para refletir isso em seu aplicativo.

## Detalhes da implementação

### Não bloqueie a orientação do seu aplicativo.

Um aplicativo adaptativo deve ter boa aparência em janelas de
tamanhos e formatos diferentes. Embora bloquear um aplicativo
no modo retrato em telefones possa ajudar a restringir o escopo
de um produto mínimo viável, pode aumentar o
esforço necessário para tornar o aplicativo adaptativo no futuro.

Por exemplo, a suposição de que os telefones só
renderizarão seu aplicativo no modo retrato em tela cheia não
é uma garantia. O suporte a aplicativos de múltiplas janelas está se tornando comum,
e os dobráveis têm muitos casos de uso que funcionam melhor com
vários aplicativos executados lado a lado.

Se você absolutamente precisar bloquear seu aplicativo no modo retrato (mas não o faça),
use a API `Display` em vez de algo como `MediaQuery`
para obter as dimensões físicas da tela.

Para resumir:

  * Telas bloqueadas podem ser [um problema de acessibilidade][] para alguns usuários
  * Os níveis de formato grande do Android exigem suporte para retrato e paisagem
    no [nível mais baixo][].
  * Dispositivos Android podem [substituir uma tela bloqueada][]
  * As diretrizes da Apple dizem que [o objetivo é suportar ambas as orientações][]

[um problema de acessibilidade]: https://www.w3.org/WAI/WCAG21/Understanding/orientation.html
[o objetivo é suportar ambas as orientações]: https://www.w3.org/WAI/WCAG21/Understanding/orientation.html
[nível mais baixo]: {{site.android-dev}}/docs/quality-guidelines/large-screen-app-quality#T3-8
[substituir uma tela bloqueada]: {{site.android-dev}}/guide/topics/large-screens/large-screen-compatibility-mode#per-app_overrides

### Evite layouts baseados em orientação

Evite usar o campo de orientação do `MediaQuery`
ou `OrientationBuilder` para alternar entre
diferentes layouts de aplicativos. Isso é semelhante à
orientação de não verificar os tipos de dispositivos para determinar
o tamanho da tela. A orientação do dispositivo também não
informa necessariamente sobre quanto espaço sua janela de aplicativo tem.

Em vez disso, use `sizeOf` ou `LayoutBuilder` de `MediaQuery`,
conforme discutido na página [Abordagem geral][].
Em seguida, use breakpoints adaptativos como os que o
[Material][] recomenda.

[Abordagem geral]: /ui/adaptive-responsive/general#
[Material]: https://m3.material.io/foundations/layout/applying-layout/window-size-classes

### Não tome todo o espaço horizontal

Aplicativos que usam toda a largura da janela para
exibir caixas ou campos de texto não funcionam bem
quando esses aplicativos são executados em telas grandes.

Para aprender como evitar isso,
confira [Layout com GridView][].

[Layout com GridView]: /ui/adaptive-responsive/large-screens#layout-with-gridview

### Evite verificar tipos de hardware

Evite escrever código que verifique se o dispositivo que você está
executando é um "telefone" ou um "tablet", ou qualquer outro tipo
de dispositivo ao tomar decisões de layout.

O espaço que seu aplicativo realmente recebe para renderizar
nem sempre está vinculado ao tamanho total da tela do dispositivo.
O Flutter pode ser executado em muitas plataformas diferentes,
e seu aplicativo pode estar sendo executado em uma janela redimensionável no ChromeOS,
lado a lado com outro aplicativo em tablets em modo de múltiplas janelas,
ou mesmo em um picture-in-picture em telefones.
Portanto, o tipo de dispositivo e o tamanho da janela do aplicativo não são
realmente fortemente conectados.

Em vez disso, use `MediaQuery` para obter o tamanho da janela
em que seu aplicativo está sendo executado atualmente.

Isso não é útil apenas para o código da UI.
Para saber como abstrair recursos do dispositivo pode ajudar
o código da sua lógica de negócios,
confira a palestra do Google I/O de 2022,
[Lições do Flutter para desenvolvimento de plugins federados][].

[Lições do Flutter para desenvolvimento de plugins federados]: {{site.youtube-site}}/watch?v=GAnSNplNpCA

### Suporte uma variedade de dispositivos de entrada

Os aplicativos devem suportar mouses básicos, trackpads,
e atalhos de teclado. Os fluxos de usuário mais comuns
devem suportar a navegação por teclado
para garantir a acessibilidade. Em particular,
seu aplicativo deve seguir as melhores práticas acessíveis
para teclados em dispositivos grandes.

A biblioteca Material fornece widgets com
excelente comportamento padrão para toque, mouse
e interação com o teclado.

Para saber como adicionar esse suporte a widgets personalizados,
confira [Entrada do usuário e acessibilidade][].

[Entrada do usuário e acessibilidade]: /ui/adaptive-responsive/input

### Restaure o estado da lista

{% comment %}
<b>PENDENTE: Reid, acho que você sugeriu renomear/remover este item? Não consigo, de jeito nenhum, encontrar esse comentário no PR</b>
{% endcomment %}

Para manter a posição de rolagem em uma lista
que não altera seu layout quando a
orientação do dispositivo muda,
use a classe [`PageStorageKey`][].
[`PageStorageKey`][] persiste o
estado do widget no armazenamento após o widget ser
destruído e restaura o estado quando recriado.

Você pode ver um exemplo disso no [aplicativo Wonderous][],
onde ele armazena o estado da lista no
widget `SingleChildScrollView`.

Se o widget `List` alterar seu layout
quando a orientação do dispositivo mudar,
você pode ter que fazer um pouco de matemática ([exemplo][])
para alterar a posição de rolagem na rotação da tela.

[exemplo]: {{site.github}}/gskinnerTeam/flutter-wonderous-app/blob/34e49a08084fbbe69ed67be948ab00ef23819313/lib/ui/screens/collection/widgets/_collection_list.dart#L39
[`PageStorageKey`]: {{site.api}}/flutter/widgets/PageStorageKey-class.html
[aplicativo Wonderous]: {{site.github}}/gskinnerTeam/flutter-wonderous-app/blob/8a29d6709668980340b1b59c3d3588f123edd4d8/lib/ui/screens/wonder_events/widgets/_events_list.dart#L64

## Salvar o estado do aplicativo

Os aplicativos devem reter ou restaurar o [estado do aplicativo][]
conforme o dispositivo gira, altera o tamanho da janela,
ou dobra e desdobra.
Por padrão, um aplicativo deve manter o estado.

Se seu aplicativo perder o estado durante a configuração do dispositivo,
verifique se os plugins e extensões nativas
que seu aplicativo usa suportam o
tipo de dispositivo, como uma tela grande.
Algumas extensões nativas podem perder o estado quando o
dispositivo muda de posição.

Para obter mais informações sobre um caso real
em que isso ocorreu, confira
[Problema: Dobrar/desdobrar causa perda de estado][state-loss]
em [Desenvolvendo aplicativos Flutter para telas grandes][article],
um artigo gratuito no Medium.

[estado do aplicativo]: {{site.android-dev}}/jetpack/compose/state#store-state
[article]: {{site.flutter-medium}}/developing-flutter-apps-for-large-screens-53b7b0e17f10
[state-loss]: {{site.flutter-medium}}/developing-flutter-apps-for-large-screens-53b7b0e17f10#:~:text=Problem%3A%20Folding/Unfolding%20causes%20state%2Dloss
