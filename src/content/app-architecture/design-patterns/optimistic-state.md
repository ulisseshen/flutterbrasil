---
ia-translate: true
title: Estado otimista
description: "Melhore a percepção de responsividade de uma aplicação implementando estado otimista."
contentTags:
  - user experience
  - asynchronous dart
iconPath: /assets/images/docs/app-architecture/design-patterns/optimistic-state-icon.svg
order: 0
---

<?code-excerpt path-base="app-architecture/optimistic_state"?>

Ao construir experiências de usuário,
a percepção de desempenho às vezes é tão importante quanto
o desempenho real do código.
Em geral, usuários não gostam de esperar uma ação terminar para ver o resultado,
e qualquer coisa que leva mais do que alguns milissegundos pode ser considerada "lenta"
ou "sem resposta" da perspectiva do usuário.

Desenvolvedores podem ajudar a mitigar essa percepção negativa
apresentando um estado de UI bem-sucedido
antes que a tarefa em segundo plano seja totalmente concluída.
Um exemplo disso seria tocar em um botão "Subscribe",
e vê-lo mudar para "Subscribed" instantaneamente,
mesmo se a chamada em segundo plano para a API de assinatura ainda estiver em execução.

Esta técnica é conhecida como Optimistic State, Optimistic UI ou
Optimistic User Experience.
Nesta receita,
você implementará uma funcionalidade de aplicação usando Optimistic State e
seguindo as [diretrizes de arquitetura Flutter][Flutter architecture guidelines].

## Funcionalidade de exemplo: um botão de inscrição

Este exemplo implementa um botão de inscrição similar ao
que você poderia encontrar em uma aplicação de streaming de vídeo ou uma newsletter.

<img src='/assets/images/docs/cookbook/architecture/optimistic-state.png'
class="site-mobile-screenshot" alt="Application with subscribe button" >

Quando o botão é tocado, a aplicação então chama uma API externa,
executando uma ação de assinatura,
por exemplo registrando em um banco de dados que o usuário agora está na
lista de assinaturas.
Para fins de demonstração, você não implementará o código backend real,
ao invés disso você substituirá esta chamada por
uma ação falsa que simulará uma requisição de rede.

No caso de a chamada ser bem-sucedida,
o texto do botão mudará de "Subscribe" para "Subscribed".
A cor de fundo do botão também mudará.

Ao contrário, se a chamada falhar,
o texto do botão deve reverter de volta para "Subscribe",
e a UI deve mostrar uma mensagem de erro ao usuário,
por exemplo usando um Snackbar.

Seguindo a ideia de Optimistic State,
o botão deve mudar instantaneamente para "Subscribed" uma vez que é tocado,
e apenas mudar de volta para "Subscribe" se a requisição falhar.

<img src='/assets/images/docs/cookbook/architecture/optimistic-state.webp'
class="site-mobile-screenshot" alt="Animation of application with subscribe button" >

## Arquitetura da funcionalidade

Comece definindo a arquitetura da funcionalidade.
Seguindo as diretrizes de arquitetura,
crie essas classes Dart em um projeto Flutter:

- Um `StatefulWidget` chamado `SubscribeButton`
- Uma classe chamada `SubscribeButtonViewModel` estendendo `ChangeNotifier`
- Uma classe chamada `SubscriptionRepository`

<?code-excerpt "lib/starter.dart (Starter)"?>
```dart
class SubscribeButton extends StatefulWidget {
  const SubscribeButton({super.key});

  @override
  State<SubscribeButton> createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<SubscribeButton> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class SubscribeButtonViewModel extends ChangeNotifier {}

class SubscriptionRepository {}
```

O widget `SubscribeButton` e o `SubscribeButtonViewModel` representam
a camada de apresentação desta solução.
O widget vai exibir um botão
que mostrará o texto "Subscribe" ou "Subscribed"
dependendo do estado da assinatura.
O view model conterá o estado da assinatura.
Quando o botão é tocado,
o widget chamará o view model para executar a ação.

O `SubscriptionRepository` implementará um método subscribe
que lançará uma exceção quando a ação falhar.
O view model chamará este método ao executar a ação de assinatura.

