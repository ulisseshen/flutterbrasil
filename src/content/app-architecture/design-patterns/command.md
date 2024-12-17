---
title: O padrão Command
description: "Simplifique a lógica do view model implementando uma classe Command."
contentTags:
  - mvvm
  - dart assíncrono
  - estado
iconPath: /assets/images/docs/app-architecture/design-patterns/command-icon.svg
order: 4
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
ia-translate: true
---

<?code-excerpt path-base="app-architecture/command"?>

[Model-View-ViewModel (MVVM)][] é um padrão de projeto
que separa um recurso de um aplicativo em três partes:
o model, o view model e a view.
Views e view models compõem a camada de UI de um aplicativo.
Repositórios e serviços representam a camada de dados de um aplicativo,
ou a camada model do MVVM.

Um comando é uma classe que envolve um método
e ajuda a lidar com os diferentes estados desse método,
como em execução, concluído e erro.

[View models][] podem usar comandos para lidar com a interação e executar ações.
Além disso, eles podem ser usados ​​para exibir diferentes estados da UI,
como indicadores de carregamento quando uma ação está em execução,
ou uma caixa de diálogo de erro quando uma ação falhou.

Os view models podem se tornar muito complexos
à medida que um aplicativo cresce
e os recursos se tornam maiores.
Os comandos podem ajudar a simplificar os view models
e reutilizar o código.

Neste guia, você aprenderá
como usar o padrão command
para melhorar seus view models.

## Desafios ao implementar view models

As classes view model no Flutter são normalmente implementadas
estendendo a classe [`ChangeNotifier`][].
Isso permite que os view models chamem `notifyListeners()` para atualizar as views
quando os dados são atualizados.

<?code-excerpt "lib/no_command.dart (HomeViewModel2)" replace="/2//g"?>
```dart
class HomeViewModel extends ChangeNotifier {
  // ···
}
```

Os view models contêm uma representação do estado da UI,
incluindo os dados que estão sendo exibidos.
Por exemplo, este `HomeViewModel` expõe a instância `User` para a view.

<?code-excerpt "lib/no_command.dart (getUser)" replace="/null;/\/\/ .../g;/2//g"?>
```dart
class HomeViewModel extends ChangeNotifier {

  User? get user => // ...
  // ···
}
```

Os view models também contêm ações normalmente acionadas pela view;
por exemplo, uma ação `load` encarregada de carregar o `user`.

<?code-excerpt "lib/no_command.dart (load1)" replace="/null;/\/\/ .../g;/2//g"?>
```dart
class HomeViewModel extends ChangeNotifier {

  User? get user => // ...
  // ···
  void load() {
    // carregar usuário
  }
  // ···
}
```

### Estado da UI em view models

Um view model também contém o estado da UI além dos dados, como
se a view está em execução ou se ocorreu um erro.
Isso permite que o aplicativo informe ao usuário se a ação foi concluída com sucesso.

<?code-excerpt "lib/no_command.dart (UiState1)" replace="/(null|false);/\/\/ .../g;/2//g"?>
```dart
class HomeViewModel extends ChangeNotifier {

  User? get user => // ...

  bool get running => // ...

  Exception? get error => // ...

  void load() {
    // carregar usuário
  }
  // ···
}
```

Você pode usar o estado de execução para exibir um indicador de progresso na view:

<?code-excerpt "lib/no_command.dart (ListenableBuilder)" replace="/\.load//g;/body: //g;/^\),$/)/g"?>
```dart
ListenableBuilder(
  listenable: widget.viewModel,
  builder: (context, _) {
    if (widget.viewModel.running) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    // ···
  },
)
```

Ou use o estado de execução para evitar a execução da ação várias vezes:

<?code-excerpt "lib/no_command.dart (load2)" replace="/2//g"?>
```dart
void load() {
  if (running) {
    return;
  }
  // carregar usuário
}

```

