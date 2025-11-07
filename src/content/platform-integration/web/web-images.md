---
ia-translate: true
title: Exibir imagens na web
short-title: Imagens web
description: Aprenda como carregar e exibir imagens na web.
---

A web suporta o widget padrão [`Image`][] e a mais
avançada classe [`dart:ui/Image`][] (onde é necessário controle
mais refinado para exibir imagens).
No entanto, como os web browsers são construídos para executar código não confiável com segurança,
há certas limitações no que você pode fazer com imagens comparado
às plataformas mobile e desktop. Esta página explica essas limitações
e oferece maneiras de contorná-las.

[`Image`]: {{site.api}}/flutter/widgets/Image-class.html
[`dart:ui/Image`]: {{site.api}}/flutter/dart-ui/Image-class.html

:::note
Para informações sobre como otimizar a velocidade de carregamento web,
confira o artigo (gratuito) no Medium,
[Melhores práticas para otimizar a velocidade de carregamento do Flutter web][article].

[article]: {{site.flutter-medium}}/best-practices-for-optimizing-flutter-web-loading-speed-7cc0df14ce5c
:::

## Background

A web oferece vários métodos para exibir imagens:

- Os elementos HTML nativos [`<img>`][] e [`<picture>`][]
- O método [`drawImage`][] no elemento [`<canvas>`][]
- Codec de imagem customizado que renderiza para um canvas WebGL

Cada opção tem seus próprios benefícios e desvantagens.
Por exemplo, os elementos nativos se encaixam bem entre
outros elementos HTML, e eles automaticamente aproveitam
o cache do browser, e otimização de imagem integrada e
gerenciamento de memória.
Eles permitem que você exiba imagens de fontes arbitrárias
com segurança (mais sobre isso na seção CORS abaixo).
`drawImage` é ótimo quando a imagem deve se encaixar dentro de
outro conteúdo renderizado usando o elemento `<canvas>`.
Você também ganha controle sobre o dimensionamento da imagem e,
quando a política CORS permite, ler os pixels
da imagem de volta para processamento adicional.
Finalmente, WebGL oferece o maior grau de
controle sobre a imagem. Você não só pode ler os pixels e
aplicar algoritmos de imagem customizados, mas também pode usar GLSL para
aceleração por hardware.

[`<img>`]: https://developer.mozilla.org/docs/Web/HTML/Element/img
[`<picture>`]: https://developer.mozilla.org/docs/Web/HTML/Element/picture
[`drawImage`]: https://developer.mozilla.org/docs/Web/API/CanvasRenderingContext2D/drawImage
[`<canvas>`]: https://developer.mozilla.org/docs/Web/HTML/Element/canvas

## Cross-Origin Resource Sharing (CORS)

[CORS][] é um mecanismo que os browsers usam para controlar como
um site acessa os recursos de outro site. É
projetado de tal forma que, por padrão, um web-site não é
permitido fazer requisições HTTP para outro site usando
[XHR][] ou [`fetch`][].
Isso previne que scripts em outro site ajam em
nome do usuário e ganhem acesso aos
recursos de outro site sem permissão.

Na web, Flutter renderiza apps usando os renderizadores CanvasKit
ou skwasm (ao usar Wasm). Ambos dependem
de WebGL. WebGL requer acesso aos dados brutos da imagem
(bytes) para ser capaz de renderizar a imagem.
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

### Imagens em memória, asset e de rede same-origin

Se o app tem os bytes da imagem codificada em memória,
fornecida como um [asset][], ou armazenada no
mesmo servidor que serve a aplicação
(também conhecido como _same-origin_), nenhum esforço extra é necessário.
A imagem pode ser exibida usando
[`Image.memory`][], [`Image.asset`][], ou [`Image.network`][].

[asset]: /ui/assets/assets-and-images
[`Image.memory`]: {{site.api}}/flutter/widgets/Image/Image.memory.html
[`Image.asset`]: {{site.api}}/flutter/widgets/Image/Image.asset.html
[`Image.network`]: {{site.api}}/flutter/widgets/Image/Image.network.html

### Hospede imagens em um CDN habilitado para CORS

Tipicamente, redes de distribuição de conteúdo (CDN)
podem ser configuradas para personalizar quais domínios
têm permissão para acessar seu conteúdo.
Por exemplo, o Firebase site hosting permite
[especificar um][custom-header] header `Access-Control-Allow-Origin`
customizado no arquivo `firebase.json`.

[custom-header]: {{site.firebase}}/docs/hosting/full-config#headers

### Use um proxy CORS se você não tem controle sobre o servidor de origem

Se o servidor de imagens não pode ser configurado para permitir requisições CORS
da sua aplicação,
você ainda pode conseguir carregar imagens fazendo proxy
das requisições através de outro servidor. Isso requer que o
servidor intermediário tenha acesso suficiente para carregar as imagens.

Este método pode ser usado em situações quando o servidor de
imagens original serve imagens publicamente,
mas não está configurado com os headers CORS corretos.

Exemplos:

* Usando [CloudFlare Workers][].
* Usando [Firebase Functions][].

[CloudFlare Workers]: https://developers.cloudflare.com/workers/examples/cors-header-proxy
[Firebase Functions]: {{site.github}}/7kfpun/cors-proxy

### Use uma HTML platform view

Se nenhuma das outras soluções funcionar para seu app, Flutter
suporta incorporar HTML bruto dentro do app usando
[`HtmlElementView`][]. Use-o para criar um elemento `<img>`
para renderizar a imagem de outro domínio.

[`HtmlElementView`]: {{site.api}}/flutter/widgets/HtmlElementView-class.html
