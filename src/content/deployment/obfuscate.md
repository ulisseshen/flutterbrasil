---
ia-translate: true
title: Ofuscar código Dart
description: Como remover nomes de funções e classes do seu binário Dart.
---

<?code-excerpt path-base="deployment/obfuscate"?>

## O que é ofuscação de código?

[Ofuscação de código][Code obfuscation] é o processo de modificar o
binário de um app para torná-lo mais difícil de ser compreendido por humanos.
A ofuscação oculta nomes de funções e classes no seu
código Dart compilado, substituindo cada símbolo por
outro símbolo, tornando difícil para um atacante
fazer engenharia reversa do seu app proprietário.

[Code obfuscation]: https://en.wikipedia.org/wiki/Obfuscation_(software)

## Limitações e avisos {: #limitations}

**A ofuscação de código do Flutter funciona
apenas em um [release build][].**

:::warning
É uma **prática de segurança inadequada**
armazenar segredos em um app.
:::

Ofuscar seu código _não_
criptografa recursos nem protege contra
engenharia reversa.
Apenas renomeia símbolos com nomes mais obscuros.

Apps web não suportam ofuscação.
Um app web pode ser [minificado][minified], o que fornece um resultado similar.
Quando você compila uma versão release de um app Flutter web,
o compilador web minifica o app. Para saber mais,
veja [Build and release a web app][].

[release build]: /testing/build-modes#release
[Build and release a web app]: /deployment/web
[minified]: https://en.wikipedia.org/wiki/Minification_(programming)

## Targets suportados

Os seguintes targets de build
suportam o processo de ofuscação
descrito nesta página:

* `aar`
* `apk`
* `appbundle`
* `ios`
* `ios-framework`
* `ipa`
* `linux`
* `macos`
* `macos-framework`
* `windows`

Para informações detalhadas sobre as opções de linha de comando
disponíveis para um target de build, execute o seguinte
comando. As opções `--obfuscate` e  `--split-debug-info` devem
estar listadas na saída. Se não estiverem, você precisará
instalar uma versão mais recente do Flutter para ofuscar seu código.

```console
$ flutter build <build-target> -h
```
   *  `<build-target>`: O target de build. Por exemplo,
      `apk`.

## Ofuscar seu app

Para ofuscar seu app e criar um mapa de símbolos, use o
comando `flutter build` em modo release
com as opções `--obfuscate` e `--split-debug-info`.
Se você quiser depurar seu app ofuscado
no futuro, você precisará do mapa de símbolos.

1. Execute o seguinte comando para ofuscar seu app e
   gerar um arquivo SYMBOLS:

   ```console
   $ flutter build <build-target> \
      --obfuscate \
      --split-debug-info=/<symbols-directory>
   ```

   *  `<build-target>`: O target de build. Por exemplo,
      `apk`.
   *  `<symbols-directory>`: O diretório onde o arquivo SYMBOLS
      deve ser colocado. Por exemplo,
      `out/android`.

1. Depois de ofuscar seu binário, **faça backup
   do arquivo SYMBOLS**. Você pode precisar disso se perder
   seu arquivo SYMBOLS original e quiser
   des-ofuscar um stack trace.

## Ler um stack trace ofuscado

Para depurar um stack trace criado por um app ofuscado,
use os seguintes passos para torná-lo legível por humanos:

1. Encontre o arquivo SYMBOLS correspondente.
   Por exemplo, uma falha de um dispositivo Android arm64
   precisaria de `app.android-arm64.symbols`.

1. Forneça tanto o stack trace (armazenado em um arquivo)
   quanto o arquivo SYMBOLS para o comando `flutter symbolize`.

   ```console
   $ flutter symbolize \
      -i <stack-trace-file> \
      -d <obfuscated-symbols-file>
   ```

   *  `<stack-trace-file>`: O caminho do arquivo para o
      stacktrace. Por exemplo, `???`.
   *  `<obfuscated-symbols-file>`: O caminho do arquivo para o
      arquivo de símbolos que contém os símbolos ofuscados.
      Por exemplo, `out/android/app.android-arm64.symbols`.

   Para mais informações sobre o comando `symbolize`,
   execute `flutter symbolize -h`.

## Ler um nome ofuscado

Você pode gerar um arquivo JSON que contém
um mapa de ofuscação. Um mapa de ofuscação é um array JSON com
pares de nomes originais e nomes ofuscados. Por exemplo,
`["MaterialApp", "ex", "Scaffold", "ey"]`, onde
`ex` é o nome ofuscado de `MaterialApp`.

Para gerar um mapa de ofuscação, use o seguinte comando:

```console
$ flutter build <build-target> \
   --obfuscate \
   --split-debug-info=/<symbols-directory> \
   --extra-gen-snapshot-options=--save-obfuscation-map=/<obfuscation-map-file>
```

*  `<build-target>`: O target de build. Por exemplo,
   `apk`.
*  `<symbols-directory>`: O diretório onde os símbolos
   devem ser colocados. Por exemplo, `out/android`
*  `<obfuscation-map-file>`: O caminho do arquivo onde o
   mapa de ofuscação JSON deve ser colocado. Por exemplo,
   `out/android/map.json`

## Ressalva

Esteja ciente do seguinte ao codificar um app que
eventualmente será um binário ofuscado.

* Código que depende de corresponder nomes específicos de classe, função,
  ou biblioteca falhará.
  Por exemplo, a seguinte chamada para `expect()` não
  funcionará em um binário ofuscado:

   <?code-excerpt "lib/main.dart (Expect)"?>
   ```dart
   expect(foo.runtimeType.toString(), equals('Foo'));
   ```

* Nomes de Enum não são ofuscados atualmente.
