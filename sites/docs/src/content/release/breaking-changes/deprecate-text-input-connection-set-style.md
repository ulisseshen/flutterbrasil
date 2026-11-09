---
ia-translate: true
title: Descontinua `TextInputConnection.setStyle`
description: >-
  O método `TextInputConnection.setStyle` foi descontinuado
  em favor do método `TextInputConnection.updateStyle`.
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

`TextInputConnection.setStyle` foi descontinuado em favor de
`TextInputConnection.updateStyle`, que oferece suporte à sincronização de
`letterSpacing`, `wordSpacing` e `lineHeight` com o engine.

## Contexto {:#context}

O método `setStyle` anterior não oferecia suporte a `letterSpacing`, `wordSpacing`
ou `lineHeight`. Isso causava um desalinhamento visual do destaque de seleção
e do cursor do IME quando essas propriedades eram usadas.

O método substituto `updateStyle` usa
`TextInputStyle` para oferecer suporte a essas propriedades,
garantindo que a entrada do sistema fique sincronizada com o texto renderizado.

## Guia de migração {:#migration-guide}

Se você cria um cliente de entrada de texto personalizado,
substitua as chamadas a `TextInputConnection.setStyle`
por `TextInputConnection.updateStyle`.

### Código antes da migração {:#code-before-migration}

```dart
connection.setStyle(
  fontFamily: 'Roboto',
  fontSize: 14.0,
  fontWeight: FontWeight.normal,
  textDirection: TextDirection.ltr,
  textAlign: TextAlign.start,
);
```

### Código após a migração {:#code-after-migration}

```dart
connection.updateStyle(
  TextInputStyle(
    fontFamily: 'Roboto',
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.start,
    letterSpacing: 1.2,
    wordSpacing: 1.0,
    lineHeight: 1.5,
  ),
);
```

## Linha do tempo {:#timeline}

Incluído na versão: 3.43.0-0.1.pre<br>
Na versão estável: 3.44

## Referências {:#references}

PR relevante:

* [Fix IME and selection by syncing more text styles][pr-180436]

Issues relevantes:

* [Incorrect position of Japanese predictive conversion popup in TextFormField using maxLines on the Web][issue-161592]

[pr-180436]: {{site.repo.flutter}}/pull/180436
[issue-161592]: {{site.repo.flutter}}/issues/161592
