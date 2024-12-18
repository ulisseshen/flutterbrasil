---
ia-translate: true
title: Hot reload
description: Acelere o desenvolvimento usando o recurso de hot reload do Flutter.
---

<?code-excerpt path-base="tools"?>

O recurso de hot reload do Flutter ajuda você a experimentar, construir UIs, adicionar funcionalidades e corrigir bugs de forma rápida e fácil. O hot reload funciona injetando arquivos de código-fonte atualizados na [Máquina Virtual Dart (VM)][]. Depois que a VM atualiza as classes com as novas versões de campos e funções, o framework Flutter reconstrói automaticamente a árvore de widgets, permitindo que você visualize rapidamente os efeitos de suas alterações.

## Como executar um hot reload

Para fazer um hot reload em um aplicativo Flutter:

1. Execute o aplicativo a partir de um [editor Flutter][] suportado ou de uma janela de terminal. O alvo pode ser um dispositivo físico ou virtual. **Apenas aplicativos Flutter em modo debug podem ter hot reload ou hot restart.**
2. Modifique um dos arquivos Dart em seu projeto. A maioria dos tipos de alterações de código podem ter hot reload; para uma lista de alterações que requerem um hot restart, veja [Casos especiais](#casosespeciais).
3. Se você estiver trabalhando em um IDE/editor que ofereça suporte às ferramentas IDE do Flutter, selecione **Salvar Tudo** (`cmd-s`/`ctrl-s`), ou clique no botão de hot reload na barra de ferramentas.

   Se você estiver executando o aplicativo na linha de comando usando `flutter run`, digite `r` na janela do terminal.

Após uma operação de hot reload bem-sucedida, você verá uma mensagem no console semelhante a:

```console
Performing hot reload...
Reloaded 1 of 448 libraries in 978ms.
```

O aplicativo é atualizado para refletir sua alteração e o estado atual do aplicativo é preservado. Seu aplicativo continua a ser executado de onde estava antes da execução do comando hot reload. O código é atualizado e a execução continua.

:::secondary
**Qual é a diferença entre hot reload, hot restart e full restart?**

*   **Hot reload** carrega as alterações de código na VM e reconstrói a árvore de widgets, preservando o estado do aplicativo; ele não executa novamente `main()` ou `initState()`. (`⌘\` no IntelliJ e Android Studio, `⌃F5` no VSCode)
*   **Hot restart** carrega as alterações de código na VM e reinicia o aplicativo Flutter, perdendo o estado do aplicativo. (`⇧⌘\` no IntelliJ e Android Studio, `⇧⌘F5` no VSCode)
*   **Full restart** reinicia o aplicativo iOS, Android ou web. Isso leva mais tempo porque também recompila o código Java/Kotlin/Objective-C/Swift. Na web, também reinicia o Dart Development Compiler. Não há um atalho de teclado específico para isso; você precisa parar e iniciar a configuração de execução.

O Flutter web atualmente suporta hot restart, mas não hot reload.
:::

![Android Studio UI](/assets/images/docs/development/tools/android-studio-run-controls.png){:width="100%"}<br>
Controles para executar, executar debug, hot reload e hot restart no Android Studio

Uma alteração de código tem um efeito visível apenas se o código Dart modificado for executado novamente após a alteração. Especificamente, um hot reload faz com que todos os widgets existentes sejam reconstruídos. Apenas o código envolvido na reconstrução dos widgets é re-executado automaticamente. As funções `main()` e `initState()`, por exemplo, não são executadas novamente.

## Casos especiais

As próximas seções descrevem cenários específicos que envolvem o hot reload. Em alguns casos, pequenas alterações no código Dart permitem que você continue usando o hot reload para seu aplicativo. Em outros casos, um hot restart ou um full restart são necessários.

### Um aplicativo é encerrado

O hot reload pode quebrar quando o aplicativo é encerrado. Por exemplo, se o aplicativo ficou em segundo plano por muito tempo.

### Erros de compilação

Quando uma alteração de código introduz um erro de compilação, o hot reload gera uma mensagem de erro semelhante a:

```plaintext
Hot reload was rejected:
'/path/to/project/lib/main.dart': warning: line 16 pos 38: unbalanced '{' opens here
  Widget build(BuildContext context) {
                                     ^
'/path/to/project/lib/main.dart': error: line 33 pos 5: unbalanced ')'
    );
    ^
```

Nesta situação, basta corrigir os erros nas linhas especificadas do código Dart para continuar usando o hot reload.

### builder do CupertinoTabView

O hot reload não aplicará alterações feitas em um `builder` de um `CupertinoTabView`. Para obter mais informações, consulte [Issue 43574][].

### Tipos enumerados

O hot reload não funciona quando os tipos enumerados são alterados para classes regulares ou as classes regulares são alteradas para tipos enumerados.

Por exemplo:

Antes da alteração:
<?code-excerpt "lib/hot-reload/before.dart (enum)"?>
```dart
enum Color {
  red,
  green,
  blue,
}
```

Após a alteração:
<?code-excerpt "lib/hot-reload/after.dart (enum)"?>
```dart
class Color {
  Color(this.i, this.j);
  final int i;
  final int j;
}
```

### Tipos genéricos

O hot reload não funcionará quando as declarações de tipo genérico forem modificadas. Por exemplo, o seguinte não funcionará:

Antes da alteração:
<?code-excerpt "lib/hot-reload/before.dart (class)"?>
```dart
class A<T> {
  T? i;
}
```

Após a alteração:
<?code-excerpt "lib/hot-reload/after.dart (class)"?>
```dart
class A<T, V> {
  T? i;
  V? v;
}
```

### Código nativo

Se você alterou o código nativo (como Kotlin, Java, Swift ou Objective-C), você deve executar um full restart (parar e reiniciar o aplicativo) para ver as alterações entrarem em vigor.

### O estado anterior é combinado com o novo código

O hot reload com estado do Flutter preserva o estado do seu aplicativo. Essa abordagem permite que você visualize apenas o efeito da alteração mais recente, sem descartar o estado atual. Por exemplo, se seu aplicativo exige que um usuário faça login, você pode modificar e fazer hot reload em uma página vários níveis abaixo na hierarquia de navegação, sem reinserir suas credenciais de login. O estado é mantido, o que geralmente é o comportamento desejado.

Se as alterações de código afetarem o estado do seu aplicativo (ou suas dependências), os dados com os quais seu aplicativo tem que trabalhar podem não ser totalmente consistentes com os dados que ele teria se fosse executado do zero. O resultado pode ser um comportamento diferente após um hot reload versus um hot restart.

### A alteração recente de código é incluída, mas o estado do aplicativo é excluído

Em Dart, [campos estáticos são inicializados tardiamente][static-variables]. Isso significa que a primeira vez que você executa um aplicativo Flutter e um campo estático é lido, ele é definido como qualquer valor que seu inicializador foi avaliado. Variáveis globais e campos estáticos são tratados como estado e, portanto, não são reinicializados durante o hot reload.

Se você alterar os inicializadores de variáveis globais e campos estáticos, um hot restart ou reiniciar o estado onde os inicializadores são mantidos é necessário para ver as alterações. Por exemplo, considere o seguinte código:

<?code-excerpt "lib/hot-reload/before.dart (sample-table)"?>
```dart
final sampleTable = [
  Table(
    children: const [
      TableRow(
        children: [Text('T1')],
      )
    ],
  ),
  Table(
    children: const [
      TableRow(
        children: [Text('T2')],
      )
    ],
  ),
  Table(
    children: const [
      TableRow(
        children: [Text('T3')],
      )
    ],
  ),
  Table(
    children: const [
      TableRow(
        children: [Text('T4')],
      )
    ],
  ),
];
```

Depois de executar o aplicativo, faça a seguinte alteração:

<?code-excerpt "lib/hot-reload/after.dart (sample-table)"?>
```dart
final sampleTable = [
  Table(
    children: const [
      TableRow(
        children: [Text('T1')],
      )
    ],
  ),
  Table(
    children: const [
      TableRow(
        children: [Text('T2')],
      )
    ],
  ),
  Table(
    children: const [
      TableRow(
        children: [Text('T3')],
      )
    ],
  ),
  Table(
    children: const [
      TableRow(
        children: [Text('T10')], // modificado
      )
    ],
  ),
];
```

Você faz o hot reload, mas a mudança não é refletida.

Por outro lado, no exemplo a seguir:

<?code-excerpt "lib/hot-reload/before.dart (const)"?>
```dart
const foo = 1;
final bar = foo;
void onClick() {
  print(foo);
  print(bar);
}
```

Executar o aplicativo pela primeira vez imprime `1` e `1`. Então, você faz a seguinte mudança:

<?code-excerpt "lib/hot-reload/after.dart (const)"?>
```dart
const foo = 2; // modificado
final bar = foo;
void onClick() {
  print(foo);
  print(bar);
}
```

Embora as alterações nos valores de campo `const` sejam sempre recarregadas via hot reload, o inicializador de campo estático não é executado novamente. Conceitualmente, campos `const` são tratados como aliases em vez de estado.

A VM Dart detecta alterações de inicializador e sinaliza quando um conjunto de alterações precisa de um hot restart para entrar em vigor. O mecanismo de sinalização é acionado para a maior parte do trabalho de inicialização no exemplo acima, mas não para casos como o seguinte:

<?code-excerpt "lib/hot-reload/after.dart (final-foo)"?>
```dart
final bar = foo;
```

Para atualizar `foo` e visualizar a alteração após o hot reload, considere redefinir o campo como `const` ou usar um getter para retornar o valor, em vez de usar `final`. Por exemplo, qualquer uma das seguintes soluções funciona:

<?code-excerpt "lib/hot-reload/foo_const.dart (const)"?>
```dart
const foo = 1;
const bar = foo; // Converta foo para um const...
void onClick() {
  print(foo);
  print(bar);
}
```

<?code-excerpt "lib/hot-reload/getter.dart (const)"?>
```dart
const foo = 1;
int get bar => foo; // ...ou forneça um getter.
void onClick() {
  print(foo);
  print(bar);
}
```

Para obter mais informações, leia sobre as [diferenças entre as palavras-chave `const` e `final`][const-new] em Dart.

### Alteração recente da UI é excluída

Mesmo quando uma operação de hot reload parece bem-sucedida e não gera exceções, algumas alterações de código podem não ficar visíveis na UI atualizada. Esse comportamento é comum após alterações nos métodos `main()` ou `initState()` do aplicativo.

Como regra geral, se o código modificado estiver a jusante do método `build()` do widget raiz, o hot reload se comportará como esperado. No entanto, se o código modificado não for reexecutado como resultado da reconstrução da árvore de widgets, você não verá seus efeitos após o hot reload.

Por exemplo, considere o seguinte código:

<?code-excerpt "lib/hot-reload/before.dart (build)"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () => print('tapped'));
  }
}
```

Depois de executar este aplicativo, altere o código da seguinte forma:

<?code-excerpt "lib/hot-reload/after.dart (main)"?>
```dart
import 'package:flutter/widgets.dart';

void main() {
  runApp(const Center(child: Text('Hello', textDirection: TextDirection.ltr)));
}
```

Com um hot restart, o programa começa do início, executa a nova versão de `main()` e constrói uma árvore de widgets que exibe o texto `Hello`.

No entanto, se você fizer um hot reload no aplicativo após essa alteração, `main()` e `initState()` não serão reexecutados, e a árvore de widgets será reconstruída com a instância inalterada de `MyApp` como o widget raiz. Isso resulta em nenhuma mudança visível após o hot reload.

## Como funciona

Quando o hot reload é invocado, a máquina host procura o código editado desde a última compilação. As seguintes bibliotecas são recompiladas:

*   Quaisquer bibliotecas com código alterado
*   A biblioteca principal do aplicativo
*   As bibliotecas da biblioteca principal que levam a bibliotecas afetadas

O código-fonte dessas bibliotecas é compilado em [arquivos kernel][] e enviado para a VM Dart do dispositivo móvel.

A VM Dart recarrega todas as bibliotecas do novo arquivo kernel. Até agora, nenhum código foi reexecutado.

O mecanismo de hot reload então faz com que o framework Flutter acione uma reconstrução/re-layout/repintura de todos os widgets e objetos de renderização existentes.

[static-variables]: {{site.dart-site}}/language/classes#static-variables
[const-new]: {{site.dart-site}}/language/variables#final-and-const
[Dart Virtual Machine (VM)]: {{site.dart-site}}/overview#platform
[Flutter editor]: /get-started/editor
[Issue 43574]: {{site.repo.flutter}}/issues/43574
[kernel files]: {{site.github}}/dart-lang/sdk/tree/main/pkg/kernel
