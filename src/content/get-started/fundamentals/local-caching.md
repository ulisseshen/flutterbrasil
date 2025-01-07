---
ia-translate: true
title: Cache local
description: Aprenda como persistir dados localmente.
prev:
  title: Rede e dados
  path: /get-started/fundamentals/networking
next:
  title: Aprenda mais
  path: /get-started/learn-flutter
---

Agora que você aprendeu como carregar dados de servidores pela
rede, seu aplicativo Flutter deve parecer mais vivo. No entanto,
só porque você *pode* carregar dados de servidores remotos não
significa que você sempre *deva*. Às vezes, é melhor renderizar
novamente os dados que você recebeu da solicitação de rede
anterior do que repeti-la e fazer seu usuário esperar até que
ela seja concluída novamente. Essa técnica de retenção de dados
do aplicativo para exibir novamente em um momento futuro é
chamada de *caching*, e esta página aborda como abordar essa
tarefa em seu aplicativo Flutter.

## Introdução ao caching

Em sua forma mais básica, todas as estratégias de caching
se resumem à mesma operação de três etapas, representada com o
seguinte pseudocódigo:

```dart
Data? _cachedData;

Future<Data> get data async {
    // Etapa 1: Verifique se seu cache já contém os dados desejados
    if (_cachedData == null) {
        // Etapa 2: Carregue os dados se o cache estiver vazio
        _cachedData = await _readData();
    }
    // Etapa 3: Retorne o valor no cache
    return _cachedData!;
}
```

Existem muitas maneiras interessantes de variar essa estratégia,
incluindo a localização do cache, a extensão em que você grava
preventivamente os valores ou "aquece" o cache; e outros.

## Terminologia comum de caching

O caching vem com sua própria terminologia, parte da qual é
definida e explicada abaixo.

**Cache hit**
: Diz-se que um aplicativo teve um cache hit quando o cache já
  continha as informações desejadas e o carregamento da fonte
  real da verdade era desnecessário.

**Cache miss**
: Diz-se que um aplicativo teve um cache miss quando o cache
  estava vazio e os dados desejados são carregados da fonte
  real da verdade e, em seguida, salvos no cache para leituras
  futuras.

## Riscos de caching de dados

Diz-se que um aplicativo tem um **cache desatualizado** quando os
dados dentro da fonte da verdade foram alterados, o que coloca
o aplicativo em risco de renderizar informações antigas e
desatualizadas.

Todas as estratégias de caching correm o risco de manter dados
desatualizados. Infelizmente, a ação de verificar a atualização
de um cache geralmente leva tanto tempo para ser concluída quanto
o carregamento completo dos dados em questão. Isso significa
que a maioria dos aplicativos tende a se beneficiar do caching de
dados apenas se confiarem que os dados estarão atualizados em
tempo de execução, sem verificação.

Para lidar com isso, a maioria dos sistemas de caching inclui
um limite de tempo em qualquer parte individual dos dados em
cache. Depois que esse limite de tempo é excedido, os possíveis
cache hits são tratados como cache misses até que dados novos
sejam carregados.

Uma piada popular entre os cientistas da computação é que "As
duas coisas mais difíceis em ciência da computação são a
invalidação de cache, a nomeação de coisas e os erros de
deslocamento por um." 😄

Apesar dos riscos, quase todos os aplicativos do mundo fazem
uso intenso do caching de dados. O restante desta página explora
várias abordagens para caching de dados em seu aplicativo
Flutter, mas saiba que todas essas abordagens podem ser ajustadas
ou combinadas para sua situação.

## Caching de dados na memória local

A estratégia de caching mais simples e com melhor desempenho é um
cache na memória. A desvantagem dessa estratégia é que, como o
cache é mantido apenas na memória do sistema, nenhum dado é
retido além da sessão em que foi armazenado em cache
originalmente. (Claro, essa "desvantagem" também tem a vantagem
de resolver automaticamente a maioria dos problemas de cache
desatualizado!)

Devido à sua simplicidade, os caches na memória imitam
fielmente o pseudocódigo visto acima. Dito isso, é melhor usar
princípios de design comprovados, como o [repository pattern][],
para organizar seu código e evitar que verificações de cache
como as acima apareçam em toda a sua base de código.

Imagine uma classe `UserRepository` que também tem a tarefa de
armazenar em cache os usuários na memória para evitar solicitações
de rede duplicadas. Sua implementação pode ser assim:

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

Este `UserRepository` segue vários princípios de design
comprovados, incluindo:

* [injeção de dependência][], o que ajuda nos testes
* [acoplamento fraco][], que protege o código circundante de
seus detalhes de implementação, e
* [separação de responsabilidades][], que impede que sua
implementação manipule muitas responsabilidades.

E o melhor de tudo, não importa quantas vezes em uma única
sessão um usuário visite páginas em seu aplicativo Flutter que
carregam um determinado usuário, a classe `UserRepository`
carrega esses dados pela rede apenas *uma vez*.

No entanto, seus usuários podem eventualmente se cansar de
esperar que os dados sejam carregados cada vez que reiniciam
seu aplicativo. Para isso, você deve escolher uma das
estratégias de caching persistente encontradas abaixo.

