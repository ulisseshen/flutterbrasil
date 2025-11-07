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

**A ofuscação de código do Flutter funciona
apenas em uma [release build][].**

[Code obfuscation]: https://en.wikipedia.org/wiki/Obfuscation_(software)
[release build]: /testing/build-modes#release

## Limitações

Note que ofuscar seu código _não_
criptografa recursos nem protege contra
engenharia reversa.
Ele apenas renomeia símbolos com nomes mais obscuros.

:::warning
É uma **prática de segurança ruim**
armazenar segredos em um app.
:::

## Alvos suportados

Os seguintes alvos de build
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

:::note
Apps web não suportam ofuscação.
Um app web pode ser [minificado][minified], o que fornece um resultado similar.
Quando você compila uma versão release de um app Flutter web,
o compilador web minifica o app. Para saber mais,
veja [Compilar e lançar um app web][Build and release a web app].
:::

[Build and release a web app]: /deployment/web
[minified]: https://en.wikipedia.org/wiki/Minification_(programming)

## Ofuscar seu app

Para ofuscar seu app, use o comando `flutter build`
em modo release
com as opções `--obfuscate` e  `--split-debug-info`.
A opção `--split-debug-info` especifica o diretório
onde o Flutter gera os arquivos de debug.
No caso da ofuscação, ele gera um mapa de símbolos.
Por exemplo:

```console
$ flutter build apk --obfuscate --split-debug-info=/<project-name>/<directory>
```

Depois de ofuscar seu binário, **salve
o arquivo de símbolos**. Você precisará dele se mais tarde
quiser desofuscar um stack trace.

:::tip
A opção `--split-debug-info` também pode ser usada sem `--obfuscate`
para extrair símbolos do programa Dart, reduzindo o tamanho do código.
Para saber mais sobre tamanho de app, veja [Medindo o tamanho do seu app][Measuring your app's size].
:::

[Measuring your app's size]: /perf/app-size

Para informações detalhadas sobre essas flags, execute
o comando de ajuda para seu alvo específico, por exemplo:

```console
$ flutter build apk -h
```

Se essas flags não estiverem listadas na saída,
execute `flutter --version` para verificar sua versão do Flutter.

## Ler um stack trace ofuscado

Para depurar um stack trace criado por um app ofuscado,
use os seguintes passos para torná-lo legível para humanos:

1. Encontre o arquivo de símbolos correspondente.
   Por exemplo, uma falha de um dispositivo Android arm64
   precisaria de `app.android-arm64.symbols`.

1. Forneça tanto o stack trace (armazenado em um arquivo)
   quanto o arquivo de símbolos para o comando `flutter symbolize`.
   Por exemplo:

   ```console
   $ flutter symbolize -i <stack trace file> -d out/android/app.android-arm64.symbols
   ```

   Para mais informações sobre o comando `symbolize`,
   execute `flutter symbolize -h`.

## Ler um nome ofuscado

Para tornar legível um nome que um app ofuscou,
use os seguintes passos:

1. Para salvar o mapa de ofuscação de nomes no momento da compilação do app,
   use `--extra-gen-snapshot-options=--save-obfuscation-map=/<your-path>`.
   Por exemplo:

   ```console
   $ flutter build apk --obfuscate --split-debug-info=/<project-name>/<directory> --extra-gen-snapshot-options=--save-obfuscation-map=/<your-path>
   ```

1. Para recuperar o nome, use o mapa de ofuscação gerado.
   O mapa de ofuscação é um array JSON plano com pares de
   nomes originais e nomes ofuscados. Por exemplo,
   `["MaterialApp", "ex", "Scaffold", "ey"]`, onde `ex`
   é o nome ofuscado de `MaterialApp`.

## Ressalva

Esteja ciente do seguinte ao codificar um app que
eventualmente será um binário ofuscado.

* Código que depende de correspondência de nomes específicos de classe, função,
  ou biblioteca falhará.
  Por exemplo, a seguinte chamada a `expect()` não
  funcionará em um binário ofuscado:

<?code-excerpt "lib/main.dart (Expect)"?>
```dart
expect(foo.runtimeType.toString(), equals('Foo'));
```

* Nomes de Enum não são ofuscados atualmente.
