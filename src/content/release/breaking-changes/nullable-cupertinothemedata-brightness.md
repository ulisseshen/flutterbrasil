---
ia-translate: true
title: Nullable CupertinoThemeData.brightness
description: >
  CupertinoThemeData.brightness agora aceita nulo e retorna o valor
  especificado pelo usuário (o padrão é nulo) como está.
---

## Sumário

[`CupertinoThemeData.brightness`] agora aceita nulo.

## Contexto

[`CupertinoThemeData.brightness`][] agora é usado para
substituir `MediaQuery.platformBrightness` para widgets Cupertino.
Antes desta mudança, o getter [`CupertinoThemeData.brightness`][]
retornava `Brightness.light` quando era definido como nulo.

## Descrição da mudança

Anteriormente, [`CupertinoThemeData.brightness`][]
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

Geralmente, [`CupertinoThemeData.brightness`][]
raramente é útil fora do framework Flutter.
Para recuperar o brilho para widgets Cupertino,
agora use [`CupertinoTheme.brightnessOf`][] em vez disso.

Com esta mudança, agora é possível substituir
`CupertinoThemeData.brightness` em uma subclasse `CupertinoThemeData`
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

Incluído na versão: 1.16.3<br>
Na versão estável: 1.17

## Referências

Documento de design:

* [Tornar `CupertinoThemeData.brightness nullable`][]

Documentação da API:

* [`CupertinoThemeData.brightness`][]

Issue relevante:

* [Issue 47255][]

PR relevante:

* [Permitir que `ThemeData` material dite o brilho se `cupertinoOverrideTheme.brightness` for nulo][]

[`CupertinoTheme.brightnessOf`]: {{site.api}}/flutter/cupertino/CupertinoTheme/brightnessOf.html
[`CupertinoThemeData.brightness`]: {{site.api}}/flutter/cupertino/NoDefaultCupertinoThemeData/brightness.html
[Issue 47255]: {{site.repo.flutter}}/issues/47255
[Permitir que `ThemeData` material dite o brilho se `cupertinoOverrideTheme.brightness` for nulo]: {{site.repo.flutter}}/pull/47249
[Tornar `CupertinoThemeData.brightness nullable`]: /go/nullable-cupertinothemedata-brightness
