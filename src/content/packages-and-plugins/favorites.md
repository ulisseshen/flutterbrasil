---
ia-translate: true
title: Programa Flutter Favorite
description: Diretrizes para identificar um plugin ou pacote como Flutter Favorite.
---

![The Flutter Favorite program logo](/assets/images/docs/development/packages-and-plugins/FlutterFavoriteLogo.png){:width="20%"}

O objetivo do programa **Flutter Favorite** é identificar
pacotes e plugins que você deve considerar primeiro ao
construir seu app.
Isso não é uma garantia de qualidade ou adequação à sua
situação particular&mdash;você deve sempre realizar sua
própria avaliação de pacotes e plugins para seu projeto.

Você pode ver a lista completa de
[pacotes Flutter Favorite][Flutter Favorite packages] no pub.dev.

:::note
Se você veio aqui procurando pelas recomendações Happy Paths,
descontinuamos esse projeto em favor do Flutter Favorites.
:::

## Métricas

Pacotes Flutter Favorite passaram por padrões de alta qualidade
usando as seguintes métricas:

* [Pontuação geral do pacote][Overall package score]
* **Licença permissiva**,
  incluindo (mas não limitado a)
  Apache, Artistic, BSD, CC BY, MIT, MS-PL e W3C
* A **tag de versão** do GitHub corresponde à versão atual do
  pub.dev, para que você possa ver exatamente qual código-fonte está no pacote
* **Completude** de recursos&mdash;e não marcado como incompleto
  (por exemplo, com rótulos como "beta" ou "em construção")
* [Publicador verificado][Verified publisher]
* **Usabilidade** geral quando se trata da visão geral,
  documentos, código de exemplo e qualidade da API
* Bom **comportamento em runtime** em termos de uso de CPU e memória
* **Dependências** de alta qualidade

## Comitê do Ecossistema Flutter

O Comitê do Ecossistema Flutter é composto por membros
do time Flutter e membros da comunidade Flutter espalhados
por seu ecossistema.
Uma de suas funções é decidir quando um pacote
atingiu o nível de qualidade para se tornar um Flutter Favorite.

Os membros atuais do comitê
(ordenados alfabeticamente por sobrenome)
são os seguintes:

* Pooja Bhaumik
* Hillel Coren
* Ander Dobo
* Majid Hajian
* Simon Lightfoot
* John Ryan
* Diego Velasquez

Se você gostaria de nomear um pacote ou plugin como um
potencial futuro Flutter Favorite, ou gostaria de
trazer quaisquer outras questões à atenção do comitê,
[envie um email ao comitê][send the committee].

## Diretrizes de uso do Flutter Favorite

Pacotes Flutter Favorite são rotulados como tal no pub.dev
pelo time Flutter.
Se você possui um pacote que foi designado como Flutter Favorite,
você deve aderir às seguintes diretrizes:

* Autores de pacotes Flutter Favorite podem colocar o logo
  Flutter Favorite no README do GitHub do pacote, na aba
  **Overview** do pub.dev do pacote,
  e em mídias sociais relacionadas a posts sobre esse pacote.
* Encorajamos você a usar a hashtag **#FlutterFavorite**
  em mídias sociais.
* Ao usar o logo Flutter Favorite,
  o autor deve linkar para (esta) página inicial do Flutter Favorite,
  para fornecer contexto para a designação.
* Se um pacote Flutter Favorite perder seu status de Flutter Favorite,
  o autor será notificado,
  momento em que o autor deve imediatamente remover todos os usos
  de "Flutter Favorite" e do logo Flutter Favorite do
  pacote afetado.
* Não altere, distorça
  ou modifique o logo Flutter Favorite de forma alguma,
  incluindo exibir o logo com variações de cor
  ou elementos visuais não aprovados.
* Não exiba o logo Flutter Favorite de uma maneira que
  seja enganosa, injusta, difamatória, infratora, difamatória,
  depreciativa, obscena ou de outra forma questionável ao Google.

## Próximos passos

Você deve esperar que a lista de pacotes Flutter Favorite
cresça e mude à medida que o ecossistema continue prosperando.
O comitê continuará trabalhando com autores de pacotes
para aumentar a qualidade, bem como considerar outras áreas do
ecossistema que poderiam se beneficiar do programa Flutter Favorite,
como ferramentas, empresas de consultoria e colaboradores prolíficos do Flutter.

À medida que o ecossistema Flutter cresce,
estaremos buscando expandir o conjunto de métricas,
que pode incluir o seguinte:

* Uso do [formato pubspec.yaml][pubspec.yaml format] que claramente
  indica quais plataformas um plugin suporta.
* Suporte para a versão estável mais recente do Flutter.
* Suporte para AndroidX.
* Suporte para múltiplas plataformas, como web, macOS,
  Windows, Linux, etc.
* Cobertura de testes de integração e unitários.

## Flutter Favorites

Você pode ver a lista completa de
[pacotes Flutter Favorite][Flutter Favorite packages] no pub.dev.


[send the committee]: mailto:flutter-committee@googlegroups.com
[Flutter Favorite packages]: {{site.pub}}/flutter/favorites
[Overall package score]: {{site.pub}}/help
[pubspec.yaml format]: /packages-and-plugins/developing-packages#plugin-platforms
[Verified publisher]: {{site.dart-site}}/tools/pub/verified-publishers
