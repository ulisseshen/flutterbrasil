---
ia-translate: true
title: Iniciando uma atividade Jetpack Compose a partir do seu aplicativo Flutter
short-title: Atividades Nativas do Android
description: >-
  Aprenda como iniciar atividades nativas do Android em seu aplicativo Flutter.
---

<?code-excerpt path-base="platform_integration/compose_activities"?>

As atividades nativas do Android permitem que você inicie
UIs em tela cheia que são totalmente executadas e na plataforma Android.
Você só escreverá código Kotlin nessas visualizações (embora elas possam
passar mensagens e receber mensagens do seu código Dart) e
você terá acesso a toda a extensão da funcionalidade nativa do Android.

Adicionar esta funcionalidade requer fazer várias alterações em
seu aplicativo Flutter e seu aplicativo Android interno gerado.
No lado do Flutter, você precisará criar um novo
canal de método de plataforma e chamar seu método `invokeMethod`.
No lado do Android, você precisará registrar um `MethodChannel` nativo correspondente
para receber o sinal do Dart e, em seguida, iniciar uma nova atividade.
Lembre-se de que todos os aplicativos Flutter (ao serem executados no Android) existem dentro
de uma atividade do Android que é completamente consumida pelo aplicativo Flutter.
Assim, como você verá no exemplo de código, o trabalho do
callback `MethodChannel` nativo é iniciar uma segunda atividade.

:::note
Esta página discute como iniciar atividades nativas do Android
dentro de um aplicativo Flutter.
Se você gostaria de hospedar visualizações nativas do Android em seu aplicativo Flutter,
confira [Hospedando visualizações nativas do Android][].
:::

[Hospedando visualizações nativas do Android]: /platform-integration/android/platform-views

Nem todas as atividades do Android usam o Jetpack Compose, mas
este tutorial assume que você deseja usar o Compose.

## No lado do Dart

No lado do Dart, crie um canal de método e o invoque a partir de
uma interação específica do usuário, como tocar em um botão.

