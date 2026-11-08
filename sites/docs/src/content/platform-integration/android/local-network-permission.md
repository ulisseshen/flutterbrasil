---
ia-translate: true
title: Solicite permissões de rede local no Android
shortTitle: Permissão de rede local
description: >-
  Aprenda a declarar e solicitar permissões de rede local no Android
  antes de abrir sockets Dart no Flutter.
---

A partir do Android 17 (API nível 37), o Android bloqueia o acesso à rede local
por padrão. Apps que têm como alvo o Android 17 ou superior e que descobrem, escaneiam
ou se conectam a dispositivos na rede local devem declarar e solicitar
a permissão de tempo de execução `ACCESS_LOCAL_NETWORK`.

:::note
Embora seja aplicada a apps que têm como alvo o Android 17 (API nível 37) ou superior,
você pode optar por testar esse comportamento no Android 16 (API nível 36).
:::

## Entenda o impacto nos sockets do Dart {:#understand-the-impact-on-dart-sockets}

A biblioteca padrão `dart:io` oferece redes por socket de baixo nível,
incluindo [`Socket`][socket-class], [`RawSocket`][raw-socket-class]
e [`ServerSocket`][server-socket-class].
Essas classes de socket operam em nível de sistema
e não interagem com o framework de aplicação do Android nem com a UI.

Como os sockets Dart não podem exibir um prompt de permissão do Android,
qualquer tentativa de conexão a um endereço IP local sem a permissão necessária
falha e lança uma `SocketException`.
Para evitar falhas de conexão,
solicite a permissão de tempo de execução no Flutter
antes de inicializar ou conectar seu socket Dart.

## Declare a permissão no Android {:#declare-the-permission-in-android}

Antes de solicitar a permissão em tempo de execução,
declare-a no manifesto do Android.

1. Abra `android/app/src/main/AndroidManifest.xml`.
1. Adicione a permissão `ACCESS_LOCAL_NETWORK` dentro da tag `<manifest>`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.ACCESS_LOCAL_NETWORK" />
    <application
        ...
    </application>
</manifest>
```

## Adicione o pacote permission_handler {:#add-the-permission_handler-package}

Para solicitar permissões de tempo de execução do Android a partir do Dart,
use o plugin [`permission_handler`][`permission_handler`] do [pub.dev][pub.dev].

Adicione o `permission_handler` às dependências do seu projeto Flutter:

```bash
flutter pub add permission_handler
```

## Solicite a permissão antes de conectar um socket {:#request-permission-before-connecting-a-socket}

Chame `Permission.accessLocalNetwork.request()`
antes de abrir uma conexão de socket Dart.

O exemplo a seguir demonstra como verificar a plataforma,
solicitar a permissão de rede local
e abrir uma conexão de socket:

```dart
import 'dart:io';
import 'package:material_ui/material_ui.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> connectToLocalDevice({
  required String host,
  required int port,
}) async {
  // Check and request runtime permission on Android.
  if (Platform.isAndroid) {
    final status = await Permission.accessLocalNetwork.request();

    if (status.isPermanentlyDenied) {
      // The user opted not to grant permission and checked "Don't ask again".
      // In a real app, show an explanation dialog before calling openAppSettings().
      debugPrint('Permission permanently denied. Please enable it in settings.');
      return;
    }

    if (!status.isGranted) {
      // Handle the case where the user denied permission.
      debugPrint('Local network permission was denied.');
      return;
    }
  }

  // Connect the Dart socket after the permission is granted.
  try {
    final socket = await Socket.connect(
      host,
      port,
      timeout: const Duration(seconds: 5),
    );

    debugPrint(
      'Connected to ${socket.remoteAddress.address}:${socket.remotePort}',
    );

    // Use the socket...

    await socket.close();
  } on SocketException catch (e) {
    debugPrint('Failed to connect: $e');
  }
}
```

## Trate o status da permissão {:#handle-permission-status}

O método `Permission.accessLocalNetwork.request()`
retorna um enum `PermissionStatus` que indica o resultado:

* `PermissionStatus.granted`: o usuário concedeu acesso à rede local.
  Você pode prosseguir para conectar seus sockets Dart.
* `PermissionStatus.denied`: o usuário negou a permissão para esta solicitação.
  Explique ao usuário antes de solicitar a permissão novamente.
* `PermissionStatus.permanentlyDenied`: o usuário negou a permissão permanentemente.
  Chame `openAppSettings()` para ajudar o usuário a ativar a permissão
  nas configurações do sistema.

:::tip
Você só precisa obter a permissão uma vez durante a sessão do app,
mas verificar o status antes de estabelecer uma conexão de socket
garante chamadas de rede confiáveis.
:::

## Mais informações {:#more-information}

Para saber mais sobre permissões de rede local e programação de sockets,
consulte os seguintes recursos:

* Guia do desenvolvedor Android sobre [Permissão de rede local][android-local-network]
* Pacote [`permission_handler`][`permission_handler`] no pub.dev
* [Documentação da classe `Socket`][socket-class] do Dart
* [Issue #184859 no GitHub][flutter-issue-184859]

[android-local-network]: https://developer.android.com/privacy-and-security/local-network-permission#android-17-enforcement
[`permission_handler`]: {{site.pub-pkg}}/permission_handler
[pub.dev]: {{site.pub}}
[socket-class]: {{site.dart.api}}/dart-io/Socket-class.html
[raw-socket-class]: {{site.dart.api}}/dart-io/RawSocket-class.html
[server-socket-class]: {{site.dart.api}}/dart-io/ServerSocket-class.html
[flutter-issue-184859]: {{site.repo.flutter}}/issues/184859
