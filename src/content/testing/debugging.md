---
ia-translate: true
title: Depurar apps Flutter
description: Como depurar seu app Flutter.
---

<?code-excerpt path-base="testing/debugging"?>

Há uma ampla variedade de ferramentas e recursos para ajudar a depurar
aplicações Flutter. Aqui estão algumas das ferramentas disponíveis:

* [VS Code][VS Code] (recomendado) e [Android Studio/IntelliJ][Android Studio/IntelliJ],
  (habilitados com os plugins Flutter e Dart)
  suportam um debugger integrado em nível de código-fonte com
  a capacidade de definir breakpoints, percorrer o código passo a passo,
  e examinar valores.
* [DevTools][DevTools], um conjunto de ferramentas de performance e profiling
  que executam em um navegador.
* [Flutter inspector][Flutter inspector], um inspetor de widgets disponível
  no DevTools, e também diretamente do Android Studio
  e IntelliJ (habilitado com o plugin Flutter).
  O inspector permite que você examine uma representação visual
  da árvore de widgets, inspecione
  widgets individuais e seus valores de propriedade,
  habilite o overlay de performance, e mais.

## Outros recursos

Você pode achar os seguintes documentos úteis:

* [Melhores práticas de performance][Performance best practices]
* [Profiling de performance do Flutter][Flutter performance profiling]
* [Use um debugger nativo][Use a native debugger]
* [Modos do Flutter][Flutter's modes]
* [Depurando apps Flutter programaticamente][Debugging Flutter apps programmatically]

[Debugging Flutter apps programmatically]: /testing/code-debugging
[Flutter's modes]: /testing/build-modes
[Flutter performance profiling]: /perf/ui-performance
[Performance best practices]: /perf/best-practices
[Use a native debugger]: /testing/native-debugging

[Android Studio/IntelliJ]: /tools/android-studio#run-app-with-breakpoints
[VS Code]: /tools/vs-code#run-app-with-breakpoints
[DevTools]: /tools/devtools
[Flutter inspector]: /tools/devtools/inspector