<?code-excerpt "lib/launch_compose_activity_example_1.dart"?>
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// SEÇÃO 1: COMECE A COPIAR AQUI
const platformMethodChannel = MethodChannel(
  // Observação: você pode alterar este valor de string, mas ele deve corresponder
  // ao atributo `CHANNEL` na próxima etapa.
  'com.example.flutter_android_activity',
);
// SEÇÃO 1: FIM DA CÓPIA AQUI

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // SEÇÃO 2: COMECE A COPIAR AQUI
  void _launchAndroidActivity() {
    platformMethodChannel.invokeMethod(
      // Observação: você pode alterar este valor, mas ele deve corresponder
      // ao valor `call.method` na próxima seção.
      'launchActivity',

      // Observação: você pode passar qualquer tipo de dados primitivos que desejar.
      // Para passar tipos complexos, use o pacote:pigeon para gerar
      // classes Dart e Kotlin correspondentes que compartilham a lógica de serialização.
      {'message': 'Olá do Flutter'},
    );
  }
  // SEÇÃO 2: FIM DA CÓPIA AQUI

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: const Center(
          child: Text('Olá Mundo!'),
        ),
        floatingActionButton: FloatingActionButton(
          // SEÇÃO 3: Chame `_launchAndroidActivity` em algum lugar.
          onPressed: _launchAndroidActivity,
          // SEÇÃO 3: Fim

          tooltip: 'Iniciar atividade do Android',
          child: const Icon(Icons.launch),
        ),
      ),
    );
  }
}
```

Existem 3 valores importantes que devem corresponder em seu código Dart e Kotlin:

 1. O nome do canal (neste exemplo, o valor é
    `"com.example.flutter_android_activity"`).
 2. O nome do método (neste exemplo, o valor é `"launchActivity"`).
 3. A estrutura dos dados que o Dart passa e
    a estrutura dos dados que o Kotlin espera receber.
    Neste caso, os dados são um mapa com uma única chave `"message"`.


## No lado do Android

Você deve fazer alterações em 4 arquivos no aplicativo Android gerado para
prepará-lo para iniciar novas atividades Compose.

O primeiro arquivo que requer modificações é `android/app/build.gradle`.

 1. Adicione o seguinte ao bloco `android` existente:

    ```groovy title="android/app/build.gradle"
    android {
      // Comece a adicionar aqui
      buildFeatures {
        compose true
      }
      composeOptions {
        // https://developer.android.com/jetpack/androidx/releases/compose-kotlin
        kotlinCompilerExtensionVersion = "1.4.8"
      }
      // Fim da adição aqui
    }
    ```

    Visite o link [developer.android.com][] no trecho de código e
    ajuste `kotlinCompilerExtensionVersion`, conforme necessário.
    Você só precisa fazer isso se você
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
 
 1. Adicione o seguinte bloco buildscript na parte superior do arquivo:
 
    ```groovy title="android/build.gradle"
    buildscript {
        dependencies {
            // Substitua pela versão mais recente.
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
 
 1. No bloco de aplicativo raiz, adicione a seguinte declaração `<activity>`:
 
    ```xml title="android/app/src/main/AndroidManifest.xml"
    <manifest xmlns:android="http://schemas.android.com/apk/res/android">
        <application
            android:label="flutter_android_activity"
            android:name="${applicationName}"
            android:icon="@mipmap/ic_launcher">

           // COMECE A COPIAR AQUI
            <activity android:name=".SecondActivity" android:exported="true" android:theme="@style/LaunchTheme"></activity>
           // FIM DA CÓPIA AQUI

           <activity android:name=".MainActivity" …></activity>
          …
    </manifest>
    ```

    O quarto e último código que requer modificações é
    `android/app/src/main/kotlin/com/example/flutter_android_activity/MainActivity.kt`.
    Aqui, você escreverá código Kotlin para a funcionalidade desejada do Android.
 
 1. Adicione as importações necessárias na parte superior do arquivo:
 
    :::note
    Suas importações podem variar se as versões da biblioteca foram alteradas ou
    se você introduzir diferentes classes Compose quando
    você escrever seu próprio código Kotlin.
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
    import io.flutter.embedding.engine.FlutterEngine
    import io.flutter.plugin.common.MethodCall
    import io.flutter.plugin.common.MethodChannel
    import io.flutter.plugins.GeneratedPluginRegistrant
    ```
 
 1. Modifique a classe `MainActivity` gerada adicionando um
    campo `CHANNEL` e um método `configureFlutterEngine`:
 
     ```kotlin  title="MainActivity.kt"
     class MainActivity: FlutterActivity() {
         // Este valor deve corresponder ao nome `MethodChannel` em seu código Dart.
         private val CHANNEL = "com.example.flutter_android_activity"

         override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
             GeneratedPluginRegistrant.registerWith(flutterEngine)

             MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                 call: MethodCall, result: MethodChannel.Result ->
                     when (call.method) {
                         // Observação: isso deve corresponder ao primeiro parâmetro passado para
                         // `platformMethodChannel.invokeMethod` em seu código Dart.
                         "launchActivity" -> {
                             try {
                                 // Recebe um objeto, neste caso uma String.
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
    referenciou nas alterações anteriores em `AndroidManifest.xml`:
 
    ```kotlin  title="MainActivity.kt"
    class SecondActivity : ComponentActivity() {
        override fun onCreate(savedInstanceState: Bundle?) {
            super.onCreate(savedInstanceState)

            setContent {
                Surface(modifier = Modifier.fillMaxSize(), color = MaterialTheme.colorScheme.background) {
                    Column {
                        Text(text = "Segunda Atividade")
                        // Observação: Isso deve corresponder ao formato dos dados passados do seu código Dart.
                        Text("" + getIntent()?.getExtras()?.getString("message"))
                        Button(onClick = {  finish() }) {
                            Text("Sair")
                        }
                    }
                }
            }
        }
    }
    ```

Estas etapas mostram como iniciar uma atividade nativa do Android a partir de um aplicativo Flutter,
o que às vezes pode ser uma maneira fácil de se conectar a funcionalidades específicas do Android.

