---
ia-translate: true
title: Suportando as novas APIs de plugins Android
description: Como atualizar um plugin usando as APIs antigas para suportar as novas APIs.
---

<?code-excerpt path-base="platform_integration/plugin_api_migration"?>

:::note
Novos plugins e todos os plugins que são compatíveis com o Flutter 2 (Março de 2021) podem ignorar esta página.
:::

:::note
Você pode ser direcionado para esta página se o framework detectar que seu app usa um plugin baseado nas APIs Android antigas.
:::

_Se você não escreve ou mantém um plugin Flutter para Android, pode pular esta página._

A partir da versão 1.12, novas APIs de plugin estão disponíveis para a plataforma Android. As APIs antigas baseadas em [`PluginRegistry.Registrar`][] não serão imediatamente descontinuadas, mas encorajamos você a migrar para as novas APIs baseadas em [`FlutterPlugin`][].

A nova API tem a vantagem de fornecer um conjunto mais limpo de acessadores para componentes dependentes do ciclo de vida em comparação com as APIs antigas. Por exemplo, [`PluginRegistry.Registrar.activity()`][] poderia retornar nulo se o Flutter não estiver anexado a nenhuma atividade.

Em outras palavras, plugins que usam a API antiga podem produzir comportamentos indefinidos ao incorporar o Flutter em um aplicativo Android. A maioria dos [plugins Flutter][] fornecidos pela equipe flutter.dev já foi migrada. (Aprenda como se tornar um [publisher verificado][] no pub.dev!) Para um exemplo de um plugin que usa as novas APIs, veja o [pacote battery plus][].

## Etapas de atualização

As instruções a seguir descrevem as etapas para suportar a nova API:

1. Atualize a classe principal do plugin (`*Plugin.java`) para implementar a interface [`FlutterPlugin`][]. Para plugins mais complexos, você pode separar o `FlutterPlugin` e o `MethodCallHandler` em duas classes. Veja a próxima seção, [Plugin básico][], para obter mais detalhes sobre como acessar os recursos do aplicativo com a versão mais recente (v2) de incorporação.
   <br><br>
   Além disso, observe que o plugin ainda deve conter o método estático `registerWith()` para permanecer compatível com aplicativos que não usam a incorporação v2 do Android. (Veja [Atualizando projetos Android pré 1.12][] para detalhes.) A coisa mais fácil a fazer (se possível) é mover a lógica de `registerWith()` para um método privado que tanto `registerWith()` quanto `onAttachedToEngine()` possam chamar. Ou `registerWith()` ou `onAttachedToEngine()` serão chamados, não ambos.
   <br><br>
   Além disso, você deve documentar todos os membros públicos não substituídos dentro do plugin. Em um cenário de adicionar a um aplicativo, essas classes são acessíveis a um desenvolvedor e exigem documentação.

2. (Opcional) Se o seu plugin precisar de uma referência `Activity`, implemente também a interface [`ActivityAware`][].

3. (Opcional) Se o seu plugin for esperado para ser mantido em um Serviço em segundo plano em algum momento, implemente a interface [`ServiceAware`][].

4. Atualize o `MainActivity.java` do aplicativo de exemplo para usar a incorporação v2 `FlutterActivity`. Para obter detalhes, consulte [Atualizando projetos Android pré 1.12][]. Pode ser necessário criar um construtor público para sua classe de plugin, caso ainda não exista. Por exemplo:

   ```java title="MainActivity.java"
    package io.flutter.plugins.firebasecoreexample;

    import io.flutter.embedding.android.FlutterActivity;
    import io.flutter.embedding.engine.FlutterEngine;
    import io.flutter.plugins.firebase.core.FirebaseCorePlugin;

    public class MainActivity extends FlutterActivity {
      // Você pode manter esta classe vazia ou removê-la. Plugins na nova incorporação
      // agora registram automaticamente os plugins.
    }
    ```

5. (Opcional) Se você removeu `MainActivity.java`, atualize o
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

6. (Opcional) Crie um arquivo `EmbeddingV1Activity.java` que use a incorporação v1 para o projeto de exemplo na mesma pasta que `MainActivity` para continuar testando a compatibilidade da incorporação v1 com seu plugin. Observe que você tem que registrar manualmente todos os plugins em vez de usar `GeneratedPluginRegistrant`. Por exemplo:

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

7.  Adicione `<meta-data android:name="flutterEmbedding" android:value="2"/>` ao
    `<plugin_name>/example/android/app/src/main/AndroidManifest.xml`.
    Isso define o aplicativo de exemplo para usar a incorporação v2.

8. (Opcional) Se você criou um `EmbeddingV1Activity` na etapa anterior, adicione o `EmbeddingV1Activity` ao arquivo `<plugin_name>/example/android/app/src/main/AndroidManifest.xml`. Por exemplo:

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

As etapas restantes abordam o teste do seu plugin, o que incentivamos, mas não é obrigatório.

1. Atualize `<plugin_name>/example/android/app/build.gradle` para substituir as referências a `android.support.test` por `androidx.test`:

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

