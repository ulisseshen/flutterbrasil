---
ia-translate: true
title: Adicionando uma splash screen ao seu app Android
shortTitle: Splash screen
description: Aprenda como adicionar uma splash screen ao seu app Android.
---

<img src='/assets/images/docs/development/ui/splash-screen/android-splash-screen/splash-screens_header.png' alt="A graphic outlining the launch flow of an app including a splash screen">

## Visão geral

Uma splash screen (também conhecida como launch screen) fornece
uma experiência inicial simples enquanto seu app Android carrega.
Ela prepara o cenário para sua aplicação,
enquanto permite tempo para o engine do app
carregar e seu app inicializar.

Você tem algumas opções para implementar uma splash screen:

1. Você pode usar um dos pacotes disponíveis no [pub.dev][pub.dev].

2. Você pode implementá-la manualmente, como mostrado no
   [app de exemplo de splash screen][splash screen sample app]. O restante desta página
   assume a abordagem manual.

[pub.dev]: {{site.pub}}/packages?q=splash+screen
[splash screen sample app]: {{site.github}}/flutter/samples/tree/main/android_splash_screen

## Inicializando o app

Todo app Android requer tempo de inicialização enquanto o
sistema operacional configura o processo do app.
O Android fornece o conceito de [launch screen][launch screen] para
exibir um `Drawable` enquanto o app está inicializando.

:::note
Para apps que incorporam uma ou mais telas Flutter dentro de um
app Android existente, considere
[pré-aquecer um `FlutterEngine`][pre-warming a `FlutterEngine`] e reutilizar o
mesmo engine em todo o seu app para minimizar o tempo de espera
associado à inicialização do engine Flutter.
:::

Um `Drawable` é um gráfico Android.
Para aprender como adicionar um `Drawable` ao seu
projeto Flutter no Android Studio,
confira [Import drawables into your project][drawables]
na documentação para desenvolvedores Android.

O template de projeto Flutter padrão inclui uma definição
de um tema de lançamento e um plano de fundo de lançamento. Você pode personalizar
isso editando `styles.xml`, onde você pode definir um tema
cujo `windowBackground` está definido para o
`Drawable` que deve ser exibido como launch screen.

```xml
<style name="LaunchTheme" parent="@android:style/Theme.Black.NoTitleBar">
    <item name="android:windowBackground">@drawable/launch_background</item>
</style>
```

Além disso, `styles.xml` define um _tema normal_
para ser aplicado à `FlutterActivity` após a launch
screen desaparecer. O plano de fundo do tema normal só aparece
por um momento muito breve após a splash screen desaparecer,
e durante mudança de orientação e restauração de `Activity`.
Portanto, é recomendado que o tema normal use uma
cor de plano de fundo sólida que se pareça com a cor de
plano de fundo primária da UI Flutter.

```xml
<style name="NormalTheme" parent="@android:style/Theme.Black.NoTitleBar">
    <item name="android:windowBackground">@drawable/normal_background</item>
</style>
```

[drawables]: {{site.android-dev}}/studio/write/resource-manager#import

## Configure a FlutterActivity em AndroidManifest.xml

Em `AndroidManifest.xml`, defina o `theme` de
`FlutterActivity` para o tema de lançamento. Então,
adicione um elemento metadata à `FlutterActivity` desejada
para instruir o Flutter a mudar do tema de lançamento
para o tema normal no momento apropriado.

```xml
<activity
    android:name=".MyActivity"
    android:theme="@style/LaunchTheme"
    // ...
    >
    <meta-data
        android:name="io.flutter.embedding.android.NormalTheme"
        android:resource="@style/NormalTheme"
        />
    <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
    </intent-filter>
</activity>
```

O app Android agora exibe a launch screen desejada
enquanto o app inicializa.

## API SplashScreen

O Android 12 introduziu a API [`SplashScreen`][SplashScreen].
Use a API `SplashScreen` em seu arquivo `styles.xml`.
Por exemplo:

```xml
<style name="LaunchTheme" parent="@android:style/Theme.Black.NoTitleBar">
    <item name="android:windowSplashScreenBackground">@color/bgColor</item>
    <item name="android:windowSplashScreenAnimatedIcon">@drawable/launch_background</item>
</style>
```

:::note
Se seu app Android suporta versões anteriores ao Android 12
_e_ versões posteriores ao Android 12, considere usar
dois recursos diferentes em seu arquivo `styles.xml`.
Além disso, certifique-se de que sua imagem de fundo esteja de acordo com
as diretrizes de ícone. Para mais informações,
visite [Android Splash Screens][Android Splash Screens].
:::

[Android Splash Screens]: https://developer.android.com/develop/ui/views/launch/splash-screen
[SplashScreen]: https://developer.android.com/reference/android/window/SplashScreen

Alguns apps podem querer continuar mostrando o último quadro da
launch screen do Android no Flutter. Por exemplo,
isso preserva a ilusão de um único quadro
enquanto carregamento adicional continua em Dart.
Para conseguir isso, as seguintes
APIs Android podem ser úteis:

<Tabs key="android-language">
<Tab name="Kotlin">

```kotlin title="MainActivity.kt"
import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    // Aligns the Flutter view vertically with the window.
    WindowCompat.setDecorFitsSystemWindows(getWindow(), false)

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
      // Disable the Android splash screen fade out animation to avoid
      // a flicker before the similar frame is drawn in Flutter.
      splashScreen.setOnExitAnimationListener { splashScreenView -> splashScreenView.remove() }
    }

    super.onCreate(savedInstanceState)
  }
}
```

</Tab>
<Tab name="Java">

```java title="MainActivity.java"
import android.os.Build;
import android.os.Bundle;
import android.window.SplashScreenView;
import androidx.core.view.WindowCompat;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // Aligns the Flutter view vertically with the window.
        WindowCompat.setDecorFitsSystemWindows(getWindow(), false);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Disable the Android splash screen fade out animation to avoid
            // a flicker before the similar frame is drawn in Flutter.
            getSplashScreen()
                .setOnExitAnimationListener(
                    (SplashScreenView splashScreenView) -> {
                        splashScreenView.remove();
                    });
        }

        super.onCreate(savedInstanceState);
    }
}
```

</Tab>
</Tabs>

Então, você pode reimplementar o primeiro quadro em Flutter
que mostra elementos de sua launch screen Android nas
mesmas posições na tela.
Para um exemplo disso, confira o
[app de exemplo de splash screen][splash screen sample app].

[launch screen]: {{site.android-dev}}/topic/performance/vitals/launch-time#themed
[pre-warming a `FlutterEngine`]: /add-to-app/android/add-flutter-fragment#using-a-pre-warmed-flutterengine
