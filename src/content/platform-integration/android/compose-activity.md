---
ia-translate: true
title: Lançando uma activity Jetpack Compose da sua aplicação Flutter
shortTitle: Activities Android nativas
description: >-
  Aprenda como lançar activities Android nativas em seu app Flutter.
---

<?code-excerpt path-base="platform_integration/compose_activities"?>

Activities Android nativas permitem que você lance
UIs em tela cheia que são inteiramente executadas pela e na plataforma Android.
Você só escreverá código Kotlin nessas views (embora elas possam
passar mensagens para e receber mensagens do seu código Dart) e
você terá acesso à amplitude completa da funcionalidade nativa do Android.

Adicionar esta funcionalidade requer fazer várias alterações ao
seu app Flutter e ao seu app Android interno gerado.
Do lado do Flutter, você precisará criar um novo
canal de método de plataforma e chamar seu método `invokeMethod`.
Do lado do Android, você precisará registrar um `MethodChannel` nativo correspondente
para receber o sinal do Dart e então lançar uma nova activity.
Lembre-se que todos os apps Flutter (quando rodando no Android) existem dentro
de uma activity Android que é completamente consumida pelo app Flutter.
Assim, como você verá na amostra de código, o trabalho do
callback do `MethodChannel` nativo é lançar uma segunda activity.

:::note
Esta página discute como lançar activities Android nativas
dentro de um app Flutter.
Se você gostaria de hospedar views Android nativas em seu app Flutter,
confira [Hospedando views Android nativas][Hosting native Android views].
:::

[Hosting native Android views]: /platform-integration/android/platform-views

Nem todas as activities Android usam Jetpack Compose, mas
este tutorial assume que você quer usar Compose.

## Do lado do Dart

Do lado do Dart, crie um canal de método e invoque-o de
uma interação específica do usuário, como tocar em um botão.

