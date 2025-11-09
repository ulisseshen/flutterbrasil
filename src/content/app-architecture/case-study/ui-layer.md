---
ia-translate: true
title: Estudo de caso da camada de UI
shortTitle: Camada de UI
description: >-
  Um passo a passo da camada de UI de um app que implementa arquitetura MVVM.
prev:
  title: Case study overview
  path: /app-architecture/case-study
next:
  title: Data Layer
  path: /app-architecture/case-study/data-layer
---

A [camada de UI][UI layer] de cada funcionalidade em sua aplicação Flutter deve ser
composta por dois componentes: uma **[`View`][`View`]** e
um **[`ViewModel`][`ViewModel`].**

![A screenshot of the booking screen of the compass app.](/assets/images/docs/app-architecture/case-study/mvvm-case-study-ui-layer-highlighted.png)

No sentido mais geral, view models gerenciam o estado da UI,
e views exibem o estado da UI.
Views e view models têm um relacionamento um-para-um;
para cada view, há exatamente um view model correspondente que
gerencia o estado dessa view.
Cada par de view e view model compõe a UI para uma única funcionalidade.
Por exemplo, um app pode ter classes chamadas
`LogOutView` e um `LogOutViewModel`.

## Definir um view model

Um view model é uma classe Dart responsável por lidar com lógica de UI.
View models recebem modelos de dados de domínio como entrada e expõem esses dados como
estado de UI para suas views correspondentes.
Eles encapsulam lógica que a view pode anexar a
manipuladores de eventos, como pressionamentos de botão, e
gerenciam o envio desses eventos para a camada de dados do app,
onde as mudanças de dados acontecem.

O trecho de código a seguir é uma declaração de classe para
uma classe view model chamada `HomeViewModel`.
Suas entradas são os [repositórios][repositories] que fornecem seus dados.
Neste caso,
o view model depende do
`BookingRepository` e `UserRepository` como argumentos.

```dart title=home_viewmodel.dart
class HomeViewModel {
  HomeViewModel({
    required BookingRepository bookingRepository,
    required UserRepository userRepository,
  }) :
    // Repositories are manually assigned because they're private members.
    _bookingRepository = bookingRepository,
    _userRepository = userRepository;

  final BookingRepository _bookingRepository;
  final UserRepository _userRepository;
  // ...
}
```

View models sempre dependem de repositórios de dados,
que são fornecidos como argumentos para o construtor do view model.
view models e repositórios têm um relacionamento muitos-para-muitos,
e a maioria dos view models dependerá de múltiplos repositórios.

Como no exemplo de declaração anterior de `HomeViewModel`,
repositórios devem ser membros privados no view model,
caso contrário as views teriam acesso direto à
camada de dados da aplicação.

### Estado de UI

A saída de um view model são dados que uma view precisa para renderizar, geralmente
referidos como **Estado de UI**, ou apenas estado. Estado de UI é um snapshot imutável de
dados que é necessário para renderizar completamente uma view.

![A screenshot of the booking screen of the compass app.](/assets/images/docs/app-architecture/case-study/mvvm-case-study-ui-state-highlighted.png)

O view model expõe estado como membros públicos.
No view model no exemplo de código a seguir,
os dados expostos são um objeto `User`,
bem como os itinerários salvos do usuário que
são expostos como um objeto do tipo `List<BookingSummary>`.

```dart title=home_viewmodel.dart
class HomeViewModel {
  HomeViewModel({
   required BookingRepository bookingRepository,
   required UserRepository userRepository,
  }) : _bookingRepository = bookingRepository,
      _userRepository = userRepository;

  final BookingRepository _bookingRepository;
  final UserRepository _userRepository;

  User? _user;
  User? get user => _user;

  List<BookingSummary> _bookings = [];

  /// Items in an [UnmodifiableListView] can't be directly modified,
  /// but changes in the source list can be modified. Since _bookings
  /// is private and bookings is not, the view has no way to modify the
  /// list directly.
  UnmodifiableListView<BookingSummary> get bookings => UnmodifiableListView(_bookings);

  // ...
}
```

Como mencionado, o estado de UI deve ser imutável.
Esta é uma parte crucial de software livre de bugs.

O app compass usa o [`package:freezed`][`package:freezed`] para
forçar imutabilidade em classes de dados. Por exemplo,
o código a seguir mostra a definição da classe `User`.
`freezed` fornece imutabilidade profunda,
e gera a implementação para métodos úteis como
`copyWith` e `toJson`.

