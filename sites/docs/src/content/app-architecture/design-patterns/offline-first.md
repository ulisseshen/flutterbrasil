---
ia-translate: true
title: "Suporte offline-first"
description: Implemente suporte offline-first para uma funcionalidade em uma aplicação.
contentTags:
  - data
  - user experience
  - repository pattern
iconPath: /assets/images/docs/app-architecture/design-patterns/offline-first-icon.svg
order: 3
---

<?code-excerpt path-base="app-architecture/offline_first"?>

Uma aplicação offline-first é um app capaz de oferecer a maior parte
ou toda a sua funcionalidade enquanto está desconectado da internet.
Aplicações offline-first geralmente dependem de dados armazenados
para oferecer aos usuários acesso temporário a dados
que de outra forma estariam disponíveis apenas online.

Algumas aplicações offline-first combinam dados locais e remotos perfeitamente,
enquanto outras aplicações informam ao usuário
quando a aplicação está usando dados em cache.
Da mesma forma,
algumas aplicações sincronizam dados em segundo plano
enquanto outras exigem que o usuário sincronize explicitamente.
Tudo depende dos requisitos da aplicação e da funcionalidade que ela oferece,
e cabe ao desenvolvedor decidir qual implementação atende suas necessidades.

Neste guia,
você aprenderá como implementar diferentes abordagens
para aplicações offline-first no Flutter,
seguindo as [diretrizes de Arquitetura Flutter][Flutter Architecture guidelines].

## Arquitetura offline-first

Como explicado no guia de conceitos comuns de arquitetura,
repositories atuam como a única fonte de verdade.
Eles são responsáveis por apresentar dados locais ou remotos,
e devem ser o único lugar onde os dados podem ser modificados.
Em aplicações offline-first,
repositories combinam diferentes fontes de dados locais e remotas
para apresentar dados em um único ponto de acesso,
independentemente do estado de conectividade do dispositivo.

Este exemplo usa o `UserProfileRepository`,
um repositório que permite obter e armazenar objetos `UserProfile`
com suporte offline-first.

O `UserProfileRepository` usa dois serviços de dados diferentes:
um trabalha com dados remotos,
e o outro trabalha com um banco de dados local.

O cliente de API, `ApiClientService`,
conecta-se a um serviço remoto usando chamadas HTTP REST.

<?code-excerpt "lib/data/services/api_client_service.dart (ApiClientService)"?>
```dart
class ApiClientService {
  /// performs GET network request to obtain a UserProfile
  Future<UserProfile> getUserProfile() async {
    // ···
  }

  /// performs PUT network request to update a UserProfile
  Future<void> putUserProfile(UserProfile userProfile) async {
    // ···
  }
}
```

O serviço de banco de dados, `DatabaseService`, armazena dados usando SQL,
similar ao encontrado na receita [Persistent Storage Architecture: SQL][Persistent Storage Architecture: SQL].

<?code-excerpt "lib/data/services/database_service.dart (DatabaseService)"?>
```dart
class DatabaseService {
  /// Fetches the UserProfile from the database.
  /// Returns null if the user profile is not found.
  Future<UserProfile?> fetchUserProfile() async {
    // ···
  }

  /// Update UserProfile in the database.
  Future<void> updateUserProfile(UserProfile userProfile) async {
    // ···
  }
}
```

Este exemplo também usa a classe de dados `UserProfile`
que foi criada usando o pacote [`freezed`][`freezed`].

<?code-excerpt "lib/domain/model/user_profile.dart (UserProfile)" remove="@Default(false) bool synchronized,"?>
```dart
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String name,
    required String photoUrl,
  }) = _UserProfile;
}
```

Em apps que têm dados complexos,
como quando os dados remotos contêm mais campos do que os necessários pela UI,
você pode querer ter uma classe de dados para os serviços de API e banco de dados,
e outra para a UI.
Por exemplo,
`UserProfileLocal` para a entidade do banco de dados,
`UserProfileRemote` para o objeto de resposta da API,
e então `UserProfile` para a classe de modelo de dados da UI.
O `UserProfileRepository` cuidaria
de converter de um para o outro quando necessário.

Este exemplo também inclui o `UserProfileViewModel`,
um view model que usa o `UserProfileRepository`
para exibir o `UserProfile` em um widget.

<?code-excerpt "lib/ui/user_profile/user_profile_viewmodel.dart (UserProfileViewModel)"?>
```dart
class UserProfileViewModel extends ChangeNotifier {
  // ···
  final UserProfileRepository _userProfileRepository;

  UserProfile? get userProfile => _userProfile;
  // ···

  /// Load the user profile from the database or the network
  Future<void> load() async {
    // ···
  }

  /// Save the user profile with the new name
  Future<void> save(String newName) async {
    // ···
  }
}
```

