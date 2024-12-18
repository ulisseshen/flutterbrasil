---
ia-translate: true
title: Cache local
description: Aprenda como persistir dados localmente.
prev:
  title: Rede e dados
  path: /get-started/fundamentals/networking
next:
  title: Saiba mais
  path: /get-started/learn-flutter
---

Agora que você aprendeu sobre como carregar dados de servidores
através da rede, seu aplicativo Flutter deve parecer mais vivo.
No entanto, só porque você *pode* carregar dados de servidores remotos
não significa que você sempre *deva*. Às vezes, é melhor
renderizar novamente os dados que você recebeu da solicitação de rede
anterior em vez de repeti-la e fazer o usuário esperar até que
ela seja concluída novamente. Essa técnica de retenção de dados do
aplicativo para exibir novamente em um momento futuro é chamada de
*cache*, e esta página aborda como abordar essa tarefa em seu
aplicativo Flutter.

## Introdução ao cache

Em sua forma mais básica, todas as estratégias de cache se resumem
à mesma operação de três etapas, representada com o seguinte pseudocódigo:

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
incluindo a localização do cache, a extensão em que você
escreve preventivamente valores no cache ou o "aquece"; e outros.

## Terminologia comum de cache

O cache vem com sua própria terminologia, parte da qual é
definida e explicada abaixo.

**Cache hit**
: Diz-se que um aplicativo teve um cache hit quando o cache já
  continha as informações desejadas e carregá-las da
  fonte real da verdade era desnecessário.

**Cache miss**
: Diz-se que um aplicativo teve um cache miss quando o cache estava
  vazio e os dados desejados são carregados da fonte real
  da verdade e, em seguida, salvos no cache para leituras futuras.

## Riscos do cache de dados

Diz-se que um aplicativo tem um **cache obsoleto** quando os dados
dentro da fonte da verdade foram alterados, o que coloca o aplicativo
em risco de renderizar informações antigas e desatualizadas.

Todas as estratégias de cache correm o risco de reter dados obsoletos.
Infelizmente, a ação de verificar a atualização de um cache
geralmente leva tanto tempo para ser concluída quanto o carregamento
completo dos dados em questão. Isso significa que a maioria dos
aplicativos tende a se beneficiar do cache de dados apenas se eles
confiarem que os dados estão atualizados em tempo de execução sem
verificação.

Para lidar com isso, a maioria dos sistemas de cache inclui um limite
de tempo para qualquer dado em cache individual. Depois que este
limite de tempo é excedido, os possíveis cache hits são tratados
como cache misses até que dados novos sejam carregados.

Uma piada popular entre os cientistas da computação é que "As duas
coisas mais difíceis na ciência da computação são a invalidação
de cache, nomear coisas e erros de um por um." 😄

Apesar dos riscos, quase todos os aplicativos do mundo fazem uso
pesado do cache de dados. O restante desta página explora várias
abordagens para o cache de dados em seu aplicativo Flutter, mas
saiba que todas essas abordagens podem ser ajustadas ou combinadas
para sua situação.

## Cache de dados na memória local

A estratégia de cache mais simples e com melhor desempenho é um
cache na memória. A desvantagem dessa estratégia é que, como o
cache é mantido apenas na memória do sistema, nenhum dado é retido
além da sessão em que é originalmente armazenado em cache. (Claro,
essa "desvantagem" também tem a vantagem de resolver automaticamente
a maioria dos problemas de cache obsoleto!)

Devido à sua simplicidade, os caches na memória imitam de perto
o pseudocódigo visto acima. Dito isso, é melhor usar princípios
de design comprovados, como o [repository pattern][],
para organizar seu código e evitar que verificações de cache como
a acima apareçam em toda a sua base de código.

Imagine uma classe `UserRepository` que também é encarregada de
armazenar usuários em cache na memória para evitar solicitações
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

* [injeção de dependência][], que ajuda nos testes
* [acoplamento fraco][], que protege o código circundante de seus
detalhes de implementação, e
* [separação de preocupações][], que evita que sua implementação
faça malabarismos com muitas preocupações.

E o melhor de tudo, não importa quantas vezes dentro de uma única
sessão um usuário visite páginas em seu aplicativo Flutter que
carregam um determinado usuário, a classe `UserRepository`
carrega esses dados pela rede apenas *uma vez*.

No entanto, seus usuários podem eventualmente se cansar de esperar
que os dados sejam carregados cada vez que eles reiniciarem seu aplicativo.
Para isso, você deve escolher uma das estratégias de cache persistente
encontradas abaixo.

[injeção de dependência]: https://en.wikipedia.org/wiki/Dependency_injection
[acoplamento fraco]: https://en.wikipedia.org/wiki/Loose_coupling
[repository Pattern]: https://medium.com/@pererikbergman/repository-design-pattern-e28c0f3e4a30
[separação de preocupações]: https://en.wikipedia.org/wiki/Separation_of_concerns

