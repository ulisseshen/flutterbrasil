---
ia-translate: true
title: Adicione o gesto de voltar preditivo
short-title: Voltar preditivo
description: >-
  Aprenda como adicionar o gesto de voltar preditivo ao seu aplicativo Android.
---

Este recurso chegou ao Flutter,
mas ainda não está habilitado por padrão no próprio Android.
Você pode experimentá-lo usando as seguintes instruções.

## Configure seu aplicativo

Certifique-se de que seu aplicativo seja compatível com a API do Android 33 ou superior,
pois o voltar preditivo não funcionará em versões mais antigas do Android.
Em seguida, defina a flag `android:enableOnBackInvokedCallback="true"`
em `android/app/src/main/AndroidManifest.xml`.

## Configure seu dispositivo

Você precisa ativar o Modo de Desenvolvedor e definir uma flag no seu dispositivo,
portanto, você ainda não pode esperar que o voltar preditivo funcione na maioria dos
dispositivos Android dos usuários. Se você quiser experimentar em seu próprio dispositivo,
certifique-se de que ele esteja executando a API 33 ou superior e, em
**Configurações => Sistema => Opções do desenvolvedor**,
certifique-se de que a chave esteja ativada ao lado de **Animações de voltar preditivo**.

## Configure seu aplicativo

As transições de rota de voltar preditivo atualmente
não estão habilitadas por padrão, então, por enquanto, você precisará habilitá-las
manualmente em seu aplicativo.
Normalmente, você faz isso configurando-as no seu tema:

```dart
MaterialApp(
  theme: ThemeData(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        // Define as transições de voltar preditivo para Android.
        TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
      },
    ),
  ),
  ...
),
```

## Execute seu aplicativo

Por fim, certifique-se de estar usando pelo menos
a versão 3.22.2 do Flutter para executar seu aplicativo,
que é a versão estável mais recente no momento da escrita deste texto.

## Para mais informações

Você pode encontrar mais informações no seguinte link:

* [Mudança de comportamento do voltar preditivo do Android][]

[Mudança de comportamento do voltar preditivo do Android]: /release/breaking-changes/android-predictive-back
