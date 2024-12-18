---
ia-translate: true
title: FlutterMain.setIsRunningInRobolectricTest removido no Android
description: >
    A API `FlutterMain.setIsRunningInRobolectricTest` apenas para testes no
    mecanismo Android é consolidada no `FlutterInjector`.
---

## Resumo

Se você escreve testes Java JUnit (como testes Robolectric) contra o
`embedding` Java do mecanismo Flutter e usou a API
`FlutterMain.setIsRunningInRobolectricTest(true)`, substitua-a pelo
seguinte:

```java
FlutterJNI mockFlutterJNI = mock(FlutterJNI.class);
FlutterInjector.setInstance(
        new FlutterInjector.Builder()
            .setFlutterLoader(new FlutterLoader(mockFlutterJNI))
            .build());
```

Isso deve ser muito incomum.

## Contexto

A própria classe `FlutterMain` está sendo descontinuada e substituída
pela classe `FlutterInjector`. A classe `FlutterMain` usa várias
variáveis e funções estáticas que dificultam o teste.
`FlutterMain.setIsRunningInRobolectricTest()` é um mecanismo estático
*ad-hoc* para permitir que os testes sejam executados na máquina host
na JVM sem carregar a biblioteca nativa `libflutter.so` (o que não
pode ser feito na máquina host).

Em vez de soluções pontuais, todas as injeções de dependência
necessárias para testes no `embedding` do mecanismo Android/Java do
Flutter agora são movidas para a classe [`FlutterInjector`].

[`FlutterInjector`]: https://cs.opensource.google/flutter/engine/+/master:shell/platform/android/io/flutter/FlutterInjector.java

Dentro da classe `FlutterInjector`, a função `setFlutterLoader()` do
Builder permite o controle de como a classe [`FlutterLoader`][]
localiza e carrega a biblioteca `libflutter.so`.

[`FlutterLoader`]: https://cs.opensource.google/flutter/engine/+/master:shell/platform/android/io/flutter/embedding/engine/loader/FlutterLoader.java

## Descrição da mudança

Este [commit do engine][] removeu a função de teste
`FlutterMain.setIsRunningInRobolectricTest()`; e o seguinte
[commit][] adicionou uma classe `FlutterInjector` para auxiliar nos
testes. O [PR 20473][] refatorou ainda mais `FlutterLoader` e
`FlutterJNI` para permitir simulações e testes adicionais.

[commit]: {{site.repo.engine}}/commit/15f5696c4139a21e1fc54014ce17d01f6ad1737c#diff-f928557f2d60773a8435366400fa42ed
[engine commit]: {{site.repo.engine}}/commit/15f5696c4139a21e1fc54014ce17d01f6ad1737c#diff-599e1d64442183ead768757cca6805c3L154
[PR 20473]: {{site.repo.engine}}/pull/20473
para permitir simulação/teste adicionais.

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

## Linha do tempo

Implementado na versão: 1.22.0-2.0.pre.133<br>
Na versão estável: 2.0.0
