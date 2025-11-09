---
ia-translate: true
title: Hot reload
description: Acelere o desenvolvimento usando o recurso de hot reload do Flutter.
---

<?code-excerpt path-base="tools"?>

O recurso de hot reload do Flutter ajuda você a experimentar, construir UIs,
adicionar recursos e corrigir bugs de forma rápida e fácil.
Hot reload funciona injetando arquivos de código-fonte atualizados
no [Dart runtime][Dart runtime].
Depois que o Dart runtime atualiza classes com as novas versões de campos e funções,
o framework Flutter reconstrói automaticamente a árvore de widgets,
permitindo que você visualize rapidamente os efeitos de suas mudanças.

![Hot reload GIF](/assets/images/docs/tools/hot-reload.gif){:width="100%"}<br>
Uma demonstração de hot reload no DartPad

## Como fazer um hot reload

Para fazer hot reload em um app Flutter:

 1. Execute o app a partir de um [Flutter editor][Flutter editor] compatível ou de uma janela de terminal.
    Tanto um dispositivo físico quanto virtual pode ser o alvo.
    **Apenas apps Flutter em modo debug podem ter hot reload ou hot restart.**
 1. Modifique um dos arquivos Dart em seu projeto.
    A maioria dos tipos de mudanças de código pode ter hot reload;
    para uma lista de mudanças que requerem hot restart,
    veja [Special cases][Special cases].
 1. Se você está trabalhando em uma IDE/editor que suporta as ferramentas de IDE do Flutter
    e hot reload ao salvar está habilitado,
    selecione **Save All** (`cmd-s`/`ctrl-s`),
    ou clique no botão hot reload na barra de ferramentas.

    <a id="hot-reload-on-save" aria-hidden="true"></a>

    :::tip Para habilitar hot reload ao salvar
    A partir de sua IDE preferida,
    habilite autosave e hot reloads ao salvar.

    **VS Code**

    Adicione o seguinte ao seu arquivo `.vscode/settings.json`:

    ```json
    "files.autoSave": "afterDelay",
    "dart.flutterHotReloadOnSave": "all",
    ```

    **Android Studio e IntelliJ**

    * Abra `Settings > Tools > Actions on Save` e selecione
      `Configure autosave options`.
        - Marque a opção para `Save files if the IDE is idle for X seconds`.
        - **Recomendado:** Defina uma duração de delay pequena. Por exemplo, 2 segundos.

    * Abra `Settings > Languages & Frameworks > Flutter`.
        - Marque a opção para `Perform hot reload on save`.
    :::

    Se você está executando o app na linha de comando usando `flutter run`,
    digite `r` na janela do terminal.

Depois de uma operação de hot reload bem-sucedida,
você verá uma mensagem no console similar a:

```console
Performing hot reload...
Reloaded 1 of 448 libraries in 978ms.
```

O app atualiza para refletir sua mudança,
e o estado atual do app é preservado.
Seu app continua a executar de onde estava antes
de executar o comando hot reload.
O código atualiza e a execução continua.

:::secondary
**Qual é a diferença entre hot reload, hot restart,
e full restart?**

