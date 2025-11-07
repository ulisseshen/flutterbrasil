---
ia-translate: true
title: Cache local
description: Aprenda como persistir dados localmente.
prev:
  title: Networking and data
  path: /get-started/fundamentals/networking
next:
  title: Learn more
  path: /get-started/learn-flutter
---

Agora que você aprendeu sobre como carregar dados de servidores
pela rede, seu app Flutter deve parecer mais vivo.
No entanto, só porque você *pode* carregar dados de servidores remotos
não significa que você sempre *deve*. Às vezes, é melhor
renderizar novamente os dados que você recebeu da requisição de rede
anterior ao invés de repeti-la e fazer seu usuário esperar até
que ela complete novamente. Esta técnica de reter dados da aplicação
para mostrar novamente em um momento futuro é chamada de *caching*, e
esta página cobre como abordar esta tarefa em seu app Flutter.

## Introdução ao caching

No mais básico, todas as estratégias de caching se resumem à mesma
operação de três etapas, representada com o seguinte pseudocódigo:

```dart
Data? _cachedData;

Future<Data> get data async {
    // Step 1: Check whether your cache already contains the desired data
    if (_cachedData == null) {
        // Step 2: Load the data if the cache was empty
        _cachedData = await _readData();
    }
    // Step 3: Return the value in the cache
    return _cachedData!;
}
```

Existem muitas maneiras interessantes de variar esta estratégia,
incluindo a localização do cache, até que ponto você
escreve preventivamente valores para, ou "aquece", o cache; e outros.

## Terminologia comum de caching

Caching vem com sua própria terminologia, parte da qual é
definida e explicada abaixo.

**Cache hit**
: Diz-se que um app teve um cache hit quando o cache já
  continha a informação desejada e carregá-la da
  fonte real de verdade era desnecessário.

**Cache miss**
: Diz-se que um app teve um cache miss quando o cache estava
  vazio e os dados desejados são carregados da fonte real
  de verdade, e então salvos no cache para leituras futuras.

## Riscos de fazer cache de dados

Diz-se que um app tem um **cache obsoleto** quando os dados dentro
da fonte de verdade mudaram, o que coloca o app em risco
de renderizar informação antiga e desatualizada.

Todas as estratégias de caching correm o risco de manter dados obsoletos.
Infelizmente, a ação de verificar a atualidade de um cache
frequentemente leva tanto tempo para completar quanto carregar totalmente os dados
em questão. Isso significa que a maioria dos apps tende a apenas se beneficiar
de fazer cache de dados se eles confiam que os dados estejam atualizados em tempo de execução
sem verificação.

Para lidar com isso, a maioria dos sistemas de caching inclui um limite de tempo
para qualquer peça individual de dados em cache. Depois que este limite de tempo
é excedido, os que seriam cache hits são tratados como cache misses
até que dados atualizados sejam carregados.

Uma piada popular entre cientistas da computação é que "As duas
coisas mais difíceis em ciência da computação são invalidação de cache,
nomear coisas, e erros de off-by-one." 😄

Apesar dos riscos, quase todo app no mundo faz uso pesado
de cache de dados. O resto desta página explora múltiplas
abordagens para fazer cache de dados em seu app Flutter, mas saiba que
todas essas abordagens podem ser ajustadas ou combinadas para sua
situação.

## Fazendo cache de dados na memória local

A estratégia de caching mais simples e performática é um
cache na memória. A desvantagem desta estratégia é que,
porque o cache é mantido apenas na memória do sistema, nenhum dado é
retido além da sessão na qual ele é originalmente cacheado.
(Claro, esta "desvantagem" também tem a vantagem de automaticamente
resolver a maioria dos problemas de cache obsoleto!)

Devido à sua simplicidade, caches na memória imitam de perto
o pseudocódigo visto acima. Dito isso, é melhor usar princípios
de design comprovados, como o [padrão repository][repository pattern],
para organizar seu código e prevenir verificações de cache como a acima
de aparecer por toda sua base de código.

Imagine uma classe `UserRepository` que também é encarregada de
fazer cache de usuários na memória para evitar requisições de rede duplicadas.
Sua implementação pode parecer assim:

```dart
class UserRepository {
  UserRepository(this.api);
  
  final Api api;
  final Map<int, User?> _userCache = {};

  Future<User?> loadUser(int id) async {
    if (!_userCache.containsKey(id)) {
      final response = await api.get(id);
      if (response.statusCode == 200) {
        _userCache[id] = User.fromJson(response.body);
      } else {
        _userCache[id] = null;
      }
    }
    return _userCache[id];
  }
}
```

Este `UserRepository` segue múltiplos princípios de design
comprovados incluindo:

* [injeção de dependência][dependency injection], que ajuda com testes
* [acoplamento fraco][loose coupling], que protege o código circundante de
seus detalhes de implementação, e
* [separação de responsabilidades][separation of concerns], que previne sua implementação
de lidar com muitas preocupações.

E o melhor de tudo, não importa quantas vezes dentro de uma única sessão
um usuário visite páginas em seu app Flutter que carregam um determinado usuário,
a classe `UserRepository` carrega aqueles dados pela rede apenas *uma vez*.

