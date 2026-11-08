---
ia-translate: true
title: "Arquitetura de armazenamento persistente: Dados chave-valor"
description: Salve dados da aplicação em um armazenamento chave-valor no dispositivo do usuário.
contentTags:
  - data
  - shared-preferences
  - dark mode
iconPath: /assets/images/docs/app-architecture/design-patterns/kv-store-icon.svg
order: 1
---

<?code-excerpt path-base="app-architecture/todo_data_service"?>

A maioria das aplicações Flutter, não importa quão pequenas ou grandes sejam,
requer armazenar dados no dispositivo do usuário em algum momento, como chaves de API,
preferências do usuário ou dados que devem estar disponíveis offline.

Nesta receita, você aprenderá como integrar armazenamento persistente
para dados chave-valor em uma aplicação Flutter
que usa o [design de arquitetura Flutter][Flutter architecture design] recomendado.
Se você não está familiarizado com armazenamento de dados em disco,
você pode ler a receita [Store key-value data on disk][Store key-value data on disk].

Armazenamentos chave-valor são frequentemente usados para salvar dados simples,
como configuração do app,
e nesta receita você usará para salvar preferências de Dark Mode.
Se você quiser aprender como armazenar dados complexos em um dispositivo,
você provavelmente vai querer usar SQL.
Nesse caso, dê uma olhada na receita do cookbook
que segue esta chamada [Persistent Storage Architecture: SQL][Persistent Storage Architecture: SQL].

## Aplicação de exemplo: App com seleção de tema

A aplicação de exemplo consiste em uma única tela com uma app bar no topo,
uma lista de itens e um campo de texto de entrada na parte inferior.

<img src='/assets/images/docs/cookbook/architecture/todo_app_light.png'
class="site-mobile-screenshot" alt="ToDo application in light mode" >

Na `AppBar`,
um `Switch` permite que usuários mudem entre os modos de tema escuro e claro.
Esta configuração é aplicada imediatamente e é armazenada no dispositivo
usando um serviço de armazenamento de dados chave-valor.
A configuração é restaurada quando o usuário inicia a aplicação novamente.

<img src='/assets/images/docs/cookbook/architecture/todo_app_dark.png'
class="site-mobile-screenshot" alt="ToDo application in dark mode" >

:::note
O código-fonte completo e executável para este exemplo está
disponível em [`/examples/app-architecture/todo_data_service/`][`/examples/app-architecture/todo_data_service/`].
:::

## Armazenando dados chave-valor de seleção de tema

Esta funcionalidade segue o padrão de design de arquitetura Flutter recomendado,
com uma camada de apresentação e uma camada de dados.

- A camada de apresentação contém o widget `ThemeSwitch`
e o `ThemeSwitchViewModel`.
- A camada de dados contém o `ThemeRepository`
e o `SharedPreferencesService`.

### Camada de apresentação da seleção de tema

O `ThemeSwitch` é um `StatelessWidget` que contém um widget `Switch`.
O estado do switch é representado
pelo campo público `isDarkMode` no `ThemeSwitchViewModel`.
Quando o usuário toca no switch,
o código executa o command `toggle` no view model.

<?code-excerpt "lib/ui/theme_config/widgets/theme_switch.dart (ThemeSwitch)"?>
```dart
class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key, required this.viewmodel});

  final ThemeSwitchViewModel viewmodel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const Text('Dark Mode'),
          ListenableBuilder(
            listenable: viewmodel,
            builder: (context, _) {
              return Switch(
                value: viewmodel.isDarkMode,
                onChanged: (_) {
                  viewmodel.toggle.execute();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
```

O `ThemeSwitchViewModel` implementa um view model
como descrito no padrão MVVM.
Este view model contém o estado do widget `ThemeSwitch`,
representado pela variável booleana `_isDarkMode`.

O view model usa o `ThemeRepository`
para armazenar e carregar a configuração de modo escuro.

Ele contém duas ações de command diferentes:
`load`, que carrega a configuração de modo escuro do repositório,
e `toggle`, que alterna o estado entre modo escuro e modo claro.
Ele expõe o estado através do getter `isDarkMode`.

O método `_load` implementa o command `load`.
Este método chama `ThemeRepository.isDarkMode`
para obter a configuração armazenada e chama `notifyListeners()` para atualizar a UI.

O método `_toggle` implementa o command `toggle`.
Este método chama `ThemeRepository.setDarkMode`
para armazenar a nova configuração de modo escuro.
Além disso, ele muda o estado local de `_isDarkMode`
e então chama `notifyListeners()` para atualizar a UI.

<?code-excerpt "lib/ui/theme_config/viewmodel/theme_switch_viewmodel.dart (ThemeSwitchViewModel)"?>
```dart
class ThemeSwitchViewModel extends ChangeNotifier {
  ThemeSwitchViewModel(this._themeRepository) {
    load = Command0(_load)..execute();
    toggle = Command0(_toggle);
  }

  final ThemeRepository _themeRepository;

  bool _isDarkMode = false;

  /// If true show dark mode
  bool get isDarkMode => _isDarkMode;

  late final Command0<void> load;

  late final Command0<void> toggle;

  /// Load the current theme setting from the repository
  Future<Result<void>> _load() async {
    final result = await _themeRepository.isDarkMode();
    if (result is Ok<bool>) {
      _isDarkMode = result.value;
    }
    notifyListeners();
    return result;
  }

  /// Toggle the theme setting
  Future<Result<void>> _toggle() async {
    _isDarkMode = !_isDarkMode;
    final result = await _themeRepository.setDarkMode(_isDarkMode);
    notifyListeners();
    return result;
  }
}
```

