---
ia-translate: true
title: Suportando as novas APIs de plugins Android
description: Como atualizar um plugin usando as APIs antigas para suportar as novas APIs.
---

{% render "docs/breaking-changes.md" %}

<?code-excerpt path-base="platform_integration/plugin_api_migration"?>

:::note
Novos plugins e todos os plugins compatíveis com Flutter 2
(Março 2021) podem ignorar esta página.
:::

:::note
Você pode ser direcionado para esta página se o framework detectar que
seu app usa um plugin baseado nas antigas APIs Android.
:::

_Se você não escreve ou mantém um plugin Flutter para Android,
pode pular esta página._

A partir da versão 1.12,
novas APIs de plugin estão disponíveis para a plataforma Android.
As APIs antigas baseadas em [`PluginRegistry.Registrar`][PluginRegistry.Registrar]
não serão descontinuadas imediatamente,
mas encorajamos você a migrar para as novas APIs baseadas em
[`FlutterPlugin`][FlutterPlugin].

A nova API tem a vantagem de fornecer um conjunto mais limpo
de acessores para componentes dependentes do ciclo de vida em comparação
com as APIs antigas. Por exemplo,
[`PluginRegistry.Registrar.activity()`][PluginRegistry.Registrar.activity] poderia retornar null se
o Flutter não estivesse anexado a nenhuma activity.

Em outras palavras, plugins usando a API antiga podem produzir comportamentos
indefinidos ao incorporar o Flutter em um app Android.
A maioria dos [Flutter plugins][Flutter plugins] fornecidos pela equipe
flutterbrasil.dev já foram migrados. (Saiba como se tornar um
[verified publisher][verified publisher] no pub.dev!) Para um exemplo de
um plugin que usa as novas APIs, veja o
[battery plus package][battery plus package].

## Passos para atualização

As instruções a seguir delineiam os passos para suportar a nova API:

1. Atualize a classe principal do plugin (`*Plugin.java`) para implementar a
   interface [`FlutterPlugin`][FlutterPlugin]. Para plugins mais complexos,
   você pode separar o `FlutterPlugin` e o `MethodCallHandler`
   em duas classes. Veja a próxima seção, [Basic plugin][Basic plugin],
   para mais detalhes sobre como acessar recursos do app com
   a versão mais recente (v2) de embedding.
   <br><br>
   Além disso, note que o plugin ainda deve conter o método
   estático `registerWith()` para permanecer compatível com apps que
   não usam o embedding Android v2.
   (Veja [Upgrading pre 1.12 Android projects][Upgrading pre 1.12 Android projects] para detalhes.)
   A coisa mais fácil a fazer (se possível) é mover a lógica de
   `registerWith()` para um método privado que tanto
   `registerWith()` quanto `onAttachedToEngine()` podem chamar.
   Ou `registerWith()` ou `onAttachedToEngine()` será chamado,
   não ambos.
   <br><br>
   Além disso, você deve documentar todos os membros públicos não sobrescritos
   dentro do plugin. Em um cenário add-to-app,
   essas classes são acessíveis a um desenvolvedor e
   requerem documentação.

1. (Opcional) Se seu plugin precisar de uma referência a `Activity`,
   também implemente a interface [`ActivityAware`][ActivityAware].

1. (Opcional) Se espera-se que seu plugin seja mantido em um
   Service em segundo plano em qualquer momento, implemente a
   interface [`ServiceAware`][ServiceAware].

1. Atualize o `MainActivity.java` do app de exemplo para usar o
   `FlutterActivity` do embedding v2. Para detalhes, veja
   [Upgrading pre 1.12 Android projects][Upgrading pre 1.12 Android projects].
   Você pode ter que criar um construtor público para sua classe de plugin
   se um ainda não existir. Por exemplo:

   ```java title="MainActivity.java"
    package io.flutter.plugins.firebasecoreexample;

    import io.flutter.embedding.android.FlutterActivity;
    import io.flutter.embedding.engine.FlutterEngine;
    import io.flutter.plugins.firebase.core.FirebaseCorePlugin;

    public class MainActivity extends FlutterActivity {
      // You can keep this empty class or remove it. Plugins on the new embedding
      // now automatically registers plugins.
    }
    ```

1. (Opcional) Se você removeu `MainActivity.java`, atualize o
   `<plugin_name>/example/android/app/src/main/AndroidManifest.xml`
   para usar `io.flutter.embedding.android.FlutterActivity`.
   Por exemplo:

    ```xml title="AndroidManifest.xml"
     <activity android:name="io.flutter.embedding.android.FlutterActivity"
            android:theme="@style/LaunchTheme"
   android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale"
            android:hardwareAccelerated="true"
            android:exported="true"
            android:windowSoftInputMode="adjustResize">
            <meta-data
                android:name="io.flutter.app.android.SplashScreenUntilFirstFrame"
                android:value="true" />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
    ```