2. Adicione arquivos de teste para `MainActivity` e `EmbeddingV1Activity` em `<plugin_name>/example/android/app/src/androidTest/java/<plugin_path>/`. Você precisará criar esses diretórios. Por exemplo:

    ```java title="MainActivityTest.java"
    package io.flutter.plugins.firebase.core;

    import androidx.test.rule.ActivityTestRule;
    import io.flutter.plugins.firebasecoreexample.MainActivity;
    import org.junit.Rule;
    import org.junit.runner.RunWith;

    @RunWith(FlutterRunner.class)
    public class MainActivityTest {
      // Substitua `MainActivity` por `io.flutter.embedding.android.FlutterActivity` se você removeu `MainActivity`.
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

3. Adicione `integration_test` e `flutter_driver` como `dev_dependencies` em `<plugin_name>/pubspec.yaml` e `<plugin_name>/example/pubspec.yaml`.

    ```yaml title="pubspec.yaml"
    integration_test:
      sdk: flutter
    flutter_driver:
      sdk: flutter
    ```

4. Atualize a versão mínima do Flutter do ambiente em `<plugin_name>/pubspec.yaml`. Todos os plugins avançando definirão a versão mínima para 1.12.13+hotfix.6, que é a versão mínima para a qual podemos garantir suporte. Por exemplo:

    ```yaml title="pubspec.yaml"
    environment:
      sdk: ">=2.16.1 <3.0.0"
      flutter: ">=1.17.0"
    ```

5. Crie um teste simples em `<plugin_name>/test/<plugin_name>_test.dart`. Para fins de teste do PR que adiciona o suporte de incorporação v2, estamos tentando testar alguma funcionalidade muito básica do plugin. Este é um smoke test para garantir que o plugin se registre corretamente com o novo embedder. Por exemplo:

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

6. Execute os testes de `integration_test` localmente. Em um terminal, faça o seguinte:

    ```console
    flutter test integration_test/app_test.dart
    ```

## Plugin básico

Para começar com um plugin Flutter Android em código, comece implementando `FlutterPlugin`.

```java
public class MyPlugin implements FlutterPlugin {
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    // TODO: seu plugin agora está anexado a uma experiência Flutter.
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    // TODO: seu plugin não está mais anexado a uma experiência Flutter.
  }
}
```

Como mostrado acima, seu plugin pode (ou não) estar associado a uma determinada experiência Flutter em qualquer momento. Você deve ter o cuidado de inicializar o comportamento do seu plugin em `onAttachedToEngine()`, e então limpar as referências do seu plugin em `onDetachedFromEngine()`.

O `FlutterPluginBinding` fornece ao seu plugin algumas referências importantes:

**binding.getFlutterEngine()**
: Retorna o `FlutterEngine` ao qual seu plugin está anexado, fornecendo acesso a componentes como `DartExecutor`, `FlutterRenderer` e muito mais.

**binding.getApplicationContext()**
: Retorna o `Context` do aplicativo Android para o aplicativo em execução.

## Plugin de UI/Activity

Se o seu plugin precisar interagir com a UI, como solicitar permissões ou alterar o cromo da UI do Android, você precisará executar etapas adicionais para definir seu plugin. Você deve implementar a interface `ActivityAware`.

```java
public class MyPlugin implements FlutterPlugin, ActivityAware {
  //...o comportamento normal do plugin está oculto...

  @Override
  public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
    // TODO: seu plugin agora está anexado a uma Activity
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    // TODO: a Activity à qual seu plugin estava anexado foi
    // destruída para alterar a configuração.
    // Esta chamada será seguida por onReattachedToActivityForConfigChanges().
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding activityPluginBinding) {
    // TODO: seu plugin agora está anexado a uma nova Activity
    // após uma mudança de configuração.
  }

  @Override
  public void onDetachedFromActivity() {
    // TODO: seu plugin não está mais associado a uma Activity.
    // Limpe as referências.
  }
}
```

Para interagir com uma `Activity`, seu plugin `ActivityAware` deve implementar o comportamento apropriado em 4 estágios. Primeiro, seu plugin é anexado a uma `Activity`. Você pode acessar essa `Activity` e um número de seus callbacks através do `ActivityPluginBinding` fornecido.

Como as `Activity`s podem ser destruídas durante as alterações de configuração, você deve limpar quaisquer referências à `Activity` fornecida em `onDetachedFromActivityForConfigChanges()`, e então restabelecer essas referências em `onReattachedToActivityForConfigChanges()`.

Finalmente, em `onDetachedFromActivity()` seu plugin deve limpar todas as referências relacionadas ao comportamento da `Activity` e retornar a uma configuração não-UI.


[`ActivityAware`]: {{site.api}}/javadoc/io/flutter/embedding/engine/plugins/activity/ActivityAware.html
[Plugin básico]: #plugin-basico
[pacote battery plus]: {{site.github}}/fluttercommunity/plus_plugins/tree/main/packages/battery_plus/battery_plus
[plugins Flutter]: {{site.pub}}/flutter/packages
[`FlutterPlugin`]: {{site.api}}/javadoc/io/flutter/embedding/engine/plugins/FlutterPlugin.html
[`PluginRegistry.Registrar`]: {{site.api}}/javadoc/io/flutter/plugin/common/PluginRegistry.Registrar.html
[`PluginRegistry.Registrar.activity()`]: {{site.api}}/javadoc/io/flutter/plugin/common/PluginRegistry.Registrar.html#activity--
[`ServiceAware`]: {{site.api}}/javadoc/io/flutter/embedding/engine/plugins/service/ServiceAware.html
[Atualizando projetos Android pré 1.12]: {{site.repo.flutter}}/blob/master/docs/platforms/android/Upgrading-pre-1.12-Android-projects.md
[publisher verificado]: {{site.dart-site}}/tools/pub/verified-publishers