### Camada de dados da seleção de tema

Seguindo as diretrizes de arquitetura,
a camada de dados é dividida em duas partes:
o `ThemeRepository` e o `SharedPreferencesService`.

O `ThemeRepository` é a única fonte de verdade
para todas as configurações de tema,
e lida com quaisquer possíveis erros vindos da camada de serviço.

Neste exemplo,
o `ThemeRepository` também expõe a configuração de modo escuro
através de um `Stream` observável.
Isso permite que outras partes da aplicação
se inscrevam em mudanças na configuração de modo escuro.

O `ThemeRepository` depende do `SharedPreferencesService`.
O repositório obtém o valor armazenado do serviço,
e o armazena quando ele muda.

O método `setDarkMode()` passa o novo valor para o `StreamController`,
para que qualquer componente escutando o stream `observeDarkMode`


<?code-excerpt "lib/data/repositories/theme_repository.dart (ThemeRepository)"?>
```dart
class ThemeRepository {
  ThemeRepository(this._service);

  final _darkModeController = StreamController<bool>.broadcast();

  final SharedPreferencesService _service;

  /// Get if dark mode is enabled
  Future<Result<bool>> isDarkMode() async {
    try {
      final value = await _service.isDarkMode();
      return Result.ok(value);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  /// Set dark mode
  Future<Result<void>> setDarkMode(bool value) async {
    try {
      await _service.setDarkMode(value);
      _darkModeController.add(value);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  /// Stream that emits theme config changes.
  /// ViewModels should call [isDarkMode] to get the current theme setting.
  Stream<bool> observeDarkMode() => _darkModeController.stream;
}
```

O `SharedPreferencesService` encapsula
a funcionalidade do plugin `SharedPreferences`,
e chama os métodos `setBool()` e `getBool()`
para armazenar a configuração de modo escuro,
ocultando esta dependência de terceiros do resto da aplicação

:::note
Uma dependência de terceiros é uma forma de se referir a pacotes e plugins
desenvolvidos por outros programadores fora da sua organização.
:::

<?code-excerpt "lib/data/services/shared_preferences_service.dart (SharedPreferencesService)"?>
```dart
class SharedPreferencesService {
  static const String _kDarkMode = 'darkMode';

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDarkMode, value);
  }

  Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kDarkMode) ?? false;
  }
}
```

## Juntando tudo

Neste exemplo,
o `ThemeRepository` e `SharedPreferencesService` são criados
no método `main()`
e passados para o `MainApp` como argumento de dependência do construtor.

<?code-excerpt "lib/main.dart (MainTheme)"?>
```dart
void main() {
  // ···
  runApp(
    MainApp(
      themeRepository: ThemeRepository(SharedPreferencesService()),
      // ···
    ),
  );
}
```

Então, quando o `ThemeSwitch` é criado,
também crie o `ThemeSwitchViewModel`
e passe o `ThemeRepository` como dependência.

<?code-excerpt "lib/main.dart (AddThemeSwitch)"?>
```dart
ThemeSwitch(
  viewmodel: ThemeSwitchViewModel(widget.themeRepository),
),
```

A aplicação de exemplo também inclui a classe `MainAppViewModel`,
que escuta mudanças no `ThemeRepository`
e expõe a configuração de modo escuro para o widget `MaterialApp`.

<?code-excerpt "lib/main_app_viewmodel.dart (MainAppViewModel)"?>
```dart
class MainAppViewModel extends ChangeNotifier {
  MainAppViewModel(this._themeRepository) {
    _subscription = _themeRepository.observeDarkMode().listen((isDarkMode) {
      _isDarkMode = isDarkMode;
      notifyListeners();
    });
    _load();
  }

  final ThemeRepository _themeRepository;
  StreamSubscription<bool>? _subscription;

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  Future<void> _load() async {
    final result = await _themeRepository.isDarkMode();
    if (result is Ok<bool>) {
      _isDarkMode = result.value;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
```

<?code-excerpt "lib/main.dart (ListenableBuilder)" replace="/^return //g;/},$/},\n  child: \/\/...\n)/g"?>
```dart
ListenableBuilder(
  listenable: _viewModel,
  builder: (context, child) {
    return MaterialApp(
      theme: _viewModel.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: child,
    );
  },
  child: //...
)
```

[Flutter architecture design]: /app-architecture
[Store key-value data on disk]: /cookbook/persistence/key-value
[Persistent Storage Architecture: SQL]: /app-architecture/design-patterns/sql
[`/examples/app-architecture/todo_data_service/`]: {{site.repo.this}}/tree/main/examples/app-architecture/todo_data_service/
