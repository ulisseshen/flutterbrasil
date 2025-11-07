---
ia-translate: true
title: Networking e dados
description: Aprenda como adicionar networking ao seu app Flutter.
prev:
  title: Handling user input
  path: /get-started/fundamentals/user-input
next:
  title: Local data and caching
  path: /get-started/fundamentals/local-caching
---

Embora se diga que "nenhum homem é uma ilha",
um app Flutter sem qualquer capacidade de networking
pode parecer um tanto desconectado.
Esta página cobre como adicionar recursos de networking
ao seu app Flutter. Seu app irá recuperar dados,
analisar JSON em representações utilizáveis na memória,
e então enviar dados novamente.

## Introdução à recuperação de dados pela rede

No mais simples, assumindo que você utilize o pacote [`http`][]
para adaptar às diferenças entre acesso à rede
de plataformas baseadas em Dart VM e ambientes baseados em navegadores web,
fazer uma requisição HTTP `GET` pode ser tão simples quanto o seguinte:

```dart
import 'package:http/http.dart' as http;

void main() async {
  var response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
  );
  print(response.body);
}
```

Os dois tutoriais a seguir mostram todos os detalhes
envolvidos em adicionar o pacote [`http`][] ao seu app,
seja você rodando no Android,
iOS, dentro de um navegador web, ou nativamente no Windows,
macOS ou Linux.
O primeiro tutorial mostra como fazer uma
requisição `GET` não autenticada a um site,
analisar os dados recuperados como `JSON` e então
exibir os dados resultantes. O segundo tutorial
constrói sobre o primeiro adicionando cabeçalhos de autenticação,
habilitando acesso a servidores web que requerem autorização.
O artigo da Mozilla Developer Network (MDN)
fornece mais contexto sobre como a autorização funciona na web.

* Tutorial: [Fetch data from the internet][]
* Tutorial: [Make authenticated requests][]
* Artigo: [MDN's article on Authorization for websites][]

## Tornando os dados recuperados da rede úteis

Uma vez que você recupera dados da rede,
você precisa de uma forma de converter os dados da rede
em algo com o qual você possa trabalhar facilmente em Dart.
Os tutoriais na seção anterior usaram Dart manual
para converter dados de rede em uma representação na memória.
Nesta seção,
você verá outras opções para lidar com esta conversão.
O primeiro link é para um vídeo do YouTube mostrando uma visão geral
do [pacote `freezed`][`freezed` package].
O segundo link é para um codelab que cobre patterns
e records usando um estudo de caso de análise de JSON.

* Vídeo do YouTube: [Freezed (Package of the Week)][]
* Codelab: [Dive into Dart's patterns and records][]

## Indo em ambas as direções, enviando dados novamente

Agora que você dominou a arte de recuperar dados,
é hora de olhar para enviar dados.
Esta informação começa com o envio de dados para a rede,
mas então mergulha na assincronia. A verdade é,
uma vez que você está em uma conversa pela rede,
você precisará lidar com o fato de que servidores web
que estão fisicamente distantes podem demorar um pouco para responder,
e você não pode parar de renderizar na tela
enquanto espera pelos pacotes fazerem o round trip.
Dart tem ótimo suporte para assincronia,
assim como Flutter.
Você aprenderá tudo sobre o suporte do Dart em um tutorial,
então verá a capacidade do Flutter coberta em um
vídeo Widget of the Week.
Uma vez que você completar isso, você aprenderá como depurar
tráfego de rede usando a Network View do DevTools.

* Tutorial: [Send data to the internet][]
* Tutorial: [Asynchronous programming: futures, async, await][]
* Vídeo do YouTube: [FutureBuilder (Widget of the Week)][]
* Artigo: [Using the Network View][]

## Material de extensão

Agora que você dominou o uso das APIs de networking do Flutter,
ajuda ver o uso de rede do Flutter em contexto.
O primeiro codelab (ostensivamente sobre criar apps Adaptativos no Flutter),
usa um servidor web escrito em Dart para contornar as
[restrições de Cross-Origin Resource Sharing (CORS)][Cross-Origin Resource Sharing (CORS) restrictions] dos navegadores web.

:::note
Se você já trabalhou através deste codelab
na página de [layout][], sinta-se à vontade para pular este passo.
:::

[layout]: /get-started/fundamentals/layout

A seguir, um vídeo longo do YouTube onde
Fitz, ex-integrante do Flutter DevRel,
fala sobre como a localização dos dados importa para apps Flutter.
Finalmente, uma série realmente útil de artigos da Flutter GDE
Anna (Domashych) Leushchenko cobrindo networking avançado no Flutter.

* Codelab: [Adaptive apps in Flutter][]
* Vídeo: [Keeping it local: Managing a Flutter app's data][]
* Série de artigos: [Basic and advanced networking in Dart and Flutter][]


[Adaptive apps in Flutter]: {{site.codelabs}}/codelabs/flutter-adaptive-app
[Asynchronous programming: futures, async, await]: {{site.dart-site}}/codelabs/async-await
[Basic and advanced networking in Dart and Flutter]: {{site.medium}}/tide-engineering-team/basic-and-advanced-networking-in-dart-and-flutter-the-tide-way-part-0-introduction-33ac040a4a1c
[Cross-Origin Resource Sharing (CORS) restrictions]: https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS
[Dive into Dart's patterns and records]: {{site.codelabs}}/codelabs/dart-patterns-records
[Fetch data from the internet]: /cookbook/networking/fetch-data
[Freezed (Package of the Week)]: {{site.youtube-site}}/watch?v=RaThk0fiphA
[`freezed` package]: {{site.pub-pkg}}/freezed
[FutureBuilder (Widget of the Week)]: {{site.youtube-site}}/watch?v=zEdw_1B7JHY
[`http`]: {{site.pub-pkg}}/http
[HTTP]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview
[Keeping it local: Managing a Flutter app's data]: {{site.youtube-site}}/watch?v=uCbHxLA9t9E
[Make authenticated requests]: /cookbook/networking/authenticated-requests
[MDN's article on Authorization for websites]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Authorization
[Using the Network View]: /tools/devtools/network
[Send data to the internet]: /cookbook/networking/send-data

## Feedback

À medida que esta seção do site evolui,
[recebemos bem seu feedback][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="networking"
