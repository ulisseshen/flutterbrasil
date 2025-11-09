---
ia-translate: true
title: Caching local
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
não significa que você sempre *deva*. Às vezes, é melhor
re-renderizar os dados que você recebeu da requisição de rede anterior
em vez de repeti-la e fazer seu usuário esperar até que
ela seja concluída novamente. Esta técnica de reter dados da
aplicação para mostrar novamente em um momento futuro é chamada de *caching*, e
esta página cobre como abordar esta tarefa no seu app Flutter.

## Introduction to caching

Em sua forma mais básica, todas as estratégias de caching equivalem à mesma
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
incluindo a localização do cache, a extensão em que você
preemptivamente escreve valores para, ou "aquece", o cache; e outras.

## Common caching terminology

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

## Risks of caching data

Diz-se que um app tem um **stale cache** quando os dados dentro
da fonte de verdade mudaram, o que coloca o app em risco
de renderizar informações antigas e desatualizadas.

Todas as estratégias de caching correm o risco de reter dados obsoletos.
Infelizmente, a ação de verificar a atualização de um cache
geralmente leva tanto tempo para completar quanto carregar completamente os dados
em questão. Isso significa que a maioria dos apps tende a apenas se beneficiar
do caching de dados se eles confiam que os dados estão atualizados em tempo de execução
sem verificação.

Para lidar com isso, a maioria dos sistemas de caching incluem um limite de tempo
em qualquer pedaço individual de dados em cache. Após este limite de tempo
ser excedido, potenciais cache hits são tratados como cache misses
até que dados atualizados sejam carregados.

Uma piada popular entre cientistas da computação é que "As duas
coisas mais difíceis em ciência da computação são invalidação de cache,
nomear coisas, e erros off-by-one." 😄

Apesar dos riscos, quase todos os apps no mundo fazem uso pesado
de caching de dados. O resto desta página explora múltiplas
abordagens para fazer caching de dados no seu app Flutter, mas saiba que
todas essas abordagens podem ser ajustadas ou combinadas para sua
situação.

## Caching data in local memory

A estratégia de caching mais simples e de melhor desempenho é um
cache em memória. A desvantagem desta estratégia é que,
porque o cache é mantido apenas na memória do sistema, nenhum dado é
retido além da sessão na qual é originalmente armazenado em cache.
(Claro, esta "desvantagem" também tem a vantagem de automaticamente
resolver a maioria dos problemas de cache obsoleto!)

Devido à sua simplicidade, caches em memória se assemelham muito ao
pseudocódigo visto acima. Dito isso, é melhor usar princípios
de design comprovados, como o [padrão repository][repository pattern],
para organizar seu código e evitar verificações de cache como a acima
de aparecer por todo o seu código base.

Imagine uma classe `UserRepository` que também é encarregada de
fazer caching de usuários em memória para evitar requisições de rede duplicadas.
Sua implementação pode parecer com isso:

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
* [acoplamento fraco][loose coupling], que protege o código ao redor de
seus detalhes de implementação, e
* [separação de responsabilidades][separation of concerns], que previne sua implementação
de fazer malabarismos com muitas preocupações.

E melhor de tudo, não importa quantas vezes dentro de uma única sessão
um usuário visite páginas no seu app Flutter que carregam um determinado usuário,
a classe `UserRepository` carrega aqueles dados pela rede apenas *uma vez*.

No entanto, seus usuários podem eventualmente se cansar de esperar que os dados
carreguem toda vez que reabrem seu app. Para isso, você deve
escolher uma das estratégias de caching persistente encontradas abaixo.

[dependency injection]: https://en.wikipedia.org/wiki/Dependency_injection
[loose coupling]: https://en.wikipedia.org/wiki/Loose_coupling
[repository Pattern]: https://medium.com/@pererikbergman/repository-design-pattern-e28c0f3e4a30
[separation of concerns]: https://en.wikipedia.org/wiki/Separation_of_concerns

## Persistent caches

Fazer caching de dados em memória nunca verá seu precioso cache
sobreviver a uma única sessão de usuário.
Para aproveitar os benefícios de desempenho de cache hits em
lançamentos novos da sua aplicação, você precisa fazer cache de dados em algum lugar
no disco rígido do dispositivo.

