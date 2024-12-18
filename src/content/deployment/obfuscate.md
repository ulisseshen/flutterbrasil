---
ia-translate: true
title: Ocultar código Dart
description: Como remover nomes de funções e classes do seu binário Dart.
---

<?code-excerpt path-base="deployment/obfuscate"?>

## O que é ofuscação de código?

[Ofuscação de código][] é o processo de modificar o binário de um aplicativo para torná-lo mais difícil de ser compreendido por humanos. A ofuscação oculta os nomes de funções e classes no seu código Dart compilado, substituindo cada símbolo por outro, dificultando que um invasor faça a engenharia reversa do seu aplicativo proprietário.

**A ofuscação de código do Flutter funciona
apenas em um [build de release][].**

[Ofuscação de código]: https://en.wikipedia.org/wiki/Obfuscation_(software)
[build de release]: /testing/build-modes#release

## Limitações

Observe que ofuscar seu código _não_ criptografa recursos, nem protege contra engenharia reversa. Ele apenas renomeia símbolos com nomes mais obscuros.

:::warning
É uma **má prática de segurança**
armazenar segredos em um aplicativo.
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
Aplicativos da web não suportam ofuscação.
Um aplicativo da web pode ser [minificado][], o que fornece um resultado semelhante.
Quando você cria uma versão de release de um aplicativo web Flutter, o compilador web minifica o aplicativo. Para saber mais, consulte [Construir e liberar um aplicativo web][].
:::

[Construir e liberar um aplicativo web]: /deployment/web
[minificado]: https://en.wikipedia.org/wiki/Minification_(programming)

## Ofuscar seu aplicativo

Para ofuscar seu aplicativo, use o comando `flutter build`
no modo release
com as opções `--obfuscate` e `--split-debug-info`.
A opção `--split-debug-info` especifica o diretório
onde o Flutter gera os arquivos de depuração.
No caso de ofuscação, ele gera um mapa de símbolos.
Por exemplo:

```console
$ flutter build apk --obfuscate --split-debug-info=/<nome-do-projeto>/<diretório>
```

Depois de ofuscar seu binário, **salve
o arquivo de símbolos**. Você precisará dele caso deseje
desofuscar um stack trace posteriormente.

:::tip
A opção `--split-debug-info` também pode ser usada sem `--obfuscate`
para extrair símbolos do programa Dart, reduzindo o tamanho do código.
Para saber mais sobre o tamanho do aplicativo, consulte [Medindo o tamanho do seu aplicativo][].
:::

[Medindo o tamanho do seu aplicativo]: /perf/app-size

Para obter informações detalhadas sobre essas flags, execute
o comando de ajuda para seu alvo específico, por exemplo:

```console
$ flutter build apk -h
```

Se essas flags não estiverem listadas na saída,
execute `flutter --version` para verificar sua versão do Flutter.

## Ler um stack trace ofuscado

Para depurar um stack trace criado por um aplicativo ofuscado,
use as seguintes etapas para torná-lo legível:

1. Encontre o arquivo de símbolos correspondente.
   Por exemplo, uma falha de um dispositivo Android arm64
   precisaria de `app.android-arm64.symbols`.

1. Forneça o stack trace (armazenado em um arquivo)
   e o arquivo de símbolos para o comando `flutter symbolize`.
   Por exemplo:

   ```console
   $ flutter symbolize -i <arquivo de stack trace> -d out/android/app.android-arm64.symbols
   ```

   Para obter mais informações sobre o comando `symbolize`,
   execute `flutter symbolize -h`.

## Ler um nome ofuscado

Para tornar o nome que um aplicativo ofuscou legível,
use as seguintes etapas:

1. Para salvar o mapa de ofuscação de nomes no momento da construção do aplicativo,
   use `--extra-gen-snapshot-options=--save-obfuscation-map=/<seu-caminho>`.
   Por exemplo:

   ```console
   $ flutter build apk --obfuscate --split-debug-info=/<nome-do-projeto>/<diretório> --extra-gen-snapshot-options=--save-obfuscation-map=/<seu-caminho>
   ```

1. Para recuperar o nome, use o mapa de ofuscação gerado.
   O mapa de ofuscação é um array JSON plano com pares de
   nomes originais e nomes ofuscados. Por exemplo,
   `["MaterialApp", "ex", "Scaffold", "ey"]`, onde `ex`
   é o nome ofuscado de `MaterialApp`.

## Resalva

Esteja ciente do seguinte ao codificar um aplicativo que
eventualmente será um binário ofuscado.

* Códigos que dependem da correspondência de nomes específicos de classes, funções ou bibliotecas falharão.
  Por exemplo, a seguinte chamada para `expect()` não
  funcionará em um binário ofuscado:

<?code-excerpt "lib/main.dart (Expect)"?>
```dart
expect(foo.runtimeType.toString(), equals('Foo'));
```

* Nomes de enum não são ofuscados atualmente.
