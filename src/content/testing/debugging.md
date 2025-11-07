---
ia-translate: true
title: Depurar apps Flutter
description: Como depurar seu app Flutter.
---

<?code-excerpt path-base="testing/debugging"?>

Há uma ampla variedade de ferramentas e recursos para ajudar a depurar
aplicações Flutter. Aqui estão algumas das ferramentas disponíveis:

* [VS Code][](recomendado) e [Android Studio/IntelliJ][],
  (habilitado com os plugins Flutter e Dart)
  suportam um depurador integrado em nível de código fonte com
  a capacidade de definir breakpoints, percorrer o código,
  e examinar valores.
* [DevTools][], uma suite de ferramentas de desempenho e profiling
  que executam em um navegador.
* [Flutter inspector][], um inspetor de widgets disponível
  no DevTools, e também diretamente do Android Studio
  e IntelliJ (habilitado com o plugin Flutter).
  O inspetor permite que você examine uma representação visual
  da árvore de widgets, inspecione
  widgets individuais e seus valores de propriedade,
  habilite a sobreposição de desempenho, e mais.
* Se você está procurando uma maneira de usar GDB para depurar remotamente o
  engine Flutter executando dentro de um processo de app Android,
  confira [`flutter_gdb`][].


[`flutter_gdb`]: {{site.repo.flutter}}/blob/main/engine/src/flutter/sky/tools/flutter_gdb

## Outros recursos

Você pode achar os seguintes documentos úteis:

* [Performance best practices][]
* [Flutter performance profiling][]
* [Use a native debugger][]
* [Flutter's modes][]
* [Debugging Flutter apps programmatically][]

[Flutter enabled IDE/editor]: /get-started/editor

[Debugging Flutter apps programmatically]: /testing/code-debugging
[Flutter's modes]: /testing/build-modes
[Flutter performance profiling]: /perf/ui-performance
[Performance best practices]: /perf/best-practices
[Use a native debugger]: /testing/native-debugging

[Android Studio/IntelliJ]: /tools/android-studio#run-app-with-breakpoints
[VS Code]: /tools/vs-code#run-app-with-breakpoints
[DevTools]: /tools/devtools
[Flutter inspector]: /tools/devtools/inspector
