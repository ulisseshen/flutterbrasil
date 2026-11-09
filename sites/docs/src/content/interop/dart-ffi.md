---
ia-translate: true
title: Interagir com memória nativa usando dart:ffi
shortTitle: dart:ffi
description: >-
  Aprenda a interagir com memória nativa usando a biblioteca dart:ffi.
---

A biblioteca `dart:ffi` (Foreign Function Interface) é uma biblioteca central do
SDK do Dart que oferece as APIs de baixo nível para chamar funções com ABI C
a partir do Dart.

Em vez de ferramentas de geração de código como [Pigeon](/interop/pigeon),
[FFIgen](/interop/ffigen),
ou [JNIgen](/interop/jnigen),
`dart:ffi` é a tecnologia subjacente que alimenta essas ferramentas
e permite a interoperabilidade com memória nativa.

## Quando usar `dart:ffi` e `package:ffi` {:#when-to-use-dart-ffi-and-package-ffi}

A memória do Dart é liberada automaticamente pelo coletor de lixo, enquanto a
memória C nativa é gerenciada manualmente. Por isso, use `dart:ffi` e
`package:ffi` para preencher essa lacuna.

Os dois cenários mais comuns em que `package:ffi` é necessário junto com
`dart:ffi` são a alocação de memória e a conversão de strings C.

Na alocação de memória, use `package:ffi` para reservar espaço na heap do
sistema para os argumentos nativos e libere essa memória manualmente quando
terminar, para evitar vazamentos.

Na conversão de dados, use `package:ffi` para converter strings do Dart em
strings C (`Pointer<Utf8>` ou `Pointer<Utf16>`), para que possam ser lidas pelo
código C nativo.

## Ferramentas principais: `dart:ffi` e `package:ffi` {:#core-tools-dart-ffi-and-package-ffi}

Para escrever código de interoperabilidade com C, use duas bibliotecas:

- **`dart:ffi`:** integrada ao SDK do Dart e necessária para fazer
  interoperabilidade FFI. Ela oferece tipos de representação nativa, ponteiros,
  structs e assinaturas para busca de funções.
- **`package:ffi`:** um pacote complementar com utilitários úteis em casos
  comuns de interoperabilidade com C, como alocação de memória (`calloc` e
  `malloc`) e funções auxiliares para conversão de strings C.

## Concorrência no Flutter {:#concurrency-in-flutter}

Chamadas FFI são síncronas e executam na thread em que foram chamadas.
Se você invocar uma função C pesada ou bloqueante na thread principal da UI do
seu app Flutter, o app pode travar ou perder frames.
Para evitar isso, execute chamadas FFI bloqueantes dentro de um isolate do Dart
em segundo plano, usando `Isolate.run`.

## Recursos {:#resources}

Para explorar exemplos de alocação de memória, conversão de strings e
carregamento dinâmico de bibliotecas, consulte estes recursos de interoperabilidade do Dart:

- [Guia de interop com C (inclui exemplos de código para ponteiros, alocação de memória e structs)][dart-c-interop]
- [Referência da API `dart:ffi`][dart-ffi-api]
- [`package:ffi` no pub.dev][package-ffi-pub]

[dart-c-interop]: {{site.dart-site}}/interop/c-interop
[dart-ffi-api]: {{site.dart.api}}/dart-ffi/dart-ffi-library.html
[package-ffi-pub]: {{site.pub-pkg}}/ffi
