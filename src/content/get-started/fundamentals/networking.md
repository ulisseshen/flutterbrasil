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

Embora seja dito que "nenhum homem é uma ilha",
um app Flutter sem qualquer capacidade de networking
pode parecer um tanto desconectado.
Esta página cobre como adicionar recursos de networking
ao seu app Flutter. Seu app irá recuperar dados,
analisar JSON em representações utilizáveis na memória,
e então enviar dados novamente.

## Introduction to retrieving data over the network

Em sua forma mais simples, assumindo que você utiliza o pacote [`http`][]
para adaptar às diferenças entre acesso à rede
de plataformas baseadas em Dart VM e ambientes baseados em navegador web,
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
seja você executando no Android,
iOS, dentro de um navegador web, ou nativamente no Windows,
macOS, ou Linux.
O primeiro tutorial mostra como fazer uma
requisição `GET` não autenticada para um site,
analisar os dados recuperados como `JSON` e então
exibir os dados resultantes. O segundo tutorial
se baseia no primeiro adicionando cabeçalhos de autenticação,
permitindo acesso a servidores web que requerem autorização.
O artigo da Mozilla Developer Network (MDN)
fornece mais contexto sobre como a autorização funciona na web.

* Tutorial: [Fetch data from the internet][]
* Tutorial: [Make authenticated requests][]
* Article: [MDN's article on Authorization for websites][]

## Making data retrieved from the network useful

Uma vez que você recupera dados da rede,
você precisa de uma maneira de converter os dados da rede
em algo com o qual você possa trabalhar facilmente em Dart.
Os tutoriais na seção anterior usaram código Dart
manual para converter dados de rede em uma representação na memória.
Nesta seção,
você verá outras opções para lidar com essa conversão.
O primeiro link para um vídeo do YouTube mostrando uma visão geral
do [pacote `freezed`][`freezed` package].
O segundo link para um codelab que cobre padrões
e records usando um estudo de caso de análise de JSON.

* YouTube video: [Freezed (Package of the Week)][]
* Codelab: [Dive into Dart's patterns and records][]

## Going both ways, getting data out again

Agora que você dominou a arte de recuperar dados,
é hora de olhar para o envio de dados.
Esta informação começa com o envio de dados para a rede,
mas então mergulha na assincronicidade. A verdade é,
uma vez que você está em uma conversa pela rede,
você precisará lidar com o fato de que servidores web
que estão fisicamente distantes podem levar um tempo para responder,
e você não pode parar de renderizar na tela
enquanto espera que os pacotes façam a viagem de ida e volta.
Dart tem ótimo suporte para assincronicidade,
assim como Flutter.
Você aprenderá tudo sobre o suporte do Dart em um tutorial,
então verá a capacidade do Flutter coberta em um
vídeo Widget of the Week.
Depois de concluir isso, você aprenderá como depurar
tráfego de rede usando o Network View do DevTools.

* Tutorial: [Send data to the internet][]
* Tutorial: [Asynchronous programming: futures, async, await][]
* YouTube video: [FutureBuilder (Widget of the Week)][]
* Article: [Using the Network View][]

## Extension material

Agora que você dominou o uso das APIs de networking do Flutter,
ajuda ver o uso de rede do Flutter em contexto.
O primeiro codelab (ostensivamente sobre criar apps adaptativos no Flutter),
usa um servidor web escrito em Dart para contornar as
[restrições de Cross-Origin Resource Sharing (CORS)][Cross-Origin Resource Sharing (CORS) restrictions] dos navegadores web.

:::note
Se você já trabalhou neste codelab
na página de [layout][], sinta-se livre para pular esta etapa.
:::

[layout]: /get-started/fundamentals/layout

Em seguida, um vídeo longo do YouTube onde
o ex-aluno do Flutter DevRel, Fitz,
fala sobre como a localização dos dados importa para apps Flutter.
Finalmente, uma série realmente útil de artigos da Flutter GDE
Anna (Domashych) Leushchenko cobrindo networking avançado no Flutter.

* Codelab: [Adaptive apps in Flutter][]
* Video: [Keeping it local: Managing a Flutter app's data][]
* Article series: [Basic and advanced networking in Dart and Flutter][]


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

À medida que esta seção do site está evoluindo,
nós [agradecemos seu feedback][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="networking"
