---
title: BorderRadius padrão de Dialogs
description: O BorderRadius padrão de widgets Dialog está mudando.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

Instâncias de `Dialog`, bem como
`SimpleDialog`, `AlertDialog`, e `showTimePicker`,
agora têm uma forma padrão de `RoundedRectangleBorder`
com um `BorderRadius` de 4.0 pixels.
Isso corresponde às especificações atuais de Material Design.
Antes desta mudança, o comportamento padrão para
o `BorderRadius` de `Dialog.shape` era 2.0 pixels.

## Context

`Dialog`s e suas subclasses associadas
(`SimpleDialog`, `AlertDialog`, e `showTimePicker`), aparecem
ligeiramente diferentes já que o border radius é maior.
Se você tem imagens de golden file master que têm a
renderização anterior do `Dialog` com um border radius de 2.0 pixels,
seus testes de widget vão falhar.
Essas imagens de golden file podem ser atualizadas para refletir a nova renderização,
ou você pode atualizar seu código para manter o comportamento original.

O dialog `showDatePicker` já correspondia
a esta especificação e não é afetado por esta mudança.

## Migration guide

Se você prefere manter a forma antiga, você pode usar
a propriedade shape do seu `Dialog` para especificar o raio original de 2 pixels.

Definindo a forma do Dialog para o raio original:

```dart
import 'package:flutter/material.dart';

void main() => runApp(Foo());

class Foo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('Alert!'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2))),
              );
            },
          );
        }),
      ),
    );
  }
}
```

Se você prefere o novo comportamento e tem testes de golden file falhando,
você pode atualizar seus arquivos golden master usando este comando:

```console
flutter test --update-goldens
```

## Timeline

Landed in version: 1.20.0-0.0.pre<br>
In stable release: 1.20

## References

API documentation:

* [`Dialog`][]
* [`SimpleDialog`][]
* [`AlertDialog`][]
* [`showTimePicker`][]
* [`showDatePicker`][]

Relevant PR:

* [PR 58829: Matching Material Spec for Dialog shape][]

[`Dialog`]: {{site.api}}/flutter/material/Dialog-class.html
[`SimpleDialog`]: {{site.api}}/flutter/material/SimpleDialog-class.html
[`AlertDialog`]: {{site.api}}/flutter/material/AlertDialog-class.html
[`showTimePicker`]: {{site.api}}/flutter/material/showTimePicker.html
[`showDatePicker`]: {{site.api}}/flutter/material/showDatePicker.html
[PR 58829: Matching Material Spec for Dialog shape]: {{site.repo.flutter}}/pull/58829
