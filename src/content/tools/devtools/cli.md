---
ia-translate: true
title: Executar DevTools da linha de comando
description: Aprenda como executar e usar DevTools da linha de comando.
---

Para executar DevTools pela CLI,
você deve ter `dart` no seu path.
Então, para iniciar DevTools, execute o comando `dart devtools`.

Para atualizar DevTools, atualize o Flutter.
Se um Dart SDK mais recente
(que está incluído no Flutter SDK)
incluir uma versão mais recente de DevTools,
executar `dart devtools` automaticamente inicia esta versão.
Se `which dart` apontar para um Dart SDK que _não_ está
incluído no seu Flutter SDK, atualizar aquele
Dart SDK não atualizará a versão do Flutter.

Quando você executa DevTools pela linha de comando,
você deve ver uma saída parecida com:

```plaintext
Serving DevTools at http://127.0.0.1:9100
```

## Iniciar uma aplicação para depurar

Em seguida, inicie um app para conectar.
Pode ser uma aplicação Flutter
ou uma aplicação Dart de linha de comando.
O comando abaixo especifica um app Flutter:

```console
cd path/to/flutter/app
flutter run
```

Você precisa ter um dispositivo conectado, ou um simulador aberto,
para que `flutter run` funcione. Quando o app iniciar, você verá uma
mensagem no seu terminal parecida com a seguinte:

```console
An Observatory debugger and profiler on macOS is available at:
http://127.0.0.1:52129/QjqebSY4lQ8=/
The Flutter DevTools debugger and profiler on macOS is available at:
http://127.0.0.1:9100?uri=http://127.0.0.1:52129/QjqebSY4lQ8=/
```

Abra a instância DevTools conectada ao seu app
abrindo o segundo link no Chrome.

Esta URL contém um token de segurança,
então é diferente para cada execução do seu app.
Isso significa que se você parar sua aplicação e executá-la novamente,
você precisa conectar ao DevTools novamente com a nova URL.

## Conectar a uma nova instância do app

Se seu app parar de executar
ou você abriu DevTools manualmente,
você deve ver um diálogo **Connect**:

![Screenshot of the DevTools connect dialog](/assets/images/docs/tools/devtools/connect_dialog.png){:width="100%"}

Você pode conectar manualmente DevTools a uma nova instância do app
copiando o link Observatory que você obteve ao executar seu app,
como `http://127.0.0.1:52129/QjqebSY4lQ8=/`
e colando-o no diálogo de conexão:
