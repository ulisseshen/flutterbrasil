---
ia-translate: true
title: Flutter Favorite program
description: Diretrizes para identificar um plugin ou package como Flutter Favorite.
---

![The Flutter Favorite program logo](/assets/images/docs/development/packages-and-plugins/FlutterFavoriteLogo.png){:width="20%"}

O objetivo do programa **Flutter Favorite** é identificar
packages e plugins que você deve considerar primeiro ao
construir seu app.
Isto não é uma garantia de qualidade ou adequação à sua
situação particular&mdash;você deve sempre realizar sua
própria avaliação de packages e plugins para seu projeto.

Você pode ver a lista completa de
[Flutter Favorite packages][] no pub.dev.

:::note
Se você veio procurando pelas recomendações Happy Paths,
descontinuamos esse projeto em favor dos Flutter Favorites.
:::

## Metrics

Flutter Favorite packages passaram por padrões de alta qualidade
usando as seguintes métricas:

* [Overall package score][]
* **Permissive license**,
  incluindo (mas não limitado a)
  Apache, Artistic, BSD, CC BY, MIT, MS-PL e W3C
* GitHub **version tag** corresponde à versão atual do
  pub.dev, para que você possa ver exatamente qual código fonte está no package
* **Completude** de recurso&mdash;e não marcado como incompleto
  (por exemplo, com rótulos como "beta" ou "under construction")
* [Verified publisher][]
* **Usabilidade** geral quando se trata da visão geral,
  docs, código de exemplo, e qualidade da API
* Bom **comportamento em runtime** em termos de uso de CPU e memória
* **Dependências** de alta qualidade

## Flutter Ecosystem Committee

O Flutter Ecosystem Committee é composto por membros da equipe Flutter
e membros da comunidade Flutter espalhados
por seu ecossistema.
Um de seus trabalhos é decidir quando um package
atendeu ao padrão de qualidade para se tornar um Flutter Favorite.

Os atuais membros do comitê
(ordenados alfabeticamente por sobrenome)
são os seguintes:

* Pooja Bhaumik
* Hillel Coren
* Ander Dobo
* Simon Lightfoot
* Lara Martín
* John Ryan
* Diego Velasquez

Se você deseja nomear um package ou plugin como um
potencial futuro Flutter Favorite, ou gostaria
de trazer quaisquer outros assuntos à atenção do comitê,
[envie um email ao comitê][send the committee].

## Flutter Favorite usage guidelines

Flutter Favorite packages são rotulados como tal no pub.dev
pela equipe Flutter.
Se você é dono de um package que foi designado como Flutter Favorite,
você deve aderir às seguintes diretrizes:

* Autores de Flutter Favorite packages podem colocar o logo Flutter Favorite
  no README do GitHub do package, na aba **Overview** do pub.dev
  do package,
  e em mídias sociais relacionadas a posts sobre esse package.
* Encorajamos você a usar a hashtag **#FlutterFavorite**
  em mídias sociais.
* Ao usar o logo Flutter Favorite,
  o autor deve linkar para (esta) página de destino Flutter Favorite,
  para fornecer contexto para a designação.
* Se um Flutter Favorite package perder seu status de Flutter Favorite,
  o autor será notificado,
  momento em que o autor deve remover imediatamente todos os usos
  de "Flutter Favorite" e o logo Flutter Favorite do
  package afetado.
* Não altere, distorça,
  ou modifique o logo Flutter Favorite de forma alguma,
  incluindo exibir o logo com variações de cor
  ou elementos visuais não aprovados.
* Não exiba o logo Flutter Favorite de maneira que
  seja enganosa, injusta, difamatória, infratora, libelosa,
  depreciativa, obscena, ou de outra forma censurável ao Google.

## What's next

Você deve esperar que a lista de Flutter Favorite packages
cresça e mude conforme o ecossistema continua a prosperar.
O comitê continuará trabalhando com autores de packages
para aumentar a qualidade, bem como considerar outras áreas do
ecossistema que poderiam se beneficiar do programa Flutter Favorite,
como ferramentas, empresas de consultoria, e colaboradores prolíficos do Flutter.

À medida que o ecossistema Flutter cresce,
estaremos analisando expandir o conjunto de métricas,
que pode incluir o seguinte:

* Uso do formato [pubspec.yaml format][] que indica claramente
  quais plataformas um plugin suporta.
* Suporte para a versão estável mais recente do Flutter.
* Suporte para AndroidX.
* Suporte para múltiplas plataformas, como web, macOS,
  Windows, Linux, etc.
* Cobertura de testes de integração e unit tests.

## Flutter Favorites

Você pode ver a lista completa de
[Flutter Favorite packages][] no pub.dev.


[send the committee]: mailto:flutter-committee@googlegroups.com
[Flutter Favorite packages]: {{site.pub}}/flutter/favorites
[Overall package score]: {{site.pub}}/help
[pubspec.yaml format]: /packages-and-plugins/developing-packages#plugin-platforms
[Verified publisher]: {{site.dart-site}}/tools/pub/verified-publishers