Gerenciar o estado de uma ação pode se tornar complicado
se o view model contiver várias ações.
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
    // carregar usuário
  }

  void edit(String name) {
    // editar usuário
  }
}
```

Compartilhar o estado de execução
entre as ações `load()` e `edit()` pode nem sempre funcionar,
porque você pode querer mostrar um componente de UI diferente
quando a ação `load()` é executada do que quando a ação `edit()` é executada,
e você terá o mesmo problema com o estado de `error`.

### Acionando ações da UI a partir de view models

As classes view model podem ter problemas quando
executam ações de UI e o estado do view model muda.

Por exemplo, você pode querer mostrar um `SnackBar` quando ocorre um erro,
ou navegar para uma tela diferente quando uma ação é concluída.
Para implementar isso, ouça as mudanças no view model,
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
    // Mostrar Snackbar
  }
}
```

Você precisa limpar o estado de erro cada vez que executar esta ação,
caso contrário, esta ação acontecerá cada vez que `notifyListeners()` for chamado.

<?code-excerpt "lib/no_command.dart (_onViewModelChanged)"?>
```dart
void _onViewModelChanged() {
  if (widget.viewModel.error != null) {
    widget.viewModel.clearError();
    // Mostrar Snackbar
  }
}
```

## Padrão Command

Você pode se ver repetindo o código acima várias vezes,
implementando um estado de execução diferente
para cada ação em cada view model.
Nesse ponto, faz sentido extrair esse código
em um padrão reutilizável: um comando.

Um comando é uma classe que encapsula uma ação do view model,
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
    // executar _action
  }

  void clear() {
    // limpar estado
  }
}
```

No view model,
em vez de definir uma ação diretamente com um método,
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
    // carregar usuário
  }
}
```

O método `load()` anterior torna-se `_load()`,
e em vez disso o comando `load` é exposto à View.
Os estados `running` e `error` anteriores podem ser removidos,
pois agora fazem parte do comando.

### Executando um comando

Em vez de chamar `viewModel.load()` para executar a ação de carregamento,
agora você chama `viewModel.load.execute()`.

O método `execute()` também pode ser chamado de dentro do view model.
A linha de código a seguir executa o comando `load` quando o
view model é criado.

<?code-excerpt "lib/main.dart (ViewModelInit)"?>
```dart
HomeViewModel() {
  load = Command(_load)..execute();
}
```

O método `execute()` define o estado de execução como `true`
e redefine os estados `error` e `completed`.
Quando a ação termina,
o estado `running` muda para `false`
e o estado `completed` para `true`.

Se o estado `running` for `true`, o comando não pode começar a ser executado novamente.
Isso impede que os usuários acionem um comando várias vezes pressionando um botão rapidamente.

O método `execute()` do comando captura quaisquer `Exceptions` lançadas
automaticamente e os expõe no estado `error`.

O código a seguir mostra uma amostra da classe `Command` que
foi simplificado para fins de demonstração.
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

### Ouvindo o estado do comando

A classe `Command` estende de `ChangeNotifier`,
permitindo que as Views ouçam seus estados.

No `ListenableBuilder`,
em vez de passar o view model para `ListenableBuilder.listenable`,
passe o comando:

<?code-excerpt "lib/main.dart (CommandListenable)" replace="/body: //g;/^\),$/)/g"?>
```dart
ListenableBuilder(
  listenable: widget.viewModel.load,
  builder: (context, child) {
    if (widget.viewModel.load.running) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  // ···
)
```

