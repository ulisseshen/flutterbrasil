---
ia-translate: true
title: Gerenciamento de estado
description: Aprenda como gerenciar estado no Flutter.
prev:
  title: Layout
  path: /get-started/fundamentals/layout
next:
  title: Handling user input
  path: /get-started/fundamentals/user-input
---

O _estado_ de um app Flutter refere-se a todos os objetos que ele usa
para exibir sua UI ou gerenciar recursos do sistema.
Gerenciamento de estado é como organizamos nosso app
para acessar mais efetivamente esses objetos
e compartilhá-los entre diferentes widgets.

Esta página explora muitos aspectos do gerenciamento de estado, incluindo:

* Usar um [`StatefulWidget`][]
* Compartilhar estado entre widgets usando construtores,
  [`InheritedWidget`][]s e callbacks
* Usar [`Listenable`][]s para notificar outros widgets
  quando algo muda
* Usar Model-View-ViewModel (MVVM)
  para a arquitetura da sua aplicação

Para outras introduções ao gerenciamento de estado, confira estes recursos:

* Vídeo: [Managing state in Flutter][managing-state-video].
  Este vídeo mostra como usar o pacote [riverpod][].

<i class="material-symbols" aria-hidden="true">flutter_dash</i> Tutorial:
[State management][].
Isso mostra como usar `ChangeNotifer` com o pacote [provider][].

Este guia não usa pacotes de terceiros
como provider ou Riverpod. Em vez disso,
ele usa apenas primitivas disponíveis no framework Flutter.

## Usando um StatefulWidget

A maneira mais simples de gerenciar estado é usar um `StatefulWidget`,
que armazena estado dentro de si mesmo.
Por exemplo, considere o seguinte widget:

```dart
class MyCounter extends StatefulWidget {
  const MyCounter({super.key});

  @override
  State<MyCounter> createState() => _MyCounterState();
}

class _MyCounterState extends State<MyCounter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: $count'),
        TextButton(
          onPressed: () {
            setState(() {
              count++;
            });
          },
          child: Text('Increment'),
        )
      ],
    );
  }
}
```

Este código ilustra dois conceitos importantes
ao pensar sobre gerenciamento de estado:

* **Encapsulamento**
: O widget que usa `MyCounter` não tem visibilidade sobre
  a variável `count` subjacente
  e nenhum meio de acessá-la ou alterá-la.
* **Ciclo de vida do objeto**
: O objeto `_MyCounterState` e sua variável `count`
  são criados na primeira vez que `MyCounter` é construído,
  e existem até que seja removido da tela.
  Este é um exemplo de _estado efêmero_.

Você pode achar os seguintes recursos úteis:

* Artigo: [Ephemeral state and app state][ephemeral-state]
* Documentação da API: [StatefulWidget][]

## Compartilhando estado entre widgets

Alguns cenários onde um app precisa armazenar estado
incluem o seguinte:

* **Atualizar** o estado compartilhado e notificar outras partes do app
* **Escutar** mudanças no estado compartilhado
  e reconstruir a UI quando ele muda

Esta seção explora como você pode efetivamente compartilhar estado
entre diferentes widgets em seu app.
Os padrões mais comuns são:

* **Usar construtores de widget**
  (às vezes chamado de "prop drilling" em outros frameworks)
* **Usar `InheritedWidget`** (ou uma API similar,
  como o pacote [provider][]).
* **Usar callbacks** para notificar um widget pai
  que algo mudou

### Usando construtores de widget

Como objetos Dart são passados por referência,
é muito comum que widgets definam os
objetos que precisam usar em seu construtor.
Qualquer estado que você passe para o construtor de um widget
pode ser usado para construir sua UI:

```dart
class MyCounter extends StatelessWidget {
  final int count;
  const MyCounter({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Text('$count');
  }
}
```

Isso torna óbvio para outros usuários do seu widget saber
o que eles precisam fornecer para usá-lo:

```dart
Column(
  children: [
    MyCounter(
      count: count,
    ),
    MyCounter(
      count: count,
    ),
    TextButton(
      child: Text('Increment'),
      onPressed: () {
        setState(() {
          count++;
        });
      },
    )
  ],
)
```

Passar os dados compartilhados do seu app através de construtores de widget
torna claro para qualquer pessoa lendo o código que existem dependências compartilhadas.
Este é um padrão de design comum chamado _injeção de dependência_
e muitos frameworks aproveitam isso ou fornecem ferramentas para torná-lo mais fácil.

