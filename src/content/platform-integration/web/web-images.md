---
ia-translate: true
title: Exibir imagens na web
short-title: Imagens na web
description: Aprenda como carregar e exibir imagens na web.
---

A web suporta o widget padrão [`Image`][] e a classe mais avançada [`dart:ui/Image`][] (onde é necessário um controle mais preciso para exibir imagens). No entanto, como os navegadores da web são construídos para executar código não confiável com segurança, existem certas limitações no que você pode fazer com imagens em comparação com plataformas móveis e desktop. Esta página explica essas limitações e oferece maneiras de contorná-las.

[`Image`]: {{site.api}}/flutter/widgets/Image-class.html
[`dart:ui/Image`]: {{site.api}}/flutter/dart-ui/Image-class.html

:::note
Para obter informações sobre como otimizar a velocidade de carregamento da web, confira o artigo (gratuito) no Medium,
[Best practices for optimizing Flutter web loading speed][article].

[article]: {{site.flutter-medium}}/best-practices-for-optimizing-flutter-web-loading-speed-7cc0df14ce5c
:::

## Plano de fundo

A web oferece vários métodos para exibir imagens:

- Os elementos HTML integrados [`<img>`][] e [`<picture>`][]
- O método [`drawImage`][] no elemento [`<canvas>`][]
- Codec de imagem personalizado que renderiza para um canvas WebGL

Cada opção tem seus próprios benefícios e desvantagens. Por exemplo, os elementos integrados se encaixam bem entre outros elementos HTML, e eles aproveitam automaticamente o cache do navegador e a otimização de imagem e gerenciamento de memória integrados. Eles permitem que você exiba imagens com segurança de fontes arbitrárias (mais sobre isso na seção CORS abaixo). `drawImage` é ótimo quando a imagem deve se encaixar em outro conteúdo renderizado usando o elemento `<canvas>`. Você também ganha controle sobre o dimensionamento da imagem e, quando a política CORS permite, lê os pixels da imagem de volta para processamento posterior. Finalmente, o WebGL oferece o maior grau de controle sobre a imagem. Você não só pode ler os pixels e aplicar algoritmos de imagem personalizados, mas também pode usar GLSL para aceleração de hardware.

[`<img>`]: https://developer.mozilla.org/docs/Web/HTML/Element/img
[`<picture>`]: https://developer.mozilla.org/docs/Web/HTML/Element/picture
[`drawImage`]: https://developer.mozilla.org/docs/Web/API/CanvasRenderingContext2D/drawImage
[`<canvas>`]: https://developer.mozilla.org/docs/Web/HTML/Element/canvas

## Compartilhamento de recursos de origem cruzada (CORS)

[CORS][] é um mecanismo que os navegadores usam para controlar como um site acessa os recursos de outro site. Ele é projetado de forma que, por padrão, um site não tenha permissão para fazer solicitações HTTP para outro site usando [XHR][] ou [`fetch`][]. Isso impede que scripts em outro site atuem em nome do usuário e obtenham acesso aos recursos de outro site sem permissão.

Na web, o Flutter renderiza aplicativos usando os renderizadores CanvasKit ou skwasm (ao usar Wasm). Ambos dependem do WebGL. O WebGL requer acesso aos dados brutos da imagem (bytes) para poder renderizar a imagem. Portanto, as imagens devem vir apenas de servidores que tenham uma política CORS configurada para funcionar com o domínio que atende seu aplicativo.

:::note
Para obter mais informações sobre renderizadores da web, consulte [Web renderers][].
:::

[CORS]: https://developer.mozilla.org/docs/Web/HTTP/CORS
[XHR]: https://developer.mozilla.org/docs/Web/API/XMLHttpRequest
[`fetch`]: https://developer.mozilla.org/docs/Web/API/Fetch_API/Using_Fetch
[Web renderers]: /platform-integration/web/renderers

## Soluções

Existem várias soluções para contornar as restrições CORS no Flutter.

### Imagens em memória, assets e de rede de mesma origem

Se o aplicativo tiver os bytes da imagem codificada na memória, fornecidos como um [asset][], ou armazenados no mesmo servidor que atende o aplicativo (também conhecido como _mesma origem_), nenhum esforço extra é necessário. A imagem pode ser exibida usando [`Image.memory`][], [`Image.asset`][], ou [`Image.network`][].

[asset]: /ui/assets/assets-and-images
[`Image.memory`]: {{site.api}}/flutter/widgets/Image/Image.memory.html
[`Image.asset`]: {{site.api}}/flutter/widgets/Image/Image.asset.html
[`Image.network`]: {{site.api}}/flutter/widgets/Image/Image.network.html

### Hospede imagens em um CDN habilitado para CORS

Normalmente, as redes de entrega de conteúdo (CDN) podem ser configuradas para personalizar quais domínios podem acessar seu conteúdo. Por exemplo, a hospedagem de sites do Firebase permite [especificar um cabeçalho][custom-header] `Access-Control-Allow-Origin` personalizado no arquivo `firebase.json`.

[custom-header]: {{site.firebase}}/docs/hosting/full-config#headers

### Use um proxy CORS se você não tiver controle sobre o servidor de origem

Se o servidor de imagem não puder ser configurado para permitir solicitações CORS do seu aplicativo, você ainda poderá carregar imagens fazendo proxy das solicitações por meio de outro servidor. Isso exige que o servidor intermediário tenha acesso suficiente para carregar as imagens.

Este método pode ser usado em situações em que o servidor de imagem original serve imagens publicamente, mas não está configurado com os cabeçalhos CORS corretos.

Exemplos:

* Usando [CloudFlare Workers][].
* Usando [Firebase Functions][].

[CloudFlare Workers]: https://developers.cloudflare.com/workers/examples/cors-header-proxy
[Firebase Functions]: {{site.github}}/7kfpun/cors-proxy

### Use uma visualização de plataforma HTML

Se nenhuma das outras soluções funcionar para o seu aplicativo, o Flutter oferece suporte à incorporação de HTML bruto dentro do aplicativo usando [`HtmlElementView`][]. Use-o para criar um elemento `<img>` para renderizar a imagem de outro domínio.

[`HtmlElementView`]: {{site.api}}/flutter/widgets/HtmlElementView-class.html
