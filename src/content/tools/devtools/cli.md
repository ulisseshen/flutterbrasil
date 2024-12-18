---
ia-translate: true
title: Execute DevTools a partir da linha de comando
description: Aprenda como iniciar e usar o DevTools a partir da linha de comando.
---

Para executar o DevTools a partir do CLI,
você deve ter o `dart` no seu path.
Então, para iniciar o DevTools, execute o comando `dart devtools`.

Para atualizar o DevTools, atualize o Flutter.
Se um SDK Dart mais recente
(que está incluído no SDK do Flutter)
incluir uma versão mais recente do DevTools,
executar `dart devtools` inicia automaticamente esta versão.
Se `which dart` apontar para um SDK Dart _não_
incluído no seu SDK do Flutter, atualizar esse
SDK Dart não atualizará a versão do Flutter.

Quando você executa o DevTools a partir da linha de comando,
você deve ver uma saída semelhante a esta:

```plaintext
Serving DevTools at http://127.0.0.1:9100
```

## Iniciar um aplicativo para depurar

Em seguida, inicie um aplicativo para se conectar.
Este pode ser um aplicativo Flutter
ou um aplicativo Dart de linha de comando.
O comando abaixo especifica um aplicativo Flutter:

```console
cd path/to/flutter/app
flutter run
```

Você precisa ter um dispositivo conectado ou um simulador aberto,
para que o `flutter run` funcione. Assim que o aplicativo iniciar, você verá uma
mensagem no seu terminal semelhante à seguinte:

```console
An Observatory debugger and profiler on macOS is available at:
http://127.0.0.1:52129/QjqebSY4lQ8=/
The Flutter DevTools debugger and profiler on macOS is available at:
http://127.0.0.1:9100?uri=http://127.0.0.1:52129/QjqebSY4lQ8=/
```

Abra a instância do DevTools conectada ao seu aplicativo
abrindo o segundo link no Chrome.

Este URL contém um token de segurança,
portanto, é diferente para cada execução do seu aplicativo.
Isso significa que, se você parar seu aplicativo e executá-lo novamente,
você precisa se conectar ao DevTools novamente com o novo URL.

## Conectar a uma nova instância de aplicativo

Se o seu aplicativo parar de ser executado
ou você abriu o DevTools manualmente,
você deverá ver uma caixa de diálogo **Connect**:

![Captura de tela da caixa de diálogo de conexão do DevTools](/assets/images/docs/tools/devtools/connect_dialog.png){:width="100%"}

Você pode conectar manualmente o DevTools a uma nova instância de aplicativo
copiando o link do Observatory que você obteve ao executar seu aplicativo,
como `http://127.0.0.1:52129/QjqebSY4lQ8=/`
e colando-o na caixa de diálogo de conexão:
