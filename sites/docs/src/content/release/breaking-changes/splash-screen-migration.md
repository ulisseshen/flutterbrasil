---
title: Migração de API de Splash Screen descontinuada
description: Como migrar de splash screen definida em Manifest/Activity.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

Antes do Flutter 2.5, aplicações Flutter podiam adicionar uma splash
screen definindo-a dentro dos metadados do arquivo manifest da aplicação
(`AndroidManifest.xml`), implementando [`provideSplashScreen`][] dentro
de sua [`FlutterActivity`][], ou ambos. Isso exibiria momentaneamente entre
o tempo depois que a tela de lançamento do Android é mostrada e quando o Flutter
desenhou o primeiro frame. Esta abordagem agora está descontinuada a partir do Flutter 2.5.
Flutter agora mantém automaticamente a tela de lançamento do Android exibida
até que desenhe o primeiro frame.

Para migrar da definição de uma splash screen customizada para apenas definir uma
tela de lançamento customizada para sua aplicação, siga os passos que correspondem
a como a splash screen customizada da sua aplicação foi definida
antes do lançamento 2.5.

**Splash screen customizada definida em [`FlutterActivity`][]**

1. Localize a implementação de `provideSplashScreen()` da sua aplicação
   dentro de sua `FlutterActivity` e **delete-a**. Esta implementação deve envolver
   a construção da splash screen customizada da sua aplicação
   como um `Drawable`. Por exemplo:

   ```java
   @Override
   public SplashScreen provideSplashScreen() {
       // ...
       return new DrawableSplashScreen(
           new SomeDrawable(
               ContextCompat.getDrawable(this, R.some_splash_screen)));
   }
   ```

2. Use os passos na seção diretamente seguinte para garantir que sua
   splash screen `Drawable` (`R.some_splash_screen` no exemplo anterior)
   está adequadamente configurada como a tela de lançamento customizada da sua aplicação.

**Splash screen customizada definida no Manifest**

1. Localize o arquivo `AndroidManifest.xml` da sua aplicação.
   Dentro deste arquivo, encontre o elemento `activity`.
   Dentro deste elemento, identifique o atributo `android:theme`
   e o elemento `meta-data` que define
   uma splash screen como uma
   `io.flutter.embedding.android.SplashScreenDrawable`,
   e atualize-o. Por exemplo:

   ```xml
   <activity
       // ...
       android:theme="@style/SomeTheme">
     // ...
     <meta-data
         android:name="io.flutter.embedding.android.SplashScreenDrawable"
         android:resource="@drawable/some_splash_screen"
         />
   </activity>
   ```

2. Se o atributo `android:theme` não está especificado, adicione o atributo e
   [defina um tema de lançamento][define a launch theme] para a tela de lançamento da sua aplicação.

3. Delete o elemento `meta-data`, já que o Flutter não
   usa mais isso, mas pode causar um crash.

4. Localize a definição do theme especificado pelo atributo `android:theme`
   dentro dos recursos `style` da sua aplicação. Este theme especifica o
   tema de lançamento da sua aplicação. Certifique-se de que o atributo `style` configura o
   atributo `android:windowBackground` com sua splash screen customizada. Por exemplo:

   ```xml
   <resources>
       <style
           name="SomeTheme"
           // ...
           >
           <!-- Show a splash screen on the activity. Automatically removed when
                Flutter draws its first frame -->
           <item name="android:windowBackground">@drawable/some_splash_screen</item>
       </style>
   </resources>
   ```

[`provideSplashScreen`]: {{site.api}}/javadoc/io/flutter/embedding/android/SplashScreenProvider.html#provideSplashScreen--
[`FlutterActivity`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterActivity.html
[define a launch theme]:  /platform-integration/android/splash-screen