### Usando InheritedWidget

Passar dados manualmente pela árvore de widgets pode ser verboso
e causar código boilerplate indesejado,
então Flutter fornece _`InheritedWidget`_,
que fornece uma maneira de hospedar dados eficientemente em um widget pai
para que widgets filhos possam acessá-los sem armazená-los como um campo.

Para usar `InheritedWidget`, estenda a classe `InheritedWidget`
e implemente o método estático `of()`
usando `dependOnInheritedWidgetOfExactType`.
Um widget chamando `of()` em um método build
cria uma dependência que é gerenciada pelo framework Flutter,
de modo que quaisquer widgets que dependem deste `InheritedWidget` reconstruam
quando este widget reconstrói com novos dados
e `updateShouldNotify` retorna true.

```dart
class MyState extends InheritedWidget {
  const MyState({
    super.key,
    required this.data,
    required super.child,
  });

  final String data;

  static MyState of(BuildContext context) {
    // This method looks for the nearest `MyState` widget ancestor.
    final result = context.dependOnInheritedWidgetOfExactType<MyState>();

    assert(result != null, 'No MyState found in context');

    return result!;
  }

  @override
  // This method should return true if the old widget's data is different
  // from this widget's data. If true, any widgets that depend on this widget
  // by calling `of()` will be re-built.
  bool updateShouldNotify(MyState oldWidget) => data != oldWidget.data;
}
```

Em seguida, chame o método `of()`
do método `build()` do widget
que precisa acessar o estado compartilhado:

```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var data = MyState.of(context).data;
    return Scaffold(
      body: Center(
        child: Text(data),
      ),
    );
  }
}
```


### Usando callbacks

Você pode notificar outros widgets quando um valor muda expondo um callback.
Flutter fornece o tipo `ValueChanged`,
que declara um callback de função com um único parâmetro:

```dart
typedef ValueChanged<T> = void Function(T value);
```

Ao expor `onChanged` no construtor do seu widget,
você fornece uma maneira para qualquer widget que está usando este widget
responder quando seu widget chama `onChanged`.

```dart
class MyCounter extends StatefulWidget {
  const MyCounter({super.key, required this.onChanged});

  final ValueChanged<int> onChanged;

  @override
  State<MyCounter> createState() => _MyCounterState();
}
```

Por exemplo, este widget pode lidar com o callback `onPressed`,
e chamar `onChanged` com seu estado interno mais recente para a variável `count`:

```dart
TextButton(
  onPressed: () {
    widget.onChanged(count++);
  },
),
```

### Mergulhe mais fundo

Para mais informações sobre compartilhar estado entre widgets,
confira os seguintes recursos:

* Artigo: [Flutter Architectural Overview—State management][architecture-state]
* Vídeo: [Pragmatic state management][]
* Vídeo: [InheritedWidgets][inherited-widget-video]
* Vídeo: [A guide to Inherited Widgets][]
* Exemplo: [Provider shopper][]
* Exemplo: [Provider counter][]
* Documentação da API: [`InheritedWidget`][]

## Usando listenables

Agora que você escolheu como quer compartilhar estado em seu app,
como você atualiza a UI quando ele muda?
Como você muda o estado compartilhado de uma forma
que notifica outras partes do app?

Flutter fornece uma classe abstrata chamada `Listenable`
que pode atualizar um ou mais listeners.
Algumas maneiras úteis de usar listenables são:

* Usar um `ChangeNotifier` e se inscrever nele usando um `ListenableBuilder`
* Usar um `ValueNotifier` com um `ValueListenableBuilder`

### ChangeNotifier

Para usar `ChangeNotifier`, crie uma classe que o estende,
e chame `notifyListeners` sempre que a classe precisar notificar seus listeners.

```dart
class CounterNotifier extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}
```

Em seguida, passe-o para `ListenableBuilder`
para garantir que a subárvore retornada pela função `builder`
seja reconstruída sempre que o `ChangeNotifier` atualizar seus listeners.

```dart
Column(
  children: [
    ListenableBuilder(
      listenable: counterNotifier,
      builder: (context, child) {
        return Text('counter: ${counterNotifier.count}');
      },
    ),
    TextButton(
      child: Text('Increment'),
      onPressed: () {
        counterNotifier.increment();
      },
    ),
  ],
)
```

