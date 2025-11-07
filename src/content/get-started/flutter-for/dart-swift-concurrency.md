---
title: Concorrência no Flutter para desenvolvedores Swift
description: >
  Aproveite seu conhecimento de concorrência em Swift enquanto aprende Flutter e Dart.
ia-translate: true
---

<?code-excerpt path-base="resources/dart_swift_concurrency"?>

Tanto Dart quanto Swift suportam programação concorrente.
Este guia deve ajudá-lo a entender como
a concorrência funciona em Dart e como ela se compara ao Swift.
Com esse entendimento, você pode criar
apps iOS de alto desempenho.

Ao desenvolver no ecossistema Apple,
algumas tarefas podem levar muito tempo para serem concluídas.
Essas tarefas incluem buscar ou processar grandes quantidades de dados.
Desenvolvedores iOS normalmente usam Grand Central Dispatch (GCD)
para agendar tarefas usando um pool de threads compartilhado.
Com GCD, desenvolvedores adicionam tarefas a filas de despacho
e o GCD decide em qual thread executá-las.

Mas, o GCD cria threads para
lidar com os itens de trabalho restantes.
Isso significa que você pode acabar com um grande número de threads
e o sistema pode ficar sobrecarregado.
Com Swift, o modelo de concorrência estruturada reduziu o número
de threads e trocas de contexto.
Agora, cada núcleo tem apenas uma thread.

Dart tem um modelo de execução single-threaded,
com suporte para `Isolates`, um event loop, e código assíncrono.
Um `Isolate` é a implementação do Dart de uma thread leve.
A menos que você crie um `Isolate`, seu código Dart é executado na
thread principal da UI, dirigida por um event loop.
O event loop do Flutter é
equivalente ao main loop do iOS—em outras palavras,
o Looper anexado à thread principal.

O modelo single-threaded do Dart não significa
que você é obrigado a executar tudo
como uma operação bloqueante que causa o congelamento da UI.
Em vez disso, use as funcionalidades assíncronas
que a linguagem Dart fornece,
como `async`/`await`.

## Programação Assíncrona

Uma operação assíncrona permite que outras operações
sejam executadas antes de ela ser concluída.
Tanto Dart quanto Swift suportam funções assíncronas
usando as palavras-chave `async` e `await`.
Em ambos os casos, `async` marca que uma função
executa trabalho assíncrono,
e `await` diz ao sistema para aguardar um resultado
da função. Isso significa que a VM do Dart _pode_
suspender a função, se necessário.
Para mais detalhes sobre programação assíncrona, confira
[Concurrency in Dart]({{site.dart-site}}/guides/language/concurrency).

### Aproveitando a thread/isolate principal

Para sistemas operacionais Apple, a thread primária (também chamada de main)
é onde a aplicação começa a ser executada.
A renderização da interface do usuário sempre acontece na thread principal.
Uma diferença entre Swift e Dart é que
Swift pode usar threads diferentes para tarefas diferentes,
e Swift não garante qual thread será usada.
Então, ao despachar atualizações de UI em Swift,
você pode precisar garantir que o trabalho ocorra na thread principal.

Digamos que você queira escrever uma função que busca o
clima de forma assíncrona e
exibe os resultados.

No GCD, para despachar manualmente um processo para a thread principal,
você pode fazer algo como o seguinte.

Primeiro, defina o `enum` `Weather`:

```swift
enum Weather: String {
    case rainy, sunny
}
```

Em seguida, defina o view model e marque-o como [`@Observable`][]
que publica o `result` do tipo `Weather?`.
Use GCD para criar uma `DispatchQueue` em background para
enviar o trabalho ao pool de threads, e então despache
de volta para a thread principal para atualizar o `result`. 

```swift
@Observable class ContentViewModel {
    private(set) var result: Weather?

    private let queue = DispatchQueue(label: "weather_io_queue")
    func load() {
        // Mimic 1 second network delay.
        queue.asyncAfter(deadline: .now() + 1) { [weak self] in
            DispatchQueue.main.async {
                self?.result = .sunny
            }
        }
    }
}
```

Finalmente, exiba os resultados:

```swift
struct ContentView: View {
    @State var viewModel = ContentViewModel()
    var body: some View {
        Text(viewModel.result?.rawValue ?? "Loading...")
            .onAppear {
                viewModel.load()
        }
    }
}
```

Mais recentemente, Swift introduziu _actors_ para suportar
sincronização para estado mutável compartilhado.
Para garantir que o trabalho seja executado na thread principal,
defina uma classe view model que seja marcada como `@MainActor`,
com uma função `load()` que chama internamente uma
função assíncrona usando `Task`.   

```swift
@MainActor @Observable class ContentViewModel {
  private(set) var result: Weather?
  
  func load() async {
    // Mimic 1 second network delay.
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    self.result = .sunny
  }
}
```

Em seguida, defina o view model como um state usando `@State`,
com uma função `load()` que pode ser chamada pelo view model:

```swift
struct ContentView: View {
  @State var viewModel = ContentViewModel()
  var body: some View {
    Text(viewModel.result?.rawValue ?? "Loading...")
      .task {
        await viewModel.load()
      }
  }
}
```