## Lendo dados

Ler dados é uma parte fundamental de qualquer aplicação
que depende de serviços de API remotos.

Em aplicações offline-first,
você quer garantir que o acesso a esses dados seja o mais rápido possível,
e que não dependa do dispositivo estar online
para fornecer dados ao usuário.
Isso é similar ao [padrão de design Optimistic State][Optimistic State design pattern].

Nesta seção,
você aprenderá duas abordagens diferentes,
uma que usa o banco de dados como fallback,
e uma que combina dados locais e remotos usando um `Stream`.

### Usando dados locais como fallback

Como primeira abordagem,
você pode implementar suporte offline tendo um mecanismo de fallback
para quando o usuário está offline ou uma chamada de rede falha.

Neste caso, o `UserProfileRepository` tenta obter o `UserProfile`
do servidor de API remoto usando o `ApiClientService`.
Se esta requisição falha,
então retorna o `UserProfile` armazenado localmente do `DatabaseService`.

<?code-excerpt "lib/data/repositories/user_profile_repository.dart (getUserProfileFallback)" replace="/Fallback//g"?>
```dart
Future<UserProfile> getUserProfile() async {
  try {
    // Fetch the user profile from the API
    final apiUserProfile = await _apiClientService.getUserProfile();
    //Update the database with the API result
    await _databaseService.updateUserProfile(apiUserProfile);

    return apiUserProfile;
  } catch (e) {
    // If the network call failed,
    // fetch the user profile from the database
    final databaseUserProfile = await _databaseService.fetchUserProfile();

    // If the user profile was never fetched from the API
    // it will be null, so throw an  error
    if (databaseUserProfile != null) {
      return databaseUserProfile;
    } else {
      // Handle the error
      throw Exception('User profile not found');
    }
  }
}
```

### Usando um Stream

Uma alternativa melhor apresenta os dados usando um `Stream`.
No melhor cenário,
o `Stream` emite dois valores,
os dados armazenados localmente e os dados do servidor.

Primeiro, o stream emite os dados armazenados localmente usando o `DatabaseService`.
Esta chamada é geralmente mais rápida e menos propensa a erros do que uma chamada de rede,
e ao fazê-la primeiro, o view model já pode exibir dados ao usuário.

Se o banco de dados não contém nenhum dado em cache,
então o `Stream` depende completamente da chamada de rede,
emitindo apenas um valor.

Então, o método executa a chamada de rede usando o `ApiClientService`
para obter dados atualizados.
Se a requisição foi bem-sucedida,
ele atualiza o banco de dados com os dados recém-obtidos,
e então envia o valor para o view model,
para que possa ser exibido ao usuário.

<?code-excerpt "lib/data/repositories/user_profile_repository.dart (getUserProfile)"?>
```dart
Stream<UserProfile> getUserProfile() async* {
  // Fetch the user profile from the database
  final userProfile = await _databaseService.fetchUserProfile();
  // Returns the database result if it exists
  if (userProfile != null) {
    yield userProfile;
  }

  // Fetch the user profile from the API
  try {
    final apiUserProfile = await _apiClientService.getUserProfile();
    //Update the database with the API result
    await _databaseService.updateUserProfile(apiUserProfile);
    // Return the API result
    yield apiUserProfile;
  } catch (e) {
    // Handle the error
  }
}
```

O view model deve se inscrever
neste `Stream` e aguardar até que seja concluído.
Para isso, chame `asFuture()` com o objeto `Subscription` e aguarde o resultado.

Para cada valor obtido,
atualize os dados do view model e chame `notifyListeners()`
para que a UI mostre os dados mais recentes.

<?code-excerpt "lib/ui/user_profile/user_profile_viewmodel.dart (load)"?>
```dart
Future<void> load() async {
  await _userProfileRepository
      .getUserProfile()
      .listen(
        (userProfile) {
          _userProfile = userProfile;
          notifyListeners();
        },
        onError: (error) {
          // handle error
        },
      )
      .asFuture<void>();
}
```
### Usando apenas dados locais

Outra abordagem possível usa dados armazenados localmente para operações de leitura.
Esta abordagem requer que os dados tenham sido pré-carregados
em algum momento no banco de dados,
e requer um mecanismo de sincronização que possa manter os dados atualizados.


