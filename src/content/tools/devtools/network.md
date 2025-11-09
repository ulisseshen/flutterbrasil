---
ia-translate: true
title: Use a View de Network
description: Como usar a view de network do DevTools.
---

:::note
A view de network funciona com todas as aplicações Flutter e Dart.
:::

## O que é isso?

A view de network permite inspecionar tráfego HTTP, HTTPS e WebSocket do
seu aplicativo Dart ou Flutter.

![Screenshot of the network screen](/assets/images/docs/tools/devtools/network_screenshot.png){:width="100%"}

## Qual tráfego de rede é registrado?

Todo o tráfego de rede que se origina do `dart:io` (como a
classe [`HttpClient`][HttpClient]) é registrado, incluindo o package [`dio`][dio].
Além disso, todo o tráfego de rede que é registrado usando o
package [`http_profile`][http_profile] é gravado na tabela de
requisições de rede. Isso inclui tráfego de rede dos
packages [`cupertino_http`][cupertino_http], [`cronet_http`][cronet_http], e
[`ok_http`][ok_http].

Para um app web que faz requisições usando o navegador, recomendamos usar
ferramentas do navegador para inspecionar o tráfego de rede, como [Chrome DevTools][Chrome DevTools].

## Como usar

Quando você abre a página Network, DevTools imediatamente começa a gravar tráfego
de rede. Para pausar e retomar a gravação, use os botões **Pause** e **Resume**
(canto superior esquerdo).

Quando uma requisição de rede é enviada pelo seu app, ela aparece na tabela de
requisições de rede (esquerda). Ela é listada como "Pending" até que uma resposta
completa seja recebida.

Selecione uma requisição de rede da tabela (esquerda) para ver detalhes (direita). Você pode
inspecionar informações gerais e de tempo sobre a requisição, bem como o conteúdo
dos headers e bodies de resposta e requisição. Alguns dados não estão disponíveis até que
a resposta seja recebida.

### Pesquisa e filtragem

Você pode usar os controles de pesquisa e filtro para encontrar uma requisição específica ou filtrar
requisições da tabela de requisições.

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
todas as categorias (method, URI, status, type).

Exemplos de consultas de filtro:

```plaintext
my-endpoint m:get t:json s:200
```

```plaintext
https s:404
```

### Gravando requisições de rede na inicialização do app

Para gravar o tráfego de rede na inicialização do app, você pode iniciar seu app em um estado
pausado, e então começar a gravar o tráfego de rede no DevTools
antes de retomar seu app.

1. Inicie seu app em um estado pausado:
    * `flutter run --start-paused ...`
    * `dart run --pause-isolates-on-start --observe ...`
2. Abra DevTools da IDE onde você iniciou seu app, ou do link que
   foi impresso na linha de comando se você iniciou seu app da CLI.
3. Navegue até a tela Network e certifique-se de que a gravação foi iniciada.
4. Retome seu app.
   ![Screenshot of the app resumption experience on the Network screen](/assets/images/docs/tools/devtools/network_startup_resume.png){:width="100%"}
5. O profiler de Network agora gravará todo o tráfego de rede do seu app,
   incluindo tráfego da inicialização do app.

## Outros recursos

Requisições HTTP e HTTPS também aparecem no [`Timeline`][timeline] como
eventos de timeline assíncronos. Visualizar a atividade de rede na timeline pode ser
útil se você quiser ver como o tráfego HTTP se alinha com outros eventos acontecendo
no seu app ou no framework Flutter.

Para aprender como monitorar o tráfego de rede de um app e inspecionar
diferentes tipos de requisições usando DevTools,
confira um [tutorial guiado da View de Network][network-tutorial].
O tutorial também usa a view para identificar atividade de rede que
causa mau desempenho do app.

[HttpClient]: {{site.api}}/dart-io/HttpClient-class.html
[dio]: https://pub.dev/packages/dio
[http_profile]: {{site.pub-pkg}}/http_profile
[cupertino_http]: {{site.pub-pkg}}/cupertino_http
[cronet_http]: {{site.pub-pkg}}/cronet_http
[ok_http]: {{site.pub-pkg}}/ok_http
[Chrome DevTools]: https://developer.chrome.com/docs/devtools/network
[timeline]: /tools/devtools/performance#timeline-events-tab
[network-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-network-view-part-4-of-8-afce2463687c
