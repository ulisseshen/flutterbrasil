---
ia-translate: true
title: SafeArea & MediaQuery
description: >-
  Aprenda como usar SafeArea e MediaQuery
  para criar um app adaptativo.
---

Esta página discute como e quando usar os
widgets `SafeArea` e `MediaQuery`.

## SafeArea

Ao executar seu app nos dispositivos mais recentes,
você pode encontrar partes da UI sendo bloqueadas
por recortes na tela do dispositivo.
Você pode corrigir isso com o widget [`SafeArea`][],
que insere seu widget filho para evitar intrusões
(como entalhes e recortes de câmera),
bem como a UI do sistema operacional
(como a barra de status no Android),
ou pelos cantos arredondados da tela física.

Se você não quiser esse comportamento,
o widget `SafeArea` permite desabilitar
o preenchimento em qualquer um de seus quatro lados.
Por padrão, todos os quatro lados estão habilitados.

É geralmente recomendado envolver o body de um
widget `Scaffold` em `SafeArea` como um bom ponto de partida,
mas você nem sempre precisa colocá-lo tão alto na
árvore de `Widget`.

Por exemplo, se você intencionalmente quer que seu app se estenda
sob os recortes, você pode mover o `SafeArea` para envolver
qualquer conteúdo que faça sentido,
e deixar o resto do app ocupar a tela inteira.

Usar `SafeArea` garante que o conteúdo do seu app não será
cortado por recursos físicos da tela ou UI do sistema operacional,
e prepara seu app para o sucesso mesmo quando novos dispositivos com
diferentes formatos e estilos de recortes entrarem no mercado.

Como o `SafeArea` faz tanto em uma pequena quantidade de código?
Nos bastidores, ele usa o objeto `MediaQuery`.

[`SafeArea`]: {{site.api}}/flutter/widgets/SafeArea-class.html

## MediaQuery

Como discutido na seção [SafeArea](#safearea),
`MediaQuery` é um widget poderoso para criar
apps adaptativos. Às vezes você usará `MediaQuery`
diretamente, e às vezes você usará `SafeArea`,
que usa `MediaQuery` nos bastidores.

`MediaQuery` fornece muitas informações,
incluindo o tamanho atual da janela do app.
Ele expõe configurações de acessibilidade como modo de alto contraste
e escalonamento de texto, ou se o usuário está usando um serviço de acessibilidade
como TalkBack ou VoiceOver.
`MediaQuery` também contém informações sobre os recursos
da tela do seu dispositivo, como ter uma dobradiça ou dobra.

`SafeArea` usa os dados do `MediaQuery` para descobrir
quanto deve inserir seu widget filho.
Especificamente, ele usa a propriedade de padding do `MediaQuery`,
que é basicamente a quantidade da tela que está
parcialmente obscurecida pela UI do sistema, entalhes da tela ou barra de status.

Então, por que não usar `MediaQuery` diretamente?

A resposta é que `SafeArea` faz uma coisa inteligente
que o torna benéfico usar em vez de apenas `MediaQueryData` bruto.
Especificamente, ele modifica o `MediaQuery` exposto
aos filhos do `SafeArea` para fazer parecer que o
padding adicionado ao `SafeArea` não existe.
Isso significa que você pode aninhar `SafeArea`s,
e apenas o mais externo aplicará o padding
necessário para evitar os entalhes como UI do sistema.

À medida que seu app cresce e você move widgets,
você não precisa se preocupar em ter muito
padding aplicado se você tiver vários `SafeArea`s,
enquanto você teria problemas se estivesse usando
`MediaQueryData.padding` diretamente.

Você _pode_ envolver o body de um widget `Scaffold`
com um `SafeArea`, mas você não _precisa_ colocá-lo tão alto
na árvore de widgets.
O `SafeArea` apenas precisa envolver o conteúdo
que causaria perda de informação se cortado pelos
recursos de hardware mencionados anteriormente.

Por exemplo, se você intencionalmente quer que seu app se estenda
sob os recortes, você pode mover o `SafeArea` para envolver
qualquer conteúdo que faça sentido,
e deixar o resto do app ocupar a tela inteira.
Uma observação adicional é que isso é o que o widget `AppBar`
faz por padrão, que é como ele vai por baixo da
barra de status do sistema. É por isso que envolver o body
de um `Scaffold` em um `SafeArea` é recomendado,
em vez de envolver todo o `Scaffold` em si.

`SafeArea` garante que o conteúdo do seu app não será
cortado de forma genérica e prepara seu app
para o sucesso mesmo quando novos dispositivos com diferentes
formatos e estilos de recortes entrarem no mercado.
