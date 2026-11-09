---
ia-translate: true
title: Camada de dados
shortTitle: Camada de dados
description: >-
  Um passo a passo da camada de dados de um app que implementa arquitetura MVVM.
prev:
  title: UI layer
  path: /app-architecture/case-study/ui-layer
next:
  title: Dependency Injection
  path: /app-architecture/case-study/dependency-injection
---


A camada de dados de uma aplicação, conhecida como *model* na terminologia MVVM,
é a fonte da verdade para todos os dados da aplicação.
Como a fonte da verdade,
é o único lugar onde os dados da aplicação devem ser atualizados.

É responsável por consumir dados de várias APIs externas,
expor esses dados para a UI,
lidar com eventos da UI que requerem que os dados sejam atualizados,
e enviar solicitações de atualização para essas APIs externas conforme necessário.

A camada de dados neste guia tem dois componentes principais,
[repositórios][repositories] e [serviços][services].

![A diagram that highlights the data layer components of an application.](/assets/images/docs/app-architecture/guide/feature-architecture-simplified-Data-highlighted.png)

* **Repositórios** são a fonte da verdade para dados da aplicação, e contêm
  lógica que se relaciona a esses dados, como atualizar os dados em resposta a novos
  eventos do usuário ou fazer polling de dados dos serviços. Repositórios são responsáveis
  por sincronizar os dados quando as capacidades offline são suportadas, gerenciar
  lógica de retry e fazer cache de dados.
* **Serviços** são classes Dart sem estado que interagem com APIs, como servidores
  HTTP e plugins de plataforma. Quaisquer dados que sua aplicação precise que não sejam
  criados dentro do próprio código da aplicação devem ser buscados de dentro
  de classes de serviço.

## Definir um serviço

Uma classe de serviço é a menos ambígua de todos os componentes de arquitetura.
Ela é sem estado, e suas funções não têm efeitos colaterais.
Seu único trabalho é envolver uma API externa.
Geralmente há uma classe de serviço por fonte de dados,
como um servidor HTTP cliente ou um plugin de plataforma.


![A diagram that shows the inputs and outputs of service objects.](/assets/images/docs/app-architecture/case-study/mvvm-case-study-services-architecture.png)

No app Compass, por exemplo, há um serviço [`APIClient`][`APIClient`] que
lida com as chamadas CRUD para o servidor voltado para o cliente.

```dart title=api_client.dart
class ApiClient {
  // Some code omitted for demo purposes.

  Future<Result<List<ContinentApiModel>>> getContinents() async { /* ... */ }

  Future<Result<List<DestinationApiModel>>> getDestinations() async { /* ... */ }

  Future<Result<List<ActivityApiModel>>> getActivityByDestination(String ref) async { /* ... */ }

  Future<Result<List<BookingApiModel>>> getBookings() async { /* ... */ }

  Future<Result<BookingApiModel>> getBooking(int id) async { /* ... */ }

  Future<Result<BookingApiModel>> postBooking(BookingApiModel booking) async { /* ... */ }

  Future<Result<void>> deleteBooking(int id) async { /* ... */ }

  Future<Result<UserApiModel>> getUser() async { /* ... */ }
}
```

O serviço em si é uma classe,
onde cada método envolve um endpoint de API diferente e
expõe objetos de resposta assíncronos.
Continuando o exemplo anterior de excluir uma reserva salva,
o método `deleteBooking` retorna um `Future<Result<void>>`.

:::note
Alguns métodos retornam classes de dados que são
especificamente para dados brutos da API,
como a classe `BookingApiModel`.
Como você verá em breve, repositórios extraem dados e
os expõem em um formato diferente.
:::


## Definir um repositório

A única responsabilidade de um repositório é gerenciar dados da aplicação.
Um repositório é a fonte da verdade para um único tipo de dados da aplicação,
e deve ser o único lugar onde esse tipo de dados é mutado.
O repositório é responsável por fazer polling de novos dados de fontes externas,
lidar com lógica de retry, gerenciar dados em cache,
e transformar dados brutos em modelos de domínio.

![A diagram that highlights the repository component of an application.](/assets/images/docs/app-architecture/guide/feature-architecture-simplified-Repository-highlighted.png)

Você deve ter um repositório separado para
cada tipo diferente de dados em sua aplicação.
Por exemplo, o app Compass tem repositórios chamados `UserRepository`,
`BookingRepository`, `AuthRepository`, `DestinationRepository`, e mais.

O exemplo a seguir é o `BookingRepository` do app Compass,
e mostra a estrutura básica de um repositório.

```dart title=booking_repository_remote.dart
class BookingRepositoryRemote implements BookingRepository {
  BookingRepositoryRemote({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;
  List<Destination>? _cachedDestinations;

  Future<Result<void>> createBooking(Booking booking) async {...}
  Future<Result<Booking>> getBooking(int id) async {...}
  Future<Result<List<BookingSummary>>> getBookingsList() async {...}
  Future<Result<void>> delete(int id) async {...}
}
```

