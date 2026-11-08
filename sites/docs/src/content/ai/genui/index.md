---
ia-translate: true
title: SDK GenUI para Flutter
shortTitle: SDK GenUI
description: >-
  Aprenda a usar o SDK GenUI para Flutter para criar
  experiências mais interativas em aplicações e chatbots.
next:
  title: Principais componentes e conceitos do SDK GenUI
  path: /ai/genui/components
---

## O que é o GenUI? {:#what-is-genui}

Em sua essência, o SDK GenUI para Flutter é uma camada de orquestração.
Este conjunto de pacotes coordena o fluxo de informações entre o usuário,
seus widgets Flutter e um agente de IA,
transformando conversas baseadas em texto em experiências ricas e interativas.

Imagine que, em vez de apresentar ao usuário uma parede de texto,
ele recebe uma interface gráfica composta por, por exemplo,
uma linha de botões com rótulos e um seletor de data.

O SDK GenUI para Flutter usa um formato baseado em JSON para
compor uma UI a partir do seu catálogo de widgets existente. Conforme o usuário
interage com a UI, as mudanças de estado são enviadas de volta ao agente,
criando um ciclo de alta largura de banda e transformando
a interação com o agente em uma experiência rica e intuitiva.

O SDK GenUI para Flutter foi projetado para se integrar
facilmente à sua aplicação Flutter.

## Quando você usaria? {:#when-would-you-use-it}

Use o SDK GenUI para Flutter para incorporar uma interface gráfica
ao seu app. Por exemplo:

* Em vez de descrever uma lista de produtos em texto,
  use-o para renderizar um carrossel clicável de widgets de produto.
* Quando um usuário pede para planejar uma viagem, use-o para gerar um
  formulário completo com controles deslizantes, seletores de data e campos de texto.

Para mais contexto sobre o SDK GenUI para Flutter,
confira o [vídeo Começando com GenUI][Getting started with GenUI video]:

<YouTubeEmbed id="nWr6eZKM6no"
    title="Começando com GenUI"></YouTubeEmbed>

Também confira o vídeo Flutter + A2UI = GenUI do
Google I/O 2026!

<YouTubeEmbed id="tXeyaV1gVJk"
    title="Flutter + A2UI = GenUI"></YouTubeEmbed>

:::experimental
O pacote `genui` está em
alpha e pode mudar.
:::

[Getting started with GenUI video]: https://www.youtube.com/watch?v=nWr6eZKM6no
