---
title: Concorrência no Flutter para desenvolvedores Swift
description: >
  Aproveite seu conhecimento de concorrência Swift ao aprender Flutter e Dart.
ia-translate: true
---

<?code-excerpt path-base="resources/dart_swift_concurrency"?>

Tanto Dart quanto Swift suportam programação concorrente.
Este guia deve ajudá-lo a entender como
a concorrência funciona no Dart e como ela se compara ao Swift.
Com esse entendimento, você pode criar
aplicativos iOS de alto desempenho.

Ao desenvolver no ecossistema Apple,
algumas tarefas podem levar muito tempo para serem concluídas.
Essas tarefas incluem buscar ou processar grandes quantidades de dados.
Desenvolvedores iOS normalmente usam Grand Central Dispatch (GCD)
para agendar tarefas usando um pool de threads compartilhado.
Com GCD, desenvolvedores adicionam tarefas para despachar filas
e GCD decide em qual thread executá-las.

Mas, GCD cria threads para
lidar com itens de trabalho restantes.
Isso significa que você pode acabar com um grande número de threads
e o sistema pode ficar supercomprometido.
Com Swift, o modelo de concorrência estruturada reduziu o número
de threads e trocas de contexto.
Agora, cada núcleo tem apenas uma thread.

Dart tem um modelo de execução single-threaded,
com suporte para `Isolates`, um loop de eventos e código assíncrono.
Um `Isolate` é a implementação do Dart de uma thread leve.
A menos que você crie um `Isolate`, seu código Dart é executado na
thread de UI principal dirigida por um loop de eventos.
O loop de eventos do Flutter é
equivalente ao loop principal do iOS—em outras palavras,
o Looper anexado à thread principal.

O modelo single-threaded do Dart não significa
que você é obrigado a executar tudo
como uma operação bloqueante que causa o congelamento da UI.
Em vez disso, use os recursos assíncronos
que a linguagem Dart fornece,
como `async`/`await`.

## Programação Assíncrona

Uma operação assíncrona permite que outras operações
sejam executadas antes de ser concluída.
Tanto Dart quanto Swift suportam funções assíncronas
usando as palavras-chave `async` e `await`.
Em ambos os casos, `async` marca que uma função
executa trabalho assíncrono,
e `await` diz ao sistema para aguardar um resultado
da função. Isso significa que a VM do Dart _poderia_
suspender a função, se necessário.
Para mais detalhes sobre programação assíncrona, confira
[Concorrência no Dart]({{site.dart-site}}/guides/language/concurrency).

### Aproveitando a thread/isolate principal

Para sistemas operacionais Apple, a thread primária (também chamada de principal)
é onde o aplicativo começa a ser executado.
A renderização da interface do usuário sempre acontece na thread principal.
Uma diferença entre Swift e Dart é que
Swift pode usar threads diferentes para tarefas diferentes,
e Swift não garante qual thread é usada.
Portanto, ao despachar atualizações de UI no Swift,
você pode precisar garantir que o trabalho ocorra na thread principal.

Digamos que você queira escrever uma função que busca o
clima assincronamente e
exibe os resultados.

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
Use GCD para criar um `DispatchQueue` em background para
enviar o trabalho ao pool de threads e, em seguida, despache
de volta para a thread principal para atualizar o `result`.

```swift
@Observable class ContentViewModel {
    private(set) var result: Weather?

    private let queue = DispatchQueue(label: "weather_io_queue")
    func load() {
        // Simular atraso de rede de 1 segundo.
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
    // Simular atraso de rede de 1 segundo.
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
    Text(viewModel.result?.rawValue ?? "Loading...")
      .task {
        await viewModel.load()
      }
  }
}
```

No Dart, todo trabalho é executado no isolate principal por padrão.
Para implementar o mesmo exemplo no Dart,
primeiro, crie o `enum` `Weather`:

<?code-excerpt "lib/async_weather.dart (weather)"?>
```dart
enum Weather { rainy, windy, sunny }
```

Em seguida, defina um view model simples (semelhante ao que foi criado no SwiftUI),
para buscar o clima. No Dart, um objeto `Future` representa um valor a ser
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
Em outras palavras, você não precisa criar uma
instância `Future` manualmente
dentro de funções marcadas como `async`.

Para a última etapa, exiba o valor do clima.
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
      // Alimentar um FutureBuilder para sua árvore de widgets.
      child: FutureBuilder<Weather>(
        // Especificar o Future que você deseja rastrear.
        future: viewModel.load(),
        builder: (context, snapshot) {
          // Um snapshot é do tipo `AsyncSnapshot` e contém o
          // estado do Future. Ao verificar se o snapshot contém
          // um erro ou se os dados são nulos, você pode decidir o que
          // mostrar ao usuário.
          if (snapshot.hasData) {
            return Center(child: Text(snapshot.data.toString()));
          } else {
            return const Center(child: CupertinoActivityIndicator());
          }
        },
      ),
    );
  }
}
```

Para o exemplo completo, confira o arquivo
[async_weather][] no GitHub.

[async_weather]: {{site.repo.this}}/examples/resources/dart_swift_concurrency/lib/async_weather.dart

### Aproveitando uma thread/isolate em background

Aplicativos Flutter podem ser executados em uma variedade de hardware multi-core,
incluindo dispositivos executando macOS e iOS.
Para melhorar o desempenho desses aplicativos,
você deve às vezes executar tarefas em núcleos diferentes
simultaneamente. Isso é especialmente importante
para evitar bloquear a renderização da UI com operações de longa duração.

No Swift, você pode aproveitar GCD para executar tarefas em filas globais
com diferentes propriedades de classe de qualidade de serviço (qos).
Isso indica a prioridade da tarefa.

```swift
func parse(string: String, completion: @escaping ([String:Any]) -> Void) {
  // Simular atraso de 1 seg.
  DispatchQueue(label: "data_processing_queue", qos: .userInitiated)
    .asyncAfter(deadline: .now() + 1) {
      let result: [String:Any] = ["foo": 123]
      completion(result)
    }
  }
}
```

No Dart, você pode descarregar computação para um isolate worker,
frequentemente chamado de worker em background.
Um cenário comum cria um isolate worker simples e
retorna os resultados em uma mensagem quando o worker sai.
A partir do Dart 2.19, você pode usar `Isolate.run()` para
criar um isolate e executar computações:

```dart
void main() async {
  // Ler alguns dados.
  final jsonData = await Isolate.run(() => jsonDecode(jsonString) as Map<String, dynamic>);`

  // Usar esses dados.
  print('Number of JSON keys: ${jsonData.length}');
}
```

No Flutter, você também pode usar a função `compute`
para criar um isolate para executar uma função de callback:

```dart
final jsonData = await compute(getNumberOfKeys, jsonString);
```

Neste caso, a função de callback é uma função de nível superior
conforme mostrado abaixo:

```dart
Map<String, dynamic> getNumberOfKeys(String jsonString) {
 return jsonDecode(jsonString);
}
```

Você pode encontrar mais informações sobre Dart em
[Aprendendo Dart como desenvolvedor Swift][],
e mais informações sobre Flutter em
[Flutter para desenvolvedores SwiftUI][] ou
[Flutter para desenvolvedores UIKit][].

[Aprendendo Dart como desenvolvedor Swift]: {{site.dart-site}}/guides/language/coming-from/swift-to-dart
[Flutter para desenvolvedores SwiftUI]: /get-started/flutter-for/swiftui-devs
[Flutter para desenvolvedores UIKit]: /get-started/flutter-for/uikit-devs
[`@Observable`]: https://developer.apple.com/documentation/observation/observable()
