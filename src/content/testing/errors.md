---
title: Tratamento de erros no Flutter
description: Como controlar mensagens de erro e registro de erros
ia-translate: true
---

<?code-excerpt path-base="testing/errors"?>

O framework Flutter captura erros que ocorrem durante callbacks
desencadeados pelo próprio framework, incluindo erros encontrados
durante as fases de build, layout e pintura. Erros que não ocorrem
dentro dos callbacks do Flutter não podem ser capturados pelo framework,
mas você pode tratá-los configurando um manipulador de erros no
[`PlatformDispatcher`][].

Todos os erros capturados pelo Flutter são roteados para o
manipulador [`FlutterError.onError`][]. Por padrão,
isso chama [`FlutterError.presentError`][],
que despeja o erro nos logs do dispositivo.
Ao executar a partir de uma IDE, o inspetor substitui este
comportamento para que os erros também possam ser roteados para o
console da IDE, permitindo que você inspecione os
objetos mencionados na mensagem.

:::note
Considere chamar [`FlutterError.presentError`][]
a partir do seu manipulador de erros personalizado para ver
os logs também no console.
:::

Quando um erro ocorre durante a fase de build,
o callback [`ErrorWidget.builder`][] é
invocado para construir o widget que é usado
em vez daquele que falhou. Por padrão,
em modo debug isso mostra uma mensagem de erro em vermelho,
e em modo release isso mostra um fundo cinza.

Quando erros ocorrem sem um callback do Flutter na pilha de chamadas,
eles são tratados pelo callback de erro do `PlatformDispatcher`. Por padrão,
isso apenas imprime os erros e não faz mais nada.

Você pode personalizar esses comportamentos,
tipicamente definindo-os para valores em
sua função `void main()`.

Abaixo, cada tipo de tratamento de erro é explicado. No final
há um trecho de código que trata todos os tipos de erros. Mesmo
que você possa simplesmente copiar e colar o trecho, recomendamos que você
primeiro se familiarize com cada um dos tipos de erro.

## Erros capturados pelo Flutter

Por exemplo, para fazer com que sua aplicação seja encerrada imediatamente sempre que um
erro for capturado pelo Flutter em modo release, você pode usar o
seguinte manipulador:

<?code-excerpt "lib/quit_immediate.dart (on-error-main)"?>
```dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };
  runApp(const MyApp());
}

// O resto do código `flutter create`...
```

:::note
A constante de nível superior [`kReleaseMode`][] indica
se o aplicativo foi compilado em modo release.
:::

Este manipulador também pode ser usado para reportar erros para um serviço de logging.
Para mais detalhes, veja nosso capítulo de cookbook para
[reportar erros para um serviço][].

## Defina um widget de erro personalizado para erros de fase de build

Para definir um widget de erro personalizado que é exibido sempre que
o builder falha ao construir um widget, use [`MaterialApp.builder`][].

<?code-excerpt "lib/excerpts.dart (custom-error)"?>
```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) {
        Widget error = const Text('...erro de renderização...');
        if (widget is Scaffold || widget is Navigator) {
          error = Scaffold(body: Center(child: error));
        }
        ErrorWidget.builder = (errorDetails) => error;
        if (widget != null) return widget;
        throw StateError('widget is null');
      },
    );
  }
}
```

## Erros não capturados pelo Flutter

Considere um callback `onPressed` que invoca uma função assíncrona,
como `MethodChannel.invokeMethod` (ou praticamente qualquer plugin).
Por exemplo:

<?code-excerpt "lib/excerpts.dart (on-pressed)" replace="/return //g;/^\);$/)/g"?>
```dart
OutlinedButton(
  child: const Text('Clique me!'),
  onPressed: () async {
    const channel = MethodChannel('crashy-custom-channel');
    await channel.invokeMethod('blah');
  },
)
```

Se `invokeMethod` lançar um erro, ele não será encaminhado para `FlutterError.onError`.
Em vez disso, ele é encaminhado para o `PlatformDispatcher`.

Para capturar tal erro, use [`PlatformDispatcher.instance.onError`][].

<?code-excerpt "lib/excerpts.dart (catch-error)"?>
```dart
import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  MyBackend myBackend = MyBackend();
  PlatformDispatcher.instance.onError = (error, stack) {
    myBackend.sendError(error, stack);
    return true;
  };
  runApp(const MyApp());
}
```

## Tratamento de todos os tipos de erros

Digamos que você queira encerrar a aplicação em qualquer exceção e exibir
um widget de erro personalizado sempre que a construção de um widget falhar - você pode basear
o tratamento de erros no próximo trecho de código:

<?code-excerpt "lib/main.dart (all-errors)"?>
```dart
import 'package:flutter/material.dart';
import 'dart:ui';

Future<void> main() async {
  await myErrorsHandler.initialize();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    myErrorsHandler.onErrorDetails(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    myErrorsHandler.onError(error, stack);
    return true;
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) {
        Widget error = const Text('...erro de renderização...');
        if (widget is Scaffold || widget is Navigator) {
          error = Scaffold(body: Center(child: error));
        }
        ErrorWidget.builder = (errorDetails) => error;
        if (widget != null) return widget;
        throw StateError('widget is null');
      },
    );
  }
}
```

[`ErrorWidget.builder`]: {{site.api}}/flutter/widgets/ErrorWidget/builder.html
[`FlutterError.onError`]: {{site.api}}/flutter/foundation/FlutterError/onError.html
[`FlutterError.presentError`]: {{site.api}}/flutter/foundation/FlutterError/presentError.html
[`kReleaseMode`]:  {{site.api}}/flutter/foundation/kReleaseMode-constant.html
[`MaterialApp.builder`]: {{site.api}}/flutter/material/MaterialApp/builder.html
[reportar erros para um serviço]: /cookbook/maintenance/error-reporting
[`PlatformDispatcher.instance.onError`]: {{site.api}}/flutter/dart-ui/PlatformDispatcher/onError.html
[`PlatformDispatcher`]: {{site.api}}/flutter/dart-ui/PlatformDispatcher-class.html
