---
ia-translate: true
title: Criar um fluxo de navegação aninhado
description: Como implementar um fluxo com navegação aninhada.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/effects/nested_nav"?>

Aplicativos acumulam dezenas e depois centenas de rotas ao longo do tempo.
Algumas de suas rotas fazem sentido como rotas de nível superior (globais).
Por exemplo, "/", "perfil", "contato", "feed_social" são todas rotas
de nível superior possíveis dentro de seu aplicativo.
Mas, imagine que você definiu todas as rotas possíveis em seu widget
`Navigator` de nível superior. A lista seria muito longa,
e muitas dessas rotas seriam melhor tratadas aninhadas dentro de outro widget.

Considere um fluxo de configuração de Internet das Coisas (IoT) para uma
lâmpada sem fio que você controla com seu aplicativo.
Este fluxo de configuração consiste em 4 páginas:
encontrar lâmpadas próximas, selecionar a lâmpada que você deseja adicionar,
adicionar a lâmpada e, em seguida, concluir a configuração.
Você pode orquestrar esse comportamento a partir do seu widget
`Navigator` de nível superior. No entanto, faz mais sentido definir um segundo
widget `Navigator` aninhado dentro de seu widget `SetupFlow` e
deixar o `Navigator` aninhado assumir a propriedade das 4 páginas
no fluxo de configuração. Essa delegação de navegação facilita
um maior controle local, o que geralmente é preferível ao desenvolver software.

A animação a seguir mostra o comportamento do aplicativo:

![Gif mostrando o fluxo aninhado de "configuração"](/assets/images/docs/cookbook/effects/NestedNavigator.gif){:.site-mobile-screenshot}

Nesta receita, você implementa um fluxo de configuração de IoT de quatro páginas
que mantém sua própria navegação aninhada abaixo do widget
`Navigator` de nível superior.

## Prepare-se para a navegação

Este aplicativo IoT tem duas telas de nível superior,
junto com o fluxo de configuração. Defina esses
nomes de rotas como constantes para que possam ser
referenciados dentro do código.

<?code-excerpt "lib/main.dart (routes)"?>
```dart
const routeHome = '/';
const routeSettings = '/settings';
const routePrefixDeviceSetup = '/setup/';
const routeDeviceSetupStart = '/setup/$routeDeviceSetupStartPage';
const routeDeviceSetupStartPage = 'find_devices';
const routeDeviceSetupSelectDevicePage = 'select_device';
const routeDeviceSetupConnectingPage = 'connecting';
const routeDeviceSetupFinishedPage = 'finished';
```

As telas inicial e de configurações são referenciadas com
nomes estáticos. As páginas do fluxo de configuração, no entanto,
usam dois caminhos para criar seus nomes de rotas:
um prefixo `/setup/` seguido pelo nome da página específica.
Ao combinar os dois caminhos, seu `Navigator` pode determinar
que um nome de rota se destina ao fluxo de configuração sem
reconhecer todas as páginas individuais associadas ao
fluxo de configuração.

O `Navigator` de nível superior não é responsável por identificar
páginas de fluxo de configuração individuais. Portanto, seu
`Navigator` de nível superior precisa analisar o nome da rota de entrada para
identificar o prefixo do fluxo de configuração. A necessidade de analisar o nome da rota
significa que você não pode usar a propriedade `routes` do seu
`Navigator` de nível superior. Em vez disso, você deve fornecer uma função para a
propriedade `onGenerateRoute`.

Implemente `onGenerateRoute` para retornar o widget apropriado
para cada um dos três caminhos de nível superior.

<?code-excerpt "lib/main.dart (OnGenerateRoute)"?>
```dart
onGenerateRoute: (settings) {
  final Widget page;
  if (settings.name == routeHome) {
    page = const HomeScreen();
  } else if (settings.name == routeSettings) {
    page = const SettingsScreen();
  } else if (settings.name!.startsWith(routePrefixDeviceSetup)) {
    final subRoute =
        settings.name!.substring(routePrefixDeviceSetup.length);
    page = SetupFlow(
      setupPageRoute: subRoute,
    );
  } else {
    throw Exception('Unknown route: ${settings.name}');
  }

  return MaterialPageRoute<dynamic>(
    builder: (context) {
      return page;
    },
    settings: settings,
  );
},
```

Observe que as rotas inicial e de configurações são correspondidas com nomes de rotas exatos.
No entanto, a condição da rota do fluxo de configuração verifica apenas
um prefixo. Se o nome da rota contiver o prefixo de configuração
fluxo, então o resto do nome da rota é ignorado
e passado para o widget `SetupFlow` para processar.
Essa divisão do nome da rota é o que permite que o nível superior
`Navigator` seja agnóstico em relação às várias subrotas
dentro do fluxo de configuração.

