---
ia-translate: true
title: O padrão command
description: "Simplifique a lógica do view model implementando uma classe Command."
contentTags:
  - mvvm
  - asynchronous dart
  - state
iconPath: /assets/images/docs/app-architecture/design-patterns/command-icon.svg
order: 4
---

<?code-excerpt path-base="app-architecture/command"?>

[Model-View-ViewModel (MVVM)][Model-View-ViewModel (MVVM)] é um padrão de design
que separa uma funcionalidade de uma aplicação em três partes:
o model, o view model e a view.
Views e view models compõem a camada de UI de uma aplicação.
Repositories e services representam a camada de dados de uma aplicação,
ou a camada model do MVVM.

Um command é uma classe que encapsula um método
e ajuda a lidar com os diferentes estados desse método,
como running, complete e error.

[View models][View models] podem usar commands para lidar com interações e executar ações.
Você também pode usá-los para exibir diferentes estados de UI,
como indicadores de carregamento quando uma ação está em execução,
ou exibir um diálogo de erro quando uma ação falha.

View models podem se tornar muito complexos
conforme uma aplicação cresce
e as funcionalidades ficam maiores.
Commands podem ajudar a simplificar view models
e reutilizar código.

Neste guia, você aprenderá
como usar o padrão command
para melhorar seus view models.

## Desafios ao implementar view models

Classes de view model no Flutter são tipicamente implementadas
estendendo a classe [`ChangeNotifier`][`ChangeNotifier`].
Isso permite que view models chamem `notifyListeners()` para atualizar views
quando os dados são atualizados.

<?code-excerpt "lib/no_command.dart (HomeViewModel2)" replace="/2//g"?>
```dart
class HomeViewModel extends ChangeNotifier {
  // ···
}
```

View models contêm uma representação do estado da UI,
incluindo os dados sendo exibidos.
Por exemplo, este `HomeViewModel` expõe a instância `User` para a view.

<?code-excerpt "lib/no_command.dart (getUser)" replace="/null;/\/\/ .../g;/2//g"?>
```dart
class HomeViewModel extends ChangeNotifier {

  User? get user => // ...
  // ···
}
```

View models também contêm ações tipicamente disparadas pela view,
como uma ação `load` encarregada de carregar o `user`.

<?code-excerpt "lib/no_command.dart (load1)" replace="/null;/\/\/ .../g;/2//g"?>
```dart
class HomeViewModel extends ChangeNotifier {

  User? get user => // ...
  // ···
  void load() {
    // load user
  }
  // ···
}
```

### Estado de UI em view models

Um view model também contém estado de UI além de dados, como
se a view está em execução ou experimentou um erro.
Isso permite que o app informe ao usuário se a ação foi concluída com sucesso.

<?code-excerpt "lib/no_command.dart (UiState1)" replace="/(null|false);/\/\/ .../g;/2//g"?>
```dart
class HomeViewModel extends ChangeNotifier {

  User? get user => // ...

  bool get running => // ...

  Exception? get error => // ...

  void load() {
    // load user
  }
  // ···
}
```

Você pode usar o estado running para exibir um indicador de progresso na view:

<?code-excerpt "lib/no_command.dart (ListenableBuilder)" replace="/\.load//g;/body: //g;/^\),$/)/g"?>
```dart
ListenableBuilder(
  listenable: widget.viewModel,
  builder: (context, _) {
    if (widget.viewModel.running) {
      return const Center(child: CircularProgressIndicator());
    }
    // ···
  },
)
```

Ou usar o estado running para evitar executar a ação múltiplas vezes:

<?code-excerpt "lib/no_command.dart (load2)" replace="/2//g"?>
```dart
void load() {
  if (running) {
    return;
  }
  // load user
}
```

Gerenciar o estado de uma ação pode ficar complicado
se o view model contém múltiplas ações.
Por exemplo, adicionar uma ação `edit()` ao `HomeViewModel`
pode levar ao seguinte resultado:

<?code-excerpt "lib/no_command.dart (HomeViewModel3)" replace="/(null|false);/\/\/ .../g;/3//g"?>
```dart
class HomeViewModel extends ChangeNotifier {
  User? get user => // ...

  bool get runningLoad => // ...

  Exception? get errorLoad => // ...

  bool get runningEdit => // ...

  Exception? get errorEdit => // ...

  void load() {
    // load user
  }

  void edit(String name) {
    // edit user
  }
}
```

Compartilhar o estado running
entre as ações `load()` e `edit()` pode nem sempre funcionar,
porque você pode querer mostrar um componente de UI diferente
quando a ação `load()` executa do que quando a ação `edit()` executa;
você terá o mesmo problema com o estado `error`.

### Disparando ações de UI a partir de view models

Classes de view model podem encontrar problemas ao
executar ações de UI e o estado do view model muda.

Por exemplo, você pode querer mostrar um `SnackBar` quando um erro ocorre,
ou navegar para uma tela diferente quando uma ação é concluída.
Para implementar isso, escute as mudanças no view model,
e execute a ação dependendo do estado.

Na view:

<?code-excerpt "lib/no_command.dart (addListener)"?>
```dart
@override
void initState() {
  super.initState();
  widget.viewModel.addListener(_onViewModelChanged);
}

@override
void dispose() {
  widget.viewModel.removeListener(_onViewModelChanged);
  super.dispose();
}
```

<?code-excerpt "lib/no_command.dart (_onViewModelChanged)" remove="widget.viewModel.clearError();"?>
```dart
void _onViewModelChanged() {
  if (widget.viewModel.error != null) {
    // Show Snackbar
  }
}
```

Você precisa limpar o estado de erro cada vez que executar esta ação,
caso contrário esta ação acontece cada vez que `notifyListeners()` é chamado.

<?code-excerpt "lib/no_command.dart (_onViewModelChanged)"?>
```dart
void _onViewModelChanged() {
  if (widget.viewModel.error != null) {
    widget.viewModel.clearError();
    // Show Snackbar
  }
}
```

## Padrão Command

Você pode se encontrar repetindo o código acima várias e várias vezes,
implementando um estado running diferente
para cada ação em cada view model.
Nesse ponto, faz sentido extrair este código
para um padrão reutilizável chamado _command_.

Um command é uma classe que encapsula uma ação de view model,
e expõe os diferentes estados que uma ação pode ter.

<?code-excerpt "lib/simple_command.dart (Command)" replace="/(null|false);/\/\/ .../g;"?>
```dart
class Command extends ChangeNotifier {
  Command(this._action);

  bool get running => // ...

  Exception? get error => // ...

  bool get completed => // ...

  void Function() _action;

  void execute() {
    // run _action
  }

  void clear() {
    // clear state
  }
}
```

No view model,
ao invés de definir uma ação diretamente com um método,
você cria um objeto command:

<?code-excerpt "lib/simple_command.dart (ViewModel)" replace="/(null|false);/\/\/ .../g;"?>
```dart
class HomeViewModel extends ChangeNotifier {
  HomeViewModel() {
    load = Command(_load)..execute();
  }

  User? get user => // ...

  late final Command load;

  void _load() {
    // load user
  }
}
```

O método `load()` anterior se torna `_load()`,
e ao invés disso o command `load` é exposto para a `View`.
Os estados `running` e `error` anteriores podem ser removidos,
pois agora são parte do command.

### Executando um command

Ao invés de chamar `viewModel.load()` para executar a ação load,
agora você chama `viewModel.load.execute()`.

O método `execute()` também pode ser chamado de dentro do view model.
A seguinte linha de código executa o command `load` quando o
view model é criado.

<?code-excerpt "lib/main.dart (ViewModelInit)"?>
```dart
HomeViewModel() {
  load = Command(_load)..execute();
}
```

O método `execute()` define o estado running como `true`
e reinicia os estados `error` e `completed`.
Quando a ação termina,
o estado `running` muda para `false`
e o estado `completed` para `true`.