### ValueNotifier

Um [`ValueNotifier`][] é uma versão mais simples de um `ChangeNotifier`,
que armazena um único valor.
Ele implementa as interfaces `ValueListenable` e `Listenable`,
então é compatível
com widgets como `ListenableBuilder` e `ValueListenableBuilder`.
Para usá-lo, crie uma instância de `ValueNotifier` com o valor inicial:

```dart
ValueNotifier<int> counterNotifier = ValueNotifier(0);
```

Em seguida, use o campo `value` para ler ou atualizar o valor,
e notificar quaisquer listeners que o valor mudou.
Como `ValueNotifier` estende `ChangeNotifier`,
ele também é um `Listenable` e pode ser usado com um `ListenableBuilder`.
Mas você também pode usar `ValueListenableBuilder`,
que fornece o valor no callback `builder`:

```dart
Column(
  children: [
    ValueListenableBuilder(
      valueListenable: counterNotifier,
      builder: (context, value, child) {
        return Text('counter: $value');
      },
    ),
    TextButton(
      child: Text('Increment'),
      onPressed: () {
        counterNotifier.value++;
      },
    ),
  ],
)
```

### Mergulhe mais fundo

Para aprender mais sobre objetos `Listenable`, confira os seguintes recursos:

* Documentação da API: [`Listenable`][]
* Documentação da API: [`ValueNotifier`][]
* Documentação da API: [`ValueListenable`][]
* Documentação da API: [`ChangeNotifier`][]
* Documentação da API: [`ListenableBuilder`][]
* Documentação da API: [`ValueListenableBuilder`][]
* Documentação da API: [`InheritedNotifier`][]

<a id="using-mvvm-for-your-applications-architecture"></a>
## Usando MVVM para a arquitetura da sua aplicação

Agora que entendemos como compartilhar estado
e notificar outras partes do app quando seu estado muda,
estamos prontos para começar a pensar sobre como organizar
os objetos stateful em nosso app.

Esta seção descreve como implementar um padrão de design que funciona bem
com frameworks reativos como Flutter,
chamado _Model-View-ViewModel_ ou _MVVM_.

### Definindo o Model

O Model é tipicamente uma classe Dart que faz tarefas de baixo nível
como fazer requisições HTTP,
fazer cache de dados, ou gerenciar recursos do sistema como um plugin.
Um model geralmente não precisa importar bibliotecas Flutter.

Por exemplo, considere um model que carrega ou atualiza o estado do contador
usando um cliente HTTP:

```dart
import 'package:http/http.dart';

class CounterData {
  CounterData(this.count);

  final int count;
}

class CounterModel {
  Future<CounterData> loadCountFromServer() async {
    final uri = Uri.parse('https://myfluttercounterapp.net/count');
    final response = await get(uri);

    if (response.statusCode != 200) {
      throw ('Failed to update resource');
    }

    return CounterData(int.parse(response.body));
  }

  Future<CounterData> updateCountOnServer(int newCount) async {
    // ...
  }
}
```

Este model não usa nenhuma primitiva Flutter ou faz quaisquer suposições
sobre a plataforma em que está executando;
seu único trabalho é buscar ou atualizar a contagem usando seu cliente HTTP.
Isso permite que o model seja implementado com um Mock ou Fake em testes unitários,
e define limites claros entre os componentes de baixo nível do seu app e os
componentes de UI de nível superior necessários para construir o app completo.

A classe `CounterData` define a estrutura dos dados
e é o verdadeiro "model" da nossa aplicação.
A camada de model é tipicamente responsável pelos algoritmos centrais
e estruturas de dados necessárias para seu app.
Se você está interessado em outras formas de definir o model,
como usar tipos de valor imutáveis,
confira pacotes como [freezed][]
ou [build_collection][] no pub.dev.

### Definindo o ViewModel

Um `ViewModel` vincula a _View_ ao _Model_.
Ele protege o model de ser acessado diretamente pela View,
e garante que o fluxo de dados comece de uma mudança no model.
O fluxo de dados é tratado pelo `ViewModel`, que usa `notifyListeners`
para informar a View que algo mudou.
O `ViewModel` é como um garçom em um restaurante
que lida com a comunicação
entre a cozinha (model) e os clientes (views).

