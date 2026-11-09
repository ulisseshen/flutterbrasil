---
ia-translate: true
title: FlutterMain.setIsRunningInRobolectricTest no Android removido
description: >
    A API apenas para testes FlutterMain.setIsRunningInRobolectricTest no
    engine Android foi consolidada no FlutterInjector.
---

{% render "docs/breaking-changes.md" %}

## Resumo

Se você escreve testes JUnit em Java (como testes Robolectric)
contra o embedding Java do engine Flutter e usou a
API `FlutterMain.setIsRunningInRobolectricTest(true)`,
substitua-a pelo seguinte:

```java
FlutterJNI mockFlutterJNI = mock(FlutterJNI.class);
FlutterInjector.setInstance(
        new FlutterInjector.Builder()
            .setFlutterLoader(new FlutterLoader(mockFlutterJNI))
            .build());
```

Isso deve ser muito incomum.

## Contexto

A própria classe `FlutterMain` está sendo depreciada e substituída pela
classe `FlutterInjector`. A classe `FlutterMain` usa várias
variáveis e funções estáticas que tornam difícil testar.
`FlutterMain.setIsRunningInRobolectricTest()` é um mecanismo estático
ad-hoc para permitir que os testes sejam executados na máquina host na JVM sem
carregar a biblioteca nativa `libflutter.so`
(o que não pode ser feito na máquina host).

Ao invés de soluções pontuais, todas as injeções de dependência necessárias para testes
no embedding Android/Java do Flutter agora foram movidas para a
classe [`FlutterInjector`][].

[`FlutterInjector`]: https://cs.opensource.google/flutter/engine/+/master:shell/platform/android/io/flutter/FlutterInjector.java

Dentro da classe `FlutterInjector`,
a função Builder `setFlutterLoader()`
permite o controle de como a
classe [`FlutterLoader`][] localiza e carrega
a biblioteca `libflutter.so`.

[`FlutterLoader`]: https://cs.opensource.google/flutter/engine/+/master:shell/platform/android/io/flutter/embedding/engine/loader/FlutterLoader.java

## Descrição da mudança

Este [commit do engine][engine commit] removeu a
função de teste `FlutterMain.setIsRunningInRobolectricTest()`;
e o seguinte [commit][] adicionou uma
classe `FlutterInjector` para auxiliar nos testes.
[PR 20473][] refatorou ainda mais `FlutterLoader`
e `FlutterJNI` para permitir mocking e testes adicionais.

[commit]: {{site.repo.engine}}/commit/15f5696c4139a21e1fc54014ce17d01f6ad1737c#diff-f928557f2d60773a8435366400fa42ed
[engine commit]: {{site.repo.engine}}/commit/15f5696c4139a21e1fc54014ce17d01f6ad1737c#diff-599e1d64442183ead768757cca6805c3L154
[PR 20473]: {{site.repo.engine}}/pull/20473
to allow for additional mocking/testing.

## Guia de migração

Código antes da migração:

```java
FlutterMain.setIsRunningInRobolectricTest(true);
```

Código após a migração:

```java
FlutterJNI mockFlutterJNI = mock(FlutterJNI.class);
FlutterInjector.setInstance(
        new FlutterInjector.Builder()
            .setFlutterLoader(new FlutterLoader(mockFlutterJNI))
            .build());
```

## Cronograma

Aterrissou na versão: 1.22.0-2.0.pre.133<br>
No lançamento estável: 2.0.0
