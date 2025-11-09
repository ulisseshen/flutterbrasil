---
ia-translate: true
title: Reportar erros a um serviço
description: Como acompanhar erros que usuários encontram.
---

<?code-excerpt path-base="cookbook/maintenance/error_reporting/"?>

Embora sempre se tente criar apps que sejam livres de bugs,
eles certamente aparecerão de tempos em tempos.
Como apps com bugs levam a usuários e clientes insatisfeitos,
é importante entender com que frequência seus usuários
experimentam bugs e onde esses bugs ocorrem.
Dessa forma, você pode priorizar os bugs com o
maior impacto e trabalhar para corrigi-los.

Como você pode determinar com que frequência seus usuários experimentam bugs?
Sempre que um erro ocorrer, crie um relatório contendo o
erro que ocorreu e o stacktrace associado.
Você pode então enviar o relatório para um serviço de rastreamento
de erros, como [Bugsnag][Bugsnag], [Datadog][Datadog],
[Firebase Crashlytics][Firebase Crashlytics], [Rollbar][Rollbar], ou Sentry.

O serviço de rastreamento de erros agrega todos os crashes que seus usuários
experimentam e os agrupa. Isso permite que você saiba com que frequência seu
app falha e onde os usuários encontram problemas.

Nesta receita, aprenda como reportar erros ao serviço de relatório
de crashes [Sentry][Sentry] usando
os seguintes passos:

  1. Obtenha um DSN do Sentry.
  2. Importe o pacote Flutter Sentry
  3. Inicialize o SDK do Sentry
  4. Capture erros programaticamente

## 1. Obtenha um DSN do Sentry

Antes de reportar erros ao Sentry, você precisa de um "DSN" para identificar exclusivamente
seu app com o serviço Sentry.io.

Para obter um DSN, use os seguintes passos:

  1. [Crie uma conta no Sentry][Create an account with Sentry].
  2. Faça login na conta.
  3. Crie um novo projeto Flutter.
  4. Copie o trecho de código que inclui o DSN.

## 2. Importe o pacote Sentry

Importe o pacote [`sentry_flutter`][`sentry_flutter`] para o app.
O pacote sentry torna mais fácil enviar
relatórios de erro para o serviço de rastreamento de erros Sentry.

Para adicionar o pacote `sentry_flutter` como uma dependência,
execute `flutter pub add`:

```console
$ flutter pub add sentry_flutter
```

## 3. Inicialize o SDK do Sentry

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

Além do relatório automático de erros que o Sentry gera ao
importar e inicializar o SDK,
você pode usar a API para reportar erros ao Sentry:

<?code-excerpt "lib/main.dart (CaptureException)"?>
```dart
await Sentry.captureException(exception, stackTrace: stackTrace);
```

Para mais informações, consulte a documentação da [API do Sentry][Sentry API] em pub.dev.

## Saiba mais

Documentação extensiva sobre o uso do SDK do Sentry pode ser encontrada no [site do Sentry][Sentry's site].

## Exemplo completo

Para ver um exemplo funcionando,
consulte o [app de exemplo do Sentry flutter][Sentry flutter example].


[Sentry flutter example]: {{site.github}}/getsentry/sentry-dart/tree/main/flutter/example
[Create an account with Sentry]: https://sentry.io/signup/
[Bugsnag]: https://www.bugsnag.com/platforms/flutter
[Datadog]: https://docs.datadoghq.com/real_user_monitoring/flutter/
[Rollbar]: https://rollbar.com/
[Sentry]: https://sentry.io/welcome/
[`sentry_flutter`]: {{site.pub-pkg}}/sentry_flutter
[Sentry API]: {{site.pub-api}}/sentry_flutter/latest/sentry_flutter/sentry_flutter-library.html
[Sentry's site]: https://docs.sentry.io/platforms/flutter/
[Firebase Crashlytics]: {{site.firebase}}/docs/crashlytics