<?code-excerpt "lib/data/repositories/user_profile_repository.dart (getUserProfileLocal)" replace="/Local//g;/Read//g"?>
```dart
Future<UserProfile> getUserProfile() async {
  // Fetch the user profile from the database
  final userProfile = await _databaseService.fetchUserProfile();

  // Return the database result if it exists
  if (userProfile == null) {
    throw Exception('Data not found');
  }

  return userProfile;
}

Future<void> sync() async {
  try {
    // Fetch the user profile from the API
    final userProfile = await _apiClientService.getUserProfile();

    // Update the database with the API result
    await _databaseService.updateUserProfile(userProfile);
  } catch (e) {
    // Try again later
  }
}
```

Esta abordagem pode ser útil para aplicações
que não requerem que os dados estejam em sincronia com o servidor o tempo todo.
Por exemplo, uma aplicação de clima
onde os dados meteorológicos são atualizados apenas uma vez por dia.

A sincronização pode ser feita manualmente pelo usuário,
por exemplo, uma ação de pull-to-refresh que então chama o método `sync()`,
ou feita periodicamente por um `Timer` ou um processo em segundo plano.
Você pode aprender como implementar uma tarefa de sincronização
na seção sobre sincronização de estado.

## Escrevendo dados

Escrever dados em aplicações offline-first depende fundamentalmente
do caso de uso da aplicação.

Algumas aplicações podem exigir que os dados de entrada do usuário
estejam imediatamente disponíveis no lado do servidor,
enquanto outras aplicações podem ser mais flexíveis
e permitir que os dados estejam fora de sincronia temporariamente.

Esta seção explica duas abordagens diferentes
para implementar escrita de dados em aplicações offline-first.

### Escrita apenas online

Uma abordagem para escrever dados em aplicações offline-first
é forçar estar online para escrever dados.
Embora isso possa soar contraintuitivo,
isso garante que os dados que o usuário modificou
estejam totalmente sincronizados com o servidor,
e a aplicação não tenha um estado diferente do servidor.

Neste caso, você primeiro tenta enviar os dados para o serviço de API,
e se a requisição tiver sucesso,
então armazena os dados no banco de dados.

<?code-excerpt "lib/data/repositories/user_profile_repository.dart (updateUserProfileOnline)" replace="/Online//g"?>
```dart
Future<void> updateUserProfile(UserProfile userProfile) async {
  try {
    // Update the API with the user profile
    await _apiClientService.putUserProfile(userProfile);

    // Only if the API call was successful
    // update the database with the user profile
    await _databaseService.updateUserProfile(userProfile);
  } catch (e) {
    // Handle the error
  }
}
```

A desvantagem neste caso é que a funcionalidade offline-first
está disponível apenas para operações de leitura,
mas não para operações de escrita, pois essas requerem que o usuário esteja online.

### Escrita offline-first

A segunda abordagem funciona de forma oposta.
Ao invés de executar a chamada de rede primeiro,
a aplicação primeiro armazena os novos dados no banco de dados,
e então tenta enviá-los ao serviço de API uma vez que foram armazenados localmente.

<?code-excerpt "lib/data/repositories/user_profile_repository.dart (updateUserProfileOffline)" replace="/Offline//g"?>
```dart
Future<void> updateUserProfile(UserProfile userProfile) async {
  // Update the database with the user profile
  await _databaseService.updateUserProfile(userProfile);

  try {
    // Update the API with the user profile
    await _apiClientService.putUserProfile(userProfile);
  } catch (e) {
    // Handle the error
  }
}
```

Esta abordagem permite que usuários armazenem dados localmente
mesmo quando a aplicação está offline,
no entanto, se a chamada de rede falha,
o banco de dados local e o serviço de API não estão mais em sincronia.
Na próxima seção,
você aprenderá diferentes abordagens para lidar com sincronização
entre dados locais e remotos.

## Sincronizando estado

Manter os dados locais e remotos em sincronia
é uma parte importante de aplicações offline-first,
pois as mudanças que foram feitas localmente
precisam ser copiadas para o serviço remoto.
O app também deve garantir que, quando o usuário volta à aplicação,
os dados armazenados localmente sejam os mesmos do serviço remoto.


### Escrevendo uma tarefa de sincronização

Existem diferentes abordagens para implementar
sincronização em uma tarefa em segundo plano.

Uma solução simples é criar um `Timer`
no `UserProfileRepository` que executa periodicamente,
por exemplo a cada cinco minutos.

<?code-excerpt "lib/data/repositories/user_profile_repository.dart (Timer)"?>
```dart
Timer.periodic(const Duration(minutes: 5), (timer) => sync());
```

O método `sync()` então busca o `UserProfile` do banco de dados,
e se ele requer sincronização, é então enviado ao serviço de API.

