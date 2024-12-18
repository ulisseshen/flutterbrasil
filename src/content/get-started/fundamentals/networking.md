---
ia-translate: true
title: Networking e dados
description: Aprenda como conectar seu aplicativo Flutter à rede.
prev:
  title: Lidando com a entrada do usuário
  path: /get-started/fundamentals/user-input
next:
  title: Dados locais e cache
  path: /get-started/fundamentals/local-caching
---

Embora se diga que "nenhum homem é uma ilha",
um aplicativo Flutter sem nenhuma capacidade de networking
pode parecer um pouco desconectado.
Esta página aborda como adicionar recursos de networking
ao seu aplicativo Flutter. Seu aplicativo irá recuperar dados,
analisar JSON em representações utilizáveis em memória
e, em seguida, enviar dados novamente.

## Introdução à recuperação de dados pela rede

Em sua forma mais simples, supondo que você utilize o pacote [`http`][]
para se adaptar às diferenças entre o acesso à rede
de plataformas baseadas em Dart VM e ambientes baseados em navegador,
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
envolvidos na adição do pacote [`http`][] ao seu aplicativo,
esteja ele rodando no Android,
iOS, dentro de um navegador da web ou nativamente no Windows,
macOS ou Linux.
O primeiro tutorial mostra como fazer uma
requisição `GET` não autenticada para um site,
analisar os dados recuperados como `JSON` e, em seguida,
exibir os dados resultantes. O segundo tutorial
se baseia no primeiro, adicionando cabeçalhos de autenticação,
permitindo o acesso a servidores web que exigem autorização.
O artigo da Mozilla Developer Network (MDN)
fornece mais informações sobre como a autorização funciona na web.

* Tutorial: [Buscar dados da internet][]
* Tutorial: [Fazer requisições autenticadas][]
* Artigo: [Artigo da MDN sobre Autorização para sites][]

## Tornando os dados recuperados da rede úteis

Depois de recuperar os dados da rede,
você precisa de uma maneira de converter os dados da rede
em algo com o qual você possa trabalhar facilmente no Dart.
Os tutoriais na seção anterior usaram Dart feito à mão
para converter dados da rede em uma representação em memória.
Nesta seção,
você verá outras opções para lidar com essa conversão.
O primeiro link leva a um vídeo do YouTube que mostra uma visão geral
do [`freezed` package][].
O segundo link leva a um codelab que abrange "design patterns"
e records usando um estudo de caso de análise de JSON.

* Vídeo do YouTube: [Freezed (Pacote da Semana)][]
* Codelab: [Mergulhe nos "patterns" e "records" do Dart][]

## Indo em ambas as direções, enviando dados novamente

Agora que você dominou a arte de recuperar dados,
é hora de analisar o envio de dados.
Esta informação começa com o envio de dados para a rede,
mas depois mergulha na assincronicidade. A verdade é que,
uma vez que você está em uma conversa pela rede,
você precisará lidar com o fato de que servidores web
que estão fisicamente distantes podem levar um tempo para responder,
e você não pode parar de renderizar na tela
enquanto espera que os pacotes façam o trajeto de ida e volta.
Dart tem um ótimo suporte para assincronicidade,
assim como Flutter.
Você aprenderá tudo sobre o suporte do Dart em um tutorial,
depois verá a capacidade do Flutter abordada em um
vídeo Widget da Semana.
Depois de concluir isso, você aprenderá como depurar
o tráfego de rede usando a Visão de Rede do DevTool.

* Tutorial: [Enviar dados para a internet][]
* Tutorial: [Programação assíncrona: futures, async, await][]
* Vídeo do YouTube: [FutureBuilder (Widget da Semana)][]
* Artigo: [Usando a Visão de Rede][]

## Material de extensão

Agora que você dominou o uso das APIs de networking do Flutter,
é útil ver o uso da rede do Flutter em contexto.
O primeiro codelab (ostensivamente sobre a criação de aplicativos adaptáveis no Flutter),
usa um servidor web escrito em Dart para contornar os
[restrições de Cross-Origin Resource Sharing (CORS)][].

:::note
Se você já trabalhou neste codelab
na página de [layout][], sinta-se à vontade para pular esta etapa.
:::

[layout]: /get-started/fundamentals/layout

Em seguida, um vídeo longo do YouTube onde
o ex-aluno do Flutter DevRel, Fitz,
fala sobre como a localização dos dados é importante para os aplicativos Flutter.
Finalmente, uma série muito útil de artigos da Flutter GDE
Anna (Domashych) Leushchenko cobrindo networking avançado no Flutter.

* Codelab: [Aplicativos adaptáveis em Flutter][]
* Vídeo: [Mantendo local: Gerenciando os dados de um aplicativo Flutter][]
* Série de artigos: [Networking básico e avançado em Dart e Flutter][]


[Aplicativos adaptáveis em Flutter]: {{site.codelabs}}/codelabs/flutter-adaptive-app
[Programação assíncrona: futures, async, await]: {{site.dart-site}}/codelabs/async-await
[Networking básico e avançado em Dart e Flutter]: {{site.medium}}/tide-engineering-team/basic-and-advanced-networking-in-dart-and-flutter-the-tide-way-part-0-introduction-33ac040a4a1c
[restrições de Cross-Origin Resource Sharing (CORS)]: https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS
[Mergulhe nos "patterns" e "records" do Dart]: {{site.codelabs}}/codelabs/dart-patterns-records
[Buscar dados da internet]: /cookbook/networking/fetch-data
[Freezed (Pacote da Semana)]: {{site.youtube-site}}/watch?v=RaThk0fiphA
[`freezed` package]: {{site.pub-pkg}}/freezed
[FutureBuilder (Widget da Semana)]: {{site.youtube-site}}/watch?v=zEdw_1B7JHY
[`http`]: {{site.pub-pkg}}/http
[HTTP]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview
[Mantendo local: Gerenciando os dados de um aplicativo Flutter]: {{site.youtube-site}}/watch?v=uCbHxLA9t9E
[Fazer requisições autenticadas]: /cookbook/networking/authenticated-requests
[Artigo da MDN sobre Autorização para sites]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Authorization
[Usando a Visão de Rede]: /tools/devtools/network
[Enviar dados para a internet]: /cookbook/networking/send-data

## Feedback

Como esta seção do site está evoluindo,
nós [agradecemos seu feedback][]!

[agradecemos seu feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="networking"
