---
title: Concorrência em Flutter para desenvolvedores Swift
description: >
  Aproveite seu conhecimento de concorrência em Swift enquanto aprende Flutter e Dart.
ia-translate: true
---

<?code-excerpt path-base="resources/dart_swift_concurrency"?>

Tanto Dart quanto Swift suportam programação concorrente.
Este guia deve ajudar você a entender como
a concorrência funciona em Dart e como ela se compara ao Swift.
Com esse entendimento, você pode criar
aplicativos iOS de alto desempenho.

Ao desenvolver no ecossistema Apple,
algumas tarefas podem levar muito tempo para serem concluídas.
Essas tarefas incluem buscar ou processar grandes quantidades de dados.
Desenvolvedores iOS normalmente usam o Grand Central Dispatch (GCD)
para agendar tarefas usando um pool de threads compartilhado.
Com o GCD, os desenvolvedores adicionam tarefas a filas de despacho
e o GCD decide em qual thread executá-las.

Mas, o GCD cria threads para
lidar com os itens de trabalho restantes.
Isso significa que você pode acabar com um grande número de threads
e o sistema pode ficar sobrecarregado.
Com Swift, o modelo de concorrência estruturada reduziu o número
de threads e trocas de contexto.
Agora, cada núcleo tem apenas uma thread.

Dart tem um modelo de execução de thread única,
com suporte para `Isolates`, um loop de eventos e código assíncrono.
Um `Isolate` é a implementação de Dart de uma thread leve.
A menos que você gere um `Isolate`, seu código Dart é executado na
thread principal da UI, impulsionada por um loop de eventos.
O loop de eventos do Flutter é
equivalente ao loop principal do iOS — em outras palavras,
o Looper anexado à thread principal.

O modelo de thread única do Dart não significa
que você seja obrigado a executar tudo
como uma operação de bloqueio que faz com que a UI congele.
Em vez disso, use os recursos assíncronos
que a linguagem Dart fornece,
como `async`/`await`.

## Programação Assíncrona

Uma operação assíncrona permite que outras operações
sejam executadas antes que ela seja concluída.
Tanto Dart quanto Swift suportam funções assíncronas
usando as palavras-chave `async` e `await`.
Em ambos os casos, `async` marca que uma função
executa trabalho assíncrono,
e `await` diz ao sistema para aguardar um resultado
da função. Isso significa que a VM Dart _poderia_
suspender a função, se necessário.
Para mais detalhes sobre programação assíncrona, confira
[Concorrência em Dart]({{site.dart-site}}/guides/language/concurrency).

### Aproveitando a thread/isolate principal

Para sistemas operacionais Apple, a thread primária (também chamada de principal)
é onde o aplicativo começa a ser executado.
A renderização da interface do usuário sempre acontece na thread principal.
Uma diferença entre Swift e Dart é que
Swift pode usar threads diferentes para tarefas diferentes,
e Swift não garante qual thread é usada.
Portanto, ao despachar atualizações da UI em Swift,
pode ser necessário garantir que o trabalho ocorra na thread principal.

Digamos que você queira escrever uma função que busque o
clima de forma assíncrona e
exiba os resultados.

No GCD, para despachar manualmente um processo para a thread principal,
você pode fazer algo como o seguinte.

Primeiro, defina o `enum` `Weather`:

```swift
enum Weather: String {
    case rainy, sunny
}
```

Em seguida, defina o view model e marque-o como um [`@Observable`][]
que publica o `result` do tipo `Weather?`.
Use GCD para criar uma `DispatchQueue` em segundo plano para
enviar o trabalho para o pool de threads e, em seguida, despache
de volta para a thread principal para atualizar o `result`.

```swift
@Observable class ContentViewModel {
    private(set) var result: Weather?

    private let queue = DispatchQueue(label: "weather_io_queue")
    func load() {
        // Simula um atraso de rede de 1 segundo.
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
        Text(viewModel.result?.rawValue ?? "Carregando...")
            .onAppear {
                viewModel.load()
        }
    }
}
```

Mais recentemente, o Swift introduziu _actors_ para suportar
a sincronização para estado compartilhado e mutável.
Para garantir que o trabalho seja realizado na thread principal,
defina uma classe view model que seja marcada como `@MainActor`,
com uma função `load()` que chama internamente uma
função assíncrona usando `Task`.