Se o estado `running` for `true`,
o command não pode começar a executar novamente.
Isso impede que usuários disparem um command
múltiplas vezes pressionando um botão rapidamente.

O método `execute()` do command captura quaisquer `Exceptions` lançadas
automaticamente e as expõe no estado `error`.

O código a seguir mostra uma classe `Command` de exemplo que
foi simplificada para fins de demonstração.
Você pode ver uma implementação completa no final desta página.

<?code-excerpt "lib/main.dart (Command)"?>
```dart
class Command extends ChangeNotifier {
  Command(this._action);

  bool _running = false;
  bool get running => _running;

  Exception? _error;
  Exception? get error => _error;

  bool _completed = false;
  bool get completed => _completed;

  final Future<void> Function() _action;

  Future<void> execute() async {
    if (_running) {
      return;
    }

    _running = true;
    _completed = false;
    _error = null;
    notifyListeners();

    try {
      await _action();
      _completed = true;
    } on Exception catch (error) {
      _error = error;
    } finally {
      _running = false;
      notifyListeners();
    }
  }

  void clear() {
    _running = false;
    _error = null;
    _completed = false;
  }
}
```

### Ouvindo o estado do command

A classe `Command` estende de `ChangeNotifier`,
permitindo que Views escutem seus estados.

No `ListenableBuilder`,
ao invés de passar o view model para `ListenableBuilder.listenable`,
passe o command:


<?code-excerpt "lib/main.dart (CommandListenable)" replace="/body: //g;/^\),$/)/g"?>
```dart
ListenableBuilder(
  listenable: widget.viewModel.load,
  builder: (context, child) {
    if (widget.viewModel.load.running) {
      return const Center(child: CircularProgressIndicator());
    }
  // ···
)
```

E escute mudanças no estado do command para executar ações de UI:

<?code-excerpt "lib/main.dart (addListener)"?>
```dart
@override
void initState() {
  super.initState();
  widget.viewModel.addListener(_onViewModelChanged);
}

@override
void dispose() {
  widget.viewModel.removeListener(_onViewModelChanged);
  super.dispose();
}
```

<?code-excerpt "lib/main.dart (_onViewModelChanged)"?>
```dart
void _onViewModelChanged() {
  if (widget.viewModel.load.error != null) {
    widget.viewModel.load.clear();
    // Show Snackbar
  }
}
```

### Combinando command e ViewModel

Você pode empilhar múltiplos widgets `ListenableBuilder` para ouvir os estados `running`
e `error` antes de mostrar os dados do view model.

<?code-excerpt "lib/main.dart (ListenableBuilder)"?>
```dart
body: ListenableBuilder(
  listenable: widget.viewModel.load,
  builder: (context, child) {
    if (widget.viewModel.load.running) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.viewModel.load.error != null) {
      return Center(
        child: Text('Error: ${widget.viewModel.load.error}'),
      );
    }

    return child!;
  },
  child: ListenableBuilder(
    listenable: widget.viewModel,
    builder: (context, _) {
      // ···
    },
  ),
),
```

Você pode definir múltiplas classes de commands em um único view model,
simplificando sua implementação
e minimizando a quantidade de código repetido.

<?code-excerpt "lib/main.dart (HomeViewModel2)" replace="/null;/\/\/ .../g"?>
```dart
class HomeViewModel2 extends ChangeNotifier {
  HomeViewModel2() {
    load = Command(_load)..execute();
    delete = Command(_delete);
  }

  User? get user => // ...

  late final Command load;

  late final Command delete;

  Future<void> _load() async {
    // load user
  }

  Future<void> _delete() async {
    // delete user
  }
}
```

### Estendendo o padrão command

O padrão command pode ser estendido de múltiplas formas.
Por exemplo, para suportar um número diferente de argumentos.

