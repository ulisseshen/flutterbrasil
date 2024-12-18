---
ia-translate: true
title: Migração da API de Tela de Abertura Descontinuada
description: Como migrar da tela de abertura definida em Manifest/Activity.
---

Antes do Flutter 2.5, os aplicativos Flutter podiam adicionar uma tela de abertura
definindo-a nos metadados de seu arquivo de manifesto do aplicativo
(`AndroidManifest.xml`), implementando [`provideSplashScreen`][] em sua
[`FlutterActivity`][], ou ambos. Isso era exibido momentaneamente entre
o momento após a exibição da tela de inicialização do Android e quando o Flutter
desenhava o primeiro frame. Essa abordagem agora está descontinuada a partir do
Flutter 2.5. O Flutter agora mantém automaticamente a tela de inicialização do
Android exibida até desenhar o primeiro frame.

Para migrar da definição de uma tela de abertura customizada para apenas definir uma
tela de inicialização customizada para seu aplicativo, siga os passos que
correspondem a como a tela de abertura customizada de seu aplicativo foi definida
antes da versão 2.5.

**Tela de abertura customizada definida em [`FlutterActivity`][]**

1. Localize a implementação de `provideSplashScreen()` do seu aplicativo
   em sua `FlutterActivity` e **delete-a**. Essa implementação deve envolver
   a construção da tela de abertura customizada de seu aplicativo
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

2. Use os passos na seção diretamente seguinte para garantir que seu
   `Drawable` da tela de abertura (`R.some_splash_screen` no exemplo anterior)
   esteja configurado corretamente como a tela de inicialização customizada do seu
   aplicativo.

**Tela de abertura customizada definida no Manifesto**

1. Localize o arquivo `AndroidManifest.xml` do seu aplicativo.
   Dentro deste arquivo, encontre o elemento `activity`.
   Dentro deste elemento, identifique o atributo `android:theme`
   e o elemento `meta-data` que define
   uma tela de abertura como um
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
   [defina um tema de inicialização][] para a tela de inicialização do seu aplicativo.

3. Delete o elemento `meta-data`, pois o Flutter não usa mais
   isso, mas pode causar uma falha.

4. Localize a definição do tema especificado pelo atributo `android:theme`
   dentro dos recursos de `style` do seu aplicativo. Este tema especifica o
   tema de inicialização do seu aplicativo. Certifique-se de que o atributo `style`
   configure o atributo `android:windowBackground` com sua tela de abertura
   customizada. Por exemplo:

   ```xml
   <resources>
       <style
           name="SomeTheme"
           // ...
           >
           <!-- Mostra uma tela de abertura na activity. Removida automaticamente quando
                o Flutter desenha seu primeiro frame -->
           <item name="android:windowBackground">@drawable/some_splash_screen</item>
       </style>
   </resources>
   ```

[`provideSplashScreen`]: {{site.api}}/javadoc/io/flutter/embedding/android/SplashScreenProvider.html#provideSplashScreen--
[`FlutterActivity`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterActivity.html
[defina um tema de inicialização]:  /platform-integration/android/splash-screen
