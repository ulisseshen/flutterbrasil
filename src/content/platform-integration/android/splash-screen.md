---
ia-translate: true
title: Adicionando uma splash screen ao seu app Android
short-title: Splash screen
description: Aprenda como adicionar uma splash screen ao seu app Android.
---

<img src='/assets/images/docs/development/ui/splash-screen/android-splash-screen/splash-screens_header.png'
class="mw-100" alt="A graphic outlining the launch flow of an app including a splash screen">

Splash screens (também conhecidas como launch screens) fornecem
uma experiência inicial simples enquanto seu app Android carrega.
Elas preparam o cenário para sua aplicação,
enquanto permitem tempo para o engine do app
carregar e seu app inicializar.

## Visão geral

:::warning
Se você está experimentando uma falha ao implementar uma splash screen, você
pode precisar migrar seu código. Veja instruções detalhadas no
[Deprecated Splash Screen API Migration guide][].
:::

No Android, existem duas telas separadas que você pode controlar:
uma _launch screen_ mostrada enquanto seu app Android inicializa,
e uma _splash screen_ que é exibida enquanto a experiência Flutter
inicializa.

:::note
A partir do Flutter 2.5, as launch e splash screens foram
consolidadas—o Flutter agora implementa apenas a launch screen do Android,
que é exibida até o framework desenhar o primeiro frame.
Esta launch screen pode atuar tanto como uma launch screen do Android quanto como uma
splash screen do Android via personalização, e portanto, é referida
como ambos os termos. Para exemplo de tal personalização, confira o
[Android splash screen sample app][].

Se, antes do 2.5, você usou `flutter create` para criar um app,
e você executa o app no 2.5 ou posterior, o app pode travar.
Para mais informações, veja o [Deprecated Splash Screen API Migration guide][].
:::

:::note
Para apps que incorporam uma ou mais telas Flutter dentro de um
app Android existente, considere
[pré-aquecer um `FlutterEngine`][pre-warming a `FlutterEngine`] e reutilizar o
mesmo engine em todo o seu app para minimizar o tempo de espera
associado à inicialização do engine Flutter.
:::

## Inicializando o app

Todo app Android requer tempo de inicialização enquanto o
sistema operacional configura o processo do app.
O Android fornece o conceito de [launch screen][] para
exibir um `Drawable` enquanto o app está inicializando.

Um `Drawable` é um gráfico Android.
Para aprender como adicionar um `Drawable` ao seu
projeto Flutter no Android Studio,
confira [Import drawables into your project][drawables]
na documentação de desenvolvedores Android.

O template de projeto Flutter padrão inclui uma definição
de um tema de lançamento e um fundo de lançamento. Você pode personalizar
isso editando `styles.xml`, onde você pode definir um tema
cujo `windowBackground` está definido como o
`Drawable` que deve ser exibido como a launch screen.

```xml
<style name="LaunchTheme" parent="@android:style/Theme.Black.NoTitleBar">
    <item name="android:windowBackground">@drawable/launch_background</item>
</style>
```

Além disso, `styles.xml` define um _tema normal_
a ser aplicado à `FlutterActivity` após a launch
screen desaparecer. O fundo do tema normal só aparece
por um breve momento após a splash screen desaparecer,
e durante mudança de orientação e restauração de `Activity`.
Portanto, é recomendado que o tema normal use uma
cor de fundo sólida que se pareça com a cor de
fundo primária da UI Flutter.

```xml
<style name="NormalTheme" parent="@android:style/Theme.Black.NoTitleBar">
    <item name="android:windowBackground">@drawable/normal_background</item>
</style>
```

[drawables]: {{site.android-dev}}/studio/write/resource-manager#import

## Configure a FlutterActivity no AndroidManifest.xml

No `AndroidManifest.xml`, defina o `theme` da
`FlutterActivity` para o tema de lançamento. Em seguida,
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

## Android 12

Para configurar sua launch screen no Android 12,
confira [Android Splash Screens][].

A partir do Android 12, você deve usar a nova API de splash screen
no seu arquivo `styles.xml`.
Considere criar um arquivo de recurso alternativo para Android 12 e superior.
Além disso, certifique-se de que sua imagem de fundo está de acordo com
as diretrizes de ícone;
confira [Android Splash Screens][] para mais detalhes.

```xml
<style name="LaunchTheme" parent="@android:style/Theme.Black.NoTitleBar">
    <item name="android:windowSplashScreenBackground">@color/bgColor</item>
    <item name="android:windowSplashScreenAnimatedIcon">@drawable/launch_background</item>
</style>
```

Certifique-se de que
`io.flutter.embedding.android.SplashScreenDrawable` **não** está
definido no seu manifest, e que `provideSplashScreen`
**não** está implementado, pois essas APIs estão obsoletas.
Fazer isso faz com que a launch screen do Android desapareça suavemente
no Flutter quando o
app é iniciado e o app pode travar.

Alguns apps podem querer continuar mostrando o último frame da
launch screen do Android no Flutter. Por exemplo,
isso preserva a ilusão de um único frame
enquanto carregamento adicional continua no Dart.
Para alcançar isso, as seguintes
APIs Android podem ser úteis:

{% tabs "android-language" %}
{% tab "Kotlin" %}

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

{% endtab %}
{% tab "Java" %}

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

{% endtab %}
{% endtabs %}

Então, você pode reimplementar o primeiro frame no Flutter
que mostra elementos da sua launch screen do Android nas
mesmas posições na tela.
Para um exemplo disso, confira o
[Android splash screen sample app][].

[Android Splash Screens]: {{site.android-dev}}/about/versions/12/features/splash-screen
[launch screen]: {{site.android-dev}}/topic/performance/vitals/launch-time#themed
[pre-warming a `FlutterEngine`]: /add-to-app/android/add-flutter-fragment#using-a-pre-warmed-flutterengine
[Android splash screen sample app]: {{site.repo.samples}}/tree/main/android_splash_screen
[Deprecated Splash Screen API Migration guide]: /release/breaking-changes/splash-screen-migration
[Customizing web app initialization guide]: /platform-integration/web/initialization
