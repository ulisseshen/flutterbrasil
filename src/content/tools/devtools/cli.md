---
ia-translate: true
title: Execute DevTools da linha de comando
description: Aprenda como iniciar e usar DevTools da linha de comando.
---

Para executar DevTools da CLI,
você deve ter `dart` no seu path.
Então, para iniciar DevTools, execute o comando `dart devtools`.

Para atualizar DevTools, atualize Flutter.
Se um Dart SDK mais recente
(que está incluído no Flutter SDK)
tiver uma versão mais recente de DevTools,
executar `dart devtools` automaticamente inicia esta versão.
Se `which dart` aponta para um Dart SDK que _não_ está
incluído no seu Flutter SDK, atualizar aquele
Dart SDK não atualizará a versão do Flutter.

Quando você executa DevTools da linha de comando,
você deverá ver uma saída que se parece com algo assim:

```plaintext
Serving DevTools at http://127.0.0.1:9100
```

## Inicie uma aplicação para depurar

Em seguida, inicie um app para conectar.
Este pode ser tanto uma aplicação Flutter
quanto uma aplicação de linha de comando Dart.
O comando abaixo especifica um app Flutter:

```console
cd path/to/flutter/app
flutter run
```

Você precisa ter um dispositivo conectado, ou um simulador aberto,
para que `flutter run` funcione. Uma vez que o app inicie,
você verá uma mensagem no seu terminal que se parece com
o seguinte:

```console
A Dart VM Service on macOS is available at:
http://127.0.0.1:51830/u37pq71Re0k=/
The Flutter DevTools debugger and profiler on macOS
is available at:
http://127.0.0.1:9100?uri=http://127.0.0.1:51830/u37pq71Re0k=/
```

Abra a instância DevTools conectada ao seu app
abrindo o segundo link no Chrome.

Esta URL contém um token de segurança,
então ela é diferente para cada execução do seu app.
Isso significa que se você parar sua aplicação e executá-la novamente,
você precisa conectar a DevTools novamente com a nova URL.

## Conecte a uma nova instância de app

Se seu app parar de executar
ou você abriu DevTools manualmente,
você deverá ver um diálogo **Connect**:

![Screenshot of the DevTools connect dialog](/assets/images/docs/tools/devtools/connect_dialog.png){:width="100%"}

Você pode conectar manualmente DevTools a uma nova instância de app
copiando o link que você obteve ao executar seu app,
como ` http://127.0.0.1:51830/u37pq71Re0k=/`