:::note Development versus staging environments
A classe no exemplo anterior é `BookingRepositoryRemote`,
que estende uma classe abstrata chamada `BookingRepository`.
Esta classe base é usada para criar repositórios para diferentes ambientes.
Por exemplo, o app compass também tem uma classe chamada `BookingRepositoryLocal`,
que é usada para desenvolvimento local.

Você pode ver as diferenças entre as
[classes `BookingRepository` no GitHub][`BookingRepository` classes on GitHub].
:::


O `BookingRepository` recebe o serviço `ApiClient` como uma entrada,
que ele usa para obter e atualizar os dados brutos do servidor.
É importante que o serviço seja um membro privado,
para que a camada de UI não possa ignorar o repositório e chamar um serviço diretamente.

Com o serviço `ApiClient`,
o repositório pode fazer polling para atualizações nas reservas salvas de um usuário que
podem acontecer no servidor, e fazer solicitações `POST` para excluir reservas salvas.

Os dados brutos que um repositório transforma em modelos de aplicação podem vir de
múltiplas fontes e múltiplos serviços,
e portanto repositórios e serviços têm um relacionamento muitos-para-muitos.
Um serviço pode ser usado por qualquer número de repositórios,
e um repositório pode usar mais de um serviço.

![A diagram that highlights the data layer components of an application.](/assets/images/docs/app-architecture/guide/feature-architecture-simplified-Data-highlighted.png)

### Modelos de domínio

O `BookingRepository` produz objetos `Booking` e `BookingSummary`,
que são *modelos de domínio*.
Todos os repositórios produzem modelos de domínio correspondentes.
Esses modelos de dados diferem dos modelos de API em que eles contêm apenas os dados
necessários pelo resto do app.
Modelos de API contêm dados brutos que frequentemente precisam ser filtrados,
combinados ou excluídos para serem úteis aos view models do app.
O repositório refina os dados brutos e os produz como modelos de domínio.

No app de exemplo, modelos de domínio são expostos através de
valores de retorno em métodos como `BookingRepository.getBooking`.
O método `getBooking` é responsável por obter os dados brutos do
serviço `ApiClient`, e transformá-los em um objeto `Booking`.
Ele faz isso combinando dados de múltiplos endpoints de serviço.

```dart title=booking_repository_remote.dart highlightLines=14-21
// This method was edited for brevity.
Future<Result<Booking>> getBooking(int id) async {
  try {
    // Get the booking by ID from server.
    final resultBooking = await _apiClient.getBooking(id);
    if (resultBooking is Error<BookingApiModel>) {
      return Result.error(resultBooking.error);
    }
    final booking = resultBooking.asOk.value;

    final destination = _apiClient.getDestination(booking.destinationRef);
    final activities = _apiClient.getActivitiesForBooking(
            booking.activitiesRef);

    return Result.ok(
      Booking(
        startDate: booking.startDate,
        endDate: booking.endDate,
        destination: destination,
        activity: activities,
      ),
    );
  } on Exception catch (e) {
    return Result.error(e);
  }
}
```

:::note
No app Compass, classes de serviço retornam objetos `Result`.
`Result` é uma classe utilitária que envolve chamadas assíncronas e
torna mais fácil lidar com erros e gerenciar estado de UI que depende
de chamadas assíncronas.

Este padrão é uma recomendação, mas não um requisito.
A arquitetura recomendada neste guia pode ser implementada sem ela.

Você pode aprender sobre esta classe na [receita Result do cookbook][Result cookbook recipe].
:::

### Completar o ciclo de evento

Ao longo desta página, você viu como um usuário pode excluir uma reserva salva,
começando com um evento—um usuário deslizando em um widget `Dismissible`.
O view model lida com esse evento delegando
a mutação real dos dados para o `BookingRepository`.
O trecho a seguir mostra o método `BookingRepository.deleteBooking`.

```dart title=booking_repository_remote.dart
Future<Result<void>> delete(int id) async {
  try {
    return _apiClient.deleteBooking(id);
  } on Exception catch (e) {
    return Result.error(e);
  }
}
```

O repositório envia uma solicitação `POST` para o cliente API com
o método `_apiClient.deleteBooking`, e retorna um `Result`.
O `HomeViewModel` consome o `Result` e os dados que ele contém,
então finalmente chama `notifyListeners`, completando o ciclo.

[repositories]: /app-architecture/guide#repositories
[services]:  /app-architecture/guide#services
[`APIClient`]: https://github.com/flutter/samples/blob/main/compass_app/app/lib/data/services/api/api_client.dart
[`sealed`]: {{site.dart-site}}/language/class-modifiers#sealed
[`BookingRepository` classes on GitHub]: https://github.com/flutter/samples/tree/main/compass_app/app/lib/data/repositories/booking
[Result cookbook recipe]: /app-architecture/design-patterns/result

## Feedback

À medida que esta seção do website está evoluindo,
nós [damos boas-vindas ao seu feedback][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_4T0XuR9Ts29acw6?page="case-study/data-layer"
