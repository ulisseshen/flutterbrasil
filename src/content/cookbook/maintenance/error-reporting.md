---
ia-translate: true
title: Reportar erros para um serviço
description: Como manter o controle dos erros que os usuários encontram.
---

<?code-excerpt path-base="cookbook/maintenance/error_reporting/"?>

Embora sempre tentemos criar aplicativos livres de bugs,
eles certamente surgirão de tempos em tempos.
Como aplicativos com bugs levam a usuários e clientes insatisfeitos,
é importante entender com que frequência seus usuários
encontram bugs e onde esses bugs ocorrem.
Dessa forma, você pode priorizar os bugs com o
maior impacto e trabalhar para corrigi-los.

Como você pode determinar com que frequência seus usuários encontram bugs?
Sempre que ocorrer um erro, crie um relatório contendo o
erro ocorrido e o stacktrace associado.
Você pode então enviar o relatório para um serviço de rastreamento de erros,
como [Bugsnag][], [Datadog][],
[Firebase Crashlytics][], [Rollbar][], ou Sentry.

O serviço de rastreamento de erros agrega todos os crashes que seus usuários
encontram e os agrupa. Isso permite que você saiba com que frequência seu
aplicativo falha e onde os usuários encontram problemas.

Nesta receita, aprenda como reportar erros para o
serviço de relatório de crashes [Sentry][] usando
os seguintes passos:

  1. Obtenha um DSN do Sentry.
  2. Importe o pacote Flutter Sentry
  3. Inicialize o SDK Sentry
  4. Capture erros programaticamente

## 1. Obtenha um DSN do Sentry

Antes de reportar erros para o Sentry, você precisa de um "DSN" para identificar
exclusivamente seu aplicativo com o serviço Sentry.io.

Para obter um DSN, use os seguintes passos:

  1. [Crie uma conta no Sentry][].
  2. Faça login na conta.
  3. Crie um novo projeto Flutter.
  4. Copie o trecho de código que inclui o DSN.

## 2. Importe o pacote Sentry

Importe o pacote [`sentry_flutter`][] para o aplicativo.
O pacote Sentry facilita o envio de
relatórios de erro para o serviço de rastreamento de erros Sentry.

Para adicionar o pacote `sentry_flutter` como uma dependência,
execute `flutter pub add`:

```console
$ flutter pub add sentry_flutter
```

## 3. Inicialize o SDK Sentry

Inicialize o SDK para capturar diferentes erros não tratados automaticamente:

<?code-excerpt "lib/main.dart (InitializeSDK)"?>
```dart
import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) => options.dsn = 'https://example@sentry.io/example',
    appRunner: () => runApp(const MyApp()),
  );
}
```

Alternativamente, você pode passar o DSN para o Flutter usando a tag `dart-define`:

```sh
--dart-define SENTRY_DSN=https://example@sentry.io/example
```

### O que isso me dá?

Isso é tudo que você precisa para o Sentry
capturar erros não tratados nas camadas Dart e nativas.
Isso inclui Swift, Objective-C, C e C++ no iOS, e
Java, Kotlin, C e C++ no Android.

## 4. Capture erros programaticamente

Além do relatório de erros automático que o Sentry gera ao
importar e inicializar o SDK,
você pode usar a API para reportar erros para o Sentry:

<?code-excerpt "lib/main.dart (CaptureException)"?>
```dart
await Sentry.captureException(exception, stackTrace: stackTrace);
```

Para mais informações, veja os documentos da [API Sentry][] no pub.dev.

## Aprenda mais

Documentação extensa sobre o uso do SDK Sentry pode ser encontrada no [site do Sentry][].

## Exemplo completo

Para ver um exemplo funcionando,
veja o aplicativo [exemplo do Sentry flutter][].


[exemplo do Sentry flutter]: {{site.github}}/getsentry/sentry-dart/tree/main/flutter/example
[Crie uma conta no Sentry]: https://sentry.io/signup/
[Bugsnag]: https://www.bugsnag.com/platforms/flutter
[Datadog]: https://docs.datadoghq.com/real_user_monitoring/flutter/
[Rollbar]: https://rollbar.com/
[Sentry]: https://sentry.io/welcome/
[`sentry_flutter`]: {{site.pub-pkg}}/sentry_flutter
[API Sentry]: {{site.pub-api}}/sentry_flutter/latest/sentry_flutter/sentry_flutter-library.html
[site do Sentry]: https://docs.sentry.io/platforms/flutter/
[Firebase Crashlytics]: {{site.firebase}}/docs/crashlytics