### Caching data with `shared_preferences`

[`shared_preferences`][] é um plugin Flutter que envolve
[armazenamento chave-valor][key-value storage] específico da plataforma em todas as seis plataformas
alvo do Flutter.
Embora esses armazenamentos chave-valor subjacentes da plataforma foram projetados
para tamanhos pequenos de dados, eles ainda são adequados para uma estratégia de
caching para a maioria das aplicações.
Para um guia completo, veja nossos outros recursos sobre o uso de armazenamentos chave-valor.

* Cookbook: [Store key-value data on disk][]
* Video: [Package of the Week: `shared_preferences`][]

[key-value storage]: https://en.wikipedia.org/wiki/Key%E2%80%93value_database
[Package of the Week: `shared_preferences`]: https://www.youtube.com/watch?v=sa_U0jffQII
[`shared_preferences`]: {{site.pub-pkg}}/shared_preferences
[Store key-value data on disk]: /cookbook/persistence/key-value

### Caching data with the file system

Se seu app Flutter ultrapassar os cenários de baixa taxa de transferência
ideais para `shared_preferences`, você pode estar pronto para explorar
caching de dados com o sistema de arquivos do seu dispositivo.
Para um guia mais completo, veja nossos outros recursos sobre
caching de sistema de arquivos.

* Cookbook: [Read and write files][]

[Read and write files]: /cookbook/persistence/reading-writing-files

### Caching data with an on-device database

O chefe final do caching de dados local é qualquer estratégia
que use um banco de dados adequado para ler e escrever dados.
Existem múltiplos tipos, incluindo bancos de dados relacionais e
não relacionais.
Todas as abordagens oferecem desempenho dramaticamente melhorado sobre
arquivos simples - especialmente para grandes conjuntos de dados.
Para um guia mais completo, veja os seguintes recursos:

* Cookbook: [Persist data with SQLite][]
* SQLite alternate: [`sqlite3` package][]
* Drift, a relational database: [`drift` package][]
* Hive CE, a non-relational database: [`hive_ce` package][]
* Remote Caching, a lightweight caching system for API responses: [`remote_caching` package][]

[`drift` package]: {{site.pub-pkg}}/drift
[`hive_ce` package]: {{site.pub-pkg}}/hive_ce
[`remote_caching` package]: {{site.pub-pkg}}/remote_caching

[Persist data with SQLite]: /cookbook/persistence/sqlite
[`sqlite3` package]: {{site.pub-pkg}}/sqlite3

## Caching images

Fazer caching de imagens é um espaço de problema similar ao caching de dados regulares,
embora com uma solução que serve para todos.
Para direcionar seu app Flutter a usar o sistema de arquivos para armazenar imagens,
use o [pacote `cached_network_image`][`cached_network_image` package].

* Video: [Package of the Week: `cached_network_image`][]

{% comment %}
TODO: My understanding is that we now recommend `Image.network` instead of cache_network_image.
{% endcomment %}

[`cached_network_image` package]: {{site.pub-pkg}}/cached_network_image
[Package of the Week: `cached_network_image`]: https://www.youtube.com/watch?v=fnHr_rsQwDA

## State restoration

Junto com os dados da aplicação, você também pode querer persistir outros
aspectos da sessão de um usuário, como sua pilha de navegação, posições de rolagem,
e até progresso parcial no preenchimento de formulários. Este
padrão é chamado de "state restoration", e é integrado ao Flutter.

State restoration funciona instruindo o framework Flutter
a sincronizar dados de sua árvore Element com o engine Flutter,
que então faz cache em armazenamento específico da plataforma para sessões
futuras. Para habilitar state restoration no Flutter para Android
e iOS, veja a seguinte documentação:

* Android documentation: [Android state restoration][]
* iOS documentation: [iOS state restoration][]

[Android state restoration]: /platform-integration/android/restore-state-android
[iOS state restoration]: /platform-integration/ios/restore-state-ios

## Feedback

À medida que esta seção do site está evoluindo,
nós [agradecemos seu feedback][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="local-caching"