* **Hot reload** carrega mudanças de código no VM ou no navegador,
  e reconstrói a árvore de widgets, preservando o estado do app;
  ele não executa novamente `main()` ou `initState()`.
  (`⌘\` no Intellij e Android Studio, `⌃F5` no VSCode)
* **Hot restart** carrega mudanças de código no VM ou no navegador,
  e reinicia o app Flutter, perdendo o estado do app.
  Na web, isso pode reiniciar o app sem um refresh completo da página.
  (`⇧⌘\` no IntelliJ e Android Studio, `⇧⌘F5` no VSCode)
* **Full restart** reinicia o app iOS, Android ou web.
  Isso leva mais tempo porque também recompila o
  código Java / Kotlin / Objective-C / Swift / JavaScript.
  Na web, também reinicia o Dart Development Compiler.
  Não há atalho de teclado específico para isso;
  você precisa parar e iniciar a configuração de execução.

Flutter web agora suporta hot restart e [hot reload][hot reload].
:::

[hot reload]: /platform-integration/web/building#hot-reload-web

![Android Studio UI](/assets/images/docs/development/tools/android-studio-run-controls.png){:width="100%"}<br>
Controles para run, run debug, hot reload e hot restart no Android Studio

Uma mudança de código tem um efeito visível apenas se o código
Dart modificado for executado novamente após a mudança. Especificamente,
um hot reload faz com que todos os widgets existentes sejam reconstruídos.
Apenas o código envolvido na reconstrução dos widgets
é automaticamente re-executado. As funções `main()` e `initState()`,
por exemplo, não são executadas novamente.

## Casos especiais

As próximas seções descrevem cenários específicos que envolvem
hot reload. Em alguns casos, pequenas mudanças no código Dart
permitem que você continue usando hot reload para seu app.
Em outros casos, um hot restart ou um full restart é necessário.

### Um app é encerrado

Hot reload pode falhar quando o app é encerrado.
Por exemplo, se o app ficou em segundo plano por muito tempo.

### Erros de compilação

Quando uma mudança de código introduz um erro de compilação,
hot reload gera uma mensagem de erro similar a:

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
linhas especificadas de código Dart para continuar usando hot reload.

### CupertinoTabView's builder

Hot reload não aplicará mudanças feitas em
um `builder` de um `CupertinoTabView`.
Para mais informações, veja [Issue 43574][Issue 43574].

### Tipos enumerados

Hot reload não funciona quando tipos enumerados são
alterados para classes regulares ou classes regulares são
alteradas para tipos enumerados.

Por exemplo:

Antes da mudança:
<?code-excerpt "lib/hot-reload/before.dart (enum)"?>
```dart
enum Color { red, green, blue }
```

Depois da mudança:
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

Antes da mudança:
<?code-excerpt "lib/hot-reload/before.dart (class)"?>
```dart
class A<T> {
  T? i;
}
```

Depois da mudança:
<?code-excerpt "lib/hot-reload/after.dart (class)"?>
```dart
class A<T, V> {
  T? i;
  V? v;
}
```

### Código nativo

Se você mudou código nativo (como Kotlin, Java, Swift,
ou Objective-C), você deve executar um full restart (parar e
reiniciar o app) para ver as mudanças terem efeito.

### Estado anterior é combinado com novo código

Hot reload com estado do Flutter preserva o estado de seu app.
Esta abordagem permite que você visualize o efeito apenas da
mudança mais recente, sem descartar o estado atual.
Por exemplo, se seu app requer que um usuário faça login,
você pode modificar e fazer hot reload de uma página vários níveis abaixo na
hierarquia de navegação, sem reinserir suas credenciais de login.
O estado é mantido, que é geralmente o comportamento desejado.

Se mudanças de código afetam o estado de seu app (ou suas dependências),
os dados com os quais seu app tem que trabalhar podem não estar totalmente consistentes
com os dados que ele teria se executasse do zero.
O resultado pode ser um comportamento diferente após um hot reload
versus um hot restart.

### Mudança recente de código é incluída mas o estado do app é excluído

No Dart, [campos estáticos são inicializados preguiçosamente][static-variables].
Isso significa que na primeira vez que você executa um app Flutter e um
campo estático é lido, ele é definido com qualquer valor para o qual seu
inicializador foi avaliado.
Variáveis globais e campos estáticos são tratados como estado,
e portanto não são reinicializados durante hot reload.

Se você mudar inicializadores de variáveis globais e campos estáticos,
um hot restart ou reiniciar o estado onde os inicializadores são mantidos
é necessário para ver as mudanças.
Por exemplo, considere o seguinte código:

<?code-excerpt "lib/hot-reload/before.dart (sample-table)"?>
```dart
final sampleTable = [
  Table(
    children: const [
      TableRow(children: [Text('T1')]),
    ],
  ),
  Table(
    children: const [
      TableRow(children: [Text('T2')]),
    ],
  ),
  Table(
    children: const [
      TableRow(children: [Text('T3')]),
    ],
  ),
  Table(
    children: const [
      TableRow(children: [Text('T4')]),
    ],
  ),
];
```

Depois de executar o app, você faz a seguinte mudança:

<?code-excerpt "lib/hot-reload/after.dart (sample-table)"?>
```dart
final sampleTable = [
  Table(
    children: const [
      TableRow(children: [Text('T1')]),
    ],
  ),
  Table(
    children: const [
      TableRow(children: [Text('T2')]),
    ],
  ),
  Table(
    children: const [
      TableRow(children: [Text('T3')]),
    ],
  ),
  Table(
    children: const [
      TableRow(
        children: [Text('T10')], // modified
      ),
    ],
  ),
];
```

Você faz hot reload, mas a mudança não é refletida.

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
Então, você faz a seguinte mudança:

<?code-excerpt "lib/hot-reload/after.dart (const)"?>
```dart
const foo = 2; // modified
final bar = foo;
void onClick() {
  print(foo);
  print(bar);
}
```

Enquanto mudanças em valores de campos `const` são sempre recarregadas com hot reload,
o inicializador de campo estático não é re-executado. Conceitualmente,
campos `const` são tratados como aliases ao invés de estado.

O Dart VM detecta mudanças de inicializador e sinaliza quando um conjunto
de mudanças precisa de um hot restart para ter efeito.
O mecanismo de sinalização é acionado para
a maior parte do trabalho de inicialização no exemplo acima,
mas não para casos como o seguinte:

<?code-excerpt "lib/hot-reload/after.dart (final-foo)"?>
```dart
final bar = foo;
```

Para atualizar `foo` e ver a mudança após hot reload,
considere redefinir o campo como `const` ou usar um getter para
retornar o valor, ao invés de usar `final`.
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

### Mudança recente de UI é excluída

Mesmo quando uma operação de hot reload parece bem-sucedida e não gera
exceções, algumas mudanças de código podem não ser visíveis na UI atualizada.
Este comportamento é comum após mudanças nos métodos `main()` ou
`initState()` do app.

Como regra geral, se o código modificado está downstream do método
`build()` do widget raiz, então hot reload se comporta como esperado.
No entanto, se o código modificado não será re-executado como resultado
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

Depois de executar este app, mude o código da seguinte forma:

<?code-excerpt "lib/hot-reload/after.dart (main)"?>
```dart
import 'package:flutter/widgets.dart';

void main() {
  runApp(const Center(child: Text('Hello', textDirection: TextDirection.ltr)));
}
```

Com um hot restart, o programa começa do início,
executa a nova versão de `main()`,
e constrói uma árvore de widgets que exibe o texto `Hello`.

No entanto, se você fizer hot reload no app após esta mudança,
`main()` e `initState()` não são re-executados,
e a árvore de widgets é reconstruída com a instância inalterada
de `MyApp` como o widget raiz.
Isso resulta em nenhuma mudança visível após hot reload.

## Como funciona

Quando hot reload é invocado, a máquina host olha
para o código editado desde a última compilação.
As seguintes bibliotecas são recompiladas:

* Quaisquer bibliotecas com código alterado
* A biblioteca principal do aplicativo
* As bibliotecas da biblioteca principal levando
  a bibliotecas afetadas

O código-fonte dessas bibliotecas é compilado em
[arquivos kernel][kernel files] e enviado ao Dart VM do dispositivo móvel.

O Dart VM recarrega todas as bibliotecas do novo arquivo kernel.
Até agora nenhum código é re-executado.

O mecanismo de hot reload então faz com que o framework Flutter
dispare um rebuild/re-layout/repaint de todos os widgets e
objetos de renderização existentes.

[static-variables]: {{site.dart-site}}/language/classes#static-variables
[const-new]: {{site.dart-site}}/language/variables#final-and-const
[Dart runtime]: {{site.dart-site}}/overview#platform
[Flutter editor]: /tools/editors
[Issue 43574]: {{site.repo.flutter}}/issues/43574
[kernel files]: {{site.github}}/dart-lang/sdk/tree/main/pkg/kernel
[Special cases]: #special-cases
