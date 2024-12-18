---
ia-translate: true
title: BorderRadius Padrão dos Diálogos
description: O BorderRadius padrão dos widgets Dialog está mudando.
---

## Resumo

Instâncias de `Dialog`, assim como `SimpleDialog`, `AlertDialog` e `showTimePicker`, agora têm um formato padrão de `RoundedRectangleBorder` com um `BorderRadius` de 4.0 pixels. Isso corresponde às especificações atuais do Material Design. Antes dessa mudança, o comportamento padrão para o `BorderRadius` de `Dialog.shape` era de 2.0 pixels.

## Contexto

`Dialog`s e suas subclasses associadas (`SimpleDialog`, `AlertDialog` e `showTimePicker`) parecem ligeiramente diferentes, pois o raio da borda é maior. Se você tiver imagens de arquivos golden master que tenham a renderização anterior do `Dialog` com um raio de borda de 2.0 pixels, seus testes de widget falharão. Essas imagens de arquivos golden podem ser atualizadas para refletir a nova renderização, ou você pode atualizar seu código para manter o comportamento original.

O diálogo `showDatePicker` já correspondia a essa especificação e não é afetado por essa alteração.

## Guia de migração

Se você preferir manter o formato antigo, pode usar a propriedade shape do seu `Dialog` para especificar o raio original de 2 pixels.

Definindo o formato do Dialog para o raio original:

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

Se você preferir o novo comportamento e tiver testes de arquivos golden com falha, você pode atualizar seus arquivos golden master usando este comando:

```console
flutter test --update-goldens
```

## Linha do tempo

Incluído na versão: 1.20.0-0.0.pre<br>
Na versão estável: 1.20

## Referências

Documentação da API:

*   [`Dialog`][]
*   [`SimpleDialog`][]
*   [`AlertDialog`][]
*   [`showTimePicker`][]
*   [`showDatePicker`][]

PR relevante:

*   [PR 58829: Matching Material Spec for Dialog shape][]

[`Dialog`]: {{site.api}}/flutter/material/Dialog-class.html
[`SimpleDialog`]: {{site.api}}/flutter/material/SimpleDialog-class.html
[`AlertDialog`]: {{site.api}}/flutter/material/AlertDialog-class.html
[`showTimePicker`]: {{site.api}}/flutter/material/showTimePicker.html
[`showDatePicker`]: {{site.api}}/flutter/material/showDatePicker.html
[PR 58829: Matching Material Spec for Dialog shape]: {{site.repo.flutter}}/pull/58829