Em seguida, conecte-os juntos adicionando o `SubscriptionRepository`
ao `SubscribeButtonViewModel`:

<?code-excerpt "lib/main.dart (ViewModelStart)" replace="/y;$/y;\n}/g"?>
```dart
class SubscribeButtonViewModel extends ChangeNotifier {
  SubscribeButtonViewModel({required this.subscriptionRepository});

  final SubscriptionRepository subscriptionRepository;
}
```

E adicione o `SubscribeButtonViewModel` ao widget `SubscribeButton`:

<?code-excerpt "lib/main.dart (Widget)"?>
```dart
class SubscribeButton extends StatefulWidget {
  const SubscribeButton({super.key, required this.viewModel});

  /// Subscribe button view model.
  final SubscribeButtonViewModel viewModel;

  @override
  State<SubscribeButton> createState() => _SubscribeButtonState();
}
```

Agora que você criou a arquitetura básica da solução,
você pode criar o widget `SubscribeButton` da seguinte forma:

<?code-excerpt "lib/main.dart (SubscribeButton)" replace="/^child: //g;/^\),$/)/g"?>
```dart
SubscribeButton(
  viewModel: SubscribeButtonViewModel(
    subscriptionRepository: SubscriptionRepository(),
  ),
)
```
### Implemente o `SubscriptionRepository`

Adicione um novo método assíncrono chamado `subscribe()`
ao `SubscriptionRepository` com o seguinte código:

<?code-excerpt "lib/main.dart (SubscriptionRepository)"?>
```dart
class SubscriptionRepository {
  /// Simulates a network request and then fails.
  Future<void> subscribe() async {
    // Simulate a network request
    await Future.delayed(const Duration(seconds: 1));
    // Fail after one second
    throw Exception('Failed to subscribe');
  }
}
```

A chamada a `await Future.delayed()` com duração de um segundo
foi adicionada para simular uma requisição de longa duração.
A execução do método pausará por um segundo e então continuará executando.

Para simular uma requisição falhando,
o método subscribe lança uma exceção no final.
Isso será usado mais tarde para mostrar como se recuperar de uma requisição falhada
ao implementar Optimistic State.

### Implemente o `SubscribeButtonViewModel`

Para representar o estado da assinatura, bem como um possível estado de erro,
adicione os seguintes membros públicos ao `SubscribeButtonViewModel`:

<?code-excerpt "lib/main.dart (States)"?>
```dart
// Whether the user is subscribed
bool subscribed = false;

// Whether the subscription action has failed
bool error = false;
```

Ambos são definidos como `false` no início.

Seguindo as ideias de Optimistic State,
o estado `subscribed` mudará para `true`
assim que o usuário tocar no botão de inscrição.
E apenas mudará de volta para `false` se a ação falhar.

O estado `error` mudará para `true` quando a ação falhar,
indicando ao widget `SubscribeButton` para mostrar uma mensagem de erro ao usuário.
A variável deve voltar para `false` uma vez que o erro foi exibido.

Em seguida, implemente um método assíncrono `subscribe()`:

<?code-excerpt "lib/main.dart (subscribe)"?>
```dart
// Subscription action
Future<void> subscribe() async {
  // Ignore taps when subscribed
  if (subscribed) {
    return;
  }

  // Optimistic state.
  // It will be reverted if the subscription fails.
  subscribed = true;
  // Notify listeners to update the UI
  notifyListeners();

  try {
    await subscriptionRepository.subscribe();
  } catch (e) {
    print('Failed to subscribe: $e');
    // Revert to the previous state
    subscribed = false;
    // Set the error state
    error = true;
  } finally {
    notifyListeners();
  }
}
```

Como descrito anteriormente, primeiro o método define o estado `subscribed` como `true`
e então chama `notifyListeners()`.
Isso força a UI a atualizar e o botão muda sua aparência,
mostrando o texto "Subscribed" ao usuário.

Então o método executa a chamada real ao repositório.
Esta chamada é envolvida por um `try-catch`
para capturar quaisquer exceções que possa lançar.
Caso uma exceção seja capturada, o estado `subscribed` é definido de volta para `false`,
e o estado `error` é definido como `true`.
Uma chamada final a `notifyListeners()` é feita
para mudar a UI de volta para 'Subscribe'.