1. (Opcional) Crie um arquivo `EmbeddingV1Activity.java`
   que usa o embedding v1 para o projeto de exemplo
   na mesma pasta que `MainActivity` para
   continuar testando a compatibilidade do embedding v1
   com seu plugin. Note que você tem que registrar manualmente
   todos os plugins ao invés de usar
   `GeneratedPluginRegistrant`. Por exemplo:

    ```java title="EmbeddingV1Activity.java"
    package io.flutter.plugins.batteryexample;

    import android.os.Bundle;
    import io.flutter.app.FlutterActivity;
    import io.flutter.plugins.battery.BatteryPlugin;

    public class EmbeddingV1Activity extends FlutterActivity {
      @Override
      protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        BatteryPlugin.registerWith(registrarFor("io.flutter.plugins.battery.BatteryPlugin"));
      }
    }
    ```

1.  Adicione `<meta-data android:name="flutterEmbedding" android:value="2"/>`
    ao `<plugin_name>/example/android/app/src/main/AndroidManifest.xml`.
    Isso configura o app de exemplo para usar o embedding v2.

1. (Opcional) Se você criou um `EmbeddingV1Activity`
   no passo anterior, adicione o `EmbeddingV1Activity` ao
   arquivo `<plugin_name>/example/android/app/src/main/AndroidManifest.xml`.
   Por exemplo:

    ```xml title="AndroidManifest.xml"
    <activity
        android:name=".EmbeddingV1Activity"
        android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale"
        android:hardwareAccelerated="true"
        android:exported="true"
        android:windowSoftInputMode="adjustResize">
    </activity>
    ```

## Testando seu plugin

Os passos restantes abordam os testes do seu plugin, o que encorajamos,
mas não são obrigatórios.

1. Atualize `<plugin_name>/example/android/app/build.gradle`
   para substituir referências a `android.support.test` por `androidx.test`:

    ```groovy title="build.gradle"
    defaultConfig {
      ...
      testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
      ...
    }
    ```

    ```groovy title="build.gradle"
    dependencies {
    ...
    androidTestImplementation 'androidx.test:runner:1.2.0'
    androidTestImplementation 'androidx.test:rules:1.2.0'
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.2.0'
    ...
    }
    ```

1. Adicione arquivos de teste para `MainActivity` e `EmbeddingV1Activity`
   em `<plugin_name>/example/android/app/src/androidTest/java/<plugin_path>/`.
   Você precisará criar esses diretórios. Por exemplo:

    ```java title="MainActivityTest.java"
    package io.flutter.plugins.firebase.core;

    import androidx.test.rule.ActivityTestRule;
    import io.flutter.plugins.firebasecoreexample.MainActivity;
    import org.junit.Rule;
    import org.junit.runner.RunWith;

    @RunWith(FlutterRunner.class)
    public class MainActivityTest {
      // Replace `MainActivity` with `io.flutter.embedding.android.FlutterActivity` if you removed `MainActivity`.
      @Rule public ActivityTestRule<MainActivity> rule = new ActivityTestRule<>(MainActivity.class);
    }
    ```

    ```java title="EmbeddingV1ActivityTest.java"
    package io.flutter.plugins.firebase.core;

    import androidx.test.rule.ActivityTestRule;
    import io.flutter.plugins.firebasecoreexample.EmbeddingV1Activity;
    import org.junit.Rule;
    import org.junit.runner.RunWith;

    @RunWith(FlutterRunner.class)
    public class EmbeddingV1ActivityTest {
      @Rule
      public ActivityTestRule<EmbeddingV1Activity> rule =
          new ActivityTestRule<>(EmbeddingV1Activity.class);
    }
    ```

1. Adicione `integration_test` e `flutter_driver` dev_dependencies ao
   `<plugin_name>/pubspec.yaml` e
   `<plugin_name>/example/pubspec.yaml`.

    ```yaml title="pubspec.yaml"
    integration_test:
      sdk: flutter
    flutter_driver:
      sdk: flutter
    ```

1. Atualize a versão mínima do Flutter em environment no
   `<plugin_name>/pubspec.yaml`. Todos os plugins daqui para frente
   definirão a versão mínima como 1.12.13+hotfix.6
   que é a versão mínima para a qual podemos garantir suporte.
   Por exemplo:

    ```yaml title="pubspec.yaml"
    environment:
      sdk: ">=2.16.1 <3.0.0"
      flutter: ">=1.17.0"
    ```

