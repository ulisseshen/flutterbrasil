---
title: Migração da API de Splash Screen depreciada
description: Como migrar de splash screen definida em Manifest/Activity.
ia-translate: true
---

Antes do Flutter 2.5, aplicativos Flutter podiam adicionar uma splash
screen definindo-a dentro dos metadados do arquivo de manifesto da aplicação
(`AndroidManifest.xml`), implementando [`provideSplashScreen`][] dentro
de sua [`FlutterActivity`][], ou ambos. Isso seria exibido momentaneamente entre
o tempo após a tela de lançamento do Android ser mostrada e quando o Flutter tivesse
desenhado o primeiro frame. Esta abordagem agora está depreciada a partir do Flutter 2.5.
O Flutter agora mantém automaticamente a tela de lançamento do Android exibida
até desenhar o primeiro frame.

Para migrar de definir uma splash screen customizada para apenas definir uma tela de
lançamento customizada para seu aplicativo, siga os passos que correspondem
a como a splash screen customizada do seu aplicativo foi definida
antes da versão 2.5.

**Splash screen customizada definida em [`FlutterActivity`][]**

1. Localize a implementação de `provideSplashScreen()` do seu aplicativo
   dentro de sua `FlutterActivity` e **delete-a**. Esta implementação deve envolver
   a construção da splash screen customizada do seu aplicativo
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
   está adequadamente configurada como a tela de lançamento customizada do seu aplicativo.

**Splash screen customizada definida em Manifest**

1. Localize o arquivo `AndroidManifest.xml` do seu aplicativo.
   Dentro deste arquivo, encontre o elemento `activity`.
   Dentro deste elemento, identifique o atributo `android:theme`
   e o elemento `meta-data` que define
   uma splash screen como
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

2. Se o atributo `android:theme` não estiver especificado, adicione o atributo e
   [defina um tema de lançamento][define a launch theme] para a tela de lançamento do seu aplicativo.

3. Delete o elemento `meta-data`, pois o Flutter não o usa mais,
   mas pode causar uma falha.

4. Localize a definição do tema especificado pelo atributo `android:theme`
   dentro dos recursos de `style` do seu aplicativo. Este tema especifica o
   tema de lançamento do seu aplicativo. Certifique-se de que o atributo `style` configura o
   atributo `android:windowBackground` com sua splash screen customizada. Por exemplo:

   ```xml
   <resources>
       <style
           name="SomeTheme"
           // ...
           >
           <!-- Mostra uma splash screen na activity. Removida automaticamente quando
                o Flutter desenha seu primeiro frame -->
           <item name="android:windowBackground">@drawable/some_splash_screen</item>
       </style>
   </resources>
   ```

[`provideSplashScreen`]: {{site.api}}/javadoc/io/flutter/embedding/android/SplashScreenProvider.html#provideSplashScreen--
[`FlutterActivity`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterActivity.html
[define a launch theme]:  /platform-integration/android/splash-screen
