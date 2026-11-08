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
Você pode corrigir isso com o widget [`SafeArea`][`SafeArea`],
que insere seu widget filho para evitar intrusões
(como notches e recortes de câmera),
bem como a UI do sistema operacional
(como a barra de status no Android),
ou por cantos arredondados da tela física.

Se você não quer esse comportamento,
o widget `SafeArea` permite desabilitar
o padding em qualquer um de seus quatro lados.
Por padrão, todos os quatro lados estão habilitados.

É geralmente recomendado envolver o body de um
widget `Scaffold` em `SafeArea` como um bom ponto de partida,
mas você nem sempre precisa colocá-lo tão alto na
árvore de `Widget`.

Por exemplo, se você intencionalmente quer que seu app se estenda
sob os recortes, você pode mover o `SafeArea` para envolver
qualquer conteúdo que faça sentido,
e deixar o resto do app ocupar a tela cheia.

Usar `SafeArea` garante que o conteúdo do seu app não seja
cortado por recursos físicos da tela ou UI do sistema operacional,
e prepara seu app para o sucesso mesmo quando novos dispositivos com
diferentes formas e estilos de recortes entram no mercado.

Como o `SafeArea` faz tanto em uma pequena quantidade de código?
Por trás das cenas, ele usa o objeto `MediaQuery`.

[`SafeArea`]: {{site.api}}/flutter/widgets/SafeArea-class.html

## MediaQuery

Como discutido na seção [SafeArea](#safearea),
`MediaQuery` é um widget poderoso para criar
apps adaptativos. Às vezes você usará `MediaQuery`
diretamente, e às vezes usará `SafeArea`,
que usa `MediaQuery` por trás das cenas.

`MediaQuery` fornece muitas informações,
incluindo o tamanho atual da janela do app.
Ele expõe configurações de acessibilidade como modo de alto contraste
e escala de texto, ou se o usuário está usando um serviço
de acessibilidade como TalkBack ou VoiceOver.
`MediaQuery` também contém informações sobre os recursos
da tela do seu dispositivo, como ter uma dobradiça ou uma dobra.

`SafeArea` usa os dados do `MediaQuery` para descobrir
quanto inserir seu `Widget` filho.
Especificamente, ele usa a propriedade padding do `MediaQuery`,
que é basicamente a quantidade da tela que está
parcialmente obscurecida pela UI do sistema, notches da tela ou barra de status.

Então, por que não usar `MediaQuery` diretamente?

A resposta é que `SafeArea` faz uma coisa inteligente
que torna benéfico usá-lo em vez de apenas `MediaQueryData` bruto.
Especificamente, ele modifica o `MediaQuery` exposto
aos filhos do `SafeArea` para fazer parecer que o
padding adicionado ao `SafeArea` não existe.
Isso significa que você pode aninhar `SafeArea`s,
e apenas o mais externo aplicará o padding
necessário para evitar os notches e UI do sistema.

Conforme seu app cresce e você move widgets,
você não precisa se preocupar em ter muito
padding aplicado se tiver múltiplos `SafeArea`s,
enquanto teria problemas se usasse
`MediaQueryData.padding` diretamente.

Você _pode_ envolver o body de um widget `Scaffold`
com um `SafeArea`, mas você não _precisa_ colocá-lo tão alto
na árvore de widgets.
O `SafeArea` apenas precisa envolver os conteúdos
que causariam perda de informação se cortados pelos
recursos de hardware mencionados anteriormente.

Por exemplo, se você intencionalmente quer que seu app se estenda
sob os recortes, você pode mover o `SafeArea` para envolver
qualquer conteúdo que faça sentido,
e deixar o resto do app ocupar a tela cheia.
Uma observação lateral é que isso é o que o widget `AppBar`
faz por padrão, que é como ele fica por baixo da
barra de status do sistema. É também por isso que envolver o body
de um `Scaffold` em um `SafeArea` é recomendado,
em vez de envolver todo o `Scaffold` em si.

`SafeArea` garante que o conteúdo do seu app não seja
cortado de forma genérica e prepara seu app
para o sucesso mesmo quando novos dispositivos com diferentes
formas e estilos de recortes entram no mercado.
