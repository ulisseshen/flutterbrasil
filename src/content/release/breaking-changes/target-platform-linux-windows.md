---
ia-translate: true
title: Adicionando 'linux' e 'windows' ao enum TargetPlatform
description: >
  Dois novos valores foram adicionados ao enum TargetPlatform que podem
  exigir casos adicionais em declarações switch que alternam em um TargetPlatform.
---

## Resumo

Dois novos valores foram adicionados ao enum [`TargetPlatform`][]
que podem exigir casos adicionais em declarações switch que
alternam em um `TargetPlatform` e não incluem um caso `default:`.

## Contexto

Antes dessa alteração, o enum `TargetPlatform` continha apenas quatro valores
e era definido da seguinte forma:

```dart
enum TargetPlatform {
  android,
  fuchsia,
  iOS,
  macOS,
}
```

Uma declaração `switch` só precisava lidar com esses casos,
e aplicativos desktop que desejavam ser executados no Linux ou
Windows geralmente tinham um teste como este em seu
método `main()`:

```dart
// Define uma substituição de plataforma para desktop para evitar exceções. Veja
// https://docs.flutter.dev/desktop#target-platform-override para mais informações.
void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  _enablePlatformOverrideForDesktop();
  runApp(MyApp());
}
```

## Descrição da mudança

O enum `TargetPlatform` agora é definido como:

```dart
enum TargetPlatform {
  android,
  fuchsia,
  iOS,
  linux, // novo valor
  macOS,
  windows, // novo valor
}
```

E a configuração de teste de plataforma
[`debugDefaultTargetPlatformOverride`][] em `main()`
não é mais necessária no Linux e Windows.

Isso pode fazer com que o analisador Dart forneça o aviso
[`missing_enum_constant_in_switch`][] para declarações switch
que não incluem um caso `default`. Escrever um switch sem um
caso `default:` é a maneira recomendada de lidar com enums,
já que o analisador pode então ajudá-lo a encontrar quaisquer casos
que não sejam tratados.

## Guia de migração

Para migrar para o novo enum e evitar o erro do analisador
`missing_enum_constant_in_switch`, que se parece com:

```plaintext
warning: Missing case clause for 'linux'. (missing_enum_constant_in_switch at [package] path/to/file.dart:111)
```

ou:

```plaintext
warning: Missing case clause for 'windows'. (missing_enum_constant_in_switch at [package] path/to/file.dart:111)
```

Modifique seu código da seguinte forma:

Código antes da migração:

```dart
void dance(TargetPlatform platform) {
  switch (platform) {
    case TargetPlatform.android:
      // Faz a dança do Android.
      break;
    case TargetPlatform.fuchsia:
      // Faz a dança do Fuchsia.
      break;
    case TargetPlatform.iOS:
      // Faz a dança do iOS.
      break;
    case TargetPlatform.macOS:
      // Faz a dança do macOS.
      break;
  }
}
```

Código após a migração:

```dart
void dance(TargetPlatform platform) {
  switch (platform) {
    case TargetPlatform.android:
      // Faz a dança do Android.
      break;
    case TargetPlatform.fuchsia:
      // Faz a dança do Fuchsia.
      break;
    case TargetPlatform.iOS:
      // Faz a dança do iOS.
      break;
    case TargetPlatform.linux: // novo caso
      // Faz a dança do Linux.
      break;
    case TargetPlatform.macOS:
      // Faz a dança do macOS.
      break;
    case TargetPlatform.windows: // novo caso
      // Faz a dança do Windows.
      break;
  }
}
```

Ter casos `default:` nessas declarações switch não é
recomendado, porque então o analisador não pode ajudá-lo a
encontrar todos os casos que precisam ser tratados.

Além disso, quaisquer testes como o mencionado acima que definem o
`debugDefaultTargetPlatformOverride` não são mais necessários
para aplicativos Linux e Windows.

## Cronograma

Incluído na versão: 1.15.4<br>
Na versão estável: 1.17

## Referências

Documentação da API:

* [`TargetPlatform`][]

Problemas relevantes:

* [Issue #31366][]

PR relevante:

* [Add Windows, and Linux as TargetPlatforms][]

[Add Windows, and Linux as TargetPlatforms]: {{site.repo.flutter}}/pull/51519
[`debugDefaultTargetPlatformOverride`]: {{site.api}}/flutter/foundation/debugDefaultTargetPlatformOverride.html
[Issue #31366]: {{site.repo.flutter}}/issues/31366
[`missing_enum_constant_in_switch`]: {{site.dart-site}}/tools/diagnostic-messages#missing_enum_constant_in_switch
[`TargetPlatform`]: {{site.api}}/flutter/foundation/TargetPlatform-class.html