No entanto, seus usuários podem eventualmente se cansar de esperar pelos dados
carregarem toda vez que eles relançam seu app. Para isso, você deve
escolher uma das estratégias de caching persistente encontradas abaixo.

[dependency injection]: https://en.wikipedia.org/wiki/Dependency_injection
[loose coupling]: https://en.wikipedia.org/wiki/Loose_coupling
[repository Pattern]: https://medium.com/@pererikbergman/repository-design-pattern-e28c0f3e4a30
[separation of concerns]: https://en.wikipedia.org/wiki/Separation_of_concerns

## Caches persistentes

Fazer cache de dados na memória nunca fará com que seu precioso cache
sobreviva a uma única sessão do usuário.
Para aproveitar os benefícios de performance de cache hits em
lançamentos recentes da sua aplicação, você precisa fazer cache de dados em algum lugar
no disco rígido do dispositivo.

### Fazendo cache de dados com `shared_preferences`

[`shared_preferences`][] é um plugin do Flutter que encapsula
[armazenamento chave-valor][key-value storage] específico da plataforma em todas as seis
plataformas alvo do Flutter.
Embora esses armazenamentos chave-valor de plataforma subjacentes tenham sido projetados
para tamanhos pequenos de dados, eles ainda são adequados para uma estratégia
de caching para a maioria das aplicações.
Para um guia completo, veja nossos outros recursos sobre uso de armazenamentos chave-valor.

* Cookbook: [Store key-value data on disk][]
* Vídeo: [Package of the Week: `shared_preferences`][]

[key-value storage]: https://en.wikipedia.org/wiki/Key%E2%80%93value_database
[Package of the Week: `shared_preferences`]: https://www.youtube.com/watch?v=sa_U0jffQII
[`shared_preferences`]: {{site.pub-pkg}}/shared_preferences
[Store key-value data on disk]: /cookbook/persistence/key-value

### Fazendo cache de dados com o sistema de arquivos

Se seu app Flutter superar os cenários de baixo throughput
ideais para `shared_preferences`, você pode estar pronto para explorar
fazer cache de dados com o sistema de arquivos do seu dispositivo.
Para um guia mais completo, veja nossos outros recursos sobre
caching de sistema de arquivos.

* Cookbook: [Read and write files][]

[Read and write files]: /cookbook/persistence/reading-writing-files

### Fazendo cache de dados com um banco de dados no dispositivo

O chefe final do caching de dados local é qualquer estratégia
que usa um banco de dados apropriado para ler e escrever dados.
Múltiplos sabores existem, incluindo bancos de dados relacionais e
não-relacionais.
Todas as abordagens oferecem performance dramaticamente melhorada em relação
a arquivos simples - especialmente para grandes conjuntos de dados.
Para um guia mais completo, veja os seguintes recursos:

* Cookbook: [Persist data with SQLite][]
* Alternativa ao SQLite: [`sqlite3` package][]
* Drift, um banco de dados relacional: [`drift` package][]
* Hive, um banco de dados não-relacional: [`hive` package][]
* Isar, um banco de dados não-relacional: [`isar` package][]

[`drift` package]: {{site.pub-pkg}}/drift
[`hive` package]: {{site.pub-pkg}}/hive
[`isar` package]: {{site.pub-pkg}}/isar
[Persist data with SQLite]: /cookbook/persistence/sqlite
[`sqlite3` package]: {{site.pub-pkg}}/sqlite3

## Fazendo cache de imagens

Fazer cache de imagens é um espaço de problema similar a fazer cache de dados regulares,
embora com uma solução única para todos os casos.
Para direcionar seu app Flutter a usar o sistema de arquivos para armazenar imagens,
use o [pacote `cached_network_image`][`cached_network_image` package].

* Vídeo: [Package of the Week: `cached_network_image`][]

{% comment %}
TODO: My understanding is that we now recommend `Image.network` instead of cache_network_image.
{% endcomment %}

[`cached_network_image` package]: {{site.pub-pkg}}/cached_network_image
[Package of the Week: `cached_network_image`]: https://www.youtube.com/watch?v=fnHr_rsQwDA

## Restauração de estado

Junto com os dados da aplicação, você também pode querer persistir outros
aspectos da sessão de um usuário, como sua pilha de navegação, posições
de scroll, e até progresso parcial preenchendo formulários. Este
padrão é chamado de "restauração de estado", e está integrado ao Flutter.

A restauração de estado funciona instruindo o framework Flutter
a sincronizar dados de sua árvore Element com a engine do Flutter,
que então faz cache deles em armazenamento específico da plataforma para
sessões futuras. Para habilitar a restauração de estado no Flutter para Android
e iOS, veja a seguinte documentação:

* Documentação Android: [Android state restoration][]
* Documentação iOS: [iOS state restoration][]

[Android state restoration]: /platform-integration/android/restore-state-android
[iOS state restoration]: /platform-integration/ios/restore-state-ios

## Feedback

À medida que esta seção do site evolui,
[recebemos bem seu feedback][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="local-caching"
