---
title: Depurar aplicativos Flutter
description: Como depurar seu aplicativo Flutter.
ia-translate: true
---

<?code-excerpt path-base="testing/debugging"?>

Há uma grande variedade de ferramentas e recursos para ajudar a depurar
aplicativos Flutter. Aqui estão algumas das ferramentas disponíveis:

* [VS Code][](recomendado) e [Android Studio/IntelliJ][],
  (habilitados com os plugins Flutter e Dart)
  oferecem suporte a um depurador de nível de código-fonte integrado com
  a capacidade de definir breakpoints, percorrer o código passo a passo,
  e examinar valores.
* [DevTools][], um conjunto de ferramentas de performance e profiling
  que são executadas em um navegador.
* [Flutter inspector][], um inspetor de widgets disponível
  no DevTools e também diretamente do Android Studio
  e IntelliJ (habilitado com o plugin Flutter).
  O inspetor permite examinar uma representação visual
  da árvore de widgets, inspecionar widgets individuais e seus valores de propriedade,
  habilitar o overlay de desempenho e muito mais.
* Se você está procurando uma maneira de usar o GDB para depurar remotamente o
  engine Flutter em execução dentro de um processo de aplicativo Android,
  confira [`flutter_gdb`][].


[`flutter_gdb`]: {{site.repo.engine}}/blob/main/sky/tools/flutter_gdb

## Outros recursos

Você pode achar os seguintes documentos úteis:

* [Melhores práticas de performance][]
* [Profiling de performance do Flutter][]
* [Usar um depurador nativo][]
* [Modos do Flutter][]
* [Depurando aplicativos Flutter programaticamente][]

[Flutter enabled IDE/editor]: /get-started/editor

[Depurando aplicativos Flutter programaticamente]: /testing/code-debugging
[Modos do Flutter]: /testing/build-modes
[Profiling de performance do Flutter]: /perf/ui-performance
[Melhores práticas de performance]: /perf/best-practices
[Usar um depurador nativo]: /testing/native-debugging

[Android Studio/IntelliJ]: /tools/android-studio#run-app-with-breakpoints
[VS Code]: /tools/vs-code#run-app-with-breakpoints
[DevTools]: /tools/devtools
[Flutter inspector]: /tools/devtools/inspector