```swift
@MainActor @Observable class ContentViewModel {
  private(set) var result: Weather?
  
  func load() async {
    // Simula um atraso de rede de 1 segundo.
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    self.result = .sunny
  }
}
```

Em seguida, defina o view model como um estado usando `@State`,
com uma função `load()` que pode ser chamada pelo view model:

```swift
struct ContentView: View {
  @State var viewModel = ContentViewModel()
  var body: some View {
    Text(viewModel.result?.rawValue ?? "Carregando...")
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

Em seguida, defina um view model simples (semelhante ao que foi criado em SwiftUI),
para buscar o clima. Em Dart, um objeto `Future` representa um valor a ser
fornecido no futuro. Um `Future` é semelhante ao `@Observable` do Swift.
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
semelhanças com o código Swift.
A função Dart é marcada como `async` porque
usa a palavra-chave `await`.

Além disso, uma função Dart marcada como `async`
retorna automaticamente um `Future`.
Em outras palavras, você não precisa criar um
`Future` manualmente
dentro de funções marcadas como `async`.

Para a última etapa, exiba o valor do clima.
Em Flutter, os widgets [`FutureBuilder`]({{site.api}}/flutter/widgets/FutureBuilder-class.html) e
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
      // Alimente um FutureBuilder na sua árvore de widgets.
      child: FutureBuilder<Weather>(
        // Especifique o Future que você deseja rastrear.
        future: viewModel.load(),
        builder: (context, snapshot) {
          // Um snapshot é do tipo `AsyncSnapshot` e contém o
          // estado do Future. Ao verificar se o snapshot contém
          // um erro ou se os dados são nulos, você pode decidir o que
          // mostrar ao usuário.
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

### Aproveitando uma thread/isolate em segundo plano

Aplicativos Flutter podem ser executados em uma variedade de hardwares multi-core,
incluindo dispositivos que executam macOS e iOS.
Para melhorar o desempenho desses aplicativos,
às vezes você deve executar tarefas em núcleos diferentes
concorrentemente. Isso é especialmente importante
para evitar bloquear a renderização da UI com operações de longa duração.

Em Swift, você pode usar o GCD para executar tarefas em filas globais
com diferentes propriedades de classe de qualidade de serviço (qos).
Isso indica a prioridade da tarefa.

```swift
func parse(string: String, completion: @escaping ([String:Any]) -> Void) {
  // Simula um atraso de 1 segundo.
  DispatchQueue(label: "data_processing_queue", qos: .userInitiated)
    .asyncAfter(deadline: .now() + 1) {
      let result: [String:Any] = ["foo": 123]
      completion(result)
    }
  }
}
```

Em Dart, você pode descarregar a computação para um isolate de worker,
geralmente chamado de worker em segundo plano.
Um cenário comum gera um isolate de worker simples e
retorna os resultados em uma mensagem quando o worker é encerrado.
A partir do Dart 2.19, você pode usar `Isolate.run()` para
gerar um isolate e executar cálculos:

```dart
void main() async {
  // Leia alguns dados.
  final jsonData = await Isolate.run(() => jsonDecode(jsonString) as Map<String, dynamic>);`

  // Use esses dados.
  print('Número de chaves JSON: ${jsonData.length}');
}
```

Em Flutter, você também pode usar a função `compute`
para iniciar um isolate para executar uma função de callback:

```dart
final jsonData = await compute(getNumberOfKeys, jsonString);
```

Nesse caso, a função de callback é uma função de nível superior,
conforme mostrado abaixo:

```dart
Map<String, dynamic> getNumberOfKeys(String jsonString) {
 return jsonDecode(jsonString);
}
```

Você pode encontrar mais informações sobre Dart em
[Aprendendo Dart como um desenvolvedor Swift][],
e mais informações sobre Flutter em
[Flutter para desenvolvedores SwiftUI][] ou
[Flutter para desenvolvedores UIKit][].

[Aprendendo Dart como um desenvolvedor Swift]: {{site.dart-site}}/guides/language/coming-from/swift-to-dart
[Flutter para desenvolvedores SwiftUI]: /get-started/flutter-for/swiftui-devs
[Flutter para desenvolvedores UIKit]: /get-started/flutter-for/uikit-devs
[`@Observable`]: https://developer.apple.com/documentation/observation/observable()
