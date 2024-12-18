---
ia-translate: true
title: SafeArea & MediaQuery
description: >-
  Aprenda como usar SafeArea e MediaQuery para criar um aplicativo adaptável.
---

Esta página discute como e quando usar os widgets
`SafeArea` e `MediaQuery`.

## SafeArea

Ao executar seu aplicativo nos dispositivos mais recentes,
você pode encontrar partes da UI sendo bloqueadas
por recortes na tela do dispositivo.
Você pode corrigir isso com o widget [`SafeArea`][],
que insere seu widget filho para evitar intrusões
(como entalhes e recortes de câmera),
bem como a interface do usuário do sistema operacional
(como a barra de status no Android),
ou pelos cantos arredondados da tela física.

Se você não quiser esse comportamento,
o widget `SafeArea` permite que você
desabilite o preenchimento em qualquer um de seus quatro lados.
Por padrão, todos os quatro lados estão habilitados.

Geralmente, é recomendado envolver o corpo de um
widget `Scaffold` em `SafeArea` como um bom ponto de partida,
mas você nem sempre precisa colocá-lo tão alto na
árvore de `Widget`.

Por exemplo, se você deseja propositalmente que seu aplicativo se estenda
sob os recortes, você pode mover o `SafeArea` para envolver
qualquer conteúdo que faça sentido,
e deixar o resto do aplicativo ocupar a tela inteira.

Usar `SafeArea` garante que o conteúdo do seu aplicativo não seja
cortado por recursos físicos da tela ou interface do usuário do sistema operacional,
e prepara seu aplicativo para o sucesso mesmo quando novos dispositivos com
diferentes formatos e estilos de recortes entrarem no mercado.

Como o `SafeArea` faz tanto em uma pequena quantidade de código?
Nos bastidores, ele usa o objeto `MediaQuery`.

[`SafeArea`]: {{site.api}}/flutter/widgets/SafeArea-class.html

## MediaQuery

Como discutido na seção [SafeArea](#safearea),
`MediaQuery` é um widget poderoso para criar
aplicativos adaptáveis. Às vezes, você usará `MediaQuery`
diretamente e, às vezes, usará `SafeArea`,
que usa `MediaQuery` nos bastidores.

`MediaQuery` fornece muitas informações,
incluindo o tamanho atual da janela do aplicativo.
Ele expõe configurações de acessibilidade como modo de alto contraste
e dimensionamento de texto, ou se o usuário está usando um serviço de acessibilidade
como TalkBack ou VoiceOver.
`MediaQuery` também contém informações sobre os recursos
da tela do seu dispositivo, como ter uma dobradiça ou uma dobra.

`SafeArea` usa os dados de `MediaQuery` para descobrir
quanto inserir seu `Widget` filho.
Especificamente, ele usa a propriedade de padding do `MediaQuery`,
que é basicamente a quantidade da tela que está
parcialmente obscurecida pela UI do sistema, recortes da tela ou barra de status.

Então, por que não usar `MediaQuery` diretamente?

A resposta é que `SafeArea` faz uma coisa inteligente
que torna benéfico usá-lo em vez de apenas `MediaQueryData` bruto.
Especificamente, ele modifica o `MediaQuery` exposto
aos filhos de `SafeArea` para fazer parecer que o
padding adicionado ao `SafeArea` não existe.
Isso significa que você pode aninhar `SafeArea`s,
e apenas o mais alto aplicará o padding
necessário para evitar os entalhes como UI do sistema.

À medida que seu aplicativo cresce e você move os widgets,
você não precisa se preocupar em ter muito
padding aplicado se tiver vários `SafeArea`s,
enquanto você teria problemas se usasse
`MediaQueryData.padding` diretamente.

Você _pode_ envolver o corpo de um widget `Scaffold`
com um `SafeArea`, mas você não _precisa_ colocá-lo tão alto
na árvore de widgets.
O `SafeArea` só precisa envolver o conteúdo
que causaria perda de informações se fosse cortado pelos
recursos de hardware mencionados anteriormente.

Por exemplo, se você deseja propositalmente que seu aplicativo se estenda
sob os recortes, você pode mover o `SafeArea` para envolver
qualquer conteúdo que faça sentido,
e deixar o resto do aplicativo ocupar a tela inteira.
Uma observação é que isso é o que o widget `AppBar`
faz por padrão, que é como ele fica sob a
barra de status do sistema. É também por isso que envolver o corpo
de um `Scaffold` em um `SafeArea` é recomendado,
em vez de envolver todo o `Scaffold` em si.

`SafeArea` garante que o conteúdo do seu aplicativo não seja
cortado de forma genérica e prepara seu aplicativo
para o sucesso mesmo quando novos dispositivos com diferentes
formatos e estilos de recortes entrarem no mercado.