```dart
import 'package:flutter/foundation.dart';

class CounterViewModel extends ChangeNotifier {
  final CounterModel model;
  int? count;
  String? errorMessage;
  CounterViewModel(this.model);

  Future<void> init() async {
    try {
      count = (await model.loadCountFromServer()).count;
    } catch (e) {
      errorMessage = 'Could not initialize counter';
    }
    notifyListeners();
  }

  Future<void> increment() async {
    var count = this.count;
    if (count == null) {
      throw('Not initialized');
    }
    try {
      await model.updateCountOnServer(count + 1);
      count++;
    } catch(e) {
      errorMessage = 'Count not update count';
    }
    notifyListeners();
  }
}
```

Observe que o `ViewModel` armazena um `errorMessage`
quando recebe um erro do Model.
Isso protege a View de erros de tempo de execução não tratados,
que poderiam levar a um crash.
Em vez disso, o campo `errorMessage`
pode ser usado pela view para mostrar uma mensagem de erro amigável ao usuário.


### Definindo a View

Como nosso `ViewModel` é um `ChangeNotifier`,
qualquer widget com uma referência a ele pode usar um `ListenableBuilder`
para reconstruir sua árvore de widgets
quando o `ViewModel` notifica seus listeners:

```dart
ListenableBuilder(
  listenable: viewModel,
  builder: (context, child) {
    return Column(
      children: [
        if (viewModel.errorMessage != null)
          Text(
            'Error: ${viewModel.errorMessage}',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.apply(color: Colors.red),
          ),
        Text('Count: ${viewModel.count}'),
        TextButton(
          onPressed: () {
            viewModel.increment();
          },
          child: Text('Increment'),
        ),
      ],
    );
  },
)
```

Este padrão permite que a lógica de negócio da sua aplicação
seja separada da lógica de UI
e operações de baixo nível executadas pela camada Model.

## Aprenda mais sobre gerenciamento de estado

Esta página toca a superfície do gerenciamento de estado pois
há muitas maneiras de organizar e gerenciar
o estado da sua aplicação Flutter.
Se você gostaria de aprender mais, confira os seguintes recursos:

* Artigo: [List of state management approaches][]
* Repositório: [Flutter Architecture Samples][]

[A guide to Inherited Widgets]: {{site.youtube-site}}/watch?v=Zbm3hjPjQMk
[build_collection]: {{site.pub-pkg}}/built_collection
[Flutter Architecture Samples]: https://fluttersamples.com/
[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[List of state management approaches]: /data-and-backend/state-mgmt/options
[Pragmatic state management]: {{site.youtube-site}}/watch?v=d_m5csmrf7I
[Provider counter]: https://github.com/flutter/samples/tree/main/provider_counter
[Provider shopper]: https://flutter.github.io/samples/provider_shopper.html
[State management]: /data-and-backend/state-mgmt/intro
[StatefulWidget]: {{site.api}}/flutter/widgets/StatefulWidget-class.html
[`StatefulWidget`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html
[`ChangeNotifier`]: {{site.api}}/flutter/foundation/ChangeNotifier-class.html
[`InheritedNotifier`]: {{site.api}}/flutter/widgets/InheritedNotifier-class.html
[`ListenableBuilder`]: {{site.api}}/flutter/widgets/ListenableBuilder-class.html
[`Listenable`]: {{site.api}}/flutter/foundation/Listenable-class.html
[`ValueListenableBuilder`]: {{site.api}}/flutter/widgets/ValueListenableBuilder-class.html
[`ValueListenable`]: {{site.api}}/flutter/foundation/ValueListenable-class.html
[`ValueNotifier`]: {{site.api}}/flutter/foundation/ValueNotifier-class.html
[architecture-state]: /resources/architectural-overview#state-management
[ephemeral-state]: /data-and-backend/state-mgmt/ephemeral-vs-app
[freezed]: {{site.pub-pkg}}/freezed
[inherited-widget-video]: {{site.youtube-site}}/watch?v=og-vJqLzg2c
[managing-state-video]: {{site.youtube-site}}/watch?v=vU9xDLdEZtU
[provider]: {{site.pub-pkg}}/provider
[riverpod]: {{site.pub-pkg}}/riverpod

## Feedback

À medida que esta seção do site evolui,
[recebemos bem seu feedback][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="state-management"
