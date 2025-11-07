---
ia-translate: true
title: Usar a visualização Network
description: Como usar a visualização de rede do DevTools.
---

:::note
A visualização de rede funciona com todas as aplicações Flutter e Dart.
:::

## O que é?

A visualização de rede permite que você inspecione tráfego HTTP, HTTPS e web socket da
sua aplicação Dart ou Flutter.

![Screenshot of the network screen](/assets/images/docs/tools/devtools/network_screenshot.png){:width="100%"}

## Como usar

O tráfego de rede deve estar gravando por padrão quando você abre a página Network.
Se não estiver, clique no botão **Resume** no canto superior esquerdo para
começar a monitorar.

Selecione uma requisição de rede da tabela (esquerda) para visualizar detalhes (direita). Você pode
inspecionar informações gerais e de timing sobre a requisição, bem como o conteúdo
de cabeçalhos e corpos de resposta e requisição.

### Busca e filtragem

Você pode usar os controles de busca e filtro para encontrar uma requisição específica ou filtrar
requisições fora da tabela de requisições.

![Screenshot of the network screen](/assets/images/docs/tools/devtools/network_search_and_filter.png)

Para aplicar um filtro, pressione o botão de filtro (à direita da barra de pesquisa). Você verá
um diálogo de filtro aparecer:

![Screenshot of the network screen](/assets/images/docs/tools/devtools/network_filter_dialog.png)

A sintaxe de consulta de filtro é descrita no diálogo. Você pode filtrar requisições
de rede pelas seguintes chaves:
* `method`, `m`: este filtro corresponde ao valor na coluna "Method"
* `status`, `s`: este filtro corresponde ao valor na coluna "Status"
* `type`, `t`: este filtro corresponde ao valor na coluna "Type"

Qualquer texto que não esteja pareado com uma chave de filtro disponível será consultado contra
todas as categorias (method, uri, status, type).

Exemplos de consultas de filtro:

```plaintext
my-endpoint m:get t:json s:200
```

```plaintext
https s:404
```

### Gravando requisições de rede na inicialização do app

Para gravar tráfego de rede na inicialização do app, você pode iniciar seu app em um estado
pausado e então começar a gravar tráfego de rede no DevTools
antes de retomar seu app.

1. Inicie seu app em um estado pausado:
    * `flutter run --start-paused ...`
    * `dart run --pause-isolates-on-start --observe ...`
2. Abra DevTools da IDE onde você iniciou seu app, ou do link que
   foi impresso na linha de comando se você iniciou seu app pela CLI.
3. Navegue para a tela Network e certifique-se de que a gravação começou.
4. Retome seu app.
   ![Screenshot of the app resumption experience on the Network screen](/assets/images/docs/tools/devtools/network_startup_resume.png){:width="100%"}
5. O profiler Network agora gravará todo o tráfego de rede do seu app,
   incluindo tráfego da inicialização do app.

## Outros recursos

Requisições HTTP e HTTPs também são exibidas na [Timeline][timeline] como
eventos de timeline assíncronos. Visualizar atividade de rede na timeline pode ser
útil se você quiser ver como o tráfego HTTP se alinha com outros eventos acontecendo
no seu app ou no framework Flutter.

Para aprender como monitorar o tráfego de rede de um app e inspecionar
diferentes tipos de requisições usando DevTools,
confira um [tutorial guiado da Network View][network-tutorial].
O tutorial também usa a visualização para identificar atividade de rede que
causa performance ruim do app.

[timeline]: /tools/devtools/performance#timeline-events-tab
[network-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-network-view-part-4-of-8-afce2463687c
