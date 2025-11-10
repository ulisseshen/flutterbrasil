---
ia-translate: true
title: Widget Radio redesenhado
description: >-
  Aprenda sobre as mudanças no widget radio no Flutter 3.35.
---

{% render "docs/breaking-changes.md" %}

## Resumo

Introduzido o widget `RadioGroup` para centralizar o gerenciamento de `groupValue` e o callback `onChanged`
para um conjunto de widgets `Radio`. Como resultado, as propriedades individuais `Radio.groupValue` e
`Radio.onChanged` foram descontinuadas.

## Contexto

Para atender aos requisitos do APG (ARIA Practices Guide) para navegação por teclado e
propriedades semânticas em grupos de botões de rádio, o Flutter precisava de um conceito dedicado de grupo de rádio.
Introduzir um widget wrapper, `RadioGroup`, fornece esse suporte pronto para uso.
Esta mudança também apresentou uma oportunidade para simplificar a API para widgets `Radio` individuais.

## Descrição da mudança

As seguintes APIs foram descontinuadas:

* `Radio.onChanged`
* `Radio.groupValue`
* `CupertinoRadio.onChanged`
* `CupertinoRadio.groupValue`
* `RadioListTile.groupValue`
* `RadioListTile.onChanged`.

## Guia de migração

Se você está usando essas propriedades, pode refatorá-las com `RadioGroup`.

### Caso 1: caso trivial

Código antes da migração:

```dart
Widget build(BuildContext context) {
  return Column(
    children: <Widget>[
      Radio<int>(
        value: 0,
        groupValue: _groupValue,
        onChanged: (int? value) {
          setState(() {
            _groupValue = value;
          });
        },
      ),
      Radio<int>(
        value: 2,
        groupValue: _groupValue,
        onChanged: (int? value) {
          setState(() {
            _groupValue = value;
          });
        },
      ),
    ],
  );
}
```

Código após a migração:

```dart
Widget build(BuildContext context) {
  return RadioGroup<int>(
    groupValue: _groupValue,
    onChanged: (int? value) {
      setState(() {
        _groupValue = value;
      });
    },
    child: Column(
      children: <Widget>[
        Radio<int>(value: 0),
        Radio<int>(value: 2),
      ],
    ),
  );
}
```

### Caso 2: radio desabilitado

Código antes da migração:

```dart
Widget build(BuildContext context) {
  return Column(
    children: <Widget>[
      Radio<int>(
        value: 0,
        groupValue: _groupValue,
        onChanged: (int? value) {
          setState(() {
            _groupValue = value;
          });
        },
      ),
      Radio<int>(
        value: 2,
        groupValue: _groupValue,
        onChanged: null, // disabled
      ),
    ],
  );
}
```

Código após a migração:

```dart
Widget build(BuildContext context) {
  return RadioGroup<int>(
    groupValue: _groupValue,
    onChanged: (int? value) {
      setState(() {
        _groupValue = value;
      });
    },
    child: Column(
      children: <Widget>[
        Radio<int>(value: 0),
        Radio<int>(value: 2, enabled: false),
      ],
    ),
  );
}
```

### Caso 3: grupo misto ou multi-seleção

Código antes da migração:

```dart
Widget build(BuildContext context) {
  return Column(
    children: <Widget>[
      Radio<int>(
        value: 1,
        groupValue: _groupValue,
        onChanged: (int? value) {
          setState(() {
            _groupValue = value;
          });
        }, // disabled
      ),
      Radio<String>(
        value: 'a',
        groupValue: _stringValue,
        onChanged: (String? value) {
          setState(() {
            _stringValue = value;
          });
        },
      ),
      Radio<String>(
        value: 'b',
        groupValue: _stringValue,
        onChanged: (String? value) {
          setState(() {
            _stringValue = value;
          });
        },
      ),
      Radio<int>(
        value: 2,
        groupValue: _groupValue,
        onChanged: (int? value) {
          setState(() {
            _groupValue = value;
          });
        }, // disabled
      ),
    ],
  );
}
```

Código após a migração:

```dart
Widget build(BuildContext context) {
  return RadioGroup<int>(
    groupValue: _groupValue,
    onChanged: (int? value) {
      setState(() {
        _groupValue = value;
      });
    },
    child: Column(
      children: <Widget>[
        Radio<int>(value: 1),
        RadioGroup<String>(
          child: Column(
            children: <Widget>[
              Radio<String>(value: 'a'),
              Radio<String>(value: 'b'),
            ]
          ),
        ),
        Radio<int>(value: 2),
      ],
    ),
  );
}
```

## Cronograma

Disponibilizado na versão: 3.34.0-0.0.pre<br>
Na versão estável: 3.35

## Referências

* [`APG`][APG]

Documentação da API:

* [`Radio`][Radio]
* [`CupertinoRadio`][CupertinoRadio]
* [`RadioListTile`][RadioListTile]
* [`RadioGroup`][RadioGroup]

Issue relevante:

* [Issue 113562][Issue 113562]

PR relevante:

* [PR 168161][PR 168161]

[APG]: https://www.w3.org/WAI/ARIA/apg/patterns/radio
[Radio]: {{site.api}}/flutter/material/Radio-class.html
[RadioListTile]: {{site.api}}/flutter/material/RadioListTile-class.html
[CupertinoRadio]: {{site.api}}/flutter/cupertino/CupertinoRadio-class.html
[RadioGroup]: {{site.api}}/flutter/widgets/RadioGroup-class.html
[Issue 113562]: {{site.repo.flutter}}/issues/113562
[PR 168161]: {{site.repo.flutter}}/pull/168161
