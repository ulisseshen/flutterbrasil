---
ia-translate: true
title: Gerenciamento de estado
description: Aprenda como gerenciar o estado no Flutter.
prev:
  title: Layout
  path: /get-started/fundamentals/layout
next:
  title: Lidando com entrada do usuário
  path: /get-started/fundamentals/user-input
---

O _estado_ de um aplicativo Flutter refere-se a todos os objetos que ele usa
para exibir sua UI ou gerenciar recursos do sistema.
O gerenciamento de estado é como organizamos nosso aplicativo
para acessar esses objetos da forma mais eficaz
e compartilhá-los entre diferentes widgets.

Esta página explora muitos aspectos do gerenciamento de estado,
incluindo:

* Usando um [`StatefulWidget`][]
* Compartilhando o estado entre widgets usando construtores,
  [`InheritedWidget`][]s e callbacks
* Usando [`Listenable`][]s para notificar outros widgets
  quando algo muda
* Usando Model-View-ViewModel (MVVM)
  para a arquitetura do seu aplicativo

Para outras introduções ao gerenciamento de estado, confira estes recursos:

* Vídeo: [Gerenciando o estado no Flutter][managing-state-video].
  Este vídeo mostra como usar o pacote [riverpod][].

<i class="material-symbols" aria-hidden="true">flutter_dash</i> Tutorial:
[Gerenciamento de estado][].
Isso mostra como usar `ChangeNotifer` com o pacote [provider][].

Este guia não usa pacotes de terceiros
como provider ou Riverpod. Em vez disso,
ele usa apenas primitivos disponíveis no framework Flutter.

## Usando um StatefulWidget

A maneira mais simples de gerenciar o estado é usar um `StatefulWidget`,
que armazena o estado dentro de si mesmo.
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
        Text('Contagem: $count'),
        TextButton(
          onPressed: () {
            setState(() {
              count++;
            });
          },
          child: Text('Incrementar'),
        )
      ],
    );
  }
}
```

Este código ilustra dois conceitos importantes
ao pensar sobre o gerenciamento de estado:

* **Encapsulamento**
: O widget que usa `MyCounter` não tem visibilidade
  na variável `count` e nem meios de acessá-la ou alterá-la.
* **Ciclo de vida do objeto**
: O objeto `_MyCounterState` e sua variável `count`
  são criados na primeira vez que `MyCounter` é construído,
  e existem até que sejam removidos da tela.
  Este é um exemplo de _estado efêmero_.

Você pode achar os seguintes recursos úteis:

* Artigo: [Estado efêmero e estado do aplicativo][ephemeral-state]
* Documentação da API: [StatefulWidget][]

## Compartilhando estado entre widgets

Alguns cenários em que um aplicativo precisa armazenar o estado
incluem o seguinte:

* Para **atualizar** o estado compartilhado e notificar outras partes
  do aplicativo
* Para **ouvir** as mudanças no estado compartilhado
  e reconstruir a UI quando ela muda

Esta seção explora como você pode compartilhar o estado de forma eficaz
entre diferentes widgets em seu aplicativo.
Os padrões mais comuns são:

* **Usando construtores de widget**
  (às vezes chamado de "prop drilling" em outros frameworks)
* **Usando `InheritedWidget`** (ou uma API similar,
  como o pacote [provider][]).
* **Usando callbacks** para notificar um widget pai
  que algo mudou

### Usando construtores de widget

Como os objetos Dart são passados por referência,
é muito comum que os widgets definam os
objetos que precisam usar em seu construtor.
Qualquer estado que você passar para o construtor de um widget
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
      child: Text('Incrementar'),
      onPressed: () {
        setState(() {
          count++;
        });
      },
    )
  ],
)
```

Passar os dados compartilhados para seu aplicativo através de construtores de widget
deixa claro para qualquer pessoa lendo o código que existem dependências compartilhadas.
Este é um padrão de design comum chamado _injeção de dependência_
e muitos frameworks se aproveitam dele ou fornecem ferramentas para facilitar.

### Usando InheritedWidget

Passar dados manualmente pela árvore de widgets pode ser verboso
e causar código boilerplate indesejado,
então o Flutter fornece _`InheritedWidget`_,
que oferece uma maneira de hospedar dados de forma eficiente em um widget pai
para que os widgets filhos possam acessá-los sem armazená-los como um campo.