Se não houver exceção, o processo está completo
porque a UI já está refletindo o estado de sucesso.

O `SubscribeButtonViewModel` completo deve ficar assim:

<?code-excerpt "lib/main.dart (ViewModelFull)"?>
```dart
/// Subscribe button View Model.
/// Handles the subscribe action and exposes the state to the subscription.
class SubscribeButtonViewModel extends ChangeNotifier {
  SubscribeButtonViewModel({required this.subscriptionRepository});

  final SubscriptionRepository subscriptionRepository;

  // Whether the user is subscribed
  bool subscribed = false;

  // Whether the subscription action has failed
  bool error = false;

  // Subscription action
  Future<void> subscribe() async {
    // Ignore taps when subscribed
    if (subscribed) {
      return;
    }

    // Optimistic state.
    // It will be reverted if the subscription fails.
    subscribed = true;
    // Notify listeners to update the UI
    notifyListeners();

    try {
      await subscriptionRepository.subscribe();
    } catch (e) {
      print('Failed to subscribe: $e');
      // Revert to the previous state
      subscribed = false;
      // Set the error state
      error = true;
    } finally {
      notifyListeners();
    }
  }

}
```

### Implemente o `SubscribeButton`

Neste passo,
você primeiro implementará o método build do `SubscribeButton`,
e então implementará o tratamento de erros da funcionalidade.

Adicione o seguinte código ao método build:

<?code-excerpt "lib/main.dart (build)"?>
```dart
@override
Widget build(BuildContext context) {
  return ListenableBuilder(
    listenable: widget.viewModel,
    builder: (context, _) {
      return FilledButton(
        onPressed: widget.viewModel.subscribe,
        style: widget.viewModel.subscribed
            ? SubscribeButtonStyle.subscribed
            : SubscribeButtonStyle.unsubscribed,
        child: widget.viewModel.subscribed
            ? const Text('Subscribed')
            : const Text('Subscribe'),
      );
    },
  );
}
```

Este método build contém um `ListenableBuilder`
que escuta mudanças do view model.
O builder então cria um `FilledButton`
que exibirá o texto "Subscribed" ou "Subscribe"
dependendo do estado do view model.
O estilo do botão também mudará dependendo deste estado.
Além disso, quando o botão é tocado,
ele executa o método `subscribe()` do view model.

O `SubscribeButtonStyle` pode ser encontrado aqui.
Adicione esta classe ao lado do `SubscribeButton`.
Sinta-se livre para modificar o `ButtonStyle`.

<?code-excerpt "lib/main.dart (style)"?>
```dart
class SubscribeButtonStyle {
  static const unsubscribed = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(Colors.red),
  );

  static const subscribed = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(Colors.green),
  );
}
```

Se você executar a aplicação agora,
você verá como o botão muda quando você pressiona,
no entanto ele mudará de volta ao estado original sem mostrar um erro.

### Tratando erros

Para tratar erros,
adicione os métodos `initState()` e `dispose()` ao `SubscribeButtonState`,
e então adicione o método `_onViewModelChange()`.

<?code-excerpt "lib/main.dart (listener1)"?>
```dart
@override
void initState() {
  super.initState();
  widget.viewModel.addListener(_onViewModelChange);
}

@override
void dispose() {
  widget.viewModel.removeListener(_onViewModelChange);
  super.dispose();
}
```

<?code-excerpt "lib/main.dart (listener2)"?>
```dart
/// Listen to ViewModel changes.
void _onViewModelChange() {
  // If the subscription action has failed
  if (widget.viewModel.error) {
    // Reset the error state
    widget.viewModel.error = false;
    // Show an error message
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Failed to subscribe')));
  }
}
```

A chamada `addListener()` registra o método `_onViewModelChange()`
para ser chamado quando o view model notifica listeners.
É importante chamar `removeListener()` quando o widget é descartado,
para evitar erros.

O método `_onViewModelChange()` verifica o estado `error`,
e se for `true`,
exibe um `Snackbar` ao usuário mostrando uma mensagem de erro.
Além disso, o estado `error` é definido de volta para `false`,
para evitar exibir a mensagem de erro múltiplas vezes
se `notifyListeners()` for chamado novamente no view model.

