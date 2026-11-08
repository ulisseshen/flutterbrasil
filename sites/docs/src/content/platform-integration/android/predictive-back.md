---
ia-translate: true
title: Adicione o gesto predictive back
shortTitle: Predictive back
description: >-
  Aprenda como habilitar e lidar com gestos predictive back do Android no Flutter.
---

O gesto predictive back do Android permite que os usuários pré-visualizem
para onde um gesto de voltar irá navegar,
seja a tela anterior ou a tela inicial,
antes de confirmá-lo ou cancelá-lo.

## Visão geral {:#overview}

A partir do Android 14 (API level 34),
as animações predictive back são habilitadas por padrão para gestos do sistema
quando suportadas pela aplicação.
O Flutter fornece suporte integrado para animações predictive back nas
transições de rota de página padrão e no tratamento personalizado de pop.

## Habilitar o predictive back no Android {:#enable-predictive-back-in-android}

Para suportar gestos predictive back no seu app Flutter
no Android 13 ou posterior:

1. Abra `android/app/src/main/AndroidManifest.xml`.
1. Adicione `android:enableOnBackInvokedCallback="true"` à tag `<application>`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="my_app"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:enableOnBackInvokedCallback="true">
        <!-- ... -->
    </application>
</manifest>
```

## Lidar com gestos de voltar com PopScope {:#handle-back-gestures-with-popscope}

Para personalizar a navegação de volta ou evitar que os usuários
saiam de uma tela acidentalmente,
use o widget [`PopScope`][].
`PopScope` substitui o widget obsoleto `WillPopScope`
e suporta gestos predictive back.

### Parâmetros do callback {:#callback-parameters}

`PopScope` usa o callback `onPopInvokedWithResult`:

* `didPop`: Um booleano que indica se a operação de pop foi bem-sucedida.
  Se `canPop` for `false`, `didPop` é `false`.
* `result`: Um payload de retorno opcional passado ao fazer pop da rota
  (por exemplo, com `Navigator.pop(context, result)`).

### Exemplo: interceptando a navegação de volta {:#example-intercepting-back-navigation}

```dart
PopScope(
  canPop: false,
  onPopInvokedWithResult: (bool didPop, Object? result) async {
    if (didPop) {
      return;
    }
    final shouldLeave = await _showExitConfirmationDialog(context);
    if (shouldLeave && context.mounted) {
      Navigator.of(context).pop(result);
    }
  },
  child: Scaffold(
    appBar: AppBar(title: const Text('Form Screen')),
    body: const Center(child: Text('Complete the form before leaving.')),
  ),
)
```

## Mais informações {:#more-information}

Para mais detalhes sobre migrações de API,
veja o [guia de migração do predictive back do Android][Android predictive back migration guide].

[`PopScope`]: {{site.api}}/flutter/widgets/PopScope-class.html
[Android predictive back migration guide]: /release/breaking-changes/android-predictive-back
