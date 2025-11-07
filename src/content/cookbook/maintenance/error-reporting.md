---
title: Reportar erros a um serviço
description: Como acompanhar os erros que os usuários encontram.
ia-translate: true
---

<?code-excerpt path-base="cookbook/maintenance/error_reporting/"?>

Embora sempre tentemos criar apps livres de bugs,
eles certamente aparecem de tempos em tempos.
Como apps com bugs levam a usuários e clientes insatisfeitos,
é importante entender com que frequência seus usuários
experimentam bugs e onde esses bugs ocorrem.
Dessa forma, você pode priorizar os bugs com o
maior impacto e trabalhar para corrigi-los.

Como você pode determinar com que frequência seus usuários experimentam bugs?
Sempre que um erro ocorrer, crie um relatório contendo o
erro que ocorreu e o stacktrace associado.
Você pode então enviar o relatório para um serviço de rastreamento
de erros, como [Bugsnag][], [Datadog][],
[Firebase Crashlytics][], [Rollbar][] ou Sentry.

O serviço de rastreamento de erros agrega todas as falhas que seus usuários
experimentam e as agrupa. Isso permite que você saiba com que frequência seu
app falha e onde os usuários encontram problemas.

Nesta receita, aprenda como reportar erros ao
serviço de relatórios de crash [Sentry][] usando
os seguintes passos:

  1. Obter um DSN do Sentry.
  2. Importar o package Flutter Sentry
  3. Inicializar o Sentry SDK
  4. Capturar erros programaticamente

## 1. Obter um DSN do Sentry

Antes de reportar erros ao Sentry, você precisa de um "DSN" para identificar
exclusivamente seu app com o serviço Sentry.io.

Para obter um DSN, use os seguintes passos:

  1. [Criar uma conta com Sentry][].
  2. Fazer login na conta.
  3. Criar um novo projeto Flutter.
  4. Copiar o trecho de código que inclui o DSN.

## 2. Importar o package Sentry

Importe o package [`sentry_flutter`][] no app.
O package sentry torna mais fácil enviar
relatórios de erros para o serviço de rastreamento de erros Sentry.

Para adicionar o package `sentry_flutter` como uma dependência,
execute `flutter pub add`:

```console
$ flutter pub add sentry_flutter
```

## 3. Inicializar o Sentry SDK

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

Isso é tudo que você precisa para que o Sentry
capture erros não tratados nas camadas Dart e nativas.
Isso inclui Swift, Objective-C, C e C++ no iOS, e
Java, Kotlin, C e C++ no Android.

## 4. Capturar erros programaticamente

Além do relatório de erros automático que o Sentry gera ao
importar e inicializar o SDK,
você pode usar a API para reportar erros ao Sentry:

<?code-excerpt "lib/main.dart (CaptureException)"?>
```dart
await Sentry.captureException(exception, stackTrace: stackTrace);
```

Para mais informações, veja a documentação da [Sentry API][] no pub.dev.

## Saiba mais

Documentação extensa sobre o uso do Sentry SDK pode ser encontrada no [site do Sentry][].

## Exemplo completo

Para visualizar um exemplo funcional,
veja o [app de exemplo do Sentry flutter][].


[app de exemplo do Sentry flutter]: {{site.github}}/getsentry/sentry-dart/tree/main/flutter/example
[Criar uma conta com Sentry]: https://sentry.io/signup/
[Bugsnag]: https://www.bugsnag.com/platforms/flutter
[Datadog]: https://docs.datadoghq.com/real_user_monitoring/flutter/
[Rollbar]: https://rollbar.com/
[Sentry]: https://sentry.io/welcome/
[`sentry_flutter`]: {{site.pub-pkg}}/sentry_flutter
[Sentry API]: {{site.pub-api}}/sentry_flutter/latest/sentry_flutter/sentry_flutter-library.html
[site do Sentry]: https://docs.sentry.io/platforms/flutter/
[Firebase Crashlytics]: {{site.firebase}}/docs/crashlytics