```dart title=user.dart
@freezed
class User with _$User {
  const factory User({
    /// The user's name.
    required String name,

    /// The user's picture URL.
    required String picture,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
```

:::note
No exemplo do view model,
dois objetos são necessários para renderizar a view.
À medida que o estado de UI para qualquer model cresce em complexidade,
um view model pode ter muitas mais peças de dados de
muitos mais repositórios expostos para a view.
Em alguns casos,
você pode querer criar objetos que representem especificamente o estado de UI.
Por exemplo, você poderia criar uma classe chamada `HomeUiState`.
:::

### Atualizando o estado de UI

Além de armazenar estado,
view models precisam dizer ao Flutter para re-renderizar views quando
a camada de dados fornece um novo estado.
No app Compass, view models estendem [`ChangeNotifier`][`ChangeNotifier`] para alcançar isso.

```dart title=home_viewmodel.dart
class HomeViewModel [!extends ChangeNotifier!] {
  HomeViewModel({
   required BookingRepository bookingRepository,
   required UserRepository userRepository,
  }) : _bookingRepository = bookingRepository,
      _userRepository = userRepository;
  final BookingRepository _bookingRepository;
  final UserRepository _userRepository;

  User? _user;
  User? get user => _user;

  List<BookingSummary> _bookings = [];
  List<BookingSummary> get bookings => _bookings;

  // ...
}
```

`HomeViewModel.user` é um membro público do qual a view depende.
Quando novos dados fluem da camada de dados e
um novo estado precisa ser emitido, [`notifyListeners`][`notifyListeners`] é chamado.

<figure>

![A screenshot of the booking screen of the compass app.](/assets/images/docs/app-architecture/case-study/mvvm-case-study-update-ui-steps.png)

    <figcaption>
Esta figura mostra em alto nível como novos dados no repositório
se propagam até a camada de UI e acionam uma reconstrução de seus widgets Flutter.
    </figcaption>
</figure>

1. Novo estado é fornecido ao view model de um Repository.
2. O view model atualiza seu estado de UI para refletir os novos dados.
3. `ViewModel.notifyListeners` é chamado, alertando a View de novo Estado de UI.
4. A view (widget) é re-renderizada.

Por exemplo, quando o usuário navega para a tela Home e o view model é
criado, o método `_load` é chamado.
Até que este método seja concluído, o estado de UI está vazio,
a view exibe um indicador de carregamento.
Quando o método `_load` é concluído, se for bem-sucedido,
há novos dados no view model, e ele deve
notificar a view que novos dados estão disponíveis.

```dart title=home_viewmodel.dart highlightLines=19
class HomeViewModel extends ChangeNotifier {
  // ...

 Future<Result> _load() async {
    try {
      final userResult = await _userRepository.getUser();
      switch (userResult) {
        case Ok<User>():
          _user = userResult.value;
          _log.fine('Loaded user');
        case Error<User>():
          _log.warning('Failed to load user', userResult.error);
      }

      // ...

      return userResult;
    } finally {
      notifyListeners();
    }
  }
}
```

:::note
`ChangeNotifier` e [`ListenableBuilder`][`ListenableBuilder`] (discutido mais adiante nesta página) são
parte do SDK do Flutter,
e fornecem uma boa solução para atualizar a UI quando o estado muda.
Você também pode usar uma solução robusta de gerenciamento de estado de terceiros,
como [package:riverpod][package:riverpod], [package:flutter_bloc][package:flutter_bloc] ou [package:signals][package:signals].
Essas bibliotecas oferecem diferentes ferramentas para lidar com atualizações de UI.
Leia mais sobre o uso de `ChangeNotifier` em
nossa [documentação de gerenciamento de estado][state-management documentation].
:::

## Definir uma view

Uma view é um widget dentro do seu app.
Frequentemente, uma view representa uma tela em seu app que
tem sua própria rota e inclui um [`Scaffold`][`Scaffold`] no topo da
subárvore de widgets, como o `HomeScreen`, mas isso nem sempre é o caso.

Às vezes uma view é um único elemento de UI que
encapsula funcionalidade que precisa ser reutilizada em todo o app.
Por exemplo, o app Compass tem uma view chamada `LogoutButton`,
que pode ser colocada em qualquer lugar na árvore de widgets onde um usuário possa
esperar encontrar um botão de logout.
A view `LogoutButton` tem seu próprio view model chamado `LogoutViewModel`.
E em telas maiores, pode haver múltiplas views na tela que
ocupariam a tela inteira no mobile.