Crie um widget stateful chamado `SetupFlow` que
aceita um nome de rota.

<?code-excerpt "lib/setupflow.dart (SetupFlow)" replace="/@override\n*.*\n\s*return const SizedBox\(\);\n\s*}/\/\/.../g"?>
```dart
class SetupFlow extends StatefulWidget {
  const SetupFlow({
    super.key,
    required this.setupPageRoute,
  });

  final String setupPageRoute;

  @override
  State<SetupFlow> createState() => SetupFlowState();
}

class SetupFlowState extends State<SetupFlow> {
  //...
}
```

## Exibir uma barra de aplicativo para o fluxo de configuração

O fluxo de configuração exibe uma barra de aplicativo persistente
que aparece em todas as páginas.

Retorne um widget `Scaffold` do método `build()` do seu `SetupFlow` e
inclua o widget `AppBar` desejado.

<?code-excerpt "lib/setupflow2.dart (SetupFlow2)"?>
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: _buildFlowAppBar(),
    body: const SizedBox(),
  );
}

PreferredSizeWidget _buildFlowAppBar() {
  return AppBar(
    title: const Text('Configuração da Lâmpada'),
  );
}
```

A barra de aplicativos exibe uma seta para trás e sai da configuração
fluxo quando a seta para trás é pressionada. No entanto,
sair do fluxo faz com que o usuário perca todo o progresso.
Portanto, o usuário é solicitado a confirmar se ele
quer sair do fluxo de configuração.

Solicite ao usuário que confirme a saída do fluxo de configuração e
garanta que o prompt apareça quando o usuário
pressionar o botão de voltar do hardware no Android.

<?code-excerpt "lib/prompt_user.dart (PromptUser)"?>
```dart
Future<void> _onExitPressed() async {
  final isConfirmed = await _isExitDesired();

  if (isConfirmed && mounted) {
    _exitSetup();
  }
}

Future<bool> _isExitDesired() async {
  return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Tem certeza?'),
              content: const Text(
                  'Se você sair da configuração do dispositivo, seu progresso será perdido.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Sair'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Ficar'),
                ),
              ],
            );
          }) ??
      false;
}

void _exitSetup() {
  Navigator.of(context).pop();
}

@override
Widget build(BuildContext context) {
  return PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, _) async {
      if (didPop) return;

      if (await _isExitDesired() && context.mounted) {
        _exitSetup();
      }
    },
    child: Scaffold(
      appBar: _buildFlowAppBar(),
      body: const SizedBox(),
    ),
  );
}

PreferredSizeWidget _buildFlowAppBar() {
  return AppBar(
    leading: IconButton(
      onPressed: _onExitPressed,
      icon: const Icon(Icons.chevron_left),
    ),
    title: const Text('Configuração da Lâmpada'),
  );
}
```

Quando o usuário toca na seta para trás na barra de aplicativos ou
pressiona o botão de voltar no Android,
uma caixa de diálogo de alerta aparece para confirmar que o
usuário deseja sair do fluxo de configuração.
Se o usuário pressionar **Sair**, o fluxo de configuração se removerá
da pilha de navegação de nível superior.
Se o usuário pressionar **Ficar**, a ação será ignorada.

Você pode notar que o `Navigator.pop()`
é invocado pelos botões **Sair** e
**Ficar**. Para deixar claro,
esta ação `pop()` remove a caixa de diálogo de alerta
da pilha de navegação, não o fluxo de configuração.

## Gerar rotas aninhadas

O trabalho do fluxo de configuração é exibir o apropriado
página dentro do fluxo.

Adicione um widget `Navigator` ao `SetupFlow` e
implemente a propriedade `onGenerateRoute`.

<?code-excerpt "lib/add_navigator.dart (AddNavigator)"?>
```dart
final _navigatorKey = GlobalKey<NavigatorState>();

void _onDiscoveryComplete() {
  _navigatorKey.currentState!.pushNamed(routeDeviceSetupSelectDevicePage);
}

void _onDeviceSelected(String deviceId) {
  _navigatorKey.currentState!.pushNamed(routeDeviceSetupConnectingPage);
}

void _onConnectionEstablished() {
  _navigatorKey.currentState!.pushNamed(routeDeviceSetupFinishedPage);
}

@override
Widget build(BuildContext context) {
  return PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, _) async {
      if (didPop) return;

      if (await _isExitDesired() && context.mounted) {
        _exitSetup();
      }
    },
    child: Scaffold(
      appBar: _buildFlowAppBar(),
      body: Navigator(
        key: _navigatorKey,
        initialRoute: widget.setupPageRoute,
        onGenerateRoute: _onGenerateRoute,
      ),
    ),
  );
}

