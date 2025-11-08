---
title: CupertinoThemeData.brightness nullable
description: >
  CupertinoThemeData.brightness agora é nullable, e retorna
  o valor especificado pelo usuário (padrão null) como está.
ia-translate: true
---

## Resumo

[`CupertinoThemeData.brightness`] agora é nullable.

## Contexto

[`CupertinoThemeData.brightness`][] agora é usado para
sobrescrever `MediaQuery.platformBrightness` para widgets Cupertino.
Antes desta mudança, o getter [`CupertinoThemeData.brightness`][]
retornava `Brightness.light` quando era definido como null.

## Descrição da mudança

Anteriormente [`CupertinoThemeData.brightness`][]
era implementado como um getter:

```dart
Brightness get brightness => _brightness ?? Brightness.light;
final Brightness _brightness;
```

Agora é uma propriedade armazenada:

```dart
final Brightness brightness;
```

## Guia de migração

Geralmente [`CupertinoThemeData.brightness`][]
é raramente útil fora do framework Flutter.
Para recuperar o brilho para widgets Cupertino,
agora use [`CupertinoTheme.brightnessOf`][] em vez disso.

Com esta mudança, agora é possível sobrescrever
`CupertinoThemeData.brightness` em uma subclasse de `CupertinoThemeData`
para mudar a substituição de brilho. Por exemplo:

```dart
class AlwaysDarkCupertinoThemeData extends CupertinoThemeData {
  Brightness brightness => Brightness.dark;
}
```

Quando um `CupertinoTheme` usa o `CupertinoThemeData` acima,
o modo escuro é habilitado para todos os seus descendentes Cupertino
que são afetados por este `CupertinoTheme`.

## Linha do tempo

Implementado na versão: 1.16.3<br>
Na versão estável: 1.17

## Referências

Documento de design:

* [Make `CupertinoThemeData.brightness nullable`][]

Documentação da API:

* [`CupertinoThemeData.brightness`][]

Issue relevante:

* [Issue 47255][]

PR relevante:

* [Let material `ThemeData` dictate brightness if `cupertinoOverrideTheme.brightness` is null][]


[`CupertinoTheme.brightnessOf`]: {{site.api}}/flutter/cupertino/CupertinoTheme/brightnessOf.html
[`CupertinoThemeData.brightness`]: {{site.api}}/flutter/cupertino/NoDefaultCupertinoThemeData/brightness.html
[Issue 47255]: {{site.repo.flutter}}/issues/47255
[Let material `ThemeData` dictate brightness if `cupertinoOverrideTheme.brightness` is null]: {{site.repo.flutter}}/pull/47249
[Make `CupertinoThemeData.brightness nullable`]: /go/nullable-cupertinothemedata-brightness