1. Crie um teste simples em `<plugin_name>/test/<plugin_name>_test.dart`.
   Para o propósito de testar o PR que adiciona o suporte ao embedding v2,
   estamos tentando testar alguma funcionalidade muito básica do plugin.
   Este é um teste de fumaça para garantir que o plugin se registre
   adequadamente com o novo embedder. Por exemplo:

    <?code-excerpt "lib/test.dart (test)"?>
    ```dart
    import 'package:flutter_test/flutter_test.dart';
    import 'package:integration_test/integration_test.dart';

    void main() {
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

      testWidgets('Can get battery level', (tester) async {
        final Battery battery = Battery();
        final int batteryLevel = await battery.batteryLevel;
        expect(batteryLevel, isNotNull);
      });
    }
    ```

1. Execute os testes `integration_test` localmente. Em um terminal,
   faça o seguinte:

    ```console
    flutter test integration_test/app_test.dart
    ```

## Plugin básico {:#basic-plugin}

Para começar com um plugin Flutter para Android em código,
comece implementando `FlutterPlugin`.

```java
public class MyPlugin implements FlutterPlugin {
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    // TODO: your plugin is now attached to a Flutter experience.
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    // TODO: your plugin is no longer attached to a Flutter experience.
  }
}
```

Como mostrado acima, seu plugin pode (ou não)
estar associado a uma determinada experiência Flutter em
qualquer momento no tempo.
Você deve tomar cuidado para inicializar o comportamento do seu plugin
em `onAttachedToEngine()`, e então limpar as referências do seu plugin
em `onDetachedFromEngine()`.

O FlutterPluginBinding fornece ao seu plugin algumas
referências importantes:

**binding.getFlutterEngine()**
: Retorna o `FlutterEngine` ao qual seu plugin está anexado,
  fornecendo acesso a componentes como o `DartExecutor`,
  `FlutterRenderer`, e mais.

**binding.getApplicationContext()**
: Retorna o `Context` da aplicação Android para o app em execução.

## Plugin UI/Activity

Se seu plugin precisa interagir com a UI,
como solicitar permissões, ou alterar o chrome da UI do Android,
então você precisa tomar passos adicionais para definir seu plugin.
Você deve implementar a interface `ActivityAware`.

```java
public class MyPlugin implements FlutterPlugin, ActivityAware {
  //...normal plugin behavior is hidden...

  @Override
  public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
    // TODO: your plugin is now attached to an Activity
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    // TODO: the Activity your plugin was attached to was
    // destroyed to change configuration.
    // This call will be followed by onReattachedToActivityForConfigChanges().
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding activityPluginBinding) {
    // TODO: your plugin is now attached to a new Activity
    // after a configuration change.
  }

  @Override
  public void onDetachedFromActivity() {
    // TODO: your plugin is no longer associated with an Activity.
    // Clean up references.
  }
}
```

Para interagir com uma `Activity`, seu plugin `ActivityAware` deve
implementar comportamento apropriado em 4 estágios. Primeiro, seu plugin
é anexado a uma `Activity`. Você pode acessar essa `Activity` e
vários de seus callbacks através do `ActivityPluginBinding` fornecido.

Como `Activity`s podem ser destruídas durante mudanças de configuração,
você deve limpar quaisquer referências à `Activity` fornecida em
`onDetachedFromActivityForConfigChanges()`,
e então reestabelecer essas referências em
`onReattachedToActivityForConfigChanges()`.

Finalmente, em `onDetachedFromActivity()` seu plugin deve limpar
todas as referências relacionadas ao comportamento da `Activity` e retornar a
uma configuração sem UI.


[ActivityAware]: {{site.api}}/javadoc/io/flutter/embedding/engine/plugins/activity/ActivityAware.html
[Basic plugin]: #basic-plugin
[battery plus package]: {{site.github}}/fluttercommunity/plus_plugins/tree/main/packages/battery_plus/battery_plus
[Flutter plugins]: {{site.pub}}/flutter/packages
[FlutterPlugin]: {{site.api}}/javadoc/io/flutter/embedding/engine/plugins/FlutterPlugin.html
[PluginRegistry.Registrar]: {{site.api}}/javadoc/io/flutter/plugin/common/PluginRegistry.Registrar.html
[PluginRegistry.Registrar.activity]: {{site.api}}/javadoc/io/flutter/plugin/common/PluginRegistry.Registrar.html#activity--
[ServiceAware]: {{site.api}}/javadoc/io/flutter/embedding/engine/plugins/service/ServiceAware.html
[Upgrading pre 1.12 Android projects]: {{site.repo.flutter}}/blob/main/docs/platforms/android/Upgrading-pre-1.12-Android-projects.md
[verified publisher]: {{site.dart-site}}/tools/pub/verified-publishers