<?code-excerpt "lib/data/repositories/user_profile_repository.dart (sync)"?>
```dart
Future<void> sync() async {
  try {
    // Fetch the user profile from the database
    final userProfile = await _databaseService.fetchUserProfile();

    // Check if the user profile requires synchronization
    if (userProfile == null || userProfile.synchronized) {
      return;
    }

    // Update the API with the user profile
    await _apiClientService.putUserProfile(userProfile);

    // Set the user profile as synchronized
    await _databaseService.updateUserProfile(
      userProfile.copyWith(synchronized: true),
    );
  } catch (e) {
    // Try again later
  }
}
```

Uma solução mais complexa usa processos em segundo plano
como o plugin [`workmanager`][`workmanager`].
Isso permite que sua aplicação execute o processo de sincronização
em segundo plano mesmo quando a aplicação não está em execução.

:::note
Executar operações em segundo plano continuamente
pode drenar a bateria do dispositivo drasticamente,
e alguns dispositivos limitam as capacidades de processamento em segundo plano,
então esta abordagem precisa ser ajustada
aos requisitos da aplicação e uma solução pode não servir para todos os casos.
:::

Também é recomendado executar a tarefa de sincronização apenas
quando a rede está disponível.
Por exemplo, você pode usar o plugin [`connectivity_plus`][`connectivity_plus`]
para verificar se o dispositivo está conectado ao WiFi.
Você também pode usar [`battery_plus`][`battery_plus`] para verificar
que o dispositivo não está com bateria baixa.

No exemplo anterior, a tarefa de sincronização executa a cada 5 minutos.
Em alguns casos, isso pode ser excessivo,
enquanto em outros pode não ser frequente o suficiente.
O tempo real do período de sincronização para sua aplicação
depende das necessidades da sua aplicação e é algo que você terá que decidir.

### Armazenando uma flag de sincronização

Para saber se os dados requerem sincronização,
adicione uma flag à classe de dados indicando se as mudanças precisam ser sincronizadas.

Por exemplo, `bool synchronized`:

<?code-excerpt "lib/domain/model/user_profile.dart (UserProfile)"?>
```dart
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String name,
    required String photoUrl,
    @Default(false) bool synchronized,
  }) = _UserProfile;
}
```

Sua lógica de sincronização deve tentar
enviá-lo ao serviço de API
apenas quando a flag `synchronized` for `false`.
Se a requisição for bem-sucedida, então mude-a para `true`.

### Enviando dados do servidor

Uma abordagem diferente para sincronização
é usar um serviço de push para fornecer dados atualizados à aplicação.
Neste caso, o servidor notifica a aplicação quando os dados mudaram,
ao invés de ser a aplicação perguntando por atualizações.

Por exemplo, você pode usar [Firebase messaging][Firebase messaging],
para enviar pequenas cargas de dados ao dispositivo,
bem como disparar tarefas de sincronização remotamente usando mensagens em segundo plano.

Ao invés de ter uma tarefa de sincronização executando em segundo plano,
o servidor notifica a aplicação
quando os dados armazenados precisam ser atualizados com uma notificação push.

Você pode combinar ambas as abordagens juntas,
tendo uma tarefa de sincronização em segundo plano e usando mensagens push em segundo plano,
para manter o banco de dados da aplicação sincronizado com o servidor.

## Juntando tudo

Escrever uma aplicação offline-first
requer tomar decisões sobre
a forma como operações de leitura, escrita e sincronização são implementadas,
que dependem dos requisitos da aplicação que você está desenvolvendo.

Os principais pontos são:

- Ao ler dados,
você pode usar um `Stream` para combinar dados armazenados localmente com dados remotos.
- Ao escrever dados,
decida se você precisa estar online ou offline,
e se você precisa sincronizar dados posteriormente ou não.
- Ao implementar uma tarefa de sincronização em segundo plano,
leve em conta o status do dispositivo e as necessidades da sua aplicação,
pois diferentes aplicações podem ter diferentes requisitos.

[Flutter Architecture guidelines]:/app-architecture
[Persistent Storage Architecture: SQL]:/app-architecture/design-patterns/sql
[`freezed`]:{{site.pub}}/packages/freezed
[Optimistic State design pattern]:/app-architecture/design-patterns/optimistic-state
[`workmanager`]:{{site.pub}}/packages/workmanager
[`connectivity_plus`]:{{site.pub}}/packages/connectivity_plus
[`battery_plus`]:{{site.pub}}/packages/battery_plus
[Firebase messaging]:{{site.firebase}}/docs/cloud-messaging/flutter/client
