---
ia-translate: true
title: Adicione o gesto predictive-back
shortTitle: Predictive-back
description: >-
  Aprenda como adicionar o gesto predictive back ao seu app Android.
---

Este recurso foi implementado no Flutter,
mas ainda não está habilitado por padrão no próprio Android.
Você pode experimentá-lo usando as seguintes instruções.

## Configure seu app

Certifique-se de que seu app suporta Android API 33 ou superior,
pois o predictive back não funcionará em versões mais antigas do Android.
Em seguida, defina a flag `android:enableOnBackInvokedCallback="true"`
em `android/app/src/main/AndroidManifest.xml`.

## Configure seu dispositivo

Você precisa habilitar o Modo de Desenvolvedor e definir uma flag em seu dispositivo,
então você ainda não pode esperar que o predictive back funcione na maioria dos dispositivos
Android dos usuários. Se você quiser experimentá-lo em seu próprio dispositivo,
certifique-se de que está rodando API 33 ou superior e, em seguida, em
**Settings => System => Developer** options,
certifique-se de que o switch está habilitado ao lado de **Predictive back animations**.

## Configure seu app

As transições de rota predictive back atualmente
não estão habilitadas por padrão, então por enquanto você precisará habilitá-las
manualmente em seu app.
Normalmente, você faz isso definindo-as em seu tema:

```dart
MaterialApp(
  theme: ThemeData(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        // Set the predictive back transitions for Android.
        TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
      },
    ),
  ),
  ...
),
```

## Execute seu app

Por último, apenas certifique-se de que está usando pelo menos
Flutter versão 3.22.2 para executar seu app,
que é a última versão estável no momento desta escrita.

## Para mais informações

Você pode encontrar mais informações no seguinte link:

* Breaking change [Android predictive back][Android predictive back]

[Android predictive back]: /release/breaking-changes/android-predictive-back
