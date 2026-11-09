---
ia-translate: true
title: Crie um app
description: Instruções sobre como criar um novo app Flutter.
layout: tutorial
---

Aprenda os primeiros passos para construir um app Flutter, desde a criação de um projeto até o entendimento de widgets e hot reload.

<YouTubeEmbed id="sE1M2EayFes" title="First steps with Flutter" fullWidth="true"></YouTubeEmbed>

<SummaryCard>
title: O que você vai realizar
items:
  - title: Criar um novo projeto Flutter usando a CLI
    icon: terminal
  - title: Entender widgets e a árvore de widgets
    icon: account_tree
  - title: Executar seu app e usar hot reload
    icon: bolt
</SummaryCard>

---

### O que você vai construir {:#what-youll-build}

Nesta primeira seção do tutorial do Flutter,
você construirá a UI principal de um app chamado 'Birdle',
um jogo similar ao [Wordle, o popular jogo do New York Times][Wordle, the popular New York Times game].

<img src='/assets/images/docs/tutorial/birdle.png' width="320px" class="diagram-wrap" alt="Uma captura de tela que se parece com o popular jogo Wordle.">

Ao final deste tutorial, você terá
aprendido os fundamentos de construção de UIs Flutter, e seu app se
parecerá com a seguinte captura de tela (e ele até funcionará quase completamente 😀).

[Wordle, the popular New York Times game]: https://www.nytimes.com/games/wordle/index.html


### Crie um novo projeto Flutter {:#create-a-new-flutter-project}

O primeiro passo para construir apps Flutter é criar um novo projeto.
Você cria novos apps com a [ferramenta CLI do Flutter][Flutter CLI tool],
instalada como parte do SDK do Flutter.

Abra seu terminal ou prompt de comando e execute
o seguinte comando para criar um novo projeto Flutter:

```console
$ flutter create birdle --empty
```

Isso cria um novo projeto Flutter usando o template mínimo "empty".

[Flutter CLI tool]: /reference/flutter-cli

### Examine o código {:#examine-the-code}

Na sua IDE, abra o arquivo em `lib/main.dart`.
Começando do topo, você verá este código.

<?code-excerpt "fwe/birdle/lib/step1_main.dart (main)"?>
```dart title="lib/main.dart"
void main() {
  runApp(const MainApp());
}
```

A função `main` é o ponto de entrada para qualquer programa Dart,
e um app Flutter é apenas um programa **Dart**.
O método `runApp` é parte do SDK do Flutter,
e ele recebe um **widget** como argumento.
Neste caso, uma instância do widget `MainApp` está sendo passada.

Logo abaixo da função `main`, você encontrará a declaração da classe `MainApp`.

<?code-excerpt "fwe/birdle/lib/step1_main.dart (MainApp)"?>
```dart
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
```

`MainApp` é o **widget raiz**,
pois é o widget que é passado para `runApp`.
Dentro deste widget, há um método `build` que
retorna outro widget chamado `MaterialApp`.
Essencialmente, isto é o que um app Flutter é:
uma composição de widgets que formam
uma estrutura de árvore chamada **árvore de widgets.**

Seu trabalho como desenvolvedor Flutter é
compor widgets do SDK em widgets maiores e personalizados que exibem uma UI.

No momento, a árvore de widgets é bem simples:

<img src='/assets/images/docs/tutorial/initial_widget_tree.png' width="320px" alt="Uma captura de tela que se parece com o popular jogo Wordle.">

### Execute seu app {:#run-your-app}

1.  No seu terminal,
    navegue até o diretório raiz do app Flutter que você criou:

    ```console
    $ cd birdle
    ```

1.  Execute o app usando a ferramenta CLI do Flutter.

    ```console
    $ flutter run -d chrome
    ```

    O app será compilado e iniciará em uma nova instância do Chrome.

<img src='/assets/images/docs/tutorial/hello_world.png' width="320px" alt="Uma captura de tela que se parece com o popular jogo Wordle.">

### Use hot reload

**Stateful hot reload**, se você ainda não ouviu falar,
permite que um app Flutter em execução re-renderize lógica de negócio ou código de UI atualizado em
menos de um segundo – tudo sem perder seu lugar no app.

Na sua IDE, abra o arquivo `main.dart` e navegue até a linha ~15 e encontre este
código:

<?code-excerpt "fwe/birdle/lib/step1_main.dart (Text)"?>
```dart
child: Text('Hello World!'),
```

Mude o texto dentro da string para qualquer coisa que você queira.
Então, faça hot reload do seu app
pressionando `r` no terminal onde o app está sendo executado.
O app em execução deve instantaneamente mostrar seu texto atualizado.

### Revisão {:#review}

<SummaryCard expands="false">
title: O que você realizou
subtitle: Aqui está um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Criou seu primeiro projeto Flutter
    icon: terminal
    details: >-
      Você usou `flutter create` com a flag `--empty` para
      criar a estrutura de um projeto Flutter mínimo.
      A CLI gera a estrutura do projeto e o
      código boilerplate necessários para começar.
  - title: Explorou a árvore de widgets
    icon: account_tree
    details: >-
      UIs Flutter são construídas compondo **widgets** em uma estrutura de árvore.
      A função `runApp` recebe um widget raiz, e o método
      `build` desse widget retorna outros widgets, formando a **árvore de widgets**.
      Seu trabalho como desenvolvedor Flutter é
      compor esses widgets em UIs personalizadas.
  - title: Executou seu app com hot reload
    icon: bolt
    details: >-
      Você executou seu app com `flutter run` e
      experimentou o **stateful hot reload**, que permite
      ver mudanças de código refletidas em menos de um segundo sem perder o estado do app.
      Pressione `r` no terminal para acionar um hot reload.
</SummaryCard>

### Teste seus conhecimentos {:#test-yourself}

<Quiz title="Quiz de criação de app">
- question: "Qual é o propósito da função `runApp` em uma aplicação Flutter?"
  options:
    - text: Ela compila o código Dart em código de máquina nativo.
      correct: false
      explanation: "A compilação acontece antes de o app ser executado; `runApp` inicia o framework Flutter com um widget raiz."
    - text: Ela recebe um widget como argumento e o torna a raiz da árvore de widgets.
      correct: true
      explanation: "A função `runApp` infla o widget fornecido e o anexa à tela, tornando-o a raiz da árvore de widgets."
    - text: "Ela cria o arquivo `main.dart` para o projeto."
      correct: false
      explanation: "O arquivo é criado por `flutter create`; `runApp` é chamada em tempo de execução."
    - text: Ela baixa as dependências do Flutter da internet.
      correct: false
      explanation: "As dependências são gerenciadas por `flutter pub get`, não por `runApp`."
- question: Como você aciona um hot reload enquanto um app Flutter está sendo executado no terminal?
  options:
    - text: "Pressione `h` no terminal."
      correct: false
      explanation: "Pressionar `h` mostra as opções de ajuda; `r` aciona o hot reload."
    - text: "Pressione `r` no terminal."
      correct: true
      explanation: "Pressionar `r` no terminal onde o app está sendo executado aciona um hot reload."
    - text: "Pare e reinicie o app com `flutter run`."
      correct: false
      explanation: Um reinício completo não é necessário; o hot reload é mais rápido.
    - text: Salve o arquivo e aguarde o reload automático.
      correct: false
      explanation: "Por padrão, você precisa pressionar `r` para acionar o hot reload no terminal."
</Quiz>
