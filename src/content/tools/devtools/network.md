---
ia-translate: true
title: Use a Visão de Rede
description: Como usar a visão de rede do DevTools.
---

:::note
A visão de rede funciona com todos os aplicativos Flutter e Dart.
:::

## O que é isso?

A visão de rede permite que você inspecione o tráfego HTTP, HTTPS e web socket do
seu aplicativo Dart ou Flutter.

![Captura de tela da tela de rede](/assets/images/docs/tools/devtools/network_screenshot.png){:width="100%"}

## Como usar

O tráfego de rede deve estar sendo gravado por padrão quando você abre a página Rede.
Se não estiver, clique no botão **Resume** no canto superior esquerdo para
começar a sondar.

Selecione uma requisição de rede da tabela (esquerda) para visualizar os detalhes (direita). Você pode
inspecionar informações gerais e de tempo sobre a requisição, bem como o conteúdo
de resposta e cabeçalhos e corpos da requisição.

### Busca e filtragem

Você pode usar os controles de busca e filtro para encontrar uma requisição específica ou filtrar
requisições da tabela de requisições.

![Captura de tela da tela de rede](/assets/images/docs/tools/devtools/network_search_and_filter.png)

Para aplicar um filtro, pressione o botão de filtro (à direita da barra de pesquisa). Você verá
uma caixa de diálogo de filtro aparecer:

![Captura de tela da tela de rede](/assets/images/docs/tools/devtools/network_filter_dialog.png)

A sintaxe de consulta de filtro é descrita na caixa de diálogo. Você pode filtrar a rede
requisições pelas seguintes chaves:
* `method`, `m`: este filtro corresponde ao valor na coluna "Method"
* `status`, `s`: este filtro corresponde ao valor na coluna "Status"
* `type`, `t`: este filtro corresponde ao valor na coluna "Type"

Qualquer texto que não esteja emparelhado com uma chave de filtro disponível será consultado em
todas as categorias (method, uri, status, type).

Exemplo de consultas de filtro:

```plaintext
my-endpoint m:get t:json s:200
```

```plaintext
https s:404
```

### Gravando requisições de rede na inicialização do app

Para gravar o tráfego de rede na inicialização do aplicativo, você pode iniciar seu aplicativo em um estado pausado
e então começar a gravar o tráfego de rede no DevTools
antes de retomar seu aplicativo.

1. Inicie seu aplicativo em um estado pausado:
    * `flutter run --start-paused ...`
    * `dart run --pause-isolates-on-start --observe ...`
2. Abra o DevTools a partir do IDE onde você iniciou seu aplicativo, ou a partir do link que
   foi impresso na linha de comando se você iniciou seu aplicativo a partir do CLI.
3. Navegue até a tela Rede e certifique-se de que a gravação foi iniciada.
4. Retome seu aplicativo.
   ![Captura de tela da experiência de retomada do aplicativo na tela de rede](/assets/images/docs/tools/devtools/network_startup_resume.png){:width="100%"}
5. O profiler de rede agora irá gravar todo o tráfego de rede do seu aplicativo,
   incluindo o tráfego da inicialização do aplicativo.

## Outros recursos

Requisições HTTP e HTTPS também são exibidas no [Timeline][timeline] como
eventos de timeline assíncronos. Visualizar a atividade de rede no timeline pode ser
útil se você quiser ver como o tráfego HTTP se alinha com outros eventos que acontecem
no seu aplicativo ou no framework Flutter.

Para aprender como monitorar o tráfego de rede de um aplicativo e inspecionar
diferentes tipos de requisições usando o DevTools,
confira um [tutorial guiado sobre a visão de rede][network-tutorial].
O tutorial também usa a visão para identificar atividades de rede que
causam baixo desempenho do aplicativo.

[timeline]: /tools/devtools/performance#timeline-events-tab
[network-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-network-view-part-4-of-8-afce2463687c