## Caches persistentes

O cache de dados na memória nunca verá seu precioso cache
sobreviver a uma única sessão de usuário.
Para desfrutar dos benefícios de desempenho dos cache hits em
novas inicializações do seu aplicativo, você precisa armazenar dados
em cache em algum lugar no disco rígido do dispositivo.

### Cache de dados com `shared_preferences`

[`shared_preferences`][] é um plugin Flutter que envolve
[armazenamento chave-valor][] específico da plataforma em todas
as seis plataformas de destino do Flutter.
Embora esses armazenamentos de chave-valor de plataforma subjacentes
tenham sido projetados para tamanhos pequenos de dados, eles ainda
são adequados para uma estratégia de cache para a maioria dos aplicativos.
Para um guia completo, consulte nossos outros recursos sobre o uso
de armazenamentos de chave-valor.

* Cookbook: [Armazenar dados de chave-valor em disco][]
* Vídeo: [Pacote da Semana: `shared_preferences`][]

[armazenamento chave-valor]: https://en.wikipedia.org/wiki/Key%E2%80%93value_database
[Pacote da Semana: `shared_preferences`]: https://www.youtube.com/watch?v=sa_U0jffQII
[`shared_preferences`]: {{site.pub-pkg}}/shared_preferences
[Armazenar dados de chave-valor em disco]: /cookbook/persistence/key-value

### Cache de dados com o sistema de arquivos

Se seu aplicativo Flutter ultrapassar os cenários de baixo rendimento
ideais para `shared_preferences`, você pode estar pronto para
explorar o cache de dados com o sistema de arquivos do seu dispositivo.
Para um guia mais completo, consulte nossos outros recursos sobre
o cache do sistema de arquivos.

* Cookbook: [Ler e escrever arquivos][]

[Ler e escrever arquivos]: /cookbook/persistence/reading-writing-files

### Cache de dados com um banco de dados no dispositivo

O chefe final do cache de dados local é qualquer estratégia
que usa um banco de dados adequado para ler e gravar dados.
Existem vários tipos, incluindo bancos de dados relacionais
e não relacionais.
Todas as abordagens oferecem um desempenho dramaticamente
melhorado em relação a arquivos simples - especialmente para grandes
conjuntos de dados.
Para um guia mais completo, consulte os seguintes recursos:

* Cookbook: [Persistir dados com SQLite][]
* Alternativa SQLite: [`sqlite3` package][]
* Drift, um banco de dados relacional: [`drift` package][]
* Hive, um banco de dados não relacional: [`hive` package][]
* Isar, um banco de dados não relacional: [`isar` package][]

[`drift` package]: {{site.pub-pkg}}/drift
[`hive` package]: {{site.pub-pkg}}/hive
[`isar` package]: {{site.pub-pkg}}/isar
[Persistir dados com SQLite]: /cookbook/persistence/sqlite
[`sqlite3` package]: {{site.pub-pkg}}/sqlite3

## Cache de imagens

O cache de imagens é um espaço de problema semelhante ao cache de
dados regulares, embora com uma solução única para todos.
Para direcionar seu aplicativo Flutter para usar o sistema de arquivos
para armazenar imagens, use o [`cached_network_image` package][].

* Vídeo: [Pacote da Semana: `cached_network_image`][]

{% comment %}
TODO: Meu entendimento é que agora recomendamos `Image.network` em vez de cache_network_image.
{% endcomment %}

[`cached_network_image` package]: {{site.pub-pkg}}/cached_network_image
[Pacote da Semana: `cached_network_image`]: https://www.youtube.com/watch?v=fnHr_rsQwDA

## Restauração de estado

Juntamente com os dados do aplicativo, você também pode querer
persistir outros aspectos da sessão de um usuário, como sua pilha
de navegação, posições de rolagem e até mesmo o progresso parcial
no preenchimento de formulários. Esse padrão é chamado de
"restauração de estado" e está integrado ao Flutter.

A restauração de estado funciona instruindo o framework Flutter
a sincronizar os dados de sua árvore de Element com o mecanismo
Flutter, que então os armazena em cache em armazenamento específico
da plataforma para sessões futuras. Para habilitar a restauração de
estado no Flutter para Android e iOS, consulte a seguinte documentação:

* Documentação do Android: [Restauração de estado do Android][]
* Documentação do iOS: [Restauração de estado do iOS][]

[Restauração de estado do Android]: /platform-integration/android/restore-state-android
[Restauração de estado do iOS]: /platform-integration/ios/restore-state-ios

## Feedback

À medida que esta seção do site está evoluindo,
nós [agradecemos seu feedback][]!

[agradecemos seu feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="local-caching"