Para usar `InheritedWidget`, estenda a classe `InheritedWidget`
e implemente o método estático `of()`
usando `dependOnInheritedWidgetOfExactType`.
Um widget chamando `of()` em um método de construção
cria uma dependência que é gerenciada pelo framework Flutter,
para que quaisquer widgets que dependem deste `InheritedWidget`
sejam reconstruídos quando este widget é reconstruído com novos dados
e `updateShouldNotify` retorna verdadeiro.

```dart
class MyState extends InheritedWidget {
  const MyState({
    super.key,
    required this.data,
    required super.child,
  });

  final String data;

  static MyState of(BuildContext context) {
    // Este método procura o ancestral widget `MyState` mais próximo.
    final result = context.dependOnInheritedWidgetOfExactType<MyState>();

    assert(result != null, 'Nenhum MyState encontrado no contexto');

    return result!;
  }

  @override
  // Este método deve retornar verdadeiro se os dados do widget antigo forem diferentes
  // dos dados deste widget. Se verdadeiro, qualquer widget que dependa deste widget
  // chamando `of()` será reconstruído.
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
O Flutter fornece o tipo `ValueChanged`,
que declara um callback de função com um único parâmetro:

```dart
typedef ValueChanged<T> = void Function(T value);
```

Ao expor `onChanged` no construtor do seu widget,
você fornece uma maneira para qualquer widget que esteja usando este widget
responder quando seu widget chama `onChanged`.

```dart
class MyCounter extends StatefulWidget {
  const MyCounter({super.key, required this.onChanged});

  final ValueChanged<int> onChanged;

  @override
  State<MyCounter> createState() => _MyCounterState();
}
```

Por exemplo, este widget pode tratar o callback `onPressed`,
e chamar `onChanged` com seu estado interno mais recente para a variável `count`:

```dart
TextButton(
  onPressed: () {
    widget.onChanged(count++);
  },
),
```

### Aprofunde-se

Para mais informações sobre como compartilhar o estado entre widgets,
confira os seguintes recursos:

* Artigo: [Visão geral da arquitetura do Flutter — Gerenciamento de estado][architecture-state]
* Vídeo: [Gerenciamento de estado pragmático][]
* Vídeo: [InheritedWidgets][inherited-widget-video]
* Vídeo: [Um guia para Inherited Widgets][]
* Exemplo: [Provider shopper][]
* Exemplo: [Provider counter][]
* Documentação da API: [`InheritedWidget`][]

## Usando listenables

Agora que você escolheu como deseja compartilhar o estado em seu aplicativo,
como você atualiza a UI quando ela muda?
Como você muda o estado compartilhado de forma
que notifique outras partes do aplicativo?

O Flutter fornece uma classe abstrata chamada `Listenable`
que pode atualizar um ou mais listeners.
Algumas maneiras úteis de usar listenables são:

* Use um `ChangeNotifier` e inscreva-se nele usando um `ListenableBuilder`
* Use um `ValueNotifier` com um `ValueListenableBuilder`

### ChangeNotifier

Para usar `ChangeNotifier`, crie uma classe que o estenda,
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
        return Text('contador: ${counterNotifier.count}');
      },
    ),
    TextButton(
      child: Text('Incrementar'),
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
e notificar quaisquer listeners de que o valor mudou.
Como `ValueNotifier` estende `ChangeNotifier`,
ele também é um `Listenable` e pode ser usado com um `ListenableBuilder`.
Mas você também pode usar `ValueListenableBuilder`,
que fornece o valor no callback `builder`:

```dart
Column(
  children: [
    ValueListenableBuilder(
      valueListenable: counterNotifier,
      builder: (context, child, value) {
        return Text('contador: $value');
      },
    ),
    TextButton(
      child: Text('Incrementar'),
      onPressed: () {
        counterNotifier.value++;
      },
    ),
  ],
)
```

### Aprofunde-se

Para aprender mais sobre objetos `Listenable`, confira os seguintes recursos:

* Documentação da API: [`Listenable`][]
* Documentação da API: [`ValueNotifier`][]
* Documentação da API: [`ValueListenable`][]
* Documentação da API: [`ChangeNotifier`][]
* Documentação da API: [`ListenableBuilder`][]
* Documentação da API: [`ValueListenableBuilder`][]
* Documentação da API: [`InheritedNotifier`][]

## Usando MVVM para a arquitetura do seu aplicativo

Agora que entendemos como compartilhar o estado
e notificar outras partes do aplicativo quando seu estado muda,
estamos prontos para começar a pensar em como organizar
os objetos stateful em nosso aplicativo.

Esta seção descreve como implementar um padrão de design que funciona bem
com frameworks reativos como o Flutter,
chamado _Model-View-ViewModel_ ou _MVVM_.

### Definindo o Model

O Model é normalmente uma classe Dart que executa tarefas de baixo nível
como fazer requisições HTTP,
armazenar dados em cache ou gerenciar recursos do sistema, como um plugin.
Um model geralmente não precisa importar bibliotecas do Flutter.

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
    final uri = Uri.parse('https://meuaplicativodecontagemflutter.net/contagem');
    final response = await get(uri);

    if (response.statusCode != 200) {
      throw ('Falha ao atualizar recurso');
    }

    return CounterData(int.parse(response.body));
  }

  Future<CounterData> updateCountOnServer(int newCount) async {
    // ...
  }
}
```