## Optimistic State avançado

Neste tutorial,
você aprendeu como implementar um Optimistic State com um único estado binário,
mas você pode usar esta técnica para criar uma solução mais avançada
incorporando um terceiro estado temporal
que indica que a ação ainda está em execução.

Por exemplo, em uma aplicação de chat quando o usuário envia uma nova mensagem,
a aplicação exibirá a nova mensagem de chat na janela de chat,
mas com um ícone indicando que a mensagem ainda está pendente para ser entregue.
Quando a mensagem é entregue, esse ícone seria removido.

No exemplo do botão de inscrição,
você poderia adicionar outra flag no view model
indicando que o método `subscribe()` ainda está em execução,
ou usar o estado running do padrão Command,
e então modificar o estilo do botão ligeiramente para mostrar que a operação está em execução.

## Exemplo interativo

Este exemplo mostra o widget `SubscribeButton`
junto com o `SubscribeButtonViewModel`
e `SubscriptionRepository`,
que implementam uma ação de toque de inscrição com Optimistic State.

Quando você toca no botão,
o texto do botão muda de "Subscribe" para "Subscribed". Após um segundo,
o repositório lança uma exceção,
que é capturada pelo view model,
e o botão reverte de volta a mostrar "Subscribe",
enquanto também exibe um Snackbar com uma mensagem de erro.

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter Optimistic State example in DartPad" run="true"
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SubscribeButton(
            viewModel: SubscribeButtonViewModel(
              subscriptionRepository: SubscriptionRepository(),
            ),
          ),
        ),
      ),
    );
  }
}

/// A button that simulates a subscription action.
/// For example, subscribing to a newsletter or a streaming channel.
class SubscribeButton extends StatefulWidget {
  const SubscribeButton({super.key, required this.viewModel});

  /// Subscribe button view model.
  final SubscribeButtonViewModel viewModel;

  @override
  State<SubscribeButton> createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<SubscribeButton> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onViewModelChange);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return FilledButton(
          onPressed: widget.viewModel.subscribe,
          style: widget.viewModel.subscribed
              ? SubscribeButtonStyle.subscribed
              : SubscribeButtonStyle.unsubscribed,
          child: widget.viewModel.subscribed
              ? const Text('Subscribed')
              : const Text('Subscribe'),
        );
      },
    );
  }

  /// Listen to ViewModel changes.
  void _onViewModelChange() {
    // If the subscription action has failed
    if (widget.viewModel.error) {
      // Reset the error state
      widget.viewModel.error = false;
      // Show an error message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to subscribe')));
    }
  }

}

class SubscribeButtonStyle {
  static const unsubscribed = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(Colors.red),
  );

  static const subscribed = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(Colors.green),
  );
}

/// Subscribe button View Model.
/// Handles the subscribe action and exposes the state to the subscription.
class SubscribeButtonViewModel extends ChangeNotifier {
  SubscribeButtonViewModel({required this.subscriptionRepository});

  final SubscriptionRepository subscriptionRepository;

  // Whether the user is subscribed
  bool subscribed = false;

  // Whether the subscription action has failed
  bool error = false;

  // Subscription action
  Future<void> subscribe() async {
    // Ignore taps when subscribed
    if (subscribed) {
      return;
    }

    // Optimistic state.
    // It will be reverted if the subscription fails.
    subscribed = true;
    // Notify listeners to update the UI
    notifyListeners();

    try {
      await subscriptionRepository.subscribe();
    } catch (e) {
      print('Failed to subscribe: $e');
      // Revert to the previous state
      subscribed = false;
      // Set the error state
      error = true;
    } finally {
      notifyListeners();
    }
  }

}

/// Repository of subscriptions.
class SubscriptionRepository {
  /// Simulates a network request and then fails.
  Future<void> subscribe() async {
    // Simulate a network request
    await Future.delayed(const Duration(seconds: 1));
    // Fail after one second
    throw Exception('Failed to subscribe');
  }
}
```

[Flutter Architecture guidelines]:/app-architecture