<?code-excerpt "lib/extended_command.dart (HomeViewModel)" replace="/null;/\/\/ .../g"?>
```dart
class HomeViewModel extends ChangeNotifier {
  HomeViewModel() {
    load = Command0(_load)..execute();
    edit = Command1<String>(_edit);
  }

  User? get user => // ...

  // Command0 accepts 0 arguments
  late final Command0 load;

  // Command1 accepts 1 argument
  late final Command1<String> edit;

  Future<void> _load() async {
    // load user
  }

  Future<void> _edit(String name) async {
    // edit user
  }
}
```

## Juntando tudo

Neste guia,
você aprendeu como usar o padrão de design command
para melhorar a implementação de view models
ao usar o padrão de design MVVM.

Abaixo, você pode encontrar a classe `Command` completa
como implementada no [exemplo Compass App][Compass App example]
para as diretrizes de arquitetura Flutter.
Ela também usa a [classe `Result`][`Result` class]
para determinar se a ação foi concluída com sucesso ou com um erro.

Esta implementação também inclui dois tipos de commands,
um `Command0`, para ações sem parâmetros,
e um `Command1`, para ações que recebem um parâmetro.

:::note
Verifique o [pub.dev][pub.dev] para outras implementações
prontas para uso do padrão command,
como o pacote [`command_it`][`command_it`].
:::

<?code-excerpt "lib/command.dart"?>
```dart
// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';

import 'result.dart';

/// Defines a command action that returns a [Result] of type [T].
/// Used by [Command0] for actions without arguments.
typedef CommandAction0<T> = Future<Result<T>> Function();

/// Defines a command action that returns a [Result] of type [T].
/// Takes an argument of type [A].
/// Used by [Command1] for actions with one argument.
typedef CommandAction1<T, A> = Future<Result<T>> Function(A);

/// Facilitates interaction with a view model.
///
/// Encapsulates an action,
/// exposes its running and error states,
/// and ensures that it can't be launched again until it finishes.
///
/// Use [Command0] for actions without arguments.
/// Use [Command1] for actions with one argument.
///
/// Actions must return a [Result] of type [T].
///
/// Consume the action result by listening to changes,
/// then call to [clearResult] when the state is consumed.
abstract class Command<T> extends ChangeNotifier {
  bool _running = false;

  /// Whether the action is running.
  bool get running => _running;

  Result<T>? _result;

  /// Whether the action completed with an error.
  bool get error => _result is Error;

  /// Whether the action completed successfully.
  bool get completed => _result is Ok;

  /// The result of the most recent action.
  ///
  /// Returns `null` if the action is running or completed with an error.
  Result<T>? get result => _result;

  /// Clears the most recent action's result.
  void clearResult() {
    _result = null;
    notifyListeners();
  }

  /// Execute the provided [action], notifying listeners and
  /// setting the running and result states as necessary.
  Future<void> _execute(CommandAction0<T> action) async {
    // Ensure the action can't launch multiple times.
    // e.g. avoid multiple taps on button
    if (_running) return;

    // Notify listeners.
    // e.g. button shows loading state
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

/// A [Command] that accepts no arguments.
final class Command0<T> extends Command<T> {
  /// Creates a [Command0] with the provided [CommandAction0].
  Command0(this._action);

  final CommandAction0<T> _action;

  /// Executes the action.
  Future<void> execute() async {
    await _execute(_action);
  }
}

/// A [Command] that accepts one argument.
final class Command1<T, A> extends Command<T> {
  /// Creates a [Command1] with the provided [CommandAction1].
  Command1(this._action);

  final CommandAction1<T, A> _action;

  /// Executes the action with the specified [argument].
  Future<void> execute(A argument) async {
    await _execute(() => _action(argument));
  }
}
```

[Compass App example]: {{site.repo.samples}}/tree/main/compass_app
[`Result` class]: /app-architecture/design-patterns/result
[pub.dev]: {{site.pub}}
[`command_it`]: {{site.pub-pkg}}/command_it
[`ChangeNotifier`]: /get-started/fundamentals/state-management
[Model-View-ViewModel (MVVM)]: /app-architecture/guide#view-models
[View models]: /app-architecture/guide#view-models
