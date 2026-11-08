---
ia-translate: true
title: FFIgen
description: >-
  Aprenda a usar o FFIgen para gerar bindings Dart com segurança de tipos
  para APIs de C, Objective-C e Swift.
---

## Visão geral {:#overview}

O FFIgen (o gerador de Foreign Function Interface) é uma ferramenta de geração
de código que cria bindings Dart com segurança de tipos para bibliotecas C e
frameworks da Apple (Objective-C e Swift).
Isso permite chamar as APIs de plataformas Apple (iOS e macOS) diretamente
e de forma síncrona a partir do seu código Dart.

:::note
O suporte direto a Swift é experimental.
:::

## Quando usar o FFIgen {:#when-to-use-ffigen}

Use o FFIgen quando precisar chamar bibliotecas C,
empacotar binários compilados (como os escritos em C, C++, Rust ou Go),
ou interagir diretamente com frameworks Objective-C e Swift no iOS e no macOS.

:::note
O FFIgen analisa headers de C e Objective-C.
Para empacotar bibliotecas C++, exponha uma interface compatível com C
em torno do seu código C++.
O FFIgen não consegue analisar classes ou templates de C++ diretamente.
:::

Para o desenvolvimento de plugins padrão e multiplataforma, em que você não tem
transferências de dados críticas, use o [Pigeon](/interop/pigeon).

## Fluxo de desenvolvimento {:#developer-flow}

Gere bindings com o FFIgen seguindo estes passos:

1.  Referencie os headers nativos.
1.  Escreva o script de configuração do FFIgen.
1.  Gere os bindings executando o FFIgen.
1.  Chame o código gerado a partir do Dart.

Para começar, identifique os arquivos de header nativos ou as APIs que você
quer empacotar.
Em seguida, escreva um script de configuração (normalmente `tool/ffigen.dart`).
Essa configuração especifica onde os arquivos de header estão localizados
e onde o código Dart gerado será gravado.

Depois, execute o script de configuração (`dart run tool/ffigen.dart`),
que analisa os headers e gera os bindings Dart correspondentes.

Por fim, importe o arquivo Dart gerado no seu app e chame as funções
diretamente.
O FFIgen se comunica diretamente pela camada FFI subjacente, então consulte o
[guia do `dart:ffi`](/interop/dart-ffi)
para aprender a gerenciar o tempo de vida da memória nativa e executar chamadas
nativas sem bloquear a thread da UI.

:::note
Se a API nativa mudar, atualize seu script de configuração
e gere os bindings novamente.
:::

## Exemplo {:#example}

Para explorar uma implementação completa desse fluxo,
incluindo como configurar o gerador,
consulte os [exemplos oficiais do FFIgen][ffigen-examples].

O exemplo `add` destaca o fluxo geral com uma API nativa de brincadeira
(uma única função em um único arquivo de header).

Os exemplos `code_assets` destacam casos reais, como
consultas de hostname do sistema e reprodução de áudio.

Para um pacote de produção no pub.dev que usa o FFIgen para empacotar a API
`NSURLSession` da Apple, confira o [`package:cupertino_http`][cupertino-http-pub]
([código-fonte no GitHub][cupertino-http-src]).

## Restrições e limitações {:#constraints-and-limitations}

Algumas considerações gerais ao trabalhar com o FFIgen:

### Arquivos de header de origem {:#source-header-files}

O FFIgen usa o `libclang` para analisar headers.
Sempre resolva os avisos do compilador registrados durante a geração
para evitar falhas em tempo de execução.

### Diferenças entre sistemas operacionais {:#os-differences}

O Dart não tem equivalente às macros de C (como `#if TARGET_OS_IPHONE`),
então trate pequenas variações de API usando verificações em tempo de execução
com `Platform.isIOS`.

Algumas armadilhas específicas de Objective-C e Swift ao trabalhar com o FFIgen:

### Bindings do Objective-C {:#objective-c-bindings}

Métodos Objective-C são resolvidos dinamicamente.
O FFIgen mapeia automaticamente os seletores de método para assinaturas Dart,
mas verifique os seletores lendo os bindings
se você estiver usando métodos nativos muito sobrecarregados.

### Gerenciamento de memória do Objective-C {:#objective-c-memory-management}

O Dart usa coleta de lixo enquanto o Objective-C usa contagem de referências.
Passar closures do Dart que capturam objetos wrapper nativos pode facilmente
criar ciclos de referência e vazamentos de memória.
Para quebrar esses ciclos, envolva o objeto capturado em um `WeakReference`,
como mostrado no [guia de gerenciamento de memória do Objective-C][objc-gc-doc].

### Verificações de runtime do Objective-C {:#objective-c-runtime-checks}

Os wrappers do FFIgen impõem os tipos estáticos do Dart,
mas o objeto Objective-C subjacente pode ter uma subclasse diferente em runtime,
então as palavras-chave `is` e `as` do Dart não funcionam como esperado.
Use `.isA()` e `.as()` no lugar, como mostrado no
[guia de tipos de runtime do Objective-C][objc-runtime-types-doc].

### Multithreading no Objective-C {:#objective-c-multithreading}

Chamadas do Objective-C relacionadas à UI precisam ser executadas na thread
principal da plataforma iOS.
Além disso, alguns tipos de callbacks podem derrubar seu app
se forem executados na thread errada.
Para saber mais, consulte o [guia de threading do Objective-C][objc-threading-doc].

### Compatibilidade com Swift {:#swift-compatibility}

O FFIgen interage com Swift por meio do Objective-C.
Recursos puros de Swift (como structs, generics ou enums com valores associados)
não são suportados, e as classes precisam ser anotadas com `@objc`.
Para interop puro com Swift, explore o pacote experimental
[`package:swiftgen`][swiftgen-pub] da equipe do Dart,
ou use o [Pigeon](/interop/pigeon) para plugins Swift de produção.

## Recursos {:#resources}

Para saber mais sobre a geração de bindings de C, Objective-C e Swift com o FFIgen,
consulte os seguintes recursos:

- [Pacote FFIgen no pub.dev][ffigen-pub]
- [Pacote `objective_c` no pub.dev][objc-pub]
- [Exemplos oficiais do FFIgen no GitHub][ffigen-examples]

[ffigen-pub]: {{site.pub-pkg}}/ffigen
[objc-pub]: {{site.pub-pkg}}/objective_c
[swiftgen-pub]: {{site.pub-pkg}}/swiftgen
[cupertino-http-pub]: {{site.pub-pkg}}/cupertino_http
[cupertino-http-src]: https://github.com/dart-lang/http/tree/master/pkgs/cupertino_http
[ffigen-examples]: https://github.com/dart-lang/native/tree/main/pkgs/ffigen/example
[objc-gc-doc]: https://github.com/dart-lang/native/blob/main/pkgs/ffigen/doc/objc_gc.md
[objc-runtime-types-doc]: https://github.com/dart-lang/native/blob/main/pkgs/ffigen/doc/objc_runtime_types.md
[objc-threading-doc]: https://github.com/dart-lang/native/blob/main/pkgs/ffigen/doc/objc_threading.md
