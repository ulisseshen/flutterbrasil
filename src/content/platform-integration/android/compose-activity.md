---
ia-translate: true
title: Iniciando uma activity Jetpack Compose a partir da sua aplicação Flutter
short-title: Activities Android nativas
description: >-
  Aprenda como iniciar activities Android nativas no seu app Flutter.
---

<?code-excerpt path-base="platform_integration/compose_activities"?>

Activities Android nativas permitem que você inicie
UIs em tela cheia que são totalmente executadas pela e na plataforma Android.
Você escreverá apenas código Kotlin nessas views (embora elas possam
passar mensagens para e receber mensagens do seu código Dart) e
terá acesso à amplitude completa da funcionalidade Android nativa.

Adicionar esta funcionalidade requer fazer várias alterações ao
seu app Flutter e ao seu app Android interno gerado.
No lado do Flutter, você precisará criar um novo
canal de método de plataforma e chamar seu método `invokeMethod`.
No lado do Android, você precisará registrar um `MethodChannel` nativo correspondente
para receber o sinal do Dart e então iniciar uma nova activity.
Lembre-se que todos os apps Flutter (quando executando no Android) existem dentro de
uma activity Android que é completamente consumida pelo app Flutter.
Assim, como você verá no exemplo de código, o trabalho do
callback `MethodChannel` nativo é iniciar uma segunda activity.

:::note
Esta página discute como iniciar activities Android nativas
dentro de um app Flutter.
Se você gostaria de hospedar views Android nativas no seu app Flutter,
confira [Hospedando views Android nativas][Hosting native Android views].
:::

[Hosting native Android views]: /platform-integration/android/platform-views

Nem todas as activities Android usam Jetpack Compose, mas
este tutorial assume que você quer usar Compose.

## No lado Dart

No lado Dart, crie um canal de método e invoque-o a partir de
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
        body: const Center(
          child: Text('Hello World!'),
        ),
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

 1. O nome do canal (neste exemplo, o valor é
    `"com.example.flutter_android_activity"`).
 2. O nome do método (neste exemplo, o valor é `"launchActivity"`).
 3. A estrutura dos dados que o Dart passa e
    a estrutura dos dados que o Kotlin espera receber.
    Neste caso, os dados são um mapa com uma única chave `"message"`.


## No lado Android

Você deve fazer alterações em 4 arquivos no app Android gerado para
prepará-lo para iniciar novas activities Compose.

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

    Visite o link [developer.android.com][] no trecho de código e
    ajuste `kotlinCompilerExtensionVersion`, conforme necessário.
    Você só precisará fazer isso se
    receber erros durante `flutter run` e esses erros informarem
    quais versões estão instaladas na sua máquina.

    [developer.android.com]: {{site.android-dev}}/jetpack/androidx/releases/compose-kotlin

 2. Em seguida, adicione o seguinte bloco no final do arquivo, no nível raiz:
 
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

 1. No bloco raiz da aplicação, adicione a seguinte declaração `<activity>`:
 
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
    Aqui você escreverá código Kotlin para a funcionalidade Android desejada.

 1. Adicione as importações necessárias no topo do arquivo:

    :::note
    Suas importações podem variar se as versões das bibliotecas mudaram ou
    se você introduzir classes Compose diferentes quando
    escrever seu próprio código Kotlin.
    Siga as dicas da sua IDE para as importações corretas que você precisa.
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
    import io.flutter.embedding.engine.FlutterEngine
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
 
 1. Adicione uma segunda `Activity` no final do arquivo, que você
    referenciou nas alterações anteriores ao `AndroidManifest.xml`:
 
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

Esses passos mostram como iniciar uma activity Android nativa a partir de um app Flutter,
o que às vezes pode ser uma maneira fácil de conectar a funcionalidades Android específicas.
