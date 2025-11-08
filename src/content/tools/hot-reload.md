---
ia-translate: true
title: Hot reload
description: Acelere o desenvolvimento usando o recurso de hot reload do Flutter.
---

<?code-excerpt path-base="tools"?>

O recurso de hot reload do Flutter ajuda você a experimentar, construir UIs, adicionar recursos e corrigir bugs de forma rápida e
fácil.
Hot reload funciona injetando arquivos de código-fonte atualizados
na [Dart Virtual Machine (VM)][] em execução.
Depois que a VM atualiza classes com as novas versões de campos e funções,
o framework Flutter reconstrói automaticamente a árvore de widgets,
permitindo que você visualize rapidamente os efeitos das suas alterações.

## Como realizar um hot reload

Para fazer hot reload em um app Flutter:

1. Execute o app a partir de um [Flutter editor][] suportado ou de uma janela de terminal.
   Um dispositivo físico ou virtual pode ser o alvo.
   **Apenas apps Flutter em modo debug podem ser hot reloaded ou hot restarted.**
1. Modifique um dos arquivos Dart no seu projeto.
   A maioria dos tipos de alterações de código pode ser hot reloaded;
   para uma lista de alterações que exigem um hot restart,
   consulte [Casos especiais](#special-cases).
1. Se você está trabalhando em uma IDE/editor que suporta ferramentas de IDE do Flutter,
   selecione **Save All** (`cmd-s`/`ctrl-s`),
   ou clique no botão de hot reload na barra de ferramentas.

   Se você está executando o app na linha de comando usando `flutter run`,
   digite `r` na janela do terminal.

Após uma operação de hot reload bem-sucedida,
você verá uma mensagem no console semelhante a:

```console
Performing hot reload...
Reloaded 1 of 448 libraries in 978ms.
```

O app é atualizado para refletir sua alteração,
e o estado atual do app é preservado.
Seu app continua a executar de onde estava antes
de executar o comando de hot reload.
O código é atualizado e a execução continua.

:::secondary
**Qual é a diferença entre hot reload, hot restart,
e full restart?**

* **Hot reload** carrega alterações de código na VM e reconstrói
  a árvore de widgets, preservando o estado do app;
  ele não executa novamente `main()` ou `initState()`.
  (`⌘\` no Intellij e Android Studio, `⌃F5` no VSCode)
* **Hot restart** carrega alterações de código na VM,
  e reinicia o app Flutter, perdendo o estado do app.
  (`⇧⌘\` no IntelliJ e Android Studio, `⇧⌘F5` no VSCode)
* **Full restart** reinicia o app iOS, Android ou web.
  Isso leva mais tempo porque também recompila o
  código Java / Kotlin / Objective-C / Swift. Na web,
  ele também reinicia o Dart Development Compiler.
  Não há atalho de teclado específico para isso;
  você precisa parar e iniciar a configuração de execução.

Flutter web atualmente suporta hot restart mas não
hot reload.
:::

![Android Studio UI](/assets/images/docs/development/tools/android-studio-run-controls.png){:width="100%"}<br>
Controles para run, run debug, hot reload, e hot restart no Android Studio

Uma alteração de código tem um efeito visível apenas se o código
Dart modificado for executado novamente após a alteração. Especificamente,
um hot reload faz com que todos os widgets existentes sejam reconstruídos.
Apenas o código envolvido na reconstrução dos widgets
é automaticamente executado novamente. As funções `main()` e `initState()`,
por exemplo, não são executadas novamente.

## Casos especiais {#special-cases}

As próximas seções descrevem cenários específicos que envolvem
hot reload. Em alguns casos, pequenas alterações no código Dart
permitem que você continue usando hot reload para seu app.
Em outros casos, um hot restart, ou uma reinicialização completa é necessária.

### Um app é encerrado

Hot reload pode quebrar quando o app é encerrado.
Por exemplo, se o app estava em segundo plano por muito tempo.

### Erros de compilação

Quando uma alteração de código introduz um erro de compilação,
hot reload gera uma mensagem de erro semelhante a:

```plaintext
Hot reload was rejected:
'/path/to/project/lib/main.dart': warning: line 16 pos 38: unbalanced '{' opens here
  Widget build(BuildContext context) {
                                     ^
'/path/to/project/lib/main.dart': error: line 33 pos 5: unbalanced ')'
    );
    ^
```

Nesta situação, simplesmente corrija os erros nas
linhas especificadas do código Dart para continuar usando hot reload.

### Builder do CupertinoTabView

Hot reload não aplicará alterações feitas a
um `builder` de um `CupertinoTabView`.
Para mais informações, consulte [Issue 43574][].

### Tipos enumerados

Hot reload não funciona quando tipos enumerados são
alterados para classes regulares ou classes regulares são
alteradas para tipos enumerados.

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

Depois da alteração:
<?code-excerpt "lib/hot-reload/after.dart (enum)"?>
```dart
class Color {
  Color(this.i, this.j);
  final int i;
  final int j;
}
```

### Tipos genéricos

Hot reload não funcionará quando declarações de tipo genérico
forem modificadas. Por exemplo, o seguinte não funcionará:

Antes da alteração:
<?code-excerpt "lib/hot-reload/before.dart (class)"?>
```dart
class A<T> {
  T? i;
}
```

Depois da alteração:
<?code-excerpt "lib/hot-reload/after.dart (class)"?>
```dart
class A<T, V> {
  T? i;
  V? v;
}
```

### Código nativo

Se você alterou código nativo (como Kotlin, Java, Swift,
ou Objective-C), você deve realizar uma reinicialização completa (parar e
reiniciar o app) para ver as alterações terem efeito.

### Estado anterior é combinado com novo código

O hot reload stateful do Flutter preserva o estado do seu app.
Esta abordagem permite que você visualize o efeito apenas da
alteração mais recente, sem descartar o estado atual.
Por exemplo, se seu app requer que um usuário faça login,
você pode modificar e fazer hot reload de uma página vários níveis abaixo na
hierarquia de navegação, sem precisar reinserir suas credenciais de login.
O estado é mantido, o que geralmente é o comportamento desejado.

Se alterações de código afetam o estado do seu app (ou suas dependências),
os dados com os quais seu app tem que trabalhar podem não ser totalmente consistentes
com os dados que teria se executasse do zero.
O resultado pode ser um comportamento diferente após um hot reload
versus um hot restart.

### Alteração recente de código está incluída mas o estado do app está excluído

No Dart, [campos estáticos são inicializados preguiçosamente][static-variables].
Isso significa que na primeira vez que você executa um app Flutter e um
campo estático é lido, ele é definido para qualquer valor que seu
inicializador foi avaliado.
Variáveis globais e campos estáticos são tratados como estado,
e portanto não são reinicializados durante hot reload.

Se você alterar inicializadores de variáveis globais e campos estáticos,
um hot restart ou reiniciar o estado onde os inicializadores estão mantidos
é necessário para ver as alterações.
Por exemplo, considere o seguinte código:

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

Após executar o app, você faz a seguinte alteração:

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
        children: [Text('T10')], // modified
      )
    ],
  ),
];
```

Você faz hot reload, mas a alteração não é refletida.

Por outro lado, no seguinte exemplo:

<?code-excerpt "lib/hot-reload/before.dart (const)"?>
```dart
const foo = 1;
final bar = foo;
void onClick() {
  print(foo);
  print(bar);
}
```

Executar o app pela primeira vez imprime `1` e `1`.
Então, você faz a seguinte alteração:

<?code-excerpt "lib/hot-reload/after.dart (const)"?>
```dart
const foo = 2; // modified
final bar = foo;
void onClick() {
  print(foo);
  print(bar);
}
```

Enquanto alterações em valores de campos `const` são sempre hot reloaded,
o inicializador de campo estático não é executado novamente. Conceitualmente,
campos `const` são tratados como aliases em vez de estado.

A Dart VM detecta alterações de inicializador e sinaliza quando um conjunto
de alterações precisa de um hot restart para ter efeito.
O mecanismo de sinalização é acionado para
a maior parte do trabalho de inicialização no exemplo acima,
mas não para casos como o seguinte:

<?code-excerpt "lib/hot-reload/after.dart (final-foo)"?>
```dart
final bar = foo;
```

Para atualizar `foo` e visualizar a alteração após hot reload,
considere redefinir o campo como `const` ou usar um getter para
retornar o valor, em vez de usar `final`.
Por exemplo, qualquer uma das seguintes soluções funciona:

<?code-excerpt "lib/hot-reload/foo_const.dart (const)"?>
```dart
const foo = 1;
const bar = foo; // Convert foo to a const...
void onClick() {
  print(foo);
  print(bar);
}
```

<?code-excerpt "lib/hot-reload/getter.dart (const)"?>
```dart
const foo = 1;
int get bar => foo; // ...or provide a getter.
void onClick() {
  print(foo);
  print(bar);
}
```

Para mais informações, leia sobre as [diferenças
entre as palavras-chave `const` e `final`][const-new] no Dart.

### Alteração recente de UI está excluída

Mesmo quando uma operação de hot reload parece bem-sucedida e não gera
exceções, algumas alterações de código podem não ser visíveis na UI atualizada.
Este comportamento é comum após alterações nos métodos `main()` ou
`initState()` do app.

Como regra geral, se o código modificado estiver downstream do
método `build()` do widget raiz, então hot reload se comporta como esperado.
No entanto, se o código modificado não for executado novamente como resultado
de reconstruir a árvore de widgets, então você não verá
seus efeitos após hot reload.

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

Após executar este app, altere o código da seguinte forma:

<?code-excerpt "lib/hot-reload/after.dart (main)"?>
```dart
import 'package:flutter/widgets.dart';

void main() {
  runApp(const Center(child: Text('Hello', textDirection: TextDirection.ltr)));
}
```

Com um hot restart, o programa inicia do início,
executa a nova versão de `main()`,
e constrói uma árvore de widgets que exibe o texto `Hello`.

No entanto, se você fizer hot reload do app após esta alteração,
`main()` e `initState()` não são executados novamente,
e a árvore de widgets é reconstruída com a instância inalterada
de `MyApp` como o widget raiz.
Isso resulta em nenhuma alteração visível após hot reload.

## Como funciona

Quando hot reload é invocado, a máquina host olha
para o código editado desde a última compilação.
As seguintes bibliotecas são recompiladas:

* Quaisquer bibliotecas com código alterado
* A biblioteca principal da aplicação
* As bibliotecas da biblioteca principal levando
  às bibliotecas afetadas

O código-fonte dessas bibliotecas é compilado em
[kernel files][] e enviado para a Dart VM do dispositivo móvel.

A Dart VM recarrega todas as bibliotecas do novo arquivo kernel.
Até agora nenhum código é executado novamente.

O mecanismo de hot reload então faz com que o framework Flutter
acione uma reconstrução/re-layout/repintura de todos os
widgets e render objects existentes.

[static-variables]: {{site.dart-site}}/language/classes#static-variables
[const-new]: {{site.dart-site}}/language/variables#final-and-const
[Dart Virtual Machine (VM)]: {{site.dart-site}}/overview#platform
[Flutter editor]: /get-started/editor
[Issue 43574]: {{site.repo.flutter}}/issues/43574
[kernel files]: {{site.github}}/dart-lang/sdk/tree/main/pkg/kernel
