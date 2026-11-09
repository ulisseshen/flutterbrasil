---
ia-translate: true
title: JNIgen
description: >-
  Aprenda a usar o JNIgen para gerar bindings Dart com segurança de tipos
  para APIs de Java e Kotlin.
---

## Visão geral {:#overview}

O JNIgen (gerador de Java Native Interface) é uma ferramenta de geração de código
que cria bindings Dart com segurança de tipos para bibliotecas e APIs de Java e Kotlin.
Isso permite chamar as APIs do Android diretamente e de forma síncrona a partir
do seu código Dart.

## Quando usar o JNIgen {:#when-to-use-jnigen}

Use o JNIgen quando precisar chamar bibliotecas Java ou Kotlin, empacotar
arquivos JAR ou AAR compilados, ou interagir diretamente com o Android a partir
do seu código Dart.

O JNIgen usa bindings JNI diretos por meio do `dart:ffi`,
por isso é a ferramenta recomendada quando você precisa de interop de alta
performance e baixa latência, ou quando precisa passar grandes volumes de dados
brutos entre o Dart e a JVM.

Para o desenvolvimento de plugins padrão e multiplataforma, em que você não tem
transferências de dados críticas, use o [Pigeon](/interop/pigeon).

## Fluxo de desenvolvimento {:#developer-flow}

Gere bindings com o JNIgen seguindo o fluxo geral abaixo:

1.  Referencie as classes nativas ou os JARs.
1.  Escreva o script de configuração do JNIgen.
1.  Gere os bindings executando o JNIgen.
1.  Chame o código gerado a partir do Dart.

:::note
Para uma lista completa das opções de configuração, consulte a
[documentação do JNIgen no pub.dev][jnigen-pub] e o README do JNIgen.
:::

Para começar, identifique as classes Java nativas, os pacotes ou os arquivos
JAR/AAR compilados que você quer empacotar.
Depois, escreva um script de configuração (normalmente `tool/jnigen.dart`).
Essa configuração especifica onde os arquivos nativos estão localizados,
quais pacotes incluir e onde o código Dart gerado será gravado.

Em seguida, execute o script de configuração (`dart run tool/jnigen.dart`),
que analisa as classes e gera os bindings Dart correspondentes.

Por fim, importe o arquivo Dart gerado no seu app e chame as funções
diretamente.
O JNIgen se comunica diretamente pela camada FFI subjacente, então consulte o
[guia do `dart:ffi`](/interop/dart-ffi)
para aprender a gerenciar o tempo de vida da memória nativa e executar chamadas
nativas sem bloquear a thread da UI.

:::note
Se a API nativa mudar, atualize seu script de configuração e
gere os bindings novamente.
:::

## Exemplos {:#examples}

Para explorar implementações completas desse fluxo,
incluindo como configurar o gerador,
consulte a [demo `permissions_plugin`][permissions-demo] e a
[`android_toast_demo`][toast-demo] no repositório oficial de demos de
interop nativo do Flutter.

Para um pacote de produção no pub.dev que usa o JNIgen para empacotar a
biblioteca HTTP Cronet do Android, confira o [`package:cronet_http`][cronet-http-pub]
([código-fonte no GitHub][cronet-http-src]).

## Restrições e limitações {:#constraints-and-limitations}

Tenha em mente estas considerações e limitações gerais ao trabalhar com o
JNIgen:

### Considerações sobre threading {:#threading-considerations}

As chamadas do JNIgen são executadas de forma síncrona na thread que as chamou.
Atenção a dois cenários comuns:

- Ao chamar APIs de plataforma que precisam ser executadas na thread da
  plataforma, use [`runOnPlatformThread`][run-on-platform-thread] de `dart:ui`.
- Callbacks do Dart chamados a partir do Java são executados no isolate que
  os criou.
  Isso pode levar a deadlocks se uma thread Java bloqueada aguardar uma thread
  Dart bloqueada.

Para saber mais, consulte o [guia de threading do JNIgen][jnigen-threading-doc].

### Ciclo de vida dos objetos Java {:#lifecycle-of-java-objects}

Os wrappers JNI usam referências globais do Java.
Há um limite rígido de 50.000 referências ativas.
Chame `.release()` ou use blocos `.using()` para evitar vazamentos de memória.
Use `WeakReference` para quebrar ciclos de referência entre os GCs do Dart e do
Java ao implementar interfaces, como mostrado no
[guia do ciclo de vida de objetos JNI][jnigen-lifecycle-doc].

### Verificações de tipo em runtime da JVM {:#jvm-runtime-type-checks}

Os wrappers JNI são extension types do Dart que são compilados para `JObject`
em runtime, então as palavras-chave nativas `is` e `as` do Dart não verificam o
tipo de runtime do Java.
Use `x.isA(Foo.type)` e `x.as(Foo.type)` no lugar, como mostrado no
[guia de tipos de runtime do Java][jnigen-runtime-types-doc].

### Depuração geral {:#general-debugging}

Rastrear bugs de alocação de memória JNI, como `DoubleReleaseError` e
`UseAfterReleaseError`, pode ser difícil.
Defina `Jni.captureStackTraceOnRelease = true` para registrar stack traces
e ajudar a rastrear vazamentos, como explicado no
[guia de depuração do JNIgen][jnigen-debugging-doc].

## Recursos {:#resources}

Para saber mais sobre a geração de bindings de Java e Kotlin com o JNIgen,
consulte os seguintes recursos:

- [Pacote JNIgen no pub.dev][jnigen-pub]
- [Pacote JNI no pub.dev][jni-pub]
- [Exemplos oficiais do JNIgen no GitHub][jnigen-examples]

[jnigen-pub]: {{site.pub-pkg}}/jnigen
[jni-pub]: {{site.pub-pkg}}/jni
[cronet-http-pub]: {{site.pub-pkg}}/cronet_http
[cronet-http-src]: https://github.com/dart-lang/http/tree/master/pkgs/cronet_http
[jnigen-examples]: https://github.com/dart-lang/native/tree/main/pkgs/jnigen/example
[permissions-demo]: {{site.repo.demos}}/tree/main/native_interop_demos/permissions_plugin
[toast-demo]: {{site.repo.demos}}/tree/main/native_interop_demos/android_toast_demo
[run-on-platform-thread]: {{site.api}}/flutter/dart-ui/runOnPlatformThread.html
[jnigen-threading-doc]: https://github.com/dart-lang/native/blob/main/pkgs/jnigen/doc/threading.md
[jnigen-lifecycle-doc]: https://github.com/dart-lang/native/blob/main/pkgs/jnigen/doc/lifecycle.md
[jnigen-runtime-types-doc]: https://github.com/dart-lang/native/blob/main/pkgs/jnigen/doc/java_runtime_types.md
[jnigen-debugging-doc]: https://github.com/dart-lang/native/blob/main/pkgs/jnigen/doc/debugging.md
