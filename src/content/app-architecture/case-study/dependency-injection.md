---
ia-translate: true
title: Comunicação entre camadas
shortTitle: Injeção de dependência
description: >-
  Como implementar injeção de dependência para comunicar entre camadas MVVM.
prev:
  title: Data layer
  path: /app-architecture/case-study/data-layer
next:
  title: Testing
  path: /app-architecture/case-study/testing
---

Junto com a definição de responsabilidades claras para cada componente da arquitetura,
é importante considerar como os componentes se comunicam.
Isso se refere tanto às regras que ditam a comunicação,
quanto à implementação técnica de como os componentes se comunicam.
A arquitetura de um app deve responder às seguintes perguntas:

* Quais componentes têm permissão para se comunicar com quais outros componentes
  (incluindo componentes do mesmo tipo)?
* O que esses componentes expõem como saída uns para os outros?
* Como qualquer camada é 'conectada' a outra camada?

![A diagram showing the components of app architecture.](/assets/images/docs/app-architecture/guide/feature-architecture-simplified.png)

Usando este diagrama como guia, as regras de engajamento são as seguintes:

| Componente | Regras de engajamento                                                                                                                                                                                                                                           |
|------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| View       | <ol><li> Uma view está ciente de exatamente um view model, e nunca está ciente de nenhuma outra camada ou componente. Quando criada, Flutter passa o view model para a view como um argumento, expondo os dados do view model e callbacks de comando para a view. </li></ul> |
| ViewModel  | <ol><li>Um ViewModel pertence a exatamente uma view, que pode ver seus dados, mas o model nunca precisa saber que uma view existe.</li><li>Um view model está ciente de um ou mais repositórios, que são passados para o construtor do view model.</li></ul>          |
| Repository | <ol><li>Um repositório pode estar ciente de muitos serviços, que são passados como argumentos para o construtor do repositório.</li><li>Um repositório pode ser usado por muitos view models, mas nunca precisa estar ciente deles.</li></ol>                       |
| Service    | <ol><li>Um serviço pode ser usado por muitos repositórios, mas nunca precisa estar ciente de um repositório (ou qualquer outro objeto).</li></ol>                                                                                                              |

{:.table .table-striped}

## Injeção de dependência

Este guia mostrou como esses diferentes componentes se comunicam
uns com os outros usando entradas e saídas.
Em todos os casos, a comunicação entre duas camadas é facilitada passando
um componente para os métodos construtores (dos componentes que
consomem seus dados), como um `Service` para um `Repository.`

```dart
class MyRepository {
  MyRepository({required MyService myService})
          : _myService = myService;

  late final MyService _myService;
}
```

Uma coisa que está faltando, no entanto, é a criação de objetos. Onde,
em uma aplicação, a instância `MyService` é criada para que possa ser
passada para `MyRepository`?
A resposta a esta pergunta envolve um
padrão conhecido como [injeção de dependência][dependency injection].

No app Compass, *injeção de dependência* é tratada usando
[`package:provider`][`package:provider`]. Com base em sua experiência construindo apps Flutter,
equipes do Google recomendam usar `package:provider` para implementar
injeção de dependência.

Serviços e repositórios são expostos ao nível superior da árvore de widgets da
aplicação Flutter como objetos `Provider`.

```dart title=dependencies.dart
runApp(
  MultiProvider(
    providers: [
      Provider(create: (context) => AuthApiClient()),
      Provider(create: (context) => ApiClient()),
      Provider(create: (context) => SharedPreferencesService()),
      ChangeNotifierProvider(
        create: (context) => AuthRepositoryRemote(
          authApiClient: context.read(),
          apiClient: context.read(),
          sharedPreferencesService: context.read(),
        ) as AuthRepository,
      ),
      Provider(create: (context) =>
        DestinationRepositoryRemote(
          apiClient: context.read(),
        ) as DestinationRepository,
      ),
      Provider(create: (context) =>
        ContinentRepositoryRemote(
          apiClient: context.read(),
        ) as ContinentRepository,
      ),
      // In the Compass app, additional service and repository providers live here.
    ],
    child: const MainApp(),
  ),
);
```

Serviços são expostos apenas para que possam ser imediatamente
injetados em repositórios via o método `BuildContext.read` do `provider`,
como mostrado no trecho anterior.
Repositórios são então expostos para que possam ser
injetados em view models conforme necessário.

Ligeiramente mais abaixo na árvore de widgets, view models que correspondem a
uma tela completa são criados na configuração do [`package:go_router`][`package:go_router`],
onde provider é novamente usado para injetar os repositórios necessários.

```dart title=router.dart
// This code was modified for demo purposes.
GoRouter router(
  AuthRepository authRepository,
) =>
    GoRouter(
      initialLocation: Routes.home,
      debugLogDiagnostics: true,
      redirect: _redirect,
      refreshListenable: authRepository,
      routes: [
        GoRoute(
          path: Routes.login,
          builder: (context, state) {
            return LoginScreen(
              viewModel: LoginViewModel(
                authRepository: context.read(),
              ),
            );
          },
        ),
        GoRoute(
          path: Routes.home,
          builder: (context, state) {
            final viewModel = HomeViewModel(
              bookingRepository: context.read(),
            );
            return HomeScreen(viewModel: viewModel);
          },
          routes: [
            // ...
          ],
        ),
      ],
    );
```

Dentro do view model ou repositório, o componente injetado deve ser privado.
Por exemplo, a classe `HomeViewModel` se parece com isto:

```dart title=home_viewmodel.dart
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required BookingRepository bookingRepository,
    required UserRepository userRepository,
  })  : _bookingRepository = bookingRepository,
        _userRepository = userRepository;

  final BookingRepository _bookingRepository;
  final UserRepository _userRepository;

  // ...
}
```

Métodos privados impedem que a view, que tem acesso ao view model, chame
métodos no repositório diretamente.

Isso conclui o passo a passo do código do app Compass. Esta página apenas percorreu
o código relacionado à arquitetura, mas não conta toda a história. A maioria
do código utilitário, código de widget e estilização de UI foi ignorada. Navegue pelo código no
[repositório do app Compass][Compass app repository] para um exemplo completo
de uma aplicação Flutter robusta construída seguindo esses princípios.

[`package:provider`]: {{site.pub-pkg}}/provider
[`package:go_router`]: {{site.pub-pkg}}/go_router
[Compass app repository]: https://github.com/flutter/samples/tree/main/compass_app
[dependency injection]: https://en.wikipedia.org/wiki/Dependency_injection

## Feedback

À medida que esta seção do website está evoluindo,
nós [damos boas-vindas ao seu feedback][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_4T0XuR9Ts29acw6?page="case-study/dependency-injection"