<?code-excerpt "lib/launch_compose_activity_example_1.dart"?>
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// SECTION 1: START COPYING HERE
const platformMethodChannel = MethodChannel(
  // Note: You can change this string value, but it must match
  // the `CHANNEL` attribute in the next step.
  'com.example.flutter_android_activity',
);
// SECTION 1: END COPYING HERE

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // SECTION 2: START COPYING HERE
  void _launchAndroidActivity() {
    platformMethodChannel.invokeMethod(
      // Note: You can change this value, but it must match
      // the `call.method` value in the next section.
      'launchActivity',

      // Note: You can pass any primitive data types you like.
      // To pass complex types, use package:pigeon to generate
      // matching Dart and Kotlin classes that share serialization logic.
      {'message': 'Hello from Flutter'},
    );
  }
  // SECTION 2: END COPYING HERE

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: const Center(child: Text('Hello World!')),
        floatingActionButton: FloatingActionButton(
          // SECTION 3: Call `_launchAndroidActivity` somewhere.
          onPressed: _launchAndroidActivity,

          // SECTION 3: End
          tooltip: 'Launch Android activity',
          child: const Icon(Icons.launch),
        ),
      ),
    );
  }
}
```

Existem 3 valores importantes que devem corresponder entre seu código Dart e Kotlin:

 1. O nome do canal (nesta amostra, o valor é
    `"com.example.flutter_android_activity"`).
 2. O nome do método (nesta amostra, o valor é `"launchActivity"`).
 3. A estrutura dos dados que o Dart passa e
    a estrutura dos dados que o Kotlin espera receber.
    Neste caso, os dados são um mapa com uma única chave `"message"`.


## Do lado do Android

Você deve fazer alterações em 4 arquivos no app Android gerado para
prepará-lo para lançar activities Compose novas.

O primeiro arquivo que requer modificações é `android/app/build.gradle`.

 1. Adicione o seguinte ao bloco `android` existente:

    ```groovy title="android/app/build.gradle"
    android {
      // Begin adding here
      buildFeatures {
        compose true
      }
      composeOptions {
        // https://developer.android.com/jetpack/androidx/releases/compose-kotlin
        kotlinCompilerExtensionVersion = "1.4.8"
      }
      // End adding here
    }
    ```

    Visite o link [developer.android.com][developer.android.com] no snippet de código e
    ajuste `kotlinCompilerExtensionVersion`, conforme necessário.
    Você só deve precisar fazer isso se
    receber erros durante `flutter run` e esses erros informarem
    quais versões estão instaladas em sua máquina.

    [developer.android.com]: {{site.android-dev}}/jetpack/androidx/releases/compose-kotlin

 2. Em seguida, adicione o seguinte bloco na parte inferior do arquivo, no nível raiz:

    ```groovy title="android/app/build.gradle"
    dependencies {
        implementation("androidx.core:core-ktx:1.10.1")
        implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.6.1")
        implementation("androidx.activity:activity-compose")
        implementation(platform("androidx.compose:compose-bom:2024.06.00"))
        implementation("androidx.compose.ui:ui")
        implementation("androidx.compose.ui:ui-graphics")
        implementation("androidx.compose.ui:ui-tooling-preview")
        implementation("androidx.compose.material:material")
        implementation("androidx.compose.material3:material3")
        testImplementation("junit:junit:4.13.2")
        androidTestImplementation("androidx.test.ext:junit:1.1.5")
        androidTestImplementation("androidx.test.espresso:espresso-core:3.5.1")
        androidTestImplementation(platform("androidx.compose:compose-bom:2023.08.00"))
        androidTestImplementation("androidx.compose.ui:ui-test-junit4")
        debugImplementation("androidx.compose.ui:ui-tooling")
        debugImplementation("androidx.compose.ui:ui-test-manifest")
    }
    ```

    O segundo arquivo que requer modificações é `android/build.gradle`.

 1. Adicione o seguinte bloco buildscript no topo do arquivo:

    ```groovy title="android/build.gradle"
    buildscript {
        dependencies {
            // Replace with the latest version.
            classpath 'com.android.tools.build:gradle:8.1.1'
        }
        repositories {
            google()
            mavenCentral()
        }
    }
    ```

    O terceiro arquivo que requer modificações é
    `android/app/src/main/AndroidManifest.xml`.

 1. No bloco raiz application, adicione a seguinte declaração `<activity>`:

    ```xml title="android/app/src/main/AndroidManifest.xml"
    <manifest xmlns:android="http://schemas.android.com/apk/res/android">
        <application
            android:label="flutter_android_activity"
            android:name="${applicationName}"
            android:icon="@mipmap/ic_launcher">

           // START COPYING HERE
            <activity android:name=".SecondActivity" android:exported="true" android:theme="@style/LaunchTheme"></activity>
           // END COPYING HERE

           <activity android:name=".MainActivity" …></activity>
          …
    </manifest>
    ```

    O quarto e último código que requer modificações é
    `android/app/src/main/kotlin/com/example/flutter_android_activity/MainActivity.kt`.
    Aqui você escreverá código Kotlin para sua funcionalidade Android desejada.

 1. Adicione as importações necessárias no topo do arquivo:

    :::note
    Suas importações podem variar se as versões da biblioteca mudaram ou
    se você introduzir classes Compose diferentes quando
    escrever seu próprio código Kotlin.
    Siga as dicas do seu IDE para as importações corretas que você precisa.
    :::

    ```kotlin title="MainActivity.kt"
    package com.example.flutter_android_activity

    import android.content.Intent
    import android.os.Bundle
    import androidx.activity.ComponentActivity
    import androidx.activity.compose.setContent
    import androidx.compose.foundation.layout.Column
    import androidx.compose.foundation.layout.fillMaxSize
    import androidx.compose.material3.Button
    import androidx.compose.material3.MaterialTheme
    import androidx.compose.material3.Surface
    import androidx.compose.material3.Text
    import androidx.compose.ui.Modifier
    import androidx.core.app.ActivityCompat
    import io.flutter.embedding.android.FlutterActivity
    import io.flutter.embedding.android.FlutterEngine
    import io.flutter.plugin.common.MethodCall
    import io.flutter.plugin.common.MethodChannel
    import io.flutter.plugins.GeneratedPluginRegistrant
    ```

 1. Modifique a classe `MainActivity` gerada adicionando um
    campo `CHANNEL` e um método `configureFlutterEngine`:

     ```kotlin  title="MainActivity.kt"
     class MainActivity: FlutterActivity() {
         // This value must match the `MethodChannel` name in your Dart code.
         private val CHANNEL = "com.example.flutter_android_activity"

         override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
             GeneratedPluginRegistrant.registerWith(flutterEngine)

             MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                 call: MethodCall, result: MethodChannel.Result ->
                     when (call.method) {
                         // Note: This must match the first parameter passed to
                         // `platformMethodChannel.invokeMethod` in your Dart code.
                         "launchActivity" -> {
                             try {
                                 // Takes an object, in this case a String.
                                 val message = call.arguments
                                 val intent = Intent(this@MainActivity, SecondActivity::class.java)
                                 intent.putExtra("message", message.toString())
                                 startActivity(intent)
                             } catch (e: Exception){}
                                 result.success(true)
                             }
                             else -> {}
                     }
             }
         }
     }
     ```

 1. Adicione uma segunda `Activity` na parte inferior do arquivo, que você
    referenciou nas alterações anteriores a `AndroidManifest.xml`:

    ```kotlin  title="MainActivity.kt"
    class SecondActivity : ComponentActivity() {
        override fun onCreate(savedInstanceState: Bundle?) {
            super.onCreate(savedInstanceState)

            setContent {
                Surface(modifier = Modifier.fillMaxSize(), color = MaterialTheme.colorScheme.background) {
                    Column {
                        Text(text = "Second Activity")
                        // Note: This must match the shape of the data passed from your Dart code.
                        Text("" + getIntent()?.getExtras()?.getString("message"))
                        Button(onClick = {  finish() }) {
                            Text("Exit")
                        }
                    }
                }
            }
        }
    }
    ```

Esses passos mostram como lançar uma activity Android nativa de um app Flutter,
o que às vezes pode ser uma forma fácil de conectar a funcionalidades específicas do Android.