E ouça as mudanças no estado do comando para executar ações de UI:

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
    // Mostrar Snackbar
  }
}
```

### Combinando comando e ViewModel

Você pode empilhar vários widgets `ListenableBuilder` para ouvir `running`
e os estados de `error` antes de mostrar os dados do view model.

<?code-excerpt "lib/main.dart (ListenableBuilder)"?>
```dart
body: ListenableBuilder(
  listenable: widget.viewModel.load,
  builder: (context, child) {
    if (widget.viewModel.load.running) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (widget.viewModel.load.error != null) {
      return Center(
        child: Text('Erro: ${widget.viewModel.load.error}'),
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

Você pode definir várias classes de comandos em um único view model,
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
    // carregar usuário
  }

  Future<void> _delete() async {
    // deletar usuário
  }
}
```

### Estendendo o padrão Command

O padrão Command pode ser estendido de várias maneiras.
Por exemplo, para suportar um número diferente de argumentos.

<?code-excerpt "lib/extended_command.dart (HomeViewModel)" replace="/null;/\/\/ .../g"?>
```dart
class HomeViewModel extends ChangeNotifier {
  HomeViewModel() {
    load = Command0(_load)..execute();
    edit = Command1<String>(_edit);
  }

  User? get user => // ...

  // Command0 aceita 0 argumentos
  late final Command0 load;

  // Command1 aceita 1 argumento
  late final Command1 edit;

  Future<void> _load() async {
    // carregar usuário
  }

  Future<void> _edit(String name) async {
    // editar usuário
  }
}
```

## Juntando tudo

Neste guia,
você aprendeu como usar o padrão de projeto command
para melhorar a implementação de view models
ao usar o padrão de projeto MVVM.

Abaixo, você pode encontrar a classe `Command` completa
conforme implementada no [exemplo do aplicativo Compass][]
para as diretrizes de arquitetura do Flutter.
Ele também usa a [`classe Result`][]
para determinar se a ação foi concluída com sucesso ou com um erro.

Esta implementação também inclui dois tipos de comandos,
um `Command0`, para ações sem parâmetros,
e um `Command1`, para ações que recebem um parâmetro.

:::note
Verifique [pub.dev][] para outras
implementações prontas para uso do padrão command,
como o pacote [`flutter_command`][].
:::

<?code-excerpt "lib/command.dart"?>
```dart
// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';

import 'result.dart';

/// Define uma ação de comando que retorna um [Result] do tipo [T].
/// Usado por [Command0] para ações sem argumentos.
typedef CommandAction0<T> = Future<Result<T>> Function();

/// Define uma ação de comando que retorna um [Result] do tipo [T].
/// Recebe um argumento do tipo [A].
/// Usado por [Command1] para ações com um argumento.
typedef CommandAction1<T, A> = Future<Result<T>> Function(A);

/// Facilita a interação com um view model.
///
/// Encapsula uma ação,
/// expõe seus estados de execução e erro,
/// e garante que ele não possa ser iniciado novamente até que termine.
///
/// Use [Command0] para ações sem argumentos.
/// Use [Command1] para ações com um argumento.
///
/// As ações devem retornar um [Result] do tipo [T].
///
/// Consuma o resultado da ação ouvindo as mudanças,
/// então chame [clearResult] quando o estado for consumido.
abstract class Command<T> extends ChangeNotifier {
  bool _running = false;

  /// Indica se a ação está em execução.
  bool get running => _running;

  Result<T>? _result;

  /// Indica se a ação foi concluída com um erro.
  bool get error => _result is Error;

  /// Indica se a ação foi concluída com sucesso.
  bool get completed => _result is Ok;

  /// O resultado da ação mais recente.
  ///
  /// Retorna `null` se a ação estiver em execução ou for concluída com um erro.
  Result<T>? get result => _result;

  /// Limpa o resultado da ação mais recente.
  void clearResult() {
    _result = null;
    notifyListeners();
  }

  /// Executa a [ação] fornecida, notificando os listeners e
  /// definindo os estados de execução e resultado conforme necessário.
  Future<void> _execute(CommandAction0<T> action) async {
    // Garante que a ação não possa ser iniciada várias vezes.
    // ex: evitar vários toques em um botão
    if (_running) return;

    // Notifica os listeners.
    // ex: o botão mostra o estado de carregamento
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

/// Um [Command] que não aceita argumentos.
final class Command0<T> extends Command<T> {
  /// Cria um [Command0] com o [CommandAction0] fornecido.
  Command0(this._action);

  final CommandAction0<T> _action;

  /// Executa a ação.
  Future<void> execute() async {
    await _execute(() => _action());
  }
}

/// Um [Command] que aceita um argumento.
final class Command1<T, A> extends Command<T> {
  /// Cria um [Command1] com o [CommandAction1] fornecido.
  Command1(this._action);

  final CommandAction1<T, A> _action;

  /// Executa a ação com o [argumento] especificado.
  Future<void> execute(A argument) async {
    await _execute(() => _action(argument));
  }
}
```

[exemplo do aplicativo Compass]: {{site.repo.samples}}/tree/main/compass_app
[`classe Result`]: /app-architecture/design-patterns/result
[pub.dev]: {{site.pub}}
[`flutter_command`]: {{site.pub-pkg}}/flutter_command
[`ChangeNotifier`]: /get-started/fundamentals/state-management
[Model-View-ViewModel (MVVM)]: /app-architecture/guide#view-models
[View models]: /app-architecture/guide#view-models
