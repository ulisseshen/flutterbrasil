---
title: CupertinoThemeData.brightness anulável
description: >
  CupertinoThemeData.brightness agora é anulável, e
  retorna o valor especificado pelo usuário (padrão null) como está.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

[`CupertinoThemeData.brightness`] agora é anulável.

## Contexto

[`CupertinoThemeData.brightness`][] agora é usado para
substituir `MediaQuery.platformBrightness` para widgets Cupertino.
Antes desta alteração, o getter [`CupertinoThemeData.brightness`][]
retornava `Brightness.light` quando era definido como null.

## Descrição da alteração

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
Para recuperar o brilho dos widgets Cupertino,
agora use [`CupertinoTheme.brightnessOf`][] no lugar.

Com esta alteração, agora é possível substituir
`CupertinoThemeData.brightness` em uma subclasse `CupertinoThemeData`
para alterar a substituição de brilho. Por exemplo:

```dart
class AlwaysDarkCupertinoThemeData extends CupertinoThemeData {
  Brightness brightness => Brightness.dark;
}
```

Quando um `CupertinoTheme` usa o `CupertinoThemeData` acima,
o modo escuro é habilitado para todos os seus descendentes Cupertino
que são afetados por este `CupertinoTheme`.

## Linha do tempo

Disponibilizado na versão: 1.16.3<br>
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
