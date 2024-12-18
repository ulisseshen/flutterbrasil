---
ia-translate: true
title: Adicionando uma tela de splash ao seu aplicativo Android
short-title: Tela de splash
description: Aprenda a adicionar uma tela de splash ao seu aplicativo Android.
---

<img src='/assets/images/docs/development/ui/splash-screen/android-splash-screen/splash-screens_header.png'
class="mw-100" alt="Um gráfico que descreve o fluxo de inicialização de um aplicativo, incluindo uma tela de splash">

As telas de splash (também conhecidas como telas de inicialização) fornecem
uma experiência inicial simples enquanto seu aplicativo Android carrega.
Elas preparam o cenário para seu aplicativo,
ao mesmo tempo que permitem que o mecanismo do aplicativo
carregue e seu aplicativo seja inicializado.

## Visão geral

:::warning
Se você está enfrentando uma falha ao implementar uma tela de splash,
pode ser necessário migrar seu código. Consulte as instruções detalhadas no
[Guia de migração da API de tela de splash descontinuada][].
:::

No Android, existem duas telas separadas que você pode controlar:
uma _tela de inicialização_ exibida enquanto seu aplicativo Android é inicializado,
e uma _tela de splash_ que é exibida enquanto a experiência Flutter
é inicializada.

:::note
A partir do Flutter 2.5, as telas de inicialização e splash foram
consolidadas — o Flutter agora implementa apenas a tela de inicialização do Android,
que é exibida até que o framework desenhe o primeiro quadro.
Esta tela de inicialização pode atuar tanto como uma tela de inicialização do Android quanto como uma
tela de splash do Android por meio de personalização e, portanto, é referida
pelos dois termos. Para um exemplo de tal personalização, confira o
[Aplicativo de exemplo de tela de splash do Android][].

Se, antes da versão 2.5, você usou `flutter create` para criar um aplicativo,
e você executar o aplicativo na versão 2.5 ou posterior, o aplicativo pode travar.
Para mais informações, consulte o [Guia de migração da API de tela de splash descontinuada][].
:::

:::note
Para aplicativos que incorporam uma ou mais telas Flutter em um
aplicativo Android existente, considere
[pré-aquecer um `FlutterEngine`][] e reutilizar o
mesmo mecanismo em todo o seu aplicativo para minimizar o tempo de espera
associado à inicialização do mecanismo Flutter.
:::

## Inicializando o aplicativo

Todo aplicativo Android requer tempo de inicialização enquanto o
sistema operacional configura o processo do aplicativo.
O Android fornece o conceito de uma [tela de inicialização][] para
exibir um `Drawable` enquanto o aplicativo está inicializando.

Um `Drawable` é um gráfico do Android.
Para saber como adicionar um `Drawable` ao seu
projeto Flutter no Android Studio,
confira [Importar drawables para seu projeto][drawables]
na documentação do desenvolvedor Android.

O modelo de projeto Flutter padrão inclui uma definição
de um tema de inicialização e um plano de fundo de inicialização. Você pode personalizar
isso editando `styles.xml`, onde você pode definir um tema
cujo `windowBackground` é definido como o
`Drawable` que deve ser exibido como a tela de inicialização.

```xml
<style name="LaunchTheme" parent="@android:style/Theme.Black.NoTitleBar">
    <item name="android:windowBackground">@drawable/launch_background</item>
</style>
```

Além disso, `styles.xml` define um _tema normal_
a ser aplicado a `FlutterActivity` após a
tela de inicialização ter desaparecido. O plano de fundo do tema normal só é exibido
por um breve momento após a tela de splash desaparecer,
e durante a mudança de orientação e restauração de `Activity`.
Portanto, é recomendável que o tema normal use uma
cor de fundo sólida que se pareça com a
cor de fundo principal da UI do Flutter.

```xml
<style name="NormalTheme" parent="@android:style/Theme.Black.NoTitleBar">
    <item name="android:windowBackground">@drawable/normal_background</item>
</style>
```

[drawables]: {{site.android-dev}}/studio/write/resource-manager#import

## Configure o FlutterActivity em AndroidManifest.xml

Em `AndroidManifest.xml`, defina o `theme` de
`FlutterActivity` para o tema de inicialização. Em seguida,
adicione um elemento de metadados ao `FlutterActivity` desejado
para instruir o Flutter a mudar do tema de inicialização
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

O aplicativo Android agora exibe a tela de inicialização desejada
enquanto o aplicativo é inicializado.

## Android 12

Para configurar sua tela de inicialização no Android 12,
confira [Telas de splash do Android][].

A partir do Android 12, você deve usar a nova API de tela de splash
em seu arquivo `styles.xml`.
Considere criar um arquivo de recursos alternativo para Android 12 e superior.
Certifique-se também de que sua imagem de fundo esteja alinhada com
as diretrizes de ícone;
confira [Telas de splash do Android][] para mais detalhes.

```xml
<style name="LaunchTheme" parent="@android:style/Theme.Black.NoTitleBar">
    <item name="android:windowSplashScreenBackground">@color/bgColor</item>
    <item name="android:windowSplashScreenAnimatedIcon">@drawable/launch_background</item>
</style>
```

Certifique-se de que
`io.flutter.embedding.android.SplashScreenDrawable` **não** esteja
definido em seu manifesto, e que `provideSplashScreen`
**não** esteja implementado, pois essas APIs estão obsoletas.
Fazer isso faz com que a tela de inicialização do Android desapareça suavemente
no Flutter quando o
aplicativo é iniciado e o aplicativo pode travar.

Alguns aplicativos podem querer continuar mostrando o último quadro da
tela de inicialização do Android no Flutter. Por exemplo,
isso preserva a ilusão de um único quadro
enquanto o carregamento adicional continua em Dart.
Para conseguir isso, as seguintes
APIs do Android podem ser úteis:

{% tabs "android-language" %}
{% tab "Kotlin" %}

```kotlin title="MainActivity.kt"
import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    // Alinha a visualização do Flutter verticalmente com a janela.
    WindowCompat.setDecorFitsSystemWindows(getWindow(), false)

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
      // Desativa a animação de fade out da tela de splash do Android para evitar
      // uma cintilação antes que o quadro semelhante seja desenhado no Flutter.
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
        // Alinha a visualização do Flutter verticalmente com a janela.
        WindowCompat.setDecorFitsSystemWindows(getWindow(), false);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Desativa a animação de fade out da tela de splash do Android para evitar
            // uma cintilação antes que o quadro semelhante seja desenhado no Flutter.
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

Em seguida, você pode reimplementar o primeiro quadro no Flutter
que mostra elementos de sua tela de inicialização do Android nas
mesmas posições na tela.
Para um exemplo disso, confira o
[Aplicativo de exemplo de tela de splash do Android][].

[Android Splash Screens]: {{site.android-dev}}/about/versions/12/features/splash-screen
[launch screen]: {{site.android-dev}}/topic/performance/vitals/launch-time#themed
[pré-aquecer um `FlutterEngine`]: /add-to-app/android/add-flutter-fragment#using-a-pre-warmed-flutterengine
[Aplicativo de exemplo de tela de splash do Android]: {{site.repo.samples}}/tree/main/android_splash_screen
[Guia de migração da API de tela de splash descontinuada]: /release/breaking-changes/splash-screen-migration
[Guia de personalização da inicialização do aplicativo da web]: /platform-integration/web/initialization
