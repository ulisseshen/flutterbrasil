---
ia-translate: true
title: Adicionando 'linux' e 'windows' ao enum TargetPlatform
description: >
  Dois novos valores foram adicionados ao enum TargetPlatform que podem
  requerer cases adicionais em instruções switch que fazem switch em um TargetPlatform.
---

{% render "docs/breaking-changes.md" %}

## Resumo

Dois novos valores foram adicionados ao enum [`TargetPlatform`][TargetPlatform]
que podem requerer cases adicionais em instruções switch que
fazem switch em um `TargetPlatform` e não incluem um case `default:`.

## Contexto

Antes desta mudança, o enum `TargetPlatform` continha apenas quatro valores,
e era definido assim:

```dart
enum TargetPlatform {
  android,
  fuchsia,
  iOS,
  macOS,
}
```

Uma instrução `switch` só precisava lidar com esses cases,
e aplicações desktop que queriam executar no Linux ou
Windows geralmente tinham um teste como este em seu
método `main()`:

```dart
// Sets a platform override for desktop to avoid exceptions. See
// https://docs.flutterbrasil.dev/desktop#target-platform-override for more info.
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
  linux, // new value
  macOS,
  windows, // new value
}
```

E o teste de plataforma configurando
[`debugDefaultTargetPlatformOverride`][debugDefaultTargetPlatformOverride] em `main()`
não é mais necessário no Linux e Windows.

Isso pode fazer com que o analisador Dart forneça o
aviso [`missing_enum_constant_in_switch`][missing_enum_constant_in_switch] para
instruções switch que não incluem um case `default`.
Escrever um switch sem um case `default:` é a
maneira recomendada de lidar com enums, já que o analisador
pode então ajudá-lo a encontrar quaisquer cases que não sejam tratados.

## Guia de migração

Para migrar para o novo enum, e evitar o erro
`missing_enum_constant_in_switch` do analisador, que se parece com:

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
      // Do Android dance.
      break;
    case TargetPlatform.fuchsia:
      // Do Fuchsia dance.
      break;
    case TargetPlatform.iOS:
      // Do iOS dance.
      break;
    case TargetPlatform.macOS:
      // Do macOS dance.
      break;
  }
}
```

Código após a migração:

```dart
void dance(TargetPlatform platform) {
  switch (platform) {
    case TargetPlatform.android:
      // Do Android dance.
      break;
    case TargetPlatform.fuchsia:
      // Do Fuchsia dance.
      break;
    case TargetPlatform.iOS:
      // Do iOS dance.
      break;
    case TargetPlatform.linux: // new case
      // Do Linux dance.
      break;
    case TargetPlatform.macOS:
      // Do macOS dance.
      break;
    case TargetPlatform.windows: // new case
      // Do Windows dance.
      break;
  }
}
```

Ter cases `default:` em tais instruções switch não é
recomendado, porque então o analisador não pode ajudá-lo a encontrar
todos os cases que precisam ser tratados.

Além disso, quaisquer testes como o referenciado acima que definem o
`debugDefaultTargetPlatformOverride` não são mais necessários
para aplicações Linux e Windows.

## Cronograma

Disponibilizado na versão: 1.15.4<br>
Na versão estável: 1.17

## Referências

Documentação da API:

* [`TargetPlatform`][TargetPlatform]

Issues relevantes:

* [Issue #31366][Issue #31366]

PR relevante:

* [Add Windows, and Linux as TargetPlatforms][Add Windows, and Linux as TargetPlatforms]

[Add Windows, and Linux as TargetPlatforms]: {{site.repo.flutter}}/pull/51519
[debugDefaultTargetPlatformOverride]: {{site.api}}/flutter/foundation/debugDefaultTargetPlatformOverride.html
[Issue #31366]: {{site.repo.flutter}}/issues/31366
[missing_enum_constant_in_switch]: {{site.dart-site}}/tools/diagnostic-messages#missing_enum_constant_in_switch
[TargetPlatform]: {{site.api}}/flutter/foundation/TargetPlatform-class.html