Em Dart, todo o trabalho é executado no isolate principal por padrão.
Para implementar o mesmo exemplo em Dart,
primeiro, crie o `enum` `Weather`:

<?code-excerpt "lib/async_weather.dart (weather)"?>
```dart
enum Weather {
  rainy,
  windy,
  sunny,
}
```

Em seguida, defina um view model simples (similar ao que foi criado em SwiftUI),
para buscar o clima. Em Dart, um objeto `Future` representa um valor a ser
fornecido no futuro. Um `Future` é similar ao `@Observable` do Swift.
Neste exemplo, uma função dentro do view model
retorna um objeto `Future<Weather>`:

<?code-excerpt "lib/async_weather.dart (home-page-view-model)"?>
```dart
@immutable
class HomePageViewModel {
  const HomePageViewModel();
  Future<Weather> load() async {
    await Future.delayed(const Duration(seconds: 1));
    return Weather.sunny;
  }
}
```

A função `load()` neste exemplo compartilha
similaridades com o código Swift.
A função Dart é marcada como `async` porque
ela usa a palavra-chave `await`.

Adicionalmente, uma função Dart marcada como `async`
automaticamente retorna um `Future`.
Em outras palavras, você não precisa criar uma
instância de `Future` manualmente
dentro de funções marcadas como `async`.

Para o último passo, exiba o valor do clima.
No Flutter, os widgets [`FutureBuilder`]({{site.api}}/flutter/widgets/FutureBuilder-class.html) e
[`StreamBuilder`]({{site.api}}/flutter/widgets/StreamBuilder-class.html)
são usados para exibir os resultados de um Future na UI.
O exemplo a seguir usa um `FutureBuilder`:

<?code-excerpt "lib/async_weather.dart (home-page-widget)"?>
```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final HomePageViewModel viewModel = const HomePageViewModel();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // Feed a FutureBuilder to your widget tree.
      child: FutureBuilder<Weather>(
        // Specify the Future that you want to track.
        future: viewModel.load(),
        builder: (context, snapshot) {
          // A snapshot is of type `AsyncSnapshot` and contains the
          // state of the Future. By looking if the snapshot contains
          // an error or if the data is null, you can decide what to
          // show to the user.
          if (snapshot.hasData) {
            return Center(
              child: Text(
                snapshot.data.toString(),
              ),
            );
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }
}
```

Para o exemplo completo, confira o
arquivo [async_weather][] no GitHub.

[async_weather]: {{site.repo.this}}/examples/resources/dart_swift_concurrency/lib/async_weather.dart

### Aproveitando uma thread/isolate em background

Apps Flutter podem ser executados em uma variedade de hardware multi-core,
incluindo dispositivos executando macOS e iOS.
Para melhorar o desempenho dessas aplicações,
você deve às vezes executar tarefas em diferentes núcleos
concorrentemente. Isso é especialmente importante
para evitar bloquear a renderização da UI com operações de longa duração. 

Em Swift, você pode aproveitar o GCD para executar tarefas em filas globais
com diferentes propriedades de classe de qualidade de serviço (qos).
Isso indica a prioridade da tarefa.

```swift
func parse(string: String, completion: @escaping ([String:Any]) -> Void) {
  // Mimic 1 sec delay.
  DispatchQueue(label: "data_processing_queue", qos: .userInitiated)
    .asyncAfter(deadline: .now() + 1) {
      let result: [String:Any] = ["foo": 123]
      completion(result)
    }
  }
}
```

Em Dart, você pode descarregar computação para um worker isolate,
frequentemente chamado de background worker.
Um cenário comum cria um worker isolate simples e
retorna os resultados em uma mensagem quando o worker termina.
A partir do Dart 2.19, você pode usar `Isolate.run()` para
criar um isolate e executar computações:

```dart
void main() async {
  // Read some data.
  final jsonData = await Isolate.run(() => jsonDecode(jsonString) as Map<String, dynamic>);`

  // Use that data.
  print('Number of JSON keys: ${jsonData.length}');
}
```

No Flutter, você também pode usar a função `compute`
para criar um isolate para executar uma função de callback:

```dart
final jsonData = await compute(getNumberOfKeys, jsonString);
```

Neste caso, a função de callback é uma função de nível superior
como mostrado abaixo:

```dart
Map<String, dynamic> getNumberOfKeys(String jsonString) {
 return jsonDecode(jsonString);
}
```

Você pode encontrar mais informações sobre Dart em
[Learning Dart as a Swift developer][],
e mais informações sobre Flutter em
[Flutter for SwiftUI developers][] ou
[Flutter for UIKit developers][].

[Learning Dart as a Swift developer]: {{site.dart-site}}/guides/language/coming-from/swift-to-dart
[Flutter for SwiftUI developers]: /get-started/flutter-for/swiftui-devs
[Flutter for UIKit developers]: /get-started/flutter-for/uikit-devs
[`@Observable`]: https://developer.apple.com/documentation/observation/observable()