Este model não usa nenhum primitivo do Flutter ou faz quaisquer suposições
sobre a plataforma em que está sendo executado;
seu único trabalho é buscar ou atualizar a contagem usando seu cliente HTTP.
Isso permite que o model seja implementado com um Mock ou Fake em testes unitários,
e define limites claros entre os componentes de baixo nível do seu aplicativo e os
componentes de UI de nível superior necessários para construir o aplicativo completo.

A classe `CounterData` define a estrutura dos dados
e é o verdadeiro "model" do nosso aplicativo.
A camada model é tipicamente responsável pelos algoritmos centrais
e estruturas de dados necessárias para o seu aplicativo.
Se você estiver interessado em outras maneiras de definir o model,
como usar tipos de valor imutáveis,
confira pacotes como [freezed][]
ou [build_collection][] em pub.dev.

### Definindo o ViewModel

Um `ViewModel` vincula a _View_ ao _Model_.
Ele protege o model de ser acessado diretamente pela View,
e garante que o fluxo de dados comece a partir de uma mudança no model.
O fluxo de dados é tratado pelo `ViewModel`, que usa `notifyListeners`
para informar a View de que algo mudou.
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
      errorMessage = 'Não foi possível inicializar o contador';
    }
    notifyListeners();
  }

  Future<void> increment() async {
    var count = this.count;
    if (count == null) {
      throw('Não inicializado');
    }
    try {
      await model.updateCountOnServer(count + 1);
      count++;
    } catch(e) {
      errorMessage = 'Não foi possível atualizar a contagem';
    }
    notifyListeners();
  }
}
```

Observe que o `ViewModel` armazena um `errorMessage`
quando recebe um erro do Model.
Isso protege a View de erros de tempo de execução não tratados,
o que poderia levar a uma falha.
Em vez disso, o campo `errorMessage`
pode ser usado pela view para mostrar uma mensagem de erro amigável.

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
            'Erro: ${viewModel.errorMessage}',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.apply(color: Colors.red),
          ),
        Text('Contagem: ${viewModel.count}'),
        TextButton(
          onPressed: () {
            viewModel.increment();
          },
          child: Text('Incrementar'),
        ),
      ],
    );
  },
)
```

Este padrão permite que a lógica de negócios do seu aplicativo
seja separada da lógica da UI
e das operações de baixo nível realizadas pela camada Model.

## Saiba mais sobre gerenciamento de estado

Esta página aborda superficialmente o gerenciamento de estado, pois
existem muitas maneiras de organizar e gerenciar
o estado do seu aplicativo Flutter.
Se você quiser saber mais, confira os seguintes recursos:

* Artigo: [Lista de abordagens de gerenciamento de estado][]
* Repositório: [Exemplos de arquitetura Flutter][]

[Um guia para Inherited Widgets]: {{site.youtube-site}}/watch?v=Zbm3hjPjQMk
[build_collection]: {{site.pub-pkg}}/built_collection
[Exemplos de arquitetura Flutter]: https://fluttersamples.com/
[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[Lista de abordagens de gerenciamento de estado]: /data-and-backend/state-mgmt/options
[Gerenciamento de estado pragmático]: {{site.youtube-site}}/watch?v=d_m5csmrf7I
[Provider counter]: https://github.com/flutter/samples/tree/main/provider_counter
[Provider shopper]: https://flutter.github.io/samples/provider_shopper.html
[Gerenciamento de estado]: /data-and-backend/state-mgmt/intro
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

Como esta seção do site está evoluindo,
nós [agradecemos seu feedback][]!

[agradecemos seu feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="state-management"
