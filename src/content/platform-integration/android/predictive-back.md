---
ia-translate: true
title: Adicionar o gesto predictive-back
short-title: Predictive-back
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

Você precisa habilitar o Developer Mode e definir uma flag no seu dispositivo,
então você ainda não pode esperar que o predictive back funcione na maioria dos
dispositivos Android dos usuários. Se você quiser experimentá-lo no seu próprio dispositivo,
certifique-se de que está executando API 33 ou superior, e então em
**Settings => System => Developer** options,
certifique-se de que o interruptor está habilitado ao lado de **Predictive back animations**.

## Configure seu app

As transições de rota predictive back atualmente
não estão habilitadas por padrão, então por enquanto você precisará habilitá-las
manualmente no seu app.
Normalmente, você faz isso configurando-as no seu tema:

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

Por último, apenas certifique-se de que você está usando pelo menos
a versão 3.22.2 do Flutter para executar seu app,
que é a versão estável mais recente no momento desta escrita.

## Para mais informações

Você pode encontrar mais informações no seguinte link:

* [Android predictive back][] breaking change

[Android predictive back]: /release/breaking-changes/android-predictive-back