[injeção de dependência]: https://en.wikipedia.org/wiki/Dependency_injection
[acoplamento fraco]: https://en.wikipedia.org/wiki/Loose_coupling
[repository pattern]: https://medium.com/@pererikbergman/repository-design-pattern-e28c0f3e4a30
[separação de responsabilidades]: https://en.wikipedia.org/wiki/Separation_of_concerns

## Caches persistentes

O caching de dados na memória nunca verá seu precioso cache
sobreviver a uma única sessão do usuário.
Para aproveitar os benefícios de desempenho dos cache hits em
novos lançamentos de seu aplicativo, você precisa armazenar
dados em cache em algum lugar no disco rígido do dispositivo.

### Caching de dados com `shared_preferences`

[`shared_preferences`][] é um plugin Flutter que envolve
[armazenamento chave-valor][] específico da plataforma em todas
as seis plataformas de destino do Flutter.
Embora esses armazenamentos chave-valor de plataforma
subjacentes tenham sido projetados para tamanhos de dados
pequenos, eles ainda são adequados para uma estratégia de
caching para a maioria dos aplicativos.
Para um guia completo, consulte nossos outros recursos sobre o
uso de armazenamentos chave-valor.

* Livro de receitas: [Armazenar dados chave-valor em disco][]
* Vídeo: [Pacote da Semana: `shared_preferences`][]

[armazenamento chave-valor]: https://en.wikipedia.org/wiki/Key%E2%80%93value_database
[Pacote da Semana: `shared_preferences`]: https://www.youtube.com/watch?v=sa_U0jffQII
[`shared_preferences`]: {{site.pub-pkg}}/shared_preferences
[Armazenar dados chave-valor em disco]: /cookbook/persistence/key-value

### Caching de dados com o sistema de arquivos

Se seu aplicativo Flutter ultrapassar os cenários de baixa
taxa de transferência ideais para `shared_preferences`, você
pode estar pronto para explorar o caching de dados com o sistema
de arquivos do seu dispositivo.
Para um guia mais completo, consulte nossos outros recursos
sobre caching do sistema de arquivos.

* Livro de receitas: [Ler e gravar arquivos][]

[Ler e gravar arquivos]: /cookbook/persistence/reading-writing-files

### Caching de dados com um banco de dados no dispositivo

O chefe final do caching de dados local é qualquer estratégia
que use um banco de dados adequado para ler e gravar dados.
Existem vários tipos, incluindo bancos de dados relacionais e
não relacionais.
Todas as abordagens oferecem um desempenho drasticamente
melhorado em relação a arquivos simples - especialmente para
grandes conjuntos de dados.
Para um guia mais completo, consulte os seguintes recursos:

* Livro de receitas: [Persistir dados com SQLite][]
* Alternativa SQLite: [`sqlite3` package][]
* Drift, um banco de dados relacional: [`drift` package][]
* Hive, um banco de dados não relacional: [`hive` package][]
* Isar, um banco de dados não relacional: [`isar` package][]

[`drift` package]: {{site.pub-pkg}}/drift
[`hive` package]: {{site.pub-pkg}}/hive
[`isar` package]: {{site.pub-pkg}}/isar
[Persistir dados com SQLite]: /cookbook/persistence/sqlite
[`sqlite3` package]: {{site.pub-pkg}}/sqlite3

## Caching de imagens

O caching de imagens é um espaço problemático semelhante ao
caching de dados regulares, embora com uma solução única para
todos.
Para direcionar seu aplicativo Flutter para usar o sistema de
arquivos para armazenar imagens, use o [`cached_network_image`
package][].

* Vídeo: [Pacote da Semana: `cached_network_image`][]

{% comment %}
TODO: Meu entendimento é que agora recomendamos `Image.network` em vez de cache_network_image.
{% endcomment %}

[`cached_network_image` package]: {{site.pub-pkg}}/cached_network_image
[Pacote da Semana: `cached_network_image`]: https://www.youtube.com/watch?v=fnHr_rsQwDA

## Restauração de estado

Juntamente com os dados do aplicativo, você também pode querer
persistir outros aspectos da sessão de um usuário, como sua pilha
de navegação, posições de rolagem e até mesmo o progresso
parcial no preenchimento de formulários. Esse padrão é chamado
de "restauração de estado" e está integrado ao Flutter.

A restauração de estado funciona instruindo a estrutura Flutter
a sincronizar os dados de sua árvore Element com o mecanismo
Flutter, que então os armazena em cache no armazenamento
específico da plataforma para sessões futuras. Para ativar a
restauração de estado no Flutter para Android e iOS, consulte
a seguinte documentação:

* Documentação do Android: [Restauração de estado do Android][]
* Documentação do iOS: [Restauração de estado do iOS][]

[Restauração de estado do Android]: /platform-integration/android/restore-state-android
[Restauração de estado do iOS]: /platform-integration/ios/restore-state-ios

## Feedback

Como esta seção do site está evoluindo,
[agradecemos seu feedback][]!

[agradecemos seu feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="local-caching"