:::note
"View" é um termo abstrato, e uma view não é igual a um widget.
Widgets são composíveis, e vários podem ser combinados para criar uma view.
Portanto, view models não têm um relacionamento um-para-um com widgets,
mas sim uma relação um-para-um com uma *coleção* de widgets.
:::

Os widgets dentro de uma view têm três responsabilidades:

* Eles exibem as propriedades de dados do view model.
* Eles escutam atualizações do view model e re-renderizam quando novos dados estão disponíveis.
* Eles anexam callbacks do view model a manipuladores de eventos, se aplicável.

![A diagram showing a view's relationship to a view model.](/assets/images/docs/app-architecture/guide/feature-architecture-simplified-View-highlighted.png)


Continuando o exemplo da funcionalidade Home,
o código a seguir mostra a definição da view `HomeScreen`.

```dart title=home_screen.dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...
    );
  }
}
```

Na maioria das vezes, as únicas entradas de uma view devem ser uma `key`,
que todos os widgets Flutter recebem como um argumento opcional,
e o view model correspondente da view.

### Exibir dados de UI em uma view

Uma view depende de um view model para seu estado. No app Compass,
o view model é passado como um argumento no construtor da view.
O exemplo de trecho de código a seguir é do widget `HomeScreen`.

```dart title=home_screen.dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, [!required this.viewModel!]});

  [!final HomeViewModel viewModel;!]

  @override
  Widget build(BuildContext context) {
    // ...
  }
}
```

Dentro do widget, você pode acessar as reservas passadas do `viewModel`.
No código a seguir,
a propriedade `booking` está sendo fornecida a um sub-widget.

```dart title=home_screen.dart
@override
  Widget build(BuildContext context) {
    return Scaffold(
      // Some code was removed for brevity.
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(...),
                SliverList.builder(
                   itemCount: [!viewModel.bookings.length!],
                    itemBuilder: (_, index) => _Booking(
                      key: ValueKey([!viewModel.bookings[index].id!]),
                      booking:viewModel.bookings[index],
                      onTap: () => context.push(Routes.bookingWithId(
                         viewModel.bookings[index].id)),
                      onDismissed: (_) => viewModel.deleteBooking.execute(
                           viewModel.bookings[index].id,
                         ),
                    ),
                ),
              ],
            );
          },
        ),
      ),
```

### Atualizar a UI

O widget `HomeScreen` escuta atualizações do view model com
o widget [`ListenableBuilder`][`ListenableBuilder`].
Tudo na subárvore de widgets sob o widget `ListenableBuilder`
é re-renderizado quando o [`Listenable`][`Listenable`] fornecido muda.
Neste caso, o `Listenable` fornecido é o view model.
Lembre-se que o view model é do tipo [`ChangeNotifier`][`ChangeNotifier`]
que é um subtipo do tipo `Listenable`.

```dart title=home_screen.dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    // Some code was removed for brevity.
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(),
                SliverList.builder(
                  itemCount: viewModel.bookings.length,
                  itemBuilder: (_, index) =>
                      _Booking(
                        key: ValueKey(viewModel.bookings[index].id),
                        booking: viewModel.bookings[index],
                        onTap: () =>
                            context.push(Routes.bookingWithId(
                                viewModel.bookings[index].id)
                            ),
                        onDismissed: (_) =>
                            viewModel.deleteBooking.execute(
                              viewModel.bookings[index].id,
                            ),
                      ),
                ),
              ],
            );
          }
        )
      )
  );
}
```

### Lidando com eventos do usuário

Finalmente, uma view precisa escutar *eventos* dos usuários,
para que o view model possa lidar com esses eventos.
Isso é alcançado expondo um método callback na classe view model que
encapsula toda a lógica.

![A diagram showing a view's relationship to a view model.](/assets/images/docs/app-architecture/guide/feature-architecture-simplified-UI-highlighted.png)

No `HomeScreen`, os usuários podem excluir eventos previamente reservados deslizando
um widget [`Dismissible`][`Dismissible`].

Lembre-se deste código do trecho anterior:

{% render "docs/code-and-image.md",
image:"app-architecture/case-study/dismissible.webp",
img-style:"max-height: 480px; border-radius: 12px; border: black 2px solid;",
alt: "A clip that demonstrates the 'dismissible' functionality of the Compass app."
code:"
```dart title=home_screen.dart highlightLines=9-10
SliverList.builder(
  itemCount: widget.viewModel.bookings.length,
  itemBuilder: (_, index) => _Booking(
    key: ValueKey(viewModel.bookings[index].id),
    booking: viewModel.bookings[index],
    onTap: () => context.push(
      Routes.bookingWithId(viewModel.bookings[index].id)
    ),
    onDismissed: (_) =>
      viewModel.deleteBooking.execute(widget.viewModel.bookings[index].id),
  ),
),
```
" %}

No `HomeScreen`, uma viagem salva do usuário é representada pelo
widget `_Booking`. Quando um `_Booking` é descartado,
o método `viewModel.deleteBooking` é executado.

Uma reserva salva é estado de aplicação que persiste além
de uma sessão ou o tempo de vida de uma view,
e apenas repositórios devem modificar tal estado de aplicação.
Então, o método `HomeViewModel.deleteBooking` chama
um método exposto por um repositório na camada de dados,
como mostrado no trecho de código a seguir.

```dart title=home_viewmodel.dart highlightLines=3
Future<Result<void>> _deleteBooking(int id) async {
  try {
    final resultDelete = await _bookingRepository.delete(id);
    switch (resultDelete) {
      case Ok<void>():
        _log.fine('Deleted booking $id');
      case Error<void>():
        _log.warning('Failed to delete booking $id', resultDelete.error);
        return resultDelete;
    }

    // Some code was omitted for brevity.
    // final  resultLoadBookings = ...;

    return resultLoadBookings;
  } finally {
    notifyListeners();
  }
}
```

No app Compass,
esses métodos que lidam com eventos do usuário são chamados **commands**.

### Objetos Command

Commands são responsáveis pela interação que começa na camada de UI e
flui de volta para a camada de dados. Neste app especificamente,
um `Command` é também um tipo que ajuda a atualizar a UI com segurança,
independentemente do tempo de resposta ou conteúdo.

A classe `Command` envolve um método e
ajuda a lidar com os diferentes estados desse método,
como `running`, `complete` e `error`.
Esses estados facilitam a exibição de diferentes UI,
como indicadores de carregamento quando `Command.running` é verdadeiro.

O seguinte é código da classe `Command`.
Algum código foi omitido para fins de demonstração.

```dart title=command.dart
abstract class Command<T> extends ChangeNotifier {
  Command();
  bool running = false;
  Result<T>? _result;

  /// true if action completed with error
  bool get error => _result is Error;

  /// true if action completed successfully
  bool get completed => _result is Ok;

  /// Internal execute implementation
  Future<void> _execute(action) async {
    if (_running) return;

    // Emit running state - e.g. button shows loading state
    _running = true;
    _result = null;
    notifyListeners();

    try {
      _result = await action();
    } finally {
      _running = false;
      notifyListeners();
    }
  }
}
```

A classe `Command` em si estende `ChangeNotifier`,
e dentro do método `Command.execute`,
`notifyListeners` é chamado múltiplas vezes.
Isso permite que a view lide com diferentes estados com muito pouca lógica,
que você verá um exemplo mais adiante nesta página.

Você também pode ter notado que `Command` é uma classe abstrata.
Ela é implementada por classes concretas como `Command0` `Command1`.
O inteiro no nome da classe se refere ao
número de argumentos que o método subjacente espera.
Você pode ver exemplos dessas classes de implementação no
[diretório `utils`][`utils` directory] do app Compass.

:::tip Recomendação de pacote
Em vez de escrever sua própria classe `Command`,
considere usar o pacote [`flutter_command`][`flutter_command`],
que é uma biblioteca robusta que implementa classes como essas.
:::


### Garantindo que views possam renderizar antes que os dados existam

Em classes view model, commands são criados no construtor.

```dart title=home_viewmodel.dart highlightLines=8-9,15-16,24-30
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
   required BookingRepository bookingRepository,
   required UserRepository userRepository,
  }) : _bookingRepository = bookingRepository,
      _userRepository = userRepository {
    // Load required data when this screen is built.
    load = Command0(_load)..execute();
    deleteBooking = Command1(_deleteBooking);
  }

  final BookingRepository _bookingRepository;
  final UserRepository _userRepository;

  late Command0 load;
  late Command1<void, int> deleteBooking;

  User? _user;
  User? get user => _user;

  List<BookingSummary> _bookings = [];
  List<BookingSummary> get bookings => _bookings;

  Future<Result> _load() async {
    // ...
  }

  Future<Result<void>> _deleteBooking(int id) async {
    // ...
  }

  // ...
}
```

O método `Command.execute` é assíncrono,
então ele não pode garantir que os dados estarão disponíveis quando
a view quiser renderizar. Isso chega ao *porquê* o app Compass usa `Commands`.
No método `Widget.build` da view,
o command é usado para renderizar condicionalmente diferentes widgets.

```dart title=home_screen.dart
// ...
child: ListenableBuilder(
  listenable: [!viewModel.load!],
  builder: (context, child) {
    if ([!viewModel.load.running!]) {
      return const Center(child: CircularProgressIndicator());
    }

    if ([!viewModel.load.error!]) {
      return ErrorIndicator(
        title: AppLocalization.of(context).errorWhileLoadingHome,
        label: AppLocalization.of(context).tryAgain,
          onPressed: viewModel.load.execute,
        );
     }

    // The command has completed without error.
    // Return the main view widget.
    return child!;
  },
),

// ...
```

Como o command `load` é uma propriedade que existe no
view model em vez de algo efêmero,
não importa quando o método `load` é chamado ou quando ele resolve.
Por exemplo, se o command load resolve antes que
o widget `HomeScreen` fosse até criado,
não é um problema porque o objeto `Command` ainda existe,
e expõe o estado correto.

Este padrão padroniza como problemas comuns de UI são resolvidos no app,
tornando sua base de código menos propensa a erros e mais escalável,
mas não é um padrão que todo app vai querer implementar.
Se você quer usá-lo é altamente dependente de
outras escolhas arquiteturais que você faz.
Muitas bibliotecas que ajudam você a gerenciar estado têm
suas próprias ferramentas para resolver esses problemas.
Por exemplo, se você fosse usar
[streams][streams] e [`StreamBuilders`][`StreamBuilders`] em seu app,
as classes [`AsyncSnapshot`][`AsyncSnapshot`] fornecidas pelo Flutter têm
essa funcionalidade integrada.

:::note Exemplo do mundo real
Ao construir o app Compass, encontramos um bug que foi resolvido usando
o padrão Command. [Leia sobre isso no GitHub][Read about it on GitHub].
:::

[UI layer]: /app-architecture/guide#ui-layer
[`View`]: /app-architecture/guide#views
[`ViewModel`]: /app-architecture/guide#view-models
[repositories]: /app-architecture/guide#repositories
[commands]: /app-architecture/guide#command-objects
[`package:freezed`]: {{site.pub-pkg}}/freezed
[`ChangeNotifier`]: {{site.api}}/flutter/foundation/ChangeNotifier-class.html
[`Listenable`]: {{site.api}}/flutter/foundation/Listenable-class.html
[`ListenableBuilder`]: {{site.api}}/flutter/widgets/ListenableBuilder-class.html
[`notifyListeners`]: {{site.api}}/flutter/foundation/ChangeNotifier/notifyListeners.html
[state-management documentation]: /get-started/fundamentals/state-management
[`Scaffold`]: {{site.api}}/flutter/material/Scaffold-class.html
[`Dismissible`]: {{site.api}}/flutter/widgets/Dismissible-class.html
[`utils` directory]: https://github.com/flutter/samples/blob/main/compass_app/app/lib/utils/command.dart
[`flutter_command`]: {{site.pub-pkg}}/flutter_command
[streams]: {{site.api}}/flutter/dart-async/Stream-class.html
[`StreamBuilders`]: {{site.api}}/flutter/widgets/StreamBuilder-class.html
[`AsyncSnapshot`]: {{site.api}}/flutter/widgets/AsyncSnapshot-class.html
[Read about it on GitHub]: https://github.com/flutter/samples/pull/2449#pullrequestreview-2328333146
[package:riverpod]: {{site.pub-pkg}}/riverpod
[package:flutter_bloc]: {{site.pub-pkg}}/flutter_bloc
[package:signals]: {{site.pub-pkg}}/signals

## Feedback

À medida que esta seção do website está evoluindo,
nós [damos boas-vindas ao seu feedback][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_4T0XuR9Ts29acw6?page="case-study/ui-layer"
