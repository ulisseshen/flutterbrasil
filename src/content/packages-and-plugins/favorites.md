---
ia-translate: true
title: Programa Flutter Favorite
description: Diretrizes para identificar um plugin ou pacote como um Flutter Favorite.
---

![O logo do programa Flutter Favorite](/assets/images/docs/development/packages-and-plugins/FlutterFavoriteLogo.png){:width="20%"}

O objetivo do programa **Flutter Favorite** é identificar
pacotes e plugins que você deve considerar primeiramente ao
construir seu aplicativo.
Isso não é uma garantia de qualidade ou adequação para sua
situação particular&mdash;você deve sempre realizar sua
própria avaliação de pacotes e plugins para seu projeto.

Você pode ver a lista completa de
[pacotes Flutter Favorite][] no pub.dev.

:::note
Se você chegou aqui procurando pelas recomendações do Happy Paths,
nós descontinuamos esse projeto em favor do Flutter Favorites.
:::

## Métricas

Pacotes Flutter Favorite passaram por altos padrões de qualidade
usando as seguintes métricas:

* [Pontuação geral do pacote][]
* **Licença permissiva**,
  incluindo (mas não limitado a)
  Apache, Artistic, BSD, CC BY, MIT, MS-PL e W3C
* **Tag de versão** no GitHub corresponde à versão atual do
  pub.dev, assim você pode ver exatamente qual código fonte está no pacote
* **Completude** de funcionalidades&mdash;e não marcado como incompleto
  (por exemplo, com labels como "beta" ou "em construção")
* [Publicador verificado][]
* **Usabilidade** geral quando se trata de visão geral,
  documentação, código de amostra/exemplo e qualidade da API
* Bom **comportamento em tempo de execução** em termos de uso de CPU e memória
* **Dependências** de alta qualidade

## Comitê do Ecossistema Flutter

O Comitê do Ecossistema Flutter é composto por membros do time
Flutter e membros da comunidade Flutter espalhados
por todo o seu ecossistema.
Um de seus trabalhos é decidir quando um pacote
atingiu o nível de qualidade para se tornar um Flutter Favorite.

Os membros atuais do comitê
(ordenados alfabeticamente pelo sobrenome)
são os seguintes:

* Pooja Bhaumik
* Hillel Coren
* Ander Dobo
* Simon Lightfoot
* Lara Martín
* John Ryan
* Diego Velasquez

Se você gostaria de indicar um pacote ou plugin como um
potencial futuro Flutter Favorite, ou gostaria de trazer
qualquer outra questão à atenção do comitê,
[envie um email para o comitê][].

## Diretrizes de uso do Flutter Favorite

Pacotes Flutter Favorite são rotulados como tal no pub.dev
pelo time Flutter.
Se você possui um pacote que foi designado como um Flutter Favorite,
você deve aderir às seguintes diretrizes:

* Autores de pacotes Flutter Favorite podem colocar o logo do
  Flutter Favorite no README do GitHub do pacote, na aba
  **Visão Geral** do pacote no pub.dev,
  e em redes sociais relacionadas a posts sobre aquele pacote.
* Nós encorajamos você a usar a hashtag **#FlutterFavorite**
  em redes sociais.
* Ao usar o logo do Flutter Favorite,
  o autor deve linkar para (esta) página de destino do Flutter Favorite,
  para fornecer contexto para a designação.
* Se um pacote Flutter Favorite perder seu status de Flutter Favorite,
  o autor será notificado,
  momento em que o autor deve remover imediatamente todos os usos
  de "Flutter Favorite" e do logo Flutter Favorite do
  pacote afetado.
* Não altere, distorça,
  ou modifique o logo Flutter Favorite de nenhuma forma,
  incluindo exibir o logo com variações de cor
  ou elementos visuais não aprovados.
* Não exiba o logo Flutter Favorite de forma que
  seja enganosa, injusta, difamatória, infrinja, caluniosa,
  depreciativa, obscena ou de outra forma questionável para o Google.

## O que vem a seguir

Você deve esperar que a lista de pacotes Flutter Favorite
cresça e mude conforme o ecossistema continua a prosperar.
O comitê continuará trabalhando com autores de pacotes
para aumentar a qualidade, bem como considerar outras áreas do
ecossistema que poderiam se beneficiar do programa Flutter Favorite,
como ferramentas, empresas de consultoria e colaboradores
prolíficos do Flutter.

À medida que o ecossistema Flutter cresce,
nós estaremos analisando a expansão do conjunto de métricas,
que pode incluir o seguinte:

* Uso do [formato pubspec.yaml][] que indica claramente
  quais plataformas um plugin suporta.
* Suporte para a versão estável mais recente do Flutter.
* Suporte para AndroidX.
* Suporte para múltiplas plataformas, como web, macOS,
  Windows, Linux, etc.
* Integração, bem como cobertura de testes unitários.

## Flutter Favorites

Você pode ver a lista completa de
[pacotes Flutter Favorite][] no pub.dev.


[envie um email para o comitê]: mailto:flutter-committee@googlegroups.com
[pacotes Flutter Favorite]: {{site.pub}}/flutter/favorites
[Pontuação geral do pacote]: {{site.pub}}/help
[formato pubspec.yaml]: /packages-and-plugins/developing-packages#plugin-platforms
[Publicador verificado]: {{site.dart-site}}/tools/pub/verified-publishers
