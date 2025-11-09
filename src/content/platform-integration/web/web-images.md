---
ia-translate: true
title: Exibir imagens na web
shortTitle: Imagens web
description: Aprenda como carregar e exibir imagens na web.
---

A web suporta o widget [`Image`][`Image`] padrão e a
classe [`dart:ui/Image`][`dart:ui/Image`] mais avançada (onde um controle
mais refinado é necessário para exibir imagens).
No entanto, como os navegadores web são construídos para executar código não confiável com segurança,
existem certas limitações no que você pode fazer com imagens em comparação
com plataformas mobile e desktop. Esta página explica essas limitações
e oferece maneiras de contorná-las.

[`Image`]: {{site.api}}/flutter/widgets/Image-class.html
[`dart:ui/Image`]: {{site.api}}/flutter/dart-ui/Image-class.html

:::note
Para informações sobre como otimizar a velocidade de carregamento web,
confira o artigo (gratuito) no Medium,
[Melhores práticas para otimizar a velocidade de carregamento do Flutter web][article].

[article]: {{site.flutter-blog}}/best-practices-for-optimizing-flutter-web-loading-speed-7cc0df14ce5c
:::

## Contexto

A web oferece vários métodos para exibir imagens:

- Os elementos HTML integrados [`<img>`][`<img>`] e [`<picture>`][`<picture>`]
- O método [`drawImage`][`drawImage`] no elemento [`<canvas>`][`<canvas>`]
- Codec de imagem personalizado que renderiza para um canvas WebGL

Cada opção tem seus próprios benefícios e desvantagens.
Por exemplo, os elementos integrados se encaixam bem entre
outros elementos HTML, e automaticamente aproveitam
o cache do navegador e a otimização de imagem integrada
e gerenciamento de memória.
Eles permitem que você exiba imagens com segurança de fontes arbitrárias
(mais sobre isso na seção CORS abaixo).
`drawImage` é ótimo quando a imagem deve se encaixar dentro de
outro conteúdo renderizado usando o elemento `<canvas>`.
Você também ganha controle sobre o dimensionamento da imagem e,
quando a política CORS permite, ler os pixels
da imagem de volta para processamento adicional.
Finalmente, WebGL oferece o mais alto grau de
controle sobre a imagem. Você não apenas pode ler os pixels e
aplicar algoritmos de imagem personalizados, mas também pode usar GLSL para
aceleração de hardware.

[`<img>`]: https://developer.mozilla.org/docs/Web/HTML/Element/img
[`<picture>`]: https://developer.mozilla.org/docs/Web/HTML/Element/picture
[`drawImage`]: https://developer.mozilla.org/docs/Web/API/CanvasRenderingContext2D/drawImage
[`<canvas>`]: https://developer.mozilla.org/docs/Web/HTML/Element/canvas

## Cross-Origin Resource Sharing (CORS)

[CORS][CORS] é um mecanismo que os navegadores usam para controlar como
um site acessa os recursos de outro site. Ele é
projetado de forma que, por padrão, um site web não é
permitido fazer requisições HTTP para outro site usando
[XHR][XHR] ou [`fetch`][`fetch`].
Isso impede que scripts em outro site ajam em
nome do usuário e ganhem acesso aos
recursos de outro site sem permissão.

Na web, o Flutter renderiza apps usando os renderizadores
CanvasKit ou skwasm (ao usar Wasm). Ambos dependem
do WebGL. WebGL requer acesso aos dados brutos da imagem
(bytes) para poder renderizar a imagem.
Portanto, as imagens devem vir apenas de servidores que
tenham uma política CORS configurada para funcionar com o domínio
que serve sua aplicação.

:::note
Para mais informações sobre renderizadores web, consulte
[Renderizadores web][Web renderers].
:::

[CORS]: https://developer.mozilla.org/docs/Web/HTTP/CORS
[XHR]: https://developer.mozilla.org/docs/Web/API/XMLHttpRequest
[`fetch`]: https://developer.mozilla.org/docs/Web/API/Fetch_API/Using_Fetch
[Web renderers]: /platform-integration/web/renderers

## Soluções

Existem múltiplas soluções para contornar as restrições CORS
no Flutter.

### Imagens em memória, de assets e de rede same-origin

Se o app tem os bytes da imagem codificada na memória,
fornecidos como um [asset][asset], ou armazenados no
mesmo servidor que serve a aplicação
(também conhecido como _same-origin_), nenhum esforço extra é necessário.
A imagem pode ser exibida usando
[`Image.memory`][`Image.memory`], [`Image.asset`][`Image.asset`], ou [`Image.network`][`Image.network`].

[asset]: /ui/assets/assets-and-images
[`Image.memory`]: {{site.api}}/flutter/widgets/Image/Image.memory.html
[`Image.asset`]: {{site.api}}/flutter/widgets/Image/Image.asset.html
[`Image.network`]: {{site.api}}/flutter/widgets/Image/Image.network.html

### Hospedar imagens em uma CDN habilitada para CORS

Tipicamente, redes de entrega de conteúdo (CDN)
podem ser configuradas para personalizar quais domínios
têm permissão para acessar seu conteúdo.
Por exemplo, o Firebase site hosting permite
[especificar um][custom-header] header `Access-Control-Allow-Origin`
personalizado no arquivo `firebase.json`.

[custom-header]: {{site.firebase}}/docs/hosting/full-config#headers

### Use um proxy CORS se você não tem controle sobre o servidor de origem

Se o servidor de imagem não pode ser configurado para permitir requisições CORS
da sua aplicação,
você ainda pode conseguir carregar imagens fazendo proxy
das requisições através de outro servidor. Isso requer que o
servidor intermediário tenha acesso suficiente para carregar as imagens.

Este método pode ser usado em situações quando o
servidor de imagens original serve imagens publicamente,
mas não está configurado com os headers CORS corretos.

Exemplos:

* Usando [CloudFlare Workers][CloudFlare Workers].
* Usando [Firebase Functions][Firebase Functions].

[CloudFlare Workers]: https://developers.cloudflare.com/workers/examples/cors-header-proxy
[Firebase Functions]: {{site.github}}/7kfpun/cors-proxy

### Use uma view de plataforma HTML

Se nenhuma das outras soluções funcionar para seu app, Flutter
suporta incorporar HTML bruto dentro do app usando
[`HtmlElementView`][`HtmlElementView`]. Use-o para criar um elemento `<img>`
para renderizar a imagem de outro domínio.

[`HtmlElementView`]: {{site.api}}/flutter/widgets/HtmlElementView-class.html