Route<Widget> _onGenerateRoute(RouteSettings settings) {
  final page = switch (settings.name) {
    routeDeviceSetupStartPage => WaitingPage(
        message: 'Buscando lâmpadas próximas...',
        onWaitComplete: _onDiscoveryComplete,
      ),
    routeDeviceSetupSelectDevicePage => SelectDevicePage(
        onDeviceSelected: _onDeviceSelected,
      ),
    routeDeviceSetupConnectingPage => WaitingPage(
        message: 'Conectando...',
        onWaitComplete: _onConnectionEstablished,
      ),
    routeDeviceSetupFinishedPage => FinishedPage(
        onFinishPressed: _exitSetup,
      ),
    _ => throw StateError('Nome de rota inesperado: ${settings.name}!')
  };

  return MaterialPageRoute(
    builder: (context) {
      return page;
    },
    settings: settings,
  );
}
```

A função `_onGenerateRoute` funciona da mesma forma que
para um `Navigator` de nível superior. Um `RouteSettings`
objeto é passado para a função,
que inclui o `name` da rota.
Com base nesse nome de rota,
uma das quatro páginas de fluxo é retornada.

A primeira página, chamada `find_devices`,
espera alguns segundos para simular a varredura de rede.
Após o período de espera, a página invoca seu callback.
Neste caso, esse callback é `_onDiscoveryComplete`.
O fluxo de configuração reconhece que, quando a descoberta do dispositivo
está concluída, a página de seleção do dispositivo deve ser mostrada.
Portanto, em `_onDiscoveryComplete`, o `_navigatorKey`
instrui o `Navigator` aninhado a navegar para o
página `select_device`.

A página `select_device` pede ao usuário para selecionar um
dispositivo de uma lista de dispositivos disponíveis. Nesta receita,
apenas um dispositivo é apresentado ao usuário.
Quando o usuário toca em um dispositivo, o callback `onDeviceSelected`
é invocado. O fluxo de configuração reconhece que,
quando um dispositivo é selecionado, a página de conexão
deve ser mostrada. Portanto, em `_onDeviceSelected`,
o `_navigatorKey` instrui o `Navigator` aninhado
para navegar até a página `"connecting"`.

A página `connecting` funciona da mesma forma que a
página `find_devices`. A página `connecting` espera
por alguns segundos e então invoca seu callback.
Neste caso, o callback é `_onConnectionEstablished`.
O fluxo de configuração reconhece que, quando uma conexão é estabelecida,
a página final deve ser mostrada. Portanto,
em `_onConnectionEstablished`, o `_navigatorKey`
instrui o `Navigator` aninhado a navegar para o
página `finished`.

A página `finished` fornece ao usuário um botão **Finalizar**.
Quando o usuário toca em **Finalizar**,
o callback `_exitSetup` é invocado, o que remove todo o
fluxo de configuração da pilha `Navigator` de nível superior,
levando o usuário de volta à tela inicial.

Parabéns!
Você implementou a navegação aninhada com quatro subrotas.

## Exemplo interativo

Execute o aplicativo:

* Na tela **Adicione sua primeira lâmpada**,
  clique no FAB, mostrado com um sinal de mais, **+**.
  Isso leva você para a tela **Selecione um dispositivo próximo**.
  Uma única lâmpada está listada.
* Clique na lâmpada listada. Uma tela **Concluído!** aparece.
* Clique no botão **Concluído** para retornar ao
  primeira tela.

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de navegação aninhada Flutter no DartPad" run="true" height="640px"
import 'package:flutter/material.dart';

const routeHome = '/';
const routeSettings = '/settings';
const routePrefixDeviceSetup = '/setup/';
const routeDeviceSetupStart = '/setup/$routeDeviceSetupStartPage';
const routeDeviceSetupStartPage = 'find_devices';
const routeDeviceSetupSelectDevicePage = 'select_device';
const routeDeviceSetupConnectingPage = 'connecting';
const routeDeviceSetupFinishedPage = 'finished';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
        ),
      ),
      onGenerateRoute: (settings) {
        final Widget page;
        if (settings.name == routeHome) {
          page = const HomeScreen();
        } else if (settings.name == routeSettings) {
          page = const SettingsScreen();
        } else if (settings.name!.startsWith(routePrefixDeviceSetup)) {
          final subRoute =
              settings.name!.substring(routePrefixDeviceSetup.length);
          page = SetupFlow(
            setupPageRoute: subRoute,
          );
        } else {
          throw Exception('Unknown route: ${settings.name}');
        }

        return MaterialPageRoute<dynamic>(
          builder: (context) {
            return page;
          },
          settings: settings,
        );
      },
      debugShowCheckedModeBanner: false,
    ),
  );
}

@immutable
class SetupFlow extends StatefulWidget {
  static SetupFlowState of(BuildContext context) {
    return context.findAncestorStateOfType<SetupFlowState>()!;
  }

  const SetupFlow({
    super.key,
    required this.setupPageRoute,
  });

  final String setupPageRoute;

  @override
  SetupFlowState createState() => SetupFlowState();
}

class SetupFlowState extends State<SetupFlow> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  void _onDiscoveryComplete() {
    _navigatorKey.currentState!.pushNamed(routeDeviceSetupSelectDevicePage);
  }

  void _onDeviceSelected(String deviceId) {
    _navigatorKey.currentState!.pushNamed(routeDeviceSetupConnectingPage);
  }

  void _onConnectionEstablished() {
    _navigatorKey.currentState!.pushNamed(routeDeviceSetupFinishedPage);
  }

  Future<void> _onExitPressed() async {
    final isConfirmed = await _isExitDesired();

    if (isConfirmed && mounted) {
      _exitSetup();
    }
  }

  Future<bool> _isExitDesired() async {
    return await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Tem certeza?'),
                content: const Text(
                    'Se você sair da configuração do dispositivo, seu progresso será perdido.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Sair'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Ficar'),
                  ),
                ],
              );
            }) ??
        false;
  }

  void _exitSetup() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        if (await _isExitDesired() && context.mounted) {
          _exitSetup();
        }
      },
      child: Scaffold(
        appBar: _buildFlowAppBar(),
        body: Navigator(
          key: _navigatorKey,
          initialRoute: widget.setupPageRoute,
          onGenerateRoute: _onGenerateRoute,
        ),
      ),
    );
  }

  Route<Widget> _onGenerateRoute(RouteSettings settings) {
    final page = switch (settings.name) {
      routeDeviceSetupStartPage => WaitingPage(
          message: 'Buscando lâmpadas próximas...',
          onWaitComplete: _onDiscoveryComplete,
        ),
      routeDeviceSetupSelectDevicePage => SelectDevicePage(
          onDeviceSelected: _onDeviceSelected,
        ),
      routeDeviceSetupConnectingPage => WaitingPage(
          message: 'Conectando...',
          onWaitComplete: _onConnectionEstablished,
        ),
      routeDeviceSetupFinishedPage => FinishedPage(
          onFinishPressed: _exitSetup,
        ),
      _ => throw StateError('Nome de rota inesperado: ${settings.name}!')
    };

    return MaterialPageRoute(
      builder: (context) {
        return page;
      },
      settings: settings,
    );
  }

  PreferredSizeWidget _buildFlowAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: _onExitPressed,
        icon: const Icon(Icons.chevron_left),
      ),
      title: const Text('Configuração da Lâmpada'),
    );
  }
}

class SelectDevicePage extends StatelessWidget {
  const SelectDevicePage({
    super.key,
    required this.onDeviceSelected,
  });

  final void Function(String deviceId) onDeviceSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Selecione um dispositivo próximo:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateColor.resolveWith((states) {
                      return const Color(0xFF222222);
                    }),
                  ),
                  onPressed: () {
                    onDeviceSelected('22n483nk5834');
                  },
                  child: const Text(
                    'Lâmpada 22n483nk5834',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WaitingPage extends StatefulWidget {
  const WaitingPage({
    super.key,
    required this.message,
    required this.onWaitComplete,
  });

  final String message;
  final VoidCallback onWaitComplete;

  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  @override
  void initState() {
    super.initState();
    _startWaiting();
  }

  Future<void> _startWaiting() async {
    await Future<dynamic>.delayed(const Duration(seconds: 3));

    if (mounted) {
      widget.onWaitComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 32),
              Text(widget.message),
            ],
          ),
        ),
      ),
    );
  }
}

class FinishedPage extends StatelessWidget {
  const FinishedPage({
    super.key,
    required this.onFinishPressed,
  });

  final VoidCallback onFinishPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF222222),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.lightbulb,
                      size: 140,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Lâmpada adicionada!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.resolveWith((states) {
                      return const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12);
                    }),
                    backgroundColor: WidgetStateColor.resolveWith((states) {
                      return const Color(0xFF222222);
                    }),
                    shape: WidgetStateProperty.resolveWith((states) {
                      return const StadiumBorder();
                    }),
                  ),
                  onPressed: onFinishPressed,
                  child: const Text(
                    'Finalizar',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF222222),
                ),
                child: Center(
                  child: Icon(
                    Icons.lightbulb,
                    size: 140,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Adicione sua primeira lâmpada',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(routeDeviceSetupStart);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Bem-vindo'),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.pushNamed(context, routeSettings);
          },
        ),
      ],
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(8, (index) {
            return Container(
              width: double.infinity,
              height: 54,
              margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF222222),
              ),
            );
          }),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Configurações'),
    );
  }
}
